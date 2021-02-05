Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAB73118F3
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhBFCv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbhBFClG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:41:06 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C5DC061D73
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:11:15 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id y17so7199976ili.12
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8+ck2H8Pw6wgSCqXl5lp8F6E+5zNs1S9ypztUefo5vE=;
        b=dTeI9ZXkMLEbDbqLDCD7wS977KZA+JfdY7T42waiRpAhSo2UF3a0My9aGY88c5II62
         1b0jcGZ7xE/D3islRRXJeTMWaX8YY1aj/OX5I/sIjX1JRkzXqwtpOodMmXJuxsRFxXoz
         U/86TNwxQdyatpc7p8CtGglxhKg5UdGjfeAx9bUHmPyt6ijWBWUdys9aKMa5MELwq4So
         wG5pl+gWqc3mR+YdOebDL38YB4NaAHBpQpXrd4AXI66bnNUxrq9gneEy8/jybvupbXwB
         ZSG2+arMRCiWCwEin2IVFuyzh093iXsN0KJId6yfdp+4M5HB2y++kiYXIGt1aflTtvx+
         YSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8+ck2H8Pw6wgSCqXl5lp8F6E+5zNs1S9ypztUefo5vE=;
        b=CRtcXMx0Cs+IgYBFgU9OxnXuQWuc0ZgkxriYF6KoVlWvUEiDE/Pu4QzN/d2sDaqKnn
         2k7JmnlRYTc4iNbJYo0cb2nlE66GS/4n+M6DjR4hS2BbdaRYyOV9f6H5XeDu4K50rM+P
         kbQAgxDoCQIySsZlC4LZ60BX0MG1Y2v4taVusbiyBw651FpywcKQNbyCvUTOcDIELeYG
         mq8gVjTaX+nRu1+qrPl9ndK0nm8/92xUOy8VVneNZpuXRwKr60S/fPX/PPzf9252TUiT
         h6PsDtfnR9KVmMS4XrlUvWkFyJ5m7sDQwNCf6AEMCkSyiQlvTlxZ4SgYghNkiR4Rhpqo
         jLGQ==
X-Gm-Message-State: AOAM5337p3iDXMEVLR9xKqUO122RgHx1JtdcGhhsC9P5bw+y3rcO58a4
        yTWKKl9Gk+1DDxMZ7ZmINUC7Yw==
X-Google-Smtp-Source: ABdhPJwVm95SUqhwcwLsT6M8j/NKgP9CdtS4acTDh2NugOZw359IHrxU2/walljAaeqSVDR2pJwxnQ==
X-Received: by 2002:a92:cbce:: with SMTP id s14mr6093470ilq.306.1612563074789;
        Fri, 05 Feb 2021 14:11:14 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m15sm4647171ilh.6.2021.02.05.14.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:11:14 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 7/7] net: ipa: avoid field overflow
Date:   Fri,  5 Feb 2021 16:11:00 -0600
Message-Id: <20210205221100.1738-8-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205221100.1738-1-elder@linaro.org>
References: <20210205221100.1738-1-elder@linaro.org>
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

