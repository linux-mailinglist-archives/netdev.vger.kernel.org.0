Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9184D1F7094
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgFKWr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:47:57 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6125
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbgFKWrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:47:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4VoAQ/rDcSttXL38PpEwVDWW9Luv/oHb7g2b2V3z9uOL295Y8kNGQluWHJA0DfjmDpyZqChZHpD42elR9pDWmAXTye5MirfdTwu8qBrQoz5ZDhfTWmQXsoCgEHrlosDhhs6g6qFb/JpBA5M+IMIgjHc5CXpDNoh5XK4c95Lu/NGjGcmn6wXmoa6Nvm45rWtm7PhgB+PVS7jUkZXF6ufPDj/aGEHJMrNhGgSJiQXBSBmEa4W38f3yaOe5d9GWO0jXL6kxdqiqq5wj/eu181WqY15buEqQSxfA8MT2EqTbPFniU8jAvue5OK8cpt1bBZ6kfH3zAdbCxe2Ryqju2+ERA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+f2wtCKnN+XvYjqJtBF3Iim/45SCS5sciUiwHMcDxI=;
 b=JdHHlRjeosHY9sAWOIpSxLdSKPUn8r3t/TR9WwsAYWlSVj+sIqnjxaJZQSFQpUcHaTHuE9Qsmh7yF2PDkSfx8zU8Iy1cVJ64LVuHFJTT6hnIO7qj0Ir/tbuFdbGYgm5G9BItCNvHRcCeiPnBEqNd6DbKIDFSxzbQGIHV8CY9WMJZ2ONZmA2iC6DNOXOeR8R16NxL2Fk46UzP6IIYF5a93vtdHAD/24AddKgtFleWumvVRFkwW7ZMjunBrUWQNU2O9lYTV3bik/30JEuLMK+VhFRn5sWbr7oNQgFGEbGIuQyxvsL10h3ol6hlMlRzuqlDJWMB8tn2Q5W0ag10ubeSzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+f2wtCKnN+XvYjqJtBF3Iim/45SCS5sciUiwHMcDxI=;
 b=mAnZMGo1qJgaMGNg/3kEHc2miUgDYTlmNFBKtt/kN7TlLbYFd40yF99TI4qHlDfnJQ725Wl+MXRJhkQRxOWZvabNeSVT0pwpDVDeNcmAt6bN4HJSnVCMl1iYXe8R6yAdy1q+AcwRur0ui46UI6YlEVVl8Fcin359jOyLUbwTOyc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4464.eurprd05.prod.outlook.com (2603:10a6:803:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Thu, 11 Jun
 2020 22:47:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:47:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 05/10] net/mlx5e: Fix ethtool hfunc configuration change
