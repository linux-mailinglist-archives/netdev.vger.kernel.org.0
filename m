Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553EC4FDF09
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348854AbiDLMFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343909AbiDLMCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:10 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7156C673D3;
        Tue, 12 Apr 2022 03:57:09 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app2 (Coremail) with SMTP id by_KCgBn3hX1WlVixrabAQ--.10506S3;
        Tue, 12 Apr 2022 18:57:00 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzk@kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        pabeni@redhat.com, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH V3 1/2] drivers: nfc: nfcmrvl: fix double free bugs caused by fw_dnld_over()
Date:   Tue, 12 Apr 2022 18:56:52 +0800
Message-Id: <a88510674c00ad2065698340e9fee89c93ad5d78.1649759498.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1649759498.git.duoming@zju.edu.cn>
References: <cover.1649759498.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1649759498.git.duoming@zju.edu.cn>
References: <cover.1649759498.git.duoming@zju.edu.cn>
X-CM-TRANSID: by_KCgBn3hX1WlVixrabAQ--.10506S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWr47uw4DAry7uw1DGFW5trb_yoWrAF1DpF
        45XF95Jr1qkr4YgF98ta1DAF98Aw43CrWUGF98Ja4fZrn0yF1vyw1ktay5ZrsFgr4Dta13
        G3ZxJa4UCFsYyr7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwSAVZdtZJwywAFsP
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are potential double free bugs in nfcmrvl usb driver among
fw_dnld_rx_work(), fw_dnld_timeout() and nfcmrvl_nci_unregister_dev().
All these three functions will call fw_dnld_over(). The fw_dnld_rx_work()
is a work item, the fw_dnld_timeout() is a timer handler and the
nfcmrvl_nci_unregister_dev() is called when nfcmrvl_nci device is
detaching. So these three functions could execute concurrently.

The race between fw_dnld_rx_work() and nfcmrvl_nci_unregister_dev()
can be shown as below:

   (Thread 1)               |      (Thread 2)
                            |       fw_dnld_rx_work
                            |        fw_dnld_over
                            |         release_firmware
                            |          kfree(fw); //(1)
nfcmrvl_disconnect          |
 nfcmrvl_nci_unregister_dev |
  nfcmrvl_fw_dnld_abort     |
   fw_dnld_over             |         ...
    if (priv->fw_dnld.fw)   |
    release_firmware        |
     kfree(fw); //(2)       |
     ...                    |         priv->fw_dnld.fw = NULL;

When the fw_dnld_rx_work work item is executing, we detach the device.
The release_firmware() will deallocate firmware in position (1),
but firmware will be deallocated again in position (2), which
leads to double free.

The race between fw_dnld_rx_work() and fw_dnld_timeout()
can be shown as below:

   (Thread 1)               |      (Thread 2)
                            |       fw_dnld_rx_work
                            |        fw_dnld_over
                            |         release_firmware
                            |          kfree(fw); //(1)
fw_dnld_timeout             |
 fw_dnld_over               |         ...
  if (priv->fw_dnld.fw)     |
   release_firmware         |
    kfree(fw); //(2)        |
     ...                    |         priv->fw_dnld.fw = NULL;

The release_firmware() will deallocate firmware in position (1),
but firmware will be deallocated again in position (2), which
leads to double free.

The race between fw_dnld_timeout() and nfcmrvl_nci_unregister_dev()
can be shown as below.

   (Thread 1)               |      (Thread 2)
                            |     nfcmrvl_disconnect
                            |      nfcmrvl_nci_unregister_dev
                            |       nfcmrvl_fw_dnld_abort
                            |        fw_dnld_over
                            |         release_firmware
                            |          kfree(fw); //(1)
fw_dnld_timeout             |
 fw_dnld_over               |         ...
  if (priv->fw_dnld.fw)     |
   release_firmware         |
    kfree(fw); //(2)        |
     ...                    |         priv->fw_dnld.fw = NULL;

The release_firmware() will deallocate firmware in position (1),
but firmware will be deallocated again in position (2), which
leads to double free.

This patch adds spin_lock_irq in fw_dnld_over() in order to synchronize
among different threads that call fw_dnld_over(). The priv->fw_dnld.fw will
be set to NULL after work item is finished and fw_dnld_over() called by
other threads will check whether priv->fw_dnld.fw is NULL. So the double
free bug could be prevented.

Fixes: 3194c6870158e3 ("NFC: nfcmrvl: add firmware download support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Lin Ma <linma@zju.edu.cn>
---
Changes in V3:
  - Make commit message more clearer.
  - Use spin_lock_irq to synchronize.

 drivers/nfc/nfcmrvl/fw_dnld.c | 3 +++
 drivers/nfc/nfcmrvl/fw_dnld.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
index e83f65596a8..c22a4556db5 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -92,12 +92,14 @@ static struct sk_buff *alloc_lc_skb(struct nfcmrvl_private *priv, uint8_t plen)
 
 static void fw_dnld_over(struct nfcmrvl_private *priv, u32 error)
 {
+	spin_lock_irq(&priv->fw_dnld.lock);
 	if (priv->fw_dnld.fw) {
 		release_firmware(priv->fw_dnld.fw);
 		priv->fw_dnld.fw = NULL;
 		priv->fw_dnld.header = NULL;
 		priv->fw_dnld.binary_config = NULL;
 	}
+	spin_unlock_irq(&priv->fw_dnld.lock);
 
 	atomic_set(&priv->ndev->cmd_cnt, 0);
 
@@ -451,6 +453,7 @@ int nfcmrvl_fw_dnld_init(struct nfcmrvl_private *priv)
 	if (!priv->fw_dnld.rx_wq)
 		return -ENOMEM;
 	skb_queue_head_init(&priv->fw_dnld.rx_q);
+	spin_lock_init(&priv->fw_dnld.lock);
 	return 0;
 }
 
diff --git a/drivers/nfc/nfcmrvl/fw_dnld.h b/drivers/nfc/nfcmrvl/fw_dnld.h
index 7c4d91b0191..e4fe0fb8aff 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.h
+++ b/drivers/nfc/nfcmrvl/fw_dnld.h
@@ -75,6 +75,8 @@ struct nfcmrvl_fw_dnld {
 	struct sk_buff_head rx_q;
 
 	struct timer_list timer;
+	/* To synchronize among different threads that call fw_dnld_over.*/
+	spinlock_t lock;
 };
 
 int nfcmrvl_fw_dnld_init(struct nfcmrvl_private *priv);
-- 
2.17.1

