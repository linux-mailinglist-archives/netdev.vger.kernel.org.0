Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BECE225F19
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgGTMse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729032AbgGTMsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:48:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB2BC061794;
        Mon, 20 Jul 2020 05:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=AgSxP7iVdXVEFS4IDrHx6ue4s0yWgQSmSEoUvewskkk=; b=RnnEltcg+Ve0KXQ0POUmdkEhpX
        m1Bl97bPCoO6r8RFt3Qske527Eq14kMVg1fs39zlPOUd4EYJigbO4Grlx3xLvXvF/prk8LOYGc74j
        84J6ZYEYeCJ6WnSwdoqcDax+ytfD8QfFPptmk3pPk2rgk63lkp3rVsJd/oLkg8eVQ8LAWdk6WadIU
        TxEKdrHInirGIMTBUfhY+V3RnTL3IgLtMkANfP2k2NKs8zOygnqI+NbkmgzymdFFSSBwv1aoemFbk
        KnC1dodsQVRGQmoqbDS0Kim0fWLF5oTQJG5uoeTUk9C0GAa1c9wqcFgAdQdaU3pMfzuzdi4NCqnIt
        WVPrsBWA==;
Received: from [2001:4bb8:105:4a81:2a8f:15b1:2c3:7be7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxVDM-0004Zn-DD; Mon, 20 Jul 2020 12:48:17 +0000
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
Subject: [PATCH 14/24] net/ipv4: merge ip_options_get and ip_options_get_from_user
Date:   Mon, 20 Jul 2020 14:47:27 +0200
Message-Id: <20200720124737.118617-15-hch@lst.de>
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

Use the sockptr_t type to merge the versions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ip.h       |  5 ++---
 net/ipv4/ip_options.c  | 43 +++++++++++-------------------------------
 net/ipv4/ip_sockglue.c |  7 ++++---
 3 files changed, 17 insertions(+), 38 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 3d34acc95ca825..d66ad3a9522081 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -23,6 +23,7 @@
 #include <linux/in.h>
 #include <linux/skbuff.h>
 #include <linux/jhash.h>
+#include <linux/sockptr.h>
 
 #include <net/inet_sock.h>
 #include <net/route.h>
@@ -707,9 +708,7 @@ int __ip_options_compile(struct net *net, struct ip_options *opt,
 int ip_options_compile(struct net *net, struct ip_options *opt,
 		       struct sk_buff *skb);
 int ip_options_get(struct net *net, struct ip_options_rcu **optp,
-		   unsigned char *data, int optlen);
-int ip_options_get_from_user(struct net *net, struct ip_options_rcu **optp,
-			     unsigned char __user *data, int optlen);
+		   sockptr_t data, int optlen);
 void ip_options_undo(struct ip_options *opt);
 void ip_forward_options(struct sk_buff *skb);
 int ip_options_rcv_srr(struct sk_buff *skb, struct net_device *dev);
diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index ddaa01ec2bce82..948747aac4e2d0 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -519,15 +519,20 @@ void ip_options_undo(struct ip_options *opt)
 	}
 }
 
-static struct ip_options_rcu *ip_options_get_alloc(const int optlen)
+int ip_options_get(struct net *net, struct ip_options_rcu **optp,
+		   sockptr_t data, int optlen)
 {
-	return kzalloc(sizeof(struct ip_options_rcu) + ((optlen + 3) & ~3),
+	struct ip_options_rcu *opt;
+
+	opt = kzalloc(sizeof(struct ip_options_rcu) + ((optlen + 3) & ~3),
 		       GFP_KERNEL);
-}
+	if (!opt)
+		return -ENOMEM;
+	if (optlen && copy_from_sockptr(opt->opt.__data, data, optlen)) {
+		kfree(opt);
+		return -EFAULT;
+	}
 
-static int ip_options_get_finish(struct net *net, struct ip_options_rcu **optp,
-				 struct ip_options_rcu *opt, int optlen)
-{
 	while (optlen & 3)
 		opt->opt.__data[optlen++] = IPOPT_END;
 	opt->opt.optlen = optlen;
@@ -540,32 +545,6 @@ static int ip_options_get_finish(struct net *net, struct ip_options_rcu **optp,
 	return 0;
 }
 
-int ip_options_get_from_user(struct net *net, struct ip_options_rcu **optp,
-			     unsigned char __user *data, int optlen)
-{
-	struct ip_options_rcu *opt = ip_options_get_alloc(optlen);
-
-	if (!opt)
-		return -ENOMEM;
-	if (optlen && copy_from_user(opt->opt.__data, data, optlen)) {
-		kfree(opt);
-		return -EFAULT;
-	}
-	return ip_options_get_finish(net, optp, opt, optlen);
-}
-
-int ip_options_get(struct net *net, struct ip_options_rcu **optp,
-		   unsigned char *data, int optlen)
-{
-	struct ip_options_rcu *opt = ip_options_get_alloc(optlen);
-
-	if (!opt)
-		return -ENOMEM;
-	if (optlen)
-		memcpy(opt->opt.__data, data, optlen);
-	return ip_options_get_finish(net, optp, opt, optlen);
-}
-
 void ip_forward_options(struct sk_buff *skb)
 {
 	struct   ip_options *opt	= &(IPCB(skb)->opt);
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index ac495b0cff8ffb..b12f39b52008a3 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -280,7 +280,8 @@ int ip_cmsg_send(struct sock *sk, struct msghdr *msg, struct ipcm_cookie *ipc,
 			err = cmsg->cmsg_len - sizeof(struct cmsghdr);
 
 			/* Our caller is responsible for freeing ipc->opt */
-			err = ip_options_get(net, &ipc->opt, CMSG_DATA(cmsg),
+			err = ip_options_get(net, &ipc->opt,
+					     KERNEL_SOCKPTR(CMSG_DATA(cmsg)),
 					     err < 40 ? err : 40);
 			if (err)
 				return err;
@@ -940,8 +941,8 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 
 		if (optlen > 40)
 			goto e_inval;
-		err = ip_options_get_from_user(sock_net(sk), &opt,
-					       optval, optlen);
+		err = ip_options_get(sock_net(sk), &opt, USER_SOCKPTR(optval),
+					      optlen);
 		if (err)
 			break;
 		old = rcu_dereference_protected(inet->inet_opt,
-- 
2.27.0

