Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDCE20E6AC
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404398AbgF2Vta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404374AbgF2VtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:49:24 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DF6C03E97B
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:49:24 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v8so18756584iox.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OnwKMPzUR7vm+fNhfAe4BP95ZmBSiCousJyVZMr+eU4=;
        b=uGRgKAiimrgL2i7Xoqg6kmfwYFmRBO1K+Hf2WRe219l2vR8aW/OqlhuegRdkChRdnc
         rEWIRCb8GE4FvyD09etNE9iSoN66TFoedqfseGxy3t/ApZOdAWdhxQf6B8bBOQSOftS8
         2P+qW5At3Ax4AqjfZVFTIpQGDm2A5NvFvPIvJv0NNZx6/t/jqaxv0r/K/R2ZZgkG7DBb
         R8Rp46qzgzYKi2/RcXo92Efw+ZSAAMW9H0sm6Nanma6Vr90PCjA5lK5gj1G30t2HFupD
         GrRfqkvcrxE5h0e4j5J/9sgEEnH9T/9T1oEnU7jgIUS27wS1H8ThmX0gfIGXYHG6ER0w
         GGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OnwKMPzUR7vm+fNhfAe4BP95ZmBSiCousJyVZMr+eU4=;
        b=bKe7l49OZAihjQ9WgT/aJ3LVsnBo5ymeFoMgNL2zVLnEBsjhEsgMPRswsNCPsl76/1
         dDVE/0K6epRoncWbxZADIFjGlRfBVngfjT4bW/FQ5o2IqO4kxstC9Yyj75WfdvzqE7DJ
         rQtAJ2pYP4dDRCL5x5LRQXQZksGpmRoZWFsV8w39iFU2I2w1QJNRTeNe/M1WHm7L4tTO
         3ImMz5gwxapMXf2ILp+FByLuxYVn8vIiosKqdHdhBn0g2Zzs3D4xGTdqk9DkT6/588UK
         IQPcYNgUuQuiosw6Cers71oa9JGy/u7T5854YuokQonehmfOkUiUdMX3nqjt7EXGfymI
         yRdQ==
X-Gm-Message-State: AOAM5314501M9DFa73Qfu8/I8xwjf1Yx7XLOLM02mtsmk7fbkWJrOC0Q
        PCn7CqmrwHvUSzwWcTpVnKFLUQ==
X-Google-Smtp-Source: ABdhPJzQw2nxuO3eOLUdcXu6/d/nND+rrrENJbWNxkhhgZktkVnd+vMwypSgufU/1EQnjqLTnT2seA==
X-Received: by 2002:a05:6638:601:: with SMTP id g1mr20258787jar.137.1593467363991;
        Mon, 29 Jun 2020 14:49:23 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u10sm555500iow.38.2020.06.29.14.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:49:23 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: ipa: head-of-line block registers are RX only
Date:   Mon, 29 Jun 2020 16:49:15 -0500
Message-Id: <20200629214919.1196017-2-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629214919.1196017-1-elder@linaro.org>
References: <20200629214919.1196017-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The INIT_HOL_BLOCK_EN and INIT_HOL_BLOCK_TIMER endpoint registers
are only valid for RX endpoints.

Have ipa_endpoint_modem_hol_block_clear_all() skip writing these
registers for TX endpoints.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 9f50d0d11704..3f5a41fc1997 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -642,6 +642,8 @@ static int ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
 	u32 offset;
 	u32 val;
 
+	/* assert(!endpoint->toward_ipa); */
+
 	/* XXX We'll fix this when the register definition is clear */
 	if (microseconds) {
 		struct device *dev = &ipa->pdev->dev;
@@ -671,6 +673,8 @@ ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint, bool enable)
 	u32 offset;
 	u32 val;
 
+	/* assert(!endpoint->toward_ipa); */
+
 	val = u32_encode_bits(enable ? 1 : 0, HOL_BLOCK_EN_FMASK);
 	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(endpoint_id);
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
@@ -683,7 +687,7 @@ void ipa_endpoint_modem_hol_block_clear_all(struct ipa *ipa)
 	for (i = 0; i < IPA_ENDPOINT_MAX; i++) {
 		struct ipa_endpoint *endpoint = &ipa->endpoint[i];
 
-		if (endpoint->ee_id != GSI_EE_MODEM)
+		if (endpoint->toward_ipa || endpoint->ee_id != GSI_EE_MODEM)
 			continue;
 
 		(void)ipa_endpoint_init_hol_block_timer(endpoint, 0);
-- 
2.25.1

