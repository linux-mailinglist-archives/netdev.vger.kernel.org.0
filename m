Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C40AAF2160
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732707AbfKFWFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:05:48 -0500
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:20628
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726957AbfKFWFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 17:05:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrzRdI871fZb0Tqmq2GHS2cJjL0CRFzVqyFG9sbC/0wwnPDDkUiZ9SzCLsixW+OSncfRrDd/Z25dDw2XaSvXXow4/FQXmy2nYthC+0O6k6G/DrcA8Uwt8NvN2oQL9PwDIiTguKaLlQCy7m6VEvcjTkZ7V1A7TeSw2CQriWoCB3Xsa5dPwFUJptBXlGzv/aMX6+uxz2AiavzciuCbEzOUd70ehWItVgmcKdr1Elus9w5DAH+Fd0eQdxVa2pvrb2qvc/qWMmYQKAuMGowcsNAT+eHBx5aRSJThP7jSf7WW+z+5q5m3E71YUcAh4EVactUsFYIMg44ZPZhlD/+rsRgygw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=073o07dYMMI0pO0e32J6Eoms2qBpqMRjbvL6stny5V8=;
 b=MDKbpGewzyYNR4A9bcEUJiu3CHpEGNrKxOOvruxJSLwAFj6rhkoJRhM8qcEsGNZR78V07wT5O+gA5qgpibJdA6K7LKGbz2Wt7no//U1lwD2aASlVh9vicqK7pdFry6xRK1cDxtk1gRGX0BqnsdIa0Fo1ktVJA6569rlbQxHQfAmCNxsb2XN55o6SuCjlgO0FhLZr+j+Khh3lxaE/qzltIfCu5zAa1TzHTcRW8htLhpENQLCaWKvfi0Q6Zx86mm23Mu6A238x7QcvrdhBizeEMkzGozS41LWIZybXyDQc/f5cbDwdB6sZ8m8xTwsPkgN+/hXHqbnrdO7XmEulkybcyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=073o07dYMMI0pO0e32J6Eoms2qBpqMRjbvL6stny5V8=;
 b=rGimbkoqWmJHCJR3ia2PegOpS8U6o2bVRfYg9y1H7iqLL5AoaGeglqEw7CH5JxTwI+oSjBEOygRsD5E0R0UDwqJjqEoegr6+0IrdTu4ZwtT0ruClSRK5yuUxnM/LGDSatjCI0ggcLHqV7iHPv7yxt/IXsk9FrR89mpK2atpEzS0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5309.eurprd05.prod.outlook.com (20.178.12.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 22:05:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 22:05:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/4] net/mlx5: DR, Fix memory leak during rule creation
Thread-Topic: [net 3/4] net/mlx5: DR, Fix memory leak during rule creation
Thread-Index: AQHVlO5VMmVe9twiCECgIH0jJjLOCw==
Date:   Wed, 6 Nov 2019 22:05:43 +0000
Message-ID: <20191106220523.18855-4-saeedm@mellanox.com>
References: <20191106220523.18855-1-saeedm@mellanox.com>
In-Reply-To: <20191106220523.18855-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b5ca73c7-7b21-479b-9eb2-08d7630577d5
x-ms-traffictypediagnostic: VI1PR05MB5309:|VI1PR05MB5309:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB53091516C47EC1604B24AC32BE790@VI1PR05MB5309.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:813;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(189003)(199004)(478600001)(102836004)(25786009)(7736002)(8936002)(14454004)(64756008)(476003)(66946007)(71190400001)(52116002)(2616005)(4744005)(86362001)(66446008)(3846002)(6116002)(256004)(2906002)(6486002)(5660300002)(6506007)(305945005)(71200400001)(76176011)(386003)(8676002)(1076003)(6512007)(6916009)(66476007)(6436002)(26005)(186003)(107886003)(54906003)(66556008)(66066001)(4326008)(446003)(99286004)(81156014)(81166006)(486006)(50226002)(36756003)(316002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5309;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NGXE8c5czbwOSCEEZXTTucO1ri4tkWvjb4MYuLx70xMBCpGGbMWc/08Bsal9+Q4kNXSKAFTmbuIBQfsz6+ZhxPg5IP5c5TJVST8iaxfeZu9IqqUacncrtw02YkKwRz8Una8hWR2AwhIgR0ct1vKjRKCTmUulnLymmo66KYIf28RDVIegRHg9EK0nlcVSStFLG7gX+mZJIFcQxnYF57fMnpoDYfrnGs1yLO+tlH63KxI6Y0fDvbT4tmBsBZu0hec5dLpGEV6F9zzJcYKJxtV5/zYeSLmad/51pnlALIGEOZgXe/Mm9IGgzQF6fknBKB9e8a8/m8r+DtbRddGmZafevbZ/GSz//IhfTySBt4FfPS6fkgwbm0ukj4vLCh7tAHLM6fuUbMboed5Bw3+AiVHEaZxSTHfVL+BIowsq1UBOlmfDQyocvTzlnSn6kg1oBcgE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ca73c7-7b21-479b-9eb2-08d7630577d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 22:05:43.5997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zEdpOMj9oRNrwtPMq36HPhXRid5bUmDHQAAD8aP6ftEHkCD5DDrX8EObBHhWCNjpnL6vOjUGaAqWB+jt9dx4Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5309
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

During rule creation hw_ste_arr was not freed.

Fixes: 41d07074154c ("net/mlx5: DR, Expose steering rule functionality")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index e8b656075c6f..5dcb8baf491a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -1096,6 +1096,8 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 	if (htbl)
 		mlx5dr_htbl_put(htbl);
=20
+	kfree(hw_ste_arr);
+
 	return 0;
=20
 free_ste:
--=20
2.21.0

