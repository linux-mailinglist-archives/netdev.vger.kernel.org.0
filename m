Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314A21D70F1
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 08:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgERG2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 02:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgERG2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 02:28:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1CCC061A0C;
        Sun, 17 May 2020 23:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=WBVjldVPlROyW79yyrIGXz/tzCpcEaJ8FqY6RWz6ets=; b=NltKmP5mJneBTQQV9GblVct4/S
        laX/3GhvB/AVHn6bCMPCXtkOJpSh3ODMWyvvHyV7TtrJ0D+H+rOZN+Rs09cnGQLyG72iU46O04s+9
        fAMth1M49zszpcxLrVngdbut/kP3R0aB1FnkpLMkfrqMY3lv4188qJJKiHDCMBJVEk8/MWqB1/0Jx
        zVO/ZFNxQCjZbGn8z3hkg0q9xnjo3GYU6Izp6NZKvb8SiSARpn8WD2muBK6x8pTsRjQ7sQzZfM0ML
        aG26Jz9bjh/BavbqNG9TZt5p8BK2hxg3J2ETZ6tdEXUO9JaB+EAlnIY7ANG3uUniL5Fqsd7xXdUqi
        DG0Ldong==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaZG5-0002Zg-JJ; Mon, 18 May 2020 06:28:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/4] ipv6: move SIOCADDRT and SIOCDELRT handling into ->compat_ioctl
Date:   Mon, 18 May 2020 08:28:06 +0200
Message-Id: <20200518062808.756610-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518062808.756610-1-hch@lst.de>
References: <20200518062808.756610-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To prepare removing the global routing_ioctl hack start lifting the code
into a newly added ipv6 ->compat_ioctl handler.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ipv6.h   |  2 ++
 net/dccp/ipv6.c      |  1 +
 net/ipv6/af_inet6.c  | 53 +++++++++++++++++++++++++++++++++++++
 net/ipv6/raw.c       |  1 +
 net/l2tp/l2tp_ip6.c  |  1 +
 net/mptcp/protocol.c |  1 +
 net/sctp/ipv6.c      |  1 +
 net/socket.c         | 63 ++++++++++++--------------------------------
 8 files changed, 77 insertions(+), 46 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 955badd1e8ffc..5fc3a9d7b053e 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1115,6 +1115,8 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
 int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
 		  int peer);
 int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
+int inet6_compat_ioctl(struct socket *sock, unsigned int cmd,
+		unsigned long arg);
 
 int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 			      struct sock *sk);
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 1e5e08cc0bfc3..650187d688519 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -1082,6 +1082,7 @@ static const struct proto_ops inet6_dccp_ops = {
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
 #ifdef CONFIG_COMPAT
+	.compat_ioctl	   = inet6_compat_ioctl,
 	.compat_setsockopt = compat_sock_common_setsockopt,
 	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index a618beb9b6d54..b69496eaf9226 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -60,6 +60,7 @@
 #include <net/calipso.h>
 #include <net/seg6.h>
 #include <net/rpl.h>
+#include <net/compat.h>
 
 #include <linux/uaccess.h>
 #include <linux/mroute6.h>
@@ -571,6 +572,56 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 }
 EXPORT_SYMBOL(inet6_ioctl);
 
