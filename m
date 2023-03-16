Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657C56BCA61
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjCPJJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCPJIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:08:53 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372342885E;
        Thu, 16 Mar 2023 02:08:49 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32G97vHeA011525, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32G97vHeA011525
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 16 Mar 2023 17:07:57 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 16 Mar 2023 17:07:35 +0800
Received: from localhost.localdomain (172.21.132.192) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 16 Mar 2023 17:07:34 +0800
From:   <hildawu@realtek.com>
To:     <marcel@holtmann.org>
CC:     <johan.hedberg@gmail.com>, <luiz.dentz@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <apusaka@chromium.org>, <mmandlik@google.com>,
        <yinghsu@chromium.org>, <max.chou@realtek.com>,
        <alex_lu@realsil.com.cn>, <kidman@realtek.com>
Subject: [PATCH] Bluetooth: msft: Extended monitor tracking by address filter
Date:   Thu, 16 Mar 2023 17:07:29 +0800
Message-ID: <20230316090729.14572-1-hildawu@realtek.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.132.192]
X-ClientProxiedBy: RTEXH36505.realtek.com.tw (172.21.6.25) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hilda Wu <hildawu@realtek.com>

Since limited tracking device per condition, this feature is to support
tracking multiple devices concurrently.
When a pattern monitor detects the device, this feature issues an address
monitor for tracking that device. Let pattern monitor can keep monitor
new devices.
This feature adds an address filter when receiving a LE monitor device
event which monitor handle is for a pattern, and the controller started
monitoring the device. And this feature also has cancelled the monitor
advertisement from address filters when receiving a LE monitor device
event when the controller stopped monitoring the device specified by an
address and monitor handle.

Signed-off-by: Alex Lu <alex_lu@realsil.com.cn>
Signed-off-by: Hilda Wu <hildawu@realtek.com>
---
 net/bluetooth/msft.c | 538 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 524 insertions(+), 14 deletions(-)

diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index bf5cee48916c..9e1f294b92a2 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -91,17 +91,49 @@ struct msft_ev_le_monitor_device {
 struct msft_monitor_advertisement_handle_data {
 	__u8  msft_handle;
 	__u16 mgmt_handle;
+	__s8 rssi_high;
+	__s8 rssi_low;
+	__u8 rssi_low_interval;
+	__u8 rssi_sampling_period;
+	__u8 cond_type;
 	struct list_head list;
 };
 
+#define MSFT_MONITOR_ADVERTISEMENT_TYPE_ADDR	0x04
+struct msft_monitor_addr_filter_data {
+	__u8     msft_handle;
+	__u8     pattern_handle; /* address filters pertain to */
+	__u16    mgmt_handle;
+	bool     active;
+	__s8     rssi_high;
+	__s8     rssi_low;
+	__u8     rssi_low_interval;
+	__u8     rssi_sampling_period;
+	__u8     addr_type;
+	bdaddr_t bdaddr;
+	struct list_head list;
+};
+
+struct addr_filter_skb_cb {
+	u8       pattern_handle;
+	u8       addr_type;
+	bdaddr_t bdaddr;
+};
+
+#define addr_filter_cb(skb) ((struct addr_filter_skb_cb *)((skb)->cb))
+
 struct msft_data {
 	__u64 features;
 	__u8  evt_prefix_len;
 	__u8  *evt_prefix;
 	struct list_head handle_map;
+	struct list_head address_filters;
 	__u8 resuming;
 	__u8 suspending;
 	__u8 filter_enabled;
+	bool addr_monitor_assist;
+	/* To synchronize add/remove address filter and monitor device event.*/
+	struct mutex filter_lock;
 };
 
 bool msft_monitor_supported(struct hci_dev *hdev)
@@ -180,6 +212,24 @@ static struct msft_monitor_advertisement_handle_data *msft_find_handle_data
 	return NULL;
 }
 
