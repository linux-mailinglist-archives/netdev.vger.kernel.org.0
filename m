Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36E3456402
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhKRU1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbhKRU1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 15:27:20 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F377DC061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:24:19 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id n26so7190139pff.3
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hMf1gD24yauyF3KjKslZWaFebiMpm2AYS7vHEx/kuE4=;
        b=bryfhy3Nc6TJ17719nhq/O5sCfMOdnRykXJxQ9YepGvk5JLK83TDfVSPhR9ucyp16t
         Zz03k6JIcai4+Wzo/DaNuqbLea/sCf/OlrjfbeLXeb9z8wNPvUyI5JVgjV0kiSsPP+HP
         cmgNsUmIFo8pXtPaKiDbxDkdHRHNhDGoWAL48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hMf1gD24yauyF3KjKslZWaFebiMpm2AYS7vHEx/kuE4=;
        b=YX3R/CRvznhv17dEUf5NydhKNq0uRVecB1UfTX1fVAt+cghOhFr1kmM/6gm5OBZIcD
         zKXRUwq77JVi/yf+D3n6DQTGDj2j4anRJvTitfgVY+s4Jw5OWl+EyBVbp/xPH1oDDWdj
         qFWWFwlMuBnbVftMaYmAUNYOvotUVXUgYEni3wkwsFtQzcj/zhkWqDEunTTJj/aobeiU
         Fxwu7jU4voWwVmrPc+XW/Ns8FWUGPGrFvFkLGqy2mxe3J+v2nkXFqQOfMwKKFxHFVCtD
         G1cYVOUC1GP4UprZ/6VCrYKhC1c8DKmRpmo/XkcreYmy0ZO+g7CgLfvN1NnhbMfy1CHj
         Vr5A==
X-Gm-Message-State: AOAM5329tm+41tnmnBn6w/r+rK0tNkRO5X8PNz91p0FH67cA6GymuMNe
        sLQkKs812Crco4UPo/4wVgraLA==
X-Google-Smtp-Source: ABdhPJxKIqpIeEh5v/1ZnJSnPEj5hFi4bW/UQYeypi4NAfAxQoU+NV4DHrHpGVvINMedRZP5FQ1Glw==
X-Received: by 2002:a05:6a00:230d:b0:49f:b8ad:ae23 with SMTP id h13-20020a056a00230d00b0049fb8adae23mr17761516pfh.80.1637267059566;
        Thu, 18 Nov 2021 12:24:19 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k2sm385162pfc.9.2021.11.18.12.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 12:24:19 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] ath11k: Use memset_startat() for clearing queue descriptors
