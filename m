Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8655C68F942
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 21:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjBHU6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 15:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjBHU5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 15:57:41 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8369C48A37
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 12:57:31 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id w2so22986ilg.8
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 12:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sXQB2Vz3QPq/JgRm7qy2VxupZ420tooXfNofrKz4Ysk=;
        b=sNHBtpzF3kQoZeUx+FMU2gvFPlHMLwT6VjUjMFXu8+YM7WVFiWzSq9WhzvVDOUyEr9
         OgZEWFOGt8xU3UT4J0H/MJ6zhxXr927hhl3cOIahKUVZ9obeWxBy3vIax7CcM4ugYoQs
         nU73xlpGzdABcw0AnxiI+fmhzuUINiDJYGIviF0Dp0DAS/kay10Fm6zOrV5xgfFnxV5V
         0wC64FXwi7eXl1F5qSlOfbNDhq/KxBQoIgP0OsZs3uAkM2gCSxdovBS1gkdVEMy/rPvr
         OHIhJtbTyYB8oJN3ju7KFwOkki4t3voRrKHA/XyDkfbUAywKsfWLuo+Uxekih5XzD4iM
         oTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sXQB2Vz3QPq/JgRm7qy2VxupZ420tooXfNofrKz4Ysk=;
        b=dwjcJsniEvFYPWuRl0ZR0VDATwBsS/l76mhRNC4Y2/mZnZKDBSpO19UsHX7l4FPJpM
         HbpNVN4ahZKNlg4dMVDiX09UuJMj/6PEr72m8U0Oe5XeuZu4B9PoFYovCPRQqnK7ZmSp
         OeZh43JRRYxmZVy8yJqwYWm3IatHyzei5qRgsD7tRsRGPcF7jZ2Nva04DnmO/SzoHsEO
         Hjf4a97dEA6cgQuj7YpVxefPNvtEF/Z7RCn9pnpwUth7ciRIfoNTPCum9ZXMCuJZ9YGN
         P6rLPkDRp58dng2Ty5oxZEMrAiJ6NQSHvcrQFzxqn79Vi6DXDPCoOk/ZDbuHRUwqwIhc
         hdJg==
X-Gm-Message-State: AO0yUKWhWDWnSF4BgF1zPhDs3wapY/cl2KC8yIJZzV4Ta230SKvy20C7
        FgbedKKGpxwVycR8DwHQ0GCdMg==
X-Google-Smtp-Source: AK7set+QbicFTnuASW4xRZPJ4F3+14+xxkvrmAPYHHely7Bs2nZQ8YXpIQ2DqjPkGhWSRalHjMLpCw==
X-Received: by 2002:a92:cd8a:0:b0:310:aff3:4cf5 with SMTP id r10-20020a92cd8a000000b00310aff34cf5mr9260051ilb.7.1675889850106;
        Wed, 08 Feb 2023 12:57:30 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id r6-20020a922a06000000b0031093e9c7fasm5236704ile.85.2023.02.08.12.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 12:57:29 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/9] net: ipa: start generalizing "ipa_reg"
Date:   Wed,  8 Feb 2023 14:56:51 -0600
Message-Id: <20230208205653.177700-8-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230208205653.177700-1-elder@linaro.org>
References: <20230208205653.177700-1-elder@linaro.org>
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

IPA register definitions have evolved with each new version.  The
changes required to support more than 32 endpoints in IPA v5.0 made
it best to define a unified mechanism for defining registers and
their fields.

GSI register definitions, meanwhile, have remained fairly stable.
And even as the total number of IPA endpoints goes beyond 32, the
number of GSI channels on a given EE that underly endpoints still
remains 32 or less.

Despite that, GSI v3.0 (which is used with IPA v5.0) extends the
number of channels (and events) it supports to be about 256, and as
a result, many GSI register definitions must change significantly.
To address this, we'll use the same "ipa_reg" mechanism to define
the GSI registers.

As a first step in generalizing the "ipa_reg" to also support GSI
registers, isolate the definitions of the "ipa_reg" and "ipa_regs"
structure types (and some supporting macros) into a new header file,
and remove the "ipa_" and "IPA_" from symbol names.

Separate the IPA register ID validity checking from the generic
check that a register ID is in range.  Aside from that, this is
intended to have no functional effect on the code.

