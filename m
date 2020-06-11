Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF451F6E3A
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 21:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgFKTtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 15:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgFKTso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 15:48:44 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7217C08C5C1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:48:43 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id e11so6633166ilr.4
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z6jCKhwU+IyQWEVkFQhufn/sexfHuVEEbtYUc9UiYh0=;
        b=Ix7sfp+3doxQbLwBXahYaQJds+bov2HQV6CLpeub2u9nSUL/xnfQgHyD7ZVAhqaahY
         wagy1nxexuL/A7a6Xq1Jsg+xKJ/4PE0v5noGHb1gd3muQ3OTxIeirfvo5MSiXmA93F03
         TO5bWdB6CQKEh/8XLH1vwSok69j8JrbOkwzTPuot49vM7Ie6RqoLfXcF+WxlT0cz6j4H
         CEG1MAco7tAOP0J/kaHLRtz3R0ThmZkOWV+tP9vfTZ9g9NH/cDApoxHHa/kubeP0tLFF
         +iebNyfkPVhDe2a9iiVZSXPYo5etqRTG8JpVMfutIuQ0VIQ7dL43FDaZTue6QEui/chk
         UY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z6jCKhwU+IyQWEVkFQhufn/sexfHuVEEbtYUc9UiYh0=;
        b=rrH/1bjmCCWTOS9mFtMueOq4477QyHUpnXyRyuL1tk14VjBFbbiEA8I3F86otiV4uP
         fMRwc/XqcqgbGBwURiUOpCBWiO8V6TWLLzg5qGO5gvnauBzbYSTP6P467UdU4ZGaK3dQ
         Y9db9XYzYVN+FN10NyolLjgZCEfwymvrC25UQ3G8+zx8MbKEClo1oQr0Xr9rTNAZsa/n
         C6Jjmq8keaOfU2XCex+pQF/KV04NPf9BkWsyZmjm3XV1AhqNtcfpVFj7rVitgoDwClY1
         gdvtd5tSJivvcL1yaj6wut7psoArYosr6wJVpHjkz7jb/yZxqKDc6+mGnc7pQTV82rbs
         RPBQ==
X-Gm-Message-State: AOAM533zAGumcAsB8byDTewol4DpPuRHtQB4qqNSYdQYWQSIiLaiRPf4
        W1QfQwuPH6IJRwkwHDVag0i4pQ==
X-Google-Smtp-Source: ABdhPJxvnq9HrJRkW4DN8CC7Fz/JkoWq26EEuDPSM9I0zWxvPkP/QO9CHkzDc6PdEI85yTd2KtmFKA==
X-Received: by 2002:a92:cb4c:: with SMTP id f12mr9691443ilq.235.1591904923087;
        Thu, 11 Jun 2020 12:48:43 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d13sm1981397ilo.40.2020.06.11.12.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 12:48:42 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 3/4] net: ipa: program upper nibbles of sequencer type
Date:   Thu, 11 Jun 2020 14:48:32 -0500
Message-Id: <20200611194833.2640177-4-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200611194833.2640177-1-elder@linaro.org>
References: <20200611194833.2640177-1-elder@linaro.org>
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
index 2825dca23ec4..bf3e8ced3ee0 100644
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

