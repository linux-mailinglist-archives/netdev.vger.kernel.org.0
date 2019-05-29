Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147802DC25
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 13:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfE2Lsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 07:48:54 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46918 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726791AbfE2Lsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 07:48:53 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hVx4b-0004We-B6; Wed, 29 May 2019 13:48:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     eric.dumazet@gmail.com, Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 7/7] net: ipv4: provide __rcu annotation for ifa_list
Date:   Wed, 29 May 2019 13:43:32 +0200
Message-Id: <20190529114332.19163-8-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529114332.19163-1-fw@strlen.de>
References: <20190529114332.19163-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ifa_list is protected by rcu, yet code doesn't reflect this.

Add the __rcu annotations and fix up all places that are now reported by
sparse.

I've done this in the same commit to not add intermediate patches that
result in new warnings.

Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 drivers/infiniband/hw/i40iw/i40iw_utils.c     | 12 ++-
 drivers/infiniband/hw/nes/nes.c               |  8 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c   | 15 ++--
 drivers/isdn/hysdn/hysdn_net.c                |  6 +-
 drivers/isdn/i4l/isdn_net.c                   | 20 ++++-
 drivers/net/ethernet/via/via-velocity.h       |  2 +-
 drivers/net/plip/plip.c                       |  4 +-
 drivers/net/vmxnet3/vmxnet3_drv.c             | 19 ++--
 drivers/net/wireless/ath/ath6kl/cfg80211.c    |  4 +-
 .../net/wireless/marvell/mwifiex/cfg80211.c   |  2 +-
 include/linux/inetdevice.h                    | 21 ++---
 net/core/netpoll.c                            | 10 ++-
 net/core/pktgen.c                             |  8 +-
 net/ipv4/devinet.c                            | 88 ++++++++++++-------
 net/mac80211/main.c                           |  4 +-
 net/netfilter/nf_nat_redirect.c               | 12 +--
 16 files changed, 150 insertions(+), 85 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index 337410f40860..016524683e17 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -174,10 +174,14 @@ int i40iw_inetaddr_event(struct notifier_block *notifier,
 		rcu_read_lock();
 		in = __in_dev_get_rcu(upper_dev);
 
-		if (!in->ifa_list)
-			local_ipaddr = 0;
-		else
-			local_ipaddr = ntohl(in->ifa_list->ifa_address);
+		local_ipaddr = 0;
+		if (in) {
+			struct in_ifaddr *ifa;
+
+			ifa = rcu_dereference(in->ifa_list);
+			if (ifa)
+				local_ipaddr = ntohl(ifa->ifa_address);
+		}
 
 		rcu_read_unlock();
 	} else {
diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index e00add6d78ec..29b324726ea6 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -183,7 +183,13 @@ static int nes_inetaddr_event(struct notifier_block *notifier,
 
 						rcu_read_lock();
 						in = __in_dev_get_rcu(upper_dev);
-						nesvnic->local_ipaddr = in->ifa_list->ifa_address;
+						if (in) {
+							struct in_ifaddr *ifa;
+
+							ifa = rcu_dereference(in->ifa_list);
+							if (ifa)
+								nesvnic->local_ipaddr = ifa->ifa_address;
+						}
 						rcu_read_unlock();
 					} else {
 						nesvnic->local_ipaddr = ifa->ifa_address;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index d88d9f8a7f9a..34c1f9d6c915 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -427,11 +427,16 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	if (netif_carrier_ok(us_ibdev->netdev))
 		usnic_fwd_carrier_up(us_ibdev->ufdev);
 
-	ind = in_dev_get(netdev);
-	if (ind->ifa_list)
-		usnic_fwd_add_ipaddr(us_ibdev->ufdev,
-				     ind->ifa_list->ifa_address);
-	in_dev_put(ind);
+	rcu_read_lock();
+	ind = __in_dev_get_rcu(netdev);
+	if (ind) {
+		const struct in_ifaddr *ifa;
+
+		ifa = rcu_dereference(ind->ifa_list);
+		if (ifa)
+			usnic_fwd_add_ipaddr(us_ibdev->ufdev, ifa->ifa_address);
+	}
+	rcu_read_unlock();
 
 	usnic_mac_ip_to_gid(us_ibdev->netdev->perm_addr,
 				us_ibdev->ufdev->inaddr, &gid.raw[0]);
diff --git a/drivers/isdn/hysdn/hysdn_net.c b/drivers/isdn/hysdn/hysdn_net.c
index 8e9c34f33d86..bea37ae30ebb 100644
--- a/drivers/isdn/hysdn/hysdn_net.c
+++ b/drivers/isdn/hysdn/hysdn_net.c
@@ -70,9 +70,13 @@ net_open(struct net_device *dev)
 		for (i = 0; i < ETH_ALEN; i++)
 			dev->dev_addr[i] = 0xfc;
 		if ((in_dev = dev->ip_ptr) != NULL) {
-			struct in_ifaddr *ifa = in_dev->ifa_list;
+			const struct in_ifaddr *ifa;
+
+			rcu_read_lock();
+			ifa = rcu_dereference(in_dev->ifa_list);
 			if (ifa != NULL)
 				memcpy(dev->dev_addr + (ETH_ALEN - sizeof(ifa->ifa_local)), &ifa->ifa_local, sizeof(ifa->ifa_local));
+			rcu_read_unlock();
 		}
 	} else
 		memcpy(dev->dev_addr, card->mac_addr, ETH_ALEN);
diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
index c138f66f2659..4751bdcaaab6 100644
--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -242,15 +242,23 @@ isdn_net_open(struct net_device *dev)
 	/* Fill in the MAC-level header (not needed, but for compatibility... */
 	for (i = 0; i < ETH_ALEN - sizeof(u32); i++)
 		dev->dev_addr[i] = 0xfc;
-	if ((in_dev = dev->ip_ptr) != NULL) {
+
+	rcu_read_lock();
+
+	in_dev = __in_dev_get_rcu(dev);
+	if (in_dev) {
+		const struct in_ifaddr *ifa;
+
 		/*
 		 *      Any address will do - we take the first
 		 */
-		struct in_ifaddr *ifa = in_dev->ifa_list;
+		ifa = rcu_dereference(in_dev->ifa_list);
 		if (ifa != NULL)
 			memcpy(dev->dev_addr + 2, &ifa->ifa_local, 4);
 	}
 
+	rcu_read_unlock();
+
 	/* If this interface has slaves, start them also */
 	p = MASTER_TO_SLAVE(dev);
 	if (p) {
@@ -1636,15 +1644,19 @@ isdn_net_ciscohdlck_slarp_send_reply(isdn_net_local *lp)
 	__be32 addr = 0;		/* local ipv4 address */
 	__be32 mask = 0;		/* local netmask */
 
-	if ((in_dev = lp->netdev->dev->ip_ptr) != NULL) {
+	rcu_read_lock();
+	in_dev = __in_dev_get_rcu(lp->netdev->dev);
+	if (in_dev) {
 		/* take primary(first) address of interface */
-		struct in_ifaddr *ifa = in_dev->ifa_list;
+		const struct in_ifaddr *ifa = rcu_dereference(in_dev->ifa_list);
 		if (ifa != NULL) {
 			addr = ifa->ifa_local;
 			mask = ifa->ifa_mask;
 		}
 	}
 
+	rcu_read_unlock();
+
 	skb = isdn_net_ciscohdlck_alloc_skb(lp, 4 + 14);
 	if (!skb)
 		return;
diff --git a/drivers/net/ethernet/via/via-velocity.h b/drivers/net/ethernet/via/via-velocity.h
index c0ecc6c7b5e0..cdfe7809e3c1 100644
--- a/drivers/net/ethernet/via/via-velocity.h
+++ b/drivers/net/ethernet/via/via-velocity.h
@@ -1509,7 +1509,7 @@ static inline int velocity_get_ip(struct velocity_info *vptr)
 	rcu_read_lock();
 	in_dev = __in_dev_get_rcu(vptr->netdev);
 	if (in_dev != NULL) {
-		ifa = (struct in_ifaddr *) in_dev->ifa_list;
+		ifa = rcu_dereference(in_dev->ifa_list);
 		if (ifa != NULL) {
 			memcpy(vptr->ip_addr, &ifa->ifa_address, 4);
 			res = 0;
diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index feb92ecd1880..3e3ac2e496a1 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -1012,7 +1012,7 @@ plip_rewrite_address(const struct net_device *dev, struct ethhdr *eth)
 	in_dev = __in_dev_get_rcu(dev);
 	if (in_dev) {
 		/* Any address will do - we take the first */
-		const struct in_ifaddr *ifa = in_dev->ifa_list;
+		const struct in_ifaddr *ifa = rcu_dereference(in_dev->ifa_list);
 		if (ifa) {
 			memcpy(eth->h_source, dev->dev_addr, ETH_ALEN);
 			memset(eth->h_dest, 0xfc, 2);
@@ -1107,7 +1107,7 @@ plip_open(struct net_device *dev)
 		/* Any address will do - we take the first. We already
 		   have the first two bytes filled with 0xfc, from
 		   plip_init_dev(). */
-		struct in_ifaddr *ifa=in_dev->ifa_list;
+		const struct in_ifaddr *ifa = rcu_dereference(in_dev->ifa_list);
 		if (ifa != NULL) {
 			memcpy(dev->dev_addr+2, &ifa->ifa_local, 4);
 		}
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 89984fcab01e..1b2a18ea855c 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3651,13 +3651,19 @@ vmxnet3_suspend(struct device *device)
 	}
 
 	if (adapter->wol & WAKE_ARP) {
-		in_dev = in_dev_get(netdev);
-		if (!in_dev)
+		rcu_read_lock();
+
+		in_dev = __in_dev_get_rcu(netdev);
+		if (!in_dev) {
+			rcu_read_unlock();
 			goto skip_arp;
+		}
 
-		ifa = (struct in_ifaddr *)in_dev->ifa_list;
-		if (!ifa)
+		ifa = rcu_dereference(in_dev->ifa_list);
+		if (!ifa) {
+			rcu_read_unlock();
 			goto skip_arp;
+		}
 
 		pmConf->filters[i].patternSize = ETH_HLEN + /* Ethernet header*/
 			sizeof(struct arphdr) +		/* ARP header */
@@ -3677,7 +3683,9 @@ vmxnet3_suspend(struct device *device)
 
 		/* The Unicast IPv4 address in 'tip' field. */
 		arpreq += 2 * ETH_ALEN + sizeof(u32);
-		*(u32 *)arpreq = ifa->ifa_address;
+		*(__be32 *)arpreq = ifa->ifa_address;
+
+		rcu_read_unlock();
 
 		/* The mask for the relevant bits. */
 		pmConf->filters[i].mask[0] = 0x00;
@@ -3686,7 +3694,6 @@ vmxnet3_suspend(struct device *device)
 		pmConf->filters[i].mask[3] = 0x00;
 		pmConf->filters[i].mask[4] = 0xC0; /* IPv4 TIP */
 		pmConf->filters[i].mask[5] = 0x03; /* IPv4 TIP */
-		in_dev_put(in_dev);
 
 		pmConf->wakeUpEvents |= VMXNET3_PM_WAKEUP_FILTER;
 		i++;
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5477a014e1fb..37cf602d8adf 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2194,13 +2194,13 @@ static int ath6kl_wow_suspend_vif(struct ath6kl_vif *vif,
 	if (!in_dev)
 		return 0;
 
-	ifa = in_dev->ifa_list;
+	ifa = rtnl_dereference(in_dev->ifa_list);
 	memset(&ips, 0, sizeof(ips));
 
 	/* Configure IP addr only if IP address count < MAX_IP_ADDRS */
 	while (index < MAX_IP_ADDRS && ifa) {
 		ips[index] = ifa->ifa_local;
-		ifa = ifa->ifa_next;
+		ifa = rtnl_dereference(ifa->ifa_next);
 		index++;
 	}
 
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index e11a4bb67172..5a7cdb981789 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3268,7 +3268,7 @@ static void mwifiex_set_auto_arp_mef_entry(struct mwifiex_private *priv,
 			in_dev = __in_dev_get_rtnl(adapter->priv[i]->netdev);
 			if (!in_dev)
 				continue;
-			ifa = in_dev->ifa_list;
+			ifa = rtnl_dereference(in_dev->ifa_list);
 			if (!ifa || !ifa->ifa_local)
 				continue;
 			ips[i] = ifa->ifa_local;
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index d5d05503a04b..3515ca64e638 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -26,7 +26,7 @@ struct in_device {
 	struct net_device	*dev;
 	refcount_t		refcnt;
 	int			dead;
-	struct in_ifaddr	*ifa_list;	/* IP ifaddr chain		*/
+	struct in_ifaddr	__rcu *ifa_list;/* IP ifaddr chain		*/
 
 	struct ip_mc_list __rcu	*mc_list;	/* IP multicast filter chain    */
 	struct ip_mc_list __rcu	* __rcu *mc_hash;
@@ -136,7 +136,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
 
 struct in_ifaddr {
 	struct hlist_node	hash;
-	struct in_ifaddr	*ifa_next;
+	struct in_ifaddr	__rcu *ifa_next;
 	struct in_device	*ifa_dev;
 	struct rcu_head		rcu_head;
 	__be32			ifa_local;
@@ -206,22 +206,13 @@ static __inline__ bool bad_mask(__be32 mask, __be32 addr)
 	return false;
 }
 
-#define for_primary_ifa(in_dev)	{ struct in_ifaddr *ifa; \
-  for (ifa = (in_dev)->ifa_list; ifa && !(ifa->ifa_flags&IFA_F_SECONDARY); ifa = ifa->ifa_next)
-
-#define for_ifa(in_dev)	{ struct in_ifaddr *ifa; \
-  for (ifa = (in_dev)->ifa_list; ifa; ifa = ifa->ifa_next)
-
-
-#define endfor_ifa(in_dev) }
-
 #define in_dev_for_each_ifa_rtnl(ifa, in_dev)			\
-	for (ifa = (in_dev)->ifa_list; ifa;			\
-	     ifa = ifa->ifa_next)
+	for (ifa = rtnl_dereference((in_dev)->ifa_list); ifa;	\
+	     ifa = rtnl_dereference(ifa->ifa_next))
 
 #define in_dev_for_each_ifa_rcu(ifa, in_dev)			\
-	for (ifa = (in_dev)->ifa_list; ifa;			\
-	     ifa = ifa->ifa_next)
+	for (ifa = rcu_dereference((in_dev)->ifa_list); ifa;	\
+	     ifa = rcu_dereference(ifa->ifa_next))
 
 static inline struct in_device *__in_dev_get_rcu(const struct net_device *dev)
 {
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index dd8b1a460d64..2cf27da1baeb 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -696,16 +696,22 @@ int netpoll_setup(struct netpoll *np)
 
 	if (!np->local_ip.ip) {
 		if (!np->ipv6) {
+			const struct in_ifaddr *ifa;
+
 			in_dev = __in_dev_get_rtnl(ndev);
+			if (!in_dev)
+				goto put_noaddr;
 
-			if (!in_dev || !in_dev->ifa_list) {
+			ifa = rtnl_dereference(in_dev->ifa_list);
+			if (!ifa) {
+put_noaddr:
 				np_err(np, "no IP address for %s, aborting\n",
 				       np->dev_name);
 				err = -EDESTADDRREQ;
 				goto put;
 			}
 
-			np->local_ip.ip = in_dev->ifa_list->ifa_local;
+			np->local_ip.ip = ifa->ifa_local;
 			np_info(np, "local IP %pI4\n", &np->local_ip.ip);
 		} else {
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 319ad5490fb3..4cd120dc30ad 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2125,9 +2125,11 @@ static void pktgen_setup_inject(struct pktgen_dev *pkt_dev)
 			rcu_read_lock();
 			in_dev = __in_dev_get_rcu(pkt_dev->odev);
 			if (in_dev) {
-				if (in_dev->ifa_list) {
-					pkt_dev->saddr_min =
-					    in_dev->ifa_list->ifa_address;
+				const struct in_ifaddr *ifa;
+
+				ifa = rcu_dereference(in_dev->ifa_list);
+				if (ifa) {
+					pkt_dev->saddr_min = ifa->ifa_address;
 					pkt_dev->saddr_max = pkt_dev->saddr_min;
 				}
 			}
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index b45421b2b734..ebaea05b4033 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -194,7 +194,8 @@ static void rtmsg_ifa(int event, struct in_ifaddr *, struct nlmsghdr *, u32);
 
 static BLOCKING_NOTIFIER_HEAD(inetaddr_chain);
 static BLOCKING_NOTIFIER_HEAD(inetaddr_validator_chain);
-static void inet_del_ifa(struct in_device *in_dev, struct in_ifaddr **ifap,
+static void inet_del_ifa(struct in_device *in_dev,
+			 struct in_ifaddr __rcu **ifap,
 			 int destroy);
 #ifdef CONFIG_SYSCTL
 static int devinet_sysctl_register(struct in_device *idev);
@@ -300,8 +301,8 @@ static void in_dev_rcu_put(struct rcu_head *head)
 
 static void inetdev_destroy(struct in_device *in_dev)
 {
-	struct in_ifaddr *ifa;
 	struct net_device *dev;
+	struct in_ifaddr *ifa;
 
 	ASSERT_RTNL();
 
@@ -311,7 +312,7 @@ static void inetdev_destroy(struct in_device *in_dev)
 
 	ip_mc_destroy_dev(in_dev);
 
-	while ((ifa = in_dev->ifa_list) != NULL) {
+	while ((ifa = rtnl_dereference(in_dev->ifa_list)) != NULL) {
 		inet_del_ifa(in_dev, &in_dev->ifa_list, 0);
 		inet_free_ifa(ifa);
 	}
@@ -342,17 +343,20 @@ int inet_addr_onlink(struct in_device *in_dev, __be32 a, __be32 b)
 	return 0;
 }
 
-static void __inet_del_ifa(struct in_device *in_dev, struct in_ifaddr **ifap,
-			 int destroy, struct nlmsghdr *nlh, u32 portid)
+static void __inet_del_ifa(struct in_device *in_dev,
+			   struct in_ifaddr __rcu **ifap,
+			   int destroy, struct nlmsghdr *nlh, u32 portid)
 {
 	struct in_ifaddr *promote = NULL;
-	struct in_ifaddr *ifa, *ifa1 = *ifap;
-	struct in_ifaddr *last_prim = in_dev->ifa_list;
+	struct in_ifaddr *ifa, *ifa1;
+	struct in_ifaddr *last_prim;
 	struct in_ifaddr *prev_prom = NULL;
 	int do_promote = IN_DEV_PROMOTE_SECONDARIES(in_dev);
 
 	ASSERT_RTNL();
 
+	ifa1 = rtnl_dereference(*ifap);
+	last_prim = rtnl_dereference(in_dev->ifa_list);
 	if (in_dev->dead)
 		goto no_promotions;
 
@@ -361,9 +365,9 @@ static void __inet_del_ifa(struct in_device *in_dev, struct in_ifaddr **ifap,
 	 **/
 
 	if (!(ifa1->ifa_flags & IFA_F_SECONDARY)) {
-		struct in_ifaddr **ifap1 = &ifa1->ifa_next;
+		struct in_ifaddr __rcu **ifap1 = &ifa1->ifa_next;
 
-		while ((ifa = *ifap1) != NULL) {
+		while ((ifa = rtnl_dereference(*ifap1)) != NULL) {
 			if (!(ifa->ifa_flags & IFA_F_SECONDARY) &&
 			    ifa1->ifa_scope <= ifa->ifa_scope)
 				last_prim = ifa;
@@ -396,7 +400,7 @@ static void __inet_del_ifa(struct in_device *in_dev, struct in_ifaddr **ifap,
 	 * and later to add them back with new prefsrc. Do this
 	 * while all addresses are on the device list.
 	 */
-	for (ifa = promote; ifa; ifa = ifa->ifa_next) {
+	for (ifa = promote; ifa; ifa = rtnl_dereference(ifa->ifa_next)) {
 		if (ifa1->ifa_mask == ifa->ifa_mask &&
 		    inet_ifa_match(ifa1->ifa_address, ifa))
 			fib_del_ifaddr(ifa, ifa1);
@@ -422,19 +426,24 @@ static void __inet_del_ifa(struct in_device *in_dev, struct in_ifaddr **ifap,
 	blocking_notifier_call_chain(&inetaddr_chain, NETDEV_DOWN, ifa1);
 
 	if (promote) {
-		struct in_ifaddr *next_sec = promote->ifa_next;
+		struct in_ifaddr *next_sec;
 
+		next_sec = rtnl_dereference(promote->ifa_next);
 		if (prev_prom) {
-			prev_prom->ifa_next = promote->ifa_next;
-			promote->ifa_next = last_prim->ifa_next;
-			last_prim->ifa_next = promote;
+			struct in_ifaddr *last_sec;
+
+			last_sec = rtnl_dereference(last_prim->ifa_next);
+			rcu_assign_pointer(prev_prom->ifa_next, next_sec);
+			rcu_assign_pointer(promote->ifa_next, last_sec);
+			rcu_assign_pointer(last_prim->ifa_next, promote);
 		}
 
 		promote->ifa_flags &= ~IFA_F_SECONDARY;
 		rtmsg_ifa(RTM_NEWADDR, promote, nlh, portid);
 		blocking_notifier_call_chain(&inetaddr_chain,
 				NETDEV_UP, promote);
-		for (ifa = next_sec; ifa; ifa = ifa->ifa_next) {
+		for (ifa = next_sec; ifa;
+		     ifa = rtnl_dereference(ifa->ifa_next)) {
 			if (ifa1->ifa_mask != ifa->ifa_mask ||
 			    !inet_ifa_match(ifa1->ifa_address, ifa))
 					continue;
@@ -446,7 +455,8 @@ static void __inet_del_ifa(struct in_device *in_dev, struct in_ifaddr **ifap,
 		inet_free_ifa(ifa1);
 }
 
-static void inet_del_ifa(struct in_device *in_dev, struct in_ifaddr **ifap,
+static void inet_del_ifa(struct in_device *in_dev,
+			 struct in_ifaddr __rcu **ifap,
 			 int destroy)
 {
 	__inet_del_ifa(in_dev, ifap, destroy, NULL, 0);
@@ -459,9 +469,10 @@ static DECLARE_DELAYED_WORK(check_lifetime_work, check_lifetime);
 static int __inet_insert_ifa(struct in_ifaddr *ifa, struct nlmsghdr *nlh,
 			     u32 portid, struct netlink_ext_ack *extack)
 {
+	struct in_ifaddr __rcu **last_primary, **ifap;
 	struct in_device *in_dev = ifa->ifa_dev;
-	struct in_ifaddr *ifa1, **ifap, **last_primary;
 	struct in_validator_info ivi;
+	struct in_ifaddr *ifa1;
 	int ret;
 
 	ASSERT_RTNL();
@@ -474,8 +485,10 @@ static int __inet_insert_ifa(struct in_ifaddr *ifa, struct nlmsghdr *nlh,
 	ifa->ifa_flags &= ~IFA_F_SECONDARY;
 	last_primary = &in_dev->ifa_list;
 
-	for (ifap = &in_dev->ifa_list; (ifa1 = *ifap) != NULL;
-	     ifap = &ifa1->ifa_next) {
+	ifap = &in_dev->ifa_list;
+	ifa1 = rtnl_dereference(*ifap);
+
+	while (ifa1) {
 		if (!(ifa1->ifa_flags & IFA_F_SECONDARY) &&
 		    ifa->ifa_scope <= ifa1->ifa_scope)
 			last_primary = &ifa1->ifa_next;
@@ -491,6 +504,9 @@ static int __inet_insert_ifa(struct in_ifaddr *ifa, struct nlmsghdr *nlh,
 			}
 			ifa->ifa_flags |= IFA_F_SECONDARY;
 		}
+
+		ifap = &ifa1->ifa_next;
+		ifa1 = rtnl_dereference(*ifap);
 	}
 
 	/* Allow any devices that wish to register ifaddr validtors to weigh
@@ -516,8 +532,8 @@ static int __inet_insert_ifa(struct in_ifaddr *ifa, struct nlmsghdr *nlh,
 		ifap = last_primary;
 	}
 
-	ifa->ifa_next = *ifap;
-	*ifap = ifa;
+	rcu_assign_pointer(ifa->ifa_next, *ifap);
+	rcu_assign_pointer(*ifap, ifa);
 
 	inet_hash_insert(dev_net(in_dev->dev), ifa);
 
@@ -617,10 +633,12 @@ static int inet_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
+	struct in_ifaddr __rcu **ifap;
 	struct nlattr *tb[IFA_MAX+1];
 	struct in_device *in_dev;
 	struct ifaddrmsg *ifm;
-	struct in_ifaddr *ifa, **ifap;
+	struct in_ifaddr *ifa;
+
 	int err = -EINVAL;
 
 	ASSERT_RTNL();
@@ -637,7 +655,7 @@ static int inet_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto errout;
 	}
 
-	for (ifap = &in_dev->ifa_list; (ifa = *ifap) != NULL;
+	for (ifap = &in_dev->ifa_list; (ifa = rtnl_dereference(*ifap)) != NULL;
 	     ifap = &ifa->ifa_next) {
 		if (tb[IFA_LOCAL] &&
 		    ifa->ifa_local != nla_get_in_addr(tb[IFA_LOCAL]))
@@ -725,15 +743,20 @@ static void check_lifetime(struct work_struct *work)
 
 			if (ifa->ifa_valid_lft != INFINITY_LIFE_TIME &&
 			    age >= ifa->ifa_valid_lft) {
-				struct in_ifaddr **ifap;
-
-				for (ifap = &ifa->ifa_dev->ifa_list;
-				     *ifap != NULL; ifap = &(*ifap)->ifa_next) {
-					if (*ifap == ifa) {
+				struct in_ifaddr __rcu **ifap;
+				struct in_ifaddr *tmp;
+
+				ifap = &ifa->ifa_dev->ifa_list;
+				tmp = rtnl_dereference(*ifap);
+				while (tmp) {
+					tmp = rtnl_dereference(tmp->ifa_next);
+					if (rtnl_dereference(*ifap) == ifa) {
 						inet_del_ifa(ifa->ifa_dev,
 							     ifap, 1);
 						break;
 					}
+					ifap = &tmp->ifa_next;
+					tmp = rtnl_dereference(*ifap);
 				}
 			} else if (ifa->ifa_preferred_lft !=
 				   INFINITY_LIFE_TIME &&
@@ -977,8 +1000,8 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 {
 	struct sockaddr_in sin_orig;
 	struct sockaddr_in *sin = (struct sockaddr_in *)&ifr->ifr_addr;
+	struct in_ifaddr __rcu **ifap = NULL;
 	struct in_device *in_dev;
-	struct in_ifaddr **ifap = NULL;
 	struct in_ifaddr *ifa = NULL;
 	struct net_device *dev;
 	char *colon;
@@ -1049,7 +1072,9 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 			/* note: we only do this for a limited set of ioctls
 			   and only if the original address family was AF_INET.
 			   This is checked above. */
-			for (ifap = &in_dev->ifa_list; (ifa = *ifap) != NULL;
+
+			for (ifap = &in_dev->ifa_list;
+			     (ifa = rtnl_dereference(*ifap)) != NULL;
 			     ifap = &ifa->ifa_next) {
 				if (!strcmp(ifr->ifr_name, ifa->ifa_label) &&
 				    sin_orig.sin_addr.s_addr ==
@@ -1062,7 +1087,8 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 		   4.3BSD-style and passed in junk so we fall back to
 		   comparing just the label */
 		if (!ifa) {
-			for (ifap = &in_dev->ifa_list; (ifa = *ifap) != NULL;
+			for (ifap = &in_dev->ifa_list;
+			     (ifa = rtnl_dereference(*ifap)) != NULL;
 			     ifap = &ifa->ifa_next)
 				if (!strcmp(ifr->ifr_name, ifa->ifa_label))
 					break;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2b608044ae23..1f11907dc528 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -354,11 +354,11 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 	sdata_lock(sdata);
 
 	/* Copy the addresses to the bss_conf list */
-	ifa = idev->ifa_list;
+	ifa = rtnl_dereference(idev->ifa_list);
 	while (ifa) {
 		if (c < IEEE80211_BSS_ARP_ADDR_LIST_LEN)
 			bss_conf->arp_addr_list[c] = ifa->ifa_address;
-		ifa = ifa->ifa_next;
+		ifa = rtnl_dereference(ifa->ifa_next);
 		c++;
 	}
 
diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index 78a9e6454ff3..8598e80968e0 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -47,15 +47,17 @@ nf_nat_redirect_ipv4(struct sk_buff *skb,
 	if (hooknum == NF_INET_LOCAL_OUT) {
 		newdst = htonl(0x7F000001);
 	} else {
-		struct in_device *indev;
-		struct in_ifaddr *ifa;
+		const struct in_device *indev;
 
 		newdst = 0;
 
 		indev = __in_dev_get_rcu(skb->dev);
-		if (indev && indev->ifa_list) {
-			ifa = indev->ifa_list;
-			newdst = ifa->ifa_local;
+		if (indev) {
+			const struct in_ifaddr *ifa;
+
+			ifa = rcu_dereference(indev->ifa_list);
+			if (ifa)
+				newdst = ifa->ifa_local;
 		}
 
 		if (!newdst)
-- 
2.21.0