Signed-off-by: Alex Elder <elder@linaro.org>
---
Note: The reg() function generates a spurious checkpatch warning.

 drivers/net/ipa/ipa.h                |   2 +-
 drivers/net/ipa/ipa_cmd.c            |   2 +-
 drivers/net/ipa/ipa_endpoint.c       |  48 ++---
 drivers/net/ipa/ipa_interrupt.c      |  12 +-
 drivers/net/ipa/ipa_main.c           |  18 +-
 drivers/net/ipa/ipa_mem.c            |   4 +-
 drivers/net/ipa/ipa_reg.c            |  48 ++---
 drivers/net/ipa/ipa_reg.h            |  81 ++------
 drivers/net/ipa/ipa_resource.c       |   6 +-
 drivers/net/ipa/ipa_table.c          |   6 +-
 drivers/net/ipa/ipa_uc.c             |   2 +-
 drivers/net/ipa/reg.h                |  70 +++++++
 drivers/net/ipa/reg/ipa_reg-v3.1.c   | 277 +++++++++++++-------------
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c | 263 +++++++++++++------------
 drivers/net/ipa/reg/ipa_reg-v4.11.c  | 265 +++++++++++++------------
 drivers/net/ipa/reg/ipa_reg-v4.2.c   | 249 ++++++++++++------------
 drivers/net/ipa/reg/ipa_reg-v4.5.c   | 281 +++++++++++++--------------
 drivers/net/ipa/reg/ipa_reg-v4.7.c   | 265 +++++++++++++------------
 drivers/net/ipa/reg/ipa_reg-v4.9.c   | 265 +++++++++++++------------
 19 files changed, 1080 insertions(+), 1084 deletions(-)
 create mode 100644 drivers/net/ipa/reg.h

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index fd54c328e8271..f3355e040a9e1 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -97,7 +97,7 @@ struct ipa {
 	bool uc_loaded;
 
 	void __iomem *reg_virt;
-	const struct ipa_regs *regs;
+	const struct regs *regs;
 
 	dma_addr_t mem_addr;
 	void *mem_virt;
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 16169641ddebe..d03956854a9ac 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -287,7 +287,7 @@ static bool ipa_cmd_register_write_offset_valid(struct ipa *ipa,
 /* Check whether offsets passed to register_write are valid */
 static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 {
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	const char *name;
 	u32 offset;
 
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 798dfa4484d5a..11e97dd80825c 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -241,7 +241,7 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 
 	if (!data->toward_ipa) {
 		const struct ipa_endpoint_rx *rx_config;
-		const struct ipa_reg *reg;
+		const struct reg *reg;
 		u32 buffer_size;
 		u32 aggr_size;
 		u32 limit;
@@ -447,7 +447,7 @@ static bool
 ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 {
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 field_id;
 	u32 offset;
 	bool state;
@@ -493,7 +493,7 @@ static bool ipa_endpoint_aggr_active(struct ipa_endpoint *endpoint)
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
 	u32 unit = endpoint_id / 32;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val;
 
 	WARN_ON(!test_bit(endpoint_id, ipa->available));
@@ -510,7 +510,7 @@ static void ipa_endpoint_force_close(struct ipa_endpoint *endpoint)
 	u32 mask = BIT(endpoint_id % 32);
 	struct ipa *ipa = endpoint->ipa;
 	u32 unit = endpoint_id / 32;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 
 	WARN_ON(!test_bit(endpoint_id, ipa->available));
 
@@ -613,7 +613,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 
 	for_each_set_bit(endpoint_id, ipa->defined, ipa->endpoint_count) {
 		struct ipa_endpoint *endpoint;
-		const struct ipa_reg *reg;
+		const struct reg *reg;
 		u32 offset;
 
 		/* We only reset modem TX endpoints */
@@ -645,7 +645,7 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
 	enum ipa_cs_offload_en enabled;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val = 0;
 
 	reg = ipa_reg(ipa, ENDP_INIT_CFG);
@@ -681,7 +681,7 @@ static void ipa_endpoint_init_nat(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val;
 
 	if (!endpoint->toward_ipa)
@@ -716,7 +716,7 @@ ipa_qmap_header_size(enum ipa_version version, struct ipa_endpoint *endpoint)
 
 /* Encoded value for ENDP_INIT_HDR register HDR_LEN* field(s) */
 static u32 ipa_header_size_encode(enum ipa_version version,
-				  const struct ipa_reg *reg, u32 header_size)
+				  const struct reg *reg, u32 header_size)
 {
 	u32 field_max = ipa_reg_field_max(reg, HDR_LEN);
 	u32 val;
@@ -738,7 +738,7 @@ static u32 ipa_header_size_encode(enum ipa_version version,
 
 /* Encoded value for ENDP_INIT_HDR register OFST_METADATA* field(s) */
 static u32 ipa_metadata_offset_encode(enum ipa_version version,
-				      const struct ipa_reg *reg, u32 offset)
+				      const struct reg *reg, u32 offset)
 {
 	u32 field_max = ipa_reg_field_max(reg, HDR_OFST_METADATA);
 	u32 val;
@@ -783,7 +783,7 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val = 0;
 
 	reg = ipa_reg(ipa, ENDP_INIT_HDR);
@@ -828,7 +828,7 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	u32 pad_align = endpoint->config.rx.pad_align;
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val = 0;
 
 	reg = ipa_reg(ipa, ENDP_INIT_HDR_EXT);
@@ -879,7 +879,7 @@ static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val = 0;
 	u32 offset;
 
@@ -899,7 +899,7 @@ static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 {
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 offset;
 	u32 val;
 
@@ -963,7 +963,7 @@ ipa_qtime_val(struct ipa *ipa, u32 microseconds, u32 max, u32 *select)
 }
 
 /* Encode the aggregation timer limit (microseconds) based on IPA version */
-static u32 aggr_time_limit_encode(struct ipa *ipa, const struct ipa_reg *reg,
+static u32 aggr_time_limit_encode(struct ipa *ipa, const struct reg *reg,
 				  u32 microseconds)
 {
 	u32 ticks;
@@ -994,7 +994,7 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val = 0;
 
 	reg = ipa_reg(ipa, ENDP_INIT_AGGR);
@@ -1043,7 +1043,7 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
  * Return the encoded value representing the timeout period provided
  * that should be written to the ENDP_INIT_HOL_BLOCK_TIMER register.
  */
-static u32 hol_block_timer_encode(struct ipa *ipa, const struct ipa_reg *reg,
+static u32 hol_block_timer_encode(struct ipa *ipa, const struct reg *reg,
 				  u32 microseconds)
 {
 	u32 width;
@@ -1109,7 +1109,7 @@ static void ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val;
 
 	/* This should only be changed when HOL_BLOCK_EN is disabled */
@@ -1124,7 +1124,7 @@ ipa_endpoint_init_hol_block_en(struct ipa_endpoint *endpoint, bool enable)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 offset;
 	u32 val;
 
@@ -1171,7 +1171,7 @@ static void ipa_endpoint_init_deaggr(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val = 0;
 
 	if (!endpoint->toward_ipa)
@@ -1191,7 +1191,7 @@ static void ipa_endpoint_init_rsrc_grp(struct ipa_endpoint *endpoint)
 	u32 resource_group = endpoint->config.resource_group;
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val;
 
 	reg = ipa_reg(ipa, ENDP_INIT_RSRC_GRP);
@@ -1204,7 +1204,7 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val;
 
 	if (!endpoint->toward_ipa)
@@ -1270,7 +1270,7 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val = 0;
 
 	reg = ipa_reg(ipa, ENDP_STATUS);
@@ -1636,7 +1636,7 @@ void ipa_endpoint_trans_release(struct ipa_endpoint *endpoint,
 
 void ipa_endpoint_default_route_set(struct ipa *ipa, u32 endpoint_id)
 {
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val;
 
 	reg = ipa_reg(ipa, ROUTE);
@@ -1985,7 +1985,7 @@ void ipa_endpoint_deconfig(struct ipa *ipa)
 int ipa_endpoint_config(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 endpoint_id;
 	u32 hw_limit;
 	u32 tx_count;
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 9a1153e80a3a0..ac5944ae0d204 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -47,7 +47,7 @@ struct ipa_interrupt {
 static void ipa_interrupt_process(struct ipa_interrupt *interrupt, u32 irq_id)
 {
 	struct ipa *ipa = interrupt->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 mask = BIT(irq_id);
 	u32 offset;
 
@@ -85,7 +85,7 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	struct ipa_interrupt *interrupt = dev_id;
 	struct ipa *ipa = interrupt->ipa;
 	u32 enabled = interrupt->enabled;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	struct device *dev;
 	u32 pending;
 	u32 offset;
@@ -132,7 +132,7 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 
 static void ipa_interrupt_enabled_update(struct ipa *ipa)
 {
-	const struct ipa_reg *reg = ipa_reg(ipa, IPA_IRQ_EN);
+	const struct reg *reg = ipa_reg(ipa, IPA_IRQ_EN);
 
 	iowrite32(ipa->interrupt->enabled, ipa->reg_virt + ipa_reg_offset(reg));
 }
@@ -170,7 +170,7 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 	struct ipa *ipa = interrupt->ipa;
 	u32 mask = BIT(endpoint_id % 32);
 	u32 unit = endpoint_id / 32;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 offset;
 	u32 val;
 
@@ -215,7 +215,7 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt)
 
 	unit_count = roundup(ipa->endpoint_count, 32);
 	for (unit = 0; unit < unit_count; unit++) {
-		const struct ipa_reg *reg;
+		const struct reg *reg;
 		u32 val;
 
 		reg = ipa_reg(ipa, IRQ_SUSPEND_INFO);
@@ -241,7 +241,7 @@ struct ipa_interrupt *ipa_interrupt_config(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
 	struct ipa_interrupt *interrupt;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	unsigned int irq;
 	int ret;
 
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 60d7c558163f1..71cf51c9cc912 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -203,7 +203,7 @@ static void ipa_teardown(struct ipa *ipa)
 static void
 ipa_hardware_config_bcr(struct ipa *ipa, const struct ipa_data *data)
 {
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val;
 
 	/* IPA v4.5+ has no backward compatibility register */
@@ -218,7 +218,7 @@ ipa_hardware_config_bcr(struct ipa *ipa, const struct ipa_data *data)
 static void ipa_hardware_config_tx(struct ipa *ipa)
 {
 	enum ipa_version version = ipa->version;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 offset;
 	u32 val;
 
@@ -239,7 +239,7 @@ static void ipa_hardware_config_tx(struct ipa *ipa)
 static void ipa_hardware_config_clkon(struct ipa *ipa)
 {
 	enum ipa_version version = ipa->version;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val;
 
 	if (version >= IPA_VERSION_4_5)
@@ -265,7 +265,7 @@ static void ipa_hardware_config_clkon(struct ipa *ipa)
 /* Configure bus access behavior for IPA components */
 static void ipa_hardware_config_comp(struct ipa *ipa)
 {
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 offset;
 	u32 val;
 
@@ -299,7 +299,7 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 {
 	const struct ipa_qsb_data *data0;
 	const struct ipa_qsb_data *data1;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val;
 
 	/* QMB 0 represents DDR; QMB 1 (if present) represents PCIe */
@@ -368,7 +368,7 @@ static __always_inline u32 ipa_aggr_granularity_val(u32 usec)
  */
 static void ipa_qtime_config(struct ipa *ipa)
 {
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 offset;
 	u32 val;
 
@@ -416,7 +416,7 @@ static void ipa_qtime_config(struct ipa *ipa)
 static void ipa_hardware_config_counter(struct ipa *ipa)
 {
 	u32 granularity = ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY);
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val;
 
 	reg = ipa_reg(ipa, COUNTER_CFG);
@@ -435,7 +435,7 @@ static void ipa_hardware_config_timing(struct ipa *ipa)
 
 static void ipa_hardware_config_hashing(struct ipa *ipa)
 {
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 
 	/* Other than IPA v4.2, all versions enable "hashing".  Starting
 	 * with IPA v5.0, the filter and router tables are implemented
@@ -458,7 +458,7 @@ static void ipa_idle_indication_cfg(struct ipa *ipa,
 				    u32 enter_idle_debounce_thresh,
 				    bool const_non_idle_enable)
 {
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val;
 
 	if (ipa->version < IPA_VERSION_3_5_1)
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index a07776e20cb0d..a6efeed253764 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -75,7 +75,7 @@ ipa_mem_zero_region_add(struct gsi_trans *trans, enum ipa_mem_id mem_id)
 int ipa_mem_setup(struct ipa *ipa)
 {
 	dma_addr_t addr = ipa->zero_addr;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	const struct ipa_mem *mem;
 	struct gsi_trans *trans;
 	u32 offset;
@@ -318,8 +318,8 @@ static bool ipa_mem_size_valid(struct ipa *ipa)
 int ipa_mem_config(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
-	const struct ipa_reg *reg;
 	const struct ipa_mem *mem;
+	const struct reg *reg;
 	dma_addr_t addr;
 	u32 mem_size;
 	void *virt;
diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
index 65d747200be3c..735fa65916097 100644
--- a/drivers/net/ipa/ipa_reg.c
+++ b/drivers/net/ipa/ipa_reg.c
@@ -13,49 +13,37 @@
 static bool ipa_reg_id_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 {
 	enum ipa_version version = ipa->version;
-	bool valid;
-
-	/* Check for bogus (out of range) register IDs */
-	if ((u32)reg_id >= ipa->regs->reg_count)
-		return false;
 
 	switch (reg_id) {
 	case IPA_BCR:
 	case COUNTER_CFG:
-		valid = version < IPA_VERSION_4_5;
-		break;
+		return version < IPA_VERSION_4_5;
 
 	case IPA_TX_CFG:
 	case FLAVOR_0:
 	case IDLE_INDICATION_CFG:
-		valid = version >= IPA_VERSION_3_5;
-		break;
+		return version >= IPA_VERSION_3_5;
 
 	case QTIME_TIMESTAMP_CFG:
 	case TIMERS_XO_CLK_DIV_CFG:
 	case TIMERS_PULSE_GRAN_CFG:
-		valid = version >= IPA_VERSION_4_5;
-		break;
+		return version >= IPA_VERSION_4_5;
 
 	case SRC_RSRC_GRP_45_RSRC_TYPE:
 	case DST_RSRC_GRP_45_RSRC_TYPE:
-		valid = version <= IPA_VERSION_3_1 ||
-			version == IPA_VERSION_4_5;
-		break;
+		return version <= IPA_VERSION_3_1 ||
+		       version == IPA_VERSION_4_5;
 
 	case SRC_RSRC_GRP_67_RSRC_TYPE:
 	case DST_RSRC_GRP_67_RSRC_TYPE:
-		valid = version <= IPA_VERSION_3_1;
-		break;
+		return version <= IPA_VERSION_3_1;
 
 	case ENDP_FILTER_ROUTER_HSH_CFG:
-		valid = version != IPA_VERSION_4_2;
-		break;
+		return version != IPA_VERSION_4_2;
 
 	case IRQ_SUSPEND_EN:
 	case IRQ_SUSPEND_CLR:
-		valid = version >= IPA_VERSION_3_1;
-		break;
+		return version >= IPA_VERSION_3_1;
 
 	case COMP_CFG:
 	case CLKON_CFG:
@@ -95,28 +83,22 @@ static bool ipa_reg_id_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 	case IPA_IRQ_CLR:
 	case IPA_IRQ_UC:
 	case IRQ_SUSPEND_INFO:
-		valid = true;	/* These should be defined for all versions */
-		break;
+		return true;	/* These should be defined for all versions */
 
 	default:
-		valid = false;
-		break;
+		return false;
 	}
-
-	/* To be valid, it must be defined */
-
-	return valid && ipa->regs->reg[reg_id];
 }
 
-const struct ipa_reg *ipa_reg(struct ipa *ipa, enum ipa_reg_id reg_id)
+const struct reg *ipa_reg(struct ipa *ipa, enum ipa_reg_id reg_id)
 {
-	if (WARN_ON(!ipa_reg_id_valid(ipa, reg_id)))
+	if (WARN(!ipa_reg_id_valid(ipa, reg_id), "invalid reg %u\n", reg_id))
 		return NULL;
 
-	return ipa->regs->reg[reg_id];
+	return reg(ipa->regs, reg_id);
 }
 
-static const struct ipa_regs *ipa_regs(enum ipa_version version)
+static const struct regs *ipa_regs(enum ipa_version version)
 {
 	switch (version) {
 	case IPA_VERSION_3_1:
@@ -141,7 +123,7 @@ static const struct ipa_regs *ipa_regs(enum ipa_version version)
 int ipa_reg_init(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
-	const struct ipa_regs *regs;
+	const struct regs *regs;
 	struct resource *res;
 
 	regs = ipa_regs(ipa->version);
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 82d43eca170ec..626a74930ff9b 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -10,6 +10,7 @@
 #include <linux/bug.h>
 
 #include "ipa_version.h"
+#include "reg.h"
 
 struct ipa;
 
@@ -110,56 +111,6 @@ enum ipa_reg_id {
 	IPA_REG_ID_COUNT,				/* Last; not an ID */
 };
 
-/**
- * struct ipa_reg - An IPA register descriptor
- * @offset:	Register offset relative to base of the "ipa-reg" memory
- * @stride:	Distance between two instances, if parameterized
- * @fcount:	Number of entries in the @fmask array
- * @fmask:	Array of mask values defining position and width of fields
- * @name:	Upper-case name of the IPA register
- */
-struct ipa_reg {
-	u32 offset;
-	u32 stride;
-	u32 fcount;
-	const u32 *fmask;			/* BIT(nr) or GENMASK(h, l) */
-	const char *name;
-};
-
-/* Helper macro for defining "simple" (non-parameterized) registers */
-#define IPA_REG(__NAME, __reg_id, __offset)				\
-	IPA_REG_STRIDE(__NAME, __reg_id, __offset, 0)
-
-/* Helper macro for defining parameterized registers, specifying stride */
-#define IPA_REG_STRIDE(__NAME, __reg_id, __offset, __stride)		\
-	static const struct ipa_reg ipa_reg_ ## __reg_id = {		\
-		.name	= #__NAME,					\
-		.offset	= __offset,					\
-		.stride	= __stride,					\
-	}
-
-#define IPA_REG_FIELDS(__NAME, __name, __offset)			\
-	IPA_REG_STRIDE_FIELDS(__NAME, __name, __offset, 0)
-
-#define IPA_REG_STRIDE_FIELDS(__NAME, __name, __offset, __stride)	\
-	static const struct ipa_reg ipa_reg_ ## __name = {		\
-		.name   = #__NAME,					\
-		.offset = __offset,					\
-		.stride = __stride,					\
-		.fcount = ARRAY_SIZE(ipa_reg_ ## __name ## _fmask),	\
-		.fmask  = ipa_reg_ ## __name ## _fmask,			\
-	}
-
-/**
- * struct ipa_regs - Description of registers supported by hardware
- * @reg_count:	Number of registers in the @reg[] array
- * @reg:		Array of register descriptors
- */
-struct ipa_regs {
-	u32 reg_count;
-	const struct ipa_reg **reg;
-};
-
 /* COMP_CFG register */
 enum ipa_reg_comp_cfg_field_id {
 	COMP_CFG_ENABLE,				/* Not IPA v4.0+ */
@@ -687,16 +638,16 @@ enum ipa_reg_ipa_irq_uc_field_id {
 	UC_INTR,
 };
 
-extern const struct ipa_regs ipa_regs_v3_1;
-extern const struct ipa_regs ipa_regs_v3_5_1;
-extern const struct ipa_regs ipa_regs_v4_2;
-extern const struct ipa_regs ipa_regs_v4_5;
-extern const struct ipa_regs ipa_regs_v4_7;
-extern const struct ipa_regs ipa_regs_v4_9;
-extern const struct ipa_regs ipa_regs_v4_11;
+extern const struct regs ipa_regs_v3_1;
+extern const struct regs ipa_regs_v3_5_1;
+extern const struct regs ipa_regs_v4_2;
+extern const struct regs ipa_regs_v4_5;
+extern const struct regs ipa_regs_v4_7;
+extern const struct regs ipa_regs_v4_9;
+extern const struct regs ipa_regs_v4_11;
 
 /* Return the field mask for a field in a register */
-static inline u32 ipa_reg_fmask(const struct ipa_reg *reg, u32 field_id)
+static inline u32 ipa_reg_fmask(const struct reg *reg, u32 field_id)
 {
 	if (!reg || WARN_ON(field_id >= reg->fcount))
 		return 0;
@@ -705,7 +656,7 @@ static inline u32 ipa_reg_fmask(const struct ipa_reg *reg, u32 field_id)
 }
 
 /* Return the mask for a single-bit field in a register */
-static inline u32 ipa_reg_bit(const struct ipa_reg *reg, u32 field_id)
+static inline u32 ipa_reg_bit(const struct reg *reg, u32 field_id)
 {
 	u32 fmask = ipa_reg_fmask(reg, field_id);
 
@@ -716,7 +667,7 @@ static inline u32 ipa_reg_bit(const struct ipa_reg *reg, u32 field_id)
 
 /* Encode a value into the given field of a register */
 static inline u32
-ipa_reg_encode(const struct ipa_reg *reg, u32 field_id, u32 val)
+ipa_reg_encode(const struct reg *reg, u32 field_id, u32 val)
 {
 	u32 fmask = ipa_reg_fmask(reg, field_id);
 
@@ -732,7 +683,7 @@ ipa_reg_encode(const struct ipa_reg *reg, u32 field_id, u32 val)
 
 /* Given a register value, decode (extract) the value in the given field */
 static inline u32
-ipa_reg_decode(const struct ipa_reg *reg, u32 field_id, u32 val)
+ipa_reg_decode(const struct reg *reg, u32 field_id, u32 val)
 {
 	u32 fmask = ipa_reg_fmask(reg, field_id);
 
@@ -740,23 +691,23 @@ ipa_reg_decode(const struct ipa_reg *reg, u32 field_id, u32 val)
 }
 
 /* Return the maximum value representable by the given field; always 2^n - 1 */
-static inline u32 ipa_reg_field_max(const struct ipa_reg *reg, u32 field_id)
+static inline u32 ipa_reg_field_max(const struct reg *reg, u32 field_id)
 {
 	u32 fmask = ipa_reg_fmask(reg, field_id);
 
 	return fmask ? fmask >> __ffs(fmask) : 0;
 }
 
-const struct ipa_reg *ipa_reg(struct ipa *ipa, enum ipa_reg_id reg_id);
+const struct reg *ipa_reg(struct ipa *ipa, enum ipa_reg_id reg_id);
 
 /* Returns 0 for NULL reg; warning will have already been issued */
-static inline u32 ipa_reg_offset(const struct ipa_reg *reg)
+static inline u32 ipa_reg_offset(const struct reg *reg)
 {
 	return reg ? reg->offset : 0;
 }
 
 /* Returns 0 for NULL reg; warning will have already been issued */
-static inline u32 ipa_reg_n_offset(const struct ipa_reg *reg, u32 n)
+static inline u32 ipa_reg_n_offset(const struct reg *reg, u32 n)
 {
 	return reg ? reg->offset + n * reg->stride : 0;
 }
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index a257f0e5e3618..3778e7664f07c 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -70,7 +70,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 
 static void
 ipa_resource_config_common(struct ipa *ipa, u32 resource_type,
-			   const struct ipa_reg *reg,
+			   const struct reg *reg,
 			   const struct ipa_resource_limits *xlimits,
 			   const struct ipa_resource_limits *ylimits)
 {
@@ -92,7 +92,7 @@ static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
 	u32 group_count = data->rsrc_group_src_count;
 	const struct ipa_resource_limits *ylimits;
 	const struct ipa_resource *resource;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 
 	resource = &data->resource_src[resource_type];
 
@@ -129,7 +129,7 @@ static void ipa_resource_config_dst(struct ipa *ipa, u32 resource_type,
 	u32 group_count = data->rsrc_group_dst_count;
 	const struct ipa_resource_limits *ylimits;
 	const struct ipa_resource *resource;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 
 	resource = &data->resource_dst[resource_type];
 
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index b9d505191f884..859286a66b0d1 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -345,8 +345,8 @@ void ipa_table_reset(struct ipa *ipa, bool modem)
 
 int ipa_table_hash_flush(struct ipa *ipa)
 {
-	const struct ipa_reg *reg;
 	struct gsi_trans *trans;
+	const struct reg *reg;
 	u32 offset;
 	u32 val;
 
@@ -495,7 +495,7 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 offset;
 	u32 val;
 
@@ -554,7 +554,7 @@ static bool ipa_route_id_modem(struct ipa *ipa, u32 route_id)
  */
 static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
 {
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 offset;
 	u32 val;
 
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index cb8a76a75f21d..2d25fe0804b25 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -231,7 +231,7 @@ void ipa_uc_power(struct ipa *ipa)
 static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 {
 	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
-	const struct ipa_reg *reg;
+	const struct reg *reg;
 	u32 val;
 
 	/* Fill in the command data */
diff --git a/drivers/net/ipa/reg.h b/drivers/net/ipa/reg.h
new file mode 100644
index 0000000000000..f0be664676d36
--- /dev/null
+++ b/drivers/net/ipa/reg.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* *Copyright (C) 2022-2023 Linaro Ltd. */
+
+#ifndef _REG_H_
+#define _REG_H_
+
+#include <linux/types.h>
+#include <linux/bits.h>
+
+/**
+ * struct reg - A register descriptor
+ * @offset:	Register offset relative to base of register memory
+ * @stride:	Distance between two instances, if parameterized
+ * @fcount:	Number of entries in the @fmask array
+ * @fmask:	Array of mask values defining position and width of fields
+ * @name:	Upper-case name of the register
+ */
+struct reg {
+	u32 offset;
+	u32 stride;
+	u32 fcount;
+	const u32 *fmask;			/* BIT(nr) or GENMASK(h, l) */
+	const char *name;
+};
+
+/* Helper macro for defining "simple" (non-parameterized) registers */
+#define REG(__NAME, __reg_id, __offset)					\
+	REG_STRIDE(__NAME, __reg_id, __offset, 0)
+
+/* Helper macro for defining parameterized registers, specifying stride */
+#define REG_STRIDE(__NAME, __reg_id, __offset, __stride)		\
+	static const struct reg reg_ ## __reg_id = {			\
+		.name	= #__NAME,					\
+		.offset	= __offset,					\
+		.stride	= __stride,					\
+	}
+
+#define REG_FIELDS(__NAME, __name, __offset)				\
+	REG_STRIDE_FIELDS(__NAME, __name, __offset, 0)
+
+#define REG_STRIDE_FIELDS(__NAME, __name, __offset, __stride)		\
+	static const struct reg reg_ ## __name = {			\
+		.name   = #__NAME,					\
+		.offset = __offset,					\
+		.stride = __stride,					\
+		.fcount = ARRAY_SIZE(reg_ ## __name ## _fmask),		\
+		.fmask  = reg_ ## __name ## _fmask,			\
+	}
+
+/**
+ * struct regs - Description of registers supported by hardware
+ * @reg_count:	Number of registers in the @reg[] array
+ * @reg:	Array of register descriptors
+ */
+struct regs {
+	u32 reg_count;
+	const struct reg **reg;
+};
+
+static inline const struct reg *reg(const struct regs *regs, u32 reg_id)
+{
+	if (WARN(reg_id >= regs->reg_count,
+		 "reg out of range (%u > %u)\n", reg_id, regs->reg_count - 1))
+		return NULL;
+
+	return regs->reg[reg_id];
+}
+
+#endif /* _REG_H_ */
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
index 677ece3bce9e5..648dbfe1fce3a 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
@@ -7,7 +7,7 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-static const u32 ipa_reg_comp_cfg_fmask[] = {
+static const u32 reg_comp_cfg_fmask[] = {
 	[COMP_CFG_ENABLE]				= BIT(0),
 	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
 	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
@@ -16,9 +16,9 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 						/* Bits 5-31 reserved */
 };
 
-IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
+REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-static const u32 ipa_reg_clkon_cfg_fmask[] = {
+static const u32 reg_clkon_cfg_fmask[] = {
 	[CLKON_RX]					= BIT(0),
 	[CLKON_PROC]					= BIT(1),
 	[TX_WRAPPER]					= BIT(2),
@@ -39,9 +39,9 @@ static const u32 ipa_reg_clkon_cfg_fmask[] = {
 						/* Bits 17-31 reserved */
 };
 
-IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
 
-static const u32 ipa_reg_route_fmask[] = {
+static const u32 reg_route_fmask[] = {
 	[ROUTE_DIS]					= BIT(0),
 	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
 	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
@@ -52,31 +52,31 @@ static const u32 ipa_reg_route_fmask[] = {
 						/* Bits 25-31 reserved */
 };
 
-IPA_REG_FIELDS(ROUTE, route, 0x00000048);
+REG_FIELDS(ROUTE, route, 0x00000048);
 
-static const u32 ipa_reg_shared_mem_size_fmask[] = {
+static const u32 reg_shared_mem_size_fmask[] = {
 	[MEM_SIZE]					= GENMASK(15, 0),
 	[MEM_BADDR]					= GENMASK(31, 16),
 };
 
-IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+static const u32 reg_qsb_max_writes_fmask[] = {
 	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
 						/* Bits 8-31 reserved */
 };
 
-IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+static const u32 reg_qsb_max_reads_fmask[] = {
 	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
 };
 
-IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
 
-static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+static const u32 reg_filt_rout_hash_en_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -87,9 +87,9 @@ static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x000008c);
+REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x000008c);
 
-static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+static const u32 reg_filt_rout_hash_flush_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -100,121 +100,121 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x0000090);
+REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x0000090);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c, 0x0004);
+REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c, 0x0004);
 
-IPA_REG(IPA_BCR, ipa_bcr, 0x000001d0);
+REG(IPA_BCR, ipa_bcr, 0x000001d0);
 
-static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+static const u32 reg_local_pkt_proc_cntxt_fmask[] = {
 	[IPA_BASE_ADDR]					= GENMASK(16, 0),
 						/* Bits 17-31 reserved */
 };
 
 /* Offset must be a multiple of 8 */
-IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
+REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
-static const u32 ipa_reg_counter_cfg_fmask[] = {
+static const u32 reg_counter_cfg_fmask[] = {
 	[EOT_COAL_GRANULARITY]				= GENMASK(3, 0),
 	[AGGR_GRANULARITY]				= GENMASK(8, 4),
 						/* Bits 5-31 reserved */
 };
 
-IPA_REG_FIELDS(COUNTER_CFG, counter_cfg, 0x000001f0);
+REG_FIELDS(COUNTER_CFG, counter_cfg, 0x000001f0);
 
-static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(7, 0),
 	[X_MAX_LIM]					= GENMASK(15, 8),
 	[Y_MIN_LIM]					= GENMASK(23, 16),
 	[Y_MAX_LIM]					= GENMASK(31, 24),
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-		      0x00000400, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		  0x00000400, 0x0020);
 
-static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(7, 0),
 	[X_MAX_LIM]					= GENMASK(15, 8),
 	[Y_MIN_LIM]					= GENMASK(23, 16),
 	[Y_MAX_LIM]					= GENMASK(31, 24),
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-		      0x00000404, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		  0x00000404, 0x0020);
 
-static const u32 ipa_reg_src_rsrc_grp_45_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_45_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(7, 0),
 	[X_MAX_LIM]					= GENMASK(15, 8),
 	[Y_MIN_LIM]					= GENMASK(23, 16),
 	[Y_MAX_LIM]					= GENMASK(31, 24),
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_45_RSRC_TYPE, src_rsrc_grp_45_rsrc_type,
-		      0x00000408, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_45_RSRC_TYPE, src_rsrc_grp_45_rsrc_type,
+		  0x00000408, 0x0020);
 
-static const u32 ipa_reg_src_rsrc_grp_67_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_67_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(7, 0),
 	[X_MAX_LIM]					= GENMASK(15, 8),
 	[Y_MIN_LIM]					= GENMASK(23, 16),
 	[Y_MAX_LIM]					= GENMASK(31, 24),
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_67_RSRC_TYPE, src_rsrc_grp_67_rsrc_type,
-		      0x0000040c, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_67_RSRC_TYPE, src_rsrc_grp_67_rsrc_type,
+		  0x0000040c, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(7, 0),
 	[X_MAX_LIM]					= GENMASK(15, 8),
 	[Y_MIN_LIM]					= GENMASK(23, 16),
 	[Y_MAX_LIM]					= GENMASK(31, 24),
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-		      0x00000500, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		  0x00000500, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(7, 0),
 	[X_MAX_LIM]					= GENMASK(15, 8),
 	[Y_MIN_LIM]					= GENMASK(23, 16),
 	[Y_MAX_LIM]					= GENMASK(31, 24),
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-		      0x00000504, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		  0x00000504, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_45_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_45_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(7, 0),
 	[X_MAX_LIM]					= GENMASK(15, 8),
 	[Y_MIN_LIM]					= GENMASK(23, 16),
 	[Y_MAX_LIM]					= GENMASK(31, 24),
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_45_RSRC_TYPE, dst_rsrc_grp_45_rsrc_type,
-		      0x00000508, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_45_RSRC_TYPE, dst_rsrc_grp_45_rsrc_type,
+		  0x00000508, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_67_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_67_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(7, 0),
 	[X_MAX_LIM]					= GENMASK(15, 8),
 	[Y_MIN_LIM]					= GENMASK(23, 16),
 	[Y_MAX_LIM]					= GENMASK(31, 24),
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_67_RSRC_TYPE, dst_rsrc_grp_67_rsrc_type,
-		      0x0000050c, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_67_RSRC_TYPE, dst_rsrc_grp_67_rsrc_type,
+		  0x0000050c, 0x0020);
 
-static const u32 ipa_reg_endp_init_ctrl_fmask[] = {
+static const u32 reg_endp_init_ctrl_fmask[] = {
 	[ENDP_SUSPEND]					= BIT(0),
 	[ENDP_DELAY]					= BIT(1),
 						/* Bits 2-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_CTRL, endp_init_ctrl, 0x00000800, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_CTRL, endp_init_ctrl, 0x00000800, 0x0070);
 
-static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+static const u32 reg_endp_init_cfg_fmask[] = {
 	[FRAG_OFFLOAD_EN]				= BIT(0),
 	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
 	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
@@ -223,16 +223,16 @@ static const u32 ipa_reg_endp_init_cfg_fmask[] = {
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-static const u32 ipa_reg_endp_init_nat_fmask[] = {
+static const u32 reg_endp_init_nat_fmask[] = {
 	[NAT_EN]					= GENMASK(1, 0),
 						/* Bits 2-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+static const u32 reg_endp_init_hdr_fmask[] = {
 	[HDR_LEN]					= GENMASK(5, 0),
 	[HDR_OFST_METADATA_VALID]			= BIT(6),
 	[HDR_OFST_METADATA]				= GENMASK(12, 7),
@@ -245,9 +245,9 @@ static const u32 ipa_reg_endp_init_hdr_fmask[] = {
 						/* Bits 29-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+static const u32 reg_endp_init_hdr_ext_fmask[] = {
 	[HDR_ENDIANNESS]				= BIT(0),
 	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
 	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
@@ -257,12 +257,12 @@ static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
 						/* Bits 14-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
-	       0x00000818, 0x0070);
+REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	   0x00000818, 0x0070);
 
-static const u32 ipa_reg_endp_init_mode_fmask[] = {
+static const u32 reg_endp_init_mode_fmask[] = {
 	[ENDP_MODE]					= GENMASK(2, 0),
 						/* Bit 3 reserved */
 	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
@@ -274,9 +274,9 @@ static const u32 ipa_reg_endp_init_mode_fmask[] = {
 						/* Bit 31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+static const u32 reg_endp_init_aggr_fmask[] = {
 	[AGGR_EN]					= GENMASK(1, 0),
 	[AGGR_TYPE]					= GENMASK(4, 2),
 	[BYTE_LIMIT]					= GENMASK(9, 5),
@@ -289,25 +289,25 @@ static const u32 ipa_reg_endp_init_aggr_fmask[] = {
 						/* Bits 25-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
 
-static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+static const u32 reg_endp_init_hol_block_en_fmask[] = {
 	[HOL_BLOCK_EN]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-		      0x0000082c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		  0x0000082c, 0x0070);
 
 /* Entire register is a tick count */
-static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+static const u32 reg_endp_init_hol_block_timer_fmask[] = {
 	[TIMER_BASE_VALUE]				= GENMASK(31, 0),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-		      0x00000830, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		  0x00000830, 0x0070);
 
-static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+static const u32 reg_endp_init_deaggr_fmask[] = {
 	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
 	[SYSPIPE_ERR_DETECTION]				= BIT(6),
 	[PACKET_OFFSET_VALID]				= BIT(7),
@@ -317,25 +317,24 @@ static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
 	[MAX_PACKET_LEN]				= GENMASK(31, 16),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+static const u32 reg_endp_init_rsrc_grp_fmask[] = {
 	[ENDP_RSRC_GRP]					= GENMASK(2, 0),
 						/* Bits 3-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
-		      0x00000838, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
 
-static const u32 ipa_reg_endp_init_seq_fmask[] = {
+static const u32 reg_endp_init_seq_fmask[] = {
 	[SEQ_TYPE]					= GENMASK(7, 0),
 	[SEQ_REP_TYPE]					= GENMASK(15, 8),
 						/* Bits 16-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
 
-static const u32 ipa_reg_endp_status_fmask[] = {
+static const u32 reg_endp_status_fmask[] = {
 	[STATUS_EN]					= BIT(0),
 	[STATUS_ENDP]					= GENMASK(5, 1),
 						/* Bits 6-7 reserved */
@@ -343,9 +342,9 @@ static const u32 ipa_reg_endp_status_fmask[] = {
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
 
-static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
+static const u32 reg_endp_filter_router_hsh_cfg_fmask[] = {
 	[FILTER_HASH_MSK_SRC_ID]			= BIT(0),
 	[FILTER_HASH_MSK_SRC_IP]			= BIT(1),
 	[FILTER_HASH_MSK_DST_IP]			= BIT(2),
@@ -366,84 +365,84 @@ static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
 						/* Bits 23-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
-		      0x0000085c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+		  0x0000085c, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
 
-static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+static const u32 reg_ipa_irq_uc_fmask[] = {
 	[UC_INTR]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
-	       0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	   0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
-	       0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	   0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
-	       0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	   0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
 
-static const struct ipa_reg *ipa_reg_array[] = {
-	[COMP_CFG]			= &ipa_reg_comp_cfg,
-	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
-	[ROUTE]				= &ipa_reg_route,
-	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
-	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
-	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
-	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
-	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
-	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
-	[IPA_BCR]			= &ipa_reg_ipa_bcr,
-	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
-	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
-	[COUNTER_CFG]			= &ipa_reg_counter_cfg,
-	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
-	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
-	[SRC_RSRC_GRP_45_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_45_rsrc_type,
-	[SRC_RSRC_GRP_67_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_67_rsrc_type,
-	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
-	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
-	[DST_RSRC_GRP_45_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_45_rsrc_type,
-	[DST_RSRC_GRP_67_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_67_rsrc_type,
-	[ENDP_INIT_CTRL]		= &ipa_reg_endp_init_ctrl,
-	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
-	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
-	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
-	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
-	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
-	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
-	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
-	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
-	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
-	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
-	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
-	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
-	[ENDP_STATUS]			= &ipa_reg_endp_status,
-	[ENDP_FILTER_ROUTER_HSH_CFG]	= &ipa_reg_endp_filter_router_hsh_cfg,
-	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
-	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
-	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
-	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
-	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
-	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
-	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+static const struct reg *reg_array[] = {
+	[COMP_CFG]			= &reg_comp_cfg,
+	[CLKON_CFG]			= &reg_clkon_cfg,
+	[ROUTE]				= &reg_route,
+	[SHARED_MEM_SIZE]		= &reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &reg_state_aggr_active,
+	[IPA_BCR]			= &reg_ipa_bcr,
+	[LOCAL_PKT_PROC_CNTXT]		= &reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &reg_aggr_force_close,
+	[COUNTER_CFG]			= &reg_counter_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &reg_src_rsrc_grp_23_rsrc_type,
+	[SRC_RSRC_GRP_45_RSRC_TYPE]	= &reg_src_rsrc_grp_45_rsrc_type,
+	[SRC_RSRC_GRP_67_RSRC_TYPE]	= &reg_src_rsrc_grp_67_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &reg_dst_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_45_RSRC_TYPE]	= &reg_dst_rsrc_grp_45_rsrc_type,
+	[DST_RSRC_GRP_67_RSRC_TYPE]	= &reg_dst_rsrc_grp_67_rsrc_type,
+	[ENDP_INIT_CTRL]		= &reg_endp_init_ctrl,
+	[ENDP_INIT_CFG]			= &reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &reg_endp_init_seq,
+	[ENDP_STATUS]			= &reg_endp_status,
+	[ENDP_FILTER_ROUTER_HSH_CFG]	= &reg_endp_filter_router_hsh_cfg,
+	[IPA_IRQ_STTS]			= &reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &reg_irq_suspend_clr,
 };
 
-const struct ipa_regs ipa_regs_v3_1 = {
-	.reg_count	= ARRAY_SIZE(ipa_reg_array),
-	.reg		= ipa_reg_array,
+const struct regs ipa_regs_v3_1 = {
+	.reg_count	= ARRAY_SIZE(reg_array),
+	.reg		= reg_array,
 };
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
index b9c6a50de2436..78b1bf60cd024 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -7,7 +7,7 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-static const u32 ipa_reg_comp_cfg_fmask[] = {
+static const u32 reg_comp_cfg_fmask[] = {
 	[COMP_CFG_ENABLE]				= BIT(0),
 	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
 	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
@@ -16,9 +16,9 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 						/* Bits 5-31 reserved */
 };
 
-IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
+REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-static const u32 ipa_reg_clkon_cfg_fmask[] = {
+static const u32 reg_clkon_cfg_fmask[] = {
 	[CLKON_RX]					= BIT(0),
 	[CLKON_PROC]					= BIT(1),
 	[TX_WRAPPER]					= BIT(2),
@@ -44,9 +44,9 @@ static const u32 ipa_reg_clkon_cfg_fmask[] = {
 						/* Bits 22-31 reserved */
 };
 
-IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
 
-static const u32 ipa_reg_route_fmask[] = {
+static const u32 reg_route_fmask[] = {
 	[ROUTE_DIS]					= BIT(0),
 	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
 	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
@@ -57,31 +57,31 @@ static const u32 ipa_reg_route_fmask[] = {
 						/* Bits 25-31 reserved */
 };
 
-IPA_REG_FIELDS(ROUTE, route, 0x00000048);
+REG_FIELDS(ROUTE, route, 0x00000048);
 
-static const u32 ipa_reg_shared_mem_size_fmask[] = {
+static const u32 reg_shared_mem_size_fmask[] = {
 	[MEM_SIZE]					= GENMASK(15, 0),
 	[MEM_BADDR]					= GENMASK(31, 16),
 };
 
-IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+static const u32 reg_qsb_max_writes_fmask[] = {
 	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
 						/* Bits 8-31 reserved */
 };
 
-IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+static const u32 reg_qsb_max_reads_fmask[] = {
 	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
 };
 
-IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
 
-static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+static const u32 reg_filt_rout_hash_en_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -92,9 +92,9 @@ static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x000008c);
+REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x000008c);
 
-static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+static const u32 reg_filt_rout_hash_flush_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -105,42 +105,42 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x0000090);
+REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x0000090);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c, 0x0004);
+REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c, 0x0004);
 
-IPA_REG(IPA_BCR, ipa_bcr, 0x000001d0);
+REG(IPA_BCR, ipa_bcr, 0x000001d0);
 
-static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+static const u32 reg_local_pkt_proc_cntxt_fmask[] = {
 	[IPA_BASE_ADDR]					= GENMASK(16, 0),
 						/* Bits 17-31 reserved */
 };
 
 /* Offset must be a multiple of 8 */
-IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
+REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
-static const u32 ipa_reg_counter_cfg_fmask[] = {
+static const u32 reg_counter_cfg_fmask[] = {
 						/* Bits 0-3 reserved */
 	[AGGR_GRANULARITY]				= GENMASK(8, 4),
 						/* Bits 5-31 reserved */
 };
 
-IPA_REG_FIELDS(COUNTER_CFG, counter_cfg, 0x000001f0);
+REG_FIELDS(COUNTER_CFG, counter_cfg, 0x000001f0);
 
-static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
+static const u32 reg_ipa_tx_cfg_fmask[] = {
 	[TX0_PREFETCH_DISABLE]				= BIT(0),
 	[TX1_PREFETCH_DISABLE]				= BIT(1),
 	[PREFETCH_ALMOST_EMPTY_SIZE]			= GENMASK(4, 2),
 						/* Bits 5-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
-static const u32 ipa_reg_flavor_0_fmask[] = {
+static const u32 reg_flavor_0_fmask[] = {
 	[MAX_PIPES]					= GENMASK(3, 0),
 						/* Bits 4-7 reserved */
 	[MAX_CONS_PIPES]				= GENMASK(12, 8),
@@ -151,17 +151,17 @@ static const u32 ipa_reg_flavor_0_fmask[] = {
 						/* Bits 28-31 reserved */
 };
 
-IPA_REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
+REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
 
-static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
+static const u32 reg_idle_indication_cfg_fmask[] = {
 	[ENTER_IDLE_DEBOUNCE_THRESH]			= GENMASK(15, 0),
 	[CONST_NON_IDLE_ENABLE]				= BIT(16),
 						/* Bits 17-31 reserved */
 };
 
-IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000220);
+REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000220);
 
-static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -172,10 +172,10 @@ static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-		      0x00000400, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		  0x00000400, 0x0020);
 
-static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -186,10 +186,10 @@ static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-		      0x00000404, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		  0x00000404, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -200,10 +200,10 @@ static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-		      0x00000500, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		  0x00000500, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -214,18 +214,18 @@ static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-		      0x00000504, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		  0x00000504, 0x0020);
 
-static const u32 ipa_reg_endp_init_ctrl_fmask[] = {
+static const u32 reg_endp_init_ctrl_fmask[] = {
 	[ENDP_SUSPEND]					= BIT(0),
 	[ENDP_DELAY]					= BIT(1),
 						/* Bits 2-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_CTRL, endp_init_ctrl, 0x00000800, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_CTRL, endp_init_ctrl, 0x00000800, 0x0070);
 
-static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+static const u32 reg_endp_init_cfg_fmask[] = {
 	[FRAG_OFFLOAD_EN]				= BIT(0),
 	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
 	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
@@ -234,16 +234,16 @@ static const u32 ipa_reg_endp_init_cfg_fmask[] = {
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-static const u32 ipa_reg_endp_init_nat_fmask[] = {
+static const u32 reg_endp_init_nat_fmask[] = {
 	[NAT_EN]					= GENMASK(1, 0),
 						/* Bits 2-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+static const u32 reg_endp_init_hdr_fmask[] = {
 	[HDR_LEN]					= GENMASK(5, 0),
 	[HDR_OFST_METADATA_VALID]			= BIT(6),
 	[HDR_OFST_METADATA]				= GENMASK(12, 7),
@@ -256,9 +256,9 @@ static const u32 ipa_reg_endp_init_hdr_fmask[] = {
 						/* Bits 29-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+static const u32 reg_endp_init_hdr_ext_fmask[] = {
 	[HDR_ENDIANNESS]				= BIT(0),
 	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
 	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
@@ -268,12 +268,12 @@ static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
 						/* Bits 14-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
-	       0x00000818, 0x0070);
+REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	   0x00000818, 0x0070);
 
-static const u32 ipa_reg_endp_init_mode_fmask[] = {
+static const u32 reg_endp_init_mode_fmask[] = {
 	[ENDP_MODE]					= GENMASK(2, 0),
 						/* Bit 3 reserved */
 	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
@@ -285,9 +285,9 @@ static const u32 ipa_reg_endp_init_mode_fmask[] = {
 						/* Bit 31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+static const u32 reg_endp_init_aggr_fmask[] = {
 	[AGGR_EN]					= GENMASK(1, 0),
 	[AGGR_TYPE]					= GENMASK(4, 2),
 	[BYTE_LIMIT]					= GENMASK(9, 5),
@@ -300,25 +300,25 @@ static const u32 ipa_reg_endp_init_aggr_fmask[] = {
 						/* Bits 25-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
 
-static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+static const u32 reg_endp_init_hol_block_en_fmask[] = {
 	[HOL_BLOCK_EN]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-		      0x0000082c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		  0x0000082c, 0x0070);
 
 /* Entire register is a tick count */
-static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+static const u32 reg_endp_init_hol_block_timer_fmask[] = {
 	[TIMER_BASE_VALUE]				= GENMASK(31, 0),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-		      0x00000830, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		  0x00000830, 0x0070);
 
-static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+static const u32 reg_endp_init_deaggr_fmask[] = {
 	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
 	[SYSPIPE_ERR_DETECTION]				= BIT(6),
 	[PACKET_OFFSET_VALID]				= BIT(7),
@@ -328,25 +328,24 @@ static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
 	[MAX_PACKET_LEN]				= GENMASK(31, 16),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+static const u32 reg_endp_init_rsrc_grp_fmask[] = {
 	[ENDP_RSRC_GRP]					= GENMASK(1, 0),
 						/* Bits 2-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
-		      0x00000838, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
 
-static const u32 ipa_reg_endp_init_seq_fmask[] = {
+static const u32 reg_endp_init_seq_fmask[] = {
 	[SEQ_TYPE]					= GENMASK(7, 0),
 	[SEQ_REP_TYPE]					= GENMASK(15, 8),
 						/* Bits 16-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
 
-static const u32 ipa_reg_endp_status_fmask[] = {
+static const u32 reg_endp_status_fmask[] = {
 	[STATUS_EN]					= BIT(0),
 	[STATUS_ENDP]					= GENMASK(5, 1),
 						/* Bits 6-7 reserved */
@@ -354,9 +353,9 @@ static const u32 ipa_reg_endp_status_fmask[] = {
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
 
-static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
+static const u32 reg_endp_filter_router_hsh_cfg_fmask[] = {
 	[FILTER_HASH_MSK_SRC_ID]			= BIT(0),
 	[FILTER_HASH_MSK_SRC_IP]			= BIT(1),
 	[FILTER_HASH_MSK_DST_IP]			= BIT(2),
@@ -377,83 +376,83 @@ static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
 						/* Bits 23-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
-		      0x0000085c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+		  0x0000085c, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
 
-static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+static const u32 reg_ipa_irq_uc_fmask[] = {
 	[UC_INTR]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
-	       0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	   0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
-	       0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	   0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
-	       0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	   0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
 
-static const struct ipa_reg *ipa_reg_array[] = {
-	[COMP_CFG]			= &ipa_reg_comp_cfg,
-	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
-	[ROUTE]				= &ipa_reg_route,
-	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
-	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
-	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
-	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
-	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
-	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
-	[IPA_BCR]			= &ipa_reg_ipa_bcr,
-	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
-	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
-	[COUNTER_CFG]			= &ipa_reg_counter_cfg,
-	[IPA_TX_CFG]			= &ipa_reg_ipa_tx_cfg,
-	[FLAVOR_0]			= &ipa_reg_flavor_0,
-	[IDLE_INDICATION_CFG]		= &ipa_reg_idle_indication_cfg,
-	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
-	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
-	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
-	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
-	[ENDP_INIT_CTRL]		= &ipa_reg_endp_init_ctrl,
-	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
-	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
-	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
-	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
-	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
-	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
-	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
-	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
-	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
-	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
-	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
-	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
-	[ENDP_STATUS]			= &ipa_reg_endp_status,
-	[ENDP_FILTER_ROUTER_HSH_CFG]	= &ipa_reg_endp_filter_router_hsh_cfg,
-	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
-	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
-	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
-	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
-	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
-	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
-	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+static const struct reg *reg_array[] = {
+	[COMP_CFG]			= &reg_comp_cfg,
+	[CLKON_CFG]			= &reg_clkon_cfg,
+	[ROUTE]				= &reg_route,
+	[SHARED_MEM_SIZE]		= &reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &reg_state_aggr_active,
+	[IPA_BCR]			= &reg_ipa_bcr,
+	[LOCAL_PKT_PROC_CNTXT]		= &reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &reg_aggr_force_close,
+	[COUNTER_CFG]			= &reg_counter_cfg,
+	[IPA_TX_CFG]			= &reg_ipa_tx_cfg,
+	[FLAVOR_0]			= &reg_flavor_0,
+	[IDLE_INDICATION_CFG]		= &reg_idle_indication_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &reg_src_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &reg_dst_rsrc_grp_23_rsrc_type,
+	[ENDP_INIT_CTRL]		= &reg_endp_init_ctrl,
+	[ENDP_INIT_CFG]			= &reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &reg_endp_init_seq,
+	[ENDP_STATUS]			= &reg_endp_status,
+	[ENDP_FILTER_ROUTER_HSH_CFG]	= &reg_endp_filter_router_hsh_cfg,
+	[IPA_IRQ_STTS]			= &reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &reg_irq_suspend_clr,
 };
 
-const struct ipa_regs ipa_regs_v3_5_1 = {
-	.reg_count	= ARRAY_SIZE(ipa_reg_array),
-	.reg		= ipa_reg_array,
+const struct regs ipa_regs_v3_5_1 = {
+	.reg_count	= ARRAY_SIZE(reg_array),
+	.reg		= reg_array,
 };
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
index 9a315130530dd..29e71cce4a843 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.11.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -7,7 +7,7 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-static const u32 ipa_reg_comp_cfg_fmask[] = {
+static const u32 reg_comp_cfg_fmask[] = {
 	[RAM_ARB_PRI_CLIENT_SAMP_FIX_DIS]		= BIT(0),
 	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
 	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
@@ -36,9 +36,9 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 	[GEN_QMB_0_DYNAMIC_ASIZE]			= BIT(31),
 };
 
-IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
+REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-static const u32 ipa_reg_clkon_cfg_fmask[] = {
+static const u32 reg_clkon_cfg_fmask[] = {
 	[CLKON_RX]					= BIT(0),
 	[CLKON_PROC]					= BIT(1),
 	[TX_WRAPPER]					= BIT(2),
@@ -73,9 +73,9 @@ static const u32 ipa_reg_clkon_cfg_fmask[] = {
 	[DRBIP]						= BIT(31),
 };
 
-IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
 
-static const u32 ipa_reg_route_fmask[] = {
+static const u32 reg_route_fmask[] = {
 	[ROUTE_DIS]					= BIT(0),
 	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
 	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
@@ -86,24 +86,24 @@ static const u32 ipa_reg_route_fmask[] = {
 						/* Bits 25-31 reserved */
 };
 
-IPA_REG_FIELDS(ROUTE, route, 0x00000048);
+REG_FIELDS(ROUTE, route, 0x00000048);
 
-static const u32 ipa_reg_shared_mem_size_fmask[] = {
+static const u32 reg_shared_mem_size_fmask[] = {
 	[MEM_SIZE]					= GENMASK(15, 0),
 	[MEM_BADDR]					= GENMASK(31, 16),
 };
 
-IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+static const u32 reg_qsb_max_writes_fmask[] = {
 	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
 						/* Bits 8-31 reserved */
 };
 
-IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+static const u32 reg_qsb_max_reads_fmask[] = {
 	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
 						/* Bits 8-15 reserved */
@@ -111,9 +111,9 @@ static const u32 ipa_reg_qsb_max_reads_fmask[] = {
 	[GEN_QMB_1_MAX_READS_BEATS]			= GENMASK(31, 24),
 };
 
-IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
 
-static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+static const u32 reg_filt_rout_hash_en_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -124,9 +124,9 @@ static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
 
-static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+static const u32 reg_filt_rout_hash_flush_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -137,23 +137,23 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
+REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
 
-static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+static const u32 reg_local_pkt_proc_cntxt_fmask[] = {
 	[IPA_BASE_ADDR]					= GENMASK(17, 0),
 						/* Bits 18-31 reserved */
 };
 
 /* Offset must be a multiple of 8 */
-IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
+REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
-static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
+static const u32 reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 0-1 reserved */
 	[PREFETCH_ALMOST_EMPTY_SIZE_TX0]		= GENMASK(5, 2),
 	[DMAW_SCND_OUTSD_PRED_THRESHOLD]		= GENMASK(9, 6),
@@ -166,9 +166,9 @@ static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 19-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
-static const u32 ipa_reg_flavor_0_fmask[] = {
+static const u32 reg_flavor_0_fmask[] = {
 	[MAX_PIPES]					= GENMASK(4, 0),
 						/* Bits 5-7 reserved */
 	[MAX_CONS_PIPES]				= GENMASK(12, 8),
@@ -179,17 +179,17 @@ static const u32 ipa_reg_flavor_0_fmask[] = {
 						/* Bits 28-31 reserved */
 };
 
-IPA_REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
+REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
 
-static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
+static const u32 reg_idle_indication_cfg_fmask[] = {
 	[ENTER_IDLE_DEBOUNCE_THRESH]			= GENMASK(15, 0),
 	[CONST_NON_IDLE_ENABLE]				= BIT(16),
 						/* Bits 17-31 reserved */
 };
 
-IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
 
-static const u32 ipa_reg_qtime_timestamp_cfg_fmask[] = {
+static const u32 reg_qtime_timestamp_cfg_fmask[] = {
 	[DPL_TIMESTAMP_LSB]				= GENMASK(4, 0),
 						/* Bits 5-6 reserved */
 	[DPL_TIMESTAMP_SEL]				= BIT(7),
@@ -199,26 +199,26 @@ static const u32 ipa_reg_qtime_timestamp_cfg_fmask[] = {
 						/* Bits 21-31 reserved */
 };
 
-IPA_REG_FIELDS(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+REG_FIELDS(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
 
-static const u32 ipa_reg_timers_xo_clk_div_cfg_fmask[] = {
+static const u32 reg_timers_xo_clk_div_cfg_fmask[] = {
 	[DIV_VALUE]					= GENMASK(8, 0),
 						/* Bits 9-30 reserved */
 	[DIV_ENABLE]					= BIT(31),
 };
 
-IPA_REG_FIELDS(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+REG_FIELDS(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
 
-static const u32 ipa_reg_timers_pulse_gran_cfg_fmask[] = {
+static const u32 reg_timers_pulse_gran_cfg_fmask[] = {
 	[PULSE_GRAN_0]					= GENMASK(2, 0),
 	[PULSE_GRAN_1]					= GENMASK(5, 3),
 	[PULSE_GRAN_2]					= GENMASK(8, 6),
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
+REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
 
-static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -229,10 +229,10 @@ static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-		      0x00000400, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		  0x00000400, 0x0020);
 
-static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -243,10 +243,10 @@ static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-		      0x00000404, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		  0x00000404, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -257,10 +257,10 @@ static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-		      0x00000500, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		  0x00000500, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -271,10 +271,10 @@ static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-		      0x00000504, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		  0x00000504, 0x0020);
 
-static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+static const u32 reg_endp_init_cfg_fmask[] = {
 	[FRAG_OFFLOAD_EN]				= BIT(0),
 	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
 	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
@@ -283,16 +283,16 @@ static const u32 ipa_reg_endp_init_cfg_fmask[] = {
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-static const u32 ipa_reg_endp_init_nat_fmask[] = {
+static const u32 reg_endp_init_nat_fmask[] = {
 	[NAT_EN]					= GENMASK(1, 0),
 						/* Bits 2-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+static const u32 reg_endp_init_hdr_fmask[] = {
 	[HDR_LEN]					= GENMASK(5, 0),
 	[HDR_OFST_METADATA_VALID]			= BIT(6),
 	[HDR_OFST_METADATA]				= GENMASK(12, 7),
@@ -305,9 +305,9 @@ static const u32 ipa_reg_endp_init_hdr_fmask[] = {
 	[HDR_OFST_METADATA_MSB]				= GENMASK(31, 30),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+static const u32 reg_endp_init_hdr_ext_fmask[] = {
 	[HDR_ENDIANNESS]				= BIT(0),
 	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
 	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
@@ -321,12 +321,12 @@ static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
 						/* Bits 22-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
-	       0x00000818, 0x0070);
+REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	   0x00000818, 0x0070);
 
-static const u32 ipa_reg_endp_init_mode_fmask[] = {
+static const u32 reg_endp_init_mode_fmask[] = {
 	[ENDP_MODE]					= GENMASK(2, 0),
 	[DCPH_ENABLE]					= BIT(3),
 	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
@@ -338,9 +338,9 @@ static const u32 ipa_reg_endp_init_mode_fmask[] = {
 						/* Bit 31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+static const u32 reg_endp_init_aggr_fmask[] = {
 	[AGGR_EN]					= GENMASK(1, 0),
 	[AGGR_TYPE]					= GENMASK(4, 2),
 	[BYTE_LIMIT]					= GENMASK(10, 5),
@@ -355,27 +355,27 @@ static const u32 ipa_reg_endp_init_aggr_fmask[] = {
 						/* Bits 28-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
 
-static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+static const u32 reg_endp_init_hol_block_en_fmask[] = {
 	[HOL_BLOCK_EN]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-		      0x0000082c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		  0x0000082c, 0x0070);
 
-static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+static const u32 reg_endp_init_hol_block_timer_fmask[] = {
 	[TIMER_LIMIT]					= GENMASK(4, 0),
 						/* Bits 5-7 reserved */
 	[TIMER_GRAN_SEL]				= BIT(8),
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-		      0x00000830, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		  0x00000830, 0x0070);
 
-static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+static const u32 reg_endp_init_deaggr_fmask[] = {
 	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
 	[SYSPIPE_ERR_DETECTION]				= BIT(6),
 	[PACKET_OFFSET_VALID]				= BIT(7),
@@ -385,24 +385,23 @@ static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
 	[MAX_PACKET_LEN]				= GENMASK(31, 16),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+static const u32 reg_endp_init_rsrc_grp_fmask[] = {
 	[ENDP_RSRC_GRP]					= GENMASK(1, 0),
 						/* Bits 2-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
-		      0x00000838, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
 
-static const u32 ipa_reg_endp_init_seq_fmask[] = {
+static const u32 reg_endp_init_seq_fmask[] = {
 	[SEQ_TYPE]					= GENMASK(7, 0),
 						/* Bits 8-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
 
-static const u32 ipa_reg_endp_status_fmask[] = {
+static const u32 reg_endp_status_fmask[] = {
 	[STATUS_EN]					= BIT(0),
 	[STATUS_ENDP]					= GENMASK(5, 1),
 						/* Bits 6-8 reserved */
@@ -410,9 +409,9 @@ static const u32 ipa_reg_endp_status_fmask[] = {
 						/* Bits 10-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
 
-static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
+static const u32 reg_endp_filter_router_hsh_cfg_fmask[] = {
 	[FILTER_HASH_MSK_SRC_ID]			= BIT(0),
 	[FILTER_HASH_MSK_SRC_IP]			= BIT(1),
 	[FILTER_HASH_MSK_DST_IP]			= BIT(2),
@@ -433,83 +432,83 @@ static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
 						/* Bits 23-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
-		      0x0000085c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+		  0x0000085c, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00004008 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00004008 + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000400c + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_EN, ipa_irq_en, 0x0000400c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00004010 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00004010 + 0x1000 * GSI_EE_AP);
 
-static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+static const u32 reg_ipa_irq_uc_fmask[] = {
 	[UC_INTR]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000401c + 0x1000 * GSI_EE_AP);
+REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000401c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
-	       0x00004030 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	   0x00004030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
-	       0x00004034 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	   0x00004034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
-	       0x00004038 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	   0x00004038 + 0x1000 * GSI_EE_AP, 0x0004);
 
-static const struct ipa_reg *ipa_reg_array[] = {
-	[COMP_CFG]			= &ipa_reg_comp_cfg,
-	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
-	[ROUTE]				= &ipa_reg_route,
-	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
-	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
-	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
-	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
-	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
-	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
-	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
-	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
-	[IPA_TX_CFG]			= &ipa_reg_ipa_tx_cfg,
-	[FLAVOR_0]			= &ipa_reg_flavor_0,
-	[IDLE_INDICATION_CFG]		= &ipa_reg_idle_indication_cfg,
-	[QTIME_TIMESTAMP_CFG]		= &ipa_reg_qtime_timestamp_cfg,
-	[TIMERS_XO_CLK_DIV_CFG]		= &ipa_reg_timers_xo_clk_div_cfg,
-	[TIMERS_PULSE_GRAN_CFG]		= &ipa_reg_timers_pulse_gran_cfg,
-	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
-	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
-	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
-	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
-	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
-	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
-	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
-	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
-	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
-	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
-	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
-	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
-	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
-	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
-	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
-	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
-	[ENDP_STATUS]			= &ipa_reg_endp_status,
-	[ENDP_FILTER_ROUTER_HSH_CFG]	= &ipa_reg_endp_filter_router_hsh_cfg,
-	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
-	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
-	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
-	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
-	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
-	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
-	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+static const struct reg *reg_array[] = {
+	[COMP_CFG]			= &reg_comp_cfg,
+	[CLKON_CFG]			= &reg_clkon_cfg,
+	[ROUTE]				= &reg_route,
+	[SHARED_MEM_SIZE]		= &reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &reg_state_aggr_active,
+	[LOCAL_PKT_PROC_CNTXT]		= &reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &reg_aggr_force_close,
+	[IPA_TX_CFG]			= &reg_ipa_tx_cfg,
+	[FLAVOR_0]			= &reg_flavor_0,
+	[IDLE_INDICATION_CFG]		= &reg_idle_indication_cfg,
+	[QTIME_TIMESTAMP_CFG]		= &reg_qtime_timestamp_cfg,
+	[TIMERS_XO_CLK_DIV_CFG]		= &reg_timers_xo_clk_div_cfg,
+	[TIMERS_PULSE_GRAN_CFG]		= &reg_timers_pulse_gran_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &reg_src_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &reg_dst_rsrc_grp_23_rsrc_type,
+	[ENDP_INIT_CFG]			= &reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &reg_endp_init_seq,
+	[ENDP_STATUS]			= &reg_endp_status,
+	[ENDP_FILTER_ROUTER_HSH_CFG]	= &reg_endp_filter_router_hsh_cfg,
+	[IPA_IRQ_STTS]			= &reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &reg_irq_suspend_clr,
 };
 
-const struct ipa_regs ipa_regs_v4_11 = {
-	.reg_count	= ARRAY_SIZE(ipa_reg_array),
-	.reg		= ipa_reg_array,
+const struct regs ipa_regs_v4_11 = {
+	.reg_count	= ARRAY_SIZE(reg_array),
+	.reg		= reg_array,
 };
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
index 7a95149f8ec7a..bb7cf488144db 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.2.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -7,7 +7,7 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-static const u32 ipa_reg_comp_cfg_fmask[] = {
+static const u32 reg_comp_cfg_fmask[] = {
 						/* Bit 0 reserved */
 	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
 	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
@@ -29,9 +29,9 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 						/* Bits 21-31 reserved */
 };
 
-IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
+REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-static const u32 ipa_reg_clkon_cfg_fmask[] = {
+static const u32 reg_clkon_cfg_fmask[] = {
 	[CLKON_RX]					= BIT(0),
 	[CLKON_PROC]					= BIT(1),
 	[TX_WRAPPER]					= BIT(2),
@@ -65,9 +65,9 @@ static const u32 ipa_reg_clkon_cfg_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
 
-static const u32 ipa_reg_route_fmask[] = {
+static const u32 reg_route_fmask[] = {
 	[ROUTE_DIS]					= BIT(0),
 	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
 	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
@@ -78,24 +78,24 @@ static const u32 ipa_reg_route_fmask[] = {
 						/* Bits 25-31 reserved */
 };
 
-IPA_REG_FIELDS(ROUTE, route, 0x00000048);
+REG_FIELDS(ROUTE, route, 0x00000048);
 
-static const u32 ipa_reg_shared_mem_size_fmask[] = {
+static const u32 reg_shared_mem_size_fmask[] = {
 	[MEM_SIZE]					= GENMASK(15, 0),
 	[MEM_BADDR]					= GENMASK(31, 16),
 };
 
-IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+static const u32 reg_qsb_max_writes_fmask[] = {
 	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
 						/* Bits 8-31 reserved */
 };
 
-IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+static const u32 reg_qsb_max_reads_fmask[] = {
 	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
 						/* Bits 8-15 reserved */
@@ -103,9 +103,9 @@ static const u32 ipa_reg_qsb_max_reads_fmask[] = {
 	[GEN_QMB_1_MAX_READS_BEATS]			= GENMASK(31, 24),
 };
 
-IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
 
-static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+static const u32 reg_filt_rout_hash_en_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -116,9 +116,9 @@ static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
 
-static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+static const u32 reg_filt_rout_hash_flush_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -129,33 +129,33 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
+REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
 
-IPA_REG(IPA_BCR, ipa_bcr, 0x000001d0);
+REG(IPA_BCR, ipa_bcr, 0x000001d0);
 
-static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+static const u32 reg_local_pkt_proc_cntxt_fmask[] = {
 	[IPA_BASE_ADDR]					= GENMASK(16, 0),
 						/* Bits 17-31 reserved */
 };
 
 /* Offset must be a multiple of 8 */
-IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
+REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
-static const u32 ipa_reg_counter_cfg_fmask[] = {
+static const u32 reg_counter_cfg_fmask[] = {
 						/* Bits 0-3 reserved */
 	[AGGR_GRANULARITY]				= GENMASK(8, 4),
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_FIELDS(COUNTER_CFG, counter_cfg, 0x000001f0);
+REG_FIELDS(COUNTER_CFG, counter_cfg, 0x000001f0);
 
-static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
+static const u32 reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 0-1 reserved */
 	[PREFETCH_ALMOST_EMPTY_SIZE_TX0]		= GENMASK(5, 2),
 	[DMAW_SCND_OUTSD_PRED_THRESHOLD]		= GENMASK(9, 6),
@@ -169,9 +169,9 @@ static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 20-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
-static const u32 ipa_reg_flavor_0_fmask[] = {
+static const u32 reg_flavor_0_fmask[] = {
 	[MAX_PIPES]					= GENMASK(3, 0),
 						/* Bits 4-7 reserved */
 	[MAX_CONS_PIPES]				= GENMASK(12, 8),
@@ -182,17 +182,17 @@ static const u32 ipa_reg_flavor_0_fmask[] = {
 						/* Bits 28-31 reserved */
 };
 
-IPA_REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
+REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
 
-static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
+static const u32 reg_idle_indication_cfg_fmask[] = {
 	[ENTER_IDLE_DEBOUNCE_THRESH]			= GENMASK(15, 0),
 	[CONST_NON_IDLE_ENABLE]				= BIT(16),
 						/* Bits 17-31 reserved */
 };
 
-IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
 
-static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -203,10 +203,10 @@ static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-		      0x00000400, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		  0x00000400, 0x0020);
 
-static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -217,10 +217,10 @@ static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-		      0x00000404, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		  0x00000404, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -231,10 +231,10 @@ static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-		      0x00000500, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		  0x00000500, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -245,10 +245,10 @@ static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-		      0x00000504, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		  0x00000504, 0x0020);
 
-static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+static const u32 reg_endp_init_cfg_fmask[] = {
 	[FRAG_OFFLOAD_EN]				= BIT(0),
 	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
 	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
@@ -257,16 +257,16 @@ static const u32 ipa_reg_endp_init_cfg_fmask[] = {
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-static const u32 ipa_reg_endp_init_nat_fmask[] = {
+static const u32 reg_endp_init_nat_fmask[] = {
 	[NAT_EN]					= GENMASK(1, 0),
 						/* Bits 2-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+static const u32 reg_endp_init_hdr_fmask[] = {
 	[HDR_LEN]					= GENMASK(5, 0),
 	[HDR_OFST_METADATA_VALID]			= BIT(6),
 	[HDR_OFST_METADATA]				= GENMASK(12, 7),
@@ -279,9 +279,9 @@ static const u32 ipa_reg_endp_init_hdr_fmask[] = {
 						/* Bits 29-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+static const u32 reg_endp_init_hdr_ext_fmask[] = {
 	[HDR_ENDIANNESS]				= BIT(0),
 	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
 	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
@@ -291,12 +291,12 @@ static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
 						/* Bits 14-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
-	       0x00000818, 0x0070);
+REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	   0x00000818, 0x0070);
 
-static const u32 ipa_reg_endp_init_mode_fmask[] = {
+static const u32 reg_endp_init_mode_fmask[] = {
 	[ENDP_MODE]					= GENMASK(2, 0),
 						/* Bit 3 reserved */
 	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
@@ -308,9 +308,9 @@ static const u32 ipa_reg_endp_init_mode_fmask[] = {
 						/* Bit 31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+static const u32 reg_endp_init_aggr_fmask[] = {
 	[AGGR_EN]					= GENMASK(1, 0),
 	[AGGR_TYPE]					= GENMASK(4, 2),
 	[BYTE_LIMIT]					= GENMASK(9, 5),
@@ -323,27 +323,27 @@ static const u32 ipa_reg_endp_init_aggr_fmask[] = {
 						/* Bits 25-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
 
-static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+static const u32 reg_endp_init_hol_block_en_fmask[] = {
 	[HOL_BLOCK_EN]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-		      0x0000082c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		  0x0000082c, 0x0070);
 
-static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+static const u32 reg_endp_init_hol_block_timer_fmask[] = {
 	[TIMER_BASE_VALUE]				= GENMASK(4, 0),
 						/* Bits 5-7 reserved */
 	[TIMER_SCALE]					= GENMASK(12, 8),
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-		      0x00000830, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		  0x00000830, 0x0070);
 
-static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+static const u32 reg_endp_init_deaggr_fmask[] = {
 	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
 	[SYSPIPE_ERR_DETECTION]				= BIT(6),
 	[PACKET_OFFSET_VALID]				= BIT(7),
@@ -353,25 +353,24 @@ static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
 	[MAX_PACKET_LEN]				= GENMASK(31, 16),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+static const u32 reg_endp_init_rsrc_grp_fmask[] = {
 	[ENDP_RSRC_GRP]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
-		      0x00000838, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
 
-static const u32 ipa_reg_endp_init_seq_fmask[] = {
+static const u32 reg_endp_init_seq_fmask[] = {
 	[SEQ_TYPE]					= GENMASK(7, 0),
 	[SEQ_REP_TYPE]					= GENMASK(15, 8),
 						/* Bits 16-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
 
-static const u32 ipa_reg_endp_status_fmask[] = {
+static const u32 reg_endp_status_fmask[] = {
 	[STATUS_EN]					= BIT(0),
 	[STATUS_ENDP]					= GENMASK(5, 1),
 						/* Bits 6-7 reserved */
@@ -380,80 +379,80 @@ static const u32 ipa_reg_endp_status_fmask[] = {
 						/* Bits 10-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
 
-static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+static const u32 reg_ipa_irq_uc_fmask[] = {
 	[UC_INTR]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
-	       0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	   0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
-	       0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	   0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
-	       0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	   0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
 
-static const struct ipa_reg *ipa_reg_array[] = {
-	[COMP_CFG]			= &ipa_reg_comp_cfg,
-	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
-	[ROUTE]				= &ipa_reg_route,
-	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
-	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
-	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
-	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
-	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
-	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
-	[IPA_BCR]			= &ipa_reg_ipa_bcr,
-	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
-	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
-	[COUNTER_CFG]			= &ipa_reg_counter_cfg,
-	[IPA_TX_CFG]			= &ipa_reg_ipa_tx_cfg,
-	[FLAVOR_0]			= &ipa_reg_flavor_0,
-	[IDLE_INDICATION_CFG]		= &ipa_reg_idle_indication_cfg,
-	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
-	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
-	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
-	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
-	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
-	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
-	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
-	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
-	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
-	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
-	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
-	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
-	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
-	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
-	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
-	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
-	[ENDP_STATUS]			= &ipa_reg_endp_status,
-	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
-	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
-	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
-	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
-	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
-	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
-	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+static const struct reg *reg_array[] = {
+	[COMP_CFG]			= &reg_comp_cfg,
+	[CLKON_CFG]			= &reg_clkon_cfg,
+	[ROUTE]				= &reg_route,
+	[SHARED_MEM_SIZE]		= &reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &reg_state_aggr_active,
+	[IPA_BCR]			= &reg_ipa_bcr,
+	[LOCAL_PKT_PROC_CNTXT]		= &reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &reg_aggr_force_close,
+	[COUNTER_CFG]			= &reg_counter_cfg,
+	[IPA_TX_CFG]			= &reg_ipa_tx_cfg,
+	[FLAVOR_0]			= &reg_flavor_0,
+	[IDLE_INDICATION_CFG]		= &reg_idle_indication_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &reg_src_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &reg_dst_rsrc_grp_23_rsrc_type,
+	[ENDP_INIT_CFG]			= &reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &reg_endp_init_seq,
+	[ENDP_STATUS]			= &reg_endp_status,
+	[IPA_IRQ_STTS]			= &reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &reg_irq_suspend_clr,
 };
 
-const struct ipa_regs ipa_regs_v4_2 = {
-	.reg_count	= ARRAY_SIZE(ipa_reg_array),
-	.reg		= ipa_reg_array,
+const struct regs ipa_regs_v4_2 = {
+	.reg_count	= ARRAY_SIZE(reg_array),
+	.reg		= reg_array,
 };
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
index 587eb8d4e00f7..1c58f78851c21 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.5.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -7,7 +7,7 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-static const u32 ipa_reg_comp_cfg_fmask[] = {
+static const u32 reg_comp_cfg_fmask[] = {
 						/* Bit 0 reserved */
 	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
 	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
@@ -30,9 +30,9 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 						/* Bits 22-31 reserved */
 };
 
-IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
+REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-static const u32 ipa_reg_clkon_cfg_fmask[] = {
+static const u32 reg_clkon_cfg_fmask[] = {
 	[CLKON_RX]					= BIT(0),
 	[CLKON_PROC]					= BIT(1),
 	[TX_WRAPPER]					= BIT(2),
@@ -67,9 +67,9 @@ static const u32 ipa_reg_clkon_cfg_fmask[] = {
 						/* Bit 31 reserved */
 };
 
-IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
 
-static const u32 ipa_reg_route_fmask[] = {
+static const u32 reg_route_fmask[] = {
 	[ROUTE_DIS]					= BIT(0),
 	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
 	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
@@ -80,24 +80,24 @@ static const u32 ipa_reg_route_fmask[] = {
 						/* Bits 25-31 reserved */
 };
 
-IPA_REG_FIELDS(ROUTE, route, 0x00000048);
+REG_FIELDS(ROUTE, route, 0x00000048);
 
-static const u32 ipa_reg_shared_mem_size_fmask[] = {
+static const u32 reg_shared_mem_size_fmask[] = {
 	[MEM_SIZE]					= GENMASK(15, 0),
 	[MEM_BADDR]					= GENMASK(31, 16),
 };
 
-IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+static const u32 reg_qsb_max_writes_fmask[] = {
 	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
 						/* Bits 8-31 reserved */
 };
 
-IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+static const u32 reg_qsb_max_reads_fmask[] = {
 	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
 						/* Bits 8-15 reserved */
@@ -105,9 +105,9 @@ static const u32 ipa_reg_qsb_max_reads_fmask[] = {
 	[GEN_QMB_1_MAX_READS_BEATS]			= GENMASK(31, 24),
 };
 
-IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
 
-static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+static const u32 reg_filt_rout_hash_en_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -118,9 +118,9 @@ static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
 
-static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+static const u32 reg_filt_rout_hash_flush_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -131,23 +131,23 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
+REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
 
-static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+static const u32 reg_local_pkt_proc_cntxt_fmask[] = {
 	[IPA_BASE_ADDR]					= GENMASK(17, 0),
 						/* Bits 18-31 reserved */
 };
 
 /* Offset must be a multiple of 8 */
-IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
+REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
-static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
+static const u32 reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 0-1 reserved */
 	[PREFETCH_ALMOST_EMPTY_SIZE_TX0]		= GENMASK(5, 2),
 	[DMAW_SCND_OUTSD_PRED_THRESHOLD]		= GENMASK(9, 6),
@@ -159,9 +159,9 @@ static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 18-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
-static const u32 ipa_reg_flavor_0_fmask[] = {
+static const u32 reg_flavor_0_fmask[] = {
 	[MAX_PIPES]					= GENMASK(3, 0),
 						/* Bits 4-7 reserved */
 	[MAX_CONS_PIPES]				= GENMASK(12, 8),
@@ -172,17 +172,17 @@ static const u32 ipa_reg_flavor_0_fmask[] = {
 						/* Bits 28-31 reserved */
 };
 
-IPA_REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
+REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
 
-static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
+static const u32 reg_idle_indication_cfg_fmask[] = {
 	[ENTER_IDLE_DEBOUNCE_THRESH]			= GENMASK(15, 0),
 	[CONST_NON_IDLE_ENABLE]				= BIT(16),
 						/* Bits 17-31 reserved */
 };
 
-IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
 
-static const u32 ipa_reg_qtime_timestamp_cfg_fmask[] = {
+static const u32 reg_qtime_timestamp_cfg_fmask[] = {
 	[DPL_TIMESTAMP_LSB]				= GENMASK(4, 0),
 						/* Bits 5-6 reserved */
 	[DPL_TIMESTAMP_SEL]				= BIT(7),
@@ -192,25 +192,25 @@ static const u32 ipa_reg_qtime_timestamp_cfg_fmask[] = {
 						/* Bits 21-31 reserved */
 };
 
-IPA_REG_FIELDS(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+REG_FIELDS(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
 
-static const u32 ipa_reg_timers_xo_clk_div_cfg_fmask[] = {
+static const u32 reg_timers_xo_clk_div_cfg_fmask[] = {
 	[DIV_VALUE]					= GENMASK(8, 0),
 						/* Bits 9-30 reserved */
 	[DIV_ENABLE]					= BIT(31),
 };
 
-IPA_REG_FIELDS(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+REG_FIELDS(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
 
-static const u32 ipa_reg_timers_pulse_gran_cfg_fmask[] = {
+static const u32 reg_timers_pulse_gran_cfg_fmask[] = {
 	[PULSE_GRAN_0]					= GENMASK(2, 0),
 	[PULSE_GRAN_1]					= GENMASK(5, 3),
 	[PULSE_GRAN_2]					= GENMASK(8, 6),
 };
 
-IPA_REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
+REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
 
-static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -221,10 +221,10 @@ static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-		      0x00000400, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		  0x00000400, 0x0020);
 
-static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -235,10 +235,10 @@ static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-		      0x00000404, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		  0x00000404, 0x0020);
 
-static const u32 ipa_reg_src_rsrc_grp_45_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_45_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -249,10 +249,10 @@ static const u32 ipa_reg_src_rsrc_grp_45_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_45_RSRC_TYPE, src_rsrc_grp_45_rsrc_type,
-		      0x00000408, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_45_RSRC_TYPE, src_rsrc_grp_45_rsrc_type,
+		  0x00000408, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -263,10 +263,10 @@ static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-		      0x00000500, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		  0x00000500, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -277,10 +277,10 @@ static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-		      0x00000504, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		  0x00000504, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_45_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_45_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -291,10 +291,10 @@ static const u32 ipa_reg_dst_rsrc_grp_45_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_45_RSRC_TYPE, dst_rsrc_grp_45_rsrc_type,
-		      0x00000508, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_45_RSRC_TYPE, dst_rsrc_grp_45_rsrc_type,
+		  0x00000508, 0x0020);
 
-static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+static const u32 reg_endp_init_cfg_fmask[] = {
 	[FRAG_OFFLOAD_EN]				= BIT(0),
 	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
 	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
@@ -303,16 +303,16 @@ static const u32 ipa_reg_endp_init_cfg_fmask[] = {
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-static const u32 ipa_reg_endp_init_nat_fmask[] = {
+static const u32 reg_endp_init_nat_fmask[] = {
 	[NAT_EN]					= GENMASK(1, 0),
 						/* Bits 2-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+static const u32 reg_endp_init_hdr_fmask[] = {
 	[HDR_LEN]					= GENMASK(5, 0),
 	[HDR_OFST_METADATA_VALID]			= BIT(6),
 	[HDR_OFST_METADATA]				= GENMASK(12, 7),
@@ -325,9 +325,9 @@ static const u32 ipa_reg_endp_init_hdr_fmask[] = {
 	[HDR_OFST_METADATA_MSB]				= GENMASK(31, 30),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+static const u32 reg_endp_init_hdr_ext_fmask[] = {
 	[HDR_ENDIANNESS]				= BIT(0),
 	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
 	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
@@ -341,12 +341,12 @@ static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
 						/* Bits 22-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
-	       0x00000818, 0x0070);
+REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	   0x00000818, 0x0070);
 
-static const u32 ipa_reg_endp_init_mode_fmask[] = {
+static const u32 reg_endp_init_mode_fmask[] = {
 	[ENDP_MODE]					= GENMASK(2, 0),
 	[DCPH_ENABLE]					= BIT(3),
 	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
@@ -357,9 +357,9 @@ static const u32 ipa_reg_endp_init_mode_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+static const u32 reg_endp_init_aggr_fmask[] = {
 	[AGGR_EN]					= GENMASK(1, 0),
 	[AGGR_TYPE]					= GENMASK(4, 2),
 	[BYTE_LIMIT]					= GENMASK(10, 5),
@@ -374,27 +374,27 @@ static const u32 ipa_reg_endp_init_aggr_fmask[] = {
 						/* Bits 28-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
 
-static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+static const u32 reg_endp_init_hol_block_en_fmask[] = {
 	[HOL_BLOCK_EN]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-		      0x0000082c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		  0x0000082c, 0x0070);
 
-static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+static const u32 reg_endp_init_hol_block_timer_fmask[] = {
 	[TIMER_LIMIT]					= GENMASK(4, 0),
 						/* Bits 5-7 reserved */
 	[TIMER_GRAN_SEL]				= BIT(8),
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-		      0x00000830, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		  0x00000830, 0x0070);
 
-static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+static const u32 reg_endp_init_deaggr_fmask[] = {
 	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
 	[SYSPIPE_ERR_DETECTION]				= BIT(6),
 	[PACKET_OFFSET_VALID]				= BIT(7),
@@ -404,24 +404,23 @@ static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
 	[MAX_PACKET_LEN]				= GENMASK(31, 16),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+static const u32 reg_endp_init_rsrc_grp_fmask[] = {
 	[ENDP_RSRC_GRP]					= GENMASK(2, 0),
 						/* Bits 3-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
-		      0x00000838, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
 
-static const u32 ipa_reg_endp_init_seq_fmask[] = {
+static const u32 reg_endp_init_seq_fmask[] = {
 	[SEQ_TYPE]					= GENMASK(7, 0),
 						/* Bits 8-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
 
-static const u32 ipa_reg_endp_status_fmask[] = {
+static const u32 reg_endp_status_fmask[] = {
 	[STATUS_EN]					= BIT(0),
 	[STATUS_ENDP]					= GENMASK(5, 1),
 						/* Bits 6-8 reserved */
@@ -429,9 +428,9 @@ static const u32 ipa_reg_endp_status_fmask[] = {
 						/* Bits 10-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
 
-static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
+static const u32 reg_endp_filter_router_hsh_cfg_fmask[] = {
 	[FILTER_HASH_MSK_SRC_ID]			= BIT(0),
 	[FILTER_HASH_MSK_SRC_IP]			= BIT(1),
 	[FILTER_HASH_MSK_DST_IP]			= BIT(2),
@@ -452,85 +451,85 @@ static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
 						/* Bits 23-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
-		      0x0000085c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+		  0x0000085c, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
 
-static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+static const u32 reg_ipa_irq_uc_fmask[] = {
 	[UC_INTR]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
-	       0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	   0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
-	       0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	   0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
-	       0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	   0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
 
-static const struct ipa_reg *ipa_reg_array[] = {
-	[COMP_CFG]			= &ipa_reg_comp_cfg,
-	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
-	[ROUTE]				= &ipa_reg_route,
-	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
-	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
-	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
-	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
-	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
-	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
-	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
-	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
-	[IPA_TX_CFG]			= &ipa_reg_ipa_tx_cfg,
-	[FLAVOR_0]			= &ipa_reg_flavor_0,
-	[IDLE_INDICATION_CFG]		= &ipa_reg_idle_indication_cfg,
-	[QTIME_TIMESTAMP_CFG]		= &ipa_reg_qtime_timestamp_cfg,
-	[TIMERS_XO_CLK_DIV_CFG]		= &ipa_reg_timers_xo_clk_div_cfg,
-	[TIMERS_PULSE_GRAN_CFG]		= &ipa_reg_timers_pulse_gran_cfg,
-	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
-	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
-	[SRC_RSRC_GRP_45_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_45_rsrc_type,
-	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
-	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
-	[DST_RSRC_GRP_45_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_45_rsrc_type,
-	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
-	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
-	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
-	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
-	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
-	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
-	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
-	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
-	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
-	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
-	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
-	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
-	[ENDP_STATUS]			= &ipa_reg_endp_status,
-	[ENDP_FILTER_ROUTER_HSH_CFG]	= &ipa_reg_endp_filter_router_hsh_cfg,
-	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
-	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
-	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
-	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
-	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
-	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
-	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+static const struct reg *reg_array[] = {
+	[COMP_CFG]			= &reg_comp_cfg,
+	[CLKON_CFG]			= &reg_clkon_cfg,
+	[ROUTE]				= &reg_route,
+	[SHARED_MEM_SIZE]		= &reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &reg_state_aggr_active,
+	[LOCAL_PKT_PROC_CNTXT]		= &reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &reg_aggr_force_close,
+	[IPA_TX_CFG]			= &reg_ipa_tx_cfg,
+	[FLAVOR_0]			= &reg_flavor_0,
+	[IDLE_INDICATION_CFG]		= &reg_idle_indication_cfg,
+	[QTIME_TIMESTAMP_CFG]		= &reg_qtime_timestamp_cfg,
+	[TIMERS_XO_CLK_DIV_CFG]		= &reg_timers_xo_clk_div_cfg,
+	[TIMERS_PULSE_GRAN_CFG]		= &reg_timers_pulse_gran_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &reg_src_rsrc_grp_23_rsrc_type,
+	[SRC_RSRC_GRP_45_RSRC_TYPE]	= &reg_src_rsrc_grp_45_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &reg_dst_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_45_RSRC_TYPE]	= &reg_dst_rsrc_grp_45_rsrc_type,
+	[ENDP_INIT_CFG]			= &reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &reg_endp_init_seq,
+	[ENDP_STATUS]			= &reg_endp_status,
+	[ENDP_FILTER_ROUTER_HSH_CFG]	= &reg_endp_filter_router_hsh_cfg,
+	[IPA_IRQ_STTS]			= &reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &reg_irq_suspend_clr,
 };
 
-const struct ipa_regs ipa_regs_v4_5 = {
-	.reg_count	= ARRAY_SIZE(ipa_reg_array),
-	.reg		= ipa_reg_array,
+const struct regs ipa_regs_v4_5 = {
+	.reg_count	= ARRAY_SIZE(reg_array),
+	.reg		= reg_array,
 };
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.7.c b/drivers/net/ipa/reg/ipa_reg-v4.7.c
index 21f8a58e59a02..731824fce1d4a 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.7.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.7.c
@@ -7,7 +7,7 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-static const u32 ipa_reg_comp_cfg_fmask[] = {
+static const u32 reg_comp_cfg_fmask[] = {
 	[RAM_ARB_PRI_CLIENT_SAMP_FIX_DIS]		= BIT(0),
 	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
 	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
@@ -30,9 +30,9 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 						/* Bits 22-31 reserved */
 };
 
-IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
+REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-static const u32 ipa_reg_clkon_cfg_fmask[] = {
+static const u32 reg_clkon_cfg_fmask[] = {
 	[CLKON_RX]					= BIT(0),
 	[CLKON_PROC]					= BIT(1),
 	[TX_WRAPPER]					= BIT(2),
@@ -67,9 +67,9 @@ static const u32 ipa_reg_clkon_cfg_fmask[] = {
 	[DRBIP]						= BIT(31),
 };
 
-IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
 
-static const u32 ipa_reg_route_fmask[] = {
+static const u32 reg_route_fmask[] = {
 	[ROUTE_DIS]					= BIT(0),
 	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
 	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
@@ -80,24 +80,24 @@ static const u32 ipa_reg_route_fmask[] = {
 						/* Bits 25-31 reserved */
 };
 
-IPA_REG_FIELDS(ROUTE, route, 0x00000048);
+REG_FIELDS(ROUTE, route, 0x00000048);
 
-static const u32 ipa_reg_shared_mem_size_fmask[] = {
+static const u32 reg_shared_mem_size_fmask[] = {
 	[MEM_SIZE]					= GENMASK(15, 0),
 	[MEM_BADDR]					= GENMASK(31, 16),
 };
 
-IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+static const u32 reg_qsb_max_writes_fmask[] = {
 	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
 						/* Bits 8-31 reserved */
 };
 
-IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+static const u32 reg_qsb_max_reads_fmask[] = {
 	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
 						/* Bits 8-15 reserved */
@@ -105,9 +105,9 @@ static const u32 ipa_reg_qsb_max_reads_fmask[] = {
 	[GEN_QMB_1_MAX_READS_BEATS]			= GENMASK(31, 24),
 };
 
-IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
 
-static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+static const u32 reg_filt_rout_hash_en_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -118,9 +118,9 @@ static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
 
-static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+static const u32 reg_filt_rout_hash_flush_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -131,23 +131,23 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
+REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
 
-static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+static const u32 reg_local_pkt_proc_cntxt_fmask[] = {
 	[IPA_BASE_ADDR]					= GENMASK(17, 0),
 						/* Bits 18-31 reserved */
 };
 
 /* Offset must be a multiple of 8 */
-IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
+REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
-static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
+static const u32 reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 0-1 reserved */
 	[PREFETCH_ALMOST_EMPTY_SIZE_TX0]		= GENMASK(5, 2),
 	[DMAW_SCND_OUTSD_PRED_THRESHOLD]		= GENMASK(9, 6),
@@ -160,9 +160,9 @@ static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 19-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
-static const u32 ipa_reg_flavor_0_fmask[] = {
+static const u32 reg_flavor_0_fmask[] = {
 	[MAX_PIPES]					= GENMASK(3, 0),
 						/* Bits 4-7 reserved */
 	[MAX_CONS_PIPES]				= GENMASK(12, 8),
@@ -173,17 +173,17 @@ static const u32 ipa_reg_flavor_0_fmask[] = {
 						/* Bits 28-31 reserved */
 };
 
-IPA_REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
+REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
 
-static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
+static const u32 reg_idle_indication_cfg_fmask[] = {
 	[ENTER_IDLE_DEBOUNCE_THRESH]			= GENMASK(15, 0),
 	[CONST_NON_IDLE_ENABLE]				= BIT(16),
 						/* Bits 17-31 reserved */
 };
 
-IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
 
-static const u32 ipa_reg_qtime_timestamp_cfg_fmask[] = {
+static const u32 reg_qtime_timestamp_cfg_fmask[] = {
 	[DPL_TIMESTAMP_LSB]				= GENMASK(4, 0),
 						/* Bits 5-6 reserved */
 	[DPL_TIMESTAMP_SEL]				= BIT(7),
@@ -193,25 +193,25 @@ static const u32 ipa_reg_qtime_timestamp_cfg_fmask[] = {
 						/* Bits 21-31 reserved */
 };
 
-IPA_REG_FIELDS(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+REG_FIELDS(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
 
-static const u32 ipa_reg_timers_xo_clk_div_cfg_fmask[] = {
+static const u32 reg_timers_xo_clk_div_cfg_fmask[] = {
 	[DIV_VALUE]					= GENMASK(8, 0),
 						/* Bits 9-30 reserved */
 	[DIV_ENABLE]					= BIT(31),
 };
 
-IPA_REG_FIELDS(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+REG_FIELDS(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
 
-static const u32 ipa_reg_timers_pulse_gran_cfg_fmask[] = {
+static const u32 reg_timers_pulse_gran_cfg_fmask[] = {
 	[PULSE_GRAN_0]					= GENMASK(2, 0),
 	[PULSE_GRAN_1]					= GENMASK(5, 3),
 	[PULSE_GRAN_2]					= GENMASK(8, 6),
 };
 
-IPA_REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
+REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
 
-static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -222,10 +222,10 @@ static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-		      0x00000400, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		  0x00000400, 0x0020);
 
-static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -236,10 +236,10 @@ static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-		      0x00000404, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		  0x00000404, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -250,10 +250,10 @@ static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-		      0x00000500, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		  0x00000500, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -264,10 +264,10 @@ static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-		      0x00000504, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		  0x00000504, 0x0020);
 
-static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+static const u32 reg_endp_init_cfg_fmask[] = {
 	[FRAG_OFFLOAD_EN]				= BIT(0),
 	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
 	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
@@ -276,16 +276,16 @@ static const u32 ipa_reg_endp_init_cfg_fmask[] = {
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-static const u32 ipa_reg_endp_init_nat_fmask[] = {
+static const u32 reg_endp_init_nat_fmask[] = {
 	[NAT_EN]					= GENMASK(1, 0),
 						/* Bits 2-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+static const u32 reg_endp_init_hdr_fmask[] = {
 	[HDR_LEN]					= GENMASK(5, 0),
 	[HDR_OFST_METADATA_VALID]			= BIT(6),
 	[HDR_OFST_METADATA]				= GENMASK(12, 7),
@@ -298,9 +298,9 @@ static const u32 ipa_reg_endp_init_hdr_fmask[] = {
 	[HDR_OFST_METADATA_MSB]				= GENMASK(31, 30),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+static const u32 reg_endp_init_hdr_ext_fmask[] = {
 	[HDR_ENDIANNESS]				= BIT(0),
 	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
 	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
@@ -314,12 +314,12 @@ static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
 						/* Bits 22-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
-	       0x00000818, 0x0070);
+REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	   0x00000818, 0x0070);
 
-static const u32 ipa_reg_endp_init_mode_fmask[] = {
+static const u32 reg_endp_init_mode_fmask[] = {
 	[ENDP_MODE]					= GENMASK(2, 0),
 	[DCPH_ENABLE]					= BIT(3),
 	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
@@ -330,9 +330,9 @@ static const u32 ipa_reg_endp_init_mode_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+static const u32 reg_endp_init_aggr_fmask[] = {
 	[AGGR_EN]					= GENMASK(1, 0),
 	[AGGR_TYPE]					= GENMASK(4, 2),
 	[BYTE_LIMIT]					= GENMASK(10, 5),
@@ -347,27 +347,27 @@ static const u32 ipa_reg_endp_init_aggr_fmask[] = {
 						/* Bits 28-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
 
-static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+static const u32 reg_endp_init_hol_block_en_fmask[] = {
 	[HOL_BLOCK_EN]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-		      0x0000082c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		  0x0000082c, 0x0070);
 
-static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+static const u32 reg_endp_init_hol_block_timer_fmask[] = {
 	[TIMER_LIMIT]					= GENMASK(4, 0),
 						/* Bits 5-7 reserved */
 	[TIMER_GRAN_SEL]				= BIT(8),
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-		      0x00000830, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		  0x00000830, 0x0070);
 
-static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+static const u32 reg_endp_init_deaggr_fmask[] = {
 	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
 	[SYSPIPE_ERR_DETECTION]				= BIT(6),
 	[PACKET_OFFSET_VALID]				= BIT(7),
@@ -377,24 +377,23 @@ static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
 	[MAX_PACKET_LEN]				= GENMASK(31, 16),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+static const u32 reg_endp_init_rsrc_grp_fmask[] = {
 	[ENDP_RSRC_GRP]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
-		      0x00000838, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
 
-static const u32 ipa_reg_endp_init_seq_fmask[] = {
+static const u32 reg_endp_init_seq_fmask[] = {
 	[SEQ_TYPE]					= GENMASK(7, 0),
 						/* Bits 8-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
 
-static const u32 ipa_reg_endp_status_fmask[] = {
+static const u32 reg_endp_status_fmask[] = {
 	[STATUS_EN]					= BIT(0),
 	[STATUS_ENDP]					= GENMASK(5, 1),
 						/* Bits 6-8 reserved */
@@ -402,9 +401,9 @@ static const u32 ipa_reg_endp_status_fmask[] = {
 						/* Bits 10-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
 
-static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
+static const u32 reg_endp_filter_router_hsh_cfg_fmask[] = {
 	[FILTER_HASH_MSK_SRC_ID]			= BIT(0),
 	[FILTER_HASH_MSK_SRC_IP]			= BIT(1),
 	[FILTER_HASH_MSK_DST_IP]			= BIT(2),
@@ -425,83 +424,83 @@ static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
 						/* Bits 23-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
-		      0x0000085c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+		  0x0000085c, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
 
-static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+static const u32 reg_ipa_irq_uc_fmask[] = {
 	[UC_INTR]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
-	       0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	   0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
-	       0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	   0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
-	       0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	   0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
 
-static const struct ipa_reg *ipa_reg_array[] = {
-	[COMP_CFG]			= &ipa_reg_comp_cfg,
-	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
-	[ROUTE]				= &ipa_reg_route,
-	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
-	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
-	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
-	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
-	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
-	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
-	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
-	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
-	[IPA_TX_CFG]			= &ipa_reg_ipa_tx_cfg,
-	[FLAVOR_0]			= &ipa_reg_flavor_0,
-	[IDLE_INDICATION_CFG]		= &ipa_reg_idle_indication_cfg,
-	[QTIME_TIMESTAMP_CFG]		= &ipa_reg_qtime_timestamp_cfg,
-	[TIMERS_XO_CLK_DIV_CFG]		= &ipa_reg_timers_xo_clk_div_cfg,
-	[TIMERS_PULSE_GRAN_CFG]		= &ipa_reg_timers_pulse_gran_cfg,
-	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
-	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
-	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
-	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
-	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
-	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
-	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
-	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
-	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
-	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
-	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
-	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
-	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
-	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
-	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
-	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
-	[ENDP_STATUS]			= &ipa_reg_endp_status,
-	[ENDP_FILTER_ROUTER_HSH_CFG]	= &ipa_reg_endp_filter_router_hsh_cfg,
-	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
-	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
-	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
-	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
-	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
-	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
-	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+static const struct reg *reg_array[] = {
+	[COMP_CFG]			= &reg_comp_cfg,
+	[CLKON_CFG]			= &reg_clkon_cfg,
+	[ROUTE]				= &reg_route,
+	[SHARED_MEM_SIZE]		= &reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &reg_state_aggr_active,
+	[LOCAL_PKT_PROC_CNTXT]		= &reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &reg_aggr_force_close,
+	[IPA_TX_CFG]			= &reg_ipa_tx_cfg,
+	[FLAVOR_0]			= &reg_flavor_0,
+	[IDLE_INDICATION_CFG]		= &reg_idle_indication_cfg,
+	[QTIME_TIMESTAMP_CFG]		= &reg_qtime_timestamp_cfg,
+	[TIMERS_XO_CLK_DIV_CFG]		= &reg_timers_xo_clk_div_cfg,
+	[TIMERS_PULSE_GRAN_CFG]		= &reg_timers_pulse_gran_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &reg_src_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &reg_dst_rsrc_grp_23_rsrc_type,
+	[ENDP_INIT_CFG]			= &reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &reg_endp_init_seq,
+	[ENDP_STATUS]			= &reg_endp_status,
+	[ENDP_FILTER_ROUTER_HSH_CFG]	= &reg_endp_filter_router_hsh_cfg,
+	[IPA_IRQ_STTS]			= &reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &reg_irq_suspend_clr,
 };
 
-const struct ipa_regs ipa_regs_v4_7 = {
-	.reg_count	= ARRAY_SIZE(ipa_reg_array),
-	.reg		= ipa_reg_array,
+const struct regs ipa_regs_v4_7 = {
+	.reg_count	= ARRAY_SIZE(reg_array),
+	.reg		= reg_array,
 };
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
index 1f67a03fe5992..01f87b5290e01 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.9.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -7,7 +7,7 @@
 #include "../ipa.h"
 #include "../ipa_reg.h"
 
-static const u32 ipa_reg_comp_cfg_fmask[] = {
+static const u32 reg_comp_cfg_fmask[] = {
 	[RAM_ARB_PRI_CLIENT_SAMP_FIX_DIS]		= BIT(0),
 	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
 	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
@@ -35,9 +35,9 @@ static const u32 ipa_reg_comp_cfg_fmask[] = {
 	[GEN_QMB_0_DYNAMIC_ASIZE]			= BIT(31),
 };
 
-IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
+REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
 
-static const u32 ipa_reg_clkon_cfg_fmask[] = {
+static const u32 reg_clkon_cfg_fmask[] = {
 	[CLKON_RX]					= BIT(0),
 	[CLKON_PROC]					= BIT(1),
 	[TX_WRAPPER]					= BIT(2),
@@ -72,9 +72,9 @@ static const u32 ipa_reg_clkon_cfg_fmask[] = {
 	[DRBIP]						= BIT(31),
 };
 
-IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
 
-static const u32 ipa_reg_route_fmask[] = {
+static const u32 reg_route_fmask[] = {
 	[ROUTE_DIS]					= BIT(0),
 	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
 	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
@@ -85,24 +85,24 @@ static const u32 ipa_reg_route_fmask[] = {
 						/* Bits 25-31 reserved */
 };
 
-IPA_REG_FIELDS(ROUTE, route, 0x00000048);
+REG_FIELDS(ROUTE, route, 0x00000048);
 
-static const u32 ipa_reg_shared_mem_size_fmask[] = {
+static const u32 reg_shared_mem_size_fmask[] = {
 	[MEM_SIZE]					= GENMASK(15, 0),
 	[MEM_BADDR]					= GENMASK(31, 16),
 };
 
-IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
 
-static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+static const u32 reg_qsb_max_writes_fmask[] = {
 	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
 						/* Bits 8-31 reserved */
 };
 
-IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
 
-static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+static const u32 reg_qsb_max_reads_fmask[] = {
 	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
 	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
 						/* Bits 8-15 reserved */
@@ -110,9 +110,9 @@ static const u32 ipa_reg_qsb_max_reads_fmask[] = {
 	[GEN_QMB_1_MAX_READS_BEATS]			= GENMASK(31, 24),
 };
 
-IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
 
-static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+static const u32 reg_filt_rout_hash_en_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -123,9 +123,9 @@ static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
 
-static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+static const u32 reg_filt_rout_hash_flush_fmask[] = {
 	[IPV6_ROUTER_HASH]				= BIT(0),
 						/* Bits 1-3 reserved */
 	[IPV6_FILTER_HASH]				= BIT(4),
@@ -136,23 +136,23 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 						/* Bits 13-31 reserved */
 };
 
-IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
+REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
 
-static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+static const u32 reg_local_pkt_proc_cntxt_fmask[] = {
 	[IPA_BASE_ADDR]					= GENMASK(17, 0),
 						/* Bits 18-31 reserved */
 };
 
 /* Offset must be a multiple of 8 */
-IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
+REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
-static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
+static const u32 reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 0-1 reserved */
 	[PREFETCH_ALMOST_EMPTY_SIZE_TX0]		= GENMASK(5, 2),
 	[DMAW_SCND_OUTSD_PRED_THRESHOLD]		= GENMASK(9, 6),
@@ -165,9 +165,9 @@ static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 19-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
 
-static const u32 ipa_reg_flavor_0_fmask[] = {
+static const u32 reg_flavor_0_fmask[] = {
 	[MAX_PIPES]					= GENMASK(3, 0),
 						/* Bits 4-7 reserved */
 	[MAX_CONS_PIPES]				= GENMASK(12, 8),
@@ -178,17 +178,17 @@ static const u32 ipa_reg_flavor_0_fmask[] = {
 						/* Bits 28-31 reserved */
 };
 
-IPA_REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
+REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
 
-static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
+static const u32 reg_idle_indication_cfg_fmask[] = {
 	[ENTER_IDLE_DEBOUNCE_THRESH]			= GENMASK(15, 0),
 	[CONST_NON_IDLE_ENABLE]				= BIT(16),
 						/* Bits 17-31 reserved */
 };
 
-IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
 
-static const u32 ipa_reg_qtime_timestamp_cfg_fmask[] = {
+static const u32 reg_qtime_timestamp_cfg_fmask[] = {
 	[DPL_TIMESTAMP_LSB]				= GENMASK(4, 0),
 						/* Bits 5-6 reserved */
 	[DPL_TIMESTAMP_SEL]				= BIT(7),
@@ -198,25 +198,25 @@ static const u32 ipa_reg_qtime_timestamp_cfg_fmask[] = {
 						/* Bits 21-31 reserved */
 };
 
-IPA_REG_FIELDS(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+REG_FIELDS(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
 
-static const u32 ipa_reg_timers_xo_clk_div_cfg_fmask[] = {
+static const u32 reg_timers_xo_clk_div_cfg_fmask[] = {
 	[DIV_VALUE]					= GENMASK(8, 0),
 						/* Bits 9-30 reserved */
 	[DIV_ENABLE]					= BIT(31),
 };
 
-IPA_REG_FIELDS(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+REG_FIELDS(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
 
-static const u32 ipa_reg_timers_pulse_gran_cfg_fmask[] = {
+static const u32 reg_timers_pulse_gran_cfg_fmask[] = {
 	[PULSE_GRAN_0]					= GENMASK(2, 0),
 	[PULSE_GRAN_1]					= GENMASK(5, 3),
 	[PULSE_GRAN_2]					= GENMASK(8, 6),
 };
 
-IPA_REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
+REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
 
-static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -227,10 +227,10 @@ static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
-		      0x00000400, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		  0x00000400, 0x0020);
 
-static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -241,10 +241,10 @@ static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
-		      0x00000404, 0x0020);
+REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		  0x00000404, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -255,10 +255,10 @@ static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
-		      0x00000500, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		  0x00000500, 0x0020);
 
-static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+static const u32 reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 	[X_MIN_LIM]					= GENMASK(5, 0),
 						/* Bits 6-7 reserved */
 	[X_MAX_LIM]					= GENMASK(13, 8),
@@ -269,10 +269,10 @@ static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 						/* Bits 30-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
-		      0x00000504, 0x0020);
+REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		  0x00000504, 0x0020);
 
-static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+static const u32 reg_endp_init_cfg_fmask[] = {
 	[FRAG_OFFLOAD_EN]				= BIT(0),
 	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
 	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
@@ -281,16 +281,16 @@ static const u32 ipa_reg_endp_init_cfg_fmask[] = {
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-static const u32 ipa_reg_endp_init_nat_fmask[] = {
+static const u32 reg_endp_init_nat_fmask[] = {
 	[NAT_EN]					= GENMASK(1, 0),
 						/* Bits 2-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+static const u32 reg_endp_init_hdr_fmask[] = {
 	[HDR_LEN]					= GENMASK(5, 0),
 	[HDR_OFST_METADATA_VALID]			= BIT(6),
 	[HDR_OFST_METADATA]				= GENMASK(12, 7),
@@ -302,9 +302,9 @@ static const u32 ipa_reg_endp_init_hdr_fmask[] = {
 	[HDR_OFST_METADATA_MSB]				= GENMASK(31, 30),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
 
-static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+static const u32 reg_endp_init_hdr_ext_fmask[] = {
 	[HDR_ENDIANNESS]				= BIT(0),
 	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
 	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
@@ -318,12 +318,12 @@ static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
 						/* Bits 22-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
-	       0x00000818, 0x0070);
+REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	   0x00000818, 0x0070);
 
-static const u32 ipa_reg_endp_init_mode_fmask[] = {
+static const u32 reg_endp_init_mode_fmask[] = {
 	[ENDP_MODE]					= GENMASK(2, 0),
 	[DCPH_ENABLE]					= BIT(3),
 	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
@@ -335,9 +335,9 @@ static const u32 ipa_reg_endp_init_mode_fmask[] = {
 						/* Bit 31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
 
-static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+static const u32 reg_endp_init_aggr_fmask[] = {
 	[AGGR_EN]					= GENMASK(1, 0),
 	[AGGR_TYPE]					= GENMASK(4, 2),
 	[BYTE_LIMIT]					= GENMASK(10, 5),
@@ -352,27 +352,27 @@ static const u32 ipa_reg_endp_init_aggr_fmask[] = {
 						/* Bits 28-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
 
-static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+static const u32 reg_endp_init_hol_block_en_fmask[] = {
 	[HOL_BLOCK_EN]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
-		      0x0000082c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		  0x0000082c, 0x0070);
 
-static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+static const u32 reg_endp_init_hol_block_timer_fmask[] = {
 	[TIMER_LIMIT]					= GENMASK(4, 0),
 						/* Bits 5-7 reserved */
 	[TIMER_GRAN_SEL]				= BIT(8),
 						/* Bits 9-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
-		      0x00000830, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		  0x00000830, 0x0070);
 
-static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+static const u32 reg_endp_init_deaggr_fmask[] = {
 	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
 	[SYSPIPE_ERR_DETECTION]				= BIT(6),
 	[PACKET_OFFSET_VALID]				= BIT(7),
@@ -382,24 +382,23 @@ static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
 	[MAX_PACKET_LEN]				= GENMASK(31, 16),
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
 
-static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+static const u32 reg_endp_init_rsrc_grp_fmask[] = {
 	[ENDP_RSRC_GRP]					= GENMASK(1, 0),
 						/* Bits 2-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
-		      0x00000838, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp, 0x00000838, 0x0070);
 
-static const u32 ipa_reg_endp_init_seq_fmask[] = {
+static const u32 reg_endp_init_seq_fmask[] = {
 	[SEQ_TYPE]					= GENMASK(7, 0),
 						/* Bits 8-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
 
-static const u32 ipa_reg_endp_status_fmask[] = {
+static const u32 reg_endp_status_fmask[] = {
 	[STATUS_EN]					= BIT(0),
 	[STATUS_ENDP]					= GENMASK(5, 1),
 						/* Bits 6-8 reserved */
@@ -407,9 +406,9 @@ static const u32 ipa_reg_endp_status_fmask[] = {
 						/* Bits 10-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
 
-static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
+static const u32 reg_endp_filter_router_hsh_cfg_fmask[] = {
 	[FILTER_HASH_MSK_SRC_ID]			= BIT(0),
 	[FILTER_HASH_MSK_SRC_IP]			= BIT(1),
 	[FILTER_HASH_MSK_DST_IP]			= BIT(2),
@@ -430,83 +429,83 @@ static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
 						/* Bits 23-31 reserved */
 };
 
-IPA_REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
-		      0x0000085c, 0x0070);
+REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+		  0x0000085c, 0x0070);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00004008 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00004008 + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000400c + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_EN, ipa_irq_en, 0x0000400c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
-IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00004010 + 0x1000 * GSI_EE_AP);
+REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00004010 + 0x1000 * GSI_EE_AP);
 
-static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+static const u32 reg_ipa_irq_uc_fmask[] = {
 	[UC_INTR]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000401c + 0x1000 * GSI_EE_AP);
+REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000401c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
-	       0x00004030 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	   0x00004030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
-	       0x00004034 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	   0x00004034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
-	       0x00004038 + 0x1000 * GSI_EE_AP, 0x0004);
+REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	   0x00004038 + 0x1000 * GSI_EE_AP, 0x0004);
 
-static const struct ipa_reg *ipa_reg_array[] = {
-	[COMP_CFG]			= &ipa_reg_comp_cfg,
-	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
-	[ROUTE]				= &ipa_reg_route,
-	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
-	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
-	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
-	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
-	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
-	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
-	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
-	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
-	[IPA_TX_CFG]			= &ipa_reg_ipa_tx_cfg,
-	[FLAVOR_0]			= &ipa_reg_flavor_0,
-	[IDLE_INDICATION_CFG]		= &ipa_reg_idle_indication_cfg,
-	[QTIME_TIMESTAMP_CFG]		= &ipa_reg_qtime_timestamp_cfg,
-	[TIMERS_XO_CLK_DIV_CFG]		= &ipa_reg_timers_xo_clk_div_cfg,
-	[TIMERS_PULSE_GRAN_CFG]		= &ipa_reg_timers_pulse_gran_cfg,
-	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
-	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
-	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
-	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
-	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
-	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
-	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
-	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
-	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
-	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
-	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
-	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
-	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
-	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
-	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
-	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
-	[ENDP_STATUS]			= &ipa_reg_endp_status,
-	[ENDP_FILTER_ROUTER_HSH_CFG]	= &ipa_reg_endp_filter_router_hsh_cfg,
-	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
-	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
-	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
-	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
-	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
-	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
-	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+static const struct reg *reg_array[] = {
+	[COMP_CFG]			= &reg_comp_cfg,
+	[CLKON_CFG]			= &reg_clkon_cfg,
+	[ROUTE]				= &reg_route,
+	[SHARED_MEM_SIZE]		= &reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &reg_state_aggr_active,
+	[LOCAL_PKT_PROC_CNTXT]		= &reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &reg_aggr_force_close,
+	[IPA_TX_CFG]			= &reg_ipa_tx_cfg,
+	[FLAVOR_0]			= &reg_flavor_0,
+	[IDLE_INDICATION_CFG]		= &reg_idle_indication_cfg,
+	[QTIME_TIMESTAMP_CFG]		= &reg_qtime_timestamp_cfg,
+	[TIMERS_XO_CLK_DIV_CFG]		= &reg_timers_xo_clk_div_cfg,
+	[TIMERS_PULSE_GRAN_CFG]		= &reg_timers_pulse_gran_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &reg_src_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &reg_dst_rsrc_grp_23_rsrc_type,
+	[ENDP_INIT_CFG]			= &reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &reg_endp_init_seq,
+	[ENDP_STATUS]			= &reg_endp_status,
+	[ENDP_FILTER_ROUTER_HSH_CFG]	= &reg_endp_filter_router_hsh_cfg,
+	[IPA_IRQ_STTS]			= &reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &reg_irq_suspend_clr,
 };
 
-const struct ipa_regs ipa_regs_v4_9 = {
-	.reg_count	= ARRAY_SIZE(ipa_reg_array),
-	.reg		= ipa_reg_array,
+const struct regs ipa_regs_v4_9 = {
+	.reg_count	= ARRAY_SIZE(reg_array),
+	.reg		= reg_array,
 };
-- 
2.34.1

