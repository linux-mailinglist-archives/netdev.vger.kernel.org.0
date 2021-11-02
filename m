Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C124424DF
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 01:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhKBAso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 20:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhKBAsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 20:48:43 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFBFC061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 17:46:10 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p18so10030489plf.13
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 17:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wh2Ik3ygotj11b5Z3MXbyTyFD1dNW9or1sCT0f1xlW4=;
        b=ZyyHE2o9Ft5i0ePce7Qwg5vl+Bu34pax16/wVZjFw5LiUC7dzFQjD3iQ65t7G9DzPN
         9dKpPfYueUwLvrIrDTp35t27AZz3qTelFoGXLqyBW+EKInRgMgavNrpt85U0c90ldrFS
         wD32nGqzb1R/F8jAxAK+1kcelj7C/f3+ennQnd6I323bmrniYJW/JBsRWOt6waabh/np
         Vw7i5zfyCVbxdDevf3AIcolf24ac2+542q1HFe3W2Qbqz1eWwigpJZ09TXu5dkHqlIUs
         JpL3AAMzzeVYyU9Mq3rQCQ57Mw+FBaxQET065teqR5dJiXpJUGDtVSNxo9QWyjzN4ETa
         bWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wh2Ik3ygotj11b5Z3MXbyTyFD1dNW9or1sCT0f1xlW4=;
        b=hKpptmbyVycluMT4qxIvQmr+/bv5B2TdAf2AFHDFs1bgPmnw2a3Z5aZeOApyNaPWF5
         DC7XrZQkZlTosqNi/NHZogUwqSl2KIcWkgpXAsytvil0IDOdX5ijHIW9U2aYLd9bpxDR
         YoQtdQJEHEi4gyjAeGP2BRfAR/sZ28SGjTYQ3+19WCNMudXV6S+aE4fS3EWPD0DE+JbM
         xeIrcEUaHGo0vveKYdZSU3gSRGFFVF2UxSsfKGmndRG0pj6UDMKk/RY2cFtY94j3tzUd
         V1hC/ZG1JEAw4K4zKpjA5KNA5n1WR79ILJXjadmkbCdznDHb++EhS+jG/RtJt9L766YP
         s74w==
X-Gm-Message-State: AOAM530B9O7MYjD0HlBw3D9iZs8/qQJnl0uU59Yf51ubaYf6t82EB1LW
        lJCMtzGfW+TGS30ObmzkhEE=
X-Google-Smtp-Source: ABdhPJxkdv+iAwKs9MXJZOH7kAlQHt3xKgheDTz1Vx87hUqKE8oh9QguLdxzgRmudDkydNV3wKrLCA==
X-Received: by 2002:a17:902:bcc4:b0:141:bfc4:ada with SMTP id o4-20020a170902bcc400b00141bfc40adamr17850280pls.20.1635813969633;
        Mon, 01 Nov 2021 17:46:09 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2901:8b5a:1727:6bfb])
        by smtp.gmail.com with ESMTPSA id t7sm17080490pfj.217.2021.11.01.17.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 17:46:09 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marco Elver <elver@google.com>
Subject: [PATCH net] net: add and use skb_unclone_keeptruesize() helper
Date:   Mon,  1 Nov 2021 17:45:55 -0700
Message-Id: <20211102004555.1359210-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While commit 097b9146c0e2 ("net: fix up truesize of cloned
skb in skb_prepare_for_shift()") fixed immediate issues found
when KFENCE was enabled/tested, there are still similar issues,
when tcp_trim_head() hits KFENCE while the master skb
is cloned.

This happens under heavy networking TX workloads,
when the TX completion might be delayed after incoming ACK.

This patch fixes the WARNING in sk_stream_kill_queues
when sk->sk_mem_queued/sk->sk_forward_alloc are not zero.

Fixes: d3fb45f370d9 ("mm, kfence: insert KFENCE hooks for SLAB")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Marco Elver <elver@google.com>
---
 include/linux/skbuff.h | 16 ++++++++++++++++
 net/core/skbuff.c      | 14 +-------------
 net/ipv4/tcp_output.c  |  6 +++---
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 841e2f0f5240ba9e210bb9a3fc1cbedc2162b2a8..b8c273af2910c780dcfbc8f18fc05e115089010b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1671,6 +1671,22 @@ static inline int skb_unclone(struct sk_buff *skb, gfp_t pri)
 	return 0;
 }
 
+/* This variant of skb_unclone() makes sure skb->truesize is not changed */
+static inline int skb_unclone_keeptruesize(struct sk_buff *skb, gfp_t pri)
+{
+	might_sleep_if(gfpflags_allow_blocking(pri));
+
+	if (skb_cloned(skb)) {
+		unsigned int save = skb->truesize;
+		int res;
+
+		res = pskb_expand_head(skb, 0, 0, pri);
+		skb->truesize = save;
+		return res;
+	}
+	return 0;
+}
+
 /**
  *	skb_header_cloned - is the header a clone
  *	@skb: buffer to check
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fe9358437380c826d6438efe939afc4b38135cff..38d7dee4bbe9e96a811ff9cfca33429b5f7dbff1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3449,19 +3449,7 @@ EXPORT_SYMBOL(skb_split);
  */
 static int skb_prepare_for_shift(struct sk_buff *skb)
 {
-	int ret = 0;
-
-	if (skb_cloned(skb)) {
-		/* Save and restore truesize: pskb_expand_head() may reallocate
-		 * memory where ksize(kmalloc(S)) != ksize(kmalloc(S)), but we
-		 * cannot change truesize at this point.
-		 */
-		unsigned int save_truesize = skb->truesize;
-
-		ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
-		skb->truesize = save_truesize;
-	}
-	return ret;
+	return skb_unclone_keeptruesize(skb, GFP_ATOMIC);
 }
 
 /**
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6d72f3ea48c4ef0d193ec804653e4d4321f3f20a..0492f6942778db21f855216bf4387682fb37091e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1562,7 +1562,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 		return -ENOMEM;
 	}
 
-	if (skb_unclone(skb, gfp))
+	if (skb_unclone_keeptruesize(skb, gfp))
 		return -ENOMEM;
 
 	/* Get a new skb... force flag on. */
@@ -1672,7 +1672,7 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
 {
 	u32 delta_truesize;
 
-	if (skb_unclone(skb, GFP_ATOMIC))
+	if (skb_unclone_keeptruesize(skb, GFP_ATOMIC))
 		return -ENOMEM;
 
 	delta_truesize = __pskb_trim_head(skb, len);
@@ -3184,7 +3184,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 				 cur_mss, GFP_ATOMIC))
 			return -ENOMEM; /* We'll try again later. */
 	} else {
-		if (skb_unclone(skb, GFP_ATOMIC))
+		if (skb_unclone_keeptruesize(skb, GFP_ATOMIC))
 			return -ENOMEM;
 
 		diff = tcp_skb_pcount(skb);
-- 
2.33.1.1089.g2158813163f-goog

