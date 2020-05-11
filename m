Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DA01CD10B
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 06:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgEKEr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 00:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727876AbgEKEpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 00:45:55 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25CCC061A0E;
        Sun, 10 May 2020 21:45:55 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY0KA-005jHj-43; Mon, 11 May 2020 04:45:54 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/19] get rid of compat_mc_getsockopt()
Date:   Mon, 11 May 2020 05:45:38 +0100
Message-Id: <20200511044553.1365660-4-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200511044553.1365660-1-viro@ZenIV.linux.org.uk>
References: <20200511044328.GP23230@ZenIV.linux.org.uk>
 <20200511044553.1365660-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

now we can do MCAST_MSFILTER in compat ->getsockopt() without
playing silly buggers with copying things back and forth.
We can form a native struct group_filter (sans the variable-length
tail) on stack, pass that + pointer to the tail of original request
to the helper doing the bulk of the work, then do the rest of
copyout - same as the native getsockopt() does.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/net/compat.h     |  3 --
 net/compat.c             | 79 ------------------------------------------------
 net/ipv4/ip_sockglue.c   | 44 +++++++++++++++++++++++++--
 net/ipv6/ipv6_sockglue.c | 41 +++++++++++++++++++++++--
 4 files changed, 79 insertions(+), 88 deletions(-)

diff --git a/include/net/compat.h b/include/net/compat.h
index 9f4a56c5671e..b6043e759cde 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -52,9 +52,6 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *, struct sock *,
 int compat_mc_setsockopt(struct sock *, int, int, char __user *, unsigned int,
 			 int (*)(struct sock *, int, int, char __user *,
 				 unsigned int));
