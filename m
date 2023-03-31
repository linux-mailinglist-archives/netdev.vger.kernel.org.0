Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE9F6D1429
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCaAgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCaAga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:36:30 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2087.outbound.protection.outlook.com [40.107.102.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC92CCA0F;
        Thu, 30 Mar 2023 17:36:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mM7mI3cgusmXuVQrpnXt1ajTsikfNy+w0HyR0AfzQPDE82uQ5NF1AsaTn81V3AuM4iDF7h+2VHsuvjCc+IFecrqPDJPaRauHFiDuwdgLtC5+B2CtnwpOYEkEw1dt5iakFcQhlYwjxKQSrXcXbgaqVLLxRGb91JgS2wOEf1krR/Rauq8MU5W/wrX/vvvCVzJB/hMXpl0m4vPENimjTKh/j7F7QW+o2wr7wyAXX1RAsPyQx8jr+LSbTfBBroI3mOuPz2dXlB5ukxqls8e9QtkbxylKlJWFBdmu5XLjetnvEZG/b5t8pa9/B1ZzotldHZ/hsFcj0YctAZnAIbkfVFR8BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZon3SMC4qd9pxwDHXGlQy9uskV+FHX7NyDllwEorak=;
 b=mAR9jNDXM/J2dVl8Qd54+4d8a6PZgsoe2gKubckirM8mejbGW2YHm7HkLSzgt1xB0FEPRV4QWcCthZLy5qpoCo6jTxtqNkg+O0h2Ro5SD7aqncgZWdUw3BQZeJ/e7NdoTGGCuzEAplur/66vDZnnLUSs0fUwbBgLaah10BPJ0S6gWX4XyorwIodrgnRYXhHMn259uGNxWPHiBt0bpnICFxgiRImsBjrpQzHrxH4fMcRdh2gNYmK5JbVP/QK5gtoongcJWYsPS6PcHyg7piatAa4Gzz/exhnMkbC3oN5x3pxVYNhpk33rbpJqcraXhoqjcMFzE8zcWqhRqFnSeLPY4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZon3SMC4qd9pxwDHXGlQy9uskV+FHX7NyDllwEorak=;
 b=SSRcFTGWVQS2MTtbM6pet7AybZ8QhSTZTU/pxu+dl/juJY83zg6zg8kuodE2wgwAGY7aETvjI/A6bJ5ntVdSYvbToPM+NMjLN6J21aSqGakSlsktrGndr3lR1Vsurt6Gmr7+Eih0u1MNcFJLFdp0wGSUBl5GKhQ9GTHQu8EtYDQ=
Received: from DM6PR06CA0063.namprd06.prod.outlook.com (2603:10b6:5:54::40) by
 CY8PR12MB7337.namprd12.prod.outlook.com (2603:10b6:930:53::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.22; Fri, 31 Mar 2023 00:36:26 +0000
Received: from DS1PEPF0000E64E.namprd02.prod.outlook.com
 (2603:10b6:5:54:cafe::1a) by DM6PR06CA0063.outlook.office365.com
 (2603:10b6:5:54::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Fri, 31 Mar 2023 00:36:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E64E.mail.protection.outlook.com (10.167.18.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Fri, 31 Mar 2023 00:36:26 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 19:36:25 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: [PATCH v7 vfio 1/7] vfio: Commonize combine_ranges for use in other VFIO drivers
Date:   Thu, 30 Mar 2023 17:36:06 -0700
Message-ID: <20230331003612.17569-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230331003612.17569-1-brett.creeley@amd.com>
References: <20230331003612.17569-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64E:EE_|CY8PR12MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: 5607de59-a159-4d78-b738-08db317ff63b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wSY1r/EU41ZbCs8znJ9SCAlp2y5uAmFc0kkAxdwSHyqKgp1fZBsqzCVxdqdzkvwK1DMTx01kRXrMZZS0HzqKBCEj7yPiEPUdi5b1z842BT2LJkB29tNXe04+neGYrHYTyy8VAwsYqd1ejcKQgMDojKuVSSLvh9GcyGn2cpbKAi+0FupysRAP1DVwX0BiORLxSFJ1dotyjo+PvVzXJ12L/tjFF/EF4hr4iQRi+u5/r6Rhu1/F5A1tuZwW4wTCbvRyR9gj3wpf80qosw0QqwuHE5HAJ8ZWsiVfunUaFQCXVaa76EWf/wBe+YCtE5ucAWwBzXKARFW7Z4ltUhqGp/v547NttdLL7/zqMdlQ4dagJp2HiZ44lEurcveRZ8uBn+3/dqxePicmogKjhTvzrnq7/DkuGKq79CXH7201DFno3fYlypM4A0wgpO1JRkEx0E138cOgnWOj7AUDpkOG2zJ+O5XXm9Od69EfsGecCMaq7l2QjSgRqkMkoXx/sNl2FrQz86aEfGliyiLvODPsGKyvZ3pfbbjgymZCLxcRY9/SPSQjfMsoWXQuFU8X8UQMOJnWA5WGqM6Hr+lplCOsvwFIFiOBpwTjvOt05GyxqKjAzlpaJDW50Hyf45jGtpCJwk2YkS9YlkKp6rCQ8Xce+2uIyQ/vT4eT4MSn3OqZ93PtsB5eBYsebxuhWxS9OWVvVg5UuohHrdwYsfPA68u9SFS5bG6Fz2hngbCdoNKCeCtKw1o=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199021)(40470700004)(46966006)(36840700001)(426003)(47076005)(81166007)(2616005)(36860700001)(6666004)(336012)(83380400001)(16526019)(316002)(26005)(2906002)(54906003)(186003)(478600001)(110136005)(1076003)(4326008)(36756003)(82310400005)(356005)(70206006)(8936002)(86362001)(44832011)(8676002)(82740400003)(41300700001)(40480700001)(5660300002)(70586007)(40460700003)(66899021)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 00:36:26.3992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5607de59-a159-4d78-b738-08db317ff63b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7337
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently only Mellanox uses the combine_ranges function. The
new pds_vfio driver also needs this function. So, move it to
a common location for other vendor drivers to use.

Also, Simon Harmon noticed that RCT ordering was not followed
for vfio_combin_iova_ranges(), so fix that.

Cc: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 48 +------------------------------------
 drivers/vfio/vfio_main.c    | 47 ++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h        |  3 +++
 3 files changed, 51 insertions(+), 47 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index deed156e6165..7f6c51992a15 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -732,52 +732,6 @@ void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf)
 	mlx5vf_cmd_dealloc_pd(migf);
 }
 
-static void combine_ranges(struct rb_root_cached *root, u32 cur_nodes,
-			   u32 req_nodes)
-{
-	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
-	unsigned long min_gap;
-	unsigned long curr_gap;
-
-	/* Special shortcut when a single range is required */
-	if (req_nodes == 1) {
-		unsigned long last;
-
-		curr = comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
-		while (curr) {
-			last = curr->last;
-			prev = curr;
-			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
-			if (prev != comb_start)
-				interval_tree_remove(prev, root);
-		}
-		comb_start->last = last;
-		return;
-	}
-
-	/* Combine ranges which have the smallest gap */
-	while (cur_nodes > req_nodes) {
-		prev = NULL;
-		min_gap = ULONG_MAX;
-		curr = interval_tree_iter_first(root, 0, ULONG_MAX);
-		while (curr) {
-			if (prev) {
-				curr_gap = curr->start - prev->last;
-				if (curr_gap < min_gap) {
-					min_gap = curr_gap;
-					comb_start = prev;
-					comb_end = curr;
-				}
-			}
-			prev = curr;
-			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
-		}
-		comb_start->last = comb_end->last;
-		interval_tree_remove(comb_end, root);
-		cur_nodes--;
-	}
-}
-
 static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
 				 struct mlx5vf_pci_core_device *mvdev,
 				 struct rb_root_cached *ranges, u32 nnodes)
