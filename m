Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F099016B62C
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgBYAAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:00:53 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39359 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbgBYAAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:00:50 -0500
Received: by mail-pj1-f65.google.com with SMTP id e9so470463pjr.4
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 16:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Um7WHOq7oL5BVx9ef4KzYXbuCI2F7lnanA46u13kxmc=;
        b=kRrwaphC58E38cqB5LNH0sgRf1ij9PWALl3QAH2ukpR5WJs/3M5veVc9Nr6ri0lFsA
         0BS0dswuppwNLRyw6hEBqx1tSuQMJWCY/3HGwMJ/RHGjC7e8w0SA4NdALO1eSzcTZJW5
         VgK+aCryTDc3WEJU7Rw0l3PwPExF+qIGm2NBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Um7WHOq7oL5BVx9ef4KzYXbuCI2F7lnanA46u13kxmc=;
        b=TsXHKXVsDVCxn3Coa1JBIXS+uLvd0desPck1/G7ACoNT1o4m/rr9/GfmVUIUPJeaSF
         CL9jTdLXmYb8IPpC0h8CtB62/K5SCwCpNIT741cN8/UuORVNa4OffmgwDkSeiVZfJF4a
         aXX0Dlbp/LYCrBVZbxkJaEWYLF1zmMrQ8i947lEvXsWufGQeAActmfK61be0eVQsjBhP
         1xbLBZ1amImelT1oCzIN6C98nUqV372bU8cRl6Hw/aX2khmmzdE5yPVf7KLOT2e2z8ZN
         uLO+rLmtw4dm8okrPiEqdBmnfgeEPWzPv7LRh/cxqhzJ/HWECDvTpJ/glap24WIdoQb/
         /nqg==
X-Gm-Message-State: APjAAAVHBHmTG/2KvXayjbdUhxvuN/a0F8+gZxP2g2T0rpvMUa+HDEuY
        Qk3Q98XHResWb/DTP7drQMbhrQ==
X-Google-Smtp-Source: APXvYqwtq0+XJEvBPN5FsKCYE1xi/p/7DfSAUUaxn0Z/X4xOZVCnAT1fSbzjFBPZgoeMsQFTtxRHEA==
X-Received: by 2002:a17:90a:a409:: with SMTP id y9mr1803111pjp.119.1582588849314;
        Mon, 24 Feb 2020 16:00:49 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id c188sm14477657pfb.151.2020.02.24.16.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 16:00:48 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com, alainm@chromium.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH v3 2/5] Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND
Date:   Mon, 24 Feb 2020 16:00:33 -0800
Message-Id: <20200224160019.RFC.v3.2.I62f17edc39370044c75ad43a55a7382b4b8a5ceb@changeid>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
In-Reply-To: <20200225000036.156250-1-abhishekpandit@chromium.org>
References: <20200225000036.156250-1-abhishekpandit@chromium.org>
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

Changes in v3: None
Changes in v2:
* Moved pm notifier registration into its own patch and moved params out
  of separate suspend_state

 include/net/bluetooth/hci_core.h | 21 ++++++++++
 net/bluetooth/hci_core.c         | 70 ++++++++++++++++++++++++++++++++
 net/bluetooth/hci_request.c      | 19 +++++++++
 net/bluetooth/hci_request.h      |  2 +
 4 files changed, 112 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 9d9ada5bc9d4..bc9620e5b65b 100644
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
2.25.0.265.gbab2e86ba0-goog

