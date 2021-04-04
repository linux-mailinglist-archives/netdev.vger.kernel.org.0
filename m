Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16111353846
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 15:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhDDNii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 09:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhDDNih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 09:38:37 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6CEC061756
        for <netdev@vger.kernel.org>; Sun,  4 Apr 2021 06:38:33 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id l76so6557503pga.6
        for <netdev@vger.kernel.org>; Sun, 04 Apr 2021 06:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RfKOC5itbQKWUnZaHUwKZ8De8Zqcy/jbE+AKWLJhCVM=;
        b=g47lOS9VSSSOcwY1Hp5S94AYU50UTve/jU+yS9LNvrXGocLSfazXTvc8twP0/WybPe
         RidrMpzA2f8inSYG8tZdwWafEHCPYb0/Cw3rdYCV8f+qEspkKWIl/cernal/UaVf5ylq
         Fth36cW2lllm314gY89MpgmqzXtCShLRj85w5v9wQbDqXZ1Srk31C/DotQwhIF99CuVP
         G66gb3/y5XolMprlrhSjr0sShuo+Q+GDO/gzkIIN2qKgYIQXNPWrnNUE45n/TRwT7n3o
         XWDZ5gML35LeMMFhQ50yHtCH0kmQX05HhhwonaRsxwUxE0DpCXLTl8DlleJMUDciv3/h
         OBIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RfKOC5itbQKWUnZaHUwKZ8De8Zqcy/jbE+AKWLJhCVM=;
        b=Svphc2bihG9j2QpBEqayCjGBem/EI2q4k7yCh5E3zv/0k+fzg0FdfWvIj1XVCA9FPA
         kRUXQYIkxOK8JZQrjassqvsjbod6b9VmECkv7Ji2VsvQ3at8YgAmaccGgHOSqrlyrIq5
         TzbX3vsyfmNADLur9JB4AFl1yYvhkgkI0sLQ/C3RiKuPL67ButnzOvL1yiyFoGNz+ayF
         Zbo87rFY1i5vwA+Sp+5oKtXcz3GL8msnWtKrvS/mTvARe3Gc2xy4I7bl/GLGsIgzIIfl
         JAj0sYTWPMINYyMCUdsynRn9FNvp8ZVQVlTUY0I8D2xspyKV3Snj8Pw98BB57Lhvrfag
         0+2A==
X-Gm-Message-State: AOAM532ZEIwh3yBX23Jcs17Tn0zkJM6+8kkrV66xt+nKJOB7ATw3uaWc
        M16Aw8+j6TF1/IlXapuq8Q8=
X-Google-Smtp-Source: ABdhPJxJT60EIR0NTUoT+uEd1FVjiIqMvEbPm2tD1PG82YjV+RIIG5wsf6xELSba+UwE9t8BHXWRhA==
X-Received: by 2002:a63:cc05:: with SMTP id x5mr19216028pgf.254.1617543513024;
        Sun, 04 Apr 2021 06:38:33 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id k10sm13269446pfk.205.2021.04.04.06.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 06:38:32 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        jmaloy@redhat.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net
Cc:     ap420073@gmail.com
Subject: [PATCH v2 net-next] mld: change lockdep annotation for ip6_sf_socklist and ipv6_mc_socklist
Date:   Sun,  4 Apr 2021 13:38:23 +0000
Message-Id: <20210404133823.15509-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ip6_sf_socklist and ipv6_mc_socklist are per-socket MLD data.
These data are protected by rtnl lock, socket lock, and RCU.
So, when these are used, it verifies whether rtnl lock is acquired or not.

ip6_mc_msfget() is called by do_ipv6_getsockopt().
But caller doesn't acquire rtnl lock.
So, when these data are used in the ip6_mc_msfget() lockdep warns about it.
But accessing these is actually safe because socket lock was acquired by
do_ipv6_getsockopt().

So, it changes lockdep annotation from rtnl lock to socket lock.
(rtnl_dereference -> sock_dereference)

Locking graph for mld data is like below:

When writing mld data:
do_ipv6_setsockopt()
    rtnl_lock
    lock_sock
    (mld functions)
        idev->mc_lock(if per-interface mld data is modified)

When reading mld data:
do_ipv6_getsockopt()
    lock_sock
    ip6_mc_msfget()

