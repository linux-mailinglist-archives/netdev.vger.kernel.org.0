Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A573D2623F4
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 02:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgIIAWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 20:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729129AbgIIAVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 20:21:41 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE443C061799
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:21:38 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id t18so67620ilp.5
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 17:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GXt6HV+Ir2mOjyqv+jsDtLLXzMvpXAXcGItzvsZha8c=;
        b=K1ikBxwOY2ZfMmKbyNAEfa+2REjTqMN5eToafYQxqDBbSkbgmYHhxvACi/tyeBGRuU
         YYlVJsbOjE1qn4oxIJMnuCo2jsxS080MXAa4SsC+XWNS257yjSYa3VBOFh47Cox/ZfKA
         MrFt1VB9WWLDTG8FYVgjeOtWDiwnXS0PIG403ri43pQKqqpnf1/DDayLHncvpXuT+fR/
         YUJhPqJvB0IoSw9DiUJ/G7uR2HGzAAahhgrEz+ao7bb67jFJjrpDVYqYvwiv0KRyE6gI
         TjVyR6PeWVZsQm0KVeM7LKeAydLYQLR7tHOlSKvxMdeQB0R9wxuhC//7VP5+5i/wBBKp
         U/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GXt6HV+Ir2mOjyqv+jsDtLLXzMvpXAXcGItzvsZha8c=;
        b=W2PtnmjrLc18y9ezjlNZZSQYeK9udHtNUHLJ4AhoP3+o5H++F9tOuXw8Hwhds9JrZ/
         to2fWhm4ZJoP1pC2CEfUmBmbkrDbwvB9WGtzcz1retCxRjJsZkWDwuSa4sNwSXgLxRTN
         Ay3FUXbqCImkIsO+c4gVSZQi5uhRSd0M0aMUsrSloWKGoiazvqJe4dXoViuUov3T5ICx
         J+dDf6xEtYdTLOvxCBN/gUnjOtSjXcGa7hadVff5rmyz2L0ccm2qedUV7BvXL6blatfm
         VCyM8rawaK5hnnMU3rLS9OeO4htEdUwum8ABvXYEnJnqt1YclBFBvWyo2JtXT/Mjwk9Y
         +G8w==
X-Gm-Message-State: AOAM531Yb5gjsoTG/iOwJMTbe7aYEBdPY5oo4EDWUhCcIZ9dmUeF1MQy
        Abz+wBLvPvV4GAQvfmi2bgZFeQ==
X-Google-Smtp-Source: ABdhPJz8Y/hkeZJj/oWXAMsOPa7lCT6ojQegClkfzBAlqYnHR0bugPQcNg9H8Kq5XTc8HyJcAi3YAg==
X-Received: by 2002:a92:9145:: with SMTP id t66mr1300389ild.305.1599610897475;
        Tue, 08 Sep 2020 17:21:37 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f21sm457739ioh.1.2020.09.08.17.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 17:21:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: ipa: do not enable GSI interrupt for wakeup
Date:   Tue,  8 Sep 2020 19:21:27 -0500
Message-Id: <20200909002127.21089-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909002127.21089-1-elder@linaro.org>
References: <20200909002127.21089-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We now trigger a system resume when we receive an IPA SUSPEND
interrupt.  We should *not* wake up on GSI interrupts.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 17 ++++-------------
 drivers/net/ipa/gsi.h |  1 -
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 0e63d35320aaf..cb75f7d540571 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1987,31 +1987,26 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
 	}
 	gsi->irq = irq;
 
-	ret = enable_irq_wake(gsi->irq);
-	if (ret)
-		dev_warn(dev, "error %d enabling gsi wake irq\n", ret);
-	gsi->irq_wake_enabled = !ret;
-
 	/* Get GSI memory range and map it */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gsi");
 	if (!res) {
 		dev_err(dev, "DT error getting \"gsi\" memory property\n");
 		ret = -ENODEV;
-		goto err_disable_irq_wake;
+		goto err_free_irq;
 	}
 
 	size = resource_size(res);
 	if (res->start > U32_MAX || size > U32_MAX - res->start) {
 		dev_err(dev, "DT memory resource \"gsi\" out of range\n");
 		ret = -EINVAL;
-		goto err_disable_irq_wake;
+		goto err_free_irq;
 	}
 
 	gsi->virt = ioremap(res->start, size);
 	if (!gsi->virt) {
 		dev_err(dev, "unable to remap \"gsi\" memory\n");
 		ret = -ENOMEM;
-		goto err_disable_irq_wake;
+		goto err_free_irq;
 	}
 
 	ret = gsi_channel_init(gsi, prefetch, count, data, modem_alloc);
@@ -2025,9 +2020,7 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
 
 err_iounmap:
 	iounmap(gsi->virt);
-err_disable_irq_wake:
-	if (gsi->irq_wake_enabled)
-		(void)disable_irq_wake(gsi->irq);
+err_free_irq:
 	free_irq(gsi->irq, gsi);
 
 	return ret;
@@ -2038,8 +2031,6 @@ void gsi_exit(struct gsi *gsi)
 {
 	mutex_destroy(&gsi->mutex);
 	gsi_channel_exit(gsi);
-	if (gsi->irq_wake_enabled)
-		(void)disable_irq_wake(gsi->irq);
 	free_irq(gsi->irq, gsi);
 	iounmap(gsi->virt);
 }
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 061312773df09..3f9f29d531c43 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -150,7 +150,6 @@ struct gsi {
 	struct net_device dummy_dev;	/* needed for NAPI */
 	void __iomem *virt;
 	u32 irq;
-	bool irq_wake_enabled;
 	u32 channel_count;
 	u32 evt_ring_count;
 	struct gsi_channel channel[GSI_CHANNEL_COUNT_MAX];
-- 
2.20.1

