Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF46668964
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 03:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjAMCIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 21:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbjAMCIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 21:08:51 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C57E13DDD
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 18:08:50 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NtPtY3T4dzRrJq;
        Fri, 13 Jan 2023 10:07:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 13 Jan 2023 10:08:45 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <shenjian15@huawei.com>,
        <wangjie125@huawei.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 1/2] net: hns3: add hns3 vf fault detect cap bit support
Date:   Fri, 13 Jan 2023 10:08:28 +0800
Message-ID: <20230113020829.48451-2-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230113020829.48451-1-lanhao@huawei.com>
References: <20230113020829.48451-1-lanhao@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently hns3 driver is designed to support VF fault detect feature in
new hardwares. For code compatibility, vf fault detect cap bit is added to
the driver.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                   | 4 ++++
 .../net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c  | 1 +
 .../net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h  | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c            | 3 +++
 4 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 17137de9338c..cd85c360335d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -98,6 +98,7 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_MC_MAC_MNG_B,
 	HNAE3_DEV_SUPPORT_CQ_B,
 	HNAE3_DEV_SUPPORT_FEC_STATS_B,
+	HNAE3_DEV_SUPPORT_VF_FAULT_B,
 	HNAE3_DEV_SUPPORT_LANE_NUM_B,
 };
 
@@ -164,6 +165,9 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_fec_stats_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_FEC_STATS_B, (ae_dev)->caps)
 
+#define hnae3_ae_dev_vf_fault_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_VF_FAULT_B, (ae_dev)->caps)
+
 #define hnae3_ae_dev_lane_num_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_LANE_NUM_B, (ae_dev)->caps)
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index f671a63cecde..2c2d8c7b4e2a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -155,6 +155,7 @@ static const struct hclge_comm_caps_bit_map hclge_pf_cmd_caps[] = {
 	{HCLGE_COMM_CAP_FD_B, HNAE3_DEV_SUPPORT_FD_B},
 	{HCLGE_COMM_CAP_FEC_STATS_B, HNAE3_DEV_SUPPORT_FEC_STATS_B},
 	{HCLGE_COMM_CAP_LANE_NUM_B, HNAE3_DEV_SUPPORT_LANE_NUM_B},
+	{HCLGE_COMM_CAP_VF_FAULT_B, HNAE3_DEV_SUPPORT_VF_FAULT_B},
 };
 
 static const struct hclge_comm_caps_bit_map hclge_vf_cmd_caps[] = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index b1f9383b418f..ca3692dc2848 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -344,6 +344,7 @@ enum HCLGE_COMM_CAP_BITS {
 	HCLGE_COMM_CAP_GRO_B = 20,
 	HCLGE_COMM_CAP_FD_B = 21,
 	HCLGE_COMM_CAP_FEC_STATS_B = 25,
+	HCLGE_COMM_CAP_VF_FAULT_B = 26,
 	HCLGE_COMM_CAP_LANE_NUM_B = 27,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 66feb23f7b7b..cf86ba96716b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -408,6 +408,9 @@ static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
 	}, {
 		.name = "support lane num",
 		.cap_bit = HNAE3_DEV_SUPPORT_LANE_NUM_B,
+	}, {
+		.name = "support vf fault detect",
+		.cap_bit = HNAE3_DEV_SUPPORT_VF_FAULT_B,
 	}
 };
 
-- 
2.30.0

