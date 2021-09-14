Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FFE40AD4B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhINMQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:16:41 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9042 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbhINMQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:16:39 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H82Md0WBYzW2Nb;
        Tue, 14 Sep 2021 20:14:21 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:15:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:15:20 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/2] net: hns3: PF support get unicast MAC address space assigned by firmware
Date:   Tue, 14 Sep 2021 20:11:16 +0800
Message-ID: <20210914121117.13054-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914121117.13054-1-huangguangbin2@huawei.com>
References: <20210914121117.13054-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there are two ways for PF to set the unicast MAC address space
size: specified by config parameters in firmware or set to default value.

That's mean if the config parameters in firmware is zero, driver will
divide the whole unicast MAC address space equally to 8 PFs. However, in
this case, the unicast MAC address space will be wasted a lot when the
hardware actually has less then 8 PFs. And in the other hand, if one PF has
much more VFs than other PFs, then each function of this PF will has much
less address space than other PFs.

In order to ameliorate the above two situations, introduce the third way
of unicast MAC address space assignment: firmware divides the whole unicast
MAC address space equally to functions of all PFs, and calculates the space
size of each PF according to its function number. PF queries the space size
by the querying device specification command when in initialization
process.

The third way assignment is lower priority than specified by config
parameters, only if the config parameters is zero can be used, and if
firmware does not support the third way assignment, then driver still
divides the whole unicast MAC address space equally to 8 PFs.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h           |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c    |  2 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h    |  4 +++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 11 ++++++++---
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 546a60530384..b100b63b13db 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -341,6 +341,7 @@ struct hnae3_dev_specs {
 	u8 max_non_tso_bd_num; /* max BD number of one non-TSO packet */
 	u16 max_frm_size;
 	u16 max_qset_num;
+	u16 umv_size;
 };
 
 struct hnae3_client_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 2b66c59f5eaf..d297f22f5af9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -924,6 +924,8 @@ hns3_dbg_dev_specs(struct hnae3_handle *h, char *buf, int len, int *pos)
 			  dev_specs->max_tm_rate);
 	*pos += scnprintf(buf + *pos, len - *pos, "MAX QSET number: %u\n",
 			  dev_specs->max_qset_num);
+	*pos += scnprintf(buf + *pos, len - *pos, "umv size: %u\n",
+			  dev_specs->umv_size);
 }
 
 static int hns3_dbg_dev_info(struct hnae3_handle *h, char *buf, int len)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 33244472e0d0..cfbb7c51b0cb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1188,7 +1188,9 @@ struct hclge_dev_specs_1_cmd {
 	__le16 max_frm_size;
 	__le16 max_qset_num;
 	__le16 max_int_gl;
-	u8 rsv1[18];
+	u8 rsv0[2];
+	__le16 umv_size;
+	u8 rsv1[14];
 };
 
 /* mac speed type defined in firmware command */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f1e46ba799f9..3ce49e437853 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1342,8 +1342,6 @@ static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 	cfg->umv_space = hnae3_get_field(__le32_to_cpu(req->param[1]),
 					 HCLGE_CFG_UMV_TBL_SPACE_M,
 					 HCLGE_CFG_UMV_TBL_SPACE_S);
-	if (!cfg->umv_space)
-		cfg->umv_space = HCLGE_DEFAULT_UMV_SPACE_PER_PF;
 
 	cfg->pf_rss_size_max = hnae3_get_field(__le32_to_cpu(req->param[2]),
 					       HCLGE_CFG_PF_RSS_SIZE_M,
@@ -1419,6 +1417,7 @@ static void hclge_set_default_dev_specs(struct hclge_dev *hdev)
 	ae_dev->dev_specs.max_int_gl = HCLGE_DEF_MAX_INT_GL;
 	ae_dev->dev_specs.max_frm_size = HCLGE_MAC_MAX_FRAME;
 	ae_dev->dev_specs.max_qset_num = HCLGE_MAX_QSET_NUM;
+	ae_dev->dev_specs.umv_size = HCLGE_DEFAULT_UMV_SPACE_PER_PF;
 }
 
 static void hclge_parse_dev_specs(struct hclge_dev *hdev,
@@ -1440,6 +1439,7 @@ static void hclge_parse_dev_specs(struct hclge_dev *hdev,
 	ae_dev->dev_specs.max_qset_num = le16_to_cpu(req1->max_qset_num);
 	ae_dev->dev_specs.max_int_gl = le16_to_cpu(req1->max_int_gl);
 	ae_dev->dev_specs.max_frm_size = le16_to_cpu(req1->max_frm_size);
+	ae_dev->dev_specs.umv_size = le16_to_cpu(req1->umv_size);
 }
 
 static void hclge_check_dev_specs(struct hclge_dev *hdev)
@@ -1460,6 +1460,8 @@ static void hclge_check_dev_specs(struct hclge_dev *hdev)
 		dev_specs->max_int_gl = HCLGE_DEF_MAX_INT_GL;
 	if (!dev_specs->max_frm_size)
 		dev_specs->max_frm_size = HCLGE_MAC_MAX_FRAME;
+	if (!dev_specs->umv_size)
+		dev_specs->umv_size = HCLGE_DEFAULT_UMV_SPACE_PER_PF;
 }
 
 static int hclge_query_dev_specs(struct hclge_dev *hdev)
@@ -1549,7 +1551,10 @@ static int hclge_configure(struct hclge_dev *hdev)
 	hdev->tm_info.num_pg = 1;
 	hdev->tc_max = cfg.tc_num;
 	hdev->tm_info.hw_pfc_map = 0;
-	hdev->wanted_umv_size = cfg.umv_space;
+	if (cfg.umv_space)
+		hdev->wanted_umv_size = cfg.umv_space;
+	else
+		hdev->wanted_umv_size = hdev->ae_dev->dev_specs.umv_size;
 	hdev->tx_spare_buf_size = cfg.tx_spare_buf_size;
 	hdev->gro_en = true;
 	if (cfg.vlan_fliter_cap == HCLGE_VLAN_FLTR_CAN_MDF)
-- 
2.33.0

