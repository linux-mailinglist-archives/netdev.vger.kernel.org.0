Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F0C6C4C9B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjCVN6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjCVN5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:57:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71665AB7D
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679493388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G0nR45WZqCZ3wypkdOhm61JxkguAfiQTHRP9kCCZS7E=;
        b=UDD/tf0eg+bY/2igC2ge1RHKq6pS6VHuLYcoXhubb9+Q4WK2GIfjuAy59ZAaTAyMIaNlxJ
        wiBaqgCZz4q9CmmpbhvlYFWRDFYif6bkX2l05VyWHdzinvcQYZkENS8zV1nTdkJloQTt38
        JQXTnumI9s0B88hNqqlTkIQgE88+dDo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-IWmzyRW8NCeVcEPMLqBz0Q-1; Wed, 22 Mar 2023 09:56:25 -0400
X-MC-Unique: IWmzyRW8NCeVcEPMLqBz0Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A804280BF6A;
        Wed, 22 Mar 2023 13:56:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D53E442C827;
        Wed, 22 Mar 2023 13:56:22 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@kernel.org>
Subject: [RFC PATCH 2/3] ip: Make __ip{,6}_append_data() and co. take a msghdr*
Date:   Wed, 22 Mar 2023 13:56:11 +0000
Message-Id: <20230322135612.3265850-3-dhowells@redhat.com>
In-Reply-To: <20230322135612.3265850-1-dhowells@redhat.com>
References: <6419bda5a2b4d_59e87208ca@willemb.c.googlers.com.notmuch>
 <20230322135612.3265850-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to pass an extra internal flag to indicate that sendmsg() should
splice pages rather than copying them, pass a struct msghdr pointer into
various paths that lead to __ip_append_data() and __ip6_append_data() and
thence into getfrag().  The flag can then be stashed in the msghdr struct
in a new field to avoid polluting the msg_flags field with non-UAPI flags.

Passing msghdr around like this allows the length and flags arguments to
__ip*_append_data() to be eliminated (the values can be obtained from the
msghdr and its iterator).  Unfortunately, the "from" parameter can't be so
easily eliminated as it's used by the icmp routines particularly.

The getfrag function pointer is formalised as ip_getfrag_t by typedef.

This requires the following additional changes:

 (1) __ip_append_data() and __ip6_append_data() add transhdrlen onto the
     data length inside the functions rather than it being included in
     msg_data_left().

 (2) A few places, such as icmp_glue_bits(), have to create a msghdr they
     didn't need before in order to pass in flags and length.  They also
     need to cheat a bit and stash the length in msg->msg_iter.count - even
     though they don't actually use the iterator.

 (3) udp_sendmsg() OR's MSG_MORE into msg->msg_flags if the corkflag is
     set.  Separate flags don't then need to be passed in to
     ip_append_data().  Ditto udpv6_sendmsg().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
cc: David Ahern <dsahern@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 include/net/ip.h      | 24 ++++++--------
 include/net/ipv6.h    | 20 ++++++------
 include/net/ping.h    |  5 ++-
 include/net/udplite.h |  4 +--
 net/ipv4/icmp.c       | 14 +++++----
 net/ipv4/ip_output.c  | 73 ++++++++++++++++++++++---------------------
 net/ipv4/ping.c       | 10 +++---
 net/ipv4/raw.c        | 20 ++++++------
 net/ipv4/udp.c        | 19 ++++++-----
 net/ipv6/icmp.c       | 21 ++++++++-----
 net/ipv6/ip6_output.c | 57 +++++++++++++++------------------
 net/ipv6/ping.c       |  7 ++---
 net/ipv6/raw.c        | 22 ++++++-------
 net/ipv6/udp.c        | 19 ++++++-----
 14 files changed, 155 insertions(+), 160 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index c3fffaa92d6e..152553bd9ad4 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -211,15 +211,13 @@ int ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
 int __ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
 		    __u8 tos);
 void ip_init(void);
-int ip_append_data(struct sock *sk, struct flowi4 *fl4,
-		   int getfrag(void *from, char *to, int offset, int len,
-			       int odd, struct sk_buff *skb),
-		   void *from, int len, int protolen,
-		   struct ipcm_cookie *ipc,
-		   struct rtable **rt,
-		   unsigned int flags);
-int ip_generic_getfrag(void *from, char *to, int offset, int len, int odd,
-		       struct sk_buff *skb);
+typedef int (*ip_getfrag_t)(struct msghdr *msg, void *from, char *to,
+			    int offset, int len, int odd, struct sk_buff *skb);
+int ip_append_data(struct sock *sk, struct flowi4 *fl4, struct msghdr *msg,
+		   ip_getfrag_t getfrag, void *from, int protolen,
+		   struct ipcm_cookie *ipc, struct rtable **rt);
+int ip_generic_getfrag(struct msghdr *msg, void *from, char *to,
+		       int offset, int len, int odd, struct sk_buff *skb);
 ssize_t ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
 		       int offset, size_t size, int flags);
 struct sk_buff *__ip_make_skb(struct sock *sk, struct flowi4 *fl4,
@@ -228,12 +226,10 @@ struct sk_buff *__ip_make_skb(struct sock *sk, struct flowi4 *fl4,
 int ip_send_skb(struct net *net, struct sk_buff *skb);
 int ip_push_pending_frames(struct sock *sk, struct flowi4 *fl4);
 void ip_flush_pending_frames(struct sock *sk);
-struct sk_buff *ip_make_skb(struct sock *sk, struct flowi4 *fl4,
-			    int getfrag(void *from, char *to, int offset,
-					int len, int odd, struct sk_buff *skb),
-			    void *from, int length, int transhdrlen,
+struct sk_buff *ip_make_skb(struct sock *sk, struct flowi4 *fl4, struct msghdr *msg,
+			    ip_getfrag_t getfrag, int transhdrlen,
 			    struct ipcm_cookie *ipc, struct rtable **rtp,
-			    struct inet_cork *cork, unsigned int flags);
+			    struct inet_cork *cork);
 
 int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl);
 
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index f2132311e92b..bec2ecf31076 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1094,12 +1094,13 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 
 int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr);
 
