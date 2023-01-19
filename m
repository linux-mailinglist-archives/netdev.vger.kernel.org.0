Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EFC67431D
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjASTvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjASTvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:51:46 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6E675A0C;
        Thu, 19 Jan 2023 11:51:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/ISnrUf9kmOe8e9Ze1leWKURvmDX/SznvR3e9lWUbLktK5aPKQ9OgKhI5SNlty6m3/h6B3TL8GRHnYEk/TL9E362L64ty6YVCEd6a/9fVjTSy7AJ6AXvOT7rlRMSCe4vRtbUL9f78U2h/MX6+xSNEoC0PBSpMycHwiG8iRzQzWIks2M6HI8GqU44U9MWsjOKtVSjSBkzz4fCxvneN3d9GlC1uJtpCjLXtkAv1C3enkkKWdPymG5hzibGYdwGOSmXQXNXg+yw9jkK5rHtfsx4bT8+fnmvp9KixwYbgYqSA8kcxeimy23MnbQDuyG7diwO4mws8EUjfsRYoHEd0ajlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfyRg1E6R2JJ5PosP1qE7Ygly7/uRo9xWvo8eA8oduM=;
 b=jjHaDsVwKPEea7omjMZclkuvOXvVXkWUI0TGip1BSSIBRQwA90K2vvpVMsVNCEhIUBfkBLtW2ZrGSvn/u+T78INnzXvkl3W77XGai96as4Oe8ei2SQlJafz+GRjUT+8+LG64IOyqQMj/Kyp3ugHRh65TjOoZlatBQBFZC905lI5guAIe2VuAdPGtrheWTGoUAuXOVok9ilOydmzsoB8917GdDAMOotX0vj224zceD7Jv/dIZ4u9zSwTt+Agu9Pxe96aTAznTaY4OexQGlmX1mmj1UdOuUkO0bEnBVnJ0g789sNquoJiODVATTT0voK09FfXAIxJJFEovbx6xjlE4Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfyRg1E6R2JJ5PosP1qE7Ygly7/uRo9xWvo8eA8oduM=;
 b=kmxllsvxNuq5M5veOiXvZjHraQoAXHde/+7eHoopsUAo/F2gn0rZhcLiGK1c8u8MlmFQXiKZEHT/z8vm7pHmqTNK732rbmy4AZ1RBKd143WWy31d1/OmYuDhxvGJ8krKST3NpowyMdlVPyrQu/Hu5TOJbYRGKWIFhttlHdNuhAg8Lj+WPqE5+Az2Ynh3A+yogWaJC2yGrm35deMlGYNOm2tJr5c08vIvuWVBCuVFS7ToelJN0WfIqssfkYC/LrxCauoyGRPTre9grK8eZckNpXCh2RXx7Ibwav0sDRozHpIuV2umghN7FAARz3ijo5h/X/pMNg3K8b+WsWDfcygFNw==
Received: from BN8PR04CA0043.namprd04.prod.outlook.com (2603:10b6:408:d4::17)
 by SN7PR12MB6888.namprd12.prod.outlook.com (2603:10b6:806:260::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 19:51:43 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::8) by BN8PR04CA0043.outlook.office365.com
 (2603:10b6:408:d4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24 via Frontend
 Transport; Thu, 19 Jan 2023 19:51:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24 via Frontend Transport; Thu, 19 Jan 2023 19:51:42 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:27 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:26 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 19 Jan
 2023 11:51:23 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 1/7] net: flow_offload: provision conntrack info in ct_metadata
