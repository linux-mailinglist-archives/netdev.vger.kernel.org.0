Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366A35E6FA1
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 00:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiIVWVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 18:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbiIVWV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 18:21:29 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010C810D0F0
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:21:14 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id v128so8934596ioe.12
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8NQbcO3RxX3i66zbcp0uk7GFHnQ5dOAsJhkZ2O3/nY8=;
        b=rnQS6/cvRAD9ElWGu7c5+xdFhhhEaPl2HOtLmQIWAmE80cjQmlE8xvf2VIywl0eWGH
         3r0KTxEr/8Lgrz8h/DeiI0WEZYzzQnfihyXpCXgzUMK0ghe6xylHP8YG+g7jRIzklO84
         kRo5rSA/C9mcfr0Sbl5dZCikTnUb4lFETe88LLFX9yI1MjEwd2OpVeuw1wuVtHiEP7vZ
         7HZ48psm0QbchBMTB7J/hqT+wn7RHupQ8WCA83BPk1EXEydqMTC6vzhkesQd2OqGc5kS
         An9aNx4khHwnLof6Qt0vAg0RtGUlXmcO8woYUqzWKmiUpGGFpVs0Kp3cDRV5knVFtOsp
         uqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8NQbcO3RxX3i66zbcp0uk7GFHnQ5dOAsJhkZ2O3/nY8=;
        b=4XYgDYHvqOnp6NgerWKBxREbhcqdi6yXKQkvr+SjKDdnRhL3iQxKPUGDbRnTf6PQZq
         h3WSmXQJ/swma19J/MZM4/+zEefNK96qtUtlvDJsfuqsB8s1Aj5TdyWBbf5AQEm6fghr
         Tvx+wpMW7OZNBquAYUq/Effg5f3VZWgPeXY5KQfHNd9Vuw5OSswJv2v8djKVh3HGD5iH
         UZlqv7N37GTLxhfF2DkqKPgkyBdedDseqJ3V20YDpn3w7ldDdE4Jh/+yP13VVl4XJydm
         djJnnPg1F+BU4Uv78SeWUbHmuiegcatMcnj9MGNU2OKuzr11h6UfyXRCgDUjUwNljsPt
         LcPg==
X-Gm-Message-State: ACrzQf3XgnPNcDKNS1AQ7Uj5iebozrqYxxYpWqsqLPWjsYGRuQEYSvOS
        rnn1M1Y+bPjJixKjW08Do/8Faw==
X-Google-Smtp-Source: AMsMyM5fqKzWRTm7+LT3vDYZIt2jxEYb4IH+OAshM0Jr14dPUohaWszSwwX80LoYbg/I4QyFzOdk1Q==
X-Received: by 2002:a05:6638:430c:b0:35a:1c37:a343 with SMTP id bt12-20020a056638430c00b0035a1c37a343mr3167198jab.183.1663885274263;
        Thu, 22 Sep 2022 15:21:14 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id g12-20020a92d7cc000000b002f592936fbfsm2483332ilq.41.2022.09.22.15.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 15:21:13 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/8] net: ipa: encapsulate updating three more registers
Date:   Thu, 22 Sep 2022 17:21:00 -0500
Message-Id: <20220922222100.2543621-9-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922222100.2543621-1-elder@linaro.org>
References: <20220922222100.2543621-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new function that encapsulates setting the BCR, TX_CFG, and
CLKON_CFG register values during hardware configuration.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 79 +++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 8bb4b036df2b4..a552d6edb702d 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -183,6 +183,56 @@ static void ipa_teardown(struct ipa *ipa)
 	gsi_teardown(&ipa->gsi);
 }
 
+static void
+ipa_hardware_config_bcr(struct ipa *ipa, const struct ipa_data *data)
+{
+	u32 val;
+
+	/* IPA v4.5+ has no backward compatibility register */
+	if (ipa->version >= IPA_VERSION_4_5)
+		return;
+
+	val = data->backward_compat;
+	iowrite32(val, ipa->reg_virt + IPA_REG_BCR_OFFSET);
+}
+
+static void ipa_hardware_config_tx(struct ipa *ipa)
+{
+	enum ipa_version version = ipa->version;
+	u32 val;
+
+	if (version <= IPA_VERSION_4_0 || version >= IPA_VERSION_4_5)
+		return;
+
+	/* Disable PA mask to allow HOLB drop */
+	val = ioread32(ipa->reg_virt + IPA_REG_TX_CFG_OFFSET);
+
+	val &= ~PA_MASK_EN_FMASK;
+
+	iowrite32(val, ipa->reg_virt + IPA_REG_TX_CFG_OFFSET);
+}
+
+static void ipa_hardware_config_clkon(struct ipa *ipa)
+{
+	enum ipa_version version = ipa->version;
+	u32 val;
+
+	if (version < IPA_VERSION_3_1 || version >= IPA_VERSION_4_5)
+		return;
+
+	/* Implement some hardware workarounds */
+	if (version >= IPA_VERSION_4_0) {
+		/* Enable open global clocks in the CLKON configuration */
+		val = GLOBAL_FMASK | GLOBAL_2X_CLK_FMASK;
+	} else if (version == IPA_VERSION_3_1) {
+		val = MISC_FMASK;	/* Disable MISC clock gating */
+	} else {
+		return;
+	}
+
+	iowrite32(val, ipa->reg_virt + IPA_REG_CLKON_CFG_OFFSET);
+}
+
 /* Configure bus access behavior for IPA components */
 static void ipa_hardware_config_comp(struct ipa *ipa)
 {
@@ -382,32 +432,9 @@ static void ipa_hardware_dcd_deconfig(struct ipa *ipa)
  */
 static void ipa_hardware_config(struct ipa *ipa, const struct ipa_data *data)
 {
-	enum ipa_version version = ipa->version;
-	u32 val;
-
-	/* IPA v4.5+ has no backward compatibility register */
-	if (version < IPA_VERSION_4_5) {
-		val = data->backward_compat;
-		iowrite32(val, ipa->reg_virt + IPA_REG_BCR_OFFSET);
-	}
-
-	/* Implement some hardware workarounds */
-	if (version >= IPA_VERSION_4_0 && version < IPA_VERSION_4_5) {
-		/* Disable PA mask to allow HOLB drop */
-		val = ioread32(ipa->reg_virt + IPA_REG_TX_CFG_OFFSET);
-		val &= ~PA_MASK_EN_FMASK;
-		iowrite32(val, ipa->reg_virt + IPA_REG_TX_CFG_OFFSET);
-
-		/* Enable open global clocks in the CLKON configuration */
-		val = GLOBAL_FMASK | GLOBAL_2X_CLK_FMASK;
-	} else if (version == IPA_VERSION_3_1) {
-		val = MISC_FMASK;	/* Disable MISC clock gating */
-	} else {
-		val = 0;		/* No CLKON configuration needed */
-	}
-	if (val)
-		iowrite32(val, ipa->reg_virt + IPA_REG_CLKON_CFG_OFFSET);
-
+	ipa_hardware_config_bcr(ipa, data);
+	ipa_hardware_config_tx(ipa);
+	ipa_hardware_config_clkon(ipa);
 	ipa_hardware_config_comp(ipa);
 	ipa_hardware_config_qsb(ipa, data);
 	ipa_hardware_config_timing(ipa);
-- 
2.34.1

