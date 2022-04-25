Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26AB50DD6B
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238353AbiDYKCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235411AbiDYKB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:01:58 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21070B35;
        Mon, 25 Apr 2022 02:58:53 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app3 (Coremail) with SMTP id cC_KCgCnb3nQcGZi0MTyAg--.60947S2;
        Mon, 25 Apr 2022 17:58:45 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzysztof.kozlowski@linaro.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linma@zju.edu.cn, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net V2] nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
Date:   Mon, 25 Apr 2022 17:58:38 +0800
Message-Id: <20220425095838.100882-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgCnb3nQcGZi0MTyAg--.60947S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAFW5Xw43WrWUAw17ZFy7Wrg_yoWrXw13pF
        4YgFy5CF1DKr4FqFs8tF4qqFyfuFZ3GFW5Cry7tr93Aws0yFWvyw1qyay5ZFsruryUJFWY
        ka43A3s8GF4vyF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvm1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_
        JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
        c2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VU1a9aPUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgcLAVZdtZZG5wATsV
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
to avoid the double-free, UAF and NPD bugs, as nci_unregister_device
is well synchronized and won't return if there is a running routine.
This was mentioned in commit 3e3b5dfcd16a ("NFC: reorder the logic in
nfc_{un,}register_device").

Fixes: 3194c6870158 ("NFC: nfcmrvl: add firmware download support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in V2:
  - Correct the subject prefix.

 drivers/nfc/nfcmrvl/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.17.1

