Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3656355D03B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243191AbiF1Blp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbiF1Blo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:41:44 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CFA4A1D0E3;
        Mon, 27 Jun 2022 18:41:41 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.190.65.205])
        by mail-app4 (Coremail) with SMTP id cS_KCgBHv443XLpibF63Ag--.15659S2;
        Tue, 28 Jun 2022 09:41:22 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        stable@vger.kernel.org
Subject: [PATCH V6 RESEND] mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
Date:   Tue, 28 Jun 2022 09:41:09 +0800
Message-Id: <20220628014110.9183-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgBHv443XLpibF63Ag--.15659S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw4UCryrJFy3JFyfCFyrCrg_yoWxZw47pa
        n8GF95Cr48Xr1qkr48JF48XFyYg3Wvka42kr1kZw4xuF4fGryfZF4UKryIgFs8XFs2va43
        Zr4kXrnaka45taDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvm1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_
        JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
        c2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUbE_M3UUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgcPAVZdtaboxAADs8
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are sleep in atomic context bugs when uploading device dump
data in mwifiex. The root cause is that dev_coredumpv could not
be used in atomic contexts, because it calls dev_set_name which
include operations that may sleep. The call tree shows execution
paths that could lead to bugs:

   (Interrupt context)
fw_dump_timer_fn
  mwifiex_upload_device_dump
    dev_coredumpv(..., GFP_KERNEL)
      dev_coredumpm()
        kzalloc(sizeof(*devcd), gfp); //may sleep
        dev_set_name
          kobject_set_name_vargs
            kvasprintf_const(GFP_KERNEL, ...); //may sleep
            kstrdup(s, GFP_KERNEL); //may sleep

The corresponding fail log is shown below:

[  135.275938] usb 1-1: == mwifiex dump information to /sys/class/devcoredump start
[  135.281029] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:265
...
[  135.293613] Call Trace:
[  135.293613]  <IRQ>
[  135.293613]  dump_stack_lvl+0x57/0x7d
[  135.293613]  __might_resched.cold+0x138/0x173
[  135.293613]  ? dev_coredumpm+0xca/0x2e0
[  135.293613]  kmem_cache_alloc_trace+0x189/0x1f0
[  135.293613]  ? devcd_match_failing+0x30/0x30
[  135.293613]  dev_coredumpm+0xca/0x2e0
[  135.293613]  ? devcd_freev+0x10/0x10
[  135.293613]  dev_coredumpv+0x1c/0x20
[  135.293613]  ? devcd_match_failing+0x30/0x30
[  135.293613]  mwifiex_upload_device_dump+0x65/0xb0
[  135.293613]  ? mwifiex_dnld_fw+0x1b0/0x1b0
[  135.293613]  call_timer_fn+0x122/0x3d0
[  135.293613]  ? msleep_interruptible+0xb0/0xb0
[  135.293613]  ? lock_downgrade+0x3c0/0x3c0
[  135.293613]  ? __next_timer_interrupt+0x13c/0x160
[  135.293613]  ? lockdep_hardirqs_on_prepare+0xe/0x220
[  135.293613]  ? mwifiex_dnld_fw+0x1b0/0x1b0
[  135.293613]  __run_timers.part.0+0x3f8/0x540
[  135.293613]  ? call_timer_fn+0x3d0/0x3d0
[  135.293613]  ? arch_restore_msi_irqs+0x10/0x10
[  135.293613]  ? lapic_next_event+0x31/0x40
[  135.293613]  run_timer_softirq+0x4f/0xb0
[  135.293613]  __do_softirq+0x1c2/0x651
...
[  135.293613] RIP: 0010:default_idle+0xb/0x10
[  135.293613] RSP: 0018:ffff888006317e68 EFLAGS: 00000246
[  135.293613] RAX: ffffffff82ad8d10 RBX: ffff888006301cc0 RCX: ffffffff82ac90e1
[  135.293613] RDX: ffffed100d9ff1b4 RSI: ffffffff831ad140 RDI: ffffffff82ad8f20
[  135.293613] RBP: 0000000000000003 R08: 0000000000000000 R09: ffff88806cff8d9b
[  135.293613] R10: ffffed100d9ff1b3 R11: 0000000000000001 R12: ffffffff84593410
[  135.293613] R13: 0000000000000000 R14: 0000000000000000 R15: 1ffff11000c62fd2
...
[  135.389205] usb 1-1: == mwifiex dump information to /sys/class/devcoredump end

