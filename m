Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0191430DE31
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 16:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbhBCPbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 10:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbhBCPa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 10:30:28 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D517C061351
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 07:29:08 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id n14so11813752iog.3
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 07:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8+ck2H8Pw6wgSCqXl5lp8F6E+5zNs1S9ypztUefo5vE=;
        b=wmkF3rstvKe+WT+YiOwKc4htIr03ntvhnhwiLHIZIojEmxC482Wf2XJ0oNwcMbvK0n
         T6p4jJIS2hlyhgNbwmgCmsJOqLwMLzFEAdjQ4aXBHizY0k1VBz1hq5Xevkt0jrWiXvmB
         hoxa7XMa7pEklv7soXXOwTeoW4WJMIA7v8D1plwJAf+0+7Sk3LaYib71DcPs7TvAY7qR
         7VEeNo1+mIse9LkAR2cK8FOpiztuXdZ4Th2UYP7rCxMkH+odnobGTE+V7Br/Xuc5r/+O
         oepy9WQ2US5Ak0gwbiV5SRvw4p+aNrxAMTiM8c060MuS0iNqJYUli/68iwEcfIdt5EfV
         fMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8+ck2H8Pw6wgSCqXl5lp8F6E+5zNs1S9ypztUefo5vE=;
        b=kyTIT7nwejqz5jSn1+AidD1ojppbpj/pcBlSy8E4Vat1ueS1HIAoDwo5sWSqp/6rjL
         goLw8fweRNYNo9G/Er50EXano2Qakk852C+SAArws22k/3zfp7BqlW6RntvV/oXfiJyf
         g1tzZM5Xz0m0gv+UpQQqHZTZe+VCEmnfrNwmxTdimjFM9J1wSiDiIbpbwLBQDemurTrp
         /Rdu+gbAjzNbQG6VzU+8m7Up6N1OnnqC3VO6phAnIYJYf93i5K+9xM40JIOrbz8auU4k
         c6LxuIaNJLeXbtDW8AJvMm37CXiQEqqS2rTovu/QDcubSZdi8Tq+v6NtVkYT657QaOA8
         8Z4Q==
X-Gm-Message-State: AOAM532rnwTKLjRFbUc5lS2M2i1j5df2XfyQJrFunBQRTVSH3+Cbuk0Z
        mtdI5TOiQGCpH615zOzc7vMQxA==
X-Google-Smtp-Source: ABdhPJzJxDoy8+bbNpiDX4F3XcepahL+QQ9JPLGXIQwTiTSf1UmICLKNZ+mNOkfPWB5h53GEfUeVCQ==
X-Received: by 2002:a02:3e96:: with SMTP id s144mr3434727jas.81.1612366147685;
        Wed, 03 Feb 2021 07:29:07 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a15sm1119774ilb.11.2021.02.03.07.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 07:29:07 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: ipa: avoid field overflow
Date:   Wed,  3 Feb 2021 09:28:55 -0600
Message-Id: <20210203152855.11866-8-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210203152855.11866-1-elder@linaro.org>
References: <20210203152855.11866-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's possible that the length passed to ipa_header_size_encoded()
is larger than what can be represented by the HDR_LEN field alone
(starting with IPA v4.5).  If we attempted that, u32_encode_bits()
would trigger a build-time error.

Avoid this problem by masking off high-order bits of the value
encoded as the lower portion of the header length.

The same sort of problem exists in ipa_metadata_offset_encoded(),
so implement the same fix there.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.h | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index e6b0827a244ec..732e691e9aa62 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -408,15 +408,18 @@ enum ipa_cs_offload_en {
 static inline u32 ipa_header_size_encoded(enum ipa_version version,
 					  u32 header_size)
 {
+	u32 size = header_size & field_mask(HDR_LEN_FMASK);
 	u32 val;
 
-	val = u32_encode_bits(header_size, HDR_LEN_FMASK);
-	if (version < IPA_VERSION_4_5)
+	val = u32_encode_bits(size, HDR_LEN_FMASK);
+	if (version < IPA_VERSION_4_5) {
+		/* ipa_assert(header_size == size); */
 		return val;
+	}
 
 	/* IPA v4.5 adds a few more most-significant bits */
-	header_size >>= hweight32(HDR_LEN_FMASK);
-	val |= u32_encode_bits(header_size, HDR_LEN_MSB_FMASK);
+	size = header_size >> hweight32(HDR_LEN_FMASK);
+	val |= u32_encode_bits(size, HDR_LEN_MSB_FMASK);
 
 	return val;
 }
@@ -425,15 +428,18 @@ static inline u32 ipa_header_size_encoded(enum ipa_version version,
 static inline u32 ipa_metadata_offset_encoded(enum ipa_version version,
 					      u32 offset)
 {
+	u32 off = offset & field_mask(HDR_OFST_METADATA_FMASK);
 	u32 val;
 
-	val = u32_encode_bits(offset, HDR_OFST_METADATA_FMASK);
-	if (version < IPA_VERSION_4_5)
+	val = u32_encode_bits(off, HDR_OFST_METADATA_FMASK);
+	if (version < IPA_VERSION_4_5) {
+		/* ipa_assert(offset == off); */
 		return val;
+	}
 
 	/* IPA v4.5 adds a few more most-significant bits */
-	offset >>= hweight32(HDR_OFST_METADATA_FMASK);
-	val |= u32_encode_bits(offset, HDR_OFST_METADATA_MSB_FMASK);
+	off = offset >> hweight32(HDR_OFST_METADATA_FMASK);
+	val |= u32_encode_bits(off, HDR_OFST_METADATA_MSB_FMASK);
 
 	return val;
 }
-- 
2.20.1

