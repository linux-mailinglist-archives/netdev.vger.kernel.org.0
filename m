Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981D12B5533
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgKPXiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730834AbgKPXiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:38:18 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F675C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:18 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id l12so16936575ilo.1
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R/KH1Zx6pvvwlPcex+1v/rVIsHRzuMbIHzVWH/5s1mU=;
        b=KwtbHymUWZJcv5S8ebV7GWJ7G+cmnf42lsHn05KJt94fUMwFY8pCs+gtLPwiF9NDhc
         oe2HZKo/Q55q8QTdehuuL2fPhfPaus6kcYJtwj26rdBq/8Ic9IjAWmhJAuhhZ2K8KBxy
         j81EZgxYGxIEnfVnSlfvqQEHwhTVVxR5KmASeIqJXJG7S4nSb4Dz0w83fmRJG+M9o6H0
         xEHEsWQG3JoEFjwmJnFZeJbB8nktaWeSZ5hEm6n62bDuhD0yVS21/Vgi2GXsbPwu+5CC
         QpANg6iyl3ox2X4PrynKq1wTMIxRUQ2P7dWx4eDM1NcNGfmWHaWu1PhvVwYvFFGm5hT9
         phJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R/KH1Zx6pvvwlPcex+1v/rVIsHRzuMbIHzVWH/5s1mU=;
        b=AcsEVdNm1qvP4dRtiSXeK43nuclyawuJakrJMJNdVZtBJrU0evW3d3waAeueloYE/E
         my5thKpiT4/EwhBUW8wp4zWBnWjCEmHPCZAY+8pxYt30uWlmgmW53qmsFLk49/RaF/yT
         DiFG9WnUKHaK7hkJSqCp1E/WxBSv1Zw7rLsZ2ECTV89Bepkf2nHlNgy+XtBgLhPW8+3w
         1OMa3hSGp6JeEXmEroBIZ4c+6UmBVDxTWQ/u6WmlBqcZ8wHzNGbEDenqd6eaLgX/hKnV
         /ypecgcQ4BAiGulG9x42scodW/TL7zPXmCw8rdzg9PgH3rtIPOOdTiqF7lwJS67ZVwmV
         eBKg==
X-Gm-Message-State: AOAM532uCckggZzCZ4cFRFp0oHZUT00nbbbi5xSrC+3b+spZK1uDNxLP
        ijPjjnrV2dlPmGcQ2HnlpXd8gA==
X-Google-Smtp-Source: ABdhPJzxIzMLlq5lYKSLoyX7o92cUlEvouY4ZKyUiVD/sh9NWgS0r6PHOxsKxbR28reCrIsgbpWyLg==
X-Received: by 2002:a05:6e02:eaa:: with SMTP id u10mr9218286ilj.96.1605569897401;
        Mon, 16 Nov 2020 15:38:17 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm10180099ill.22.2020.11.16.15.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:38:16 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/11] net: ipa: make filter/routing hash enable register variable
Date:   Mon, 16 Nov 2020 17:37:56 -0600
Message-Id: <20201116233805.13775-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116233805.13775-1-elder@linaro.org>
References: <20201116233805.13775-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For IPA v3.5.1, the IPA filter/routing hash enable register actually
does exist, but it is at offset 0x8c into the IPA register space.
For newer versions of IPA it is at offset 0x148.

Define a new inline function ipa_reg_filt_rout_hash_en_offset() to
return the appropriate value for a given version of IPA hardware.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 9 ++++++---
 drivers/net/ipa/ipa_reg.h  | 9 +++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index bfe95a46acaf1..a9d8597f970aa 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -339,9 +339,12 @@ static void ipa_hardware_config(struct ipa *ipa)
 	val = u32_encode_bits(granularity, AGGR_GRANULARITY);
 	iowrite32(val, ipa->reg_virt + IPA_REG_COUNTER_CFG_OFFSET);
 
-	/* Disable hashed IPv4 and IPv6 routing and filtering for IPA v4.2 */
-	if (ipa->version == IPA_VERSION_4_2)
-		iowrite32(0, ipa->reg_virt + IPA_REG_FILT_ROUT_HASH_EN_OFFSET);
+	/* IPA v4.2 does not support hashed tables, so disable them */
+	if (ipa->version == IPA_VERSION_4_2) {
+		u32 offset = ipa_reg_filt_rout_hash_en_offset(ipa->version);
+
+		iowrite32(0, ipa->reg_virt + offset);
+	}
 
 	/* Enable dynamic clock division */
 	ipa_hardware_dcd_config(ipa);
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 001961cd526bc..b46e60744f57f 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -151,8 +151,13 @@ static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
 }
 /* ipa->available defines the valid bits in the STATE_AGGR_ACTIVE register */
 
-/* The next register is present for IPA v4.2 and above */
-#define IPA_REG_FILT_ROUT_HASH_EN_OFFSET		0x00000148
+static inline u32 ipa_reg_filt_rout_hash_en_offset(enum ipa_version version)
+{
+	if (version == IPA_VERSION_3_5_1)
+		return 0x000008c;
+
+	return 0x0000148;
+}
 
 static inline u32 ipa_reg_filt_rout_hash_flush_offset(enum ipa_version version)
 {
-- 
2.20.1

