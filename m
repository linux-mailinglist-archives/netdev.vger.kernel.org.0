Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8692233E2
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgGQGZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgGQGYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0E3C08C5C0;
        Thu, 16 Jul 2020 23:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HWKUrMU7y7FykbOHZGTc2Y+JrTvxO4f9VIsHEh08/RU=; b=e48fLHcJwVEo+UkX1/mK0+z2I1
        q+RKf9d8bw/O9G7YRI9XjTwtGqLI1nxSbt8EUvRL/5z3evvLG9xn/G/8mbLaT1oVQ8W5xlKnUC8OD
        ZXjLY2UFV35hrKq1Ut/uAK561ACk/iwosVMPfkl+tI37B4L3GBODPhNXVwoY9Yt2wDJXvYq9rOb3j
        YsUc/yCl0kLFu2A+Evy26MiwlWgrM+/+b9f8maHw7q1FqcXrNhX5eBWHXHmf/bxRtyMOuMyP0o+v7
        Qyg/4mgDBAXYSTo3yuHFqtwKuY5rm/VmN8DBtnTepUaswPvSPwYpWhrN8Y0K1MzyhdzcQTprxKAnZ
        6xo9agpA==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJnC-00055O-C8; Fri, 17 Jul 2020 06:24:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chas Williams <3chas3@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-wpan@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH 17/22] net/ipv4: remove compat_ip_{get,set}sockopt
Date:   Fri, 17 Jul 2020 08:23:26 +0200
Message-Id: <20200717062331.691152-18-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717062331.691152-1-hch@lst.de>
References: <20200717062331.691152-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle the few cases that need special treatment in-line using
in_compat_syscall().

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ip.h       |   4 -
 net/dccp/ipv4.c        |   4 -
 net/ipv4/ip_sockglue.c | 214 ++++++++++++-----------------------------
 net/ipv4/raw.c         |  22 -----
 net/ipv4/tcp_ipv4.c    |   4 -
 net/ipv4/udp.c         |  24 -----
 net/ipv4/udp_impl.h    |   6 --
 net/ipv4/udplite.c     |   4 -
 net/l2tp/l2tp_ip.c     |   4 -
 net/sctp/protocol.c    |   4 -
 10 files changed, 61 insertions(+), 229 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 862c9545833a95..3d34acc95ca825 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -727,10 +727,6 @@ int ip_setsockopt(struct sock *sk, int level, int optname, char __user *optval,
 		  unsigned int optlen);
 int ip_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
 		  int __user *optlen);
-int compat_ip_setsockopt(struct sock *sk, int level, int optname,
-			 char __user *optval, unsigned int optlen);
-int compat_ip_getsockopt(struct sock *sk, int level, int optname,
-			 char __user *optval, int __user *optlen);
 int ip_ra_control(struct sock *sk, unsigned char on,
 		  void (*destructor)(struct sock *));
 
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 316cc5ac0da72b..b91373eb1c7974 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -913,10 +913,6 @@ static const struct inet_connection_sock_af_ops dccp_ipv4_af_ops = {
 	.getsockopt	   = ip_getsockopt,
 	.addr2sockaddr	   = inet_csk_addr2sockaddr,
 	.sockaddr_len	   = sizeof(struct sockaddr_in),
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_ip_setsockopt,
-	.compat_getsockopt = compat_ip_getsockopt,
-#endif
 };
 
 static int dccp_v4_init_sock(struct sock *sk)
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 73bb88fbe54661..86b3b9a7cea30d 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -679,20 +679,48 @@ static int set_mcast_msfilter(struct sock *sk, int ifindex,
 	return -EADDRNOTAVAIL;
 }
 
