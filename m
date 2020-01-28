Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232C614ADCF
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 02:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgA1B7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 20:59:17 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39973 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgA1B67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 20:58:59 -0500
Received: by mail-pf1-f196.google.com with SMTP id q8so5810670pfh.7
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 17:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HKsS8qF05DpfZ/OvNtTJkkeAgQW+Ixfc27KHvW3AT9U=;
        b=O72QWJxi2ZgaKY2GMQxX4LLxr1PU3ARd6gB+LGofhADsgwwJBS4kSQRYv4IBLayLtv
         6SrKbQ86frya8w3wQcYE/5sYR8uJNZEREuML+E+LDgTcWwY52R98oMgaTWGXrxnq6qnk
         NANAmc1R+dgxtDa1K4sAt9Whk3c3PZm+crFc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HKsS8qF05DpfZ/OvNtTJkkeAgQW+Ixfc27KHvW3AT9U=;
        b=MADuK2H76twgfqcp/eGgAt5G0cpMw98Af7zMHRzQow6hu9jhH69rh6PkUFk+nf05f6
         1zlBRHhkTZl53ZzptWpcyctqxaGZWnhTlHkD9DDZRIi4WByux2h1ZFZsLUoDt6IHZtVD
         EjnMYcIPMT0cF0vTvi0q63VB2zLl7bzLj+9voWcB0o8AaEVtqBDPndu7EAroTQpZdcts
         dWDL/QX+IL5EWNwMkgq0hoUwTuQMn3kAeNWhXlAv5w5KsBaD+VXWo+rNCu9t5La/wO57
         rr84QtIZ70by0/BS+Zn+lieLvq9NSIfNBiekBbXIoc6j5li3aMRY3AKbIhSmeB5VYBk/
         bRYw==
X-Gm-Message-State: APjAAAU+p8iYfW6iDnMWMqCRn8Kt+BOJiLHQpM/NaADUf6veegse961g
        JQ5mXs0eo0CE6bwm41Ix+LwHSzZVGZMejA==
X-Google-Smtp-Source: APXvYqxGkrOAfiBxFvxG8X97U6yS4/cdg9lZ7y7ewsWYU+hQV/cQnzUeWzvDWI1N9NS0m291XTzyvA==
X-Received: by 2002:a65:68c8:: with SMTP id k8mr22660195pgt.216.1580176738597;
        Mon, 27 Jan 2020 17:58:58 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id a17sm364153pjv.6.2020.01.27.17.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 17:58:58 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com, alainm@chromium.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH v2 2/4] Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND
Date:   Mon, 27 Jan 2020 17:58:46 -0800
Message-Id: <20200127175842.RFC.v2.2.I62f17edc39370044c75ad43a55a7382b4b8a5ceb@changeid>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
In-Reply-To: <20200128015848.226966-1-abhishekpandit@chromium.org>
References: <20200128015848.226966-1-abhishekpandit@chromium.org>
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

Changes in v2:
* Moved pm notifier registration into its own patch and moved params out
  of separate suspend_state

 include/net/bluetooth/hci_core.h | 21 ++++++++++
 net/bluetooth/hci_core.c         | 70 ++++++++++++++++++++++++++++++++
 net/bluetooth/hci_request.c      | 19 +++++++++
 net/bluetooth/hci_request.h      |  2 +
 4 files changed, 112 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index ce4bebcb0265..74d703e46fb4 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -88,6 +88,18 @@ struct discovery_state {
 	unsigned long		scan_duration;
 };
 
+#define SUSPEND_NOTIFIER_TIMEOUT	msecs_to_jiffies(2000) /* 2 seconds */
+
+enum suspend_tasks {
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
@@ -389,6 +401,15 @@ struct hci_dev {
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
index 2fceaf76644a..6ca0aa8d30dd 100644
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
@@ -3241,6 +3243,65 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
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
+		BT_DBG("Timed out waiting for suspend");
+		for (i = 0; i < __SUSPEND_NUM_TASKS; ++i) {
+			if (test_bit(i, hdev->suspend_tasks))
+				BT_DBG("Bit %d is set", i);
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
+	return ret ? notifier_from_errno(-EBUSY) : NOTIFY_STOP;
+}
 /* Alloc HCI device */
 struct hci_dev *hci_alloc_dev(void)
 {
@@ -3319,6 +3380,7 @@ struct hci_dev *hci_alloc_dev(void)
 	INIT_WORK(&hdev->tx_work, hci_tx_work);
 	INIT_WORK(&hdev->power_on, hci_power_on);
 	INIT_WORK(&hdev->error_reset, hci_error_reset);
+	INIT_WORK(&hdev->suspend_prepare, hci_prepare_suspend);
 
 	INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
 
@@ -3327,6 +3389,7 @@ struct hci_dev *hci_alloc_dev(void)
 	skb_queue_head_init(&hdev->raw_q);
 
 	init_waitqueue_head(&hdev->req_wait_q);
+	init_waitqueue_head(&hdev->suspend_wait_q);
 
 	INIT_DELAYED_WORK(&hdev->cmd_timer, hci_cmd_timeout);
 
@@ -3438,6 +3501,11 @@ int hci_register_dev(struct hci_dev *hdev)
 	hci_sock_dev_event(hdev, HCI_DEV_REG);
 	hci_dev_hold(hdev);
 
+	hdev->suspend_notifier.notifier_call = hci_suspend_notifier;
+	error = register_pm_notifier(&hdev->suspend_notifier);
+	if (error)
+		goto err_wqueue;
+
 	queue_work(hdev->req_workqueue, &hdev->power_on);
 
 	return id;
@@ -3471,6 +3539,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 
 	hci_dev_do_close(hdev);
 
+	unregister_pm_notifier(&hdev->suspend_notifier);
+
 	if (!test_bit(HCI_INIT, &hdev->flags) &&
 	    !hci_dev_test_flag(hdev, HCI_SETUP) &&
 	    !hci_dev_test_flag(hdev, HCI_CONFIG)) {
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 2a1b64dbf76e..08908469c043 100644
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
+		BT_DBG("Same state before and after: %d", next);
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
2.25.0.341.g760bfbb309-goog

