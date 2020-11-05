Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46EE2A85E3
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732165AbgKESPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732023AbgKESOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:25 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D717C0613D2
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:14:25 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id x20so2203962ilj.8
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2PJWUoHpmESWXqIfBKXGznd5UIamnc/hAIa/GVw/pCg=;
        b=kSovUEpZr0YIvAaJt83aabflm8Zz2k83YaUFMfdccbrscT0Zzvm4fw+wKKTAkpV3XB
         /AggGLN0Wn3Phyg76T1KD+lCAWFMGWPIc0onj7rbIYWC4zO0bl+cERawbY8fV0IbpnMf
         d09qVmWqejEIG3743ZI6jfbBlV7+pg6g/us3t1ohEtdTFwTvYwnkimuSosYFyACZTOPo
         U5llt41Kz8oP8ChFc6S92q3Jhqtn7R86/kzJgDC6Pr6sXl/yFWKSnc4nfTuXbcWcqKRU
         JqfKegLs83qYODfNfOyFpJ+HUTm3i+mxSh4iCBEE1vZZ2WJa1KWZvAl4iI283ghOSIS8
         3L6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2PJWUoHpmESWXqIfBKXGznd5UIamnc/hAIa/GVw/pCg=;
        b=ssziV+gDAg08m9dNBLZBb+JYTlshncO9D5H+d+/SyA/c6ueOy4no8G2gmQcNE5emC+
         /UFXDn1LAbNFewFYQz1WsRKeTDUgwa4879M3ljc7xcq11jxOEB30KMXU8+72u8P6coCM
         HT8AGi59mKI0Pm08Y/pVF5Bf6LD4O9iC6VK3TgWSXHl6Nm/Ep29ZqVV0lDiz+UrJ17mt
         f8PvX+B5cQDijEUJ2j+pseu/1pOBDtLvWZNLhSEwGdsIrvGRrxpxmhssrLlPLsKMS9nU
         XafFN1R5CuDftwae9dknIJEMaWQhGbh4JljjoalxO67oKUzu6JTVMeMKmGKsNFWLLt+V
         FPng==
X-Gm-Message-State: AOAM5334uxNusTz5D5VgJBVqzw0XMroVxaGIYWL5Xjbd9I1EABQZPawV
        Qg+Y8ckIYntfEqDyUc05l0Lrkw==
X-Google-Smtp-Source: ABdhPJx3ziihbxZAHeK78BLiBC1ORAyA2ul59VxjefvU4gNjbhihnqTrBXvdkiVCkSY5EwBwiyUVAg==
X-Received: by 2002:a92:dc0f:: with SMTP id t15mr2818571iln.1.1604600064656;
        Thu, 05 Nov 2020 10:14:24 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o19sm1554136ilt.24.2020.11.05.10.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:14:24 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/13] net: ipa: only enable generic command completion IRQ when needed
Date:   Thu,  5 Nov 2020 12:14:03 -0600
Message-Id: <20201105181407.8006-10-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201105181407.8006-1-elder@linaro.org>
References: <20201105181407.8006-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The completion of a generic EE GSI command is signaled by a global
interrupt of type GP_INT1.  The only other used type for a global
interrupt is a hardware error report.

First, disallow all global interrupt types in gsi_irq_setup().  We
want to know about hardware errors, so re-enable the interrupt type
in gsi_irq_enable(), to allow hardware errors to be reported.
Disable that interrupt type again in gsi_irq_disable().

We only issue generic EE commands one at a time, and there's no
reason to keep the completion interrupt enabled when no generic
EE command is pending.  We furthermore have no need to enable the
GP_INT2 or GP_INT3 interrupt types (which aren't used).

The change in gsi_irq_enable() makes GSI_CNTXT_GLOB_IRQ_ALL unused,
so get rid of it.  Have gsi_generic_command() enable the GP_INT1
interrupt type (in addition to the ERROR_INT type) only while a
generic command is pending.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 35 +++++++++++++++++++++++++++--------
 drivers/net/ipa/gsi_reg.h |  1 -
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 2c01a04e07b70..4ab1d89f642ea 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -257,6 +257,7 @@ static void gsi_irq_setup(struct gsi *gsi)
 
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
+	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 }
 
 /* Turn off all GSI interrupts when we're all done */
