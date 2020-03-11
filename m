Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBEC4181D00
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 16:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbgCKPyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 11:54:19 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36014 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730130AbgCKPyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 11:54:17 -0400
Received: by mail-pf1-f196.google.com with SMTP id i13so1580837pfe.3
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 08:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SiS876Z1YTCTtULNBEBE9ahiWqE8Kjok6cPSZdz9AZk=;
        b=f1pC36g/iqHHTsSUpTdjWhpIF94q7otY+IhyDd+EQBpQz7xeZ/47sHS3alWXxH7R+t
         N1XavTsn3F/KLNKOZwBGoxJrxJ0ZqazSMx6iyVFKRX1QGWix22Xc4v4I04Ia/gDNiRur
         +pL8fTbB8FLTgzo5XlP3PV4y5X10/D3sPeI7o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SiS876Z1YTCTtULNBEBE9ahiWqE8Kjok6cPSZdz9AZk=;
        b=YSEiUPXJyeCg37BKCx/gjw8rbY3ar2Ji7hKz26pfbgM0MqohiqmmhFp5jlJxubbHlX
         6hUnVI4CLFowXxu2D0GfeJxMRNlv2J9eKWEI0ebFvsJDdWNZr7FC01LFz27Y5borkhNV
         0JJpHj09A6y7hY2bb6SAUHnsmFkX8/ZtFXy7OoApkCJA4/my9kegUNoxzlReSijTXppx
         2tg4+e3BUEdquib9O6xUu98AlWhTk94T8e/efqq7Qu/6eP20YjXSRjq5LLW1Ijz1cURz
         +cgIuIfbOfuPWkqJd4zAFfdnPV/ySTlNxvou+miWR4kLPVnU26XOYFGxGhGlmwspWtt2
         7Hxw==
X-Gm-Message-State: ANhLgQ3UOAiXO0DBbVsacKOR6YP32o7Cy0VZsErVLSu3WT9GtiZEGxfh
        OzU+2UF0QiRWnbYT/qhl3GqHPw==
X-Google-Smtp-Source: ADFU+vutW9wcMgq8XcsYi6ed6fYmWNdJav+xgEwmMCzaQkWq+vdQNzNI5NRdeZ0vwh+Ep2om/XgdqA==
X-Received: by 2002:a65:638e:: with SMTP id h14mr3418151pgv.433.1583942055680;
        Wed, 11 Mar 2020 08:54:15 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id a71sm13756265pfa.162.2020.03.11.08.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 08:54:15 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com, alainm@chromium.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH v6 4/5] Bluetooth: Pause discovery and advertising during suspend
Date:   Wed, 11 Mar 2020 08:54:03 -0700
Message-Id: <20200311085359.RFC.v6.4.Iccdad520469ca3524a7e5966c5f88e5bca756e13@changeid>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200311155404.209990-1-abhishekpandit@chromium.org>
References: <20200311155404.209990-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To prevent spurious wake ups, we disable any discovery or advertising
when we enter suspend and restore it when we exit suspend. While paused,
we disable any management requests to modify discovery or advertising.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

Changes in v6:
* Add int old_state to this patch

Changes in v5:
* Changed BT_DBG to bt_dev_dbg

