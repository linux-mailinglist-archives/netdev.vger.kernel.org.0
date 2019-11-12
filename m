Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055C5F96C8
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfKLRNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:13:45 -0500
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:60022
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbfKLRNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 12:13:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WiENS/Dxo0D7UCs8H9z39l1o46WvXfMq8lzxH3kQwtCIJaiPm0ZTOltGVZ/wnZZRDwacEcWXxsntQqHkKZNnnslY88Ic6FY4o2zscOX0sD4A7FqdfSS2jr8F1C7dp5wHxswKjf6Iw65O71tIPzr1ByDTSppGbLWzYBrQ/J+GvdDeyfC5Ez0i/fMtwbJ+8k4RBRNsr7uujgy+fMP+43oVp4rYEb/HQ0OLYvQLqxDulOMO4VvdgV9VaqxRdWIN7tIxHXAuAV6Sb4RDvFLiL1siwgszqbebuslHQwNfZ6OQsOFyGQWusJbltcODefuWpXZKn9KR+x6i5XmVCS73Zfokqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQiJM7GcgkVR55Dn54Okk740G2Jrc0vbaySe+Ji0vXU=;
 b=hEDSG6X2WsAxatDrPQWPAQe00jRnALUzpBUA7wCvAaZyYjiTLH2HavZT3HvzE5ZeJ4O7WGcR9xHYsyjKc++oGWVlOe8/iE1VGyHqSsrDba7/PZ95tHmE4pSou14VxMR4m24qbMINQ4io51fkdkOH79ROlRw4LMGQoaWVYSVf6BnJPF7lVLU6G/7y2XiGsb/8oE/0WNaJNlmuOV1KxaXrU3YVEZJRy5ZVSQ/jm1aI+ez//pUxpNl0wOTRKYFCEbhez6qp63zIrV/ADLjOUwPjUlvthu2u9Ln0fQlQHzSWcn3bRH5Z3vutONzg47ug2fPJFtjyHMyXRU7e7GVGEM/gQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQiJM7GcgkVR55Dn54Okk740G2Jrc0vbaySe+Ji0vXU=;
 b=rEr3jIV/rihgs+ZVkTSNH7g+fcxfzv3ZdNVTdlrFdOlMw4V13Fw4NlaMJy6NaRgiGoH/XTwcVV92dvic7nYyx+d2Cm64vrzz/+B3n1RTUorOUnT1Jx4IqF/CPbdv/cxB0oeiOhV5+FPAcdpZx1PdHRn879gI0knHcdf2N5JWgs8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6078.eurprd05.prod.outlook.com (20.178.125.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Tue, 12 Nov 2019 17:13:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 17:13:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 1/8] net/mlx5: DR, Fix matcher builders select check
Thread-Topic: [net-next 1/8] net/mlx5: DR, Fix matcher builders select check
Thread-Index: AQHVmXyHRwxTr7GLs0iNZMZiDN5h4A==
Date:   Tue, 12 Nov 2019 17:13:40 +0000
Message-ID: <20191112171313.7049-2-saeedm@mellanox.com>
References: <20191112171313.7049-1-saeedm@mellanox.com>
In-Reply-To: <20191112171313.7049-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0059.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::36) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6b993b1a-15e8-4739-2882-08d76793a985
x-ms-traffictypediagnostic: VI1PR05MB6078:|VI1PR05MB6078:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6078257D665C774AF1AC895EBE770@VI1PR05MB6078.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(199004)(189003)(71200400001)(446003)(71190400001)(11346002)(3846002)(76176011)(6506007)(386003)(52116002)(256004)(316002)(476003)(14444005)(2616005)(486006)(6116002)(66446008)(1076003)(102836004)(66946007)(54906003)(6512007)(64756008)(66556008)(66476007)(86362001)(5660300002)(305945005)(2906002)(6916009)(7736002)(8676002)(81166006)(50226002)(8936002)(6436002)(478600001)(6486002)(14454004)(81156014)(36756003)(26005)(186003)(25786009)(99286004)(4326008)(107886003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6078;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JnUvo/M7zSBCEwUNdUejfhoZeglXXs2IwoXOZ/IhHWK6S6wro3Rax1lOngEFzBZBeAagelhlF6pOBONtwyZ3ya1qYRQYtjJaK9dXoZEXsReq8hzdRGEh85SbyymrRLlSon4/UF/xaY4QyPasPypNMNW+/byMn4koixhVgAfF1rOfmuaSHTZKH5/ikpTuJ1G9OMHDoyAfaqZJp/EnX5Pku78c5mUpPTjyKofHlKWwQaPQHKTn4+DVqG3bb/nodYXuTXvo53fngpUzvVM07PrkWWUhhHd97lkrxniYjEcK1LWqYwuUyfFGKolpKNRdC9N26nj93Uo617gnPFZJLC8QjoUonCCTmxQ3ItXJhsJ9DI8fLFowMw9gi4q16iTOsUq5voscf9gm5gTMhA1vZ1eaGsEY9TbeJaFuD5b/hLy5DlYAq1QI/9k09pMurrEFE0r/
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b993b1a-15e8-4739-2882-08d76793a985
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 17:13:40.2301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dd2uD+spZay4sw+tVY2GOCJ07rL/lYYU1w/RA/g6HmuGqC5XofwByf/ZhVhp7c4Rkntqmz4An9tyPi96Ld3e6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

When selecting a matcher ste_builder_arr will always be evaluated
as true, instead check if num_of_builders is set for validity.

Fixes: 667f264676c7 ("net/mlx5: DR, Support IPv4 and IPv6 mixed matcher")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 5db947df8763..c6548980daf0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -154,7 +154,7 @@ int mlx5dr_matcher_select_builders(struct mlx5dr_matche=
r *matcher,
 	nic_matcher->num_of_builders =3D
 		nic_matcher->num_of_builders_arr[outer_ipv][inner_ipv];
=20
-	if (!nic_matcher->ste_builder) {
+	if (!nic_matcher->num_of_builders) {
 		mlx5dr_dbg(matcher->tbl->dmn,
 			   "Rule not supported on this matcher due to IP related fields\n");
 		return -EINVAL;
--=20
2.21.0

