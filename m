Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD24C476927
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 05:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbhLPEjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 23:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbhLPEjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 23:39:53 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39CEC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 20:39:52 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e131-20020a25d389000000b005fb5e6eb757so47482981ybf.22
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 20:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2tm2TinJWVsfiImw5s/WKNTXMA4mDw5OGO2Ynij0Bjg=;
        b=jXxanjWEMvdM39KElk2F/6rA0WePX9axVOXi01jnJGhz5PCIMTPxc4sxcAK2M5IPRv
         qJGyFxmhHOCoik/LGfV8PQZwnGhZwMQu+pTL0sYbHNsreEYi/oVmzfBLdC3lpUIZE8Jp
         TwXEyHpM4XqJnneJdSDTER1Nq8sk3sEzaJtZw6ZYUfcn8mYnI64sfgXL2Iueg3k1QTp0
         /mtu/mTK8C1WNvH66hEgzpnkBKM56Ge+ZzsVoK90Hpy+d/l4ptT+PzLEflRJ2hkb+OUh
         1ygZlApdlsvgdjSix58NHuQJ0hAis6DGBIe+cd741J3uDHl4okghxXY4r7lzVC+XtlVt
         dsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2tm2TinJWVsfiImw5s/WKNTXMA4mDw5OGO2Ynij0Bjg=;
        b=8A1SgwTeaFHz4mVwlPmMNq804Rx3xklU9I+8owkOG+68chcK3cnMMp7pefFLwNMz1z
         GYAg4zC+xPA1oc3aI+SEHjgqB8dnI6Xi1iwVAuLHLBYSppxWoAa/DDfwDBQKngcfzBHj
         Y8chQXH5UYsbdjt1ATcdqPPu0iZw6x0MBYZC9r8c46pc3aUPG5Eez8A+5ZrrwpoQmNSw
         7ocff21zJ4pYMMlC7J6bZzYhyBWJQYhKWK8iGyNnoZIOvVwYICRu9FpugJAfhmwhXJxf
         STx8ouEXI7viiuzwh7XQbMrJA6zuhp0Yn56+a3ML5/tV8UgWpKZK94zHD4rmyrEnpFBK
         nI2Q==
X-Gm-Message-State: AOAM532HNrSJXYGV7YpP6IXJ9QQNcWeVHxWiR+bfNcwsJ/ly2ueXYpwA
        bE9Mh+V+1hAiwupHwyNGwJsy3Eqw7MHAWw==
X-Google-Smtp-Source: ABdhPJwaDrc8T97XI1ZD4dM+OijD31ReME9OwXKRjinoL8bI+HIBOE04u/H8I+5+AO1NA7xj7E/wJvcL3tqmAQ==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:bfe1:d4f7:bb68:8aa6])
 (user=mmandlik job=sendgmr) by 2002:a25:a184:: with SMTP id
 a4mr10703551ybi.56.1639629591889; Wed, 15 Dec 2021 20:39:51 -0800 (PST)
Date:   Wed, 15 Dec 2021 20:39:45 -0800
Message-Id: <20211215203919.v8.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v8 1/3] bluetooth: msft: Handle MSFT Monitor Device Event
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
 net/bluetooth/msft.c             | 149 +++++++++++++++++++++++++++++--
 3 files changed, 153 insertions(+), 8 deletions(-)

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
index 6a943634b31a..b4544b1acf8f 100644
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
@@ -294,6 +302,15 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
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
@@ -538,6 +555,7 @@ void msft_do_close(struct hci_dev *hdev)
 	struct msft_data *msft = hdev->msft_data;
 	struct msft_monitor_advertisement_handle_data *handle_data, *tmp;
 	struct adv_monitor *monitor;
+	struct monitored_device *dev, *tmp_dev;
 
 	if (!msft)
 		return;
@@ -557,6 +575,16 @@ void msft_do_close(struct hci_dev *hdev)
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
@@ -590,10 +618,103 @@ void msft_unregister(struct hci_dev *hdev)
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
@@ -602,13 +723,12 @@ void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
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
@@ -617,10 +737,23 @@ void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
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

