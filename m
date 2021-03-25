Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95CE349695
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCYQSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhCYQRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:17:37 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5BBC06174A;
        Thu, 25 Mar 2021 09:17:37 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h25so2299778pgm.3;
        Thu, 25 Mar 2021 09:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=itA6cBW70QcpHwdijhOyiNQnZri5yCqO9XV9od2wLUI=;
        b=nuAyTbo/0QGYPLwU2sUTwyV1p7+pQkSiMQXGrUKywcKpwwUpFV2nwbNq7fFnE6F1J9
         lrbQfVW60751mZkw3ZCOA/IMPzLNcMPOG6YfRei3nynxF9NCuJ8eZeeQZwHRvEhJ/3QV
         8x6m90RVm8/yOsqafWOJcmuN61ybP32ZHEKvavNgypUWRWO0P0adD9ot2KJeeVn0w6cg
         UX1DkC8F13H3RH5KxHPlZpbOc+RLrDTCkKvjuKr4bTAZwgu6Dsa8iqyKfc0ttTzDtNtl
         9tHu7O1hAZDLIMNnBuxdRPiLzl4KV9/2Ckp8L430oobAj8fLCerkiFxgO/esoMe/iany
         fi2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=itA6cBW70QcpHwdijhOyiNQnZri5yCqO9XV9od2wLUI=;
        b=Tya4NwavWr6ugkgf2HPnMeJiH2NjI+5rCAv8r2i9mNVP0uKNgftj7lon/9dYfiNuOZ
         yaqH6Y0bWpHVK4srhJO7dZfIJjdGWJg7DGPq2rG041RCJMlsV7KSCXyvd4oyPZR2crZ+
         NaeQIr6h0xA5CfboHiIeEyvqT4XR+gshGnhf9pcuLwDgbP2ZNw1PlP72EDxPPXu3gVC8
         xlfcdUV8DvVAsCPE7mnglJjOOcqiVuA+T4g9Xn8oJuU7hvUZz6xdgS9OJgKSO1Qg0Oc6
         nvuaJ0UGGiOzyZh94JUp7N4EDGH6Oj51rRdI7HCyC9DXxoaz8Dw9c07my2lrSxeTu8Ge
         l13g==
X-Gm-Message-State: AOAM533PcZrv2Q6xnaY5ucSZHDMKxWU+rJXz1z/8RnP+XZVGR+yUvk1Z
        6XGMwPJFlYAtgr2RXtbnSTyB1Vu2k05xpA==
X-Google-Smtp-Source: ABdhPJw+3NiGilNghfaGv4PGOp1CinMiWLSeLry0Y6+AVyQYUPPBuq1OmtP5PNnGvi4yNhoMzQfQ6w==
X-Received: by 2002:a62:1b88:0:b029:1fb:d3d0:343a with SMTP id b130-20020a621b880000b02901fbd3d0343amr8681389pfb.76.1616689056267;
        Thu, 25 Mar 2021 09:17:36 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id s15sm6416917pgs.28.2021.03.25.09.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 09:17:35 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     ap420073@gmail.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-s390@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH net-next v3 5/7] mld: convert ifmcaddr6 to RCU
Date:   Thu, 25 Mar 2021 16:16:55 +0000
Message-Id: <20210325161657.10517-6-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210325161657.10517-1-ap420073@gmail.com>
References: <20210325161657.10517-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ifmcaddr6 has been protected by inet6_dev->lock(rwlock) so that
the critical section is atomic context. In order to switch this context,
changing locking is needed. The ifmcaddr6 actually already protected by
RTNL So if it's converted to use RCU, its control path context can be
switched to sleepable.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v2 -> v3:
 - Fix sparse warnings because of rcu annotation
 - Do not use mca_lock
