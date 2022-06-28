Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8579055F19C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiF1WwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiF1WwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:52:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F783A735;
        Tue, 28 Jun 2022 15:52:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C579EB82064;
        Tue, 28 Jun 2022 22:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E75C341C8;
        Tue, 28 Jun 2022 22:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656456727;
        bh=8kNQyGytWQf7/KlaaDxJECJopOaWhuY2g1zLQhnc40Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jg55iHB5Biy9na3j/tjH6LM4ip/stsaU2mE5INPVlXhz6qG3bf+ZKuGORw1cxQ6Ao
         u49RNEY8N02ObYXcFt8nA9J5st4Se9J8upPMsfqaQDFIvHoE+Ds8C1sS2fTzZiijFD
         Y0qpNnH8UF+6A+JUupGfLAfLLfEBFvmNoiyERfCeUDinLG4n826GA9aKdCyPIX3nqB
         1HWlpOdQ8sLPjVHrth4YwurgWivWL28zxzUIiBD2aOEdS9QyXEvsfkaasW1j9VPMSj
         8CEOOMlIEid6NkO1eUoiBEU0wlIptxgffZTgxCct6lJzreDbqW1BbwuSCSUEIbQdrv
         2Kh1BCTnW23hw==
Date:   Tue, 28 Jun 2022 16:52:04 -0600
From:   David Ahern <dsahern@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
Subject: Re: [RFC net-next v3 05/29] net: bvec specific path in
 zerocopy_sg_from_iter
Message-ID: <20220628225204.GA27554@u2004-local>
References: <cover.1653992701.git.asml.silence@gmail.com>
 <5143111391e771dc97237e2a5e6a74223ef8f15f.1653992701.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <5143111391e771dc97237e2a5e6a74223ef8f15f.1653992701.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 28, 2022 at 07:56:27PM +0100, Pavel Begunkov wrote:
> Add an bvec specialised and optimised path in zerocopy_sg_from_iter.
> It'll be used later for {get,put}_page() optimisations.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  net/core/datagram.c | 47 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 

Rather than propagating iter functions, I have been using the attached
patch for a few months now. It leverages your ubuf_info in msghdr to
allow in kernel users to pass in their own iter handler.

--1yeeQ81UyVL57Vl7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-net-Allow-custom-iter-handler-in-uarg.patch"

From 1101177acb64832df2bb2b44d9305a8ebc4ca648 Mon Sep 17 00:00:00 2001
From: David Ahern <dsahern@kernel.org>
Date: Tue, 19 Apr 2022 10:39:59 -0600
Subject: [PATCH] net: Allow custom iter handler in uarg

Add support for custom iov_iter handling to ubuf. The idea is that
in-kernel subsystems want control over how an SG is split.

The custom iterator is a union with mmpin to keep the size of
ubuf_info <= sizeof(skb->cb) which is 48B.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 include/linux/skbuff.h | 21 ++++++++++++++++-----
 net/core/datagram.c    | 11 ++++++++---
 net/core/datagram.h    |  3 ++-
 net/core/skbuff.c      | 19 +++++++++++++++----
 net/ipv4/ip_output.c   |  2 +-
 net/ipv6/ip6_output.c  |  2 +-
 6 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dbf820a50a39..71161f65dedd 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -482,11 +482,21 @@ struct ubuf_info {
 	};
 	refcount_t refcnt;
 	u8 flags;
+	u8 has_sg_from_iter;
 
-	struct mmpin {
-		struct user_struct *user;
-		unsigned int num_pg;
-	} mmp;
+	/* sg_from_iter is expected to be used with ubuf in
+	 * msghdr and is only referenced at the transport
+	 * layer segmenting an iov into packets. mmpin is used
+	 * by in-tree ubuf_info {re,}alloc at L3 layer.
+	 */
+	union {
+		int (*sg_from_iter)(struct sock *sk, struct sk_buff *skb,
+				    struct iov_iter *from, size_t length);
+		struct mmpin {
+			struct user_struct *user;
+			unsigned int num_pg;
+		} mmp;
+	};
 };
 
 #define skb_uarg(SKB)	((struct ubuf_info *)(skb_shinfo(SKB)->destructor_arg))
@@ -503,7 +513,8 @@ void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
 void msg_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 			   bool success);
 
-int skb_zerocopy_iter_dgram(struct sk_buff *skb, struct msghdr *msg, int len);
+int skb_zerocopy_iter_dgram(struct sk_buff *skb, struct msghdr *msg, int len,
+			    struct ubuf_info *uarg);
 int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct msghdr *msg, int len,
 			     struct ubuf_info *uarg);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 15ab9ffb27fe..9ca61a0a400d 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -617,10 +617,15 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 EXPORT_SYMBOL(skb_copy_datagram_from_iter);
 
 int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
