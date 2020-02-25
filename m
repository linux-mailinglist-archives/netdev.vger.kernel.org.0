Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D6516B631
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgBYAAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:00:52 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37566 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbgBYAAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:00:51 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so6203455pfn.4
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 16:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eCXHKHSG5tUPSj/yQUn0bkQviD7fnjUbdLXbxBcttuo=;
        b=dBAl+L53PGN6bN4IcYwOx4NFEh5M4UIEVmBXUT9yEG+bVp5/kNlc3e2bhadpz5/IhR
         K26yQomUUpkY+eQp/bwMnp3ZqekXI48Mxjvt3NkxZqC23y2UKy1fOM9mEAaHvuDxEf11
         9+kc+GQFC9Lw7sQRxBRWdobYz/5qwJCM3nhB0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eCXHKHSG5tUPSj/yQUn0bkQviD7fnjUbdLXbxBcttuo=;
        b=tCUrSHnIy+Tt6RCri+MHL/KxU22LsIntfuEeEwuim7xSm3gMdaILKV/cgIUemRWrKS
         a896s2yrp2rDL8Gual54OzAC1R5WWkuI88ZIaAHTfYcCJ9RlQlbMl6ICjp4Ebu9VKcbZ
         hN9pfJ3ju/TTojzpcOg2HJIftcGG/LcvGE06Y7fBGfxkQ/4fnfbh/HilFn+hwEeZ1tG1
         GH2fTaA0jpK62mAI/cmRTUYbooPQkrBQ0p/OylueXFTVL5Uq7BHBAkfXAVTp6ROE8SfV
         paVEpkXJSMnlqNHFESfFUK6+z8JBso6AkjdFMCeHq8OUjuhZ7mWGer62WKVH4vAHmfMn
         N5RQ==
X-Gm-Message-State: APjAAAXShnqcwuz7UtdNwkbsYf5nkzqz/Auu75Z3YmF2GkMJSBTczmuc
        6/YKE/u/cdtkGV1OOMfEIWMECg==
X-Google-Smtp-Source: APXvYqwOWjtbYtWknl4UkWTjpQEhekZVVkt8T8cNU9N7dgD8W9ctQnQV3fXsHsv11R0fWzIAKQ9FVQ==
X-Received: by 2002:a63:3048:: with SMTP id w69mr26679991pgw.184.1582588850449;
        Mon, 24 Feb 2020 16:00:50 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id c188sm14477657pfb.151.2020.02.24.16.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 16:00:49 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com, alainm@chromium.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH v3 3/5] Bluetooth: Handle BR/EDR devices during suspend
Date:   Mon, 24 Feb 2020 16:00:34 -0800
Message-Id: <20200224160019.RFC.v3.3.Icc7c35e1cabf10f8a383a009694987520f1d1b35@changeid>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
In-Reply-To: <20200225000036.156250-1-abhishekpandit@chromium.org>
References: <20200225000036.156250-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To handle BR/EDR devices, we first disable page scan and disconnect all
connected devices. Once that is complete, we add event filters (for
devices that can wake the system) and re-enable page scan.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

Changes in v3:
* Refactored to only handle BR/EDR devices