v1 -> v2:
 - Separated from previous big one patch.

 drivers/s390/net/qeth_l3_main.c |   6 +-
 include/net/if_inet6.h          |   7 +-
 net/batman-adv/multicast.c      |   6 +-
 net/ipv6/addrconf.c             |   9 +-
 net/ipv6/addrconf_core.c        |   2 +-
 net/ipv6/af_inet6.c             |   2 +-
 net/ipv6/mcast.c                | 296 +++++++++++++-------------------
 7 files changed, 140 insertions(+), 188 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 35b42275a06c..d308ff744a29 100644
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
index 7875a3208426..521158e05c18 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -115,7 +115,7 @@ struct ip6_sf_list {
 struct ifmcaddr6 {
 	struct in6_addr		mca_addr;
 	struct inet6_dev	*idev;
-	struct ifmcaddr6	*next;
+	struct ifmcaddr6	__rcu *next;
 	struct ip6_sf_list	__rcu *mca_sources;
 	struct ip6_sf_list	__rcu *mca_tomb;
 	unsigned int		mca_sfmode;
@@ -128,6 +128,7 @@ struct ifmcaddr6 {
 	spinlock_t		mca_lock;
 	unsigned long		mca_cstamp;
 	unsigned long		mca_tstamp;
+	struct rcu_head		rcu;
 };
 
 /* Anycast stuff */
@@ -166,8 +167,8 @@ struct inet6_dev {
 
 	struct list_head	addr_list;
 
-	struct ifmcaddr6	*mc_list;
-	struct ifmcaddr6	*mc_tomb;
+	struct ifmcaddr6	__rcu *mc_list;
+	struct ifmcaddr6	__rcu *mc_tomb;
 
 	unsigned char		mc_qrv;		/* Query Robustness Variable */
 	unsigned char		mc_gq_running;
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
index 802f5111805a..3c9bacffc9c3 100644
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
index bc0fb4815c97..75541cf53153 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -112,6 +112,11 @@ int sysctl_mld_qrv __read_mostly = MLD_QRV_DEFAULT;
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
@@ -132,6 +137,21 @@ int sysctl_mld_qrv __read_mostly = MLD_QRV_DEFAULT;
 	     psf;						\
 	     psf = rtnl_dereference(psf->sf_next))
 
+#define for_each_mc_rtnl(idev, mc)				\
+	for (mc = rtnl_dereference((idev)->mc_list);		\
+	     mc;						\
+	     mc = rtnl_dereference(mc->next))
+
+#define for_each_mc_rcu(idev, mc)				\
+	for (mc = rcu_dereference((idev)->mc_list);             \
+	     mc;                                                \
+	     mc = rcu_dereference(mc->next))
+
+#define for_each_mc_tomb(idev, mc)				\
+	for (mc = rtnl_dereference((idev)->mc_tomb);		\
+	     mc;						\
+	     mc = rtnl_dereference(mc->next))
+
 static int unsolicited_report_interval(struct inet6_dev *idev)
 {
 	int iv;
@@ -158,15 +178,11 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
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
 
@@ -268,10 +284,9 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, const struct in6_addr *addr)
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
@@ -283,19 +298,17 @@ static struct inet6_dev *ip6_mc_find_dev_rcu(struct net *net,
 			dev = rt->dst.dev;
 			ip6_rt_put(rt);
 		}
-	} else
-		dev = dev_get_by_index_rcu(net, ifindex);
+	} else {
+		dev = __dev_get_by_index(net, ifindex);
+	}
 
 	if (!dev)
 		return NULL;
 	idev = __in6_dev_get(dev);
 	if (!idev)
 		return NULL;
-	read_lock_bh(&idev->lock);
-	if (idev->dead) {
-		read_unlock_bh(&idev->lock);
+	if (idev->dead)
 		return NULL;
-	}
 	return idev;
 }
 
@@ -357,16 +370,13 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
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
@@ -459,8 +469,6 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	/* update the interface list */
 	ip6_mc_add_src(idev, group, omode, 1, source, 1);
 done:
-	read_unlock_bh(&idev->lock);
-	rcu_read_unlock();
 	if (leavegroup)
 		err = ipv6_sock_mc_drop(sk, pgsr->gsr_interface, group);
 	return err;
