Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C33681C24
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjA3VDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjA3VDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:03:00 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570AB7EF0
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:02:59 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id k12so668322ilv.10
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hMq3JNiaNSjQXwZ1boO/j34bxxGpJn4ZMoNDU6z/FXU=;
        b=VZt9ikiN+21jBHUUuDf6aSL8Q1sjS2JZsHMvuEb/YPohu8UFnG+0enzAlO5dDSIJMM
         OMy6vsJbz+Ds3lKztH+FzQopalTZj2oqhLBeKXdZPA8BJrgStrnHE845X/Qra2htvXWa
         IsP8LkAwQFn2HfyBnzW2K32UgggAC1WZNw3esxTHs23TeCLtHWO32Gm/NUiIQYaZQ+Bj
         WUhr8RtVrawRMwdhn7YM2NM1qEgcGCSQIR+eLd3Wwuj5YckOdV7Yw5aW8pmGFcaizNsA
         NGMCZdZevfj/kS7/eixfa2kLTwmhV/Bjo8+iZPTSefFNe5n9kZKtOVXGkCHE90Va1WCJ
         IEdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hMq3JNiaNSjQXwZ1boO/j34bxxGpJn4ZMoNDU6z/FXU=;
        b=CZgTfj+Srarkha4OhPlK6Xtyb2jAT2lT2fWgHOEL9jnwk9jRqdQldqUaYni99GDGUe
         cOaJ3ngrw4Ado9N3GysSu9RkR+88FHdDOMTQV7DB9EuEj4u691srFIi9OSiqmB65z/ZJ
         Fz+I73asmiwTG/2YIq6sOXPQ1AyWGeS8F4fqaPehSFaZq9fdNMEE/aLmIMfX/33/XlLG
         afHSRVmTxNCa5RJ/4XMNwBKE3wmn7jjBt9wC2+gs++wtXPOaQb8u/4KXjp001BENU7Dx
         zVxKr4mnpGyVkNl0az+TrxTPYslUiEFPtuF7T0gWrvPHAidE/FfAElr0IKFiqBxNEKP0
         SIXQ==
X-Gm-Message-State: AO0yUKVEeY3QrwmKtd//AOr7vp7k6nZgTUjoEnCH/b9h9PI0mEAzBi31
        SkPiCtEix6J5eCV4AtMKznjbUw==
X-Google-Smtp-Source: AK7set9TSD4n14c/WyeF+aojzUX61n96RMQWDPaZa6tz9I3XGVGIXKChMmSkPRMBYXSYNcruCyZ/Fg==
X-Received: by 2002:a05:6e02:2181:b0:310:f912:5a7c with SMTP id j1-20020a056e02218100b00310f9125a7cmr3450789ila.25.1675112578623;
        Mon, 30 Jan 2023 13:02:58 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id a30-20020a02735e000000b003aef8fded9asm1992046jae.127.2023.01.30.13.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:02:47 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/8] net: ipa: support more endpoints
Date:   Mon, 30 Jan 2023 15:01:51 -0600
Message-Id: <20230130210158.4126129-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130210158.4126129-1-elder@linaro.org>
References: <20230130210158.4126129-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increase the number of endpoints supported by the driver to 36,
which IPA v5.0 supports.  This makes it impossible to check at build
time whether the supported number is too big to fit within the
(5-bit) PACKET_INIT destination endpoint field.  Instead, convert
the build time check to compare against what fits in 8 bits.

Add a check in ipa_endpoint_config() to also ensure the hardware
reports an endpoint count that's in the expected range.  Just
open-code 32 as the limit (the PACKET_INIT field mask is not
available where we'd want to use it).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c      | 13 +++++++++----
 drivers/net/ipa/ipa_endpoint.c | 11 ++++++++++-
 drivers/net/ipa/ipa_endpoint.h |  4 ++--
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index bb3dfa9a2bc81..aa2b594ca5067 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2022 Linaro Ltd.
+ * Copyright (C) 2019-2023 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -157,9 +157,14 @@ static void ipa_cmd_validate_build(void)
 	BUILD_BUG_ON(field_max(IP_FLTRT_FLAGS_HASH_ADDR_FMASK) !=
 		     field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK));
 
-	/* Valid endpoint numbers must fit in the IP packet init command */
-	BUILD_BUG_ON(field_max(IPA_PACKET_INIT_DEST_ENDPOINT_FMASK) <
-		     IPA_ENDPOINT_MAX - 1);
+	/* Prior to IPA v5.0, we supported no more than 32 endpoints,
+	 * and this was reflected in some 5-bit fields that held
+	 * endpoint numbers.  Starting with IPA v5.0, the widths of
+	 * these fields were extended to 8 bits, meaning up to 256
+	 * endpoints.  If the driver claims to support more than
+	 * that it's an error.
+	 */
+	BUILD_BUG_ON(IPA_ENDPOINT_MAX - 1 > U8_MAX);
 }
 
 /* Validate a memory region holding a table */
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index ce7f2d6e447ed..8909ba8bfd0e9 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2022 Linaro Ltd.
+ * Copyright (C) 2019-2023 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -1986,6 +1986,7 @@ int ipa_endpoint_config(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	const struct ipa_reg *reg;
 	u32 endpoint_id;
+	u32 hw_limit;
 	u32 tx_count;
 	u32 rx_count;
 	u32 rx_base;
@@ -2031,6 +2032,14 @@ int ipa_endpoint_config(struct ipa *ipa)
 		return -EINVAL;
 	}
 
+	/* Until IPA v5.0, the max endpoint ID was 32 */
+	hw_limit = ipa->version < IPA_VERSION_5_0 ? 32 : U8_MAX + 1;
+	if (limit > hw_limit) {
+		dev_err(dev, "unexpected endpoint count, %u > %u\n",
+			limit, hw_limit);
+		return -EINVAL;
+	}
+
 	/* Allocate and initialize the available endpoint bitmap */
 	ipa->available = bitmap_zalloc(limit, GFP_KERNEL);
 	if (!ipa->available)
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 4a5c3bc549df5..3ad2e802040aa 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2022 Linaro Ltd.
+ * Copyright (C) 2019-2023 Linaro Ltd.
  */
 #ifndef _IPA_ENDPOINT_H_
 #define _IPA_ENDPOINT_H_
@@ -38,7 +38,7 @@ enum ipa_endpoint_name {
 	IPA_ENDPOINT_COUNT,	/* Number of names (not an index) */
 };
 
-#define IPA_ENDPOINT_MAX		32	/* Max supported by driver */
+#define IPA_ENDPOINT_MAX		36	/* Max supported by driver */
 
 /**
  * struct ipa_endpoint_tx - Endpoint configuration for TX endpoints
-- 
2.34.1

