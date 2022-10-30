Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A85E6126AC
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 02:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJ3ATK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 20:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJ3AS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 20:18:56 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709224F39A
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:49 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id y6so4401323iof.9
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+B/7+vxq/3O8eHqvvwYVc/AJMZK0GiWxC3wTnrGp9I=;
        b=DhWUxWBhTCG5yXmaIEiO0wHnWESH7Gv7FRtu6HxINJuMw049G+YgGqg8ETIky4mg3s
         P34Iq01Vs0y5lMRJCk04FOX903W9KiDQZRYtUt90DGeBJ8T0hfTQ2syfwJ6Se8Boar7h
         zmKX7Qea1iW+WmdatZTeA6p+kL9J36UPBDPBtT1qs2TmCPzA9VzPNKfzH2v5orrkrxX0
         usKvqTGI2Gz7G1IVJSrPhVnK5wqsJ5Rhvjv7mOZnT8WOdGIxqvB4wDauO4zEAMreYkwB
         /9o7XE6DKGMReppUtPvAfSuq5Fn1LsqlN6h7FYvXRkaX+Jh7TnKW2hlGyUJqp5ULBqKp
         PctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b+B/7+vxq/3O8eHqvvwYVc/AJMZK0GiWxC3wTnrGp9I=;
        b=bgiknAZGsKXdPPg++QOorflaXiDlaQVW1rkFnhSn8h2tCLebQYN2xz7Uv6xye0QkXR
         yN0I8aFgBXhjVqUAQHeIi5NBlj5J6EwVePWPou65GSJii5OkzAIrSZltC5WYHAxS7jdx
         N8NvtL6RVTBpqryy87BklK58q40n55TAH+znS2z2A/IkGgIGuxOAA73utU48EaIRuG8d
         NGrBOcaFd8j4urQHwo5I74jciKt+3YjXUa0d1L1wlIBva5C8iblRJCH1fNQQ4K77UoFR
         vvykw8zASTkwWtlGUlSeACrZ7T8VDQMuEaOg+0Leky28dOQT5i0D25hLJ9bvqtnlxGLy
         w85A==
X-Gm-Message-State: ACrzQf0Glh2laWiUqJ5gqoVMCeB1W5jF7tETYaIaHv5ZdAmqQdPoVKxP
        NeT1U7klm3gPvriGvMIz0yPqW9zDe5OaZw==
X-Google-Smtp-Source: AMsMyM4vT16xj28EmMQBmvwxLMlKoyqYJDW49Qxrtxe+2op3EhhS5twTkItI3xEeD49DfeO4qWJa5A==
X-Received: by 2002:a05:6638:1644:b0:363:eeaf:cc66 with SMTP id a4-20020a056638164400b00363eeafcc66mr3354728jat.68.1667089128743;
        Sat, 29 Oct 2022 17:18:48 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id co20-20020a0566383e1400b00375126ae55fsm1087519jab.58.2022.10.29.17.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 17:18:48 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/9] net: ipa: support more filtering endpoints
Date:   Sat, 29 Oct 2022 19:18:26 -0500
Message-Id: <20221030001828.754010-8-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221030001828.754010-1-elder@linaro.org>
References: <20221030001828.754010-1-elder@linaro.org>
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

Prior to IPA v5.0, there could be no more than 32 endpoints.

A filter table begins with a bitmap indicating which endpoints have
a filter defined.  That bitmap is currently assumed to fit in a
32-bit value.

Starting with IPA v5.0, more than 32 endpoints are supported, so
it's conceivable that a TX endpoint has an ID that exceeds 32.
Increase the size of the field representing endpoints that support
filtering to 64 bits.  Rename the bitmap field "filtered".

Unlike other similar fields, we do not use an (arbitrarily long)
Linux bitmap for this purpose.  The reason is that if a filter table
ever *did* need to support more than 64 TX endpoints, its format
would change in ways we can't anticipate.

