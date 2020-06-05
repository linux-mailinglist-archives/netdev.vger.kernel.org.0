Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102F31EF092
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 06:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgFEE3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 00:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgFEE3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 00:29:00 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4DCC08C5C1
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 21:28:58 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q24so2194700pjd.1
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 21:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iR4VqTS2EXdW82BaNRGhQ3j0kiUhB8MOVYBA8SqjWtM=;
        b=GglctBBjQUAAk/bc1+7mPFWpkcziV5Aq2oYrhkBd0Q3yOtOzkvGxsJzgyC5XqmNwx3
         Y7nZYBsY3ko21cxMFnLpWj4lWmPERhVu5u3atotCjgUkgYpEr6AE3M0DQQbMLBPeN80f
         EVhK/VGaOjXsdpaDCCUD3qgR2W/NsZu20jcdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iR4VqTS2EXdW82BaNRGhQ3j0kiUhB8MOVYBA8SqjWtM=;
        b=a390iQs3yHo8gVS1kiiNmHHGzBNOfAVppSUIqA5UlUqPh107+NgtRixjA8vLQxOLqU
         ZADzNttjogMZqrLJGVVltDq2es4wdAOhi/yvojyQ8he8yKYVUWVCulcyDffCskBC+PHy
         DEnmlTn5FnqR8A3IjXQuWwIHB+wfCyTaOCDLgrf6xhUERsOxiReP3GhnxdrkRFkw1aqa
         k+JIF9c+CFwK7+JzY2Gqmr1EvWAcJe9XB/Sa5qyrvTM1ykhlYb3+h6x+4MKQYsIi+G6t
         zCdFCHFN7YqlRIpjmogHzThjP1n70QJL+5RwIGNwMAYGG39KWyO+jxLlivsgQK48+wQN
         I8rQ==
X-Gm-Message-State: AOAM530Jf5vy6eGQIeNOuWWQwZpwwlxgfQZKcKoTAeR0OW7hKKDy8Yd9
        aPLDs7On7VLEGm40uEGKejXjFg==
X-Google-Smtp-Source: ABdhPJx1VMDcMi0/N7mvHzWvVFSJxRkPEio6Bfmea2ChvhgLtvq0jgqSVywNQc2r0Mrblr3i0vyIjA==
X-Received: by 2002:a17:90a:cf17:: with SMTP id h23mr816932pju.139.1591331338098;
        Thu, 04 Jun 2020 21:28:58 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id z20sm6793906pjn.53.2020.06.04.21.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 21:28:57 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     len.brown@intel.com, chromeos-bluetooth-upstreaming@chromium.org,
        linux-pm@vger.kernel.org, rafael@kernel.org,
        todd.e.brandt@linux.intel.com, rui.zhang@intel.com,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2] Bluetooth: Allow suspend even when preparation has failed
Date:   Thu,  4 Jun 2020 21:28:50 -0700
Message-Id: <20200604212842.v2.1.I0ec31d716619532fc007eac081e827a204ba03de@changeid>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is preferable to allow suspend even when Bluetooth has problems
preparing for sleep. When Bluetooth fails to finish preparing for
suspend, log the error and allow the suspend notifier to continue
instead.

To also make it clearer why suspend failed, change bt_dev_dbg to
bt_dev_err when handling the suspend timeout.

Fixes: dd522a7429b07e ("Bluetooth: Handle LE devices during suspend")
Reported-by: Len Brown <len.brown@intel.com>
Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---
To verify this is properly working, I added an additional change to
hci_suspend_wait_event to always return -16. This validates that suspend
continues even when an error has occurred during the suspend
preparation.

Example on Chromebook:
[   55.834524] PM: Syncing filesystems ... done.
[   55.841930] PM: Preparing system for sleep (s2idle)
[   55.940492] Bluetooth: hci_core.c:hci_suspend_notifier() hci0: Suspend notifier action (3) failed: -16
[   55.940497] Freezing user space processes ... (elapsed 0.001 seconds) done.
[   55.941692] OOM killer disabled.
[   55.941693] Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
[   55.942632] PM: Suspending system (s2idle)

I ran this through a suspend_stress_test in the following scenarios:
* Peer classic device connected: 50+ suspends
* No devices connected: 100 suspends
* With the above test case returning -EBUSY: 50 suspends

I also ran this through our automated testing for suspend and wake on
BT from suspend continues to work.


Changes in v2:
- Added fixes and reported-by tags

 net/bluetooth/hci_core.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index dbe2d79f233fba..54da48441423e0 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3289,10 +3289,10 @@ static int hci_suspend_wait_event(struct hci_dev *hdev)
 				     WAKE_COND, SUSPEND_NOTIFIER_TIMEOUT);
 
 	if (ret == 0) {
-		bt_dev_dbg(hdev, "Timed out waiting for suspend");
+		bt_dev_err(hdev, "Timed out waiting for suspend events");
 		for (i = 0; i < __SUSPEND_NUM_TASKS; ++i) {
 			if (test_bit(i, hdev->suspend_tasks))
-				bt_dev_dbg(hdev, "Bit %d is set", i);
+				bt_dev_err(hdev, "Suspend timeout bit: %d", i);
 			clear_bit(i, hdev->suspend_tasks);
 		}
 
@@ -3360,12 +3360,15 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 		ret = hci_change_suspend_state(hdev, BT_RUNNING);
 	}
 
-	/* If suspend failed, restore it to running */
-	if (ret && action == PM_SUSPEND_PREPARE)
-		hci_change_suspend_state(hdev, BT_RUNNING);
-
 done:
-	return ret ? notifier_from_errno(-EBUSY) : NOTIFY_STOP;
+	/* We always allow suspend even if suspend preparation failed and
+	 * attempt to recover in resume.
+	 */
+	if (ret)
+		bt_dev_err(hdev, "Suspend notifier action (%x) failed: %d",
+			   action, ret);
+
+	return NOTIFY_STOP;
 }
 
 /* Alloc HCI device */
-- 
2.27.0.278.ge193c7cf3a9-goog

