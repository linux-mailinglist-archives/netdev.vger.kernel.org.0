Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBD32B9DB9
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgKSWkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgKSWks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:40:48 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF6FC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:40:47 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id m9so7882167iox.10
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wz7gXC8ze/fDTzyrxDiiPOcQHm+Sr4yptt5JBx9VBH0=;
        b=Y/fqlOr0kTK4g+x9HK55Xee5JYJKvPMPwwKHsYB+9lFJlEX7Zg9vD1vyDfLz5tNkWP
         H5wEEUt701tK4zz3+QHBbdmFYEEQXesa8bWieBCxCLu0OqMM33eBmDHz7Wo2Nl64tYVh
         0TRq/4j49ZUlBbedAYcWWYooOijiEtdu5m1wj7xv++C8/fKd0T6QA1jRFnGTCYm6KvB1
         o/MeyYyt77frxvIoD0XDzNgc03W+ye9Au3MRRmTd2rEtrGPSAMZT+W1Ley5NqyCKs0uZ
         FpYMUc6191gljBQZ+a5wK17TRrrjOp4n77JMQhk4P/51WHEeDv9u22MxTOgCt2rMZMUl
         2dqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wz7gXC8ze/fDTzyrxDiiPOcQHm+Sr4yptt5JBx9VBH0=;
        b=N4LTZY8O8QNiNaN6zrraVJ9SGDrE4APjpe3ts5+ko37WNnqP++m/fzSogkqCTHmLJh
         kGqcenPUACpM4S67B3JMD3+NBhkNNCP+U6OzMWdeJA7gC8uPYghjb6G/dI9DsWkkxUmk
         WuZieEokoyzXvzfJWymTVP7Y+Nuu/ZGuZmJbPPDCLqQ3xvT0v4bffg1irwUagPlFxqm0
         Ry07Xm+ONMa9oJknJt97VqzAhF4JeEThydsVcctHqNgzX7VKX9QM9EsLclclfjX3uFu0
         RmSo/lryQgQdZpITmPnJ07d7ClF7ILHOiqA9dqmc57JIWTwInjDKMeHjm19y7ygFsZAp
         z4SQ==
X-Gm-Message-State: AOAM533qaAk0ZAJGcxQzTJIKsh7XYm6Lj7sXwlgejiqrOTHt/ygtnLPp
        0vDBQsieGp3YHHz+63f/kP6kIQ==
X-Google-Smtp-Source: ABdhPJymIWKuw0w/AMzcZYge4ePtKwYp/8M71guyt/RTUVUtkJ1C7excrhNy5gH4TWvBk86pGX/DBQ==
X-Received: by 2002:a6b:6217:: with SMTP id f23mr15683303iog.201.1605825647335;
        Thu, 19 Nov 2020 14:40:47 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b4sm587797ile.13.2020.11.19.14.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 14:40:46 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] net: ipa: define clock and interconnect data
Date:   Thu, 19 Nov 2020 16:40:39 -0600
Message-Id: <20201119224041.16066-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201119224041.16066-1-elder@linaro.org>
References: <20201119224041.16066-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define a new type of configuration data, used to initialize the
IPA core clock and interconnects.  This is the first of three
patches, and defines the data types and interface but doesn't
yet use them.

Switch the return value if there is no matching configuration data
to ENODEV instead of ENOTSUPP (to avoid using the nonstandard errno).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c |  7 ++++++-
 drivers/net/ipa/ipa_clock.h |  5 ++++-
 drivers/net/ipa/ipa_data.h  | 31 ++++++++++++++++++++++++++++++-
 drivers/net/ipa/ipa_main.c  | 21 ++++++++++-----------
 4 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index a2c0fde058199..ef343669280ef 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -13,6 +13,7 @@
 #include "ipa.h"
 #include "ipa_clock.h"
 #include "ipa_modem.h"
+#include "ipa_data.h"
 
 /**
  * DOC: IPA Clocking
@@ -49,6 +50,7 @@
  * @memory_path:	Memory interconnect
  * @imem_path:		Internal memory interconnect
  * @config_path:	Configuration space interconnect
+ * @interconnect_data:	Interconnect configuration data
  */
 struct ipa_clock {
 	refcount_t count;
@@ -57,6 +59,7 @@ struct ipa_clock {
 	struct icc_path *memory_path;
 	struct icc_path *imem_path;
 	struct icc_path *config_path;
+	const struct ipa_interconnect_data *interconnect_data;
 };
 
 static struct icc_path *
@@ -257,7 +260,8 @@ u32 ipa_clock_rate(struct ipa *ipa)
 }
 
 /* Initialize IPA clocking */
-struct ipa_clock *ipa_clock_init(struct device *dev)
+struct ipa_clock *
+ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 {
 	struct ipa_clock *clock;
 	struct clk *clk;
@@ -282,6 +286,7 @@ struct ipa_clock *ipa_clock_init(struct device *dev)
 		goto err_clk_put;
 	}
 	clock->core = clk;