@@ -486,13 +494,9 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	    gsf->gf_fmode != MCAST_EXCLUDE)
 		return -EINVAL;
 
-	rcu_read_lock();
-	idev = ip6_mc_find_dev_rcu(net, group, gsf->gf_interface);
-
-	if (!idev) {
-		rcu_read_unlock();
+	idev = ip6_mc_find_dev_rtnl(net, group, gsf->gf_interface);
+	if (!idev)
 		return -ENODEV;
-	}
 
 	err = 0;
 
@@ -501,7 +505,7 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 		goto done;
 	}
 
-	for_each_pmc_rcu(inet6, pmc) {
+	for_each_pmc_rtnl(inet6, pmc) {
 		if (pmc->ifindex != gsf->gf_interface)
 			continue;
 		if (ipv6_addr_equal(&pmc->addr, group))
@@ -548,8 +552,6 @@ int ip6_mc_msfilter(struct sock *sk, struct group_filter *gsf,
 	pmc->sfmode = gsf->gf_fmode;
 	err = 0;
 done:
-	read_unlock_bh(&idev->lock);
-	rcu_read_unlock();
 	if (leavegroup)
 		err = ipv6_sock_mc_drop(sk, gsf->gf_interface, group);
 	return err;
@@ -571,13 +573,9 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	if (!ipv6_addr_is_multicast(group))
 		return -EINVAL;
 
-	rcu_read_lock();
-	idev = ip6_mc_find_dev_rcu(net, group, gsf->gf_interface);
-
-	if (!idev) {
-		rcu_read_unlock();
+	idev = ip6_mc_find_dev_rtnl(net, group, gsf->gf_interface);
+	if (!idev)
 		return -ENODEV;
-	}
 
 	err = -EADDRNOTAVAIL;
 	/* changes to the ipv6_mc_list require the socket lock and
@@ -585,19 +583,18 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 	 * so reading the list is safe.
 	 */
 
-	for_each_pmc_rcu(inet6, pmc) {
+	for_each_pmc_rtnl(inet6, pmc) {
 		if (pmc->ifindex != gsf->gf_interface)
 			continue;
 		if (ipv6_addr_equal(group, &pmc->addr))
 			break;
 	}
 	if (!pmc)		/* must have a prior join */
-		goto done;
+		return err;
+
 	gsf->gf_fmode = pmc->sfmode;
 	psl = rtnl_dereference(pmc->sflist);
 	count = psl ? psl->sl_count : 0;
-	read_unlock_bh(&idev->lock);
-	rcu_read_unlock();
 
 	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
 	gsf->gf_numsrc = count;
@@ -614,10 +611,6 @@ int ip6_mc_msfget(struct sock *sk, struct group_filter *gsf,
 			return -EFAULT;
 	}
 	return 0;
-done:
-	read_unlock_bh(&idev->lock);
-	rcu_read_unlock();
-	return err;
 }
 
 bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
@@ -761,8 +754,8 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	}
 	spin_unlock_bh(&im->mca_lock);
 
-	pmc->next = idev->mc_tomb;
-	idev->mc_tomb = pmc;
+	rcu_assign_pointer(pmc->next, idev->mc_tomb);
+	rcu_assign_pointer(idev->mc_tomb, pmc);
 }
 
 static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
@@ -772,16 +765,16 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	struct ifmcaddr6 *pmc, *pmc_prev;
 
 	pmc_prev = NULL;
-	for (pmc = idev->mc_tomb; pmc; pmc = pmc->next) {
+	for_each_mc_tomb(idev, pmc) {
 		if (ipv6_addr_equal(&pmc->mca_addr, pmca))
 			break;
 		pmc_prev = pmc;
 	}
 	if (pmc) {
 		if (pmc_prev)
-			pmc_prev->next = pmc->next;
+			rcu_assign_pointer(pmc_prev->next, pmc->next);
 		else
-			idev->mc_tomb = pmc->next;
+			rcu_assign_pointer(idev->mc_tomb, pmc->next);
 	}
 
 	spin_lock_bh(&im->mca_lock);
@@ -804,7 +797,7 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 		}
 		in6_dev_put(pmc->idev);
 		ip6_mc_clear_src(pmc);
-		kfree(pmc);
+		kfree_rcu(pmc, rcu);
 	}
 	spin_unlock_bh(&im->mca_lock);
 }