+#ifdef CONFIG_COMPAT
+struct compat_in6_rtmsg {
+	struct in6_addr		rtmsg_dst;
+	struct in6_addr		rtmsg_src;
+	struct in6_addr		rtmsg_gateway;
+	u32			rtmsg_type;
+	u16			rtmsg_dst_len;
+	u16			rtmsg_src_len;
+	u32			rtmsg_metric;
+	u32			rtmsg_info;
+	u32			rtmsg_flags;
+	s32			rtmsg_ifindex;
+};
+
+static int inet6_compat_routing_ioctl(struct sock *sk, unsigned int cmd,
+		struct compat_in6_rtmsg __user *ur)
+{
+	struct in6_rtmsg rt;
+
+	if (copy_from_user(&rt.rtmsg_dst, &ur->rtmsg_dst,
+			3 * sizeof(struct in6_addr)) ||
+	    get_user(rt.rtmsg_type, &ur->rtmsg_type) ||
+	    get_user(rt.rtmsg_dst_len, &ur->rtmsg_dst_len) ||
+	    get_user(rt.rtmsg_src_len, &ur->rtmsg_src_len) ||
+	    get_user(rt.rtmsg_metric, &ur->rtmsg_metric) ||
+	    get_user(rt.rtmsg_info, &ur->rtmsg_info) ||
+	    get_user(rt.rtmsg_flags, &ur->rtmsg_flags) ||
+	    get_user(rt.rtmsg_ifindex, &ur->rtmsg_ifindex))
+		return -EFAULT;
+
+
+	return ipv6_route_ioctl(sock_net(sk), cmd, &rt);
+}
+
+int inet6_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = compat_ptr(arg);
+	struct sock *sk = sock->sk;
+
+	switch (cmd) {
+	case SIOCADDRT:
+	case SIOCDELRT:
+		return inet6_compat_routing_ioctl(sk, cmd, argp);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+EXPORT_SYMBOL_GPL(inet6_compat_ioctl);
+#endif /* CONFIG_COMPAT */
+
 INDIRECT_CALLABLE_DECLARE(int udpv6_sendmsg(struct sock *, struct msghdr *,
 					    size_t));
 int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
@@ -632,6 +683,7 @@ const struct proto_ops inet6_stream_ops = {
 	.read_sock	   = tcp_read_sock,
 	.peek_len	   = tcp_peek_len,
 #ifdef CONFIG_COMPAT
+	.compat_ioctl	   = inet6_compat_ioctl,
 	.compat_setsockopt = compat_sock_common_setsockopt,
 	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
@@ -660,6 +712,7 @@ const struct proto_ops inet6_dgram_ops = {
 	.sendpage	   = sock_no_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
 #ifdef CONFIG_COMPAT
+	.compat_ioctl	   = inet6_compat_ioctl,
 	.compat_setsockopt = compat_sock_common_setsockopt,
 	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 0028aa1d78691..8ef5a7b30524f 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1377,6 +1377,7 @@ const struct proto_ops inet6_sockraw_ops = {
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
 #ifdef CONFIG_COMPAT
+	.compat_ioctl	   = inet6_compat_ioctl,
 	.compat_setsockopt = compat_sock_common_setsockopt,
 	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index d148766f40d11..fdfef926c5916 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -758,6 +758,7 @@ static const struct proto_ops l2tp_ip6_ops = {
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
 #ifdef CONFIG_COMPAT
+	.compat_ioctl	   = inet6_compat_ioctl,
 	.compat_setsockopt = compat_sock_common_setsockopt,
 	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e3a628bea2b81..ba9d3d5c625f7 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2068,6 +2068,7 @@ static const struct proto_ops mptcp_v6_stream_ops = {
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = inet_sendpage,
 #ifdef CONFIG_COMPAT
+	.compat_ioctl	   = inet6_compat_ioctl,
 	.compat_setsockopt = compat_sock_common_setsockopt,
 	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index c87af430107ae..ccfa0ab3e7f48 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1032,6 +1032,7 @@ static const struct proto_ops inet6_seqpacket_ops = {
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
 #ifdef CONFIG_COMPAT
+	.compat_ioctl	   = inet6_compat_ioctl,
 	.compat_setsockopt = compat_sock_common_setsockopt,
 	.compat_getsockopt = compat_sock_common_getsockopt,
 #endif
diff --git a/net/socket.c b/net/socket.c
index 1c9a7260a41de..6824470757753 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3384,62 +3384,33 @@ struct rtentry32 {
 	unsigned short  rt_irtt;        /* Initial RTT                  */
 };
 
-struct in6_rtmsg32 {
-	struct in6_addr		rtmsg_dst;
-	struct in6_addr		rtmsg_src;
-	struct in6_addr		rtmsg_gateway;
-	u32			rtmsg_type;
-	u16			rtmsg_dst_len;
-	u16			rtmsg_src_len;
-	u32			rtmsg_metric;
-	u32			rtmsg_info;
-	u32			rtmsg_flags;
-	s32			rtmsg_ifindex;
-};
-
 static int routing_ioctl(struct net *net, struct socket *sock,
 			 unsigned int cmd, void __user *argp)
 {
+	struct rtentry32 __user *ur4 = argp;
 	int ret;
 	void *r = NULL;
-	struct in6_rtmsg r6;
 	struct rtentry r4;
 	char devname[16];
 	u32 rtdev;
 	mm_segment_t old_fs = get_fs();
 
-	if (sock && sock->sk && sock->sk->sk_family == AF_INET6) { /* ipv6 */
-		struct in6_rtmsg32 __user *ur6 = argp;
-		ret = copy_from_user(&r6.rtmsg_dst, &(ur6->rtmsg_dst),
-			3 * sizeof(struct in6_addr));
-		ret |= get_user(r6.rtmsg_type, &(ur6->rtmsg_type));
-		ret |= get_user(r6.rtmsg_dst_len, &(ur6->rtmsg_dst_len));
-		ret |= get_user(r6.rtmsg_src_len, &(ur6->rtmsg_src_len));
-		ret |= get_user(r6.rtmsg_metric, &(ur6->rtmsg_metric));
-		ret |= get_user(r6.rtmsg_info, &(ur6->rtmsg_info));
-		ret |= get_user(r6.rtmsg_flags, &(ur6->rtmsg_flags));
-		ret |= get_user(r6.rtmsg_ifindex, &(ur6->rtmsg_ifindex));
-
-		r = (void *) &r6;
-	} else { /* ipv4 */
-		struct rtentry32 __user *ur4 = argp;
-		ret = copy_from_user(&r4.rt_dst, &(ur4->rt_dst),
-					3 * sizeof(struct sockaddr));
-		ret |= get_user(r4.rt_flags, &(ur4->rt_flags));
-		ret |= get_user(r4.rt_metric, &(ur4->rt_metric));
-		ret |= get_user(r4.rt_mtu, &(ur4->rt_mtu));
-		ret |= get_user(r4.rt_window, &(ur4->rt_window));
-		ret |= get_user(r4.rt_irtt, &(ur4->rt_irtt));
-		ret |= get_user(rtdev, &(ur4->rt_dev));
-		if (rtdev) {
-			ret |= copy_from_user(devname, compat_ptr(rtdev), 15);
-			r4.rt_dev = (char __user __force *)devname;
-			devname[15] = 0;
-		} else
-			r4.rt_dev = NULL;
-
-		r = (void *) &r4;
-	}
+	ret = copy_from_user(&r4.rt_dst, &(ur4->rt_dst),
+				3 * sizeof(struct sockaddr));
+	ret |= get_user(r4.rt_flags, &(ur4->rt_flags));
+	ret |= get_user(r4.rt_metric, &(ur4->rt_metric));
+	ret |= get_user(r4.rt_mtu, &(ur4->rt_mtu));
+	ret |= get_user(r4.rt_window, &(ur4->rt_window));
+	ret |= get_user(r4.rt_irtt, &(ur4->rt_irtt));
+	ret |= get_user(rtdev, &(ur4->rt_dev));
+	if (rtdev) {
+		ret |= copy_from_user(devname, compat_ptr(rtdev), 15);
+		r4.rt_dev = (char __user __force *)devname;
+		devname[15] = 0;
+	} else
+		r4.rt_dev = NULL;
+
+	r = (void *) &r4;
 
 	if (ret) {
 		ret = -EFAULT;
-- 
2.26.2

