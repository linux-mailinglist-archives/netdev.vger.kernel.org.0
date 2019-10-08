Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BA8CF05C
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 03:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfJHBW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 21:22:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53036 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729635AbfJHBWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 21:22:55 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 59C00EF9B73CDB7C635C;
        Tue,  8 Oct 2019 09:22:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 8 Oct 2019 09:22:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next 5/6] net: hns3: add support for configuring VF MAC from the host
Date:   Tue, 8 Oct 2019 09:20:08 +0800
Message-ID: <1570497609-36349-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570497609-36349-1-git-send-email-tanhuazhong@huawei.com>
References: <1570497609-36349-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support of configuring VF MAC from the host
for the HNS3 driver.

BTW, the parameter init in the hns3_init_mac_addr is
unnecessary now, since the MAC address will not read from
NCL_CONFIG when doing reset, so it should be removed,
otherwise it will affect VF's MAC address initialization.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  3 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 43 ++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 62 ++++++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 29 ++++++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 28 +++++++++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  1 +
 6 files changed, 158 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 1202bbc..c15d7fc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -375,6 +375,8 @@ struct hnae3_ae_dev {
  *   it can enable promisc mode
  * set_vf_rate
  *   Set the max tx rate of specified vf.
+ * set_vf_mac
+ *   Configure the default MAC for specified VF
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -549,6 +551,7 @@ struct hnae3_ae_ops {
 	int (*set_vf_trust)(struct hnae3_handle *handle, int vf, bool enable);
 	int (*set_vf_rate)(struct hnae3_handle *handle, int vf,
 			   int min_tx_rate, int max_tx_rate, bool force);
+	int (*set_vf_mac)(struct hnae3_handle *handle, int vf, u8 *p);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5a8c316..4e304b4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1413,6 +1413,16 @@ static int hns3_nic_net_set_mac_address(struct net_device *netdev, void *p)
 		return 0;
 	}
 
+	/* For VF device, if there is a perm_addr, then the user will not
+	 * be allowed to change the address.
+	 */
+	if (!hns3_is_phys_func(h->pdev) &&
+	    !is_zero_ether_addr(netdev->perm_addr)) {
+		netdev_err(netdev, "has permanent MAC %pM, user MAC %pM not allow\n",
+			   netdev->perm_addr, mac_addr->sa_data);
+		return -EPERM;
+	}
+
 	ret = h->ae_algo->ops->set_mac_addr(h, mac_addr->sa_data, false);
 	if (ret) {
 		netdev_err(netdev, "set_mac_address fail, ret=%d!\n", ret);
@@ -1862,6 +1872,23 @@ static int hns3_nic_set_vf_rate(struct net_device *ndev, int vf,
 					    false);
 }
 
+static int hns3_nic_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
+{
+	struct hnae3_handle *h = hns3_get_handle(netdev);
+
+	if (!h->ae_algo->ops->set_vf_mac)
+		return -EOPNOTSUPP;
+
+	if (is_multicast_ether_addr(mac)) {
+		netdev_err(netdev,
+			   "Invalid MAC:%pM specified. Could not set MAC\n",
+			   mac);
+		return -EINVAL;
+	}
+
+	return h->ae_algo->ops->set_vf_mac(h, vf_id, mac);
+}
+
 static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_open		= hns3_nic_net_open,
 	.ndo_stop		= hns3_nic_net_stop,
@@ -1885,6 +1912,7 @@ static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_get_vf_config	= hns3_nic_get_vf_config,
 	.ndo_set_vf_link_state	= hns3_nic_set_vf_link_state,
 	.ndo_set_vf_rate	= hns3_nic_set_vf_rate,
+	.ndo_set_vf_mac		= hns3_nic_set_vf_mac,
 };
 
 bool hns3_is_phys_func(struct pci_dev *pdev)
@@ -3804,23 +3832,24 @@ int hns3_uninit_all_ring(struct hns3_nic_priv *priv)
 }
 
 /* Set mac addr if it is configured. or leave it to the AE driver */
