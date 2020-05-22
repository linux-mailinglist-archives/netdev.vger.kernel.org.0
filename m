Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33291DF34E
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgEVXwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:52:41 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:15428
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731233AbgEVXwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 19:52:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pf4SJDCv4sq8URwICaCie6KBVC2bjy4g1KxJumwHXH4CBY+EABvoJV5SxFwkmc2H3JAcGGqOGtkkuUJZS2Ce4DY2Ap6JWduxhYj8BXmgDti3gQQyVC4DxC1xz0vNujA9hIpNamxYuKHMWEeKPzD/dgSpeS1XvSy1TNkFPcFnFYolX3fHq3RAr4VI3b017bSoE4aC90TKIV1AfHB5TQQI6NanWAPiP6mQeTNNRB6nM72W9n7S4J0AKrh0oG+MjsxzJs0oA5vv05SudmKmS9MKDlO+eNZOkfWWy45+Mnvq/wpvDO4ot1DlBJFldmy3ck8em74UuVkB55Yga5YNnid5eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFIOK/EdRhtIkSGKymtP/0ilqte42hQW941PbUKuH9E=;
 b=JERmyanRK1wyFJNPF55IMW3OiwL8muWC+UZ7lP8Vaq+Bf5ibOzRqi8J9LEyxfvcv0QCVABvZ9/Z4zp1mlRWvzh99EZAXEycCQbyfX85BghllhXkycIglMLlidbhPaews/AdlxjvpfU/0LyuPhcbj/9a2H0/Q0+QUPGMlADH4jDJdXvzy/l+7ob2ZZFAkXgB2j2SUdoVbDugxtL0j6MTqVFXl2ckaapxm1rYNVMlarGfIWdZYpEA1K/errhdaIX78rXVkmPn392qpIiwahPALTXgTQmPsaUwYaWEWirkZPAhQCc+mqgPyWDxOghC1WKaBqWJI2RPg/wOUStL1eRXIHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFIOK/EdRhtIkSGKymtP/0ilqte42hQW941PbUKuH9E=;
 b=fs+0gMu0JuuLg6V0cLUQYzIai5U3i7rVLSX/McqaTOH8cihsBRqzrQnphiBqmffcBfnz6r3swjFTzbu2QwnRE+7QFo+rgxVBaqV3cCLCiUOhl7DFE8h88TFWDa/8aBX2HW4HbkT2GkveBoupWFuRWWWeMLK2VLiFFYVGzGBJzjI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4544.eurprd05.prod.outlook.com (2603:10a6:802:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 23:52:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Fri, 22 May 2020
 23:52:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/10] net/mlx5e: Move TC-specific code from en_main.c to en_tc.c
Date:   Fri, 22 May 2020 16:51:42 -0700
Message-Id: <20200522235148.28987-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200522235148.28987-1-saeedm@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Fri, 22 May 2020 23:52:16 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f1da15b-9095-48be-a26f-08d7feab2913
X-MS-TrafficTypeDiagnostic: VI1PR05MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4544C027E0B563ED41490914BEB40@VI1PR05MB4544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9LpSJ4iFQeqH3R/g4pMkIGLnIlpwfN/hJv2mfu6mcMGlQIkTarr5VVQRi4r4HzjOfLbxocjUJhdsKRDp9FuiRamLk9727z+iO9fMk0ZSekdmCvAyckcgcxqm9c+/PCxxbuTL1cRfiCbSHLiSrQzN79p0XHrOkNsXyTthTm3okAJwMFaBNsXZFauZwLBvb/r88rAP9/+mBL/EV0qGBcQG/6PpDWxeWxgXPgu1klFKFSIZjdJSy3Xbqv0cLGy5iRZoUqYw2DXU8ZJhdXplwwDwxfZqbJodn2JsuRVCT7YACm8i57BwRHLcs37vSrxWtNRZLLDsQkorj31TudyU+A/imAH7lpvkQqIkv77Ep+GJX92TOC2b6pMhQTLo9oebd5ms
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(66476007)(956004)(6506007)(66556008)(2616005)(66946007)(107886003)(6512007)(1076003)(16526019)(478600001)(186003)(52116002)(26005)(4326008)(6666004)(316002)(6486002)(86362001)(8676002)(54906003)(36756003)(8936002)(2906002)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: N39qlbQYUpmA5zzQdcLRFJuL0DYMJGfrB5qqyeGB7yA5isbjMXfOtv3EYp9gTOHZ/b2My2TpWlFlkQbazZyHJxmBAn0qAYAHXyMRgo3tRJvFBqVMxEJCkJ0QRclypoJ31Qwz1X/+jYaGg4p7zlPOTipmu9bhQ3kxn3F7BpLIn1203kpxy6nrDtT9A8C0o3MljpeK4ad9uxHAdqIFpruX+QL0rp5pD8xX9YwOBl3iDxI0PSD9A0iUE/SYTxzh2gmcv8GNgeadXWXl4DktjZTU4y80wE6iaEMvUuGjAo5q9QFF1ad6MNlZ14A5IPp7/1OmqetphjKkFeybGTw0yhU6BjU683ktXMdRLsxDkXiTsJLkKwpaIOM1o5+UZiCpTowfZw8K/4oYGP8yKfNLTbCY5iyxcNkuFG6lPub3Qc10tCz2+GxHCPxNU4dlOOHodVpz6r5vENtZ/V7c+C827lpna+1C1NiSPGMgyjiBFYv50No=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1da15b-9095-48be-a26f-08d7feab2913
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 23:52:18.0048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1rYTw//tmY2e7Zcuc6BkKmdFj4dF9UOech4Beg2kyWzmerHg+Ap3sZxHO1dxVJXsx24hKCDphMe9jug6OzL1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