-int ip6_append_data(struct sock *sk,
-		    int getfrag(void *from, char *to, int offset, int len,
-				int odd, struct sk_buff *skb),
-		    void *from, size_t length, int transhdrlen,
+typedef int (*ip_getfrag_t)(struct msghdr *msg, void *from, char *to,
+			    int offset, int len, int odd, struct sk_buff *skb);
+
+int ip6_append_data(struct sock *sk, struct msghdr *msg,
+		    ip_getfrag_t getfrag, void *from, int transhdrlen,
 		    struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
-		    struct rt6_info *rt, unsigned int flags);
+		    struct rt6_info *rt);
 
 int ip6_push_pending_frames(struct sock *sk);
 
@@ -1110,12 +1111,9 @@ int ip6_send_skb(struct sk_buff *skb);
 struct sk_buff *__ip6_make_skb(struct sock *sk, struct sk_buff_head *queue,
 			       struct inet_cork_full *cork,
 			       struct inet6_cork *v6_cork);
-struct sk_buff *ip6_make_skb(struct sock *sk,
-			     int getfrag(void *from, char *to, int offset,
-					 int len, int odd, struct sk_buff *skb),
-			     void *from, size_t length, int transhdrlen,
-			     struct ipcm6_cookie *ipc6,
-			     struct rt6_info *rt, unsigned int flags,
+struct sk_buff *ip6_make_skb(struct sock *sk, struct msghdr *msg,
+			     ip_getfrag_t getfrag, void *from, int transhdrlen,
+			     struct ipcm6_cookie *ipc6, struct rt6_info *rt,
 			     struct inet_cork_full *cork);
 
 static inline struct sk_buff *ip6_finish_skb(struct sock *sk)
diff --git a/include/net/ping.h b/include/net/ping.h
index 04814edde8e3..cfa7cbeb5ebc 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -52,7 +52,6 @@ extern struct pingv6_ops pingv6_ops;
 
 struct pingfakehdr {
 	struct icmphdr icmph;
-	struct msghdr *msg;
 	sa_family_t family;
 	__wsum wcheck;
 };
@@ -65,8 +64,8 @@ int  ping_init_sock(struct sock *sk);
 void ping_close(struct sock *sk, long timeout);
 int  ping_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 void ping_err(struct sk_buff *skb, int offset, u32 info);
-int  ping_getfrag(void *from, char *to, int offset, int fraglen, int odd,
-		  struct sk_buff *);
+int  ping_getfrag(struct msghdr *msg, void *from, char *to,
+		  int offset, int fraglen, int odd, struct sk_buff *skb);
 
 int  ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		  int flags, int *addr_len);
diff --git a/include/net/udplite.h b/include/net/udplite.h
index 299c14ce2bb9..13ffb096154f 100644
--- a/include/net/udplite.h
+++ b/include/net/udplite.h
@@ -18,10 +18,10 @@ extern struct udp_table		udplite_table;
 /*
  *	Checksum computation is all in software, hence simpler getfrag.
  */