Splat looks like:
=============================
WARNING: suspicious RCU usage
5.12.0-rc4+ #503 Not tainted
-----------------------------
net/ipv6/mcast.c:610 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by mcast-listener-/923:
 #0: ffff888007958a70 (sk_lock-AF_INET6){+.+.}-{0:0}, at:
ipv6_get_msfilter+0xaf/0x190

stack backtrace:
CPU: 1 PID: 923 Comm: mcast-listener- Not tainted 5.12.0-rc4+ #503
Call Trace:
 dump_stack+0xa4/0xe5
 ip6_mc_msfget+0x553/0x6c0
 ? ipv6_sock_mc_join_ssm+0x10/0x10
 ? lockdep_hardirqs_on_prepare+0x3e0/0x3e0
 ? mark_held_locks+0xb7/0x120
 ? lockdep_hardirqs_on_prepare+0x27c/0x3e0
 ? __local_bh_enable_ip+0xa5/0xf0
 ? lock_sock_nested+0x82/0xf0
 ipv6_get_msfilter+0xc3/0x190
 ? compat_ipv6_get_msfilter+0x300/0x300
 ? lock_downgrade+0x690/0x690
 do_ipv6_getsockopt.isra.6.constprop.13+0x1809/0x29e0
 ? do_ipv6_mcast_group_source+0x150/0x150
 ? register_lock_class+0x1750/0x1750
 ? kvm_sched_clock_read+0x14/0x30
 ? sched_clock+0x5/0x10
 ? sched_clock_cpu+0x18/0x170
 ? find_held_lock+0x3a/0x1c0
 ? lock_downgrade+0x690/0x690
 ? ipv6_getsockopt+0xdb/0x1b0
 ipv6_getsockopt+0xdb/0x1b0
[ ... ]

Fixes: 88e2ca308094 ("mld: convert ifmcaddr6 to RCU")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Do not add new rtnl lock(by Eric Dumazet)
 - Add missing lock_sock().
 - Change headline.

 net/ipv6/mcast.c     | 48 +++++++++++++++++++++-----------------------
 net/tipc/udp_media.c |  2 ++
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 49b0cebfdcdc..ff536a158b85 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -114,10 +114,13 @@ int sysctl_mld_qrv __read_mostly = MLD_QRV_DEFAULT;
 #define mc_dereference(e, idev) \
 	rcu_dereference_protected(e, lockdep_is_held(&(idev)->mc_lock))
 
