Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6624E3E0774
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 20:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbhHDSVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 14:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238755AbhHDSU6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 14:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30A3A60F94;
        Wed,  4 Aug 2021 18:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628101245;
        bh=7e9VthFDgj2TLGdYUTdWlqA7YJoPwfJ6cIu1tk2mhkU=;
        h=Date:From:To:Cc:Subject:From;
        b=UG6KL8imFGrl/yQtt+/Yb9Bk+RGlr1K9H/xsQgVXUaLdjo4Jxlj8RAzAuBJ6bRFLO
         eleu/UP7iywxcQ8yAtPNFfUy1UYiXDzd8Wm9szr8FlxJ6MKqc2JhVw+H3ioKa002IP
         GTqFwwuZHIlFPho5VV/QllPon+vh8zHkF0Uk4M/2yfslaKVEZ2TRYVQQRJu8f1QeZC
         FYrEwQWxBFluiGEZKURPeKylVDncpmJBXiw3HxAHJWoZOK5UYmMakwed4bU8eYaGwY
         9TIihRFPa2aNIakr8+5n1qpN+kCKvSkeT3OmEUFesO94u9Sp2iAH67hgkbNSQUXEW+
         oPTPBDEiZesWw==
Date:   Wed, 4 Aug 2021 13:23:25 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net/ipv4: Revert use of struct_size() helper
Message-ID: <20210804182325.GA11752@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revert the use of structr_size() and stay with IP_MSFILTER_SIZE() for
now, as in this case, the size of struct ip_msfilter didn't change with
the addition of the flexible array imsf_slist_flex[]. So, if we use
struct_size() we will be allocating and calculating the size of
struct ip_msfilter with one too many items for imsf_slist_flex[].

We might use struct_size() in the future, but for now let's stay
with IP_MSFILTER_SIZE().

Fixes: 	2d3e5caf96b9 ("net/ipv4: Replace one-element array with flexible-array member")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/ipv4/igmp.c        |  4 ++--
 net/ipv4/ip_sockglue.c | 12 +++++-------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index a5f4ecb02e97..c2d477eb6825 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2553,8 +2553,8 @@ int ip_mc_msfget(struct sock *sk, struct ip_msfilter *msf,
 	copycount = count < msf->imsf_numsrc ? count : msf->imsf_numsrc;
 	len = flex_array_size(psl, sl_addr, copycount);
 	msf->imsf_numsrc = count;
-	if (put_user(struct_size(optval, imsf_slist_flex, copycount), optlen) ||
-	    copy_to_user(optval, msf, struct_size(optval, imsf_slist_flex, 0))) {
+	if (put_user(IP_MSFILTER_SIZE(copycount), optlen) ||
+	    copy_to_user(optval, msf, IP_MSFILTER_SIZE(0))) {
 		return -EFAULT;
 	}
 	if (len &&
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index bbe660b84a91..468969c75708 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -667,7 +667,7 @@ static int set_mcast_msfilter(struct sock *sk, int ifindex,
 	struct sockaddr_in *psin;
 	int err, i;
 
-	msf = kmalloc(struct_size(msf, imsf_slist_flex, numsrc), GFP_KERNEL);
+	msf = kmalloc(IP_MSFILTER_SIZE(numsrc), GFP_KERNEL);
 	if (!msf)
 		return -ENOBUFS;
 
@@ -1228,7 +1228,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 	{
 		struct ip_msfilter *msf;
 
-		if (optlen < struct_size(msf, imsf_slist_flex, 0))
+		if (optlen < IP_MSFILTER_SIZE(0))
 			goto e_inval;
 		if (optlen > sysctl_optmem_max) {
 			err = -ENOBUFS;
@@ -1246,8 +1246,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 			err = -ENOBUFS;
 			break;
 		}
-		if (struct_size(msf, imsf_slist_flex, msf->imsf_numsrc) >
-		    optlen) {
+		if (IP_MSFILTER_SIZE(msf->imsf_numsrc) > optlen) {
 			kfree(msf);
 			err = -EINVAL;
 			break;
@@ -1660,12 +1659,11 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	{
 		struct ip_msfilter msf;
 
-		if (len < struct_size(&msf, imsf_slist_flex, 0)) {
+		if (len < IP_MSFILTER_SIZE(0)) {
 			err = -EINVAL;
 			goto out;
 		}
-		if (copy_from_user(&msf, optval,
-				   struct_size(&msf, imsf_slist_flex, 0))) {
+		if (copy_from_user(&msf, optval, IP_MSFILTER_SIZE(0))) {
 			err = -EFAULT;
 			goto out;
 		}
-- 
2.27.0

