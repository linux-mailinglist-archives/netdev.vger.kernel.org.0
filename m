Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C68626E303
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgIQR4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgIQRjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:39:42 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6ADDC06121D
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:37 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x2so3142052ilm.0
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c6CNu1LYWNz4YTYxiYPRvkqPWBqpDM+ovhrPcXJRY08=;
        b=xcjO2apobyoynwr8mlo+BSGWBbL2VnaNrO/p5X+YCAfoQW0L3BTq5m4l9/P5y82U1b
         31XYlB/+9ASi1ngE2ipcUdePPYfd3yRJrFhgHXqqU1y6x4ymTawjEeEyat16xG3dy3JI
         dUQ+qPqLg/kCTQPGyc/nWbHkBo1CJFnyQzLvnIhoGjtUbjGVK3gQQL+UfJFTv1JSMMVb
         4trRT8nGQQxMY4b9jpbIHpHzq6QLy6KhCUOO066hxad3KHSQtV0btNKx2hRwsbOA/2RS
         /22uXRYgObFyCedDtzl17so7ac6enMRyDVgttaNomlW33nsHMxuUCP3B/RlQjVJJYY1t
         Z+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c6CNu1LYWNz4YTYxiYPRvkqPWBqpDM+ovhrPcXJRY08=;
        b=mgqvmMJ6bIwuUW83lPMS8Z90rZdsanQ4Zebd21TkyyX2chKXyT046dFPZBxbkF19H3
         CJ9Zoh1+TJs16qkp2RSFfZvMrpvmNNiU9i7Hpyuf6E/3qMqNwAVpQEy6hQJaAiSBR7vz
         v/QIVklaUYmy42OgBkUccrVyM8Qfpa/mhffFb4DXUgEovg5tbN7bh6rOnketlWp1r98d
         9x8ppP8O3DKO5HSCzM01zCHDqkHyyXDYrh/GNy2//vWu/HHjTc3LpS+Xg9owK7qVenE4
         xcGeZudA/+fjYbEaR4gIYKnAOb1FJffvFZOnNWLimVCIZHMTcPMBBUULIwizYzAc5mc8
         pY4g==
X-Gm-Message-State: AOAM533R0qPsHostz/fStvuO7XKcEX1bRvxYzE7GjgOD8P3PNyvFvz2y
        AJ3O6YKRjFOi+9Igt6OYq0Kygg==
X-Google-Smtp-Source: ABdhPJwaFsCSU3TPi/ucp9NUFbo+IVA1+K0seDDcl5QN5d1HKoNl+4jATzsWhbdJY0CYLF0bWqLxcw==
X-Received: by 2002:a92:8b0e:: with SMTP id i14mr485068ild.28.1600364376991;
        Thu, 17 Sep 2020 10:39:36 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l6sm192725ilt.34.2020.09.17.10.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 10:39:35 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 5/7] net: ipa: repurpose CLOCK_HELD flag
Date:   Thu, 17 Sep 2020 12:39:24 -0500
Message-Id: <20200917173926.24266-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200917173926.24266-1-elder@linaro.org>
References: <20200917173926.24266-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch causes a system resume to be triggered when a
packet is available for receipt on a suspended RX endpoint.

The CLOCK_HELD flag was previously used to indicate that an extra
clock reference was held, preventing suspend.  But we no longer need
such a flag:
  - We take an initial reference in ipa_config().
  - That reference is held until ipa_suspend() releases it.
  - A subsequent system resume leads to a reference getting
    re-acquired in ipa_resume().
  - This can repeat until ultimately the module is removed, where
    ipa_remove() releases the reference.
We no longer need a special flag to determine whether this extra
reference is held--it is, provided probe has completed successfully
and the driver is not suspended (or removed).

On the other hand, once suspended, it's possible for more than one
endpoint to trip the IPA SUSPEND interrupt, and we only want to
trigger the system resume once.  So repurpose the Boolean CLOCK_HELD
flag to record whether the IPA SUSPEND handler should initiate a
system resume.

The flag will be be cleared each time ipa_suspend() is called,
*before* any endpoints are suspended.  And it will be set inside the
IPA SUSPEND interrupt handler exactly once per suspend.

Rename the flag IPA_FLAG_RESUMED to reflect its new purpose.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v3: New; eliminated need for "clock held" flag, as Bjorn suggested.

 drivers/net/ipa/ipa.h      |  6 +++---
 drivers/net/ipa/ipa_main.c | 14 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index c688155ccf375..6c2371084c55a 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -29,11 +29,11 @@ struct ipa_interrupt;
 
 /**
  * enum ipa_flag - IPA state flags
- * @IPA_FLAG_CLOCK_HELD:	Whether IPA clock is held to prevent suspend
- * @IPA_FLAG_COUNT:		Number of defined IPA flags
+ * @IPA_FLAG_RESUMED:	Whether resume from suspend has been signaled
+ * @IPA_FLAG_COUNT:	Number of defined IPA flags
  */
 enum ipa_flag {
-	IPA_FLAG_CLOCK_HELD,
+	IPA_FLAG_RESUMED,
 	IPA_FLAG_COUNT,		/* Last; not a flag */
 };
 
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 4e2508bb1bf80..1044758b501d2 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -86,7 +86,7 @@ static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 	 * More than one endpoint could signal this; if so, ignore
 	 * all but the first.
 	 */
-	if (!test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
+	if (!test_and_set_bit(IPA_FLAG_RESUMED, ipa->flags))
 		pm_wakeup_dev_event(&ipa->pdev->dev, 0, true);
 
 	/* Acknowledge/clear the suspend interrupt on all endpoints */
@@ -518,7 +518,6 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 	 * is held after initialization completes, and won't get dropped
 	 * unless/until a system suspend request arrives.
 	 */
-	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 	ipa_clock_get(ipa);
 
 	ipa_hardware_config(ipa);
@@ -554,7 +553,6 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 err_hardware_deconfig:
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
-	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 
 	return ret;
 }
@@ -572,7 +570,6 @@ static void ipa_deconfig(struct ipa *ipa)
 	ipa_endpoint_deconfig(ipa);
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
-	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 }
 
 static int ipa_firmware_load(struct device *dev)
@@ -778,7 +775,6 @@ static int ipa_probe(struct platform_device *pdev)
 	dev_set_drvdata(dev, ipa);
 	ipa->modem_rproc = rproc;
 	ipa->clock = clock;
-	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 	ipa->version = data->version;
 
 	ret = ipa_reg_init(ipa);
@@ -908,10 +904,15 @@ static int ipa_suspend(struct device *dev)
 {
 	struct ipa *ipa = dev_get_drvdata(dev);
 
+	/* When a suspended RX endpoint has a packet ready to receive, we
+	 * get an IPA SUSPEND interrupt.  We trigger a system resume in
+	 * that case, but only on the first such interrupt since suspend.
+	 */
+	__clear_bit(IPA_FLAG_RESUMED, ipa->flags);
+
 	ipa_endpoint_suspend(ipa);
 
 	ipa_clock_put(ipa);
-	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 
 	return 0;
 }
@@ -933,7 +934,6 @@ static int ipa_resume(struct device *dev)
 	/* This clock reference will keep the IPA out of suspend
 	 * until we get a power management suspend request.
 	 */
-	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 	ipa_clock_get(ipa);
 
 	ipa_endpoint_resume(ipa);
-- 
2.20.1

