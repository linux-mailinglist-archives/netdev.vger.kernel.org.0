Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D0F53C6D7
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 10:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242782AbiFCITh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 04:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241021AbiFCITg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 04:19:36 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647271A822;
        Fri,  3 Jun 2022 01:19:34 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id r3so5483415ilt.8;
        Fri, 03 Jun 2022 01:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TK3AysTtR0qNSoTXRQfI9MmzeRKPRXKi7E94xqdy03I=;
        b=XX9H8fgRlIHpKXvwSpOkg5bk2Nkp0mC8bcTk2xL+tP2xInMkAxLZaBFTX66ACoZRON
         pH+7zrUy6sr4xIpyLO3tSK5j2ZjVyVpPL6XFT1FUyov4fCrX8XNrbVB2fOsBzrb2UjB6
         YbMv9nb3RWzN47+195aKF9er1hSpw4oAN/SYxLgvJmlBo6dwjE+VhRNUBRW8D3p+/403
         Pzaw2fKYaV3F+BB3P+K2tnPGyQ6ozBofJcSLBTy6/un494kDVzjGgPXntLCWsZsBpcOs
         7cLSZxUYU0WIgIiAZWvVS1CHQKyzcbkF+/kgmGndE9qn8Tzi+yJ23Tu/Xuy3F09Ruqz5
         9BsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TK3AysTtR0qNSoTXRQfI9MmzeRKPRXKi7E94xqdy03I=;
        b=fasi57z2vM4luSeI/s5B1isLFjFtFjyEl41Uucwva8cHRlqNQsvp6Zx3GGobhJa96q
         ok1SMO4eMXdpi+0pdow8fIx6SLwkEswtmLgPDe1eIL/Su8pJkS7kmnyY1NC8U8TFqCnK
         3LjNNi2iSVWmfEQKN8lDF6FbvPmhWxi3PQNy+eGxVnYHRy7FGrMvU/e8hK2gNFOskNF8
         obexXIgUuuNrmAzu6zKHZeK3GB1mcF2mkOlOM6v/cugApjaYb1O+LEx1L1Rskm1ne9FN
         +/PMW2QnIO/cfnIOfT/atEN3hRQD8+Icnpucq/piECqUwySVRsi8g1ChAx/9UN9dy4y6
         DCfQ==
X-Gm-Message-State: AOAM532pMdYUxPLybx/qkd73qDT/j1j2tASj/dD8w+CBfrzMMzwc9UQQ
        oRHNuv9KyRU/PpG7p5NmiSI=
X-Google-Smtp-Source: ABdhPJzCnVfesOGR1WJBjeMBHLfF/ORjm7ebmlYuqy94E0wbJB6sfV8gfaIllw0abmjh8rPXTAmN0g==
X-Received: by 2002:a05:6602:2a45:b0:669:17b2:b71c with SMTP id k5-20020a0566022a4500b0066917b2b71cmr2544395iov.10.1654244373734;
        Fri, 03 Jun 2022 01:19:33 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-59-0-164.us-east-2.compute.amazonaws.com. [13.59.0.164])
        by smtp.gmail.com with ESMTPSA id t67-20020a025446000000b0032ec5c47c17sm2236864jaa.46.2022.06.03.01.19.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jun 2022 01:19:33 -0700 (PDT)
From:   Schspa Shi <schspa@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        syzbot+63bed493aebbf6872647@syzkaller.appspotmail.com
Subject: [PATCH v3] Bluetooth: When HCI work queue is drained, only queue chained work
Date:   Fri,  3 Jun 2022 16:19:14 +0800
Message-Id: <20220603081914.42512-1-schspa@gmail.com>
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
        - Move the workqueue drain flag to controller flags, and
          use hci_dev_*_flag.
        - Add missing ncmd_timer cancel.
        - Clear DRAIN_WORKQUEUE flag after device command flushed.
v2 -> v3:
        - Fix typos in comments and adjust the description.
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
index 5abb2ca5b129..8539b4233da8 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -593,6 +593,11 @@ static int hci_dev_do_reset(struct hci_dev *hdev)
 	skb_queue_purge(&hdev->rx_q);
 	skb_queue_purge(&hdev->cmd_q);
 
+	/* Cancel these to avoid queueing non-chained pending work */
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

