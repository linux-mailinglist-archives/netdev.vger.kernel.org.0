Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3541569B896
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 09:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjBRIAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 03:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBRIAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 03:00:40 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AB224DE2C;
        Sat, 18 Feb 2023 00:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=mSlY7
        9GAIPqWM6x0QcLyyzMg/OV9+44uQhIVEfrs9mk=; b=Bnb2TMzOvDXgckSvXKh83
        CbSRZ2OVRYKEiVux4Lw0HdUcarmHuEGjVZJYoNBBBdrfFp7w3BkWL4FlXyR4V3xB
        OXDwhZCVQatzckOqZ3Agj4O6+i4KfJ0XRZEQ4CC9bmQSR0KqdX4Nl++QCGkxRb/B
        gBGm+3cKliG938gAGorafk=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g0-4 (Coremail) with SMTP id _____wCnGEx9hfBjeoLtAA--.39355S2;
        Sat, 18 Feb 2023 15:59:57 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     ganapathi017@gmail.com
Cc:     alex000young@gmail.com, amitkarwar@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH] mwifiex: Fix use-after-free bug due to race condition between main thread thread and timer thread
Date:   Sat, 18 Feb 2023 15:59:56 +0800
Message-Id: <20230218075956.1563118-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wCnGEx9hfBjeoLtAA--.39355S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXF4UuryrtFy5CF18Xr45GFg_yoW5Gr47pa
        nxA3s7uw4Iqr4qkw4kJFy0yFWjg3WrKrWjkrWkAwn5Gr4rJas3ZrW5KFy0gr15XF4vga43
        Ar1qq343Z3WkXFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziIJPiUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/xtbBzgAaU2I0XXgkYAAAsw
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a potential race condition by executing the following order.

In summary, the adapter could be freed in timer function and be used after
that. The race condition needs 10s window which could be extended by the
paper : https://www.usenix.org/system/files/sec21-lee-yoochan.pdf

And the function in wakeup_timer_fn may have the same problem.

I dont't really know how to fix that, so I just removed the reset call,
which is totally wrong. If you know anything abouth the fix,
plz free to let me know.

Note that, this bug is found by static analysis, it could be wrong. We
could discuss that before writing the fix.

        CPU0                                                        CPU1
mwifiex_sdio_probe
mwifiex_add_card
mwifiex_init_hw_fw
request_firmware_nowait
  mwifiex_fw_dpc
    _mwifiex_fw_dpc
      mwifiex_init_fw
        mwifiex_main_process
          mwifiex_exec_next_cmd
            mwifiex_dnld_cmd_to_fw
              mod_timer(&adapter->cmd_timer,..)
                                                mwifiex_cmd_timeout_func
                                                  if_ops.card_reset(adapter)
                                                    mwifiex_sdio_card_reset
                                                      schedule_work(&card->work)
                                                        mwifiex_sdio_work
                                                          mwifiex_sdio_card_reset_work
                                                            mwifiex_reinit_sw
                                                              _mwifiex_fw_dpc
                                                                mwifiex_free_adapter
                                                                  mwifiex_unregister
                                                                    kfree(adapter)  //free adapter
                mwifiex_get_priv
                  // Use adapter

Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 2 --
 drivers/net/wireless/marvell/mwifiex/init.c   | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index d3339d67e7a0..688dd451aba9 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1016,8 +1016,6 @@ mwifiex_cmd_timeout_func(struct timer_list *t)
 	if (adapter->if_ops.device_dump)
 		adapter->if_ops.device_dump(adapter);
 
-	if (adapter->if_ops.card_reset)
-		adapter->if_ops.card_reset(adapter);
 }
 
 void
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 7dddb4b5dea1..ff2d447c1de3 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -47,8 +47,6 @@ static void wakeup_timer_fn(struct timer_list *t)
 	adapter->hw_status = MWIFIEX_HW_STATUS_RESET;
 	mwifiex_cancel_all_pending_cmd(adapter);
 
-	if (adapter->if_ops.card_reset)
-		adapter->if_ops.card_reset(adapter);
 }
 
 static void fw_dump_work(struct work_struct *work)
-- 
2.25.1

