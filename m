Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C023A2F7AB3
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387877AbhAOMxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387995AbhAOMwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:52:15 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5DAC06179C
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:50:58 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id d9so17844401iob.6
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ijl7ke0iXPO6hOHYeKFTmnnrMsXMs0BUA8XlyHgNlok=;
        b=Mc9ADDnnnwX3YZ5XXXnOTMJhwH9KTtI4eBuZCODN3bPiyrVcthEGgvuho4ikKP275X
         ju9isuNruW9yao4rIFQzOOr2vlQpCdgfrdm1QKyPig7bJA24AcWuERKqCV5bdpt5iY0r
         TLDrGUED7WassXd2c7ynjo4Eu4xKPyMsYdjTNn1jyINja8zU2Um5xb6DoH7JfGHDu5U7
         zUnYVOjZAD5OQ/HslDe0CG/UzAkzbJcz/4pxnOUTKpWP2U7WFIvaFVBg10Rjiow5SvbC
         01lQ+E1vaYTun/jIucQPECZczjGQNyz8Oi/J2X3GUPp4A3G03KA118K+wXRaQY5mqlfQ
         vP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ijl7ke0iXPO6hOHYeKFTmnnrMsXMs0BUA8XlyHgNlok=;
        b=oep92USVSKR55SqzTUOqIwthIZ5UYDw9GHkMA85hA9pyJJC2W9YZIoy3lIGW/VtJcU
         HffjFxfbMzo1lBTkTuh6rVR4ONEdgOLd4ezV1m0UX3ShKh5fIqGJZHHrkLsbFvkgWKAc
         d4+UIfalDvu/oHPvy+6wfkXuqxsqdWDbhKIvhzhPR//DkaW692vlesuq8McKHBI5c/z5
         kTrziOo+/I4EfKow9bzX1t4CVkJulKvhwcWV3qE+UsB2EC0fUoNFKpHsi6Zn2vJcHptc
         etviVtUWQuCzRFl5J7SOPLRs1KDJuHOb95OmkZGco4FiYupVMYdRICZLl9SOjJHi4yQ1
         JNUQ==
X-Gm-Message-State: AOAM532b1ZwkBXgOkC1iiSnvnYrOSgd/2OAldQvg2rQYunnPb+V1d/Ur
        CCREd9bzg/KN9gcTeYhfeMzA2Q==
X-Google-Smtp-Source: ABdhPJzVVT2+YHMsnUDsFDAdnuDOCR+vXrxVORBiYnHSzC7zy3xT8dWrO2//ikw9XuRMkgG0ZPbmQA==
X-Received: by 2002:a5e:c00e:: with SMTP id u14mr8274095iol.194.1610715057781;
        Fri, 15 Jan 2021 04:50:57 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f13sm3952450iog.18.2021.01.15.04.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:50:57 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/7] net: ipa: store average and peak interconnect bandwidth
Date:   Fri, 15 Jan 2021 06:50:47 -0600
Message-Id: <20210115125050.20555-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210115125050.20555-1-elder@linaro.org>
References: <20210115125050.20555-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add fields in the ipa_interconnect structure to hold the average and
peak bandwidth values for the interconnect.  Pass the configuring
data for interconnects to ipa_interconnect_init() so these values
can be recorded, and use them when enabling the interconnects.

