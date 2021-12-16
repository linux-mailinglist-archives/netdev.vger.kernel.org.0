Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1FD47722C
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbhLPMuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbhLPMuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 07:50:02 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8914C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 04:50:01 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e131-20020a25d389000000b005fb5e6eb757so49396121ybf.22
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 04:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OYe0X5Z+39vgIcBBkai30ctoKVlHHKDrTKntAV/6gvE=;
        b=Vl3sYzpqAwU82wJDrYCE5h/TokhiDADcrgd9aF5HL7gVg3nuo9DVNYh8YkS1ZMJ8Ql
         R+HQMhz2b0sW4hHVdTUTd3Yndb0SNBhLbBYF9uiivsVHmMvHOs0Mw9mcapYlUGVqKYhb
         +ZMoJafXYD3bnO6qdlx0BUzv5MmBeJrBQXvtPkNKQhhVQu9p0kh5FIOOQBdgEzcN3cJd
         /lVQ32O7QR+GeOX/Py2kxQAQBFIQwwQkNVS20LBINSePohZAYz+3B1isZIDHtIe7ewF/
         GThNuCvAJh2v9Fiy/MNMhaSNA+AHZlPw0/zGivXVzg2FfYIryy+RLdCci0lHJDVlYtfn
         R+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OYe0X5Z+39vgIcBBkai30ctoKVlHHKDrTKntAV/6gvE=;
        b=JX5LA15Hf+ZkRxd3jHkzEl51/04IYsWK5KV2P/sg2AZ6hZZq5bDM2elc7EzcdHB6gC
         KIUYgLkJ+v6zQKlWNqIYktYM30JeVZg0UQgWhG2MVbUTuYcokAZWhl10xqBQIoIBUe9e
         IJjxH4lKZ0FbmMZRfmJdC+jfA5z1BfHQt78w0ZCPGNCiczl5AV1uHsKdxvkZVcB06JyE
         CldpvxWyHVccV9V4NE1SRtD4BQnSriQMvihHNBxD9Nticiz76B4MEM37MppO8MQNBBMg
         X/ouhURwb7/oiyIqyKir74vDG66qGYHwrGXL00gzikD7OYApsMuO1RPTWMSuj/vv5RMW
         OiFQ==
X-Gm-Message-State: AOAM532RTTKUz4DSnKRVtuVNqSzNdDwlsw2VShLfVvy1/cAlYm2l6NMo
        ozQM8R2Ft2kYrfpf+CEtypv5ljNG1FKMGQ==
X-Google-Smtp-Source: ABdhPJws2q8VMhv19+PsC7/kIw2UIk2tic+egzZT5bj+wH1nPfB7/uW9Z6bDjRvMy5/qMZFeGfXJawTBbbuQmw==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:bfe1:d4f7:bb68:8aa6])
 (user=mmandlik job=sendgmr) by 2002:a25:6d04:: with SMTP id
 i4mr13837902ybc.757.1639659000972; Thu, 16 Dec 2021 04:50:00 -0800 (PST)
Date:   Thu, 16 Dec 2021 04:49:54 -0800
Message-Id: <20211216044839.v9.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v9 1/3] bluetooth: msft: Handle MSFT Monitor Device Event
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Manish Mandlik <mmandlik@google.com>,
        Miao-chen Chou <mcchou@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever the controller starts/stops monitoring a bt device, it sends
MSFT Monitor Device event. Add handler to read this vendor event.

Test performed:
- Verified by logs that the MSFT Monitor Device event is received from
  the controller whenever it starts/stops monitoring a device.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
Reviewed-by: Miao-chen Chou <mcchou@google.com>
---
Hello Bt-Maintainers,

As mentioned in the bluez patch series [1], we need to capture the 'MSFT
Monitor Device' event from the controller and pass on the necessary
information to the bluetoothd.

This is required to further optimize the power consumption by avoiding
handling of RSSI thresholds and timeouts in the user space and let the
controller do the RSSI tracking.

This patch series adds support to read the MSFT vendor event
HCI_VS_MSFT_LE_Monitor_Device_Event and introduces new MGMT events
MGMT_EV_ADV_MONITOR_DEVICE_FOUND and MGMT_EV_ADV_MONITOR_DEVICE_LOST to
indicate that the controller has started/stopped tracking a particular
device.

Please let me know what you think about this or if you have any further
questions.

[1] https://patchwork.kernel.org/project/bluetooth/list/?series=583423

Thanks,
Manish.

Changes in v9:
- Fix compiler error.

Changes in v8:
- Fix use-after-free in msft_le_cancel_monitor_advertisement_cb().
- Use skb_pull_data() instead of skb_pull().