Date:   Thu, 11 Jun 2020 15:47:03 -0700
Message-Id: <20200611224708.235014-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611224708.235014-1-saeedm@mellanox.com>
References: <20200611224708.235014-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0066.namprd06.prod.outlook.com (2603:10b6:a03:14b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20 via Frontend Transport; Thu, 11 Jun 2020 22:47:46 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 95c9a765-14e5-4bef-c782-08d80e597710
X-MS-TrafficTypeDiagnostic: VI1PR05MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4464B6DEAAC932B0901AA59BBE800@VI1PR05MB4464.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YUSPkL8gV5ADEKRK/6sKw4jLyaEb2UGrgQ9A5Sn6Pexea8Pvmoqv0xnQNkz4Glvw1q4jjZSQ2HwLcvNQlxJoGLF1nCgOe8ujEWV+h4cC2Uv2/Mtshzb7YN2ttJM0cnYptn+V8HAyE9jmTSUoo9+LEEEFHoxXbyJWsqI2SjL5GiG/98GoT7WkDScC1+DPJbdy03ATsJdLVnleubfYK4WYrZGSkfKGM6cpwvvPkXu1WsFIVBPvXmZLXVrSh+MWC89AqynitubP90ZaXJpDHO10GM1tx842cMdy27jWsY9NP9DfnI7UPBcB79zIjWFONjBI8G/HhgE4kwoq3s8995+km89pEXuNm773sYmpyxhgpFT/lKHDEph+krt7CQsM6X1b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8936002)(16526019)(186003)(4326008)(316002)(8676002)(107886003)(5660300002)(478600001)(26005)(956004)(2616005)(6666004)(66556008)(86362001)(6512007)(6486002)(66946007)(54906003)(1076003)(6506007)(36756003)(66476007)(83380400001)(2906002)(52116002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZTfDTLLpW/BzF34kE35ENLwK70s8CWpQo+UdUXQSylMbeUvn5vonm3Ck/mvoBpD2tyqyEz58EfIGqJ+tNBQEUT86bpbFQqqRyiegTXvFNWJB06kHaXI4tpk72DAeFFzWLzzY87vpNdEcgc8EdNSUkrL+Nm2KSE0pJp0XMJxhJWfkiZ34sM4n8jZ7sYEq5qx64z91DGIETTKWpX1wKPm9zwuXy9S4gRaNDYxrc0kTYYSj9EIIF3v1zJtajaY+HVPa5vDgOE9aXxvDrNOwx0mVE9+VxJ2HduLPKetAmYNXm3uCetfcwIhHKDrRq5d1/KA+fA5nak7cIgIKLoNJeLxwTNdUAQOhftM8XxyB8p/DSXMrEK4jDHt2/nfh+ditKXmZA+tH8fqd6a5IfVnKcjspkFxV0i4wfgMM3VDIXKvYWWCxVeeLerdHUlFvH2JKvgvz1gvV25915iO7bNAj4A/Ri109fKlQ2429zAe71EdnupE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c9a765-14e5-4bef-c782-08d80e597710
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 22:47:48.7450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YAulH5gMlSE85VmZAWror05/bghO2YVubJWnHsTE69Tnxp3ER5ihSVs6fevS65scP4w4DvRWcO041EFUFV5Eyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Changing RX hash function requires rearranging of RQT internal indexes,
the user isn't exposed to such changes and these changes do not affect
the user configured indirection table. Rebuild RQ table on hfunc change.

Fixes: bdfc028de1b3 ("net/mlx5e: Fix ethtool RX hash func configuration change")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 41 ++++++++++---------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 3ef2525e8de9c..ec5658bbe3c57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1173,7 +1173,8 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_rss_params *rss = &priv->rss_params;
 	int inlen = MLX5_ST_SZ_BYTES(modify_tir_in);
-	bool hash_changed = false;
+	bool refresh_tirs = false;
+	bool refresh_rqt = false;
 	void *in;
 
 	if ((hfunc != ETH_RSS_HASH_NO_CHANGE) &&
@@ -1189,36 +1190,38 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 
 	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != rss->hfunc) {
 		rss->hfunc = hfunc;
-		hash_changed = true;
+		refresh_rqt = true;
+		refresh_tirs = true;
 	}
 
 	if (indir) {
 		memcpy(rss->indirection_rqt, indir,
 		       sizeof(rss->indirection_rqt));
-
-		if (test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-			u32 rqtn = priv->indir_rqt.rqtn;
-			struct mlx5e_redirect_rqt_param rrp = {
-				.is_rss = true,
-				{
-					.rss = {
-						.hfunc = rss->hfunc,
-						.channels  = &priv->channels,
-					},
-				},
-			};
-
-			mlx5e_redirect_rqt(priv, rqtn, MLX5E_INDIR_RQT_SIZE, rrp);
-		}
+		refresh_rqt = true;
 	}
 
 	if (key) {
 		memcpy(rss->toeplitz_hash_key, key,
 		       sizeof(rss->toeplitz_hash_key));
-		hash_changed = hash_changed || rss->hfunc == ETH_RSS_HASH_TOP;
+		refresh_tirs = refresh_tirs || rss->hfunc == ETH_RSS_HASH_TOP;
+	}
+
+	if (refresh_rqt && test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		struct mlx5e_redirect_rqt_param rrp = {
+			.is_rss = true,
+			{
+				.rss = {
+					.hfunc = rss->hfunc,
+					.channels  = &priv->channels,
+				},
+			},
+		};
+		u32 rqtn = priv->indir_rqt.rqtn;
+
+		mlx5e_redirect_rqt(priv, rqtn, MLX5E_INDIR_RQT_SIZE, rrp);
 	}
 
-	if (hash_changed)
+	if (refresh_tirs)
 		mlx5e_modify_tirs_hash(priv, in);
 
 	mutex_unlock(&priv->state_lock);
-- 
2.26.2

