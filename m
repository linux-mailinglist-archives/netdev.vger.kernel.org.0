Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8631C34968F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhCYQRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhCYQR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:17:27 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4891EC06174A;
        Thu, 25 Mar 2021 09:17:27 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id v10so2264727pgs.12;
        Thu, 25 Mar 2021 09:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ePd2nzr069/DYs7GoG+OEBXQEkaa1ywzcceGhv7GEG8=;
        b=m6wAPab30HqSMyCpRBFxYu6SsuvJL4a2GR83OUNL+Ez1HnRm+DjbnLVYhszR5On8Eh
         N/CptTpVL0oIg6cB3VP51CMKRpgOHndXLkbA5VgegMRUlbYhvgVXrSIdZY2hqiRLBYXj
         W0KHDwxr4FJ2W72oAdCOriaAO8JSLcFCk/2akn0gSR0IYnFoI91TXP/0f77TTIckaRCj
         5VLcs1AEmAFkqd0aVaZfNWEqREyV3twnaxf/7ltGV30Z5TrNaXP5qRWZTkBPuxRxhTtu
         6fC1E/5hHm3DXKIuIig4kxS0IT23MhW8CnV8Ju0gdt2CkOmKtw3+n8NXmv9ahqk7KMSw
         zvCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ePd2nzr069/DYs7GoG+OEBXQEkaa1ywzcceGhv7GEG8=;
        b=N2vnn56SdyhjgIyGVi/jvND3EC7RIHxOGGqsnTrQj5BxkPqXL/DEvzPLgysroSF1gu
         ANGwDeUGz9mKnzHRJk2NRndfhnMd/nQhjIqUANWG/mL/ahlD9AAQ+GweHU7l1oOUZt7s
         eKJ/0xxgziQVIpEkyzDTX9Gh2DY0o3tbnbq5Y84DipyY9xyT6xcAcQ6QlpGc19Iwsywb
         M8te1tZpA0wrXnB4+ITIIo/gn6yQcabpNTeHVg9UqgV0/oB5jHxX0wTw3eArzpC68GGa
         3PV/wk4xI28CcXMwf1wJENBVRqtWZm/Dqoo83ie32QZ5vq58n9p5BRxaT/clrlViJbOw
         FwTQ==
X-Gm-Message-State: AOAM531UnZ4oByIxBQcJXHiEXPOjSzOYAncBetuIQ8tUz/7d9yYyVAjr
        2KeoFnHYl6jvmE6o1ISRnSgwcKcXIJCwOQ==
X-Google-Smtp-Source: ABdhPJzhqHePcmN04ovx0DTYY4JGja6x2uYx4U8Im8/HFshcqrFZZAN5feDAUemXBrrt6lLSnpmRXw==
X-Received: by 2002:a17:902:aa0c:b029:e5:da5f:5f66 with SMTP id be12-20020a170902aa0cb02900e5da5f5f66mr10371163plb.81.1616689046466;
        Thu, 25 Mar 2021 09:17:26 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id s15sm6416917pgs.28.2021.03.25.09.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 09:17:25 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     ap420073@gmail.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-s390@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH net-next v3 3/7] mld: convert ipv6_mc_socklist->sflist to RCU
Date:   Thu, 25 Mar 2021 16:16:53 +0000
Message-Id: <20210325161657.10517-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210325161657.10517-1-ap420073@gmail.com>
References: <20210325161657.10517-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sflist has been protected by rwlock so that the critical section
is atomic context.
In order to switch this context, changing locking is needed.
The sflist actually already protected by RTNL So if it's converted
to use RCU, its control path context can be switched to sleepable.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v2 -> v3:
 - Fix sparse warnings because of rcu annotation
