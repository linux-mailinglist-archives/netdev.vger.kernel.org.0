Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713B1181CF9
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 16:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbgCKPyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 11:54:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34945 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730088AbgCKPyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 11:54:14 -0400
Received: by mail-pf1-f195.google.com with SMTP id u68so1580697pfb.2
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 08:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fb4ezRe9Vp5Bk7iXgk13RS1R8EhEq0B+gCyLSWK1z9Q=;
        b=DbYg5ukVPkJqkhrMeDXriB4SkXNRYV6wtEiMPMNgWP8KhWNd+iRveTl3LB13Fw6pJq
         rP41FNSMUtXGngP37L6P/+40Il9cRs4plDRzqY3MNmsQqpJnRX4jf4vDqRFRLXyB8vcg
         /GhB1bOYaT71uxlcFFX3WEGVWtouqdTaUVVWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fb4ezRe9Vp5Bk7iXgk13RS1R8EhEq0B+gCyLSWK1z9Q=;
        b=hrhFporHfcHvT31hLpui6w7UQo4AImSzP77VidSNYq+Z36qtZhshWdIJXlrXT5L9S3
         5Lin8tJEAsQ3rNllk9nHL0Mcx9DpECaaIiJKbGC/mT2jF2TdOy6p+NNzcXHY+1MA5kzz
         9Gk+CPnUpZSoBNT9gKAfSVQkG9VqWDhroutduMAhSuoRDuvL4XBx8DjyJ583xA/fPRi+
         uDls4K8PrpufOBf57W6yWPkD52T+D+lhsBEWQL9/Q8ob0eM91tfE0jr28mwu9BksiAJC
         FwyTxFrFwzadqTzOq89c8fqURYOx1VZlqNeIYc/tWlMzl/BnhiC7T+mIfT8rPguPfnsN
         Udgw==
X-Gm-Message-State: ANhLgQ1TaP0V37qH2N6PGazWIaZYvLsXtTriuJ35DwDIcfGDbuXU6PbR
        nrYVtzD9sXJQm8nlqn/YKQdRLQ==
X-Google-Smtp-Source: ADFU+vsZ3kNmQCFXo4cc79WF10A/jlpsALX7147SEEpT+KNulKEsSO8RcA0RHaK6hWbmbpdMUd6sBg==
X-Received: by 2002:a63:e20a:: with SMTP id q10mr3352797pgh.331.1583942053083;
        Wed, 11 Mar 2020 08:54:13 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id a71sm13756265pfa.162.2020.03.11.08.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 08:54:12 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com, alainm@chromium.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH v6 2/5] Bluetooth: Handle BR/EDR devices during suspend
Date:   Wed, 11 Mar 2020 08:54:01 -0700
Message-Id: <20200311085359.RFC.v6.2.Icc7c35e1cabf10f8a383a009694987520f1d1b35@changeid>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200311155404.209990-1-abhishekpandit@chromium.org>
References: <20200311155404.209990-1-abhishekpandit@chromium.org>
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

Changes in v6: None
Changes in v5:
* Added wakeable list and changed BT_DBG to bt_dev_dbg

Changes in v4: None
Changes in v3:
* Refactored to only handle BR/EDR devices

