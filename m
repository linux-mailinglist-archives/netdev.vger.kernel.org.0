Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781263E098E
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 22:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241030AbhHDUnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 16:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240980AbhHDUnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 16:43:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DF2D60F10;
        Wed,  4 Aug 2021 20:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628109776;
        bh=V8FQrr/pOQD/jpb+JD9qUKf1+X451XE2zUJ4yVXzaaM=;
        h=Date:From:To:Cc:Subject:From;
        b=eTDPxngbu35dnjX3TnsltuccH+12lNGgbsOEMTdB0lm5JFQJnB3WW6crFfBbq1eWP
         sjjKNbWzItWyHXbh6CU+E2BEHkwPBPjjCG1hoJmPbNZU189YpDAeKxrh569gfiXdv/
         nCeZ1350MJjLM+A6glVxI0VQIiuWf91pGmbyphW5rqTqjVyDegC+hPXaWXpy6oMjXZ
         7lCNgHGKThq0OFwi5GyXjh6hWAlv6YHuxpJgB90Z9oPWC2sg+eS0GixP23AtGfbWmu
         gn20fOj/CeqQ9aUqyVnZW2ld/jNA2mbyfCKAguBxCiMhTnJ18fYuTR5sAOgoZJm65s
         /13N8Cv2RM/pA==
Date:   Wed, 4 Aug 2021 15:45:36 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net/ipv4/ipv6: Replace one-element arraya with
 flexible-array members
Message-ID: <20210804204536.GA22727@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Use an anonymous union with a couple of anonymous structs in order to
keep userspace unchanged and refactor the related code accordingly:

$ pahole -C group_filter net/ipv4/ip_sockglue.o
struct group_filter {
	union {
		struct {
			__u32      gf_interface_aux;     /*     0     4 */

			/* XXX 4 bytes hole, try to pack */

			struct __kernel_sockaddr_storage gf_group_aux; /*     8   128 */
			/* --- cacheline 2 boundary (128 bytes) was 8 bytes ago --- */
			__u32      gf_fmode_aux;         /*   136     4 */
			__u32      gf_numsrc_aux;        /*   140     4 */
			struct __kernel_sockaddr_storage gf_slist[1]; /*   144   128 */
		};                                       /*     0   272 */
		struct {
			__u32      gf_interface;         /*     0     4 */

			/* XXX 4 bytes hole, try to pack */

			struct __kernel_sockaddr_storage gf_group; /*     8   128 */
			/* --- cacheline 2 boundary (128 bytes) was 8 bytes ago --- */
			__u32      gf_fmode;             /*   136     4 */
			__u32      gf_numsrc;            /*   140     4 */
			struct __kernel_sockaddr_storage gf_slist_flex[0]; /*   144     0 */
		};                                       /*     0   144 */
	};                                               /*     0   272 */

	/* size: 272, cachelines: 5, members: 1 */
	/* last cacheline: 16 bytes */
};

$ pahole -C compat_group_filter net/ipv4/ip_sockglue.o
struct compat_group_filter {
	union {
		struct {
			__u32      gf_interface_aux;     /*     0     4 */
			struct __kernel_sockaddr_storage gf_group_aux __attribute__((__aligned__(4))); /*     4   128 */
			/* --- cacheline 2 boundary (128 bytes) was 4 bytes ago --- */
			__u32      gf_fmode_aux;         /*   132     4 */
			__u32      gf_numsrc_aux;        /*   136     4 */
			struct __kernel_sockaddr_storage gf_slist[1] __attribute__((__aligned__(4))); /*   140   128 */
		} __attribute__((__packed__)) __attribute__((__aligned__(4)));                     /*     0   268 */
		struct {
			__u32      gf_interface;         /*     0     4 */
			struct __kernel_sockaddr_storage gf_group __attribute__((__aligned__(4))); /*     4   128 */
			/* --- cacheline 2 boundary (128 bytes) was 4 bytes ago --- */
			__u32      gf_fmode;             /*   132     4 */
			__u32      gf_numsrc;            /*   136     4 */
			struct __kernel_sockaddr_storage gf_slist_flex[0] __attribute__((__aligned__(4))); /*   140     0 */
		} __attribute__((__packed__)) __attribute__((__aligned__(4)));                     /*     0   140 */
	} __attribute__((__aligned__(1)));               /*     0   268 */

