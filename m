Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA570502F7B
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 22:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350457AbiDOUGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 16:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350369AbiDOUGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 16:06:01 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130F2AD100;
        Fri, 15 Apr 2022 13:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1650053010; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=X8XqTX5Aa+xTio1ILtRRVmNUUVfRikfaXwMfFs7ihhg=;
        b=unBceM8U0rPwtfJS1oOhnosDflzBeEUkwZOraybpOPDlXlgDIRhOYTF8O3hePf+Fcn38Jm
        g5/G8Dpm4UTyyRPnmeqj70/eeHeqJAeXGkHYGZnfJ0ta0xGGF4Sr2KfrqR9jZgLQw4xV6p
        wgsMwHWRfL7iYf602cQV8wG5oa94/X8=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH] brcmfmac: Remove #ifdef guards for PM related functions
Date:   Fri, 15 Apr 2022 21:03:22 +0100
Message-Id: <20220415200322.7511-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new DEFINE_SIMPLE_DEV_PM_OPS() and pm_sleep_ptr() macros to
handle the .suspend/.resume callbacks.

These macros allow the suspend and resume functions to be automatically
dropped by the compiler when CONFIG_SUSPEND is disabled, without having
to use #ifdef guards. The advantage is then that these functions are not
conditionally compiled.

Some other functions not directly called by the .suspend/.resume
callbacks, but still related to PM were also taken outside #ifdef
guards.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      | 44 +++++++------------
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  5 +--
 .../broadcom/brcm80211/brcmfmac/sdio.h        | 16 -------
 3 files changed, 19 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index ac02244a6fdf..a8cf5a570101 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -784,7 +784,6 @@ void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->txglomsz = sdiodev->settings->bus.sdio.txglomsz;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int brcmf_sdiod_freezer_attach(struct brcmf_sdio_dev *sdiodev)
 {
 	sdiodev->freezer = kzalloc(sizeof(*sdiodev->freezer), GFP_KERNEL);
@@ -833,7 +832,8 @@ static void brcmf_sdiod_freezer_off(struct brcmf_sdio_dev *sdiodev)
 
 bool brcmf_sdiod_freezing(struct brcmf_sdio_dev *sdiodev)
 {
-	return atomic_read(&sdiodev->freezer->freezing);
+	return IS_ENABLED(CONFIG_PM_SLEEP) &&
+		atomic_read(&sdiodev->freezer->freezing);
 }
 
 void brcmf_sdiod_try_freeze(struct brcmf_sdio_dev *sdiodev)
@@ -847,24 +847,16 @@ void brcmf_sdiod_try_freeze(struct brcmf_sdio_dev *sdiodev)
 
 void brcmf_sdiod_freezer_count(struct brcmf_sdio_dev *sdiodev)
 {
-	atomic_inc(&sdiodev->freezer->thread_count);
+	if (IS_ENABLED(CONFIG_PM_SLEEP))
+		atomic_inc(&sdiodev->freezer->thread_count);
 }
 
 void brcmf_sdiod_freezer_uncount(struct brcmf_sdio_dev *sdiodev)
 {
-	atomic_dec(&sdiodev->freezer->thread_count);
-}
-#else
-static int brcmf_sdiod_freezer_attach(struct brcmf_sdio_dev *sdiodev)
-{
-	return 0;
+	if (IS_ENABLED(CONFIG_PM_SLEEP))
+		atomic_dec(&sdiodev->freezer->thread_count);
 }
 
-static void brcmf_sdiod_freezer_detach(struct brcmf_sdio_dev *sdiodev)
-{
-}
-#endif /* CONFIG_PM_SLEEP */
-
 int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 {
 	sdiodev->state = BRCMF_SDIOD_DOWN;
@@ -873,7 +865,8 @@ int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 		sdiodev->bus = NULL;
 	}
 
-	brcmf_sdiod_freezer_detach(sdiodev);
+	if (IS_ENABLED(CONFIG_PM_SLEEP))
+		brcmf_sdiod_freezer_detach(sdiodev);
 
 	/* Disable Function 2 */
 	sdio_claim_host(sdiodev->func2);
@@ -949,9 +942,11 @@ int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 		goto out;
 	}
 
