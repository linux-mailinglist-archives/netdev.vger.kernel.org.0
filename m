Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CD94BF0CB
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241157AbiBVDWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:22:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbiBVDV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:21:59 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FECE1705E
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:21:20 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso1041332pjs.1
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z1RLPhzHphYqp20LF1LMcNNA7U/wXwrvcaLGQpnY0ZA=;
        b=SuLpWZvVbeUZ7h1ecZYdLEsw/7C4iPAAx0psOJQ2Ub6B0MBOHiwqbwoPdVSNquvJU+
         iRy3XWpeW9Pl/ormbWwcehg3xgF9hxMUOyu9yDwDUQ2KRtbThl2s6igZj5RI67sCewPJ
         ojwjGEYa/TIg4aVt9T6u+d676OkMqMOHh6CDxMQrt+rTkq2h2dVw79sGD0wOh7g0WwHW
         MUuml7fzzwXHTzqR8k6zm/IPSRmGVxPcq9yulQsegEI8xBHu7XQ58iLxb13YicWq5IDN
         7Z++osUILVoEG/V9gfz3HxUP0lMgGoNkQ01XZe9Isn9xdPMQGSZ78u/nKD6SOWlE2eBH
         VLxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z1RLPhzHphYqp20LF1LMcNNA7U/wXwrvcaLGQpnY0ZA=;
        b=pgKSOipSJnb33nlzG3NXMz7oKB+9oirSvfKYTKBCcuEnEBuIt8UqgHqTFc7J7puyOk
         PiDS2x2LYIsQ106LRfsflt6StR6XAnVQVkM9q30LqA88p1vUTJmM+Q332dzNovFEaDw/
         n/iZdaE9CEt1zEdX3XDdEA8glLeCoXvEOU93ecRYpqMiPlDSFzn+yW3JwkZeuG3l38BR
         8L8iUOXw2tBXYO5BaazHyc7hQ5kYrj0Cuy8d1POsrS8Vaz6TZGHE3kGOhAz7BwkTvwuG
         WHLX15EyoRaf/Pa/qyVkWKgZKYaMvQyMPzgTKMoK82/wmu4sRcN72ZpWTOBCDoyzKKO+
         W89Q==
X-Gm-Message-State: AOAM531r21RM0qVZOO7akD74hUPko2hcPIBZ81IbZg0g7uQVbyeiLx2w
        pT4koNWVIctIknz2ZKPPQL4=
X-Google-Smtp-Source: ABdhPJx85+KQgccPt5gLy6UNApJCgZQeutJoCI1Kfaer8VVWxiOcSZvSS2B/oB7v8nqKK2zFmefQNw==
X-Received: by 2002:a17:90a:b88a:b0:1bc:62eb:49c with SMTP id o10-20020a17090ab88a00b001bc62eb049cmr2026696pjr.228.1645500080052;
        Mon, 21 Feb 2022 19:21:20 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f99a:9263:216c:fd72])
        by smtp.gmail.com with ESMTPSA id w198sm14799662pff.96.2022.02.21.19.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 19:21:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Marco Elver <elver@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/2] net: add skb_set_end_offset() helper
Date:   Mon, 21 Feb 2022 19:21:12 -0800
Message-Id: <20220222032113.4005821-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
In-Reply-To: <20220222032113.4005821-1-eric.dumazet@gmail.com>
References: <20220222032113.4005821-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We have multiple places where this helper is convenient,
and plan using it in the following patch.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 10 ++++++++++
 net/core/skbuff.c      | 19 +++++--------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a3e90efe65861c32078684ef29bfdefd9f92d6f3..115be7f7348759f33bb7a7c77e3341e6fefd3796 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1536,6 +1536,11 @@ static inline unsigned int skb_end_offset(const struct sk_buff *skb)
 {
 	return skb->end;
 }
+
+static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
+{
+	skb->end = offset;
+}
 #else
 static inline unsigned char *skb_end_pointer(const struct sk_buff *skb)
 {
@@ -1546,6 +1551,11 @@ static inline unsigned int skb_end_offset(const struct sk_buff *skb)
 {
 	return skb->end - skb->head;
 }
+
+static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
+{
+	skb->end = skb->head + offset;
+}
 #endif
 
 /* Internal */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9d0388bed0c1d2166214c95081f4778afe9f50ed..27a2296241c9a1b174495cc8f67c4274aec9cca3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -201,7 +201,7 @@ static void __build_skb_around(struct sk_buff *skb, void *data,
 	skb->head = data;
 	skb->data = data;
 	skb_reset_tail_pointer(skb);
-	skb->end = skb->tail + size;
+	skb_set_end_offset(skb, size);
 	skb->mac_header = (typeof(skb->mac_header))~0U;
 	skb->transport_header = (typeof(skb->transport_header))~0U;
 
@@ -1736,11 +1736,10 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	skb->head     = data;
 	skb->head_frag = 0;
 	skb->data    += off;
+
+	skb_set_end_offset(skb, size);
 #ifdef NET_SKBUFF_DATA_USES_OFFSET
-	skb->end      = size;
 	off           = nhead;
-#else
-	skb->end      = skb->head + size;
 #endif
 	skb->tail	      += off;
 	skb_headers_offset_update(skb, nhead);
@@ -6044,11 +6043,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	skb->head = data;
 	skb->data = data;
 	skb->head_frag = 0;
-#ifdef NET_SKBUFF_DATA_USES_OFFSET
-	skb->end = size;
-#else
-	skb->end = skb->head + size;
-#endif
+	skb_set_end_offset(skb, size);
 	skb_set_tail_pointer(skb, skb_headlen(skb));
 	skb_headers_offset_update(skb, 0);
 	skb->cloned = 0;
@@ -6186,11 +6181,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 	skb->head = data;
 	skb->head_frag = 0;
 	skb->data = data;
-#ifdef NET_SKBUFF_DATA_USES_OFFSET
-	skb->end = size;
-#else
-	skb->end = skb->head + size;
-#endif
+	skb_set_end_offset(skb, size);
 	skb_reset_tail_pointer(skb);
 	skb_headers_offset_update(skb, 0);
 	skb->cloned   = 0;
-- 
2.35.1.473.g83b2b277ed-goog

