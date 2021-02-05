Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCF4310DDB
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 17:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBEOr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 09:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhBEOlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:41:24 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C89C0617AB
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 08:19:29 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id j12so4629731pfj.12
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 08:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8+ck2H8Pw6wgSCqXl5lp8F6E+5zNs1S9ypztUefo5vE=;
        b=uRg8k3YjUU6IsLiiIhlzn9AWCPcV4/IAp/ZEAfeGG+ImCWMygj0IZBfQ7gVH70CLSH
         97ff0J7fH6wSURs2K965ZD6sWg1r4c5xVlMhWrDaAgJjON6Xb+1mK0m9hDi+LId4DfvW
         aInXRjPS/iCQusA4QlP7fzT/hcKqUrfXNq2O2geCzmCbg6h9XpjkdBu/TH6oxmTeW3E6
         vsztOYoSdXZumasBlAH/6/TFmVsyvBrxCsoDWJO56ItgtXo8z3BaDFtVrpBvZIE7vLrs
         oBGKZGLb6jgjEmtxr8bxia0AhrARBVDRtjkgAWwS43xSeddxvq+tBk5CrHCV4KAyTpiA
         q7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8+ck2H8Pw6wgSCqXl5lp8F6E+5zNs1S9ypztUefo5vE=;
        b=oHn8+/iy3B4EIOTuU7d+aRhULzazzzoIb6c40p33/grWi12j7+rYcOjPnzGeb6sKac
         dz/2HCkh8VjlZZFY/TA6rVvnwsshIFa//4oxBE1Dwl9LbocUc39cGpVIeWX9oVbnfGXG
         3419DGEIDzchDQMsFXTJbIulmgR7L+AOB5NgDyjBk9Sdp+L/qnVzSmWLPJvWf1tVadWs
         Rzl2RT5mM8IjYFLguHzN1lmsUo+g+lfCh+gmJ5qAazZhiTHyhZiuPlo3ltBn+4A36FH0
         rYgj26TO5szGaUk43Mp254WdO8vUB6x5SzLb4KPSR4ISOE2Jsv/enjleDVagXzVI7+F+
         Hv1A==
X-Gm-Message-State: AOAM531K/3LW2VDi52HH/iHKpRT0A8cfYZSBY5n6imK1I7jwrOaU3KTU
        Grfk6aFifpu0q0D/SKPYcqDEXnWB6hRfJw==
X-Google-Smtp-Source: ABdhPJxDtf0c+ed0u2t7JMLZjtqoLdm3/SJWfOMF1H0Mi0q45y7CyLLK/VMMb0DlqB6xpgRJEp//pw==
X-Received: by 2002:a05:6602:154e:: with SMTP id h14mr4291585iow.1.1612535921035;
        Fri, 05 Feb 2021 06:38:41 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h9sm4136882ili.43.2021.02.05.06.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:38:40 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 7/7] net: ipa: avoid field overflow
Date:   Fri,  5 Feb 2021 08:38:29 -0600
Message-Id: <20210205143829.16271-8-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205143829.16271-1-elder@linaro.org>
References: <20210205143829.16271-1-elder@linaro.org>
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

