Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739CD476B9D
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 09:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbhLPINa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 03:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbhLPIN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 03:13:28 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB980C061751
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 00:13:25 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id e17so988191plh.8
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 00:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=enNvAidD7aC1MSQe5kOL/Uwk02cQQ2m1aOWlTzGJAQU=;
        b=QESxoDtBBXJwq0idcsyzVJiP5Xgi15Hl+mYL2yzNHK8FoVf+XgWIIhgSeJb+uQ2lwT
         BvLzlmXmUcsza25QUAlhHSbSxXQ4QZWx4Jypfq0l6pM/pZCoT8ZsON8ZtD6FOKYoJQu1
         jzXCVLAFTX8b/viIkeznC3Q0f/dGrhHLzBThyVuihiHi3qt32oMqRFIw+oouvM18T94u
         CvypPQOla11GhxWekfkUxtcX9ENOWiapIiumxShhp9FAU2B0wH+WGsvNUoSgiUtdj2Xl
         fyYOZH1KcJrzoMUfWFEEBEplC2E7xgg9hBMSmxIbm4Q25uyHBgbeyysoMg15+PP5fu3l
         jtIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=enNvAidD7aC1MSQe5kOL/Uwk02cQQ2m1aOWlTzGJAQU=;
        b=AKEVlMYef8yFro0KSip040RK40TO3ROsyXI8BdEP8IWDaYOvMqmz52G4iIcthzFgOW
         FSvU0HMMnWGDnRERz3F0DyBs09Qp+UrFtnbYgNYeN0+ws3XfS7Q94qmjmIheCwDtm5L5
         3plTKyHx3z6RwSHi6HkgOmPKjQ2e1qpL4tv6mgfHhqsNnq4/gIyIquVAYY1Xoboub2+m
         F5kqYig9/gzikXLIoFtruf2PgC4fy49w5+iCHoNP/cJXIEwKbzDgDfeyvN+6C5DB7fG8
         fUUG+p8BpHqfEthiVASMzy0AXvDmzZ5149/fwhzlnTkxCxY3axSJIl15vxrWVLw+lT2s
         o9IQ==
X-Gm-Message-State: AOAM533Z7u4iQb1GGeHHE67p8vLwkjSXpYTYZA1+EbttJ2tL8vRVhr7F
        98Jn+U2U5dy6r5pi3UZ1evmc
X-Google-Smtp-Source: ABdhPJwlReClAX9+UMTwttFpEG/42fmLGQdm2dkTiZlLNsC/iQnt2ITEHo589IPN6Cc856LjR77ZJQ==
X-Received: by 2002:a17:902:e750:b0:148:a2e8:277b with SMTP id p16-20020a170902e75000b00148a2e8277bmr8449380plf.130.1639642405385;
        Thu, 16 Dec 2021 00:13:25 -0800 (PST)
Received: from localhost.localdomain ([117.193.208.121])
        by smtp.gmail.com with ESMTPSA id u38sm326835pfg.4.2021.12.16.00.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 00:13:25 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, thomas.perrot@bootlin.com,
        aleksander@aleksander.es, slark_xiao@163.com,
        christophe.jaillet@wanadoo.fr, keescook@chromium.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 07/10] bus: mhi: core: Fix race while handling SYS_ERR at power up
Date:   Thu, 16 Dec 2021 13:42:24 +0530
Message-Id: <20211216081227.237749-8-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
References: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During SYS_ERR condition, as a response to the MHI_RESET from host, some
devices tend to issue BHI interrupt without clearing the SYS_ERR state in
the device. This creates a race condition and causes a failure in booting
up the device.

The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
handling in mhi_async_power_up(). Once the host detects that the device
is in SYS_ERR state, it issues MHI_RESET and waits for the device to
process the reset request. During this time, the device triggers the BHI
interrupt to the host without clearing SYS_ERR condition. So the host
starts handling the SYS_ERR condition again.

To fix this issue, let's register the IRQ handler only after handling the
SYS_ERR check to avoid getting spurious IRQs from the device.

Cc: stable@vger.kernel.org
Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
Reported-by: Aleksander Morgado <aleksander@aleksander.es>
Tested-by: Aleksander Morgado <aleksander@aleksander.es>
Tested-by: Thomas Perrot <thomas.perrot@bootlin.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/pm.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index 7464f5d09973..9ae8532df5a3 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -1038,7 +1038,7 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 	enum mhi_ee_type current_ee;
 	enum dev_st_transition next_state;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
-	u32 val;
+	u32 interval_us = 25000; /* poll register field every 25 milliseconds */
 	int ret;
 
 	dev_info(dev, "Requested to power ON\n");
@@ -1055,10 +1055,6 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 	mutex_lock(&mhi_cntrl->pm_mutex);
 	mhi_cntrl->pm_state = MHI_PM_DISABLE;
 
-	ret = mhi_init_irq_setup(mhi_cntrl);
-	if (ret)
-		goto error_setup_irq;
-
 	/* Setup BHI INTVEC */
 	write_lock_irq(&mhi_cntrl->pm_lock);
 	mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
@@ -1072,7 +1068,7 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 		dev_err(dev, "%s is not a valid EE for power on\n",
 			TO_MHI_EXEC_STR(current_ee));
 		ret = -EIO;
-		goto error_async_power_up;
+		goto error_exit;
 	}
 
 	state = mhi_get_mhi_state(mhi_cntrl);
@@ -1081,20 +1077,12 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 
 	if (state == MHI_STATE_SYS_ERR) {
 		mhi_set_mhi_state(mhi_cntrl, MHI_STATE_RESET);
-		ret = wait_event_timeout(mhi_cntrl->state_event,
-				MHI_PM_IN_FATAL_STATE(mhi_cntrl->pm_state) ||
-					mhi_read_reg_field(mhi_cntrl,
-							   mhi_cntrl->regs,
-							   MHICTRL,
-							   MHICTRL_RESET_MASK,
-							   MHICTRL_RESET_SHIFT,
-							   &val) ||
-					!val,
-				msecs_to_jiffies(mhi_cntrl->timeout_ms));
-		if (!ret) {
-			ret = -EIO;
+		ret = mhi_poll_reg_field(mhi_cntrl, mhi_cntrl->regs, MHICTRL,
+				 MHICTRL_RESET_MASK, MHICTRL_RESET_SHIFT, 0,
+				 interval_us);
+		if (ret) {
 			dev_info(dev, "Failed to reset MHI due to syserr state\n");
-			goto error_async_power_up;
+			goto error_exit;
 		}
 
 		/*
@@ -1104,6 +1092,10 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 		mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
 	}
 
+	ret = mhi_init_irq_setup(mhi_cntrl);
+	if (ret)
+		goto error_exit;
+
 	/* Transition to next state */
 	next_state = MHI_IN_PBL(current_ee) ?
 		DEV_ST_TRANSITION_PBL : DEV_ST_TRANSITION_READY;
@@ -1116,10 +1108,7 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
 
 	return 0;
 
-error_async_power_up:
-	mhi_deinit_free_irq(mhi_cntrl);
-
-error_setup_irq:
+error_exit:
 	mhi_cntrl->pm_state = MHI_PM_DISABLE;
 	mutex_unlock(&mhi_cntrl->pm_mutex);
 
-- 
2.25.1

