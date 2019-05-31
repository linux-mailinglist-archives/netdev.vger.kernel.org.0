Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5A0431256
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfEaQ1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:27:41 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33380 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726818AbfEaQ1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:27:41 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hWkNW-0005hF-ST; Fri, 31 May 2019 18:27:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v3 6/7] drivers: use in_dev_for_each_ifa_rtnl/rcu
Date:   Fri, 31 May 2019 18:27:08 +0200
Message-Id: <20190531162709.9895-7-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531162709.9895-1-fw@strlen.de>
References: <20190531162709.9895-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like previous patches, use the new iterator macros to avoid sparse
warnings once proper __rcu annotations are added.

Compile tested only.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 drivers/infiniband/core/roce_gid_mgmt.c              |  5 +++--
 drivers/infiniband/hw/cxgb4/cm.c                     |  9 +++++++--
 drivers/infiniband/hw/i40iw/i40iw_cm.c               |  7 +++++--
 drivers/infiniband/hw/i40iw/i40iw_main.c             |  6 ++++--
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |  8 +++++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c     |  5 +++--
 drivers/net/wan/hdlc_cisco.c                         | 11 +++++------
 7 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 558de0b9895c..2860def84f4d 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -330,6 +330,7 @@ static void bond_delete_netdev_default_gids(struct ib_device *ib_dev,
 static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
 				 u8 port, struct net_device *ndev)
 {
+	const struct in_ifaddr *ifa;
 	struct in_device *in_dev;
 	struct sin_list {
 		struct list_head	list;
@@ -349,7 +350,7 @@ static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
 		return;
 	}
 
-	for_ifa(in_dev) {
+	in_dev_for_each_ifa_rcu(ifa, in_dev) {
 		struct sin_list *entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 
 		if (!entry)
@@ -359,7 +360,7 @@ static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
 		entry->ip.sin_addr.s_addr = ifa->ifa_address;
 		list_add_tail(&entry->list, &sin_list);
 	}
-	endfor_ifa(in_dev);
+
 	rcu_read_unlock();
 
 	list_for_each_entry_safe(sin_iter, sin_temp, &sin_list, list) {
diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 0f3b1193d5f8..09fcfc9e052d 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3230,17 +3230,22 @@ static int pick_local_ipaddrs(struct c4iw_dev *dev, struct iw_cm_id *cm_id)
 	int found = 0;
 	struct sockaddr_in *laddr = (struct sockaddr_in *)&cm_id->m_local_addr;
 	struct sockaddr_in *raddr = (struct sockaddr_in *)&cm_id->m_remote_addr;
+	const struct in_ifaddr *ifa;
 
 	ind = in_dev_get(dev->rdev.lldi.ports[0]);
 	if (!ind)
 		return -EADDRNOTAVAIL;
-	for_primary_ifa(ind) {
+	rcu_read_lock();
+	in_dev_for_each_ifa_rcu(ifa, ind) {
+		if (ifa->ifa_flags & IFA_F_SECONDARY)
+			continue;
 		laddr->sin_addr.s_addr = ifa->ifa_address;
 		raddr->sin_addr.s_addr = ifa->ifa_address;
 		found = 1;
 		break;
 	}
-	endfor_ifa(ind);
+	rcu_read_unlock();
+
 	in_dev_put(ind);
 	return found ? 0 : -EADDRNOTAVAIL;
 }
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 8233f5a4e623..700a5d06b60c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1773,8 +1773,11 @@ static enum i40iw_status_code i40iw_add_mqh_4(
 		if ((((rdma_vlan_dev_vlan_id(dev) < I40IW_NO_VLAN) &&
 		      (rdma_vlan_dev_real_dev(dev) == iwdev->netdev)) ||
 		    (dev == iwdev->netdev)) && (dev->flags & IFF_UP)) {
+			const struct in_ifaddr *ifa;
+
 			idev = in_dev_get(dev);
-			for_ifa(idev) {
+
+			in_dev_for_each_ifa_rtnl(ifa, idev) {
 				i40iw_debug(&iwdev->sc_dev,
 					    I40IW_DEBUG_CM,
 					    "Allocating child CM Listener forIP=%pI4, vlan_id=%d, MAC=%pM\n",
@@ -1819,7 +1822,7 @@ static enum i40iw_status_code i40iw_add_mqh_4(
 					cm_parent_listen_node->cm_core->stats_listen_nodes_created--;
 				}
 			}
-			endfor_ifa(idev);
+
 			in_dev_put(idev);
 		}
 	}
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 10932baee279..d44cf33df81a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1222,8 +1222,10 @@ static void i40iw_add_ipv4_addr(struct i40iw_device *iwdev)
 		if ((((rdma_vlan_dev_vlan_id(dev) < 0xFFFF) &&
 		      (rdma_vlan_dev_real_dev(dev) == iwdev->netdev)) ||
 		    (dev == iwdev->netdev)) && (dev->flags & IFF_UP)) {
+			const struct in_ifaddr *ifa;
+
 			idev = in_dev_get(dev);
-			for_ifa(idev) {
+			in_dev_for_each_ifa_rtnl(ifa, idev) {
 				i40iw_debug(&iwdev->sc_dev, I40IW_DEBUG_CM,
 					    "IP=%pI4, vlan_id=%d, MAC=%pM\n", &ifa->ifa_address,
 					     rdma_vlan_dev_vlan_id(dev), dev->dev_addr);
@@ -1235,7 +1237,7 @@ static void i40iw_add_ipv4_addr(struct i40iw_device *iwdev)
 						       true,
 						       I40IW_ARP_ADD);
 			}
-			endfor_ifa(idev);
+
 			in_dev_put(idev);
 		}
 	}
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 84cb62434556..58e2eaf77014 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -3248,6 +3248,7 @@ netxen_config_indev_addr(struct netxen_adapter *adapter,
 		struct net_device *dev, unsigned long event)
 {
 	struct in_device *indev;
+	struct in_ifaddr *ifa;
 
 	if (!netxen_destip_supported(adapter))
 		return;
@@ -3256,7 +3257,8 @@ netxen_config_indev_addr(struct netxen_adapter *adapter,
 	if (!indev)
 		return;
 
-	for_ifa(indev) {
+	rcu_read_lock();
+	in_dev_for_each_ifa_rcu(ifa, indev) {
 		switch (event) {
 		case NETDEV_UP:
 			netxen_list_config_ip(adapter, ifa, NX_IP_UP);
@@ -3267,8 +3269,8 @@ netxen_config_indev_addr(struct netxen_adapter *adapter,
 		default:
 			break;
 		}
-	} endfor_ifa(indev);
-
+	}
+	rcu_read_unlock();
 	in_dev_put(indev);
 }
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 7a873002e626..c07438db30ba 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -4119,13 +4119,14 @@ static void
 qlcnic_config_indev_addr(struct qlcnic_adapter *adapter,
 			struct net_device *dev, unsigned long event)
 {
+	const struct in_ifaddr *ifa;
 	struct in_device *indev;
 
 	indev = in_dev_get(dev);
 	if (!indev)
 		return;
 
-	for_ifa(indev) {
+	in_dev_for_each_ifa_rtnl(ifa, indev) {
 		switch (event) {
 		case NETDEV_UP:
 			qlcnic_config_ipaddr(adapter,
@@ -4138,7 +4139,7 @@ qlcnic_config_indev_addr(struct qlcnic_adapter *adapter,
 		default:
 			break;
 		}
-	} endfor_ifa(indev);
+	}
 
 	in_dev_put(indev);
 }
diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index 320039d329c7..4976ca3f30c7 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -196,16 +196,15 @@ static int cisco_rx(struct sk_buff *skb)
 			mask = ~cpu_to_be32(0); /* is the mask correct? */
 
 			if (in_dev != NULL) {
-				struct in_ifaddr **ifap = &in_dev->ifa_list;
+				const struct in_ifaddr *ifa;
 
-				while (*ifap != NULL) {
+				in_dev_for_each_ifa_rcu(ifa, in_dev) {
 					if (strcmp(dev->name,
-						   (*ifap)->ifa_label) == 0) {
-						addr = (*ifap)->ifa_local;
-						mask = (*ifap)->ifa_mask;
+						   ifa->ifa_label) == 0) {
+						addr = ifa->ifa_local;
+						mask = ifa->ifa_mask;
 						break;
 					}
-					ifap = &(*ifap)->ifa_next;
 				}
 
 				cisco_keepalive_send(dev, CISCO_ADDR_REPLY,
-- 
2.21.0