+/* This function requires the caller holds msft->filter_lock */
+static struct msft_monitor_addr_filter_data *msft_find_address_data
+			(struct hci_dev *hdev, u8 addr_type, bdaddr_t *addr,
+			 u8 pattern_handle)
+{
+	struct msft_monitor_addr_filter_data *entry;
+	struct msft_data *msft = hdev->msft_data;
+
+	list_for_each_entry(entry, &msft->address_filters, list) {
+		if (entry->pattern_handle == pattern_handle &&
+		    addr_type == entry->addr_type &&
+		    !bacmp(addr, &entry->bdaddr))
+			return entry;
+	}
+
+	return NULL;
+}
+
 /* This function requires the caller holds hdev->lock */
 static int msft_monitor_device_del(struct hci_dev *hdev, __u16 mgmt_handle,
 				   bdaddr_t *bdaddr, __u8 addr_type,
@@ -240,6 +290,7 @@ static int msft_le_monitor_advertisement_cb(struct hci_dev *hdev, u16 opcode,
 
 	handle_data->mgmt_handle = monitor->handle;
 	handle_data->msft_handle = rp->handle;
+	handle_data->cond_type   = MSFT_MONITOR_ADVERTISEMENT_TYPE_PATTERN;
 	INIT_LIST_HEAD(&handle_data->list);
 	list_add(&handle_data->list, &msft->handle_map);
 
@@ -254,6 +305,64 @@ static int msft_le_monitor_advertisement_cb(struct hci_dev *hdev, u16 opcode,
 	return status;
 }
 
+/* This function requires the caller holds hci_req_sync_lock */
+static int msft_remove_addr_filters_sync(struct hci_dev *hdev, u8 handle)
+{
+	struct msft_monitor_addr_filter_data *address_filter, *n;
+	struct msft_data *msft = hdev->msft_data;
+	struct msft_cp_le_cancel_monitor_advertisement cp;
+	struct sk_buff *skb;
+	struct list_head head;
+
+	INIT_LIST_HEAD(&head);
+
+	/* Cancel all corresponding address monitors */
+	mutex_lock(&msft->filter_lock);
+
+	list_for_each_entry_safe(address_filter, n, &msft->address_filters,
+				 list) {
+		if (address_filter->pattern_handle != handle)
+			continue;
+
+		list_del(&address_filter->list);
+
+		/* If the address_filter was added but haven't been enabled,
+		 * just free it.
+		 */
+		if (!address_filter->active) {
+			kfree(address_filter);
+			continue;
+		}
+
+		list_add_tail(&address_filter->list, &head);
+	}
+
+	mutex_unlock(&msft->filter_lock);
+
+	list_for_each_entry_safe(address_filter, n, &head, list) {
+		list_del(&address_filter->list);
+
+		cp.sub_opcode = MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT;
+		cp.handle = address_filter->msft_handle;
+
+		skb = __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(cp), &cp,
+				     HCI_CMD_TIMEOUT);
+		if (IS_ERR_OR_NULL(skb)) {
+			kfree(address_filter);
+			continue;
+		}
+
+		kfree_skb(skb);
+
+		bt_dev_info(hdev, "MSFT: Canceled device %pMR address filter",
+			    &address_filter->bdaddr);
+
+		kfree(address_filter);
+	}
+
+	return 0;
+}
+
 static int msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 						   u16 opcode,
 						   struct adv_monitor *monitor,
@@ -263,6 +372,7 @@ static int msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 	struct msft_monitor_advertisement_handle_data *handle_data;
 	struct msft_data *msft = hdev->msft_data;
 	int status = 0;
+	u8 msft_handle;
 
 	rp = (struct msft_rp_le_cancel_monitor_advertisement *)skb->data;
 	if (skb->len < sizeof(*rp)) {
@@ -293,11 +403,17 @@ static int msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 						NULL, 0, false);
 		}
 
+		msft_handle = handle_data->msft_handle;
+
 		list_del(&handle_data->list);
 		kfree(handle_data);
-	}
 
