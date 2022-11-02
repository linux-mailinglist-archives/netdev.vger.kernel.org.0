Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B0F617071
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 23:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbiKBWL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 18:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiKBWLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 18:11:49 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2A6BC96
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 15:11:47 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id r81so7547641iod.2
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 15:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=44inpgxMtLGpYTBDTKxPiEfpRDa0k0SEfGcjuP68SFA=;
        b=E8zRVS9F27rajNfZCJWIwaTxqcrfrRyozWVG3XQoiJ8geI02YDsiE/2sOfBxZJVxVa
         77XMug2VsyzU22K+Psprfc76f4gTh5GroQQql8AS8/rwlPm8ohIngsEcqrVz0R0J973P
         VVDPDtnMWZShk+x9LRnIyJnMzWpM5ohFyjVUCBxfCdlUUbHR1JuIye7p7WGSErPbwF2L
         K8ZrHNAt28nJUo4rcc4+S7nn/hyabbD0IzRm8pVGxB8lRf1XUSK8K1WI9W5vrd53dC4U
         IygDp9EIwZOGARqXKtDOows34n75OHdnCz1DrRfPS8RpUVUknEvaIxW81hutDvsFicNy
         CKdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=44inpgxMtLGpYTBDTKxPiEfpRDa0k0SEfGcjuP68SFA=;
        b=r7dkyePErsAjXkGneyI6uauNMn/TWS0DLuwhKnV+vi5xizC8JlEjBYqXQhfzxGUajS
         fWZ+eOySLGVdtRLGrFOiMTw3WUSmHpiXw8XDiemQQ+h23dLGgg4VvetiP/CST3kQKTSr
         n3ErwxoDZXT8sgdjifx6U5cwvB9ZjbHLqtkA0HHIilDxHREI6UTTXROiQHqEH5AJecNX
         xZAPbQeiIabLFxaE20kH+oohUqrE6iEI1H2EoPP81TmDtWdVxkZ1Jyn5+xewFgoCdh+b
         zmsFEBZTUTOTZwguGaXBETdB22+2sWdOgDm6qpsQUKsFFd3DeU/4h1KidT4ptN7BmKDO
         fufQ==
X-Gm-Message-State: ACrzQf2nUgZDdH0I1klJCoNjGOC9owsXdkU5Dpv85f+d1c2WmdxE8uxz
        Hm34bFSmuBp+XiT5pNTdCwHhTA==
X-Google-Smtp-Source: AMsMyM7BQ9X4OlwxKp6Z0UVt5tWSmJ3HSKggYZ99QQCfxwC6Gjbz86LMNO/ALVMBbrSkJMN8xXEHRg==
X-Received: by 2002:a05:6602:134f:b0:6a5:3fdb:574e with SMTP id i15-20020a056602134f00b006a53fdb574emr17598065iov.218.1667427107220;
        Wed, 02 Nov 2022 15:11:47 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id f8-20020a02a108000000b0037465a1dd3fsm5073974jag.156.2022.11.02.15.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 15:11:46 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/9] net: ipa: add a parameter to aggregation registers
Date:   Wed,  2 Nov 2022 17:11:33 -0500
Message-Id: <20221102221139.1091510-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102221139.1091510-1-elder@linaro.org>
References: <20221102221139.1091510-1-elder@linaro.org>
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

Starting with IPA v5.0, a single IPA instance can have more than 32
endpoints defined.  To handle this, each register that holds a
bitmap of IPA endpoints is replicated as needed to represent the
available endpoints.

To prepare for this, registers that represent endpoint IDs in a bit
mask will be defined to have a parameter, with a stride value of 4
bytes.  The first 32 endpoints are represented in the first 32-bit
register, then the next (up to) 32 endpoints at an offset 4 bytes
higher.  When accessing such a register, the endpoint ID divided
by 32 determines the offset, and the endpoint ID modulo 32 defines
the endpoint's bit position within the register.

The first two registers we'll update for this are STATE_AGGR_ACTIVE
and AGGR_FORCE_CLOSE.

