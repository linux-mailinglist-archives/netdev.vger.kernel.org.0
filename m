Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7070F52B83E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 13:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiERLDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235271AbiERLDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:03:24 -0400
X-Greylist: delayed 556 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 May 2022 04:03:19 PDT
Received: from zg8tmtyylji0my4xnjqunzqa.icoremail.net (zg8tmtyylji0my4xnjqunzqa.icoremail.net [162.243.164.74])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 8DE50166D7C;
        Wed, 18 May 2022 04:03:18 -0700 (PDT)
Received: from localhost.localdomain (unknown [183.157.163.156])
        by mail-app3 (Coremail) with SMTP id cC_KCgCXfUwv0IRiHWB1AA--.24950S4;
        Wed, 18 May 2022 18:53:36 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     krzysztof.kozlowski@linaro.org, dan.carpenter@oracle.com,
        cyeaa@connect.ust.hk, rikard.falkeborn@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v0] nfc: pn533: Fix buggy cleanup order
Date:   Wed, 18 May 2022 18:53:21 +0800
Message-Id: <20220518105321.32746-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cC_KCgCXfUwv0IRiHWB1AA--.24950S4
X-Coremail-Antispam: 1UD129KBjvJXoW7AF1rGw4ftr1rZw1UAF1UWrg_yoW8Zr4xp3
        9Iva4ayw4kJr4jkF4DWw4kX343Gan7JFyxKr4xGw4Uurn5JF1UJFWftFyjqayxJrWkGr43
        ArZ5Wr98KFZ8AF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUym14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
        xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
        cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
        AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
        14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When removing the pn533 device (i2c or USB), there is a logic error. The
original code first cancels the worker (flush_delayed_work) and then
destroys the workqueue (destroy_workqueue), leaving the timer the last
one to be deleted (del_timer). This result in a possible race condition
in a multi-core preempt-able kernel. That is, if the cleanup
(pn53x_common_clean) is concurrently run with the timer handler
(pn533_listen_mode_timer), the timer can queue the poll_work to the
already destroyed workqueue, causing use-after-free.

This patch reorder the cleanup: it uses the del_timer_sync to make sure
the handler is finished before the routine will destroy the workqueue.
Note that the timer cannot be activated by the worker again.

static void pn533_wq_poll(struct work_struct *work)
...
 rc = pn533_send_poll_frame(dev);
 if (rc)
   return;

 if (cur_mod->len == 0 && dev->poll_mod_count > 1)
   mod_timer(&dev->listen_timer, ...);

That is, the mod_timer can be called only when pn533_send_poll_frame()
returns no error, which is impossible because the device is detaching
and the lower driver should return ENODEV code.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 drivers/nfc/pn533/pn533.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index a491db46e3bd..a0532647b040 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2787,13 +2787,14 @@ void pn53x_common_clean(struct pn533 *priv)
 {
 	struct pn533_cmd *cmd, *n;
 
+	/* delete the timer before cleanup the worker */
+	del_timer_sync(&priv->listen_timer);
+
 	flush_delayed_work(&priv->poll_work);
 	destroy_workqueue(priv->wq);
 
 	skb_queue_purge(&priv->resp_q);
 
-	del_timer(&priv->listen_timer);
-
 	list_for_each_entry_safe(cmd, n, &priv->cmd_queue, queue) {
 		list_del(&cmd->queue);
 		kfree(cmd);
-- 
2.35.1

