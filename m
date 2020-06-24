Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62141206A0F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388341AbgFXCVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:21:35 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:63460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388095AbgFXCVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:21:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekf6uUkJ/R4IJNGi/QTkv71Gm8IfXEpWyKP5QDov/EBMCeSjE6BcNJixAWbsR2mi1bgYBIx4Z27TpFaMb7zIr7lubZwZ8sujpGXwXX4PcUFluuFNcGps8W3aS+pJDNOIXOP2JvMORtnULnfX2iAXecWQ82hTC+7je5p1Ikg8n9nQH6vAhJG9Fy6yaqNos9J5nm3L48vFr5eYqHXHUQNELXa6kFZdODm3yJsusDRHcQC2B1mgAnnUmdtcTlcCc80c6jnvMoTnHolDA4TuZCzAt714F8skyI5izLSf682QQgSjsHuN1xzOyNThqMcnUXsvQdGen6jQ1NX/MogmvmUZcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1ulmEsLk87aPuwLqOA4+/0tBo0bloH/+X64+wQ9dqk=;
 b=Wz5FqsBaByGyIjXbUaEh5v6mhqGqM21TM+53bkLomfONLwnnWJArFR9XOUYICD7SesZw5BywrmXX263O5zf8hrUxsQI3yixWbCTqQLlvw6l2tA1ljaBy4ms93ASYgLDJMcWGjHM2gEKPbQDmGlMDkcTIfBIIh/2VgtlY4UCw+N9VkEckk7Rq9jO+gVUgSj18E29Umt5FwG3xb29N9r1G8XtZlThsWuFDsXkZrc9qz074uO4MvwnccQQ7w9sGfqixmLVBpWLO6uPABmp/j0XgadFjupNg8qutLrmaynlx6c/443Jx/Mc9KW2SXOmvu9ic6fraDDae1q7ETm7NHdnmWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1ulmEsLk87aPuwLqOA4+/0tBo0bloH/+X64+wQ9dqk=;
 b=MmM6xMFtouFYpU89WIQ2okvgMu1ZnoOVcfs6PaBOPGKc3aJQII4XowtzIIuUNEs++XBJNEOOiWy+Kk/w4gGN4N6B11+m+tCtMbsLX2dPCeBOdUWh178o7HzWrz0KZdNzKybeJR5PZZsWZq9vB2jlLlQn1a21B204P+G8j10NBSE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7022.eurprd05.prod.outlook.com (2603:10a6:800:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 02:21:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 02:21:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Maor Dickman <maord@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 07/10] net/mlx5e: Move TC-specific function definitions into MLX5_CLS_ACT
Date:   Tue, 23 Jun 2020 19:18:22 -0700
Message-Id: <20200624021825.53707-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624021825.53707-1-saeedm@mellanox.com>
References: <20200624021825.53707-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 02:21:19 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9c495c9f-7d42-43d5-abc1-08d817e54925
X-MS-TrafficTypeDiagnostic: VI1PR05MB7022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7022E9208E38F0D8A60FD9ABBE950@VI1PR05MB7022.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:257;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /1nqucVSfEgxoEx2mCM1PiAF0VuIzTAnZ7IuXEthupyz2B9A0CpoyumOJhdaZ5BNBkAsU1r+CmOMqdBkhGj4T0AleCRENihgPSVTfu5jClMu9gitsFjQg3l0fBokg9elbDb2Y5h0tPPhKdnCv0dA5CnXuurrWeRydsMScJZm9v28wgY6sTM+9DWNlGPz9UwZjze2JlQ/vP7QfKAdnV8QF187jd/n2GGpyL2/H/ccAT+2Zf8cyZifHAlEWSr7sLfOim2vkFo73qB0bioiR64q2yWNnt197c+qI00/4mxotPm4aIiTRMq4/6oVTDFHvGsgFnXHH0QMGo7bdi2E5NvZy0NyxHx1vjemFpbSCdN0F/sj5tMYxxbgC+yXdzNrZlJ3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(8936002)(316002)(478600001)(107886003)(2906002)(2616005)(16526019)(956004)(6666004)(186003)(1076003)(26005)(4326008)(8676002)(5660300002)(6486002)(66556008)(66476007)(83380400001)(6512007)(66946007)(52116002)(6506007)(86362001)(36756003)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YUQY0rYz9eT9ebKJ6eVRB4fVoxQ/uf+GwslKqdrelhfkz0ewJ+PEgLqHJ20sZlaiKR7ykkqPCryvYbl60i0C0L1ht4l2pWE5cT9dqu9LrckKZgEgSwkXfDHUXu1ESEORy7TeBaWE4B1JI2b5A0yd49++1oIxrS+wZ+6dKmllup+dnpmfu1Zw4rC/kxOyrJnewo2esIkX0F6BJI1rj3Vta59zpQgBK/TvUv2B/ro8SjyaT7sOYFKzmS4xtA59QQhU8W0kMZDnjbRJ274/foOcnw5S/gkeHC5Ls+9cX6SawM/yTDAmHfnj9QpEXZ+SxSMIJ5ztsJWclVdQD/N6Ax4sNwd8hW/YuXnM125JylpZ9FxyWg7D/jZAcfOc9sEWgMCHl6/HZ0vPmLBvp4HXWzP5Wb12iTOMz7O4PKrqyATUXHcYwtFRV0y1HtZdOe5tGp3AKLW8shFE5gPxjAzcOtGjQXsExaV9Ago+ChOqHr/HkbA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c495c9f-7d42-43d5-abc1-08d817e54925
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 02:21:21.7119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qypaGW4AWd04qxtKI9qXttsMsS9uzwaIOQhyWq+TV9uOrYf4RGCLVsO8xTUYMsGxiCR7VsfqRa8FHwn/Tzssg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7022
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

en_tc.h header file declares several TC-specific functions in
CONFIG_MLX5_ESWITCH block even though those functions are only compiled
when CONFIG_MLX5_CLS_ACT is set, which is a recent change. Move them to
proper block.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Maor Dickman <maord@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 5c330b0cae213..1561eaa89ffd2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -40,6 +40,14 @@
 
 #ifdef CONFIG_MLX5_ESWITCH
 
+int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
+
+struct mlx5e_tc_update_priv {
+	struct net_device *tun_dev;
+};
+
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+
 struct tunnel_match_key {
 	struct flow_dissector_key_control enc_control;
 	struct flow_dissector_key_keyid enc_key_id;
@@ -114,8 +122,6 @@ void mlx5e_put_encap_flow_list(struct mlx5e_priv *priv, struct list_head *flow_l
 struct mlx5e_neigh_hash_entry;
 void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe);
 
-int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
-
 void mlx5e_tc_reoffload_flows_work(struct work_struct *work);
 
 enum mlx5e_tc_attr_to_reg {
@@ -142,10 +148,6 @@ extern struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[];
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 				    struct net_device *out_dev);
 
-struct mlx5e_tc_update_priv {
-	struct net_device *tun_dev;
-};
-
 struct mlx5e_tc_mod_hdr_acts {
 	int num_actions;
 	int max_actions;
@@ -174,8 +176,6 @@ void mlx5e_tc_set_ethertype(struct mlx5_core_dev *mdev,
 			    struct flow_match_basic *match, bool outer,
 			    void *headers_c, void *headers_v);
 
-#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-
 int mlx5e_tc_nic_init(struct mlx5e_priv *priv);
 void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv);
 
-- 
2.26.2

