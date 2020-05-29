Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DCD1E86CD
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgE2Shh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:37 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46239 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727923AbgE2Shd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 22A0E5C00B2;
        Fri, 29 May 2020 14:37:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=5d+nixm9SBcocQCInco9vPmMKcxR1yDs/9iTioFwLw4=; b=oXivKQr4
        5RqrPWqcBSDybmCN2DiGVGlYAtEz3GaGDWiFX2z/TVBVP7y21oP8XxO/GXuln0p7
        e5O+NzpIJGsNA96M1xae8RplUwDbhQGtXR10qB8+oDjefum0dgNLlfdndRRX4oRq
        6sYOkQmKgvrsz6cWrXPWoX8P980nqHREZknmwt+B9aSxTVlY5psyLJ/AJ0bsWx0l
        ApaF75WbhYllX90QYaQG2y2oUusM+iUfA9ORzJPK7s3bOjaeC242rjdv2+4XQL1v
        vKJTm4JvzStJwneiEWvPmCAsxp5VJC3X+TmOPANYTsgQPQmgAsFIEQps26f721s2
        hAcqj9gZR5mvWA==
X-ME-Sender: <xms:albRXjJoadSTZ39c3uvjhpHICaradC5sOLHdXB6K8Y9mXFWIIYeoLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:a1bRXnJljNbCADic9ckrR1f2AeEp9Lc5By9uZcr70fYZCupGKc44XQ>
    <xmx:a1bRXrv1Y9XoyP2SivkI7lHhUqjkXcpC2QdlxDwWDf2ycXw6c4W6Dw>
    <xmx:a1bRXsYOnaFilxTWY8Ag7UN9aABNYOV9PYi-3o3cNSyh8YGOpEBbPg>
    <xmx:a1bRXtzsYJm0alXC4gxlfFenY7bp_QFAGQqcCwE1e-juQYCByXw57g>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B2E7D3060F09;
        Fri, 29 May 2020 14:37:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/14] devlink: Add layer 3 control packet traps
Date:   Fri, 29 May 2020 21:36:42 +0300
Message-Id: <20200529183649.1602091-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529183649.1602091-1-idosch@idosch.org>
References: <20200529183649.1602091-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add layer 3 control packet traps such as ARP and DHCP, so that capable
device drivers could register them with devlink. Add documentation for
every added packet trap and packet trap group.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../networking/devlink/devlink-trap.rst       | 143 ++++++++++++++++++
 include/net/devlink.h                         | 126 +++++++++++++++
 net/core/devlink.c                            |  42 +++++
 3 files changed, 311 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index e9fc3c9d7d7a..621b634b16be 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -288,6 +288,115 @@ be added to the following table:
    * - ``mld_v1_done``
      - ``control``
      - Traps MLD Version 1 Multicast Listener Done packets
