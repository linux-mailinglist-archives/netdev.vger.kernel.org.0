Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033E04F7653
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241374AbiDGGkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241357AbiDGGkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:40:02 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74A8C10BF;
        Wed,  6 Apr 2022 23:37:19 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgDHPKSNhk5ifp7iAA--.11453S2;
        Thu, 07 Apr 2022 14:37:04 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org
Cc:     chris@zankel.net, jcmvbkbc@gmail.com, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, jgg@ziepe.ca, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jes@trained-monkey.org,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alexander.deucher@amd.com, linux-xtensa@linux-xtensa.org,
        linux-rdma@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-hippi@sunsite.dk,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 08/11] drivers: net: can: Fix deadlock in grcan_close()
Date:   Thu,  7 Apr 2022 14:37:00 +0800
Message-Id: <4cf24d94ecf99d6feb4cb1ff7e01fb33976d9df0.1649310812.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1649310812.git.duoming@zju.edu.cn>
References: <cover.1649310812.git.duoming@zju.edu.cn>
X-CM-TRANSID: cS_KCgDHPKSNhk5ifp7iAA--.11453S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr4kXF45Xw1xWr4kWr4kJFb_yoW8Gw4xpw
        47KFyfAFWvvr4UK3Z7Xw4kZF1rZ3WDWFWUJFy5Wws5Zwn3ZF15JF1rKa4UuF47KFyDKFsx
        uF1rXrZ3CFs8GrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
        twAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY
        0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
        x4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa
        73UjIFyTuYvjfU5JPEDUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAggNAVZdtZEcMgAHsA
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are deadlocks caused by del_timer_sync(&priv->hang_timer)
and del_timer_sync(&priv->rr_timer) in grcan_close(), one of
the deadlocks are shown below:

   (Thread 1)              |      (Thread 2)
                           | grcan_reset_timer()
grcan_close()              |  mod_timer()
 spin_lock_irqsave() //(1) |  (wait a time)
 ...                       | grcan_initiate_running_reset()
 del_timer_sync()          |  spin_lock_irqsave() //(2)
 (wait timer to stop)      |  ...

We hold priv->lock in position (1) of thread 1 and use
del_timer_sync() to wait timer to stop, but timer handler
also need priv->lock in position (2) of thread 2.
As a result, grcan_close() will block forever.

This patch extracts del_timer_sync() from the protection of
spin_lock_irqsave(), which could let timer handler to obtain
the needed lock.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/net/can/grcan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index d0c5a7a60da..1189057b5d6 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1102,8 +1102,10 @@ static int grcan_close(struct net_device *dev)
 
 	priv->closing = true;
 	if (priv->need_txbug_workaround) {
+		spin_unlock_irqrestore(&priv->lock, flags);
 		del_timer_sync(&priv->hang_timer);
 		del_timer_sync(&priv->rr_timer);
+		spin_lock_irqsave(&priv->lock, flags);
 	}
 	netif_stop_queue(dev);
 	grcan_stop_hardware(dev);
-- 
2.17.1