Changes in v4: None
Changes in v3: None
Changes in v2:
* Refactored pause discovery + advertising into its own patch

 include/net/bluetooth/hci_core.h | 11 ++++++++
 net/bluetooth/hci_request.c      | 44 ++++++++++++++++++++++++++++++++
 net/bluetooth/mgmt.c             | 41 +++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 2d58485d0335..d4e28773d378 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -91,6 +91,12 @@ struct discovery_state {
 #define SUSPEND_NOTIFIER_TIMEOUT	msecs_to_jiffies(2000) /* 2 seconds */
 
 enum suspend_tasks {
+	SUSPEND_PAUSE_DISCOVERY,
+	SUSPEND_UNPAUSE_DISCOVERY,
+
+	SUSPEND_PAUSE_ADVERTISING,
+	SUSPEND_UNPAUSE_ADVERTISING,
+
 	SUSPEND_SCAN_DISABLE,
 	SUSPEND_SCAN_ENABLE,
 	SUSPEND_DISCONNECTING,
@@ -410,6 +416,11 @@ struct hci_dev {
 
 	struct discovery_state	discovery;
 
+	int			discovery_old_state;
+	bool			discovery_paused;
+	int			advertising_old_state;
+	bool			advertising_paused;
+
 	struct notifier_block	suspend_notifier;
 	struct work_struct	suspend_prepare;
 	enum suspended_state	suspend_state_next;
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 11624645cfcf..bf83179ab9d1 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1021,6 +1021,7 @@ static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
 /* Call with hci_dev_lock */
 void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 {
+	int old_state;
 	struct hci_conn *conn;
 	struct hci_request req;
 	u8 page_scan;
@@ -1038,6 +1039,28 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		/* Mark device as suspended */
 		hdev->suspended = true;
 
+		/* Pause discovery if not already stopped */
+		old_state = hdev->discovery.state;
+		if (old_state != DISCOVERY_STOPPED) {
+			set_bit(SUSPEND_PAUSE_DISCOVERY, hdev->suspend_tasks);
+			hci_discovery_set_state(hdev, DISCOVERY_STOPPING);
+			queue_work(hdev->req_workqueue, &hdev->discov_update);
+		}
+
+		hdev->discovery_paused = true;
+		hdev->discovery_old_state = old_state;
+
+		/* Stop advertising */
+		old_state = hci_dev_test_flag(hdev, HCI_ADVERTISING);
+		if (old_state) {
+			set_bit(SUSPEND_PAUSE_ADVERTISING, hdev->suspend_tasks);
+			cancel_delayed_work(&hdev->discov_off);
+			queue_delayed_work(hdev->req_workqueue,
+					   &hdev->discov_off, 0);
+		}
+
+		hdev->advertising_paused = true;
+		hdev->advertising_old_state = old_state;
 		/* Disable page scan */
 		page_scan = SCAN_DISABLED;
 		hci_req_add(&req, HCI_OP_WRITE_SCAN_ENABLE, 1, &page_scan);
@@ -1084,6 +1107,27 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		hci_req_clear_event_filter(&req);
 		/* Reset passive/background scanning to normal */
 		hci_req_config_le_suspend_scan(&req);
+
+		/* Unpause advertising */
+		hdev->advertising_paused = false;
+		if (hdev->advertising_old_state) {
+			set_bit(SUSPEND_UNPAUSE_ADVERTISING,
+				hdev->suspend_tasks);
+			hci_dev_set_flag(hdev, HCI_ADVERTISING);
+			queue_work(hdev->req_workqueue,
+				   &hdev->discoverable_update);
+			hdev->advertising_old_state = 0;
+		}
+
+		/* Unpause discovery */
+		hdev->discovery_paused = false;
+		if (hdev->discovery_old_state != DISCOVERY_STOPPED &&
+		    hdev->discovery_old_state != DISCOVERY_STOPPING) {
+			set_bit(SUSPEND_UNPAUSE_DISCOVERY, hdev->suspend_tasks);
+			hci_discovery_set_state(hdev, DISCOVERY_STARTING);
+			queue_work(hdev->req_workqueue, &hdev->discov_update);
+		}
+
 		hci_req_run(&req, suspend_req_complete);
 	}
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index b3a7f387da32..6552003a170e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1390,6 +1390,12 @@ static int set_discoverable(struct sock *sk, struct hci_dev *hdev, void *data,
 		goto failed;
 	}
 
+	if (hdev->advertising_paused) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_DISCOVERABLE,
+				      MGMT_STATUS_BUSY);
+		goto failed;
+	}
+
 	if (!hdev_is_powered(hdev)) {
 		bool changed = false;
 
@@ -3929,6 +3935,13 @@ void mgmt_start_discovery_complete(struct hci_dev *hdev, u8 status)
 	}
 
 	hci_dev_unlock(hdev);
+
+	/* Handle suspend notifier */
+	if (test_and_clear_bit(SUSPEND_UNPAUSE_DISCOVERY,
+			       hdev->suspend_tasks)) {
+		bt_dev_dbg(hdev, "Unpaused discovery");
+		wake_up(&hdev->suspend_wait_q);
+	}
 }
 
 static bool discovery_type_is_valid(struct hci_dev *hdev, uint8_t type,
@@ -3990,6 +4003,13 @@ static int start_discovery_internal(struct sock *sk, struct hci_dev *hdev,
 		goto failed;
 	}
 
+	/* Can't start discovery when it is paused */
+	if (hdev->discovery_paused) {
+		err = mgmt_cmd_complete(sk, hdev->id, op, MGMT_STATUS_BUSY,
+					&cp->type, sizeof(cp->type));
+		goto failed;
+	}
+
 	/* Clear the discovery filter first to free any previously
 	 * allocated memory for the UUID list.
 	 */
@@ -4157,6 +4177,12 @@ void mgmt_stop_discovery_complete(struct hci_dev *hdev, u8 status)
 	}
 
 	hci_dev_unlock(hdev);
+
+	/* Handle suspend notifier */
+	if (test_and_clear_bit(SUSPEND_PAUSE_DISCOVERY, hdev->suspend_tasks)) {
+		bt_dev_dbg(hdev, "Paused discovery");
+		wake_up(&hdev->suspend_wait_q);
+	}
 }
 
 static int stop_discovery(struct sock *sk, struct hci_dev *hdev, void *data,
@@ -4388,6 +4414,17 @@ static void set_advertising_complete(struct hci_dev *hdev, u8 status,
 	if (match.sk)
 		sock_put(match.sk);
 
+	/* Handle suspend notifier */
+	if (test_and_clear_bit(SUSPEND_PAUSE_ADVERTISING,
+			       hdev->suspend_tasks)) {
+		bt_dev_dbg(hdev, "Paused advertising");
+		wake_up(&hdev->suspend_wait_q);
+	} else if (test_and_clear_bit(SUSPEND_UNPAUSE_ADVERTISING,
+				      hdev->suspend_tasks)) {
+		bt_dev_dbg(hdev, "Unpaused advertising");
+		wake_up(&hdev->suspend_wait_q);
+	}
+
 	/* If "Set Advertising" was just disabled and instance advertising was
 	 * set up earlier, then re-enable multi-instance advertising.
 	 */
@@ -4439,6 +4476,10 @@ static int set_advertising(struct sock *sk, struct hci_dev *hdev, void *data,
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTISING,
 				       MGMT_STATUS_INVALID_PARAMS);
 
+	if (hdev->advertising_paused)
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTISING,
+				       MGMT_STATUS_BUSY);
+
 	hci_dev_lock(hdev);
 
 	val = !!cp->val;
-- 
2.25.1.481.gfbce0eb801-goog

