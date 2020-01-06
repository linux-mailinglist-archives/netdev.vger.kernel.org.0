Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B78713172B
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 19:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgAFSCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 13:02:15 -0500
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:39567
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726677AbgAFSCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 13:02:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcPdSltryTFr9N3+AObgm/zDf2tY6H0uMjTfgHa7CwU3WIQzFkKoS2TchqrI/Lm2V/2AbMCUrETGIy2/xofDKieuMJL5+H2FxwKH9NkvmJO1yZc9IMhAX1xUeFxLw57OEGY/aaRTdqccHs+PMdTPUw4VHIrAJw5RRSKYz/zDLopGvz4qH2j7bXPA5SApaFc6CtjfLrS/0eCJo1I4BsnFAmIvZ6pSbUuu2IDRIXuaMNWZ05tqU6fbNukPujN1YG/sh7ucu+V3Wkj0BBTK/9qrmzb4doLv0ZIfQSNmFds2IyVq95UPRZhYV1z/0JijiSmPGxXGoTZ5BHE9yko82UKfRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6Txzk6m825/7W9xpHnAbt85HYpxSqckyv1boHUAkvc=;
 b=H1AgjMIjpM/kcmkedKNPQ5wu7MCzHVikoUqa5D+mxWFSf+AKLte7d3ud3INwCAqB9dlbE1hNfwq7VVl14Ik1DxsbQrB84TacGxDRxZlxQVTz7HTyY1xokQYzCHO+puuIYw4/52C4rA9lpMfQzUcolitxgOD1nYSmZ6RI87YZ1rRW1xe/pFxOeHlMvaI0BeIE/jpRAfgShEvIMAKDF6zmiSybu8O5oh5Q6JvSSKT2uM/N4WzozkwvIkUyFrYEaqOaiNm7bRpsqgJOo5EiCizjVaUrBXNSZep2BHPoWqbGoeFeQl74ptOzjxOfZciGdgkO66fQBxf3lYIw1XGbnFUEwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6Txzk6m825/7W9xpHnAbt85HYpxSqckyv1boHUAkvc=;
 b=kw7uSMpEEVWCDPMr3HLVxla0KGVv2SqnHGFxDqQ5aLx4NspbysHP/N8mZOrGrlLM109knbP7cxkUszNz2mxY6muCHzkn2f0aD2MDPEveyFX5w0XFjPJdGn13p6L5fvzfYdIAuxYZB3cqeQ/mzU4gGxDFA3xxwj/YQOAz4sMhtjE=
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4762.eurprd05.prod.outlook.com (20.176.164.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 18:01:56 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::4145:5526:973b:718b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::4145:5526:973b:718b%7]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 18:01:56 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0100.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.11 via Frontend Transport; Mon, 6 Jan 2020 18:01:55 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>, Petr Machata <petrm@mellanox.com>
Subject: [PATCH net 2/2] net: sch_prio: When ungrafting, replace with FIFO
Thread-Topic: [PATCH net 2/2] net: sch_prio: When ungrafting, replace with
 FIFO
Thread-Index: AQHVxLtiAiT8Rf0SM0i7h94tzVo84w==
Date:   Mon, 6 Jan 2020 18:01:56 +0000
Message-ID: <ead37a85f4b86130add5d6756c0755a59d788822.1578333529.git.petrm@mellanox.com>
References: <cover.1578333529.git.petrm@mellanox.com>
In-Reply-To: <cover.1578333529.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR0P264CA0100.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::16) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 83e2d9dd-403b-43b6-f347-08d792d2848b
x-ms-traffictypediagnostic: HE1PR05MB4762:|HE1PR05MB4762:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR05MB4762DDD31721925FFCC85FD1DB3C0@HE1PR05MB4762.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(189003)(199004)(8676002)(86362001)(81166006)(6512007)(478600001)(36756003)(8936002)(52116002)(81156014)(16526019)(6506007)(66946007)(26005)(186003)(2616005)(956004)(6486002)(107886003)(2906002)(6916009)(4326008)(54906003)(71200400001)(5660300002)(66446008)(64756008)(66556008)(66476007)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB4762;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e9H9N9hfJg6wjLrOWk7zG34tKWQPflpVQU/pgOd6sIxpB0AUicD2PUnqChuOsrzi3gy6bAgxwF211a4E3qj4Xzr/9xdY5T3BtqjCW5H9FK9o8p87S7FTYwpPK5oTx1+ncp7R4YOPaHY2J9VszAvr9rth/4qhnPKsExc0KFaOig8/FzAlry23G4Z/oKFaRMoPydk3AHnANQ26wMKvZS9h3qsWBuRuhi4IeQSIN0+x4hZ3QmQm0098eeohXYgsqn5Pf4tUuAUPliNhZ6TDXLiqZbZejAv5ACdDBWE/YJJum0ZRmE/mVf7iw2fkC9ePBAzAjKbV0oWpzq8VeeERPNZesZbmK1/LYL2oWXgfPdRGJ/35aNdxtSqmGJd1Ina3rVX3OT9dVjB3Y4FgrlQbbyjskwb5WSfqSHrvthuW+kpI7qnFEBMp1/8tmvgre8TuvDeJ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83e2d9dd-403b-43b6-f347-08d792d2848b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 18:01:56.3534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5vGfuFbHdSwGU8DG6pN91IHiSKG+YSHQrGwSJ4VtZsXGJKux9tp2uiWFdj1kB5T3iLkzb17XsklxaxrNLecL0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4762
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a child Qdisc is removed from one of the PRIO Qdisc's bands, it is
replaced unconditionally by a NOOP qdisc. As a result, any traffic hitting
that band gets dropped. That is incorrect--no Qdisc was explicitly added
when PRIO was created, and after removal, none should have to be added
either.

Fix PRIO by first attempting to create a default Qdisc and only falling
back to noop when that fails. This pattern of attempting to create an
invisible FIFO, using NOOP only as a fallback, is also seen in other
Qdiscs.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/sched/sch_prio.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 18b884cfdfe8..647941702f9f 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -292,8 +292,14 @@ static int prio_graft(struct Qdisc *sch, unsigned long=
 arg, struct Qdisc *new,
 	struct tc_prio_qopt_offload graft_offload;
 	unsigned long band =3D arg - 1;
=20
-	if (new =3D=3D NULL)
-		new =3D &noop_qdisc;
+	if (!new) {
+		new =3D qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
+					TC_H_MAKE(sch->handle, arg), extack);
+		if (!new)
+			new =3D &noop_qdisc;
+		else
+			qdisc_hash_add(new, true);
+	}
=20
 	*old =3D qdisc_replace(sch, new, &q->queues[band]);
=20
--=20
2.20.1

