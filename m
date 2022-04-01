Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1B04EE662
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244327AbiDADD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244311AbiDADDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:03:55 -0400
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38376256679
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 20:02:05 -0700 (PDT)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id CC2D1213EF; Fri,  1 Apr 2022 11:02:02 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1648782122;
        bh=eQVkh96gzibtkZ8mB647ryuVkFFmjHS5q6o+HUH2npU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=KKHQpbMyX/hvKQ0YPdLWL0+astXPQVKdcZSpkKxb1/TfJs2+2YYmp6LKsnsPEYuGs
         C07hXcp6BCIJUXHlB04S5mCZxtfwh3Q8gkXR6Fb9TngtJlHG3PXkcQPw2KY+BhUdYs
         JwB5euzjs/l6VeGcPm8Etda35Tpl0seZOgbYI2tEGMSVMWyXJjJsAXEYVq+0uNiHNN
         BHjJzkxYhytHACcZ8NnY0mXIpWHqgsgy2nLoSMjC+WjX7AkW2ASb1qiMEMGi8eBsFM
         g86gTPPH3jYCghn3ilyjJmXbhiQcr5klFP0mqQP/wMBHYe82bqwZr1k1d2mQQG+QL9
         B1nrM0rN6oKag==
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     mjrinal@g.clemson.edu, jk@codeconstruct.com.au,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net 3/3] mctp: Use output netdev to allocate skb headroom
Date:   Fri,  1 Apr 2022 10:48:44 +0800
Message-Id: <20220401024844.1578937-4-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220401024844.1578937-1-matt@codeconstruct.com.au>
References: <20220401024844.1578937-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously the skb was allocated with headroom MCTP_HEADER_MAXLEN,
but that isn't sufficient if we are using devs that are not MCTP
specific.

