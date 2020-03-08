Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C572A17D640
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 22:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgCHVXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 17:23:54 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37739 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgCHVXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 17:23:54 -0400
Received: by mail-pl1-f193.google.com with SMTP id f16so1008007plj.4
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 14:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9XlkxJqMSEN09ZZELF811t7c5hOmARzjciwzs1E88LE=;
        b=kVSxcbpvC5j1O+i5Pz+BeJtUf1uNat51sxWU1W+eXwVZQXHlQ96daxSa8d6wVQjfPX
         z3yC8i/gZjWjhQajl6EiMOrlqMn5cHd1Vo6SzqrhYLyStHxp7FzzIbWgraXwR+tRjeyu
         EqJTXQgvMjfr6NTXv7T2q6J1ceNA5gCQOaqoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9XlkxJqMSEN09ZZELF811t7c5hOmARzjciwzs1E88LE=;
        b=fJ9RLBvsjbN+/EBgTdZlmY6IW1S8Wyk8WYpsVE34fHVt/1YqW0RpXvABaZeOzKIG77
         471ZnOobj4VzavQvj9VOOw4SauTIfT76tEb+JOdJtGTzBZwfbIhI9bfRQex9v2Ol+piU
         6kQjzfk5fSPwo1bb+lbHsu+tGYb8OAJ/46fkHLvVL7sJTVlEx0B4pzQBd9je4AK7gt52
         vt2usKaFvRdBuopTnO6hznV4vLiLWfVcDRDxtfL4xo14306wZkXuj/LgRuuM67a7gjxv
         maisllIBqPVhg/K9ai3+IjGWz5MBrJRZiXaUtNJSLCJ5yLDEgG1hflJr8hQwmVl6Chs9
         lmEg==
X-Gm-Message-State: ANhLgQ3Ch8KhAvgeU9+GTonDZIYc+EZOKaK2cmXwJkO+fI4+HaaT6JiW
        KoocxtFoEDdv2AGoMMzWfx9X4w==
X-Google-Smtp-Source: ADFU+vuHaevFDIOLmeO47QqA6pLXaJ8Ay9B8Ax5pLbxoNARoXRUO2ifBThBpuk5h6B+RxA1c5E200w==
X-Received: by 2002:a17:902:8d93:: with SMTP id v19mr13257547plo.327.1583702631400;
        Sun, 08 Mar 2020 14:23:51 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id k1sm39509228pgt.70.2020.03.08.14.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2020 14:23:50 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com, alainm@chromium.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH v5 1/5] Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND
Date:   Sun,  8 Mar 2020 14:23:30 -0700
Message-Id: <20200308142005.RFC.v5.1.I62f17edc39370044c75ad43a55a7382b4b8a5ceb@changeid>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200308212334.213841-1-abhishekpandit@chromium.org>
References: <20200308212334.213841-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register for PM_SUSPEND_PREPARE and PM_POST_SUSPEND to make sure the
Bluetooth controller is prepared correctly for suspend/resume. Implement
the registration, scheduling and task handling portions only in this
patch.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

Changes in v5:
* Convert BT_DBG to bt_dev_dbg

Changes in v4:
* Added check for mgmt_powering_down and hdev_is_powered in notifier

Changes in v3: None
Changes in v2:
* Moved pm notifier registration into its own patch and moved params out
  of separate suspend_state

 include/net/bluetooth/hci_core.h | 23 +++++++++
 net/bluetooth/hci_core.c         | 86 ++++++++++++++++++++++++++++++++
 net/bluetooth/hci_request.c      | 19 +++++++
 net/bluetooth/hci_request.h      |  2 +
 4 files changed, 130 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index c498ac113930..d6f694b436bf 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -88,6 +88,20 @@ struct discovery_state {
 	unsigned long		scan_duration;
 };
 
