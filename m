Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F3218C41C
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgCTAHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:07:41 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46259 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgCTAHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 20:07:33 -0400
Received: by mail-pg1-f196.google.com with SMTP id k191so1001461pgc.13
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 17:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PQXtrFBK0FlZQNQPvUALv+UR85FSVb3kUvsKXL/U5Nc=;
        b=TEvD6Q64qVYmIQlbmaLjnNAY+7OlBcvgfXNGmoM8H/sSiTi7kDeL1NdArsDpd6XdQP
         UopKYZ+HGb4EiFgFJNZUtac5kGMrZRQpz/m4OuxcwNtKFmoTQbeDusSuIIgC+Gpg1MUt
         +3+VGvMUj5tfzJ/QcW1KuKU/1IEDdJdPTfRQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PQXtrFBK0FlZQNQPvUALv+UR85FSVb3kUvsKXL/U5Nc=;
        b=e+bkJxIJc0nvjtsNRZ6puW84tWu8PYyaUmzUjvfPL7s+Q8IApglRFZ6i1GthdsToWA
         0xQH2Me960eNT8EWDvhFkaHQ/H4er3t8yyNPdhe4dKMMDkb/EA5rH4kWKp8MvIjpseGn
         DSoxcsLW1l/7vG98je2y7cQbs39jJm+RnTwaYhbXq3/WZEkdBszLobqEynS38cdo+SZc
         pLFTORu+sfWQimX++qi41xfWO14NCOv6V817cuyzlEf+BRcgDwZU1vS1K7S/Oh+RrLsn
         yaHLykyvhUd47H/cU6dTyz03Q8mQ70TnFCJccV2XUdXiChPdAJweDCAe7G7OWMPHDsVP
         +XBQ==
X-Gm-Message-State: ANhLgQ2TJfz5s6ReERocEo63JuSqou5eu1AYTKbLkZH/2MUPEH2asTmI
        Y1k+JyDhru3o+bNj0hQYHFKlqA==
X-Google-Smtp-Source: ADFU+vtOCz6ZIdxB66p7W+0Ice1rjK2QrirMgDN1ixu5hAnGyJU2ZhDTWPnn8LAZR5Dj63+UeS+nxw==
X-Received: by 2002:aa7:86ce:: with SMTP id h14mr6580091pfo.311.1584662850242;
        Thu, 19 Mar 2020 17:07:30 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id m12sm2928292pjf.25.2020.03.19.17.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 17:07:29 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/2] Bluetooth: Restore running state if suspend fails
Date:   Thu, 19 Mar 2020 17:07:12 -0700
Message-Id: <20200319170708.1.I83970586f8340022b3909dccac1d79d191c6c70a@changeid>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
In-Reply-To: <20200320000713.32899-1-abhishekpandit@chromium.org>
References: <20200320000713.32899-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If Bluetooth fails to enter the suspended state correctly, restore the
state to running (re-enabling scans). PM_POST_SUSPEND is only sent to
notifiers that successfully return from PM_PREPARE_SUSPEND notification
so we should recover gracefully if it fails.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

 net/bluetooth/hci_core.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index dbd2ad3a26ed..2e7bc2da8371 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3305,6 +3305,15 @@ static void hci_prepare_suspend(struct work_struct *work)
 	hci_dev_unlock(hdev);
 }
 
+static int hci_change_suspend_state(struct hci_dev *hdev,
+				    enum suspended_state next)
+{
+	hdev->suspend_state_next = next;
+	set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
+	queue_work(hdev->req_workqueue, &hdev->suspend_prepare);
+	return hci_suspend_wait_event(hdev);
+}
+
 static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 				void *data)
 {
@@ -3330,32 +3339,24 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 		 *    connectable (disabling scanning)
 		 *  - Second, program event filter/whitelist and enable scan
 		 */
-		hdev->suspend_state_next = BT_SUSPEND_DISCONNECT;
-		set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
-		queue_work(hdev->req_workqueue, &hdev->suspend_prepare);
-		ret = hci_suspend_wait_event(hdev);
+		ret = hci_change_suspend_state(hdev, BT_SUSPEND_DISCONNECT);
 
-		/* If the disconnect portion failed, don't attempt to complete
-		 * by configuring the whitelist. The suspend notifier will
-		 * follow a cancelled suspend with a PM_POST_SUSPEND
-		 * notification.
-		 */
-		if (!ret) {
-			hdev->suspend_state_next = BT_SUSPEND_COMPLETE;
-			set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
-			queue_work(hdev->req_workqueue, &hdev->suspend_prepare);
-			ret = hci_suspend_wait_event(hdev);
-		}
+		/* Only configure whitelist if disconnect succeeded */
+		if (!ret)
+			ret = hci_change_suspend_state(hdev,
+						       BT_SUSPEND_COMPLETE);
 	} else if (action == PM_POST_SUSPEND) {
-		hdev->suspend_state_next = BT_RUNNING;
-		set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
-		queue_work(hdev->req_workqueue, &hdev->suspend_prepare);
-		ret = hci_suspend_wait_event(hdev);
+		ret = hci_change_suspend_state(hdev, BT_RUNNING);
 	}
 
+	/* If suspend failed, restore it to running */
+	if (ret && action == PM_SUSPEND_PREPARE)
+		hci_change_suspend_state(hdev, BT_RUNNING);
+
 done:
 	return ret ? notifier_from_errno(-EBUSY) : NOTIFY_STOP;
 }
+
 /* Alloc HCI device */
 struct hci_dev *hci_alloc_dev(void)
 {
-- 
2.25.1.696.g5e7596f4ac-goog

