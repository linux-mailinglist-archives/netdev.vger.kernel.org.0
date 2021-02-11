Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D80D31950F
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhBKVV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhBKVUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:20:53 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED69C061797
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:19:36 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id u20so7219858iot.9
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IStF8omOtMMIRYTaQJuhUXxte77Gy13HZh8YPRMX9jw=;
        b=AaO/WNil1d0IglNbl3EOtwIFStOFY2YUW3SMEvQSQD+OMVyLRPFy9V6y/P7YUPvT13
         8OXWvn1FOIzvj/wP8kSMZ3SAHZSVj55fu3estS5ZfZvsNyedgwxNBGz88bS/LXMIINi9
         eGVdqchNQv4kiKlVshihBM+9CupkYNlEUVzDLHDq+FEF13WAy3EUZ4DGxaUp7PVJnZ0i
         23Fir9SEKbcG799IuMV7vGy+ggQUAHnSTD7/ro/hMnczN/yT1i0O6ILUc7xObuI4qcXC
         oKOlqKfCQK0ujdSwPtMvT0S2uXhBqwEBEw1DM4BLBfRhPGQBko8klDPodRF5kFxys2z6
         zmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IStF8omOtMMIRYTaQJuhUXxte77Gy13HZh8YPRMX9jw=;
        b=Mq5UdSKgdtX7Ko0RJV3Ri+KuCnlDK91+YMpwN0lJXIU3mxXH8y07nd6ppoMcZI1OOH
         HHcG/183Dr8CL3ljfLeS2JZ7cr7/rSum7quSEUAdg+h1C/CM/UKa35yOdqbSaVuaryBh
         JK+lqEt//d4v2wDG2eB6/TpdDDnN8SgljS1u3f4GJhRmWsNTXZCSTfTO+JkxOWz79YPx
         VCDbSOV/ZsPpkf3n8dw3uQW9qRbPmrmuZUBrEF8+lxvf8yGtQ/bH5LN8oe4/MYpvhs8z
         CgjudUc+3z1/mBVjxBKzQ/z6Gmypeek4f5iKcI7GhH7tXg1KaYhSOS0MgycThcZ3Hjwy
         s9jg==
X-Gm-Message-State: AOAM532QbREDOrYPfOPDDUp6nFBzTSYMlQfNHR8TP+tJqtFFVG5rFzpx
        Uj/1AXBjSbOFrXnqOvH5/jEU/g==
X-Google-Smtp-Source: ABdhPJyYhHkpluPFNpiG8qc/R7acS+fgII35iU6S28EOk4KTo99DGnOZ2+F0bW0IedTGvxhCoGVfCw==
X-Received: by 2002:a5d:8d92:: with SMTP id b18mr7243216ioj.167.1613078375566;
        Thu, 11 Feb 2021 13:19:35 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j10sm3155718ilc.50.2021.02.11.13.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 13:19:34 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 4/5] net: ipa: introduce ipa_table_hash_support()
Date:   Thu, 11 Feb 2021 15:19:26 -0600
Message-Id: <20210211211927.28061-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210211211927.28061-1-elder@linaro.org>
References: <20210211211927.28061-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new function to abstract the knowledge of whether hashed
routing and filter tables are supported for a given IPA instance.

IPA v4.2 is the only one that doesn't support hashed tables (now
and for the foreseeable future), but the name of the helper function
is better for explaining what's going on.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c   |  2 +-
 drivers/net/ipa/ipa_table.c | 16 +++++++++-------
 drivers/net/ipa/ipa_table.h |  8 +++++++-
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index fd8bf6468d313..35e35852c25c5 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -268,7 +268,7 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 	/* If hashed tables are supported, ensure the hash flush register
 	 * offset will fit in a register write IPA immediate command.
 	 */
-	if (ipa->version != IPA_VERSION_4_2) {
+	if (ipa_table_hash_support(ipa)) {
 		offset = ipa_reg_filt_rout_hash_flush_offset(ipa->version);
 		name = "filter/route hash flush";
 		if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 32e2d3e052d55..baaab3dd0e63c 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2021 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -239,6 +239,11 @@ static void ipa_table_validate_build(void)
 
 #endif /* !IPA_VALIDATE */
 
+bool ipa_table_hash_support(struct ipa *ipa)
+{
+	return ipa->version != IPA_VERSION_4_2;
+}
+
 /* Zero entry count means no table, so just return a 0 address */
 static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
 {
@@ -412,8 +417,7 @@ int ipa_table_hash_flush(struct ipa *ipa)
 	struct gsi_trans *trans;
 	u32 val;
 
-	/* IPA version 4.2 does not support hashed tables */
-	if (ipa->version == IPA_VERSION_4_2)
+	if (!ipa_table_hash_support(ipa))
 		return 0;
 
 	trans = ipa_cmd_trans_alloc(ipa, 1);
@@ -531,8 +535,7 @@ static void ipa_filter_config(struct ipa *ipa, bool modem)
 	enum gsi_ee_id ee_id = modem ? GSI_EE_MODEM : GSI_EE_AP;
 	u32 ep_mask = ipa->filter_map;
 
-	/* IPA version 4.2 has no hashed route tables */
-	if (ipa->version == IPA_VERSION_4_2)
+	if (!ipa_table_hash_support(ipa))
 		return;
 
 	while (ep_mask) {
@@ -582,8 +585,7 @@ static void ipa_route_config(struct ipa *ipa, bool modem)
 {
 	u32 route_id;
 
-	/* IPA version 4.2 has no hashed route tables */
-	if (ipa->version == IPA_VERSION_4_2)
+	if (!ipa_table_hash_support(ipa))
 		return;
 
 	for (route_id = 0; route_id < IPA_ROUTE_COUNT_MAX; route_id++)
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 78038d14fcea9..1a68d20f19d6a 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2021 Linaro Ltd.
  */
 #ifndef _IPA_TABLE_H_
 #define _IPA_TABLE_H_
@@ -51,6 +51,12 @@ static inline bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask)
 
 #endif /* !IPA_VALIDATE */
 
+/**
+ * ipa_table_hash_support() - Return true if hashed tables are supported
+ * @ipa:	IPA pointer
+ */
+bool ipa_table_hash_support(struct ipa *ipa);
+
 /**
  * ipa_table_reset() - Reset filter and route tables entries to "none"
  * @ipa:	IPA pointer
-- 
2.20.1