Date:   Thu, 18 Nov 2021 12:24:16 -0800
Message-Id: <20211118202416.1286046-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3154; h=from:subject; bh=Z7ww62H2LCcWjbE7PDOS85aSn8pEtYcisufGb7NuKpM=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlrZvPaK6H9IfHnqcjxvW6VHMgSx/+zSIUUBsGrBv LkmvTcGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZa2bwAKCRCJcvTf3G3AJl3SD/ 4pqvkd2z1L/ax9cY37TqcgdUqtA+JYMgutREFg1df1xVUyL5EsVAnS70cGNgGfY688VlzwH4K61UYN XCqte++H2Bfi2XOUmy5cG5cLVMno0eLpt9cMNt7URQR7oTrgQ8981uQHB0J6HEcrbv1jKBdX46EzXX s14R4t/cMGGV0DsqT4Aq+twUuWeaHNX7mYL7jDCEllw5asIe0TrZm6x7FDdAHhGGpGW9UgLPzyqdX/ GNEQZ0gNJv89AjPlYeCyP2YxFeNs4Q3KnWJ1EdOM5ArTTsbPOjYqcYK5UMjx18PWYTWB6IyAxzIJ/0 9ojSRaQbabNnn/DblIsUhEmzUcTUXAsGskbpnfa/Q16EMgyxF5r3s8I/hIL+oGzDnAqQSwW1mJyB8C xnX0gi3QzgR6kDHOFkrzrIJHO4b/lcsOZIHkN7RP/Mj34DgOmFcR9mWMBirn3tT9abIQIVbU83IC2c guZE+H0/Zh4BvIiDIsygyaOG9cb/yScax1g83Mr56XO7zGlNmjamPAtRX9Y+dpfik9P1rgJIWVBoZR 08QZpDXSW3nbYC71q4kGQQgeW5ZZnCRhJP6bwz721f5a5DSusAQmVtxpcpTFe6LgmtRAPiXgSfGGb7 wq1VyLZaDxM0twr/10q3AkOo3VYoyAUAh/MyPjd87n36C1EPX6DkRSugAVcQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_startat() so memset() doesn't get confused about writing
beyond the destination member that is intended to be the starting point
of zeroing through the end of the struct. Additionally split up a later
field-spanning memset() so that memset() can reason about the size.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ath/ath11k/hal_rx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/hal_rx.c b/drivers/net/wireless/ath/ath11k/hal_rx.c
index 329c404cfa80..0e43e215c10a 100644
--- a/drivers/net/wireless/ath/ath11k/hal_rx.c
+++ b/drivers/net/wireless/ath/ath11k/hal_rx.c
@@ -29,8 +29,7 @@ static int ath11k_hal_reo_cmd_queue_stats(struct hal_tlv_hdr *tlv,
 		  FIELD_PREP(HAL_TLV_HDR_LEN, sizeof(*desc));
 
 	desc = (struct hal_reo_get_queue_stats *)tlv->value;
-	memset(&desc->queue_addr_lo, 0,
-	       (sizeof(*desc) - sizeof(struct hal_reo_cmd_hdr)));
+	memset_startat(desc, 0, queue_addr_lo);
 
 	desc->cmd.info0 &= ~HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED;
 	if (cmd->flag & HAL_REO_CMD_FLG_NEED_STATUS)
@@ -62,8 +61,7 @@ static int ath11k_hal_reo_cmd_flush_cache(struct ath11k_hal *hal, struct hal_tlv
 		  FIELD_PREP(HAL_TLV_HDR_LEN, sizeof(*desc));
 
 	desc = (struct hal_reo_flush_cache *)tlv->value;
-	memset(&desc->cache_addr_lo, 0,
-	       (sizeof(*desc) - sizeof(struct hal_reo_cmd_hdr)));
+	memset_startat(desc, 0, cache_addr_lo);
 
 	desc->cmd.info0 &= ~HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED;
 	if (cmd->flag & HAL_REO_CMD_FLG_NEED_STATUS)
@@ -101,8 +99,7 @@ static int ath11k_hal_reo_cmd_update_rx_queue(struct hal_tlv_hdr *tlv,
 		  FIELD_PREP(HAL_TLV_HDR_LEN, sizeof(*desc));
 
 	desc = (struct hal_reo_update_rx_queue *)tlv->value;
-	memset(&desc->queue_addr_lo, 0,
-	       (sizeof(*desc) - sizeof(struct hal_reo_cmd_hdr)));
+	memset_startat(desc, 0, queue_addr_lo);
 
 	desc->cmd.info0 &= ~HAL_REO_CMD_HDR_INFO0_STATUS_REQUIRED;
 	if (cmd->flag & HAL_REO_CMD_FLG_NEED_STATUS)
@@ -764,15 +761,17 @@ void ath11k_hal_reo_qdesc_setup(void *vaddr, int tid, u32 ba_window_size,
 	 * size changes and also send WMI message to FW to change the REO
 	 * queue descriptor in Rx peer entry as part of dp_rx_tid_update.
 	 */
-	memset(ext_desc, 0, 3 * sizeof(*ext_desc));
+	memset(ext_desc, 0, sizeof(*ext_desc));
 	ath11k_hal_reo_set_desc_hdr(&ext_desc->desc_hdr, HAL_DESC_REO_OWNED,
 				    HAL_DESC_REO_QUEUE_EXT_DESC,
 				    REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_1);
 	ext_desc++;
+	memset(ext_desc, 0, sizeof(*ext_desc));
 	ath11k_hal_reo_set_desc_hdr(&ext_desc->desc_hdr, HAL_DESC_REO_OWNED,
 				    HAL_DESC_REO_QUEUE_EXT_DESC,
 				    REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_2);
 	ext_desc++;
+	memset(ext_desc, 0, sizeof(*ext_desc));
 	ath11k_hal_reo_set_desc_hdr(&ext_desc->desc_hdr, HAL_DESC_REO_OWNED,
 				    HAL_DESC_REO_QUEUE_EXT_DESC,
 				    REO_QUEUE_DESC_MAGIC_DEBUG_PATTERN_3);
-- 
2.30.2

