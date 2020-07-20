Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2216C225EF9
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgGTMsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729195AbgGTMss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:48:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC15C061794;
        Mon, 20 Jul 2020 05:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=GQn0sG9CSctd3r9tXWfKFi/perePeGXKxZIJGtFsY+Q=; b=X4uzGeNPKo0XSGnzu8xCZ3ILFx
        iP7gt8StBF43AdVui2+PI+2wBcc0BcoqL9vxrZK9N086yxeXTTJi78IQHFStqzejrTuE+I+nhvoOT
        /n+yUed61AqqNbJgATD4DKCx/smgC26qET+TTVoCPrs5AYQeeav5DV7eArEey1VDOtdwQqvmlspBs
        xzEHXl4tpNjCHuy4HSTnaq1aWriYa9Z+1en44osAOEnhFvn3QIP2g0iRqAr6xArrnxApqpwgk1hce
        VZIxsGdRbHT6hHUymppaqrolyeIfWBAw7o4OrPUbgreSDeDAF5FBRPm98nX11NZMT6xMw2JqQrJJR
        P/dOnE8w==;
Received: from [2001:4bb8:105:4a81:2a8f:15b1:2c3:7be7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxVDf-0004ct-DY; Mon, 20 Jul 2020 12:48:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: [PATCH 20/24] net/ipv6: switch do_ipv6_setsockopt to sockptr_t
Date:   Mon, 20 Jul 2020 14:47:33 +0200
Message-Id: <20200720124737.118617-21-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720124737.118617-1-hch@lst.de>
References: <20200720124737.118617-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a sockptr_t to prepare for set_fs-less handling of the kernel
pointer from bpf-cgroup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv6/ipv6_sockglue.c | 66 ++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 90442c8366dff2..dcd000a5a9b124 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -136,15 +136,15 @@ static bool setsockopt_needs_rtnl(int optname)
 	return false;
 }
 