+#define SUSPEND_NOTIFIER_TIMEOUT	msecs_to_jiffies(2000) /* 2 seconds */
+
+enum suspend_tasks {
+	SUSPEND_POWERING_DOWN,
+
+	SUSPEND_PREPARE_NOTIFIER,
+	__SUSPEND_NUM_TASKS
+};
+
+enum suspended_state {
+	BT_RUNNING = 0,
+	BT_SUSPENDED,
+};
+
 struct hci_conn_hash {
 	struct list_head list;
 	unsigned int     acl_num;
@@ -390,6 +404,15 @@ struct hci_dev {
 	void			*smp_bredr_data;
 
 	struct discovery_state	discovery;
+
+	struct notifier_block	suspend_notifier;
+	struct work_struct	suspend_prepare;
+	enum suspended_state	suspend_state_next;
+	enum suspended_state	suspend_state;
+
+	wait_queue_head_t	suspend_wait_q;
+	DECLARE_BITMAP(suspend_tasks, __SUSPEND_NUM_TASKS);
+
 	struct hci_conn_hash	conn_hash;
 
 	struct list_head	mgmt_pending;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 9ce98762559b..2286b556c69e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -31,6 +31,8 @@
 #include <linux/debugfs.h>
 #include <linux/crypto.h>
 #include <linux/property.h>
+#include <linux/suspend.h>
+#include <linux/wait.h>
 #include <asm/unaligned.h>
 
 #include <net/bluetooth/bluetooth.h>
@@ -1787,6 +1789,9 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	clear_bit(HCI_RUNNING, &hdev->flags);
 	hci_sock_dev_event(hdev, HCI_DEV_CLOSE);
 
+	if (test_and_clear_bit(SUSPEND_POWERING_DOWN, hdev->suspend_tasks))
+		wake_up(&hdev->suspend_wait_q);
+
 	/* After this point our queues are empty
 	 * and no tasks are scheduled. */
 	hdev->close(hdev);
@@ -3264,6 +3269,78 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	}
 }
 
