Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D243F22EF
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbhHSWUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236175AbhHSWUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 18:20:07 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411E6C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 15:19:31 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id z2so7560331iln.0
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 15:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V++C25JgTAQBV+qvjbbsx7LF9B3PcrPKDl21IMwbBpc=;
        b=s5OT934ARZG2T706DJwUzoXYG1MuzAK8St19X9YAi8+KxO4XZcpoL+COEtj/GQs5Wb
         KyurwKfLS7m15lTEy9/Tfoqr55D6va0IN/nKjcbVAv203qb/Jj4ycBbxOlKfwxu6ShOq
         u67svKGCITaG0MaIUKIPteM5ietmI08WniGCCV9VDRkYilV+CU83bjQ9o/6Dqo1t48Kv
         V4qXN85gcOumEFvIWGPmqbq40XuWekGkTusVrcySWJ6M32/dsMHWfFn+0tWySGoM+3DY
         8jj/iXM6/K/yDmNmt3sdZ1K9e/Y22dMqNoi11ItomFl0suhJp+NEadsGO/7y2v4+FA7D
         n2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V++C25JgTAQBV+qvjbbsx7LF9B3PcrPKDl21IMwbBpc=;
        b=OCNFzRhtcN20riva78Ss3t3sbGQk93VgA7d1o7ffP98BszVpiIyQAFVN9FEyNPg71U
         V5gkuiesxTOVcrGWJJg5K4ubK/RKMTwYl7o/8J12ZsZ5+L+lsh1KLlkxRnaZxx6RC3Vy
         nPhU9fVI8AIuGLephiIGNGWEBKibQVwmqKA9JZfa7FGentI2vmzRb/X/YdLUjcBERDHD
         X9+a/UacIt9gXUXMf4SnQjIswFagC8qkpImBJMeYysZiD862VE7bAIhHqHz1FXMQZEIE
         p4pe5UUwoTmAzW/2KTw1Za7NZc8wJB0isXOI0Tw1wnDZYXGqrRZgLGCCOiRfdxiQuNvY
         NAVQ==
X-Gm-Message-State: AOAM531W4Opo3KwVX4bngxnT/Dsp67zr8NIkgx4QyldpbrzOEejS1sYA
        48qA/RFDC2dukCncG7m9b+vOow==
X-Google-Smtp-Source: ABdhPJyoBfygwH63o/Y4lTrQ8gTQ0nUkr/9iuKVAdVpmJAwAdMrGlkKIJCQHaYpTRI/f/eozX812MQ==
X-Received: by 2002:a92:cccf:: with SMTP id u15mr12046419ilq.144.1629411570672;
        Thu, 19 Aug 2021 15:19:30 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o15sm2245188ilo.73.2021.08.19.15.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 15:19:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: ipa: don't use ipa_clock_get() in "ipa_main.c"
Date:   Thu, 19 Aug 2021 17:19:23 -0500
Message-Id: <20210819221927.3286267-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210819221927.3286267-1-elder@linaro.org>
References: <20210819221927.3286267-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need the hardware to be powered starting at the config stage of
initialization when the IPA driver probes.  And we need it powered
when the driver is removed, at least until the deconfig stage has
completed.

Replace callers of ipa_clock_get() in ipa_probe() and ipa_exit(),
calling pm_runtime_get_sync() instead.  Replace the corresponding
callers of ipa_clock_put(), calling pm_runtime_put() instead.

The only error we expect when getting power would occur when the
system is suspended.  The ->probe and ->remove driver callbacks
won't be called when suspended, so issue a WARN() call if an error
is seen getting power.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 69fa4b3120fd3..3969aef6c4370 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
+#include <linux/pm_runtime.h>
 #include <linux/qcom_scm.h>
 #include <linux/soc/qcom/mdt_loader.h>
 
@@ -737,13 +738,13 @@ static int ipa_probe(struct platform_device *pdev)
 		goto err_table_exit;
 
 	/* The clock needs to be active for config and setup */
-	ret = ipa_clock_get(ipa);
+	ret = pm_runtime_get_sync(dev);
 	if (WARN_ON(ret < 0))
-		goto err_clock_put;
+		goto err_power_put;
 
 	ret = ipa_config(ipa, data);
 	if (ret)
-		goto err_clock_put;
+		goto err_power_put;
 
 	dev_info(dev, "IPA driver initialized");
 
@@ -765,14 +766,14 @@ static int ipa_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_deconfig;
 done:
-	(void)ipa_clock_put(ipa);
+	(void)pm_runtime_put(dev);
 
 	return 0;
 
 err_deconfig:
 	ipa_deconfig(ipa);
-err_clock_put:
-	(void)ipa_clock_put(ipa);
+err_power_put:
+	(void)pm_runtime_put(dev);
 	ipa_modem_exit(ipa);
 err_table_exit:
 	ipa_table_exit(ipa);
@@ -798,9 +799,9 @@ static int ipa_remove(struct platform_device *pdev)
 	struct ipa_clock *clock = ipa->clock;
 	int ret;
 
-	ret = ipa_clock_get(ipa);
+	ret = pm_runtime_get_sync(&pdev->dev);
 	if (WARN_ON(ret < 0))
-		goto out_clock_put;
+		goto out_power_put;
 
 	if (ipa->setup_complete) {
 		ret = ipa_modem_stop(ipa);
@@ -816,8 +817,8 @@ static int ipa_remove(struct platform_device *pdev)
 	}
 
 	ipa_deconfig(ipa);
-out_clock_put:
-	(void)ipa_clock_put(ipa);
+out_power_put:
+	(void)pm_runtime_put(&pdev->dev);
 
 	ipa_modem_exit(ipa);
 	ipa_table_exit(ipa);
-- 
2.27.0