-static int copy_group_source_from_user(struct group_source_req *greqs,
-		void __user *optval, int optlen)
+static int copy_group_source_from_sockptr(struct group_source_req *greqs,
+		sockptr_t optval, int optlen)
 {
 	if (in_compat_syscall()) {
 		struct compat_group_source_req gr32;
 
 		if (optlen < sizeof(gr32))
 			return -EINVAL;
-		if (copy_from_user(&gr32, optval, sizeof(gr32)))
+		if (copy_from_sockptr(&gr32, optval, sizeof(gr32)))
 			return -EFAULT;
 		greqs->gsr_interface = gr32.gsr_interface;
 		greqs->gsr_group = gr32.gsr_group;
@@ -152,7 +152,7 @@ static int copy_group_source_from_user(struct group_source_req *greqs,
 	} else {
 		if (optlen < sizeof(*greqs))
 			return -EINVAL;
-		if (copy_from_user(greqs, optval, sizeof(*greqs)))
+		if (copy_from_sockptr(greqs, optval, sizeof(*greqs)))
 			return -EFAULT;
 	}
 
@@ -160,13 +160,13 @@ static int copy_group_source_from_user(struct group_source_req *greqs,
 }
 
 static int do_ipv6_mcast_group_source(struct sock *sk, int optname,
-		void __user *optval, int optlen)
+		sockptr_t optval, int optlen)
 {
 	struct group_source_req greqs;
 	int omode, add;
 	int ret;
 
-	ret = copy_group_source_from_user(&greqs, optval, optlen);
+	ret = copy_group_source_from_sockptr(&greqs, optval, optlen);
 	if (ret)
 		return ret;
 
@@ -200,7 +200,7 @@ static int do_ipv6_mcast_group_source(struct sock *sk, int optname,
 	return ip6_mc_source(add, omode, sk, &greqs);
 }
 
-static int ipv6_set_mcast_msfilter(struct sock *sk, void __user *optval,
+static int ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 		int optlen)
 {
 	struct group_filter *gsf;
@@ -211,7 +211,7 @@ static int ipv6_set_mcast_msfilter(struct sock *sk, void __user *optval,
 	if (optlen > sysctl_optmem_max)
 		return -ENOBUFS;
 
-	gsf = memdup_user(optval, optlen);
+	gsf = memdup_sockptr(optval, optlen);
 	if (IS_ERR(gsf))
 		return PTR_ERR(gsf);
 
@@ -231,7 +231,7 @@ static int ipv6_set_mcast_msfilter(struct sock *sk, void __user *optval,
 	return ret;
 }
 
-static int compat_ipv6_set_mcast_msfilter(struct sock *sk, void __user *optval,
+static int compat_ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 		int optlen)
 {
 	const int size0 = offsetof(struct compat_group_filter, gf_slist);
@@ -251,7 +251,7 @@ static int compat_ipv6_set_mcast_msfilter(struct sock *sk, void __user *optval,
 
 	gf32 = p + 4; /* we want ->gf_group and ->gf_slist aligned */
 	ret = -EFAULT;
-	if (copy_from_user(gf32, optval, optlen))
+	if (copy_from_sockptr(gf32, optval, optlen))
 		goto out_free_p;
 
 	/* numsrc >= (4G-140)/128 overflow in 32 bits */
@@ -276,14 +276,14 @@ static int compat_ipv6_set_mcast_msfilter(struct sock *sk, void __user *optval,
 }
 
 static int ipv6_mcast_join_leave(struct sock *sk, int optname,
-		void __user *optval, int optlen)
+		sockptr_t optval, int optlen)
 {
 	struct sockaddr_in6 *psin6;
 	struct group_req greq;
 
 	if (optlen < sizeof(greq))
 		return -EINVAL;
-	if (copy_from_user(&greq, optval, sizeof(greq)))
+	if (copy_from_sockptr(&greq, optval, sizeof(greq)))
 		return -EFAULT;
 
 	if (greq.gr_group.ss_family != AF_INET6)
@@ -296,14 +296,14 @@ static int ipv6_mcast_join_leave(struct sock *sk, int optname,
 }
 
 static int compat_ipv6_mcast_join_leave(struct sock *sk, int optname,
-		void __user *optval, int optlen)
+		sockptr_t optval, int optlen)
 {
 	struct compat_group_req gr32;
 	struct sockaddr_in6 *psin6;
 
 	if (optlen < sizeof(gr32))
 		return -EINVAL;
-	if (copy_from_user(&gr32, optval, sizeof(gr32)))
+	if (copy_from_sockptr(&gr32, optval, sizeof(gr32)))
 		return -EFAULT;
 
 	if (gr32.gr_group.ss_family != AF_INET6)
@@ -315,7 +315,7 @@ static int compat_ipv6_mcast_join_leave(struct sock *sk, int optname,
 	return ipv6_sock_mc_drop(sk, gr32.gr_interface, &psin6->sin6_addr);
 }
 
-static int ipv6_set_opt_hdr(struct sock *sk, int optname, void __user *optval,
+static int ipv6_set_opt_hdr(struct sock *sk, int optname, sockptr_t optval,
 		int optlen)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
@@ -332,14 +332,14 @@ static int ipv6_set_opt_hdr(struct sock *sk, int optname, void __user *optval,
 	 * length, per RFC3542.
 	 */
 	if (optlen > 0) {
-		if (!optval)
+		if (sockptr_is_null(optval))
 			return -EINVAL;
 		if (optlen < sizeof(struct ipv6_opt_hdr) ||
 		    optlen & 0x7 ||
 		    optlen > 8 * 255)
 			return -EINVAL;
 
-		new = memdup_user(optval, optlen);
+		new = memdup_sockptr(optval, optlen);
 		if (IS_ERR(new))
 			return PTR_ERR(new);
 		if (unlikely(ipv6_optlen(new) > optlen)) {
@@ -390,7 +390,7 @@ static int ipv6_set_opt_hdr(struct sock *sk, int optname, void __user *optval,
 }
 
 static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
-		    char __user *optval, unsigned int optlen)
+		   sockptr_t optval, unsigned int optlen)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct net *net = sock_net(sk);
@@ -398,11 +398,11 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 	int retv = -ENOPROTOOPT;
 	bool needs_rtnl = setsockopt_needs_rtnl(optname);
 
-	if (!optval)
+	if (sockptr_is_null(optval))
 		val = 0;
 	else {
 		if (optlen >= sizeof(int)) {
-			if (get_user(val, (int __user *) optval))
+			if (copy_from_sockptr(&val, optval, sizeof(val)))
 				return -EFAULT;
 		} else
 			val = 0;
@@ -411,8 +411,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 	valbool = (val != 0);
 
 	if (ip6_mroute_opt(optname))
-		return ip6_mroute_setsockopt(sk, optname, USER_SOCKPTR(optval),
-					     optlen);
+		return ip6_mroute_setsockopt(sk, optname, optval, optlen);
 
 	if (needs_rtnl)
 		rtnl_lock();
@@ -663,12 +662,13 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 
 		if (optlen == 0)
 			goto e_inval;
-		else if (optlen < sizeof(struct in6_pktinfo) || !optval)
+		else if (optlen < sizeof(struct in6_pktinfo) ||
+			 sockptr_is_null(optval))
 			goto e_inval;
 
-		if (copy_from_user(&pkt, optval, sizeof(struct in6_pktinfo))) {
-				retv = -EFAULT;
-				break;
+		if (copy_from_sockptr(&pkt, optval, sizeof(pkt))) {
+			retv = -EFAULT;
+			break;
 		}
 		if (!sk_dev_equal_l3scope(sk, pkt.ipi6_ifindex))
 			goto e_inval;
@@ -709,7 +709,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		refcount_set(&opt->refcnt, 1);
 		opt->tot_len = sizeof(*opt) + optlen;
 		retv = -EFAULT;
-		if (copy_from_user(opt+1, optval, optlen))
+		if (copy_from_sockptr(opt + 1, optval, optlen))
 			goto done;
 
 		msg.msg_controllen = optlen;
@@ -831,7 +831,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 			break;
 
 		retv = -EFAULT;
-		if (copy_from_user(&mreq, optval, sizeof(struct ipv6_mreq)))
+		if (copy_from_sockptr(&mreq, optval, sizeof(struct ipv6_mreq)))
 			break;
 
 		if (optname == IPV6_ADD_MEMBERSHIP)
@@ -849,7 +849,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 			goto e_inval;
 
 		retv = -EFAULT;
-		if (copy_from_user(&mreq, optval, sizeof(struct ipv6_mreq)))
+		if (copy_from_sockptr(&mreq, optval, sizeof(struct ipv6_mreq)))
 			break;
 
 		if (optname == IPV6_JOIN_ANYCAST)
@@ -929,15 +929,14 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		retv = 0;
 		break;
 	case IPV6_FLOWLABEL_MGR:
-		retv = ipv6_flowlabel_opt(sk, USER_SOCKPTR(optval), optlen);
+		retv = ipv6_flowlabel_opt(sk, optval, optlen);
 		break;
 	case IPV6_IPSEC_POLICY:
 	case IPV6_XFRM_POLICY:
 		retv = -EPERM;
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			break;
-		retv = xfrm_user_policy(sk, optname, USER_SOCKPTR(optval),
-					optlen);
+		retv = xfrm_user_policy(sk, optname, optval, optlen);
 		break;
 
 	case IPV6_ADDR_PREFERENCES:
@@ -992,7 +991,8 @@ int ipv6_setsockopt(struct sock *sk, int level, int optname,
 	if (level != SOL_IPV6)
 		return -ENOPROTOOPT;
 
-	err = do_ipv6_setsockopt(sk, level, optname, optval, optlen);
+	err = do_ipv6_setsockopt(sk, level, optname, USER_SOCKPTR(optval),
+				 optlen);
 #ifdef CONFIG_NETFILTER
 	/* we need to exclude all possible ENOPROTOOPTs except default case */
 	if (err == -ENOPROTOOPT && optname != IPV6_IPSEC_POLICY &&
-- 
2.27.0

