Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359FB1DF393
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387486AbgEWAl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:28 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:1415
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387463AbgEWAl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ammPoh+oJZbCJwLXe8kMTBrSAQ4+AK6p9+6lAT3Snyw1pg8vEy0ZhuO0LuGsXH7jGIFQpNZlblgZJXNsBcG9zs2cknRwizRiX4OAdbqGSU0d9vvUYMoDdsxBO/tpdd5jB6/wTk58IJwoquLZ4du+jp5s4RLgH65HAE6UXGQPoCa/nyfs+WidTrd9xslC36EaRtBvsF9pQxtZd6fl9XjsMIzE2bCpshrF9Zl0VcWckWKvB+yMn6SoChIi7GiAT76aaABQM6uNDKhWn7oipc3dnsPwHJczg8/66+c+bVPQjsr5wygh57d1eDf+d80tl4yDNQCoTh+tRYBn3af8n2MBKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLCySMjJ9vOE5hYMVgHvWvpfOvCwtkmPWfkUX5lw6Hg=;
 b=GpVkytJ7SMQVUpRXW8bMghelS5IB9sdRgLkiE0UzSocyxd1h4qJd+E9q3lRT9YfW5Xl2ybW0S0pMLdGum1gozTkaTVKQZdZ/GoO6Tat5FzbaHqEx9CD9QcrFWp8LVUCI9/GUBpRDuOR5wOQHCssodu7AxYkxVX+NI4Uqm/+/MTuzvbA5lgpeumHyeH9LCqKYP5BDaqYFk/VPxc26cvJPELhJKvH0rSHkcJDSQxtlA5FvhartPhnTQebCfh0e5Jr1326ZbPd7XecR7/wFhDbp93QLcl98Aryd8kSMXL6h/y7/C7IG6UoIJTKxPLy2IFzp5TsVbMfQUMFe/u51LZ689g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLCySMjJ9vOE5hYMVgHvWvpfOvCwtkmPWfkUX5lw6Hg=;
 b=Yn5MLfPWF4FdqxSVPwazAuI0HDip/Cla840Cp+LCv+HIAJKImtIgzEmMYtOsyx3SEPUqmemClbq4PZ3RQXkM5HjSUAS/SWXsxP7+kOX/xKMpmjEs3HEJL3MIU36WcMzQXPtyJT4SkBQIi5aIWlojv9Y4WLBUqS7LtQ+Xj11x+8Y=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 04/13] net/mlx5e: Fix allowed tc redirect merged eswitch offload cases
Date:   Fri, 22 May 2020 17:40:40 -0700
Message-Id: <20200523004049.34832-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200523004049.34832-1-saeedm@mellanox.com>
References: <20200523004049.34832-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:13 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 36e17e41-6b13-41c8-7c3b-08d7feb20013
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB53912618E1C3196AD1BD0478BEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KFkb9NEJLeq+W7PSxR8Xptal4ik0USiM9UUPAn/QSzWniip501awQ5AeLuCpmcR9bT0MmqrLU8utHugw0eO/bjTimoiJ4QYdjzYicbl1yHDjqi63rhChauMM7i/iuRhL3sKP5ZZ6MhUYGjMX2jgXG41wLlcCjezHcs0ziQpDdKWFzdBXN46tazMZyAhvpcX2Nmt9r4tz2MysczdSvMUwYM2URf4bhpMxU7hwAveQE9O2cU4YT41QCIMnXCYtMJxJiyILoCmjt/4VWGWFWsaPi+rMJ9VJHmA3S7R6GDn0BppKGjPczBNlrwxLY/y51pDeinE4/rlEvJHqhzq02xs0l36O+08N87+fybDiN8N4p4D4ws6kyYlmiCcV3liD21CP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(316002)(5660300002)(8936002)(6486002)(66946007)(54906003)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8pvaeLx708D3vbV1iSOiCtaVCh1zV/G7oMWHF7THJrZE0KiozXh3+GHdmy9chyZdoKuUpOdzd+dF3fEO4aVp+zsbukby9ZnxEHNvj6v0+qxccEgkibvqvfQqUvpeHVKnnJq3WmliwYo04lWXK7a8q7l8/VuDyKd79H5uRr9QJhIAbtVCIkNat5LIYGPauw2Lgw8IYejjxtjczqEnZJR7lKYv4zdCduJA41NkrDaMRtNm0fBvqhp2zKnPW2dcp1OwQmdrreTNzTXWTpUTee+qJjZrJmxpDnQGmEdSP1MrK+WrzpyvM779/xAml97/39gZrV2aDyfV2h84MR70Oowfz7Gklg2P1CgQ+r1YV0zksglOUIiIvGC2GLqZijD9qZ18MvqfELJ29AaemvdIFupsphBHj75TNFf0pbtzTyaDju+fjq8hAXCGYx0RTfmjBu13Er5XMPLo5uffo63ktr4mnzhWcpTf99pa3BSwyT2RVv0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e17e41-6b13-41c8-7c3b-08d7feb20013
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:15.7204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ingg5TGZA4CRjD0OUmLXiSoe87KbKYzrd9eXDhrOFvjPpr9mJpd39USFvWGrRtotxBSXJ8uVh5Z+t2rnyu25OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@mellanox.com>