-int compat_mc_getsockopt(struct sock *, int, int, char __user *, int __user *,
-			 int (*)(struct sock *, int, int, char __user *,
-				 int __user *));
 
 struct compat_group_req {
 	__u32				 gr_interface;
diff --git a/net/compat.c b/net/compat.c
index 06af69e7b408..6191481b5ef0 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -537,85 +537,6 @@ int compat_mc_setsockopt(struct sock *sock, int level, int optname,
 }
 EXPORT_SYMBOL(compat_mc_setsockopt);
 
-int compat_mc_getsockopt(struct sock *sock, int level, int optname,
-	char __user *optval, int __user *optlen,
-	int (*getsockopt)(struct sock *, int, int, char __user *, int __user *))
-{
-	struct compat_group_filter __user *gf32 = (void __user *)optval;
-	struct group_filter __user *kgf;
-	int __user	*koptlen;
-	u32 interface, fmode, numsrc;
-	int klen, ulen, err;
-
-	if (optname != MCAST_MSFILTER)
-		return getsockopt(sock, level, optname, optval, optlen);
-
-	koptlen = compat_alloc_user_space(sizeof(*koptlen));
-	if (!access_ok(optlen, sizeof(*optlen)) ||
-	    __get_user(ulen, optlen))
-		return -EFAULT;
-
-	/* adjust len for pad */
-	klen = ulen + sizeof(*kgf) - sizeof(*gf32);
-
-	if (klen < GROUP_FILTER_SIZE(0))
-		return -EINVAL;
-
-	if (!access_ok(koptlen, sizeof(*koptlen)) ||
-	    __put_user(klen, koptlen))
-		return -EFAULT;
-
-	/* have to allow space for previous compat_alloc_user_space, too */
-	kgf = compat_alloc_user_space(klen+sizeof(*optlen));
-
-	if (!access_ok(gf32, __COMPAT_GF0_SIZE) ||
-	    __get_user(interface, &gf32->gf_interface) ||
-	    __get_user(fmode, &gf32->gf_fmode) ||
-	    __get_user(numsrc, &gf32->gf_numsrc) ||
-	    __put_user(interface, &kgf->gf_interface) ||
-	    __put_user(fmode, &kgf->gf_fmode) ||
-	    __put_user(numsrc, &kgf->gf_numsrc) ||
-	    copy_in_user(&kgf->gf_group, &gf32->gf_group, sizeof(kgf->gf_group)))
-		return -EFAULT;
-
-	err = getsockopt(sock, level, optname, (char __user *)kgf, koptlen);
-	if (err)
-		return err;
-
-	if (!access_ok(koptlen, sizeof(*koptlen)) ||
-	    __get_user(klen, koptlen))
-		return -EFAULT;
-
-	ulen = klen - (sizeof(*kgf)-sizeof(*gf32));
-
-	if (!access_ok(optlen, sizeof(*optlen)) ||
-	    __put_user(ulen, optlen))
-		return -EFAULT;
-
-	if (!access_ok(kgf, klen) ||
-	    !access_ok(gf32, ulen) ||
-	    __get_user(interface, &kgf->gf_interface) ||
-	    __get_user(fmode, &kgf->gf_fmode) ||
-	    __get_user(numsrc, &kgf->gf_numsrc) ||
-	    __put_user(interface, &gf32->gf_interface) ||
-	    __put_user(fmode, &gf32->gf_fmode) ||
-	    __put_user(numsrc, &gf32->gf_numsrc))
-		return -EFAULT;
-	if (numsrc) {
-		int copylen;
-
-		klen -= GROUP_FILTER_SIZE(0);
-		copylen = numsrc * sizeof(gf32->gf_slist[0]);
-		if (copylen > klen)
-			copylen = klen;
-		if (copy_in_user(gf32->gf_slist, kgf->gf_slist, copylen))
-			return -EFAULT;
-	}
-	return err;
-}
-EXPORT_SYMBOL(compat_mc_getsockopt);
-
-
 /* Argument list sizes for compat_sys_socketcall */
 #define AL(x) ((x) * sizeof(u32))
 static unsigned char nas[21] = {
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 8616c38bd420..6bdaf43236ea 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1606,9 +1606,47 @@ int compat_ip_getsockopt(struct sock *sk, int level, int optname,
 {
 	int err;
 
-	if (optname == MCAST_MSFILTER)
-		return compat_mc_getsockopt(sk, level, optname, optval, optlen,
-			ip_getsockopt);
+	if (optname == MCAST_MSFILTER) {
+		const int size0 = offsetof(struct compat_group_filter, gf_slist);
+		struct compat_group_filter __user *p = (void __user *)optval;
+		struct compat_group_filter gf32;
+		struct group_filter gf;
+		int ulen, err;
+		int num;
+
+		if (level != SOL_IP)
+			return -EOPNOTSUPP;
+
+		if (get_user(ulen, optlen))
+			return -EFAULT;
+
+		if (ulen < size0)
+			return -EINVAL;
+
+		if (copy_from_user(&gf32, p, size0))
+			return -EFAULT;
+
+		gf.gf_interface = gf32.gf_interface;
+		gf.gf_fmode = gf32.gf_fmode;
+		num = gf.gf_numsrc = gf32.gf_numsrc;
+		gf.gf_group = gf32.gf_group;
+
+		rtnl_lock();
+		lock_sock(sk);
+		err = ip_mc_gsfget(sk, &gf, p->gf_slist);
+		release_sock(sk);
+		rtnl_unlock();
+		if (err)
+			return err;
+		if (gf.gf_numsrc < num)
+			num = gf.gf_numsrc;
+		ulen = GROUP_FILTER_SIZE(num) - (sizeof(gf) - sizeof(gf32));
+		if (put_user(ulen, optlen) ||
+		    put_user(gf.gf_fmode, &p->gf_fmode) ||
+		    put_user(gf.gf_numsrc, &p->gf_numsrc))
+			return -EFAULT;
+		return 0;
+	}
 
 	err = do_ip_getsockopt(sk, level, optname, optval, optlen,
 		MSG_CMSG_COMPAT);
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 6441e824b63b..3f127c6b3c22 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -1445,9 +1445,44 @@ int compat_ipv6_getsockopt(struct sock *sk, int level, int optname,
 	if (level != SOL_IPV6)
 		return -ENOPROTOOPT;
 
-	if (optname == MCAST_MSFILTER)
-		return compat_mc_getsockopt(sk, level, optname, optval, optlen,
-			ipv6_getsockopt);
+	if (optname == MCAST_MSFILTER) {
+		const int size0 = offsetof(struct compat_group_filter, gf_slist);
+		struct compat_group_filter __user *p = (void __user *)optval;
+		struct compat_group_filter gf32;
+		struct group_filter gf;
+		int ulen, err;
+		int num;
+
+		if (get_user(ulen, optlen))
+			return -EFAULT;
+
+		if (ulen < size0)
+			return -EINVAL;
+
+		if (copy_from_user(&gf32, p, size0))
+			return -EFAULT;
+
+		gf.gf_interface = gf32.gf_interface;
+		gf.gf_fmode = gf32.gf_fmode;
+		num = gf.gf_numsrc = gf32.gf_numsrc;
+		gf.gf_group = gf32.gf_group;
+
+		if (gf.gf_group.ss_family != AF_INET6)
+			return -EADDRNOTAVAIL;
+		lock_sock(sk);
+		err = ip6_mc_msfget(sk, &gf, p->gf_slist);
+		release_sock(sk);
+		if (err)
+			return err;
+		if (num > gf.gf_numsrc)
+			num = gf.gf_numsrc;
+		ulen = GROUP_FILTER_SIZE(num) - (sizeof(gf)-sizeof(gf32));
+		if (put_user(ulen, optlen) ||
+		    put_user(gf.gf_fmode, &p->gf_fmode) ||
+		    put_user(gf.gf_numsrc, &p->gf_numsrc))
+			return -EFAULT;
+		return 0;
+	}
 
 	err = do_ipv6_getsockopt(sk, level, optname, optval, optlen,
 				 MSG_CMSG_COMPAT);
-- 
2.11.0

