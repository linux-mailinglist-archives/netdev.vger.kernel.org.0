Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4769541D0B2
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 02:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347545AbhI3Anj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:43:39 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33364 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhI3Anj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:43:39 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 0464320166; Thu, 30 Sep 2021 08:41:49 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH RFC net-next] mctp: Implement extended addressing
Date:   Thu, 30 Sep 2021 08:41:23 +0800
Message-Id: <20210930004123.1417190-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change allows an extended address struct - struct sockaddr_mctp_ext
- to be passed to sendmsg/recvmsg. This allows userspace to specify
output ifindex and physical address information (for sendmsg) or receive
the input ifindex/physaddr for incoming messages (for recvmsg). This is
typicaly used by userspace for MCTP address discovery and assignment
operations.

The extended addressing facility is conditional on a new sockopt:
MCTP_OPT_ADDR_EXT; userspace must explicitly enable addressing before
the kernel will consume/populate the extended address data.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

---
RFC: this patch adds a bit of an new ABI, in that the struct sockaddr
for MCTP has been extended, with extra addressing data being available
for applications after setting a sockopt.

Using something like IP_PKTINFO might be suitable instead, but that
requires sendmsg/recvmsg, and control message setup, whereas this is a
a simpler interface, and also allows extended addressing info in
sendto/recvfrom too. Comments most welcome!

