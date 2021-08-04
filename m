Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E123E0A11
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 23:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhHDVl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 17:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231893AbhHDVlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 17:41:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BE7360C3F;
        Wed,  4 Aug 2021 21:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628113272;
        bh=19rsvQG9EMQz8ZhU8YsqRzqcn4Eqt5DitxY+bamsUcM=;
        h=Date:From:To:Cc:Subject:From;
        b=JlTvXNk9yjFt4kBLUd2m7/d5ZyfZPTcIYF7Hc9Omr28oBjW62I0Gdd1V/ih/72y+h
         XKSDdi2e4o6F36xUgFDGD1LK0FAzqkSutClEEsZZYOA1MkEWzk8GX6tbmju4DksBXJ
         BOHwNy56fXnWQwyoa26p8CT+a8Vc1rXgurUmwUm17XGqa0Neh9WawGnrv2E/zjOR1/
         CS4iK3w7V1qBFTUZVkHwCUmbTr6fsFeuI/NAsURQSkvtzCp0xIz/0+WXd8UM4L+MUS
         E62czxYC/LrHuQimjN92RM2A6v23PBIRumwwMwbNB1WmfGRVo7wu8dMqsICo3RC3Fx
         7kOZ12XC/Znxg==
Date:   Wed, 4 Aug 2021 16:43:52 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net/ipv6/mcast: Use struct_size() helper
Message-ID: <20210804214352.GA46670@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace IP6_SFLSIZE() with struct_size() helper in order to avoid any
potential type mistakes or integer overflows that, in the worst
scenario, could lead to heap overflows.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 include/net/if_inet6.h |  3 ---
 net/ipv6/mcast.c       | 20 +++++++++++++-------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 71bb4cc4d05d..42235c178b06 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -82,9 +82,6 @@ struct ip6_sf_socklist {
 	struct in6_addr		sl_addr[];
 };
 
-#define IP6_SFLSIZE(count)	(sizeof(struct ip6_sf_socklist) + \
-	(count) * sizeof(struct in6_addr))
-
 #define IP6_SFBLOCK	10	/* allocate this many at once */
 
 struct ipv6_mc_socklist {
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 54ec163fbafa..cd951faa2fac 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -447,7 +447,8 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 
 		if (psl)
 			count += psl->sl_max;
-		newpsl = sock_kmalloc(sk, IP6_SFLSIZE(count), GFP_KERNEL);
+		newpsl = sock_kmalloc(sk, struct_size(newpsl, sl_addr, count),
+				      GFP_KERNEL);
 		if (!newpsl) {
 			err = -ENOBUFS;
 			goto done;
@@ -457,7 +458,8 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		if (psl) {
 			for (i = 0; i < psl->sl_count; i++)
 				newpsl->sl_addr[i] = psl->sl_addr[i];
-			atomic_sub(IP6_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
+			atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
+				   &sk->sk_omem_alloc);
 			kfree_rcu(psl, rcu);
 		}
 		psl = newpsl;
@@ -525,8 +527,9 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		goto done;
 	}
 	if (gsf->gf_numsrc) {
-		newpsl = sock_kmalloc(sk, IP6_SFLSIZE(gsf->gf_numsrc),
-							  GFP_KERNEL);
+		newpsl = sock_kmalloc(sk, struct_size(newpsl, sl_addr,
+						      gsf->gf_numsrc),
+				      GFP_KERNEL);
 		if (!newpsl) {
 			err = -ENOBUFS;
 			goto done;
@@ -543,7 +546,8 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 				     newpsl->sl_count, newpsl->sl_addr, 0);
 		if (err) {
 			mutex_unlock(&idev->mc_lock);
-			sock_kfree_s(sk, newpsl, IP6_SFLSIZE(newpsl->sl_max));
+			sock_kfree_s(sk, newpsl, struct_size(newpsl, sl_addr,
+							     newpsl->sl_max));
 			goto done;
 		}
 		mutex_unlock(&idev->mc_lock);
@@ -559,7 +563,8 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	if (psl) {
 		ip6_mc_del_src(idev, group, pmc->sfmode,
 			       psl->sl_count, psl->sl_addr, 0);
-		atomic_sub(IP6_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
+		atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
+			   &sk->sk_omem_alloc);
 		kfree_rcu(psl, rcu);
 	} else {
 		ip6_mc_del_src(idev, group, pmc->sfmode, 0, NULL, 0);
@@ -2607,7 +2612,8 @@ static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
 		err = ip6_mc_del_src(idev, &iml->addr, iml->sfmode,
 				     psl->sl_count, psl->sl_addr, 0);
 		RCU_INIT_POINTER(iml->sflist, NULL);
-		atomic_sub(IP6_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
+		atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
+			   &sk->sk_omem_alloc);
 		kfree_rcu(psl, rcu);
 	}
 
-- 
2.27.0