Changes in v6:
- Fix compiler warning bt_dev_err() missing argument.

Changes in v5:
- Split v4 into two patches.
- Buffer controller Device Found event and maintain the device tracking
  state in the kernel.

Changes in v4:
- Add Advertisement Monitor Device Found event and update addr type.

Changes in v3:
- Discard changes to the Device Found event and notify bluetoothd only
  when the controller stops monitoring the device via new Device Lost
  event.

Changes in v2:
- Instead of creating a new 'Device Tracking' event, add a flag 'Device
  Tracked' in the existing 'Device Found' event and add a new 'Device
  Lost' event to indicate that the controller has stopped tracking that
  device.

 include/net/bluetooth/hci_core.h |  11 +++
 net/bluetooth/hci_core.c         |   1 +
 net/bluetooth/msft.c             | 150 +++++++++++++++++++++++++++++--
 3 files changed, 154 insertions(+), 8 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 4d69dcfebd63..c2a8b1163c30 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -258,6 +258,15 @@ struct adv_info {
 
 #define HCI_ADV_TX_POWER_NO_PREFERENCE 0x7F
 
+struct monitored_device {
+	struct list_head list;
+
+	bdaddr_t bdaddr;
+	__u8     addr_type;
+	__u16    handle;
+	bool     notified;
+};
+
 struct adv_pattern {
 	struct list_head list;
 	__u8 ad_type;
@@ -590,6 +599,8 @@ struct hci_dev {
 
 	struct delayed_work	interleave_scan;
 
+	struct list_head	monitored_devices;
+
 #if IS_ENABLED(CONFIG_BT_LEDS)
 	struct led_trigger	*power_led;
 #endif
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 38063bf1fdc5..c67e6d40c97d 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2503,6 +2503,7 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
 	INIT_LIST_HEAD(&hdev->conn_hash.list);
 	INIT_LIST_HEAD(&hdev->adv_instances);
 	INIT_LIST_HEAD(&hdev->blocked_keys);
+	INIT_LIST_HEAD(&hdev->monitored_devices);
 
 	INIT_LIST_HEAD(&hdev->local_codecs);
 	INIT_WORK(&hdev->rx_work, hci_rx_work);
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 6a943634b31a..a2e1cfb5d5d0 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -80,6 +80,14 @@ struct msft_rp_le_set_advertisement_filter_enable {
 	__u8 sub_opcode;
 } __packed;
 
+#define MSFT_EV_LE_MONITOR_DEVICE	0x02
+struct msft_ev_le_monitor_device {
+	__u8     addr_type;
+	bdaddr_t bdaddr;
+	__u8     monitor_handle;
+	__u8     monitor_state;
+} __packed;
+
 struct msft_monitor_advertisement_handle_data {
 	__u8  msft_handle;
 	__u16 mgmt_handle;
@@ -266,6 +274,7 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 	struct msft_data *msft = hdev->msft_data;
 	int err;
 	bool pending;
+	struct monitored_device *dev, *tmp;
 
 	if (status)
 		goto done;
@@ -294,6 +303,15 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 		if (monitor && !msft->suspending)
 			hci_free_adv_monitor(hdev, monitor);
 
+		/* Clear any monitored devices by this Adv Monitor */
+		list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices,
+					 list) {
+			if (dev->handle == handle_data->mgmt_handle) {
+				list_del(&dev->list);
+				kfree(dev);
+			}
+		}
+
 		list_del(&handle_data->list);
 		kfree(handle_data);
 	}
@@ -538,6 +556,7 @@ void msft_do_close(struct hci_dev *hdev)
 	struct msft_data *msft = hdev->msft_data;
 	struct msft_monitor_advertisement_handle_data *handle_data, *tmp;
 	struct adv_monitor *monitor;
+	struct monitored_device *dev, *tmp_dev;
 
 	if (!msft)
 		return;
@@ -557,6 +576,16 @@ void msft_do_close(struct hci_dev *hdev)
 		list_del(&handle_data->list);
 		kfree(handle_data);
 	}
+
+	hci_dev_lock(hdev);
+
+	/* Clear any devices that are being monitored */
+	list_for_each_entry_safe(dev, tmp_dev, &hdev->monitored_devices, list) {
+		list_del(&dev->list);
+		kfree(dev);
+	}
+
+	hci_dev_unlock(hdev);
 }
 
 void msft_register(struct hci_dev *hdev)
@@ -590,10 +619,103 @@ void msft_unregister(struct hci_dev *hdev)
 	kfree(msft);
 }
 
