Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D3C539662
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 20:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347074AbiEaSlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 14:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiEaSlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 14:41:35 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3833915A5;
        Tue, 31 May 2022 11:41:34 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id 62so6675304iov.4;
        Tue, 31 May 2022 11:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kqe9evV1atpm/M/tjKb2Y4GxU1Je7w96xyTQRQy2Xg=;
        b=hFoAo92Gjz68ERtH/X4rx7PSLu0QIVkWfERaSZoghbjarCTL+k/It6KbTXOj2bufO8
         LhPBqdr06i5aoKTbTrVHML8QqYvvwIVPK9OHhe3155O0b9F4funK96ZcOjP1zr+uXjGo
         HTdagdDoVUj4eOxWJPMauajNPdMygGUrsqK7GAKs7eMJwnudQnew6Fzg4GilxmTrXl+m
         ExhDv9UZFA3omqXso69vT2LXpWTxg+GvjnaprEmqSyyAzG4dOHOZhpiDPVIGkI8EpbdW
         Y17mkDNLkHRax0IsUDo4vw+qlkdUXzRxySjj4GdMxyCM48buZLD5CaFOP7eAjkCEbCrB
         ZHPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kqe9evV1atpm/M/tjKb2Y4GxU1Je7w96xyTQRQy2Xg=;
        b=qOdn7BwCWoyQs3FHlsQB1Xucsq6TGx6CCI4wIV97yFcop9mWQiby8AXe+RtWtn1qO6
         JCzmWItIwDZhALAfezoocI6dxKs6/OH8mL8V5327n5Df5Z7mPSA/e3wB2frC2WcdMG+T
         EATmeuV0sbrX80TWCsnvStTKRGgD2urc1kn35rcC/BnR4hutDUCqA1m+/6PkJ6GfqpU/
         RxUxiZ95p4mWENl1mdkmJpqPDArXmLLm+7lHMn+NGtM+DCtTH+jd1Alk3UYdZoKsmVK9
         Op2ibyDxQfJEhfHLN8l67/2LUbsgUwNN0ZhPjdGP8ve01tt91ZrpdCW0ciTNUE9thQ4K
         +0YQ==
X-Gm-Message-State: AOAM533OnR2O4M1piVi27H0uzfdJf4xYTOp+od6i6wsxsBAlYoyMg2+S
        cwS1caimeRbB355Wqe9NJPE=
X-Google-Smtp-Source: ABdhPJyZjb1lBXyQ6D9K6hRhCZcRQEkKFx7c9R0PfsCATlzfztX7qhwnJy+m5O/Xolc9T/NFrIPv1Q==
X-Received: by 2002:a02:cb11:0:b0:331:5525:adf1 with SMTP id j17-20020a02cb11000000b003315525adf1mr385064jap.157.1654022494333;
        Tue, 31 May 2022 11:41:34 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-59-0-164.us-east-2.compute.amazonaws.com. [13.59.0.164])
        by smtp.gmail.com with ESMTPSA id d39-20020a026067000000b0032b5316724dsm3661321jaf.22.2022.05.31.11.41.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 May 2022 11:41:33 -0700 (PDT)
From:   Schspa Shi <schspa@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        syzbot+63bed493aebbf6872647@syzkaller.appspotmail.com
Subject: [PATCH] Bluetooth: When HCI work queue is drained, only queue chained work.
Date:   Wed,  1 Jun 2022 02:41:24 +0800
Message-Id: <20220531184124.20577-1-schspa@gmail.com>
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
Modules linked in:
CPU: 1 PID: 18374 Comm: kworker/1:9 Not tainted 5.18.0-rc6-next-20220516-syzkaller #0
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
---
 include/net/bluetooth/hci.h | 1 +
 net/bluetooth/hci_core.c    | 8 +++++++-
 net/bluetooth/hci_event.c   | 5 +++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index fe7935be7dc4..c2cba0a621d3 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -291,6 +291,7 @@ enum {
 	HCI_RAW,
 
 	HCI_RESET,
+	HCI_DRAIN_WQ,
 };
 
 /* HCI socket flags */
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 5abb2ca5b129..ef3bd543ce04 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -593,6 +593,10 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
 	skb_queue_purge(&hdev->rx_q);
 	skb_queue_purge(&hdev->cmd_q);
 
+	hci_dev_lock(hdev);
+	set_bit(HCI_DRAIN_WQ, &hdev->flags);
+	hci_dev_unlock(hdev);
+	cancel_delayed_work(&hdev->cmd_timer);
 	/* Avoid potential lockdep warnings from the *_flush() calls by
 	 * ensuring the workqueue is empty up front.
 	 */
@@ -601,6 +605,7 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
 	hci_dev_lock(hdev);
 	hci_inquiry_cache_flush(hdev);
 	hci_conn_hash_flush(hdev);
+	clear_bit(HCI_DRAIN_WQ, &hdev->flags);
 	hci_dev_unlock(hdev);
 
 	if (hdev->flush)
@@ -3861,7 +3866,8 @@ static void hci_cmd_work(struct work_struct *work)
 			if (res < 0)
 				__hci_cmd_sync_cancel(hdev, -res);
 
-			if (test_bit(HCI_RESET, &hdev->flags))
+			if (test_bit(HCI_RESET, &hdev->flags) ||
+			    test_bit(HCI_DRAIN_WQ, &hdev->flags))
 				cancel_delayed_work(&hdev->cmd_timer);
 			else
 				schedule_delayed_work(&hdev->cmd_timer,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index af17dfb20e01..700cd01df3a1 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3768,8 +3768,9 @@ static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev, u8 ncmd)
 			cancel_delayed_work(&hdev->ncmd_timer);
 			atomic_set(&hdev->cmd_cnt, 1);
 		} else {
-			schedule_delayed_work(&hdev->ncmd_timer,
-					      HCI_NCMD_TIMEOUT);
+			if (!test_bit(HCI_DRAIN_WQ, &hdev->flags))
+				schedule_delayed_work(&hdev->ncmd_timer,
+						      HCI_NCMD_TIMEOUT);
 		}
 	}
 }
-- 
2.24.3 (Apple Git-128)

