Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3002A85D5
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732131AbgKESOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732115AbgKESOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:31 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA06C0613D2
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:14:29 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id x7so2221364ili.5
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tLtk2ibesqsxzXzb9KuT/GH5fhME26PM/cBtUYjvqb8=;
        b=meZ+fiTEV2I0dOKr67GE4GP6C3/S9T9WnXAarJ6vJ7Udasf9z4NZLNpe9wXABhT6Rw
         wXepI40XY7I83C138kw+/E/d5+ulsUnptHpoWC5hpeSQc2cbBGPTz1sAEPJ8qbv4JkcK
         ZOGTHvhnoVMFa6h0ODvfuTX0RhFXd7K10VKQkjnIVaIGRulPzDDTKD1X8fnJIro/WeHv
         zsOue9c74fUsaPHSJC/9eb/3PcJA9EhpDD2gwZL1qKdyKbfS78V6ioSwU3BaAw7HWGub
         x56nqaUZ4dETBYsFe4Be95Ka1lEHkEMtFLKs4MjoWpwgTMun3YmgVb7euKUgTWzm+/Eg
         rzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tLtk2ibesqsxzXzb9KuT/GH5fhME26PM/cBtUYjvqb8=;
        b=Ew6DNKTkYat2pPYm1T4DKtA2uhlOaR6KC51FNlL8sv6i7cMR6SiB6Wvvn6V+DwOR5X
         ohRRq1Yol92lIT/usNqGbblqYFi54ZWecbL4+1TLk0ZK9Vcb8wfo8FHguMjRBw9A5utl
         TQkACEY2+GgLn5s+8LcZDsblo45XppP+qOA8ADiheOCnmiDKavPyvYIZITeXlGysM1YS
         R3SvZ2DiaXIMWEkoCR4BbNoQ5nP3mZlR1FfQCBfWJY6qW6bqB2yDG2M+j7o63XMZwu/k
         mMO4lUWkXM4koN6yO19WhPF0Qknc+B7YhPetVYnopZ1SWbPT3iI9mIb/vcsHEyJFb50y
         mpvA==
X-Gm-Message-State: AOAM532SUEkYjIBl9X/rVmO4xbA3bpVEtLtZmY2b1Zkhl/VE/GDaSnll
        YnGN6cUl6E6FcVxtI5vnlWXr8w==
X-Google-Smtp-Source: ABdhPJyLQRShErQLyjn9KMJ/DBmJgtwt8ZC9BewhJuCPJzZ5R5Ev9ftON8AjY7spQ1f1e8D07Vcy/Q==
X-Received: by 2002:a92:154c:: with SMTP id v73mr3004497ilk.263.1604600068896;
        Thu, 05 Nov 2020 10:14:28 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o19sm1554136ilt.24.2020.11.05.10.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:14:28 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 12/13] net: ipa: only enable GSI general IRQs when needed
Date:   Thu,  5 Nov 2020 12:14:06 -0600
Message-Id: <20201105181407.8006-13-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201105181407.8006-1-elder@linaro.org>
References: <20201105181407.8006-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most GSI general errors are unrecoverable without a full reset.
Despite that, we want to receive these errors so we can at least
report what happened before whatever undefined behavior ensues.

Explicitly disable all such interrupts in gsi_irq_setup(), then
enable those we want in gsi_irq_enable().  List the interrupt types
we are interested in (everything but breakpoint) explicitly rather
than using GSI_CNTXT_GSI_IRQ_ALL, and remove that symbol's
definition.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 14 ++++++++++----
 drivers/net/ipa/gsi_reg.h |  1 -
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 5e10e5c1713b1..aa3983649bc30 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -261,6 +261,7 @@ static void gsi_irq_setup(struct gsi *gsi)
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 	iowrite32(0, gsi->virt + GSI_INTER_EE_SRC_CH_IRQ_OFFSET);
 	iowrite32(0, gsi->virt + GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET);
+	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 }
 
 /* Turn off all GSI interrupts when we're all done */
@@ -309,8 +310,14 @@ static void gsi_irq_enable(struct gsi *gsi)
 	iowrite32(ERROR_INT_FMASK, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 	gsi->type_enabled_bitmap |= BIT(GSI_GLOB_EE);
 
-	/* Never enable GSI_BREAK_POINT */
-	val = GSI_CNTXT_GSI_IRQ_ALL & ~BREAK_POINT_FMASK;
+	/* General GSI interrupts are reported to all EEs; if they occur
+	 * they are unrecoverable (without reset).  A breakpoint interrupt
+	 * also exists, but we don't support that.  We want to be notified
+	 * of errors so we can report them, even if they can't be handled.
+	 */
+	val = BUS_ERROR_FMASK;
+	val |= CMD_FIFO_OVRFLOW_FMASK;
+	val |= MCS_STACK_OVRFLOW_FMASK;
 	iowrite32(val, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 	gsi->type_enabled_bitmap |= BIT(GSI_GENERAL);
 
@@ -1186,8 +1193,7 @@ static void gsi_isr_general(struct gsi *gsi)
 	val = ioread32(gsi->virt + GSI_CNTXT_GSI_IRQ_STTS_OFFSET);
 	iowrite32(val, gsi->virt + GSI_CNTXT_GSI_IRQ_CLR_OFFSET);
 
-	if (val)
-		dev_err(dev, "unexpected general interrupt 0x%08x\n", val);
+	dev_err(dev, "unexpected general interrupt 0x%08x\n", val);
 }
 
 /**
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index ae00aff1cfa50..c50464984c6e3 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -353,7 +353,6 @@ enum gsi_irq_type_id {
 #define BUS_ERROR_FMASK			GENMASK(1, 1)
 #define CMD_FIFO_OVRFLOW_FMASK		GENMASK(2, 2)
 #define MCS_STACK_OVRFLOW_FMASK		GENMASK(3, 3)
-#define GSI_CNTXT_GSI_IRQ_ALL		GENMASK(3, 0)
 
 #define GSI_CNTXT_INTSET_OFFSET \
 			GSI_EE_N_CNTXT_INTSET_OFFSET(GSI_EE_AP)
-- 
2.20.1

