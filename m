Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DA54E51ED
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 13:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242410AbiCWMM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 08:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242743AbiCWMMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 08:12:18 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA4E340927;
        Wed, 23 Mar 2022 05:10:43 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:39292.1744386625
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.38 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id A4045280096;
        Wed, 23 Mar 2022 20:10:38 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 5b1da142045f453f9793dd4eb9d45378 for j.vosburgh@gmail.com;
        Wed, 23 Mar 2022 20:10:42 CST
X-Transaction-ID: 5b1da142045f453f9793dd4eb9d45378
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: [PATCH v6 4/4] net:bonding:Add support for IPV6 RLB to balance-alb mode
Date:   Wed, 23 Mar 2022 08:09:06 -0400
Message-Id: <20220323120906.42692-5-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220323120906.42692-1-sunshouxin@chinatelecom.cn>
References: <20220323120906.42692-1-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is implementing IPV6 RLB for balance-alb mode.

Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
Introduction:
This is like ipv4 rlb,ipv6 rlb uses ND to realize it.
I would show it through each function.

Add rx6_hashtbl in alb_bond_info to save ipv6 rlb client_info.
Add rx6_ntt,rx6_hashtbl_used_head,rlb6_update_delay_counter,
and rlb6_update_retry_counter in alb_bond_info to support ipv6 rlb update.
Add ip6_src and ip6_dst in rlb_client_info.
Add ipv6 rlb actions in bond_alb_monitor and rlb_rebalance.

rlb6_update_client:send na packet based client_info to update
the neighbour infomation in other host.
rlb6_update_rx_clients:send na packet based ntt
rlb6_delete_table_entry_dst:
rlb6_src_link:
rlb6_src_unlink:update rx6_hashtbl

rlb6_nd_choose_channel:choose tx_slave and update the client_info
rlb_nd_xmit:when sending ns and na packet,choose tx_slave packet
and update the client_info
rlb6_update_entry_from_na:update the client_info when receiving na
rlb6_delete_table_entry:delete client_info
rlb6_purge_src_ip:deletes all rx_hashtbl entries with ip_src if their
mac_src does not match lladdr
rlb_recv:as the recv_probe
rlb_nd_recv:receiving ns and na packet
---
 drivers/net/bonding/bond_3ad.c     |   2 +-
 drivers/net/bonding/bond_alb.c     | 612 ++++++++++++++++++++++++++++-
 drivers/net/bonding/bond_debugfs.c |  14 +
 drivers/net/bonding/bond_main.c    |   6 +-
 include/net/bond_3ad.h             |   2 +-
 include/net/bond_alb.h             |   7 +
 include/net/bonding.h              |   6 +-
 7 files changed, 635 insertions(+), 14 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index a86b1f71762e..3cba269f12e2 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2682,7 +2682,7 @@ int bond_3ad_get_active_agg_info(struct bonding *bond, struct ad_info *ad_info)
 	return ret;
 }
 