-#define for_each_pmc_rtnl(np, pmc)				\
-	for (pmc = rtnl_dereference((np)->ipv6_mc_list);	\
+#define sock_dereference(e, sk) \
+	rcu_dereference_protected(e, lockdep_sock_is_held(sk))
+
+#define for_each_pmc_socklock(np, sk, pmc)			\
+	for (pmc = sock_dereference((np)->ipv6_mc_list, sk);	\
 	     pmc;						\
-	     pmc = rtnl_dereference(pmc->next))
+	     pmc = sock_dereference(pmc->next, sk))
 
 #define for_each_pmc_rcu(np, pmc)				\
 	for (pmc = rcu_dereference((np)->ipv6_mc_list);		\
@@ -180,7 +183,7 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 	if (!ipv6_addr_is_multicast(addr))
 		return -EINVAL;
 
-	for_each_pmc_rtnl(np, mc_lst) {
+	for_each_pmc_socklock(np, sk, mc_lst) {
 		if ((ifindex == 0 || mc_lst->ifindex == ifindex) &&
 		    ipv6_addr_equal(&mc_lst->addr, addr))
 			return -EADDRINUSE;
@@ -258,7 +261,7 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 		return -EINVAL;
 
 	for (lnk = &np->ipv6_mc_list;
-	     (mc_lst = rtnl_dereference(*lnk)) != NULL;
+	     (mc_lst = sock_dereference(*lnk, sk)) != NULL;
 	      lnk = &mc_lst->next) {
 		if ((ifindex == 0 || mc_lst->ifindex == ifindex) &&
 		    ipv6_addr_equal(&mc_lst->addr, addr)) {
@@ -323,7 +326,7 @@ void __ipv6_sock_mc_close(struct sock *sk)
 
 	ASSERT_RTNL();
 
-	while ((mc_lst = rtnl_dereference(np->ipv6_mc_list)) != NULL) {
+	while ((mc_lst = sock_dereference(np->ipv6_mc_list, sk)) != NULL) {
 		struct net_device *dev;
 
 		np->ipv6_mc_list = mc_lst->next;
@@ -350,8 +353,11 @@ void ipv6_sock_mc_close(struct sock *sk)
 
 	if (!rcu_access_pointer(np->ipv6_mc_list))
 		return;
+
 	rtnl_lock();
+	lock_sock(sk);
 	__ipv6_sock_mc_close(sk);
+	release_sock(sk);
 	rtnl_unlock();
 }
 
@@ -381,7 +387,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	err = -EADDRNOTAVAIL;
 
 	mutex_lock(&idev->mc_lock);
-	for_each_pmc_rtnl(inet6, pmc) {
+	for_each_pmc_socklock(inet6, sk, pmc) {
 		if (pgsr->gsr_interface && pmc->ifindex != pgsr->gsr_interface)
 			continue;
 		if (ipv6_addr_equal(&pmc->addr, group))
@@ -404,7 +410,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		pmc->sfmode = omode;
 	}
 
-	psl = rtnl_dereference(pmc->sflist);
+	psl = sock_dereference(pmc->sflist, sk);
 	if (!add) {
 		if (!psl)
 			goto done;	/* err = -EADDRNOTAVAIL */
@@ -511,7 +517,7 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		goto done;
 	}
 
-	for_each_pmc_rtnl(inet6, pmc) {
+	for_each_pmc_socklock(inet6, sk, pmc) {
 		if (pmc->ifindex != gsf->gf_interface)
 			continue;
 		if (ipv6_addr_equal(&pmc->addr, group))
@@ -552,7 +558,7 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	}
 
 	mutex_lock(&idev->mc_lock);
-	psl = rtnl_dereference(pmc->sflist);
+	psl = sock_dereference(pmc->sflist, sk);
 	if (psl) {
 		ip6_mc_del_src(idev, group, pmc->sfmode,
 			       psl->sl_count, psl->sl_addr, 0);
@@ -574,40 +580,32 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 		  struct sockaddr_storage __user *p)
 {
-	int err, i, count, copycount;
+	struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	const struct in6_addr *group;
 	struct ipv6_mc_socklist *pmc;
-	struct inet6_dev *idev;
-	struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	struct ip6_sf_socklist *psl;
-	struct net *net = sock_net(sk);
+	int i, count, copycount;
 
 	group = &((struct sockaddr_in6 *)&gsf->gf_group)->sin6_addr;
 
 	if (!ipv6_addr_is_multicast(group))
 		return -EINVAL;
 
-	idev = ip6_mc_find_dev_rtnl(net, group, gsf->gf_interface);
-	if (!idev)
-		return -ENODEV;
-
-	err = -EADDRNOTAVAIL;
 	/* changes to the ipv6_mc_list require the socket lock and
-	 * rtnl lock. We have the socket lock and rcu read lock,
-	 * so reading the list is safe.
+	 * rtnl lock. We have the socket lock, so reading the list is safe.
 	 */
 
-	for_each_pmc_rtnl(inet6, pmc) {
+	for_each_pmc_socklock(inet6, sk, pmc) {
 		if (pmc->ifindex != gsf->gf_interface)
 			continue;
 		if (ipv6_addr_equal(group, &pmc->addr))
 			break;
 	}
 	if (!pmc)		/* must have a prior join */
-		return err;
+		return -EADDRNOTAVAIL;
 
 	gsf->gf_fmode = pmc->sfmode;
-	psl = rtnl_dereference(pmc->sflist);
+	psl = sock_dereference(pmc->sflist, sk);
 	count = psl ? psl->sl_count : 0;
 
 	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
@@ -2600,7 +2598,7 @@ static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
 	struct ip6_sf_socklist *psl;
 	int err;
 
-	psl = rtnl_dereference(iml->sflist);
+	psl = sock_dereference(iml->sflist, sk);
 
 	if (idev)
 		mutex_lock(&idev->mc_lock);
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 21e75e28e86a..e556d2cdc064 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -414,8 +414,10 @@ static int enable_mcast(struct udp_bearer *ub, struct udp_media_addr *remote)
 		err = ip_mc_join_group(sk, &mreqn);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
+		lock_sock(sk);
 		err = ipv6_stub->ipv6_sock_mc_join(sk, ub->ifindex,
 						   &remote->ipv6);
+		release_sock(sk);
 #endif
 	}
 	return err;
-- 
2.17.1