Changes in v2:
* Refactored filters and whitelist settings to its own patch
* Refactored update_white_list to have clearer edge cases
* Add connected devices to whitelist (previously missing corner case)

 include/net/bluetooth/hci.h      |  17 ++++--
 include/net/bluetooth/hci_core.h |   9 ++-
 net/bluetooth/hci_core.c         |  21 ++++++-
 net/bluetooth/hci_event.c        |  24 ++++++++
 net/bluetooth/hci_request.c      | 101 +++++++++++++++++++++++++++++++
 5 files changed, 162 insertions(+), 10 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 6293bdd7d862..720d8e633f7e 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -932,10 +932,14 @@ struct hci_cp_sniff_subrate {
 #define HCI_OP_RESET			0x0c03
 
 #define HCI_OP_SET_EVENT_FLT		0x0c05
-struct hci_cp_set_event_flt {
-	__u8     flt_type;
-	__u8     cond_type;
-	__u8     condition[0];
+#define HCI_SET_EVENT_FLT_SIZE		9
+struct hci_cp_set_event_filter {
+	__u8		flt_type;
+	__u8		cond_type;
+	struct {
+		bdaddr_t bdaddr;
+		__u8 auto_accept;
+	} __packed	addr_conn_flt;
 } __packed;
 
 /* Filter types */
@@ -949,8 +953,9 @@ struct hci_cp_set_event_flt {
 #define HCI_CONN_SETUP_ALLOW_BDADDR	0x02
 
 /* CONN_SETUP Conditions */
-#define HCI_CONN_SETUP_AUTO_OFF	0x01
-#define HCI_CONN_SETUP_AUTO_ON	0x02
+#define HCI_CONN_SETUP_AUTO_OFF		0x01
+#define HCI_CONN_SETUP_AUTO_ON		0x02
+#define HCI_CONN_SETUP_AUTO_ON_WITH_RS	0x03
 
 #define HCI_OP_READ_STORED_LINK_KEY	0x0c0d
 struct hci_cp_read_stored_link_key {
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index bc9620e5b65b..2723a608183e 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -91,13 +91,18 @@ struct discovery_state {
 #define SUSPEND_NOTIFIER_TIMEOUT	msecs_to_jiffies(2000) /* 2 seconds */
 
 enum suspend_tasks {
+	SUSPEND_SCAN_DISABLE,
+	SUSPEND_SCAN_ENABLE,
+	SUSPEND_DISCONNECTING,
+
 	SUSPEND_PREPARE_NOTIFIER,
 	__SUSPEND_NUM_TASKS
 };
 
 enum suspended_state {
 	BT_RUNNING = 0,
-	BT_SUSPENDED,
+	BT_SUSPEND_DISCONNECT,
+	BT_SUSPEND_COMPLETE,
 };
 
 struct hci_conn_hash {
@@ -406,6 +411,8 @@ struct hci_dev {
 	struct work_struct	suspend_prepare;
 	enum suspended_state	suspend_state_next;
 	enum suspended_state	suspend_state;
+	bool			scanning_paused;
+	bool			suspended;
 
 	wait_queue_head_t	suspend_wait_q;
 	DECLARE_BITMAP(suspend_tasks, __SUSPEND_NUM_TASKS);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 6ca0aa8d30dd..66b5dbbe8ea0 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3287,16 +3287,31 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 	int ret = 0;
 
 	if (action == PM_SUSPEND_PREPARE) {
-		hdev->suspend_state_next = BT_SUSPENDED;
+		/* Suspend consists of two actions:
+		 *  - First, disconnect everything and make the controller not
+		 *    connectable (disabling scanning)
+		 *  - Second, program event filter/whitelist and enable scan
+		 */
+		hdev->suspend_state_next = BT_SUSPEND_DISCONNECT;
 		set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
 		queue_work(hdev->req_workqueue, &hdev->suspend_prepare);
-
 		ret = hci_suspend_wait_event(hdev);
+
+		/* If the disconnect portion failed, don't attempt to complete
+		 * by configuring the whitelist. The suspend notifier will
+		 * follow a cancelled suspend with a PM_POST_SUSPEND
+		 * notification.
+		 */
+		if (!ret) {
+			hdev->suspend_state_next = BT_SUSPEND_COMPLETE;
+			set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
+			queue_work(hdev->req_workqueue, &hdev->suspend_prepare);
+			ret = hci_suspend_wait_event(hdev);
+		}
 	} else if (action == PM_POST_SUSPEND) {
 		hdev->suspend_state_next = BT_RUNNING;
 		set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
 		queue_work(hdev->req_workqueue, &hdev->suspend_prepare);
-
 		ret = hci_suspend_wait_event(hdev);
 	}
 
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 591e7477e925..e3c36230f705 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2474,6 +2474,7 @@ static void hci_inquiry_result_evt(struct hci_dev *hdev, struct sk_buff *skb)
 static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hci_ev_conn_complete *ev = (void *) skb->data;
+	struct inquiry_entry *ie;
 	struct hci_conn *conn;
 
 	BT_DBG("%s", hdev->name);
@@ -2482,6 +2483,21 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	conn = hci_conn_hash_lookup_ba(hdev, ev->link_type, &ev->bdaddr);
 	if (!conn) {
+		/* Connection may not exist if auto-connected. Check the inquiry
+		 * cache to see if we've already discovered this bdaddr before.
+		 * If found and link is an ACL type, create a connection class
+		 * automatically.
+		 */
+		ie = hci_inquiry_cache_lookup(hdev, &ev->bdaddr);
+		if (ie && ev->link_type == ACL_LINK) {
+			conn = hci_conn_add(hdev, ev->link_type, &ev->bdaddr,
+					    HCI_ROLE_SLAVE);
+			if (!conn) {
+				bt_dev_err(hdev, "no memory for new conn");
+				goto unlock;
+			}
+		}
+
 		if (ev->link_type != SCO_LINK)
 			goto unlock;
 
@@ -2743,6 +2759,14 @@ static void hci_disconn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_disconn_cfm(conn, ev->reason);
 	hci_conn_del(conn);
 
+	/* The suspend notifier is waiting for all devices to disconnect so
+	 * clear the bit from pending tasks and inform the wait queue.
+	 */
+	if (list_empty(&hdev->conn_hash.list) &&
+	    test_and_clear_bit(SUSPEND_DISCONNECTING, hdev->suspend_tasks)) {
+		wake_up(&hdev->suspend_wait_q);
+	}
+
 	/* Re-enable advertising if necessary, since it might
 	 * have been disabled by the connection. From the
 	 * HCI_LE_Set_Advertise_Enable command description in
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 08908469c043..4d67b1d08608 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -918,12 +918,62 @@ static u8 get_adv_instance_scan_rsp_len(struct hci_dev *hdev, u8 instance)
 	return adv_instance->scan_rsp_len;
 }
 
+static void hci_req_clear_event_filter(struct hci_request *req)
+{
+	struct hci_cp_set_event_filter f;
+
+	memset(&f, 0, sizeof(f));
+	f.flt_type = HCI_FLT_CLEAR_ALL;
+	hci_req_add(req, HCI_OP_SET_EVENT_FLT, 1, &f);
+
+	/* Update page scan state (since we may have modified it when setting
+	 * the event filter).
+	 */
+	__hci_req_update_scan(req);
+}
+
+static void hci_req_set_event_filter(struct hci_request *req)
+{
+	struct bdaddr_list *b;
+	struct hci_cp_set_event_filter f;
+	struct hci_dev *hdev = req->hdev;
+	u8 scan;
+
+	/* Always clear event filter when starting */
+	hci_req_clear_event_filter(req);
+
+	list_for_each_entry(b, &hdev->wakeable, list) {
+		memset(&f, 0, sizeof(f));
+		bacpy(&f.addr_conn_flt.bdaddr, &b->bdaddr);
+		f.flt_type = HCI_FLT_CONN_SETUP;
+		f.cond_type = HCI_CONN_SETUP_ALLOW_BDADDR;
+		f.addr_conn_flt.auto_accept = HCI_CONN_SETUP_AUTO_ON;
+
+		BT_DBG("Adding event filters for %pMR", &b->bdaddr);
+		hci_req_add(req, HCI_OP_SET_EVENT_FLT, sizeof(f), &f);
+	}
+
+	scan = !list_empty(&hdev->wakeable) ? SCAN_PAGE : SCAN_DISABLED;
+	hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
+}
+
+static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
+{
+	BT_DBG("Request complete opcode=0x%x, status=0x%x", opcode, status);
+	if (test_and_clear_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks) ||
+	    test_and_clear_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks)) {
+		wake_up(&hdev->suspend_wait_q);
+	}
+}
+
 /* Call with hci_dev_lock */
 void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 {
 	int old_state;
 	struct hci_conn *conn;
 	struct hci_request req;
+	u8 page_scan;
+	int disconnect_counter;
 
 	if (next == hdev->suspend_state) {
 		BT_DBG("Same state before and after: %d", next);
@@ -931,6 +981,54 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 	}
 
 	hdev->suspend_state = next;
+	hci_req_init(&req, hdev);
+
+	if (next == BT_SUSPEND_DISCONNECT) {
+		/* Mark device as suspended */
+		hdev->suspended = true;
+
+		/* Disable page scan */
+		page_scan = SCAN_DISABLED;
+		hci_req_add(&req, HCI_OP_WRITE_SCAN_ENABLE, 1, &page_scan);
+
+		/* Mark task needing completion */
+		set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
+
+		/* Prevent disconnects from causing scanning to be re-enabled */
+		hdev->scanning_paused = true;
+
+		/* Run commands before disconnecting */
+		hci_req_run(&req, suspend_req_complete);
+
+		disconnect_counter = 0;
+		/* Soft disconnect everything (power off) */
+		list_for_each_entry(conn, &hdev->conn_hash.list, list) {
+			hci_disconnect(conn, HCI_ERROR_REMOTE_POWER_OFF);
+			disconnect_counter++;
+		}
+
+		if (disconnect_counter > 0) {
+			BT_DBG("Had %d disconnects. Will wait on them",
+			       disconnect_counter);
+			set_bit(SUSPEND_DISCONNECTING, hdev->suspend_tasks);
+		}
+	} else if (next == BT_SUSPEND_COMPLETE) {
+		/* Unpause to take care of updating scanning params */
+		hdev->scanning_paused = false;
+		/* Enable event filter for paired devices */
+		hci_req_set_event_filter(&req);
+		/* Pause scan changes again. */
+		hdev->scanning_paused = true;
+		hci_req_run(&req, suspend_req_complete);
+	} else {
+		hdev->suspended = false;
+		hdev->scanning_paused = false;
+
+		hci_req_clear_event_filter(&req);
+		hci_req_run(&req, suspend_req_complete);
+	}
+
+	hdev->suspend_state = next;
 
 done:
 	clear_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
@@ -2034,6 +2132,9 @@ void __hci_req_update_scan(struct hci_request *req)
 	if (mgmt_powering_down(hdev))
 		return;
 
+	if (hdev->scanning_paused)
+		return;
+
 	if (hci_dev_test_flag(hdev, HCI_CONNECTABLE) ||
 	    disconnected_whitelist_entries(hdev))
 		scan = SCAN_PAGE;
-- 
2.25.0.265.gbab2e86ba0-goog

