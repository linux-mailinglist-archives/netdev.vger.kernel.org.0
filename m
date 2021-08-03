Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE3F3DEF90
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbhHCOBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236464AbhHCOBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:01:24 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC84C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 07:01:13 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id i13so7659682ilm.11
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 07:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+yxvUAjlQXeGYAgTSezvFwBfFS0lHATudjbMDmfcOIk=;
        b=Dm3YNwsg0N6z7fNUXisHxsWrxCpPda9PcrAhzw44fFqIANO0//ygJq53XY6I+9mQhh
         xhl7BFHEVuHuwcg+lp8btAUOn0bTwn6wUA04Cw9zdDWKjTchYP5bN91bKBP4NTcqWxQv
         v2MI64FvF+QEo2xolfDQoqt0tknzL7PsBS7lFdfmtSBZWYbTkuSxYE7OdxV79cvAqWFb
         sziAz2oc6Oz2ynfV/SbC5Tepm1URTx6zcJMNBjsPakXllAAZur1wy3FlGZPENoIuuY81
         nPiBJNuwIs0A170yiZtrzIaxgOMK2D/izOxyJIe5YSbUGJcwFLz//HrbTKUWfS4fzPlh
         Pwsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+yxvUAjlQXeGYAgTSezvFwBfFS0lHATudjbMDmfcOIk=;
        b=dZV2MIrMPFGzEya1OW5XE/fiZZewTRzEu3fDqRjG+5BwTpJfIY3WOjJV6WNwWe+ope
         oNYQeXLn2S737isHrbkqQrmL+NtkfL7Png0tXftQzMrNt5v519lTtjn2U+5xioTLg2cj
         JJne7vhfxyIR5Hox+dhhqoNeHbQ7lm/FsX12jguxTK7+gSuNhmfMl8kWklBmsL9+JcNB
         B3/s3NjoEAWv5AxH9lYexj88mrgCcz3hVENbKmz7bKmg/rAEaKKYyI4ysXkxcUtqedZV
         3R/TKkjQdRHEIWrFlWoktJ58WWAvtcUl+CiYBF/yWAd0LQT57mFhRAHp1z2D5t3dt/C8
         wU+w==
X-Gm-Message-State: AOAM533PWwef2YMG2bFyRkuJH9/xn4IrHc9RDWvikUZA39dedVNKmxce
        kl/+bdUgrLdsC6fOAZMnnv23LsahlATWTQ==
X-Google-Smtp-Source: ABdhPJyEm95vTS5ttRg71MCe4jkHPpvliQKqk6OovREX87ruK5imq4u2583b4K8dNSKIEW4AeuY1WA==
X-Received: by 2002:a92:ca45:: with SMTP id q5mr778759ilo.7.1627999273004;
        Tue, 03 Aug 2021 07:01:13 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w7sm9456798iox.1.2021.08.03.07.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 07:01:12 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: move gsi_irq_init() code into setup
Date:   Tue,  3 Aug 2021 09:01:02 -0500
Message-Id: <20210803140103.1012697-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210803140103.1012697-1-elder@linaro.org>
References: <20210803140103.1012697-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GSI IRQ handler could be triggered as soon as it is registered
with request_irq().  The handler function, gsi_isr(), touches
hardware, meaning the IPA clock must be operational.  The IPA clock
is not operating when the handler is registered (in gsi_irq_init()),
so this is a problem.

Move the call to request_irq() for the GSI interrupt handler into
gsi_irq_setup(), which is called when the IPA clock is known to be
operational (and furthermore, the GSI firmware will have been
loaded).  Request the IRQ at the end of that function, after all
interrupt types have been disabled and masked.

Move the matching free_irq() call into gsi_irq_teardown(), and get
rid of the now empty gsi_irq_exit(),

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index be069d7c4feb9..c555ccd778bb8 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1303,33 +1303,20 @@ static irqreturn_t gsi_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+/* Init function for GSI IRQ lookup; there is no gsi_irq_exit() */
 static int gsi_irq_init(struct gsi *gsi, struct platform_device *pdev)
 {
-	struct device *dev = &pdev->dev;
-	unsigned int irq;
 	int ret;
 
 	ret = platform_get_irq_byname(pdev, "gsi");
 	if (ret <= 0)
 		return ret ? : -EINVAL;
 
-	irq = ret;
-
-	ret = request_irq(irq, gsi_isr, 0, "gsi", gsi);
-	if (ret) {
-		dev_err(dev, "error %d requesting \"gsi\" IRQ\n", ret);
-		return ret;
-	}
-	gsi->irq = irq;
+	gsi->irq = ret;
 
 	return 0;
 }
 
-static void gsi_irq_exit(struct gsi *gsi)
-{
-	free_irq(gsi->irq, gsi);
-}
-
 /* Return the transaction associated with a transfer completion event */
 static struct gsi_trans *gsi_event_trans(struct gsi_channel *channel,
 					 struct gsi_event *event)
@@ -1810,6 +1797,8 @@ static void gsi_channel_teardown(struct gsi *gsi)
 /* Turn off all GSI interrupts initially */
 static int gsi_irq_setup(struct gsi *gsi)
 {
+	int ret;
+
 	/* Writing 1 indicates IRQ interrupts; 0 would be MSI */
 	iowrite32(1, gsi->virt + GSI_CNTXT_INTSET_OFFSET);
 
@@ -1835,11 +1824,16 @@ static int gsi_irq_setup(struct gsi *gsi)
 
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 
-	return 0;
+	ret = request_irq(gsi->irq, gsi_isr, 0, "gsi", gsi);
+	if (ret)
+		dev_err(gsi->dev, "error %d requesting \"gsi\" IRQ\n", ret);
+
+	return ret;
 }
 
 static void gsi_irq_teardown(struct gsi *gsi)
 {
+	free_irq(gsi->irq, gsi);
 }
 
 /* Get # supported channel and event rings; there is no gsi_ring_teardown() */
@@ -2224,20 +2218,18 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 
 	init_completion(&gsi->completion);
 
-	ret = gsi_irq_init(gsi, pdev);
+	ret = gsi_irq_init(gsi, pdev);	/* No matching exit required */
 	if (ret)
 		goto err_iounmap;
 
 	ret = gsi_channel_init(gsi, count, data);
 	if (ret)
-		goto err_irq_exit;
+		goto err_iounmap;
 
 	mutex_init(&gsi->mutex);
 
 	return 0;
 
-err_irq_exit:
-	gsi_irq_exit(gsi);
 err_iounmap:
 	iounmap(gsi->virt_raw);
 
@@ -2249,7 +2241,6 @@ void gsi_exit(struct gsi *gsi)
 {
 	mutex_destroy(&gsi->mutex);
 	gsi_channel_exit(gsi);
-	gsi_irq_exit(gsi);
 	iounmap(gsi->virt_raw);
 }
 
-- 
2.27.0

