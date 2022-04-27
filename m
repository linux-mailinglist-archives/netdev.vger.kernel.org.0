Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9C8510DD5
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 03:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiD0BSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 21:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356638AbiD0BSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 21:18:47 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D34342CE2F;
        Tue, 26 Apr 2022 18:15:33 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app3 (Coremail) with SMTP id cC_KCgDXKMkCmWhiN_ARAw--.54568S2;
        Wed, 27 Apr 2022 09:14:49 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        linma@zju.edu.cn, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v4] nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
Date:   Wed, 27 Apr 2022 09:14:38 +0800
Message-Id: <20220427011438.110582-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgDXKMkCmWhiN_ARAw--.54568S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKw1UGF47Jw15WF4kAF4fXwb_yoW7CF1xpF
        4FgFyakF1DKr4rWr45tF4DGFyruFZ7GFWrCryxKryfCrs0yFWktF1qyay5ZFnrWrWUAFWY
        ka43A348WFsYvFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgMMAVZdtZasRQAZsU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are destructive operations such as nfcmrvl_fw_dnld_abort and
gpio_free in nfcmrvl_nci_unregister_dev. The resources such as firmware,
gpio and so on could be destructed while the upper layer functions such as
nfcmrvl_fw_dnld_start and nfcmrvl_nci_recv_frame is executing, which leads
to double-free, use-after-free and null-ptr-deref bugs.

There are three situations that could lead to double-free bugs.

The first situation is shown below:

   (Thread 1)                 |      (Thread 2)
nfcmrvl_fw_dnld_start         |
 ...                          |  nfcmrvl_nci_unregister_dev
 release_firmware()           |   nfcmrvl_fw_dnld_abort
  kfree(fw) //(1)             |    fw_dnld_over
                              |     release_firmware
  ...                         |      kfree(fw) //(2)
                              |     ...

The second situation is shown below:

   (Thread 1)                 |      (Thread 2)
nfcmrvl_fw_dnld_start         |
 ...                          |
 mod_timer                    |
 (wait a time)                |
 fw_dnld_timeout              |  nfcmrvl_nci_unregister_dev
   fw_dnld_over               |   nfcmrvl_fw_dnld_abort
    release_firmware          |    fw_dnld_over
     kfree(fw) //(1)          |     release_firmware
     ...                      |      kfree(fw) //(2)

The third situation is shown below:

       (Thread 1)               |       (Thread 2)
nfcmrvl_nci_recv_frame          |
 if(..->fw_download_in_progress)|
  nfcmrvl_fw_dnld_recv_frame    |
   queue_work                   |
                                |
fw_dnld_rx_work                 | nfcmrvl_nci_unregister_dev
 fw_dnld_over                   |  nfcmrvl_fw_dnld_abort
  release_firmware              |   fw_dnld_over
   kfree(fw) //(1)              |    release_firmware
                                |     kfree(fw) //(2)

The firmware struct is deallocated in position (1) and deallocated
in position (2) again.

The crash trace triggered by POC is like below:

[  122.640457] BUG: KASAN: double-free or invalid-free in fw_dnld_over+0x28/0xf0
[  122.640457] Call Trace:
[  122.640457]  <TASK>
[  122.640457]  kfree+0xb0/0x330
[  122.640457]  fw_dnld_over+0x28/0xf0
[  122.640457]  nfcmrvl_nci_unregister_dev+0x61/0x70
[  122.640457]  nci_uart_tty_close+0x87/0xd0
[  122.640457]  tty_ldisc_kill+0x3e/0x80
[  122.640457]  tty_ldisc_hangup+0x1b2/0x2c0
[  122.640457]  __tty_hangup.part.0+0x316/0x520
[  122.640457]  tty_release+0x200/0x670
[  122.640457]  __fput+0x110/0x410
[  122.640457]  task_work_run+0x86/0xd0
[  122.640457]  exit_to_user_mode_prepare+0x1aa/0x1b0
[  122.640457]  syscall_exit_to_user_mode+0x19/0x50
[  122.640457]  do_syscall_64+0x48/0x90
[  122.640457]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  122.640457] RIP: 0033:0x7f68433f6beb

What's more, there are also use-after-free and null-ptr-deref bugs
in nfcmrvl_fw_dnld_start. If we deallocate firmware struct, gpio or
set null to the members of priv->fw_dnld in nfcmrvl_nci_unregister_dev,
then, we dereference firmware, gpio or the members of priv->fw_dnld in
nfcmrvl_fw_dnld_start, the UAF or NPD bugs will happen.

This patch reorders destructive operations after nci_unregister_device
and adds bool variable protected by device_lock to synchronize between
cleanup routine and firmware download routine. The process is shown below.

       (Thread 1)               |       (Thread 2)
nfcmrvl_nci_unregister_dev      |
  nci_unregister_device         |
    nfc_unregister_device       | nfc_fw_download
      device_lock()             |
      ...                       |
      nfc_download = false;     |   ...
      device_unlock()           |
  ...                           |   device_lock()
  (destructive operations)      |   if(.. || !nfc_download)
                                |     goto error;
                                | error:
                                |   device_unlock()

If the device is detaching, the download function will goto error.
If the download function is executing, nci_unregister_device will
wait until download function is finished.

Fixes: 3194c6870158 ("NFC: nfcmrvl: add firmware download support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v4:
  - Change bool variable nfc_download to static.

 drivers/nfc/nfcmrvl/main.c | 2 +-
 net/nfc/core.c             | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
index 2fcf545012b..1a5284de434 100644
--- a/drivers/nfc/nfcmrvl/main.c
+++ b/drivers/nfc/nfcmrvl/main.c
@@ -183,6 +183,7 @@ void nfcmrvl_nci_unregister_dev(struct nfcmrvl_private *priv)
 {
 	struct nci_dev *ndev = priv->ndev;
 
+	nci_unregister_device(ndev);
 	if (priv->ndev->nfc_dev->fw_download_in_progress)
 		nfcmrvl_fw_dnld_abort(priv);
 
@@ -191,7 +192,6 @@ void nfcmrvl_nci_unregister_dev(struct nfcmrvl_private *priv)
 	if (gpio_is_valid(priv->config.reset_n_io))
 		gpio_free(priv->config.reset_n_io);
 
-	nci_unregister_device(ndev);
 	nci_free_device(ndev);
 	kfree(priv);
 }
diff --git a/net/nfc/core.c b/net/nfc/core.c
index dc7a2404efd..1d91334ee86 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -25,6 +25,8 @@
 #define NFC_CHECK_PRES_FREQ_MS	2000
 
 int nfc_devlist_generation;
+/* nfc_download: used to judge whether nfc firmware download could start */
+static bool nfc_download;
 DEFINE_MUTEX(nfc_devlist_mutex);
 
 /* NFC device ID bitmap */
@@ -38,7 +40,7 @@ int nfc_fw_download(struct nfc_dev *dev, const char *firmware_name)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!device_is_registered(&dev->dev) || !nfc_download) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -1134,6 +1136,7 @@ int nfc_register_device(struct nfc_dev *dev)
 			dev->rfkill = NULL;
 		}
 	}
+	nfc_download = true;
 	device_unlock(&dev->dev);
 
 	rc = nfc_genl_device_added(dev);
@@ -1166,6 +1169,7 @@ void nfc_unregister_device(struct nfc_dev *dev)
 		rfkill_unregister(dev->rfkill);
 		rfkill_destroy(dev->rfkill);
 	}
+	nfc_download = false;
 	device_unlock(&dev->dev);
 
 	if (dev->ops->check_presence) {
-- 
2.17.1

