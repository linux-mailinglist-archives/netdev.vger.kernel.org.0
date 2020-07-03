Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B272140C2
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 23:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgGCVXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 17:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgGCVXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 17:23:40 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FB5C061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 14:23:39 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id k6so28262554ili.6
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 14:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GOZruoDFDXv5kLGp9J9FoBUytV2ZuP8UVxYNd0ERIPw=;
        b=SFF7IduqK8G6MhS5t5x3A4loCCSNpXlU/vcFEq44zuOhsuUIuL9X3xebW5rn37ffhK
         vReqYlp/FW149sVy2BhJUkAuTw9y1wGoVmsdpv/eqHR/iu7GmOr4D3gy8Y6TLmYi1K/T
         MuwR3Qtgm63pdp5TN2QJN5i7Z/4Cm+vq2+BPEW2UlO8xL5odTRCvfsjTtySnYh50RTwk
         1dCSOUA5jVUDHSNZrAxnspSMXOlUr1G+Qf7IKjPVrAa57hHGJ+I6qps+0H3OUWO68ZPY
         oNwr1AJLa58H609yScK+jSqGsRmWZbtjJFeipgUJExrrp+DIH+vUhVIGqSLPmvmH+dv0
         qnSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GOZruoDFDXv5kLGp9J9FoBUytV2ZuP8UVxYNd0ERIPw=;
        b=dgbtzTxIjjzGoMhrMgvqwnrJ/3Lya8Jmm+as/U+RPSpFuL1fr0wiF0RZm2DuDDsXDU
         rt4wdttEvqATg/pI5xPrE5fNVsJO1Sf97HjaUns58BCqGIBtQf50ImpWMl6vy12JHI/q
         0qmdyoQBhYzMaxcLt05zoiJ+q5mPA92sUdoeeCzlwrCbRfp1O4Mi1+L1KFhF+0oiarLX
         dVRJeUZOtH3hFr3MGdxJgvuBq7WtJMXl6dDxpAgwhaTDOuIyrujrjBrpQF16fHRhk4jb
         Mujmh4l8JMQNdhTlHhuW0AJ1ce/c3zuJaiZESOBDg6aS2PK4dQ8zYL6+22dq1V/gTYt8
         pfGg==
X-Gm-Message-State: AOAM533Pbuutcoi1plbMHOhyBGDjrXZWCJ0hXIBCCMDkQyrjWSG7QrSH
        u3BqI89tbpk489FW6laUmv8IXg==
X-Google-Smtp-Source: ABdhPJzd2ewsFruwmxIfzsQDQR1WJ6igBFAXPgq3+XijH73+x/sX+9JIniWbRhBLw7MHTREUQRVdjg==
X-Received: by 2002:a92:c530:: with SMTP id m16mr20147548ili.300.1593811419265;
        Fri, 03 Jul 2020 14:23:39 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m6sm7485292ilb.39.2020.07.03.14.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 14:23:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: ipa: introduce ipa_clock_rate()
Date:   Fri,  3 Jul 2020 16:23:34 -0500
Message-Id: <20200703212335.465355-2-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200703212335.465355-1-elder@linaro.org>
References: <20200703212335.465355-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new function that returns the current rate of the IPA core
clock.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 6 ++++++
 drivers/net/ipa/ipa_clock.h | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index c5204fd58ac4..0fbc8b1bdf41 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -256,6 +256,12 @@ void ipa_clock_put(struct ipa *ipa)
 	mutex_unlock(&clock->mutex);
 }
 
+/* Return the current IPA core clock rate */
+u32 ipa_clock_rate(struct ipa *ipa)
+{
+	return ipa->clock ? (u32)clk_get_rate(ipa->clock->core) : 0;
+}
+
 /* Initialize IPA clocking */
 struct ipa_clock *ipa_clock_init(struct device *dev)
 {
diff --git a/drivers/net/ipa/ipa_clock.h b/drivers/net/ipa/ipa_clock.h
index bc52b35e6bb2..0f4e2877a6df 100644
--- a/drivers/net/ipa/ipa_clock.h
+++ b/drivers/net/ipa/ipa_clock.h
@@ -10,6 +10,14 @@ struct device;
 
 struct ipa;
 
+/**
+ * ipa_clock_rate() - Return the current IPA core clock rate
+ * @ipa:	IPA structure
+ *
+ * Return: The current clock rate (in Hz), or 0.
+ */
+u32 ipa_clock_rate(struct ipa *ipa);
+
 /**
  * ipa_clock_init() - Initialize IPA clocking
  * @dev:	IPA device
-- 
2.25.1