@@ -813,19 +806,18 @@ static void mld_clear_delrec(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *pmc, *nextpmc;
 
-	pmc = idev->mc_tomb;
-	idev->mc_tomb = NULL;
+	pmc = rtnl_dereference(idev->mc_tomb);
+	RCU_INIT_POINTER(idev->mc_tomb, NULL);
 
 	for (; pmc; pmc = nextpmc) {
-		nextpmc = pmc->next;
+		nextpmc = rtnl_dereference(pmc->next);
 		ip6_mc_clear_src(pmc);
 		in6_dev_put(pmc->idev);
-		kfree(pmc);
+		kfree_rcu(pmc, rcu);
 	}
 
 	/* clear dead sources, too */
-	read_lock_bh(&idev->lock);
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
+	for_each_mc_rtnl(idev, pmc) {
 		struct ip6_sf_list *psf, *psf_next;
 
 		spin_lock_bh(&pmc->mca_lock);
@@ -837,7 +829,6 @@ static void mld_clear_delrec(struct inet6_dev *idev)
 			kfree_rcu(psf, rcu);
 		}
 	}
-	read_unlock_bh(&idev->lock);
 }
 
 static void mca_get(struct ifmcaddr6 *mc)
@@ -849,7 +840,7 @@ static void ma_put(struct ifmcaddr6 *mc)
 {
 	if (refcount_dec_and_test(&mc->mca_refcnt)) {
 		in6_dev_put(mc->idev);
-		kfree(mc);
+		kfree_rcu(mc, rcu);
 	}
 }
 
