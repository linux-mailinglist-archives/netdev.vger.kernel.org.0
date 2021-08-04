Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9271D3E09EB
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 23:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhHDVQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 17:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhHDVQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 17:16:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 511C160EE8;
        Wed,  4 Aug 2021 21:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628111770;
        bh=VXiqPxF0kjv6nWSjkMwVKlsBbYuZtRFsnuWf5zouccE=;
        h=Date:From:To:Cc:Subject:From;
        b=hF5WVeKONzt1hdOekY4f2881K2Sh+Ch7vjgKV6wOGs8H/ZI02DdgNePxokRg6nZ2g
         YtdajtoC+X18GwemzS9BkcDiDCnLPUeaFpRlYCz3DDSl1/a4g8MJ9bN17wdBdwLwCC
         MLLkT03bB+gYpEji0BT8GHoaOw+dBtJ6oXfRGuxoBGWusX/QfowVexx3mXLa8ZwM5g
         rysUJxqP6p1h5H2y3viHY5yQtFQPGQ1MZbUVUHSr1+MKltHPns5/vGC1s29gbu6/PJ
         0ODp45SjlCA63Xds+2sne77khLEs7CtXlD61Ahe0GVAcjaywqq+bgahYDb6eIeZIsp
         QlxQB8elpYh9w==
Date:   Wed, 4 Aug 2021 16:18:50 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net/ipv4/igmp: Use struct_size() helper
Message-ID: <20210804211850.GA42046@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace IP_SFLSIZE() with struct_size() helper in order to avoid any
potential type mistakes or integer overflows that, in the worst
scenario, could lead to heap overflows.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 include/linux/igmp.h |  3 ---
 net/ipv4/igmp.c      | 20 +++++++++++++-------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index 64ce8cd1cfaf..93c262ecbdc9 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -41,9 +41,6 @@ struct ip_sf_socklist {
 	__be32			sl_addr[];
 };
 
-#define IP_SFLSIZE(count)	(sizeof(struct ip_sf_socklist) + \
-	(count) * sizeof(__be32))
-
 #define IP_SFBLOCK	10	/* allocate this many at once */
 
 /* ip_mc_socklist is real list now. Speed is not argument;
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index a5f4ecb02e97..cca84d2b13d6 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2233,7 +2233,7 @@ static int ip_mc_leave_src(struct sock *sk, struct ip_mc_socklist *iml,
 			iml->sfmode, psf->sl_count, psf->sl_addr, 0);
 	RCU_INIT_POINTER(iml->sflist, NULL);
 	/* decrease mem now to avoid the memleak warning */
-	atomic_sub(IP_SFLSIZE(psf->sl_max), &sk->sk_omem_alloc);
+	atomic_sub(struct_size(psf, sl_addr, psf->sl_max), &sk->sk_omem_alloc);
 	kfree_rcu(psf, rcu);
 	return err;
 }
@@ -2382,7 +2382,8 @@ int ip_mc_source(int add, int omode, struct sock *sk, struct
 
 		if (psl)
 			count += psl->sl_max;
-		newpsl = sock_kmalloc(sk, IP_SFLSIZE(count), GFP_KERNEL);
+		newpsl = sock_kmalloc(sk, struct_size(newpsl, sl_addr, count),
+				      GFP_KERNEL);
 		if (!newpsl) {
 			err = -ENOBUFS;
 			goto done;
@@ -2393,7 +2394,8 @@ int ip_mc_source(int add, int omode, struct sock *sk, struct
 			for (i = 0; i < psl->sl_count; i++)
 				newpsl->sl_addr[i] = psl->sl_addr[i];
 			/* decrease mem now to avoid the memleak warning */
-			atomic_sub(IP_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
+			atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
+				   &sk->sk_omem_alloc);
 			kfree_rcu(psl, rcu);
 		}
 		rcu_assign_pointer(pmc->sflist, newpsl);
@@ -2468,8 +2470,9 @@ int ip_mc_msfilter(struct sock *sk, struct ip_msfilter *msf, int ifindex)
 		goto done;
 	}
 	if (msf->imsf_numsrc) {
-		newpsl = sock_kmalloc(sk, IP_SFLSIZE(msf->imsf_numsrc),
-							   GFP_KERNEL);
+		newpsl = sock_kmalloc(sk, struct_size(newpsl, sl_addr,
+						      msf->imsf_numsrc),
+				      GFP_KERNEL);
 		if (!newpsl) {
 			err = -ENOBUFS;
 			goto done;
@@ -2480,7 +2483,9 @@ int ip_mc_msfilter(struct sock *sk, struct ip_msfilter *msf, int ifindex)
 		err = ip_mc_add_src(in_dev, &msf->imsf_multiaddr,
 			msf->imsf_fmode, newpsl->sl_count, newpsl->sl_addr, 0);
 		if (err) {
-			sock_kfree_s(sk, newpsl, IP_SFLSIZE(newpsl->sl_max));
+			sock_kfree_s(sk, newpsl,
+				     struct_size(newpsl, sl_addr,
+						 newpsl->sl_max));
 			goto done;
 		}
 	} else {
@@ -2493,7 +2498,8 @@ int ip_mc_msfilter(struct sock *sk, struct ip_msfilter *msf, int ifindex)
 		(void) ip_mc_del_src(in_dev, &msf->imsf_multiaddr, pmc->sfmode,
 			psl->sl_count, psl->sl_addr, 0);
 		/* decrease mem now to avoid the memleak warning */
-		atomic_sub(IP_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
+		atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
+			   &sk->sk_omem_alloc);
 		kfree_rcu(psl, rcu);
 	} else
 		(void) ip_mc_del_src(in_dev, &msf->imsf_multiaddr, pmc->sfmode,
-- 
2.27.0

