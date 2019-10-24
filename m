Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAED8E3C19
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436786AbfJXTiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:38:54 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:7745
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387655AbfJXTix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:38:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V39aWqimcsLRTuzeoRCQHshhvBerGOIPzfEWIlt13PoSEjv3aw5m5Bbld7vw9Bj2K2/7s2Aqla+YgHwebbRZ/NsUGHZC02U7HWy8Nk2yEpJzGXdL7I44gmsdZVw4Ep53eNwv//jKX6CFUpFeJP5Fh4wri1c7TPgmigtoJsvkyz3waVWmkhaPnuTRDMF52Swiwqqb3+mmTZF4ZdGu+YU0nw4uajurPLpHvZC9a5Q2zNEliJKwh2npUz+POHBeLL+ntb3ljAdJpQ6W/fzxzLC3E38IlXjmxevv5MOSVRcZiNlgotOo3SnPdPofNZNLq5S/OOX7qKlB9bs5+2iSVZ5BjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FN+d1CJe00PDnrnGyes/eJpvvUnN+nZwVFj+Hw8SmoQ=;
 b=UeNw/9Juwfpw5HRcCrjm8etZH18l4cGz8sTxoLGk64s9nXeAnz+vBf+nOLfZ3ZPIfaysRkOqmh1G6jKHv8G9cqi03L/X9xTp7CO5CToVYvMDORoj1Q5nSmUADzz5/dg/cqleICufcnYLDtbkmCqq0yCtQ5hI2XxsJaB5Z3M3REZU0xMoE5a6e81XNUAYblA78BM876pehWWGwiqGCDqjIg9tQETALv+zWFbmzX6/6NMymS+czIvEs7KCOkpfZ3HCNyF2025I3f5HF1wNgbJ72QsDQBQyiFAk9JyPtl+OwncjhBO42R0h9o4p/1rjZiBrPcoC9x90raL4RgNLbqjcug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FN+d1CJe00PDnrnGyes/eJpvvUnN+nZwVFj+Hw8SmoQ=;
 b=mxS2icde+K/EgEKuLF/qU3QESORDZwHY6hsXbiKotoMACI4WEoYHfa6IqBjSbviNFO1OX5yiVNYJR89DBQyJfgN5iaiY7vPZ8vQgfXz/R9TjKRr8riYqMIPgQoUfgLAZ3Lu6f63CSwxmx5sV/+gWeRYwsxyQuEn6D66amI5xTAA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4623.eurprd05.prod.outlook.com (20.176.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 24 Oct 2019 19:38:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 19:38:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 04/11] net/mlx5e: Replace kfree with kvfree when free vhca stats
Thread-Topic: [net 04/11] net/mlx5e: Replace kfree with kvfree when free vhca
 stats
Thread-Index: AQHViqKoiUuwDmyIoUOHTnewHn3Enw==
Date:   Thu, 24 Oct 2019 19:38:49 +0000
Message-ID: <20191024193819.10389-5-saeedm@mellanox.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
In-Reply-To: <20191024193819.10389-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d99825d5-f0f5-4128-d0fc-08d758b9caae
x-ms-traffictypediagnostic: VI1PR05MB4623:|VI1PR05MB4623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB46239617128E1625FD6E81C5BE6A0@VI1PR05MB4623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:130;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6486002)(8936002)(316002)(478600001)(50226002)(81166006)(81156014)(256004)(7736002)(8676002)(305945005)(2906002)(52116002)(6512007)(54906003)(5660300002)(99286004)(186003)(476003)(486006)(102836004)(4326008)(6506007)(386003)(11346002)(6916009)(26005)(107886003)(6116002)(76176011)(3846002)(14454004)(66066001)(36756003)(66946007)(6436002)(446003)(86362001)(1076003)(71200400001)(25786009)(66476007)(64756008)(66446008)(66556008)(2616005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4623;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r/MCd1L8L1koTn4UtmHn5va9IdopFBtz0l7FV3tILJQam0C49UMUvMrpOSVcFRcCwcQEtyUDHgj6iV2qFrdJKIfv5MUdMlqlOgytzde0fwQNnMTpp4GBW6I5Eo8W2WJ9/Hk5S7IHTVg6iTeCoxFVxHlcZ3SPC3B29iBkvolYa0Ky43eSe3u9TeWf1j80mq3dA+0JLUXLqjWKoY5ifydg/zXQL+5GuYk8r2SliLUp3tHj/qGfXUdkoA7V60eEaOkTwmYupSMt0p9XMTy0IUaTSN209iDbuf111zLfnNew2Duk6LwsPp9gVIr+9ISX712i4JJo/hkEo2dJBHi8uXhL+W7rN177mTXCsyEiksmV6FzYico6E8ldTClaFk7bCLSH4TfTh6nGjDZuPXRapQSZ4pXPZ1SjatUHJOqWYVLfjkC76QPOmzpzE/JB6jjiIB+h
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d99825d5-f0f5-4128-d0fc-08d758b9caae
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 19:38:49.2740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FaiqJlX2vU/sT7hVg/dH7JnFBr2+bNePFqvgJy5xJT9/6sDrP/K858Gy9n6+3ynwdcG0rPOr0HYF0rl3f1EjvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Memory allocated by kvzalloc should be freed by kvfree.

Fixes: cef35af34d6d ("net/mlx5e: Add mlx5e HV VHCA stats agent")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
index b3a249b2a482..ac44bbe95c5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
@@ -141,7 +141,7 @@ int mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv)
 				    "Failed to create hv vhca stats agent, err =3D %ld\n",
 				    PTR_ERR(agent));
=20
-		kfree(priv->stats_agent.buf);
+		kvfree(priv->stats_agent.buf);
 		return IS_ERR_OR_NULL(agent);
 	}
=20
@@ -157,5 +157,5 @@ void mlx5e_hv_vhca_stats_destroy(struct mlx5e_priv *pri=
v)
 		return;
=20
 	mlx5_hv_vhca_agent_destroy(priv->stats_agent.agent);
-	kfree(priv->stats_agent.buf);
+	kvfree(priv->stats_agent.buf);
 }
--=20
2.21.0