This patch uses delayed work to replace timer and moves the operations
that may sleep into a delayed work in order to mitigate bugs, it was
tested on Marvell 88W8801 chip whose port is usb and the firmware is
usb8801_uapsta.bin. The following is the result after using delayed
work to replace timer.

[  134.936453] usb 1-1: == mwifiex dump information to /sys/class/devcoredump start
[  135.043344] usb 1-1: == mwifiex dump information to /sys/class/devcoredump end

As we can see, there is no bug now.

Cc: stable@vger.kernel.org
Fixes: f5ecd02a8b20 ("mwifiex: device dump support for usb interface")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Brian Norris <briannorris@chromium.org>
---
Changes in v6:
  - Use clang-format to adjust the format of code.

 drivers/net/wireless/marvell/mwifiex/init.c      | 9 +++++----
 drivers/net/wireless/marvell/mwifiex/main.h      | 3 ++-
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 6 +++---
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 88c72d1827a..fca3ab948f6 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -63,9 +63,10 @@ static void wakeup_timer_fn(struct timer_list *t)
 		adapter->if_ops.card_reset(adapter);
 }
 
-static void fw_dump_timer_fn(struct timer_list *t)
+static void fw_dump_work(struct work_struct *work)
 {
-	struct mwifiex_adapter *adapter = from_timer(adapter, t, devdump_timer);
+	struct mwifiex_adapter *adapter =
+		container_of(work, struct mwifiex_adapter, devdump_work.work);
 
 	mwifiex_upload_device_dump(adapter);
 }
@@ -321,7 +322,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->active_scan_triggered = false;
 	timer_setup(&adapter->wakeup_timer, wakeup_timer_fn, 0);
 	adapter->devdump_len = 0;
-	timer_setup(&adapter->devdump_timer, fw_dump_timer_fn, 0);
+	INIT_DELAYED_WORK(&adapter->devdump_work, fw_dump_work);
 }
 
 /*
@@ -400,7 +401,7 @@ static void
 mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
 	del_timer(&adapter->wakeup_timer);
-	del_timer_sync(&adapter->devdump_timer);
+	cancel_delayed_work_sync(&adapter->devdump_work);
 	mwifiex_cancel_all_pending_cmd(adapter);
 	wake_up_interruptible(&adapter->cmd_wait_q.wait);
 	wake_up_interruptible(&adapter->hs_activate_wait_q);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 332dd1c8db3..5d8646f1616 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -49,6 +49,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/of_irq.h>
+#include <linux/workqueue.h>
 
 #include "decl.h"
 #include "ioctl.h"
@@ -1055,7 +1056,7 @@ struct mwifiex_adapter {
 	/* Device dump data/length */
 	void *devdump_data;
 	int devdump_len;
-	struct timer_list devdump_timer;
+	struct delayed_work devdump_work;
 
 	bool ignore_btcoex_events;
 };
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 7d42c5d2dbf..4d93386494c 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -623,8 +623,8 @@ mwifiex_fw_dump_info_event(struct mwifiex_private *priv,
 		 * transmission event get lost, in this cornel case,
 		 * user would still get partial of the dump.
 		 */
-		mod_timer(&adapter->devdump_timer,
-			  jiffies + msecs_to_jiffies(MWIFIEX_TIMER_10S));
+		schedule_delayed_work(&adapter->devdump_work,
+				      msecs_to_jiffies(MWIFIEX_TIMER_10S));
 	}
 
 	/* Overflow check */
@@ -643,7 +643,7 @@ mwifiex_fw_dump_info_event(struct mwifiex_private *priv,
 	return;
 
 upload_dump:
-	del_timer_sync(&adapter->devdump_timer);
+	cancel_delayed_work_sync(&adapter->devdump_work);
 	mwifiex_upload_device_dump(adapter);
 }
 
-- 
2.17.1

