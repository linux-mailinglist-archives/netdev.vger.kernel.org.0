Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E3A31AD7C
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhBMRyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhBMRyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 12:54:04 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D39C0613D6
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:53:24 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id e9so1453487pjj.0
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=W6cX2R/XxA8xXlioJTWLTiN6J6N/xAO8S2W6b5ypstU=;
        b=t0mbbsNy7OOG5egvZQUaBDpuL2mJhFrjqO9He81vyNwNewSqpEOUGHEDHBIwh59YUb
         FAbGAqr7aLmpRHxbvg3MwLmdYy7N2DcX0NSJwFFf6F7ZB2Tr6YDKBxhANiJlfhqZ7XxS
         1DMLFZpX9XrOMWAySXbR/KHnCTGz1zUVgzjHJKOhBN+spYzBKe4k10o9c4eZE5iEANrm
         ezuQNrTJ7XPXpH0pHsJSARfTiF/DllweqmY7awfEGEMjAduH+7PZ+FUtVM3BmsHIufcX
         Cmwe5rlPPEnf5QOpHVdOtTBFhgSYUZIp5X30Q4KXQmYWmq0AqVcOlvvqlT3iHU7qie2u
         O5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=W6cX2R/XxA8xXlioJTWLTiN6J6N/xAO8S2W6b5ypstU=;
        b=QXAS7RrodVSnGF0TpAsrr9nqD5rqNbXAVPB6LP0jm3pqeovxi1xPVFuyKOcW9J+KsW
         KygO5v+hRyNeZvvK+eaYRU2jPCDMZPGifgXBf+GpT+UUPytSCqr2X0wyvtxVoyeLgnSg
         Jy1qHiDb7dqZBDM0TZK5Ns7wfD3ujWKA1aREO2eCcmAfvvXn0RiHOiK2R+y0MuvBaAOg
         Q3NZaIzZqz4Z/DZTmr/ESL9GLNXyChY4ehDLP9OOaZfGQfR2Vl7l0vwp3vx/Nd9fIcna
         O26W2/aaEWgmZFY8i5HVox3dTSwsfZp1IrV3OLvQHwNTnce3f16lID9ZjeK6ENPbnsbH
         5FIQ==
X-Gm-Message-State: AOAM531s3oc4mrxQNRDh4qimG7iPLiUf35vGNthiw1KKGfSefdkvk1kz
        lCGbDEnbzGVkYltfv82Mc2k=
X-Google-Smtp-Source: ABdhPJx5AevkASPjfOx33yPYhNwE/wRvN3FgHmFrS9gLLstHbc/nBcCliffeteHnhfqx7HFMZV2Pjw==
X-Received: by 2002:a17:90b:11c9:: with SMTP id gv9mr7986191pjb.196.1613238803433;
        Sat, 13 Feb 2021 09:53:23 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id q15sm11414225pja.22.2021.02.13.09.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 09:53:22 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH net-next v2 7/7] mld: convert ifmcaddr6 to RCU
Date:   Sat, 13 Feb 2021 17:53:15 +0000
Message-Id: <20210213175315.28717-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ifmcaddr6 has been protected by inet6_dev->lock(rwlock) so that
the critical section is atomic context. In order to switch this context,
changing locking is needed. The ifmcaddr6 actually already protected by
RTNL So if it's converted to use RCU, its control path context can be
switched to sleepable.

Because of this conversion, the locking scenario can be changed.
So, the locking scenario is changed to the following.
1. ifmcaddr6->mca_lock only protects following resources.
   a) ifmcaddr6->mca_flags
   b) ifmcaddr6->mca_work.
   c) ifmcaddr6->mca_sources->sf_gsresp
2. inet6_dev->lock only protects following resources.
   a) inet6_dev->mc_gq_running
   b) inet6_dev->mc_gq_work
   c) inet6_dev->mc_ifc_count
   d) inet6_dev->mc_ifc_work
   e) inet6_dev->mc_delerec_work
3. Other resources are protected by RTNL and RCU.

There are only two atomic context locks, they are ifmcaddr6->mca_lock
and inet6_dev->lock. These locks are protecting resources, they are
written on the datapath.
RTNL can't be used on the datapath, these locks are used.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - Separated from previous big one patch.
 - Do not rename 'ifmcaddr6->mca_lock'.
 - Do not use atomic_t for 'ifmcaddr6->mca_sfcount'
 - Do not use atomic_t for 'ipv6_mc_socklist'->sf_count'.
 - Do not add mld_check_leave_group() function.
 - Do not add ip6_mc_del_src_bulk() function.
 - Do not add ip6_mc_add_src_bulk() function.
 - Do not use rcu_read_lock() in the qeth_l3_add_mcast_rtnl().

 drivers/s390/net/qeth_l3_main.c |   6 +-
 include/net/if_inet6.h          |   5 +-
 net/batman-adv/multicast.c      |   6 +-
 net/ipv6/addrconf.c             |   9 +-
 net/ipv6/addrconf_core.c        |   2 +-
 net/ipv6/af_inet6.c             |   2 +-
 net/ipv6/mcast.c                | 340 ++++++++++++++------------------
 7 files changed, 169 insertions(+), 201 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index dd441eaec66e..5a0ba65971cc 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1098,8 +1098,9 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 	tmp.disp_flag = QETH_DISP_ADDR_ADD;
 	tmp.is_multicast = 1;
 
-	read_lock_bh(&in6_dev->lock);
-	for (im6 = in6_dev->mc_list; im6 != NULL; im6 = im6->next) {
+	for (im6 = rtnl_dereference(in6_dev->mc_list);
+	     im6;
+	     im6 = rtnl_dereference(im6->next)) {
 		tmp.u.a6.addr = im6->mca_addr;
 
 		ipm = qeth_l3_find_addr_by_ip(card, &tmp);
@@ -1117,7 +1118,6 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
 			 qeth_l3_ipaddr_hash(ipm));
 
 	}
-	read_unlock_bh(&in6_dev->lock);
 
 out:
 	return 0;
diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index b26fecb669e3..9e7f5b4bf7ae 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -113,7 +113,7 @@ struct ip6_sf_list {
 struct ifmcaddr6 {
 	struct in6_addr		mca_addr;
 	struct inet6_dev	*idev;
-	struct ifmcaddr6	*next;
+	struct ifmcaddr6	__rcu *next;
 	struct ip6_sf_list	__rcu *mca_sources;
 	struct ip6_sf_list	*mca_tomb;
 	unsigned int		mca_sfmode;
@@ -128,6 +128,7 @@ struct ifmcaddr6 {
 	spinlock_t		mca_lock;
 	unsigned long		mca_cstamp;
 	unsigned long		mca_tstamp;
+	struct rcu_head		rcu;
 };
 
 /* Anycast stuff */
@@ -166,7 +167,7 @@ struct inet6_dev {
 
 	struct list_head	addr_list;
 
-	struct ifmcaddr6	*mc_list;
+	struct ifmcaddr6	__rcu *mc_list;
 	struct ifmcaddr6	*mc_tomb;
 
 	unsigned char		mc_qrv;		/* Query Robustness Variable */
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 28166402d30c..1d63c8cbbfe7 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -454,8 +454,9 @@ batadv_mcast_mla_softif_get_ipv6(struct net_device *dev,
 		return 0;
 	}
 
-	read_lock_bh(&in6_dev->lock);
-	for (pmc6 = in6_dev->mc_list; pmc6; pmc6 = pmc6->next) {
+	for (pmc6 = rcu_dereference(in6_dev->mc_list);
+	     pmc6;
+	     pmc6 = rcu_dereference(pmc6->next)) {
 		if (IPV6_ADDR_MC_SCOPE(&pmc6->mca_addr) <
 		    IPV6_ADDR_SCOPE_LINKLOCAL)
 			continue;
@@ -484,7 +485,6 @@ batadv_mcast_mla_softif_get_ipv6(struct net_device *dev,
 		hlist_add_head(&new->list, mcast_list);
 		ret++;
 	}
-	read_unlock_bh(&in6_dev->lock);
 	rcu_read_unlock();
 
 	return ret;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f2337fb756ac..b502f78d5091 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5107,17 +5107,20 @@ static int in6_dump_addrs(struct inet6_dev *idev, struct sk_buff *skb,
 		break;
 	}
 	case MULTICAST_ADDR:
+		read_unlock_bh(&idev->lock);
 		fillargs->event = RTM_GETMULTICAST;
 
 		/* multicast address */
-		for (ifmca = idev->mc_list; ifmca;
-		     ifmca = ifmca->next, ip_idx++) {
+		for (ifmca = rcu_dereference(idev->mc_list);
+		     ifmca;
+		     ifmca = rcu_dereference(ifmca->next), ip_idx++) {
 			if (ip_idx < s_ip_idx)
 				continue;
 			err = inet6_fill_ifmcaddr(skb, ifmca, fillargs);
 			if (err < 0)
 				break;
 		}
+		read_lock_bh(&idev->lock);
 		break;
 	case ANYCAST_ADDR:
 		fillargs->event = RTM_GETANYCAST;
@@ -6093,10 +6096,8 @@ static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
 
 static void ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
 {
-	rcu_read_lock_bh();
 	if (likely(ifp->idev->dead == 0))
 		__ipv6_ifa_notify(event, ifp);
-	rcu_read_unlock_bh();
 }
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index c70c192bc91b..a36626afbc02 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -250,7 +250,7 @@ void in6_dev_finish_destroy(struct inet6_dev *idev)
 	struct net_device *dev = idev->dev;
 
 	WARN_ON(!list_empty(&idev->addr_list));
-	WARN_ON(idev->mc_list);
+	WARN_ON(rcu_access_pointer(idev->mc_list));
 	WARN_ON(timer_pending(&idev->rs_timer));
 
 #ifdef NET_REFCNT_DEBUG
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 0e9994e0ecd7..8de7eb53e5ea 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -222,7 +222,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	inet->mc_loop	= 1;
 	inet->mc_ttl	= 1;
 	inet->mc_index	= 0;
-	inet->mc_list	= NULL;
+	RCU_INIT_POINTER(inet->mc_list, NULL);
 	inet->rcv_tos	= 0;
 
 	if (net->ipv4.sysctl_ip_no_pmtu_disc)
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 792f16e2ad83..2b33196d6a84 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -112,11 +112,26 @@ int sysctl_mld_qrv __read_mostly = MLD_QRV_DEFAULT;
  *	socket join on multicast group
  */
 
+#define for_each_pmc_rtnl(np, pmc)				\
+	for (pmc = rtnl_dereference((np)->ipv6_mc_list);	\
+	     pmc;						\
+	     pmc = rtnl_dereference(pmc->next))
+
 #define for_each_pmc_rcu(np, pmc)				\
 	for (pmc = rcu_dereference((np)->ipv6_mc_list);		\
 	     pmc;						\
 	     pmc = rcu_dereference(pmc->next))
 
+#define for_each_mc_rtnl(idev, mc)				\
+	for (mc = rtnl_dereference((idev)->mc_list);		\
+	     mc;						\
+	     mc = rtnl_dereference(mc->next))
+
+#define for_each_mc_rcu(idev, mc)				\
+	for (mc = rcu_dereference((idev)->mc_list);		\
+	     mc;						\
+	     mc = rcu_dereference(mc->next))
+
 #define for_each_psf_rtnl(mc, psf)				\
 	for (psf = rtnl_dereference((mc)->mca_sources);		\
 	     psf;						\
@@ -153,15 +168,11 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
 	if (!ipv6_addr_is_multicast(addr))
 		return -EINVAL;
 
-	rcu_read_lock();
-	for_each_pmc_rcu(np, mc_lst) {
+	for_each_pmc_rtnl(np, mc_lst) {
 		if ((ifindex == 0 || mc_lst->ifindex == ifindex) &&
-		    ipv6_addr_equal(&mc_lst->addr, addr)) {
-			rcu_read_unlock();
+		    ipv6_addr_equal(&mc_lst->addr, addr))
 			return -EADDRINUSE;
-		}
 	}
-	rcu_read_unlock();
 
 	mc_lst = sock_kmalloc(sk, sizeof(struct ipv6_mc_socklist), GFP_KERNEL);
 
@@ -263,10 +274,9 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
 }
 EXPORT_SYMBOL(ipv6_sock_mc_drop);
 
-/* called with rcu_read_lock() */
-static struct inet6_dev *ip6_mc_find_dev_rcu(struct net *net,
-					     const struct in6_addr *group,
-					     int ifindex)
+static struct inet6_dev *ip6_mc_find_dev_rtnl(struct net *net,
+					      const struct in6_addr *group,
+					      int ifindex)
 {
 	struct net_device *dev = NULL;
 	struct inet6_dev *idev = NULL;
@@ -279,18 +289,17 @@ static struct inet6_dev *ip6_mc_find_dev_rcu(struct net *net,
 			ip6_rt_put(rt);
 		}
 	} else
-		dev = dev_get_by_index_rcu(net, ifindex);
+		dev = __dev_get_by_index(net, ifindex);
 
 	if (!dev)
 		return NULL;
 	idev = __in6_dev_get(dev);
 	if (!idev)
 		return NULL;
-	read_lock_bh(&idev->lock);
-	if (idev->dead) {
-		read_unlock_bh(&idev->lock);
+
+	if (idev->dead)
 		return NULL;
-	}
+
 	return idev;
 }
 
@@ -346,22 +355,21 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	int leavegroup = 0;
 	int err;
 
+	ASSERT_RTNL();
+
 	source = &((struct sockaddr_in6 *)&pgsr->gsr_source)->sin6_addr;
 	group = &((struct sockaddr_in6 *)&pgsr->gsr_group)->sin6_addr;
 
 	if (!ipv6_addr_is_multicast(group))
 		return -EINVAL;
 
-	rcu_read_lock();
-	idev = ip6_mc_find_dev_rcu(net, group, pgsr->gsr_interface);
-	if (!idev) {
-		rcu_read_unlock();
+	idev = ip6_mc_find_dev_rtnl(net, group, pgsr->gsr_interface);
+	if (!idev)
 		return -ENODEV;
-	}
 
 	err = -EADDRNOTAVAIL;
 
-	for_each_pmc_rcu(inet6, pmc) {
+	for_each_pmc_rtnl(inet6, pmc) {
 		if (pgsr->gsr_interface && pmc->ifindex != pgsr->gsr_interface)
 			continue;
 		if (ipv6_addr_equal(&pmc->addr, group))
@@ -371,6 +379,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 		err = -EINVAL;
 		goto done;
 	}
+
 	/* if a source filter was set, must be the same mode as before */
 	if (rcu_access_pointer(pmc->sflist)) {
 		if (pmc->sfmode != omode) {
@@ -424,7 +433,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 
 		if (psl)
 			count += psl->sl_max;
-		newpsl = sock_kmalloc(sk, IP6_SFLSIZE(count), GFP_ATOMIC);
+		newpsl = sock_kmalloc(sk, IP6_SFLSIZE(count), GFP_KERNEL);
 		if (!newpsl) {
 			err = -ENOBUFS;
 			goto done;
@@ -454,8 +463,6 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	/* update the interface list */
 	ip6_mc_add_src(idev, group, omode, 1, source, 1);
 done:
-	read_unlock_bh(&idev->lock);
-	rcu_read_unlock();
 	if (leavegroup)
 		err = ipv6_sock_mc_drop(sk, pgsr->gsr_interface, group);
 	return err;
@@ -473,6 +480,8 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	int leavegroup = 0;
 	int i, err;
 
+	ASSERT_RTNL();
+
 	group = &((struct sockaddr_in6 *)&gsf->gf_group)->sin6_addr;
 
 	if (!ipv6_addr_is_multicast(group))
@@ -481,13 +490,10 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	    gsf->gf_fmode != MCAST_EXCLUDE)
 		return -EINVAL;
 
-	rcu_read_lock();
-	idev = ip6_mc_find_dev_rcu(net, group, gsf->gf_interface);
+	idev = ip6_mc_find_dev_rtnl(net, group, gsf->gf_interface);
 
-	if (!idev) {
-		rcu_read_unlock();
+	if (!idev)
 		return -ENODEV;
-	}
 
 	err = 0;
 
@@ -496,7 +502,7 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		goto done;
 	}
 
-	for_each_pmc_rcu(inet6, pmc) {
+	for_each_pmc_rtnl(inet6, pmc) {
 		if (pmc->ifindex != gsf->gf_interface)
 			continue;
 		if (ipv6_addr_equal(&pmc->addr, group))
@@ -508,7 +514,7 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	}
 	if (gsf->gf_numsrc) {
 		newpsl = sock_kmalloc(sk, IP6_SFLSIZE(gsf->gf_numsrc),
-							  GFP_ATOMIC);
+							  GFP_KERNEL);
 		if (!newpsl) {
 			err = -ENOBUFS;
 			goto done;
@@ -543,8 +549,6 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	pmc->sfmode = gsf->gf_fmode;
 	err = 0;
 done:
-	read_unlock_bh(&idev->lock);
-	rcu_read_unlock();
 	if (leavegroup)
 		err = ipv6_sock_mc_drop(sk, gsf->gf_interface, group);
 	return err;
@@ -561,13 +565,14 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	struct ip6_sf_socklist *psl;
 	struct net *net = sock_net(sk);
 
+	ASSERT_RTNL();
+
 	group = &((struct sockaddr_in6 *)&gsf->gf_group)->sin6_addr;
 
 	if (!ipv6_addr_is_multicast(group))
 		return -EINVAL;
 
-	rcu_read_lock();
-	idev = ip6_mc_find_dev_rcu(net, group, gsf->gf_interface);
+	idev = ip6_mc_find_dev_rtnl(net, group, gsf->gf_interface);
 
 	if (!idev) {
 		rcu_read_unlock();
@@ -580,7 +585,7 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	 * so reading the list is safe.
 	 */
 
-	for_each_pmc_rcu(inet6, pmc) {
+	for_each_pmc_rtnl(inet6, pmc) {
 		if (pmc->ifindex != gsf->gf_interface)
 			continue;
 		if (ipv6_addr_equal(group, &pmc->addr))
@@ -591,8 +596,6 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	gsf->gf_fmode = pmc->sfmode;
 	psl = rtnl_dereference(pmc->sflist);
 	count = psl ? psl->sl_count : 0;
-	read_unlock_bh(&idev->lock);
-	rcu_read_unlock();
 
 	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
 	gsf->gf_numsrc = count;
@@ -610,8 +613,6 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	}
 	return 0;
 done:
-	read_unlock_bh(&idev->lock);
-	rcu_read_unlock();
 	return err;
 }
 
@@ -726,11 +727,10 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	 * for deleted items allows change reports to use common code with
 	 * non-deleted or query-response MCA's.
 	 */
-	pmc = kzalloc(sizeof(*pmc), GFP_ATOMIC);
+	pmc = kzalloc(sizeof(*pmc), GFP_KERNEL);
 	if (!pmc)
 		return;
 
-	spin_lock_bh(&im->mca_lock);
 	spin_lock_init(&pmc->mca_lock);
 	pmc->idev = im->idev;
 	in6_dev_hold(idev);
@@ -749,7 +749,6 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 		for_each_psf_rtnl(pmc, psf)
 			psf->sf_crcount = pmc->mca_crcount;
 	}
-	spin_unlock_bh(&im->mca_lock);
 
 	rcu_assign_pointer(pmc->next, idev->mc_tomb);
 	idev->mc_tomb = pmc;
@@ -774,7 +773,6 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 			idev->mc_tomb = pmc->next;
 	}
 
-	spin_lock_bh(&im->mca_lock);
 	if (pmc) {
 		im->idev = pmc->idev;
 		if (im->mca_sfmode == MCAST_INCLUDE) {
@@ -793,7 +791,6 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 		ip6_mc_clear_src(pmc);
 		kfree(pmc);
 	}
-	spin_unlock_bh(&im->mca_lock);
 }
 
 static void mld_clear_delrec(struct inet6_dev *idev)
@@ -811,20 +808,16 @@ static void mld_clear_delrec(struct inet6_dev *idev)
 	}
 
 	/* clear dead sources, too */
-	read_lock_bh(&idev->lock);
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
+	for_each_mc_rtnl(idev, pmc) {
 		struct ip6_sf_list *psf, *psf_next;
 
-		spin_lock_bh(&pmc->mca_lock);
 		psf = pmc->mca_tomb;
 		pmc->mca_tomb = NULL;
-		spin_unlock_bh(&pmc->mca_lock);
 		for (; psf; psf = psf_next) {
 			psf_next = rtnl_dereference(psf->sf_next);
 			kfree_rcu(psf, rcu);
 		}
 	}
-	read_unlock_bh(&idev->lock);
 }
 
 static void mca_get(struct ifmcaddr6 *mc)
@@ -836,7 +829,7 @@ static void ma_put(struct ifmcaddr6 *mc)
 {
 	if (refcount_dec_and_test(&mc->mca_refcnt)) {
 		in6_dev_put(mc->idev);
-		kfree(mc);
+		kfree_rcu(mc, rcu);
 	}
 }
 
@@ -846,7 +839,7 @@ static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 {
 	struct ifmcaddr6 *mc;
 
-	mc = kzalloc(sizeof(*mc), GFP_ATOMIC);
+	mc = kzalloc(sizeof(*mc), GFP_KERNEL);
 	if (!mc)
 		return NULL;
 
@@ -887,17 +880,14 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 	if (!idev)
 		return -EINVAL;
 
-	write_lock_bh(&idev->lock);
 	if (idev->dead) {
-		write_unlock_bh(&idev->lock);
 		in6_dev_put(idev);
 		return -ENODEV;
 	}
 
-	for (mc = idev->mc_list; mc; mc = mc->next) {
+	for_each_mc_rtnl(idev, mc) {
 		if (ipv6_addr_equal(&mc->mca_addr, addr)) {
 			mc->mca_users++;
-			write_unlock_bh(&idev->lock);
 			ip6_mc_add_src(idev, &mc->mca_addr, mode, 0, NULL, 0);
 			in6_dev_put(idev);
 			return 0;
@@ -906,19 +896,14 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 
 	mc = mca_alloc(idev, addr, mode);
 	if (!mc) {
-		write_unlock_bh(&idev->lock);
 		in6_dev_put(idev);
 		return -ENOMEM;
 	}
 
-	mc->next = idev->mc_list;
-	idev->mc_list = mc;
+	rcu_assign_pointer(mc->next, idev->mc_list);
+	rcu_assign_pointer(idev->mc_list, mc);
 
-	/* Hold this for the code below before we unlock,
-	 * it is already exposed via idev->mc_list.
-	 */
 	mca_get(mc);
-	write_unlock_bh(&idev->lock);
 
 	mld_del_delrec(idev, mc);
 	igmp6_group_added(mc);
@@ -937,16 +922,17 @@ EXPORT_SYMBOL(ipv6_dev_mc_inc);
  */
 int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 {
-	struct ifmcaddr6 *ma, **map;
+	struct ifmcaddr6 __rcu **map;
+	struct ifmcaddr6 *ma;
 
 	ASSERT_RTNL();
 
-	write_lock_bh(&idev->lock);
-	for (map = &idev->mc_list; (ma = *map) != NULL; map = &ma->next) {
+	for (map = &idev->mc_list;
+	     (ma = rtnl_dereference(*map)) != NULL;
+	     map = &ma->next) {
 		if (ipv6_addr_equal(&ma->mca_addr, addr)) {
 			if (--ma->mca_users == 0) {
-				*map = ma->next;
-				write_unlock_bh(&idev->lock);
+				*map = rtnl_dereference(ma->next);
 
 				igmp6_group_dropped(ma);
 				ip6_mc_clear_src(ma);
@@ -954,11 +940,9 @@ int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 				ma_put(ma);
 				return 0;
 			}
-			write_unlock_bh(&idev->lock);
 			return 0;
 		}
 	}
-	write_unlock_bh(&idev->lock);
 
 	return -ENOENT;
 }
@@ -993,8 +977,7 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 	rcu_read_lock();
 	idev = __in6_dev_get(dev);
 	if (idev) {
-		read_lock_bh(&idev->lock);
-		for (mc = idev->mc_list; mc; mc = mc->next) {
+		for_each_mc_rcu(idev, mc) {
 			if (ipv6_addr_equal(&mc->mca_addr, group))
 				break;
 		}
@@ -1002,7 +985,6 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 			if (src_addr && !ipv6_addr_any(src_addr)) {
 				struct ip6_sf_list *psf;
 
-				spin_lock_bh(&mc->mca_lock);
 				for_each_psf_rcu(mc, psf) {
 					if (ipv6_addr_equal(&psf->sf_addr, src_addr))
 						break;
@@ -1013,11 +995,9 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 						mc->mca_sfcount[MCAST_EXCLUDE];
 				else
 					rv = mc->mca_sfcount[MCAST_EXCLUDE] != 0;
-				spin_unlock_bh(&mc->mca_lock);
 			} else
 				rv = true; /* don't filter unspecified source */
 		}
-		read_unlock_bh(&idev->lock);
 	}
 	rcu_read_unlock();
 	return rv;
@@ -1027,16 +1007,20 @@ static void mld_gq_start_work(struct inet6_dev *idev)
 {
 	unsigned long tv = prandom_u32() % idev->mc_maxdelay;
 
+	write_lock_bh(&idev->lock);
 	idev->mc_gq_running = 1;
 	if (!mod_delayed_work(mld_wq, &idev->mc_gq_work, msecs_to_jiffies(tv + 2)))
 		in6_dev_hold(idev);
+	write_unlock_bh(&idev->lock);
 }
 
 static void mld_gq_stop_work(struct inet6_dev *idev)
 {
+	write_lock_bh(&idev->lock);
 	idev->mc_gq_running = 0;
 	if (cancel_delayed_work(&idev->mc_gq_work))
 		__in6_dev_put(idev);
+	write_unlock_bh(&idev->lock);
 }
 
 static void mld_ifc_start_work(struct inet6_dev *idev, unsigned long delay)
@@ -1049,9 +1033,11 @@ static void mld_ifc_start_work(struct inet6_dev *idev, unsigned long delay)
 
 static void mld_ifc_stop_work(struct inet6_dev *idev)
 {
+	write_lock_bh(&idev->lock);
 	idev->mc_ifc_count = 0;
 	if (cancel_delayed_work(&idev->mc_ifc_work))
 		__in6_dev_put(idev);
+	write_unlock_bh(&idev->lock);
 }
 
 static void mld_dad_start_work(struct inet6_dev *idev, unsigned long delay)
@@ -1084,10 +1070,9 @@ static void mld_clear_delrec_stop_work(struct inet6_dev *idev)
 	write_unlock_bh(&idev->lock);
 }
 
-/*
- *	IGMP handling (alias multicast ICMPv6 messages)
+/* IGMP handling (alias multicast ICMPv6 messages)
+ * called with mca_lock
  */
-
 static void igmp6_group_queried(struct ifmcaddr6 *ma, unsigned long resptime)
 {
 	unsigned long delay = resptime;
@@ -1425,15 +1410,14 @@ int igmp6_event_query(struct sk_buff *skb)
 		return -EINVAL;
 	}
 
-	read_lock_bh(&idev->lock);
 	if (group_type == IPV6_ADDR_ANY) {
-		for (ma = idev->mc_list; ma; ma = ma->next) {
+		for_each_mc_rcu(idev, ma) {
 			spin_lock_bh(&ma->mca_lock);
 			igmp6_group_queried(ma, max_delay);
 			spin_unlock_bh(&ma->mca_lock);
 		}
 	} else {
-		for (ma = idev->mc_list; ma; ma = ma->next) {
+		for_each_mc_rcu(idev, ma) {
 			if (!ipv6_addr_equal(group, &ma->mca_addr))
 				continue;
 			spin_lock_bh(&ma->mca_lock);
@@ -1455,7 +1439,6 @@ int igmp6_event_query(struct sk_buff *skb)
 			break;
 		}
 	}
-	read_unlock_bh(&idev->lock);
 
 	return 0;
 }
@@ -1496,18 +1479,17 @@ int igmp6_event_report(struct sk_buff *skb)
 	 *	Cancel the work for this group
 	 */
 
-	read_lock_bh(&idev->lock);
-	for (ma = idev->mc_list; ma; ma = ma->next) {
+	for_each_mc_rcu(idev, ma) {
 		if (ipv6_addr_equal(&ma->mca_addr, &mld->mld_mca)) {
 			spin_lock(&ma->mca_lock);
 			if (cancel_delayed_work(&ma->mca_work))
 				refcount_dec(&ma->mca_refcnt);
-			ma->mca_flags &= ~(MAF_LAST_REPORTER|MAF_TIMER_RUNNING);
+			ma->mca_flags &= ~(MAF_LAST_REPORTER |
+					   MAF_TIMER_RUNNING);
 			spin_unlock(&ma->mca_lock);
 			break;
 		}
 	}
-	read_unlock_bh(&idev->lock);
 	return 0;
 }
 
@@ -1562,8 +1544,12 @@ mld_scount(struct ifmcaddr6 *pmc, int type, int gdeleted, int sdeleted)
 	int scount = 0;
 
 	for_each_psf_rtnl(pmc, psf) {
-		if (!is_in(pmc, psf, type, gdeleted, sdeleted))
+		spin_lock_bh(&pmc->mca_lock);
+		if (!is_in(pmc, psf, type, gdeleted, sdeleted)) {
+			spin_unlock_bh(&pmc->mca_lock);
 			continue;
+		}
+		spin_unlock_bh(&pmc->mca_lock);
 		scount++;
 	}
 	return scount;
@@ -1790,10 +1776,13 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 
 		*psf_list = rtnl_dereference(psf->sf_next);
 
+		spin_lock_bh(&pmc->mca_lock);
 		if (!is_in(pmc, psf, type, gdeleted, sdeleted) && !crsend) {
+			spin_unlock_bh(&pmc->mca_lock);
 			psf_prev = psf;
 			continue;
 		}
+		spin_unlock_bh(&pmc->mca_lock);
 
 		/* Based on RFC3810 6.1. Should not send source-list change
 		 * records when there is a filter mode change.
@@ -1805,8 +1794,11 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 			goto decrease_sf_crcount;
 
 		/* clear marks on query responses */
-		if (isquery)
+		if (isquery) {
+			spin_lock_bh(&pmc->mca_lock);
 			psf->sf_gsresp = 0;
+			spin_unlock_bh(&pmc->mca_lock);
+		}
 
 		if (AVAILABLE(skb) < sizeof(*psrc) +
 		    first*sizeof(struct mld2_grec)) {
@@ -1863,8 +1855,11 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ifmcaddr6 *pmc,
 	if (pgr)
 		pgr->grec_nsrcs = htons(scount);
 
-	if (isquery)
+	if (isquery) {
+		spin_lock_bh(&pmc->mca_lock);
 		pmc->mca_flags &= ~MAF_GSQUERY;	/* clear query state */
+		spin_unlock_bh(&pmc->mca_lock);
+	}
 	return skb;
 }
 
@@ -1873,29 +1868,24 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
 	struct sk_buff *skb = NULL;
 	int type;
 
-	read_lock_bh(&idev->lock);
 	if (!pmc) {
-		for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
+		for_each_mc_rtnl(idev, pmc) {
 			if (pmc->mca_noreport)
 				continue;
-			spin_lock_bh(&pmc->mca_lock);
 			if (pmc->mca_sfcount[MCAST_EXCLUDE])
 				type = MLD2_MODE_IS_EXCLUDE;
 			else
 				type = MLD2_MODE_IS_INCLUDE;
 			skb = add_grec(skb, pmc, type, 0, 0, 0);
-			spin_unlock_bh(&pmc->mca_lock);
 		}
 	} else {
-		spin_lock_bh(&pmc->mca_lock);
 		if (pmc->mca_sfcount[MCAST_EXCLUDE])
 			type = MLD2_MODE_IS_EXCLUDE;
 		else
 			type = MLD2_MODE_IS_INCLUDE;
 		skb = add_grec(skb, pmc, type, 0, 0, 0);
-		spin_unlock_bh(&pmc->mca_lock);
 	}
-	read_unlock_bh(&idev->lock);
+
 	if (skb)
 		mld_sendpack(skb);
 }
@@ -1929,8 +1919,6 @@ static void mld_send_cr(struct inet6_dev *idev)
 	struct sk_buff *skb = NULL;
 	int type, dtype;
 
-	read_lock_bh(&idev->lock);
-
 	/* deleted MCA's */
 	pmc_prev = NULL;
 	for (pmc = idev->mc_tomb; pmc; pmc = pmc_next) {
@@ -1965,8 +1953,7 @@ static void mld_send_cr(struct inet6_dev *idev)
 	}
 
 	/* change recs */
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
-		spin_lock_bh(&pmc->mca_lock);
+	for_each_mc_rtnl(idev, pmc) {
 		if (pmc->mca_sfcount[MCAST_EXCLUDE]) {
 			type = MLD2_BLOCK_OLD_SOURCES;
 			dtype = MLD2_ALLOW_NEW_SOURCES;
@@ -1986,9 +1973,8 @@ static void mld_send_cr(struct inet6_dev *idev)
 			skb = add_grec(skb, pmc, type, 0, 0, 0);
 			pmc->mca_crcount--;
 		}
-		spin_unlock_bh(&pmc->mca_lock);
 	}
-	read_unlock_bh(&idev->lock);
+
 	if (!skb)
 		return;
 	(void) mld_sendpack(skb);
@@ -2100,17 +2086,14 @@ static void mld_send_initial_cr(struct inet6_dev *idev)
 		return;
 
 	skb = NULL;
-	read_lock_bh(&idev->lock);
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
-		spin_lock_bh(&pmc->mca_lock);
+	for_each_mc_rtnl(idev, pmc) {
 		if (pmc->mca_sfcount[MCAST_EXCLUDE])
 			type = MLD2_CHANGE_TO_EXCLUDE;
 		else
 			type = MLD2_ALLOW_NEW_SOURCES;
 		skb = add_grec(skb, pmc, type, 0, 0, 1);
-		spin_unlock_bh(&pmc->mca_lock);
 	}
-	read_unlock_bh(&idev->lock);
+
 	if (skb)
 		mld_sendpack(skb);
 }
@@ -2207,24 +2190,19 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 
 	if (!idev)
 		return -ENODEV;
-	read_lock_bh(&idev->lock);
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
+
+	for_each_mc_rtnl(idev, pmc) {
 		if (ipv6_addr_equal(pmca, &pmc->mca_addr))
 			break;
 	}
-	if (!pmc) {
+	if (!pmc)
 		/* MCA not found?? bug */
-		read_unlock_bh(&idev->lock);
 		return -ESRCH;
-	}
-	spin_lock_bh(&pmc->mca_lock);
+
 	sf_markstate(pmc);
 	if (!delta) {
-		if (!pmc->mca_sfcount[sfmode]) {
-			spin_unlock_bh(&pmc->mca_lock);
-			read_unlock_bh(&idev->lock);
+		if (!pmc->mca_sfcount[sfmode])
 			return -EINVAL;
-		}
 		pmc->mca_sfcount[sfmode]--;
 	}
 	err = 0;
@@ -2243,14 +2221,15 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 		/* filter mode change */
 		pmc->mca_sfmode = MCAST_INCLUDE;
 		pmc->mca_crcount = idev->mc_qrv;
+		write_lock_bh(&idev->lock);
 		idev->mc_ifc_count = pmc->mca_crcount;
+		write_unlock_bh(&idev->lock);
 		for_each_psf_rtnl(pmc, psf)
 			psf->sf_crcount = 0;
 		mld_ifc_event(pmc->idev);
 	} else if (sf_setstate(pmc) || changerec)
 		mld_ifc_event(pmc->idev);
-	spin_unlock_bh(&pmc->mca_lock);
-	read_unlock_bh(&idev->lock);
+
 	return err;
 }
 
@@ -2269,7 +2248,7 @@ static int ip6_mc_add1_src(struct ifmcaddr6 *pmc, int sfmode,
 		psf_prev = psf;
 	}
 	if (!psf) {
-		psf = kzalloc(sizeof(*psf), GFP_ATOMIC);
+		psf = kzalloc(sizeof(*psf), GFP_KERNEL);
 		if (!psf)
 			return -ENOBUFS;
 
@@ -2346,7 +2325,7 @@ static int sf_setstate(struct ifmcaddr6 *pmc)
 				    &psf->sf_addr))
 					break;
 			if (!dpsf) {
-				dpsf = kmalloc(sizeof(*dpsf), GFP_ATOMIC);
+				dpsf = kmalloc(sizeof(*dpsf), GFP_KERNEL);
 				if (!dpsf)
 					continue;
 				*dpsf = *psf;
@@ -2373,17 +2352,14 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 
 	if (!idev)
 		return -ENODEV;
-	read_lock_bh(&idev->lock);
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
+
+	for_each_mc_rtnl(idev, pmc) {
 		if (ipv6_addr_equal(pmca, &pmc->mca_addr))
 			break;
 	}
-	if (!pmc) {
+	if (!pmc)
 		/* MCA not found?? bug */
-		read_unlock_bh(&idev->lock);
 		return -ESRCH;
-	}
-	spin_lock_bh(&pmc->mca_lock);
 
 	sf_markstate(pmc);
 	isexclude = pmc->mca_sfmode == MCAST_EXCLUDE;
@@ -2413,14 +2389,16 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 		/* else no filters; keep old mode for reports */
 
 		pmc->mca_crcount = idev->mc_qrv;
+		write_lock_bh(&idev->lock);
 		idev->mc_ifc_count = pmc->mca_crcount;
+		write_unlock_bh(&idev->lock);
 		for_each_psf_rtnl(pmc, psf)
 			psf->sf_crcount = 0;
 		mld_ifc_event(idev);
-	} else if (sf_setstate(pmc))
+	} else if (sf_setstate(pmc)) {
 		mld_ifc_event(idev);
-	spin_unlock_bh(&pmc->mca_lock);
-	read_unlock_bh(&idev->lock);
+	}
+
 	return err;
 }
 
@@ -2493,9 +2471,14 @@ static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
 static void igmp6_leave_group(struct ifmcaddr6 *ma)
 {
 	if (mld_in_v1_mode(ma->idev)) {
-		if (ma->mca_flags & MAF_LAST_REPORTER)
+		spin_lock_bh(&ma->mca_lock);
+		if (ma->mca_flags & MAF_LAST_REPORTER) {
+			spin_unlock_bh(&ma->mca_lock);
 			igmp6_send(&ma->mca_addr, ma->idev->dev,
 				ICMPV6_MGM_REDUCTION);
+		} else {
+			spin_unlock_bh(&ma->mca_lock);
+		}
 	} else {
 		mld_add_delrec(ma->idev, ma);
 		mld_ifc_event(ma->idev);
@@ -2508,10 +2491,12 @@ static void mld_gq_work(struct work_struct *work)
 					      struct inet6_dev,
 					      mc_gq_work);
 
-	idev->mc_gq_running = 0;
 	rtnl_lock();
 	mld_send_report(idev, NULL);
 	rtnl_unlock();
+	write_lock_bh(&idev->lock);
+	idev->mc_gq_running = 0;
+	write_unlock_bh(&idev->lock);
 	in6_dev_put(idev);
 }
 
@@ -2523,13 +2508,16 @@ static void mld_ifc_work(struct work_struct *work)
 
 	rtnl_lock();
 	mld_send_cr(idev);
+	rtnl_unlock();
+
+	write_lock_bh(&idev->lock);
 	if (idev->mc_ifc_count) {
 		idev->mc_ifc_count--;
 		if (idev->mc_ifc_count)
 			mld_ifc_start_work(idev,
 					   unsolicited_report_interval(idev));
 	}
-	rtnl_unlock();
+	write_unlock_bh(&idev->lock);
 	in6_dev_put(idev);
 }
 
@@ -2537,8 +2525,11 @@ static void mld_ifc_event(struct inet6_dev *idev)
 {
 	if (mld_in_v1_mode(idev))
 		return;
+
+	write_lock_bh(&idev->lock);
 	idev->mc_ifc_count = idev->mc_qrv;
 	mld_ifc_start_work(idev, 1);
+	write_unlock_bh(&idev->lock);
 }
 
 static void mld_mca_work(struct work_struct *work)
@@ -2568,10 +2559,8 @@ void ipv6_mc_unmap(struct inet6_dev *idev)
 
 	/* Install multicast list, except for all-nodes (already installed) */
 
-	read_lock_bh(&idev->lock);
-	for (i = idev->mc_list; i; i = i->next)
+	for_each_mc_rtnl(idev, i)
 		igmp6_group_dropped(i);
-	read_unlock_bh(&idev->lock);
 }
 
 void ipv6_mc_remap(struct inet6_dev *idev)
@@ -2587,9 +2576,7 @@ void ipv6_mc_down(struct inet6_dev *idev)
 
 	/* Withdraw multicast list */
 
-	read_lock_bh(&idev->lock);
-
-	for (i = idev->mc_list; i; i = i->next)
+	for_each_mc_rtnl(idev, i)
 		igmp6_group_dropped(i);
 
 	/* Should stop work after group drop. or we will
@@ -2598,7 +2585,6 @@ void ipv6_mc_down(struct inet6_dev *idev)
 	mld_ifc_stop_work(idev);
 	mld_gq_stop_work(idev);
 	mld_dad_stop_work(idev);
-	read_unlock_bh(&idev->lock);
 	mld_clear_delrec_stop_work(idev);
 }
 
@@ -2619,20 +2605,19 @@ void ipv6_mc_up(struct inet6_dev *idev)
 
 	/* Install multicast list, except for all-nodes (already installed) */
 
-	read_lock_bh(&idev->lock);
 	ipv6_mc_reset(idev);
-	for (i = idev->mc_list; i; i = i->next) {
+	for_each_mc_rtnl(idev, i) {
 		mld_del_delrec(idev, i);
 		igmp6_group_added(i);
 	}
-	read_unlock_bh(&idev->lock);
 }
 
 /* IPv6 device initialization. */
 
 void ipv6_mc_init_dev(struct inet6_dev *idev)
 {
-	write_lock_bh(&idev->lock);
+	ASSERT_RTNL();
+
 	idev->mc_gq_running = 0;
 	INIT_DELAYED_WORK(&idev->mc_gq_work, mld_gq_work);
 	idev->mc_tomb = NULL;
@@ -2641,7 +2626,6 @@ void ipv6_mc_init_dev(struct inet6_dev *idev)
 	INIT_DELAYED_WORK(&idev->mc_dad_work, mld_dad_work);
 	INIT_DELAYED_WORK(&idev->mc_delrec_work, mld_clear_delrec_work);
 	ipv6_mc_reset(idev);
-	write_unlock_bh(&idev->lock);
 }
 
 /*
@@ -2652,6 +2636,8 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *i;
 
+	ASSERT_RTNL();
+
 	/* Deactivate works */
 	ipv6_mc_down(idev);
 	mld_clear_delrec(idev);
@@ -2666,16 +2652,12 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 	if (idev->cnf.forwarding)
 		__ipv6_dev_mc_dec(idev, &in6addr_linklocal_allrouters);
 
-	write_lock_bh(&idev->lock);
-	while ((i = idev->mc_list) != NULL) {
-		idev->mc_list = i->next;
+	while ((i = rtnl_dereference(idev->mc_list)) != NULL) {
+		rcu_assign_pointer(idev->mc_list, rtnl_dereference(i->next));
 
-		write_unlock_bh(&idev->lock);
 		ip6_mc_clear_src(i);
 		ma_put(i);
-		write_lock_bh(&idev->lock);
 	}
-	write_unlock_bh(&idev->lock);
 }
 
 static void ipv6_mc_rejoin_groups(struct inet6_dev *idev)
@@ -2685,12 +2667,11 @@ static void ipv6_mc_rejoin_groups(struct inet6_dev *idev)
 	ASSERT_RTNL();
 
 	if (mld_in_v1_mode(idev)) {
-		read_lock_bh(&idev->lock);
-		for (pmc = idev->mc_list; pmc; pmc = pmc->next)
+		for_each_mc_rtnl(idev, pmc)
 			igmp6_join_group(pmc);
-		read_unlock_bh(&idev->lock);
-	} else
+	} else {
 		mld_send_report(idev, NULL);
+	}
 }
 
 static int ipv6_mc_netdev_event(struct notifier_block *this,
@@ -2737,13 +2718,11 @@ static inline struct ifmcaddr6 *igmp6_mc_get_first(struct seq_file *seq)
 		idev = __in6_dev_get(state->dev);
 		if (!idev)
 			continue;
-		read_lock_bh(&idev->lock);
-		im = idev->mc_list;
+		im = rcu_dereference(idev->mc_list);
 		if (im) {
 			state->idev = idev;
 			break;
 		}
-		read_unlock_bh(&idev->lock);
 	}
 	return im;
 }
