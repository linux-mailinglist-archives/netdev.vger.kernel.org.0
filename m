Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B29458617
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 20:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238797AbhKUTPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 14:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238732AbhKUTPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 14:15:30 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFB5C06174A
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 11:12:25 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id e4-20020a630f04000000b002cc40fe16afso5695731pgl.23
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 11:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hDIoAvkNcFbCZq/ORvsIeSTOW2dtoloq5o2DbK2A+jg=;
        b=lwsouI/hqwoU6hYfwpbAUEbBNDqix1pjJbs9vt7pPg6EZhJsRZSdayTwPD86SLZ8ZA
         P4OSRrOqxTBv0ICqRz5TQB3eLI7zZT9SyJ0ie1f05lk9V2eJ6f5HwbZK0SAf+0pE6wpO
         oxDN1oDgVF6YFJACm20PURn+OebzaQZX5Ns323glaOJurDPTmXXkJWyZ+iEczMMuCJru
         8lS9as1lkhrdCvJ9p271PENRSC5Q2lpz8M1DzYy7C2vNpCBt6zxjKM3r7NRcWT5wbGyn
         6cB7E78wCbrVfTIO9juwaZ+UaQhBmy99ulzf2/GwLHitegRzZaM8nI/iIjywJm+N1oXO
         lnkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hDIoAvkNcFbCZq/ORvsIeSTOW2dtoloq5o2DbK2A+jg=;
        b=L7Kl91OwKXwCZQFHSuuZ6qSHV724DbjClFwFziiA+HdLQHMpQg5jhQ7kCBGk9+sMlU
         7G+EOg/RosYTLYHCEyesymQXMJtMfy3kX6bTc8BrKIkZWyd7+M2MT/2L55neoCavk4b6
         hJnLzfNYtIJFdavipBoqcuV8A/YA/oIIHt3GL8lVD4Mjucn2N8T/HkxEP4w33KgUjWTw
         uV22IV1PRyCPuz6Si2uJmZKQX2/st8vL6oKPVU9uYuTGO3qN8mfe3UlbnMdVRDs8Tq31
         2cjLV/BTYAR+DCiYn0IZQw74MA5cTitLjQSQ47L3Amh11fnIJGj74m9Ig/LTZMUPHkpH
         nPdA==
X-Gm-Message-State: AOAM530YQNRlONvztQz1l1GDuc1gO87dZrfWsfD9qcLx/+jaqvaw7Lxf
        n/jPhIEEAHanwStpe2FUANmSbNSypRmLeg==
X-Google-Smtp-Source: ABdhPJwll5ih1P4J3LZzmostSXaYMop78R1/AB8SDMjp44AQlQKAbV+rcofL5Bcyafffslhy3TprLwMGTw67BA==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:6b32:e5fa:422f:7e99])
 (user=mmandlik job=sendgmr) by 2002:a63:7d01:: with SMTP id
 y1mr29676961pgc.343.1637521944606; Sun, 21 Nov 2021 11:12:24 -0800 (PST)
Date:   Sun, 21 Nov 2021 11:12:18 -0800
In-Reply-To: <20211121110853.v6.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
Message-Id: <20211121110853.v6.2.I9eda306e4c542010535dc49b5488946af592795e@changeid>
Mime-Version: 1.0
References: <20211121110853.v6.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v6 2/2] bluetooth: Add MGMT Adv Monitor Device Found/Lost events
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

Changes in v6:
- Fix compiler warning for mgmt_adv_monitor_device_found().

