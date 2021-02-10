Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E16F31736F
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhBJWek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbhBJWe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:34:28 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED8EC061794
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:33:26 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id e133so3680204iof.8
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ebGMA32A3lz4dOPF3atpHHf9aQxnDO22teaa/gzKf7E=;
        b=TRkL8rpb7xtowbI7NG5qRcVYCoyiVGgNCywcggZ+i3Y5YsMSxdMkcklXAj/HqCbCKp
         7WjOTC+wEQW658qVbVhEtpD41DsJLrs+9aXyDJL2MwfPgTX1kuk2KK4cghv58MTne353
         aMnSyVqAIy6gqAOlPrKyK6cuEs07P7AKQLEPfkt+0iAz9f8ZmMzu7uuZZx0c1zlGbhvt
         I9tAZzgq/7RaMV6AL5F9IO7/YKEXLk418PA+hjOfovJC8SD2W4o8U2ilkFVmlPOqEa8o
         DYXll+c00hfrCX6KiJUXOBnnOxD8E7OtFAbnXj+SRe28CIr5cZySVb73PVcDhn0keBwl
         DtjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ebGMA32A3lz4dOPF3atpHHf9aQxnDO22teaa/gzKf7E=;
        b=keZyvcq9CYBvT6gGL7LAjhIe1LBMdBnuSCF15duPjDBo3YE9E3bml4ep/jxB4zRJGc
         zGK8yq83O4xcR+0Yfe7B1syFU1eGCYF+ZNs9VkXgWABDjUEY5icalPvTKIeqSAsVJ1En
         0cEj4XJWKiAcr5N+MY/umi39YAYHNbLG4HYj9IOzpJu7BdP5oLhhEqwgf+AShcCGVOVa
         YaCWFdFOfRh5ZMADW5O38iSTSx1CNgoiaKzkDC/D0u7D3Fy0CD61kZ30/whbuhSmOiX5
         Eu2coc0VC3ibzJyEFJ90aL1AhRsUKg1sN+RDhxN/PJdIE8IHKA66O2FXPb2EOC18fucb
         3BXg==
X-Gm-Message-State: AOAM532oNEYOmdcs2KEw0qof6ZKCP57U8YTBt3XzjdVq8DrQzk4K/UM2
        uHb2p8BzYulTjqwv20Oevr7KOA==
X-Google-Smtp-Source: ABdhPJzzApz4CRdzB0M8M/56mIFQy+VD+EC7Q5O0Ksdf8b1eA+vagWh3Ckhsxf+xnr9NQYSzpZMQUA==
X-Received: by 2002:a5d:81c8:: with SMTP id t8mr2888690iol.38.1612996406423;
        Wed, 10 Feb 2021 14:33:26 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e23sm1484525ioc.34.2021.02.10.14.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 14:33:26 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: ipa: fix register write command validation
Date:   Wed, 10 Feb 2021 16:33:18 -0600
Message-Id: <20210210223320.11269-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210223320.11269-1-elder@linaro.org>
References: <20210210223320.11269-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ipa_cmd_register_write_valid() we verify that values we will
supply to a REGISTER_WRITE IPA immediate command will fit in
the fields that need to hold them.  This patch fixes some issues
in that function and ipa_cmd_register_write_offset_valid().

The dev_err() call in ipa_cmd_register_write_offset_valid() has
some printf format errors:
  - The name of the register (corresponding to the string format
    specifier) was not supplied.
  - The IPA base offset and offset need to be supplied separately to
    match the other format specifiers.
Also make the ~0 constant used there to compute the maximum
supported offset value explicitly unsigned.

There are two other issues in ipa_cmd_register_write_valid():
  - There's no need to check the hash flush register for platforms
    (like IPA v4.2) that do not support hashed tables
  - The highest possible endpoint number, whose status register
    offset is computed, is COUNT - 1, not COUNT.

Fix these problems, and add some additional commentary.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 97b50fee60089..8c832bf2637ab 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -244,11 +244,15 @@ static bool ipa_cmd_register_write_offset_valid(struct ipa *ipa,
 	if (ipa->version != IPA_VERSION_3_5_1)
 		bit_count += hweight32(REGISTER_WRITE_FLAGS_OFFSET_HIGH_FMASK);
 	BUILD_BUG_ON(bit_count > 32);
-	offset_max = ~0 >> (32 - bit_count);
+	offset_max = ~0U >> (32 - bit_count);
 
+	/* Make sure the offset can be represented by the field(s)
+	 * that holds it.  Also make sure the offset is not outside
+	 * the overall IPA memory range.
+	 */
 	if (offset > offset_max || ipa->mem_offset > offset_max - offset) {
 		dev_err(dev, "%s offset too large 0x%04x + 0x%04x > 0x%04x)\n",
-				ipa->mem_offset + offset, offset_max);
+			name, ipa->mem_offset, offset, offset_max);
 		return false;
 	}
 
@@ -261,12 +265,24 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 	const char *name;
 	u32 offset;
 
-	offset = ipa_reg_filt_rout_hash_flush_offset(ipa->version);
-	name = "filter/route hash flush";
-	if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
-		return false;
+	/* If hashed tables are supported, ensure the hash flush register
+	 * offset will fit in a register write IPA immediate command.
+	 */
+	if (ipa->version != IPA_VERSION_4_2) {
+		offset = ipa_reg_filt_rout_hash_flush_offset(ipa->version);
+		name = "filter/route hash flush";
+		if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
+			return false;
+	}
 
-	offset = IPA_REG_ENDP_STATUS_N_OFFSET(IPA_ENDPOINT_COUNT);
+	/* Each endpoint can have a status endpoint associated with it,
+	 * and this is recorded in an endpoint register.  If the modem
+	 * crashes, we reset the status endpoint for all modem endpoints
+	 * using a register write IPA immediate command.  Make sure the
+	 * worst case (highest endpoint number) offset of that endpoint
+	 * fits in the register write command field(s) that must hold it.
+	 */
+	offset = IPA_REG_ENDP_STATUS_N_OFFSET(IPA_ENDPOINT_COUNT - 1);
 	name = "maximal endpoint status";
 	if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
 		return false;
-- 
2.20.1

