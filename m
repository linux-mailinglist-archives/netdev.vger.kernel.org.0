Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B74557A89
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbiFWMmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiFWMmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:42:38 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123334991E;
        Thu, 23 Jun 2022 05:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1655988152; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=0wMZkfhKmaBVieQjspEnioAUmjxOfe2EjfUYozTaP3s=;
        b=CvykSZkFx+kydcC3E7oAXMiJF5UYAR3nUcVoBRQSuSrERA24g624uH6hi2n2DCGQ5r3psU
        3IFIQ0W5vkdZqVWnfA8+cv+QAvG4UCqz1/P7wYHZQyEAXB3Sicm2gBMoIw/oa5UpFtU3tv
        39krHrS+SUPAvT8D1xP4AkB/RC34rRE=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH v2] brcmfmac: Remove #ifdef guards for PM related functions
Date:   Thu, 23 Jun 2022 13:42:21 +0100
Message-Id: <20220623124221.18238-1-paul@crapouillou.net>
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
to use #ifdef guards.

Some other functions not directly called by the .suspend/.resume
callbacks, but still related to PM were also taken outside #ifdef
guards.

The advantage is then that these functions are now always compiled
independently of any Kconfig option, and thanks to that bugs and
regressions are easier to catch.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---

Notes:
    v2:
    - Move checks for IS_ENABLED(CONFIG_PM_SLEEP) inside functions to keep
      the calling functions intact.
    - Reword the commit message to explain why this patch is useful.

 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      | 38 +++++++------------
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  5 +--
 .../broadcom/brcm80211/brcmfmac/sdio.h        | 16 --------
 3 files changed, 16 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 9c598ea97499..11ad878a906b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -784,9 +784,11 @@ void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
 	sdiodev->txglomsz = sdiodev->settings->bus.sdio.txglomsz;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int brcmf_sdiod_freezer_attach(struct brcmf_sdio_dev *sdiodev)
 {
+	if (!IS_ENABLED(CONFIG_PM_SLEEP))
+		return 0;
+
 	sdiodev->freezer = kzalloc(sizeof(*sdiodev->freezer), GFP_KERNEL);
 	if (!sdiodev->freezer)
 		return -ENOMEM;
@@ -799,7 +801,7 @@ static int brcmf_sdiod_freezer_attach(struct brcmf_sdio_dev *sdiodev)
 
 static void brcmf_sdiod_freezer_detach(struct brcmf_sdio_dev *sdiodev)
 {
-	if (sdiodev->freezer) {
+	if (IS_ENABLED(CONFIG_PM_SLEEP) && sdiodev->freezer) {
 		WARN_ON(atomic_read(&sdiodev->freezer->freezing));
 		kfree(sdiodev->freezer);
 	}
@@ -833,7 +835,8 @@ static void brcmf_sdiod_freezer_off(struct brcmf_sdio_dev *sdiodev)
 
 bool brcmf_sdiod_freezing(struct brcmf_sdio_dev *sdiodev)
 {
-	return atomic_read(&sdiodev->freezer->freezing);
+	return IS_ENABLED(CONFIG_PM_SLEEP) &&
+		atomic_read(&sdiodev->freezer->freezing);
 }
 
 void brcmf_sdiod_try_freeze(struct brcmf_sdio_dev *sdiodev)
@@ -847,24 +850,16 @@ void brcmf_sdiod_try_freeze(struct brcmf_sdio_dev *sdiodev)
 
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
@@ -1136,7 +1131,6 @@ void brcmf_sdio_wowl_config(struct device *dev, bool enabled)
 	brcmf_dbg(SDIO, "WOWL not supported\n");
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int brcmf_ops_sdio_suspend(struct device *dev)
 {
 	struct sdio_func *func;
@@ -1204,11 +1198,9 @@ static int brcmf_ops_sdio_resume(struct device *dev)
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
@@ -1217,9 +1209,7 @@ static struct sdio_driver brcmf_sdmmc_driver = {
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
index 212fbbe1cd7e..58ed6b70f8c5 100644
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