@@ -289,14 +290,16 @@ static void gsi_irq_enable(struct gsi *gsi)
 {
 	u32 val;
 
+	/* Global interrupts include hardware error reports.  Enable
+	 * that so we can at least report the error should it occur.
+	 */
+	iowrite32(ERROR_INT_FMASK, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+	gsi->type_enabled_bitmap |= BIT(GSI_GLOB_EE);
+
 	/* Each IEOB interrupt is enabled (later) as needed by channels */
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 	gsi->type_enabled_bitmap |= BIT(GSI_IEOB);
 
-	val = GSI_CNTXT_GLOB_IRQ_ALL;
-	iowrite32(val, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
-	gsi->type_enabled_bitmap |= BIT(GSI_GLOB_EE);
-
 	/* We don't use inter-EE channel or event interrupts */
 
 	/* Never enable GSI_BREAK_POINT */
@@ -315,8 +318,8 @@ static void gsi_irq_disable(struct gsi *gsi)
 	gsi_irq_type_update(gsi);
 
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
-	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
+	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 }
 
 /* Return the virtual address associated with a ring index */
@@ -1101,8 +1104,8 @@ static void gsi_isr_glob_err(struct gsi *gsi)
 	iowrite32(~0, gsi->virt + GSI_ERROR_LOG_CLR_OFFSET);
 
 	ee = u32_get_bits(val, ERR_EE_FMASK);
-	which = u32_get_bits(val, ERR_VIRT_IDX_FMASK);
 	type = u32_get_bits(val, ERR_TYPE_FMASK);
+	which = u32_get_bits(val, ERR_VIRT_IDX_FMASK);
 	code = u32_get_bits(val, ERR_CODE_FMASK);
 
 	if (type == GSI_ERR_TYPE_CHAN)
@@ -1606,8 +1609,19 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 			       enum gsi_generic_cmd_opcode opcode)
 {
 	struct completion *completion = &gsi->completion;
+	bool success;
 	u32 val;
 
+	/* The error global interrupt type is always enabled (until we
+	 * teardown), so we won't change that.  A generic EE command
+	 * completes with a GSI global interrupt of type GP_INT1.  We
+	 * only perform one generic command at a time (to allocate or
+	 * halt a modem channel) and only from this function.  So we
+	 * enable the GP_INT1 IRQ type here while we're expecting it.
+	 */
+	val = ERROR_INT_FMASK | GP_INT1_FMASK;
+	iowrite32(val, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+
 	/* First zero the result code field */
 	val = ioread32(gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
 	val &= ~GENERIC_EE_RESULT_FMASK;
@@ -1618,8 +1632,13 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	val |= u32_encode_bits(channel_id, GENERIC_CHID_FMASK);
 	val |= u32_encode_bits(GSI_EE_MODEM, GENERIC_EE_FMASK);
 
-	if (gsi_command(gsi, GSI_GENERIC_CMD_OFFSET, val, completion))
-		return 0;	/* Success! */
+	success = gsi_command(gsi, GSI_GENERIC_CMD_OFFSET, val, completion);
+
+	/* Disable the GP_INT1 IRQ type again */
+	iowrite32(ERROR_INT_FMASK, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+
+	if (success)
+		return 0;
 
 	dev_err(gsi->dev, "GSI generic command %u to channel %u timed out\n",
 		opcode, channel_id);
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 1dd81cf0b46a8..ae00aff1cfa50 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -335,7 +335,6 @@ enum gsi_irq_type_id {
 #define GP_INT1_FMASK			GENMASK(1, 1)
 #define GP_INT2_FMASK			GENMASK(2, 2)
 #define GP_INT3_FMASK			GENMASK(3, 3)
-#define GSI_CNTXT_GLOB_IRQ_ALL		GENMASK(3, 0)
 
 #define GSI_CNTXT_GSI_IRQ_STTS_OFFSET \
 			GSI_EE_N_CNTXT_GSI_IRQ_STTS_OFFSET(GSI_EE_AP)
-- 
2.20.1

