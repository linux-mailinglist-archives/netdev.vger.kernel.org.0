Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32F84FACEF
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiDJIdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235703AbiDJIdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:33:46 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEFD25A092;
        Sun, 10 Apr 2022 01:31:36 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgD3_6fdlVJiTNwDAQ--.8607S2;
        Sun, 10 Apr 2022 16:31:29 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzk@kernel.org, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH] drivers: nfc: nfcmrvl: fix double free bug in nfcmrvl_nci_unregister_dev()
Date:   Sun, 10 Apr 2022 16:31:25 +0800
Message-Id: <20220410083125.62909-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgD3_6fdlVJiTNwDAQ--.8607S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KFy7XF17GFWkKw17WFy3Jwb_yoW8AryxpF
        45WF1rAw1DKFWYqFsYyrsxtFy5Ca13GryUGFZxAas3Zw1YvFWvywnFyFy8XrnFqrWDJayY
        kwsxAa4UWF4vyr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUka1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
        6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr
        1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUp6wZUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgAQAVZdtZHR5QACsK
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a potential double bug in nfcmrvl usb driver between
unregister and resume operation.

The race that cause that double free bug can be shown as below:

   (FREE)                   |      (USE)
                            | nfcmrvl_resume
                            |  nfcmrvl_submit_bulk_urb
                            |   nfcmrvl_bulk_complete
                            |    nfcmrvl_nci_recv_frame
                            |     nfcmrvl_fw_dnld_recv_frame
                            |      queue_work
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
     ...                    |         fw = NULL;

When nfcmrvl usb driver is resuming, we detach the device.
The release_firmware() will deallocate firmware in position (1),
but firmware will be deallocated again in position (2), which
leads to double free.

This patch reorders nfcmrvl_fw_dnld_deinit() before nfcmrvl_fw_dnld_abort()
in order to prevent double free bug. Because destroy_workqueue() will
not return until all work is finished.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/nfc/nfcmrvl/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
index 2fcf545012b..d8342271f50 100644
--- a/drivers/nfc/nfcmrvl/main.c
+++ b/drivers/nfc/nfcmrvl/main.c
@@ -183,11 +183,10 @@ void nfcmrvl_nci_unregister_dev(struct nfcmrvl_private *priv)
 {
 	struct nci_dev *ndev = priv->ndev;
 
+	nfcmrvl_fw_dnld_deinit(priv);
 	if (priv->ndev->nfc_dev->fw_download_in_progress)
 		nfcmrvl_fw_dnld_abort(priv);
 
-	nfcmrvl_fw_dnld_deinit(priv);
-
 	if (gpio_is_valid(priv->config.reset_n_io))
 		gpio_free(priv->config.reset_n_io);
 
-- 
2.17.1