Changes in v5:
- New patch in the series. Split previous patch into two.
- Update the Device Found logic to send existing Device Found event or
  Adv Monitor Device Found event depending on the active scanning state.

 include/net/bluetooth/hci_core.h |   3 +
 include/net/bluetooth/mgmt.h     |  16 +++++
 net/bluetooth/mgmt.c             | 100 ++++++++++++++++++++++++++++++-
 net/bluetooth/msft.c             |  15 ++++-
 4 files changed, 132 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 6734b394c6e7..2aabd6f62f51 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -598,6 +598,7 @@ struct hci_dev {
 	struct delayed_work	interleave_scan;
 
 	struct list_head	monitored_devices;
+	bool			advmon_pend_notify;
 
 #if IS_ENABLED(CONFIG_BT_LEDS)
 	struct led_trigger	*power_led;
@@ -1844,6 +1845,8 @@ void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
 int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
 int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
 int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
+void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
+				  bdaddr_t *bdaddr, u8 addr_type);
 
 u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
 		      u16 to_multiplier);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 23a0524061b7..4b85f93b8a77 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -1103,3 +1103,19 @@ struct mgmt_ev_controller_resume {
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
index f8f74d344297..01f74e4feb97 100644
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
@@ -9524,6 +9526,78 @@ static bool is_filter_match(struct hci_dev *hdev, s8 rssi, u8 *eir,
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
+					  struct mgmt_ev_device_found *ev,
+					  size_t ev_size, bool discovering)
+{
+	char buf[518];
+	struct mgmt_ev_adv_monitor_device_found *advmon_ev = (void *)buf;
+	size_t advmon_ev_size;
+	struct monitored_device *dev, *tmp;
+	bool matched = false;
+	bool notified = false;
+
+	/* Make sure that the buffer is big enough */
+	advmon_ev_size = ev_size + (sizeof(*advmon_ev) - sizeof(*ev));
+	if (advmon_ev_size > sizeof(buf))
+		return;
+
+	/* ADV_MONITOR_DEVICE_FOUND is similar to DEVICE_FOUND event except
+	 * that it also has 'monitor_handle'. Make a copy of DEVICE_FOUND and
+	 * store monitor_handle of the matched monitor.
+	 */
+	memcpy(&advmon_ev->addr, ev, ev_size);
+
+	hdev->advmon_pend_notify = false;
+
+	list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices, list) {
+		if (!bacmp(&dev->bdaddr, &advmon_ev->addr.bdaddr)) {
+			matched = true;
+
+			if (!dev->notified) {
+				advmon_ev->monitor_handle =
+						cpu_to_le16(dev->handle);
+
+				mgmt_event(MGMT_EV_ADV_MONITOR_DEVICE_FOUND,
+					   hdev, advmon_ev, advmon_ev_size,
+					   NULL);
+
+				notified = true;
+				dev->notified = true;
+			}
+		}
+
+		if (!dev->notified)
+			hdev->advmon_pend_notify = true;
+	}
+
+	if (!discovering &&
+	    ((matched && !notified) || !msft_monitor_supported(hdev))) {
+		/* Handle 0 indicates that we are not active scanning and this
+		 * is a subsequent advertisement report for an already matched
+		 * Advertisement Monitor or the controller offloading support
+		 * is not available.
+		 */
+		advmon_ev->monitor_handle = 0;
+
+		mgmt_event(MGMT_EV_ADV_MONITOR_DEVICE_FOUND, hdev, advmon_ev,
+			   advmon_ev_size, NULL);
+	}
+}
+
 void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 		       u8 addr_type, u8 *dev_class, s8 rssi, u32 flags,
 		       u8 *eir, u16 eir_len, u8 *scan_rsp, u8 scan_rsp_len)
@@ -9606,7 +9680,31 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 	ev->eir_len = cpu_to_le16(eir_len + scan_rsp_len);
 	ev_size = sizeof(*ev) + eir_len + scan_rsp_len;
 
-	mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, ev_size, NULL);
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
+
+	if (hci_discovery_active(hdev) ||
+	    (link_type == LE_LINK && !list_empty(&hdev->pend_le_reports))) {
+		mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, ev_size, NULL);
+
+		if (hdev->advmon_pend_notify)
+			mgmt_adv_monitor_device_found(hdev, ev, ev_size, true);
+	} else {
+		mgmt_adv_monitor_device_found(hdev, ev, ev_size, false);
+	}
 }
 
 void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index aadabe78baf6..3e2385562d2b 100644
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
2.34.0.rc2.393.gf8c9666880-goog