-int bond_3ad_lacpdu_recv(const struct sk_buff *skb, struct bonding *bond,
+int bond_3ad_lacpdu_recv(struct sk_buff *skb, struct bonding *bond,
 			 struct slave *slave)
 {
 	struct lacpdu *lacpdu, _lacpdu;
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 303c8d32d451..bb01e168cd0e 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -23,6 +23,9 @@
 #include <asm/byteorder.h>
 #include <net/bonding.h>
 #include <net/bond_alb.h>
+#include <net/addrconf.h>
+#include <net/ip6_checksum.h>
+#include <net/ipv6_stubs.h>
 
 static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned = {
 	0x33, 0x33, 0x00, 0x00, 0x00, 0x01
@@ -57,6 +60,15 @@ static void rlb_purge_src_ip(struct bonding *bond, struct arp_pkt *arp);
 static void rlb_src_unlink(struct bonding *bond, u32 index);
 static void rlb_src_link(struct bonding *bond, u32 ip_src_hash,
 			 u32 ip_dst_hash);
+#if IS_ENABLED(CONFIG_IPV6)
+static void rlb6_delete_table_entry(struct bonding *bond, u32 index);
+static u8 *alb_get_lladdr(struct sk_buff *skb);
+static void alb_set_nd_option(struct sk_buff *skb, struct bonding *bond,
+			      struct slave *tx_slave);
+static bool alb_determine_ipv6_nd(struct sk_buff *skb, struct bonding *bond);
+#endif
+static int rlb_recv(struct sk_buff *skb, struct bonding *bond,
+		    struct slave *slave);
 
 static inline u8 _simple_hash(const u8 *hash_start, int hash_size)
 {
@@ -269,7 +281,7 @@ static void rlb_update_entry_from_arp(struct bonding *bond, struct arp_pkt *arp)
 	spin_unlock_bh(&bond->mode_lock);
 }
 
-static int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond,
+static int rlb_arp_recv(struct sk_buff *skb, struct bonding *bond,
 			struct slave *slave)
 {
 	struct arp_pkt *arp, _arp;
@@ -415,6 +427,31 @@ static void rlb_clear_slave(struct bonding *bond, struct slave *slave)
 		}
 	}
 
+	rx_hash_table = bond_info->rx6_hashtbl;
+	index = bond_info->rx6_hashtbl_used_head;
+	for (; index != RLB_NULL_INDEX; index = next_index) {
+		next_index = rx_hash_table[index].used_next;
+		if (rx_hash_table[index].slave == slave) {
+			struct slave *assigned_slave = rlb_next_rx_slave(bond);
+
+			if (assigned_slave) {
+				u8 mac_dst[ETH_ALEN];
+
+				rx_hash_table[index].slave = assigned_slave;
+				memcpy(mac_dst, rx_hash_table[index].mac_dst,
+				       sizeof(mac_dst));
+				if (is_valid_ether_addr(mac_dst)) {
+					bond_info->rx6_hashtbl[index].ntt = 1;
+					bond_info->rx6_ntt = 1;
+					bond_info->rlb6_update_retry_counter =
+						RLB_UPDATE_RETRY;
+				}
+			} else {  /* there is no active slave */
+				rx_hash_table[index].slave = NULL;
+			}
+		}
+	}
+
 	spin_unlock_bh(&bond->mode_lock);
 
 	if (slave != rtnl_dereference(bond->curr_active_slave))
@@ -704,7 +741,7 @@ static void rlb_rebalance(struct bonding *bond)
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
 	struct slave *assigned_slave;
 	struct rlb_client_info *client_info;
-	int ntt;
+	int ntt, ntt_ip6;
 	u32 hash_index;
 
 	spin_lock_bh(&bond->mode_lock);
@@ -724,9 +761,27 @@ static void rlb_rebalance(struct bonding *bond)
 		}
 	}
 
+	ntt_ip6 = 0;
+	hash_index = bond_info->rx6_hashtbl_used_head;
+	for (; hash_index != RLB_NULL_INDEX;
+		 hash_index = client_info->used_next) {
+		client_info = &bond_info->rx6_hashtbl[hash_index];
+		assigned_slave = __rlb_next_rx_slave(bond);
+		if (assigned_slave && client_info->slave != assigned_slave) {
+			client_info->slave = assigned_slave;
+			if (!is_zero_ether_addr(client_info->mac_dst)) {
+				client_info->ntt = 1;
+				ntt_ip6 = 1;
+			}
+		}
+	}
+
 	/* update the team's flag only after the whole iteration */
 	if (ntt)
 		bond_info->rx_ntt = 1;
+
+	if (ntt_ip6)
+		bond_info->rx6_ntt = 1;
 	spin_unlock_bh(&bond->mode_lock);
 }
 
@@ -846,6 +901,7 @@ static int rlb_initialize(struct bonding *bond)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
 	struct rlb_client_info	*new_hashtbl;
+	struct rlb_client_info	*new6_hashtbl;
 	int size = RLB_HASH_TABLE_SIZE * sizeof(struct rlb_client_info);
 	int i;
 
@@ -853,19 +909,29 @@ static int rlb_initialize(struct bonding *bond)
 	if (!new_hashtbl)
 		return -1;
 
+	new6_hashtbl = kmalloc(size, GFP_KERNEL);
+	if (!new6_hashtbl) {
+		kfree(new_hashtbl);
+		return -1;
+	}
+
 	spin_lock_bh(&bond->mode_lock);
 
 	bond_info->rx_hashtbl = new_hashtbl;
+	bond_info->rx6_hashtbl = new6_hashtbl;
 
 	bond_info->rx_hashtbl_used_head = RLB_NULL_INDEX;
+	bond_info->rx6_hashtbl_used_head = RLB_NULL_INDEX;
 
-	for (i = 0; i < RLB_HASH_TABLE_SIZE; i++)
+	for (i = 0; i < RLB_HASH_TABLE_SIZE; i++) {
 		rlb_init_table_entry(bond_info->rx_hashtbl + i);
+		rlb_init_table_entry(bond_info->rx6_hashtbl + i);
+	}
 
 	spin_unlock_bh(&bond->mode_lock);
 
 	/* register to receive ARPs */
-	bond->recv_probe = rlb_arp_recv;
+	bond->recv_probe = rlb_recv;
 
 	return 0;
 }
