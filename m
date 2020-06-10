Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62D91F4F6A
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 09:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgFJHp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 03:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgFJHpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 03:45:18 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94448C08C5C2
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:45:18 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id jz3so524633pjb.0
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dSE9dqY0eKEnI3JM3RkevfVx7P9DxAySSIY6zGnKG0k=;
        b=WXzfKpRRB+NVEcrx1DrXeFn4Zl0QZkDdxU//UBjGNAaCX+JQVGITtK+UGOBEoCUXIK
         myf8udUAJmwR/9W5QhgROJsAIQ3emSO1B/VNRSPChKLzT2h188lJKbMGa+mE+fk0V55+
         90JALIk6+qnfPhWOvhpZY6kPp/te71ZWukNxu2+zzKmF3sc0xj0+nFd8cYcdWs+/tEgv
         0wRxswm3c+jDYZFIahRpQ77uyjSj87kH5OzsVodMBxQRLzcQjv02kH4YlPyAj+0O0QN6
         3w4R02ldFEClJoNRIqcy60ArKH74VkIuJiAUUrR1vRbWef5r5f3OosL3rTBUkMktIN7v
         mAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dSE9dqY0eKEnI3JM3RkevfVx7P9DxAySSIY6zGnKG0k=;
        b=U6IGxIPJsfVvemzzjSmezGA5U68eGeqax74rwskKK6U974lMJY8mYV0RNOaler5uXd
         gIltQwpxnF+9HS1qvbZfn+7iKnmO+o58T2MXa3cxzhodHvTM1tjw4VpcvoFwIycNCpnY
         AJOlqYGSPjYO/IApFe5gX14SvjbZwQdLL+NsfVPsMHvaMAlaA6ycI+aRo0M7CPROTb78
         6vTYd4gMvjq6ABGZEyJLt+nVWH7g1tsVGaSTY59gWnrG3ntQnw7henbPO0MjvTOePS1r
         /kNBqWOL/vqcO37+CeLdKJw6FEAysUwU2CDlFVMi6Q7l8JGi9NTpUm3L5BXMmBKsG7KO
         bwrA==
X-Gm-Message-State: AOAM532LCIoem8JwT8P0rxEM295lCwJRLhr0aKJ10wK8+ZUvXpO0xk3I
        1/X1hXshJUrCVcBI+2tO1GB2
X-Google-Smtp-Source: ABdhPJwmMllCSLLM48OYqjMqz6MJbQ+nGsnFGVQP7soYwKKPuw84pquM6EqVv45zwjpIhzYLZwIo9A==
X-Received: by 2002:a17:90a:8a18:: with SMTP id w24mr1702381pjn.222.1591775118019;
        Wed, 10 Jun 2020 00:45:18 -0700 (PDT)
Received: from Mani-XPS-13-9360.localdomain ([2409:4072:630f:1dba:c41:a14e:6586:388a])
        by smtp.gmail.com with ESMTPSA id a20sm11516795pff.147.2020.06.10.00.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 00:45:17 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     wg@grandegger.com, mkl@pengutronix.de
Cc:     kernel@martin.sperl.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5/6] can: mcp25xxfd: Optimize TEF read by avoiding unnecessary SPI transfers
Date:   Wed, 10 Jun 2020 13:14:41 +0530
Message-Id: <20200610074442.10808-6-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200610074442.10808-1-manivannan.sadhasivam@linaro.org>
References: <20200610074442.10808-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Sperl <kernel@martin.sperl.org>

We have already enough information to know how many tx-messages have
been terminated so that we do not have to query TEF every time if
there is anything pending but we can read the tefs blindly.

This avoids 1 SPI transfer per TEF read.

Signed-off-by: Martin Sperl <kernel@martin.sperl.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 .../net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.c  | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.c
index 5ea1e525e776..6f066cb95844 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.c
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.c
@@ -263,6 +263,13 @@ int mcp25xxfd_can_tx_handle_int_tefif_fifo(struct mcp25xxfd_can_priv *cpriv)
 					MCP25XXFD_CAN_TEFCON_UINC);
 }
 
+/* reading TEF entries can be made even more efficient by reading
+ * multiple TEF entries in one go.
+ * Under the assumption that we have count(TEF) >= count(TX_FIFO)
+ * we can even release TEFs early (before we read them)
+ * (and potentially restarting the transmit-queue early aswell)
+ */
+
 static int
 mcp25xxfd_can_tx_handle_int_tefif_conservative(struct mcp25xxfd_can_priv *cpriv)
 {
@@ -293,6 +300,25 @@ mcp25xxfd_can_tx_handle_int_tefif_conservative(struct mcp25xxfd_can_priv *cpriv)
 	return 0;
 }
 
+static int
+mcp25xxfd_can_tx_handle_int_tefif_optimized(struct mcp25xxfd_can_priv *cpriv,
+					    u32 finished)
+{
+	int i, fifo, ret;
+
+	/* now iterate those */
+	for (i = 0, fifo = cpriv->fifos.tx.start; i < cpriv->fifos.tx.count;
+	     i++, fifo++) {
+		if (finished & BIT(fifo)) {
+			ret = mcp25xxfd_can_tx_handle_int_tefif_fifo(cpriv);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
 int mcp25xxfd_can_tx_handle_int_tefif(struct mcp25xxfd_can_priv *cpriv)
 {
 	unsigned long flags;
@@ -310,6 +336,13 @@ int mcp25xxfd_can_tx_handle_int_tefif(struct mcp25xxfd_can_priv *cpriv)
 
 	spin_unlock_irqrestore(&cpriv->fifos.tx_queue->lock, flags);
 
+	/* run in optimized mode if possible */
+	if (finished)
+		return mcp25xxfd_can_tx_handle_int_tefif_optimized(cpriv,
+								   finished);
+	/* otherwise play it safe */
+	netdev_warn(cpriv->can.dev,
+		    "Something is wrong - we got a TEF interrupt but we were not able to detect a finished fifo\n");
 	return mcp25xxfd_can_tx_handle_int_tefif_conservative(cpriv);
 }
 
-- 
2.17.1

