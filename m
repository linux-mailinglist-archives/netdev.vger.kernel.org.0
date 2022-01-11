Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE71048B1BD
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349863AbiAKQOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349854AbiAKQOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:14:40 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E9AC06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 08:14:39 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id w12-20020a05690202cc00b006118e0d9e8cso1958638ybh.2
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 08:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bRgtmsZkZY5nRN85ZrAvfNzGxHj/4mRTxjjZBiSBJbY=;
        b=ra413p7jplEAajYJ0ZSAspvvU5TB5WuxXrjAIThPnJztFVI6EMrDuffVD1Fgndj+dz
         kEAWBNe0HP0jX36D2eIUYVE3Sb50o1st0rP+gxqa99pc2vKgCMvQdb4Tttic++gntzkk
         kMyCY478Q3FAhYbNNs7Es8AlzcaWXeNa+3I4Sn3Co9vpfMnQLoKtqbViUke75mUNtwiX
         4I8wAGQvuTl3qEaPkkApLAMcKOvxyhGB8BGnndbBkRfWf8rz+IiXO80OTyWch/zRaKDC
         WxlBxxYSG5BDHcS+rnMc9fAvehaIFD9drhUoyhA9Vcl7pmy7rOqkZKNgKOq/WM+Fld92
         E9gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bRgtmsZkZY5nRN85ZrAvfNzGxHj/4mRTxjjZBiSBJbY=;
        b=epS8KJqXItEc2Xw/F+/0l/VXQmqP2nqYrubeFcpVCjO8cD7nHqV0IDYQzRy9GzHJlQ
         ltTmBz+ybVyETJj2U6SQJjYEwFX1B+kCRETrLtEUhhjl2IiUpRr4fMJsn/w1No8lubQ9
         f2HYYGrV/bG/Blddh6vooeR4ciFmdM69KbmAc/7jyx51Nx2oHBqf5Ft2gA7s19KPtCk4
         R3+Ru2yyIyv6R6Ycp/Jkg7+I/pugVYLRsQb7HTQVnZedrbOIOG4ekayJ+Ay0qSeY/LBC
         FGbrHpu+obJxt7On1LQGREeGPot15ueMM8N378ZRlWb1jPDJRWFw2UDsX19DxO9cRriX
         E6qQ==
X-Gm-Message-State: AOAM531QC5a0gz0tBTpr4ChcOTvQVCU2dI4MBCJHzh8HCe8WDkGKsGfY
        Z43GELr+BQbeqZnteCJJ+E9YfGHFlk5J0Q==
X-Google-Smtp-Source: ABdhPJy36jMPV3rI0MD+J1YcXGGNmqHDalcNcJjcI+FKBtQ6OOHU6DNObI5gCrbDTjqUeWM3FZ9IWlj+X8RGtg==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:716a:2c40:e18c:6d5a])
 (user=mmandlik job=sendgmr) by 2002:a25:ad17:: with SMTP id
 y23mr6747888ybi.568.1641917679168; Tue, 11 Jan 2022 08:14:39 -0800 (PST)
Date:   Tue, 11 Jan 2022 08:14:26 -0800
In-Reply-To: <20220111081048.v10.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
Message-Id: <20220111081048.v10.2.I9eda306e4c542010535dc49b5488946af592795e@changeid>
Mime-Version: 1.0
References: <20220111081048.v10.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH v10 2/2] bluetooth: mgmt: Add MGMT Adv Monitor Device
 Found/Lost events
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

This patch introduces two new MGMT events for notifying the bluetoothd
whenever the controller starts/stops monitoring a device.

Test performed:
- Verified by logs that the MSFT Monitor Device is received from the
  controller and the bluetoothd is notified whenever the controller
  starts/stops monitoring a device.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
Reviewed-by: Miao-chen Chou <mcchou@google.com>

---

Changes in v10:
- Update code to use monitor device delete helper function.

Changes in v8:
- Refactor mgmt_adv_monitor_device_found() to make use of
  skb_put/skb_put_data.

Changes in v7:
- Refactor mgmt_device_found() to fix stack frame size limit

Changes in v6:
- Fix compiler warning for mgmt_adv_monitor_device_found().