---
 include/net/mctp.h        | 16 +++++--
 include/uapi/linux/mctp.h | 13 ++++++
 net/mctp/af_mctp.c        | 86 ++++++++++++++++++++++++++++++----
 net/mctp/route.c          | 97 +++++++++++++++++++++++++++++----------
 4 files changed, 172 insertions(+), 40 deletions(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index a824d47c3c6d..fb1f865b3e67 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -58,6 +58,9 @@ struct mctp_sock {
 	mctp_eid_t	bind_addr;
 	__u8		bind_type;
 
+	/* sendmsg()/recvmsg() uses struct sockaddr_mctp_ext */
+	bool		addr_ext;
+
 	/* list of mctp_sk_key, for incoming tag lookup. updates protected
 	 * by sk->net->keys_lock
 	 */
@@ -128,10 +131,16 @@ struct mctp_sk_key {
 
 struct mctp_skb_cb {
 	unsigned int	magic;
-	unsigned int	net;
+	int		net;
+	int		ifindex; /* extended/direct addressing if set */
+	unsigned char	halen;
 	mctp_eid_t	src;
+	unsigned char	haddr[];
 };
 
+#define MCTP_SKB_CB_HADDR_MAXLEN (sizeof((((struct sk_buff *)(NULL))->cb)) \
+				  - offsetof(struct mctp_skb_cb, haddr))
+
 /* skb control-block accessors with a little extra debugging for initial
  * development.
  *
@@ -165,8 +174,7 @@ static inline struct mctp_skb_cb *mctp_cb(struct sk_buff *skb)
  *
  * Updates to the route table are performed under rtnl; all reads under RCU,
  * so routes cannot be referenced over a RCU grace period. Specifically: A
- * caller cannot block between mctp_route_lookup and passing the route to
- * mctp_do_route.
+ * caller cannot block between mctp_route_lookup and mctp_route_release()
  */
 struct mctp_route {
 	mctp_eid_t		min, max;
@@ -186,8 +194,6 @@ struct mctp_route {
 struct mctp_route *mctp_route_lookup(struct net *net, unsigned int dnet,
 				     mctp_eid_t daddr);
 
-int mctp_do_route(struct mctp_route *rt, struct sk_buff *skb);
-
 int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 		      struct sk_buff *skb, mctp_eid_t daddr, u8 req_tag);
 
diff --git a/include/uapi/linux/mctp.h b/include/uapi/linux/mctp.h
index 52b54d13f385..896432ce3c71 100644
--- a/include/uapi/linux/mctp.h
+++ b/include/uapi/linux/mctp.h
@@ -10,6 +10,7 @@
 #define __UAPI_MCTP_H
 
 #include <linux/types.h>
+#include <linux/netdevice.h>
 
 typedef __u8			mctp_eid_t;
 
@@ -25,6 +26,13 @@ struct sockaddr_mctp {
 	__u8			smctp_tag;
 };
 
+struct sockaddr_mctp_ext {
+	struct sockaddr_mctp	smctp_base;
+	int			smctp_ifindex;
+	unsigned char		smctp_halen;
+	unsigned char		smctp_haddr[MAX_ADDR_LEN];
+};
+
 #define MCTP_NET_ANY		0x0
 
 #define MCTP_ADDR_NULL		0x00
@@ -33,4 +41,9 @@ struct sockaddr_mctp {
 #define MCTP_TAG_MASK		0x07
 #define MCTP_TAG_OWNER		0x08
 
+/* setsockopt(2) level & options */
+#define SOL_MCTP		0
+
+#define MCTP_OPT_ADDR_EXT	1
+
 #endif /* __UAPI_MCTP_H */
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index a9526ac29dff..5708ed02f144 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -74,6 +74,7 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	const int hlen = MCTP_HEADER_MAXLEN + sizeof(struct mctp_hdr);
 	int rc, addrlen = msg->msg_namelen;
 	struct sock *sk = sock->sk;
+	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 	struct mctp_skb_cb *cb;
 	struct mctp_route *rt;
 	struct sk_buff *skb;
@@ -97,11 +98,6 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	if (addr->smctp_network == MCTP_NET_ANY)
 		addr->smctp_network = mctp_default_net(sock_net(sk));
 
-	rt = mctp_route_lookup(sock_net(sk), addr->smctp_network,
-			       addr->smctp_addr.s_addr);
-	if (!rt)
-		return -EHOSTUNREACH;
-
 	skb = sock_alloc_send_skb(sk, hlen + 1 + len,
 				  msg->msg_flags & MSG_DONTWAIT, &rc);
 	if (!skb)
@@ -113,19 +109,45 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	*(u8 *)skb_put(skb, 1) = addr->smctp_type;
 
 	rc = memcpy_from_msg((void *)skb_put(skb, len), msg, len);
-	if (rc < 0) {
-		kfree_skb(skb);
-		return rc;
-	}
+	if (rc < 0)
+		goto err_free;
 
 	/* set up cb */
 	cb = __mctp_cb(skb);
 	cb->net = addr->smctp_network;
 
+	/* direct addressing */
+	if (msk->addr_ext && addrlen >= sizeof(struct sockaddr_mctp_ext)) {
+		DECLARE_SOCKADDR(struct sockaddr_mctp_ext *,
+				 extaddr, msg->msg_name);
+
+		if (extaddr->smctp_halen > MCTP_SKB_CB_HADDR_MAXLEN) {
+			rc = -EINVAL;
+			goto err_free;
+		}
+
+		cb->ifindex = extaddr->smctp_ifindex;
+		cb->halen = extaddr->smctp_halen;
+		memcpy(cb->haddr, extaddr->smctp_haddr, cb->halen);
+
+		rt = NULL;
+	} else {
+		rt = mctp_route_lookup(sock_net(sk), addr->smctp_network,
+				       addr->smctp_addr.s_addr);
+		if (!rt) {
+			rc = -EHOSTUNREACH;
+			goto err_free;
+		}
+	}
+
 	rc = mctp_local_output(sk, rt, skb, addr->smctp_addr.s_addr,
 			       addr->smctp_tag);
 
 	return rc ? : len;
+
+err_free:
+	kfree_skb(skb);
+	return rc;
 }
 
 static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
@@ -133,6 +155,7 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 {
 	DECLARE_SOCKADDR(struct sockaddr_mctp *, addr, msg->msg_name);
 	struct sock *sk = sock->sk;
+	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 	struct sk_buff *skb;
 	size_t msglen;
 	u8 type;
@@ -178,6 +201,16 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		addr->smctp_tag = hdr->flags_seq_tag &
 					(MCTP_HDR_TAG_MASK | MCTP_HDR_FLAG_TO);
 		msg->msg_namelen = sizeof(*addr);
+
+		if (msk->addr_ext) {
+			DECLARE_SOCKADDR(struct sockaddr_mctp_ext *, ae,
+					 msg->msg_name);
+			msg->msg_namelen = sizeof(*ae);
+			ae->smctp_ifindex = cb->ifindex;
+			ae->smctp_halen = cb->halen;
+			memset(ae->smctp_haddr, 0x0, sizeof(ae->smctp_haddr));
+			memcpy(ae->smctp_haddr, cb->haddr, cb->halen);
+		}
 	}
 
 	rc = len;
@@ -193,12 +226,45 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 static int mctp_setsockopt(struct socket *sock, int level, int optname,
 			   sockptr_t optval, unsigned int optlen)
 {
-	return -EINVAL;
+	struct mctp_sock *msk = container_of(sock->sk, struct mctp_sock, sk);
+	int val;
+
+	if (level != SOL_MCTP)
+		return -EINVAL;
+
+	if (optname == MCTP_OPT_ADDR_EXT) {
+		if (optlen != sizeof(int))
+			return -EINVAL;
+		if (copy_from_sockptr(&val, optval, sizeof(int)))
+			return -EFAULT;
+		msk->addr_ext = val;
+		return 0;
+	}
+
+	return -ENOPROTOOPT;
 }
 
 static int mctp_getsockopt(struct socket *sock, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
+	struct mctp_sock *msk = container_of(sock->sk, struct mctp_sock, sk);
+	int len, val;
+
+	if (level != SOL_MCTP)
+		return -EINVAL;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+
+	if (optname == MCTP_OPT_ADDR_EXT) {
+		if (len != sizeof(int))
+			return -EINVAL;
+		val = !!msk->addr_ext;
+		if (copy_to_user(optval, &val, len))
+			return -EFAULT;
+		return 0;
+	}
+
 	return -EINVAL;
 }
 
diff --git a/net/mctp/route.c b/net/mctp/route.c
index aeafc367cf5c..9a877fbd23ae 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -376,6 +376,7 @@ static unsigned int mctp_route_mtu(struct mctp_route *rt)
 
 static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 {
+	struct mctp_skb_cb *cb = mctp_cb(skb);
 	struct mctp_hdr *hdr = mctp_hdr(skb);
 	char daddr_buf[MAX_ADDR_LEN];
 	char *daddr = NULL;
@@ -390,9 +391,14 @@ static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 		return -EMSGSIZE;
 	}
 
-	/* If lookup fails let the device handle daddr==NULL */
-	if (mctp_neigh_lookup(route->dev, hdr->dest, daddr_buf) == 0)
-		daddr = daddr_buf;
+	if (cb->ifindex) {
+		/* direct route; use the hwaddr we stashed in sendmsg */
+		daddr = cb->haddr;
+	} else {
+		/* If lookup fails let the device handle daddr==NULL */
+		if (mctp_neigh_lookup(route->dev, hdr->dest, daddr_buf) == 0)
+			daddr = daddr_buf;
+	}
 
 	rc = dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
 			     daddr, skb->dev->dev_addr, skb->len);
@@ -570,16 +576,6 @@ static struct mctp_route *mctp_route_lookup_null(struct net *net,
 	return NULL;
 }
 
-/* sends a skb to rt and releases the route. */
-int mctp_do_route(struct mctp_route *rt, struct sk_buff *skb)
-{
-	int rc;
-
-	rc = rt->output(rt, skb);
-	mctp_route_release(rt);
-	return rc;
-}
-
 static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 				  unsigned int mtu, u8 tag)
 {
@@ -646,7 +642,7 @@ static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 		/* copy message payload */
 		skb_copy_bits(skb, pos, skb_transport_header(skb2), size);
 
-		/* do route, but don't drop the rt reference */
+		/* do route */
 		rc = rt->output(rt, skb2);
 		if (rc)
 			break;
@@ -655,7 +651,6 @@ static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 		pos += size;
 	}
 
-	mctp_route_release(rt);
 	consume_skb(skb);
 	return rc;
 }