@@ -880,6 +946,10 @@ static void rlb_deinitialize(struct bonding *bond)
 	bond_info->rx_hashtbl = NULL;
 	bond_info->rx_hashtbl_used_head = RLB_NULL_INDEX;
 
+	kfree(bond_info->rx6_hashtbl);
+	bond_info->rx6_hashtbl = NULL;
+	bond_info->rx6_hashtbl_used_head = RLB_NULL_INDEX;
+
 	spin_unlock_bh(&bond->mode_lock);
 }
 
@@ -901,9 +971,402 @@ static void rlb_clear_vlan(struct bonding *bond, unsigned short vlan_id)
 		curr_index = next_index;
 	}
 
+#if IS_ENABLED(CONFIG_IPV6)
+	curr_index = bond_info->rx6_hashtbl_used_head;
+	while (curr_index != RLB_NULL_INDEX) {
+		struct rlb_client_info *curr = &bond_info->rx6_hashtbl[curr_index];
+		u32 next_index = bond_info->rx6_hashtbl[curr_index].used_next;
+
+		if (curr->vlan_id == vlan_id)
+			rlb6_delete_table_entry(bond, curr_index);
+
+		curr_index = next_index;
+	}
+#endif
+	spin_unlock_bh(&bond->mode_lock);
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+/*********************** ipv6 rlb specific functions ***************************/
+static void rlb6_update_client(struct rlb_client_info *client_info)
+{
+	struct nd_sendinfo sendinfo;
+	int i;
+
+	if (!client_info->slave || !is_valid_ether_addr(client_info->mac_dst))
+		return;
+
+	sendinfo.vlanid = client_info->vlan_id;
+	sendinfo.mac_dst = client_info->mac_dst;
+	sendinfo.mac_src = client_info->slave->dev->dev_addr;
+
+	for (i = 0; i < RLB_ARP_BURST_SIZE; i++) {
+		ipv6_stub->ndisc_send_na(client_info->slave->dev,
+					 &client_info->ip6_dst,
+					 &client_info->ip6_src,
+					 false, false, true, true,
+					 &sendinfo);
+	}
+}
+
+static void rlb6_update_rx_clients(struct bonding *bond)
+{
+	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
+	struct rlb_client_info *client_info;
+	u32 hash_index;
+
+	spin_lock_bh(&bond->mode_lock);
+
+	hash_index = bond_info->rx6_hashtbl_used_head;
+	for (; hash_index != RLB_NULL_INDEX;
+	    hash_index = client_info->used_next) {
+		client_info = &bond_info->rx6_hashtbl[hash_index];
+		if (client_info->ntt) {
+			rlb6_update_client(client_info);
+			if (bond_info->rlb6_update_retry_counter == 0)
+				client_info->ntt = 0;
+		}
+	}
+
+	bond_info->rlb6_update_delay_counter = RLB_UPDATE_DELAY;
+
+	spin_unlock_bh(&bond->mode_lock);
+}
+
+static void rlb6_delete_table_entry_dst(struct bonding *bond, u32 index)
+{
+	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
+	u32 next_index = bond_info->rx6_hashtbl[index].used_next;
+	u32 prev_index = bond_info->rx6_hashtbl[index].used_prev;
+
+	if (index == bond_info->rx6_hashtbl_used_head)
+		bond_info->rx6_hashtbl_used_head = next_index;
+
+	if (next_index != RLB_NULL_INDEX)
+		bond_info->rx6_hashtbl[next_index].used_prev = prev_index;
+
+	if (prev_index != RLB_NULL_INDEX)
+		bond_info->rx6_hashtbl[prev_index].used_next = next_index;
+}
+
+static void rlb6_src_link(struct bonding *bond, u32 ip_src_hash,
+			  u32 ip_dst_hash)
+{
+	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
+	u32 next;
+
+	bond_info->rx6_hashtbl[ip_dst_hash].src_prev = ip_src_hash;
+	next = bond_info->rx6_hashtbl[ip_src_hash].src_first;
+	bond_info->rx6_hashtbl[ip_dst_hash].src_next = next;
+	if (next != RLB_NULL_INDEX)
+		bond_info->rx6_hashtbl[next].src_prev = ip_dst_hash;
+	bond_info->rx6_hashtbl[ip_src_hash].src_first = ip_dst_hash;
+}
+
+static void rlb6_src_unlink(struct bonding *bond, u32 index)
+{
+	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
+	u32 next_index = bond_info->rx6_hashtbl[index].src_next;
+	u32 prev_index = bond_info->rx6_hashtbl[index].src_prev;
+
+	bond_info->rx6_hashtbl[index].src_next = RLB_NULL_INDEX;
+	bond_info->rx6_hashtbl[index].src_prev = RLB_NULL_INDEX;
+
+	if (next_index != RLB_NULL_INDEX)
+		bond_info->rx6_hashtbl[next_index].src_prev = prev_index;
+
+	if (prev_index == RLB_NULL_INDEX)
+		return;
+
+	if (bond_info->rx6_hashtbl[prev_index].src_first == index)
+		bond_info->rx6_hashtbl[prev_index].src_first = next_index;
+	else
+		bond_info->rx6_hashtbl[prev_index].src_next = next_index;
+}
+
+static void rlb6_req_update_slave_clients(struct bonding *bond,
+					  struct slave *slave)
+{
+	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
+	struct rlb_client_info *client_info;
+	u32 hash_index;
+	int ntt = 0;
+
+	spin_lock_bh(&bond->mode_lock);
+
+	hash_index = bond_info->rx6_hashtbl_used_head;
+	for (; hash_index != RLB_NULL_INDEX;
+	    hash_index = client_info->used_next) {
+		client_info = &bond_info->rx6_hashtbl[hash_index];
+		if (client_info->slave == slave &&
+		    is_valid_ether_addr(client_info->mac_dst)) {
+			client_info->ntt = 1;
+			ntt = 1;
+		}
+	}
+
+	if (ntt) {
+		bond_info->rx6_ntt = 1;
+		bond_info->rlb6_update_retry_counter =
+			RLB_UPDATE_RETRY;
+	}
+	spin_unlock_bh(&bond->mode_lock);
+}
+
+static struct slave *rlb6_nd_choose_channel(struct sk_buff *skb,
+					    struct bonding *bond,
+					    struct ipv6hdr *ip6hdr,
+					    u8 type)
+{
+	struct nd_msg *msg;
+	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
+	struct slave *assigned_slave, *curr_active_slave;
+	struct rlb_client_info *client_info;
+	struct ethhdr *eth_data;
+	u8 *dst_ip;
+	u32 hash_index = 0;
+
+	spin_lock(&bond->mode_lock);
+
+	msg = (struct nd_msg *)skb_transport_header(skb);
+	eth_data = eth_hdr(skb);
+	curr_active_slave = rcu_dereference(bond->curr_active_slave);
+
+	if (type == NDISC_NEIGHBOUR_SOLICITATION)
+		dst_ip = (u8 *)msg->target.s6_addr;
+	else
+		dst_ip = (u8 *)ip6hdr->daddr.s6_addr;
+
+	hash_index = _simple_hash(dst_ip,
+				  sizeof(struct in6_addr));
+	client_info = &bond_info->rx6_hashtbl[hash_index];
+
+	if (client_info->assigned) {
+		if (!memcmp(client_info->ip6_dst.s6_addr, dst_ip,
+			    sizeof(struct in6_addr)) &&
+			    !memcmp(client_info->ip6_src.s6_addr,
+			    ip6hdr->saddr.s6_addr,
+			    sizeof(ip6hdr->saddr.s6_addr))) {
+			ether_addr_copy(client_info->mac_src,
+					eth_data->h_source);
+
+			assigned_slave = client_info->slave;
+			if (assigned_slave) {
+				spin_unlock(&bond->mode_lock);
+				return assigned_slave;
+			}
+		} else {
+			if (curr_active_slave &&
+			    curr_active_slave != client_info->slave) {
+				client_info->slave = curr_active_slave;
+				rlb6_update_client(client_info);
+			}
+		}
+	}
+
+	/* assign a new slave */
+	assigned_slave = __rlb_next_rx_slave(bond);
+
+	if (assigned_slave) {
+		if (!(client_info->assigned &&
+		      !memcmp(client_info->ip6_src.s6_addr,
+		      ip6hdr->saddr.s6_addr, sizeof(ip6hdr->saddr.s6_addr)))) {
+			u32 hash_src = _simple_hash((u8 *)ip6hdr->saddr.s6_addr,
+						sizeof(ip6hdr->saddr.s6_addr));
+
+			rlb6_src_unlink(bond, hash_index);
+			rlb6_src_link(bond, hash_src, hash_index);
+		}
+
+		memcpy(client_info->ip6_src.s6_addr, ip6hdr->saddr.s6_addr,
+		       sizeof(ip6hdr->saddr.s6_addr));
+		memcpy(client_info->ip6_dst.s6_addr, dst_ip,
+		       sizeof(struct in6_addr));
+
+		ether_addr_copy(client_info->mac_dst, eth_data->h_dest);
+		ether_addr_copy(client_info->mac_src, eth_data->h_source);
+
+		client_info->slave = assigned_slave;
+
+		if (is_valid_ether_addr(client_info->mac_dst)) {
+			client_info->ntt = 1;
+			bond->alb_info.rx6_ntt = 1;
+		} else {
+			client_info->ntt = 0;
+		}
+
+		if (vlan_get_tag(skb, &client_info->vlan_id))
+			client_info->vlan_id = 0;
+
+		if (!client_info->assigned) {
+			u32 prev_tbl_head = bond_info->rx6_hashtbl_used_head;
+
+			bond_info->rx6_hashtbl_used_head = hash_index;
+			client_info->used_next = prev_tbl_head;
+			if (prev_tbl_head != RLB_NULL_INDEX)
+				bond_info->rx6_hashtbl[prev_tbl_head].used_prev = hash_index;
+			client_info->assigned = 1;
+		}
+	}
+
+	spin_unlock(&bond->mode_lock);
+
+	return assigned_slave;
+}
+
+static struct slave *rlb_nd_xmit(struct sk_buff *skb, struct bonding *bond)
+{
+	struct slave *tx_slave = NULL;
+	struct ipv6hdr *ip6hdr;
+	struct icmp6hdr *hdr;
+	u8 *lladdr;
+
+	if (!pskb_network_may_pull(skb, sizeof(*ip6hdr)))
+		return NULL;
+
+	ip6hdr = ipv6_hdr(skb);
+	if (ip6hdr->nexthdr != IPPROTO_ICMPV6)
+		return NULL;
+
+	if (!pskb_network_may_pull(skb, sizeof(*ip6hdr) + sizeof(*hdr)))
+		return NULL;
+
+	hdr = icmp6_hdr(skb);
+
+	if (hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT &&
+	    hdr->icmp6_type != NDISC_NEIGHBOUR_SOLICITATION) {
+		return NULL;
+	}
+
+	lladdr = alb_get_lladdr(skb);
+	if (!lladdr)
+		return NULL;
+
+	if (!bond_slave_has_mac_rx(bond, lladdr)) {
+		tx_slave = rcu_dereference(bond->curr_active_slave);
+		return tx_slave;
+	}
+
+	tx_slave = rlb6_nd_choose_channel(skb, bond, ip6hdr, hdr->icmp6_type);
+	if (!tx_slave)
+		return NULL;
+
+	alb_set_nd_option(skb, bond, tx_slave);
+
+	return tx_slave;
+}
+
+static void rlb6_update_entry_from_na(struct bonding *bond,
+				      struct ipv6hdr *ip6hdr, u8 *lladdr)
+{
+	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
+	struct rlb_client_info *client_info;
+	u32 hash_index;
+
+	spin_lock_bh(&bond->mode_lock);
+
+	hash_index = _simple_hash(ip6hdr->saddr.s6_addr,
+				  sizeof(ip6hdr->saddr.s6_addr));
+	client_info = &bond_info->rx6_hashtbl[hash_index];
+
+	if (client_info->assigned &&
+	    !memcmp(ip6hdr->saddr.s6_addr, client_info->ip6_dst.s6_addr,
+	    sizeof(ip6hdr->saddr.s6_addr)) && !memcmp(ip6hdr->daddr.s6_addr,
+	    client_info->ip6_src.s6_addr, sizeof(ip6hdr->daddr.s6_addr)) &&
+	    !ether_addr_equal_64bits(client_info->mac_dst, lladdr)) {
+		memcpy(client_info->mac_dst, lladdr,
+		       sizeof(client_info->mac_dst));
+	}
 	spin_unlock_bh(&bond->mode_lock);
 }
 
