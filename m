Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6B52233EA
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgGQGYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgGQGYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC31C061755;
        Thu, 16 Jul 2020 23:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=5UhNspDdIml9tpfUfRWGkC9v9AOZv925n+e1F7He35A=; b=ngePkQgpsw8v14v2e2H1RuLUgP
        0xqQQ043zu+gtXRpXV0bf1ADe/edoqtXj7z3kKW9mKK+iCMOqbmpx3giNOQFrEznviF1qfzoZwbDo
        xr7UnllY+pDKH2CH55FbdxZENM4P5ohmSYAJ0fRT7rs+qqeSNBf08yCPD3u4f/qFc5Y9NGvnoQNep
        Q1DsD4GKGED6DkS1FkzSoMqYpNOH/w2g4VpT16FR3tH0BYHZ8AioctdDH4k7C39SaqLi85vEZptIG
        vVRFnCSAKWjMPjLVXYuX97UKI3rDl+CoNmVE1f7b4ZTU02I8+ZHtLq4ucRfi35nEz/aA046/AsP0+
        9sdcqAzw==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJnA-00054z-MC; Fri, 17 Jul 2020 06:24:21 +0000
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
Subject: [PATCH 16/22] net/ipv4: factor out mcast join/leave setsockopt helpers
Date:   Fri, 17 Jul 2020 08:23:25 +0200
Message-Id: <20200717062331.691152-17-hch@lst.de>
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

Factor out one helper each for setting the native and compat
version of the MCAST_MSFILTER option.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv4/ip_sockglue.c | 109 +++++++++++++++++++++--------------------
 1 file changed, 56 insertions(+), 53 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index b587dee006f882..73bb88fbe54661 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -806,6 +806,60 @@ static int compat_ip_set_mcast_msfilter(struct sock *sk, void __user *optval,
 }
 #endif
 
+static int ip_mcast_join_leave(struct sock *sk, int optname,
+		void __user *optval, int optlen)
+{
+	struct ip_mreqn mreq = { };
+	struct sockaddr_in *psin;
+	struct group_req greq;
+
+	if (optlen < sizeof(struct group_req))
+		return -EINVAL;
+	if (copy_from_user(&greq, optval, sizeof(greq)))
+		return -EFAULT;
+
+	psin = (struct sockaddr_in *)&greq.gr_group;
+	if (psin->sin_family != AF_INET)
+		return -EINVAL;
+	mreq.imr_multiaddr = psin->sin_addr;
+	mreq.imr_ifindex = greq.gr_interface;
+	if (optname == MCAST_JOIN_GROUP)
+		return ip_mc_join_group(sk, &mreq);
+	return ip_mc_leave_group(sk, &mreq);
+}
+
+#ifdef CONFIG_COMPAT
+static int compat_ip_mcast_join_leave(struct sock *sk, int optname,
+		void __user *optval, int optlen)
+{
+	struct compat_group_req greq;
+	struct ip_mreqn mreq = { };
+	struct sockaddr_in *psin;
+	int err;
+
+	if (optlen < sizeof(struct compat_group_req))
+		return -EINVAL;
+	if (copy_from_user(&greq, optval, sizeof(greq)))
+		return -EFAULT;
+
+	psin = (struct sockaddr_in *)&greq.gr_group;
+	if (psin->sin_family != AF_INET)
+		return -EINVAL;
+	mreq.imr_multiaddr = psin->sin_addr;
+	mreq.imr_ifindex = greq.gr_interface;
+
+	rtnl_lock();
+	lock_sock(sk);
+	if (optname == MCAST_JOIN_GROUP)
+		err = ip_mc_join_group(sk, &mreq);
+	else
+		err = ip_mc_leave_group(sk, &mreq);
+	release_sock(sk);
+	rtnl_unlock();
+	return err;
+}
+#endif
+
 static int do_ip_setsockopt(struct sock *sk, int level,
 			    int optname, char __user *optval, unsigned int optlen)
 {
@@ -1211,29 +1265,8 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 	}
 	case MCAST_JOIN_GROUP:
 	case MCAST_LEAVE_GROUP:
-	{
-		struct group_req greq;
-		struct sockaddr_in *psin;
-		struct ip_mreqn mreq;
-
-		if (optlen < sizeof(struct group_req))
-			goto e_inval;
-		err = -EFAULT;
-		if (copy_from_user(&greq, optval, sizeof(greq)))
-			break;
-		psin = (struct sockaddr_in *)&greq.gr_group;
-		if (psin->sin_family != AF_INET)
-			goto e_inval;
-		memset(&mreq, 0, sizeof(mreq));
-		mreq.imr_multiaddr = psin->sin_addr;
-		mreq.imr_ifindex = greq.gr_interface;
-
-		if (optname == MCAST_JOIN_GROUP)
-			err = ip_mc_join_group(sk, &mreq);
-		else
-			err = ip_mc_leave_group(sk, &mreq);
+		err = ip_mcast_join_leave(sk, optname, optval, optlen);
 		break;
-	}
 	case MCAST_JOIN_SOURCE_GROUP:
 	case MCAST_LEAVE_SOURCE_GROUP:
 	case MCAST_BLOCK_SOURCE:
@@ -1389,37 +1422,7 @@ int compat_ip_setsockopt(struct sock *sk, int level, int optname,
 	switch (optname) {
 	case MCAST_JOIN_GROUP:
 	case MCAST_LEAVE_GROUP:
-	{
-		struct compat_group_req __user *gr32 = (void __user *)optval;
-		struct group_req greq;
-		struct sockaddr_in *psin = (struct sockaddr_in *)&greq.gr_group;
-		struct ip_mreqn mreq;
-
-		if (optlen < sizeof(struct compat_group_req))
-			return -EINVAL;
-
-		if (get_user(greq.gr_interface, &gr32->gr_interface) ||
-		    copy_from_user(&greq.gr_group, &gr32->gr_group,
-				sizeof(greq.gr_group)))
-			return -EFAULT;
-
-		if (psin->sin_family != AF_INET)
-			return -EINVAL;
-
-		memset(&mreq, 0, sizeof(mreq));
-		mreq.imr_multiaddr = psin->sin_addr;
-		mreq.imr_ifindex = greq.gr_interface;
-
-		rtnl_lock();
-		lock_sock(sk);
-		if (optname == MCAST_JOIN_GROUP)
-			err = ip_mc_join_group(sk, &mreq);
-		else
-			err = ip_mc_leave_group(sk, &mreq);
-		release_sock(sk);
-		rtnl_unlock();
-		return err;
-	}
+		return compat_ip_mcast_join_leave(sk, optname, optval, optlen);
 	case MCAST_JOIN_SOURCE_GROUP:
 	case MCAST_LEAVE_SOURCE_GROUP:
 	case MCAST_BLOCK_SOURCE:
-- 
2.27.0

