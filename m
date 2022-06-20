Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE695521B5
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243981AbiFTP63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244634AbiFTP6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:58:25 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12AD1EADA
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:58:08 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n1so15048683wrg.12
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=zM/4A/0FzI3LueQp/lLuLTBhBzYoP1N8Lrg5gaf5AEI=;
        b=f+yP5nvfJFoBl1woLqazqtLILc8agwxzQRXnFprYUYFtPmrcdoxB4KNpmlseuz9r0M
         Dh+VAktizl4AI6sSmM2F8IIrx04rUeprUUE3GuxNWn58u/5/fy9IHjSVKF4NjA7KUQdc
         WHq5CLefRRhzVZHvf21iJW4fBSdNZDhq6TYe23BwPmVzGZU9Tc11uu2AGOJJFzgLkGIr
         7kPJCPYMqXzaYGW5AKoCDLgt6WUrPTPpz78Il1l6knIxmkhNJhGanGh6M1DHl0l2UqEI
         iuzQs2f2dXvP6rqf5o7T4uq1MlLSIN9sEC8kI7TauHa8dud3MSVV5qbQ48lYCv+yQcvm
         6LIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=zM/4A/0FzI3LueQp/lLuLTBhBzYoP1N8Lrg5gaf5AEI=;
        b=Y5b3iD3aubFvD1G/ZJGe/9EUsGfisbG4PQadjzwWsqi2RNwLlAe7zHxpilojVJZSO8
         Uux5lYurB98WwtXWGJM6EDkxC6F/c22Fi9HQDtqMV6/rQNHy92WdF0RPARErYq7Bo/e0
         MvxEjSS8L6bIGg6otSwTpZRTtk4YHOmTcDvEADqzNOvuExn2LFC8bSK7zsDElNyQPqV9
         Vds/11iYCMzpqYQ7Rh345pakKcuZc869zsiyRFk4zZzgIVc+ookU+VgVb9EP3MT7jI8M
         xZjgbDJHBcEmaNLWm8nUjSMTgGC8tjFd8lcWaPW8bM6oxI+EvfaF/QTIBj7axpO/zAic
         j5JA==
X-Gm-Message-State: AJIora/57OYQKATRYmQcNXMfwIKbKzFu4ezVTkfHU4mXb4DtgSuLYttj
        rNv6OlcCOu7/6KiUBpKjkGI=
X-Google-Smtp-Source: AGRyM1skeNId4253kICem5yeGCvsLb+79OsmCXhoO4WSbjxeuhvd4jETS/vRXDjGEXbbXoTy2IEvVw==
X-Received: by 2002:a05:6000:901:b0:21a:a576:23cc with SMTP id bz1-20020a056000090100b0021aa57623ccmr17464636wrb.489.1655740687322;
        Mon, 20 Jun 2022 08:58:07 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id n1-20020a5d4201000000b0021a36955493sm13740717wrq.74.2022.06.20.08.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:58:07 -0700 (PDT)
Date:   Mon, 20 Jun 2022 17:56:48 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        willemb@google.com, imagedong@tencent.com, talalahmad@google.com,
        kafai@fb.com, vasily.averin@linux.dev, luiz.von.dentz@intel.com,
        jk@codeconstruct.com.au, netdev@vger.kernel.org
Subject: [PATCH v2] net: helper function for skb_shift
Message-ID: <20220620155641.GA3846@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the len fields manipulation in the skbs to a helper function.
There is a comment specifically requesting this and there are several
other areas in the code displaying the same pattern which can be
refactored.
This improves code readability.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 include/net/sock.h   | 16 +++++++++++++---
 net/core/skbuff.c    | 13 +++----------
 net/ipv4/esp4.c      |  4 +---
 net/ipv4/ip_output.c |  8 ++------
 4 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index a01d6c421aa2..21122a22f624 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2218,6 +2218,18 @@ static inline int skb_add_data_nocache(struct sock *sk, struct sk_buff *skb,
 	return err;
 }
 
+/**
+ * skb_update_len - Updates len fields of skb
+ * @skb: buffer to add len to
+ * @len: number of bytes to add
+ */
+static inline void skb_update_len(struct sk_buff *skb, int len)
+{
+	skb->len += len;
+	skb->data_len += len;
+	skb->truesize += len;
+}
+
 static inline int skb_copy_to_page_nocache(struct sock *sk, struct iov_iter *from,
 					   struct sk_buff *skb,
 					   struct page *page,
@@ -2230,9 +2242,7 @@ static inline int skb_copy_to_page_nocache(struct sock *sk, struct iov_iter *fro
 	if (err)
 		return err;
 
-	skb->len	     += copy;
-	skb->data_len	     += copy;
-	skb->truesize	     += copy;
+	skb_update_len(skb, copy);
 	sk_wmem_queued_add(sk, copy);
 	sk_mem_charge(sk, copy);
 	return 0;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 30b523fa4ad2..e6b5dd69b78f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3195,9 +3195,7 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 		}
 	}
 
-	to->truesize += len + plen;
-	to->len += len + plen;
-	to->data_len += len + plen;
+	skb_update_len(to, len + plen);
 
 	if (unlikely(skb_orphan_frags(from, GFP_ATOMIC))) {
 		skb_tx_error(from);
@@ -3634,13 +3632,8 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 	tgt->ip_summed = CHECKSUM_PARTIAL;
 	skb->ip_summed = CHECKSUM_PARTIAL;
 
-	/* Yak, is it really working this way? Some helper please? */
-	skb->len -= shiftlen;
-	skb->data_len -= shiftlen;
-	skb->truesize -= shiftlen;
-	tgt->len += shiftlen;
-	tgt->data_len += shiftlen;
-	tgt->truesize += shiftlen;
+	skb_update_len(skb, -shiftlen);
+	skb_update_len(tgt, shiftlen);
 
 	return shiftlen;
 }
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index d747166bb291..6d4194349108 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -502,9 +502,7 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 
 			nfrags++;
 
-			skb->len += tailen;
-			skb->data_len += tailen;
-			skb->truesize += tailen;
+			skb_update_len(skb, tailen);
 			if (sk && sk_fullsock(sk))
 				refcount_add(tailen, &sk->sk_wmem_alloc);
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 00b4bf26fd93..2c46ecc495a4 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1214,9 +1214,7 @@ static int __ip_append_data(struct sock *sk,
 
 			pfrag->offset += copy;
 			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
-			skb->len += copy;
-			skb->data_len += copy;
-			skb->truesize += copy;
+			skb_update_len(skb, copy);
 			wmem_alloc_delta += copy;
 		} else {
 			err = skb_zerocopy_iter_dgram(skb, from, copy);
@@ -1443,9 +1441,7 @@ ssize_t	ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
 			skb->csum = csum_block_add(skb->csum, csum, skb->len);
 		}
 
-		skb->len += len;
-		skb->data_len += len;
-		skb->truesize += len;
+		skb_update_len(skb, len);
 		refcount_add(len, &sk->sk_wmem_alloc);
 		offset += len;
 		size -= len;
-- 
2.36.1

