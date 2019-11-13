Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7A1FBBC4
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfKMWlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:41:36 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:22577
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbfKMWlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 17:41:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZTJsMkKSr4B72QRgQc0BrFdfmms5RJBuF7ZIrYR8allUjKMlhuHpoKVFTeuGKiUYX+51C8hECvkBFbmeocRE+lpSj+GcJDXa5O2fr6egCZqh9EzlRISUxWqa+m/q0gF0Z3xH/gCfmkMMLxGknoImNkwQEEgdYwwL/Ms0ZzUQsExjDIKFrMmf/x+piW5j0t45wYa1FvJkehAj1oHl/IS3ftUUYDkFnVeEklOiYcfoKCv9jzNiJwF5H5tnrhDHw4J67EqTsy3gKPxAdp+oOk8J33C+Rnmm9YJ80AmFsyix7B8FAC7HPCKyw0v9mA/8CWhdQr9WGxp+kXopG8pjG4Epg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQiJM7GcgkVR55Dn54Okk740G2Jrc0vbaySe+Ji0vXU=;
 b=EhxTziyNgnVNLKrCNC06HmlWO6VGKjLhJv0quTbvf0+mdCdq7BdEK9OLDpBEQxSKp2+cRDD+D9Sb60TwAtjWE/c+2lDvqMvG76N3fZzScPaVB4ZCK2aXKQWhWpZ7MQf/SMJtqDPFMVr/KAqvauoTLmvA39+dXxYYO2Ot/R4uyJLYzTb8TSBoou97TjmkwsbJVN0RkU537CUNltQapVISJmnmwvekTE1d56SYUmJkXBvcksZRT4UgJ7JOHxYIe9H5k4uvejyH2WRS2QfePJoFFjCB0M7zEHjFn0C5nM319hpNwGNT6QjMMxdzLGFLwSTTb8fFpkYFkB2jx4HFgtuTZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQiJM7GcgkVR55Dn54Okk740G2Jrc0vbaySe+Ji0vXU=;
 b=GhIi8brmzJi5LbH9FhRBRW/mU7CJXeQdoSNb/wDgY55IbiEeX6v8+EbbKTAsHf8Pd5/LsSJy6Z+AvH09300jeYtKdu7yYJsIIaUFi80d9DG7IbfeJ1BKW9u5B6Ygf9kH4BxMWBGe95OT104Woewt/S0rpUe6hcEaCaHffJT2Ylo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5135.eurprd05.prod.outlook.com (20.178.11.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 22:41:31 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 22:41:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 1/7] net/mlx5: DR, Fix matcher builders select check
Thread-Topic: [net-next V2 1/7] net/mlx5: DR, Fix matcher builders select
 check
Thread-Index: AQHVmnN+AtMi0nv5fEKGx1Kfia5t8A==
Date:   Wed, 13 Nov 2019 22:41:31 +0000
Message-ID: <20191113224059.19051-2-saeedm@mellanox.com>
References: <20191113224059.19051-1-saeedm@mellanox.com>
In-Reply-To: <20191113224059.19051-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e6389d3b-126a-4aa9-6578-08d7688aa105
x-ms-traffictypediagnostic: VI1PR05MB5135:|VI1PR05MB5135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5135A11F78707F03017C85CEBE760@VI1PR05MB5135.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(189003)(199004)(26005)(3846002)(6116002)(54906003)(66946007)(64756008)(66556008)(66476007)(2906002)(66446008)(36756003)(316002)(99286004)(81166006)(81156014)(8936002)(8676002)(50226002)(5660300002)(1076003)(102836004)(186003)(6512007)(6486002)(6436002)(386003)(478600001)(52116002)(25786009)(76176011)(7736002)(6506007)(14454004)(305945005)(14444005)(86362001)(486006)(107886003)(256004)(4326008)(66066001)(2616005)(6916009)(11346002)(71200400001)(71190400001)(446003)(476003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5135;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oMuYJ6ea2fmfGlaFC3ok/15CLxyhbsy8ENuPz/uL9vFUOH2xt6EGAGbBILNkqBqYWeSML3/eBYugXTueA0R2bD0fbpiwocM4qn5I0JQv0l2a36gI8Y8RJOnxgznW3S3SXuKf1MxGeQAvJdMGs688JlV100t+PCpE5TcGu3ThZ3bdX+hTQu3BCFxnkbJOyYUI+yyg/hb2LkXTtK1oGOmwrkYLemJFVbXmbJUPmqbxRpzf0YDzuIRYMnW/p3KolYZ5vaBKHxcriyM6wdUtTP9skrDjS/x9IawLhlL7qGrGilTZcjH/vTCc5JXX8jhonHABnlgdCQQLPplRswweRjGaSL5x5DbH711HejXjl5IVywhE02EMzKFp3EDegd5Fdi2bMj471kfUpv3DpSdH+qJN2ibRbFTdKgNWEDjeSmVFXdlMDzwIjsehvI4lu4JuS4fh
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6389d3b-126a-4aa9-6578-08d7688aa105
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 22:41:31.5873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NVd7UgHQ4aShmW3gji+BXep96Yzhy+lzFTW5q+eCzBhdp0l5TBbSqM3UlywveI9FOzdl8PcNYatqUDOZHnOx2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
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