+static void rlb6_delete_table_entry(struct bonding *bond, u32 index)
+{
+	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
+	struct rlb_client_info *entry = &bond_info->rx_hashtbl[index];
+
+	rlb6_delete_table_entry_dst(bond, index);
+	rlb_init_table_entry_dst(entry);
+	rlb6_src_unlink(bond, index);
+}
+
+static void rlb6_purge_src_ip(struct bonding *bond, struct ipv6hdr *ip6hdr,
+			      u8 *lladdr)
+{
+	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
+	struct rlb_client_info *client_info;
+	u32 ip_src_hash = _simple_hash((u8 *)ip6hdr->saddr.s6_addr,
+					sizeof(ip6hdr->saddr.s6_addr));
+	u32 index, next_index;
+
+	spin_lock_bh(&bond->mode_lock);
+
+	index = bond_info->rx6_hashtbl[ip_src_hash].src_first;
+	while (index != RLB_NULL_INDEX) {
+		client_info = &bond_info->rx6_hashtbl[index];
+		next_index = client_info->src_next;
+
+		if (!memcmp(client_info->ip6_src.s6_addr,
+			    ip6hdr->saddr.s6_addr,
+			    sizeof(ip6hdr->saddr.s6_addr)) &&
+			    !ether_addr_equal_64bits(lladdr,
+			    client_info->mac_src))
+			rlb6_delete_table_entry(bond, index);
+		index = next_index;
+	}
+
+	spin_unlock_bh(&bond->mode_lock);
+}
+
+static int rlb_nd_recv(struct sk_buff *skb, struct bonding *bond)
+{
+	struct ipv6hdr *ip6hdr;
+	struct nd_msg *msg;
+	struct inet6_ifaddr *ifp;
+	u8 *lladdr;
+
+	if (!pskb_network_may_pull(skb, sizeof(*ip6hdr)))
+		return RX_HANDLER_ANOTHER;
+
+	ip6hdr = ipv6_hdr(skb);
+
+	ifp = ipv6_get_ifaddr(dev_net(skb->dev), &ip6hdr->saddr, NULL, 0);
+	if (ifp) {
+		in6_ifa_put(ifp);
+		return RX_HANDLER_ANOTHER;
+	}
+
+	if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr) +
+				sizeof(struct nd_msg)))
+		return RX_HANDLER_ANOTHER;
+
+	msg = (struct nd_msg *)skb_transport_header(skb);
+	lladdr = alb_get_lladdr(skb);
+	if (!lladdr)
+		return RX_HANDLER_ANOTHER;
+
+	rlb6_purge_src_ip(bond, ip6hdr, lladdr);
+
+	if (msg->icmph.icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT)
+		rlb6_update_entry_from_na(bond, ip6hdr, lladdr);
+
+	return RX_HANDLER_ANOTHER;
+}
+#endif
+
+static int rlb_recv(struct sk_buff *skb, struct bonding *bond,
+		    struct slave *slave)
+{
+	if (skb->protocol == cpu_to_be16(ETH_P_ARP))
+		return rlb_arp_recv(skb, bond, slave);
+#if IS_ENABLED(CONFIG_IPV6)
+	else if (alb_determine_ipv6_nd(skb, bond))
+		return rlb_nd_recv(skb, bond);
+#endif
+
+	return RX_HANDLER_ANOTHER;
+}
+
 /*********************** tlb/rlb shared functions *********************/
 
 static void alb_send_lp_vid(struct slave *slave, const u8 mac_addr[],
@@ -1068,6 +1531,9 @@ static void alb_fasten_mac_swap(struct bonding *bond, struct slave *slave1,
 			 * has changed
 			 */
 			rlb_req_update_slave_clients(bond, slave1);
+#if IS_ENABLED(CONFIG_IPV6)
+			rlb6_req_update_slave_clients(bond, slave1);
+#endif
 		}
 	} else {
 		disabled_slave = slave1;
@@ -1080,6 +1546,9 @@ static void alb_fasten_mac_swap(struct bonding *bond, struct slave *slave1,
 			 * has changed
 			 */
 			rlb_req_update_slave_clients(bond, slave2);
+#if IS_ENABLED(CONFIG_IPV6)
+			rlb6_req_update_slave_clients(bond, slave2);
+#endif
 		}
 	} else {
 		disabled_slave = slave2;
@@ -1291,6 +1760,113 @@ static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
 		hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static bool alb_determine_ipv6_nd(struct sk_buff *skb, struct bonding *bond)
+{
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		if (skb_vlan_tag_present(skb))
+			skb->transport_header = skb->network_header + sizeof(struct ipv6hdr);
+		return alb_determine_nd(skb, bond);
+	}
+
+	return false;
+}
+
+static void alb_change_nd_option(struct sk_buff *skb, const void *data)
+{
+	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
+	struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
+	struct net_device *dev = skb->dev;
+	struct icmp6hdr *icmp6h = icmp6_hdr(skb);
+	struct ipv6hdr *ip6hdr = ipv6_hdr(skb);
+	u8 *lladdr = NULL;
+	u32 ndoptlen = skb_tail_pointer(skb) - (skb_transport_header(skb) +
+				offsetof(struct nd_msg, opt));
+
+	while (ndoptlen) {
+		int l;
+
+		switch (nd_opt->nd_opt_type) {
+		case ND_OPT_SOURCE_LL_ADDR:
+		case ND_OPT_TARGET_LL_ADDR:
+			lladdr = ndisc_opt_addr_data(nd_opt, dev);
+			break;
+
+		default:
+			lladdr = NULL;
+			break;
+		}
+
+		l = nd_opt->nd_opt_len << 3;
+
+		if (ndoptlen < l || l == 0)
+			return;
+
+		if (lladdr) {
+			memcpy(lladdr, data, dev->addr_len);
+			icmp6h->icmp6_cksum = 0;
+
+			icmp6h->icmp6_cksum = csum_ipv6_magic(&ip6hdr->saddr,
+							      &ip6hdr->daddr,
+						ntohs(ip6hdr->payload_len),
+						IPPROTO_ICMPV6,
+						csum_partial(icmp6h,
+							     ntohs(ip6hdr->payload_len),
+							     0));
+			return;
+		}
+		ndoptlen -= l;
+		nd_opt = ((void *)nd_opt) + l;
+	}
+}
+
+static u8 *alb_get_lladdr(struct sk_buff *skb)
+{
+	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
+	struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
+	struct net_device *dev = skb->dev;
+	u8 *lladdr = NULL;
+	u32 ndoptlen = skb_tail_pointer(skb) - (skb_transport_header(skb) +
+				offsetof(struct nd_msg, opt));
+
+	while (ndoptlen) {
+		int l;
+
+		switch (nd_opt->nd_opt_type) {
+		case ND_OPT_SOURCE_LL_ADDR:
+		case ND_OPT_TARGET_LL_ADDR:
+			lladdr = ndisc_opt_addr_data(nd_opt, dev);
+			break;
+
+		default:
+			break;
+		}
+
+		l = nd_opt->nd_opt_len << 3;
+
+		if (ndoptlen < l || l == 0)
+			return NULL;
+
+		if (lladdr)
+			return lladdr;
+
+		ndoptlen -= l;
+		nd_opt = ((void *)nd_opt) + l;
+	}
+
+	return lladdr;
+}
+
+static void alb_set_nd_option(struct sk_buff *skb, struct bonding *bond,
+			      struct slave *tx_slave)
+{
+	if (tx_slave != rcu_access_pointer(bond->curr_active_slave)) {
+		if (alb_determine_nd(skb, bond))
+			alb_change_nd_option(skb, tx_slave->dev->dev_addr);
+	}
+}
+#endif
+
 /************************ exported alb functions ************************/
 
 int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
