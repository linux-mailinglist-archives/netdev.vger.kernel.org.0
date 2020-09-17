Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236FF26E329
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgIQSBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgIQRjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:39:39 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4559C061352
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:33 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u6so3118238iow.9
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6NeP1uYfvZjGbv5rdqBsPlN4zX/YVHDBY5G7Hrtv3Dw=;
        b=ijnENzeeMfTLahfsLi5q0tEX3kQ7Lap1kUdtclu/SG+CxdoqD+j3runx39IWzp95tc
         eJYGKaDCQHWvzVi6MPZzje1uigbERnhu+W+Mr87RxUP5q3nDZ2JLBVcdT/D1J+3wAnRd
         DJQIoszoyycEjxstpylzxmvaHnAda147k7uKVYgxcWdB7HbVF5H+HJ/8zvTaatQknCJI
         peN3MR6Z/OGm76MA2UD80lOQ7IHypIvRK0xR/LuTv6C8AzwFHH4T7j35rwyETnfh0SbS
         JYtn17tL1pfl8i7xvPRiJ9EivLKBah9d2BY6X0zG+vKoMe6iVoELaD6lSqkE91SbodSm
         dnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6NeP1uYfvZjGbv5rdqBsPlN4zX/YVHDBY5G7Hrtv3Dw=;
        b=MufeRrp0gRiam6iaX3aPMpYqC6yOaO8e0HGG9gX/oKOl3U2zN3GAkb+JnNxbUM7tfu
         mWLqOdY1zvkJLHhaxicTgyxsxomnL9jVUKkk9gHLJwB/1FA1ajg1AykTv+AZ/PdH0T5O
         U0nKfK7J+O7Ry8GjBQt1QKHmXapRqcND2oSuHYrGceBUWJtlFifIsI7HMVuOylnkzc80
         PNO4doGPIudETkRXPcwCtDOu4Xa/tUgmvWTE3M2eXx09zbBgNbzzBTYSry0yN2TeVqQI
         /UG+SWFj15k+yWym6HPoDLhsOcnI9rSdlesXSzu1yN11TsUUIcJwS8mppmbwD+OnkJfZ
         x0Ig==
X-Gm-Message-State: AOAM531btx7zoGgtvoYWdNc3Kt30qM/OZmyNby1HYM1JeYIICGNKg9gz
        fXDC3wS0xkG9eg3kFhVXshvRVw==
X-Google-Smtp-Source: ABdhPJwQvO5YWHl+O2xM5gmzF2vWl8o1dgXrc3XsDy+LaNNXY+rSQuA42VVwui9q86GrU/TRYBkNlA==
X-Received: by 2002:a5e:9911:: with SMTP id t17mr24297534ioj.58.1600364373031;
        Thu, 17 Sep 2020 10:39:33 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l6sm192725ilt.34.2020.09.17.10.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 10:39:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 2/7] net: ipa: replace ipa->suspend_ref with a flag bit
Date:   Thu, 17 Sep 2020 12:39:21 -0500
Message-Id: <20200917173926.24266-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200917173926.24266-1-elder@linaro.org>
References: <20200917173926.24266-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We take a clock reference in ipa_config() in order to prevent the
the IPA clock from being shutdown until a power management suspend
request arrives.  An atomic field in the IPA structure records
whether that extra reference had been taken.

Rather than using an atomic to represent a Boolean value, define
a new flags bitmap, and define a "clock held" flag to represent
whether the extra clock reference has been taken.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: New patch to use a bitmap bit rather than an atomic_t.
v3: No change since v2.

 drivers/net/ipa/ipa.h      | 14 ++++++++++++--
 drivers/net/ipa/ipa_main.c | 14 +++++++-------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 407fee841a9a8..e02fe979b645b 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -27,15 +27,25 @@ struct ipa_clock;
 struct ipa_smp2p;
 struct ipa_interrupt;
 
+/**
+ * enum ipa_flag - IPA state flags
+ * @IPA_FLAG_CLOCK_HELD:	Whether IPA clock is held to prevent suspend
+ * @IPA_FLAG_COUNT:		Number of defined IPA flags
+ */
+enum ipa_flag {
+	IPA_FLAG_CLOCK_HELD,
+	IPA_FLAG_COUNT,		/* Last; not a flag */
+};
+
 /**
  * struct ipa - IPA information
  * @gsi:		Embedded GSI structure
+ * @flags:		Boolean state flags
  * @version:		IPA hardware version
  * @pdev:		Platform device
  * @modem_rproc:	Remoteproc handle for modem subsystem
  * @smp2p:		SMP2P information
  * @clock:		IPA clocking information
- * @suspend_ref:	Whether clock reference preventing suspend taken
  * @table_addr:		DMA address of filter/route table content
  * @table_virt:		Virtual address of filter/route table content
  * @interrupt:		IPA Interrupt information
@@ -70,6 +80,7 @@ struct ipa_interrupt;
  */
 struct ipa {
 	struct gsi gsi;
+	DECLARE_BITMAP(flags, IPA_FLAG_COUNT);
 	enum ipa_version version;
 	struct platform_device *pdev;
 	struct rproc *modem_rproc;
@@ -77,7 +88,6 @@ struct ipa {
 	void *notifier;
 	struct ipa_smp2p *smp2p;
 	struct ipa_clock *clock;
-	atomic_t suspend_ref;
 
 	dma_addr_t table_addr;
 	__le64 *table_virt;
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 1fdfec41e4421..409375b96eb8f 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -84,7 +84,7 @@ static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 	 * endpoints will be resumed as a result.  This reference will
 	 * be dropped when we get a power management suspend request.
 	 */
-	if (!atomic_xchg(&ipa->suspend_ref, 1))
+	if (!test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
 		ipa_clock_get(ipa);
 
 	/* Acknowledge/clear the suspend interrupt on all endpoints */
@@ -508,7 +508,7 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 	 * is held after initialization completes, and won't get dropped
 	 * unless/until a system suspend request arrives.
 	 */
-	atomic_set(&ipa->suspend_ref, 1);
+	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 	ipa_clock_get(ipa);
 
 	ipa_hardware_config(ipa);
@@ -544,7 +544,7 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 err_hardware_deconfig:
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
-	atomic_set(&ipa->suspend_ref, 0);
+	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 
 	return ret;
 }
@@ -562,7 +562,7 @@ static void ipa_deconfig(struct ipa *ipa)
 	ipa_endpoint_deconfig(ipa);
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
-	atomic_set(&ipa->suspend_ref, 0);
+	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 }
 
 static int ipa_firmware_load(struct device *dev)
@@ -777,7 +777,7 @@ static int ipa_probe(struct platform_device *pdev)
 	dev_set_drvdata(dev, ipa);
 	ipa->modem_rproc = rproc;
 	ipa->clock = clock;
-	atomic_set(&ipa->suspend_ref, 0);
+	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 	ipa->wakeup_source = wakeup_source;
 	ipa->version = data->version;
 
@@ -913,7 +913,7 @@ static int ipa_suspend(struct device *dev)
 	struct ipa *ipa = dev_get_drvdata(dev);
 
 	ipa_clock_put(ipa);
-	atomic_set(&ipa->suspend_ref, 0);
+	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 
 	return 0;
 }
@@ -933,7 +933,7 @@ static int ipa_resume(struct device *dev)
 	/* This clock reference will keep the IPA out of suspend
 	 * until we get a power management suspend request.
 	 */
-	atomic_set(&ipa->suspend_ref, 1);
+	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 	ipa_clock_get(ipa);
 
 	return 0;
-- 
2.20.1

