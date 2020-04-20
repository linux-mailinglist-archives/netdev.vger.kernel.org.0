Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7587C1B185A
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgDTVXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:23:53 -0400
Received: from mail-eopbgr30068.outbound.protection.outlook.com ([40.107.3.68]:52910
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbgDTVXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:23:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtoESOjB4s7oUS84PYiCCf8lApHUanmtFBo9T36TuNll2p9oAlITNt/V+SdL0AKLWhgp4i3PMy607uLJnZaklHmPIuzUbQjyt8QR1Qgp55HMSmuLZfNZ8tEzI5Ik2HBIA2ZZSFr92r03jU3thLUy1iqjnvtn2Fk2mTsVSjH52K9ZAXQ3B6jEBImJLj8AbqprfdBKgiHC+78McqFSS+OIXmGl+lqyW8wmZ/pBdBwupu35rRTLwnPFQzBXV1GdxLO9MAwI7p3gGIkBQkR5nzuqFUgOOGIVrppOFUjioPVY3LBm7yoR1/EzuRpLYOyL61OvPUsPhM8N83bIEhUk/b7DWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qtG1Lqhm1Sp3q1WZ4RvsGlSHfMs/aMQ6Jku+ORGr60=;
 b=Jz5vZAGm781AqNjZHjMjVWpsqHP9kdRGQQU3uA1E0q/Bo/G2p0VujVSxKDZV/rddBKl+Vp2brv3I1iXWKmKIov5sSbSVBKG/dQmXCRjphPsgCt8ehPMpo3ceZwEVbn7yIarO/SkJ6JmXMm9nFYsIq3R6em1dnT309PCS/L0PXB1JLXFk5WN84IXXaqwcEQXcf8enLPlyhO2jCNEQ3bjGz514yEzAULhQDhp11vQfgv/nsqukhmW5dTUJ4q+7fHBAjyv5t4d/8TwKfHc1oUWUwuZ4AKe77xNyTD1xrh+S+f0JuZu3G0z8soGVmlubOOCF2cb3wu/nksed4uLyblFovg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qtG1Lqhm1Sp3q1WZ4RvsGlSHfMs/aMQ6Jku+ORGr60=;
 b=Q7ofIc8NeZZDuoP6hHxh30yeTqgMaAhu2Dp6wAfkL8/v098ZaCrB2PdbMxOt+jdtKNqHce/IB41uuyQonL2Vxljlz/KdB5Wk5rR3M+Ub+Y5zMwHokMO6S4OZLsGrR/YWNQixtzTK9hvxRaPuPx2tvJcbIkUKsyhCQ9iBDoa3K/A=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6478.eurprd05.prod.outlook.com (2603:10a6:803:f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:23:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:23:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/10] net/mlx5e: Allow partial data mask for tunnel options
Date:   Mon, 20 Apr 2020 14:22:20 -0700
Message-Id: <20200420212223.41574-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420212223.41574-1-saeedm@mellanox.com>
References: <20200420212223.41574-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 21:23:11 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e8132df1-1e88-496f-c6d0-08d7e5710837
X-MS-TrafficTypeDiagnostic: VI1PR05MB6478:|VI1PR05MB6478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB64781116C9BCA9169182690FBED40@VI1PR05MB6478.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(107886003)(6506007)(86362001)(2906002)(186003)(16526019)(26005)(4326008)(5660300002)(36756003)(316002)(1076003)(66556008)(478600001)(956004)(6666004)(66946007)(52116002)(66476007)(6512007)(6486002)(2616005)(54906003)(8676002)(8936002)(81156014)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: naw/aKg/pPV+yKBwQ4bDq5XX08+aFRFLdPyvk+yxNfMBb6v4Es2N8SbOTyUvt5CTwIJB06+hTIMRymFIOB/m9b7YeQ9C66EneEWPiKVxTgUSsaSLhwQQKeddEbyfzN3i7aiWVEah6x+BOE+BDgscdZ2PFsRq3bnMmWKcBfR/mDXBhrA+4C5cbV6julVMSIn2dUjr68befv9C6L6aaLKYetO2OKAggKTMsbFesK3nlj7kAI2kANEg4KWdT9qpjwff4Bky8kwIj2f1pcFW0e1sipJ5dD0TiVmu/ZQdkN3WPmd1jSstTzdp+V33frffFjV+P5yTvBj1vN8IW8+dKzRHbu6z1a5Iwsz6ZJuCwMObqpG5zzCdC3eAwWBBEZg9krCrwjnk74L6VDU4iX+7ZwdeMH1XUCVgrBdflrn17rOkwn9BmryGc0pAWq0A3XFdOd/KNxBIvHiRSSBP8NfrxsxGDYfOii1rLQfa+Da6FtxVjwjgl+nDz+4IdqGsNlL9GfaR
X-MS-Exchange-AntiSpam-MessageData: b0Z46pmEC6T6SYEgB4lPdmXR0B7wSVQKg5ndRnIqYXW6c+qBqnJfjjrMP6m+DRDz6hnYqE2BWH6DZsoDbiyQx7pPMubJqVxbUrxbWu+iQuBoYRnQ5Io+hj1UEhSswVzZ1ME3UWgZ0Q/jtNHEyhycUA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8132df1-1e88-496f-c6d0-08d7e5710837
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:23:13.0501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2XTe0H9xsx7ehenFU1OlXoDDJk9zYBZuBgwGPdhrmW98fqaZUkB8t4lDx3lrxyPI8zbzDXHZA/+3K+T8S4YIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6478
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

We use mapping to save and restore the tunnel options.
Save also the tunnel options mask.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 32 +++++++++++++------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a574c588269a..7d2b05576f44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -171,6 +171,11 @@ struct tunnel_match_key {
 	int filter_ifindex;
 };
 
+struct tunnel_match_enc_opts {
+	struct flow_dissector_key_enc_opts key;
+	struct flow_dissector_key_enc_opts mask;
+};
+
 /* Tunnel_id mapping is TUNNEL_INFO_BITS + ENC_OPTS_BITS.
  * Upper TUNNEL_INFO_BITS for general tunnel info.
  * Lower ENC_OPTS_BITS bits for enc_opts.
@@ -1824,9 +1829,7 @@ enc_opts_is_dont_care_or_full_match(struct mlx5e_priv *priv,
 			*dont_care = false;
 
 			if (opt->opt_class != U16_MAX ||
-			    opt->type != U8_MAX ||
-			    memchr_inv(opt->opt_data, 0xFF,
-				       opt->length * 4)) {
+			    opt->type != U8_MAX) {
 				NL_SET_ERR_MSG(extack,
 					       "Partial match of tunnel options in chain > 0 isn't supported");
 				netdev_warn(priv->netdev,
@@ -1863,6 +1866,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
 	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts;
 	struct flow_match_enc_opts enc_opts_match;
+	struct tunnel_match_enc_opts tun_enc_opts;
 	struct mlx5_rep_uplink_priv *uplink_priv;
 	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tunnel_match_key tunnel_key;
@@ -1905,8 +1909,14 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 		goto err_enc_opts;
 
 	if (!enc_opts_is_dont_care) {
+		memset(&tun_enc_opts, 0, sizeof(tun_enc_opts));
+		memcpy(&tun_enc_opts.key, enc_opts_match.key,
+		       sizeof(*enc_opts_match.key));
+		memcpy(&tun_enc_opts.mask, enc_opts_match.mask,
+		       sizeof(*enc_opts_match.mask));
+
 		err = mapping_add(uplink_priv->tunnel_enc_opts_mapping,
-				  enc_opts_match.key, &enc_opts_id);
+				  &tun_enc_opts, &enc_opts_id);
 		if (err)
 			goto err_enc_opts;
 	}
@@ -4707,7 +4717,7 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 
 int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 {
-	const size_t sz_enc_opts = sizeof(struct flow_dissector_key_enc_opts);
+	const size_t sz_enc_opts = sizeof(struct tunnel_match_enc_opts);
 	struct mlx5_rep_uplink_priv *uplink_priv;
 	struct mlx5e_rep_priv *priv;
 	struct mapping_ctx *mapping;
@@ -4802,7 +4812,7 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 				 u32 tunnel_id)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct flow_dissector_key_enc_opts enc_opts = {};
+	struct tunnel_match_enc_opts enc_opts = {};
 	struct mlx5_rep_uplink_priv *uplink_priv;
 	struct mlx5e_rep_priv *uplink_rpriv;
 	struct metadata_dst *tun_dst;
@@ -4840,7 +4850,7 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 		}
 	}
 
-	tun_dst = tun_rx_dst(enc_opts.len);
+	tun_dst = tun_rx_dst(enc_opts.key.len);
 	if (!tun_dst) {
 		WARN_ON_ONCE(true);
 		return false;
@@ -4854,9 +4864,11 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 			   key32_to_tunnel_id(key.enc_key_id.keyid),
 			   TUNNEL_KEY);
 
-	if (enc_opts.len)
-		ip_tunnel_info_opts_set(&tun_dst->u.tun_info, enc_opts.data,
-					enc_opts.len, enc_opts.dst_opt_type);
+	if (enc_opts.key.len)
+		ip_tunnel_info_opts_set(&tun_dst->u.tun_info,
+					enc_opts.key.data,
+					enc_opts.key.len,
+					enc_opts.key.dst_opt_type);
 
 	skb_dst_set(skb, (struct dst_entry *)tun_dst);
 	dev = dev_get_by_index(&init_net, key.filter_ifindex);
-- 
2.25.3