+static int hci_suspend_wait_event(struct hci_dev *hdev)
+{
+#define WAKE_COND                                                              \
+	(find_first_bit(hdev->suspend_tasks, __SUSPEND_NUM_TASKS) ==           \
+	 __SUSPEND_NUM_TASKS)
+
+	int i;
+	int ret = wait_event_timeout(hdev->suspend_wait_q,
+				     WAKE_COND, SUSPEND_NOTIFIER_TIMEOUT);
+
+	if (ret == 0) {
+		bt_dev_dbg(hdev, "Timed out waiting for suspend");
+		for (i = 0; i < __SUSPEND_NUM_TASKS; ++i) {
+			if (test_bit(i, hdev->suspend_tasks))
+				bt_dev_dbg(hdev, "Bit %d is set", i);
+			clear_bit(i, hdev->suspend_tasks);
+		}
+
+		ret = -ETIMEDOUT;
+	} else {
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static void hci_prepare_suspend(struct work_struct *work)
+{
+	struct hci_dev *hdev =
+		container_of(work, struct hci_dev, suspend_prepare);
+
+	hci_dev_lock(hdev);
+	hci_req_prepare_suspend(hdev, hdev->suspend_state_next);
+	hci_dev_unlock(hdev);
+}
+
+static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
+				void *data)
+{
+	struct hci_dev *hdev =
+		container_of(nb, struct hci_dev, suspend_notifier);
+	int ret = 0;
+
+	/* If powering down, wait for completion. */
+	if (mgmt_powering_down(hdev)) {
+		set_bit(SUSPEND_POWERING_DOWN, hdev->suspend_tasks);
+		ret = hci_suspend_wait_event(hdev);
+		if (ret)
+			goto done;
+	}
+
+	/* Suspend notifier should only act on events when powered. */
+	if (!hdev_is_powered(hdev))
+		goto done;
+
+	if (action == PM_SUSPEND_PREPARE) {
+		hdev->suspend_state_next = BT_SUSPENDED;
+		set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
+		queue_work(hdev->req_workqueue, &hdev->suspend_prepare);
+
+		ret = hci_suspend_wait_event(hdev);
+	} else if (action == PM_POST_SUSPEND) {
+		hdev->suspend_state_next = BT_RUNNING;
+		set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
+		queue_work(hdev->req_workqueue, &hdev->suspend_prepare);
+
+		ret = hci_suspend_wait_event(hdev);
+	}
+
+done:
+	return ret ? notifier_from_errno(-EBUSY) : NOTIFY_STOP;
+}
 /* Alloc HCI device */
 struct hci_dev *hci_alloc_dev(void)
 {
@@ -3341,6 +3418,7 @@ struct hci_dev *hci_alloc_dev(void)
 	INIT_WORK(&hdev->tx_work, hci_tx_work);
 	INIT_WORK(&hdev->power_on, hci_power_on);
 	INIT_WORK(&hdev->error_reset, hci_error_reset);
+	INIT_WORK(&hdev->suspend_prepare, hci_prepare_suspend);
 
 	INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
 
@@ -3349,6 +3427,7 @@ struct hci_dev *hci_alloc_dev(void)
 	skb_queue_head_init(&hdev->raw_q);
 
 	init_waitqueue_head(&hdev->req_wait_q);
+	init_waitqueue_head(&hdev->suspend_wait_q);
 
 	INIT_DELAYED_WORK(&hdev->cmd_timer, hci_cmd_timeout);
 
@@ -3460,6 +3539,11 @@ int hci_register_dev(struct hci_dev *hdev)
 	hci_sock_dev_event(hdev, HCI_DEV_REG);
 	hci_dev_hold(hdev);
 
+	hdev->suspend_notifier.notifier_call = hci_suspend_notifier;
+	error = register_pm_notifier(&hdev->suspend_notifier);
+	if (error)
+		goto err_wqueue;
+
 	queue_work(hdev->req_workqueue, &hdev->power_on);
 
 	return id;
@@ -3493,6 +3577,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 
 	hci_dev_do_close(hdev);
 
+	unregister_pm_notifier(&hdev->suspend_notifier);
+
 	if (!test_bit(HCI_INIT, &hdev->flags) &&
 	    !hci_dev_test_flag(hdev, HCI_SETUP) &&
 	    !hci_dev_test_flag(hdev, HCI_CONFIG)) {
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 2a1b64dbf76e..1c5a76df1ded 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -918,6 +918,25 @@ static u8 get_adv_instance_scan_rsp_len(struct hci_dev *hdev, u8 instance)
 	return adv_instance->scan_rsp_len;
 }
 
+/* Call with hci_dev_lock */
+void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
+{
+	int old_state;
+	struct hci_conn *conn;
+	struct hci_request req;
+
+	if (next == hdev->suspend_state) {
+		bt_dev_dbg(hdev, "Same state before and after: %d", next);
+		goto done;
+	}
+
+	hdev->suspend_state = next;
+
+done:
+	clear_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
+	wake_up(&hdev->suspend_wait_q);
+}
+
 static u8 get_cur_adv_instance_scan_rsp_len(struct hci_dev *hdev)
 {
 	u8 instance = hdev->cur_adv_instance;
diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
index a7019fbeadd3..0e81614d235e 100644
--- a/net/bluetooth/hci_request.h
+++ b/net/bluetooth/hci_request.h
@@ -68,6 +68,8 @@ void __hci_req_update_eir(struct hci_request *req);
 void hci_req_add_le_scan_disable(struct hci_request *req);
 void hci_req_add_le_passive_scan(struct hci_request *req);
 
+void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next);
+
 void hci_req_reenable_advertising(struct hci_dev *hdev);
 void __hci_req_enable_advertising(struct hci_request *req);
 void __hci_req_disable_advertising(struct hci_request *req);
-- 
2.25.1.481.gfbce0eb801-goog

