Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9828743AA0D
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhJZCAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 22:00:14 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:42132 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhJZCAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 22:00:13 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 8F3A120223; Tue, 26 Oct 2021 09:57:49 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Eugene Syromiatnikov <esyr@redhat.com>
Subject: [PATCH net-next v6] mctp: Implement extended addressing
Date:   Tue, 26 Oct 2021 09:57:28 +0800
Message-Id: <20211026015728.3006286-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change allows an extended address struct - struct sockaddr_mctp_ext
- to be passed to sendmsg/recvmsg. This allows userspace to specify
output ifindex and physical address information (for sendmsg) or receive
the input ifindex/physaddr for incoming messages (for recvmsg). This is
typically used by userspace for MCTP address discovery and assignment
operations.

The extended addressing facility is conditional on a new sockopt:
MCTP_OPT_ADDR_EXT; userspace must explicitly enable addressing before
the kernel will consume/populate the extended address data.

Includes a fix for an uninitialised var:
Reported-by: kernel test robot <lkp@intel.com>

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

---
v6:
 - use MAX_ADDR_LEN for mctp_skb_cb.haddr, and add a BUILD_BUG_ON for
   checking suitable cb size.

v5:
 - rebase to net-next, where we've added explicit padding to struct
   sockaddr_mctp. Consequently, pad sockaddr_mctp_ext too, and
   unify types.

v4:
 - move SOL_MCTP to linux/sockets.h

v3:
 - avoid uninitialised rc if we hit the !rt->dev WARN.

v2:
 - non-RFC
 - learn to spell "typically"

RFC: this patch adds a bit of an new ABI, in that the struct sockaddr
for MCTP has been extended, with extra addressing data being available
for applications after setting a sockopt.