@@ -2752,11 +2731,8 @@ static struct ifmcaddr6 *igmp6_mc_get_next(struct seq_file *seq, struct ifmcaddr
 {
 	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
 
-	im = im->next;
+	im = rcu_dereference(im->next);
 	while (!im) {
-		if (likely(state->idev))
-			read_unlock_bh(&state->idev->lock);
-
 		state->dev = next_net_device_rcu(state->dev);
 		if (!state->dev) {
 			state->idev = NULL;
@@ -2765,8 +2741,7 @@ static struct ifmcaddr6 *igmp6_mc_get_next(struct seq_file *seq, struct ifmcaddr
 		state->idev = __in6_dev_get(state->dev);
 		if (!state->idev)
 			continue;
-		read_lock_bh(&state->idev->lock);
-		im = state->idev->mc_list;
+		im = rcu_dereference(state->idev->mc_list);
 	}
 	return im;
 }
@@ -2800,10 +2775,9 @@ static void igmp6_mc_seq_stop(struct seq_file *seq, void *v)
 {
 	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
 
-	if (likely(state->idev)) {
-		read_unlock_bh(&state->idev->lock);
+	if (likely(state->idev))
 		state->idev = NULL;
-	}
+
 	state->dev = NULL;
 	rcu_read_unlock();
 }
@@ -2813,13 +2787,15 @@ static int igmp6_mc_seq_show(struct seq_file *seq, void *v)
 	struct ifmcaddr6 *im = (struct ifmcaddr6 *)v;
 	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
 
+	spin_lock_bh(&im->mca_lock);
 	seq_printf(seq,
 		   "%-4d %-15s %pi6 %5d %08X %ld\n",
 		   state->dev->ifindex, state->dev->name,
 		   &im->mca_addr,
 		   im->mca_users, im->mca_flags,
-		   (im->mca_flags&MAF_TIMER_RUNNING) ?
+		   (im->mca_flags & MAF_TIMER_RUNNING) ?
 		   jiffies_to_clock_t(im->mca_work.timer.expires - jiffies) : 0);
+	spin_unlock_bh(&im->mca_lock);
 	return 0;
 }
 
@@ -2850,22 +2826,19 @@ static inline struct ip6_sf_list *igmp6_mcf_get_first(struct seq_file *seq)
 	state->im = NULL;
 	for_each_netdev_rcu(net, state->dev) {
 		struct inet6_dev *idev;
+
 		idev = __in6_dev_get(state->dev);
 		if (unlikely(idev == NULL))
 			continue;
-		read_lock_bh(&idev->lock);
-		im = idev->mc_list;
+		im = rcu_dereference(idev->mc_list);
 		if (likely(im)) {
-			spin_lock_bh(&im->mca_lock);
 			psf = rcu_dereference(im->mca_sources);
 			if (likely(psf)) {
 				state->im = im;
 				state->idev = idev;
 				break;
 			}
-			spin_unlock_bh(&im->mca_lock);
 		}
-		read_unlock_bh(&idev->lock);
 	}
 	return psf;
 }
@@ -2876,12 +2849,8 @@ static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq, struct ip6_s
 
 	psf = rcu_dereference(psf->sf_next);
 	while (!psf) {
-		spin_unlock_bh(&state->im->mca_lock);
-		state->im = state->im->next;
+		state->im = rcu_dereference(state->im->next);
 		while (!state->im) {
-			if (likely(state->idev))
-				read_unlock_bh(&state->idev->lock);
-
 			state->dev = next_net_device_rcu(state->dev);
 			if (!state->dev) {
 				state->idev = NULL;
@@ -2890,12 +2859,10 @@ static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq, struct ip6_s
 			state->idev = __in6_dev_get(state->dev);
 			if (!state->idev)
 				continue;
-			read_lock_bh(&state->idev->lock);
-			state->im = state->idev->mc_list;
+			state->im = rcu_dereference(state->idev->mc_list);
 		}
 		if (!state->im)
 			break;
-		spin_lock_bh(&state->im->mca_lock);
 		psf = rcu_dereference(state->im->mca_sources);
 	}
 out:
@@ -2933,14 +2900,12 @@ static void igmp6_mcf_seq_stop(struct seq_file *seq, void *v)
 	__releases(RCU)
 {
 	struct igmp6_mcf_iter_state *state = igmp6_mcf_seq_private(seq);
-	if (likely(state->im)) {
-		spin_unlock_bh(&state->im->mca_lock);
+	if (likely(state->im))
 		state->im = NULL;
-	}
-	if (likely(state->idev)) {
-		read_unlock_bh(&state->idev->lock);
+
+	if (likely(state->idev))
 		state->idev = NULL;
-	}
+
 	state->dev = NULL;
 	rcu_read_unlock();
 }
@@ -3021,6 +2986,7 @@ static int __net_init igmp6_net_init(struct net *net)
 	}
 
 	inet6_sk(net->ipv6.igmp_sk)->hop_limit = 1;
+	net->ipv6.igmp_sk->sk_allocation = GFP_KERNEL;
 
 	err = inet_ctl_sock_create(&net->ipv6.mc_autojoin_sk, PF_INET6,
 				   SOCK_RAW, IPPROTO_ICMPV6, net);
-- 
2.17.1