@@ -900,17 +891,14 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
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
@@ -919,19 +907,14 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 
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
@@ -950,16 +933,16 @@ EXPORT_SYMBOL(ipv6_dev_mc_inc);
  */
 int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 {
-	struct ifmcaddr6 *ma, **map;
+	struct ifmcaddr6 *ma, __rcu **map;
 
 	ASSERT_RTNL();
 
-	write_lock_bh(&idev->lock);
-	for (map = &idev->mc_list; (ma = *map) != NULL; map = &ma->next) {
+	for (map = &idev->mc_list;
+	     (ma = rtnl_dereference(*map));
+	     map = &ma->next) {
 		if (ipv6_addr_equal(&ma->mca_addr, addr)) {
 			if (--ma->mca_users == 0) {
 				*map = ma->next;
-				write_unlock_bh(&idev->lock);
 
 				igmp6_group_dropped(ma);
 				ip6_mc_clear_src(ma);
@@ -967,11 +950,9 @@ int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
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
@@ -1006,8 +987,7 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 	rcu_read_lock();
 	idev = __in6_dev_get(dev);
 	if (idev) {
-		read_lock_bh(&idev->lock);
-		for (mc = idev->mc_list; mc; mc = mc->next) {
+		for_each_mc_rcu(idev, mc) {
 			if (ipv6_addr_equal(&mc->mca_addr, group))
 				break;
 		}
@@ -1030,7 +1010,6 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 			} else
 				rv = true; /* don't filter unspecified source */
 		}
-		read_unlock_bh(&idev->lock);
 	}
 	rcu_read_unlock();
 	return rv;
@@ -1082,9 +1061,8 @@ static void mld_dad_stop_work(struct inet6_dev *idev)
 }
 
 /*
- *	IGMP handling (alias multicast ICMPv6 messages)
+ * IGMP handling (alias multicast ICMPv6 messages)
  */
-
 static void igmp6_group_queried(struct ifmcaddr6 *ma, unsigned long resptime)
 {
 	unsigned long delay = resptime;
@@ -1422,15 +1400,14 @@ int igmp6_event_query(struct sk_buff *skb)
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
@@ -1452,7 +1429,6 @@ int igmp6_event_query(struct sk_buff *skb)
 			break;
 		}
 	}
-	read_unlock_bh(&idev->lock);
 
 	return 0;
 }
@@ -1493,18 +1469,17 @@ int igmp6_event_report(struct sk_buff *skb)
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
 
@@ -1868,9 +1843,8 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
 	struct sk_buff *skb = NULL;
 	int type;
 
-	read_lock_bh(&idev->lock);
 	if (!pmc) {
-		for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
+		for_each_mc_rtnl(idev, pmc) {
 			if (pmc->mca_flags & MAF_NOREPORT)
 				continue;
 			spin_lock_bh(&pmc->mca_lock);
@@ -1890,7 +1864,6 @@ static void mld_send_report(struct inet6_dev *idev, struct ifmcaddr6 *pmc)
 		skb = add_grec(skb, pmc, type, 0, 0, 0);
 		spin_unlock_bh(&pmc->mca_lock);
 	}
-	read_unlock_bh(&idev->lock);
 	if (skb)
 		mld_sendpack(skb);
 }
@@ -1927,12 +1900,12 @@ static void mld_send_cr(struct inet6_dev *idev)
 	struct sk_buff *skb = NULL;
 	int type, dtype;
 
-	read_lock_bh(&idev->lock);
-
 	/* deleted MCA's */
 	pmc_prev = NULL;
-	for (pmc = idev->mc_tomb; pmc; pmc = pmc_next) {
-		pmc_next = pmc->next;
+	for (pmc = rtnl_dereference(idev->mc_tomb);
+	     pmc;
+	     pmc = pmc_next) {
+		pmc_next = rtnl_dereference(pmc->next);
 		if (pmc->mca_sfmode == MCAST_INCLUDE) {
 			type = MLD2_BLOCK_OLD_SOURCES;
 			dtype = MLD2_BLOCK_OLD_SOURCES;
@@ -1954,17 +1927,17 @@ static void mld_send_cr(struct inet6_dev *idev)
 		    !rcu_access_pointer(pmc->mca_tomb) &&
 		    !rcu_access_pointer(pmc->mca_sources)) {
 			if (pmc_prev)
-				pmc_prev->next = pmc_next;
+				rcu_assign_pointer(pmc_prev->next, pmc_next);
 			else
-				idev->mc_tomb = pmc_next;
+				rcu_assign_pointer(idev->mc_tomb, pmc_next);
 			in6_dev_put(pmc->idev);
-			kfree(pmc);
+			kfree_rcu(pmc, rcu);
 		} else
 			pmc_prev = pmc;
 	}
 
 	/* change recs */
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
+	for_each_mc_rtnl(idev, pmc) {
 		spin_lock_bh(&pmc->mca_lock);
 		if (pmc->mca_sfcount[MCAST_EXCLUDE]) {
 			type = MLD2_BLOCK_OLD_SOURCES;
@@ -1987,7 +1960,6 @@ static void mld_send_cr(struct inet6_dev *idev)
 		}
 		spin_unlock_bh(&pmc->mca_lock);
 	}
-	read_unlock_bh(&idev->lock);
 	if (!skb)
 		return;
 	(void) mld_sendpack(skb);
@@ -2099,8 +2071,7 @@ static void mld_send_initial_cr(struct inet6_dev *idev)
 		return;
 
 	skb = NULL;
-	read_lock_bh(&idev->lock);
-	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
+	for_each_mc_rtnl(idev, pmc) {
 		spin_lock_bh(&pmc->mca_lock);
 		if (pmc->mca_sfcount[MCAST_EXCLUDE])
 			type = MLD2_CHANGE_TO_EXCLUDE;
@@ -2109,7 +2080,6 @@ static void mld_send_initial_cr(struct inet6_dev *idev)
 		skb = add_grec(skb, pmc, type, 0, 0, 1);
 		spin_unlock_bh(&pmc->mca_lock);
 	}
-	read_unlock_bh(&idev->lock);
 	if (skb)
 		mld_sendpack(skb);
 }
@@ -2132,7 +2102,9 @@ static void mld_dad_work(struct work_struct *work)
 					      struct inet6_dev,
 					      mc_dad_work);
 
