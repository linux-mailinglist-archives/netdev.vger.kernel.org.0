Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C725329D9C8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390006AbgJ1XCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731974AbgJ1XBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:01:38 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EBEC0613D1;
        Wed, 28 Oct 2020 16:01:38 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id s21so1355516oij.0;
        Wed, 28 Oct 2020 16:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c2/gqc31dmi9zA2aGWplgme+HPGKlgH66xNk9nHvWto=;
        b=bWYaHqkYPc2iXRaUYFoKv/DT1zz6MURWRCPi1TvR3qcDkoPbIekEzmPv9fA0tiUUHV
         qLFaTfhYLwHIj4DXvnVBM9C9ZBrKzo9LkCpod1qq6woIR35hdnu1t+ycFMMKMOAj/Ouh
         Q9AFojKT/trJllLTlX57BeemiX4Z1mRdSwoct7hXd8Vp7B1FgQsbEKOFHWUALeuneMxD
         +RmzbZcrmxneBDs0XbGHQVgyB7Gh6cHVgphxBLSAspUH3QSEjFRkshzy5HcGkHRJf9+U
         1cssz7sw1CpiMz1/fstMDGMBE2Jx5Wwgp5KyeFceoBBZV7jPIDSN+/Jvrpnb8p6qcPI8
         9TFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c2/gqc31dmi9zA2aGWplgme+HPGKlgH66xNk9nHvWto=;
        b=ZXIpwFAWqyOev8e2wEk5q2uqdZN0pMMnhGZRx1rab+VtWzjUm39BJNnP2QIZuvQUO7
         J3AXgyx2mmZ11o7NN1Xn6Kf+rwf21bl9X2P6dVKZoSRL/IGDOsfvHFMo0LSLtQuoDCU7
         hmGu7JryFsLhP3dJgzyAPGk1okLGWesPpVS+NNFuzNuqcF+/ossP3ReFmrIH4Fd4F3NH
         WRk2pvTP47sLNDDqOnaL1l5W7OCGMw96X/9py5d1GEDyGcwW44Ho6DfloxcoJ6tsekr9
         bLIzcCxTGQITAUEnroFGgeCuQ5VSpDSjO6SqxeMuLaS/udiqCZ+hNlN0iMvFzkYb7FWe
         VQog==
X-Gm-Message-State: AOAM530+TypIMzU2COnLGc30l7gCm4IwUZ66cj+UneybQvHSJntJmaJ0
        X04JplqoOYIeB+aWYFzRGLmc+LfYuFg3LFIa
X-Google-Smtp-Source: ABdhPJxovUxraliBkm/Bf6MK9y9XXJoeXrAW+xnL9AzhQOMP3GGXkLU/zxjXzieF+ZVTF8XwxspNyw==
X-Received: by 2002:a17:90a:5885:: with SMTP id j5mr7498189pji.117.1603895264368;
        Wed, 28 Oct 2020 07:27:44 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id n25sm5977673pgd.67.2020.10.28.07.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:27:43 -0700 (PDT)
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
Subject: [RFC PATCH] mwifiex: pcie: use shutdown_sw()/reinit_sw() on suspend/resume
Date:   Wed, 28 Oct 2020 23:27:19 +0900
Message-Id: <20201028142719.18765-1-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Microsoft Surface devices (PCIe-88W8897), there are issues with S0ix
achievement and AP scanning after suspend with the current Host Sleep
method.

When using the Host Sleep method, it prevents the platform to reach S0ix
during suspend. Also, sometimes AP scanning won't work, resulting in
non-working wifi after suspend.

To fix such issues, perform shutdown_sw()/reinit_sw() instead of Host
Sleep on suspend/resume.

Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
---
As a side effect, this patch disables wakeups (means that Wake-On-WLAN
can't be used anymore, if it was working before), and might also reset
some internal states.

Of course it's the best to rather fix Host Sleep itself. But if it's
difficult, I'm afraid we have to go this way.

I reused the contents of suspend()/resume() functions as much as possible,
and removed only the parts that are incompatible or redundant with
shutdown_sw()/reinit_sw().

- Removed wait_for_completion() as redundant
  mwifiex_shutdown_sw() does this.
- Removed flush_workqueue() as incompatible
  Causes kernel crashing.
- Removed mwifiex_enable_wake()/mwifiex_disable_wake()
  as incompatible and redundant because the driver will be shut down
  instead of entering Host Sleep.

I'm worried about why flush_workqueue() causes kernel crash with this
suspend method. Is it OK to just drop it? At least We Microsoft Surface
devices users used this method for about one month and haven't observed
any issues.

Note that suspend() no longer checks if it's already suspended.
With the previous Host Sleep method, the check was done by looking at
adapter->hs_activated in mwifiex_enable_hs() [sta_ioctl.c], but not
MWIFIEX_IS_SUSPENDED. So, what the previous method checked was instead
Host Sleep state, not suspend itself.

Therefore, there is no need to check the suspend state now.
Also removed comment for suspend state check at top of suspend()
accordingly.

 drivers/net/wireless/marvell/mwifiex/pcie.c | 29 +++++++--------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 6a10ff0377a24..3b5c614def2f5 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -293,8 +293,7 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
  * registered functions must have drivers with suspend and resume
  * methods. Failing that the kernel simply removes the whole card.
  *
- * If already not suspended, this function allocates and sends a host
- * sleep activate request to the firmware and turns off the traffic.
+ * This function shuts down the adapter.
  */
 static int mwifiex_pcie_suspend(struct device *dev)
 {
@@ -302,31 +301,21 @@ static int mwifiex_pcie_suspend(struct device *dev)
 	struct pcie_service_card *card = dev_get_drvdata(dev);
 
 
-	/* Might still be loading firmware */
-	wait_for_completion(&card->fw_done);
-
 	adapter = card->adapter;
 	if (!adapter) {
 		dev_err(dev, "adapter is not valid\n");
 		return 0;
 	}
 
-	mwifiex_enable_wake(adapter);
-
-	/* Enable the Host Sleep */
-	if (!mwifiex_enable_hs(adapter)) {
+	/* Shut down SW */
+	if (mwifiex_shutdown_sw(adapter)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "cmd: failed to suspend\n");
-		clear_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
-		mwifiex_disable_wake(adapter);
 		return -EFAULT;
 	}
 
-	flush_workqueue(adapter->workqueue);
-
 	/* Indicate device suspended */
 	set_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
-	clear_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
 
 	return 0;
 }
@@ -336,13 +325,13 @@ static int mwifiex_pcie_suspend(struct device *dev)
  * registered functions must have drivers with suspend and resume
  * methods. Failing that the kernel simply removes the whole card.
  *
- * If already not resumed, this function turns on the traffic and
- * sends a host sleep cancel request to the firmware.
+ * If already not resumed, this function reinits the adapter.
  */
 static int mwifiex_pcie_resume(struct device *dev)
 {
 	struct mwifiex_adapter *adapter;
 	struct pcie_service_card *card = dev_get_drvdata(dev);
+	int ret;
 
 
 	if (!card->adapter) {
@@ -360,9 +349,11 @@ static int mwifiex_pcie_resume(struct device *dev)
 
 	clear_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
 
-	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
-			  MWIFIEX_ASYNC_CMD);
-	mwifiex_disable_wake(adapter);
+	ret = mwifiex_reinit_sw(adapter);
+	if (ret)
+		dev_err(dev, "reinit failed: %d\n", ret);
+	else
+		mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
 
 	return 0;
 }
-- 
2.29.1

