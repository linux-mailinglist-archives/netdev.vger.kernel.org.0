Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED264B104F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242890AbiBJOYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:24:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbiBJOYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:24:03 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D35398
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 06:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FUcNHYl0fpmlgJ2yLQo9+ZKbGHwmTipa42eUnYwvIUw=; b=cAoypgbE3uBlVBdX6wOj5pYla8
        GFtgqF0IdD2/LLxOBSkIfWu+yrB8MPUuWG+0MV2Hh2DoM63j0UGJN/t4BCVNqx/HQNTUsrlHx7Gmc
        7FAj8z7z4w+zDMRs/ufB0OCO4i4QWRkaLMjim9/UJgi/AlUuVmJjm/palQGnDpJWuX4A=;
Received: from p200300daa71e0b00a1d8c0925f6cfb96.dip0.t-ipconnect.de ([2003:da:a71e:b00:a1d8:c092:5f6c:fb96] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nIAMb-0002Vw-TT
        for netdev@vger.kernel.org; Thu, 10 Feb 2022 15:24:01 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [RFC 1/2] net: bridge: add knob for filtering rx/tx BPDU packets on a port
Date:   Thu, 10 Feb 2022 15:24:00 +0100
Message-Id: <20220210142401.4912-1-nbd@nbd.name>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices (e.g. wireless APs) can't have devices behind them be part of
a bridge topology with redundant links, due to address limitations.
Additionally, broadcast traffic on these devices is somewhat expensive, due to
the low data rate and wakeups of clients in powersave mode.
This knob can be used to ensure that BPDU packets are never sent or forwarded
to/from these devices

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/if_bridge.h    | 1 +
 include/uapi/linux/if_link.h | 1 +
 net/bridge/br_forward.c      | 5 +++++
 net/bridge/br_input.c        | 2 ++
 net/bridge/br_netlink.c      | 6 +++++-
 net/bridge/br_stp_bpdu.c     | 9 +++++++--
 net/core/rtnetlink.c         | 4 +++-
 7 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 509e18c7e740..18d3b264b754 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -58,6 +58,7 @@ struct br_ip_list {
 #define BR_MRP_LOST_CONT	BIT(18)
 #define BR_MRP_LOST_IN_CONT	BIT(19)
 #define BR_TX_FWD_OFFLOAD	BIT(20)
+#define BR_BPDU_FILTER		BIT(21)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 6218f93f5c1a..4c847c2d6afa 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -537,6 +537,7 @@ enum {
 	IFLA_BRPORT_MRP_IN_OPEN,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
+	IFLA_BRPORT_BPDU_FILTER,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index ec646656dbf1..9fe5c888f27d 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -199,6 +199,7 @@ static struct net_bridge_port *maybe_deliver(
 void br_flood(struct net_bridge *br, struct sk_buff *skb,
 	      enum br_pkt_type pkt_type, bool local_rcv, bool local_orig)
 {
+	const unsigned char *dest = eth_hdr(skb)->h_dest;
 	struct net_bridge_port *prev = NULL;
 	struct net_bridge_port *p;
 
@@ -214,6 +215,10 @@ void br_flood(struct net_bridge *br, struct sk_buff *skb,
 		case BR_PKT_MULTICAST:
 			if (!(p->flags & BR_MCAST_FLOOD) && skb->dev != br->dev)
 				continue;
+			if ((p->flags & BR_BPDU_FILTER) &&
+			    unlikely(is_link_local_ether_addr(dest) &&
+				     dest[5] == 0))
+				continue;
 			break;
 		case BR_PKT_BROADCAST:
 			if (!(p->flags & BR_BCAST_FLOOD) && skb->dev != br->dev)
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index b50382f957c1..d8263c4849c1 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -316,6 +316,8 @@ static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 		fwd_mask |= p->group_fwd_mask;
 		switch (dest[5]) {
 		case 0x00:	/* Bridge Group Address */
+			if (p->flags & BR_BPDU_FILTER)
+				goto drop;
 			/* If STP is turned off,
 			   then must forward to keep loop detection */
 			if (p->br->stp_enabled == BR_NO_STP ||
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 2ff83d84230d..11215c55adc2 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -184,6 +184,7 @@ static inline size_t br_port_info_size(void)
 		+ nla_total_size(1)	/* IFLA_BRPORT_VLAN_TUNNEL */
 		+ nla_total_size(1)	/* IFLA_BRPORT_NEIGH_SUPPRESS */
 		+ nla_total_size(1)	/* IFLA_BRPORT_ISOLATED */
+		+ nla_total_size(1)	/* IFLA_BRPORT_BPDU_FILTER */
 		+ nla_total_size(sizeof(struct ifla_bridge_id))	/* IFLA_BRPORT_ROOT_ID */
 		+ nla_total_size(sizeof(struct ifla_bridge_id))	/* IFLA_BRPORT_BRIDGE_ID */
 		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_DESIGNATED_PORT */
@@ -269,7 +270,8 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 							  BR_MRP_LOST_CONT)) ||
 	    nla_put_u8(skb, IFLA_BRPORT_MRP_IN_OPEN,
 		       !!(p->flags & BR_MRP_LOST_IN_CONT)) ||
-	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)))
+	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)) ||
+	    nla_put_u8(skb, IFLA_BRPORT_BPDU_FILTER, !!(p->flags & BR_BPDU_FILTER)))
 		return -EMSGSIZE;
 
 	timerval = br_timer_value(&p->message_age_timer);