Changes in v2:
* Refactored filters and whitelist settings to its own patch
* Refactored update_white_list to have clearer edge cases
* Add connected devices to whitelist (previously missing corner case)

 include/net/bluetooth/hci.h      |  17 +++--
 include/net/bluetooth/hci_core.h |  10 ++-
 net/bluetooth/hci_core.c         |  22 ++++++-
 net/bluetooth/hci_event.c        |  24 +++++++
 net/bluetooth/hci_request.c      | 106 +++++++++++++++++++++++++++++++
 5 files changed, 169 insertions(+), 10 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 4e86f1bb7a87..5f60e135aeb6 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -942,10 +942,14 @@ struct hci_cp_sniff_subrate {
 #define HCI_OP_RESET			0x0c03
 
 #define HCI_OP_SET_EVENT_FLT		0x0c05
-struct hci_cp_set_event_flt {
-	__u8     flt_type;
-	__u8     cond_type;
-	__u8     condition[];
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
@@ -959,8 +963,9 @@ struct hci_cp_set_event_flt {
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
index d6f694b436bf..1a4d732bdce6 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -91,6 +91,10 @@ struct discovery_state {
 #define SUSPEND_NOTIFIER_TIMEOUT	msecs_to_jiffies(2000) /* 2 seconds */
 
 enum suspend_tasks {
+	SUSPEND_SCAN_DISABLE,
+	SUSPEND_SCAN_ENABLE,
+	SUSPEND_DISCONNECTING,
+
 	SUSPEND_POWERING_DOWN,
 
 	SUSPEND_PREPARE_NOTIFIER,
@@ -99,7 +103,8 @@ enum suspend_tasks {
 
 enum suspended_state {
 	BT_RUNNING = 0,
-	BT_SUSPENDED,
+	BT_SUSPEND_DISCONNECT,
+	BT_SUSPEND_COMPLETE,
 };
 
 struct hci_conn_hash {
@@ -409,6 +414,8 @@ struct hci_dev {
 	struct work_struct	suspend_prepare;
 	enum suspended_state	suspend_state_next;
 	enum suspended_state	suspend_state;
+	bool			scanning_paused;
+	bool			suspended;
 
 	wait_queue_head_t	suspend_wait_q;
 	DECLARE_BITMAP(suspend_tasks, __SUSPEND_NUM_TASKS);
@@ -418,6 +425,7 @@ struct hci_dev {
 	struct list_head	mgmt_pending;
 	struct list_head	blacklist;
 	struct list_head	whitelist;
+	struct list_head	wakeable;
 	struct list_head	uuids;
 	struct list_head	link_keys;
 	struct list_head	long_term_keys;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 39aa21a1fe92..dbd2ad3a26ed 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3325,16 +3325,31 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 		goto done;
 
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
 
@@ -3399,6 +3414,7 @@ struct hci_dev *hci_alloc_dev(void)
 	INIT_LIST_HEAD(&hdev->mgmt_pending);
 	INIT_LIST_HEAD(&hdev->blacklist);
 	INIT_LIST_HEAD(&hdev->whitelist);
+	INIT_LIST_HEAD(&hdev->wakeable);
 	INIT_LIST_HEAD(&hdev->uuids);
 	INIT_LIST_HEAD(&hdev->link_keys);
 	INIT_LIST_HEAD(&hdev->long_term_keys);
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index b9186026508e..0908eaa7cacf 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2505,6 +2505,7 @@ static void hci_inquiry_result_evt(struct hci_dev *hdev, struct sk_buff *skb)
 static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hci_ev_conn_complete *ev = (void *) skb->data;
+	struct inquiry_entry *ie;
 	struct hci_conn *conn;
 
 	BT_DBG("%s", hdev->name);
@@ -2513,6 +2514,21 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
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
 
@@ -2774,6 +2790,14 @@ static void hci_disconn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
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
index 2343166614f0..051e1b16c988 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -918,15 +918,118 @@ static u8 get_adv_instance_scan_rsp_len(struct hci_dev *hdev, u8 instance)
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
+		bt_dev_dbg(hdev, "Adding event filters for %pMR", &b->bdaddr);
+		hci_req_add(req, HCI_OP_SET_EVENT_FLT, sizeof(f), &f);
+	}
+
+	scan = !list_empty(&hdev->wakeable) ? SCAN_PAGE : SCAN_DISABLED;
+	hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
+}
+
+static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
+{
+	bt_dev_dbg(hdev, "Request complete opcode=0x%x, status=0x%x", opcode,
+		   status);
+	if (test_and_clear_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks) ||
+	    test_and_clear_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks)) {
+		wake_up(&hdev->suspend_wait_q);
+	}
+}
+
 /* Call with hci_dev_lock */
 void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 {
+	struct hci_conn *conn;
+	struct hci_request req;
+	u8 page_scan;
+	int disconnect_counter;
+
 	if (next == hdev->suspend_state) {
 		bt_dev_dbg(hdev, "Same state before and after: %d", next);
 		goto done;
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
+			bt_dev_dbg(hdev,
+				   "Had %d disconnects. Will wait on them",
+				   disconnect_counter);
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
@@ -2030,6 +2133,9 @@ void __hci_req_update_scan(struct hci_request *req)
 	if (mgmt_powering_down(hdev))
 		return;
 
+	if (hdev->scanning_paused)
+		return;
+
 	if (hci_dev_test_flag(hdev, HCI_CONNECTABLE) ||
 	    disconnected_whitelist_entries(hdev))
 		scan = SCAN_PAGE;
-- 
2.25.1.481.gfbce0eb801-goog

