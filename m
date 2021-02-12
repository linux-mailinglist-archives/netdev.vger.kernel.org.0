Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC1831A0B7
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 15:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhBLOg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 09:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhBLOfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 09:35:37 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB05C061793
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 06:34:11 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id e7so8316117ile.7
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 06:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ngv77mR7Co8Qy7c/B5fzu3p8H6PwwheqBKQO9srQZxA=;
        b=R5u4P04CZ7grGZ7fbvA5XfXzxSvuYuV+iJYbKZIHQTuGbr4BGsVOCVCdoR5YyXNJdB
         uhE75wljXlMRAul7Ry+AfoWl0dLgibGYvoBYff+S/ZeuaBW/sd/3JlVW3t0k9n3oowXS
         lN/HNcuwFhbz3ysUJ2s3xDbofUEBdXK+94CccYL/XC44/fpqCpGG8vSMfY6NQEW0B3Po
         z34rtbePrU43DaFK4xNu4Qrz8bhGmf9dYk2lyqSDJdI7u33WK6ZfvyvaKyQFBJMvId82
         RASkG/mgYVyn3xKJYsr/Zcbz9p07vbK2SKLjdGd5RK5v0KY5cMiLFOj93PVI73TJH1s+
         igMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ngv77mR7Co8Qy7c/B5fzu3p8H6PwwheqBKQO9srQZxA=;
        b=jow4UxA+CCHo87hWPyMGR/f7a8TuS7rG6FnCIcauotDj1H5eFi3VGmqFThc35ZwFDJ
         /JsH+DrzEMvyorb0K6sp3uUeDrNzhdH6VoqMyV+sEDv4EA2N3f1ypaN++WsoK02eukUZ
         f/e/uzqTcGPAzo9k8Zb2ueOwqx49yQCPEIQgWl6t4lElI07GdpcfYHgNqkgE/sa+16rT
         31RGV8UA1T69JpH9xoCNE8kaPzh3MDlSBcD5K0/Bxl/34eQNedhKoUhflcXDb+2puUOD
         j8BMxO2zxxJktGzcE7q27loVouywVdOcGyvhhnu4y5HEVnIR8kphCqgpacpXe5OYKynE
         AKAw==
X-Gm-Message-State: AOAM531Jl4snZEKULKtltkIRLrE+PqaSZwqk8zfqrVq/rWAl4povewG6
        BYH8Wkwnfgk0RTKbHhqkzKZA8Q==
X-Google-Smtp-Source: ABdhPJzxxdQB6s2y487v3A39vmX2xoUBnaAcqFTe0XyWVwvTs/IE8Vz1tB2igmSZr6A2+lZqs/lNnw==
X-Received: by 2002:a92:850d:: with SMTP id f13mr2659960ilh.216.1613140450550;
        Fri, 12 Feb 2021 06:34:10 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j12sm4387878ila.75.2021.02.12.06.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 06:34:10 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 4/5] net: ipa: introduce ipa_table_hash_support()
Date:   Fri, 12 Feb 2021 08:34:01 -0600
Message-Id: <20210212143402.2691-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210212143402.2691-1-elder@linaro.org>
References: <20210212143402.2691-1-elder@linaro.org>
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
v2: - Update copyrights.

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