-	hci_dev_unlock(hdev);
+		hci_dev_unlock(hdev);
+
+		msft_remove_addr_filters_sync(hdev, msft_handle);
+	} else {
+		hci_dev_unlock(hdev);
+	}
 
 done:
 	return status;
@@ -400,6 +516,9 @@ static int msft_add_monitor_sync(struct hci_dev *hdev,
 	ptrdiff_t offset = 0;
 	u8 pattern_count = 0;
 	struct sk_buff *skb;
+	int err;
+	struct msft_monitor_advertisement_handle_data *handle_data;
+	struct msft_rp_le_monitor_advertisement *rp;
 
 	if (!msft_monitor_pattern_valid(monitor))
 		return -EINVAL;
@@ -436,16 +555,30 @@ static int msft_add_monitor_sync(struct hci_dev *hdev,
 
 	skb = __hci_cmd_sync(hdev, hdev->msft_opcode, total_size, cp,
 			     HCI_CMD_TIMEOUT);
-	kfree(cp);
 
 	if (IS_ERR_OR_NULL(skb)) {
-		if (!skb)
-			return -EIO;
+		kfree(cp);
 		return PTR_ERR(skb);
 	}
 
-	return msft_le_monitor_advertisement_cb(hdev, hdev->msft_opcode,
-						monitor, skb);
+	err = msft_le_monitor_advertisement_cb(hdev, hdev->msft_opcode,
+					       monitor, skb);
+	if (!err) {
+		rp = (struct msft_rp_le_monitor_advertisement *)skb->data;
+		handle_data = msft_find_handle_data(hdev, monitor->handle,
+						    true);
+		if (handle_data) {
+			handle_data->rssi_high   = cp->rssi_high;
+			handle_data->rssi_low    = cp->rssi_low;
+			handle_data->rssi_low_interval    =
+						cp->rssi_low_interval;
+			handle_data->rssi_sampling_period =
+						cp->rssi_sampling_period;
+		}
+	}
+	kfree(cp);
+
+	return err;
 }
 
 /* This function requires the caller holds hci_req_sync_lock */
@@ -497,6 +630,41 @@ int msft_resume_sync(struct hci_dev *hdev)
 	return 0;
 }
 
