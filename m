Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2AC3DC712
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhGaRGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 13:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhGaRGC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 13:06:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04263600CC;
        Sat, 31 Jul 2021 17:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627751155;
        bh=Ocj+hjomQZVskSA44UN2nQzT4hs/eVLY9vWEHfHjgDE=;
        h=Date:From:To:Cc:Subject:From;
        b=XsS6iIVMDkNmYrNLjsWHH7pA07i4UN8viVVu0ZSsTEx+1Ua9Q3/+5z3lr91wl7WKE
         GvV51ziCxvT3nBLLS5O9KXnr4TRCu0FsD/LFWJjg7gUaF8R9A/OAGOGJM3h1K9zKgI
         gRArS5jE7+BdERhdJtoKKmd9qjEkT5rMmZSP2plqX2tUTm5y8TtHYMz3LHC5cuxoAm
         cgo0h9jlGzwg/knwp6SdsWabmjqmTX6osWmaoAGPpL3naiOroHVcus7FPmVFJ85NWd
         s8HOAucJip3fB7qBBnYYwitNzshK9uoC4xC3Vu8HFSH1dZTAglK77ajrElD1qqFo1v
         8UU879DDXPWcA==
Date:   Sat, 31 Jul 2021 12:08:30 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net/ipv4: Replace one-element array with
 flexible-array member
Message-ID: <20210731170830.GA48844@embeddedor>
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
keep userspace unchanged:

$ pahole -C ip_msfilter net/ipv4/ip_sockglue.o
struct ip_msfilter {
	union {
		struct {
			__be32     imsf_multiaddr_aux;   /*     0     4 */
			__be32     imsf_interface_aux;   /*     4     4 */
			__u32      imsf_fmode_aux;       /*     8     4 */
			__u32      imsf_numsrc_aux;      /*    12     4 */
			__be32     imsf_slist[1];        /*    16     4 */
		};                                       /*     0    20 */
		struct {
			__be32     imsf_multiaddr;       /*     0     4 */
			__be32     imsf_interface;       /*     4     4 */
			__u32      imsf_fmode;           /*     8     4 */
			__u32      imsf_numsrc;          /*    12     4 */
			__be32     imsf_slist_flex[0];   /*    16     0 */
		};                                       /*     0    16 */
	};                                               /*     0    20 */

	/* size: 20, cachelines: 1, members: 1 */
	/* last cacheline: 20 bytes */
};

Also, refactor the code accordingly and make use of the struct_size()
and flex_array_size() helpers.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 include/uapi/linux/in.h | 21 ++++++++++++++++-----
 net/ipv4/igmp.c         | 12 ++++++------
 net/ipv4/ip_sockglue.c  | 15 ++++++++-------
 3 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index d1b327036ae4..193b7cf1f0ac 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -188,11 +188,22 @@ struct ip_mreq_source {
 };
 
 struct ip_msfilter {
-	__be32		imsf_multiaddr;
-	__be32		imsf_interface;
-	__u32		imsf_fmode;
-	__u32		imsf_numsrc;
-	__be32		imsf_slist[1];
+	union {
+		struct {
+			__be32		imsf_multiaddr_aux;
+			__be32		imsf_interface_aux;
+			__u32		imsf_fmode_aux;
+			__u32		imsf_numsrc_aux;
+			__be32		imsf_slist[1];
+		};
+		struct {
+			__be32		imsf_multiaddr;
+			__be32		imsf_interface;
+			__u32		imsf_fmode;
+			__u32		imsf_numsrc;
+			__be32		imsf_slist_flex[];
+		};
+	};
 };
 
 #define IP_MSFILTER_SIZE(numsrc) \
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 03589a04f9aa..a5f4ecb02e97 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2475,8 +2475,8 @@ int ip_mc_msfilter(struct sock *sk, struct ip_msfilter *msf, int ifindex)
 			goto done;
 		}
 		newpsl->sl_max = newpsl->sl_count = msf->imsf_numsrc;
