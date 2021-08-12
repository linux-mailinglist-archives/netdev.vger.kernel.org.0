Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669363EAB53
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbhHLTvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbhHLTvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 15:51:06 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA39CC061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 12:50:40 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id f11so9999310ioj.3
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 12:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GOarOxSvxcoFvnrPmbTCMPoPjyx0rRztFou8dZUd36s=;
        b=WS24WPgGay3hQgbUIR436kNFc73DRxNzR3maz8Q/Ph21IP6Fpg407QTGxKiL8dFeMN
         9gzxpBAYI2oznD4Gi6IjhQocSIqiv9IDTeseCP8xuHAPb8QPartndvy9p8FL3ZTIUl3m
         y/RHgUXbnXSJOUL5xnqwdCdSEkqStWw0S81nQFgMTMdHFIlMEZo6i8JxEYwqvtyGFkTm
         HKuWXWyc5cdyNHt4utgsJsESyOMojkUTno/4kbpnj+DUS2PinE2PYailtvZbQ/yx+m3q
         a0+JaCudbp46HQPAij2MjeA48cm5zdmnECy9KG6c0Wls7XjOcR9SP2MRen6e2kRZ9Cvm
         1SqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GOarOxSvxcoFvnrPmbTCMPoPjyx0rRztFou8dZUd36s=;
        b=sx3riKQ/ohG2cCKqt5zlXerQT0/DlVO3EiSrV6RaXONetQojGjqkn33KUXOAcSDK+I
         nfbnjRatY/U+blTTW3JwU2As2JMVjFIQn7PmC+5quKbblZ5ThYcPMigB2F8sDd9aqy87
         jXelroHAQRg/50pKMbjaVID8mBq0flNgUD5iJf0FpR6YkySTgF7m8yyLF/DRCCqy4KAv
         BXppavyCe2J6WCc2AuZdkn1moBoKVJ86qflg0ekjY2B3/QXC0qSYRAAF5uAH5k7A6iS+
         aMl7nZDAks0gTjAp37X9WL+boWus9vvr7B1HwNcLuNOr594hGpTHMZbjLTHUqnHV++d0
         x1IQ==
X-Gm-Message-State: AOAM532W/UTrKRpXQXP7fdgpXpNhgEzTPyexiiMlPMZLc05d48Jvhfbj
        6DqUcehsqNpHAjdRxw4RywUJxQ==
X-Google-Smtp-Source: ABdhPJy/9rv232NekVd+M5Ni0VhcYctvIDVA50FozNenTQVCECo7MwQ5xRTKD42TWvSDXQZ///EvUw==
X-Received: by 2002:a05:6602:220e:: with SMTP id n14mr4261919ion.150.1628797840279;
        Thu, 12 Aug 2021 12:50:40 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s16sm2058821iln.5.2021.08.12.12.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 12:50:39 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: distinguish system from runtime suspend
Date:   Thu, 12 Aug 2021 14:50:31 -0500
Message-Id: <20210812195035.2816276-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210812195035.2816276-1-elder@linaro.org>
References: <20210812195035.2816276-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new flag that is set when the hardware is suspended due to a
system suspend operation, distingishing it from runtime suspend.
Use it in the SUSPEND IPA interrupt handler to determine whether to
trigger a system resume because of the event.  Define new suspend
and resume power management callback functions to set and clear the
new flag, respectively.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 38 ++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index cdbaba6618e9e..8f25107c1f1e7 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -47,10 +47,12 @@ struct ipa_interconnect {
 /**
  * enum ipa_power_flag - IPA power flags
  * @IPA_POWER_FLAG_RESUMED:	Whether resume from suspend has been signaled
+ * @IPA_POWER_FLAG_SYSTEM:	Hardware is system (not runtime) suspended
  * @IPA_POWER_FLAG_COUNT:	Number of defined power flags
  */
 enum ipa_power_flag {
 	IPA_POWER_FLAG_RESUMED,
+	IPA_POWER_FLAG_SYSTEM,
 	IPA_POWER_FLAG_COUNT,		/* Last; not a flag */
 };
 
@@ -281,6 +283,27 @@ int ipa_clock_put(struct ipa *ipa)
 	return pm_runtime_put(&ipa->pdev->dev);
 }
 
+static int ipa_suspend(struct device *dev)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+
+	__set_bit(IPA_POWER_FLAG_SYSTEM, ipa->clock->flags);
+
+	return pm_runtime_force_suspend(dev);
+}
+
+static int ipa_resume(struct device *dev)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+	int ret;
+
+	ret = pm_runtime_force_resume(dev);
+
+	__clear_bit(IPA_POWER_FLAG_SYSTEM, ipa->clock->flags);
+
+	return ret;
+}
+
 /* Return the current IPA core clock rate */
 u32 ipa_clock_rate(struct ipa *ipa)
 {
@@ -299,12 +322,13 @@ u32 ipa_clock_rate(struct ipa *ipa)
  */
 static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 {
-	/* Just report the event, and let system resume handle the rest.
-	 * More than one endpoint could signal this; if so, ignore
-	 * all but the first.
+	/* To handle an IPA interrupt we will have resumed the hardware
+	 * just to handle the interrupt, so we're done.  If we are in a
+	 * system suspend, trigger a system resume.
 	 */
-	if (!test_and_set_bit(IPA_POWER_FLAG_RESUMED, ipa->clock->flags))
-		pm_wakeup_dev_event(&ipa->pdev->dev, 0, true);
+	if (!__test_and_set_bit(IPA_POWER_FLAG_RESUMED, ipa->clock->flags))
+		if (test_bit(IPA_POWER_FLAG_SYSTEM, ipa->clock->flags))
+			pm_wakeup_dev_event(&ipa->pdev->dev, 0, true);
 
 	/* Acknowledge/clear the suspend interrupt on all endpoints */
 	ipa_interrupt_suspend_clear_all(ipa->interrupt);
@@ -390,8 +414,8 @@ void ipa_clock_exit(struct ipa_clock *clock)
 }
 
 const struct dev_pm_ops ipa_pm_ops = {
-	.suspend		= pm_runtime_force_suspend,
-	.resume			= pm_runtime_force_resume,
+	.suspend		= ipa_suspend,
+	.resume			= ipa_resume,
 	.runtime_suspend	= ipa_runtime_suspend,
 	.runtime_resume		= ipa_runtime_resume,
 	.runtime_idle		= ipa_runtime_idle,
-- 
2.27.0

