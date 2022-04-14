Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FC5500572
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 07:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbiDNFeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 01:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239862AbiDNFeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 01:34:10 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1807A3B3FC;
        Wed, 13 Apr 2022 22:31:42 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgDHr_KqsVdi+oM1AQ--.59165S3;
        Thu, 14 Apr 2022 13:31:32 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzk@kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org, linma@zju.edu.cn,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH V3 1/3] drivers: nfc: nfcmrvl: fix double free bugs caused by fw_dnld_over()
Date:   Thu, 14 Apr 2022 13:31:20 +0800
Message-Id: <1d34425a0ea8a553a66dcf4f22ca55cc920dbb42.1649913521.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1649913521.git.duoming@zju.edu.cn>
References: <cover.1649913521.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1649913521.git.duoming@zju.edu.cn>
References: <cover.1649913521.git.duoming@zju.edu.cn>
X-CM-TRANSID: cS_KCgDHr_KqsVdi+oM1AQ--.59165S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWr47uw4DAry7uw1DGFW5trb_yoWrAF17pF
        45WFykJr1qkr4YgF98ta1DAF98Aw43CrWUGF98Ja4xZrn0yF1vyw1ktay5ZrsFgr4Dta13
        GasxJa4UCFsYyr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvm1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
        c2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgITAVZdtZLd3gAesj
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
index 7c4d91b0191..6974c307947 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.h
+++ b/drivers/nfc/nfcmrvl/fw_dnld.h
@@ -75,6 +75,8 @@ struct nfcmrvl_fw_dnld {
 	struct sk_buff_head rx_q;
 
 	struct timer_list timer;
+	/* To synchronize among different threads that call firmware.*/
+	spinlock_t lock;
 };
 
 int nfcmrvl_fw_dnld_init(struct nfcmrvl_private *priv);
-- 
2.17.1

