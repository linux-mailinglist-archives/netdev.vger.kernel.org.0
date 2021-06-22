Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB623B0B52
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhFVRWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhFVRWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D365361026;
        Tue, 22 Jun 2021 17:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624382393;
        bh=z5yOOT5esyKS8Dgsj2tlS/BuZXg2aa89V0SIURoMpXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nRIPHj2WonsG66nmeP44NbnvzWTQ7rt+z1azjIKQuMynp+rrkVlKmQ56Mr+YFPO3T
         XYR5p2FZlLlHspMkITsMpAwNnCXH4FjXCWuFDQ9Vu8LKp9dw55apD2M8pMjo+iI+/7
         8KLWAzpshP42W7Hn8UFZjmKtNmyH2YJCMOVItr8UPjYQjwamLfg8+xSnKExuqYAJ/w
         aHY45R5K/sI2astmFNEVdEiP9or3lnsXUK4ZFMy8aVW+w0ia+PUpwlqdleBYCi84Dt
         BIILJ95XVvGN738zPZrb24RsBO29oephmUdozG99mzO4prGwLvj4PxV64iro+HgBAH
         0g6mEEnqy7QZA==
Date:   Tue, 22 Jun 2021 10:19:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
Subject: Re: [PATCH net-next] ip: avoid OOM kills with large UDP sends over
 loopback
Message-ID: <20210622101952.28839d7e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210622095422.5e078bd4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20210621231307.1917413-1-kuba@kernel.org>
        <8fe00e04-3a79-6439-6ec7-5e40408529e2@gmail.com>
        <20210622095422.5e078bd4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 09:54:22 -0700 Jakub Kicinski wrote:
> > > +static inline void sk_allocation_push(struct sock *sk, gfp_t flag, gfp_t *old)
> > > +{
> > > +	*old = sk->sk_allocation;
> > > +	sk->sk_allocation |= flag;
> > > +}
> > > +    
> > 
> > This is not thread safe.
> > 
> > Remember UDP sendmsg() does not lock the socket for non-corking sends.  
> 
> Ugh, you're right :(

Hm, isn't it buggy to call sock_alloc_send_[p]skb() without holding the
lock in the first place, then? The knee jerk fix would be to add another 
layer of specialization to the helpers:

diff --git a/include/net/sock.h b/include/net/sock.h
index 7a7058f4f265..06f031705418 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1714,9 +1725,20 @@ int sock_gettstamp(struct socket *sock, void __user *userstamp,
 		   bool timeval, bool time32);
 struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
 				    int noblock, int *errcode);
-struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
-				     unsigned long data_len, int noblock,
-				     int *errcode, int max_page_order);
+struct sk_buff *__sock_alloc_send_pskb(struct sock *sk,
+				       unsigned long header_len,
+				       unsigned long data_len, int noblock,
+				       int *errcode, int max_page_order,
+				       gfp_t gfp_flags);
+
+static inline sk_buff *
+sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
+		     unsigned long data_len, int noblock, int *errcode)
+{
+	return __sock_alloc_send_pskb(sk, header_len, data_len,
+				      noblock, errcode, 0, sk->sk_allocation);
+}
+
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority);
 void sock_kfree_s(struct sock *sk, void *mem, int size);
 void sock_kzfree_s(struct sock *sk, void *mem, int size);
diff --git a/net/core/sock.c b/net/core/sock.c
index 946888afef88..64b7271a7d21 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2331,9 +2331,11 @@ static long sock_wait_for_wmem(struct sock *sk, long timeo)
  *	Generic send/receive buffer handlers
  */
 
-struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
-				     unsigned long data_len, int noblock,
-				     int *errcode, int max_page_order)
+struct sk_buff *__sock_alloc_send_pskb(struct sock *sk,
+				       unsigned long header_len,
+				       unsigned long data_len, int noblock,
+				       int *errcode, int max_page_order,
+				       gfp_t gfp_flags)
 {
 	struct sk_buff *skb;
 	long timeo;
@@ -2362,7 +2364,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 		timeo = sock_wait_for_wmem(sk, timeo);
 	}
 	skb = alloc_skb_with_frags(header_len, data_len, max_page_order,
-				   errcode, sk->sk_allocation);
+				   errcode, gfp_flags);
 	if (skb)
 		skb_set_owner_w(skb, sk);
 	return skb;
@@ -2373,7 +2375,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 	*errcode = err;
 	return NULL;
 }
-EXPORT_SYMBOL(sock_alloc_send_pskb);
+EXPORT_SYMBOL(__sock_alloc_send_pskb);
 
 struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
 				    int noblock, int *errcode)
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index c3efc7d658f6..211f1ea6cf2a 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1095,9 +1095,22 @@ static int __ip_append_data(struct sock *sk,
 				alloclen += rt->dst.trailer_len;
 
 			if (transhdrlen) {
-				skb = sock_alloc_send_skb(sk,
-						alloclen + hh_len + 15,
-						(flags & MSG_DONTWAIT), &err);
+				bool sg = rt->dst.dev->features & NETIF_F_SG;
+				size_t header_len = alloclen + hh_len + 15;
+				gfp_t sk_allocation;
+
+				sk_allocation = sk->sk_allocation;
+				if (header_len > PAGE_SIZE && sg)
+					sk_allocation |= __GFP_NORETRY;
+
+				skb = __sock_alloc_send_pskb(sk, header_len, 0,
+						(flags & MSG_DONTWAIT), &err,
+							     0, sk_allocation);
+				if (unlikely(!skb) && !paged && sg) {
+					BUILD_BUG_ON(MAX_HEADER >= PAGE_SIZE);
+					paged = true;
+					goto alloc_new_skb;
+				}
 			} else {
 				skb = NULL;
 				if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
