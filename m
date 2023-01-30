Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DEE681C39
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjA3VEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjA3VD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:03:58 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D2917CEA
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:03:51 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id g16so5717571ilr.1
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/wNCgzH7OXXpYksxcizbVKUE/CMJ5l2Lr3suZg8TUds=;
        b=wBLF6pnJdn3Jnnbb13uL54pswL0stCyhafTbjIvE6CeWY6sOeO3Xeu9buwxhrDrWDP
         2IjAIHmkhEaZFZYDrZKRlLcgl+6C8NNFgsQsu+L+MNqyoUyDW5+iRpT/Tmxbqj1zpwc6
         Z1ht48ePW7+1SeYmCStPHc/5vyXUOr+h848wi6h8UI7vc8cystuEe7+rbD4KjPCNigTO
         D3h6zWOZKs1rH1wdMYfOS+zY7HpPi7OkXBpohTsKirXl5FE7CO0yKkaipKOybkJCVYOy
         p+OlsTB/ox28mRNuRLOL+/NQPJYv8HLIsKYDmPwNs0sF6koHFdkEDOF4uH2Q+ckEHpr5
         ErkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/wNCgzH7OXXpYksxcizbVKUE/CMJ5l2Lr3suZg8TUds=;
        b=Tm0XTwnkQLoR4QJbn37MFdFsl45j1vYq6Uwhrj2bw4iXy5emOhBepIpL4VUqdAWdd5
         7QNaIi9uAYx/lcD6fRRfHrtZeovtwF+PEQZxJ1Z8tuWf6aqTuaAJ0l5k5UEXsfZxJ7vl
         +Sg2gLwGalVR+cXQcCaY0s8isM4HpeuO3hZ9eUZe3jTQbNW8hZa9zNXO9vzUyigW9ffU
         Jue6M3q3A+TMz/5832I39LXqemiFzR5Of8AkICOIBw1P7cQfJfJcDj7fLup2tb+FJB/B
         dmEDsDXPshFomKJlqqmus4+fjFGRhAMAzTYu3zbzzW/Osa5ycXO5G7mJ+NwYry/SAJkU
         OM/g==
X-Gm-Message-State: AO0yUKUsGfVB1RzB6m2ab5HK0vOO5+eEmusNN09/3IYx2103/g+qyvtW
        CQbC9xSGeMgi/SG8DohbPkudzw==
X-Google-Smtp-Source: AK7set9BSoOOmpQ0C59BIU93sw8ZvwFDjHQeC5zEndueQeZrMBUPeujA3sXeLiKaROaoLbB436rE9w==
X-Received: by 2002:a05:6e02:1a42:b0:310:e798:aa2d with SMTP id u2-20020a056e021a4200b00310e798aa2dmr6098956ilv.13.1675112630340;
        Mon, 30 Jan 2023 13:03:50 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id a30-20020a02735e000000b003aef8fded9asm1992046jae.127.2023.01.30.13.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:03:49 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/8] net: ipa: update table cache flushing
Date:   Mon, 30 Jan 2023 15:01:54 -0600
Message-Id: <20230130210158.4126129-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130210158.4126129-1-elder@linaro.org>
References: <20230130210158.4126129-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the code that causes filter and router table caches to be
flushed so that it supports IPA versions 5.0+.  It adds a comment in
ipa_hardware_config_hashing() that explains that cacheing does not
need to be enabled, just as before, because it's enabled by default.
(For the record, the FILT_ROUT_CACHE_CFG register would have been
used if we wanted to explicitly enable these.)

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c   |  6 +++++-
 drivers/net/ipa/ipa_main.c  |  7 ++++++-
 drivers/net/ipa/ipa_table.c | 23 ++++++++++++++++-------
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 5d3a875e50fee..16169641ddebe 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -295,7 +295,11 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 	 * offset will fit in a register write IPA immediate command.
 	 */
 	if (ipa_table_hash_support(ipa)) {
-		reg = ipa_reg(ipa, FILT_ROUT_HASH_FLUSH);
+		if (ipa->version < IPA_VERSION_5_0)
+			reg = ipa_reg(ipa, FILT_ROUT_HASH_FLUSH);
+		else
+			reg = ipa_reg(ipa, FILT_ROUT_CACHE_FLUSH);
+
 		offset = ipa_reg_offset(reg);
 		name = "filter/route hash flush";
 		if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 4fb92f7719741..f3466b913394c 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2022 Linaro Ltd.
+ * Copyright (C) 2018-2023 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -432,6 +432,11 @@ static void ipa_hardware_config_hashing(struct ipa *ipa)
 {
 	const struct ipa_reg *reg;
 
+	/* Other than IPA v4.2, all versions enable "hashing".  Starting
+	 * with IPA v5.0, the filter and router tables are implemented
+	 * differently, but the default configuration enables this feature
+	 * (now referred to as "cacheing"), so there's nothing to do here.
+	 */
 	if (ipa->version != IPA_VERSION_4_2)
 		return;
 
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index b81e27b613549..32ed9fec2ca74 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2022 Linaro Ltd.
+ * Copyright (C) 2018-2023 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -359,13 +359,22 @@ int ipa_table_hash_flush(struct ipa *ipa)
 		return -EBUSY;
 	}
 
-	reg = ipa_reg(ipa, FILT_ROUT_HASH_FLUSH);
-	offset = ipa_reg_offset(reg);
+	if (ipa->version < IPA_VERSION_5_0) {
+		reg = ipa_reg(ipa, FILT_ROUT_HASH_FLUSH);
+		offset = ipa_reg_offset(reg);
 
-	val = ipa_reg_bit(reg, IPV6_ROUTER_HASH);
-	val |= ipa_reg_bit(reg, IPV6_FILTER_HASH);
-	val |= ipa_reg_bit(reg, IPV4_ROUTER_HASH);
-	val |= ipa_reg_bit(reg, IPV4_FILTER_HASH);
+		val = ipa_reg_bit(reg, IPV6_ROUTER_HASH);
+		val |= ipa_reg_bit(reg, IPV6_FILTER_HASH);
+		val |= ipa_reg_bit(reg, IPV4_ROUTER_HASH);
+		val |= ipa_reg_bit(reg, IPV4_FILTER_HASH);
+	} else {
+		reg = ipa_reg(ipa, FILT_ROUT_CACHE_FLUSH);
+		offset = ipa_reg_offset(reg);
+
+		/* IPA v5.0+ uses a unified cache (both IPv4 and IPv6) */
+		val = ipa_reg_bit(reg, ROUTER_CACHE);
+		val |= ipa_reg_bit(reg, FILTER_CACHE);
+	}
 
 	ipa_cmd_register_write_add(trans, offset, val, val, false);
 
-- 
2.34.1

