Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A21F53BEA6
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 21:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbiFBTUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 15:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238474AbiFBTUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 15:20:31 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE12E03C;
        Thu,  2 Jun 2022 12:20:29 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id i201so136759ioa.6;
        Thu, 02 Jun 2022 12:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DhDehDv+zyKXYiYJM+Nr2lBfUGVAiGOwaQ4CdscP8uc=;
        b=i6TBiLZqe1oL9IOPeyZnjGYZJr8DmUWKj0v+gQQ6DA09+Z4bdSxO5gnHvBvV4G/oKU
         SP92cYH0eoFfKI/JN3rl6w/ZBC6pp1w+2CgYQD/inO+pMg1A758xwIfddTDNA4kTbuh8
         ry2+IwjCHg1GHYog+/ik1YvxmDPyntKKBJAGnN1EkPMIlJaehh0QfPJX0B84+0NdmTzY
         YfFkl9ShyqIWE6Uc/CfHtnXqsNLakhOkxAthrE8qg8T9A6iUDILjEI4NiqEAVkbXny6i
         KMeAZ/n++zZgZy+iqIn6SeuKAwCk5P4+BXP0m6e3sXfjwUWMbjt+7xjAU1hEWIhEE3Uk
         tPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DhDehDv+zyKXYiYJM+Nr2lBfUGVAiGOwaQ4CdscP8uc=;
        b=6M4SwfsoyIgc0rj0N9vR2D76M3JsDWB0MVewHZGjWSKJOU7dm7Y/mf67ZZzFd4/sqw
         4/forC6WWNKezNQGzDqn51kiDK5wmbLiJDt5lIoSkM57D7p2tbx+Bzk5yayYzQrFtZG4
         fAcCGb2YhdtkSrw13EB36Uxw4mloh77PQ/YXEfYyUd8N/dnvxCg9KY04Z6ZAXIWcOw68
         QiY1vPjgnATSVWrFJR7mlDkB6kgoPLOWBcznYjfqzgSmoZ7KLnL7An5eIK3dBHdwJaW/
         CPN1sKdHBBNdzmOHLm6tb+3wsMZrcg5MPwiWt7RNZuAvmnauUNun4QsTy5xstH431am4
         +Lqg==
X-Gm-Message-State: AOAM531oifDhfYdAxIQD+vijapCn43vSlEfNY9gb2C/gwX9x/sDH9uw8
        9BgHfec5DfB68jLtvpy16chI9Ytb8V5jjIEz
X-Google-Smtp-Source: ABdhPJxRhNoGFVFaxtC2dKLeNxK3hXDGM7nCKmJbcMVmpnweuzmYFrp+rEMsJHj2M60bFJsIxtjqDA==
X-Received: by 2002:a02:90ce:0:b0:32e:e2ce:b17c with SMTP id c14-20020a0290ce000000b0032ee2ceb17cmr4037064jag.268.1654197628758;
        Thu, 02 Jun 2022 12:20:28 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-59-0-164.us-east-2.compute.amazonaws.com. [13.59.0.164])
        by smtp.gmail.com with ESMTPSA id n18-20020a02a192000000b0032b3a7817dbsm1575609jah.159.2022.06.02.12.20.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jun 2022 12:20:28 -0700 (PDT)
From:   Schspa Shi <schspa@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        syzbot+63bed493aebbf6872647@syzkaller.appspotmail.com
Subject: [PATCH v2] Bluetooth: When HCI work queue is drained, only queue chained work
Date:   Fri,  3 Jun 2022 03:19:49 +0800
Message-Id: <20220602191949.31311-1-schspa@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HCI command, event, and data packet processing workqueue is drained
to avoid deadlock in commit
76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state").

There is another delayed work, which will queue command to this drained
workqueue. Which results in the following error report:

