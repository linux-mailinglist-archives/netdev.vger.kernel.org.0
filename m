Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8FF4E803B
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 10:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiCZJ6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 05:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiCZJ6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 05:58:14 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99E11EC6F;
        Sat, 26 Mar 2022 02:56:37 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KQZ7m4DGCzfZWv;
        Sat, 26 Mar 2022 17:55:00 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 17:56:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 17:56:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 3/6] net: hns3: clean residual vf config after disable sriov
Date:   Sat, 26 Mar 2022 17:51:02 +0800
Message-ID: <20220326095105.54075-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220326095105.54075-1-huangguangbin2@huawei.com>
References: <20220326095105.54075-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

After disable sriov, VF still has some config and info need to be
cleaned, which configured by PF. This patch clean the HW config
and SW struct vport->vf_info.

Fixes: fa8d82e853e8 ("net: hns3: Add support of .sriov_configure in HNS3 driver")
Signed-off-by: Peng Li<lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  3 ++
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 18 +++++++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 50 +++++++++++++++++++
 3 files changed, 71 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 6f18c9a03231..d44dd7091fa1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -537,6 +537,8 @@ struct hnae3_ae_dev {
  *   Get 1588 rx hwstamp
  * get_ts_info
  *   Get phc info
+ * clean_vf_config
+ *   Clean residual vf info after disable sriov
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -730,6 +732,7 @@ struct hnae3_ae_ops {
 			   struct ethtool_ts_info *info);
 	int (*get_link_diagnosis_info)(struct hnae3_handle *handle,
 				       u32 *status_code);
+	void (*clean_vf_config)(struct hnae3_ae_dev *ae_dev, int num_vfs);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 530ba8bef503..14dc12c2155d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3060,6 +3060,21 @@ static int hns3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 }
 
+/**
+ * hns3_clean_vf_config
+ * @pdev: pointer to a pci_dev structure
+ * @num_vfs: number of VFs allocated
+ *
+ * Clean residual vf config after disable sriov
+ **/
+static void hns3_clean_vf_config(struct pci_dev *pdev, int num_vfs)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
+
+	if (ae_dev->ops->clean_vf_config)
+		ae_dev->ops->clean_vf_config(ae_dev, num_vfs);
+}
+
 /* hns3_remove - Device removal routine
  * @pdev: PCI device information struct
  */
@@ -3098,7 +3113,10 @@ static int hns3_pci_sriov_configure(struct pci_dev *pdev, int num_vfs)
 		else
 			return num_vfs;
 	} else if (!pci_vfs_assigned(pdev)) {
+		int num_vfs_pre = pci_num_vf(pdev);
+
 		pci_disable_sriov(pdev);
+		hns3_clean_vf_config(pdev, num_vfs_pre);
 	} else {
 		dev_warn(&pdev->dev,
 			 "Unable to free VFs because some are assigned to VMs.\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 279a1771fe7c..2a5e6a241d52 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12724,6 +12724,55 @@ static int hclge_get_link_diagnosis_info(struct hnae3_handle *handle,
 	return 0;
 }
 
+/* After disable sriov, VF still has some config and info need clean,
+ * which configed by PF.
+ */
+static void hclge_clear_vport_vf_info(struct hclge_vport *vport, int vfid)
+{
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_vlan_info vlan_info;
+	int ret;
+
+	/* after disable sriov, clean VF rate configured by PF */
+	ret = hclge_tm_qs_shaper_cfg(vport, 0);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to clean vf%d rate config, ret = %d\n",
+			vfid, ret);
+
+	vlan_info.vlan_tag = 0;
+	vlan_info.qos = 0;
+	vlan_info.vlan_proto = ETH_P_8021Q;
+	ret = hclge_update_port_base_vlan_cfg(vport,
+					      HNAE3_PORT_BASE_VLAN_DISABLE,
+					      &vlan_info);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to clean vf%d port base vlan, ret = %d\n",
+			vfid, ret);
+
+	ret = hclge_set_vf_spoofchk_hw(hdev, vport->vport_id, false);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to clean vf%d spoof config, ret = %d\n",
+			vfid, ret);
+
+	memset(&vport->vf_info, 0, sizeof(vport->vf_info));
+}
+
+static void hclge_clean_vport_config(struct hnae3_ae_dev *ae_dev, int num_vfs)
+{
+	struct hclge_dev *hdev = ae_dev->priv;
+	struct hclge_vport *vport;
+	int i;
+
+	for (i = 0; i < num_vfs; i++) {
+		vport = &hdev->vport[i + HCLGE_VF_VPORT_START_NUM];
+
+		hclge_clear_vport_vf_info(vport, i);
+	}
+}
+
 static const struct hnae3_ae_ops hclge_ops = {
 	.init_ae_dev = hclge_init_ae_dev,
 	.uninit_ae_dev = hclge_uninit_ae_dev,
@@ -12825,6 +12874,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_rx_hwts = hclge_ptp_get_rx_hwts,
 	.get_ts_info = hclge_ptp_get_ts_info,
 	.get_link_diagnosis_info = hclge_get_link_diagnosis_info,
+	.clean_vf_config = hclge_clean_vport_config,
 };
 
 static struct hnae3_ae_algo ae_algo = {
-- 
2.33.0

