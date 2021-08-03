Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05863DEF8F
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbhHCOBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236386AbhHCOBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:01:23 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB105C0613D5
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 07:01:12 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id r6so16080068ioj.8
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 07:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PtQLPSseXwgcXWxbV0GTVE8n9SJgEFIFbxs9fZ84aRA=;
        b=wbylETv5vnvmDPaVcbGsCeoWhKCZAnyQ+225qyafuZslTvRqdGl6+217DdQjaX5Re+
         4M7TDRY3ZzAvBuQ2BFgyCkEmyV+KZ1/tf2CQADMisFgIJG8v0M7BfFFbRgDuCO2iFT0v
         LZLgn0GlO/0MhUnr/Pm+F8GJdA3WswI41knmUxJNcu9DL0fcZqtpH74AyvfwOnzRCDM8
         2zX9XitaX7598xTk+VI+Ac6jKeKb0X9UtvEDXhbXxdtw5D3CoCsy7QG/ffjzrHtBWMfx
         QJ20gzCpK1b9pcQTUGINyK+DBwSHX7TKu/8VTk7Q7t3ekUfdRrNnv5VkIzTI5QLRd2Ss
         dz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PtQLPSseXwgcXWxbV0GTVE8n9SJgEFIFbxs9fZ84aRA=;
        b=BYr/uteUguisRztBXtTcntR8TASkotOup3rarARamHmfLqriq6dCkfNCqDzShLYaxA
         6qvhEHSNmRGOCqHh0Po31FH7MmehI9GCCn9BvsvH1xn67fik6oqdIYGwT5/le6/EmDWA
         OMeFi58du7j7GxmASaSVEdJQSH1jcjpdx5PiLSIpulw5Jyv6YALvoSRakW3nMtayHn+m
         FslTVVpfKlv+MendoE8+vkEYBD+o/AbGj9oHw0mWUGPYikmg3lMiIrF6ZumbegGp3y87
         zTWSbiWGtNcCngBuZE9M4W1qXpFmuR49yA8aE0tWnNiGWfT8diRYLZI3lGf26Bo7Xsi6
         4pjA==
X-Gm-Message-State: AOAM531FcRc4glHr9ujfNOiD4AqpdNC84c0ZYb4s4HMYdDatwIJqWHa2
        yQ0mL5gpfYA0E/umXWBvJs589A==
X-Google-Smtp-Source: ABdhPJxDnE4oi3J7yYbDm+d9me0sbRoq3aMtICUSZ3pBZcA+wimiZpB4RUD+PCE2Dat1+w9acM6UWQ==
X-Received: by 2002:a5e:d905:: with SMTP id n5mr1145832iop.136.1627999272164;
        Tue, 03 Aug 2021 07:01:12 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w7sm9456798iox.1.2021.08.03.07.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 07:01:11 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: have gsi_irq_setup() return an error code
Date:   Tue,  3 Aug 2021 09:01:01 -0500
Message-Id: <20210803140103.1012697-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210803140103.1012697-1-elder@linaro.org>
References: <20210803140103.1012697-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change gsi_irq_setup() so it returns an error value, and introduce
gsi_irq_teardown() as its inverse.  Set the interrupt type (IRQ
rather than MSI) in gsi_irq_setup().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index a5d23a2837cb6..be069d7c4feb9 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1807,9 +1807,12 @@ static void gsi_channel_teardown(struct gsi *gsi)
 	gsi_irq_disable(gsi);
 }
 
-/* Turn off all GSI interrupts initially; there is no gsi_irq_teardown() */
-static void gsi_irq_setup(struct gsi *gsi)
+/* Turn off all GSI interrupts initially */
+static int gsi_irq_setup(struct gsi *gsi)
 {
+	/* Writing 1 indicates IRQ interrupts; 0 would be MSI */
+	iowrite32(1, gsi->virt + GSI_CNTXT_INTSET_OFFSET);
+
 	/* Disable all interrupt types */
 	gsi_irq_type_update(gsi, 0);
 
@@ -1831,6 +1834,12 @@ static void gsi_irq_setup(struct gsi *gsi)
 	}
 
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
+
+	return 0;
+}
+
+static void gsi_irq_teardown(struct gsi *gsi)
+{
 }
 
 /* Get # supported channel and event rings; there is no gsi_ring_teardown() */
@@ -1891,25 +1900,34 @@ int gsi_setup(struct gsi *gsi)
 		return -EIO;
 	}
 
-	gsi_irq_setup(gsi);		/* No matching teardown required */
+	ret = gsi_irq_setup(gsi);
+	if (ret)
+		return ret;
 
 	ret = gsi_ring_setup(gsi);	/* No matching teardown required */
 	if (ret)
-		return ret;
+		goto err_irq_teardown;
 
 	/* Initialize the error log */
 	iowrite32(0, gsi->virt + GSI_ERROR_LOG_OFFSET);
 
-	/* Writing 1 indicates IRQ interrupts; 0 would be MSI */
-	iowrite32(1, gsi->virt + GSI_CNTXT_INTSET_OFFSET);
+	ret = gsi_channel_setup(gsi);
+	if (ret)
+		goto err_irq_teardown;
 
-	return gsi_channel_setup(gsi);
+	return 0;
+
+err_irq_teardown:
+	gsi_irq_teardown(gsi);
+
+	return ret;
 }
 
 /* Inverse of gsi_setup() */
 void gsi_teardown(struct gsi *gsi)
 {
 	gsi_channel_teardown(gsi);
+	gsi_irq_teardown(gsi);
 }
 
 /* Initialize a channel's event ring */
-- 
2.27.0