-static __inline__ int udplite_getfrag(void *from, char *to, int  offset,
+static __inline__ int udplite_getfrag(struct msghdr *msg,
+				      void *from, char *to, int  offset,
 				      int len, int odd, struct sk_buff *skb)
 {
-	struct msghdr *msg = from;
 	return copy_from_iter_full(to, len, &msg->msg_iter) ? 0 : -EFAULT;
 }
 
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 8cebb476b3ab..5496cd50285a 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -344,8 +344,8 @@ void icmp_out_count(struct net *net, unsigned char type)
  *	Checksum each fragment, and on the first include the headers and final
  *	checksum.
  */
-static int icmp_glue_bits(void *from, char *to, int offset, int len, int odd,
-			  struct sk_buff *skb)
+static int icmp_glue_bits(struct msghdr *msg, void *from, char *to,
+			  int offset, int len, int odd, struct sk_buff *skb)
 {
 	struct icmp_bxm *icmp_param = from;
 	__wsum csum;
@@ -366,11 +366,13 @@ static void icmp_push_reply(struct sock *sk,
 			    struct ipcm_cookie *ipc, struct rtable **rt)
 {
 	struct sk_buff *skb;
+	struct msghdr msg = {
+		.msg_flags	= MSG_DONTWAIT,
+		.msg_iter.count	= icmp_param->data_len,
+	};
 
-	if (ip_append_data(sk, fl4, icmp_glue_bits, icmp_param,
-			   icmp_param->data_len+icmp_param->head_len,
-			   icmp_param->head_len,
-			   ipc, rt, MSG_DONTWAIT) < 0) {
+	if (ip_append_data(sk, fl4, &msg, icmp_glue_bits, icmp_param,
+			   icmp_param->head_len, ipc, rt) < 0) {
 		__ICMP_INC_STATS(sock_net(sk), ICMP_MIB_OUTERRORS);
 		ip_flush_pending_frames(sk);
 	} else if ((skb = skb_peek(&sk->sk_write_queue)) != NULL) {
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index cb04dbad9ea4..46ab2ea25764 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -929,10 +929,9 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 EXPORT_SYMBOL(ip_do_fragment);
 
 int
-ip_generic_getfrag(void *from, char *to, int offset, int len, int odd, struct sk_buff *skb)
+ip_generic_getfrag(struct msghdr *msg, void *from, char *to,
+		   int offset, int len, int odd, struct sk_buff *skb)
 {
-	struct msghdr *msg = from;
-
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		if (!copy_from_iter_full(to, len, &msg->msg_iter))
 			return -EFAULT;
@@ -959,13 +958,12 @@ csum_page(struct page *page, int offset, int copy)
 
 static int __ip_append_data(struct sock *sk,
 			    struct flowi4 *fl4,
+			    struct msghdr *msg,
 			    struct sk_buff_head *queue,
 			    struct inet_cork *cork,
 			    struct page_frag *pfrag,
-			    int getfrag(void *from, char *to, int offset,
-					int len, int odd, struct sk_buff *skb),
-			    void *from, int length, int transhdrlen,
-			    unsigned int flags)
+			    ip_getfrag_t getfrag,
+			    void *from, int transhdrlen)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct ubuf_info *uarg = NULL;
@@ -978,6 +976,7 @@ static int __ip_append_data(struct sock *sk,
 	int err;
 	int offset = 0;
 	bool zc = false;
+	unsigned int length = msg_data_left(msg) + transhdrlen;
 	unsigned int maxfraglen, fragheaderlen, maxnonfragsize;
 	int csummode = CHECKSUM_NONE;
 	struct rtable *rt = (struct rtable *)cork->dst;
@@ -1014,11 +1013,11 @@ static int __ip_append_data(struct sock *sk,
 	if (transhdrlen &&
 	    length + fragheaderlen <= mtu &&
 	    rt->dst.dev->features & (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM) &&
-	    (!(flags & MSG_MORE) || cork->gso_size) &&
+	    (!(msg->msg_flags & MSG_MORE) || cork->gso_size) &&
 	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
 		csummode = CHECKSUM_PARTIAL;
 
-	if ((flags & MSG_ZEROCOPY) && length) {
+	if ((msg->msg_flags & MSG_ZEROCOPY) && length) {
 		struct msghdr *msg = from;
 
 		if (getfrag == ip_generic_getfrag && msg->msg_ubuf) {
@@ -1103,7 +1102,7 @@ static int __ip_append_data(struct sock *sk,
 			if (datalen == length + fraggap)
 				alloc_extra += rt->dst.trailer_len;
 
-			if ((flags & MSG_MORE) &&
+			if ((msg->msg_flags & MSG_MORE) &&
 			    !(rt->dst.dev->features&NETIF_F_SG))
 				alloclen = mtu;
 			else if (!paged &&
@@ -1119,7 +1118,7 @@ static int __ip_append_data(struct sock *sk,
 
 			if (transhdrlen) {
 				skb = sock_alloc_send_skb(sk, alloclen,
-						(flags & MSG_DONTWAIT), &err);
+						(msg->msg_flags & MSG_DONTWAIT), &err);
 			} else {
 				skb = NULL;
 				if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
@@ -1159,7 +1158,8 @@ static int __ip_append_data(struct sock *sk,
 			}
 
 			copy = datalen - transhdrlen - fraggap - pagedlen;
-			if (copy > 0 && getfrag(from, data + transhdrlen, offset, copy, fraggap, skb) < 0) {
+			if (copy > 0 && getfrag(msg, from, data + transhdrlen,
+						offset, copy, fraggap, skb) < 0) {
 				err = -EFAULT;
 				kfree_skb(skb);
 				goto error;
@@ -1178,7 +1178,7 @@ static int __ip_append_data(struct sock *sk,
 			tskey = 0;
 			skb_zcopy_set(skb, uarg, &extra_uref);
 
-			if ((flags & MSG_CONFIRM) && !skb_prev)
+			if ((msg->msg_flags & MSG_CONFIRM) && !skb_prev)
 				skb_set_dst_pending_confirm(skb, 1);
 
 			/*
@@ -1201,8 +1201,8 @@ static int __ip_append_data(struct sock *sk,
 			unsigned int off;
 
 			off = skb->len;
-			if (getfrag(from, skb_put(skb, copy),
-					offset, copy, off, skb) < 0) {
+			if (getfrag(msg, from, skb_put(skb, copy),
+				    offset, copy, off, skb) < 0) {
 				__skb_trim(skb, off);
 				err = -EFAULT;
 				goto error;
@@ -1227,7 +1227,7 @@ static int __ip_append_data(struct sock *sk,
 				get_page(pfrag->page);
 			}
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
-			if (getfrag(from,
+			if (getfrag(msg, from,
 				    page_address(pfrag->page) + pfrag->offset,
 				    offset, copy, skb->len, skb) < 0)
 				goto error_efault;
@@ -1320,17 +1320,14 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
  *
  *	LATER: length must be adjusted by pad at tail, when it is required.
  */
-int ip_append_data(struct sock *sk, struct flowi4 *fl4,
-		   int getfrag(void *from, char *to, int offset, int len,
-			       int odd, struct sk_buff *skb),
-		   void *from, int length, int transhdrlen,
-		   struct ipcm_cookie *ipc, struct rtable **rtp,
-		   unsigned int flags)
+int ip_append_data(struct sock *sk, struct flowi4 *fl4, struct msghdr *msg,
+		   ip_getfrag_t getfrag, void *from, int transhdrlen,
+		   struct ipcm_cookie *ipc, struct rtable **rtp)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	int err;
 
-	if (flags&MSG_PROBE)
+	if (msg->msg_flags & MSG_PROBE)
 		return 0;
 
 	if (skb_queue_empty(&sk->sk_write_queue)) {
@@ -1341,9 +1338,9 @@ int ip_append_data(struct sock *sk, struct flowi4 *fl4,
 		transhdrlen = 0;
 	}
 
-	return __ip_append_data(sk, fl4, &sk->sk_write_queue, &inet->cork.base,
-				sk_page_frag(sk), getfrag,
-				from, length, transhdrlen, flags);
+	return __ip_append_data(sk, fl4, msg, &sk->sk_write_queue,
+				&inet->cork.base, sk_page_frag(sk),
+				getfrag, from, transhdrlen);
 }
 
 ssize_t	ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
@@ -1629,16 +1626,16 @@ void ip_flush_pending_frames(struct sock *sk)
 
 struct sk_buff *ip_make_skb(struct sock *sk,
 			    struct flowi4 *fl4,
-			    int getfrag(void *from, char *to, int offset,
-					int len, int odd, struct sk_buff *skb),
-			    void *from, int length, int transhdrlen,
+			    struct msghdr *msg,
+			    ip_getfrag_t getfrag,
+			    int transhdrlen,
 			    struct ipcm_cookie *ipc, struct rtable **rtp,
-			    struct inet_cork *cork, unsigned int flags)
+			    struct inet_cork *cork)
 {
 	struct sk_buff_head queue;
 	int err;
 
-	if (flags & MSG_PROBE)
+	if (msg->msg_flags & MSG_PROBE)
 		return NULL;
 
 	__skb_queue_head_init(&queue);
@@ -1650,9 +1647,9 @@ struct sk_buff *ip_make_skb(struct sock *sk,
 	if (err)
 		return ERR_PTR(err);
 
-	err = __ip_append_data(sk, fl4, &queue, cork,
+	err = __ip_append_data(sk, fl4, msg, &queue, cork,
 			       &current->task_frag, getfrag,
-			       from, length, transhdrlen, flags);
+			       msg, transhdrlen);
 	if (err) {
 		__ip_flush_pending_frames(sk, &queue, cork);
 		return ERR_PTR(err);
@@ -1664,7 +1661,7 @@ struct sk_buff *ip_make_skb(struct sock *sk,
 /*
  *	Fetch data from kernel space and fill in checksum if needed.
  */
-static int ip_reply_glue_bits(void *dptr, char *to, int offset,
+static int ip_reply_glue_bits(struct msghdr *msg, void *dptr, char *to, int offset,
 			      int len, int odd, struct sk_buff *skb)
 {
 	__wsum csum;
@@ -1690,6 +1687,10 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 	struct rtable *rt = skb_rtable(skb);
 	struct net *net = sock_net(sk);
 	struct sk_buff *nskb;
+	struct msghdr msg = {
+		.msg_flags	= MSG_DONTWAIT,
+		.msg_iter.count	= len,
+	};
 	int err;
 	int oif;
 
@@ -1730,8 +1731,8 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 	sk->sk_bound_dev_if = arg->bound_dev_if;
 	sk->sk_sndbuf = READ_ONCE(sysctl_wmem_default);
 	ipc.sockc.mark = fl4.flowi4_mark;
-	err = ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
-			     len, 0, &ipc, &rt, MSG_DONTWAIT);
+	err = ip_append_data(sk, &fl4, &msg, ip_reply_glue_bits, arg->iov->iov_base,
+			     0, &ipc, &rt);
 	if (unlikely(err)) {
 		ip_flush_pending_frames(sk);
 		goto out;
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index f689f9f530c9..e93e0a8849cb 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -617,13 +617,13 @@ EXPORT_SYMBOL_GPL(ping_err);
  *	starting from the payload.
  */
 
-int ping_getfrag(void *from, char *to,
+int ping_getfrag(struct msghdr *msg, void *from, char *to,
 		 int offset, int fraglen, int odd, struct sk_buff *skb)
 {
 	struct pingfakehdr *pfh = from;
 
 	if (!csum_and_copy_from_iter_full(to, fraglen, &pfh->wcheck,
-					  &pfh->msg->msg_iter))
+					  &msg->msg_iter))
 		return -EFAULT;
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -832,13 +832,11 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg)
 	pfh.icmph.checksum = 0;
 	pfh.icmph.un.echo.id = inet->inet_sport;
 	pfh.icmph.un.echo.sequence = user_icmph.un.echo.sequence;
-	pfh.msg = msg;
 	pfh.wcheck = 0;
 	pfh.family = AF_INET;
 
-	err = ip_append_data(sk, &fl4, ping_getfrag, &pfh, len,
-			     sizeof(struct icmphdr), &ipc, &rt,
-			     msg->msg_flags);
+	err = ip_append_data(sk, &fl4, msg, ping_getfrag, &pfh,
+			     sizeof(struct icmphdr), &ipc, &rt);
 	if (err)
 		ip_flush_pending_frames(sk);
 	else
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index f2859c117796..504045163f86 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -77,7 +77,6 @@
 #include <linux/uio.h>
 
 struct raw_frag_vec {
-	struct msghdr *msg;
 	union {
 		struct icmphdr icmph;
 		char c[1];
@@ -420,7 +419,8 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 	return err;
 }
 
-static int raw_probe_proto_opt(struct raw_frag_vec *rfv, struct flowi4 *fl4)
+static int raw_probe_proto_opt(struct msghdr *msg, struct raw_frag_vec *rfv,
+			       struct flowi4 *fl4)
 {
 	int err;
 
@@ -430,7 +430,7 @@ static int raw_probe_proto_opt(struct raw_frag_vec *rfv, struct flowi4 *fl4)
 	/* We only need the first two bytes. */
 	rfv->hlen = 2;
 
-	err = memcpy_from_msg(rfv->hdr.c, rfv->msg, rfv->hlen);
+	err = memcpy_from_msg(rfv->hdr.c, msg, rfv->hlen);
 	if (err)
 		return err;
 
@@ -440,8 +440,8 @@ static int raw_probe_proto_opt(struct raw_frag_vec *rfv, struct flowi4 *fl4)
 	return 0;
 }
 
-static int raw_getfrag(void *from, char *to, int offset, int len, int odd,
-		       struct sk_buff *skb)
+static int raw_getfrag(struct msghdr *msg, void *from, char *to,
+		       int offset, int len, int odd, struct sk_buff *skb)
 {
 	struct raw_frag_vec *rfv = from;
 
@@ -468,7 +468,7 @@ static int raw_getfrag(void *from, char *to, int offset, int len, int odd,
 
 	offset -= rfv->hlen;
 
-	return ip_generic_getfrag(rfv->msg, to, offset, len, odd, skb);
+	return ip_generic_getfrag(msg, NULL, to, offset, len, odd, skb);
 }
 
 static int raw_sendmsg(struct sock *sk, struct msghdr *msg)
@@ -608,10 +608,9 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg)
 			   daddr, saddr, 0, 0, sk->sk_uid);
 
 	if (!hdrincl) {
-		rfv.msg = msg;
 		rfv.hlen = 0;
 
-		err = raw_probe_proto_opt(&rfv, &fl4);
+		err = raw_probe_proto_opt(msg, &rfv, &fl4);
 		if (err)
 			goto done;
 	}
@@ -640,9 +639,8 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg)
 		if (!ipc.addr)
 			ipc.addr = fl4.daddr;
 		lock_sock(sk);
-		err = ip_append_data(sk, &fl4, raw_getfrag,
-				     &rfv, len, 0,
-				     &ipc, &rt, msg->msg_flags);
+		err = ip_append_data(sk, &fl4, msg, raw_getfrag,
+				     &rfv, 0, &ipc, &rt);
 		if (err)
 			ip_flush_pending_frames(sk);
 		else if (!(msg->msg_flags & MSG_MORE)) {
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index b2ed9d37a362..bb2e2e98c94c 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1066,11 +1066,16 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg)
 	__be16 dport;
 	u8  tos;
 	int err, is_udplite = IS_UDPLITE(sk);
-	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
-	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
+	bool corkreq = READ_ONCE(up->corkflag);
+	ip_getfrag_t getfrag;
 	struct sk_buff *skb;
 	struct ip_options_data opt_copy;
 
+	if (corkreq)
+		msg->msg_flags |= MSG_MORE;
+	else
+		corkreq = msg->msg_flags & MSG_MORE;
+
 	if (len > 0xFFFF)
 		return -EMSGSIZE;
 
@@ -1258,9 +1263,8 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg)
 	if (!corkreq) {
 		struct inet_cork cork;
 
-		skb = ip_make_skb(sk, fl4, getfrag, msg, ulen,
-				  sizeof(struct udphdr), &ipc, &rt,
-				  &cork, msg->msg_flags);
+		skb = ip_make_skb(sk, fl4, msg, getfrag,
+				  sizeof(struct udphdr), &ipc, &rt, &cork);
 		err = PTR_ERR(skb);
 		if (!IS_ERR_OR_NULL(skb))
 			err = udp_send_skb(skb, fl4, &cork);
@@ -1289,9 +1293,8 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg)
 
 do_append_data:
 	up->len += ulen;
-	err = ip_append_data(sk, fl4, getfrag, msg, ulen,
-			     sizeof(struct udphdr), &ipc, &rt,
-			     corkreq ? msg->msg_flags|MSG_MORE : msg->msg_flags);
+	err = ip_append_data(sk, fl4, msg, getfrag, NULL,
+			     sizeof(struct udphdr), &ipc, &rt);
 	if (err)
 		udp_flush_pending_frames(sk);
 	else if (!corkreq)
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 1f53f2a74480..92d94943bbee 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -313,7 +313,8 @@ struct icmpv6_msg {
 	uint8_t		type;
 };
 
-static int icmpv6_getfrag(void *from, char *to, int offset, int len, int odd, struct sk_buff *skb)
+static int icmpv6_getfrag(struct msghdr *_msg, void *from, char *to,
+			  int offset, int len, int odd, struct sk_buff *skb)
 {
 	struct icmpv6_msg *msg = (struct icmpv6_msg *) from;
 	struct sk_buff *org_skb = msg->skb;
@@ -453,6 +454,7 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	struct flowi6 fl6;
 	struct icmpv6_msg msg;
 	struct ipcm6_cookie ipc6;
+	struct msghdr msghdr;
 	int iif = 0;
 	int addr_type = 0;
 	int len;
@@ -606,14 +608,15 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 		goto out_dst_release;
 	}
 
+	msghdr.msg_iter.count = len;
+	msghdr.msg_flags = MSG_DONTWAIT;
+
 	rcu_read_lock();
 	idev = __in6_dev_get(skb->dev);
 
-	if (ip6_append_data(sk, icmpv6_getfrag, &msg,
-			    len + sizeof(struct icmp6hdr),
+	if (ip6_append_data(sk, &msghdr, icmpv6_getfrag, &msg,
 			    sizeof(struct icmp6hdr),
-			    &ipc6, &fl6, (struct rt6_info *)dst,
-			    MSG_DONTWAIT)) {
+			    &ipc6, &fl6, (struct rt6_info *)dst)) {
 		ICMP6_INC_STATS(net, idev, ICMP6_MIB_OUTERRORS);
 		ip6_flush_pending_frames(sk);
 	} else {
@@ -718,6 +721,7 @@ static enum skb_drop_reason icmpv6_echo_reply(struct sk_buff *skb)
 	struct icmpv6_msg msg;
 	struct dst_entry *dst;
 	struct ipcm6_cookie ipc6;
+	struct msghdr msghdr;
 	u32 mark = IP6_REPLY_MARK(net, skb->mark);
 	SKB_DR(reason);
 	bool acast;
@@ -796,10 +800,11 @@ static enum skb_drop_reason icmpv6_echo_reply(struct sk_buff *skb)
 		if (!icmp_build_probe(skb, (struct icmphdr *)&tmp_hdr))
 			goto out_dst_release;
 
-	if (ip6_append_data(sk, icmpv6_getfrag, &msg,
-			    skb->len + sizeof(struct icmp6hdr),
+	msghdr.msg_iter.count	= skb->len;
+	msghdr.msg_flags	= MSG_DONTWAIT;
+	if (ip6_append_data(sk, &msghdr, icmpv6_getfrag, &msg,
 			    sizeof(struct icmp6hdr), &ipc6, &fl6,
-			    (struct rt6_info *)dst, MSG_DONTWAIT)) {
+			    (struct rt6_info *)dst)) {
 		__ICMP6_INC_STATS(net, idev, ICMP6_MIB_OUTERRORS);
 		ip6_flush_pending_frames(sk);
 	} else {
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e5ed39a3c65f..171a026d1dca 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1462,13 +1462,13 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 
 static int __ip6_append_data(struct sock *sk,
 			     struct sk_buff_head *queue,
+			     struct msghdr *msg,
 			     struct inet_cork_full *cork_full,
 			     struct inet6_cork *v6_cork,
 			     struct page_frag *pfrag,
-			     int getfrag(void *from, char *to, int offset,
-					 int len, int odd, struct sk_buff *skb),
-			     void *from, size_t length, int transhdrlen,
-			     unsigned int flags, struct ipcm6_cookie *ipc6)
+			     ip_getfrag_t getfrag,
+			     void *from, int transhdrlen,
+			     struct ipcm6_cookie *ipc6)
 {
 	struct sk_buff *skb, *skb_prev = NULL;
 	struct inet_cork *cork = &cork_full->base;
@@ -1488,6 +1488,7 @@ static int __ip6_append_data(struct sock *sk,
 	int csummode = CHECKSUM_NONE;
 	unsigned int maxnonfragsize, headersize;
 	unsigned int wmem_alloc_delta = 0;
+	size_t length = msg_data_left(msg) + transhdrlen;
 	bool paged, extra_uref = false;
 
 	skb = skb_peek_tail(queue);
@@ -1555,11 +1556,11 @@ static int __ip6_append_data(struct sock *sk,
 	if (transhdrlen && sk->sk_protocol == IPPROTO_UDP &&
 	    headersize == sizeof(struct ipv6hdr) &&
 	    length <= mtu - headersize &&
-	    (!(flags & MSG_MORE) || cork->gso_size) &&
+	    (!(msg->msg_flags & MSG_MORE) || cork->gso_size) &&
 	    rt->dst.dev->features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
 		csummode = CHECKSUM_PARTIAL;
 
-	if ((flags & MSG_ZEROCOPY) && length) {
+	if ((msg->msg_flags & MSG_ZEROCOPY) && length) {
 		struct msghdr *msg = from;
 
 		if (getfrag == ip_generic_getfrag && msg->msg_ubuf) {
@@ -1659,7 +1660,7 @@ static int __ip6_append_data(struct sock *sk,
 			 */
 			alloc_extra += sizeof(struct frag_hdr);
 
-			if ((flags & MSG_MORE) &&
+			if ((msg->msg_flags & MSG_MORE) &&
 			    !(rt->dst.dev->features&NETIF_F_SG))
 				alloclen = mtu;
 			else if (!paged &&
@@ -1689,7 +1690,7 @@ static int __ip6_append_data(struct sock *sk,
 			}
 			if (transhdrlen) {
 				skb = sock_alloc_send_skb(sk, alloclen,
-						(flags & MSG_DONTWAIT), &err);
+						(msg->msg_flags & MSG_DONTWAIT), &err);
 			} else {
 				skb = NULL;
 				if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
@@ -1729,7 +1730,7 @@ static int __ip6_append_data(struct sock *sk,
 				pskb_trim_unique(skb_prev, maxfraglen);
 			}
 			if (copy > 0 &&
-			    getfrag(from, data + transhdrlen, offset,
+			    getfrag(msg, from, data + transhdrlen, offset,
 				    copy, fraggap, skb) < 0) {
 				err = -EFAULT;
 				kfree_skb(skb);
@@ -1749,7 +1750,7 @@ static int __ip6_append_data(struct sock *sk,
 			tskey = 0;
 			skb_zcopy_set(skb, uarg, &extra_uref);
 
-			if ((flags & MSG_CONFIRM) && !skb_prev)
+			if ((msg->msg_flags & MSG_CONFIRM) && !skb_prev)
 				skb_set_dst_pending_confirm(skb, 1);
 
 			/*
@@ -1772,8 +1773,8 @@ static int __ip6_append_data(struct sock *sk,
 			unsigned int off;
 
 			off = skb->len;
-			if (getfrag(from, skb_put(skb, copy),
-						offset, copy, off, skb) < 0) {
+			if (getfrag(msg, from, skb_put(skb, copy),
+				    offset, copy, off, skb) < 0) {
 				__skb_trim(skb, off);
 				err = -EFAULT;
 				goto error;
@@ -1798,7 +1799,7 @@ static int __ip6_append_data(struct sock *sk,
 				get_page(pfrag->page);
 			}
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
-			if (getfrag(from,
+			if (getfrag(msg, from,
 				    page_address(pfrag->page) + pfrag->offset,
 				    offset, copy, skb->len, skb) < 0)
 				goto error_efault;
@@ -1832,19 +1833,17 @@ static int __ip6_append_data(struct sock *sk,
 	return err;
 }
 
-int ip6_append_data(struct sock *sk,
-		    int getfrag(void *from, char *to, int offset, int len,
-				int odd, struct sk_buff *skb),
-		    void *from, size_t length, int transhdrlen,
+int ip6_append_data(struct sock *sk, struct msghdr *msg,
+		    ip_getfrag_t getfrag, void *from, int transhdrlen,
 		    struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
-		    struct rt6_info *rt, unsigned int flags)
+		    struct rt6_info *rt)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	int exthdrlen;
 	int err;
 
-	if (flags&MSG_PROBE)
+	if (msg->msg_flags & MSG_PROBE)
 		return 0;
 	if (skb_queue_empty(&sk->sk_write_queue)) {
 		/*
@@ -1858,15 +1857,14 @@ int ip6_append_data(struct sock *sk,
 
 		inet->cork.fl.u.ip6 = *fl6;
 		exthdrlen = (ipc6->opt ? ipc6->opt->opt_flen : 0);
-		length += exthdrlen;
 		transhdrlen += exthdrlen;
 	} else {
 		transhdrlen = 0;
 	}
 
-	return __ip6_append_data(sk, &sk->sk_write_queue, &inet->cork,
+	return __ip6_append_data(sk, &sk->sk_write_queue, msg, &inet->cork,
 				 &np->cork, sk_page_frag(sk), getfrag,
-				 from, length, transhdrlen, flags, ipc6);
+				 from, transhdrlen, ipc6);
 }
 EXPORT_SYMBOL_GPL(ip6_append_data);
 
@@ -2029,19 +2027,17 @@ void ip6_flush_pending_frames(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(ip6_flush_pending_frames);
 
-struct sk_buff *ip6_make_skb(struct sock *sk,
-			     int getfrag(void *from, char *to, int offset,
-					 int len, int odd, struct sk_buff *skb),
-			     void *from, size_t length, int transhdrlen,
+struct sk_buff *ip6_make_skb(struct sock *sk, struct msghdr *msg,
+			     ip_getfrag_t getfrag, void *from, int transhdrlen,
 			     struct ipcm6_cookie *ipc6, struct rt6_info *rt,
-			     unsigned int flags, struct inet_cork_full *cork)
+			     struct inet_cork_full *cork)
 {
 	struct inet6_cork v6_cork;
 	struct sk_buff_head queue;
 	int exthdrlen = (ipc6->opt ? ipc6->opt->opt_flen : 0);
 	int err;
 
-	if (flags & MSG_PROBE) {
+	if (msg->msg_flags & MSG_PROBE) {
 		dst_release(&rt->dst);
 		return NULL;
 	}
@@ -2060,10 +2056,9 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 	if (ipc6->dontfrag < 0)
 		ipc6->dontfrag = inet6_sk(sk)->dontfrag;
 
-	err = __ip6_append_data(sk, &queue, cork, &v6_cork,
+	err = __ip6_append_data(sk, &queue, msg, cork, &v6_cork,
 				&current->task_frag, getfrag, from,
-				length + exthdrlen, transhdrlen + exthdrlen,
-				flags, ipc6);
+				transhdrlen + exthdrlen, ipc6);
 	if (err) {
 		__ip6_flush_pending_frames(sk, &queue, cork, &v6_cork);
 		return ERR_PTR(err);
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 54c94b28744f..0380d3230814 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -166,17 +166,16 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg)
 	pfh.icmph.checksum = 0;
 	pfh.icmph.un.echo.id = inet->inet_sport;
 	pfh.icmph.un.echo.sequence = user_icmph.icmp6_sequence;
-	pfh.msg = msg;
 	pfh.wcheck = 0;
 	pfh.family = AF_INET6;
 
 	if (ipc6.hlimit < 0)
 		ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 
+	msg->msg_flags = MSG_DONTWAIT;
 	lock_sock(sk);
-	err = ip6_append_data(sk, ping_getfrag, &pfh, len,
-			      sizeof(struct icmp6hdr), &ipc6, &fl6, rt,
-			      MSG_DONTWAIT);
+	err = ip6_append_data(sk, msg, ping_getfrag, &pfh,
+			      sizeof(struct icmp6hdr), &ipc6, &fl6, rt);
 
 	if (err) {
 		ICMP6_INC_STATS(sock_net(sk), rt->rt6i_idev,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index a3437deeeb74..2affd7589939 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -678,18 +678,18 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 }
 
 struct raw6_frag_vec {
-	struct msghdr *msg;
 	int hlen;
 	char c[4];
 };
 
-static int rawv6_probe_proto_opt(struct raw6_frag_vec *rfv, struct flowi6 *fl6)
+static int rawv6_probe_proto_opt(struct raw6_frag_vec *rfv, struct flowi6 *fl6,
+				 struct msghdr *msg)
 {
 	int err = 0;
 	switch (fl6->flowi6_proto) {
 	case IPPROTO_ICMPV6:
 		rfv->hlen = 2;
-		err = memcpy_from_msg(rfv->c, rfv->msg, rfv->hlen);
+		err = memcpy_from_msg(rfv->c, msg, rfv->hlen);
 		if (!err) {
 			fl6->fl6_icmp_type = rfv->c[0];
 			fl6->fl6_icmp_code = rfv->c[1];
@@ -697,15 +697,15 @@ static int rawv6_probe_proto_opt(struct raw6_frag_vec *rfv, struct flowi6 *fl6)
 		break;
 	case IPPROTO_MH:
 		rfv->hlen = 4;
-		err = memcpy_from_msg(rfv->c, rfv->msg, rfv->hlen);
+		err = memcpy_from_msg(rfv->c, msg, rfv->hlen);
 		if (!err)
 			fl6->fl6_mh_type = rfv->c[2];
 	}
 	return err;
 }
 
-static int raw6_getfrag(void *from, char *to, int offset, int len, int odd,
-		       struct sk_buff *skb)
+static int raw6_getfrag(struct msghdr *msg, void *from, char *to,
+			int offset, int len, int odd, struct sk_buff *skb)
 {
 	struct raw6_frag_vec *rfv = from;
 
@@ -732,7 +732,7 @@ static int raw6_getfrag(void *from, char *to, int offset, int len, int odd,
 
 	offset -= rfv->hlen;
 
-	return ip_generic_getfrag(rfv->msg, to, offset, len, odd, skb);
+	return ip_generic_getfrag(msg, NULL, to, offset, len, odd, skb);
 }
 
 static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg)
@@ -868,9 +868,8 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg)
 	fl6.flowi6_mark = ipc6.sockc.mark;
 
 	if (!hdrincl) {
-		rfv.msg = msg;
 		rfv.hlen = 0;
-		err = rawv6_probe_proto_opt(&rfv, &fl6);
+		err = rawv6_probe_proto_opt(&rfv, &fl6, msg);
 		if (err)
 			goto out;
 	}
@@ -919,9 +918,8 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg)
 	else {
 		ipc6.opt = opt;
 		lock_sock(sk);
-		err = ip6_append_data(sk, raw6_getfrag, &rfv,
-			len, 0, &ipc6, &fl6, (struct rt6_info *)dst,
-			msg->msg_flags);
+		err = ip6_append_data(sk, msg, raw6_getfrag, &rfv,
+				      0, &ipc6, &fl6, (struct rt6_info *)dst);
 
 		if (err)
 			ip6_flush_pending_frames(sk);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 80f2eb58ba1a..5bb67739bc0d 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1345,10 +1345,15 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg)
 	bool connected = false;
 	size_t len = msg_data_left(msg);
 	int ulen = len;
-	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
+	int corkreq = READ_ONCE(up->corkflag);
 	int err;
 	int is_udplite = IS_UDPLITE(sk);
-	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
+	ip_getfrag_t getfrag;
+
+	if (corkreq)
+		msg->msg_flags |= MSG_MORE;
+	else
+		corkreq = msg->msg_flags & MSG_MORE;
 
 	ipcm6_init(&ipc6);
 	ipc6.gso_size = READ_ONCE(up->gso_size);
@@ -1578,10 +1583,9 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg)
 	if (!corkreq) {
 		struct sk_buff *skb;
 
-		skb = ip6_make_skb(sk, getfrag, msg, ulen,
+		skb = ip6_make_skb(sk, msg, getfrag, NULL,
 				   sizeof(struct udphdr), &ipc6,
-				   (struct rt6_info *)dst,
-				   msg->msg_flags, &cork);
+				   (struct rt6_info *)dst, &cork);
 		err = PTR_ERR(skb);
 		if (!IS_ERR_OR_NULL(skb))
 			err = udp_v6_send_skb(skb, fl6, &cork.base);
@@ -1606,9 +1610,8 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg)
 	if (ipc6.dontfrag < 0)
 		ipc6.dontfrag = np->dontfrag;
 	up->len += ulen;
-	err = ip6_append_data(sk, getfrag, msg, ulen, sizeof(struct udphdr),
-			      &ipc6, fl6, (struct rt6_info *)dst,
-			      corkreq ? msg->msg_flags|MSG_MORE : msg->msg_flags);
+	err = ip6_append_data(sk, msg, getfrag, NULL, sizeof(struct udphdr),
+			      &ipc6, fl6, (struct rt6_info *)dst);
 	if (err)
 		udp_v6_flush_pending_frames(sk);
 	else if (!corkreq)