+/* This function requires the caller holds hci_req_sync_lock */
+static bool msft_address_monitor_assist_realtek(struct hci_dev *hdev)
+{
+	struct sk_buff *skb;
+	struct {
+		__u8   status;
+		__u8   chip_id;
+	} *rp;
+
+	skb = __hci_cmd_sync(hdev, 0xfc6f, 0, NULL, HCI_CMD_TIMEOUT);
+	if (IS_ERR_OR_NULL(skb)) {
+		bt_dev_err(hdev, "MSFT: Failed to send the cmd 0xfc6f");
+		return false;
+	}
+
+	rp = (void *)skb->data;
+	if (skb->len < sizeof(*rp) || rp->status) {
+		kfree_skb(skb);
+		return false;
+	}
+
+	/* RTL8822C chip id: 13
+	 * RTL8852A chip id: 18
+	 * RTL8852C chip id: 25
+	 */
+	if (rp->chip_id == 13 || rp->chip_id == 18 || rp->chip_id == 25) {
+		kfree_skb(skb);
+		return true;
+	}
+
+	kfree_skb(skb);
+
+	return false;
+}
+
 /* This function requires the caller holds hci_req_sync_lock */
 void msft_do_open(struct hci_dev *hdev)
 {
@@ -518,6 +686,10 @@ void msft_do_open(struct hci_dev *hdev)
 	msft->evt_prefix_len = 0;
 	msft->features = 0;
 
+	if (hdev->manufacturer == 0x005d)
+		msft->addr_monitor_assist =
+			msft_address_monitor_assist_realtek(hdev);
+
 	if (!read_supported_features(hdev, msft)) {
 		hdev->msft_data = NULL;
 		kfree(msft);
@@ -538,6 +710,7 @@ void msft_do_close(struct hci_dev *hdev)
 {
 	struct msft_data *msft = hdev->msft_data;
 	struct msft_monitor_advertisement_handle_data *handle_data, *tmp;
+	struct msft_monitor_addr_filter_data *address_filter, *n;
 	struct adv_monitor *monitor;
 
 	if (!msft)
@@ -559,6 +732,14 @@ void msft_do_close(struct hci_dev *hdev)
 		kfree(handle_data);
 	}
 
+	mutex_lock(&msft->filter_lock);
+	list_for_each_entry_safe(address_filter, n, &msft->address_filters,
+				 list) {
+		list_del(&address_filter->list);
+		kfree(address_filter);
+	}
+	mutex_unlock(&msft->filter_lock);
+
 	hci_dev_lock(hdev);
 
 	/* Clear any devices that are being monitored and notify device lost */
@@ -568,6 +749,58 @@ void msft_do_close(struct hci_dev *hdev)
 	hci_dev_unlock(hdev);
 }
 
+static int msft_cancel_address_filter_sync(struct hci_dev *hdev, void *data)
+{
+	struct msft_monitor_addr_filter_data *address_filter = NULL;
+	struct msft_cp_le_cancel_monitor_advertisement cp;
+	struct msft_data *msft = hdev->msft_data;
+	struct sk_buff *nskb;
+	u8 handle = PTR_ERR(data);
+
+	if (!msft) {
+		bt_dev_err(hdev, "MSFT: msft data is freed");
+		return -EINVAL;
+	}
+
+	mutex_lock(&msft->filter_lock);
+
+	list_for_each_entry(address_filter, &msft->address_filters, list) {
+		if (address_filter->active &&
+		    handle == address_filter->msft_handle) {
+			break;
+		}
+	}
+	if (!address_filter) {
+		bt_dev_warn(hdev, "MSFT: No active addr filter (%u) to cancel",
+			    handle);
+		mutex_unlock(&msft->filter_lock);
+		return -ENODEV;
+	}
+	list_del(&address_filter->list);
+
+	mutex_unlock(&msft->filter_lock);
+
+	cp.sub_opcode = MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT;
+	cp.handle = address_filter->msft_handle;
+
+	nskb = __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(cp), &cp,
+			      HCI_CMD_TIMEOUT);
+	if (IS_ERR_OR_NULL(nskb)) {
+		bt_dev_err(hdev, "MSFT: Failed to cancel address (%pMR) filter",
+			   &address_filter->bdaddr);
+		kfree(address_filter);
+		return -EIO;
+	}
+	kfree_skb(nskb);
+
+	bt_dev_info(hdev, "MSFT: Canceled device %pMR address filter",
+		    &address_filter->bdaddr);
+
+	kfree(address_filter);
+
+	return 0;
+}
+
 void msft_register(struct hci_dev *hdev)
 {
 	struct msft_data *msft = NULL;
@@ -581,7 +814,9 @@ void msft_register(struct hci_dev *hdev)
 	}
 
 	INIT_LIST_HEAD(&msft->handle_map);
+	INIT_LIST_HEAD(&msft->address_filters);
 	hdev->msft_data = msft;
+	mutex_init(&msft->filter_lock);
 }
 
 void msft_unregister(struct hci_dev *hdev)
@@ -596,6 +831,7 @@ void msft_unregister(struct hci_dev *hdev)
 	hdev->msft_data = NULL;
 
 	kfree(msft->evt_prefix);
+	mutex_destroy(&msft->filter_lock);
 	kfree(msft);
 }
 
@@ -645,12 +881,237 @@ static void *msft_skb_pull(struct hci_dev *hdev, struct sk_buff *skb,
 	return data;
 }
 
