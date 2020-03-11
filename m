Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C255181CFB
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 16:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbgCKPyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 11:54:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42826 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730110AbgCKPyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 11:54:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id x2so1202716pfn.9
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 08:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zAvd1ksO0MBnEiO3G1YLnuSyJu5VWl3XeOEuxRpF2PM=;
        b=UhsmUJpJ1/vewdawWKK9xpyOuXdKDRhnCPoHLCgWDHc4mH2hSSSxq/ec5oThlKa+MP
         fb2ctyH4LHh5e7fw8kPfLKo0Vx2E6X1vgNp/+9Wd/6nun5Cu0OHFvz3S6j+qFhkN3q6p
         MYEnG1UwypJLlSSixpzq4SqnwEU489mMUyUQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zAvd1ksO0MBnEiO3G1YLnuSyJu5VWl3XeOEuxRpF2PM=;
        b=TUYw2rMFRNu9AYzIoh6LJ9f1tzGDvZHeOxdiL/HwMlk/41ktDgP5qSDbo9tXRTNXgZ
         mk/EG7ySRpohUgSF+C4AAotQ+VXp8kBlV0v2+tCObDHdw+v8wo4I0AndaW+/ngfcqDRq
         2mz/+0eummJYDIg/5t6eBRFr1kRqQrREyA078jABaRPzezYMsEmuePBHz9JtBHacwqnU
         ieTvkyPDtwpc+zjC4b452cCrAS1OCRLoNdoAjli8Zgh/hj2NW61t2Tn2v7Y5WPt5iIqn
         +L9cykg+8VGB+jSxJLk/G+mMgPGxDZ8YoCWP93LxgJAon98zFab9gbP7Wu0W8hZAVsjL
         +QrQ==
X-Gm-Message-State: ANhLgQ0PiSV3HuIlcHSYAd+o4qzKfXKuARyACtpUcIC/NP5YsK93i5xH
        gN27DtDrGdhmX/ARM3MIhDzWQQ==
X-Google-Smtp-Source: ADFU+vt8w4Z2163qqxwPhh3yxFW8RNUtv1bTdqhADmRz75AblKafwJBOXpTvm5f4iCmeOtwxBPJeug==
X-Received: by 2002:a63:650:: with SMTP id 77mr3425992pgg.201.1583942054430;
        Wed, 11 Mar 2020 08:54:14 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id a71sm13756265pfa.162.2020.03.11.08.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 08:54:13 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com, alainm@chromium.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH v6 3/5] Bluetooth: Handle LE devices during suspend
Date:   Wed, 11 Mar 2020 08:54:02 -0700
Message-Id: <20200311085359.RFC.v6.3.Ib0d1956aff8b9b0eff8efff085675f2156fe91c5@changeid>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200311155404.209990-1-abhishekpandit@chromium.org>
References: <20200311155404.209990-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To handle LE devices, we must first disable passive scanning and
disconnect all connected devices. Once that is complete, we update the
whitelist and re-enable scanning

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

Changes in v6: None
Changes in v5:
* Add wakeable to hci_conn_params and change BT_DBG to bt_dev_dbg

Changes in v4: None
Changes in v3:
* Split LE changes into its own commit

Changes in v2: None

 include/net/bluetooth/hci_core.h |   1 +
 net/bluetooth/hci_request.c      | 166 +++++++++++++++++++++----------
 2 files changed, 113 insertions(+), 54 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 1a4d732bdce6..2d58485d0335 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -607,6 +607,7 @@ struct hci_conn_params {
 
 	struct hci_conn *conn;
 	bool explicit_connect;
+	bool wakeable;
 };
 
 extern struct list_head hci_dev_list;
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 051e1b16c988..11624645cfcf 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -34,6 +34,9 @@
 #define HCI_REQ_PEND	  1
 #define HCI_REQ_CANCELED  2
 