Have ipa_endpoint_init() return a negative errno rather than a mask
that indicates which endpoints support filtering, and have that
function assign the "filtered" field directly.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h          |  4 ++--
 drivers/net/ipa/ipa_endpoint.c | 20 +++++++++++---------
 drivers/net/ipa/ipa_endpoint.h |  2 +-
 drivers/net/ipa/ipa_main.c     |  7 ++-----
 drivers/net/ipa/ipa_table.c    | 20 ++++++++++----------
 drivers/net/ipa/ipa_table.h    |  6 +++---
 6 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index c603575e2a58b..557101c2d5838 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -65,7 +65,7 @@ struct ipa_interrupt;
  * @available_count:	Number of defined bits in the available bitmap
  * @defined:		Bitmap of endpoints defined in config data
  * @available:		Bitmap of endpoints supported by hardware
- * @filter_map:		Bit mask indicating endpoints that support filtering
+ * @filtered:		Bitmap of endpoints that support filtering
  * @set_up:		Bit mask indicating endpoints set up
  * @enabled:		Bit mask indicating endpoints enabled
  * @modem_tx_count:	Number of defined modem TX endoints
@@ -123,7 +123,7 @@ struct ipa {
 	u32 available_count;
 	unsigned long *defined;		/* Defined in configuration data */
 	unsigned long *available;	/* Supported by hardware */
-	u32 filter_map;
+	u64 filtered;			/* Support filtering (AP and modem) */
 	u32 set_up;
 	u32 enabled;
 
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 8d4cb2c30ec90..923299cc46fe5 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1985,28 +1985,28 @@ void ipa_endpoint_exit(struct ipa *ipa)
 }
 
 /* Returns a bitmask of endpoints that support filtering, or 0 on error */
-u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
+int ipa_endpoint_init(struct ipa *ipa, u32 count,
 		      const struct ipa_gsi_endpoint_data *data)
 {
 	struct device *dev = &ipa->pdev->dev;
 	enum ipa_endpoint_name name;
-	u32 filter_map;
+	u32 filtered;
 
 	BUILD_BUG_ON(!IPA_REPLENISH_BATCH);
 
 	/* Number of endpoints is one more than the maximum ID */
 	ipa->endpoint_count = ipa_endpoint_max(ipa, count, data) + 1;
 	if (!ipa->endpoint_count)
-		return 0;	/* Error */
+		return -EINVAL;
 
 	/* Set up the defined endpoint bitmap */
 	ipa->defined = bitmap_zalloc(ipa->endpoint_count, GFP_KERNEL);
 	if (!ipa->defined) {
 		dev_err(dev, "unable to allocate defined endpoint bitmap\n");
-		return 0;
+		return -ENOMEM;
 	}
 
-	filter_map = 0;
+	filtered = 0;
 	for (name = 0; name < count; name++, data++) {
 		if (ipa_gsi_endpoint_data_empty(data))
 			continue;	/* Skip over empty slots */
@@ -2014,18 +2014,20 @@ u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
 		ipa_endpoint_init_one(ipa, name, data);
 
 		if (data->endpoint.filter_support)
-			filter_map |= BIT(data->endpoint_id);
+			filtered |= BIT(data->endpoint_id);
 		if (data->ee_id == GSI_EE_MODEM && data->toward_ipa)
 			ipa->modem_tx_count++;
 	}
 
-	if (!ipa_filter_map_valid(ipa, filter_map))
+	if (!ipa_filtered_valid(ipa, filtered))
 		goto err_endpoint_exit;
 
-	return filter_map;	/* Non-zero bitmask */
+	ipa->filtered = filtered;
+
+	return 0;
 
 err_endpoint_exit:
 	ipa_endpoint_exit(ipa);
 
-	return 0;	/* Error */
+	return -EINVAL;
 }
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index d8dfa24f52140..4a5c3bc549df5 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -195,7 +195,7 @@ void ipa_endpoint_deconfig(struct ipa *ipa);
 void ipa_endpoint_default_route_set(struct ipa *ipa, u32 endpoint_id);
 void ipa_endpoint_default_route_clear(struct ipa *ipa);
 
-u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
+int ipa_endpoint_init(struct ipa *ipa, u32 count,
 		      const struct ipa_gsi_endpoint_data *data);
 void ipa_endpoint_exit(struct ipa *ipa);
 
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 8f6a6890697e8..ebb6c9b311eb9 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -788,12 +788,9 @@ static int ipa_probe(struct platform_device *pdev)
 		goto err_mem_exit;
 
 	/* Result is a non-zero mask of endpoints that support filtering */