@@ -1457,12 +2033,19 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 			break;
 		}
 
-		if (alb_determine_nd(skb, bond)) {
+#if IS_ENABLED(CONFIG_IPV6)
+		tx_slave = rlb_nd_xmit(skb, bond);
+		if (tx_slave) {
+			do_tx_balance = false;
+			break;
+		}
+#endif
+
+		if (!pskb_network_may_pull(skb, sizeof(*ip6hdr))) {
 			do_tx_balance = false;
 			break;
 		}
 
-		/* The IPv6 header is pulled by alb_determine_nd */
 		/* Additionally, DAD probes should not be tx-balanced as that
 		 * will lead to false positives for duplicate addresses and
 		 * prevent address configuration from working.
@@ -1612,6 +2195,20 @@ void bond_alb_monitor(struct work_struct *work)
 					bond_info->rx_ntt = 0;
 			}
 		}
+
+#if IS_ENABLED(CONFIG_IPV6)
+		if (bond_info->rx6_ntt) {
+			if (bond_info->rlb6_update_delay_counter) {
+				--bond_info->rlb6_update_delay_counter;
+			} else {
+				rlb6_update_rx_clients(bond);
+				if (bond_info->rlb6_update_retry_counter)
+					--bond_info->rlb6_update_retry_counter;
+				else
+					bond_info->rx6_ntt = 0;
+			}
+		}
+#endif
 	}
 	rcu_read_unlock();
 re_arm:
@@ -1812,6 +2409,9 @@ int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr)
 		if (bond->alb_info.rlb_enabled) {
 			/* inform clients mac address has changed */
 			rlb_req_update_slave_clients(bond, curr_active);
+#if IS_ENABLED(CONFIG_IPV6)
+			rlb6_req_update_slave_clients(bond, curr_active);
+#endif
 		}
 	}
 
