Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3872B9DBB
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgKSWkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgKSWkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:40:51 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB6DC0617A7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:40:50 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id y9so6896215ilb.0
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OOSsF7KnxFiHnRY0GY2iUK6XWu8gB3i6mV+T4+SlcUs=;
        b=R95lTJA4IP1J1OO+QCE2nzBGjLaWqo+e9QFoqUa3A7O7xI3pKQ4r0uG4HT4Jz67IUm
         whiNfCSA+tDFO3KaafhnjbDo2y6/qPsh7rhnFGHRTv8Lq8dQ8VuTLi7ld4o0kc/6gFql
         cxzbEoCamnJ6ymEaOUox37s6nEcaowVc5XJmlmbXm/Xjv5MDpLy5q/NRoxRP1M8cEOFg
         ORv161ukmdMhWu8OMMAgnUp799EYwsrg4rCWaMZzTtgt3ZrhKLurZg5TEtdOftIrAlGi
         XOv1qy/ClMZXVjO2fdH7ywR3Umxx3n+JILYv4Gx0wmjFBQm0NjloTdfFRLmkDcDP4pWV
         +oBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OOSsF7KnxFiHnRY0GY2iUK6XWu8gB3i6mV+T4+SlcUs=;
        b=lBH7orBWwjvGV/YjlowydYgHuc/Sl1MvVMogYvjp1EaOcdBvXPfDaORoHI8vuLe4fB
         RQv+ou/CISRDn+agkGHwrM2dP/o9QcT8E4nAZlSZtpzdiCxMAsiJjaCmihGZ7dCGm2lQ
         dfgK0+ALipvbYo4shLsyKTbHqSG4fMnW66NEn95mnjswsGAvl4AzEdEXPZLXwPNWB8hS
         3QUJjHlKRvdl+r2Tea0Ps2O0iCTMT+c3Y+/U94uk4U2GJo7S1y99MsDlcJYfk6PIYWfA
         A/qDfs0tJqJgmBSc/QxUVFidD9jcD3Y5M3SBOkF8bzX1+bBeBXP1cgpCiUrnVdSt9Wiv
         dE+A==
X-Gm-Message-State: AOAM533v1ilFHAJmL5yOjqPo9dFnlr+JqSX/HTxlik5iKDTcTmEGTO6o
        XAFNLEwFx1vgbfN6QuiEr27oLA==
X-Google-Smtp-Source: ABdhPJza97JlcTNihMoQGiobgh1N6Iww+mRwBtUxxzJD3ZmxFQlJhkmVeLvYXNTgwB3M+a/Cm8ma2A==
X-Received: by 2002:a05:6e02:92f:: with SMTP id o15mr23878207ilt.169.1605825649701;
        Thu, 19 Nov 2020 14:40:49 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b4sm587797ile.13.2020.11.19.14.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 14:40:49 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net: ipa: use config data for clocking
Date:   Thu, 19 Nov 2020 16:40:41 -0600
Message-Id: <20201119224041.16066-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201119224041.16066-1-elder@linaro.org>
References: <20201119224041.16066-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop assuming a fixed IPA core clock rate and interconnect
bandwidths.  Use the configuration data defined for these
things instead.  Get rid of the previously-used constants.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 40 ++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index ef343669280ef..9dcf16f399b7a 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -30,18 +30,6 @@
  * An IPA clock reference must be held for any access to IPA hardware.
  */
 
-#define	IPA_CORE_CLOCK_RATE		(75UL * 1000 * 1000)	/* Hz */
-
-/* Interconnect path bandwidths (each times 1000 bytes per second) */
-#define IPA_MEMORY_AVG			(80 * 1000)	/* 80 MBps */
-#define IPA_MEMORY_PEAK			(600 * 1000)
-
-#define IPA_IMEM_AVG			(80 * 1000)
-#define IPA_IMEM_PEAK			(350 * 1000)
-
-#define IPA_CONFIG_AVG			(40 * 1000)
-#define IPA_CONFIG_PEAK			(40 * 1000)
-
 /**
  * struct ipa_clock - IPA clocking information
  * @count:		Clocking reference count
@@ -116,18 +104,25 @@ static void ipa_interconnect_exit(struct ipa_clock *clock)
 /* Currently we only use one bandwidth level, so just "enable" interconnects */
 static int ipa_interconnect_enable(struct ipa *ipa)
 {
+	const struct ipa_interconnect_data *data;
 	struct ipa_clock *clock = ipa->clock;
 	int ret;
 
-	ret = icc_set_bw(clock->memory_path, IPA_MEMORY_AVG, IPA_MEMORY_PEAK);
+	data = &clock->interconnect_data[IPA_INTERCONNECT_MEMORY];
+	ret = icc_set_bw(clock->memory_path, data->average_rate,
+			 data->peak_rate);
 	if (ret)
 		return ret;
 
-	ret = icc_set_bw(clock->imem_path, IPA_IMEM_AVG, IPA_IMEM_PEAK);
+	data = &clock->interconnect_data[IPA_INTERCONNECT_IMEM];
+	ret = icc_set_bw(clock->memory_path, data->average_rate,
+			 data->peak_rate);
 	if (ret)
 		goto err_memory_path_disable;
 
-	ret = icc_set_bw(clock->config_path, IPA_CONFIG_AVG, IPA_CONFIG_PEAK);
+	data = &clock->interconnect_data[IPA_INTERCONNECT_CONFIG];
+	ret = icc_set_bw(clock->memory_path, data->average_rate,
+			 data->peak_rate);
 	if (ret)
 		goto err_imem_path_disable;
 
@@ -144,6 +139,7 @@ static int ipa_interconnect_enable(struct ipa *ipa)
 /* To disable an interconnect, we just its bandwidth to 0 */
 static int ipa_interconnect_disable(struct ipa *ipa)
 {
+	const struct ipa_interconnect_data *data;
 	struct ipa_clock *clock = ipa->clock;
 	int ret;
 
@@ -162,9 +158,13 @@ static int ipa_interconnect_disable(struct ipa *ipa)
 	return 0;
 
 err_imem_path_reenable:
-	(void)icc_set_bw(clock->imem_path, IPA_IMEM_AVG, IPA_IMEM_PEAK);
+	data = &clock->interconnect_data[IPA_INTERCONNECT_IMEM];
+	(void)icc_set_bw(clock->imem_path, data->average_rate,
+			 data->peak_rate);
 err_memory_path_reenable:
-	(void)icc_set_bw(clock->memory_path, IPA_MEMORY_AVG, IPA_MEMORY_PEAK);
+	data = &clock->interconnect_data[IPA_INTERCONNECT_MEMORY];
+	(void)icc_set_bw(clock->memory_path, data->average_rate,
+			 data->peak_rate);
 
 	return ret;
 }
@@ -273,10 +273,10 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 		return ERR_CAST(clk);
 	}
 
-	ret = clk_set_rate(clk, IPA_CORE_CLOCK_RATE);
+	ret = clk_set_rate(clk, data->core_clock_rate);
 	if (ret) {
-		dev_err(dev, "error %d setting core clock rate to %lu\n",
-			ret, IPA_CORE_CLOCK_RATE);
+		dev_err(dev, "error %d setting core clock rate to %u\n",
+			ret, data->core_clock_rate);
 		goto err_clk_put;
 	}
 
-- 
2.20.1

