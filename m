Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49FA500571
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 07:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239856AbiDNFeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 01:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239866AbiDNFeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 01:34:12 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CFD83BA6F;
        Wed, 13 Apr 2022 22:31:47 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgDHr_KqsVdi+oM1AQ--.59165S5;
        Thu, 14 Apr 2022 13:31:41 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzk@kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org, linma@zju.edu.cn,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 3/3] drivers: nfc: nfcmrvl: fix use-after-free bug in nfcmrvl_fw_dnld_start()
Date:   Thu, 14 Apr 2022 13:31:22 +0800
Message-Id: <67e074f0c8e538caa2d2cd0eb49936e112249839.1649913521.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1649913521.git.duoming@zju.edu.cn>
References: <cover.1649913521.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1649913521.git.duoming@zju.edu.cn>
References: <cover.1649913521.git.duoming@zju.edu.cn>
X-CM-TRANSID: cS_KCgDHr_KqsVdi+oM1AQ--.59165S5
X-Coremail-Antispam: 1UD129KBjvJXoW7uw15Cw1xZr4Dtw15GrykKrg_yoW8Wr47pF
        43AFyrAw4Yk3yYqFn5trnxGrs8Zw4xCFyUKF9F9FyfZF90vFW8Ar1kK34rZr1qgw4UXay5
        CwnIy34UuF4vyF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgITAVZdtZLd3gAisf
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are potential use-after-free bug in nfcmrvl_fw_dnld_start().
The race between nfcmrvl_disconnect() and nfcmrvl_fw_dnld_start()
can be shown as below:

   (USE)                      |      (FREE)
                              | nfcmrvl_disconnect
                              |  nfcmrvl_nci_unregister_dev
                              |   nfcmrvl_fw_dnld_abort
                              |    fw_dnld_over
nfcmrvl_fw_dnld_start         |     release_firmware
 ...                          |      kfree(fw) //(1)
  priv->fw_dnld.fw->data //(2)|      ...
   ...                        |

The firmware is deallocate in position (1), but it is used in position
(2), which leads to UAF bug.

This patch add spin_lock() and check in nfcmrvl_fw_dnld_start()
in order to synchronize with other threads that could free firmware.
Therefore, the UAF bug could be prevented.

Fixes: 3194c6870158e3 ("NFC: nfcmrvl: add firmware download support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/nfc/nfcmrvl/fw_dnld.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
index bb9e7e2bdec..910f6eaec65 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -511,7 +511,10 @@ int nfcmrvl_fw_dnld_start(struct nci_dev *ndev, const char *firmware_name)
 		return -ENOENT;
 	}
 
-	fw_dnld->header = (const struct nfcmrvl_fw *) priv->fw_dnld.fw->data;
+	spin_lock(&priv->fw_dnld.lock);
+	if (priv->fw_dnld.fw)
+		fw_dnld->header = (const struct nfcmrvl_fw *)priv->fw_dnld.fw->data;
+	spin_unlock(&priv->fw_dnld.lock);
 
 	if (fw_dnld->header->magic != NFCMRVL_FW_MAGIC ||
 	    fw_dnld->header->phy != priv->phy) {
-- 
2.17.1

