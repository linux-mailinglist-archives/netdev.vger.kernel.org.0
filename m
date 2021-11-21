Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1580458614
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 20:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238782AbhKUTPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 14:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238526AbhKUTPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 14:15:30 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCCDC061574
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 11:12:24 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id x16-20020a25b910000000b005b6b7f2f91cso24992414ybj.1
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 11:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zXuNZPgHww6ClyLM/SyDdg6ExQAderRWoAeWScbILpY=;
        b=OL9xIcTf2C82fesxbYBkLm6EF0F3PRsfkzC4r/czsIHs46ZwbxXsbOZvq2FrHCxHpb
         oKH7ivH0hnyZJMkXAbYk1rx8MjbKbSzquJZpnqPdL1VMVKqgzFi4054Vk6PEy09gPZDR
         byn3taGQRZIkUNmjFcTUhMxsNKKz9D8jGi+4CRXHjM41xjz7Hi3DBzefwZDCpYZTbIhP
         RywAOLotgKPUDNz8SAMVMxVf3wM6kR5XImGyKErmt6exH1ScXOzEVolBTQX2k9MgLLaD
         jpdJsb/amKHs+bdtbVqV9QeoHhW36y+yfsY2St6liKL9OOz0MemYLP5JwIc2oIUBzEsu
         SVAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zXuNZPgHww6ClyLM/SyDdg6ExQAderRWoAeWScbILpY=;
        b=y0dPbFzmfbSqKlDyHozHo1qDpP4oQBoYLMghXSloXGlDqYmH/TcD8X4Lhb313EKoDn
         bEn3YwZW2szr9Z4c6TOMoavfxbfZgW0oeVTj+9RE7VtaOEeNIvEyksiOuX4LwjfjCOH3
         mvErinQXCzi7We3q4gnhShqrq9x0OT7jJVW2C9l1xSvB8CYuWxBMQL/OZEbPGien8opd
         umiq65lAsUGIudrRp9VMlEhZz3V2dw0l57fJuBKxLWUSwHg6IjmV6irzMoKvFNMuF0uC
         4UBRQ/NSdAAcb9Tp6mtcekf9crDd9FHgJYqNdbUfxCHhSFWrBWdAKw+zuQtn3wrxWcS5
         4V9w==
X-Gm-Message-State: AOAM531y9Xw4GemiPFY1hQbXk0DvsLTHqTlsX3VO1N6mrEQEjO3X1e0O
        ulw/8XqDSgyTXYIUj1W1+TyN3mziwPq85Q==
X-Google-Smtp-Source: ABdhPJyDzbIpL0uo1ZqdBGFWVO0Tg/8j8JIR0IMtn9zJAqjcZDs8h7lDGj+vXU5wM1kBfjJEt9RGRf8fusHj1w==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:6b32:e5fa:422f:7e99])
 (user=mmandlik job=sendgmr) by 2002:a25:848d:: with SMTP id
 v13mr10662117ybk.178.1637521942489; Sun, 21 Nov 2021 11:12:22 -0800 (PST)
Date:   Sun, 21 Nov 2021 11:12:17 -0800
Message-Id: <20211121110853.v6.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v6 1/2] bluetooth: Handle MSFT Monitor Device Event
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
 net/bluetooth/msft.c             | 127 ++++++++++++++++++++++++++++++-
 3 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 2560cfe80db8..6734b394c6e7 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -257,6 +257,15 @@ struct adv_info {
 
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
@@ -588,6 +597,8 @@ struct hci_dev {
 
 	struct delayed_work	interleave_scan;
 
+	struct list_head	monitored_devices;
+
 #if IS_ENABLED(CONFIG_BT_LEDS)
 	struct led_trigger	*power_led;
 #endif
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index fdc0dcf8ee36..d4bcd511530a 100644
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
index 1122097e1e49..aadabe78baf6 100644
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
@@ -296,6 +305,15 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 
 		list_del(&handle_data->list);
 		kfree(handle_data);
+
+		/* Clear any monitored devices by this Adv Monitor */
+		list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices,
+					 list) {
+			if (dev->handle == handle_data->mgmt_handle) {
+				list_del(&dev->list);
+				kfree(dev);
+			}
+		}
 	}
 
 	/* If remove all monitors is required, we need to continue the process
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
@@ -590,6 +619,90 @@ void msft_unregister(struct hci_dev *hdev)
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
+/* This function requires the caller holds hdev->lock */
+static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct msft_ev_le_monitor_device *ev = (void *)skb->data;
+	struct msft_monitor_advertisement_handle_data *handle_data;
+	u8 addr_type;
+
+	if (skb->len < sizeof(*ev)) {
+		bt_dev_err(hdev,
+			   "MSFT vendor event %u: insufficient data (len: %u)",
+			   MSFT_EV_LE_MONITOR_DEVICE, skb->len);
+		return;
+	}
+	skb_pull(skb, sizeof(*ev));
+
+	bt_dev_dbg(hdev,
+		   "MSFT vendor event %u: handle 0x%04x state %d addr %pMR",
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
+			   "MSFT vendor event %u: unknown addr type 0x%02x",
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
 void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct msft_data *msft = hdev->msft_data;
@@ -617,10 +730,22 @@ void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	if (skb->len < 1)
 		return;
 
+	hci_dev_lock(hdev);
+
 	event = *skb->data;
 	skb_pull(skb, 1);
 
-	bt_dev_dbg(hdev, "MSFT vendor event %u", event);
+	switch (event) {
+	case MSFT_EV_LE_MONITOR_DEVICE:
+		msft_monitor_device_evt(hdev, skb);
+		break;
+
+	default:
+		bt_dev_dbg(hdev, "MSFT vendor event %u", event);
+		break;
+	}
+
+	hci_dev_unlock(hdev);
 }
 
 __u64 msft_get_features(struct hci_dev *hdev)
-- 
2.34.0.rc2.393.gf8c9666880-goog

