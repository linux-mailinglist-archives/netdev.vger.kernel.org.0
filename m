Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA4B234711
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 15:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387428AbgGaNiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 09:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730684AbgGaNiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 09:38:21 -0400
X-Greylist: delayed 353 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 31 Jul 2020 06:38:21 PDT
Received: from olfflo.fourcot.fr (fourcot.fr [IPv6:2001:4b98:dc0:41:216:3eff:fe52:be3b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A0DC061575
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 06:38:21 -0700 (PDT)
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: [PATCH net-next 2/2] ipv6/addrconf: use a boolean to choose between UNREGISTER/DOWN
Date:   Fri, 31 Jul 2020 15:32:07 +0200
Message-Id: <20200731133207.26964-2-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200731133207.26964-1-florent.fourcot@wifirst.fr>
References: <20200731133207.26964-1-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"how" was used as a boolean. Change the type to bool, and improve
variable name

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
---
 net/ipv6/addrconf.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 861265fa9d6d..0acf6a9796ca 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -163,7 +163,7 @@ static void addrconf_leave_anycast(struct inet6_ifaddr *ifp);
 
 static void addrconf_type_change(struct net_device *dev,
 				 unsigned long event);
-static int addrconf_ifdown(struct net_device *dev, int how);
+static int addrconf_ifdown(struct net_device *dev, bool unregister);
 
 static struct fib6_info *addrconf_get_prefix_route(const struct in6_addr *pfx,
 						  int plen,
@@ -3630,7 +3630,7 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 		 * an L3 master device (e.g., VRF)
 		 */
 		if (info->upper_dev && netif_is_l3_master(info->upper_dev))
-			addrconf_ifdown(dev, 0);
+			addrconf_ifdown(dev, false);
 	}
 
 	return NOTIFY_OK;
@@ -3663,9 +3663,9 @@ static bool addr_is_local(const struct in6_addr *addr)
 		(IPV6_ADDR_LINKLOCAL | IPV6_ADDR_LOOPBACK);
 }
 
-static int addrconf_ifdown(struct net_device *dev, int how)
+static int addrconf_ifdown(struct net_device *dev, bool unregister)
 {
-	unsigned long event = how ? NETDEV_UNREGISTER : NETDEV_DOWN;
+	unsigned long event = unregister ? NETDEV_UNREGISTER : NETDEV_DOWN;
 	struct net *net = dev_net(dev);
 	struct inet6_dev *idev;
 	struct inet6_ifaddr *ifa, *tmp;
@@ -3684,7 +3684,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
 	 * Step 1: remove reference to ipv6 device from parent device.
 	 *	   Do not dev_put!
 	 */
-	if (how) {
+	if (unregister) {
 		idev->dead = 1;
 
 		/* protected by rtnl_lock */
@@ -3698,7 +3698,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
 	/* combine the user config with event to determine if permanent
 	 * addresses are to be removed from address hash table
 	 */
-	if (!how && !idev->cnf.disable_ipv6) {
+	if (!unregister && !idev->cnf.disable_ipv6) {
 		/* aggregate the system setting and interface setting */
 		int _keep_addr = net->ipv6.devconf_all->keep_addr_on_down;
 
@@ -3736,7 +3736,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
 	addrconf_del_rs_timer(idev);
 
 	/* Step 2: clear flags for stateless addrconf */
-	if (!how)
+	if (!unregister)
 		idev->if_flags &= ~(IF_RS_SENT|IF_RA_RCVD|IF_READY);
 
 	/* Step 3: clear tempaddr list */
@@ -3806,7 +3806,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
 	write_unlock_bh(&idev->lock);
 
 	/* Step 5: Discard anycast and multicast list */
-	if (how) {
+	if (unregister) {
 		ipv6_ac_destroy_dev(idev);
 		ipv6_mc_destroy_dev(idev);
 	} else {
@@ -3816,7 +3816,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
 	idev->tstamp = jiffies;
 
 	/* Last: Shot the device (if unregistered) */
-	if (how) {
+	if (unregister) {
 		addrconf_sysctl_unregister(idev);
 		neigh_parms_release(&nd_tbl, idev->nd_parms);
 		neigh_ifdown(&nd_tbl, dev);
@@ -4038,7 +4038,7 @@ static void addrconf_dad_work(struct work_struct *w)
 		in6_ifa_hold(ifp);
 		addrconf_dad_stop(ifp, 1);
 		if (disable_ipv6)
-			addrconf_ifdown(idev->dev, 0);
+			addrconf_ifdown(idev->dev, false);
 		goto out;
 	}
 
@@ -7187,9 +7187,9 @@ void addrconf_cleanup(void)
 	for_each_netdev(&init_net, dev) {
 		if (__in6_dev_get(dev) == NULL)
 			continue;
-		addrconf_ifdown(dev, 1);
+		addrconf_ifdown(dev, true);
 	}
-	addrconf_ifdown(init_net.loopback_dev, 1);
+	addrconf_ifdown(init_net.loopback_dev, true);
 
 	/*
 	 *	Check hash table.
-- 
2.20.1

