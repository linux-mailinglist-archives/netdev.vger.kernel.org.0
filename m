Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EAE2D51CE
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbgLJDoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:44:37 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9424 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730952AbgLJDoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:44:15 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cs08x6JlCz7CBG;
        Thu, 10 Dec 2020 11:42:09 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 11:42:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <huangdaode@huawei.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/7] net: hns3: add support for max 512 rss size
Date:   Thu, 10 Dec 2020 11:42:10 +0800
Message-ID: <1607571732-24219-6-git-send-email-tanhuazhong@huawei.com>
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

From: Guojia Liao <liaoguojia@huawei.com>

Currently, the driver gets the max rss size from configuration
file when initialization. Both the PF and VF share the same
max rss size, and no more than 128.

For DEVICE_VERSION_V3, the max rss size for PF can be up to
512, so there is a new field in configuration file to store it,
the old filed is used for VF.

To be compatible with boards using old configure file, the PF
will use the old filed if the one is zero.

For the rss size may be larger than 256, so the type of
rss_indirection_tbl of struct hclge_vport should be changed to
u16 as well.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  2 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  4 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 36 ++++++++++++++++------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  8 +++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  5 ++-
 5 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index df5417d..f5a620c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -518,6 +518,8 @@ struct hclge_pf_res_cmd {
 #define HCLGE_CFG_SPEED_ABILITY_EXT_M	GENMASK(15, 10)
 #define HCLGE_CFG_UMV_TBL_SPACE_S	16
 #define HCLGE_CFG_UMV_TBL_SPACE_M	GENMASK(31, 16)
+#define HCLGE_CFG_PF_RSS_SIZE_S		0
+#define HCLGE_CFG_PF_RSS_SIZE_M		GENMASK(3, 0)
 
 #define HCLGE_CFG_CMD_CNT		4
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index a7f4c6a..e08d11b8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -421,10 +421,10 @@ static int hclge_mqprio_qopt_check(struct hclge_dev *hdev,
 			return -EINVAL;
 		}
 
-		if (mqprio_qopt->qopt.count[i] > hdev->rss_size_max) {
+		if (mqprio_qopt->qopt.count[i] > hdev->pf_rss_size_max) {
 			dev_err(&hdev->pdev->dev,
 				"qopt queue count should be no more than %u\n",
-				hdev->rss_size_max);
+				hdev->pf_rss_size_max);
 			return -EINVAL;
 		}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 455ee6c..f361226 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1285,9 +1285,9 @@ static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 	cfg->default_speed = hnae3_get_field(__le32_to_cpu(req->param[3]),
 					     HCLGE_CFG_DEFAULT_SPEED_M,
 					     HCLGE_CFG_DEFAULT_SPEED_S);
-	cfg->rss_size_max = hnae3_get_field(__le32_to_cpu(req->param[3]),
-					    HCLGE_CFG_RSS_SIZE_M,
-					    HCLGE_CFG_RSS_SIZE_S);
+	cfg->vf_rss_size_max = hnae3_get_field(__le32_to_cpu(req->param[3]),
+					       HCLGE_CFG_RSS_SIZE_M,
+					       HCLGE_CFG_RSS_SIZE_S);
 
 	for (i = 0; i < ETH_ALEN; i++)
 		cfg->mac_addr[i] = (mac_addr_tmp >> (8 * i)) & 0xff;
@@ -1308,6 +1308,21 @@ static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 					 HCLGE_CFG_UMV_TBL_SPACE_S);
 	if (!cfg->umv_space)
 		cfg->umv_space = HCLGE_DEFAULT_UMV_SPACE_PER_PF;
+
+	cfg->pf_rss_size_max = hnae3_get_field(__le32_to_cpu(req->param[2]),
+					       HCLGE_CFG_PF_RSS_SIZE_M,
+					       HCLGE_CFG_PF_RSS_SIZE_S);
+
+	/* HCLGE_CFG_PF_RSS_SIZE_M is the PF max rss size, which is a
+	 * power of 2, instead of reading out directly. This would
+	 * be more flexible for future changes and expansions.
+	 * When VF max  rss size field is HCLGE_CFG_RSS_SIZE_S,
+	 * it does not make sense if PF's field is 0. In this case, PF and VF
+	 * has the same max rss size filed: HCLGE_CFG_RSS_SIZE_S.
+	 */
+	cfg->pf_rss_size_max = cfg->pf_rss_size_max ?
+			       1U << cfg->pf_rss_size_max :
+			       cfg->vf_rss_size_max;
 }
 
 /* hclge_get_cfg: query the static parameter from flash
@@ -1469,7 +1484,8 @@ static int hclge_configure(struct hclge_dev *hdev)
 
 	hdev->num_vmdq_vport = cfg.vmdq_vport_num;
 	hdev->base_tqp_pid = 0;
-	hdev->rss_size_max = cfg.rss_size_max;
+	hdev->vf_rss_size_max = cfg.vf_rss_size_max;
+	hdev->pf_rss_size_max = cfg.pf_rss_size_max;
 	hdev->rx_buf_len = cfg.rx_buf_len;
 	ether_addr_copy(hdev->hw.mac.mac_addr, cfg.mac_addr);
 	hdev->hw.mac.media_type = cfg.media_type;
@@ -1652,7 +1668,7 @@ static int  hclge_assign_tqp(struct hclge_vport *vport, u16 num_tqps)
 		}
 	}
 	vport->alloc_tqps = alloced;
-	kinfo->rss_size = min_t(u16, hdev->rss_size_max,
+	kinfo->rss_size = min_t(u16, hdev->pf_rss_size_max,
 				vport->alloc_tqps / hdev->tm_info.num_tc);
 
 	/* ensure one to one mapping between irq and queue at default */
