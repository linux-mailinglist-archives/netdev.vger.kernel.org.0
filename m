Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9120549D7A
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348933AbiFMTWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347664AbiFMTVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:21:34 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0975832050
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:18:06 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h192so6118957pgc.4
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KwXY14Kz4g2aCYAhdgeSpgsRv05HFkaBSKgnXrsuDCI=;
        b=xeagx102iZADD8vk/6snUp2Y6cRGsNv1mAD7IDjympqVvYfiMzNOk4WBMCsM6E9Rz8
         gF8d0YMOQgauc99u+zhhag3P3yCbc/6E4Ei3febosxzlesH6c3f788NXi/7RMSIvnqmG
         px7Rwwj0v8R83vIycU1S4BZ5RaQXjCHu/t/eKH5N0SFbQSQ99TEsxcTvg0LumocszxhO
         hrqLphG+9rCcGVZ/aMdesKL8hx4+q+TFbvjSp7PChzG8DXmDNNILcqbcLR6O5pstSjeI
         iHidJpc1F7ZEu/i5qxDboqUs9QOUiviEH/A6JrfgcIbpGUMFPTNy4ysSTMDWXV43gmWH
         WnHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KwXY14Kz4g2aCYAhdgeSpgsRv05HFkaBSKgnXrsuDCI=;
        b=F97LFEjx3mTzYWtPYumzV5hOajf//nf8j2RR5YRQ9UiNHKQN6lr7vwAqVdh83Z6Jkl
         Kuh9hPLPOaQ1QuIrsgvk9zdJNq2KdMpgxBA9pDst+clDmuv+c/95zCDzLksPmBL/EHV3
         p+ZwYtDJMNXQ3FJpSO+EVh+nwSj0Gy4ehm988o2t9nCMQGqSkKNqM+vPuhz5VDRMuFDl
         vcflyq+KL8WVvedfrucMpJoy07JMLdRwRY1TI1oYGXjbBqfQfHduJydMG5xe4a8G2IRt
         2Gyv6eN+lwZ90nEQSCxB3geewp3s9K8qvP/T/nD+4K30b/Y5lAjNxTzjrGNcMDxx2jZf
         NXrw==
X-Gm-Message-State: AOAM530gLu2UHaKPf3800FMECGrc66VIQ5Uwcf5L1083NQuH0O11/J2t
        SJDaQgZZZafOAHk9CyGUq3+SPQ==
X-Google-Smtp-Source: ABdhPJzUzxhI0lhys4D/Olq54dljejhmpv3sYwLxkp0naQcvqNQRnmbZmw8PvLIUp9jxtrK1HaCR+A==
X-Received: by 2002:a63:894a:0:b0:3fc:a724:578c with SMTP id v71-20020a63894a000000b003fca724578cmr530868pgd.499.1655140685485;
        Mon, 13 Jun 2022 10:18:05 -0700 (PDT)
Received: from localhost.localdomain ([192.77.111.2])
        by smtp.gmail.com with ESMTPSA id u17-20020a62d451000000b0050dc762812csm5646641pfl.6.2022.06.13.10.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:18:05 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: use "tre_ring" for all TRE ring local variables
Date:   Mon, 13 Jun 2022 12:17:54 -0500
Message-Id: <20220613171759.578856-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220613171759.578856-1-elder@linaro.org>
References: <20220613171759.578856-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All local variables that represent event rings are named "ring".

All but two functions that represent a channel's TRE ring with a
local variable use the name "tre_ring".  For consistency, use that
name in the two functions that don't fit the pattern.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 278e467c5430b..e3f3c736c7409 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -549,7 +549,7 @@ static void gsi_trans_tre_fill(struct gsi_tre *dest_tre, dma_addr_t addr,
 static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 {
 	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
-	struct gsi_ring *ring = &channel->tre_ring;
+	struct gsi_ring *tre_ring = &channel->tre_ring;
 	enum ipa_cmd_opcode opcode = IPA_CMD_NONE;
 	bool bei = channel->toward_ipa;
 	struct gsi_tre *dest_tre;
@@ -567,8 +567,8 @@ static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 	 * transfer request, whose opcode is IPA_CMD_NONE.
 	 */
 	cmd_opcode = channel->command ? &trans->cmd_opcode[0] : NULL;
-	avail = ring->count - ring->index % ring->count;
-	dest_tre = gsi_ring_virt(ring, ring->index);
+	avail = tre_ring->count - tre_ring->index % tre_ring->count;
+	dest_tre = gsi_ring_virt(tre_ring, tre_ring->index);
 	for_each_sg(trans->sgl, sg, trans->used, i) {
 		bool last_tre = i == trans->used - 1;
 		dma_addr_t addr = sg_dma_address(sg);
@@ -576,14 +576,14 @@ static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 
 		byte_count += len;
 		if (!avail--)
-			dest_tre = gsi_ring_virt(ring, 0);
+			dest_tre = gsi_ring_virt(tre_ring, 0);
 		if (cmd_opcode)
 			opcode = *cmd_opcode++;
 
 		gsi_trans_tre_fill(dest_tre, addr, len, last_tre, bei, opcode);
 		dest_tre++;
 	}
-	ring->index += trans->used;
+	tre_ring->index += trans->used;
 
 	if (channel->toward_ipa) {
 		/* We record TX bytes when they are sent */
@@ -595,7 +595,7 @@ static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 	}
 
 	/* Associate the last TRE with the transaction */
-	gsi_channel_trans_map(channel, ring->index - 1, trans);
+	gsi_channel_trans_map(channel, tre_ring->index - 1, trans);
 
 	gsi_trans_move_pending(trans);
 
@@ -675,7 +675,7 @@ void gsi_channel_trans_cancel_pending(struct gsi_channel *channel)
 int gsi_trans_read_byte(struct gsi *gsi, u32 channel_id, dma_addr_t addr)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
-	struct gsi_ring *ring = &channel->tre_ring;
+	struct gsi_ring *tre_ring = &channel->tre_ring;
 	struct gsi_trans_info *trans_info;
 	struct gsi_tre *dest_tre;
 
@@ -687,10 +687,10 @@ int gsi_trans_read_byte(struct gsi *gsi, u32 channel_id, dma_addr_t addr)
 
 	/* Now fill the the reserved TRE and tell the hardware */
 
-	dest_tre = gsi_ring_virt(ring, ring->index);
+	dest_tre = gsi_ring_virt(tre_ring, tre_ring->index);
 	gsi_trans_tre_fill(dest_tre, addr, 1, true, false, IPA_CMD_NONE);
 
-	ring->index++;
+	tre_ring->index++;
 	gsi_channel_doorbell(channel);
 
 	return 0;
-- 
2.34.1