+	clock->interconnect_data = data->interconnect;
 
 	ret = ipa_interconnect_init(clock, dev);
 	if (ret)
diff --git a/drivers/net/ipa/ipa_clock.h b/drivers/net/ipa/ipa_clock.h
index 1d70f1de3875b..1fe634760e59d 100644
--- a/drivers/net/ipa/ipa_clock.h
+++ b/drivers/net/ipa/ipa_clock.h
@@ -9,6 +9,7 @@
 struct device;
 
 struct ipa;
+struct ipa_clock_data;
 
 /**
  * ipa_clock_rate() - Return the current IPA core clock rate
@@ -21,10 +22,12 @@ u32 ipa_clock_rate(struct ipa *ipa);
 /**
  * ipa_clock_init() - Initialize IPA clocking
  * @dev:	IPA device
+ * @data:	Clock configuration data
  *
  * Return:	A pointer to an ipa_clock structure, or a pointer-coded error
  */
-struct ipa_clock *ipa_clock_init(struct device *dev);
+struct ipa_clock *ipa_clock_init(struct device *dev,
+				 const struct ipa_clock_data *data);
 
 /**
  * ipa_clock_exit() - Inverse of ipa_clock_init()
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 83c4b78373efb..0ed5ffe2b8da0 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -241,7 +241,7 @@ struct ipa_resource_data {
 };
 
 /**
- * struct ipa_mem - description of IPA memory regions
+ * struct ipa_mem_data - description of IPA memory regions
  * @local_count:	number of regions defined in the local[] array
  * @local:		array of IPA-local memory region descriptors
  * @imem_addr:		physical address of IPA region within IMEM
@@ -258,6 +258,34 @@ struct ipa_mem_data {
 	u32 smem_size;
 };
 
+/** enum ipa_interconnect_id - IPA interconnect identifier */
+enum ipa_interconnect_id {
+	IPA_INTERCONNECT_MEMORY,
+	IPA_INTERCONNECT_IMEM,
+	IPA_INTERCONNECT_CONFIG,
+	IPA_INTERCONNECT_COUNT,		/* Last; not an interconnect */
+};
+
+/**
+ * struct ipa_interconnect_data - description of IPA interconnect rates
+ * @peak_rate:		Peak interconnect bandwidth (in 1000 byte/sec units)
+ * @average_rate:	Average interconnect bandwidth (in 1000 byte/sec units)
+ */
+struct ipa_interconnect_data {
+	u32 peak_rate;
+	u32 average_rate;
+};
+
+/**
+ * struct ipa_clock_data - description of IPA clock and interconnect rates
+ * @core_clock_rate:	Core clock rate (Hz)
+ * @interconnect:	Array of interconnect bandwidth parameters
+ */
+struct ipa_clock_data {
+	u32 core_clock_rate;
+	struct ipa_interconnect_data interconnect[IPA_INTERCONNECT_COUNT];
+};
+
 /**
  * struct ipa_data - combined IPA/GSI configuration data
  * @version:		IPA hardware version
@@ -273,6 +301,7 @@ struct ipa_data {
 	const struct ipa_gsi_endpoint_data *endpoint_data;
 	const struct ipa_resource_data *resource_data;
 	const struct ipa_mem_data *mem_data;
+	const struct ipa_clock_data *clock_data;
 };
 
 extern const struct ipa_data ipa_data_sdm845;
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 3fb9c5d90b70e..468ab1acc20e0 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -728,6 +728,14 @@ static int ipa_probe(struct platform_device *pdev)
 
 	ipa_validate_build();
 
+	/* Get configuration data early; needed for clock initialization */
+	data = of_device_get_match_data(dev);
+	if (!data) {
+		/* This is really IPA_VALIDATE (should never happen) */
+		dev_err(dev, "matched hardware not supported\n");
+		return -ENODEV;
+	}
+
 	/* If we need Trust Zone, make sure it's available */
 	modem_init = of_property_read_bool(dev->of_node, "modem-init");
 	if (!modem_init)
@@ -748,22 +756,13 @@ static int ipa_probe(struct platform_device *pdev)
 	/* The clock and interconnects might not be ready when we're
 	 * probed, so might return -EPROBE_DEFER.
 	 */
-	clock = ipa_clock_init(dev);
+	clock = ipa_clock_init(dev, data->clock_data);
 	if (IS_ERR(clock)) {
 		ret = PTR_ERR(clock);
 		goto err_rproc_put;
 	}
 
-	/* No more EPROBE_DEFER.  Get our configuration data */
-	data = of_device_get_match_data(dev);
-	if (!data) {
-		/* This is really IPA_VALIDATE (should never happen) */
-		dev_err(dev, "matched hardware not supported\n");
-		ret = -ENOTSUPP;
-		goto err_clock_exit;
-	}
-
-	/* Allocate and initialize the IPA structure */
+	/* No more EPROBE_DEFER.  Allocate and initialize the IPA structure */
 	ipa = kzalloc(sizeof(*ipa), GFP_KERNEL);
 	if (!ipa) {
 		ret = -ENOMEM;
-- 
2.20.1