@@ -4262,7 +4278,7 @@ static int hclge_set_rss_algo_key(struct hclge_dev *hdev,
 	return 0;
 }
 
-static int hclge_set_rss_indir_table(struct hclge_dev *hdev, const u8 *indir)
+static int hclge_set_rss_indir_table(struct hclge_dev *hdev, const u16 *indir)
 {
 	struct hclge_rss_indirection_table_cmd *req;
 	struct hclge_desc desc;
@@ -4601,7 +4617,7 @@ static int hclge_get_tc_size(struct hnae3_handle *handle)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	return hdev->rss_size_max;
+	return hdev->pf_rss_size_max;
 }
 
 static int hclge_init_rss_tc_mode(struct hclge_dev *hdev)
@@ -4650,7 +4666,7 @@ static int hclge_init_rss_tc_mode(struct hclge_dev *hdev)
 int hclge_rss_init_hw(struct hclge_dev *hdev)
 {
 	struct hclge_vport *vport = hdev->vport;
-	u8 *rss_indir = vport[0].rss_indirection_tbl;
+	u16 *rss_indir = vport[0].rss_indirection_tbl;
 	u8 *key = vport[0].rss_hash_key;
 	u8 hfunc = vport[0].rss_algo;
 	int ret;
@@ -11018,7 +11034,7 @@ static u32 hclge_get_max_channels(struct hnae3_handle *handle)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	return min_t(u32, hdev->rss_size_max, vport->alloc_tqps);
+	return min_t(u32, hdev->pf_rss_size_max, vport->alloc_tqps);
 }
 
 static void hclge_get_channels(struct hnae3_handle *handle,
@@ -11037,7 +11053,7 @@ static void hclge_get_tqps_and_rss_info(struct hnae3_handle *handle,
 	struct hclge_dev *hdev = vport->back;
 
 	*alloc_tqps = vport->alloc_tqps;
-	*max_rss_size = hdev->rss_size_max;
+	*max_rss_size = hdev->pf_rss_size_max;
 }
 
 static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 008005e..50a294d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -348,7 +348,8 @@ struct hclge_cfg {
 	u8 tc_num;
 	u16 tqp_desc_num;
 	u16 rx_buf_len;
-	u16 rss_size_max;
+	u16 vf_rss_size_max;
+	u16 pf_rss_size_max;
 	u8 phy_addr;
 	u8 media_type;
 	u8 mac_addr[ETH_ALEN];
@@ -757,7 +758,8 @@ struct hclge_dev {
 
 	u16 base_tqp_pid;	/* Base task tqp physical id of this PF */
 	u16 alloc_rss_size;		/* Allocated RSS task queue */
-	u16 rss_size_max;		/* HW defined max RSS task queue */
+	u16 vf_rss_size_max;		/* HW defined VF max RSS task queue */
+	u16 pf_rss_size_max;		/* HW defined PF max RSS task queue */
 
 	u16 fdir_pf_filter_count; /* Num of guaranteed filters for this PF */
 	u16 num_alloc_vport;		/* Num vports this driver supports */
@@ -918,7 +920,7 @@ struct hclge_vport {
 
 	u8  rss_hash_key[HCLGE_RSS_KEY_SIZE]; /* User configured hash keys */
 	/* User configured lookup table entries */
-	u8  rss_indirection_tbl[HCLGE_RSS_IND_TBL_SIZE];
+	u16 rss_indirection_tbl[HCLGE_RSS_IND_TBL_SIZE];
 	int rss_algo;		/* User configured hash algorithm */
 	/* User configured rss tuple sets */
 	struct hclge_rss_tuple_cfg rss_tuple_sets;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index c3dcf94..82742a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -633,6 +633,7 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 {
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
 	struct hclge_dev *hdev = vport->back;
+	u16 vport_max_rss_size;
 	u16 max_rss_size;
 	u8 i;
 
@@ -644,7 +645,9 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 	vport->qs_offset = (vport->vport_id ? HNAE3_MAX_TC : 0) +
 				(vport->vport_id ? (vport->vport_id - 1) : 0);
 
-	max_rss_size = min_t(u16, hdev->rss_size_max,
+	vport_max_rss_size = vport->vport_id ? hdev->vf_rss_size_max :
+				hdev->pf_rss_size_max;
+	max_rss_size = min_t(u16, vport_max_rss_size,
 			     hclge_vport_get_max_rss_size(vport));
 
 	/* Set to user value, no larger than max_rss_size. */
-- 
2.7.4