-			    struct iov_iter *from, size_t length)
+			    struct iov_iter *from, size_t length,
+			    struct ubuf_info *uarg)
 {
-	int frag = skb_shinfo(skb)->nr_frags;
+	int frag;
 
+	if (unlikely(uarg && uarg->has_sg_from_iter))
+		return uarg->sg_from_iter(sk, skb, from, length);
+
+	frag = skb_shinfo(skb)->nr_frags;
 	while (length && iov_iter_count(from)) {
 		struct page *pages[MAX_SKB_FRAGS];
 		struct page *last_head = NULL;
@@ -704,7 +709,7 @@ int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *from)
 	if (skb_copy_datagram_from_iter(skb, 0, from, copy))
 		return -EFAULT;
 
-	return __zerocopy_sg_from_iter(NULL, skb, from, ~0U);
+	return __zerocopy_sg_from_iter(NULL, skb, from, ~0U, NULL);
 }
 EXPORT_SYMBOL(zerocopy_sg_from_iter);
 
diff --git a/net/core/datagram.h b/net/core/datagram.h
index bcfb75bfa3b2..65027fcf3322 100644
--- a/net/core/datagram.h
+++ b/net/core/datagram.h
@@ -10,6 +10,7 @@ struct sk_buff;
 struct iov_iter;
 
 int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
-			    struct iov_iter *from, size_t length);
+			    struct iov_iter *from, size_t length,
+			    struct ubuf_info *uarg);
 
 #endif /* _NET_CORE_DATAGRAM_H_ */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 17b93177a68f..9acb43e5a779 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1158,6 +1158,7 @@ struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 
 	BUILD_BUG_ON(sizeof(*uarg) > sizeof(skb->cb));
 	uarg = (void *)skb->cb;
+	uarg->has_sg_from_iter = 0;
 	uarg->mmp.user = NULL;
 
 	if (mm_account_pinned_pages(&uarg->mmp, size)) {
@@ -1206,6 +1207,12 @@ struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 			return NULL;
 		}
 
+		if (WARN_ON(uarg->has_sg_from_iter)) {
+			uarg->has_sg_from_iter = 0;
+			uarg->mmp.user = NULL;
+			uarg->mmp.num_pg = 0;
+		}
+
 		next = (u32)atomic_read(&sk->sk_zckey);
 		if ((u32)(uarg->id + uarg->len) == next) {
 			if (mm_account_pinned_pages(&uarg->mmp, size))
@@ -1258,7 +1265,10 @@ static void __msg_zerocopy_callback(struct ubuf_info *uarg)
 	u32 lo, hi;
 	u16 len;
 
-	mm_unaccount_pinned_pages(&uarg->mmp);
+
+	WARN_ON(uarg->has_sg_from_iter);
+	if (!uarg->has_sg_from_iter)
+		mm_unaccount_pinned_pages(&uarg->mmp);
 
 	/* if !len, there was only 1 call, and it was aborted
 	 * so do not queue a completion notification
@@ -1319,9 +1329,10 @@ void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 }
 EXPORT_SYMBOL_GPL(msg_zerocopy_put_abort);
 
-int skb_zerocopy_iter_dgram(struct sk_buff *skb, struct msghdr *msg, int len)
+int skb_zerocopy_iter_dgram(struct sk_buff *skb, struct msghdr *msg, int len,
+			    struct ubuf_info *uarg)
 {
-	return __zerocopy_sg_from_iter(skb->sk, skb, &msg->msg_iter, len);
+	return __zerocopy_sg_from_iter(skb->sk, skb, &msg->msg_iter, len, uarg);
 }
 EXPORT_SYMBOL_GPL(skb_zerocopy_iter_dgram);
 
@@ -1339,7 +1350,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 	if (orig_uarg && uarg != orig_uarg)
 		return -EEXIST;
 
-	err = __zerocopy_sg_from_iter(sk, skb, &msg->msg_iter, len);
+	err = __zerocopy_sg_from_iter(sk, skb, &msg->msg_iter, len, uarg);
 	if (err == -EFAULT || (err == -EMSGSIZE && skb->len == orig_len)) {
 		struct sock *save_sk = skb->sk;
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 1b6a64b19c76..1ff403c2dcb0 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1238,7 +1238,7 @@ static int __ip_append_data(struct sock *sk,
 			skb->truesize += copy;
 			wmem_alloc_delta += copy;
 		} else {
-			err = skb_zerocopy_iter_dgram(skb, from, copy);
+			err = skb_zerocopy_iter_dgram(skb, from, copy, uarg);
 			if (err < 0)
 				goto error;
 		}
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 63a217128f8b..6795144653ac 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1791,7 +1791,7 @@ static int __ip6_append_data(struct sock *sk,
 			skb->truesize += copy;
 			wmem_alloc_delta += copy;
 		} else {
-			err = skb_zerocopy_iter_dgram(skb, from, copy);
+			err = skb_zerocopy_iter_dgram(skb, from, copy, uarg);
 			if (err < 0)
 				goto error;
 		}
-- 
2.25.1


--1yeeQ81UyVL57Vl7--
