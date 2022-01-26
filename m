Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C74449C48E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbiAZHgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237969AbiAZHf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:59 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CF5C06175D
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:35:49 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b15so7059692plg.3
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=239wNQI3EPhYbaeenarp6EYIQtLUZXx2pDSqNuEW6n4=;
        b=QsXB+En6ZeizTGO8pC7J1pKiO2Mx9MsC8eJsqkRlqq8W7+HB0TEOsTGu9jN46GZlz8
         kI2/Aje4RwfJIGZGS7QjblU8gClI2l6bcSQyem9zSQBgxyUYV5+m4OJjr+TBeu9ECMNc
         l5gL0YVw1pBUBoSDVwSKqT1amfGuOVS47mnAdsli9cy5HCsAgqE/zfsWDAlJAZMg7Wi9
         +upGfIGsepGg3hRD9fenUwZbfUEcmUXSj9SnI6VBQUnGPGLCMa+/rGpPJV8Okthh8SUv
         sZq8ePrU+xrss1qA7r0oCofdEGxvuoTMjQ6+quzx03g3I+8yBVLT4R1VgdWSMX55GUmP
         9eyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=239wNQI3EPhYbaeenarp6EYIQtLUZXx2pDSqNuEW6n4=;
        b=5M+NxFHhETJnh3uA4j4R6bqBVAb62qs5w2qyyidT07ZvHYx7OfUSuXukqVSpoNImNW
         y7QZpY5+SOr2rSDZ2OFlpCrPB9R803wts/dq+NEQ68wpRqibJYXgMnQk9BaEMokM/9HU
         xyKc3ZqLnla+ZeiuP70BHIP8Br6d3k68BSg7TIbjoP40rxtMfAM6ckkbtkS3aYU/y6QF
         cgPhdBMo1xqw8PnOwicU3srpJShnI/jMXwtnRKkL7dOmVwqgoMx/3AdqN8CnNFFqMtc7
         xzr75NsPNrr93955oTx3K4S4oDQ9SvWaH5fKNeTXeskIxAZK08iUezBUHPGkDZ3D8xAs
         aOEA==
X-Gm-Message-State: AOAM532jnrSkAfudx3yYG12QaXgX8kNg1p43JxOJgun2e5P3uxGn1Y7j
        BrlkpJ9TfPPRknGEc5SthlIAHtpAg74=
X-Google-Smtp-Source: ABdhPJzXTmd4WkDUiI0aokvprfVcIaQeEP+jRz6WoSshY53MSAUNJO7xVg3i8R4seY0dvt2ycM1WbQ==
X-Received: by 2002:a17:902:8f91:b0:149:87ff:ac85 with SMTP id z17-20020a1709028f9100b0014987ffac85mr22290931plo.162.1643182549074;
        Tue, 25 Jan 2022 23:35:49 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p12sm2240819pjj.55.2022.01.25.23.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 23:35:48 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH RFC net-next 4/5] bonding: add new parameter ns_targets
Date:   Wed, 26 Jan 2022 15:35:20 +0800
Message-Id: <20220126073521.1313870-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220126073521.1313870-1-liuhangbin@gmail.com>
References: <20220126073521.1313870-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new bonding parameter ns_targets to store IPv6 address.
Add required bond_ns_send/rcv functions first before adding
IPv6 address option setting.

The bond_do_ns_validate() will check if there is any IPv6 address in
bond parameter ns_targets. If yes, we will use IPv6 NS/NA probe
instead of ARP probe.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c    | 209 ++++++++++++++++++++++++++++-
 drivers/net/bonding/bond_options.c |   5 +-
 include/net/bonding.h              |  29 ++++
 3 files changed, 237 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0ff51207dd49..5f5f0e030bd1 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -88,6 +88,7 @@
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
 #include <net/tls.h>
 #endif
+#include <net/ip6_route.h>
 
 #include "bonding_priv.h"
 
@@ -3069,6 +3070,190 @@ int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
 	return RX_HANDLER_ANOTHER;
 }
 