There's no longer any need to keep a copy of the interconnect data
after initialization.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 88 ++++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 2bf5af6823d8c..537c72b5267f6 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -33,9 +33,13 @@
 /**
  * struct ipa_interconnect - IPA interconnect information
  * @path:		Interconnect path
+ * @average_bandwidth:	Average interconnect bandwidth (KB/second)
+ * @peak_bandwidth:	Peak interconnect bandwidth (KB/second)
  */
 struct ipa_interconnect {
 	struct icc_path *path;
+	u32 average_bandwidth;
+	u32 peak_bandwidth;
 };
 
 /**
@@ -44,14 +48,12 @@ struct ipa_interconnect {
  * @mutex:		Protects clock enable/disable
  * @core:		IPA core clock
  * @interconnect:	Interconnect array
- * @interconnect_data:	Interconnect configuration data
  */
 struct ipa_clock {
 	refcount_t count;
 	struct mutex mutex; /* protects clock enable/disable */
 	struct clk *core;
-	struct ipa_interconnect *interconnect[IPA_INTERCONNECT_COUNT];
-	const struct ipa_interconnect_data *interconnect_data;
+	struct ipa_interconnect interconnect[IPA_INTERCONNECT_COUNT];
 };
 
 static struct icc_path *
@@ -61,38 +63,52 @@ ipa_interconnect_init_one(struct device *dev, const char *name)
 
 	path = of_icc_get(dev, name);
 	if (IS_ERR(path))
-		dev_err(dev, "error %ld getting %s interconnect\n",
-			PTR_ERR(path), name);
+		dev_err(dev, "error %d getting %s interconnect\n",
+			(int)PTR_ERR(path), name);
 
 	return path;
 }
 
 /* Initialize interconnects required for IPA operation */
-static int ipa_interconnect_init(struct ipa_clock *clock, struct device *dev)
+static int ipa_interconnect_init(struct ipa_clock *clock, struct device *dev,
+				 const struct ipa_interconnect_data *data)
 {
+	struct ipa_interconnect *interconnect;
 	struct icc_path *path;
 
 	path = ipa_interconnect_init_one(dev, "memory");
 	if (IS_ERR(path))
 		goto err_return;
-	clock->interconnect[IPA_INTERCONNECT_MEMORY]->path = path;
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
+	interconnect->path = path;
+	interconnect->average_bandwidth = data->average_bandwidth;
+	interconnect->peak_bandwidth = data->peak_bandwidth;
+	data++;
 
 	path = ipa_interconnect_init_one(dev, "imem");
 	if (IS_ERR(path))
 		goto err_memory_path_put;
-	clock->interconnect[IPA_INTERCONNECT_IMEM]->path = path;
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
+	interconnect->path = path;
+	interconnect->average_bandwidth = data->average_bandwidth;
+	interconnect->peak_bandwidth = data->peak_bandwidth;
+	data++;
 
 	path = ipa_interconnect_init_one(dev, "config");
 	if (IS_ERR(path))
 		goto err_imem_path_put;
-	clock->interconnect[IPA_INTERCONNECT_CONFIG]->path = path;
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_CONFIG];
+	interconnect->path = path;
+	interconnect->average_bandwidth = data->average_bandwidth;
+	interconnect->peak_bandwidth = data->peak_bandwidth;
+	data++;
 
 	return 0;
 
 err_imem_path_put:
-	icc_put(clock->interconnect[IPA_INTERCONNECT_IMEM]->path);
+	icc_put(clock->interconnect[IPA_INTERCONNECT_IMEM].path);
 err_memory_path_put:
-	icc_put(clock->interconnect[IPA_INTERCONNECT_MEMORY]->path);
+	icc_put(clock->interconnect[IPA_INTERCONNECT_MEMORY].path);
 err_return:
 	return PTR_ERR(path);
 }