Date:   Thu, 19 Jan 2023 20:50:58 +0100
Message-ID: <20230119195104.3371966-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119195104.3371966-1-vladbu@nvidia.com>
References: <20230119195104.3371966-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT004:EE_|SN7PR12MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eb855c6-0ef5-45f4-b11c-08dafa5696d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bQajP8LKuzOOOzdwlwLWjRdAbltOKpnoPMOCeYfIg9cj97BUuzhDvccXM3cMr60jH1PMdBiIP5A67IMZOX4lypnKnFh+aCxs2fScF+PXDwnavXoNbQNzUWIaSWCZ23xFFP1INOSKwf6SipFNyqM89gwoiTQXIdbi155Wt9fGu2cRiBIVs27JTK7m7w2Z1mselptogXQ+zarfA2cMbRVrgcBRoRCvdiUYPRdFXEsZ4D7xN4aYLoETq36guqs1d6sB4rmbU16SFIzpKu3u+bzQIh6e1I69fcvyfXlSUYK6+OJwqkOr6fVERnRfCCWRxIEIIb/+Gk1A/d6xyaS9uGOYw3rKjA9HXbwxcXd/SUup1QkTjzX9YueNfiTO5xslFiXlQYwLX9g8bk3zjLDuuL0H1MmpozrdNBOCOalp+vQjiVvPqyiBr/08L163dVB/nHttghTMWUkmnnZL0GoADT2vdHlr2OzM110sMt0eTPeY4GjINYYMWZH5pbeTTjGZYmKw3D6s1QLMpdR+L2tSirkP7Atr2vlK/b8ykkh84zG6dd+EQWsVzhEXfWljITccCBbIv5YN+GeS0SR1BlztgBwVa+kMr/myUnJ0/rJ8uAGDoD5Yyakb5Kc8aYyTDda/ZbAxWylnLPUQGsXFJkkawJV7vEb56M5VaceqGLJ5PLuUmEKNAJwdIlOlqERLhxBk/icOp7aeLr8tC6IFnpEJinNZdRKyePJDF7AvW/nSUSaknEw=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199015)(46966006)(36840700001)(40470700004)(47076005)(82740400003)(83380400001)(36860700001)(86362001)(426003)(7636003)(5660300002)(356005)(82310400005)(8936002)(7416002)(2906002)(41300700001)(4326008)(1076003)(2616005)(40460700003)(6666004)(107886003)(336012)(186003)(316002)(478600001)(26005)(54906003)(110136005)(70586007)(70206006)(7696005)(40480700001)(8676002)(36756003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 19:51:42.9099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb855c6-0ef5-45f4-b11c-08dafa5696d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6888
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to offload connections in other states besides "established" the
driver offload callbacks need to have access to connection conntrack info.
Flow offload intermediate representation data structure already contains
that data encoded in 'cookie' field, so just reuse it in the drivers.

Reject offloading IP_CT_NEW connections for now by returning an error in
relevant driver callbacks based on value of ctinfo. Support for offloading
such connections will need to be added to the drivers afterwards.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V2 -> V3:
    
    - Reuse existing meta action 'cookie' field to obtain ctinfo instead of
    introducing a new field as suggested by Marcelo.
    
    Changes V1 -> V2:
    
    - Add missing include that caused compilation errors on certain configs.
    
    - Change naming in nfp driver as suggested by Simon and Baowen.

 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  4 +++-
 .../ethernet/netronome/nfp/flower/conntrack.c | 24 +++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 313df8232db7..6774e441f490 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1073,11 +1073,13 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
 	struct flow_action_entry *meta_action;
 	unsigned long cookie = flow->cookie;
+	enum ip_conntrack_info ctinfo;
 	struct mlx5_ct_entry *entry;
 	int err;
 
 	meta_action = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
-	if (!meta_action)
+	ctinfo = meta_action->ct_metadata.cookie & NFCT_INFOMASK;
+	if (!meta_action || ctinfo == IP_CT_NEW)
 		return -EOPNOTSUPP;
 
 	spin_lock_bh(&ct_priv->ht_lock);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index f693119541d5..d23830b5bcb8 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1964,6 +1964,27 @@ int nfp_fl_ct_stats(struct flow_cls_offload *flow,
 	return 0;
 }
 
+static bool
+nfp_fl_ct_offload_nft_supported(struct flow_cls_offload *flow)
+{
+	struct flow_rule *flow_rule = flow->rule;
+	struct flow_action *flow_action =
+		&flow_rule->action;
+	struct flow_action_entry *act;
+	int i;
+
+	flow_action_for_each(i, act, flow_action) {
+		if (act->id == FLOW_ACTION_CT_METADATA) {
+			enum ip_conntrack_info ctinfo =
+				act->ct_metadata.cookie & NFCT_INFOMASK;
+
+			return ctinfo != IP_CT_NEW;
+		}
+	}
+
+	return false;
+}
+
 static int
 nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offload *flow)
 {
@@ -1976,6 +1997,9 @@ nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offl
 	extack = flow->common.extack;
 	switch (flow->command) {
 	case FLOW_CLS_REPLACE:
+		if (!nfp_fl_ct_offload_nft_supported(flow))
+			return -EOPNOTSUPP;
+
 		/* Netfilter can request offload multiple times for the same
 		 * flow - protect against adding duplicates.
 		 */
-- 
2.38.1

