Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B110731950D
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhBKVVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhBKVUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:20:53 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90FBC061793
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:19:34 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id o15so5438716ilt.6
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Qrga60o/lyaLM8rZ05SjxSzhBr8SgrRcVc1JO91zNY=;
        b=lJxYYFeLSvXh8SjWSJ83KiNCbHsmbgYwbUjFxiVKKGQF6Rlo5CNW67Rz6/zxicammH
         qGn+r9Zrzzfp9lNFWMGnJAZubT8ABGUo9y3qYARNWXfMMhHRHIb35BWs6GcXzwHA3csD
         7YcOcpaXDY0iF6bHbdAT1fzR6hyOhfho2k3Lxv7GLERQaIJ3UZDiGU/uGbIjgxI/uOcU
         +UHKLqEwFE/4Tl/3KhrKln4KvFrQ8HlfqVlYCyEjCz1X179oiZXFatXJFdAqaTXzdsO3
         tANwb89LvY3SVIXynhMvxFXt5jwiN8CiMIuL6124HPLD1jnQ+21aw9GJbleHbtY0PAop
         /OzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Qrga60o/lyaLM8rZ05SjxSzhBr8SgrRcVc1JO91zNY=;
        b=r1YudxlNz+YuI0kEoRUAbLhYTtKlYYSG0b2Shbh7hgJGbKP/1K4n+zc8YU5+TagiyX
         datgDW1wVODVaYQqHzAl1ovvNQVkv7RcnIeVOKHj8EgIXktH5ZjdFVABt4Q9CTXzOvip
         WR8OfVu8jB5izXz1m0364oq7ZSEDOLMzvcX6IeeJhxkoYDj3X4CiQuq86/p9ADRn3ulW
         49rRXNpGidNOqULwNlYOIf9BgfIjgH5NyinsMr6yab0ULL9BPCBIeuKUC3e+ktUpDuxD
         KMxVsjkem4VyhmBDIyyBcb9UdduHquIorhcd3CfplXqClMyWOrjDybUTcKOGkyPmm0if
         4wlg==
X-Gm-Message-State: AOAM531zkbKWWs0gdALMTX+3/r9RSp08iF+ebrWe2n1gCAbPpLPOUfh/
        bfEGoXdEFSIjPDnh+UrDPmpzDA==
X-Google-Smtp-Source: ABdhPJzEN0K4Yc48Di7eIl9sDiIIQOMUVR/0R1NthgAnAx54PAXVX0egmtkMb+C/jn+F3oKsGdxBYA==
X-Received: by 2002:a92:cb52:: with SMTP id f18mr55476ilq.294.1613078374166;
        Thu, 11 Feb 2021 13:19:34 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j10sm3155718ilc.50.2021.02.11.13.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 13:19:33 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 3/5] net: ipa: fix register write command validation
Date:   Thu, 11 Feb 2021 15:19:25 -0600
Message-Id: <20210211211927.28061-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210211211927.28061-1-elder@linaro.org>
References: <20210211211927.28061-1-elder@linaro.org>
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
 drivers/net/ipa/ipa_cmd.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 97b50fee60089..fd8bf6468d313 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2021 Linaro Ltd.
  */
 
 #include <linux/types.h>
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

