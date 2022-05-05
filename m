Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D4B51BFD7
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377697AbiEEMyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358784AbiEEMyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:54:10 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CF843EE9;
        Thu,  5 May 2022 05:50:30 -0700 (PDT)
Received: from kwepemi500005.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KvD6X1MQHz1JBnP;
        Thu,  5 May 2022 20:49:24 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500005.china.huawei.com (7.221.188.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 20:50:28 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 20:50:28 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 2/5] net: hns3: remove the affinity settings of vector0
Date:   Thu, 5 May 2022 20:44:41 +0800
Message-ID: <20220505124444.2233-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220505124444.2233-1-huangguangbin2@huawei.com>
References: <20220505124444.2233-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Vector0 is used for common interrupt control events and is
irrelevant to performance. Currently, the driver sets the
default affinity of vector0 to NUMA nodes, which is unnecessary.
Therefore, the default setting is removed, and the driver does
not set the affinity for vector0.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 27 +------------------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  2 --
 2 files changed, 1 insertion(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a5dd2c8c244a..1ebad0e50e6a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1546,9 +1546,8 @@ static void hclge_init_tc_config(struct hclge_dev *hdev)
 static int hclge_configure(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-	const struct cpumask *cpumask = cpu_online_mask;
 	struct hclge_cfg cfg;
-	int node, ret;
+	int ret;
 
 	ret = hclge_get_cfg(hdev, &cfg);
 	if (ret)
@@ -1594,13 +1593,6 @@ static int hclge_configure(struct hclge_dev *hdev)
 	hclge_init_tc_config(hdev);
 	hclge_init_kdump_kernel_config(hdev);
 
-	/* Set the affinity based on numa node */
-	node = dev_to_node(&hdev->pdev->dev);
-	if (node != NUMA_NO_NODE)
-		cpumask = cpumask_of_node(node);
-
-	cpumask_copy(&hdev->affinity_mask, cpumask);
-
 	return ret;
 }
 
@@ -3564,17 +3556,6 @@ static void hclge_get_misc_vector(struct hclge_dev *hdev)
 	hdev->num_msi_used += 1;
 }
 
-static void hclge_misc_affinity_setup(struct hclge_dev *hdev)
-{
-	irq_set_affinity_hint(hdev->misc_vector.vector_irq,
-			      &hdev->affinity_mask);
-}
-
-static void hclge_misc_affinity_teardown(struct hclge_dev *hdev)
-{
-	irq_set_affinity_hint(hdev->misc_vector.vector_irq, NULL);
-}
-
 static int hclge_misc_irq_init(struct hclge_dev *hdev)
 {
 	int ret;
@@ -11457,11 +11438,6 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	timer_setup(&hdev->reset_timer, hclge_reset_timer, 0);
 	INIT_DELAYED_WORK(&hdev->service_task, hclge_service_task);
 
-	/* Setup affinity after service timer setup because add_timer_on
-	 * is called in affinity notify.
-	 */
-	hclge_misc_affinity_setup(hdev);
-
 	hclge_clear_all_event_cause(hdev);
 	hclge_clear_resetting_state(hdev);
 
@@ -11879,7 +11855,6 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	hclge_reset_vf_rate(hdev);
 	hclge_clear_vf_vlan(hdev);
-	hclge_misc_affinity_teardown(hdev);
 	hclge_state_uninit(hdev);
 	hclge_ptp_uninit(hdev);
 	hclge_uninit_rxd_adv_layout(hdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index c70239758bb2..ab5c37848a7b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -938,8 +938,6 @@ struct hclge_dev {
 	DECLARE_KFIFO(mac_tnl_log, struct hclge_mac_tnl_stats,
 		      HCLGE_MAC_TNL_LOG_SIZE);
 
-	/* affinity mask and notify for misc interrupt */
-	cpumask_t affinity_mask;
 	struct hclge_ptp *ptp;
 	struct devlink *devlink;
 	struct hclge_comm_rss_cfg rss_cfg;
-- 
2.33.0