+static void bond_ns_send(struct slave *slave, const struct in6_addr *daddr,
+			 const struct in6_addr *saddr, struct bond_vlan_tag *tags)
+{
+	struct sk_buff *skb;
+	struct net_device *slave_dev = slave->dev;
+	struct net_device *bond_dev = slave->bond->dev;
+	struct in6_addr mcaddr;
+
+	slave_dbg(bond_dev, slave_dev, "NS on slave: dst %pI6 src %pI6\n",
+		  &daddr, &saddr);
+
+	skb = ndisc_ns_create(slave_dev, daddr, saddr, 0);
+	if (!skb) {
+		net_err_ratelimited("NS packet allocation failed\n");
+		return;
+	}
+
+	addrconf_addr_solict_mult(daddr, &mcaddr);
+	if (bond_handle_vlan(slave, tags, skb))
+		ndisc_send_skb(skb, &mcaddr, saddr);
+	return;
+}
+
+static void bond_ns_send_all(struct bonding *bond, struct slave *slave)
+{
+	struct in6_addr *targets = bond->params.ns_targets;
+	struct bond_vlan_tag *tags;
+	struct in6_addr saddr;
+	struct dst_entry *dst;
+	struct flowi6 fl6;
+	int i;
+
+	for (i = 0; i < BOND_MAX_ARP_TARGETS && !ipv6_addr_any(&targets[i]); i++) {
+		slave_dbg(bond->dev, slave->dev, "%s: target %pI6\n",
+			  __func__, &targets[i]);
+		tags = NULL;
+
+		/* Find out through which dev should the packet go */
+		memset(&fl6, 0, sizeof(struct flowi6));
+		fl6.daddr = targets[i];
+		fl6.flowi6_oif = bond->dev->ifindex;
+
+		dst = ip6_route_output(dev_net(bond->dev), NULL, &fl6);
+		if (dst->error) {
+			dst_release(dst);
+			/* there's no route to target - try to send arp
+			 * probe to generate any traffic (arp_validate=0)
+			 */
+			if (bond->params.arp_validate)
+				pr_warn_once("%s: no route to ns_ip6_target %pI6 and arp_validate is set\n",
+					     bond->dev->name,
+					     &targets[i]);
+			bond_ns_send(slave, &targets[i], &in6addr_any, tags);
+			continue;
+		}
+
+		/* bond device itself */
+		if (dst->dev == bond->dev)
+			goto found;
+
+		rcu_read_lock();
+		tags = bond_verify_device_path(bond->dev, dst->dev, 0);
+		rcu_read_unlock();
+
+		if (!IS_ERR_OR_NULL(tags))
+			goto found;
+
+		/* Not our device - skip */
+		slave_dbg(bond->dev, slave->dev, "no path to ns_ip6_target %pI6 via dst->dev %s\n",
+			   &targets[i], dst->dev ? dst->dev->name : "NULL");
+
+		dst_release(dst);
+		continue;
+
+found:
+		if (!ipv6_dev_get_saddr(dev_net(dst->dev), dst->dev, &targets[i], 0, &saddr))
+			bond_ns_send(slave, &targets[i], &saddr, tags);
+		dst_release(dst);
+		kfree(tags);
+	}
+}
+
+static int bond_confirm_addr6(struct net_device *dev,
+			       struct netdev_nested_priv *priv)
+{
+	struct in6_addr *addr = (struct in6_addr *)priv->data;
+
+	return ipv6_chk_addr(dev_net(dev), addr, dev, 0);
+}
+
+static bool bond_has_this_ip6(struct bonding *bond, struct in6_addr *addr)
+{
+	struct netdev_nested_priv priv = {
+		.data = addr,
+	};
+	int ret = false;
+
+	if (bond_confirm_addr6(bond->dev, &priv))
+		return true;
+
+	rcu_read_lock();
+	if (netdev_walk_all_upper_dev_rcu(bond->dev, bond_confirm_addr6, &priv))
+		ret = true;
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static void bond_validate_ns(struct bonding *bond, struct slave *slave,
+			     struct in6_addr *saddr, struct in6_addr *daddr)
+{
+	int i;
+
+	if (ipv6_addr_any(saddr) || !bond_has_this_ip6(bond, daddr)) {
+		slave_dbg(bond->dev, slave->dev, "%s: sip %pI6 tip %pI6 not found\n",
+			   __func__, saddr, daddr);
+		return;
+	}
+
+	i = bond_get_targets_ip6(bond->params.ns_targets, saddr);
+	if (i == -1) {
+		slave_dbg(bond->dev, slave->dev, "%s: sip %pI6 not found in targets\n",
+			   __func__, saddr);
+		return;
+	}
+	slave->last_rx = jiffies;
+	slave->target_last_arp_rx[i] = jiffies;
+}
+
+int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
+		 struct slave *slave)
+{
+	struct icmp6hdr *hdr = icmp6_hdr(skb);
+	struct slave *curr_active_slave, *curr_arp_slave;
+	struct in6_addr *saddr, *daddr;
+	bool is_ipv6 = skb->protocol == __cpu_to_be16(ETH_P_IPV6);
+
+	/* Use arp validate logic, should we add a NS one? or an alise? */
+	if (!slave_do_arp_validate(bond, slave)) {
+		if ((slave_do_arp_validate_only(bond) && is_ipv6) ||
+		    !slave_do_arp_validate_only(bond))
+			slave->last_rx = jiffies;
+		return RX_HANDLER_ANOTHER;
+	} else if (!is_ipv6) {
+		return RX_HANDLER_ANOTHER;
+	}
+
+	slave_dbg(bond->dev, slave->dev, "%s: skb->dev %s\n",
+		   __func__, skb->dev->name);
+
+	if (skb->pkt_type == PACKET_OTHERHOST ||
+	    skb->pkt_type == PACKET_LOOPBACK ||
+	    hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
+		goto out;
+
+	saddr = &ipv6_hdr(skb)->saddr;
+	daddr = &ipv6_hdr(skb)->daddr;
+
+	slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip %pI6 tip %pI6\n",
+		  __func__, slave->dev->name, bond_slave_state(slave),
+		  bond->params.arp_validate, slave_do_arp_validate(bond, slave),
+		  saddr, daddr);
+
+	curr_active_slave = rcu_dereference(bond->curr_active_slave);
+	curr_arp_slave = rcu_dereference(bond->current_arp_slave);
+
+	/* We 'trust' the received ARP enough to validate it if:
+	 * see bond_arp_rcv().
+	 */
+	if (bond_is_active_slave(slave))
+		bond_validate_ns(bond, slave, saddr, daddr);
+	else if (curr_active_slave &&
+		 time_after(slave_last_rx(bond, curr_active_slave),
+			    curr_active_slave->last_link_up))
+		bond_validate_ns(bond, slave, saddr, daddr);
+	else if (curr_arp_slave &&
+		 bond_time_in_interval(bond,
+				       dev_trans_start(curr_arp_slave->dev), 1))
+		bond_validate_ns(bond, slave, saddr, daddr);
+
+out:
+	return RX_HANDLER_ANOTHER;
+}
+
 /* function to verify if we're in the arp_interval timeslice, returns true if
  * (last_act - arp_interval) <= jiffies <= (last_act + mod * arp_interval +
  * arp_interval/2) . the arp_interval/2 is needed for really fast networks.
@@ -3163,8 +3348,12 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 		 * do - all replies will be rx'ed on same link causing slaves
 		 * to be unstable during low/no traffic periods
 		 */