diff --git a/drivers/net/bonding/bond_debugfs.c b/drivers/net/bonding/bond_debugfs.c
index 4f9b4a18c74c..90e88ff9b2bf 100644
--- a/drivers/net/bonding/bond_debugfs.c
+++ b/drivers/net/bonding/bond_debugfs.c
@@ -41,6 +41,20 @@ static int bond_debug_rlb_hash_show(struct seq_file *m, void *v)
 			client_info->slave->dev->name);
 	}
 
+	seq_puts(m, "SourceIP                                 DestinationIP                           Destination MAC   Src MAC           DEV\n");
+
+	hash_index = bond_info->rx6_hashtbl_used_head;
+	for (; hash_index != RLB_NULL_INDEX;
+	     hash_index = client_info->used_next) {
+		client_info = &bond_info->rx6_hashtbl[hash_index];
+		seq_printf(m, "%-40pI6 %-40pI6 %-17pM %-17pM %s\n",
+			   &client_info->ip6_src,
+			   &client_info->ip6_dst,
+			   &client_info->mac_dst,
+			   &client_info->mac_src,
+			   client_info->slave->dev->name);
+	}
+
 	spin_unlock_bh(&bond->mode_lock);
 
 	return 0;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 15eddca7b4b6..b6252b181940 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1510,8 +1510,8 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 	struct sk_buff *skb = *pskb;
 	struct slave *slave;
 	struct bonding *bond;