-	ret = brcmf_sdiod_freezer_attach(sdiodev);
-	if (ret)
-		goto out;
+	if (IS_ENABLED(CONFIG_PM_SLEEP)) {
+		ret = brcmf_sdiod_freezer_attach(sdiodev);
+		if (ret)
+			goto out;
+	}
 
 	/* try to attach to the target device */
 	sdiodev->bus = brcmf_sdio_probe(sdiodev);
@@ -1124,7 +1119,6 @@ void brcmf_sdio_wowl_config(struct device *dev, bool enabled)
 	sdiodev->wowl_enabled = enabled;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int brcmf_ops_sdio_suspend(struct device *dev)
 {
 	struct sdio_func *func;
@@ -1199,11 +1193,9 @@ static int brcmf_ops_sdio_resume(struct device *dev)
 	return ret;
 }
 
-static const struct dev_pm_ops brcmf_sdio_pm_ops = {
-	.suspend	= brcmf_ops_sdio_suspend,
-	.resume		= brcmf_ops_sdio_resume,
-};
-#endif	/* CONFIG_PM_SLEEP */
+static DEFINE_SIMPLE_DEV_PM_OPS(brcmf_sdio_pm_ops,
+				brcmf_ops_sdio_suspend,
+				brcmf_ops_sdio_resume);
 
 static struct sdio_driver brcmf_sdmmc_driver = {
 	.probe = brcmf_ops_sdio_probe,
@@ -1212,9 +1204,7 @@ static struct sdio_driver brcmf_sdmmc_driver = {
 	.id_table = brcmf_sdmmc_ids,
 	.drv = {
 		.owner = THIS_MODULE,
-#ifdef CONFIG_PM_SLEEP
-		.pm = &brcmf_sdio_pm_ops,
-#endif	/* CONFIG_PM_SLEEP */
+		.pm = pm_sleep_ptr(&brcmf_sdio_pm_ops),
 		.coredump = brcmf_dev_coredump,
 	},
 };
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 55285cad527f..d34797a214ba 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4020,15 +4020,14 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	 */
 	brcmf_sdiod_sgtable_alloc(sdiodev);
 
-#ifdef CONFIG_PM_SLEEP
 	/* wowl can be supported when KEEP_POWER is true and (WAKE_SDIO_IRQ
 	 * is true or when platform data OOB irq is true).
 	 */
-	if ((sdio_get_host_pm_caps(sdiodev->func1) & MMC_PM_KEEP_POWER) &&
+	if (IS_ENABLED(CONFIG_PM_SLEEP) &&
+	    (sdio_get_host_pm_caps(sdiodev->func1) & MMC_PM_KEEP_POWER) &&
 	    ((sdio_get_host_pm_caps(sdiodev->func1) & MMC_PM_WAKE_SDIO_IRQ) ||
 	     (sdiodev->settings->bus.sdio.oob_irq_supported)))
 		sdiodev->bus_if->wowl_supported = true;
-#endif
 
 	if (brcmf_sdio_kso_init(bus)) {
 		brcmf_err("error enabling KSO\n");
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 15d2c02fa3ec..47351ff458ca 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -346,26 +346,10 @@ int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, struct sdio_func *func);
 void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
 			      enum brcmf_sdiod_state state);
-#ifdef CONFIG_PM_SLEEP
 bool brcmf_sdiod_freezing(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdiod_try_freeze(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdiod_freezer_count(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdiod_freezer_uncount(struct brcmf_sdio_dev *sdiodev);
-#else
-static inline bool brcmf_sdiod_freezing(struct brcmf_sdio_dev *sdiodev)
-{
-	return false;
-}
-static inline void brcmf_sdiod_try_freeze(struct brcmf_sdio_dev *sdiodev)
-{
-}
-static inline void brcmf_sdiod_freezer_count(struct brcmf_sdio_dev *sdiodev)
-{
-}
-static inline void brcmf_sdiod_freezer_uncount(struct brcmf_sdio_dev *sdiodev)
-{
-}
-#endif /* CONFIG_PM_SLEEP */
 
 int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev);
 int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev);
-- 
2.35.1

