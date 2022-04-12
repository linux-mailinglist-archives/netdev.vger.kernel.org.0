Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A994FDEEE
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344538AbiDLMCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244281AbiDLMCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:10 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B43EE673DD;
        Tue, 12 Apr 2022 03:57:10 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app2 (Coremail) with SMTP id by_KCgBn3hX1WlVixrabAQ--.10506S4;
        Tue, 12 Apr 2022 18:57:03 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzk@kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        pabeni@redhat.com, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 2/2] drivers: nfc: nfcmrvl: fix double free bug in nfc_fw_download_done()
Date:   Tue, 12 Apr 2022 18:56:53 +0800
Message-Id: <d958c7ea019766405bf9db42d58d24d61d6b7607.1649759498.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1649759498.git.duoming@zju.edu.cn>
References: <cover.1649759498.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1649759498.git.duoming@zju.edu.cn>
References: <cover.1649759498.git.duoming@zju.edu.cn>
X-CM-TRANSID: by_KCgBn3hX1WlVixrabAQ--.10506S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1DZFW8KF4ktF15tr43Jrb_yoW8CFyDpr
        WrGFy7Ar4DJr4YvFWFqFyDWrs8Cw47CryUGFZrG3yfZFn8tFyqyr1kGa4rZF4DWr48ta15
        K39xJayUKanYvrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvl1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28I
        cxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
        DU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwSAVZdtZJwywAHsN
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are potential double free bug in nfc_fw_download_done().
The timer handler fw_dnld_timeout() and work item fw_dnld_rx_work()
could both reach in fw_dnld_over() and nfc_fw_download_done() is not
protected by any lock, which leads to double free.

The race between fw_dnld_rx_work() and fw_dnld_timeout()
can be shown as below:

   (Thread 1)               |      (Thread 2)
fw_dnld_timeout             |  fw_dnld_rx_work
                            |   fw_dnld_over
 fw_dnld_over               |    nfc_fw_download_done
  nfc_fw_download_done      |     nfc_genl_fw_download_done
   nfc_genl_fw_download_done|      nlmsg_free(msg)  //(1)
    nlmsg_free(msg) //(2)   |      ...
     ...                    |

The nlmsg_free() will deallocate sk_buff in position (1), but
nlmsg_free will be deallocated again in position (2), which
leads to double free.

This patch adds spin_lock_irq() and check in fw_dnld_over()
in order to synchronize among different threads that call
fw_dnld_over(). So the double free bug could be prevented.

Fixes: 3194c6870158e3 ("NFC: nfcmrvl: add firmware download support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Lin Ma <linma@zju.edu.cn>
---
 drivers/nfc/nfcmrvl/fw_dnld.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
index c22a4556db5..7586a2f678d 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -116,7 +116,10 @@ static void fw_dnld_over(struct nfcmrvl_private *priv, u32 error)
 		nfcmrvl_chip_halt(priv);
 	}
 
-	nfc_fw_download_done(priv->ndev->nfc_dev, priv->fw_dnld.name, error);
+	spin_lock_irq(&priv->fw_dnld.lock);
+	if (dev->fw_download_in_progress)
+		nfc_fw_download_done(priv->ndev->nfc_dev, priv->fw_dnld.name, error);
+	spin_unlock_irq(&priv->fw_dnld.lock);
 }
 
 static void fw_dnld_timeout(struct timer_list *t)
-- 
2.17.1