+#define LE_SUSPEND_SCAN_WINDOW		0x0012
+#define LE_SUSPEND_SCAN_INTERVAL	0x0060
+
 void hci_req_init(struct hci_request *req, struct hci_dev *hdev)
 {
 	skb_queue_head_init(&req->cmd_q);
@@ -654,6 +657,11 @@ void hci_req_add_le_scan_disable(struct hci_request *req)
 {
 	struct hci_dev *hdev = req->hdev;
 
+	if (hdev->scanning_paused) {
+		bt_dev_dbg(hdev, "Scanning is paused for suspend");
+		return;
+	}
+
 	if (use_ext_scan(hdev)) {
 		struct hci_cp_le_set_ext_scan_enable cp;
 
@@ -670,15 +678,55 @@ void hci_req_add_le_scan_disable(struct hci_request *req)
 	}
 }
 
-static void add_to_white_list(struct hci_request *req,
-			      struct hci_conn_params *params)
+static void del_from_white_list(struct hci_request *req, bdaddr_t *bdaddr,
+				u8 bdaddr_type)
+{
+	struct hci_cp_le_del_from_white_list cp;
+
+	cp.bdaddr_type = bdaddr_type;
+	bacpy(&cp.bdaddr, bdaddr);
+
+	bt_dev_dbg(req->hdev, "Remove %pMR (0x%x) from whitelist", &cp.bdaddr,
+		   cp.bdaddr_type);
+	hci_req_add(req, HCI_OP_LE_DEL_FROM_WHITE_LIST, sizeof(cp), &cp);
+}
+
+/* Adds connection to white list if needed. On error, returns -1. */
+static int add_to_white_list(struct hci_request *req,
+			     struct hci_conn_params *params, u8 *num_entries,
+			     bool allow_rpa)
 {
 	struct hci_cp_le_add_to_white_list cp;
+	struct hci_dev *hdev = req->hdev;
+
+	/* Already in white list */
+	if (hci_bdaddr_list_lookup(&hdev->le_white_list, &params->addr,
+				   params->addr_type))
+		return 0;
+
+	/* Select filter policy to accept all advertising */
+	if (*num_entries >= hdev->le_white_list_size)
+		return -1;
 
+	/* White list can not be used with RPAs */
+	if (!allow_rpa &&
+	    hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
+		return -1;
+	}
+
+	/* During suspend, only wakeable devices can be in whitelist */
+	if (hdev->suspended && !params->wakeable)
+		return 0;
+
+	*num_entries += 1;
 	cp.bdaddr_type = params->addr_type;
 	bacpy(&cp.bdaddr, &params->addr);
 
+	bt_dev_dbg(hdev, "Add %pMR (0x%x) to whitelist", &cp.bdaddr,
+		   cp.bdaddr_type);
 	hci_req_add(req, HCI_OP_LE_ADD_TO_WHITE_LIST, sizeof(cp), &cp);
+
+	return 0;
 }
 
 static u8 update_white_list(struct hci_request *req)
@@ -686,7 +734,14 @@ static u8 update_white_list(struct hci_request *req)
 	struct hci_dev *hdev = req->hdev;
 	struct hci_conn_params *params;
 	struct bdaddr_list *b;
-	uint8_t white_list_entries = 0;
+	u8 num_entries = 0;
+	bool pend_conn, pend_report;
+	/* We allow whitelisting even with RPAs in suspend. In the worst case,
+	 * we won't be able to wake from devices that use the privacy1.2
+	 * features. Additionally, once we support privacy1.2 and IRK
+	 * offloading, we can update this to also check for those conditions.
+	 */
+	bool allow_rpa = hdev->suspended;
 
 	/* Go through the current white list programmed into the
 	 * controller one by one and check if that address is still
@@ -695,29 +750,28 @@ static u8 update_white_list(struct hci_request *req)
 	 * command to remove it from the controller.
 	 */
 	list_for_each_entry(b, &hdev->le_white_list, list) {
-		/* If the device is neither in pend_le_conns nor
-		 * pend_le_reports then remove it from the whitelist.
+		pend_conn = hci_pend_le_action_lookup(&hdev->pend_le_conns,
+						      &b->bdaddr,
+						      b->bdaddr_type);
+		pend_report = hci_pend_le_action_lookup(&hdev->pend_le_reports,
+							&b->bdaddr,
+							b->bdaddr_type);
+
+		/* If the device is not likely to connect or report,
+		 * remove it from the whitelist.
 		 */
-		if (!hci_pend_le_action_lookup(&hdev->pend_le_conns,
-					       &b->bdaddr, b->bdaddr_type) &&
-		    !hci_pend_le_action_lookup(&hdev->pend_le_reports,
-					       &b->bdaddr, b->bdaddr_type)) {
-			struct hci_cp_le_del_from_white_list cp;
-
-			cp.bdaddr_type = b->bdaddr_type;
-			bacpy(&cp.bdaddr, &b->bdaddr);
-
-			hci_req_add(req, HCI_OP_LE_DEL_FROM_WHITE_LIST,
-				    sizeof(cp), &cp);
+		if (!pend_conn && !pend_report) {
+			del_from_white_list(req, &b->bdaddr, b->bdaddr_type);
 			continue;
 		}
 
-		if (hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
-			/* White list can not be used with RPAs */
+		/* White list can not be used with RPAs */
+		if (!allow_rpa &&
+		    hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
 			return 0x00;
 		}
 
-		white_list_entries++;
+		num_entries++;
 	}
 
 	/* Since all no longer valid white list entries have been
@@ -731,47 +785,17 @@ static u8 update_white_list(struct hci_request *req)
 	 * white list.
 	 */
 	list_for_each_entry(params, &hdev->pend_le_conns, action) {
-		if (hci_bdaddr_list_lookup(&hdev->le_white_list,
-					   &params->addr, params->addr_type))
-			continue;
-
-		if (white_list_entries >= hdev->le_white_list_size) {
-			/* Select filter policy to accept all advertising */
+		if (add_to_white_list(req, params, &num_entries, allow_rpa))
 			return 0x00;
-		}
-
-		if (hci_find_irk_by_addr(hdev, &params->addr,
-					 params->addr_type)) {
-			/* White list can not be used with RPAs */
-			return 0x00;
-		}
-
-		white_list_entries++;
-		add_to_white_list(req, params);
 	}
 
 	/* After adding all new pending connections, walk through
 	 * the list of pending reports and also add these to the
-	 * white list if there is still space.
+	 * white list if there is still space. Abort if space runs out.
 	 */
 	list_for_each_entry(params, &hdev->pend_le_reports, action) {
-		if (hci_bdaddr_list_lookup(&hdev->le_white_list,
-					   &params->addr, params->addr_type))
-			continue;
-
-		if (white_list_entries >= hdev->le_white_list_size) {
-			/* Select filter policy to accept all advertising */
+		if (add_to_white_list(req, params, &num_entries, allow_rpa))
 			return 0x00;
-		}
-
-		if (hci_find_irk_by_addr(hdev, &params->addr,
-					 params->addr_type)) {
-			/* White list can not be used with RPAs */
-			return 0x00;
-		}
-
-		white_list_entries++;
-		add_to_white_list(req, params);
 	}
 
 	/* Select filter policy to use white list */
@@ -866,6 +890,12 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 	struct hci_dev *hdev = req->hdev;
 	u8 own_addr_type;
 	u8 filter_policy;
+	u8 window, interval;
+
+	if (hdev->scanning_paused) {
+		bt_dev_dbg(hdev, "Scanning is paused for suspend");
+		return;
+	}
 
 	/* Set require_privacy to false since no SCAN_REQ are send
 	 * during passive scanning. Not using an non-resolvable address
@@ -896,8 +926,17 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 	    (hdev->le_features[0] & HCI_LE_EXT_SCAN_POLICY))
 		filter_policy |= 0x02;
 
-	hci_req_start_scan(req, LE_SCAN_PASSIVE, hdev->le_scan_interval,
-			   hdev->le_scan_window, own_addr_type, filter_policy);
+	if (hdev->suspended) {
+		window = LE_SUSPEND_SCAN_WINDOW;
+		interval = LE_SUSPEND_SCAN_INTERVAL;
+	} else {
+		window = hdev->le_scan_window;
+		interval = hdev->le_scan_interval;
+	}
+
+	bt_dev_dbg(hdev, "LE passive scan with whitelist = %d", filter_policy);
+	hci_req_start_scan(req, LE_SCAN_PASSIVE, interval, window,
+			   own_addr_type, filter_policy);
 }
 
 static u8 get_adv_instance_scan_rsp_len(struct hci_dev *hdev, u8 instance)
@@ -957,6 +996,18 @@ static void hci_req_set_event_filter(struct hci_request *req)
 	hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
 }
 
+static void hci_req_config_le_suspend_scan(struct hci_request *req)
+{
+	/* Can't change params without disabling first */
+	hci_req_add_le_scan_disable(req);
+
+	/* Configure params and enable scanning */
+	hci_req_add_le_passive_scan(req);
+
+	/* Block suspend notifier on response */
+	set_bit(SUSPEND_SCAN_ENABLE, req->hdev->suspend_tasks);
+}
+
 static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
 {
 	bt_dev_dbg(hdev, "Request complete opcode=0x%x, status=0x%x", opcode,
@@ -991,6 +1042,9 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		page_scan = SCAN_DISABLED;
 		hci_req_add(&req, HCI_OP_WRITE_SCAN_ENABLE, 1, &page_scan);
 
+		/* Disable LE passive scan */
+		hci_req_add_le_scan_disable(&req);
+
 		/* Mark task needing completion */
 		set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
 
@@ -1018,6 +1072,8 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		hdev->scanning_paused = false;
 		/* Enable event filter for paired devices */
 		hci_req_set_event_filter(&req);
+		/* Enable passive scan at lower duty cycle */
+		hci_req_config_le_suspend_scan(&req);
 		/* Pause scan changes again. */
 		hdev->scanning_paused = true;
 		hci_req_run(&req, suspend_req_complete);
@@ -1026,6 +1082,8 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		hdev->scanning_paused = false;
 
 		hci_req_clear_event_filter(&req);
+		/* Reset passive/background scanning to normal */
+		hci_req_config_le_suspend_scan(&req);
 		hci_req_run(&req, suspend_req_complete);
 	}
 
-- 
2.25.1.481.gfbce0eb801-goog

