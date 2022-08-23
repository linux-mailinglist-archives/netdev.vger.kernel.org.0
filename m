Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09B859E50E
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 16:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242428AbiHWOTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 10:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242416AbiHWOTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 10:19:09 -0400
Received: from zg8tmtyylji0my4xnjqunzqa.icoremail.net (zg8tmtyylji0my4xnjqunzqa.icoremail.net [162.243.164.74])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 2EA9327E7AC;
        Tue, 23 Aug 2022 04:33:13 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [218.12.19.15])
        by mail-app2 (Coremail) with SMTP id by_KCgDnqrA5uARjm7mFAw--.5982S4;
        Tue, 23 Aug 2022 19:21:46 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        briannorris@chromium.org
Cc:     johannes@sipsolutions.net, rafael@kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH v8 2/2 RESEND] mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
Date:   Tue, 23 Aug 2022 19:21:27 +0800
Message-Id: <5cfa5c473ff6d069cb67760ffa04a2f84ef450a8.1661252818.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1661252818.git.duoming@zju.edu.cn>
References: <cover.1661252818.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1661252818.git.duoming@zju.edu.cn>
References: <cover.1661252818.git.duoming@zju.edu.cn>
X-CM-TRANSID: by_KCgDnqrA5uARjm7mFAw--.5982S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw4UCryrJFy3JFyfCFyrCrg_yoWxury3pF
        s8GF95Cr48Xr1qkr48Ja1kXFyYg3ZYka42kr1kZw4xuF4fGryfXF4UKryIgFs8XFs2va43
        Zrn7Xrnaka45taDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
        x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
        A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
        xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
        6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2
        Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
        Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
        CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOJPEUUUU
        U
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgULAVZdtbI0NQAWsW
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Fixes: f5ecd02a8b20 ("mwifiex: device dump support for usb interface")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Changes since v6:
  - Use clang-format to adjust the format of code.

 drivers/net/wireless/marvell/mwifiex/init.c      | 9 +++++----
 drivers/net/wireless/marvell/mwifiex/main.h      | 3 ++-
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 6 +++---
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index fc77489cc51..7dddb4b5dea 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -51,9 +51,10 @@ static void wakeup_timer_fn(struct timer_list *t)
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
@@ -309,7 +310,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->active_scan_triggered = false;
 	timer_setup(&adapter->wakeup_timer, wakeup_timer_fn, 0);
 	adapter->devdump_len = 0;
-	timer_setup(&adapter->devdump_timer, fw_dump_timer_fn, 0);
+	INIT_DELAYED_WORK(&adapter->devdump_work, fw_dump_work);
 }
 
 /*
@@ -388,7 +389,7 @@ static void
 mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
 	del_timer(&adapter->wakeup_timer);
-	del_timer_sync(&adapter->devdump_timer);
+	cancel_delayed_work_sync(&adapter->devdump_work);
 	mwifiex_cancel_all_pending_cmd(adapter);
 	wake_up_interruptible(&adapter->cmd_wait_q.wait);
 	wake_up_interruptible(&adapter->hs_activate_wait_q);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 87729d251fe..63f861e6b28 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -37,6 +37,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/of_irq.h>
+#include <linux/workqueue.h>
 
 #include "decl.h"
 #include "ioctl.h"
@@ -1043,7 +1044,7 @@ struct mwifiex_adapter {
 	/* Device dump data/length */
 	void *devdump_data;
 	int devdump_len;
-	struct timer_list devdump_timer;
+	struct delayed_work devdump_work;
 
 	bool ignore_btcoex_events;
 };
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index b95e90a7d12..e80e372cce8 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -611,8 +611,8 @@ mwifiex_fw_dump_info_event(struct mwifiex_private *priv,
 		 * transmission event get lost, in this cornel case,
 		 * user would still get partial of the dump.
 		 */
-		mod_timer(&adapter->devdump_timer,
-			  jiffies + msecs_to_jiffies(MWIFIEX_TIMER_10S));
+		schedule_delayed_work(&adapter->devdump_work,
+				      msecs_to_jiffies(MWIFIEX_TIMER_10S));
 	}
 
 	/* Overflow check */
@@ -631,7 +631,7 @@ mwifiex_fw_dump_info_event(struct mwifiex_private *priv,
 	return;
 
 upload_dump:
-	del_timer_sync(&adapter->devdump_timer);
+	cancel_delayed_work_sync(&adapter->devdump_work);
 	mwifiex_upload_device_dump(adapter);
 }
 
-- 
2.17.1