After changing the parent_id to be the same for both NICs of same
The cited commit wrongly allow offload of tc redirect flows from
VF to uplink and vice versa when devcies are on different eswitch,
these cases aren't supported by HW.

Disallow the above offloads when devcies are on different eswitch
and VF LAG is not configured.

Fixes: f6dc1264f1c0 ("net/mlx5e: Disallow tc redirect offload cases we don't support")
Signed-off-by: Maor Dickman <maord@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  8 +---
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  7 +++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 40 +++++++++++++++----
 3 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index f372e94948fd..cdecf4280e86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1484,13 +1484,9 @@ bool mlx5e_eswitch_uplink_rep(struct net_device *netdev)
 	return netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep;
 }
 
-bool mlx5e_eswitch_rep(struct net_device *netdev)
+bool mlx5e_eswitch_vf_rep(struct net_device *netdev)
 {
-	if (netdev->netdev_ops == &mlx5e_netdev_ops_rep ||
-	    netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep)
-		return true;
-
-	return false;
+	return netdev->netdev_ops == &mlx5e_netdev_ops_rep;
 }
 
 static void mlx5e_build_rep_params(struct net_device *netdev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 6a2337900420..612b5cf0673d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -210,8 +210,13 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
 
 void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
 
-bool mlx5e_eswitch_rep(struct net_device *netdev);
+bool mlx5e_eswitch_vf_rep(struct net_device *netdev);
 bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
+static inline bool mlx5e_eswitch_rep(struct net_device *netdev)
+{
+	return mlx5e_eswitch_vf_rep(netdev) ||
+	       mlx5e_eswitch_uplink_rep(netdev);
+}
 
 #else /* CONFIG_MLX5_ESWITCH */
 static inline bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv) { return false; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a574c588269a..5bcf95fcdd59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3073,6 +3073,11 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 	return true;
 }
 
+static bool same_port_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
+{
+	return priv->mdev == peer_priv->mdev;
+}
+
 static bool same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
 {
 	struct mlx5_core_dev *fmdev, *pmdev;
@@ -3291,7 +3296,7 @@ static inline int hash_encap_info(struct encap_key *key)
 }
 
 
-static bool is_merged_eswitch_dev(struct mlx5e_priv *priv,
+static bool is_merged_eswitch_vfs(struct mlx5e_priv *priv,
 				  struct net_device *peer_netdev)
 {
 	struct mlx5e_priv *peer_priv;
@@ -3299,13 +3304,11 @@ static bool is_merged_eswitch_dev(struct mlx5e_priv *priv,
 	peer_priv = netdev_priv(peer_netdev);
 
 	return (MLX5_CAP_ESW(priv->mdev, merged_eswitch) &&
-		mlx5e_eswitch_rep(priv->netdev) &&
-		mlx5e_eswitch_rep(peer_netdev) &&
+		mlx5e_eswitch_vf_rep(priv->netdev) &&
+		mlx5e_eswitch_vf_rep(peer_netdev) &&
 		same_hw_devs(priv, peer_priv));
 }
 
-
-
 bool mlx5e_encap_take(struct mlx5e_encap_entry *e)
 {
 	return refcount_inc_not_zero(&e->refcnt);
@@ -3575,14 +3578,37 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
 	return err;
 }
 
+static bool same_hw_reps(struct mlx5e_priv *priv,
+			 struct net_device *peer_netdev)
+{
+	struct mlx5e_priv *peer_priv;
+
+	peer_priv = netdev_priv(peer_netdev);
+
+	return mlx5e_eswitch_rep(priv->netdev) &&
+	       mlx5e_eswitch_rep(peer_netdev) &&
+	       same_hw_devs(priv, peer_priv);
+}
+
+static bool is_lag_dev(struct mlx5e_priv *priv,
+		       struct net_device *peer_netdev)
+{
+	return ((mlx5_lag_is_sriov(priv->mdev) ||
+		 mlx5_lag_is_multipath(priv->mdev)) &&
+		 same_hw_reps(priv, peer_netdev));
+}
+
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 				    struct net_device *out_dev)
 {
-	if (is_merged_eswitch_dev(priv, out_dev))
+	if (is_merged_eswitch_vfs(priv, out_dev))
+		return true;
+
+	if (is_lag_dev(priv, out_dev))
 		return true;
 
 	return mlx5e_eswitch_rep(out_dev) &&
-	       same_hw_devs(priv, netdev_priv(out_dev));
+	       same_port_devs(priv, netdev_priv(out_dev));
 }
 
 static bool is_duplicated_output_device(struct net_device *dev,
-- 
2.25.4

