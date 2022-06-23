Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47AD5571AE
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiFWElD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347410AbiFWEfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:35:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37D430F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:49 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q138-20020a252a90000000b006694ac29d4eso6491897ybq.14
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wU6WCF7T9LlGsf1erjP98rpgqQYf0p7+pD0Eq8p6bVo=;
        b=pUmZPhVXrjdGlbnaeLKzElu9MnfSPZmne1g+/EL1Qox1l1ERItxLLf2rQpzjnPBndM
         fO42fUMCiDHbtk9oV8UENZPj0LK0QOI/uUskrWf2+rOj2XT5/j5bT0tfi1EyZDMP+OfU
         8z6JzwKA1ny7Dw/0dsc/d60TLvnXs/a3NvzDa0EuRe68lq6EJtYFaQayYwwBhXo0t0CH
         Fqv1LQ7fm1WehgKhEkUDDcEB9wL3a6CIHlk6YkpQxg8Z7epqcO38Icg+eJvjG6j44Fnz
         KjqWw8qkOE0tpwDUrn9paqSvvMicx6cYFs6hTPNyGQxdfQlToBUFHNu++N9gc/OriBx4
         5p7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wU6WCF7T9LlGsf1erjP98rpgqQYf0p7+pD0Eq8p6bVo=;
        b=OPlrPUCgS/3wjv30AmHvnQqP+Rc60qND36qOgroVw5N+4nqQroPIxt7W4/vn5u2MM8
         nAx3Jl8FUQ8iB0hsfA4So9ixTDLmcalWmT+JcDRzX1psD3tUOL/vwAis5GbzZjp9Q47f
         UTDaWz6ISmE9JXXkpscKDKkrYiT/8AvTnrWCdvhO7BPVQP+H+wdKLHC11HdMHBlgIHhj
         YCeRuVmBJPAG4M+bhk5LJjXqDqectYn9DjvGfAYQWDPpLv0IPHGFGJHJcubhHMb2a9St
         Vswfwug3cURPyWsjqXqKcPhTaagesyfI2RlN3iajaLo0zqRA9m7Rx96ULWKLvlilbJGL
         dxsA==
X-Gm-Message-State: AJIora+mC3uq6qD5rkW+z8/EEzZH6pnuZl2Wqcv9PYMaMAXKRt3/fnUi
        dXeYj+2SPKuFnh04MuT1IdwrGI9FQnMqZg==
X-Google-Smtp-Source: AGRyM1uORbST/ujU7iR5N3jptcAZ+KkY1L7yoeCeRF/X4xZIKP62Uho+9kIzJivnPhNLJ9BEfPQKCQYQaZAtNQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:7456:0:b0:668:ed94:7744 with SMTP id
 p83-20020a257456000000b00668ed947744mr6990705ybc.259.1655958949324; Wed, 22
 Jun 2022 21:35:49 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:42 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-13-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 12/19] ip6mr: do not acquire mrt_lock in ioctl(SIOCGETMIFCNT_IN6)
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rcu_read_lock() protection is good enough.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index fa6720377e82d732ccafa02b37cc28e0ab1cea07..b4ad606e24bdaf12c233f642cee303f06ccfa4eb 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1896,20 +1896,20 @@ int ip6mr_ioctl(struct sock *sk, int cmd, void __user *arg)
 		if (vr.mifi >= mrt->maxvif)
 			return -EINVAL;
 		vr.mifi = array_index_nospec(vr.mifi, mrt->maxvif);
-		read_lock(&mrt_lock);
+		rcu_read_lock();
 		vif = &mrt->vif_table[vr.mifi];
 		if (VIF_EXISTS(mrt, vr.mifi)) {
-			vr.icount = vif->pkt_in;
-			vr.ocount = vif->pkt_out;
-			vr.ibytes = vif->bytes_in;
-			vr.obytes = vif->bytes_out;
-			read_unlock(&mrt_lock);
+			vr.icount = READ_ONCE(vif->pkt_in);
+			vr.ocount = READ_ONCE(vif->pkt_out);
+			vr.ibytes = READ_ONCE(vif->bytes_in);
+			vr.obytes = READ_ONCE(vif->bytes_out);
+			rcu_read_unlock();
 
 			if (copy_to_user(arg, &vr, sizeof(vr)))
 				return -EFAULT;
 			return 0;
 		}
-		read_unlock(&mrt_lock);
+		rcu_read_unlock();
 		return -EADDRNOTAVAIL;
 	case SIOCGETSGCNT_IN6:
 		if (copy_from_user(&sr, arg, sizeof(sr)))
@@ -1971,20 +1971,20 @@ int ip6mr_compat_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
 		if (vr.mifi >= mrt->maxvif)
 			return -EINVAL;
 		vr.mifi = array_index_nospec(vr.mifi, mrt->maxvif);
-		read_lock(&mrt_lock);
+		rcu_read_lock();
 		vif = &mrt->vif_table[vr.mifi];
 		if (VIF_EXISTS(mrt, vr.mifi)) {
-			vr.icount = vif->pkt_in;
-			vr.ocount = vif->pkt_out;
-			vr.ibytes = vif->bytes_in;
-			vr.obytes = vif->bytes_out;
-			read_unlock(&mrt_lock);
+			vr.icount = READ_ONCE(vif->pkt_in);
+			vr.ocount = READ_ONCE(vif->pkt_out);
+			vr.ibytes = READ_ONCE(vif->bytes_in);
+			vr.obytes = READ_ONCE(vif->bytes_out);
+			rcu_read_unlock();
 
 			if (copy_to_user(arg, &vr, sizeof(vr)))
 				return -EFAULT;
 			return 0;
 		}
-		read_unlock(&mrt_lock);
+		rcu_read_unlock();
 		return -EADDRNOTAVAIL;
 	case SIOCGETSGCNT_IN6:
 		if (copy_from_user(&sr, arg, sizeof(sr)))
@@ -2038,8 +2038,8 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 
 #ifdef CONFIG_IPV6_PIMSM_V2
 	if (vif->flags & MIFF_REGISTER) {
-		vif->pkt_out++;
-		vif->bytes_out += skb->len;
+		WRITE_ONCE(vif->pkt_out, vif->pkt_out + 1);
+		WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
 		vif_dev->stats.tx_bytes += skb->len;
 		vif_dev->stats.tx_packets++;
 		rcu_read_lock();
@@ -2077,8 +2077,8 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 	 * result in receiving multiple packets.
 	 */
 	skb->dev = vif_dev;
-	vif->pkt_out++;
-	vif->bytes_out += skb->len;
+	WRITE_ONCE(vif->pkt_out, vif->pkt_out + 1);
+	WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
 
 	/* We are about to write */
 	/* XXX: extension headers? */
@@ -2168,8 +2168,10 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 	}
 
 forward:
-	mrt->vif_table[vif].pkt_in++;
-	mrt->vif_table[vif].bytes_in += skb->len;
+	WRITE_ONCE(mrt->vif_table[vif].pkt_in,
+		   mrt->vif_table[vif].pkt_in + 1);
+	WRITE_ONCE(mrt->vif_table[vif].bytes_in,
+		   mrt->vif_table[vif].bytes_in + skb->len);
 
 	/*
 	 *	Forward the frame
-- 
2.37.0.rc0.104.g0611611a94-goog

