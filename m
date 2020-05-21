Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8AE1DC413
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgEUAi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbgEUAhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 20:37:23 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1B3C061A0E;
        Wed, 20 May 2020 17:37:23 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jbZD7-00CgdZ-VH; Thu, 21 May 2020 00:37:22 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/19] ip*_mc_gsfget(): lift copyout of struct group_filter into callers
Date:   Thu, 21 May 2020 01:37:05 +0100
Message-Id: <20200521003721.3023783-3-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200521003721.3023783-1-viro@ZenIV.linux.org.uk>
References: <20200521003657.GE23230@ZenIV.linux.org.uk>
 <20200521003721.3023783-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

pass the userland pointer to the array in its tail, so that part
gets copied out by our functions; copyout of everything else is
done in the callers.  Rationale: reuse for compat; the array
is the same in native and compat, the layout of parts before it
is different for compat.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/igmp.h     |  2 +-
 include/net/ipv6.h       |  2 +-
 net/ipv4/igmp.c          | 18 +++++-------------
 net/ipv4/ip_sockglue.c   | 19 ++++++++++++++-----
 net/ipv6/ipv6_sockglue.c | 18 ++++++++++++++----
 net/ipv6/mcast.c         | 10 +++-------
 6 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index faa6586a5783..64ce8cd1cfaf 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -123,7 +123,7 @@ extern int ip_mc_msfilter(struct sock *sk, struct ip_msfilter *msf,int ifindex);
 extern int ip_mc_msfget(struct sock *sk, struct ip_msfilter *msf,
 		struct ip_msfilter __user *optval, int __user *optlen);
 extern int ip_mc_gsfget(struct sock *sk, struct group_filter *gsf,
-		struct group_filter __user *optval, int __user *optlen);
+			struct sockaddr_storage __user *p);
 extern int ip_mc_sf_allow(struct sock *sk, __be32 local, __be32 rmt,
 			  int dif, int sdif);
 extern void ip_mc_init_dev(struct in_device *);
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 5fc3a9d7b053..c45eb78d970f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1138,7 +1138,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		  struct group_source_req *pgsr);
 int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf);
 int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
