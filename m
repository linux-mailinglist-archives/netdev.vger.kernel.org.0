Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B232A85DA
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732173AbgKESOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732083AbgKESO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:28 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43F3C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:14:26 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id a20so2185215ilk.13
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q46g2Y4Md6zeZcB0v/PCzPRQD2/DO2sEvtaycXsef+M=;
        b=aoiHrPfJtviJWxpB0JTShgx5+idh8ck62Xs+hABLTdURbuevfLTEvRtsyLebTs+/Hc
         Y8vAopVPwC6PMNtl0q0mt7LQaVvTdv67cwsKRqdgClNOyl0KKs+XYCLc4X5xxu4EWtgp
         9OFy/cffEgYlAhqUENFc4wDDbYtXbLzUnytT4MjoYVgyh1ldnaOkh45oTDuulvftni0Q
         3RpQGKHnteYd0S9z09MFoKVgjQmj+caGy6YKXOP9vE9y3uJMSmBvjY4jA/JY3gkcIYq9
         tgSWMXdVExzdtlNyBLjM8GFHnRKbk0rJ2VSmRpue1AIxJOcu556qJdLNctvxFsjpK9DL
         YlOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q46g2Y4Md6zeZcB0v/PCzPRQD2/DO2sEvtaycXsef+M=;
        b=N8rX9JGwkASUehpJowNMjN8FYOCdBDeA6DsCGiUvH9ZJBZzdymrYq3q1MO8ofTaPFG
         udDNwkr+GvDeQs9a2gv5Mv56iQrAmCEFTUe4pYWoRF0PQ+bW0oXd4GfjTauSR2/+LmvD
         ij4DMMDlvY/+c2/DrPkxFO9KSzOgubtZOufuyLnTGFM/WB36xWj/ihHboXEZGU4huJwM
         5axg0/QM0153CFsFPtCRDBxMS1IJBSCPhlqiP5fLhGgnRuOJh78qW+G76P2EVk/eCXWj
         5JRWOZgBh9Twg0euPxXA76k04hcRGSdgaQ7Xb6TTswr+gRXumKywZR1wH4U1EEAyVCLp
         g60g==
X-Gm-Message-State: AOAM533/9QVT1zB3bxek6Y7B/kgKEcFa7QmKhezSlJ8Cxfop5ThYfQYh
        +V0slN1ljKL/5yUVOEM9MEcZFA==
X-Google-Smtp-Source: ABdhPJyiaIVvYMPOI0rermK3dUd5lICYM6Jc4yylzvun/oYgwxnt0fkRt7l3FO0SbwmhuFjN2WbulA==
X-Received: by 2002:a92:ca86:: with SMTP id t6mr2777842ilo.95.1604600066131;
        Thu, 05 Nov 2020 10:14:26 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o19sm1554136ilt.24.2020.11.05.10.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:14:25 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/13] net: ipa: only enable GSI IEOB IRQs when needed
Date:   Thu,  5 Nov 2020 12:14:04 -0600
Message-Id: <20201105181407.8006-11-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201105181407.8006-1-elder@linaro.org>
References: <20201105181407.8006-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A GSI channel must be started in order to use it to perform a
transfer data (or command) transaction.  And the only time we'll see
an IEOB interrupt is if we send a transaction to a started channel.
Therefore we do not need to have the IEOB interrupt type enabled
until at least one channel has been started.  And once the last
started channel has been stopped, we can disable the IEOB interrupt
type again.

We already enable the IEOB interrupt for a particular channel only
when it is started.  Extend that by having the IEOB interrupt *type*
be enabled only when at least one channel is in STARTED state.

Disallow all channels from triggering the IEOB interrupt in
gsi_irq_setup().  We only enable an channel's interrupt when
needed, so there is no longer any need to zero the channel mask
in gsi_irq_disable().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 4ab1d89f642ea..aae8ea852349d 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -258,6 +258,7 @@ static void gsi_irq_setup(struct gsi *gsi)
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 }
 
 /* Turn off all GSI interrupts when we're all done */
@@ -269,11 +270,16 @@ static void gsi_irq_teardown(struct gsi *gsi)
 
 static void gsi_irq_ieob_enable(struct gsi *gsi, u32 evt_ring_id)
 {
+	bool enable_ieob = !gsi->ieob_enabled_bitmap;
 	u32 val;
 
 	gsi->ieob_enabled_bitmap |= BIT(evt_ring_id);
 	val = gsi->ieob_enabled_bitmap;
 	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
+
+	/* Enable the interrupt type if this is the first channel enabled */
+	if (enable_ieob)
+		gsi_irq_type_enable(gsi, GSI_IEOB);
 }
 
 static void gsi_irq_ieob_disable(struct gsi *gsi, u32 evt_ring_id)
@@ -281,6 +287,11 @@ static void gsi_irq_ieob_disable(struct gsi *gsi, u32 evt_ring_id)
 	u32 val;
 
 	gsi->ieob_enabled_bitmap &= ~BIT(evt_ring_id);
+
+	/* Disable the interrupt type if this was the last enabled channel */
+	if (!gsi->ieob_enabled_bitmap)
+		gsi_irq_type_disable(gsi, GSI_IEOB);
+
 	val = gsi->ieob_enabled_bitmap;
 	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 }
@@ -296,10 +307,6 @@ static void gsi_irq_enable(struct gsi *gsi)
 	iowrite32(ERROR_INT_FMASK, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 	gsi->type_enabled_bitmap |= BIT(GSI_GLOB_EE);
 
-	/* Each IEOB interrupt is enabled (later) as needed by channels */
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
-	gsi->type_enabled_bitmap |= BIT(GSI_IEOB);
-
 	/* We don't use inter-EE channel or event interrupts */
 
 	/* Never enable GSI_BREAK_POINT */
@@ -318,7 +325,6 @@ static void gsi_irq_disable(struct gsi *gsi)
 	gsi_irq_type_update(gsi);
 
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 }
 
-- 
2.20.1

