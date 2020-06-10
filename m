Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73771F5C44
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 21:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbgFJTyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 15:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730383AbgFJTxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 15:53:53 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1304C03E96F
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 12:53:52 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id 9so3153648ilg.12
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 12:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5T05cldmDvQfb77MhXbjwDSTWhsR/a0PAAsdMXfo7+U=;
        b=IYvRVub8FU12CaBQnSJ2Hg6GIrhJmIi6cUGltv6PVN66zyTX70sHSyd0ICHKjU6V9x
         rLmepJu4GpTX4wNlOll08ytzCDn1Ol1D65KaSMQB5ySSrwfnKIPBXn2IAAXRjbkXLED6
         kpEv+B1EZ4Tanfj8QYBKVQRrr27c6PPzXdubnHU3W2LPCSVV865TeTw4aSQdglLrGBvu
         frTbFad/Pil8R+xm9KOR/uH3wS/Um+sNQxvCVnrgIvUpEN6AGYTzu1QH92R6FYFETJh6
         qWhWvcYPVDpfp7FCAIuax4b25ffslmx+YL1e9e+k//8jIYxawuDfIzUFyPMlvXzQ2lB9
         zQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5T05cldmDvQfb77MhXbjwDSTWhsR/a0PAAsdMXfo7+U=;
        b=GCDQTpS66xSLUge6U27YUpVH3IqTW+n6A1Ea4cMXbJc31eh6uOqh3Bsmwf6qRMfQEw
         oOTSLPSVagVrIEg+WWw+L5MeRR9tYrvffrrtpNfnHpfOuLjPHvRhCEYgg1+Nmaox+7Vu
         WPRTxcoQUOj5EUQCSQA89cQ2PeDU6toODhJEaYD3ce4pdv026Iu913TbtO/jFfsQTrN9
         McjS5dK72P3xwk2fsafeLnfjGrehm5kknvyoRHSRcYJET+zEARrRWV4yKgsdfgfSU7EM
         9jLjKm7qppDTnC8UewvdEwosTOHKEv3Pkitl/pRbNCN39o1YQy38KTyA57hWr7iYy7ti
         fjtg==
X-Gm-Message-State: AOAM530VU5DCkj9NV0A/v7J/tXFqIQTUK+ZYHOwW7rBhK2Yqlb8beg1c
        tybE7mJa16X3CvpxE21fGSUOBQ==
X-Google-Smtp-Source: ABdhPJzaarLdXeahhIkS4rtJPH7St+FhJ1fUqWHoibOoLJjv5eJVw88zDBj3opnjHqvL0pAiV7Vw0g==
X-Received: by 2002:a92:d302:: with SMTP id x2mr4710813ila.175.1591818832177;
        Wed, 10 Jun 2020 12:53:52 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r10sm408828ile.36.2020.06.10.12.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 12:53:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 4/5] net: ipa: header pad field only valid for AP->modem endpoint
Date:   Wed, 10 Jun 2020 14:53:31 -0500
Message-Id: <20200610195332.2612233-5-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200610195332.2612233-1-elder@linaro.org>
References: <20200610195332.2612233-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only QMAP endpoints should be configured to find a pad size field
within packet headers.  They are found in the first byte of the QMAP
header (and the hardware fills only the 6 bits in that byte that
constitute the pad_len field).

The RMNet driver assumes the pad_len field is valid for received
packets, so we want to ensure the pad_len field is filled in that
case.  That driver also assumes the length in the QMAP header
includes the pad bytes.

The RMNet driver does *not* pad the packets it sends, so the pad_len
field can be ignored.

Fix ipa_endpoint_init_hdr_ext() so it only marks the pad field
offset valid for QMAP RX endpoints, and in that case indicates
that the length field in the header includes the pad bytes.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 59313ced7036..b35e027003b3 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -467,7 +467,7 @@ void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 			header_size += sizeof(struct rmnet_map_ul_csum_header);
 		val |= u32_encode_bits(header_size, HDR_LEN_FMASK);
 
-		/* Define how to fill mux_id in a received QMAP header */
+		/* Define how to fill fields in a received QMAP header */
 		if (!endpoint->toward_ipa) {
 			u32 off;	/* Field offset within header */
 
@@ -499,10 +499,21 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	u32 val = 0;
 
 	val |= HDR_ENDIANNESS_FMASK;		/* big endian */
-	val |= HDR_TOTAL_LEN_OR_PAD_VALID_FMASK;
-	/* HDR_TOTAL_LEN_OR_PAD is 0 (pad, not total_len) */
+
+	/* A QMAP header contains a 6 bit pad field at offset 0.  The RMNet
+	 * driver assumes this field is meaningful in packets it receives,
+	 * and assumes the header's payload length includes that padding.
+	 * The RMNet driver does *not* pad packets it sends, however, so
+	 * the pad field (although 0) should be ignored.
+	 */
+	if (endpoint->data->qmap && !endpoint->toward_ipa) {
+		val |= HDR_TOTAL_LEN_OR_PAD_VALID_FMASK;
+		/* HDR_TOTAL_LEN_OR_PAD is 0 (pad, not total_len) */
+		val |= HDR_PAYLOAD_LEN_INC_PADDING_FMASK;
+		/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0 */
+	}
+
 	/* HDR_PAYLOAD_LEN_INC_PADDING is 0 */
-	/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0 */
 	if (!endpoint->toward_ipa)
 		val |= u32_encode_bits(pad_align, HDR_PAD_TO_ALIGNMENT_FMASK);
 
-- 
2.25.1

