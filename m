Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4602C92D8
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389090AbgK3Xij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388929AbgK3Xij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:38:39 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0E2C061A48
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:37:21 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id z10so4644771ilu.3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=owLQOsjd54lIVwCHCW8NL5nsggMxStD0VTTtJ4eXi54=;
        b=v2RG9eLLlUHmR3Qf00pGT9aBCtottVrk1hTmHKTcFObglnWHgqSUI4GVC1822x7y2O
         C3MngA0lHHlhqCnLWf/nzCTx81G/tXrlra5Jx5V91FEiIMOEAyA+1n9I7Caoch3fGYmM
         pHM2A4HCBwXWdd26vjGJhxR1kKGkWJU1RFYjQfSEZZ+DYD2UfcSp05Uwo5fCKy4a5VLk
         jSfK/A8sjZBeGJB3/KkDtKld2xS7+UMQ4wti8OLnM+h612hLrFCA0Tm8WrPgpCjlGQx1
         qGkMg+JG17Em3HHD6OtruejQkSpookPg/1fcsSDgX5SfaajjRYyJXuPDJXBptC3f6cD4
         EVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=owLQOsjd54lIVwCHCW8NL5nsggMxStD0VTTtJ4eXi54=;
        b=la0k9c0IBsjX4mEgNc+rHnwenqJazAG5gjuQAhi/3JVN+tAYdkS73Aqzho8zfBUh76
         Qs3J3dczYgvCbT7a21avcccnXcNax8Z4RUvCuGc8pOPbtWa10ci+O8ceaXFEH6vtAN8G
         QdGplz2eTu39ERQcJ0QmyjuhRLFTnA6qIA7a2B98XzGnrFyQ5ksbnDDwdnRNQW+xEI9J
         oVGzw5GdZYV/QlBaPuuSFeMlDCz0OV1GALY4+1s2dDVjaBDa8Ok0PKT/1YtMQmzC3Z/f
         p9kgStjAU/VOHugyv++wyHEpFbanhzqqOYP0OGWlSwMMfxTQDZDTCSmvV0pSZZ8/X18o
         sWAw==
X-Gm-Message-State: AOAM530qA8idnP063y6j+nobFRHMzSm1CarYFuCJ3MBjUVyxKDGd7ugR
        pSIp3WP0+mLz5ODYpltv04Bqng==
X-Google-Smtp-Source: ABdhPJyaBBDobaI1A57A8XILvD2zNxbH275m703Vp7hf6cVSDcTpS+SmGGEUihPPhO9zMnrgdj+dcw==
X-Received: by 2002:a92:c08d:: with SMTP id h13mr142160ile.118.1606779440851;
        Mon, 30 Nov 2020 15:37:20 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o195sm62574ila.38.2020.11.30.15.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 15:37:20 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] net: ipa: use Qtime for IPA v4.5 head-of-line time limit
Date:   Mon, 30 Nov 2020 17:37:12 -0600
Message-Id: <20201130233712.29113-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201130233712.29113-1-elder@linaro.org>
References: <20201130233712.29113-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend ipa_reg_init_hol_block_timer_val() so it properly calculates
the head-of-line block timeout to use for IPA v4.5.

Introduce hol_block_timer_qtime_val() to compute the value to use
for IPA v4.5, where Qtime is used as the basis of the timer.  Call
that function from hol_block_timer_val() for IPA v4.5.

Both of these are private functions, so shorten their names a bit so
they don't take up so much space on the line.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 48 +++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index b4c884ccb77d2..9f4be9812a1f3 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -724,12 +724,45 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
-/* The head-of-line blocking timer is defined as a tick count, where each
- * tick represents 128 cycles of the IPA core clock.  Return the value
- * that should be written to that register that represents the timeout
- * period provided.
+/* Return the Qtime-based head-of-line blocking timer value that
+ * represents the given number of microseconds.  The result
+ * includes both the timer value and the selected timer granularity.
  */
-static u32 ipa_reg_init_hol_block_timer_val(struct ipa *ipa, u32 microseconds)
+static u32 hol_block_timer_qtime_val(struct ipa *ipa, u32 microseconds)
+{
+	u32 gran_sel;
+	u32 val;
+
+	/* IPA v4.5 expresses time limits using Qtime.  The AP has
+	 * pulse generators 0 and 1 available, which were configured
+	 * in ipa_qtime_config() to have granularity 100 usec and
+	 * 1 msec, respectively.  Use pulse generator 0 if possible,
+	 * otherwise fall back to pulse generator 1.
+	 */
+	val = DIV_ROUND_CLOSEST(microseconds, 100);
+	if (val > field_max(TIME_LIMIT_FMASK)) {
+		/* Have to use pulse generator 1 (millisecond granularity) */
+		gran_sel = GRAN_SEL_FMASK;
+		val = DIV_ROUND_CLOSEST(microseconds, 1000);
+	} else {
+		/* We can use pulse generator 0 (100 usec granularity) */
+		gran_sel = 0;
+	}
+
+	return gran_sel | u32_encode_bits(val, TIME_LIMIT_FMASK);
+}
+
+/* The head-of-line blocking timer is defined as a tick count.  For
+ * IPA version 4.5 the tick count is based on the Qtimer, which is
+ * derived from the 19.2 MHz SoC XO clock.  For older IPA versions
+ * each tick represents 128 cycles of the IPA core clock.
+ *
+ * Return the encoded value that should be written to that register
+ * that represents the timeout period provided.  For IPA v4.2 this
+ * encodes a base and scale value, while for earlier versions the
+ * value is a simple tick count.
+ */
+static u32 hol_block_timer_val(struct ipa *ipa, u32 microseconds)
 {
 	u32 width;
 	u32 scale;
@@ -741,6 +774,9 @@ static u32 ipa_reg_init_hol_block_timer_val(struct ipa *ipa, u32 microseconds)
 	if (!microseconds)
 		return 0;	/* Nothing to compute if timer period is 0 */
 
+	if (ipa->version == IPA_VERSION_4_5)
+		return hol_block_timer_qtime_val(ipa, microseconds);
+
 	/* Use 64 bit arithmetic to avoid overflow... */
 	rate = ipa_clock_rate(ipa);
 	ticks = DIV_ROUND_CLOSEST(microseconds * rate, 128 * USEC_PER_SEC);
@@ -786,7 +822,7 @@ static void ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
 	u32 val;
 
 	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(endpoint_id);
-	val = ipa_reg_init_hol_block_timer_val(ipa, microseconds);
+	val = hol_block_timer_val(ipa, microseconds);
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
-- 
2.20.1

