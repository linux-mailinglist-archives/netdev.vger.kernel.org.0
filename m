Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3773C51026F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 18:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352731AbiDZQDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352739AbiDZQDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:03:13 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1EBCEDFEB;
        Tue, 26 Apr 2022 09:00:03 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgD3eRDQFmhiS6HXAQ--.38008S2;
        Tue, 26 Apr 2022 23:59:17 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        broonie@kernel.org, akpm@linux-foundation.org, linma@zju.edu.cn,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v3] nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
Date:   Tue, 26 Apr 2022 23:59:11 +0800
Message-Id: <20220426155911.77761-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgD3eRDQFmhiS6HXAQ--.38008S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKw1UGF47Jw15WF4kAF4fXwb_yoW7Aw1kpF
        4FgFy3Cr1DKr4rXr45tF4DGFyruFZ3CFWrCryxtryfCws0yFWktr1vyay5ZFnrZrWUAFWY
        ka43A348WFsYvFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvl1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r10
        6r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28I
        cxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
        DU0xZFpf9x0JUZa9-UUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAg4MAVZdtZafogAJsd
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
Changes in v3:
  - Add bool variable to synchronize.
  - Make commit message clearer.

 drivers/nfc/nfcmrvl/main.c | 2 +-
 net/nfc/core.c             | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

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
index dc7a2404efd..da8199f67d4 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -25,6 +25,7 @@
 #define NFC_CHECK_PRES_FREQ_MS	2000
 
 int nfc_devlist_generation;
+bool nfc_download;
 DEFINE_MUTEX(nfc_devlist_mutex);
 
 /* NFC device ID bitmap */
@@ -38,7 +39,7 @@ int nfc_fw_download(struct nfc_dev *dev, const char *firmware_name)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!device_is_registered(&dev->dev) || !nfc_download) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -1134,6 +1135,7 @@ int nfc_register_device(struct nfc_dev *dev)
 			dev->rfkill = NULL;
 		}
 	}
+	nfc_download = true;
 	device_unlock(&dev->dev);
 
 	rc = nfc_genl_device_added(dev);
@@ -1166,6 +1168,7 @@ void nfc_unregister_device(struct nfc_dev *dev)
 		rfkill_unregister(dev->rfkill);
 		rfkill_destroy(dev->rfkill);
 	}
+	nfc_download = false;
 	device_unlock(&dev->dev);
 
 	if (dev->ops->check_presence) {
-- 
2.17.1

