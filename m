Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3EF5FD9B1
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 14:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJMM5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 08:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiJMM5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 08:57:52 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27E3A139E45;
        Thu, 13 Oct 2022 05:57:49 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.162.98.155])
        by mail-app3 (Coremail) with SMTP id cC_KCgDXWLU6C0hjcwbVBw--.25275S2;
        Thu, 13 Oct 2022 20:57:37 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de, kuba@kernel.org,
        gregkh@linuxfoundation.org, andrii@kernel.org, davem@davemloft.net,
        axboe@kernel.dk, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH] mISDN: hfcpci: Fix use-after-free bug in hfcpci_Timer
Date:   Thu, 13 Oct 2022 20:57:29 +0800
Message-Id: <20221013125729.105652-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgDXWLU6C0hjcwbVBw--.25275S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW8JFW7AF18ur48tF48Crg_yoW8Gw13pF
        W5WF42yrWqqF1jya1UZan8uF93Aa1vyrWrKFWqk39xZ3Z3XFy5AF1Ut3yv9FWfGr93W39x
        XF40qw1YkF9rAFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgECAVZdtb56rwASsH
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the timer handler hfcpci_Timer() is running, the
del_timer(&hc->hw.timer) in release_io_hfcpci() could
not stop it. As a result, the use-after-free bug will
happen. The process is shown below:

    (cleanup routine)          |        (timer handler)
release_card()                 | hfcpci_Timer()
  release_io_hfcpci            |
    del_timer(&hc->hw.timer)   |
  ...                          |  ...
  kfree(hc) //[1]FREE          |
                               |   hc->hw.timer.expires //[2]USE

The hfc_pci is deallocated in position [1] and used in
position [2].

Fix by changing del_timer() in release_io_hfcpci() to
del_timer_sync(), which makes sure the hfcpci_Timer()
have finished before the hfc_pci is deallocated.

Fixes: 1700fe1a10dc ("Add mISDN HFC PCI driver")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index af17459c1a5..5cf37fe7de2 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -157,7 +157,7 @@ release_io_hfcpci(struct hfc_pci *hc)
 {
 	/* disable memory mapped ports + busmaster */
 	pci_write_config_word(hc->pdev, PCI_COMMAND, 0);
-	del_timer(&hc->hw.timer);
+	del_timer_sync(&hc->hw.timer);
 	dma_free_coherent(&hc->pdev->dev, 0x8000, hc->hw.fifos,
 			  hc->hw.dmahandle);
 	iounmap(hc->hw.pci_io);
-- 
2.17.1