	/* size: 268, cachelines: 5, members: 1 */
	/* forced alignments: 1 */
	/* last cacheline: 12 bytes */
} __attribute__((__packed__));

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 include/net/compat.h     | 27 ++++++++++++++++++++-------
 include/uapi/linux/in.h  | 21 ++++++++++++++++-----
 net/ipv4/ip_sockglue.c   | 19 ++++++++++---------
 net/ipv6/ipv6_sockglue.c | 18 +++++++++---------
 4 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/include/net/compat.h b/include/net/compat.h
index 84805bdc4435..595fee069b82 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -71,13 +71,26 @@ struct compat_group_source_req {
 } __packed;
 
 struct compat_group_filter {
-	__u32				 gf_interface;
-	struct __kernel_sockaddr_storage gf_group
-		__aligned(4);
-	__u32				 gf_fmode;
-	__u32				 gf_numsrc;
-	struct __kernel_sockaddr_storage gf_slist[1]
-		__aligned(4);
+	union {
+		struct {
+			__u32				 gf_interface_aux;
+			struct __kernel_sockaddr_storage gf_group_aux
+				__aligned(4);
+			__u32				 gf_fmode_aux;
+			__u32				 gf_numsrc_aux;
+			struct __kernel_sockaddr_storage gf_slist[1]
+				__aligned(4);
+		} __packed;
+		struct {
+			__u32				 gf_interface;
+			struct __kernel_sockaddr_storage gf_group
+				__aligned(4);
+			__u32				 gf_fmode;
+			__u32				 gf_numsrc;
+			struct __kernel_sockaddr_storage gf_slist_flex[]
+				__aligned(4);
+		} __packed;
+	};
 } __packed;
 
 #endif /* NET_COMPAT_H */
diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index d1b327036ae4..d8bd07215770 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -211,11 +211,22 @@ struct group_source_req {
 };
 
 struct group_filter {
-	__u32				 gf_interface;	/* interface index */
-	struct __kernel_sockaddr_storage gf_group;	/* multicast address */
-	__u32				 gf_fmode;	/* filter mode */
-	__u32				 gf_numsrc;	/* number of sources */
-	struct __kernel_sockaddr_storage gf_slist[1];	/* interface index */
+	union {
+		struct {
+			__u32				 gf_interface_aux; /* interface index */
+			struct __kernel_sockaddr_storage gf_group_aux;	   /* multicast address */
+			__u32				 gf_fmode_aux;	   /* filter mode */
+			__u32				 gf_numsrc_aux;	   /* number of sources */
+			struct __kernel_sockaddr_storage gf_slist[1];	   /* interface index */
+		};
+		struct {
+			__u32				 gf_interface;	  /* interface index */
+			struct __kernel_sockaddr_storage gf_group;	  /* multicast address */
+			__u32				 gf_fmode;	  /* filter mode */
+			__u32				 gf_numsrc;	  /* number of sources */
+			struct __kernel_sockaddr_storage gf_slist_flex[]; /* interface index */
+		};
+	};
 };
 
 #define GROUP_FILTER_SIZE(numsrc) \
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index ec6036713e2c..6ac6e4aec29f 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -791,7 +791,8 @@ static int ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval, int optlen)
 		goto out_free_gsf;
 
 	err = set_mcast_msfilter(sk, gsf->gf_interface, gsf->gf_numsrc,
-				 gsf->gf_fmode, &gsf->gf_group, gsf->gf_slist);
+				 gsf->gf_fmode, &gsf->gf_group,
+				 gsf->gf_slist_flex);
 out_free_gsf:
 	kfree(gsf);
 	return err;
