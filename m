Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CEB47C2E5
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbhLUPf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239395AbhLUPfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:35:55 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970D9C061574;
        Tue, 21 Dec 2021 07:35:54 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d9so8205178wrb.0;
        Tue, 21 Dec 2021 07:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NHE8ME2eLtzIF/v1MnQsFdVidn9PyCvdv39RROWf7fc=;
        b=ovBWMQqZUDsCBIbS8jeptc4UubI1uVUW1A0gy2VO58qznwemwF10wpfS5lQzL7D5H0
         7e1I9qRx9KPbIwd7yqUB76tN7rahCV8OKPmz++jZf5ME6DQkGxgmoBnfI5d3sofrqOgP
         Xp2R7lQ/yVKMTD8XqWZJZfBmabGbCv/Bg+I7u8Us2BDfKNnoWu+Mgt0kkdHpUcRJV1oU
         GoQg4bXE0z+/k9ApnSVV163/WODdmGrhGdja1docQnk4VmeYSCnJEAC8ydyBrb3RAoUo
         SdpWKxmIAja/Lo/ljJOIVdXUe9PKi6goM8S4PFJ+bOkp8ezXoUxiAwvGr9BlinTTtbyq
         L1Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NHE8ME2eLtzIF/v1MnQsFdVidn9PyCvdv39RROWf7fc=;
        b=CK89iy4ljPF9AzscoRh7GCAN1Wwh+Uj2udV9wlYDYusCOxBvuhV2RI6ONGcYKqEOmE
         5K/1ou5No4gb+EpzVTDI6cmlRctBWx3Ci38uF9OR02tEIWy7wo9vIXXNilbQ8mZNyVxf
         zUv97iLj2g0oE0kqZd0aiIoPxE/HQKSWCO7NOUBV6ZW5vGeYLNrfB7XDqhQs8Udn/B94
         zUB49N3zzLAnsXEU7LBgUV35QELqQvxJaJckXRfaXRdx3UfUVq+qEmq3xcpNOsc/TGca
         yPsFwFgVvKAZlqF4FpCnNWtV9DXyqqlgb8xVKPZWrUCw7qLUuq/BZdLvCNEdiQCjIBFG
         BVsA==
X-Gm-Message-State: AOAM531bCyozZlSueHBjOJsamMrtXhhIe4Ehu8OgQQWL69LcUP62kzGk
        1T+3qdo6TUtet3OahdC3jNZFR+DDrO0=
X-Google-Smtp-Source: ABdhPJx1pfUCucQ26f5ozBDWYnV52qT59g54Z+6AlnCbhyIyW2MeK6IuK0roy41Rzy+yhC5TL+MQyQ==
X-Received: by 2002:adf:e0c8:: with SMTP id m8mr3246345wri.113.1640100953014;
        Tue, 21 Dec 2021 07:35:53 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:35:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 01/19] skbuff: add SKBFL_DONT_ORPHAN flag
Date:   Tue, 21 Dec 2021 15:35:23 +0000
Message-Id: <f330899a88665c09a2cf6eb66ffd2d266f6e8703.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't want to list every single ubuf_info callback in
skb_orphan_frags(), add a flag controlling the behaviour.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 8 +++++---
 net/core/skbuff.c      | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c8cb7e697d47..b80944a9ce8f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -459,10 +459,13 @@ enum {
 	 * charged to the kernel memory.
 	 */
 	SKBFL_PURE_ZEROCOPY = BIT(2),
+
+	SKBFL_DONT_ORPHAN = BIT(3),
 };
 
 #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
-#define SKBFL_ALL_ZEROCOPY	(SKBFL_ZEROCOPY_FRAG | SKBFL_PURE_ZEROCOPY)
+#define SKBFL_ALL_ZEROCOPY	(SKBFL_ZEROCOPY_FRAG | SKBFL_PURE_ZEROCOPY | \
+				 SKBFL_DONT_ORPHAN)
 
 /*
  * The callback notifies userspace to release buffers when skb DMA is done in
@@ -2839,8 +2842,7 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
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
2.34.1