Bluetooth: hci2: command 0x040f tx timeout
WARNING: CPU: 1 PID: 18374 at kernel/workqueue.c:1438 __queue_work+0xdad/0x1140
Workqueue: events hci_cmd_timeout
RIP: 0010:__queue_work+0xdad/0x1140
RSP: 0000:ffffc90002cffc60 EFLAGS: 00010093
RAX: 0000000000000000 RBX: ffff8880b9d3ec00 RCX: 0000000000000000
RDX: ffff888024ba0000 RSI: ffffffff814e048d RDI: ffff8880b9d3ec08
RBP: 0000000000000008 R08: 0000000000000000 R09: 00000000b9d39700
R10: ffffffff814f73c6 R11: 0000000000000000 R12: ffff88807cce4c60
R13: 0000000000000000 R14: ffff8880796d8800 R15: ffff8880796d8800
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c0174b4000 CR3: 000000007cae9000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ? queue_work_on+0xcb/0x110
 ? lockdep_hardirqs_off+0x90/0xd0
 queue_work_on+0xee/0x110
 process_one_work+0x996/0x1610
 ? pwq_dec_nr_in_flight+0x2a0/0x2a0
 ? rwlock_bug.part.0+0x90/0x90
 ? _raw_spin_lock_irq+0x41/0x50
 worker_thread+0x665/0x1080
 ? process_one_work+0x1610/0x1610
 kthread+0x2e9/0x3a0
 ? kthread_complete_and_exit+0x40/0x40
 ret_from_fork+0x1f/0x30
 </TASK>

To fix this, we can add a new HCI_DRAIN_WQ flag, and don't queue the
timeout workqueue while command workqueue is draining.

Fixes: 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state")
Reported-by: syzbot+63bed493aebbf6872647@syzkaller.appspotmail.com
Signed-off-by: Schspa Shi <schspa@gmail.com>

Changelog:
v1 -> v2:
        - Move the workqueue drain flag to controller flags, and use hci_dev_*_flag.
        - Add missing ncmd_timer cancel.
        - Clear DRAIN_WORKQUEUE flag after device command flushed.
---
 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_core.c    | 10 +++++++++-
 net/bluetooth/hci_event.c   |  5 +++--
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index fe7935be7dc4..4a45c48eb0d2 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -361,6 +361,7 @@ enum {
 	HCI_QUALITY_REPORT,
 	HCI_OFFLOAD_CODECS_ENABLED,
 	HCI_LE_SIMULTANEOUS_ROLES,
+	HCI_CMD_DRAIN_WORKQUEUE,
 
 	__HCI_NUM_FLAGS,
 };
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 5abb2ca5b129..e908fdc4625c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -593,6 +593,11 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
 	skb_queue_purge(&hdev->rx_q);
 	skb_queue_purge(&hdev->cmd_q);
 
+	/* Cancel these not cahined pending work */
+	hci_dev_set_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
+	cancel_delayed_work(&hdev->cmd_timer);
+	cancel_delayed_work(&hdev->ncmd_timer);
+
 	/* Avoid potential lockdep warnings from the *_flush() calls by
 	 * ensuring the workqueue is empty up front.
 	 */
@@ -606,6 +611,8 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
 	if (hdev->flush)
 		hdev->flush(hdev);
 
+	hci_dev_clear_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
+
 	atomic_set(&hdev->cmd_cnt, 1);
 	hdev->acl_cnt = 0; hdev->sco_cnt = 0; hdev->le_cnt = 0;
 
@@ -3861,7 +3868,8 @@ static void hci_cmd_work(struct work_struct *work)
 			if (res < 0)
 				__hci_cmd_sync_cancel(hdev, -res);
 
-			if (test_bit(HCI_RESET, &hdev->flags))
+			if (test_bit(HCI_RESET, &hdev->flags) ||
+			    hci_dev_test_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE))
 				cancel_delayed_work(&hdev->cmd_timer);
 			else
 				schedule_delayed_work(&hdev->cmd_timer,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index af17dfb20e01..7cb956d3abb2 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3768,8 +3768,9 @@ static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev, u8 ncmd)
 			cancel_delayed_work(&hdev->ncmd_timer);
 			atomic_set(&hdev->cmd_cnt, 1);
 		} else {
-			schedule_delayed_work(&hdev->ncmd_timer,
-					      HCI_NCMD_TIMEOUT);
+			if (!hci_dev_test_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE))
+				schedule_delayed_work(&hdev->ncmd_timer,
+						      HCI_NCMD_TIMEOUT);
 		}
 	}
 }
-- 
2.24.3 (Apple Git-128)

