Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC673F22F4
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbhHSWUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236732AbhHSWUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 18:20:10 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0739C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 15:19:33 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id j18so9661026ioj.8
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 15:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bnBaACXlOYhgGho8VFfK4AyQp6ASY7kxEYVRMApr6Zk=;
        b=xOhBKq3uSJcSZsnys7NGlYXqOHoFDCFIStrVP/IqwhQ9jglVkwgpJkjqGbRmw/f+2O
         F1GS4WK3MNX4rL/l0uC+4TuErZvxX1/0EuMSZ23d8NBCbAPssVDcxTmHpHu7lEHLTnCQ
         7sBWH5EMsTeKcx5YntxoEYWsxH3GpWDUJ7dsZZAkpCKYCLgl3ic2rUKDJNib70EnUFBi
         uFOb8ynOHM+QBuP3W4JHvnpvKzQRpdW1w+fIG0aPcHXcEvF04S/Wk3mrMDZZ3AFFzXJA
         B2fYWejBSAb9chxTxJAcasjim75llVDIKK5JV3iiM9NW+BCFOEjSCqlg73YRrfZbuI8U
         zseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bnBaACXlOYhgGho8VFfK4AyQp6ASY7kxEYVRMApr6Zk=;
        b=o7g9czuxBPga08nQdOsa6ot6DyevasL7V7nyaDxCbmwvjqWYbUnZx7NzC3z+vI4+oI
         gLq/9FzqtfBwl05XVsaTonEGbcUUQQzIZiYitV/OnhVBe3iikCCXbsMToJnXaThcgCFE
         OrPPsYqxeOfcWhSdn8zWKsOmVJPmf68XNUYoWREQzAMXpqFkjMr+/4guQheavhV5q9hp
         isAIRdvKWkSBW7Ja5mo7NiMgwA/yFMl53lIv8gFLgti9Dye3Oy7Q/qqaHsiCBotQR+ep
         rPUznxo6QggFflWa4WO3vG67IE9he9amqf5PozkVNYmkaOZTV5L/DAUm/5iYVGFb1mwM
         ZWtA==
X-Gm-Message-State: AOAM5305y/3YSgcf9AqYsDFuUBwee6SaEb3MDGwHny6TETUyzONoPWvV
        AESmVhsX97/L/L9NtTf++lzUqQpIoTU4TLCq
X-Google-Smtp-Source: ABdhPJyY9OcTcosA8P39ECBpKfk7anRKwMO/WZLb/5bX37T3mEfzzoPkI/RF6o/n9h34W9nK65zsTA==
X-Received: by 2002:a02:c507:: with SMTP id s7mr14887069jam.36.1629411573208;
        Thu, 19 Aug 2021 15:19:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o15sm2245188ilo.73.2021.08.19.15.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 15:19:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: ipa: don't use ipa_clock_get() in "ipa_modem.c"
Date:   Thu, 19 Aug 2021 17:19:26 -0500
Message-Id: <20210819221927.3286267-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210819221927.3286267-1-elder@linaro.org>
References: <20210819221927.3286267-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we open or close the modem network device we need to ensure the
hardware is powered.  Replace the callers of ipa_clock_get() found
in ipa_open() and ipa_stop() with calls to pm_runtime_get_sync().
If an error is returned, simply return that error to the caller
(without any error or warning message).  This could conceivably
occur if the function was called while the system was suspended,
but that really shouldn't happen.  Replace corresponding calls to
ipa_clock_put() with pm_runtime_put() also.

If the modem crashes we also need to ensure the hardware is powered
to recover.  If getting power returns an error there's not much we
can do, but at least report the error.  (Ideally the remoteproc SSR
code would ensure the AP was not suspended when it sends the
notification, but that is not (yet) the case.)

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_modem.c | 40 +++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index c8724af935b85..7e05b22d6e18b 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -49,15 +49,17 @@ static int ipa_open(struct net_device *netdev)
 {
 	struct ipa_priv *priv = netdev_priv(netdev);
 	struct ipa *ipa = priv->ipa;
+	struct device *dev;
 	int ret;
 
-	ret = ipa_clock_get(ipa);
-	if (WARN_ON(ret < 0))
-		goto err_clock_put;
+	dev = &ipa->pdev->dev;
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0)
+		goto err_power_put;
 
 	ret = ipa_endpoint_enable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
 	if (ret)
-		goto err_clock_put;
+		goto err_power_put;
 
 	ret = ipa_endpoint_enable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
 	if (ret)
@@ -65,14 +67,14 @@ static int ipa_open(struct net_device *netdev)
 
 	netif_start_queue(netdev);
 
-	(void)ipa_clock_put(ipa);
+	(void)pm_runtime_put(dev);
 
 	return 0;
 
 err_disable_tx:
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
-err_clock_put:
-	(void)ipa_clock_put(ipa);
+err_power_put:
+	(void)pm_runtime_put(dev);
 
 	return ret;
 }
@@ -82,18 +84,20 @@ static int ipa_stop(struct net_device *netdev)
 {
 	struct ipa_priv *priv = netdev_priv(netdev);
 	struct ipa *ipa = priv->ipa;
+	struct device *dev;
 	int ret;
 
-	ret = ipa_clock_get(ipa);
-	if (WARN_ON(ret < 0))
-		goto out_clock_put;
+	dev = &ipa->pdev->dev;
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0)
+		goto out_power_put;
 
 	netif_stop_queue(netdev);
 
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
-out_clock_put:
-	(void)ipa_clock_put(ipa);
+out_power_put:
+	(void)pm_runtime_put(dev);
 
 	return 0;
 }
@@ -359,9 +363,11 @@ static void ipa_modem_crashed(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	int ret;
 
-	ret = ipa_clock_get(ipa);
-	if (WARN_ON(ret < 0))
-		goto out_clock_put;
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "error %d getting power to handle crash\n", ret);
+		goto out_power_put;
+	}
 
 	ipa_endpoint_modem_pause_all(ipa, true);
 
@@ -388,8 +394,8 @@ static void ipa_modem_crashed(struct ipa *ipa)
 	if (ret)
 		dev_err(dev, "error %d zeroing modem memory regions\n", ret);
 
-out_clock_put:
-	(void)ipa_clock_put(ipa);
+out_power_put:
+	(void)pm_runtime_put(dev);
 }
 
 static int ipa_modem_notify(struct notifier_block *nb, unsigned long action,
-- 
2.27.0