+	rtnl_lock();
 	mld_send_initial_cr(idev);
+	rtnl_unlock();
 	if (idev->mc_dad_count) {
 		idev->mc_dad_count--;
 		if (idev->mc_dad_count)
@@ -2194,24 +2166,22 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 
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
-		/* MCA not found?? bug */
-		read_unlock_bh(&idev->lock);
+	if (!pmc)
 		return -ESRCH;
-	}
 	spin_lock_bh(&pmc->mca_lock);
+
 	sf_markstate(pmc);
 	if (!delta) {
 		if (!pmc->mca_sfcount[sfmode]) {
 			spin_unlock_bh(&pmc->mca_lock);
-			read_unlock_bh(&idev->lock);
 			return -EINVAL;
 		}
+
 		pmc->mca_sfcount[sfmode]--;
 	}
 	err = 0;
@@ -2237,7 +2207,6 @@ static int ip6_mc_del_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 	} else if (sf_setstate(pmc) || changerec)
 		mld_ifc_event(pmc->idev);
 	spin_unlock_bh(&pmc->mca_lock);
-	read_unlock_bh(&idev->lock);
 	return err;
 }
 
@@ -2363,16 +2332,13 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 
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
-		/* MCA not found?? bug */
-		read_unlock_bh(&idev->lock);
+	if (!pmc)
 		return -ESRCH;
-	}
 	spin_lock_bh(&pmc->mca_lock);
 
 	sf_markstate(pmc);
@@ -2407,10 +2373,10 @@ static int ip6_mc_add_src(struct inet6_dev *idev, const struct in6_addr *pmca,
 		for_each_psf_rtnl(pmc, psf)
 			psf->sf_crcount = 0;
 		mld_ifc_event(idev);
-	} else if (sf_setstate(pmc))
+	} else if (sf_setstate(pmc)) {
 		mld_ifc_event(idev);
+	}
 	spin_unlock_bh(&pmc->mca_lock);
-	read_unlock_bh(&idev->lock);
 	return err;
 }
 
@@ -2485,9 +2451,10 @@ static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
 static void igmp6_leave_group(struct ifmcaddr6 *ma)
 {
 	if (mld_in_v1_mode(ma->idev)) {
-		if (ma->mca_flags & MAF_LAST_REPORTER)
+		if (ma->mca_flags & MAF_LAST_REPORTER) {
 			igmp6_send(&ma->mca_addr, ma->idev->dev,
 				ICMPV6_MGM_REDUCTION);
+		}
 	} else {
 		mld_add_delrec(ma->idev, ma);
 		mld_ifc_event(ma->idev);
@@ -2500,8 +2467,12 @@ static void mld_gq_work(struct work_struct *work)
 					      struct inet6_dev,
 					      mc_gq_work);
 
-	idev->mc_gq_running = 0;
+	rtnl_lock();
 	mld_send_report(idev, NULL);
+	rtnl_unlock();
+
+	idev->mc_gq_running = 0;
+
 	in6_dev_put(idev);
 }
 
@@ -2511,7 +2482,10 @@ static void mld_ifc_work(struct work_struct *work)
 					      struct inet6_dev,
 					      mc_ifc_work);
 
+	rtnl_lock();
 	mld_send_cr(idev);