v1 -> v2:
 - Separated from previous big one patch.

 include/net/if_inet6.h |  4 ++--
 net/ipv6/mcast.c       | 52 ++++++++++++++++++------------------------
 2 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 1080d2248304..062294aeeb6d 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -78,6 +78,7 @@ struct inet6_ifaddr {
 struct ip6_sf_socklist {
 	unsigned int		sl_max;
 	unsigned int		sl_count;
+	struct rcu_head		rcu;
 	struct in6_addr		sl_addr[];
 };
 
@@ -91,8 +92,7 @@ struct ipv6_mc_socklist {
 	int			ifindex;
 	unsigned int		sfmode;		/* MCAST_{INCLUDE,EXCLUDE} */
 	struct ipv6_mc_socklist __rcu *next;
-	rwlock_t		sflock;
-	struct ip6_sf_socklist	*sflist;
+	struct ip6_sf_socklist	__rcu *sflist;
 	struct rcu_head		rcu;
 };
 
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 35962aa3cc22..9da55d23a13c 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -178,8 +178,7 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 
 	mc_lst->ifindex = dev->ifindex;
 	mc_lst->sfmode = mode;
-	rwlock_init(&mc_lst->sflock);
-	mc_lst->sflist = NULL;
+	RCU_INIT_POINTER(mc_lst->sflist, NULL);
 
 	/*
 	 *	now add/increase the group membership on the device
@@ -335,7 +334,6 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	struct net *net = sock_net(sk);
 	int i, j, rv;
 	int leavegroup = 0;
-	int pmclocked = 0;
 	int err;
 
 	source = &((struct sockaddr_in6 *)&pgsr->gsr_source)->sin6_addr;
@@ -364,7 +362,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		goto done;
 	}
 	/* if a source filter was set, must be the same mode as before */
-	if (pmc->sflist) {
+	if (rcu_access_pointer(pmc->sflist)) {
 		if (pmc->sfmode != omode) {
 			err = -EINVAL;
 			goto done;
@@ -376,10 +374,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		pmc->sfmode = omode;
 	}
 
-	write_lock(&pmc->sflock);
-	pmclocked = 1;
-
-	psl = pmc->sflist;
+	psl = rtnl_dereference(pmc->sflist);
 	if (!add) {
 		if (!psl)
 			goto done;	/* err = -EADDRNOTAVAIL */
@@ -429,9 +424,11 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		if (psl) {
 			for (i = 0; i < psl->sl_count; i++)
 				newpsl->sl_addr[i] = psl->sl_addr[i];
-			sock_kfree_s(sk, psl, IP6_SFLSIZE(psl->sl_max));
+			atomic_sub(IP6_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
+			kfree_rcu(psl, rcu);
 		}
-		pmc->sflist = psl = newpsl;
+		psl = newpsl;
+		rcu_assign_pointer(pmc->sflist, psl);
 	}
 	rv = 1;	/* > 0 for insert logic below if sl_count is 0 */
 	for (i = 0; i < psl->sl_count; i++) {
@@ -447,8 +444,6 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	/* update the interface list */
 	ip6_mc_add_src(idev, group, omode, 1, source, 1);
 done:
-	if (pmclocked)
-		write_unlock(&pmc->sflock);
 	read_unlock_bh(&idev->lock);
 	rcu_read_unlock();
 	if (leavegroup)
@@ -526,17 +521,16 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		(void) ip6_mc_add_src(idev, group, gsf->gf_fmode, 0, NULL, 0);
 	}
 
-	write_lock(&pmc->sflock);
-	psl = pmc->sflist;
+	psl = rtnl_dereference(pmc->sflist);
 	if (psl) {
 		(void) ip6_mc_del_src(idev, group, pmc->sfmode,
 			psl->sl_count, psl->sl_addr, 0);
-		sock_kfree_s(sk, psl, IP6_SFLSIZE(psl->sl_max));
+		atomic_sub(IP6_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
+		kfree_rcu(psl, rcu);
 	} else
 		(void) ip6_mc_del_src(idev, group, pmc->sfmode, 0, NULL, 0);
-	pmc->sflist = newpsl;
+	rcu_assign_pointer(pmc->sflist, newpsl);
 	pmc->sfmode = gsf->gf_fmode;
-	write_unlock(&pmc->sflock);
 	err = 0;
 done:
 	read_unlock_bh(&idev->lock);
@@ -585,16 +579,14 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	if (!pmc)		/* must have a prior join */
 		goto done;
 	gsf->gf_fmode = pmc->sfmode;
-	psl = pmc->sflist;
+	psl = rtnl_dereference(pmc->sflist);
 	count = psl ? psl->sl_count : 0;
 	read_unlock_bh(&idev->lock);
 	rcu_read_unlock();
 
 	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
 	gsf->gf_numsrc = count;
-	/* changes to psl require the socket lock, and a write lock
-	 * on pmc->sflock. We have the socket lock so reading here is safe.
-	 */
+
 	for (i = 0; i < copycount; i++, p++) {
 		struct sockaddr_in6 *psin6;
 		struct sockaddr_storage ss;
@@ -630,8 +622,7 @@ bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 		rcu_read_unlock();
 		return np->mc_all;
 	}
-	read_lock(&mc->sflock);
-	psl = mc->sflist;
+	psl = rcu_dereference(mc->sflist);
 	if (!psl) {
 		rv = mc->sfmode == MCAST_EXCLUDE;
 	} else {
@@ -646,7 +637,6 @@ bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 		if (mc->sfmode == MCAST_EXCLUDE && i < psl->sl_count)
 			rv = false;
 	}
-	read_unlock(&mc->sflock);
 	rcu_read_unlock();
 
 	return rv;
@@ -2422,19 +2412,21 @@ static void igmp6_join_group(struct ifmcaddr6 *ma)
 static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
 			    struct inet6_dev *idev)
 {
+	struct ip6_sf_socklist *psl;
 	int err;
 
-	write_lock_bh(&iml->sflock);
-	if (!iml->sflist) {
+	psl = rtnl_dereference(iml->sflist);
+
+	if (!psl) {
 		/* any-source empty exclude case */
 		err = ip6_mc_del_src(idev, &iml->addr, iml->sfmode, 0, NULL, 0);
 	} else {
 		err = ip6_mc_del_src(idev, &iml->addr, iml->sfmode,
-				iml->sflist->sl_count, iml->sflist->sl_addr, 0);
-		sock_kfree_s(sk, iml->sflist, IP6_SFLSIZE(iml->sflist->sl_max));
-		iml->sflist = NULL;
+				psl->sl_count, psl->sl_addr, 0);
+		RCU_INIT_POINTER(iml->sflist, NULL);
+		atomic_sub(IP6_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
+		kfree_rcu(psl, rcu);
 	}
-	write_unlock_bh(&iml->sflock);
 	return err;
 }
 
-- 
2.17.1

