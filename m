Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6B722A772
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgGWGJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgGWGJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:09:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808EDC0619E2;
        Wed, 22 Jul 2020 23:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=QrqaYh4fSMgupA4iEFhXoiD4XEjtKBO+4D3VptAqYus=; b=IgVGLyqCozX/nHw3MIQ3FpanQV
        jLXIw5Td5nt6zIvvCqGUnFabfrveTd++UbO9scS2aRy/PoKQeztwbLyv6jvpJEEtyLYhY/m6rTBL6
        xKVVcTbM5bzajlkFK+OMU/FCH/VUQb3QOSfT60/o0JP8TjPIteycrNbr+PR78U+fooJ7APKnL+yYS
        LnZShKyk4tzuP+1iFVKpCOrQNDU1b9MW81GHnHJhLWwat6fM0aDFsEEbWZC8tBP1kpjEiRUmCTv9j
        fB/bPDia78CQ2+QlSJR5h2YA0Ym1SepAIfAmUqUk8+ueyWBGAtskROW4abUO80BOV+yb8+9iuyose
        7pSKeTKQ==;
Received: from [2001:4bb8:18c:2acc:91df:aae8:fa3b:de9c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyUQ9-0003n1-PK; Thu, 23 Jul 2020 06:09:34 +0000
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
Subject: [PATCH 17/26] net/ipv6: switch ip6_mroute_setsockopt to sockptr_t
Date:   Thu, 23 Jul 2020 08:08:59 +0200
Message-Id: <20200723060908.50081-18-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723060908.50081-1-hch@lst.de>
References: <20200723060908.50081-1-hch@lst.de>
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
 include/linux/mroute6.h  |  8 ++++----
 net/ipv6/ip6mr.c         | 17 +++++++++--------
 net/ipv6/ipv6_sockglue.c |  3 ++-
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/linux/mroute6.h b/include/linux/mroute6.h
index c4a45859f586d4..bc351a85ce9b9c 100644
--- a/include/linux/mroute6.h
+++ b/include/linux/mroute6.h
@@ -8,6 +8,7 @@
 #include <net/net_namespace.h>
 #include <uapi/linux/mroute6.h>
 #include <linux/mroute_base.h>
+#include <linux/sockptr.h>
 #include <net/fib_rules.h>
 
 #ifdef CONFIG_IPV6_MROUTE
@@ -25,7 +26,7 @@ static inline int ip6_mroute_opt(int opt)
 struct sock;
 
 #ifdef CONFIG_IPV6_MROUTE
-extern int ip6_mroute_setsockopt(struct sock *, int, char __user *, unsigned int);
+extern int ip6_mroute_setsockopt(struct sock *, int, sockptr_t, unsigned int);
 extern int ip6_mroute_getsockopt(struct sock *, int, char __user *, int __user *);
 extern int ip6_mr_input(struct sk_buff *skb);
 extern int ip6mr_ioctl(struct sock *sk, int cmd, void __user *arg);
@@ -33,9 +34,8 @@ extern int ip6mr_compat_ioctl(struct sock *sk, unsigned int cmd, void __user *ar
 extern int ip6_mr_init(void);
 extern void ip6_mr_cleanup(void);
 #else
-static inline
-int ip6_mroute_setsockopt(struct sock *sock,
-			  int optname, char __user *optval, unsigned int optlen)
+static inline int ip6_mroute_setsockopt(struct sock *sock, int optname,
+		sockptr_t optval, unsigned int optlen)
 {
 	return -ENOPROTOOPT;
 }
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 1f4d20e97c07f9..06b0d2c329b94b 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1629,7 +1629,8 @@ EXPORT_SYMBOL(mroute6_is_socket);
  *	MOSPF/PIM router set up we can clean this up.
  */
 
-int ip6_mroute_setsockopt(struct sock *sk, int optname, char __user *optval, unsigned int optlen)
+int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
+			  unsigned int optlen)
 {
 	int ret, parent = 0;
 	struct mif6ctl vif;
@@ -1665,7 +1666,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, char __user *optval, uns
 	case MRT6_ADD_MIF:
 		if (optlen < sizeof(vif))
 			return -EINVAL;
-		if (copy_from_user(&vif, optval, sizeof(vif)))
+		if (copy_from_sockptr(&vif, optval, sizeof(vif)))
 			return -EFAULT;
 		if (vif.mif6c_mifi >= MAXMIFS)
 			return -ENFILE;
@@ -1678,7 +1679,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, char __user *optval, uns
 	case MRT6_DEL_MIF:
 		if (optlen < sizeof(mifi_t))
 			return -EINVAL;
-		if (copy_from_user(&mifi, optval, sizeof(mifi_t)))
+		if (copy_from_sockptr(&mifi, optval, sizeof(mifi_t)))
 			return -EFAULT;
 		rtnl_lock();
 		ret = mif6_delete(mrt, mifi, 0, NULL);
@@ -1697,7 +1698,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, char __user *optval, uns
 	case MRT6_DEL_MFC_PROXY:
 		if (optlen < sizeof(mfc))
 			return -EINVAL;
-		if (copy_from_user(&mfc, optval, sizeof(mfc)))
+		if (copy_from_sockptr(&mfc, optval, sizeof(mfc)))
 			return -EFAULT;
 		if (parent == 0)
 			parent = mfc.mf6cc_parent;
@@ -1718,7 +1719,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, char __user *optval, uns
 
 		if (optlen != sizeof(flags))
 			return -EINVAL;
-		if (get_user(flags, (int __user *)optval))
+		if (copy_from_sockptr(&flags, optval, sizeof(flags)))
 			return -EFAULT;
 		rtnl_lock();
 		mroute_clean_tables(mrt, flags);
@@ -1735,7 +1736,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, char __user *optval, uns
 
 		if (optlen != sizeof(v))
 			return -EINVAL;
-		if (get_user(v, (int __user *)optval))
+		if (copy_from_sockptr(&v, optval, sizeof(v)))
 			return -EFAULT;
 		mrt->mroute_do_assert = v;
 		return 0;
@@ -1748,7 +1749,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, char __user *optval, uns
 
 		if (optlen != sizeof(v))
 			return -EINVAL;
-		if (get_user(v, (int __user *)optval))
+		if (copy_from_sockptr(&v, optval, sizeof(v)))
 			return -EFAULT;
 		v = !!v;
 		rtnl_lock();
@@ -1769,7 +1770,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, char __user *optval, uns
 
 		if (optlen != sizeof(u32))
 			return -EINVAL;
-		if (get_user(v, (u32 __user *)optval))
+		if (copy_from_sockptr(&v, optval, sizeof(v)))
 			return -EFAULT;
 		/* "pim6reg%u" should not exceed 16 bytes (IFNAMSIZ) */
 		if (v != RT_TABLE_DEFAULT && v >= 100000000)
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 85892b35cff7b3..119dfaf5f4bb26 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -337,7 +337,8 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 	valbool = (val != 0);
 
 	if (ip6_mroute_opt(optname))
-		return ip6_mroute_setsockopt(sk, optname, optval, optlen);
+		return ip6_mroute_setsockopt(sk, optname, USER_SOCKPTR(optval),
+					     optlen);
 
 	if (needs_rtnl)
 		rtnl_lock();
-- 
2.27.0

