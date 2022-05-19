Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195C152D041
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 12:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbiESKR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 06:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiESKRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 06:17:25 -0400
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id EAAC237003;
        Thu, 19 May 2022 03:17:21 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [124.236.130.193])
        by mail-app3 (Coremail) with SMTP id cC_KCgB3HdgZGYZimG+EAA--.40215S2;
        Thu, 19 May 2022 18:17:09 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] net: wireless: marvell: mwifiex: fix sleep in atomic context bugs
Date:   Thu, 19 May 2022 18:16:56 +0800
Message-Id: <20220519101656.44513-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgB3HdgZGYZimG+EAA--.40215S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAr1UWr15KrWktw1rKw43GFg_yoWrGw45pa
        n8KF93Zw40qrs0k3ykJa1kZF98K3WrKry2kFs7Aw4F9F4fGryrZFyaqFyIgFs8XF4vqa4a
        vr1qqw13Arn3tFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgAPAVZdtZxiqAAXsz
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are sleep in atomic context bugs when uploading device dump
data on usb interface. The root cause is that the operations that
may sleep are called in fw_dump_timer_fn which is a timer handler.
The call tree shows the execution paths that could lead to bugs:

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

This patch moves the operations that may sleep into a work item.
The work item will run in another kernel thread which is in
process context to execute the bottom half of the interrupt.
So it could prevent atomic context from sleeping.

Fixes: f5ecd02a8b20 ("mwifiex: device dump support for usb interface")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/net/wireless/marvell/mwifiex/init.c      | 12 +++++++++++-
 drivers/net/wireless/marvell/mwifiex/main.h      |  1 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c |  1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 88c72d1827a..727963d0c82 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -63,11 +63,19 @@ static void wakeup_timer_fn(struct timer_list *t)
 		adapter->if_ops.card_reset(adapter);
 }
 
+static void fw_dump_work(struct work_struct *work)
+{
+	struct mwfiex_adapter *adapter =
+		container_of(work, struct mwfiex_adapter, devdump_work);
+
+	mwifiex_upload_device_dump(adapter);
+}
+
 static void fw_dump_timer_fn(struct timer_list *t)
 {
 	struct mwifiex_adapter *adapter = from_timer(adapter, t, devdump_timer);
 
-	mwifiex_upload_device_dump(adapter);
+	schedule_work(&adapter->devdump_work);
 }
 
 /*
@@ -321,6 +329,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->active_scan_triggered = false;
 	timer_setup(&adapter->wakeup_timer, wakeup_timer_fn, 0);
 	adapter->devdump_len = 0;
+	INIT_WORK(&adapter->devdump_work, fw_dump_work);
 	timer_setup(&adapter->devdump_timer, fw_dump_timer_fn, 0);
 }
 
@@ -401,6 +410,7 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
 	del_timer(&adapter->wakeup_timer);
 	del_timer_sync(&adapter->devdump_timer);
+	cancel_work_sync(&adapter->devdump_work);
 	mwifiex_cancel_all_pending_cmd(adapter);
 	wake_up_interruptible(&adapter->cmd_wait_q.wait);
 	wake_up_interruptible(&adapter->hs_activate_wait_q);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 332dd1c8db3..c8ac2f57f18 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -900,6 +900,7 @@ struct mwifiex_adapter {
 	struct work_struct rx_work;
 	struct workqueue_struct *dfs_workqueue;
 	struct work_struct dfs_work;
+	struct work_struct devdump_work;
 	bool rx_work_enabled;
 	bool rx_processing;
 	bool delay_main_work;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 7d42c5d2dbf..8e28d0107d7 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -644,6 +644,7 @@ mwifiex_fw_dump_info_event(struct mwifiex_private *priv,
 
 upload_dump:
 	del_timer_sync(&adapter->devdump_timer);
+	cancel_work_sync(&adapter->devdump_work);
 	mwifiex_upload_device_dump(adapter);
 }
 
-- 
2.17.1