-static int hns3_init_mac_addr(struct net_device *netdev, bool init)
+static int hns3_init_mac_addr(struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
 	u8 mac_addr_temp[ETH_ALEN];
 	int ret = 0;
 
-	if (h->ae_algo->ops->get_mac_addr && init) {
+	if (h->ae_algo->ops->get_mac_addr)
 		h->ae_algo->ops->get_mac_addr(h, mac_addr_temp);
-		ether_addr_copy(netdev->dev_addr, mac_addr_temp);
-	}
 
 	/* Check if the MAC address is valid, if not get a random one */
-	if (!is_valid_ether_addr(netdev->dev_addr)) {
+	if (!is_valid_ether_addr(mac_addr_temp)) {
 		eth_hw_addr_random(netdev);
 		dev_warn(priv->dev, "using random MAC address %pM\n",
 			 netdev->dev_addr);
+	} else {
+		ether_addr_copy(netdev->dev_addr, mac_addr_temp);
+		ether_addr_copy(netdev->perm_addr, mac_addr_temp);
 	}
 
 	if (h->ae_algo->ops->set_mac_addr)
@@ -3924,7 +3953,7 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	handle->kinfo.netdev = netdev;
 	handle->priv = (void *)priv;
 
-	hns3_init_mac_addr(netdev, true);
+	hns3_init_mac_addr(netdev);
 
 	hns3_set_default_feature(netdev);
 
@@ -4392,7 +4421,7 @@ static int hns3_reset_notify_restore_enet(struct hnae3_handle *handle)
 	bool vlan_filter_enable;
 	int ret;
 
-	ret = hns3_init_mac_addr(netdev, false);
+	ret = hns3_init_mac_addr(netdev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b88c0aa..8a3a4fd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7490,6 +7490,67 @@ static int hclge_get_mac_ethertype_cmd_status(struct hclge_dev *hdev,
 	return return_status;
 }
 
+static bool hclge_check_vf_mac_exist(struct hclge_vport *vport, int vf_idx,
+				     u8 *mac_addr)
+{
+	struct hclge_mac_vlan_tbl_entry_cmd req;
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_desc desc;
+	u16 egress_port = 0;
+	int i;
+
+	if (is_zero_ether_addr(mac_addr))
+		return false;
+
+	memset(&req, 0, sizeof(req));
+	hnae3_set_field(egress_port, HCLGE_MAC_EPORT_VFID_M,
+			HCLGE_MAC_EPORT_VFID_S, vport->vport_id);
+	req.egress_port = cpu_to_le16(egress_port);
+	hclge_prepare_mac_addr(&req, mac_addr, false);
+
+	if (hclge_lookup_mac_vlan_tbl(vport, &req, &desc, false) != -ENOENT)
+		return true;
+
+	vf_idx += HCLGE_VF_VPORT_START_NUM;
+	for (i = hdev->num_vmdq_vport + 1; i < hdev->num_alloc_vport; i++)
+		if (i != vf_idx &&
+		    ether_addr_equal(mac_addr, hdev->vport[i].vf_info.mac))
+			return true;
+
+	return false;
+}
+
+static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
+			    u8 *mac_addr)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	vport = hclge_get_vf_vport(hdev, vf);
+	if (!vport)
+		return -EINVAL;
+
+	if (ether_addr_equal(mac_addr, vport->vf_info.mac)) {
+		dev_info(&hdev->pdev->dev,
+			 "Specified MAC(=%pM) is same as before, no change committed!\n",
+			 mac_addr);
+		return 0;
+	}
+
+	if (hclge_check_vf_mac_exist(vport, vf, mac_addr)) {
+		dev_err(&hdev->pdev->dev, "Specified MAC(=%pM) exists!\n",
+			mac_addr);
+		return -EEXIST;
+	}
+
+	ether_addr_copy(vport->vf_info.mac, mac_addr);
+	dev_info(&hdev->pdev->dev,
+		 "MAC of VF %d has been set to %pM, and it will be reinitialized!\n",
+		 vf, mac_addr);
+
+	return hclge_inform_reset_assert_to_vf(vport);
+}
+
 static int hclge_add_mgr_tbl(struct hclge_dev *hdev,
 			     const struct hclge_mac_mgr_tbl_entry_cmd *req)
 {
@@ -10490,6 +10551,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.set_vf_spoofchk = hclge_set_vf_spoofchk,
 	.set_vf_trust = hclge_set_vf_trust,
 	.set_vf_rate = hclge_set_vf_rate,
+	.set_vf_mac = hclge_set_vf_mac,
 };
 
 static struct hnae3_ae_algo ae_algo = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 131b47b..97463e11 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -249,6 +249,20 @@ static int hclge_set_vf_uc_mac_addr(struct hclge_vport *vport,
 	if (mbx_req->msg[1] == HCLGE_MBX_MAC_VLAN_UC_MODIFY) {
 		const u8 *old_addr = (const u8 *)(&mbx_req->msg[8]);
 
+		/* If VF MAC has been configured by the host then it
+		 * cannot be overridden by the MAC specified by the VM.
+		 */
+		if (!is_zero_ether_addr(vport->vf_info.mac) &&
+		    !ether_addr_equal(mac_addr, vport->vf_info.mac)) {
+			status = -EPERM;
+			goto out;
+		}
+
+		if (!is_valid_ether_addr(mac_addr)) {
+			status = -EINVAL;
+			goto out;
+		}
+
 		hclge_rm_uc_addr_common(vport, old_addr);
 		status = hclge_add_uc_addr_common(vport, mac_addr);
 		if (status) {
@@ -276,6 +290,7 @@ static int hclge_set_vf_uc_mac_addr(struct hclge_vport *vport,
 		return -EIO;
 	}
 
+out:
 	if (mbx_req->mbx_need_resp & HCLGE_MBX_NEED_RESP_BIT)
 		hclge_gen_resp_to_vf(vport, mbx_req, status, NULL, 0);
 
@@ -427,6 +442,13 @@ static int hclge_get_vf_queue_info(struct hclge_vport *vport,
 				    HCLGE_TQPS_RSS_INFO_LEN);
 }
 
+static int hclge_get_vf_mac_addr(struct hclge_vport *vport,
+				 struct hclge_mbx_vf_to_pf_cmd *mbx_req)
+{
+	return hclge_gen_resp_to_vf(vport, mbx_req, 0, vport->vf_info.mac,
+				    ETH_ALEN);
+}
+
 static int hclge_get_vf_queue_depth(struct hclge_vport *vport,
 				    struct hclge_mbx_vf_to_pf_cmd *mbx_req,
 				    bool gen_resp)
@@ -793,6 +815,13 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		case HCLGE_MBX_PUSH_LINK_STATUS:
 			hclge_handle_link_change_event(hdev, req);
 			break;
+		case HCLGE_MBX_GET_MAC_ADDR:
+			ret = hclge_get_vf_mac_addr(vport, req);
+			if (ret)
+				dev_err(&hdev->pdev->dev,
+					"PF failed(%d) to get MAC for VF\n",
+					ret);
+			break;
 		case HCLGE_MBX_NCSI_ERROR:
 			hclge_handle_ncsi_error(hdev);
 			break;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 1732668..9c8fd97 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1176,11 +1176,37 @@ static void hclgevf_reset_tqp_stats(struct hnae3_handle *handle)
 	}
 }
 
+static int hclgevf_get_host_mac_addr(struct hclgevf_dev *hdev, u8 *p)
+{
+	u8 host_mac[ETH_ALEN];
+	int status;
+
+	status = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_MAC_ADDR, 0, NULL, 0,
+				      true, host_mac, ETH_ALEN);
+	if (status) {
+		dev_err(&hdev->pdev->dev,
+			"fail to get VF MAC from host %d", status);
+		return status;
+	}
+
+	ether_addr_copy(p, host_mac);
+
+	return 0;
+}
+
 static void hclgevf_get_mac_addr(struct hnae3_handle *handle, u8 *p)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	u8 host_mac_addr[ETH_ALEN];
 
-	ether_addr_copy(p, hdev->hw.mac.mac_addr);
+	if (hclgevf_get_host_mac_addr(hdev, host_mac_addr))
+		return;
+
+	hdev->has_pf_mac = !is_zero_ether_addr(host_mac_addr);
+	if (hdev->has_pf_mac)
+		ether_addr_copy(p, host_mac_addr);
+	else
+		ether_addr_copy(p, hdev->hw.mac.mac_addr);
 }
 
 static int hclgevf_set_mac_addr(struct hnae3_handle *handle, void *p,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index bdde3af..ed83940 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -266,6 +266,7 @@ struct hclgevf_dev {
 	u16 num_tx_desc;	/* desc num of per tx queue */
 	u16 num_rx_desc;	/* desc num of per rx queue */
 	u8 hw_tc_map;
+	u8 has_pf_mac;
 
 	u16 num_msi;
 	u16 num_msi_left;
-- 
2.7.4