+   * - ``ipv4_dhcp``
+     - ``control``
+     - Traps IPv4 DHCP packets
+   * - ``ipv6_dhcp``
+     - ``control``
+     - Traps IPv6 DHCP packets
+   * - ``arp_request``
+     - ``control``
+     - Traps ARP request packets
+   * - ``arp_response``
+     - ``control``
+     - Traps ARP response packets
+   * - ``arp_overlay``
+     - ``control``
+     - Traps NVE-decapsulated ARP packets that reached the overlay network.
+       This is required, for example, when the address that needs to be
+       resolved is a local address
+   * - ``ipv6_neigh_solicit``
+     - ``control``
+     - Traps IPv6 Neighbour Solicitation packets
+   * - ``ipv6_neigh_advert``
+     - ``control``
+     - Traps IPv6 Neighbour Advertisement packets
+   * - ``ipv4_bfd``
+     - ``control``
+     - Traps IPv4 BFD packets
+   * - ``ipv6_bfd``
+     - ``control``
+     - Traps IPv6 BFD packets
+   * - ``ipv4_ospf``
+     - ``control``
+     - Traps IPv4 OSPF packets
+   * - ``ipv6_ospf``
+     - ``control``
+     - Traps IPv6 OSPF packets
+   * - ``ipv4_bgp``
+     - ``control``
+     - Traps IPv4 BGP packets
+   * - ``ipv6_bgp``
+     - ``control``
+     - Traps IPv6 BGP packets
+   * - ``ipv4_vrrp``
+     - ``control``
+     - Traps IPv4 VRRP packets
+   * - ``ipv6_vrrp``
+     - ``control``
+     - Traps IPv6 VRRP packets
+   * - ``ipv4_pim``
+     - ``control``
+     - Traps IPv4 PIM packets
+   * - ``ipv6_pim``
+     - ``control``
+     - Traps IPv6 PIM packets
+   * - ``uc_loopback``
+     - ``control``
+     - Traps unicast packets that need to be routed through the same layer 3
+       interface from which they were received. Such packets are routed by the
+       kernel, but also cause it to potentially generate ICMP redirect packets
+   * - ``local_route``
+     - ``control``
+     - Traps unicast packets that hit a local route and need to be locally
+       delivered
+   * - ``external_route``
+     - ``control``
+     - Traps packets that should be routed through an external interface (e.g.,
+       management interface) that does not belong to the same device (e.g.,
+       switch ASIC) as the ingress interface
+   * - ``ipv6_uc_dip_link_local_scope``
+     - ``control``
+     - Traps unicast IPv6 packets that need to be routed and have a destination
+       IP address with a link-local scope (i.e., fe80::/10). The trap allows
+       device drivers to avoid programming link-local routes, but still receive
+       packets for local delivery
+   * - ``ipv6_dip_all_nodes``
+     - ``control``
+     - Traps IPv6 packets that their destination IP address is the "All Nodes
+       Address" (i.e., ff02::1)
+   * - ``ipv6_dip_all_routers``
+     - ``control``
+     - Traps IPv6 packets that their destination IP address is the "All Routers
+       Address" (i.e., ff02::2)
+   * - ``ipv6_router_solicit``
+     - ``control``
+     - Traps IPv6 Router Solicitation packets
+   * - ``ipv6_router_advert``
+     - ``control``
+     - Traps IPv6 Router Advertisement packets
+   * - ``ipv6_redirect``
+     - ``control``
+     - Traps IPv6 Redirect Message packets
+   * - ``ipv4_router_alert``
+     - ``control``
+     - Traps IPv4 packets that need to be routed and include the Router Alert
+       option. Such packets need to be locally delivered to raw sockets that
+       have the IP_ROUTER_ALERT socket option set
+   * - ``ipv6_router_alert``
+     - ``control``
+     - Traps IPv6 packets that need to be routed and include the Router Alert
+       option in their Hop-by-Hop extension header. Such packets need to be
+       locally delivered to raw sockets that have the IPV6_ROUTER_ALERT socket
+       option set
+   * - ``ptp_event``
+     - ``control``
+     - Traps PTP time-critical event messages (Sync, Delay_req, Pdelay_Req and
+       Pdelay_Resp)
+   * - ``ptp_general``
+     - ``control``
+     - Traps PTP general messages (Announce, Follow_Up, Delay_Resp,
+       Pdelay_Resp_Follow_Up, management and signaling)
 
 Driver-specific Packet Traps
 ============================
@@ -344,6 +453,40 @@ narrow. The description of these groups must be added to the following table:
    * - ``mc_snooping``
      - Contains packet traps for IGMP and MLD packets required for multicast
        snooping
+   * - ``dhcp``
+     - Contains packet traps for DHCP packets
+   * - ``neigh_discovery``
+     - Contains packet traps for neighbour discovery packets (e.g., ARP, IPv6
+       ND)
+   * - ``bfd``
+     - Contains packet traps for BFD packets
+   * - ``ospf``
+     - Contains packet traps for OSPF packets
+   * - ``bgp``
+     - Contains packet traps for BGP packets
+   * - ``vrrp``
+     - Contains packet traps for VRRP packets
+   * - ``pim``
+     - Contains packet traps for PIM packets
+   * - ``uc_loopback``
+     - Contains a packet trap for unicast loopback packets (i.e.,
+       ``uc_loopback``). This trap is singled-out because in cases such as
+       one-armed router it will be constantly triggered. To limit the impact on
+       the CPU usage, a packet trap policer with a low rate can be bound to the
+       group without affecting other traps
+   * - ``local_delivery``
+     - Contains packet traps for packets that should be locally delivered after
+       routing, but do not match more specific packet traps (e.g.,
+       ``ipv4_bgp``)
+   * - ``ipv6``
+     - Contains packet traps for various IPv6 control packets (e.g., Router
+       Advertisements)
+   * - ``ptp_event``
+     - Contains packet traps for PTP time-critical event messages (Sync,
+       Delay_req, Pdelay_Req and Pdelay_Resp)
+   * - ``ptp_general``
+     - Contains packet traps for PTP general messages (Announce, Follow_Up,
+       Delay_Resp, Pdelay_Resp_Follow_Up, management and signaling)
 
 Packet Trap Policers
 ====================
diff --git a/include/net/devlink.h b/include/net/devlink.h
index c0061542ad65..05a45dea976b 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -657,6 +657,36 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_MLD_V1_REPORT,
 	DEVLINK_TRAP_GENERIC_ID_MLD_V2_REPORT,
 	DEVLINK_TRAP_GENERIC_ID_MLD_V1_DONE,