@@ -829,6 +831,7 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
 	[IFLA_BRPORT_ISOLATED]	= { .type = NLA_U8 },
 	[IFLA_BRPORT_BACKUP_PORT] = { .type = NLA_U32 },
 	[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT] = { .type = NLA_U32 },
+	[IFLA_BRPORT_BPDU_FILTER] = { .type = NLA_U8 },
 };
 
 /* Change the state of the port and notify spanning tree */
@@ -893,6 +896,7 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 	br_set_port_flag(p, tb, IFLA_BRPORT_VLAN_TUNNEL, BR_VLAN_TUNNEL);
 	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS, BR_NEIGH_SUPPRESS);
 	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
+	br_set_port_flag(p, tb, IFLA_BRPORT_BPDU_FILTER, BR_BPDU_FILTER);
 
 	changed_mask = old_flags ^ p->flags;
 
diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index 0e4572f31330..9d2a235260eb 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -80,7 +80,8 @@ void br_send_config_bpdu(struct net_bridge_port *p, struct br_config_bpdu *bpdu)
 {
 	unsigned char buf[35];
 
-	if (p->br->stp_enabled != BR_KERNEL_STP)
+	if (p->br->stp_enabled != BR_KERNEL_STP ||
+	    (p->flags & BR_BPDU_FILTER))
 		return;
 
 	buf[0] = 0;
@@ -127,7 +128,8 @@ void br_send_tcn_bpdu(struct net_bridge_port *p)
 {
 	unsigned char buf[4];
 
-	if (p->br->stp_enabled != BR_KERNEL_STP)
+	if (p->br->stp_enabled != BR_KERNEL_STP ||
+	    (p->flags & BR_BPDU_FILTER))
 		return;
 
 	buf[0] = 0;
@@ -172,6 +174,9 @@ void br_stp_rcv(const struct stp_proto *proto, struct sk_buff *skb,
 	if (!(br->dev->flags & IFF_UP))
 		goto out;
 
+	if (p->flags & BR_BPDU_FILTER)
+		goto out;
+
 	if (p->state == BR_STATE_DISABLED)
 		goto out;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 710da8a36729..00328f0dd22b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4707,7 +4707,9 @@ int ndo_dflt_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 	    brport_nla_put_flag(skb, flags, mask,
 				IFLA_BRPORT_MCAST_FLOOD, BR_MCAST_FLOOD) ||
 	    brport_nla_put_flag(skb, flags, mask,
-				IFLA_BRPORT_BCAST_FLOOD, BR_BCAST_FLOOD)) {
+				IFLA_BRPORT_BCAST_FLOOD, BR_BCAST_FLOOD) ||
+	    brport_nla_put_flag(skb, flags, mask,
+				IFLA_BRPORT_BPDU_FILTER, BR_BPDU_FILTER)) {
 		nla_nest_cancel(skb, protinfo);
 		goto nla_put_failure;
 	}
-- 
2.32.0 (Apple Git-132)