As a preparation for introducing new kconfig option that controls
compilation of all TC offloads code in mlx5, extract TC-specific code from
en_main.c to en_tc.c. This allows easily compiling out the code by
only including new source in make file when corresponding kconfig is
enabled instead of adding multiple ifdef blocks to en_main.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 37 -------------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 35 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  7 ++++
 3 files changed, 42 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 07823abe5557..3829dfd39800 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3539,41 +3539,6 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 	return err;
 }
 
-#ifdef CONFIG_MLX5_ESWITCH
-static int mlx5e_setup_tc_cls_flower(struct mlx5e_priv *priv,
-				     struct flow_cls_offload *cls_flower,
-				     unsigned long flags)
-{
-	switch (cls_flower->command) {
-	case FLOW_CLS_REPLACE:
-		return mlx5e_configure_flower(priv->netdev, priv, cls_flower,
-					      flags);
-	case FLOW_CLS_DESTROY:
-		return mlx5e_delete_flower(priv->netdev, priv, cls_flower,
-					   flags);
-	case FLOW_CLS_STATS:
-		return mlx5e_stats_flower(priv->netdev, priv, cls_flower,
-					  flags);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
-				   void *cb_priv)
-{
-	unsigned long flags = MLX5_TC_FLAG(INGRESS) | MLX5_TC_FLAG(NIC_OFFLOAD);
-	struct mlx5e_priv *priv = cb_priv;
-
-	switch (type) {
-	case TC_SETUP_CLSFLOWER:
-		return mlx5e_setup_tc_cls_flower(priv, type_data, flags);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-#endif
-
 static LIST_HEAD(mlx5e_block_cb_list);
 
 static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
@@ -3582,7 +3547,6 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
 	switch (type) {
-#ifdef CONFIG_MLX5_ESWITCH
 	case TC_SETUP_BLOCK: {
 		struct flow_block_offload *f = type_data;
 
@@ -3592,7 +3556,6 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 						  mlx5e_setup_tc_block_cb,
 						  priv, priv, true);
 	}
-#endif
 	case TC_SETUP_QDISC_MQPRIO:
 		return mlx5e_setup_tc_mqprio(priv, type_data);
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 749390dc7aaa..1614b077a477 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -31,6 +31,7 @@
  */
 
 #include <net/flow_dissector.h>
+#include <net/flow_offload.h>
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gact.h>
@@ -50,6 +51,7 @@
 #include "en.h"
 #include "en_rep.h"
 #include "en/rep/tc.h"
+#include "en/rep/neigh.h"
 #include "en_tc.h"
 #include "eswitch.h"
 #include "esw/chains.h"
@@ -4777,3 +4779,36 @@ void mlx5e_tc_reoffload_flows_work(struct work_struct *work)
 	}
 	mutex_unlock(&rpriv->unready_flows_lock);
 }
+
+static int mlx5e_setup_tc_cls_flower(struct mlx5e_priv *priv,
+				     struct flow_cls_offload *cls_flower,
+				     unsigned long flags)
+{
+	switch (cls_flower->command) {
+	case FLOW_CLS_REPLACE:
+		return mlx5e_configure_flower(priv->netdev, priv, cls_flower,
+					      flags);
+	case FLOW_CLS_DESTROY:
+		return mlx5e_delete_flower(priv->netdev, priv, cls_flower,
+					   flags);
+	case FLOW_CLS_STATS:
+		return mlx5e_stats_flower(priv->netdev, priv, cls_flower,
+					  flags);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
+			    void *cb_priv)
+{
+	unsigned long flags = MLX5_TC_FLAG(INGRESS) | MLX5_TC_FLAG(NIC_OFFLOAD);
+	struct mlx5e_priv *priv = cb_priv;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return mlx5e_setup_tc_cls_flower(priv, type_data, flags);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 1d8d85b842fe..9c59b7fe258a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -173,6 +173,9 @@ void dealloc_mod_hdr_actions(struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
 struct mlx5e_tc_flow;
 u32 mlx5e_tc_get_flow_tun_id(struct mlx5e_tc_flow *flow);
 
+int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
+			    void *cb_priv);
+
 #else /* CONFIG_MLX5_ESWITCH */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
@@ -181,6 +184,10 @@ static inline int  mlx5e_tc_num_filters(struct mlx5e_priv *priv,
 {
 	return 0;
 }
+
+static inline int
+mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
+{ return -EOPNOTSUPP; }
 #endif
 
 #endif /* __MLX5_EN_TC_H__ */
-- 
2.25.4

