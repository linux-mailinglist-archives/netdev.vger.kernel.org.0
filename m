Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A0013172A
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 19:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgAFSCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 13:02:13 -0500
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:39567
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726677AbgAFSCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 13:02:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMRAODtH0k8Xfo+Mn7eghJ+OJ8Z/vx/4L5nvrYvjLkcptDOonQkxl4Cic2Dmk8CFNp9qcsFZQNhRjtd3s11miAGQ3r2RKSXPgZUjTwcZgigDA7b1s+mb7RJ9buVPa5DPnCdkQwkJidaIE548+cn0oGJz+cWi8de8yBzW6dPF3Oh8h6Jpr/hyMIQ8aAa2M59q5LvI7VvG5CV6Ijd8ObXEORTOJIa+IqDvySAIFmoxwKMbpMPerj97Sbx0/4fLUpur+DhQFqOoNKOzW6CZf4vXe6yAF80srEemblOuWyt0khq7yNdfG7NmrTyETPFa9LFEwonbsSycbc08foQme3v8fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMictXWuOUs5BoeLBQv7bfRu1FLJHg5z+YkFX2VqB7s=;
 b=TxtJUgVgf8zEPpA/UFlSdtemODfSnLSTkUIgtEsXQXnMMgNwr+BM/u7tNKiCup1v7UQ8m+bzfQzWt+DhXtFex6dyaTEC1TGlzSS2YpIXcal3/N/ELdU9HbkKzQtLKGHw/4KfSaY06dWqjF0qosScROwrPdFDHMnwlzZS7vbmUahJ1io2yLNT6tEKXKyRM+QFMMv1IM4hoKOOO1tsOZBmIvXQFEAflnNc6Ic6Jtx+Jh4neHamlgC+EJpWbafbtXx8jBTkFKuOPx6F1GDLynSI45mk+7Mg9AxtuFAMrxcw62euVKpHb+V7jlpttA5hzEuE+6o6ZHSbdybzixIekDXyWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMictXWuOUs5BoeLBQv7bfRu1FLJHg5z+YkFX2VqB7s=;
 b=mB/n85NdUvrevPWNM73folVCd/KwPs2Sgh3mfLnKCeuF8x4yWvswiqnE7EW61nMFr52HpbUzDw6jpCCccF5sfdZf3iEl4bU6gWWSBKJuBDI6ts4FKR3j7v+vh6s4C0Jo9H/ghMlMWi5kIFletSE6OB87rKFCidBxoXR6Mup41Cs=
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4762.eurprd05.prod.outlook.com (20.176.164.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 18:01:55 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::4145:5526:973b:718b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::4145:5526:973b:718b%7]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 18:01:55 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0100.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.11 via Frontend Transport; Mon, 6 Jan 2020 18:01:54 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>, Petr Machata <petrm@mellanox.com>
Subject: [PATCH net 1/2] mlxsw: spectrum_qdisc: Ignore grafting of invisible
 FIFO
Thread-Topic: [PATCH net 1/2] mlxsw: spectrum_qdisc: Ignore grafting of
 invisible FIFO
Thread-Index: AQHVxLthKpC6HAth/kG3C0ukrRoSXQ==
Date:   Mon, 6 Jan 2020 18:01:55 +0000
Message-ID: <4f352657f275209e1923975f71641a00d5fdb046.1578333529.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 39c4586b-d595-4a26-98de-08d792d283d1
x-ms-traffictypediagnostic: HE1PR05MB4762:|HE1PR05MB4762:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR05MB4762B6FB813449D36708BF20DB3C0@HE1PR05MB4762.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(189003)(199004)(8676002)(86362001)(81166006)(6512007)(478600001)(36756003)(8936002)(52116002)(81156014)(16526019)(6506007)(66946007)(26005)(186003)(2616005)(956004)(6486002)(107886003)(2906002)(6916009)(4326008)(54906003)(71200400001)(5660300002)(66446008)(64756008)(66556008)(66476007)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB4762;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gsWj5k8W6mBc0Bn6by5v6BDieJ47Yr912WVaUKDX6rKb3oDrEYOKycjTywTtDbw2nc6z7rVFX2SookeEjDq0kk60FQQMJ+AMhYCaWz8c41dXsX1z4MXxuOl/Wtnx1MVbQ9iWgR90SW06GSjpBo1ULwbBovqdJKya34IDyVYflqmMsKDtrBtyDMx869l2N4rFhO+2iyLXl+kX6+p8L1XHQjEX4ewOClAMwHqRXY3i0qE2ZzRIRQCL/pssIZyrxNfW8nU6OKE/xk4kvCZw8Wt+xE1kd6lduaISDc92BVvK9fmGj9CVoKBD8sJpV5qegahUkKVnt6QDzrNi9h6aK8movVe0HTOw9UGvldwkl0abpu7sxVJZrnZQO8YC2u7F6T7ModMZNnDxWG7pq4ZgbEzG5qnkDfjmldEkRsfTyuIAEh17aIFTVZhKcimg9BSA6eLN
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c4586b-d595-4a26-98de-08d792d283d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 18:01:55.0962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4NlNwwJ9YiwThm97jrIgiudkhJCxIKL1hVyjYFfOuFzuWXoy2EUwNLLv5tDr96fNcB/XphFJ/sLm5ytHi7zXkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4762
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch will change PRIO to replace a removed Qdisc with an
invisible FIFO, instead of NOOP. mlxsw will see this replacement due to the
graft message that is generated. But because FIFO does not issue its own
REPLACE message, when the graft operation takes place, the Qdisc that mlxsw
tracks under the indicated band is still the old one. The child
handle (0:0) therefore does not match, and mlxsw rejects the graft
operation, which leads to an extack message:

    Warning: Offloading graft operation failed.

Fix by ignoring the invisible children in the PRIO graft handler. The
DESTROY message of the removed Qdisc is going to follow shortly and handle
the removal.

Fixes: 32dc5efc6cb4 ("mlxsw: spectrum: qdiscs: prio: Handle graft command")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers=
/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 68cc6737d45c..46d43cfd04e9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -651,6 +651,13 @@ mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_=
sp_port,
 	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle =3D=3D p->child_handl=
e)
 		return 0;
=20
+	if (!p->child_handle) {
+		/* This is an invisible FIFO replacing the original Qdisc.
+		 * Ignore it--the original Qdisc's destroy will follow.
+		 */
+		return 0;
+	}
+
 	/* See if the grafted qdisc is already offloaded on any tclass. If so,
 	 * unoffload it.
 	 */
--=20
2.20.1

