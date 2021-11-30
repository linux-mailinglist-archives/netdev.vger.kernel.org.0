Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF424639DF
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243202AbhK3PYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245056AbhK3PX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:27 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BC7C061376;
        Tue, 30 Nov 2021 07:19:20 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id l16so45201297wrp.11;
        Tue, 30 Nov 2021 07:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wYoGOjP1qgzxWAnYrLXhDnTMkpReRIX9LA5n6MsGWNs=;
        b=YHyyEq3f0kBU2I3kngd9RBrs3EiT3kUBhg9v27N+jy8Wz2rP5+jM6BSrcPgt/wqNVq
         NK7AIFLE8pLhgGj8bPwBJMGBEqrtOFSpddHPtkeDX5Sab7xIamukDZPgSvijxFO4dH1K
         mLlPt5S/0JxM5ryLudklKL0B/utQKyaFgAr4mWjUPCpZQfL6nmxgWQvTcmFRhFs7ZGXf
         MI2d7u0L5sbQAOS00oWl151DkZRZcf6L0RVK7n+tr2N1HkscMWeqp/H8n35mMlCCk1Rg
         W7g4L/M32te83ufNFvFEFskjBo31yz9W+et24sbGm+A5mJlU1rGw0/UkYD6I6qbwMMLP
         TpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wYoGOjP1qgzxWAnYrLXhDnTMkpReRIX9LA5n6MsGWNs=;
        b=UUCR+58bPtHFeQAsBxoSydp8Fqux9Ki8NCgNDApOcWxlZu+/5YE6L58jXkX+hYdoyS
         cq3XmJs/S2Is0LD/vzC6tkUdfvpVH+HloBtTTq1ZTrmsRV2yCYwR8gty8xoZaysUD3vw
         MQWrCsVBkO1Ee0dUWs63iX94PTQUJjD8UOwJXNlCN23Nm5mzywXMEwQm1mCNEP9mtFWM
         3n8bdsWjS7t6fumxrafPGTBc3gCsVVB9vDw4vomBYTaXszg/GHqU7IFvy8gdmMBBpPcG
         DmJizGzsLPdGMDF52pgQDVWVo2giAKwVBLSsCQ1g3pGTQ2oape30KWu9sx1ncJP4i6/h
         rC1Q==
X-Gm-Message-State: AOAM531NvqxnotJy+vrdz/UpYNNuJU0nsNYwH3mXdz/L80oHG9HVMMMD
        bj8on8oO7rZG7BIy8g71pnU331KSLTk=
X-Google-Smtp-Source: ABdhPJzbhIYydzfuouAWnaI3AWEq+lyO8VxwgoR5pYdE2F+Wye/YXWeULUbif4Am6fEMR1CkTqXvoA==
X-Received: by 2002:a5d:4a85:: with SMTP id o5mr41066948wrq.109.1638285559139;
        Tue, 30 Nov 2021 07:19:19 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:18 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC 01/12] skbuff: add SKBFL_DONT_ORPHAN flag
Date:   Tue, 30 Nov 2021 15:18:49 +0000
Message-Id: <079685f334f479f70dfed5ab98e06fbfaf81ee3b.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't want to list every single ubuf_info callback in
skb_orphan_frags(), add a flag controlling the behaviour.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 5 +++--
 net/core/skbuff.c      | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c8cb7e697d47..750b7518d6e2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -459,6 +459,8 @@ enum {
 	 * charged to the kernel memory.
 	 */
 	SKBFL_PURE_ZEROCOPY = BIT(2),
+
+	SKBFL_DONT_ORPHAN = BIT(3),
 };
 
 #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
@@ -2839,8 +2841,7 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
 {
 	if (likely(!skb_zcopy(skb)))
 		return 0;
-	if (!skb_zcopy_is_nouarg(skb) &&
-	    skb_uarg(skb)->callback == msg_zerocopy_callback)
+	if (skb_shinfo(skb)->flags & SKBFL_DONT_ORPHAN)
 		return 0;
 	return skb_copy_ubufs(skb, gfp_mask);
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ba2f38246f07..b23db60ea6f9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1191,7 +1191,7 @@ struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 	uarg->len = 1;
 	uarg->bytelen = size;
 	uarg->zerocopy = 1;
-	uarg->flags = SKBFL_ZEROCOPY_FRAG;
+	uarg->flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 	refcount_set(&uarg->refcnt, 1);
 	sock_hold(sk);
 
-- 
2.34.0