+static int msft_add_address_filter_sync(struct hci_dev *hdev, void *data)
+{
+	struct sk_buff *skb = data;
+	struct msft_monitor_addr_filter_data *address_filter = NULL;
+	struct sk_buff *nskb;
+	struct msft_rp_le_monitor_advertisement *rp;
+	bool remove = false;
+	struct msft_data *msft = hdev->msft_data;
+	int err;
+
+	if (!msft) {
+		bt_dev_err(hdev, "MSFT: msft data is freed");
+		err = -EINVAL;
+		goto error;
+	}
+
+	mutex_lock(&msft->filter_lock);
+
+	address_filter = msft_find_address_data(hdev,
+						addr_filter_cb(skb)->addr_type,
+						&addr_filter_cb(skb)->bdaddr,
+						addr_filter_cb(skb)->pattern_handle);
+	if (!address_filter) {
+		bt_dev_warn(hdev, "MSFT: No address (%pMR) filter to enable",
+			    &addr_filter_cb(skb)->bdaddr);
+		mutex_unlock(&msft->filter_lock);
+		err = -ENODEV;
+		goto error;
+	}
+
+	mutex_unlock(&msft->filter_lock);
+
+send_cmd:
+	nskb = __hci_cmd_sync(hdev, hdev->msft_opcode, skb->len, skb->data,
+			      HCI_CMD_TIMEOUT);
+	if (IS_ERR_OR_NULL(nskb)) {
+		bt_dev_err(hdev, "Failed to enable address %pMR filter",
+			   &address_filter->bdaddr);
+		nskb = NULL;
+		remove = true;
+		goto done;
+	}
+
+	rp = (struct msft_rp_le_monitor_advertisement *)nskb->data;
+	if (nskb->len < sizeof(*rp) ||
+	    rp->sub_opcode != MSFT_OP_LE_MONITOR_ADVERTISEMENT) {
+		remove = true;
+		goto done;
+	}
+
+	/* If Controller's memory capacity exceeded, cancel the first address
+	 * filter in the msft->address_filters, then try to add the new address
+	 * filter.
+	 */
+	if (rp->status == HCI_ERROR_MEMORY_EXCEEDED) {
+		struct msft_cp_le_cancel_monitor_advertisement cp;
+		struct msft_monitor_addr_filter_data *n;
+		u8 addr_type = 0xff;
+
+		mutex_lock(&msft->filter_lock);
+
+		/* If the current address filter is the first one in
+		 * msft->address_filters, it means no active address filter in
+		 * Controller.
+		 */
+		if (list_is_first(&address_filter->list,
+				  &msft->address_filters)) {
+			mutex_unlock(&msft->filter_lock);
+			bt_dev_err(hdev, "Memory capacity exceeded");
+			remove = true;
+			goto done;
+		}
+
+		n = list_first_entry(&msft->address_filters,
+				     struct msft_monitor_addr_filter_data,
+				     list);
+		list_del(&n->list);
+
+		mutex_unlock(&msft->filter_lock);
+
+		cp.sub_opcode = MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT;
+		cp.handle = n->msft_handle;
+
+		nskb = __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(cp), &cp,
+				      HCI_CMD_TIMEOUT);
+		if (IS_ERR_OR_NULL(nskb)) {
+			bt_dev_err(hdev, "MSFT: Failed to cancel filter (%pMR)",
+				   &n->bdaddr);
+			kfree(n);
+			remove = true;
+			goto done;
+		}
+
+		/* Fake a device lost event after canceling the corresponding
+		 * address filter.
+		 */
+		hci_dev_lock(hdev);
+
+		switch (n->addr_type) {
+		case ADDR_LE_DEV_PUBLIC:
+			addr_type = BDADDR_LE_PUBLIC;
+			break;
+
+		case ADDR_LE_DEV_RANDOM:
+			addr_type = BDADDR_LE_RANDOM;
+			break;
+
+		default:
+			bt_dev_err(hdev, "MSFT unknown addr type 0x%02x",
+				   n->addr_type);
+			break;
+		}
+
+		msft_device_lost(hdev, &n->bdaddr, addr_type,
+				 n->mgmt_handle);
+		hci_dev_unlock(hdev);
+
+		kfree(n);
+		kfree_skb(nskb);
+		goto send_cmd;
+	} else if (rp->status) {
+		bt_dev_err(hdev, "Enable address filter err (status 0x%02x)",
+			   rp->status);
+		remove = true;
+	}
+
+done:
+	kfree_skb(skb);
+
+	mutex_lock(&msft->filter_lock);
+
+	/* Be careful about address_filter that is not protected by the
+	 * filter_lock while the above __hci_cmd_sync() is running.
+	 */
+	if (remove) {
+		bt_dev_warn(hdev, "MSFT: Remove address (%pMR) filter",
+			    &address_filter->bdaddr);
+		list_del(&address_filter->list);
+		kfree(address_filter);
+	} else {
+		address_filter->active = true;
+		address_filter->msft_handle = rp->handle;
+		bt_dev_info(hdev, "MSFT: Address %pMR filter enabled",
+			    &address_filter->bdaddr);
+	}
+
+	mutex_unlock(&msft->filter_lock);
+
+	kfree_skb(nskb);
+
+	return 0;
+error:
+	kfree_skb(skb);
+	return err;
+}
+
+/* This function requires the caller holds msft->filter_lock */
+static struct msft_monitor_addr_filter_data *msft_add_address_filter
+		(struct hci_dev *hdev, u8 addr_type, bdaddr_t *bdaddr,
+		 struct msft_monitor_advertisement_handle_data *handle_data)
+{
+	struct sk_buff *skb;
+	struct msft_cp_le_monitor_advertisement *cp;
+	struct msft_monitor_addr_filter_data *address_filter = NULL;
+	size_t size;
+	struct msft_data *msft = hdev->msft_data;
+	int err;
+
+	size = sizeof(*cp) + sizeof(addr_type) + sizeof(*bdaddr);
+	skb = alloc_skb(size, GFP_KERNEL);
+	if (!skb) {
+		bt_dev_err(hdev, "MSFT: alloc skb err in device evt");
+		return NULL;
+	}
+
+	cp = skb_put(skb, sizeof(*cp));
+	cp->sub_opcode	    = MSFT_OP_LE_MONITOR_ADVERTISEMENT;
+	cp->rssi_high	    = handle_data->rssi_high;
+	cp->rssi_low	    = handle_data->rssi_low;
+	cp->rssi_low_interval    = handle_data->rssi_low_interval;
+	cp->rssi_sampling_period = handle_data->rssi_sampling_period;
+	cp->cond_type	    = MSFT_MONITOR_ADVERTISEMENT_TYPE_ADDR;
+	skb_put_u8(skb, addr_type);
+	skb_put_data(skb, bdaddr, sizeof(*bdaddr));
+
+	address_filter = kzalloc(sizeof(*address_filter), GFP_KERNEL);
+	if (!address_filter) {
+		kfree_skb(skb);
+		return NULL;
+	}
+
+	address_filter->active		     = false;
+	address_filter->msft_handle	     = 0xff;
+	address_filter->pattern_handle	     = handle_data->msft_handle;
+	address_filter->mgmt_handle	     = handle_data->mgmt_handle;
+	address_filter->rssi_high	     = cp->rssi_high;
+	address_filter->rssi_low	     = cp->rssi_low;
+	address_filter->rssi_low_interval    = cp->rssi_low_interval;
+	address_filter->rssi_sampling_period = cp->rssi_sampling_period;
+	address_filter->addr_type	     = addr_type;
+	bacpy(&address_filter->bdaddr, bdaddr);
+	list_add_tail(&address_filter->list, &msft->address_filters);
+
+	addr_filter_cb(skb)->pattern_handle = address_filter->pattern_handle;
+	addr_filter_cb(skb)->addr_type = addr_type;
+	bacpy(&addr_filter_cb(skb)->bdaddr, bdaddr);
+
+	err = hci_cmd_sync_queue(hdev, msft_add_address_filter_sync, skb, NULL);
+	if (err < 0) {
+		bt_dev_err(hdev, "MSFT: Add address %pMR filter err", bdaddr);
+		list_del(&address_filter->list);
+		kfree(address_filter);
+		kfree_skb(skb);
+		return NULL;
+	}
+
+	bt_dev_info(hdev, "MSFT: Add device %pMR address filter",
+		    &address_filter->bdaddr);
+
+	return address_filter;
+}
+
 /* This function requires the caller holds hdev->lock */
 static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct msft_ev_le_monitor_device *ev;
 	struct msft_monitor_advertisement_handle_data *handle_data;