+/* This function requires the caller holds hdev->lock */
+static void msft_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr,
+			      __u8 addr_type, __u16 mgmt_handle)
+{
+	struct monitored_device *dev;
+
+	dev = kmalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		bt_dev_err(hdev, "MSFT vendor event %u: no memory",
+			   MSFT_EV_LE_MONITOR_DEVICE);
+		return;
+	}
+
+	bacpy(&dev->bdaddr, bdaddr);
+	dev->addr_type = addr_type;
+	dev->handle = mgmt_handle;
+	dev->notified = false;
+
+	INIT_LIST_HEAD(&dev->list);
+	list_add(&dev->list, &hdev->monitored_devices);
+}
+
+/* This function requires the caller holds hdev->lock */
+static void msft_device_lost(struct hci_dev *hdev, bdaddr_t *bdaddr,
+			     __u8 addr_type, __u16 mgmt_handle)
+{
+	struct monitored_device *dev, *tmp;
+
+	list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices, list) {
+		if (dev->handle == mgmt_handle) {
+			list_del(&dev->list);
+			kfree(dev);
+
+			break;
+		}
+	}
+}
+
+static void *msft_skb_pull(struct hci_dev *hdev, struct sk_buff *skb,
+			   u8 ev, size_t len)
+{
+	void *data;
+
+	data = skb_pull_data(skb, len);
+	if (!data)
+		bt_dev_err(hdev, "Malformed MSFT vendor event: 0x%02x", ev);
+
+	return data;
+}
+
+/* This function requires the caller holds hdev->lock */
+static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct msft_ev_le_monitor_device *ev;
+	struct msft_monitor_advertisement_handle_data *handle_data;
+	u8 addr_type;
+
+	ev = msft_skb_pull(hdev, skb, MSFT_EV_LE_MONITOR_DEVICE, sizeof(*ev));
+	if (!ev)
+		return;
+
+	bt_dev_dbg(hdev,
+		   "MSFT vendor event 0x%02x: handle 0x%04x state %d addr %pMR",
+		   MSFT_EV_LE_MONITOR_DEVICE, ev->monitor_handle,
+		   ev->monitor_state, &ev->bdaddr);
+
+	handle_data = msft_find_handle_data(hdev, ev->monitor_handle, false);
+
+	switch (ev->addr_type) {
+	case ADDR_LE_DEV_PUBLIC:
+		addr_type = BDADDR_LE_PUBLIC;
+		break;
+
+	case ADDR_LE_DEV_RANDOM:
+		addr_type = BDADDR_LE_RANDOM;
+		break;
+
+	default:
+		bt_dev_err(hdev,
+			   "MSFT vendor event 0x%02x: unknown addr type 0x%02x",
+			   MSFT_EV_LE_MONITOR_DEVICE, ev->addr_type);
+		return;
+	}
+
+	if (ev->monitor_state)
+		msft_device_found(hdev, &ev->bdaddr, addr_type,
+				  handle_data->mgmt_handle);
+	else
+		msft_device_lost(hdev, &ev->bdaddr, addr_type,
+				 handle_data->mgmt_handle);
+}
+
 void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
 {
 	struct msft_data *msft = hdev->msft_data;
-	u8 event;
+	u8 *evt_prefix;
+	u8 *evt;
 
 	if (!msft)
 		return;
@@ -602,13 +724,12 @@ void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
 	 * matches, and otherwise just return.
 	 */
 	if (msft->evt_prefix_len > 0) {
-		if (skb->len < msft->evt_prefix_len)
+		evt_prefix = msft_skb_pull(hdev, skb, 0, msft->evt_prefix_len);
+		if (!evt_prefix)
 			return;
 
-		if (memcmp(skb->data, msft->evt_prefix, msft->evt_prefix_len))
+		if (memcmp(evt_prefix, msft->evt_prefix, msft->evt_prefix_len))
 			return;
-
-		skb_pull(skb, msft->evt_prefix_len);
 	}
 
 	/* Every event starts at least with an event code and the rest of
@@ -617,10 +738,23 @@ void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
 	if (skb->len < 1)
 		return;
 
-	event = *skb->data;
-	skb_pull(skb, 1);
+	hci_dev_lock(hdev);
+
+	evt = msft_skb_pull(hdev, skb, 0, sizeof(*evt));
+	if (!evt)
+		return;
+
+	switch (*evt) {
+	case MSFT_EV_LE_MONITOR_DEVICE:
+		msft_monitor_device_evt(hdev, skb);
+		break;
 
-	bt_dev_dbg(hdev, "MSFT vendor event %u", event);
+	default:
+		bt_dev_dbg(hdev, "MSFT vendor event 0x%02x", *evt);
+		break;
+	}
+
+	hci_dev_unlock(hdev);
 }
 
 __u64 msft_get_features(struct hci_dev *hdev)
-- 
2.34.1.173.g76aa8bc2d0-goog