Using something like IP_PKTINFO might be suitable instead, but that
requires sendmsg/recvmsg, and control message setup, whereas this is a
a simpler interface, and also allows extended addressing info in
sendto/recvfrom too. Comments most welcome!
---
 include/linux/socket.h    |  1 +
 include/net/mctp.h        | 13 ++++--
 include/uapi/linux/mctp.h | 11 +++++
 net/mctp/af_mctp.c        | 86 ++++++++++++++++++++++++++++++----
 net/mctp/route.c          | 98 +++++++++++++++++++++++++++++----------
 5 files changed, 170 insertions(+), 39 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 7612d760b6a9..8ef26d89ef49 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -365,6 +365,7 @@ struct ucred {
 #define SOL_TLS		282
 #define SOL_XDP		283
 #define SOL_MPTCP	284
+#define SOL_MCTP	285
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/include/net/mctp.h b/include/net/mctp.h
index 2a83443bdfac..23bec708f4c7 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -11,6 +11,7 @@
 
 #include <linux/bits.h>
 #include <linux/mctp.h>
+#include <linux/netdevice.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 
@@ -58,6 +59,9 @@ struct mctp_sock {
 	mctp_eid_t	bind_addr;
 	__u8		bind_type;
 
+	/* sendmsg()/recvmsg() uses struct sockaddr_mctp_ext */
+	bool		addr_ext;
+
 	/* list of mctp_sk_key, for incoming tag lookup. updates protected
 	 * by sk->net->keys_lock
 	 */
@@ -153,7 +157,10 @@ struct mctp_sk_key {
 struct mctp_skb_cb {
 	unsigned int	magic;
 	unsigned int	net;
+	int		ifindex; /* extended/direct addressing if set */
 	mctp_eid_t	src;
+	unsigned char	halen;
+	unsigned char	haddr[MAX_ADDR_LEN];
 };
 
 /* skb control-block accessors with a little extra debugging for initial
@@ -177,6 +184,7 @@ static inline struct mctp_skb_cb *mctp_cb(struct sk_buff *skb)
 {
 	struct mctp_skb_cb *cb = (void *)skb->cb;
 
+	BUILD_BUG_ON(sizeof(struct mctp_skb_cb) > sizeof(skb->cb));
 	WARN_ON(cb->magic != 0x4d435450);
 	return (void *)(skb->cb);
 }
@@ -189,8 +197,7 @@ static inline struct mctp_skb_cb *mctp_cb(struct sk_buff *skb)
  *
  * Updates to the route table are performed under rtnl; all reads under RCU,
  * so routes cannot be referenced over a RCU grace period. Specifically: A
- * caller cannot block between mctp_route_lookup and passing the route to
- * mctp_do_route.
+ * caller cannot block between mctp_route_lookup and mctp_route_release()
  */
 struct mctp_route {
 	mctp_eid_t		min, max;
@@ -210,8 +217,6 @@ struct mctp_route {
 struct mctp_route *mctp_route_lookup(struct net *net, unsigned int dnet,
 				     mctp_eid_t daddr);
 
-int mctp_do_route(struct mctp_route *rt, struct sk_buff *skb);
-
 int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 		      struct sk_buff *skb, mctp_eid_t daddr, u8 req_tag);
 
diff --git a/include/uapi/linux/mctp.h b/include/uapi/linux/mctp.h
index 6acd4ccafbf7..07b0318716fc 100644
--- a/include/uapi/linux/mctp.h
+++ b/include/uapi/linux/mctp.h
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/socket.h>
+#include <linux/netdevice.h>
 
 typedef __u8			mctp_eid_t;
 
@@ -28,6 +29,14 @@ struct sockaddr_mctp {
 	__u8			__smctp_pad1;
 };
 
+struct sockaddr_mctp_ext {
+	struct sockaddr_mctp	smctp_base;
+	int			smctp_ifindex;
+	__u8			smctp_halen;
+	__u8			__smctp_pad0[3];
+	__u8			smctp_haddr[MAX_ADDR_LEN];
+};
+
 #define MCTP_NET_ANY		0x0
 
 #define MCTP_ADDR_NULL		0x00
@@ -36,4 +45,6 @@ struct sockaddr_mctp {
 #define MCTP_TAG_MASK		0x07
 #define MCTP_TAG_OWNER		0x08
 
+#define MCTP_OPT_ADDR_EXT	1
+
 #endif /* __UAPI_MCTP_H */
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 66a411d60b6c..d344b02a1cde 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -77,6 +77,7 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	const int hlen = MCTP_HEADER_MAXLEN + sizeof(struct mctp_hdr);
 	int rc, addrlen = msg->msg_namelen;
 	struct sock *sk = sock->sk;
+	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 	struct mctp_skb_cb *cb;
 	struct mctp_route *rt;
 	struct sk_buff *skb;
@@ -100,11 +101,6 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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
@@ -116,19 +112,45 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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
+		if (extaddr->smctp_halen > sizeof(cb->haddr)) {
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
@@ -136,6 +158,7 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 {
 	DECLARE_SOCKADDR(struct sockaddr_mctp *, addr, msg->msg_name);
 	struct sock *sk = sock->sk;
+	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 	struct sk_buff *skb;
 	size_t msglen;
 	u8 type;
@@ -181,6 +204,16 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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
@@ -196,12 +229,45 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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
index 82fb5ae524f6..c23ab3547ee5 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -434,6 +434,7 @@ static unsigned int mctp_route_mtu(struct mctp_route *rt)
 
 static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 {
+	struct mctp_skb_cb *cb = mctp_cb(skb);
 	struct mctp_hdr *hdr = mctp_hdr(skb);
 	char daddr_buf[MAX_ADDR_LEN];
 	char *daddr = NULL;
@@ -448,9 +449,14 @@ static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
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
@@ -649,16 +655,6 @@ static struct mctp_route *mctp_route_lookup_null(struct net *net,
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
@@ -725,7 +721,7 @@ static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 		/* copy message payload */
 		skb_copy_bits(skb, pos, skb_transport_header(skb2), size);
 
-		/* do route, but don't drop the rt reference */
+		/* do route */
 		rc = rt->output(rt, skb2);
 		if (rc)
 			break;
@@ -734,7 +730,6 @@ static int mctp_do_fragment_route(struct mctp_route *rt, struct sk_buff *skb,
 		pos += size;
 	}
 
-	mctp_route_release(rt);
 	consume_skb(skb);
 	return rc;
 }
@@ -744,15 +739,51 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
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
+	rc = -ENODEV;
+
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
@@ -765,18 +796,17 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
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
@@ -796,12 +826,22 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
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
@@ -942,8 +982,15 @@ static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
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
 
@@ -954,7 +1001,8 @@ static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
 	if (!rt)
 		goto err_drop;
 
-	mctp_do_route(rt, skb);
+	rt->output(rt, skb);
+	mctp_route_release(rt);
 
 	return NET_RX_SUCCESS;
 
-- 
2.33.0