@@ -800,7 +801,7 @@ static int ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval, int optlen)
 static int compat_ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 		int optlen)
 {
-	const int size0 = offsetof(struct compat_group_filter, gf_slist);
+	const int size0 = offsetof(struct compat_group_filter, gf_slist_flex);
 	struct compat_group_filter *gf32;
 	unsigned int n;
 	void *p;
@@ -814,7 +815,7 @@ static int compat_ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 	p = kmalloc(optlen + 4, GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
-	gf32 = p + 4; /* we want ->gf_group and ->gf_slist aligned */
+	gf32 = p + 4; /* we want ->gf_group and ->gf_slist_flex aligned */
 
 	err = -EFAULT;
 	if (copy_from_sockptr(gf32, optval, optlen))
@@ -827,7 +828,7 @@ static int compat_ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 		goto out_free_gsf;
 
 	err = -EINVAL;
-	if (offsetof(struct compat_group_filter, gf_slist[n]) > optlen)
+	if (offsetof(struct compat_group_filter, gf_slist_flex[n]) > optlen)
 		goto out_free_gsf;
 
 	/* numsrc >= (4G-140)/128 overflow in 32 bits */
@@ -835,7 +836,7 @@ static int compat_ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 	if (n > sock_net(sk)->ipv4.sysctl_igmp_max_msf)
 		goto out_free_gsf;
 	err = set_mcast_msfilter(sk, gf32->gf_interface, n, gf32->gf_fmode,
-				 &gf32->gf_group, gf32->gf_slist);
+				 &gf32->gf_group, gf32->gf_slist_flex);
 out_free_gsf:
 	kfree(p);
 	return err;
@@ -1456,7 +1457,7 @@ static bool getsockopt_needs_rtnl(int optname)
 static int ip_get_mcast_msfilter(struct sock *sk, void __user *optval,
 		int __user *optlen, int len)
 {
-	const int size0 = offsetof(struct group_filter, gf_slist);
+	const int size0 = offsetof(struct group_filter, gf_slist_flex);
 	struct group_filter __user *p = optval;
 	struct group_filter gsf;
 	int num;
@@ -1468,7 +1469,7 @@ static int ip_get_mcast_msfilter(struct sock *sk, void __user *optval,
 		return -EFAULT;
 
 	num = gsf.gf_numsrc;
-	err = ip_mc_gsfget(sk, &gsf, p->gf_slist);
+	err = ip_mc_gsfget(sk, &gsf, p->gf_slist_flex);
 	if (err)
 		return err;
 	if (gsf.gf_numsrc < num)
@@ -1482,7 +1483,7 @@ static int ip_get_mcast_msfilter(struct sock *sk, void __user *optval,
 static int compat_ip_get_mcast_msfilter(struct sock *sk, void __user *optval,
 		int __user *optlen, int len)
 {
-	const int size0 = offsetof(struct compat_group_filter, gf_slist);
+	const int size0 = offsetof(struct compat_group_filter, gf_slist_flex);
 	struct compat_group_filter __user *p = optval;
 	struct compat_group_filter gf32;
 	struct group_filter gf;
@@ -1499,7 +1500,7 @@ static int compat_ip_get_mcast_msfilter(struct sock *sk, void __user *optval,
 	num = gf.gf_numsrc = gf32.gf_numsrc;
 	gf.gf_group = gf32.gf_group;
 
-	err = ip_mc_gsfget(sk, &gf, p->gf_slist);
+	err = ip_mc_gsfget(sk, &gf, p->gf_slist_flex);
 	if (err)
 		return err;
 	if (gf.gf_numsrc < num)
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index a6804a7e34c1..e4bdb09c5586 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -225,7 +225,7 @@ static int ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 	if (GROUP_FILTER_SIZE(gsf->gf_numsrc) > optlen)
 		goto out_free_gsf;
 
-	ret = ip6_mc_msfilter(sk, gsf, gsf->gf_slist);
+	ret = ip6_mc_msfilter(sk, gsf, gsf->gf_slist_flex);
 out_free_gsf:
 	kfree(gsf);
 	return ret;
@@ -234,7 +234,7 @@ static int ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 static int compat_ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 		int optlen)
 {
-	const int size0 = offsetof(struct compat_group_filter, gf_slist);
+	const int size0 = offsetof(struct compat_group_filter, gf_slist_flex);
 	struct compat_group_filter *gf32;
 	void *p;
 	int ret;
@@ -249,7 +249,7 @@ static int compat_ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 	if (!p)
 		return -ENOMEM;
 
-	gf32 = p + 4; /* we want ->gf_group and ->gf_slist aligned */
+	gf32 = p + 4; /* we want ->gf_group and ->gf_slist_flex aligned */
 	ret = -EFAULT;
 	if (copy_from_sockptr(gf32, optval, optlen))
 		goto out_free_p;
@@ -261,14 +261,14 @@ static int compat_ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 		goto out_free_p;
 
 	ret = -EINVAL;
-	if (offsetof(struct compat_group_filter, gf_slist[n]) > optlen)
+	if (offsetof(struct compat_group_filter, gf_slist_flex[n]) > optlen)
 		goto out_free_p;
 
 	ret = ip6_mc_msfilter(sk, &(struct group_filter){
 			.gf_interface = gf32->gf_interface,
 			.gf_group = gf32->gf_group,
 			.gf_fmode = gf32->gf_fmode,
-			.gf_numsrc = gf32->gf_numsrc}, gf32->gf_slist);
+			.gf_numsrc = gf32->gf_numsrc}, gf32->gf_slist_flex);
 
 out_free_p:
 	kfree(p);
@@ -1048,7 +1048,7 @@ static int ipv6_getsockopt_sticky(struct sock *sk, struct ipv6_txoptions *opt,
 static int ipv6_get_msfilter(struct sock *sk, void __user *optval,
 		int __user *optlen, int len)
 {
-	const int size0 = offsetof(struct group_filter, gf_slist);
+	const int size0 = offsetof(struct group_filter, gf_slist_flex);
 	struct group_filter __user *p = optval;
 	struct group_filter gsf;
 	int num;
@@ -1062,7 +1062,7 @@ static int ipv6_get_msfilter(struct sock *sk, void __user *optval,
 		return -EADDRNOTAVAIL;
 	num = gsf.gf_numsrc;
 	lock_sock(sk);
-	err = ip6_mc_msfget(sk, &gsf, p->gf_slist);
+	err = ip6_mc_msfget(sk, &gsf, p->gf_slist_flex);
 	if (!err) {
 		if (num > gsf.gf_numsrc)
 			num = gsf.gf_numsrc;
@@ -1077,7 +1077,7 @@ static int ipv6_get_msfilter(struct sock *sk, void __user *optval,
 static int compat_ipv6_get_msfilter(struct sock *sk, void __user *optval,
 		int __user *optlen)
 {
-	const int size0 = offsetof(struct compat_group_filter, gf_slist);
+	const int size0 = offsetof(struct compat_group_filter, gf_slist_flex);
 	struct compat_group_filter __user *p = optval;
 	struct compat_group_filter gf32;
 	struct group_filter gf;
@@ -1100,7 +1100,7 @@ static int compat_ipv6_get_msfilter(struct sock *sk, void __user *optval,
 		return -EADDRNOTAVAIL;
 
 	lock_sock(sk);
-	err = ip6_mc_msfget(sk, &gf, p->gf_slist);
+	err = ip6_mc_msfget(sk, &gf, p->gf_slist_flex);
 	release_sock(sk);
 	if (err)
 		return err;
-- 
2.27.0