-		memcpy(newpsl->sl_addr, msf->imsf_slist,
-			msf->imsf_numsrc * sizeof(msf->imsf_slist[0]));
+		memcpy(newpsl->sl_addr, msf->imsf_slist_flex,
+		       flex_array_size(msf, imsf_slist_flex, msf->imsf_numsrc));
 		err = ip_mc_add_src(in_dev, &msf->imsf_multiaddr,
 			msf->imsf_fmode, newpsl->sl_count, newpsl->sl_addr, 0);
 		if (err) {
@@ -2551,14 +2551,14 @@ int ip_mc_msfget(struct sock *sk, struct ip_msfilter *msf,
 		count = psl->sl_count;
 	}
 	copycount = count < msf->imsf_numsrc ? count : msf->imsf_numsrc;
-	len = copycount * sizeof(psl->sl_addr[0]);
+	len = flex_array_size(psl, sl_addr, copycount);
 	msf->imsf_numsrc = count;
-	if (put_user(IP_MSFILTER_SIZE(copycount), optlen) ||
-	    copy_to_user(optval, msf, IP_MSFILTER_SIZE(0))) {
+	if (put_user(struct_size(optval, imsf_slist_flex, copycount), optlen) ||
+	    copy_to_user(optval, msf, struct_size(optval, imsf_slist_flex, 0))) {
 		return -EFAULT;
 	}
 	if (len &&
-	    copy_to_user(&optval->imsf_slist[0], psl->sl_addr, len))
+	    copy_to_user(&optval->imsf_slist_flex[0], psl->sl_addr, len))
 		return -EFAULT;
 	return 0;
 done:
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index ec6036713e2c..bbe660b84a91 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -663,12 +663,11 @@ static int set_mcast_msfilter(struct sock *sk, int ifindex,
 			      struct sockaddr_storage *group,
 			      struct sockaddr_storage *list)
 {
-	int msize = IP_MSFILTER_SIZE(numsrc);
 	struct ip_msfilter *msf;
 	struct sockaddr_in *psin;
 	int err, i;
 
-	msf = kmalloc(msize, GFP_KERNEL);
+	msf = kmalloc(struct_size(msf, imsf_slist_flex, numsrc), GFP_KERNEL);
 	if (!msf)
 		return -ENOBUFS;
 
@@ -684,7 +683,7 @@ static int set_mcast_msfilter(struct sock *sk, int ifindex,
 
 		if (psin->sin_family != AF_INET)
 			goto Eaddrnotavail;
-		msf->imsf_slist[i] = psin->sin_addr.s_addr;
+		msf->imsf_slist_flex[i] = psin->sin_addr.s_addr;
 	}
 	err = ip_mc_msfilter(sk, msf, ifindex);
 	kfree(msf);
@@ -1229,7 +1228,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 	{
 		struct ip_msfilter *msf;
 
-		if (optlen < IP_MSFILTER_SIZE(0))
+		if (optlen < struct_size(msf, imsf_slist_flex, 0))
 			goto e_inval;
 		if (optlen > sysctl_optmem_max) {
 			err = -ENOBUFS;
@@ -1247,7 +1246,8 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 			err = -ENOBUFS;
 			break;
 		}
-		if (IP_MSFILTER_SIZE(msf->imsf_numsrc) > optlen) {
+		if (struct_size(msf, imsf_slist_flex, msf->imsf_numsrc) >
+		    optlen) {
 			kfree(msf);
 			err = -EINVAL;
 			break;
@@ -1660,11 +1660,12 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	{
 		struct ip_msfilter msf;
 
-		if (len < IP_MSFILTER_SIZE(0)) {
+		if (len < struct_size(&msf, imsf_slist_flex, 0)) {
 			err = -EINVAL;
 			goto out;
 		}
-		if (copy_from_user(&msf, optval, IP_MSFILTER_SIZE(0))) {
+		if (copy_from_user(&msf, optval,
+				   struct_size(&msf, imsf_slist_flex, 0))) {
 			err = -EFAULT;
 			goto out;
 		}
-- 
2.27.0