Until more than 32 endpoints are supported, this change has no
practical effect.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c       | 14 ++++++++++----
 drivers/net/ipa/reg/ipa_reg-v3.1.c   |  4 ++--
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c |  4 ++--
 drivers/net/ipa/reg/ipa_reg-v4.11.c  |  4 ++--
 drivers/net/ipa/reg/ipa_reg-v4.2.c   |  4 ++--
 drivers/net/ipa/reg/ipa_reg-v4.5.c   |  4 ++--
 drivers/net/ipa/reg/ipa_reg-v4.9.c   |  4 ++--
 7 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 2a6184ea8f5ca..32559ed498c19 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -350,29 +350,35 @@ ipa_endpoint_program_delay(struct ipa_endpoint *endpoint, bool enable)
 
 static bool ipa_endpoint_aggr_active(struct ipa_endpoint *endpoint)
 {
-	u32 mask = BIT(endpoint->endpoint_id);
+	u32 endpoint_id = endpoint->endpoint_id;
+	u32 mask = BIT(endpoint_id % 32);
 	struct ipa *ipa = endpoint->ipa;
+	u32 unit = endpoint_id / 32;
 	const struct ipa_reg *reg;
 	u32 val;
 
+	/* This works until we actually have more than 32 endpoints */
 	WARN_ON(!(mask & ipa->available));
 
 	reg = ipa_reg(ipa, STATE_AGGR_ACTIVE);
-	val = ioread32(ipa->reg_virt + ipa_reg_offset(reg));
+	val = ioread32(ipa->reg_virt + ipa_reg_n_offset(reg, unit));
 
 	return !!(val & mask);
 }
 
 static void ipa_endpoint_force_close(struct ipa_endpoint *endpoint)
 {
-	u32 mask = BIT(endpoint->endpoint_id);
+	u32 endpoint_id = endpoint->endpoint_id;
+	u32 mask = BIT(endpoint_id % 32);
 	struct ipa *ipa = endpoint->ipa;
+	u32 unit = endpoint_id / 32;
 	const struct ipa_reg *reg;
 
+	/* This works until we actually have more than 32 endpoints */
 	WARN_ON(!(mask & ipa->available));
 
 	reg = ipa_reg(ipa, AGGR_FORCE_CLOSE);
-	iowrite32(mask, ipa->reg_virt + ipa_reg_offset(reg));
+	iowrite32(mask, ipa->reg_virt + ipa_reg_n_offset(reg, unit));
 }
 
 /**
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
index 0d002c3c38a26..0b6edc2912bd3 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
@@ -103,7 +103,7 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x0000090);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c);
+IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c, 0x0004);
 
 IPA_REG(IPA_BCR, ipa_bcr, 0x000001d0);
 
@@ -116,7 +116,7 @@ static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
 IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
+IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
 static const u32 ipa_reg_counter_cfg_fmask[] = {
 	[EOT_COAL_GRANULARITY]				= GENMASK(3, 0),
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
index 6e2f939b18f19..10f62f6aaf7a4 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -108,7 +108,7 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x0000090);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c);
+IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x0000010c, 0x0004);
 
 IPA_REG(IPA_BCR, ipa_bcr, 0x000001d0);
 
@@ -121,7 +121,7 @@ static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
 IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
+IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
 static const u32 ipa_reg_counter_cfg_fmask[] = {
 						/* Bits 0-3 reserved */
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
index 8fd36569bb9f8..113a25c006da1 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.11.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -140,7 +140,7 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
+IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
 
 static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
 	[IPA_BASE_ADDR]					= GENMASK(17, 0),
@@ -151,7 +151,7 @@ static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
 IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
+IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
 static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 0-1 reserved */
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
index f8e78e1907c83..c93f2da9290fc 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.2.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -132,7 +132,7 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
+IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
 
 IPA_REG(IPA_BCR, ipa_bcr, 0x000001d0);
 
@@ -145,7 +145,7 @@ static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
 IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
+IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
 static const u32 ipa_reg_counter_cfg_fmask[] = {
 						/* Bits 0-3 reserved */
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
index d32b805abb11a..1615c5ead8cc1 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.5.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -134,7 +134,7 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
+IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
 
 static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
 	[IPA_BASE_ADDR]					= GENMASK(17, 0),
@@ -145,7 +145,7 @@ static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
 IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
+IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
 static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 0-1 reserved */
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
index eabbc5451937b..4efc890d31589 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.9.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -139,7 +139,7 @@ static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
 IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4);
+IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
 
 static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
 	[IPA_BASE_ADDR]					= GENMASK(17, 0),
@@ -150,7 +150,7 @@ static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
 IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec);
+IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
 
 static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
 						/* Bits 0-1 reserved */
-- 
2.34.1

