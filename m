Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A323C26E2FE
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgIQRzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgIQRjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:39:42 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68D0C061220
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:38 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j2so3128210ioj.7
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HrZCFxVFcYmGpM7JLW5ZudWd5nkjs2XIh9Pd/OiKsY0=;
        b=K3Ac1DXpCUDFckXVqfzLOHAWwGMN6dq3ot6IW6bcmrnjNhVJyoUuGUkN8jQkaAuLfP
         8M+jfohg5uj6njFc14tkJPL4rmiXsOdeXXT5q/pUVKBYSlDur1WwBf575bfX3PkkEKUr
         AeJVa+zjaJWj/R/zNHs0Q1LHsn514TU0WhQEHEdvYvWzSRnyPG+GB5O894O4cnR3RVu8
         q+zeXa4zSuLLDW/3/Ko3B80JQFlb7jSb7GP/5+gUwajDg0JfDrRwG3JtTPhJa2Xij5pA
         /DNzmd43ZwZ/x5Bq5QZdLixq9XORb5pBNWozbasYrdW1qUP5Kj03mbmS4ERHiuzhwnaN
         ZkJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HrZCFxVFcYmGpM7JLW5ZudWd5nkjs2XIh9Pd/OiKsY0=;
        b=Wpup2OR32gpxA6wYtn6xUfozUsfE0tXqJJkx6KWTZzzJ9qVKAIsEaSbjlY6AyZ3bSD
         kU+hprIPxW4LUoGuihbMWcL4rJJwdky5aWC7iwcUWICRIwfXRcAXsr5R6Dj+qk2MQAeq
         DKW8IIlw0EGHQHJ86bGqbx2XWefz797y5KbIlSGSjVGb/UX3H97yxKNabAZhKMLxKuvX
         34ImmYTxdA3BWKdl5rSIkuPBF0qNjq/bDBWe9TmCD5OPHxtoWTF6kHJtalC2QhKtA4il
         Yick+ho3wW7dSNHt9ES4YKLKsMATBUGJSGprJozwJONIAA2QqBMJOuzBMU8X0/jX/Lb+
         y8og==
X-Gm-Message-State: AOAM530Xu1ajE7A+WZjb9aKBWvN8qQmGLfByYmEggegBmXSyGGOleW32
        NIXpZAKS9hh3LfHiHimubYW8+g==
X-Google-Smtp-Source: ABdhPJz+iPi9RVcnb1dl99VPd/ct60p0U2gUgsb/VWfvS5Z46FlYjdvhnktkK4WE62uiKjzi0CNqzg==
X-Received: by 2002:a05:6602:2201:: with SMTP id n1mr23796879ion.35.1600364378167;
        Thu, 17 Sep 2020 10:39:38 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l6sm192725ilt.34.2020.09.17.10.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 10:39:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 6/7] net: ipa: enable wakeup on IPA interrupt
Date:   Thu, 17 Sep 2020 12:39:25 -0500
Message-Id: <20200917173926.24266-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200917173926.24266-1-elder@linaro.org>
References: <20200917173926.24266-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we handle wakeup interrupts properly, arrange for the IPA
interrupt to be treated as a wakeup interrupt.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
v3: Added Bjorn's reviewed-by tag.

 drivers/net/ipa/ipa_interrupt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 90353987c45fc..cc1ea28f7bc2e 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -237,8 +237,16 @@ struct ipa_interrupt *ipa_interrupt_setup(struct ipa *ipa)
 		goto err_kfree;
 	}
 
+	ret = enable_irq_wake(irq);
+	if (ret) {
+		dev_err(dev, "error %d enabling wakeup for \"ipa\" IRQ\n", ret);
+		goto err_free_irq;
+	}
+
 	return interrupt;
 
+err_free_irq:
+	free_irq(interrupt->irq, interrupt);
 err_kfree:
 	kfree(interrupt);
 
@@ -248,6 +256,12 @@ struct ipa_interrupt *ipa_interrupt_setup(struct ipa *ipa)
 /* Tear down the IPA interrupt framework */
 void ipa_interrupt_teardown(struct ipa_interrupt *interrupt)
 {
+	struct device *dev = &interrupt->ipa->pdev->dev;
+	int ret;
+
+	ret = disable_irq_wake(interrupt->irq);
+	if (ret)
+		dev_err(dev, "error %d disabling \"ipa\" IRQ wakeup\n", ret);
 	free_irq(interrupt->irq, interrupt);
 	kfree(interrupt);
 }
-- 
2.20.1

