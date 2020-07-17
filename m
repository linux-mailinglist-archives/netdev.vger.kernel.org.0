Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B542233FD
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgGQGY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgGQGYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D77CC061755;
        Thu, 16 Jul 2020 23:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hTVOd3UZredsxZyfKUM3xddwhLoRQHrm4mrO/1PLzMY=; b=ddaAJJead2QuCg8AEy4hqxQ947
        pYgOj7htGBfdPViQwK0s0Vw8MrYBgAvSHG2QfBVCuIb8m7J9H5KoNFX1OM67AI2yDKNOYXn07f8WN
        VASvMsJRwd6ugDo9abPx3J8v3xJ+Gwtq8xRfI6WJRA3+Jwdix5gvgoLm/72Y9Qp18kBgaR0LrvxiJ
        apAqoAoJ0teV8HW4EFrM0bJBw9zVGN+nUohIDxEKdymjzfarx00DmA+eAMwLy7QdaYBsmlJYE5fB1
        0nH3dfU9kXdg5kuqTzgKjGj+c7qVx9HbYNApA0JC0ONocXO2Cp746qhMENQQVOaj+X9jGFtJBpnLe
        unpW/dIw==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJn2-00053o-Dz; Fri, 17 Jul 2020 06:24:13 +0000
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
Subject: [PATCH 11/22] netfilter: remove the compat_{get,set} methods
Date:   Fri, 17 Jul 2020 08:23:20 +0200
Message-Id: <20200717062331.691152-12-hch@lst.de>
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

All instances handle compat sockopts via in_compat_syscall() now, so
remove the compat_{get,set} methods as well as the
compat_nf_{get,set}sockopt wrappers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/netfilter.h  | 14 -------------
 net/ipv4/ip_sockglue.c     |  5 ++---
 net/ipv6/ipv6_sockglue.c   |  5 ++---
 net/netfilter/nf_sockopt.c | 42 --------------------------------------
 4 files changed, 4 insertions(+), 62 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index eb312e7ca36ee5..711b4d4486f042 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -164,17 +164,9 @@ struct nf_sockopt_ops {
 	int set_optmin;
 	int set_optmax;
 	int (*set)(struct sock *sk, int optval, void __user *user, unsigned int len);
-#ifdef CONFIG_COMPAT
-	int (*compat_set)(struct sock *sk, int optval,
-			void __user *user, unsigned int len);
-#endif
 	int get_optmin;
 	int get_optmax;
 	int (*get)(struct sock *sk, int optval, void __user *user, int *len);
-#ifdef CONFIG_COMPAT
-	int (*compat_get)(struct sock *sk, int optval,
-			void __user *user, int *len);
-#endif
 	/* Use the module struct to lock set/get code in place */
 	struct module *owner;
 };
@@ -350,12 +342,6 @@ int nf_setsockopt(struct sock *sk, u_int8_t pf, int optval, char __user *opt,
 		  unsigned int len);
 int nf_getsockopt(struct sock *sk, u_int8_t pf, int optval, char __user *opt,
 		  int *len);
-#ifdef CONFIG_COMPAT
-int compat_nf_setsockopt(struct sock *sk, u_int8_t pf, int optval,
-		char __user *opt, unsigned int len);
-int compat_nf_getsockopt(struct sock *sk, u_int8_t pf, int optval,
-		char __user *opt, int *len);
-#endif
 
 struct flowi;
 struct nf_queue_entry;
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 84ec3703c90916..95f4248c6fc5ed 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1446,8 +1446,7 @@ int compat_ip_setsockopt(struct sock *sk, int level, int optname,
 			optname != IP_IPSEC_POLICY &&
 			optname != IP_XFRM_POLICY &&
 			!ip_mroute_opt(optname))
-		err = compat_nf_setsockopt(sk, PF_INET, optname, optval,
-					   optlen);
+		err = nf_setsockopt(sk, PF_INET, optname, optval, optlen);
 #endif
 	return err;
 }
@@ -1821,7 +1820,7 @@ int compat_ip_getsockopt(struct sock *sk, int level, int optname,
 		if (get_user(len, optlen))
 			return -EFAULT;
 
-		err = compat_nf_getsockopt(sk, PF_INET, optname, optval, &len);
+		err = nf_getsockopt(sk, PF_INET, optname, optval, &len);
 		if (err >= 0)
 			err = put_user(len, optlen);
 		return err;
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 6ab44ec2c369da..6adfbdcb7979bd 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -1030,8 +1030,7 @@ int compat_ipv6_setsockopt(struct sock *sk, int level, int optname,
 	/* we need to exclude all possible ENOPROTOOPTs except default case */
 	if (err == -ENOPROTOOPT && optname != IPV6_IPSEC_POLICY &&
 	    optname != IPV6_XFRM_POLICY)
-		err = compat_nf_setsockopt(sk, PF_INET6, optname, optval,
-					   optlen);
+		err = nf_setsockopt(sk, PF_INET6, optname, optval, optlen);
 #endif
 	return err;
 }
@@ -1531,7 +1530,7 @@ int compat_ipv6_getsockopt(struct sock *sk, int level, int optname,
 		if (get_user(len, optlen))
 			return -EFAULT;
 
-		err = compat_nf_getsockopt(sk, PF_INET6, optname, optval, &len);
+		err = nf_getsockopt(sk, PF_INET6, optname, optval, &len);
 		if (err >= 0)
 			err = put_user(len, optlen);
 	}
diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index 46cb3786e0ec5c..02870993d335c9 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -122,45 +122,3 @@ int nf_getsockopt(struct sock *sk, u_int8_t pf, int val, char __user *opt,
 	return nf_sockopt(sk, pf, val, opt, len, 1);
 }
 EXPORT_SYMBOL(nf_getsockopt);
-
-#ifdef CONFIG_COMPAT
-static int compat_nf_sockopt(struct sock *sk, u_int8_t pf, int val,
-			     char __user *opt, int *len, int get)
-{
-	struct nf_sockopt_ops *ops;
-	int ret;
-
-	ops = nf_sockopt_find(sk, pf, val, get);
-	if (IS_ERR(ops))
-		return PTR_ERR(ops);
-
-	if (get) {
-		if (ops->compat_get)
-			ret = ops->compat_get(sk, val, opt, len);
-		else
-			ret = ops->get(sk, val, opt, len);
-	} else {
-		if (ops->compat_set)
-			ret = ops->compat_set(sk, val, opt, *len);
-		else
-			ret = ops->set(sk, val, opt, *len);
-	}
-
-	module_put(ops->owner);
-	return ret;
-}
-
-int compat_nf_setsockopt(struct sock *sk, u_int8_t pf,
-		int val, char __user *opt, unsigned int len)
-{
-	return compat_nf_sockopt(sk, pf, val, opt, &len, 0);
-}
-EXPORT_SYMBOL(compat_nf_setsockopt);
-
-int compat_nf_getsockopt(struct sock *sk, u_int8_t pf,
-		int val, char __user *opt, int *len)
-{
-	return compat_nf_sockopt(sk, pf, val, opt, len, 1);
-}
-EXPORT_SYMBOL(compat_nf_getsockopt);
-#endif
-- 
2.27.0

