Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1ED72B5538
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730997AbgKPXiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730975AbgKPXiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:38:21 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3F7C0613D2
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:21 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id y18so9648092ilp.13
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ahB8Vs+/9GAyZh/jpoO8CVqISomCaLk8a4aDUbRn4HU=;
        b=q+cz86dxZ+NwglH37/AD1/8kW5RILaviNKefVxvQKYpOi15MNfoZSuuuCiR22nVWdH
         F/VDaE61n0f8w9WghmGAlUYSeWwwfkH0coVS4B4Q5mZMqT7uirkuzAeOs5KEgYp+4IJj
         Knc2jvuBIMo7PLNp/yX7LycS5wh1XymYfXWrPvCAMKRzvW3d8EF/lJZQhez9HaMrjHIt
         YVWKSoOGMQhdiY2qaYLFLN8mFLfz8qDMZDzehKuh4o5S/KPzurg6a3uAjnRzP4cCaXb/
         VYrj0MUUNMPsiprIOciYPpmaieeV+jJDF/HpSjtpMXB2o82lYXSzSbF1x4hBEYbKun7d
         pWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ahB8Vs+/9GAyZh/jpoO8CVqISomCaLk8a4aDUbRn4HU=;
        b=rnz6hsEWeo7hefqyZdCOKmEufzBixjShNzXzi8WGhtyYSC4XFcrlNF5Y9wrt/ZsBe2
         dxhlVOuVPaKJ/qt25ABk55l8UNC79QfFavYHGVpcI5qMAl1XfJyBF/6Bz928HUOMRyG8
         RpgdQdJA5+m9JTM+8T8ktdFH9soBByfmOM1MC/1hDH4JwGHGrohGHmjX6/XW+SpnHEMV
         eF0fvrSPuo4L0tMv+Jrc24ynz3LDlq51KarjyHu/R6/p8+Zvgy94cFlfxrOUoesHmb76
         Kr701zyEw0cw+kKWeknNLcPmRHmU75dQokpZc+4eHpDtRKTwsGWXq3bvRkvYAlGdeZou
         m/lg==
X-Gm-Message-State: AOAM5323CFBJdjn9l6yC0d48/ZAgXQrQfOFalI/8/1d2SIzrcoEFAMXx
        XB8XeAAAqzOoGwMSIIqDfCX+Iw==
X-Google-Smtp-Source: ABdhPJzxKHRc61ssbe+CW0woTKjnowJvdcw5Kv9IOWo5nULoSjcIPQghfU8/9wYEPuX5O8V6NLoJbQ==
X-Received: by 2002:a92:d0cf:: with SMTP id y15mr10719506ila.168.1605569900594;
        Mon, 16 Nov 2020 15:38:20 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm10180099ill.22.2020.11.16.15.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:38:20 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/11] net: ipa: use _FMASK consistently
Date:   Mon, 16 Nov 2020 17:37:59 -0600
Message-Id: <20201116233805.13775-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116233805.13775-1-elder@linaro.org>
References: <20201116233805.13775-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several IPA register field masks are defined without the "_FMASK"
suffix naming convention.  Rename these, so all field masks are
consistently named.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c |  6 +++---
 drivers/net/ipa/ipa_reg.h  | 24 ++++++++++++------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index a9d8597f970aa..3fb9c5d90b70e 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -325,7 +325,7 @@ static void ipa_hardware_config(struct ipa *ipa)
 
 		/* Disable PA mask to allow HOLB drop (hardware workaround) */
 		val = ioread32(ipa->reg_virt + IPA_REG_TX_CFG_OFFSET);
-		val &= ~PA_MASK_EN;
+		val &= ~PA_MASK_EN_FMASK;
 		iowrite32(val, ipa->reg_virt + IPA_REG_TX_CFG_OFFSET);
 	}
 
@@ -336,7 +336,7 @@ static void ipa_hardware_config(struct ipa *ipa)
 
 	/* Configure aggregation granularity */
 	granularity = ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY);