+	rtnl_unlock();
+
 	if (idev->mc_ifc_count) {
 		idev->mc_ifc_count--;
 		if (idev->mc_ifc_count)
@@ -2525,6 +2499,7 @@ static void mld_ifc_event(struct inet6_dev *idev)
 {
 	if (mld_in_v1_mode(idev))
 		return;
+
 	idev->mc_ifc_count = idev->mc_qrv;
 	mld_ifc_start_work(idev, 1);
 }
@@ -2534,10 +2509,12 @@ static void mld_mca_work(struct work_struct *work)
 	struct ifmcaddr6 *ma = container_of(to_delayed_work(work),
 					    struct ifmcaddr6, mca_work);
 
+	rtnl_lock();
 	if (mld_in_v1_mode(ma->idev))
 		igmp6_send(&ma->mca_addr, ma->idev->dev, ICMPV6_MGM_REPORT);
 	else
 		mld_send_report(ma->idev, ma);
+	rtnl_unlock();
 
 	spin_lock_bh(&ma->mca_lock);
 	ma->mca_flags |=  MAF_LAST_REPORTER;
@@ -2554,10 +2531,8 @@ void ipv6_mc_unmap(struct inet6_dev *idev)
 
 	/* Install multicast list, except for all-nodes (already installed) */
 
-	read_lock_bh(&idev->lock);
-	for (i = idev->mc_list; i; i = i->next)
+	for_each_mc_rtnl(idev, i)
 		igmp6_group_dropped(i);
-	read_unlock_bh(&idev->lock);
 }
 
 void ipv6_mc_remap(struct inet6_dev *idev)
@@ -2572,10 +2547,7 @@ void ipv6_mc_down(struct inet6_dev *idev)
 	struct ifmcaddr6 *i;
 
 	/* Withdraw multicast list */