-	int (*recv_probe)(const struct sk_buff *, struct bonding *,
-			  struct slave *);
+	int (*recv_probe)(struct sk_buff *skb, struct bonding *bond,
+			  struct slave *slave);
 	int ret = RX_HANDLER_ANOTHER;
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
@@ -3228,7 +3228,7 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 }
 #endif
 
-int bond_rcv_validate(const struct sk_buff *skb, struct bonding *bond,
+int bond_rcv_validate(struct sk_buff *skb, struct bonding *bond,
 		      struct slave *slave)
 {
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/include/net/bond_3ad.h b/include/net/bond_3ad.h
index 184105d68294..51886d9c928d 100644
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -300,7 +300,7 @@ void bond_3ad_handle_link_change(struct slave *slave, char link);
 int  bond_3ad_get_active_agg_info(struct bonding *bond, struct ad_info *ad_info);
 int  __bond_3ad_get_active_agg_info(struct bonding *bond,
 				    struct ad_info *ad_info);
-int bond_3ad_lacpdu_recv(const struct sk_buff *skb, struct bonding *bond,
+int bond_3ad_lacpdu_recv(struct sk_buff *skb, struct bonding *bond,
 			 struct slave *slave);
 int bond_3ad_set_carrier(struct bonding *bond);
 void bond_3ad_update_lacp_active(struct bonding *bond);
diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
index 191c36afa1f4..b1a572eead31 100644
--- a/include/net/bond_alb.h
+++ b/include/net/bond_alb.h
@@ -94,6 +94,8 @@ struct tlb_client_info {
 struct rlb_client_info {
 	__be32 ip_src;		/* the server IP address */
 	__be32 ip_dst;		/* the client IP address */
+	struct in6_addr	ip6_src;
+	struct in6_addr	ip6_dst;
 	u8  mac_src[ETH_ALEN];	/* the server MAC address */
 	u8  mac_dst[ETH_ALEN];	/* the client MAC address */
 
@@ -131,10 +133,13 @@ struct alb_bond_info {
 	/* -------- rlb parameters -------- */
 	int rlb_enabled;
 	struct rlb_client_info	*rx_hashtbl;	/* Receive hash table */
+	struct rlb_client_info	*rx6_hashtbl;	/* Receive hash table */
 	u32			rx_hashtbl_used_head;
+	u32			rx6_hashtbl_used_head;
 	u8			rx_ntt;	/* flag - need to transmit
 					 * to all rx clients
 					 */
+	u8			rx6_ntt;
 	struct slave		*rx_slave;/* last slave to xmit from */
 	u8			primary_is_promisc;	   /* boolean */
 	u32			rlb_promisc_timeout_counter;/* counts primary
@@ -144,6 +149,8 @@ struct alb_bond_info {
 	u32			rlb_update_retry_counter;/* counter of retries
 							  * of client update
 							  */
+	u32			rlb6_update_delay_counter;
+	u32			rlb6_update_retry_counter;
 	u8			rlb_rebalance;	/* flag - indicates that the
 						 * rx traffic should be
 						 * rebalanced
diff --git a/include/net/bonding.h b/include/net/bonding.h
index b14f4c0b4e9e..552bce0168d1 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -220,8 +220,8 @@ struct bonding {
 	struct   bond_up_slave __rcu *all_slaves;
 	bool     force_primary;
 	s32      slave_cnt; /* never change this value outside the attach/detach wrappers */
-	int     (*recv_probe)(const struct sk_buff *, struct bonding *,
-			      struct slave *);
+	int     (*recv_probe)(struct sk_buff *skb, struct bonding *bond,
+			      struct slave *slave);
 	/* mode_lock is used for mode-specific locking needs, currently used by:
 	 * 3ad mode (4) - protect against running bond_3ad_unbind_slave() and
 	 *                bond_3ad_state_machine_handler() concurrently and also
@@ -639,7 +639,7 @@ struct bond_net {
 	struct class_attribute	class_attr_bonding_masters;
 };
 
-int bond_rcv_validate(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
+int bond_rcv_validate(struct sk_buff *skb, struct bonding *bond, struct slave *slave);
 netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb, struct net_device *slave_dev);
 int bond_create(struct net *net, const char *name);
 int bond_create_sysfs(struct bond_net *net);
-- 
2.27.0