@@ -800,7 +754,7 @@ static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
 	int i;
 
 	if (num_ranges > max_num_range) {
-		combine_ranges(ranges, nnodes, max_num_range);
+		vfio_combine_iova_ranges(ranges, nnodes, max_num_range);
 		num_ranges = max_num_range;
 	}
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 43bd6b76e2b6..ad8a3f948f05 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -864,6 +864,53 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 	return 0;
 }
 
+void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
+			      u32 req_nodes)
+{
+	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
+	unsigned long min_gap, curr_gap;
+
+	/* Special shortcut when a single range is required */
+	if (req_nodes == 1) {
+		unsigned long last;
+
+		comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
+		curr = comb_start;
+		while (curr) {
+			last = curr->last;
+			prev = curr;
+			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
+			if (prev != comb_start)
+				interval_tree_remove(prev, root);
+		}
+		comb_start->last = last;
+		return;
+	}
+
+	/* Combine ranges which have the smallest gap */
+	while (cur_nodes > req_nodes) {
+		prev = NULL;
+		min_gap = ULONG_MAX;
+		curr = interval_tree_iter_first(root, 0, ULONG_MAX);
+		while (curr) {
+			if (prev) {
+				curr_gap = curr->start - prev->last;
+				if (curr_gap < min_gap) {
+					min_gap = curr_gap;
+					comb_start = prev;
+					comb_end = curr;
+				}
+			}
+			prev = curr;
+			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
+		}
+		comb_start->last = comb_end->last;
+		interval_tree_remove(comb_end, root);
+		cur_nodes--;
+	}
+}
+EXPORT_SYMBOL_GPL(vfio_combine_iova_ranges);
+
 /* Ranges should fit into a single kernel page */
 #define LOG_MAX_RANGES \
 	(PAGE_SIZE / sizeof(struct vfio_device_feature_dma_logging_range))
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 93134b023968..10db5aa3e985 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -241,6 +241,9 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 			    enum vfio_device_mig_state new_fsm,
 			    enum vfio_device_mig_state *next_fsm);
 
+void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
+			      u32 req_nodes);
+
 /*
  * External user API
  */
-- 
2.17.1