-	ipa->filter_map = ipa_endpoint_init(ipa, data->endpoint_count,
-					    data->endpoint_data);
-	if (!ipa->filter_map) {
-		ret = -EINVAL;
+	ret = ipa_endpoint_init(ipa, data->endpoint_count, data->endpoint_data);
+	if (ret)
 		goto err_gsi_exit;
-	}
 
 	ret = ipa_table_init(ipa);
 	if (ret)
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 3a14465bf8a64..e657540dc7dfb 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -161,18 +161,18 @@ ipa_table_mem(struct ipa *ipa, bool filter, bool hashed, bool ipv6)
 	return ipa_mem_find(ipa, mem_id);
 }
 
-bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_map)
+bool ipa_filtered_valid(struct ipa *ipa, u64 filtered)
 {
 	struct device *dev = &ipa->pdev->dev;
 	u32 count;
 
-	if (!filter_map) {
+	if (!filtered) {
 		dev_err(dev, "at least one filtering endpoint is required\n");
 
 		return false;
 	}
 
-	count = hweight32(filter_map);
+	count = hweight64(filtered);
 	if (count > ipa->filter_count) {
 		dev_err(dev, "too many filtering endpoints (%u, max %u)\n",
 			count, ipa->filter_count);
@@ -230,8 +230,8 @@ static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
 static int
 ipa_filter_reset_table(struct ipa *ipa, bool hashed, bool ipv6, bool modem)
 {
-	u32 ep_mask = ipa->filter_map;
-	u32 count = hweight32(ep_mask);
+	u64 ep_mask = ipa->filtered;
+	u32 count = hweight64(ep_mask);
 	struct gsi_trans *trans;
 	enum gsi_ee_id ee_id;
 
@@ -405,7 +405,7 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter, bool ipv6)
 		 * to hold the bitmap itself.  The size of the hashed filter
 		 * table is either the same as the non-hashed one, or zero.
 		 */
-		count = 1 + hweight32(ipa->filter_map);
+		count = 1 + hweight64(ipa->filtered);
 		hash_count = hash_mem && hash_mem->size ? count : 0;
 	} else {
 		/* The size of a route table region determines the number
@@ -503,7 +503,7 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
 static void ipa_filter_config(struct ipa *ipa, bool modem)
 {
 	enum gsi_ee_id ee_id = modem ? GSI_EE_MODEM : GSI_EE_AP;
-	u32 ep_mask = ipa->filter_map;
+	u64 ep_mask = ipa->filtered;
 
 	if (!ipa_table_hash_support(ipa))
 		return;
@@ -615,7 +615,7 @@ bool ipa_table_mem_valid(struct ipa *ipa, bool filter)
 		/* Filter tables must able to hold the endpoint bitmap plus
 		 * an entry for each endpoint that supports filtering
 		 */
-		if (count < 1 + hweight32(ipa->filter_map))
+		if (count < 1 + hweight64(ipa->filtered))
 			return false;
 	} else {
 		/* Routing tables must be able to hold all modem entries,
@@ -720,9 +720,9 @@ int ipa_table_init(struct ipa *ipa)
 	 * that option, so there's no shifting required.
 	 */
 	if (ipa->version < IPA_VERSION_5_0)
-		*virt++ = cpu_to_le64((u64)ipa->filter_map << 1);
+		*virt++ = cpu_to_le64(ipa->filtered << 1);
 	else
-		*virt++ = cpu_to_le64((u64)ipa->filter_map);
+		*virt++ = cpu_to_le64(ipa->filtered);
 
 	/* All the rest contain the DMA address of the zero rule */
 	le_addr = cpu_to_le64(addr);
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 8a4dcd7df4c0f..7cc951904bb48 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -11,13 +11,13 @@
 struct ipa;
 
 /**
- * ipa_filter_map_valid() - Validate a filter table endpoint bitmap
+ * ipa_filtered_valid() - Validate a filter table endpoint bitmap
  * @ipa:	IPA pointer
- * @filter_mask: Filter table endpoint bitmap to check
+ * @filtered:	Filter table endpoint bitmap to check
  *
  * Return:	true if all regions are valid, false otherwise
  */
-bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask);
+bool ipa_filtered_valid(struct ipa *ipa, u64 filtered);
 
 /**
  * ipa_table_hash_support() - Return true if hashed tables are supported
-- 
2.34.1

