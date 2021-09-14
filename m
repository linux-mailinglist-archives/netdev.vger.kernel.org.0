Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98A140AD4F
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhINMQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:16:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9043 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbhINMQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:16:40 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H82Md3Zl6zVnw6;
        Tue, 14 Sep 2021 20:14:21 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:15:21 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:15:20 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/2] net: hns3: PF support get multicast MAC address space assigned by firmware
Date:   Tue, 14 Sep 2021 20:11:17 +0800
Message-ID: <20210914121117.13054-3-huangguangbin2@huawei.com>
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

The new firmware supports to divides the whole multicast MAC address space
equally to functions of all PFs, and calculates the space size of each PF
according to its function number.

To support this feature, PF driver adds querying multicast MAC address
space size from firmware and limits used number according to space size.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  5 +++
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  2 ++
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  3 +-
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  3 ++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 35 +++++++++++++++----
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  2 ++
 6 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index b100b63b13db..6ccb0109412b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -95,6 +95,7 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B,
 	HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B,
 	HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B,
+	HNAE3_DEV_SUPPORT_MC_MAC_MNG_B,
 };
 
 #define hnae3_dev_fd_supported(hdev) \
@@ -151,6 +152,9 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_rxd_adv_layout_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B, (ae_dev)->caps)
 
+#define hnae3_ae_dev_mc_mac_mng_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_MC_MAC_MNG_B, (ae_dev)->caps)
+
 enum HNAE3_PF_CAP_BITS {
 	HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B = 0,
 };
@@ -342,6 +346,7 @@ struct hnae3_dev_specs {
 	u16 max_frm_size;
 	u16 max_qset_num;
 	u16 umv_size;
+	u16 mc_mac_size;
 };
 
 struct hnae3_client_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index d297f22f5af9..a1555f074e06 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -926,6 +926,8 @@ hns3_dbg_dev_specs(struct hnae3_handle *h, char *buf, int len, int *pos)
 			  dev_specs->max_qset_num);
 	*pos += scnprintf(buf + *pos, len - *pos, "umv size: %u\n",
 			  dev_specs->umv_size);
+	*pos += scnprintf(buf + *pos, len - *pos, "mc mac size: %u\n",
+			  dev_specs->mc_mac_size);
 }
 
 static int hns3_dbg_dev_info(struct hnae3_handle *h, char *buf, int len)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index cfbb7c51b0cb..bfcfefa9d2b5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1190,7 +1190,8 @@ struct hclge_dev_specs_1_cmd {
 	__le16 max_int_gl;
 	u8 rsv0[2];
 	__le16 umv_size;
-	u8 rsv1[14];
+	__le16 mc_mac_size;
+	u8 rsv1[12];
 };
 
 /* mac speed type defined in firmware command */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 87d96f82c318..a983d012e26f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1972,6 +1972,9 @@ static int hclge_dbg_dump_umv_info(struct hclge_dev *hdev, char *buf, int len)
 	}
 	mutex_unlock(&hdev->vport_lock);
 
+	pos += scnprintf(buf + pos, len - pos, "used_mc_mac_num  : %u\n",
+			 hdev->used_mc_mac_num);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3ce49e437853..a0d0fa4f6a24 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1440,6 +1440,7 @@ static void hclge_parse_dev_specs(struct hclge_dev *hdev,
 	ae_dev->dev_specs.max_int_gl = le16_to_cpu(req1->max_int_gl);
 	ae_dev->dev_specs.max_frm_size = le16_to_cpu(req1->max_frm_size);
 	ae_dev->dev_specs.umv_size = le16_to_cpu(req1->umv_size);
+	ae_dev->dev_specs.mc_mac_size = le16_to_cpu(req1->mc_mac_size);
 }
 
 static void hclge_check_dev_specs(struct hclge_dev *hdev)
@@ -8483,6 +8484,9 @@ static int hclge_init_umv_space(struct hclge_dev *hdev)
 	hdev->share_umv_size = hdev->priv_umv_size +
 			hdev->max_umv_size % (hdev->num_alloc_vport + 1);
 