-	val = u32_encode_bits(granularity, AGGR_GRANULARITY);
+	val = u32_encode_bits(granularity, AGGR_GRANULARITY_FMASK);
 	iowrite32(val, ipa->reg_virt + IPA_REG_COUNTER_CFG_OFFSET);
 
 	/* IPA v4.2 does not support hashed tables, so disable them */
@@ -688,7 +688,7 @@ static void ipa_validate_build(void)
 	/* Aggregation granularity value can't be 0, and must fit */
 	BUILD_BUG_ON(!ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY));
 	BUILD_BUG_ON(ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY) >
-			field_max(AGGR_GRANULARITY));
+			field_max(AGGR_GRANULARITY_FMASK));
 #endif /* IPA_VALIDATE */
 }
 
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index e24c190665139..9e92fe022c6f9 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -203,7 +203,7 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
 #define TIMER_FREQUENCY	32000	/* 32 KHz inactivity timer clock */
 
 #define IPA_REG_COUNTER_CFG_OFFSET			0x000001f0
-#define AGGR_GRANULARITY			GENMASK(8, 4)
+#define AGGR_GRANULARITY_FMASK			GENMASK(8, 4)
 /* Compute the value to use in the AGGR_GRANULARITY field representing the
  * given number of microseconds.  The value is one less than the number of
  * timer ticks in the requested period.  Zero not a valid granularity value.
@@ -215,19 +215,19 @@ static inline u32 ipa_aggr_granularity_val(u32 usec)
 
 #define IPA_REG_TX_CFG_OFFSET				0x000001fc
 /* The first three fields are present for IPA v3.5.1 only */
-#define TX0_PREFETCH_DISABLE			GENMASK(0, 0)
-#define TX1_PREFETCH_DISABLE			GENMASK(1, 1)
-#define PREFETCH_ALMOST_EMPTY_SIZE		GENMASK(4, 2)
+#define TX0_PREFETCH_DISABLE_FMASK		GENMASK(0, 0)
+#define TX1_PREFETCH_DISABLE_FMASK		GENMASK(1, 1)
+#define PREFETCH_ALMOST_EMPTY_SIZE_FMASK	GENMASK(4, 2)
 /* The next fields are present for IPA v4.0 and above */
-#define PREFETCH_ALMOST_EMPTY_SIZE_TX0		GENMASK(5, 2)
-#define DMAW_SCND_OUTSD_PRED_THRESHOLD		GENMASK(9, 6)
-#define DMAW_SCND_OUTSD_PRED_EN			GENMASK(10, 10)
-#define DMAW_MAX_BEATS_256_DIS			GENMASK(11, 11)
-#define PA_MASK_EN				GENMASK(12, 12)
-#define PREFETCH_ALMOST_EMPTY_SIZE_TX1		GENMASK(16, 13)
+#define PREFETCH_ALMOST_EMPTY_SIZE_TX0_FMASK	GENMASK(5, 2)
+#define DMAW_SCND_OUTSD_PRED_THRESHOLD_FMASK	GENMASK(9, 6)
+#define DMAW_SCND_OUTSD_PRED_EN_FMASK		GENMASK(10, 10)
+#define DMAW_MAX_BEATS_256_DIS_FMASK		GENMASK(11, 11)
+#define PA_MASK_EN_FMASK			GENMASK(12, 12)
+#define PREFETCH_ALMOST_EMPTY_SIZE_TX1_FMASK	GENMASK(16, 13)
 /* The last two fields are present for IPA v4.2 and above */
-#define SSPND_PA_NO_START_STATE			GENMASK(18, 18)
-#define SSPND_PA_NO_BQ_STATE			GENMASK(19, 19)
+#define SSPND_PA_NO_START_STATE_FMASK		GENMASK(18, 18)
+#define SSPND_PA_NO_BQ_STATE_FMASK		GENMASK(19, 19)
 
 #define IPA_REG_FLAVOR_0_OFFSET				0x00000210
 #define BAM_MAX_PIPES_FMASK			GENMASK(4, 0)
-- 
2.20.1