-		  struct group_filter __user *optval, int __user *optlen);
+		  struct sockaddr_storage __user *p);
 
 #ifdef CONFIG_PROC_FS
 int ac6_proc_init(struct net *net);
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 47f0502b2101..7b272bbed2b4 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2565,9 +2565,9 @@ int ip_mc_msfget(struct sock *sk, struct ip_msfilter *msf,
 }
 
 int ip_mc_gsfget(struct sock *sk, struct group_filter *gsf,
-	struct group_filter __user *optval, int __user *optlen)
+	struct sockaddr_storage __user *p)
 {
-	int err, i, count, copycount;
+	int i, count, copycount;
 	struct sockaddr_in *psin;
 	__be32 addr;
 	struct ip_mc_socklist *pmc;
@@ -2583,37 +2583,29 @@ int ip_mc_gsfget(struct sock *sk, struct group_filter *gsf,
 	if (!ipv4_is_multicast(addr))
 		return -EINVAL;
 
-	err = -EADDRNOTAVAIL;
-
 	for_each_pmc_rtnl(inet, pmc) {
 		if (pmc->multi.imr_multiaddr.s_addr == addr &&
 		    pmc->multi.imr_ifindex == gsf->gf_interface)
 			break;
 	}
 	if (!pmc)		/* must have a prior join */
-		goto done;
+		return -EADDRNOTAVAIL;
 	gsf->gf_fmode = pmc->sfmode;
 	psl = rtnl_dereference(pmc->sflist);
 	count = psl ? psl->sl_count : 0;
 	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
 	gsf->gf_numsrc = count;
-	if (put_user(GROUP_FILTER_SIZE(copycount), optlen) ||
-	    copy_to_user(optval, gsf, GROUP_FILTER_SIZE(0))) {
-		return -EFAULT;
-	}
-	for (i = 0; i < copycount; i++) {
+	for (i = 0; i < copycount; i++, p++) {
 		struct sockaddr_storage ss;
 
 		psin = (struct sockaddr_in *)&ss;
 		memset(&ss, 0, sizeof(ss));
 		psin->sin_family = AF_INET;
 		psin->sin_addr.s_addr = psl->sl_addr[i];
-		if (copy_to_user(&optval->gf_slist[i], &ss, sizeof(ss)))
+		if (copy_to_user(p, &ss, sizeof(ss)))
 			return -EFAULT;
 	}
 	return 0;
-done:
-	return err;
 }
 
 /*
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 3c2c6cd3933b..e3703a3e7ef4 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1473,19 +1473,28 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	}
 	case MCAST_MSFILTER:
 	{
+		struct group_filter __user *p = (void __user *)optval;
 		struct group_filter gsf;
+		const int size0 = offsetof(struct group_filter, gf_slist);
+		int num;
 
-		if (len < GROUP_FILTER_SIZE(0)) {
+		if (len < size0) {
 			err = -EINVAL;
 			goto out;
 		}
-		if (copy_from_user(&gsf, optval, GROUP_FILTER_SIZE(0))) {
+		if (copy_from_user(&gsf, p, size0)) {
 			err = -EFAULT;
 			goto out;
 		}
-		err = ip_mc_gsfget(sk, &gsf,
-				   (struct group_filter __user *)optval,
-				   optlen);
+		num = gsf.gf_numsrc;
+		err = ip_mc_gsfget(sk, &gsf, p->gf_slist);
+		if (err)
+			goto out;
+		if (gsf.gf_numsrc < num)
+			num = gsf.gf_numsrc;
+		if (put_user(GROUP_FILTER_SIZE(num), optlen) ||
+		    copy_to_user(p, &gsf, size0))
+			err = -EFAULT;
 		goto out;
 	}
 	case IP_MULTICAST_ALL:
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 96e3f603c8d8..e4a62ca1a3d0 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -1056,18 +1056,28 @@ static int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
 		break;
 	case MCAST_MSFILTER:
 	{
+		struct group_filter __user *p = (void __user *)optval;
 		struct group_filter gsf;
+		const int size0 = offsetof(struct group_filter, gf_slist);
+		int num;
 		int err;
 
-		if (len < GROUP_FILTER_SIZE(0))
+		if (len < size0)
 			return -EINVAL;
-		if (copy_from_user(&gsf, optval, GROUP_FILTER_SIZE(0)))
+		if (copy_from_user(&gsf, p, size0))
 			return -EFAULT;
 		if (gsf.gf_group.ss_family != AF_INET6)
 			return -EADDRNOTAVAIL;
+		num = gsf.gf_numsrc;
 		lock_sock(sk);
-		err = ip6_mc_msfget(sk, &gsf,
-			(struct group_filter __user *)optval, optlen);
+		err = ip6_mc_msfget(sk, &gsf, p->gf_slist);
+		if (!err) {
+			if (num > gsf.gf_numsrc)
+				num = gsf.gf_numsrc;
+			if (put_user(GROUP_FILTER_SIZE(num), optlen) ||
+			    copy_to_user(p, &gsf, size0))
+				err = -EFAULT;
+		}
 		release_sock(sk);
 		return err;
 	}
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index eaa4c2cc2fbb..97d796c7d6c0 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -547,7 +547,7 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf)
 }
 
 int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
-	struct group_filter __user *optval, int __user *optlen)
+	struct sockaddr_storage *p)
 {
 	int err, i, count, copycount;
 	const struct in6_addr *group;
@@ -592,14 +592,10 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 
 	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
 	gsf->gf_numsrc = count;
-	if (put_user(GROUP_FILTER_SIZE(copycount), optlen) ||
-	    copy_to_user(optval, gsf, GROUP_FILTER_SIZE(0))) {
-		return -EFAULT;
-	}
 	/* changes to psl require the socket lock, and a write lock
 	 * on pmc->sflock. We have the socket lock so reading here is safe.
 	 */
-	for (i = 0; i < copycount; i++) {
+	for (i = 0; i < copycount; i++, p++) {
 		struct sockaddr_in6 *psin6;
 		struct sockaddr_storage ss;
 
@@ -607,7 +603,7 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 		memset(&ss, 0, sizeof(ss));
 		psin6->sin6_family = AF_INET6;
 		psin6->sin6_addr = psl->sl_addr[i];
-		if (copy_to_user(&optval->gf_slist[i], &ss, sizeof(ss)))
+		if (copy_to_user(p, &ss, sizeof(ss)))
 			return -EFAULT;
 	}
 	return 0;
-- 
2.11.0

