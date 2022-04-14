Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73E550056D
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 07:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239865AbiDNFeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 01:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239861AbiDNFeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 01:34:10 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E5273B54F;
        Wed, 13 Apr 2022 22:31:42 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgDHr_KqsVdi+oM1AQ--.59165S4;
        Thu, 14 Apr 2022 13:31:35 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzk@kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org, linma@zju.edu.cn,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH V2 2/3] drivers: nfc: nfcmrvl: fix double free bug in nfc_fw_download_done()
Date:   Thu, 14 Apr 2022 13:31:21 +0800
Message-Id: <538873335b034d7d97a08d2343e898cfa924918a.1649913521.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1649913521.git.duoming@zju.edu.cn>
References: <cover.1649913521.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1649913521.git.duoming@zju.edu.cn>
References: <cover.1649913521.git.duoming@zju.edu.cn>
X-CM-TRANSID: cS_KCgDHr_KqsVdi+oM1AQ--.59165S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1DZFW8KF4ktF15tr43Jrb_yoW8ZFW5pr
        WrGFy2yr4DAr4jvFWrtFyDWrs8Cw47CryUGFZrG3yfZFn8tFyqyr1kGFyrZF4DWr48ta15
        K39xJayjkanYvr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgITAVZdtZLd3gAgsd
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

 drivers/nfc/nfcmrvl/fw_dnld.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
index c22a4556db5..bb9e7e2bdec 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -115,8 +115,10 @@ static void fw_dnld_over(struct nfcmrvl_private *priv, u32 error)
 		/* failed, halt the chip to avoid power consumption */
 		nfcmrvl_chip_halt(priv);
 	}
-
-	nfc_fw_download_done(priv->ndev->nfc_dev, priv->fw_dnld.name, error);
+	spin_lock_irq(&priv->fw_dnld.lock);
+	if (priv->ndev->nfc_dev->fw_download_in_progress)
+		nfc_fw_download_done(priv->ndev->nfc_dev, priv->fw_dnld.name, error);
+	spin_unlock_irq(&priv->fw_dnld.lock);
 }
 
 static void fw_dnld_timeout(struct timer_list *t)
-- 
2.17.1