+	DEVLINK_TRAP_GENERIC_ID_IPV4_DHCP,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_DHCP,
+	DEVLINK_TRAP_GENERIC_ID_ARP_REQUEST,
+	DEVLINK_TRAP_GENERIC_ID_ARP_RESPONSE,
+	DEVLINK_TRAP_GENERIC_ID_ARP_OVERLAY,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_NEIGH_SOLICIT,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_NEIGH_ADVERT,
+	DEVLINK_TRAP_GENERIC_ID_IPV4_BFD,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_BFD,
+	DEVLINK_TRAP_GENERIC_ID_IPV4_OSPF,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_OSPF,
+	DEVLINK_TRAP_GENERIC_ID_IPV4_BGP,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_BGP,
+	DEVLINK_TRAP_GENERIC_ID_IPV4_VRRP,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_VRRP,
+	DEVLINK_TRAP_GENERIC_ID_IPV4_PIM,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_PIM,
+	DEVLINK_TRAP_GENERIC_ID_UC_LB,
+	DEVLINK_TRAP_GENERIC_ID_LOCAL_ROUTE,
+	DEVLINK_TRAP_GENERIC_ID_EXTERNAL_ROUTE,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_UC_DIP_LINK_LOCAL_SCOPE,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_DIP_ALL_NODES,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_DIP_ALL_ROUTERS,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_ROUTER_SOLICIT,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_ROUTER_ADVERT,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_REDIRECT,
+	DEVLINK_TRAP_GENERIC_ID_IPV4_ROUTER_ALERT,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_ROUTER_ALERT,
+	DEVLINK_TRAP_GENERIC_ID_PTP_EVENT,
+	DEVLINK_TRAP_GENERIC_ID_PTP_GENERAL,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -677,6 +707,18 @@ enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_LACP,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_LLDP,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_MC_SNOOPING,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_DHCP,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_NEIGH_DISCOVERY,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_BFD,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_OSPF,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_BGP,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_VRRP,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_PIM,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_UC_LB,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_LOCAL_DELIVERY,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_IPV6,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_PTP_EVENT,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_PTP_GENERAL,
 
 	/* Add new generic trap group IDs above */
 	__DEVLINK_TRAP_GROUP_GENERIC_ID_MAX,