+static int copy_group_source_from_user(struct group_source_req *greqs,
+		void __user *optval, int optlen)
+{
+	if (in_compat_syscall()) {
+		struct compat_group_source_req gr32;
+
+		if (optlen != sizeof(gr32))
+			return -EINVAL;
+		if (copy_from_user(&gr32, optval, sizeof(gr32)))
+			return -EFAULT;
+		greqs->gsr_interface = gr32.gsr_interface;
+		greqs->gsr_group = gr32.gsr_group;
+		greqs->gsr_source = gr32.gsr_source;
+	} else {
+		if (optlen != sizeof(*greqs))
+			return -EINVAL;
+		if (copy_from_user(greqs, optval, sizeof(*greqs)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
 static int do_mcast_group_source(struct sock *sk, int optname,
-				 struct group_source_req *greqs)
+		void __user *optval, int optlen)
 {
+	struct group_source_req greqs;
 	struct ip_mreq_source mreqs;
 	struct sockaddr_in *psin;
 	int omode, add, err;
 
-	if (greqs->gsr_group.ss_family != AF_INET ||
-	    greqs->gsr_source.ss_family != AF_INET)
+	err = copy_group_source_from_user(&greqs, optval, optlen);
+	if (err)
+		return err;
+
+	if (greqs.gsr_group.ss_family != AF_INET ||
+	    greqs.gsr_source.ss_family != AF_INET)
 		return -EADDRNOTAVAIL;
 
-	psin = (struct sockaddr_in *)&greqs->gsr_group;
+	psin = (struct sockaddr_in *)&greqs.gsr_group;
 	mreqs.imr_multiaddr = psin->sin_addr.s_addr;
-	psin = (struct sockaddr_in *)&greqs->gsr_source;
+	psin = (struct sockaddr_in *)&greqs.gsr_source;
 	mreqs.imr_sourceaddr = psin->sin_addr.s_addr;
 	mreqs.imr_interface = 0; /* use index for mc_source */
 
@@ -705,21 +733,21 @@ static int do_mcast_group_source(struct sock *sk, int optname,
 	} else if (optname == MCAST_JOIN_SOURCE_GROUP) {
 		struct ip_mreqn mreq;
 
-		psin = (struct sockaddr_in *)&greqs->gsr_group;
+		psin = (struct sockaddr_in *)&greqs.gsr_group;
 		mreq.imr_multiaddr = psin->sin_addr;
 		mreq.imr_address.s_addr = 0;
-		mreq.imr_ifindex = greqs->gsr_interface;
+		mreq.imr_ifindex = greqs.gsr_interface;
 		err = ip_mc_join_group_ssm(sk, &mreq, MCAST_INCLUDE);
 		if (err && err != -EADDRINUSE)
 			return err;
-		greqs->gsr_interface = mreq.imr_ifindex;
+		greqs.gsr_interface = mreq.imr_ifindex;
 		omode = MCAST_INCLUDE;
 		add = 1;
 	} else /* MCAST_LEAVE_SOURCE_GROUP */ {
 		omode = MCAST_INCLUDE;
 		add = 0;
 	}
-	return ip_mc_source(add, omode, sk, &mreqs, greqs->gsr_interface);
+	return ip_mc_source(add, omode, sk, &mreqs, greqs.gsr_interface);
 }
 
 static int ip_set_mcast_msfilter(struct sock *sk, void __user *optval,
@@ -754,7 +782,6 @@ static int ip_set_mcast_msfilter(struct sock *sk, void __user *optval,
 	return err;
 }
 
-#ifdef CONFIG_COMPAT
 static int compat_ip_set_mcast_msfilter(struct sock *sk, void __user *optval,
 		int optlen)
 {
@@ -788,23 +815,16 @@ static int compat_ip_set_mcast_msfilter(struct sock *sk, void __user *optval,
 	if (offsetof(struct compat_group_filter, gf_slist[n]) > optlen)
 		goto out_free_gsf;
 
-	rtnl_lock();
-	lock_sock(sk);
-
 	/* numsrc >= (4G-140)/128 overflow in 32 bits */
 	err = -ENOBUFS;
 	if (n > sock_net(sk)->ipv4.sysctl_igmp_max_msf)
-		goto out_unlock;
+		goto out_free_gsf;
 	err = set_mcast_msfilter(sk, gf32->gf_interface, n, gf32->gf_fmode,
 				 &gf32->gf_group, gf32->gf_slist);
-out_unlock:
-	release_sock(sk);
-	rtnl_unlock();
 out_free_gsf:
 	kfree(p);
 	return err;
 }
-#endif
 
 static int ip_mcast_join_leave(struct sock *sk, int optname,
 		void __user *optval, int optlen)
@@ -828,14 +848,12 @@ static int ip_mcast_join_leave(struct sock *sk, int optname,
 	return ip_mc_leave_group(sk, &mreq);
 }
 
-#ifdef CONFIG_COMPAT
 static int compat_ip_mcast_join_leave(struct sock *sk, int optname,
 		void __user *optval, int optlen)
 {
 	struct compat_group_req greq;
 	struct ip_mreqn mreq = { };
 	struct sockaddr_in *psin;
-	int err;
 
 	if (optlen < sizeof(struct compat_group_req))
 		return -EINVAL;
@@ -848,17 +866,10 @@ static int compat_ip_mcast_join_leave(struct sock *sk, int optname,
 	mreq.imr_multiaddr = psin->sin_addr;
 	mreq.imr_ifindex = greq.gr_interface;
 
-	rtnl_lock();
-	lock_sock(sk);
 	if (optname == MCAST_JOIN_GROUP)
-		err = ip_mc_join_group(sk, &mreq);
-	else
-		err = ip_mc_leave_group(sk, &mreq);
-	release_sock(sk);
-	rtnl_unlock();
-	return err;
+		return ip_mc_join_group(sk, &mreq);
+	return ip_mc_leave_group(sk, &mreq);
 }
-#endif
 
 static int do_ip_setsockopt(struct sock *sk, int level,
 			    int optname, char __user *optval, unsigned int optlen)
@@ -1265,26 +1276,23 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 	}
 	case MCAST_JOIN_GROUP:
 	case MCAST_LEAVE_GROUP:
-		err = ip_mcast_join_leave(sk, optname, optval, optlen);
+		if (in_compat_syscall())
+			err = compat_ip_mcast_join_leave(sk, optname, optval,
+							 optlen);
+		else
+			err = ip_mcast_join_leave(sk, optname, optval, optlen);
 		break;
 	case MCAST_JOIN_SOURCE_GROUP:
 	case MCAST_LEAVE_SOURCE_GROUP:
 	case MCAST_BLOCK_SOURCE:
 	case MCAST_UNBLOCK_SOURCE:
-	{
-		struct group_source_req greqs;
-
-		if (optlen != sizeof(struct group_source_req))
-			goto e_inval;
-		if (copy_from_user(&greqs, optval, sizeof(greqs))) {
-			err = -EFAULT;
-			break;
-		}
-		err = do_mcast_group_source(sk, optname, &greqs);
+		err = do_mcast_group_source(sk, optname, optval, optlen);
 		break;
-	}
 	case MCAST_MSFILTER:
-		err = ip_set_mcast_msfilter(sk, optval, optlen);
+		if (in_compat_syscall())
+			err = compat_ip_set_mcast_msfilter(sk, optval, optlen);
+		else
+			err = ip_set_mcast_msfilter(sk, optval, optlen);
 		break;
 	case IP_MULTICAST_ALL:
 		if (optlen < 1)
@@ -1410,62 +1418,6 @@ int ip_setsockopt(struct sock *sk, int level,
 }
 EXPORT_SYMBOL(ip_setsockopt);
 
-#ifdef CONFIG_COMPAT
-int compat_ip_setsockopt(struct sock *sk, int level, int optname,
-			 char __user *optval, unsigned int optlen)
-{
-	int err;
-
-	if (level != SOL_IP)
-		return -ENOPROTOOPT;
-
-	switch (optname) {
-	case MCAST_JOIN_GROUP:
-	case MCAST_LEAVE_GROUP:
-		return compat_ip_mcast_join_leave(sk, optname, optval, optlen);
-	case MCAST_JOIN_SOURCE_GROUP:
-	case MCAST_LEAVE_SOURCE_GROUP:
-	case MCAST_BLOCK_SOURCE:
-	case MCAST_UNBLOCK_SOURCE:
-	{
-		struct compat_group_source_req __user *gsr32 = (void __user *)optval;
-		struct group_source_req greqs;
-
-		if (optlen != sizeof(struct compat_group_source_req))
-			return -EINVAL;
-
-		if (get_user(greqs.gsr_interface, &gsr32->gsr_interface) ||
-		    copy_from_user(&greqs.gsr_group, &gsr32->gsr_group,
-				sizeof(greqs.gsr_group)) ||
-		    copy_from_user(&greqs.gsr_source, &gsr32->gsr_source,
-				sizeof(greqs.gsr_source)))
-			return -EFAULT;
-
-		rtnl_lock();
-		lock_sock(sk);
-		err = do_mcast_group_source(sk, optname, &greqs);
-		release_sock(sk);
-		rtnl_unlock();
-		return err;
-	}
-	case MCAST_MSFILTER:
-		return compat_ip_set_mcast_msfilter(sk, optval, optlen);
-	}
-
-	err = do_ip_setsockopt(sk, level, optname, optval, optlen);
-#ifdef CONFIG_NETFILTER
-	/* we need to exclude all possible ENOPROTOOPTs except default case */
-	if (err == -ENOPROTOOPT && optname != IP_HDRINCL &&
-			optname != IP_IPSEC_POLICY &&
-			optname != IP_XFRM_POLICY &&
-			!ip_mroute_opt(optname))
-		err = nf_setsockopt(sk, PF_INET, optname, optval, optlen);
-#endif
-	return err;
-}
-EXPORT_SYMBOL(compat_ip_setsockopt);
-#endif
-
 /*
  *	Get the options. Note for future reference. The GET of IP options gets
  *	the _received_ ones. The set sets the _sent_ ones.
@@ -1507,22 +1459,18 @@ static int ip_get_mcast_msfilter(struct sock *sk, void __user *optval,
 	return 0;
 }
 
-#ifdef CONFIG_COMPAT
 static int compat_ip_get_mcast_msfilter(struct sock *sk, void __user *optval,
-		int __user *optlen)
+		int __user *optlen, int len)
 {
 	const int size0 = offsetof(struct compat_group_filter, gf_slist);
 	struct compat_group_filter __user *p = optval;
 	struct compat_group_filter gf32;
 	struct group_filter gf;
-	int len, err;
 	int num;
+	int err;
 
-	if (get_user(len, optlen))
-		return -EFAULT;
 	if (len < size0)
 		return -EINVAL;
-
 	if (copy_from_user(&gf32, p, size0))
 		return -EFAULT;
 
@@ -1531,11 +1479,7 @@ static int compat_ip_get_mcast_msfilter(struct sock *sk, void __user *optval,
 	num = gf.gf_numsrc = gf32.gf_numsrc;
 	gf.gf_group = gf32.gf_group;
 
-	rtnl_lock();
-	lock_sock(sk);
 	err = ip_mc_gsfget(sk, &gf, p->gf_slist);
-	release_sock(sk);
-	rtnl_unlock();
 	if (err)
 		return err;
 	if (gf.gf_numsrc < num)
@@ -1547,10 +1491,9 @@ static int compat_ip_get_mcast_msfilter(struct sock *sk, void __user *optval,
 		return -EFAULT;
 	return 0;
 }
-#endif
 
 static int do_ip_getsockopt(struct sock *sk, int level, int optname,
-			    char __user *optval, int __user *optlen, unsigned int flags)
+			    char __user *optval, int __user *optlen)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	bool needs_rtnl = getsockopt_needs_rtnl(optname);
@@ -1707,7 +1650,11 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 		goto out;
 	}
 	case MCAST_MSFILTER:
-		err = ip_get_mcast_msfilter(sk, optval, optlen, len);
+		if (in_compat_syscall())
+			err = compat_ip_get_mcast_msfilter(sk, optval, optlen,
+							   len);
+		else
+			err = ip_get_mcast_msfilter(sk, optval, optlen, len);
 		goto out;
 	case IP_MULTICAST_ALL:
 		val = inet->mc_all;
@@ -1724,7 +1671,7 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 		msg.msg_control_is_user = true;
 		msg.msg_control_user = optval;
 		msg.msg_controllen = len;
-		msg.msg_flags = flags;
+		msg.msg_flags = in_compat_syscall() ? MSG_CMSG_COMPAT : 0;
 
 		if (inet->cmsg_flags & IP_CMSG_PKTINFO) {
 			struct in_pktinfo info;
@@ -1788,45 +1735,7 @@ int ip_getsockopt(struct sock *sk, int level,
 {
 	int err;
 
-	err = do_ip_getsockopt(sk, level, optname, optval, optlen, 0);
-#if IS_ENABLED(CONFIG_BPFILTER_UMH)
-	if (optname >= BPFILTER_IPT_SO_GET_INFO &&
-	    optname < BPFILTER_IPT_GET_MAX)
-		err = bpfilter_ip_get_sockopt(sk, optname, optval, optlen);
-#endif
-#ifdef CONFIG_NETFILTER
-	/* we need to exclude all possible ENOPROTOOPTs except default case */
-	if (err == -ENOPROTOOPT && optname != IP_PKTOPTIONS &&
-			!ip_mroute_opt(optname)) {
-		int len;
-
-		if (get_user(len, optlen))
-			return -EFAULT;
-
-		err = nf_getsockopt(sk, PF_INET, optname, optval, &len);
-		if (err >= 0)
-			err = put_user(len, optlen);
-		return err;
-	}
-#endif
-	return err;
-}
-EXPORT_SYMBOL(ip_getsockopt);
-
-#ifdef CONFIG_COMPAT
-int compat_ip_getsockopt(struct sock *sk, int level, int optname,
-			 char __user *optval, int __user *optlen)
-{
-	int err;
-
-	if (optname == MCAST_MSFILTER) {
-		if (level != SOL_IP)
-			return -EOPNOTSUPP;
-		return compat_ip_get_mcast_msfilter(sk, optval, optlen);
-	}
-
-	err = do_ip_getsockopt(sk, level, optname, optval, optlen,
-		MSG_CMSG_COMPAT);
+	err = do_ip_getsockopt(sk, level, optname, optval, optlen);
 
 #if IS_ENABLED(CONFIG_BPFILTER_UMH)
 	if (optname >= BPFILTER_IPT_SO_GET_INFO &&
@@ -1850,5 +1759,4 @@ int compat_ip_getsockopt(struct sock *sk, int level, int optname,
 #endif
 	return err;
 }
-EXPORT_SYMBOL(compat_ip_getsockopt);
-#endif
+EXPORT_SYMBOL(ip_getsockopt);
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 47665919048f9d..2a57d633b31e00 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -857,16 +857,6 @@ static int raw_setsockopt(struct sock *sk, int level, int optname,
 	return do_raw_setsockopt(sk, level, optname, optval, optlen);
 }
 
-#ifdef CONFIG_COMPAT
-static int compat_raw_setsockopt(struct sock *sk, int level, int optname,
-				 char __user *optval, unsigned int optlen)
-{
-	if (level != SOL_RAW)
-		return compat_ip_setsockopt(sk, level, optname, optval, optlen);
-	return do_raw_setsockopt(sk, level, optname, optval, optlen);
-}
-#endif
-
 static int do_raw_getsockopt(struct sock *sk, int level, int optname,
 			  char __user *optval, int __user *optlen)
 {
@@ -887,16 +877,6 @@ static int raw_getsockopt(struct sock *sk, int level, int optname,
 	return do_raw_getsockopt(sk, level, optname, optval, optlen);
 }
 
-#ifdef CONFIG_COMPAT
-static int compat_raw_getsockopt(struct sock *sk, int level, int optname,
-				 char __user *optval, int __user *optlen)
-{
-	if (level != SOL_RAW)
-		return compat_ip_getsockopt(sk, level, optname, optval, optlen);
-	return do_raw_getsockopt(sk, level, optname, optval, optlen);
-}
-#endif
-
 static int raw_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
 	switch (cmd) {
@@ -980,8 +960,6 @@ struct proto raw_prot = {
 	.usersize	   = sizeof_field(struct raw_sock, filter),
 	.h.raw_hash	   = &raw_v4_hashinfo,
 #ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_raw_setsockopt,
-	.compat_getsockopt = compat_raw_getsockopt,
 	.compat_ioctl	   = compat_raw_ioctl,
 #endif
 	.diag_destroy	   = raw_abort,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 116c11a0aaed62..e5b7ef9a288769 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2134,10 +2134,6 @@ const struct inet_connection_sock_af_ops ipv4_specific = {
 	.getsockopt	   = ip_getsockopt,
 	.addr2sockaddr	   = inet_csk_addr2sockaddr,
 	.sockaddr_len	   = sizeof(struct sockaddr_in),
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_ip_setsockopt,
-	.compat_getsockopt = compat_ip_getsockopt,
-#endif
 	.mtu_reduced	   = tcp_v4_mtu_reduced,
 };
 EXPORT_SYMBOL(ipv4_specific);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 073d346f515c44..d4be4471c424e3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2656,17 +2656,6 @@ int udp_setsockopt(struct sock *sk, int level, int optname,
 	return ip_setsockopt(sk, level, optname, optval, optlen);
 }
 
-#ifdef CONFIG_COMPAT
-int compat_udp_setsockopt(struct sock *sk, int level, int optname,
-			  char __user *optval, unsigned int optlen)
-{
-	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
-		return udp_lib_setsockopt(sk, level, optname, optval, optlen,
-					  udp_push_pending_frames);
-	return compat_ip_setsockopt(sk, level, optname, optval, optlen);
-}
-#endif
-
 int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		       char __user *optval, int __user *optlen)
 {
@@ -2732,15 +2721,6 @@ int udp_getsockopt(struct sock *sk, int level, int optname,
 	return ip_getsockopt(sk, level, optname, optval, optlen);
 }
 
-#ifdef CONFIG_COMPAT
-int compat_udp_getsockopt(struct sock *sk, int level, int optname,
-				 char __user *optval, int __user *optlen)
-{
-	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
-		return udp_lib_getsockopt(sk, level, optname, optval, optlen);
-	return compat_ip_getsockopt(sk, level, optname, optval, optlen);
-}
-#endif
 /**
  * 	udp_poll - wait for a UDP event.
  *	@file: - file struct
@@ -2812,10 +2792,6 @@ struct proto udp_prot = {
 	.sysctl_rmem_offset	= offsetof(struct net, ipv4.sysctl_udp_rmem_min),
 	.obj_size		= sizeof(struct udp_sock),
 	.h.udp_table		= &udp_table,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt	= compat_udp_setsockopt,
-	.compat_getsockopt	= compat_udp_getsockopt,
-#endif
 	.diag_destroy		= udp_abort,
 };
 EXPORT_SYMBOL(udp_prot);
diff --git a/net/ipv4/udp_impl.h b/net/ipv4/udp_impl.h
index 6b2fa77eeb1c3e..ab313702c87f30 100644
--- a/net/ipv4/udp_impl.h
+++ b/net/ipv4/udp_impl.h
@@ -17,12 +17,6 @@ int udp_setsockopt(struct sock *sk, int level, int optname,
 int udp_getsockopt(struct sock *sk, int level, int optname,
 		   char __user *optval, int __user *optlen);
 
-#ifdef CONFIG_COMPAT
-int compat_udp_setsockopt(struct sock *sk, int level, int optname,
-			  char __user *optval, unsigned int optlen);
-int compat_udp_getsockopt(struct sock *sk, int level, int optname,
-			  char __user *optval, int __user *optlen);
-#endif
 int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 		int flags, int *addr_len);
 int udp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index 5936d66d1ce2f2..bd8773b49e72ed 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -56,10 +56,6 @@ struct proto 	udplite_prot = {
 	.sysctl_mem	   = sysctl_udp_mem,
 	.obj_size	   = sizeof(struct udp_sock),
 	.h.udp_table	   = &udplite_table,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_udp_setsockopt,
-	.compat_getsockopt = compat_udp_getsockopt,
-#endif
 };
 EXPORT_SYMBOL(udplite_prot);
 
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index f8d7412cfb3d37..2a3fd31fb589dc 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -612,10 +612,6 @@ static struct proto l2tp_ip_prot = {
 	.hash		   = l2tp_ip_hash,
 	.unhash		   = l2tp_ip_unhash,
 	.obj_size	   = sizeof(struct l2tp_ip_sock),
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_ip_setsockopt,
-	.compat_getsockopt = compat_ip_getsockopt,
-#endif
 };
 
 static const struct proto_ops l2tp_ip_ops = {
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 8d25cc464efdf3..7ecaf7d575c097 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1089,10 +1089,6 @@ static struct sctp_af sctp_af_inet = {
 	.net_header_len	   = sizeof(struct iphdr),
 	.sockaddr_len	   = sizeof(struct sockaddr_in),
 	.ip_options_len	   = sctp_v4_ip_options_len,
-#ifdef CONFIG_COMPAT
-	.compat_setsockopt = compat_ip_setsockopt,
-	.compat_getsockopt = compat_ip_getsockopt,
-#endif
 };
 
 struct sctp_pf *sctp_get_pf_specific(sa_family_t family)
-- 
2.27.0

