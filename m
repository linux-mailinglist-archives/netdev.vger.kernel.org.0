Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A424FE583
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354377AbiDLQHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiDLQHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:07:13 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E198940E7C;
        Tue, 12 Apr 2022 09:04:52 -0700 (PDT)
Received: from localhost.localdomain (unknown [222.205.9.127])
        by mail-app4 (Coremail) with SMTP id cS_KCgA3OfAXo1ViBSYjAQ--.15521S4;
        Wed, 13 Apr 2022 00:04:40 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     krzk@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mudongliangabcd@gmail.com
Cc:     Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v0] nfc: nci: add flush_workqueue to prevent uaf
Date:   Wed, 13 Apr 2022 00:04:30 +0800
Message-Id: <20220412160430.11581-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cS_KCgA3OfAXo1ViBSYjAQ--.15521S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWF45CryfuF15Zr1DCF1xXwb_yoWrtry3pF
        s5GryxGr10qa4qqr47tF4kWw4rtwsFyry2yw1xGw47ur13Xr4DtFyIkFykXr13Gr45uFyD
        Ar1jqa43GF4qv3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUka1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r4UJwAS0I0E0xvYzx
        vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        JVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
        AKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCF04k20xvE74AG
        Y7Cv6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
        WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
        I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r
        4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
        6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our detector found a concurrent use-after-free bug when detaching an
NCI device. The main reason for this bug is the unexpected scheduling
between the used delayed mechanism (timer and workqueue).

The race can be demonstrated below:

Thread-1                           Thread-2
                                 | nci_dev_up()
                                 |   nci_open_device()
                                 |     __nci_request(nci_reset_req)
                                 |       nci_send_cmd
                                 |         queue_work(cmd_work)
nci_unregister_device()          |
  nci_close_device()             | ...
    del_timer_sync(cmd_timer)[1] |
...                              | Worker
nci_free_device()                | nci_cmd_work()
  kfree(ndev)[3]                 |   mod_timer(cmd_timer)[2]

In short, the cleanup routine thought that the cmd_timer has already
been detached by [1] but the mod_timer can re-attach the timer [2], even
it is already released [3], resulting in UAF.

This UAF is easy to trigger, crash trace by POC is like below

[   66.703713] ==================================================================
[   66.703974] BUG: KASAN: use-after-free in enqueue_timer+0x448/0x490
[   66.703974] Write of size 8 at addr ffff888009fb7058 by task kworker/u4:1/33
[   66.703974]
[   66.703974] CPU: 1 PID: 33 Comm: kworker/u4:1 Not tainted 5.18.0-rc2 #5
[   66.703974] Workqueue: nfc2_nci_cmd_wq nci_cmd_work
[   66.703974] Call Trace:
[   66.703974]  <TASK>
[   66.703974]  dump_stack_lvl+0x57/0x7d
[   66.703974]  print_report.cold+0x5e/0x5db
[   66.703974]  ? enqueue_timer+0x448/0x490
[   66.703974]  kasan_report+0xbe/0x1c0
[   66.703974]  ? enqueue_timer+0x448/0x490
[   66.703974]  enqueue_timer+0x448/0x490
[   66.703974]  __mod_timer+0x5e6/0xb80
[   66.703974]  ? mark_held_locks+0x9e/0xe0
[   66.703974]  ? try_to_del_timer_sync+0xf0/0xf0
[   66.703974]  ? lockdep_hardirqs_on_prepare+0x17b/0x410
[   66.703974]  ? queue_work_on+0x61/0x80
[   66.703974]  ? lockdep_hardirqs_on+0xbf/0x130
[   66.703974]  process_one_work+0x8bb/0x1510
[   66.703974]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[   66.703974]  ? pwq_dec_nr_in_flight+0x230/0x230
[   66.703974]  ? rwlock_bug.part.0+0x90/0x90
[   66.703974]  ? _raw_spin_lock_irq+0x41/0x50
[   66.703974]  worker_thread+0x575/0x1190
[   66.703974]  ? process_one_work+0x1510/0x1510
[   66.703974]  kthread+0x2a0/0x340
[   66.703974]  ? kthread_complete_and_exit+0x20/0x20
[   66.703974]  ret_from_fork+0x22/0x30
[   66.703974]  </TASK>
[   66.703974]
[   66.703974] Allocated by task 267:
[   66.703974]  kasan_save_stack+0x1e/0x40
[   66.703974]  __kasan_kmalloc+0x81/0xa0
[   66.703974]  nci_allocate_device+0xd3/0x390
[   66.703974]  nfcmrvl_nci_register_dev+0x183/0x2c0
[   66.703974]  nfcmrvl_nci_uart_open+0xf2/0x1dd
[   66.703974]  nci_uart_tty_ioctl+0x2c3/0x4a0
[   66.703974]  tty_ioctl+0x764/0x1310
[   66.703974]  __x64_sys_ioctl+0x122/0x190
[   66.703974]  do_syscall_64+0x3b/0x90
[   66.703974]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   66.703974]
[   66.703974] Freed by task 406:
[   66.703974]  kasan_save_stack+0x1e/0x40
[   66.703974]  kasan_set_track+0x21/0x30
[   66.703974]  kasan_set_free_info+0x20/0x30
[   66.703974]  __kasan_slab_free+0x108/0x170
[   66.703974]  kfree+0xb0/0x330
[   66.703974]  nfcmrvl_nci_unregister_dev+0x90/0xd0
[   66.703974]  nci_uart_tty_close+0xdf/0x180
[   66.703974]  tty_ldisc_kill+0x73/0x110
[   66.703974]  tty_ldisc_hangup+0x281/0x5b0
[   66.703974]  __tty_hangup.part.0+0x431/0x890
[   66.703974]  tty_release+0x3a8/0xc80
[   66.703974]  __fput+0x1f0/0x8c0
[   66.703974]  task_work_run+0xc9/0x170
[   66.703974]  exit_to_user_mode_prepare+0x194/0x1a0
[   66.703974]  syscall_exit_to_user_mode+0x19/0x50
[   66.703974]  do_syscall_64+0x48/0x90
[   66.703974]  entry_SYSCALL_64_after_hwframe+0x44/0xae

To fix the UAF, this patch adds flush_workqueue() to ensure the
nci_cmd_work is finished before the following del_timer_sync.
This combination will promise the timer is actually detached.

Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 net/nfc/nci/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index d2537383a3e8..0d7763c322b5 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -560,6 +560,10 @@ static int nci_close_device(struct nci_dev *ndev)
 	mutex_lock(&ndev->req_lock);
 
 	if (!test_and_clear_bit(NCI_UP, &ndev->flags)) {
+		/* Need to flush the cmd wq in case
+		 * there is a queued/running cmd_work
+		 */
+		flush_workqueue(ndev->cmd_wq);
 		del_timer_sync(&ndev->cmd_timer);
 		del_timer_sync(&ndev->data_timer);
 		mutex_unlock(&ndev->req_lock);
-- 
2.35.1