@@ -766,6 +808,66 @@ enum devlink_trap_group_generic_id {
 	"mld_v2_report"
 #define DEVLINK_TRAP_GENERIC_NAME_MLD_V1_DONE \
 	"mld_v1_done"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV4_DHCP \
+	"ipv4_dhcp"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_DHCP \
+	"ipv6_dhcp"
+#define DEVLINK_TRAP_GENERIC_NAME_ARP_REQUEST \
+	"arp_request"
+#define DEVLINK_TRAP_GENERIC_NAME_ARP_RESPONSE \
+	"arp_response"
+#define DEVLINK_TRAP_GENERIC_NAME_ARP_OVERLAY \
+	"arp_overlay"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_NEIGH_SOLICIT \
+	"ipv6_neigh_solicit"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_NEIGH_ADVERT \
+	"ipv6_neigh_advert"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV4_BFD \
+	"ipv4_bfd"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_BFD \
+	"ipv6_bfd"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV4_OSPF \
+	"ipv4_ospf"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_OSPF \
+	"ipv6_ospf"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV4_BGP \
+	"ipv4_bgp"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_BGP \
+	"ipv6_bgp"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV4_VRRP \
+	"ipv4_vrrp"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_VRRP \
+	"ipv6_vrrp"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV4_PIM \
+	"ipv4_pim"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_PIM \
+	"ipv6_pim"
+#define DEVLINK_TRAP_GENERIC_NAME_UC_LB \
+	"uc_loopback"
+#define DEVLINK_TRAP_GENERIC_NAME_LOCAL_ROUTE \
+	"local_route"
+#define DEVLINK_TRAP_GENERIC_NAME_EXTERNAL_ROUTE \
+	"external_route"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_UC_DIP_LINK_LOCAL_SCOPE \
+	"ipv6_uc_dip_link_local_scope"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_DIP_ALL_NODES \
+	"ipv6_dip_all_nodes"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_DIP_ALL_ROUTERS \
+	"ipv6_dip_all_routers"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_ROUTER_SOLICIT \
+	"ipv6_router_solicit"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_ROUTER_ADVERT \
+	"ipv6_router_advert"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_REDIRECT \
+	"ipv6_redirect"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV4_ROUTER_ALERT \
+	"ipv4_router_alert"
+#define DEVLINK_TRAP_GENERIC_NAME_IPV6_ROUTER_ALERT \
+	"ipv6_router_alert"
+#define DEVLINK_TRAP_GENERIC_NAME_PTP_EVENT \
+	"ptp_event"
+#define DEVLINK_TRAP_GENERIC_NAME_PTP_GENERAL \
+	"ptp_general"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
@@ -787,6 +889,30 @@ enum devlink_trap_group_generic_id {
 	"lldp"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_MC_SNOOPING  \
 	"mc_snooping"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_DHCP \
+	"dhcp"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_NEIGH_DISCOVERY \
+	"neigh_discovery"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_BFD \
+	"bfd"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_OSPF \
+	"ospf"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_BGP \
+	"bgp"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_VRRP \
+	"vrrp"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_PIM \
+	"pim"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_UC_LB \
+	"uc_loopback"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_LOCAL_DELIVERY \
+	"local_delivery"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_IPV6 \
+	"ipv6"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_PTP_EVENT \
+	"ptp_event"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_PTP_GENERAL \
+	"ptp_general"
 
 #define DEVLINK_TRAP_GENERIC(_type, _init_action, _id, _group_id,	      \
 			     _metadata_cap)				      \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index c91ef1b5f738..f32854c3d0e7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8507,6 +8507,36 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(MLD_V1_REPORT, CONTROL),
 	DEVLINK_TRAP(MLD_V2_REPORT, CONTROL),
 	DEVLINK_TRAP(MLD_V1_DONE, CONTROL),
+	DEVLINK_TRAP(IPV4_DHCP, CONTROL),
+	DEVLINK_TRAP(IPV6_DHCP, CONTROL),
+	DEVLINK_TRAP(ARP_REQUEST, CONTROL),
+	DEVLINK_TRAP(ARP_RESPONSE, CONTROL),
+	DEVLINK_TRAP(ARP_OVERLAY, CONTROL),
+	DEVLINK_TRAP(IPV6_NEIGH_SOLICIT, CONTROL),
+	DEVLINK_TRAP(IPV6_NEIGH_ADVERT, CONTROL),
+	DEVLINK_TRAP(IPV4_BFD, CONTROL),
+	DEVLINK_TRAP(IPV6_BFD, CONTROL),
+	DEVLINK_TRAP(IPV4_OSPF, CONTROL),
+	DEVLINK_TRAP(IPV6_OSPF, CONTROL),
+	DEVLINK_TRAP(IPV4_BGP, CONTROL),
+	DEVLINK_TRAP(IPV6_BGP, CONTROL),
+	DEVLINK_TRAP(IPV4_VRRP, CONTROL),
+	DEVLINK_TRAP(IPV6_VRRP, CONTROL),
+	DEVLINK_TRAP(IPV4_PIM, CONTROL),
+	DEVLINK_TRAP(IPV6_PIM, CONTROL),
+	DEVLINK_TRAP(UC_LB, CONTROL),
+	DEVLINK_TRAP(LOCAL_ROUTE, CONTROL),
+	DEVLINK_TRAP(EXTERNAL_ROUTE, CONTROL),
+	DEVLINK_TRAP(IPV6_UC_DIP_LINK_LOCAL_SCOPE, CONTROL),
+	DEVLINK_TRAP(IPV6_DIP_ALL_NODES, CONTROL),
+	DEVLINK_TRAP(IPV6_DIP_ALL_ROUTERS, CONTROL),
+	DEVLINK_TRAP(IPV6_ROUTER_SOLICIT, CONTROL),
+	DEVLINK_TRAP(IPV6_ROUTER_ADVERT, CONTROL),
+	DEVLINK_TRAP(IPV6_REDIRECT, CONTROL),
+	DEVLINK_TRAP(IPV4_ROUTER_ALERT, CONTROL),
+	DEVLINK_TRAP(IPV6_ROUTER_ALERT, CONTROL),
+	DEVLINK_TRAP(PTP_EVENT, CONTROL),
+	DEVLINK_TRAP(PTP_GENERAL, CONTROL),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
@@ -8526,6 +8556,18 @@ static const struct devlink_trap_group devlink_trap_group_generic[] = {
 	DEVLINK_TRAP_GROUP(LACP),
 	DEVLINK_TRAP_GROUP(LLDP),
 	DEVLINK_TRAP_GROUP(MC_SNOOPING),
+	DEVLINK_TRAP_GROUP(DHCP),
+	DEVLINK_TRAP_GROUP(NEIGH_DISCOVERY),
+	DEVLINK_TRAP_GROUP(BFD),
+	DEVLINK_TRAP_GROUP(OSPF),
+	DEVLINK_TRAP_GROUP(BGP),
+	DEVLINK_TRAP_GROUP(VRRP),
+	DEVLINK_TRAP_GROUP(PIM),
+	DEVLINK_TRAP_GROUP(UC_LB),
+	DEVLINK_TRAP_GROUP(LOCAL_DELIVERY),
+	DEVLINK_TRAP_GROUP(IPV6),
+	DEVLINK_TRAP_GROUP(PTP_EVENT),
+	DEVLINK_TRAP_GROUP(PTP_GENERAL),
 };
 
 static int devlink_trap_generic_verify(const struct devlink_trap *trap)
-- 
2.26.2