+	struct msft_monitor_addr_filter_data *n, *address_filter = NULL;
 	u8 addr_type;
+	u16 mgmt_handle = 0xffff;
+	struct msft_data *msft = hdev->msft_data;
 
 	ev = msft_skb_pull(hdev, skb, MSFT_EV_LE_MONITOR_DEVICE, sizeof(*ev));
 	if (!ev)
@@ -662,9 +1123,52 @@ static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		   ev->monitor_state, &ev->bdaddr);
 
 	handle_data = msft_find_handle_data(hdev, ev->monitor_handle, false);
-	if (!handle_data)
+
+	if (!msft->addr_monitor_assist) {
+		if (!handle_data)
+			return;
+		mgmt_handle = handle_data->mgmt_handle;
+		goto report_state;
+	}
+
+	if (handle_data) {
+		/* Don't report any device found/lost event from pattern
+		 * monitors. Pattern monitor always has its address filters for
+		 * tracking devices.
+		 */
+
+		address_filter = msft_find_address_data(hdev, ev->addr_type,
+							&ev->bdaddr,
+							handle_data->msft_handle);
+		if (address_filter)
+			return;
+
+		if (ev->monitor_state && handle_data->cond_type ==
+				MSFT_MONITOR_ADVERTISEMENT_TYPE_PATTERN)
+			msft_add_address_filter(hdev, ev->addr_type,
+						&ev->bdaddr, handle_data);
+
+		return;
+	}
+
+	/* This device event is not from pattern monitor.
+	 * Report it if there is a corresponding address_filter for it.
+	 */
+	list_for_each_entry(n, &msft->address_filters, list) {
+		if (n->active && n->msft_handle == ev->monitor_handle) {
+			mgmt_handle = n->mgmt_handle;
+			address_filter = n;
+			break;
+		}
+	}
+
+	if (!address_filter) {
+		bt_dev_warn(hdev, "MSFT: Unexpected device event %pMR, %u, %u",
+			    &ev->bdaddr, ev->monitor_handle, ev->monitor_state);
 		return;
+	}
 