This also adds a check that the smctp_halen provided to sendmsg for
extended addressing is the correct size for the netdev.

Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
Reported-by: Matthew Rinaldi <mjrinal@g.clemson.edu>
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 include/net/mctp.h |  2 --
 net/mctp/af_mctp.c | 46 +++++++++++++++++++++++++++++++++-------------
 net/mctp/route.c   | 14 +++++++++++---
 3 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index d37268fe6825..82800d521c3d 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -36,8 +36,6 @@ struct mctp_hdr {
 #define MCTP_HDR_TAG_SHIFT	0
 #define MCTP_HDR_TAG_MASK	GENMASK(2, 0)
 
-#define MCTP_HEADER_MAXLEN	4
-
 #define MCTP_INITIAL_DEFAULT_NET	1
 
 static inline bool mctp_address_unicast(mctp_eid_t eid)
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index f0702d920d8d..e22b0cbb2f35 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -93,13 +93,13 @@ static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
 	DECLARE_SOCKADDR(struct sockaddr_mctp *, addr, msg->msg_name);
-	const int hlen = MCTP_HEADER_MAXLEN + sizeof(struct mctp_hdr);
 	int rc, addrlen = msg->msg_namelen;
 	struct sock *sk = sock->sk;
 	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 	struct mctp_skb_cb *cb;
 	struct mctp_route *rt;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
+	int hlen;
 
 	if (addr) {
 		const u8 tagbits = MCTP_TAG_MASK | MCTP_TAG_OWNER |
@@ -129,6 +129,34 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	if (addr->smctp_network == MCTP_NET_ANY)
 		addr->smctp_network = mctp_default_net(sock_net(sk));
 
+	/* direct addressing */
+	if (msk->addr_ext && addrlen >= sizeof(struct sockaddr_mctp_ext)) {
+		DECLARE_SOCKADDR(struct sockaddr_mctp_ext *,
+				 extaddr, msg->msg_name);
+		struct net_device *dev;
+
+		rc = -EINVAL;
+		rcu_read_lock();
+		dev = dev_get_by_index_rcu(sock_net(sk), extaddr->smctp_ifindex);
+		/* check for correct halen */
+		if (dev && extaddr->smctp_halen == dev->addr_len) {
+			hlen = LL_RESERVED_SPACE(dev) + sizeof(struct mctp_hdr);
+			rc = 0;
+		}
+		rcu_read_unlock();
+		if (rc)
+			goto err_free;
+		rt = NULL;
+	} else {
+		rt = mctp_route_lookup(sock_net(sk), addr->smctp_network,
+				       addr->smctp_addr.s_addr);
+		if (!rt) {
+			rc = -EHOSTUNREACH;
+			goto err_free;
+		}
+		hlen = LL_RESERVED_SPACE(rt->dev->dev) + sizeof(struct mctp_hdr);
+	}
+
 	skb = sock_alloc_send_skb(sk, hlen + 1 + len,
 				  msg->msg_flags & MSG_DONTWAIT, &rc);
 	if (!skb)
@@ -147,8 +175,8 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	cb = __mctp_cb(skb);
 	cb->net = addr->smctp_network;
 
-	/* direct addressing */
-	if (msk->addr_ext && addrlen >= sizeof(struct sockaddr_mctp_ext)) {
+	if (!rt) {
+		/* fill extended address in cb */
 		DECLARE_SOCKADDR(struct sockaddr_mctp_ext *,
 				 extaddr, msg->msg_name);
 
@@ -159,17 +187,9 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		}
 
 		cb->ifindex = extaddr->smctp_ifindex;
+		/* smctp_halen is checked above */
 		cb->halen = extaddr->smctp_halen;
 		memcpy(cb->haddr, extaddr->smctp_haddr, cb->halen);
-
-		rt = NULL;
-	} else {
-		rt = mctp_route_lookup(sock_net(sk), addr->smctp_network,
-				       addr->smctp_addr.s_addr);
-		if (!rt) {
-			rc = -EHOSTUNREACH;
-			goto err_free;
-		}
 	}
 
 	rc = mctp_local_output(sk, rt, skb, addr->smctp_addr.s_addr,
diff --git a/net/mctp/route.c b/net/mctp/route.c
index ee548c46c78f..3b24b8d18b5b 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -503,6 +503,11 @@ static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 
 	if (cb->ifindex) {
 		/* direct route; use the hwaddr we stashed in sendmsg */
+		if (cb->halen != skb->dev->addr_len) {
+			/* sanity check, sendmsg should have already caught this */
+			kfree_skb(skb);
+			return -EMSGSIZE;
+		}
 		daddr = cb->haddr;
 	} else {
 		/* If lookup fails let the device handle daddr==NULL */
@@ -756,7 +761,7 @@ static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 {
 	const unsigned int hlen = sizeof(struct mctp_hdr);
 	struct mctp_hdr *hdr, *hdr2;
-	unsigned int pos, size;
+	unsigned int pos, size, headroom;
 	struct sk_buff *skb2;
 	int rc;
 	u8 seq;
@@ -770,6 +775,9 @@ static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 		return -EMSGSIZE;
 	}
 
+	/* keep same headroom as the original skb */
+	headroom = skb_headroom(skb);
+
 	/* we've got the header */
 	skb_pull(skb, hlen);
 
@@ -777,7 +785,7 @@ static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 		/* size of message payload */
 		size = min(mtu - hlen, skb->len - pos);
 
-		skb2 = alloc_skb(MCTP_HEADER_MAXLEN + hlen + size, GFP_KERNEL);
+		skb2 = alloc_skb(headroom + hlen + size, GFP_KERNEL);
 		if (!skb2) {
 			rc = -ENOMEM;
 			break;
@@ -793,7 +801,7 @@ static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 			skb_set_owner_w(skb2, skb->sk);
 
 		/* establish packet */
-		skb_reserve(skb2, MCTP_HEADER_MAXLEN);
+		skb_reserve(skb2, headroom);
 		skb_reset_network_header(skb2);
 		skb_put(skb2, hlen + size);
 		skb2->transport_header = skb2->network_header + hlen;
-- 
2.32.0

