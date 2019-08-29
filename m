Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F05BCA2B1E
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfH2Xm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:42:58 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:7907
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726416AbfH2Xm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 19:42:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ahm+FQKBhgZd9wopDuIiOV8zxe/vN8xdWtRurW7KejSCxGOFA3eFRdiGhyEgQcWvK6mWucjCzRQBo36xrWpJ3upKbJk1T5yV34h9MV1qGM+wOAgk0WCM+jcsQEpheLJuX6Lh6B9EdyKBlgp2fcKqzhhtIuGaBJfFhOGSMMq+zLIc0e0uSwi2V1g+GQjOG14Fd4oxcpbNWwZ76nkEovZEYxtqZ2s7bbuO4c3QePkKhMQfqTdlTE2AYtjjFtwMTjNvLyw1O9aJ9jwizY5thavgE0S4Lyg75kujRWCvTKIovlNWlFDTx+s+ML4P/r72Pe1b3EXHStyG9G9jVCk8Xnjtmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7O9iV/I9K5wbljMEOHx774xUFTtf1UDv/lD2OJv7M8=;
 b=PgFBEswVfzRn7T9/gPYIuTbQkFFpt86TMqgZBDgs2OqPg08uYEGNvdESv415O/8f/xZEUqXaOcSF1M0VAoS9qfeVYehAQIjt75pQIORvJ0B5UtB3H9tX7mdekXLdouWyuwAsQ9019h9PlABLObFZrqG2iadLePJDCjMw3usGVNj0cGOSvESMBL3tR+UXnxj2QVCbF96Ce5tg/R+Eub/FIWnyOtLf/D1t2VTTiFVCaBILpDCq38DatKSFlqlQykjG3crzaB2fp8BkaNwHNIAQPHu+PKMP5of4hB3Keo9Eq+B73XDZCjmnnYuyaHxBMcdq/HCfvPxf8lSaQadlcUwL9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7O9iV/I9K5wbljMEOHx774xUFTtf1UDv/lD2OJv7M8=;
 b=pFRm3zn+BkObWIXGeQSP0CGfKCGTz8hTO1hrKzeNJCZa2a/ziESb1wHJZz7glb9fyuP0A3mjWL/YPMJItpl79WPRyKIiPparGZH+PqNDQO6VbD9pz0gCc28sbHAFSDqax87pcfUmCZVuktqi6JyWrUK1IfalkK0UBTaAVC3oybU=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2333.eurprd05.prod.outlook.com (10.169.135.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 23:42:39 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 23:42:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 5/5] net/mlx5: Set only stag for match untagged
 packets
Thread-Topic: [PATCH mlx5-next 5/5] net/mlx5: Set only stag for match untagged
 packets
Thread-Index: AQHVXsNxmoWv9+99zUOKlWI4lbIP9Q==
Date:   Thu, 29 Aug 2019 23:42:38 +0000
Message-ID: <20190829234151.9958-6-saeedm@mellanox.com>
References: <20190829234151.9958-1-saeedm@mellanox.com>
In-Reply-To: <20190829234151.9958-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b36a6e0-e699-4448-30e3-08d72cda9370
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2333;
x-ms-traffictypediagnostic: VI1PR0501MB2333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB23333D891F0D28ECA833CEE0BEA20@VI1PR0501MB2333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(199004)(189003)(476003)(486006)(450100002)(4326008)(478600001)(2906002)(81156014)(6636002)(110136005)(71200400001)(36756003)(54906003)(71190400001)(305945005)(11346002)(446003)(8676002)(81166006)(7736002)(14444005)(8936002)(5660300002)(50226002)(256004)(2616005)(64756008)(66446008)(186003)(66946007)(14454004)(6116002)(3846002)(316002)(1076003)(6512007)(6486002)(53936002)(6506007)(76176011)(107886003)(102836004)(6436002)(386003)(25786009)(99286004)(52116002)(86362001)(26005)(66066001)(66556008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2333;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: L9k+yn7dsoENhad08AmIafhPrpLFWhysD61uYONVW4kFF8CpPM2QOSswmBKp89nRrbpgqvZ5XGc/mMApLMXaa8d70j2Ms7cUf5g2tK+xT8rU1ByXHBszNHX6BIGLurJt4nE+VVKn6uq/H+ZQsFLCl2vpZMyGzLmEExR9A7WeG5a+5B2stlYCe2DNblkNV3KhBqKEv7AGPDR+Cg1+Vbkpiu1I0kRq+HRiSJkV/AM7krrrue49E9MbuB0ECl8mvrMJgUsP8iEL9XrUunNXz0hh6FbXMJ/gbLLF0YRE8JCe0Is/CxvbpuE0xIpTAN66tC9NZC7bXA8xWSH0/8hmqf+PykWwKBa0NSdgzRMyd918TyTRKlL4riI597k0VHYpGcCOH9DSdsBGpi9OBYtMFNnr5oWKGKYm0eU8VV/R+z84kPo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b36a6e0-e699-4448-30e3-08d72cda9370
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 23:42:38.8728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pAVrCwrg0XFe8yBGjT+LnvgSkMLNf7qGaLgCSfC7ZPtbkZYEUYNCpr7Ecy93RP9zPAse3l7osR3KsIMxZ5e+cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

cvlan_tag enabled in match criteria and disabled in
match value means both S & C tags don't exist (untagged of both).

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index cc096f6011d9..9e9b41ab392b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1593,7 +1593,10 @@ static int __parse_cls_flower(struct mlx5e_priv *pri=
v,
 			*match_level =3D MLX5_MATCH_L2;
 		}
 	} else if (*match_level !=3D MLX5_MATCH_NONE) {
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, svlan_tag, 1);
+		/* cvlan_tag enabled in match criteria and
+		 * disabled in match value means both S & C tags
+		 * don't exist (untagged of both)
+		 */
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, cvlan_tag, 1);
 		*match_level =3D MLX5_MATCH_L2;
 	}
--=20
2.21.0

