Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091A72623EF
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 02:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgIIAVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 20:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbgIIAVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 20:21:41 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1947C061798
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:21:37 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q6so641666ild.12
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 17:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C+4RJZne7XWnSNpMScCQkiPgvon7cqSHe4LlitFTkv0=;
        b=GtxiWvZyyPJXhAnEqPmFRyB1Iwm/yOJg+CcAcbtkzQyjJlbWzaEyhnOQjzqBwXKo3D
         9JQyr17zUT2RnvfiYlhhg3oFOt7Ogs/pthIq4Jxc0vPVcajwml3Ip/jlx14KcCPydm4O
         JYB143HO5vjRwfNMfCVFSpFU7oJmHFoVbV/b2CaOVhksmyiM/8WYLTfiQuq45Nl30hRr
         l7PdGLTfb8XG17Fo1zl2RODD1wxEPrqzK8Pf/Oq7xbUWViY87GPdn2Wl72j02Te8ayT4
         R06fi0wDnpGU879RpFlzPmpmyDbjXusF9id9XZHmuRMO4Gf8WbAUpRENTeOMxVVFDmDT
         EjaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C+4RJZne7XWnSNpMScCQkiPgvon7cqSHe4LlitFTkv0=;
        b=jZJNB6CVUE7jRWH52hJlsBfjD7wb3NQchOiKhae5QhhALbT0MCVG/nrVh68cTeQ6zf
         hUZhQlrU3/YQ+vrzK2rKErcwUg2HBOo72YmDucMd0p571f5TwPkwa0K3e9ik3r5eqMlX
         N38CfRDyNuE4oBHVS0uHHFsqqO77ZEUEp1RKwrSVCg2ZNvpahFjvmXsOvyn+q0QWE556
         4+DwbIBItsy46eGuRIa4zhfZibiwFiO2qm0xjtxLSOq4H3I0/2MOXtXb7bmhpJSUnHt+
         W6wyvfgueDV6WeU2hcW+VEI77iEyVeMHeTK7QE5rp9uBHadVhQZo3D9LR15mYDuYMuBT
         S6mQ==
X-Gm-Message-State: AOAM533Gkm3T9vLiUWOMZ9+CK3smIw+qmAoGOgOC5SH0nyvQ8dAZBZYn
        str4nCRgUkg6qySgjOS/oSLhJA==
X-Google-Smtp-Source: ABdhPJyQs0NlFJVVQcPt1Fprj0cFZca4Dlw3CpJSD9OOToUdZ7XtGb4Nz9Twt8m78EsKb3vgQWKKkg==
X-Received: by 2002:a05:6e02:1205:: with SMTP id a5mr1440543ilq.167.1599610896416;
        Tue, 08 Sep 2020 17:21:36 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f21sm457739ioh.1.2020.09.08.17.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 17:21:35 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: ipa: enable wakeup on IPA interrupt
Date:   Tue,  8 Sep 2020 19:21:26 -0500
Message-Id: <20200909002127.21089-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909002127.21089-1-elder@linaro.org>
References: <20200909002127.21089-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we handle wakeup interrupts properly, arrange for the IPA
interrupt to be treated as a wakeup interrupt.

Signed-off-by: Alex Elder <elder@linaro.org>
---
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