Changes in v5:
- New patch in the series. Split previous patch into two.
- Update the Device Found logic to send existing Device Found event or
  Adv Monitor Device Found event depending on the active scanning state.

 include/net/bluetooth/hci_core.h |   3 +
 include/net/bluetooth/mgmt.h     |  16 +++++
 net/bluetooth/mgmt.c             | 115 +++++++++++++++++++++++++++++--
 net/bluetooth/msft.c             |  20 ++++--
 4 files changed, 144 insertions(+), 10 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 639fb9f57ae7..21eadb113a31 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -601,6 +601,7 @@ struct hci_dev {
 	struct delayed_work	interleave_scan;
 
 	struct list_head	monitored_devices;
+	bool			advmon_pend_notify;
 
 #if IS_ENABLED(CONFIG_BT_LEDS)
 	struct led_trigger	*power_led;
@@ -1858,6 +1859,8 @@ void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
 int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
 int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
 int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
+void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
+				  bdaddr_t *bdaddr, u8 addr_type);
 
 u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
 		      u16 to_multiplier);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 107b25deae68..99266f7aebdc 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -1104,3 +1104,19 @@ struct mgmt_ev_controller_resume {
 #define MGMT_WAKE_REASON_NON_BT_WAKE		0x0
 #define MGMT_WAKE_REASON_UNEXPECTED		0x1
 #define MGMT_WAKE_REASON_REMOTE_WAKE		0x2
+
+#define MGMT_EV_ADV_MONITOR_DEVICE_FOUND	0x002f
+struct mgmt_ev_adv_monitor_device_found {
+	__le16 monitor_handle;
+	struct mgmt_addr_info addr;
+	__s8   rssi;
+	__le32 flags;
+	__le16 eir_len;
+	__u8   eir[0];
+} __packed;
+
+#define MGMT_EV_ADV_MONITOR_DEVICE_LOST		0x0030
+struct mgmt_ev_adv_monitor_device_lost {
+	__le16 monitor_handle;
+	struct mgmt_addr_info addr;
+} __packed;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 37087cf7dc5a..08d6494f1b34 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -174,6 +174,8 @@ static const u16 mgmt_events[] = {
 	MGMT_EV_ADV_MONITOR_REMOVED,
 	MGMT_EV_CONTROLLER_SUSPEND,
 	MGMT_EV_CONTROLLER_RESUME,
+	MGMT_EV_ADV_MONITOR_DEVICE_FOUND,
+	MGMT_EV_ADV_MONITOR_DEVICE_LOST,
 };
 
 static const u16 mgmt_untrusted_commands[] = {
@@ -9589,12 +9591,116 @@ static bool is_filter_match(struct hci_dev *hdev, s8 rssi, u8 *eir,
 	return true;
 }
 
+void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
+				  bdaddr_t *bdaddr, u8 addr_type)
+{
+	struct mgmt_ev_adv_monitor_device_lost ev;
+
+	ev.monitor_handle = cpu_to_le16(handle);
+	bacpy(&ev.addr.bdaddr, bdaddr);
+	ev.addr.type = addr_type;
+
+	mgmt_event(MGMT_EV_ADV_MONITOR_DEVICE_LOST, hdev, &ev, sizeof(ev),
+		   NULL);
+}
+
+static void mgmt_adv_monitor_device_found(struct hci_dev *hdev,
+					  bdaddr_t *bdaddr, bool report_device,
+					  struct sk_buff *skb,
+					  struct sock *skip_sk)
+{
+	struct sk_buff *advmon_skb;
+	size_t advmon_skb_len;
+	__le16 *monitor_handle;
+	struct monitored_device *dev, *tmp;
+	bool matched = false;
+	bool notify = false;
+
+	/* We have received the Advertisement Report because:
+	 * 1. the kernel has initiated active discovery
+	 * 2. if not, we have pend_le_reports > 0 in which case we are doing
+	 *    passive scanning
+	 * 3. if none of the above is true, we have one or more active
+	 *    Advertisement Monitor
+	 *
+	 * For case 1 and 2, report all advertisements via MGMT_EV_DEVICE_FOUND
+	 * and report ONLY one advertisement per device for the matched Monitor
+	 * via MGMT_EV_ADV_MONITOR_DEVICE_FOUND event.
+	 *
+	 * For case 3, since we are not active scanning and all advertisements
+	 * received are due to a matched Advertisement Monitor, report all
+	 * advertisements ONLY via MGMT_EV_ADV_MONITOR_DEVICE_FOUND event.
+	 */
+	if (report_device && !hdev->advmon_pend_notify) {
+		mgmt_event_skb(skb, skip_sk);
+		return;
+	}
+
+	advmon_skb_len = (sizeof(struct mgmt_ev_adv_monitor_device_found) -
+			  sizeof(struct mgmt_ev_device_found)) + skb->len;
+	advmon_skb = mgmt_alloc_skb(hdev, MGMT_EV_ADV_MONITOR_DEVICE_FOUND,
+				    advmon_skb_len);
+	if (!advmon_skb) {
+		if (report_device)
+			mgmt_event_skb(skb, skip_sk);
+		else
+			kfree_skb(skb);
+		return;
+	}
+
+	/* ADV_MONITOR_DEVICE_FOUND is similar to DEVICE_FOUND event except
+	 * that it also has 'monitor_handle'. Make a copy of DEVICE_FOUND and
+	 * store monitor_handle of the matched monitor.
+	 */
+	monitor_handle = skb_put(advmon_skb, sizeof(*monitor_handle));
+	skb_put_data(advmon_skb, skb->data, skb->len);
+
+	hdev->advmon_pend_notify = false;
+
+	list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices, list) {
+		if (!bacmp(&dev->bdaddr, bdaddr)) {
+			matched = true;
+
+			if (!dev->notified) {
+				*monitor_handle = cpu_to_le16(dev->handle);
+				notify = true;
+				dev->notified = true;
+			}
+		}
+
+		if (!dev->notified)
+			hdev->advmon_pend_notify = true;
+	}
+
+	if (!report_device &&
+	    ((matched && !notify) || !msft_monitor_supported(hdev))) {
+		/* Handle 0 indicates that we are not active scanning and this
+		 * is a subsequent advertisement report for an already matched
+		 * Advertisement Monitor or the controller offloading support
+		 * is not available.
+		 */
+		*monitor_handle = 0;
+		notify = true;
+	}
+
+	if (report_device)
+		mgmt_event_skb(skb, skip_sk);
+	else
+		kfree_skb(skb);
+
+	if (notify)
+		mgmt_event_skb(advmon_skb, skip_sk);
+	else
+		kfree_skb(advmon_skb);
+}
+
 void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 		       u8 addr_type, u8 *dev_class, s8 rssi, u32 flags,
 		       u8 *eir, u16 eir_len, u8 *scan_rsp, u8 scan_rsp_len)
 {
 	struct sk_buff *skb;
 	struct mgmt_ev_device_found *ev;
+	bool report_device = hci_discovery_active(hdev);
 
 	/* Don't send events for a non-kernel initiated discovery. With
 	 * LE one exception is if we have pend_le_reports > 0 in which
@@ -9603,11 +9709,10 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 	if (!hci_discovery_active(hdev)) {
 		if (link_type == ACL_LINK)
 			return;
-		if (link_type == LE_LINK &&
-		    list_empty(&hdev->pend_le_reports) &&
-		    !hci_is_adv_monitoring(hdev)) {
+		if (link_type == LE_LINK && !list_empty(&hdev->pend_le_reports))
+			report_device = true;
+		else if (!hci_is_adv_monitoring(hdev))
 			return;
-		}
 	}
 
 	if (hdev->discovery.result_filtering) {
@@ -9672,7 +9777,7 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 
 	ev->eir_len = cpu_to_le16(eir_len + scan_rsp_len);
 
-	mgmt_event_skb(skb, NULL);
+	mgmt_adv_monitor_device_found(hdev, bdaddr, report_device, skb, NULL);
 }
 
 void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 213eab2f085a..484540855863 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -214,7 +214,8 @@ static struct msft_monitor_advertisement_handle_data *msft_find_handle_data
 
 /* This function requires the caller holds hdev->lock */
 static int msft_monitor_device_del(struct hci_dev *hdev, __u16 mgmt_handle,
-				   bdaddr_t *bdaddr, __u8 addr_type)
+				   bdaddr_t *bdaddr, __u8 addr_type,
+				   bool notify)
 {
 	struct monitored_device *dev, *tmp;
 	int count = 0;
@@ -227,6 +228,12 @@ static int msft_monitor_device_del(struct hci_dev *hdev, __u16 mgmt_handle,
 		if ((!mgmt_handle || dev->handle == mgmt_handle) &&
 		    (!bdaddr || (!bacmp(bdaddr, &dev->bdaddr) &&
 				 addr_type == dev->addr_type))) {
+			if (notify && dev->notified) {
+				mgmt_adv_monitor_device_lost(hdev, dev->handle,
+							     &dev->bdaddr,
+							     dev->addr_type);
+			}
+
 			list_del(&dev->list);
 			kfree(dev);
 			count++;
@@ -328,7 +335,7 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 
 		/* Clear any monitored devices by this Adv Monitor */
 		msft_monitor_device_del(hdev, handle_data->mgmt_handle, NULL,
-					0);
+					0, false);
 
 		list_del(&handle_data->list);
 		kfree(handle_data);
@@ -596,8 +603,9 @@ void msft_do_close(struct hci_dev *hdev)
 
 	hci_dev_lock(hdev);
 
-	/* Clear any devices that are being monitored */
-	msft_monitor_device_del(hdev, 0, NULL, 0);
+	/* Clear any devices that are being monitored and notify device lost */
+	hdev->advmon_pend_notify = false;
+	msft_monitor_device_del(hdev, 0, NULL, 0, true);
 
 	hci_dev_unlock(hdev);
 }
@@ -653,13 +661,15 @@ static void msft_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr,
 
 	INIT_LIST_HEAD(&dev->list);
 	list_add(&dev->list, &hdev->monitored_devices);
+	hdev->advmon_pend_notify = true;
 }
 
 /* This function requires the caller holds hdev->lock */
 static void msft_device_lost(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			     __u8 addr_type, __u16 mgmt_handle)
 {
-	if (!msft_monitor_device_del(hdev, mgmt_handle, bdaddr, addr_type)) {
+	if (!msft_monitor_device_del(hdev, mgmt_handle, bdaddr, addr_type,
+				     true)) {
 		bt_dev_err(hdev, "MSFT vendor event %u: dev %pMR not in list",
 			   MSFT_EV_LE_MONITOR_DEVICE, bdaddr);
 	}
-- 
2.34.1.575.g55b058a8bb-goog

