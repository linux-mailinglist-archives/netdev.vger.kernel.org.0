Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1F0131729
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 19:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgAFSB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 13:01:58 -0500
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:39567
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726448AbgAFSB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 13:01:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pla0n8YectTyKDnho+p4sXjOj6SxJR9OyxK1liUSu0MloRF1vVCQL2gqtfmKyXg11KrgcaoZUiR36saTD4Iv+46W0HP6yWaG7eKBtmNGXbwDZhHacX5YxVHdE3+SbPchFZJHTPIrFy9uu081ZcNj1zyHDkDuvYoxxJrwlsyDmcjATpO/c5OcmCHnKwx3E+u3Fj3n6/0GrG2uYhIIHusmxtBsQ0lx7PaETVkXjjTcoLE4NmywX+i341i+RGVj1Ra1eBx5nmqLKO3nwE4nUWRhRLN+bH0JyY03SE0fS1wMgLvKC1CrAWh6zYXxyaIa+5V1z9sb+uarPl29U0AVJ5zlew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2x4rWdlwxMJMAKAlmkdpPc7+oMulldm7HyudPOZ2+4=;
 b=aYqWexM3SkvCXSLs0uW3KZassAxDQ22+PBo7/uaW4vB3Cjwx1vXD5hrYzpzKJMg2RfUIpIy7k7B1rJ5iQY223PXdVsFnrQK2x0VaZpgl40oD4+bvRx7XQtFgNqh7GTGKLp0B65KgOA5dIJM3XivPxQ6Yho4lx/7iM8iJ9sJ9dY3ldCSsxyRYfUA3DNNlwGPnFuV98SUSUJBfIz45mAi9kiwP3aEEnCnVpFAdjA85oO2GNK/pDum9UKHMBWMDyp7saqULil5fn1gdBNWdvVdT5Ebw6Iuey3TwihSBMmKJdjlJmFF5YWM5H8V+2AzmMch6Nf0YImNEo72syp+ZFzlM5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2x4rWdlwxMJMAKAlmkdpPc7+oMulldm7HyudPOZ2+4=;
 b=m2z8E/3WAWJE8KS4cVg980NX4dXFNRE01rnSjx2tY9c/0cRAE2KYpKt7x//1PxtiF1GTM6p0Nf8+1fXY8PNyTey+iRPxR1p9dh7/oSPD+IVEZ/2IDadOyRk27KEoV3f8JIYAGlUTJTozyGRGDlRLBXRrZyAN3SPjweGdUGTnGOY=
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4762.eurprd05.prod.outlook.com (20.176.164.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 18:01:54 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::4145:5526:973b:718b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::4145:5526:973b:718b%7]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 18:01:54 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0100.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.11 via Frontend Transport; Mon, 6 Jan 2020 18:01:53 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>, Petr Machata <petrm@mellanox.com>
Subject: [PATCH net 0/2] When ungrafting from PRIO, replace child with FIFO
Thread-Topic: [PATCH net 0/2] When ungrafting from PRIO, replace child with
 FIFO
Thread-Index: AQHVxLtgu3RFIA6GoEu5J26Y4eoPbg==
Date:   Mon, 6 Jan 2020 18:01:53 +0000
Message-ID: <cover.1578333529.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: f470e77e-251d-4196-b397-08d792d28317
x-ms-traffictypediagnostic: HE1PR05MB4762:|HE1PR05MB4762:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR05MB47629367536705C177712EDBDB3C0@HE1PR05MB4762.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(189003)(199004)(8676002)(86362001)(81166006)(6512007)(478600001)(36756003)(8936002)(52116002)(81156014)(16526019)(6506007)(66946007)(26005)(186003)(2616005)(956004)(6486002)(107886003)(2906002)(6916009)(4326008)(54906003)(71200400001)(5660300002)(66446008)(64756008)(66556008)(66476007)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB4762;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jorIFEVbLGH3vM3+qykaHcWmJdyMtKjHDHqOhU9zLWNveQQQFkGuYtVbY95bwIh3M9Jfb87n0cE/07P82kWmDLJyVvLhP2D9CTFADnsMFCif20ag2M5yrtPlYy5WrHP9Dn9EfMoePxLjwgJCQ1VfaHuzm13S4guX1n3hhDaqgTiw7ExQVirOxtwUS1Mt+Kafq2b6E8Hq5OGgJ1TF1uj9xo3gLbG4fzhNZVvUPCae4+kzKl4RYfRjUc0Ppj/hawEcHwo3wbIT8VfaAlu+mOBp84xZqDhrwYFP5MfGFT0tmR58uO1dcMixGmT/d/YfcH/gwuR8VldBPXdXoEigvZXsaQjpAtXdFh1VGXI0lySyP7fVQ+j5NFDhnD/2Jcm1r9ZDO9plMWuk18q8trdbG2b+DZomWq5A/pRqX1mxbCl6uSvelbDSbBOr3FvMIcHAcQtj
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f470e77e-251d-4196-b397-08d792d28317
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 18:01:53.9158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /sOleKlD2phVZZ2/Twfraui7I3AQQmyoZBoLn8YM9n9DoOoIpXZ/N7ydQ/JG5xIMiB9g+HaVj5lvd4EdJWqmpQ==
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

In patch #2, this problem is fixed for PRIO by first attempting to create a
default Qdisc and only falling back to noop when that fails. This pattern
of attempting to create an invisible FIFO, using NOOP only as a fallback,
is also seen in some other Qdiscs.

The only driver currently offloading PRIO (and thus presumably the only one
impacted by this) is mlxsw. Therefore patch #1 extends mlxsw to handle the
replacement by an invisible FIFO gracefully.

Petr Machata (2):
  mlxsw: spectrum_qdisc: Ignore grafting of invisible FIFO
  net: sch_prio: When ungrafting, replace with FIFO

 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c |  7 +++++++
 net/sched/sch_prio.c                                 | 10 ++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

--=20
2.20.1