-		if (bond_slave_is_up(slave))
-			bond_arp_send_all(bond, slave);
+		if (bond_slave_is_up(slave)) {
+			if (bond_do_ns_validate(bond))
+				bond_ns_send_all(bond, slave);
+			else
+				bond_arp_send_all(bond, slave);
+		}
 	}
 
 	rcu_read_unlock();
@@ -3378,7 +3567,10 @@ static bool bond_ab_arp_probe(struct bonding *bond)
 			    curr_active_slave->dev->name);
 
 	if (curr_active_slave) {
-		bond_arp_send_all(bond, curr_active_slave);
+		if (bond_do_ns_validate(bond))
+			bond_ns_send_all(bond, curr_active_slave);
+		else
+			bond_arp_send_all(bond, curr_active_slave);
 		return should_notify_rtnl;
 	}
 
@@ -3430,7 +3622,10 @@ static bool bond_ab_arp_probe(struct bonding *bond)
 	bond_set_slave_link_state(new_slave, BOND_LINK_BACK,
 				  BOND_SLAVE_NOTIFY_LATER);
 	bond_set_slave_active_flags(new_slave, BOND_SLAVE_NOTIFY_LATER);
-	bond_arp_send_all(bond, new_slave);
+	if (bond_do_ns_validate(bond))
+		bond_ns_send_all(bond, new_slave);
+	else
+		bond_arp_send_all(bond, new_slave);
 	new_slave->last_link_up = jiffies;
 	rcu_assign_pointer(bond->current_arp_slave, new_slave);
 