+report_state:
 	switch (ev->addr_type) {
 	case ADDR_LE_DEV_PUBLIC:
 		addr_type = BDADDR_LE_PUBLIC;
@@ -681,12 +1185,16 @@ static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		return;
 	}
 
-	if (ev->monitor_state)
-		msft_device_found(hdev, &ev->bdaddr, addr_type,
-				  handle_data->mgmt_handle);
-	else
-		msft_device_lost(hdev, &ev->bdaddr, addr_type,
-				 handle_data->mgmt_handle);
+	if (ev->monitor_state) {
+		msft_device_found(hdev, &ev->bdaddr, addr_type, mgmt_handle);
+	} else {
+		if (address_filter && address_filter->active)
+			hci_cmd_sync_queue(hdev,
+					   msft_cancel_address_filter_sync,
+					   ERR_PTR(address_filter->msft_handle),
+					   NULL);
+		msft_device_lost(hdev, &ev->bdaddr, addr_type, mgmt_handle);
+	}
 }
 
 void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
@@ -724,7 +1232,9 @@ void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
 
 	switch (*evt) {
 	case MSFT_EV_LE_MONITOR_DEVICE:
+		mutex_lock(&msft->filter_lock);
 		msft_monitor_device_evt(hdev, skb);
+		mutex_unlock(&msft->filter_lock);
 		break;
 
 	default:
-- 
2.17.1

