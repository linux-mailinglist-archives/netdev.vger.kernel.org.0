Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6D73D81AC
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhG0VVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbhG0VVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:21:14 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41946C0619EC
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:19:39 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id o7so621103ilh.11
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uxr6HGwaPwBEs31x3X5oKeAbqmL6VbyD6eX4zPry52o=;
        b=npRv/52O9Ij5zUv0wUR9QJ/AIumYBM3czuulN1dd6wfQ1K65Z+0dm0EkbmKiaOkHRS
         jafAmXiX4yBZwjt1M2yOTLDnmU4xXrfrUjP5DBHBYhDOKbBWSvQpFLU3eDHgOVvft7s7
         PnDzrygzNENKwh0jFrSZdbuXRDF57VvoiklqwKawked3xicdq05p4+rpjywrGgOKTFlh
         A2isPKA0kca3tE/y3sUJSSGFKgsdCWvKEaS+S1mhmECLahmm9qbNBimz9iDH5jcZjiwo
         tjfsDNB1MO4yekGh5IfckpsyI9nvFZM2jfY0cI9ZZk5f0T0xqsqMxd5/8a/VEd8OSkFi
         4zag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uxr6HGwaPwBEs31x3X5oKeAbqmL6VbyD6eX4zPry52o=;
        b=OkNfSunnOrTUdpZ2BNUm3vB+/fMQbgcyhfyw+XTBVSL1BVGSm8dZ33ldeU03NCm1VS
         69QfvtLPsO7nNtg9YEzKHwgbUPMEKkxu1XySoJT2J7v0Pha2tIA+6S5/CdATPUeU+qVf
         XRebpQPaoN9fCQnsZRNfP491gFIRB/WqpiWaWc3oc2RiwBJvPAVkdJB7mekUjhGCXbG/
         bUYNXitEU7ZiXvCfcHE9pIQzjF0p75T4eMpDfWBqSZLe2I4woCggs01w5hZq1WkKfw6B
         fkU9WiFadFWBDHtlSQKsP/Pwvmva9MeWWpz/ZJ12QmLMWt9AGxsnDnUhfLx5ROwaO/HC
         cBNQ==
X-Gm-Message-State: AOAM530s7/aZhQQt5qln3W2IP6PJ9HtcSHY6001sCSW5W3D0xCO7lexa
        POND4iO/MNPhs/G20xAGrX4ogA==
X-Google-Smtp-Source: ABdhPJzF17a4LwnMj7RkUe6d1ZU1uenDR3QIXJvzKbFngCjImX/xzYNNYXY1x2J04GixmsCt3MUCWw==
X-Received: by 2002:a05:6e02:1208:: with SMTP id a8mr18103144ilq.257.1627420778680;
        Tue, 27 Jul 2021 14:19:38 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s21sm3136068iot.33.2021.07.27.14.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:19:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: ipa: add clock reference for remoteproc SSR
Date:   Tue, 27 Jul 2021 16:19:31 -0500
Message-Id: <20210727211933.926593-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210727211933.926593-1-elder@linaro.org>
References: <20210727211933.926593-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The remoteproc SSR callback function for the modem requires hardware
access when handling a modem crash or shutdown.  Take and later
release an IPA clock reference in ipa_modem_crashed(), to ensure the
hardware is operational.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_modem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index c851e2cf12552..a744b81db0d9f 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -20,6 +20,7 @@
 #include "ipa_smp2p.h"
 #include "ipa_qmi.h"
 #include "ipa_uc.h"
+#include "ipa_clock.h"
 
 #define IPA_NETDEV_NAME		"rmnet_ipa%d"
 #define IPA_NETDEV_TAILROOM	0	/* for padding by mux layer */
@@ -279,6 +280,8 @@ static void ipa_modem_crashed(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	int ret;
 
+	ipa_clock_get(ipa);
+
 	ipa_endpoint_modem_pause_all(ipa, true);
 
 	ipa_endpoint_modem_hol_block_clear_all(ipa);
@@ -303,6 +306,8 @@ static void ipa_modem_crashed(struct ipa *ipa)
 	ret = ipa_mem_zero_modem(ipa);
 	if (ret)
 		dev_err(dev, "error %d zeroing modem memory regions\n", ret);
+
+	ipa_clock_put(ipa);
 }
 
 static int ipa_modem_notify(struct notifier_block *nb, unsigned long action,
-- 
2.27.0

