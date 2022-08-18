Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D4E59808D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbiHRJGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbiHRJGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:06:48 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B432FB08A9;
        Thu, 18 Aug 2022 02:06:46 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.190.66.64])
        by mail-app3 (Coremail) with SMTP id cC_KCgBXqLQOAf5iHIBTAw--.61019S2;
        Thu, 18 Aug 2022 17:06:33 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     netdev@vger.kernel.org, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org, kuba@kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] nfc: pn533: Fix use-after-free bugs caused by pn532_cmd_timeout
Date:   Thu, 18 Aug 2022 17:06:21 +0800
Message-Id: <20220818090621.106094-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgBXqLQOAf5iHIBTAw--.61019S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF17XFW8uw1kGr4UAr4fKrg_yoW8GFyxpF
        ZagFn8Ar18Jr4UCa1xur1rXa4rJws7Jry0gFy7uw13Was7CF1rGrs3tFyjyFsxXrWkKFn3
        ZFZ5Xw1UGF98KFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgMGAVZdtbFGtwAMs0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the pn532 uart device is detaching, the pn532_uart_remove()
is called. But there are no functions in pn532_uart_remove() that
could delete the cmd_timeout timer, which will cause use-after-free
bugs. The process is shown below:

    (thread 1)                  |        (thread 2)
                                |  pn532_uart_send_frame
pn532_uart_remove               |    mod_timer(&pn532->cmd_timeout,...)
  ...                           |    (wait a time)
  kfree(pn532) //FREE           |    pn532_cmd_timeout
                                |      pn532_uart_send_frame
                                |        pn532->... //USE

This patch adds del_timer_sync() in pn532_uart_remove() in order to
prevent the use-after-free bugs. What's more, the pn53x_unregister_nfc()
is well synchronized, it sets nfc_dev->shutting_down to true and there
are no syscalls could restart the cmd_timeout timer.

Fixes: c656aa4c27b1 ("nfc: pn533: add UART phy driver")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/nfc/pn533/uart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index 2caf997f9bc..07596bf5f7d 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -310,6 +310,7 @@ static void pn532_uart_remove(struct serdev_device *serdev)
 	pn53x_unregister_nfc(pn532->priv);
 	serdev_device_close(serdev);
 	pn53x_common_clean(pn532->priv);
+	del_timer_sync(&pn532->cmd_timeout);
 	kfree_skb(pn532->recv_skb);
 	kfree(pn532);
 }
-- 
2.17.1

