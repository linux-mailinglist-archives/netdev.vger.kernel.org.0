Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6087D48B1BA
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349808AbiAKQOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240977AbiAKQOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:14:38 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6946C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 08:14:37 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id s7-20020a5b0447000000b005fb83901511so34988592ybp.11
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 08:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VWXKqe1v/3IVgDAhUfx03uwtbJ9WWw17H61osD45Awg=;
        b=AiHFcbPvSom6iM8PqymmySD0jyl0PtGSL9TJtCI5lxpmls/N+a2kVSSlG564zwy9XM
         J/Aa4JsvQsKoh2edAVxVPUur40lJikaojAWnlN3mrFj4TQWv+ETzaR5nuSRFTeba6wob
         uHGz19DnkKh5nM+1x9Tvp1Re4x/IBTEIhC2RQRN7KebQOur3pqd4C6Vvyf4DOy4v8D2o
         +/sw5LXQusnwDk5G0P2DvR66wvgFClmTuqJjTx5OlXOIqU6dVTduHRzmYu9+ITxnl0hx
         riNRYWQmEG8qrIXqzhnrWjU6cDAp70yOBH9y4ytc/zq1cEr9EK00vn1DrWl9eiKEzKf0
         v2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VWXKqe1v/3IVgDAhUfx03uwtbJ9WWw17H61osD45Awg=;
        b=59Jz5qxKYwyYWSPlCBuBeAFEhyqDjPsCN5859vuXJ7dk6kICrGRXdB3f01MUrCx7lI
         zCE8pe15OOVkE/0FCJaIWHh8bQ/8GZgi/fXG3Bb0pc9ykUS45CIepwvbvKAVyhPKPpbH
         jS+a6wzobQ56xskRE5rNgZJ9SDH5JJCzOA8KAjau7Q37vfwUUia6V1BlLT9wVZaRoKBO
         chfxVij2Ip7UKfvTnYIOhp+w+XNWtiVxfM4v38L3Gq7tVR+LwkRO8wgN/gbVLtVmN/C8
         4SfI20NpLj0EsLVTqfh5C0pWka7BGKxxFa1WBEwUnOphPHz62LpIEA/le0m9jIFpSbXT
         y+Qg==
X-Gm-Message-State: AOAM532YlrmcpTnMs7L3koDYFG4r0m/q7ZvtawY5dgoLibKmSPfCa/0B
        ZAcq15Nc7l5OV81THJTPovB2Brf3HuBYWg==
X-Google-Smtp-Source: ABdhPJxCW3tFr2T/hWr6btefzM+EmCwIuE8leqsrj6ocoEK5XmtaczQ/CbWxrUjWhk2+PknBEzXzVpQJqBzoCg==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:716a:2c40:e18c:6d5a])
 (user=mmandlik job=sendgmr) by 2002:a25:7352:: with SMTP id
 o79mr7628431ybc.108.1641917676918; Tue, 11 Jan 2022 08:14:36 -0800 (PST)
Date:   Tue, 11 Jan 2022 08:14:25 -0800
Message-Id: <20220111081048.v10.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH v10 1/2] bluetooth: msft: Handle MSFT Monitor Device Event
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
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

Changes in v10:
- Create a helper function to delete monitor device.
- Fix inconsistent returns '&hdev->lock'.

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
 net/bluetooth/msft.c             | 158 +++++++++++++++++++++++++++++--
 3 files changed, 162 insertions(+), 8 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 586f69d084a2..639fb9f57ae7 100644
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
@@ -591,6 +600,8 @@ struct hci_dev {
 
 	struct delayed_work	interleave_scan;
 
+	struct list_head	monitored_devices;
+
 #if IS_ENABLED(CONFIG_BT_LEDS)
 	struct led_trigger	*power_led;
 #endif
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 2b7bd3655b07..14c2da9d33ff 100644
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
index 6a943634b31a..213eab2f085a 100644
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
@@ -204,6 +212,30 @@ static struct msft_monitor_advertisement_handle_data *msft_find_handle_data
 	return NULL;
 }
 
+/* This function requires the caller holds hdev->lock */
+static int msft_monitor_device_del(struct hci_dev *hdev, __u16 mgmt_handle,
+				   bdaddr_t *bdaddr, __u8 addr_type)
+{
+	struct monitored_device *dev, *tmp;
+	int count = 0;
+
+	list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices, list) {
+		/* mgmt_handle == 0 indicates remove all devices, whereas,
+		 * bdaddr == NULL indicates remove all devices matching the
+		 * mgmt_handle.
+		 */
+		if ((!mgmt_handle || dev->handle == mgmt_handle) &&
+		    (!bdaddr || (!bacmp(bdaddr, &dev->bdaddr) &&
+				 addr_type == dev->addr_type))) {
+			list_del(&dev->list);
+			kfree(dev);
+			count++;
+		}
+	}
+
+	return count;
+}
+
 static void msft_le_monitor_advertisement_cb(struct hci_dev *hdev,
 					     u8 status, u16 opcode,
 					     struct sk_buff *skb)
@@ -294,6 +326,10 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 		if (monitor && !msft->suspending)
 			hci_free_adv_monitor(hdev, monitor);
 
+		/* Clear any monitored devices by this Adv Monitor */
+		msft_monitor_device_del(hdev, handle_data->mgmt_handle, NULL,
+					0);
+
 		list_del(&handle_data->list);
 		kfree(handle_data);
 	}
@@ -557,6 +593,13 @@ void msft_do_close(struct hci_dev *hdev)
 		list_del(&handle_data->list);
 		kfree(handle_data);
 	}
+
+	hci_dev_lock(hdev);
+
+	/* Clear any devices that are being monitored */
+	msft_monitor_device_del(hdev, 0, NULL, 0);
+
+	hci_dev_unlock(hdev);
 }
 
 void msft_register(struct hci_dev *hdev)
@@ -590,10 +633,97 @@ void msft_unregister(struct hci_dev *hdev)
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
+	if (!msft_monitor_device_del(hdev, mgmt_handle, bdaddr, addr_type)) {
+		bt_dev_err(hdev, "MSFT vendor event %u: dev %pMR not in list",
+			   MSFT_EV_LE_MONITOR_DEVICE, bdaddr);
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
@@ -602,13 +732,12 @@ void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
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
@@ -617,10 +746,23 @@ void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
 	if (skb->len < 1)
 		return;
 
-	event = *skb->data;
-	skb_pull(skb, 1);
+	evt = msft_skb_pull(hdev, skb, 0, sizeof(*evt));
+	if (!evt)
+		return;
+
+	hci_dev_lock(hdev);
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
2.34.1.575.g55b058a8bb-goog

