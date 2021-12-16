Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3B647722F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbhLPMuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234267AbhLPMuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 07:50:04 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178A4C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 04:50:04 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b15-20020a25ae8f000000b005c20f367790so49521108ybj.2
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 04:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4E46wH3yvcuVYAB7a18vEgINbxOyjE1Nt6ME7Foq9JU=;
        b=m7uC2w8pfP0RNfizHcNxfi3qgcR4Gm7ltAtaF8eUGGeXSl8bLOElBzOqEyrzKT/+WM
         wIeEAKcbk7D+ZvsIA85HutMcEpRffcYWZC7GL5bgrUGWtqRKSDyPpmFii7djkuVtmt1A
         oHTafZQ0l+m7LBRX14Di/8iURQZz8AZlDs3hBBcQUPGKxAEHKADqNtKLYqDnGwNc4dbQ
         PtqNcgvf0wTS4/iGXkXNaROB1F4fY8bBv3e99VXViAJ3wZFVviMahA5A7TB3iDEExqzN
         mbP4r7my9C6Rtlutcbb/hksX9/EIq2gAgeb7VwJMQH7ve6j1E2VP9dAHdr9pbYcSqcnl
         XK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4E46wH3yvcuVYAB7a18vEgINbxOyjE1Nt6ME7Foq9JU=;
        b=RminvMLWrWbFVHYceIU56DR5pcokUobN+4r6Ri9ZldkR8Q8LuutmVftqrpdZOHiq9c
         tw50UH+rQnLmMXQuUhkr2VfkIbwbdOfUcZfcqg6hab+fBauBokUMOpqoZEZtvDs5GTW3
         e5cB8UF3hNUr04VqTgRbevJy5M+kzs8dBepRQzNmrBdVfZ+zfmq0CCM+Dv7cPsiLjp5Y
         iwujzWdUtsDlXf32PxXcqhv7FR7FbPOguejfPhPI537atj4ad2vxk00mxEQQYdpiR5pD
         8D8DbuHvEkf0fmgqMIqxjx8yzcDnZ/5XgTCb+7btHF/N0V2XOzeuIK5Nd9vo5nD9Bgi4
         FPEQ==
X-Gm-Message-State: AOAM53121W6AlTa20lhneTpNAo81N7G4jRJFZ6xYWf5O0U7nYj9SW0X9
        zpnXP5WcMy0LTqSdJzaOp9YHbTrQJLLAqQ==
X-Google-Smtp-Source: ABdhPJyS/SwSK7zhuZYNsgo5Gcbdjn6HjsXhhVX+fbFa4ysZEu2I7EVbH3ljSmWRiNYjJVL6jDyDLI4RKyL6DQ==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:bfe1:d4f7:bb68:8aa6])
 (user=mmandlik job=sendgmr) by 2002:a25:287:: with SMTP id
 129mr13756470ybc.524.1639659003289; Thu, 16 Dec 2021 04:50:03 -0800 (PST)
Date:   Thu, 16 Dec 2021 04:49:55 -0800
In-Reply-To: <20211216044839.v9.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
Message-Id: <20211216044839.v9.2.I9eda306e4c542010535dc49b5488946af592795e@changeid>
Mime-Version: 1.0
References: <20211216044839.v9.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v9 2/3] bluetooth: mgmt: Add MGMT Adv Monitor Device
 Found/Lost events
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

This patch introduces two new MGMT events for notifying the bluetoothd
whenever the controller starts/stops monitoring a device.

Test performed:
- Verified by logs that the MSFT Monitor Device is received from the
  controller and the bluetoothd is notified whenever the controller
  starts/stops monitoring a device.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
Reviewed-by: Miao-chen Chou <mcchou@google.com>

---

(no changes since v8)

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
 net/bluetooth/msft.c             |  15 +++-
 4 files changed, 143 insertions(+), 6 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index c2a8b1163c30..290b8a1ac0f9 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -600,6 +600,7 @@ struct hci_dev {
 	struct delayed_work	interleave_scan;
 
 	struct list_head	monitored_devices;
+	bool			advmon_pend_notify;
 
 #if IS_ENABLED(CONFIG_BT_LEDS)
 	struct led_trigger	*power_led;
@@ -1852,6 +1853,8 @@ void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
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
index e931e417d3e1..c65247b5896c 100644
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
@@ -9562,12 +9564,116 @@ static bool is_filter_match(struct hci_dev *hdev, s8 rssi, u8 *eir,
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
@@ -9576,11 +9682,10 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
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
@@ -9645,7 +9750,7 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 
 	ev->eir_len = cpu_to_le16(eir_len + scan_rsp_len);
 
-	mgmt_event_skb(skb, NULL);
+	mgmt_adv_monitor_device_found(hdev, bdaddr, report_device, skb, NULL);
 }
 
 void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index a2e1cfb5d5d0..d507faa9626a 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -579,8 +579,16 @@ void msft_do_close(struct hci_dev *hdev)
 
 	hci_dev_lock(hdev);
 
-	/* Clear any devices that are being monitored */
+	/* Clear any devices that are being monitored and notify device lost */
+
+	hdev->advmon_pend_notify = false;
+
 	list_for_each_entry_safe(dev, tmp_dev, &hdev->monitored_devices, list) {
+		if (dev->notified)
+			mgmt_adv_monitor_device_lost(hdev, dev->handle,
+						     &dev->bdaddr,
+						     dev->addr_type);
+
 		list_del(&dev->list);
 		kfree(dev);
 	}
@@ -639,6 +647,7 @@ static void msft_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr,
 
 	INIT_LIST_HEAD(&dev->list);
 	list_add(&dev->list, &hdev->monitored_devices);
+	hdev->advmon_pend_notify = true;
 }
 
 /* This function requires the caller holds hdev->lock */
@@ -649,6 +658,10 @@ static void msft_device_lost(struct hci_dev *hdev, bdaddr_t *bdaddr,
 
 	list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices, list) {
 		if (dev->handle == mgmt_handle) {
+			if (dev->notified)
+				mgmt_adv_monitor_device_lost(hdev, mgmt_handle,
+							     bdaddr, addr_type);
+
 			list_del(&dev->list);
 			kfree(dev);
 
-- 
2.34.1.173.g76aa8bc2d0-goog

