Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60A42D51C3
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730948AbgLJDnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:43:47 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9421 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730784AbgLJDna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:43:30 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cs08x4cFhz7C9w;
        Thu, 10 Dec 2020 11:42:09 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 11:42:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <huangdaode@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/7] net: hns3: add support for tc mqprio offload
Date:   Thu, 10 Dec 2020 11:42:07 +0800
Message-ID: <1607571732-24219-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, the HNS3 driver only supports offload for tc number
and prio_tc. This patch adds support for other qopts, including
queues count and offset for each tc.

When enable tc mqprio offload, it's not allowed to change
queue numbers by ethtool. For hardware limitation, the queue
number of each tc should be power of 2.

For the queues is not assigned to each tc by average, so it's
should return vport->alloc_tqps for hclge_get_max_channels().

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   6 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  13 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 126 +++++++++++++++++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  80 +++++++------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  48 +++++++-
 5 files changed, 220 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 0cb80ef..a7ff9c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -29,7 +29,9 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
+#include <linux/pkt_sched.h>
 #include <linux/types.h>
+#include <net/pkt_cls.h>
 
 #define HNAE3_MOD_VERSION "1.0"
 
@@ -647,7 +649,8 @@ struct hnae3_dcb_ops {
 	u8   (*getdcbx)(struct hnae3_handle *);
 	u8   (*setdcbx)(struct hnae3_handle *, u8);
 
-	int (*setup_tc)(struct hnae3_handle *, u8, u8 *);
+	int (*setup_tc)(struct hnae3_handle *handle,
+			struct tc_mqprio_qopt_offload *mqprio_qopt);
 };
 
 struct hnae3_ae_algo {
@@ -667,6 +670,7 @@ struct hnae3_tc_info {
 	u16 tqp_offset[HNAE3_MAX_TC];
 	unsigned long tc_en; /* bitmap of TC enabled */
 	u8 num_tc; /* Total number of enabled TCs */
+	bool mqprio_active;
 };
 
 struct hnae3_knic_private_info {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 36e74ad..d6dd4bc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -324,10 +324,10 @@ static int hns3_nic_set_real_num_queue(struct net_device *netdev)
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct hnae3_knic_private_info *kinfo = &h->kinfo;
 	struct hnae3_tc_info *tc_info = &kinfo->tc_info;
-	unsigned int queue_size = kinfo->rss_size * tc_info->num_tc;
+	unsigned int queue_size = kinfo->num_tqps;
 	int i, ret;
 
-	if (tc_info->num_tc <= 1) {
+	if (tc_info->num_tc <= 1 && !tc_info->mqprio_active) {
 		netdev_reset_tc(netdev);
 	} else {
 		ret = netdev_set_num_tc(netdev, tc_info->num_tc);
@@ -1793,7 +1793,6 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 static int hns3_setup_tc(struct net_device *netdev, void *type_data)
 {
 	struct tc_mqprio_qopt_offload *mqprio_qopt = type_data;
-	u8 *prio_tc = mqprio_qopt->qopt.prio_tc_map;
 	struct hnae3_knic_private_info *kinfo;
 	u8 tc = mqprio_qopt->qopt.num_tc;
 	u16 mode = mqprio_qopt->mode;
@@ -1816,7 +1815,7 @@ static int hns3_setup_tc(struct net_device *netdev, void *type_data)
 	netif_dbg(h, drv, netdev, "setup tc: num_tc=%u\n", tc);
 
 	return (kinfo->dcb_ops && kinfo->dcb_ops->setup_tc) ?
-		kinfo->dcb_ops->setup_tc(h, tc ? tc : 1, prio_tc) : -EOPNOTSUPP;
+		kinfo->dcb_ops->setup_tc(h, mqprio_qopt) : -EOPNOTSUPP;
 }
 
 static int hns3_nic_setup_tc(struct net_device *dev, enum tc_setup_type type,
@@ -4691,6 +4690,12 @@ int hns3_set_channels(struct net_device *netdev,
 	if (ch->rx_count || ch->tx_count)
 		return -EINVAL;
 
+	if (kinfo->tc_info.mqprio_active) {
+		dev_err(&netdev->dev,
+			"it's not allowed to set channels via ethtool when MQPRIO mode is on\n");
+		return -EINVAL;
+	}
+
 	if (new_tqp_num > hns3_get_max_available_channels(h) ||
 	    new_tqp_num < 1) {
 		dev_err(&netdev->dev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index f990f69..a7f4c6a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -397,32 +397,130 @@ static u8 hclge_setdcbx(struct hnae3_handle *h, u8 mode)
 	return 0;
 }
 
+static int hclge_mqprio_qopt_check(struct hclge_dev *hdev,
+				   struct tc_mqprio_qopt_offload *mqprio_qopt)
+{
+	u16 queue_sum = 0;
+	int ret;
+	int i;
+
+	if (!mqprio_qopt->qopt.num_tc) {
+		mqprio_qopt->qopt.num_tc = 1;
+		return 0;
+	}
+
+	ret = hclge_dcb_common_validate(hdev, mqprio_qopt->qopt.num_tc,
+					mqprio_qopt->qopt.prio_tc_map);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < mqprio_qopt->qopt.num_tc; i++) {
+		if (!is_power_of_2(mqprio_qopt->qopt.count[i])) {
+			dev_err(&hdev->pdev->dev,
+				"qopt queue count must be power of 2\n");
+			return -EINVAL;
+		}
+
+		if (mqprio_qopt->qopt.count[i] > hdev->rss_size_max) {
+			dev_err(&hdev->pdev->dev,
+				"qopt queue count should be no more than %u\n",
+				hdev->rss_size_max);
+			return -EINVAL;
+		}
+
+		if (mqprio_qopt->qopt.offset[i] != queue_sum) {
+			dev_err(&hdev->pdev->dev,
+				"qopt queue offset must start from 0, and being continuous\n");
+			return -EINVAL;
+		}
+
+		if (mqprio_qopt->min_rate[i] || mqprio_qopt->max_rate[i]) {
+			dev_err(&hdev->pdev->dev,
+				"qopt tx_rate is not supported\n");
+			return -EOPNOTSUPP;
+		}
+
+		queue_sum = mqprio_qopt->qopt.offset[i];
+		queue_sum += mqprio_qopt->qopt.count[i];
+	}
+	if (hdev->vport[0].alloc_tqps < queue_sum) {
+		dev_err(&hdev->pdev->dev,
+			"qopt queue count sum should be less than %u\n",
+			hdev->vport[0].alloc_tqps);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void hclge_sync_mqprio_qopt(struct hnae3_tc_info *tc_info,
+				   struct tc_mqprio_qopt_offload *mqprio_qopt)
+{
+	int i;
+
+	memset(tc_info, 0, sizeof(*tc_info));
+	tc_info->num_tc = mqprio_qopt->qopt.num_tc;
+	memcpy(tc_info->prio_tc, mqprio_qopt->qopt.prio_tc_map,
+	       sizeof_field(struct hnae3_tc_info, prio_tc));
+	memcpy(tc_info->tqp_count, mqprio_qopt->qopt.count,
+	       sizeof_field(struct hnae3_tc_info, tqp_count));
+	memcpy(tc_info->tqp_offset, mqprio_qopt->qopt.offset,
+	       sizeof_field(struct hnae3_tc_info, tqp_offset));
+
+	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++)
+		set_bit(tc_info->prio_tc[i], &tc_info->tc_en);
+}
+
+static int hclge_config_tc(struct hclge_dev *hdev,
+			   struct hnae3_tc_info *tc_info)
+{
+	int i;
+
+	hclge_tm_schd_info_update(hdev, tc_info->num_tc);
+	for (i = 0; i < HNAE3_MAX_USER_PRIO; i++)
+		hdev->tm_info.prio_tc[i] = tc_info->prio_tc[i];
+
+	return hclge_map_update(hdev);
+}
+
 /* Set up TC for hardware offloaded mqprio in channel mode */
-static int hclge_setup_tc(struct hnae3_handle *h, u8 tc, u8 *prio_tc)
+static int hclge_setup_tc(struct hnae3_handle *h,
+			  struct tc_mqprio_qopt_offload *mqprio_qopt)
 {
 	struct hclge_vport *vport = hclge_get_vport(h);
+	struct hnae3_knic_private_info *kinfo;
 	struct hclge_dev *hdev = vport->back;
+	struct hnae3_tc_info old_tc_info;
+	u8 tc = mqprio_qopt->qopt.num_tc;
 	int ret;
 
+	/* if client unregistered, it's not allowed to change
+	 * mqprio configuration, which may cause uninit ring
+	 * fail.
+	 */
+	if (!test_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state))
+		return -EBUSY;
+
 	if (hdev->flag & HCLGE_FLAG_DCB_ENABLE)
 		return -EINVAL;
 
-	ret = hclge_dcb_common_validate(hdev, tc, prio_tc);
-	if (ret)
-		return -EINVAL;
+	ret = hclge_mqprio_qopt_check(hdev, mqprio_qopt);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to check mqprio qopt params, ret = %d\n", ret);
+		return ret;
+	}
 
 	ret = hclge_notify_down_uinit(hdev);
 	if (ret)
 		return ret;
 
-	hclge_tm_schd_info_update(hdev, tc);
-	hclge_tm_prio_tc_info_update(hdev, prio_tc);
-
-	ret = hclge_tm_init_hw(hdev, false);
-	if (ret)
-		goto err_out;
+	kinfo = &vport->nic.kinfo;
+	memcpy(&old_tc_info, &kinfo->tc_info, sizeof(old_tc_info));
+	hclge_sync_mqprio_qopt(&kinfo->tc_info, mqprio_qopt);
+	kinfo->tc_info.mqprio_active = tc > 0;
 
-	ret = hclge_client_setup_tc(hdev);
+	ret = hclge_config_tc(hdev, &kinfo->tc_info);
 	if (ret)
 		goto err_out;
 
@@ -436,6 +534,12 @@ static int hclge_setup_tc(struct hnae3_handle *h, u8 tc, u8 *prio_tc)
 	return hclge_notify_init_up(hdev);
 
 err_out:
+	/* roll-back */
+	memcpy(&kinfo->tc_info, &old_tc_info, sizeof(old_tc_info));
+	if (hclge_config_tc(hdev, &kinfo->tc_info))
+		dev_err(&hdev->pdev->dev,
+			"failed to roll back tc configuration\n");
+
 	hclge_notify_init_up(hdev);
 
 	return ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 8bf1027..366920b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4604,18 +4604,55 @@ static int hclge_get_tc_size(struct hnae3_handle *handle)
 	return hdev->rss_size_max;
 }
 
-int hclge_rss_init_hw(struct hclge_dev *hdev)
+static int hclge_init_rss_tc_mode(struct hclge_dev *hdev)
 {
+	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
 	struct hclge_vport *vport = hdev->vport;
-	u8 *rss_indir = vport[0].rss_indirection_tbl;
-	u16 rss_size = vport[0].alloc_rss_size;
 	u16 tc_offset[HCLGE_MAX_TC_NUM] = {0};
+	u16 tc_valid[HCLGE_MAX_TC_NUM] = {0};
 	u16 tc_size[HCLGE_MAX_TC_NUM] = {0};
+	struct hnae3_tc_info *tc_info;
+	u16 roundup_size;
+	u16 rss_size;
+	int i;
+
+	tc_info = &vport->nic.kinfo.tc_info;
+	for (i = 0; i < HCLGE_MAX_TC_NUM; i++) {
+		rss_size = tc_info->tqp_count[i];
+		tc_valid[i] = 0;
+
+		if (!(hdev->hw_tc_map & BIT(i)))
+			continue;
+
+		/* tc_size set to hardware is the log2 of roundup power of two
+		 * of rss_size, the acutal queue size is limited by indirection
+		 * table.
+		 */
+		if (rss_size > ae_dev->dev_specs.rss_ind_tbl_size ||
+		    rss_size == 0) {
+			dev_err(&hdev->pdev->dev,
+				"Configure rss tc size failed, invalid TC_SIZE = %u\n",
+				rss_size);
+			return -EINVAL;
+		}
+
+		roundup_size = roundup_pow_of_two(rss_size);
+		roundup_size = ilog2(roundup_size);
+
+		tc_valid[i] = 1;
+		tc_size[i] = roundup_size;
+		tc_offset[i] = tc_info->tqp_offset[i];
+	}
+
+	return hclge_set_rss_tc_mode(hdev, tc_valid, tc_size, tc_offset);
+}
+
+int hclge_rss_init_hw(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport = hdev->vport;
+	u8 *rss_indir = vport[0].rss_indirection_tbl;
 	u8 *key = vport[0].rss_hash_key;
 	u8 hfunc = vport[0].rss_algo;
-	u16 tc_valid[HCLGE_MAX_TC_NUM];
-	u16 roundup_size;
-	unsigned int i;
 	int ret;
 
 	ret = hclge_set_rss_indir_table(hdev, rss_indir);
@@ -4630,32 +4667,7 @@ int hclge_rss_init_hw(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
-	/* Each TC have the same queue size, and tc_size set to hardware is
-	 * the log2 of roundup power of two of rss_size, the acutal queue
-	 * size is limited by indirection table.
-	 */
-	if (rss_size > HCLGE_RSS_TC_SIZE_7 || rss_size == 0) {
-		dev_err(&hdev->pdev->dev,
-			"Configure rss tc size failed, invalid TC_SIZE = %u\n",
-			rss_size);
-		return -EINVAL;
-	}
-
-	roundup_size = roundup_pow_of_two(rss_size);
-	roundup_size = ilog2(roundup_size);
-
-	for (i = 0; i < HCLGE_MAX_TC_NUM; i++) {
-		tc_valid[i] = 0;
-
-		if (!(hdev->hw_tc_map & BIT(i)))
-			continue;
-
-		tc_valid[i] = 1;
-		tc_size[i] = roundup_size;
-		tc_offset[i] = rss_size * i;
-	}
-
-	return hclge_set_rss_tc_mode(hdev, tc_valid, tc_size, tc_offset);
+	return hclge_init_rss_tc_mode(hdev);
 }
 
 void hclge_rss_indir_init_cfg(struct hclge_dev *hdev)
@@ -10694,12 +10706,10 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 static u32 hclge_get_max_channels(struct hnae3_handle *handle)
 {
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	return min_t(u32, hdev->rss_size_max,
-		     vport->alloc_tqps / kinfo->tc_info.num_tc);
+	return min_t(u32, hdev->rss_size_max, vport->alloc_tqps);
 }
 
 static void hclge_get_channels(struct hnae3_handle *handle,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index dd2b100..c3dcf94 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -589,6 +589,46 @@ int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate)
 	return 0;
 }
 
+static u16 hclge_vport_get_max_rss_size(struct hclge_vport *vport)
+{
+	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
+	struct hnae3_tc_info *tc_info = &kinfo->tc_info;
+	struct hclge_dev *hdev = vport->back;
+	u16 max_rss_size = 0;
+	int i;
+
+	if (!tc_info->mqprio_active)
+		return vport->alloc_tqps / tc_info->num_tc;
+
+	for (i = 0; i < HNAE3_MAX_TC; i++) {
+		if (!(hdev->hw_tc_map & BIT(i)) || i >= tc_info->num_tc)
+			continue;
+		if (max_rss_size < tc_info->tqp_count[i])
+			max_rss_size = tc_info->tqp_count[i];
+	}
+
+	return max_rss_size;
+}
+
+static u16 hclge_vport_get_tqp_num(struct hclge_vport *vport)
+{
+	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
+	struct hnae3_tc_info *tc_info = &kinfo->tc_info;
+	struct hclge_dev *hdev = vport->back;
+	int sum = 0;
+	int i;
+
+	if (!tc_info->mqprio_active)
+		return kinfo->rss_size * tc_info->num_tc;
+
+	for (i = 0; i < HNAE3_MAX_TC; i++) {
+		if (hdev->hw_tc_map & BIT(i) && i < tc_info->num_tc)
+			sum += tc_info->tqp_count[i];
+	}
+
+	return sum;
+}
+
 static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 {
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
@@ -605,7 +645,7 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 				(vport->vport_id ? (vport->vport_id - 1) : 0);
 
 	max_rss_size = min_t(u16, hdev->rss_size_max,
-			     vport->alloc_tqps / kinfo->tc_info.num_tc);
+			     hclge_vport_get_max_rss_size(vport));
 
 	/* Set to user value, no larger than max_rss_size. */
 	if (kinfo->req_rss_size != kinfo->rss_size && kinfo->req_rss_size &&
@@ -628,11 +668,15 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 		kinfo->rss_size = max_rss_size;
 	}
 
-	kinfo->num_tqps = kinfo->tc_info.num_tc * kinfo->rss_size;
+	kinfo->num_tqps = hclge_vport_get_tqp_num(vport);
 	vport->dwrr = 100;  /* 100 percent as init */
 	vport->alloc_rss_size = kinfo->rss_size;
 	vport->bw_limit = hdev->tm_info.pg_info[0].bw_limit;
 
+	/* when enable mqprio, the tc_info has been updated. */
+	if (kinfo->tc_info.mqprio_active)
+		return;
+
 	for (i = 0; i < HNAE3_MAX_TC; i++) {
 		if (hdev->hw_tc_map & BIT(i) && i < kinfo->tc_info.num_tc) {
 			set_bit(i, &kinfo->tc_info.tc_en);
-- 
2.7.4

