Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB29681C2D
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjA3VDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjA3VDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:03:52 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBA813DC4
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:03:48 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id l7so3826844ilf.0
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tOyLjlWftaazOIBf1HphYUtK4tgdVdjT0p+urwc0ffk=;
        b=BRiJl/Sxqr0OJaaeJd62qJfIzmm5RIsUMo9nk/IhN4hNmOZk7/vTtKevXu1EDW7kB4
         SrBsiHcrP3nW3Tgu+qgrHJl/VrhpFu6/X6YMdENVrLH2V8Dd+gpgbWVh7bLWoX/KXRCv
         wwmiicBtD8kCLmK/ghUxR1/btNXSIcjHyb8LsQkBeGHjfcrYeE/MEVlwWR7JrA2jGZth
         Ii0CTVMycz+XYBQS81KmwlXYI0TiA+/1ppzJT5m9KXJ8Gs9Ld4WC9YHvTTRIgHfe1Mn9
         728DizukwpjTZLwaI4n+bMqBROPNk5CvOgeDjhSWDHSTmgev5Ap3UcV0yuBVt9VzFu+4
         Rn1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOyLjlWftaazOIBf1HphYUtK4tgdVdjT0p+urwc0ffk=;
        b=mMAF9IMVUxDOxkLFuotiJOajBdqM1ttu2smsSB6gnJh5xzryB28nV6zylMG48X0O0E
         XjtMEOocMoZxiidC2wOJFH6jmtrYfDP1W+9yn00NhqjB3DR6X6xdrI/50UcOTuvcDlAh
         KXHRUqB+C0Tjp6Lnk87GKzbIRsb9EO+mxjTGI469Wdc+VbFcIARK+mP8l6btzI+inRSV
         Zd7hqOpCZpA/l/FPdbCjyeieZBKG50ezcW83sYOc7aOPOMpZFGHF1IuTCRc0p971j3MO
         67NhY35EPzzqwZLoqo87s5BpxxEx49Up768ksATlI5iN9sBaP1I3eEdz/qzHQNvKJXQi
         4LSQ==
X-Gm-Message-State: AO0yUKUTbShCQuYl18PxU5cWPhR1Jhl4m6IfQBZqpgOlxsTWN7S64dDL
        lSUyeGtiVCW41D9ooNeQBdFCnA==
X-Google-Smtp-Source: AK7set/fvnnk/+ZR+ye7CyMzj6m4N5Gna08GsVWs8CaUWQN281Ph1JGpvK8l76be6RAd7njuZGzMMA==
X-Received: by 2002:a05:6e02:1485:b0:310:ef5d:de8a with SMTP id n5-20020a056e02148500b00310ef5dde8amr6327006ilk.27.1675112627758;
        Mon, 30 Jan 2023 13:03:47 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id a30-20020a02735e000000b003aef8fded9asm1992046jae.127.2023.01.30.13.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:03:26 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/8] net: ipa: define IPA v5.0+ registers
Date:   Mon, 30 Jan 2023 15:01:53 -0600
Message-Id: <20230130210158.4126129-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130210158.4126129-1-elder@linaro.org>
References: <20230130210158.4126129-1-elder@linaro.org>
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

Define some new registers that appear starting with IPA v5.0, along
with enumerated types identifying their fields.  Code that uses
these will be added by upcoming patches.

Most of the new registers are related to filter and routing tables,
and in particular, their "hashed" variant.  These tables are better
described as "cached", where a hash value determines which entries
are cached.  From now on, naming related to this functionality will
use "cache" instead of "hash", and that is reflected in these new
register names.  Some registers for managing these caches and their
contents have changed as well.

A few other new field definitions for registers (unrelated to table
caches) are also defined.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.h | 43 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index b1a3c2c7e1674..82d43eca170ec 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2022 Linaro Ltd.
+ * Copyright (C) 2018-2023 Linaro Ltd.
  */
 #ifndef _IPA_REG_H_
 #define _IPA_REG_H_