@@ -3966,7 +4161,10 @@ static int bond_open(struct net_device *bond_dev)
 
 	if (bond->params.arp_interval) {  /* arp interval, in milliseconds. */
 		queue_delayed_work(bond->wq, &bond->arp_work, 0);
-		bond->recv_probe = bond_arp_rcv;
+		if (bond_do_ns_validate(bond))
+			bond->recv_probe = bond_na_rcv;
+		else
+			bond->recv_probe = bond_arp_rcv;
 	}
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
@@ -5937,6 +6135,7 @@ static int bond_check_params(struct bond_params *params)
 		strscpy_pad(params->primary, primary, sizeof(params->primary));
 
 	memcpy(params->arp_targets, arp_target, sizeof(arp_target));
+	memset(params->ns_targets, 0, sizeof(struct in6_addr) * BOND_MAX_ARP_TARGETS);
 
 	return 0;
 }
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 2e8484a91a0e..bf48aea770a7 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1052,7 +1052,10 @@ static int bond_option_arp_interval_set(struct bonding *bond,
 			cancel_delayed_work_sync(&bond->arp_work);
 		} else {
 			/* arp_validate can be set only in active-backup mode */
-			bond->recv_probe = bond_arp_rcv;
+			if (bond_do_ns_validate(bond))
+				bond->recv_probe = bond_na_rcv;
+			else
+				bond->recv_probe = bond_arp_rcv;
 			cancel_delayed_work_sync(&bond->mii_work);
 			queue_delayed_work(bond->wq, &bond->arp_work, 0);
 		}
diff --git a/include/net/bonding.h b/include/net/bonding.h
index f6ae3a4baea4..15a7659bbd1c 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -29,6 +29,8 @@
 #include <net/bond_3ad.h>
 #include <net/bond_alb.h>
 #include <net/bond_options.h>
+#include <net/ipv6.h>
+#include <net/addrconf.h>
 
 #define BOND_MAX_ARP_TARGETS	16
 
@@ -146,6 +148,7 @@ struct bond_params {
 	struct reciprocal_value reciprocal_packets_per_slave;
 	u16 ad_actor_sys_prio;
 	u16 ad_user_port_key;
+	struct in6_addr ns_targets[BOND_MAX_ARP_TARGETS];
 
 	/* 2 bytes of padding : see ether_addr_equal_64bits() */
 	u8 ad_actor_system[ETH_ALEN + 2];
@@ -619,6 +622,18 @@ static inline __be32 bond_confirm_addr(struct net_device *dev, __be32 dst, __be3
 	return addr;
 }
 
+static inline bool bond_do_ns_validate(struct bonding *bond)
+{
+	int i;
+
+	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++) {
+		if (!ipv6_addr_any(&bond->params.ns_targets[i]))
+			return true;
+	}
+
+	return false;
+}
+
 struct bond_net {
 	struct net		*net;	/* Associated network namespace */
 	struct list_head	dev_list;
@@ -629,6 +644,7 @@ struct bond_net {
 };
 
 int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
+int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
 netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb, struct net_device *slave_dev);
 int bond_create(struct net *net, const char *name);
 int bond_create_sysfs(struct bond_net *net);
@@ -749,6 +765,19 @@ static inline int bond_get_targets_ip(__be32 *targets, __be32 ip)
 	return -1;
 }
 
+static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr *ip)
+{
+	int i;
+
+	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++)
+		if (ipv6_addr_equal(&targets[i], ip))
+			return i;
+		else if (ipv6_addr_any(&targets[i]))
+			break;
+
+	return -1;
+}
+
 /* exported from bond_main.c */
 extern unsigned int bond_net_id;
 
-- 
2.31.1

