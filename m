Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81EA691806
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 06:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjBJFnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 00:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjBJFnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 00:43:18 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C712C60B8C
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 21:43:16 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id b5so5421492plz.5
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 21:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SOE16gpo14kJ2EwIrQmS9P4CD4KSR3yX19I9pXw0xUw=;
        b=mnbG3Inx9g2cxrN6CsW3YFXBcbi6wMmtdtMcCb07RbVziOaeGdHHWQD+1nh1RgMmYO
         0a3K9TQBovQAyK3QV6TuzwyAr5KH4HnQU0pqz2e4sCjK2dUV2jW3V6ZPclrIpxY6hXoL
         A4YG6ij1lr9PhrpIJM+anjeg+z616nrJiLtFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SOE16gpo14kJ2EwIrQmS9P4CD4KSR3yX19I9pXw0xUw=;
        b=jGgTwiatw8H/LlDv6kiluGhGnwupa0JHbL2OsSUsK7u3uvcRJy0oV8RtfKGvX6hUYy
         gyJJ5DF5cqWlN/l+DpCj/ZgcMdl2minnib43WUzRKFVJVDErHUPrm+NvHCdB9DZnlRgY
         V7Gm8+chNtKIHZIS/RjfuFjmc/t8OOF5oaVSMClmDoXfhfkTy8RssVoI7Cou0RdJTUyw
         RgmdtZ/IcyFJnk/J9n9rUpbdmIhi2x+3aoK4GbhLSIw67NnWz/MOVSIHks7FOC2dFKGW
         bnVGDn9C5bLrnkhEOkPWOzG3hXw9nglDD3fYLp8N7BBUpfcIvrhmUJ0jQ9NO4ZmVQF5H
         qVnw==
X-Gm-Message-State: AO0yUKXIzCqXgT/RZ2Jaehy942p7MfJjWR656Fc3k9mNsJcX4cOtE1q5
        9sVQTZod1hEnfSb+F0uxw/AF3w==
X-Google-Smtp-Source: AK7set+1n5AGJexcYbatfSHJZ2Nw0rtc/AT+n0aM3Z+adx6Q/lu2rO9E0f/rQJGPlffIl4QbJSX5wA==
X-Received: by 2002:a17:902:f549:b0:199:3f82:ef49 with SMTP id h9-20020a170902f54900b001993f82ef49mr12206318plf.49.1676007796046;
        Thu, 09 Feb 2023 21:43:16 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id v8-20020a17090331c800b00199023c688esm2481518ple.26.2023.02.09.21.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 21:43:15 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] wifi: ath: Silence memcpy run-time false positive warning
Date:   Thu,  9 Feb 2023 21:43:13 -0800
Message-Id: <20230210054310.never.554-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2274; h=from:subject:message-id; bh=HpKo9sTr/HDvjHRUnQNbbmtTY7h1S1HI2SjgTQu+PF0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBj5dlx5/oUi2b864PAZJA2tYIlXO8n8wbWjG+PlQly 9C7XAsyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY+XZcQAKCRCJcvTf3G3AJlZzD/ 9+QfS5oxR9/4Qs0yKAwtDcjvnug1MfW4BnEtT2afvu7iPZkrCDin60lTjPGTN4vglnrMWT6afqpXnB XHgLTZj2ahcVuOQLBAF9mPTqGZYFEWYMLcqakJ2hKGbtM2MpzjEYSfnGbfk08ATNfrrC9vmHuk1Hce xcVxtBS1ehTzBqZBnCBzV386ODKpzGPsVezLVFr0b0hB86eQNAC0pW7cC6stmrpk5U8cyCTv20dZuZ PJkFEBjLOQZuuzP0V8BCZ867TU/el8Bx3w1/F8Ce3bkO/Km4WQBLJ5+rBMPwsLYWsTdrhDqdu3euTe Bhp89FnehAlsKcXvPnLHys4JZWQ5s1/wupi0YapBpwtlTaGioAeuKXEJzZebafhBWdv7XtQN6PogwP lvSu5npSmpiQj8iytbaqxBptNCQCmZYnhv2z9UFLBkvj1L3dZ9feb5jEU+nVwbL3jJa/D1DaP8U3Kc 2ZzjO/UrTknTbD0H4ctE/3jt/Ya1qsDBg2/JLVYrRne8C65le2FKflS229RM8Yb/IaMUarTPoHX6Pq 8Go0XC4epyRU13nhw/0ZnydH+ugnE9KAroC++PaLXm7AYp1ste2SnMkQyKGQZJ3jgv33xMXlxEaveo PE1rh9N3Ycjh+pdBdVCzJrUR4MAtEoCFKpudfDhRQge812Fsl2prEPkk5bCA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The memcpy() in ath_key_config() was attempting to write across
neighboring struct members in struct ath_keyval. Introduce a wrapping
struct_group, kv_values, to be the addressable target of the memcpy
without overflowing an individual member. Silences the false positive
run-time warning:

  memcpy: detected field-spanning write (size 32) of single field "hk.kv_val" at drivers/net/wireless/ath/key.c:506 (size 16)

Link: https://bbs.archlinux.org/viewtopic.php?id=282254
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ath/ath.h | 12 +++++++-----
 drivers/net/wireless/ath/key.c |  2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index f083fb9038c3..f02a308a9ffc 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -96,11 +96,13 @@ struct ath_keyval {
 	u8 kv_type;
 	u8 kv_pad;
 	u16 kv_len;
-	u8 kv_val[16]; /* TK */
-	u8 kv_mic[8]; /* Michael MIC key */
-	u8 kv_txmic[8]; /* Michael MIC TX key (used only if the hardware
-			 * supports both MIC keys in the same key cache entry;
-			 * in that case, kv_mic is the RX key) */
+	struct_group(kv_values,
+		u8 kv_val[16]; /* TK */
+		u8 kv_mic[8]; /* Michael MIC key */
+		u8 kv_txmic[8]; /* Michael MIC TX key (used only if the hardware
+				 * supports both MIC keys in the same key cache entry;
+				 * in that case, kv_mic is the RX key) */
+	);
 };
 
 enum ath_cipher {
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 61b59a804e30..b7b61d4f02ba 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -503,7 +503,7 @@ int ath_key_config(struct ath_common *common,
 
 	hk.kv_len = key->keylen;
 	if (key->keylen)
-		memcpy(hk.kv_val, key->key, key->keylen);
+		memcpy(&hk.kv_values, key->key, key->keylen);
 
 	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
 		switch (vif->type) {
-- 
2.34.1