@@ -59,8 +59,10 @@ enum ipa_reg_id {
 	SHARED_MEM_SIZE,
 	QSB_MAX_WRITES,
 	QSB_MAX_READS,
-	FILT_ROUT_HASH_EN,
-	FILT_ROUT_HASH_FLUSH,
+	FILT_ROUT_HASH_EN,				/* Not IPA v5.0+ */
+	FILT_ROUT_CACHE_CFG,				/* IPA v5.0+ */
+	FILT_ROUT_HASH_FLUSH,				/* Not IPA v5.0+ */
+	FILT_ROUT_CACHE_FLUSH,				/* IPA v5.0+ */
 	STATE_AGGR_ACTIVE,
 	IPA_BCR,					/* Not IPA v4.5+ */
 	LOCAL_PKT_PROC_CNTXT,
@@ -95,7 +97,9 @@ enum ipa_reg_id {
 	ENDP_INIT_SEQ,			/* TX only */
 	ENDP_STATUS,
 	ENDP_FILTER_ROUTER_HSH_CFG,			/* Not IPA v4.2 */
-	/* The IRQ registers are only used for GSI_EE_AP */
+	ENDP_FILTER_CACHE_CFG,				/* IPA v5.0+ */
+	ENDP_ROUTER_CACHE_CFG,				/* IPA v5.0+ */
+	/* The IRQ registers that follow are only used for GSI_EE_AP */
 	IPA_IRQ_STTS,
 	IPA_IRQ_EN,
 	IPA_IRQ_CLR,
@@ -251,14 +255,28 @@ enum ipa_reg_qsb_max_reads_field_id {
 	GEN_QMB_1_MAX_READS_BEATS,			/* IPA v4.0+ */
 };
 
+/* FILT_ROUT_CACHE_CFG register */
+enum ipa_reg_filt_rout_cache_cfg_field_id {
+	ROUTER_CACHE_EN,
+	FILTER_CACHE_EN,
+	LOW_PRI_HASH_HIT_DISABLE,
+	LRU_EVICTION_THRESHOLD,
+};
+
 /* FILT_ROUT_HASH_EN and FILT_ROUT_HASH_FLUSH registers */
-enum ipa_reg_rout_hash_field_id {
+enum ipa_reg_filt_rout_hash_field_id {
 	IPV6_ROUTER_HASH,
 	IPV6_FILTER_HASH,
 	IPV4_ROUTER_HASH,
 	IPV4_FILTER_HASH,
 };
 
+/* FILT_ROUT_CACHE_FLUSH register */
+enum ipa_reg_filt_rout_cache_field_id {
+	ROUTER_CACHE,
+	FILTER_CACHE,
+};
+
 /* BCR register */
 enum ipa_bcr_compat {
 	BCR_CMDQ_L_LACK_ONE_ENTRY		= 0x0,	/* Not IPA v4.2+ */
@@ -298,6 +316,7 @@ enum ipa_reg_ipa_tx_cfg_field_id {
 	DUAL_TX_ENABLE,					/* v4.5+ */
 	SSPND_PA_NO_START_STATE,			/* v4,2+, not v4.5 */
 	SSPND_PA_NO_BQ_STATE,				/* v4.2 only */
+	HOLB_STICKY_DROP_EN,				/* v5.0+ */
 };
 
 /* FLAVOR_0 register */
@@ -333,6 +352,7 @@ enum ipa_reg_timers_pulse_gran_cfg_field_id {
 	PULSE_GRAN_0,
 	PULSE_GRAN_1,
 	PULSE_GRAN_2,
+	PULSE_GRAN_3,
 };
 
 /* Values for IPA_GRAN_x fields of TIMERS_PULSE_GRAN_CFG */
@@ -415,6 +435,8 @@ enum ipa_reg_endp_init_hdr_ext_field_id {
 	HDR_TOTAL_LEN_OR_PAD_OFFSET_MSB,		/* v4.5+ */
 	HDR_OFST_PKT_SIZE_MSB,				/* v4.5+ */
 	HDR_ADDITIONAL_CONST_LEN_MSB,			/* v4.5+ */
+	HDR_BYTES_TO_REMOVE_VALID,			/* v5.0+ */
+	HDR_BYTES_TO_REMOVE,				/* v5.0+ */
 };
 
 /* ENDP_INIT_MODE register */
@@ -573,6 +595,17 @@ enum ipa_reg_endp_filter_router_hsh_cfg_field_id {
 	ROUTER_HASH_MSK_ALL,		/* Bitwise OR of the above 6 fields */
 };
 
+/* ENDP_FILTER_CACHE_CFG and ENDP_ROUTER_CACHE_CFG registers */
+enum ipa_reg_endp_cache_cfg_field_id {
+	CACHE_MSK_SRC_ID,
+	CACHE_MSK_SRC_IP,
+	CACHE_MSK_DST_IP,
+	CACHE_MSK_SRC_PORT,
+	CACHE_MSK_DST_PORT,
+	CACHE_MSK_PROTOCOL,
+	CACHE_MSK_METADATA,
+};
+
 /* IPA_IRQ_STTS, IPA_IRQ_EN, and IPA_IRQ_CLR registers */
 /**
  * enum ipa_irq_id - Bit positions representing type of IPA IRQ
-- 
2.34.1

