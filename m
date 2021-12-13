Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892FD473796
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 23:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243795AbhLMWeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 17:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243613AbhLMWdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 17:33:40 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9C8C0617A1
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:33:39 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id k64so16181253pfd.11
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ypAqfpDLyABO9VWd+7q/zjxqivhps6ZCyCGIhUJeNUo=;
        b=HYmmpRXYw9np+KrjXksOTVvhJk0hzDZeScnf9C7zBXEwa5722xBZplzxqHkk8K+wM4
         x22paAjEOeVuthEIWSgYEmtRdyL5TKg6eREa9ytfvORoA0AaohsVTGUhnh4EB8VyJeAC
         pQT/0Unsm2FNNqR364Q9Q2aBpcGImYaZf1Y+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ypAqfpDLyABO9VWd+7q/zjxqivhps6ZCyCGIhUJeNUo=;
        b=ot5pQ4Nw1lRy3X7rTolB3aVx3nyU/HNaTYOL7rv/TkrTumVEWs09lm0GDH5+iYLt1K
         tDyKKtLJ1nNWHUDY3VC+72sCDaVciAnl31nY4qFBhASK2vYFCLUiDJ2S3/2ctYKdxd+2
         QrSfhgXJ+8n2JRI9ls8OUXU1OxDr8NYFEcEb5IglQNxrR23gQEOo2/Hfub5p0vlHY4dC
         8EN9NN9UG5bNqx/RBosvFqNkJRXRo5jf402To6WRa+h41tZNutXp99wYFbnf1ncfdM7z
         fD1lRVfNMMCb9G4V/26LojqMEzLzbk8BX7DxEy0Za8qUlo26jRQnvSABw2dOwDKdJ8fy
         rUJg==
X-Gm-Message-State: AOAM530cl7s8WePoUzbPC7ZIV0Kup/V3i+0Hgtz9c64Mf5Vd/RZQXm1U
        yBCtZQjNqkzJiVDjPOEtUxBZSw==
X-Google-Smtp-Source: ABdhPJzszKffG7hEVNrsqgjUaqXQV6JWoKj4r0PQL/u6NXJoP3YaNuhktq12bKwSnBSjLUJ1jff2Ig==
X-Received: by 2002:a05:6a00:728:b0:4b0:b1c:6fd9 with SMTP id 8-20020a056a00072800b004b00b1c6fd9mr931373pfm.27.1639434819126;
        Mon, 13 Dec 2021 14:33:39 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n6sm12607167pfa.28.2021.12.13.14.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 14:33:37 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/17] ath11k: Use memset_startat() for clearing queue descriptors
Date:   Mon, 13 Dec 2021 14:33:22 -0800
Message-Id: <20211213223331.135412-9-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211213223331.135412-1-keescook@chromium.org>
References: <20211213223331.135412-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3372; h=from:subject; bh=axAygS4thk+uvbzO1moZ1VRjcqDhXcfP4Vyjt/i9h9M=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBht8o4MSeELfzO6H9fAjm8hu3Uuu54uiFqPasTWcda Tt84i++JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYbfKOAAKCRCJcvTf3G3AJg6UD/ 9gv7gsrwjC3trNa3bqE7ASZwIKkSV3jhOCULnnlAT6TpZapvVHloCauOe9Ak3kdSyLU2+YLoH6d9oP uQssQ49+Z90FyBh5emo/KJCJ4sMgBRpll+uOJfCswRp/CcqW9EylGTrhnIN30velUf4G3BYdw6ZKpE SVjvVrn6G9P2O5q7P/i9ylYPuylcQD8ON+n/NZHUTfqjJ1hFLVsMUv2j52yGA8dSQj4mAIDbao1EJc shIWDyhCXdTvlOBvAJRAkHm15rGNigJT7KwYk02RC5xnN6ScOurvW7G0IL+/UqWrAJ8lvkcyYvX10Y QBM6MbTZHh/4u6lVad/yxGEf5HdixHSLa3Pai8MhD69OVpm3IkVIKKwutpVcZ+xECf3pdjIGGx5omH r96QH6cu5J+ffvGzxCDEse2Gt3XA2Fp2UF2rm4a6gph4+0FYYrys8j0sRZkPpu3NpMHitpbyLcRz2l UfX2cxTiFr9Q+ERqtJga9+XGJlcNK/4ELfdNws/B63tcQ+bYP/Sf1Wzl+y3aHzNANidROlMbt6hiXq 9+WjpjvJD9QcPRJ97roicypuAOgGUGOUAKX6/0+YQa8nuQNBrJjG/UyhG5AMzXvvc6xOF1Hm1K8IeF bZfkQZJuNx7BPw1+ejSvtegHLr9aaclfNTDjDugQ+0gUU1C4y4EaostljlpA==
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

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
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

