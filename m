Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893884FDFFA
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354408AbiDLMVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355890AbiDLMT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:19:27 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 158F88CDA6;
        Tue, 12 Apr 2022 04:23:12 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app2 (Coremail) with SMTP id by_KCgCnHhYUYVViTRWcAQ--.9963S2;
        Tue, 12 Apr 2022 19:23:03 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzk@kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        pabeni@redhat.com, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH V2 2/2] drivers: nfc: nfcmrvl: fix double free bug in nfc_fw_download_done()
Date:   Tue, 12 Apr 2022 19:23:00 +0800
Message-Id: <20220412112300.106640-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgCnHhYUYVViTRWcAQ--.9963S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1DZFW8KF4ktF15tr43Jrb_yoW8Zry7pr
        WrGFy7Ar4DAr4YvFW5tFyDWrs8Cw47CryUGFZrG3yfZFn8tFyqy34kGFyrZF4DWr48ta15
        K39xJayjkanYvr7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9C1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
        n4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GFWkJr1UJw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxK
        x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI
        0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgISAVZdtZJyPAADsy
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
Changes in V2:
  - Fix the check in spin_lock_irq.

 drivers/nfc/nfcmrvl/fw_dnld.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
index c22a4556db5..8188d466a01 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -116,7 +116,10 @@ static void fw_dnld_over(struct nfcmrvl_private *priv, u32 error)
 		nfcmrvl_chip_halt(priv);
 	}
 
-	nfc_fw_download_done(priv->ndev->nfc_dev, priv->fw_dnld.name, error);
+	spin_lock_irq(&priv->fw_dnld.lock);
+	if (priv->ndev->nfc_dev->fw_download_in_progress)
+		nfc_fw_download_done(priv->ndev->nfc_dev, priv->fw_dnld.name, error);
+	spin_unlock_irq(&priv->fw_dnld.lock);
 }
 
 static void fw_dnld_timeout(struct timer_list *t)
-- 
2.17.1