@@ -665,15 +660,50 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 {
 	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 	struct mctp_skb_cb *cb = mctp_cb(skb);
+	struct mctp_route tmp_rt;
+	struct net_device *dev;
 	struct mctp_hdr *hdr;
 	unsigned long flags;
 	unsigned int mtu;
 	mctp_eid_t saddr;
+	bool ext_rt;
 	int rc;
 	u8 tag;
 
-	if (WARN_ON(!rt->dev))
+	if (rt) {
+		ext_rt = false;
+		dev = NULL;
+
+		if (WARN_ON(!rt->dev))
+			goto out_release;
+
+	} else if (cb->ifindex) {
+		ext_rt = true;
+		rt = &tmp_rt;
+
+		rc = -ENODEV;
+		rcu_read_lock();
+		dev = dev_get_by_index_rcu(sock_net(sk), cb->ifindex);
+		if (!dev) {
+			rcu_read_unlock();
+			return rc;
+		}
+
+		rt->dev = __mctp_dev_get(dev);
+		rcu_read_unlock();
+
+		if (!rt->dev)
+			goto out_release;
+
+		/* establish temporary route - we set up enough to keep
+		 * mctp_route_output happy
+		 */
+		rt->output = mctp_route_output;
+		rt->mtu = 0;
+
+	} else {
 		return -EINVAL;
+	}
 
 	spin_lock_irqsave(&rt->dev->addrs_lock, flags);
 	if (rt->dev->num_addrs == 0) {
@@ -686,18 +716,17 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 	spin_unlock_irqrestore(&rt->dev->addrs_lock, flags);
 
 	if (rc)
-		return rc;
+		goto out_release;
 
 	if (req_tag & MCTP_HDR_FLAG_TO) {
 		rc = mctp_alloc_local_tag(msk, saddr, daddr, &tag);
 		if (rc)
-			return rc;
+			goto out_release;
 		tag |= MCTP_HDR_FLAG_TO;
 	} else {
 		tag = req_tag;
 	}
 
-
 	skb->protocol = htons(ETH_P_MCTP);
 	skb->priority = 0;
 	skb_reset_transport_header(skb);
@@ -717,12 +746,22 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 	mtu = mctp_route_mtu(rt);
 
 	if (skb->len + sizeof(struct mctp_hdr) <= mtu) {
-		hdr->flags_seq_tag = MCTP_HDR_FLAG_SOM | MCTP_HDR_FLAG_EOM |
-			tag;
-		return mctp_do_route(rt, skb);
+		hdr->flags_seq_tag = MCTP_HDR_FLAG_SOM |
+			MCTP_HDR_FLAG_EOM | tag;
+		rc = rt->output(rt, skb);
 	} else {
-		return mctp_do_fragment_route(rt, skb, mtu, tag);
+		rc = mctp_do_fragment_route(rt, skb, mtu, tag);
 	}
+
+out_release:
+	if (!ext_rt)
+		mctp_route_release(rt);
+
+	if (dev)
+		dev_put(dev);
+
+	return rc;
+
 }
 
 /* route management */
@@ -863,8 +902,15 @@ static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
 	if (mh->ver < MCTP_VER_MIN || mh->ver > MCTP_VER_MAX)
 		goto err_drop;
 
-	cb = __mctp_cb(skb);
+	/* MCTP drivers must populate halen/haddr */
+	if (dev->type == ARPHRD_MCTP) {
+		cb = mctp_cb(skb);
+	} else {
+		cb = __mctp_cb(skb);
+		cb->halen = 0;
+	}
 	cb->net = READ_ONCE(mdev->net);
+	cb->ifindex = dev->ifindex;
 
 	rt = mctp_route_lookup(net, cb->net, mh->dest);
 
@@ -875,7 +921,8 @@ static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
 	if (!rt)
 		goto err_drop;
 
-	mctp_do_route(rt, skb);
+	rt->output(rt, skb);
+	mctp_route_release(rt);
 
 	return NET_RX_SUCCESS;
 
-- 
2.30.2