+	if (hdev->ae_dev->dev_specs.mc_mac_size)
+		set_bit(HNAE3_DEV_SUPPORT_MC_MAC_MNG_B, hdev->ae_dev->caps);
+
 	return 0;
 }
 
@@ -8500,6 +8504,8 @@ static void hclge_reset_umv_space(struct hclge_dev *hdev)
 	hdev->share_umv_size = hdev->priv_umv_size +
 			hdev->max_umv_size % (hdev->num_alloc_vport + 1);
 	mutex_unlock(&hdev->vport_lock);
+
+	hdev->used_mc_mac_num = 0;
 }
 
 static bool hclge_is_umv_space_full(struct hclge_vport *vport, bool need_lock)
@@ -8761,6 +8767,7 @@ int hclge_add_mc_addr_common(struct hclge_vport *vport,
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_mac_vlan_tbl_entry_cmd req;
 	struct hclge_desc desc[3];
+	bool is_new_addr = false;
 	int status;
 
 	/* mac addr check */
@@ -8774,6 +8781,13 @@ int hclge_add_mc_addr_common(struct hclge_vport *vport,
 	hclge_prepare_mac_addr(&req, addr, true);
 	status = hclge_lookup_mac_vlan_tbl(vport, &req, desc, true);
 	if (status) {
+		if (hnae3_ae_dev_mc_mac_mng_supported(hdev->ae_dev) &&
+		    hdev->used_mc_mac_num >=
+		    hdev->ae_dev->dev_specs.mc_mac_size)
+			goto err_no_space;
+
+		is_new_addr = true;
+
 		/* This mac addr do not exist, add new entry for it */
 		memset(desc[0].data, 0, sizeof(desc[0].data));
 		memset(desc[1].data, 0, sizeof(desc[0].data));
@@ -8783,12 +8797,18 @@ int hclge_add_mc_addr_common(struct hclge_vport *vport,
 	if (status)
 		return status;
 	status = hclge_add_mac_vlan_tbl(vport, &req, desc);
-	/* if already overflow, not to print each time */
-	if (status == -ENOSPC &&
-	    !(vport->overflow_promisc_flags & HNAE3_OVERFLOW_MPE))
-		dev_err(&hdev->pdev->dev, "mc mac vlan table is full\n");
+	if (status == -ENOSPC)
+		goto err_no_space;
+	else if (!status && is_new_addr)
+		hdev->used_mc_mac_num++;
 
 	return status;
+
+err_no_space:
+	/* if already overflow, not to print each time */
+	if (!(vport->overflow_promisc_flags & HNAE3_OVERFLOW_MPE))
+		dev_err(&hdev->pdev->dev, "mc mac vlan table is full\n");
+	return -ENOSPC;
 }
 
 static int hclge_rm_mc_addr(struct hnae3_handle *handle,
@@ -8825,12 +8845,15 @@ int hclge_rm_mc_addr_common(struct hclge_vport *vport,
 		if (status)
 			return status;
 
-		if (hclge_is_all_function_id_zero(desc))
+		if (hclge_is_all_function_id_zero(desc)) {
 			/* All the vfid is zero, so need to delete this entry */
 			status = hclge_remove_mac_vlan_tbl(vport, &req);
-		else
+			if (!status)
+				hdev->used_mc_mac_num--;
+		} else {
 			/* Not all the vfid is zero, update the vfid */
 			status = hclge_add_mac_vlan_tbl(vport, &req, desc);
+		}
 	} else if (status == -ENOENT) {
 		status = 0;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index de6afbcbfbac..ca25e2edf3f0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -938,6 +938,8 @@ struct hclge_dev {
 	u16 priv_umv_size;
 	/* unicast mac vlan space shared by PF and its VFs */
 	u16 share_umv_size;
+	/* multicast mac address number used by PF and its VFs */
+	u16 used_mc_mac_num;
 
 	DECLARE_KFIFO(mac_tnl_log, struct hclge_mac_tnl_stats,
 		      HCLGE_MAC_TNL_LOG_SIZE);
-- 
2.33.0

