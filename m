Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBCD342D37
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 15:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhCTOR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 10:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhCTORe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 10:17:34 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D857C061763
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 07:17:34 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id n21so9186261ioa.7
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 07:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MPhTVsIrHH/+WBVpw+HPz1pu5PAIUwUB7d8TMcipYVo=;
        b=AYnWCupF+3rpVEr6FSMw6Rp9j9Yf6VodW8GpLy4c12hv3qXXeu+99AZ9aawZfyM4GR
         YgZ/w69yJONbH0X0zK0zoeTf6ywkV4fRFDyKAaCgyX2cdB5CKHUqrw0WfzIFBQDS8Hld
         SkGYCu+GKJYGDr9g16nnCsQP9mQNAdzNUVL6SVSI1Q+eH8KJkujjtOKr41w1lGj5B5Bz
         FZE3QKEoD+G6r9nQzLy0PBb7qbyKDDQrEmVi1zqa5IG60Ck1F/j9a27YBS/x+p7asb9K
         AwSBzu7vqHwErccbtdY56yfOczjQPoNnG+Xkr71ga4kL1QKWkO4/H10341LcQQxkmSlk
         zmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MPhTVsIrHH/+WBVpw+HPz1pu5PAIUwUB7d8TMcipYVo=;
        b=cGCe6EPPiR9ZFjpsakYC0+tpgL0F9g8WOv0/zunj5z6dd72Y/YduERPd4XuNiL2wBT
         tEeiSBaTzSvcsJ4mF+leBHj6fspONBTaK6lOTLltqa67E9Z5qjKyD5mZQ0mBePZ7fwv6
         L2+ZkBft4Xz2iBAIs3ijOrcK57T0H411S9JMAsEcSPnVOqtbIKezMwXSPBSlOs1lX5Sx
         4ku5afTjXt+Rzq2OMrRNidVFrrP6ui3j5pVpxXKEpQK5usM2ZNTs4tmHRce9oumjNqXD
         HzwX0BTvztQKfu5XqAvJ4Svh5o3Xs2YETKFZao37TBvEOgLHVKtssViUKWhM0iTF/hGk
         TygA==
X-Gm-Message-State: AOAM532DOKtscieZUS4sqDjuWeyGIBtlN4OlMnRawEvRaKw39GCzeztF
        G5f+lnAAf/MvxNX9cuYEAMULFw==
X-Google-Smtp-Source: ABdhPJwi26zKAyotBpBe9+RVEr0fTGE0EM82JfS4kTE+PSjCN7Vk3LzyqtkXpP4Vv5Ieaoigqq3ziw==
X-Received: by 2002:a5e:d901:: with SMTP id n1mr6118543iop.84.1616249853910;
        Sat, 20 Mar 2021 07:17:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s16sm4273221ioe.44.2021.03.20.07.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 07:17:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     leon@kernel.org, andrew@lunn.ch, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/2] net: ipa: fix init header command validation
Date:   Sat, 20 Mar 2021 09:17:28 -0500
Message-Id: <20210320141729.1956732-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210320141729.1956732-1-elder@linaro.org>
References: <20210320141729.1956732-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use ipa_cmd_header_valid() to ensure certain values we will
program into hardware are within range, well in advance of when we
actually program them.  This way we avoid having to check for errors
when we actually program the hardware.

Unfortunately the dev_err() call for a bad offset value does not
supply the arguments to match the format specifiers properly.
Fix this.

There was also supposed to be a check to ensure the size to be
programmed fits in the field that holds it.  Add this missing check.

Rearrange the way we ensure the header table fits in overall IPA
memory range.

Finally, update ipa_cmd_table_valid() so the format of messages
printed for errors matches what's done in ipa_cmd_header_valid().

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: - Updated description to mention ipa_cmd_table_valid() changes.

 drivers/net/ipa/ipa_cmd.c | 50 ++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 35e35852c25c5..d73b03a80ef89 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -175,21 +175,23 @@ bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
 			    : field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK);
 	if (mem->offset > offset_max ||
 	    ipa->mem_offset > offset_max - mem->offset) {
-		dev_err(dev, "IPv%c %s%s table region offset too large "
-			      "(0x%04x + 0x%04x > 0x%04x)\n",
-			      ipv6 ? '6' : '4', hashed ? "hashed " : "",
-			      route ? "route" : "filter",
-			      ipa->mem_offset, mem->offset, offset_max);
+		dev_err(dev, "IPv%c %s%s table region offset too large\n",
+			ipv6 ? '6' : '4', hashed ? "hashed " : "",
+			route ? "route" : "filter");
+		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
+			ipa->mem_offset, mem->offset, offset_max);
+
 		return false;
 	}
 
 	if (mem->offset > ipa->mem_size ||
 	    mem->size > ipa->mem_size - mem->offset) {
-		dev_err(dev, "IPv%c %s%s table region out of range "
-			      "(0x%04x + 0x%04x > 0x%04x)\n",
-			      ipv6 ? '6' : '4', hashed ? "hashed " : "",
-			      route ? "route" : "filter",
-			      mem->offset, mem->size, ipa->mem_size);
+		dev_err(dev, "IPv%c %s%s table region out of range\n",
+			ipv6 ? '6' : '4', hashed ? "hashed " : "",
+			route ? "route" : "filter");
+		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
+			mem->offset, mem->size, ipa->mem_size);
+
 		return false;
 	}
 
@@ -205,22 +207,36 @@ static bool ipa_cmd_header_valid(struct ipa *ipa)
 	u32 size_max;
 	u32 size;
 
+	/* In ipa_cmd_hdr_init_local_add() we record the offset and size
+	 * of the header table memory area.  Make sure the offset and size
+	 * fit in the fields that need to hold them, and that the entire
+	 * range is within the overall IPA memory range.
+	 */
 	offset_max = field_max(HDR_INIT_LOCAL_FLAGS_HDR_ADDR_FMASK);
 	if (mem->offset > offset_max ||
 	    ipa->mem_offset > offset_max - mem->offset) {
-		dev_err(dev, "header table region offset too large "
-			      "(0x%04x + 0x%04x > 0x%04x)\n",
-			      ipa->mem_offset + mem->offset, offset_max);
+		dev_err(dev, "header table region offset too large\n");
+		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
+			ipa->mem_offset, mem->offset, offset_max);
+
 		return false;
 	}
 
 	size_max = field_max(HDR_INIT_LOCAL_FLAGS_TABLE_SIZE_FMASK);
 	size = ipa->mem[IPA_MEM_MODEM_HEADER].size;
 	size += ipa->mem[IPA_MEM_AP_HEADER].size;
-	if (mem->offset > ipa->mem_size || size > ipa->mem_size - mem->offset) {
-		dev_err(dev, "header table region out of range "
-			      "(0x%04x + 0x%04x > 0x%04x)\n",
-			      mem->offset, size, ipa->mem_size);
+
+	if (size > size_max) {
+		dev_err(dev, "header table region size too large\n");
+		dev_err(dev, "    (0x%04x > 0x%08x)\n", size, size_max);
+
+		return false;
+	}
+	if (size > ipa->mem_size || mem->offset > ipa->mem_size - size) {
+		dev_err(dev, "header table region out of range\n");
+		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
+			mem->offset, size, ipa->mem_size);
+
 		return false;
 	}
 
-- 
2.27.0