@@ -100,44 +116,44 @@ static int ipa_interconnect_init(struct ipa_clock *clock, struct device *dev)
 /* Inverse of ipa_interconnect_init() */
 static void ipa_interconnect_exit(struct ipa_clock *clock)
 {
-	icc_put(clock->interconnect[IPA_INTERCONNECT_CONFIG]->path);
-	icc_put(clock->interconnect[IPA_INTERCONNECT_IMEM]->path);
-	icc_put(clock->interconnect[IPA_INTERCONNECT_MEMORY]->path);
+	icc_put(clock->interconnect[IPA_INTERCONNECT_CONFIG].path);
+	icc_put(clock->interconnect[IPA_INTERCONNECT_IMEM].path);
+	icc_put(clock->interconnect[IPA_INTERCONNECT_MEMORY].path);
 }
 
 /* Currently we only use one bandwidth level, so just "enable" interconnects */
 static int ipa_interconnect_enable(struct ipa *ipa)
 {
-	const struct ipa_interconnect_data *data;
+	struct ipa_interconnect *interconnect;
 	struct ipa_clock *clock = ipa->clock;
 	int ret;
 
-	data = &clock->interconnect_data[IPA_INTERCONNECT_MEMORY];
-	ret = icc_set_bw(clock->interconnect[IPA_INTERCONNECT_MEMORY]->path,
-			 data->average_bandwidth, data->peak_bandwidth);
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
+	ret = icc_set_bw(interconnect->path, interconnect->average_bandwidth,
+			 interconnect->peak_bandwidth);
 	if (ret)
 		return ret;
 
-	data = &clock->interconnect_data[IPA_INTERCONNECT_IMEM];
-	ret = icc_set_bw(clock->interconnect[IPA_INTERCONNECT_IMEM]->path,
-			 data->average_bandwidth, data->peak_bandwidth);
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
+	ret = icc_set_bw(interconnect->path, interconnect->average_bandwidth,
+			 interconnect->peak_bandwidth);
 	if (ret)
 		goto err_memory_path_disable;
 
-	data = &clock->interconnect_data[IPA_INTERCONNECT_CONFIG];
-	ret = icc_set_bw(clock->interconnect[IPA_INTERCONNECT_CONFIG]->path,
-			 data->average_bandwidth, data->peak_bandwidth);
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_CONFIG];
+	ret = icc_set_bw(interconnect->path, interconnect->average_bandwidth,
+			 interconnect->peak_bandwidth);
 	if (ret)
 		goto err_imem_path_disable;
 
 	return 0;
 
 err_imem_path_disable:
-	(void)icc_set_bw(clock->interconnect[IPA_INTERCONNECT_IMEM]->path,
-			 0, 0);
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
+	(void)icc_set_bw(interconnect->path, 0, 0);
 err_memory_path_disable:
-	(void)icc_set_bw(clock->interconnect[IPA_INTERCONNECT_MEMORY]->path,
-			 0, 0);
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
+	(void)icc_set_bw(interconnect->path, 0, 0);
 
 	return ret;
 }
@@ -145,22 +161,23 @@ static int ipa_interconnect_enable(struct ipa *ipa)
 /* To disable an interconnect, we just its bandwidth to 0 */
 static void ipa_interconnect_disable(struct ipa *ipa)
 {
+	struct ipa_interconnect *interconnect;
 	struct ipa_clock *clock = ipa->clock;
 	int result = 0;
 	int ret;
 
-	ret = icc_set_bw(clock->interconnect[IPA_INTERCONNECT_MEMORY]->path,
-			 0, 0);
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
+	ret = icc_set_bw(interconnect->path, 0, 0);
 	if (ret)
 		result = ret;
 
-	ret = icc_set_bw(clock->interconnect[IPA_INTERCONNECT_IMEM]->path,
-			 0, 0);
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
+	ret = icc_set_bw(interconnect->path, 0, 0);
 	if (ret && !result)
 		result = ret;
 
-	ret = icc_set_bw(clock->interconnect[IPA_INTERCONNECT_CONFIG]->path,
-			 0, 0);
+	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
+	ret = icc_set_bw(interconnect->path, 0, 0);
 	if (ret && !result)
 		result = ret;
 
@@ -286,9 +303,8 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 		goto err_clk_put;
 	}
 	clock->core = clk;
-	clock->interconnect_data = data->interconnect;
 
-	ret = ipa_interconnect_init(clock, dev);
+	ret = ipa_interconnect_init(clock, dev, data->interconnect);
 	if (ret)
 		goto err_kfree;
 
-- 
2.20.1