-
-	read_lock_bh(&idev->lock);
-
-	for (i = idev->mc_list; i; i = i->next)
+	for_each_mc_rtnl(idev, i)
 		igmp6_group_dropped(i);
 
 	/* Should stop work after group drop. or we will
@@ -2584,7 +2556,6 @@ void ipv6_mc_down(struct inet6_dev *idev)
 	mld_ifc_stop_work(idev);
 	mld_gq_stop_work(idev);
 	mld_dad_stop_work(idev);
-	read_unlock_bh(&idev->lock);
 }
 
 static void ipv6_mc_reset(struct inet6_dev *idev)
@@ -2604,28 +2575,24 @@ void ipv6_mc_up(struct inet6_dev *idev)
 
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
 	idev->mc_gq_running = 0;
 	INIT_DELAYED_WORK(&idev->mc_gq_work, mld_gq_work);
-	idev->mc_tomb = NULL;
+	RCU_INIT_POINTER(idev->mc_tomb, NULL);
 	idev->mc_ifc_count = 0;
 	INIT_DELAYED_WORK(&idev->mc_ifc_work, mld_ifc_work);
 	INIT_DELAYED_WORK(&idev->mc_dad_work, mld_dad_work);
 	ipv6_mc_reset(idev);
-	write_unlock_bh(&idev->lock);
 }
 
 /*
@@ -2650,16 +2617,12 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 	if (idev->cnf.forwarding)
 		__ipv6_dev_mc_dec(idev, &in6addr_linklocal_allrouters);
 
-	write_lock_bh(&idev->lock);
-	while ((i = idev->mc_list) != NULL) {
-		idev->mc_list = i->next;
+	while ((i = rtnl_dereference(idev->mc_list))) {
+		rcu_assign_pointer(idev->mc_list, rtnl_dereference(i->next));
 
-		write_unlock_bh(&idev->lock);
 		ip6_mc_clear_src(i);
 		ma_put(i);
-		write_lock_bh(&idev->lock);
 	}
-	write_unlock_bh(&idev->lock);
 }
 
 static void ipv6_mc_rejoin_groups(struct inet6_dev *idev)
@@ -2669,12 +2632,11 @@ static void ipv6_mc_rejoin_groups(struct inet6_dev *idev)
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
@@ -2721,13 +2683,12 @@ static inline struct ifmcaddr6 *igmp6_mc_get_first(struct seq_file *seq)
 		idev = __in6_dev_get(state->dev);
 		if (!idev)
 			continue;
-		read_lock_bh(&idev->lock);
-		im = idev->mc_list;
+
+		im = rcu_dereference(idev->mc_list);
 		if (im) {
 			state->idev = idev;
 			break;
 		}
-		read_unlock_bh(&idev->lock);
 	}
 	return im;
 }
@@ -2736,11 +2697,8 @@ static struct ifmcaddr6 *igmp6_mc_get_next(struct seq_file *seq, struct ifmcaddr
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
@@ -2749,8 +2707,7 @@ static struct ifmcaddr6 *igmp6_mc_get_next(struct seq_file *seq, struct ifmcaddr
 		state->idev = __in6_dev_get(state->dev);
 		if (!state->idev)
 			continue;
-		read_lock_bh(&state->idev->lock);
-		im = state->idev->mc_list;
+		im = rcu_dereference(state->idev->mc_list);
 	}
 	return im;
 }
@@ -2784,10 +2741,8 @@ static void igmp6_mc_seq_stop(struct seq_file *seq, void *v)
 {
 	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
 
-	if (likely(state->idev)) {
-		read_unlock_bh(&state->idev->lock);
+	if (likely(state->idev))
 		state->idev = NULL;
-	}
 	state->dev = NULL;
 	rcu_read_unlock();
 }
@@ -2802,7 +2757,7 @@ static int igmp6_mc_seq_show(struct seq_file *seq, void *v)
 		   state->dev->ifindex, state->dev->name,
 		   &im->mca_addr,
 		   im->mca_users, im->mca_flags,
-		   (im->mca_flags&MAF_TIMER_RUNNING) ?
+		   (im->mca_flags & MAF_TIMER_RUNNING) ?
 		   jiffies_to_clock_t(im->mca_work.timer.expires - jiffies) : 0);
 	return 0;
 }
@@ -2837,8 +2792,8 @@ static inline struct ip6_sf_list *igmp6_mcf_get_first(struct seq_file *seq)
 		idev = __in6_dev_get(state->dev);
 		if (unlikely(idev == NULL))
 			continue;
-		read_lock_bh(&idev->lock);
-		im = idev->mc_list;
+
+		im = rcu_dereference(idev->mc_list);
 		if (likely(im)) {
 			spin_lock_bh(&im->mca_lock);
 			psf = rcu_dereference(im->mca_sources);
@@ -2849,7 +2804,6 @@ static inline struct ip6_sf_list *igmp6_mcf_get_first(struct seq_file *seq)
 			}
 			spin_unlock_bh(&im->mca_lock);
 		}
-		read_unlock_bh(&idev->lock);
 	}
 	return psf;
 }
@@ -2861,11 +2815,8 @@ static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq, struct ip6_s
 	psf = rcu_dereference(psf->sf_next);
 	while (!psf) {
 		spin_unlock_bh(&state->im->mca_lock);
-		state->im = state->im->next;
+		state->im = rcu_dereference(state->im->next);
 		while (!state->im) {
-			if (likely(state->idev))
-				read_unlock_bh(&state->idev->lock);
-
 			state->dev = next_net_device_rcu(state->dev);
 			if (!state->dev) {
 				state->idev = NULL;
@@ -2874,8 +2825,7 @@ static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq, struct ip6_s
 			state->idev = __in6_dev_get(state->dev);
 			if (!state->idev)
 				continue;
-			read_lock_bh(&state->idev->lock);
-			state->im = state->idev->mc_list;
+			state->im = rcu_dereference(state->idev->mc_list);
 		}
 		if (!state->im)
 			break;
@@ -2917,14 +2867,14 @@ static void igmp6_mcf_seq_stop(struct seq_file *seq, void *v)
 	__releases(RCU)
 {
 	struct igmp6_mcf_iter_state *state = igmp6_mcf_seq_private(seq);
+
 	if (likely(state->im)) {
 		spin_unlock_bh(&state->im->mca_lock);
 		state->im = NULL;
 	}
-	if (likely(state->idev)) {
-		read_unlock_bh(&state->idev->lock);
+	if (likely(state->idev))
 		state->idev = NULL;
-	}
+
 	state->dev = NULL;
 	rcu_read_unlock();
 }
-- 
2.17.1

