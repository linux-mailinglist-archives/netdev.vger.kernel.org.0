Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43FDA14ADCD
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 02:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgA1B7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 20:59:13 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:54554 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbgA1B7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 20:59:01 -0500
Received: by mail-pj1-f65.google.com with SMTP id dw13so299944pjb.4
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 17:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lpOZX+dHz9XxjRDtH5GLorxQ2Si7tonYbZOshKJtM8M=;
        b=fcoQcbFDoN5vbYWDPP9Wp2ic5JaIMTPATUx8ivh8JTvD8b+3c8cJLEyDd22ABwJVOi
         E5abq61sDd8zUEA+sJeWJ2RQEu5qL5oXz5yxCLDoJy1INeOgE6TXeJRIYjo7ZJqrHbZ1
         dQ2a19ezKQtu7wrvIy1PKh7UCYdJqPd4XL8Eo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lpOZX+dHz9XxjRDtH5GLorxQ2Si7tonYbZOshKJtM8M=;
        b=XBgyX905uQc2QR5z+5EqafSplLhzPWsHmQP3bZYYupBInMVUziNQnhFL2a8rZtzmIM
         8KZQCnS/UzUFLGcHlKJ2OVUgddReCuTAGtx6HhhruGbFnVv+IGnzUfK9rsjV/Zyz/9yT
         bOWbESGWm6Lmfu5ECfH6IxE7ebDHGsGJ1cVohPcrtfEBaJfA0gqn1NGaRCCJoe079qyE
         RTsYiWKUgw7yxR4hHsJJ3PkyqgMljVxa3CuDcTKbtPEeAxVVfvsowr13fk/SaNsW/9XH
         ff0OZM30cIdtF2sPcskhenl99565BxWmzOfeZLXrbLKsMQ9Otrv4hFEVlR7ocYVyYjy6
         /Gsw==
X-Gm-Message-State: APjAAAUUE7jzDQ3ztv1jaxUSikhl6U/AEygdNA8S4tysp1aPk3fD7n5U
        AjF2B4vT3qCG3eShK7VhnABolA==
X-Google-Smtp-Source: APXvYqzGkVvPG+VeW5WBWQ7FEUOErqJgtn8CgErajJWirEZi0wGmcm0S7JrkLLuZ+QkcMy0b4dXvZg==
X-Received: by 2002:a17:902:222:: with SMTP id 31mr6454087plc.108.1580176740934;
        Mon, 27 Jan 2020 17:59:00 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id a17sm364153pjv.6.2020.01.27.17.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 17:59:00 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com, alainm@chromium.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH v2 4/4] Bluetooth: Pause discovery and advertising during suspend
Date:   Mon, 27 Jan 2020 17:58:48 -0800
Message-Id: <20200127175842.RFC.v2.4.Iccdad520469ca3524a7e5966c5f88e5bca756e13@changeid>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
In-Reply-To: <20200128015848.226966-1-abhishekpandit@chromium.org>
References: <20200128015848.226966-1-abhishekpandit@chromium.org>
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

Changes in v2:
* Refactored pause discovery + advertising into its own patch

 include/net/bluetooth/hci_core.h | 11 ++++++++
 net/bluetooth/hci_request.c      | 43 ++++++++++++++++++++++++++++++++
 net/bluetooth/mgmt.c             | 41 ++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 49eae4a802ac..cbfaa80067d6 100644
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
 	SUSPEND_LE_SET_SCAN_ENABLE,
 	SUSPEND_DISCONNECTING,
 
@@ -405,6 +411,11 @@ struct hci_dev {
 
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
index c930b9ff1cfd..487c84841351 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1089,6 +1089,29 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 
 	hci_req_init(&req, hdev);
 	if (next == BT_SUSPENDED) {
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
+
 		/* Enable event filter for existing devices */
 		hci_req_set_event_filter(&req);
 
@@ -1120,6 +1143,26 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		/* Reset passive/background scanning to normal */
 		hci_req_enable_le_suspend_scan(&req, 0);
 
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
 		hci_req_run(&req, le_suspend_req_complete);
 	}
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 269ce70e501c..b3bd7a5ae718 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1383,6 +1383,12 @@ static int set_discoverable(struct sock *sk, struct hci_dev *hdev, void *data,
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
 
@@ -3866,6 +3872,13 @@ void mgmt_start_discovery_complete(struct hci_dev *hdev, u8 status)
 	}
 
 	hci_dev_unlock(hdev);
+
+	/* Handle suspend notifier */
+	if (test_and_clear_bit(SUSPEND_UNPAUSE_DISCOVERY,
+			       hdev->suspend_tasks)) {
+		BT_DBG("Unpaused discovery");
+		wake_up(&hdev->suspend_wait_q);
+	}
 }
 
 static bool discovery_type_is_valid(struct hci_dev *hdev, uint8_t type,
@@ -3927,6 +3940,13 @@ static int start_discovery_internal(struct sock *sk, struct hci_dev *hdev,
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
@@ -4094,6 +4114,12 @@ void mgmt_stop_discovery_complete(struct hci_dev *hdev, u8 status)
 	}
 
 	hci_dev_unlock(hdev);
+
+	/* Handle suspend notifier */
+	if (test_and_clear_bit(SUSPEND_PAUSE_DISCOVERY, hdev->suspend_tasks)) {
+		BT_DBG("Paused discovery");
+		wake_up(&hdev->suspend_wait_q);
+	}
 }
 
 static int stop_discovery(struct sock *sk, struct hci_dev *hdev, void *data,
@@ -4325,6 +4351,17 @@ static void set_advertising_complete(struct hci_dev *hdev, u8 status,
 	if (match.sk)
 		sock_put(match.sk);
 
+	/* Handle suspend notifier */
+	if (test_and_clear_bit(SUSPEND_PAUSE_ADVERTISING,
+			       hdev->suspend_tasks)) {
+		BT_DBG("Paused advertising");
+		wake_up(&hdev->suspend_wait_q);
+	} else if (test_and_clear_bit(SUSPEND_UNPAUSE_ADVERTISING,
+				      hdev->suspend_tasks)) {
+		BT_DBG("Unpaused advertising");
+		wake_up(&hdev->suspend_wait_q);
+	}
+
 	/* If "Set Advertising" was just disabled and instance advertising was
 	 * set up earlier, then re-enable multi-instance advertising.
 	 */
@@ -4376,6 +4413,10 @@ static int set_advertising(struct sock *sk, struct hci_dev *hdev, void *data,
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTISING,
 				       MGMT_STATUS_INVALID_PARAMS);
 
+	if (hdev->advertising_paused)
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTISING,
+				       MGMT_STATUS_BUSY);
+
 	hci_dev_lock(hdev);
 
 	val = !!cp->val;
-- 
2.25.0.341.g760bfbb309-goog

