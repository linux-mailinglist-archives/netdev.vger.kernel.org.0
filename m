Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC331F5C40
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 21:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730402AbgFJTx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 15:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730368AbgFJTxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 15:53:51 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639B1C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 12:53:51 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q8so3697906iow.7
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 12:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TPu28iSnpxiaKV6OmQYQaLs7QlaJe31+At5Kd0wdaDI=;
        b=K3+ZwfORmOVFRGG1urRqIcC4gUufLJJjuwLcZ7LSR+xCycfbHvEeB6GoJxqPsZwH1H
         6p0Q+K4GKZtgn+82EMsnrOfYroJoKWl8b94TzFLGm5GmDGnOhg8t0mnC5U8TV+yjqG0l
         Humzwmlu/BVXvtE1GkdoJlmkoaEIvBgI8pMGOJDTfIxJuBgKd04lms6IXA87MUVhkVhH
         DP8axBJPM9c75q9HQ+PnrYDmI/+owBVOhw0OM7Bjr4QRTfGk966Qy1kSNxrm3Od/YldA
         piYET9anDy4k2M/bpN1Dl82TjtyAdxG7DwCEtWNiCYB10HYNa/s3ifQWJFpSUQk/mGe7
         Qleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TPu28iSnpxiaKV6OmQYQaLs7QlaJe31+At5Kd0wdaDI=;
        b=gY1Y0co6DBTCEfXST0ME9PGNap6fTX3g9o2OU49HB1KHDzKpajqWhCApvd+vFAKfU5
         s8b/dsDK6yUv/AVamRvD5uoCfYCWoJCbnaNMCWcvJpHqjuFxY6ymBdxdQP6JgFk5AgZI
         eO4e1Ey5n0sz3GC274irX3jv/qATWETd6VXF55yV/RioxDjpY2h7iHQsSMVpIi+/EoRI
         s4YEQzDabRkqWh2TO534gUg3A9xfL3bi3JroDghCtKhIIpv9xC0WBSyZWTCqb0agOrK6
         Dxg5n3SMGQap30c12qYJSSIDvgwHdmj+54uEpNz7N4KpaMZ5No9R6ZyPcW2lbELTlLfj
         OBOQ==
X-Gm-Message-State: AOAM5308BMzj5Jt9mBTQVyVaBo3+XErOcsMhgU0IUAj2JXlGydx/ipvX
        UTl+UzsP5L4oO0miFZKTMQlvRA==
X-Google-Smtp-Source: ABdhPJwewTX9Sq82Or47p/sVRzCbeGlI/MpiGttp6BlkKzGBfJsIMA/TR+2gXpGwoOLg29k4xpjzhg==
X-Received: by 2002:a6b:2cc5:: with SMTP id s188mr4956803ios.77.1591818830843;
        Wed, 10 Jun 2020 12:53:50 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r10sm408828ile.36.2020.06.10.12.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 12:53:50 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 3/5] net: ipa: program upper nibbles of sequencer type
Date:   Wed, 10 Jun 2020 14:53:30 -0500
Message-Id: <20200610195332.2612233-4-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200610195332.2612233-1-elder@linaro.org>
References: <20200610195332.2612233-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The upper two nibbles of the sequencer type were not used for
SDM845, and were assumed to be 0.  But for SC7180 they are used, and
so they must be programmed by ipa_endpoint_init_seq().  Fix this bug.

IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP doesn't have a descriptive
comment, so add one.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 6 ++++--
 drivers/net/ipa/ipa_reg.h      | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 6015fabb4df5..59313ced7036 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -699,10 +699,12 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 	u32 seq_type = endpoint->seq_type;
 	u32 val = 0;
 
+	/* Sequencer type is made up of four nibbles */
 	val |= u32_encode_bits(seq_type & 0xf, HPS_SEQ_TYPE_FMASK);
 	val |= u32_encode_bits((seq_type >> 4) & 0xf, DPS_SEQ_TYPE_FMASK);
-	/* HPS_REP_SEQ_TYPE is 0 */
-	/* DPS_REP_SEQ_TYPE is 0 */
+	/* The second two apply to replicated packets */
+	val |= u32_encode_bits((seq_type >> 8) & 0xf, HPS_REP_SEQ_TYPE_FMASK);
+	val |= u32_encode_bits((seq_type >> 12) & 0xf, DPS_REP_SEQ_TYPE_FMASK);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 3b8106aa277a..0a688d8c1d7c 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -455,6 +455,8 @@ enum ipa_mode {
  *	second packet processing pass + no decipher + microcontroller
  * @IPA_SEQ_DMA_DEC:		DMA + cipher/decipher
  * @IPA_SEQ_DMA_COMP_DECOMP:	DMA + compression/decompression
+ * @IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP:
+ *	packet processing + no decipher + no uCP + HPS REP DMA parser
  * @IPA_SEQ_INVALID:		invalid sequencer type
  *
  * The values defined here are broken into 4-bit nibbles that are written
-- 
2.25.1

