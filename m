Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AFE2B3158
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 00:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgKNXKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 18:10:02 -0500
Received: from smtp.netregistry.net ([202.124.241.204]:54682 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKNXKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 18:10:02 -0500
Received: from 124-148-94-203.tpgi.com.au ([124.148.94.203]:41324 helo=192-168-1-16.tpgi.com.au)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1ke4g7-00017o-BN; Sun, 15 Nov 2020 10:09:59 +1100
Date:   Sun, 15 Nov 2020 09:09:54 +1000
From:   Russell Strong <russell@strong.id.au>
To:     Guillaume Nault <gnault@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing
Message-ID: <20201115090954.10cf1596@192-168-1-16.tpgi.com.au>
In-Reply-To: <20201113090225.GA25425@linux.home>
References: <20201113120637.39c45f3f@192-168-1-16.tpgi.com.au>
        <20201112193656.73621cd5@hermes.local>
        <20201113090225.GA25425@linux.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated-User: russell@strong.id.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[PATCH 1/2] DSCP in IPv4 routing

TOS handling in ipv4 routing does not use all the bits in a DSCP
value.  This change introduces a sysctl "route_tos_as_dscp" control
that, when enabled, widens masks to used the 6 DSCP bits in routing.

This commit adds the sysctl

Signed-off-by: Russell Strong <russell@strong.id.au>
---
 Documentation/networking/ip-sysctl.rst |  5 +++++
 include/net/netns/ipv4.h               |  2 ++
 include/net/route.h                    | 16 ++++++++++++++++
 include/uapi/linux/in_route.h          |  3 +++
 include/uapi/linux/ip.h                |  2 ++
 net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
 6 files changed, 37 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index dd2b12a32b73..e728c58dbc08 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1596,6 +1596,11 @@ igmp_link_local_mcast_reports - BOOLEAN
 
 	Default TRUE
 
+route_tos_as_dscp - BOOLEAN
+        Interpret TOS as DSCP for routing purposes
+
+        Default 0
+
 Alexey Kuznetsov.
 kuznet@ms2.inr.ac.ru
 
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 8e4fcac4df72..8c4230090149 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -197,6 +197,8 @@ struct netns_ipv4 {
 	int sysctl_igmp_llm_reports;
 	int sysctl_igmp_qrv;
 
+	int sysctl_route_tos_as_dscp;
+
 	struct ping_group_range ping_group_range;
 
 	atomic_t dev_addr_genid;
diff --git a/include/net/route.h b/include/net/route.h
index ff021cab657e..0cc8ce316940 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -38,6 +38,22 @@
 /* IPv4 datagram length is stored into 16bit field (tot_len) */
 #define IP_MAX_MTU	0xFFFFU
 
+static inline u8 iptos_rt_mask(const struct net *net)
+{
+	if (net->ipv4.sysctl_route_tos_as_dscp)
+		return IPTOS_DS_MASK;
+	else
+		return IPTOS_TOS_MASK & ~3;
+}
+
+static inline u8 rt_tos(const struct net *net, u8 tos)
+{
+	if (net->ipv4.sysctl_route_tos_as_dscp)
+		return RT_DS(tos);
+	else
+		return RT_TOS(tos);
+}
+
 #define RTO_ONLINK	0x01
 
 #define RT_CONN_FLAGS(sk)   (RT_TOS(inet_sk(sk)->tos) | sock_flag(sk, SOCK_LOCALROUTE))
diff --git a/include/uapi/linux/in_route.h b/include/uapi/linux/in_route.h
index 0cc2c23b47f8..61a95ed2a2e0 100644
--- a/include/uapi/linux/in_route.h
+++ b/include/uapi/linux/in_route.h
@@ -28,6 +28,9 @@
 
 #define RTCF_NAT	(RTCF_DNAT|RTCF_SNAT)
 
+/* sysctl route_tos_as_dscp = 0 */
 #define RT_TOS(tos)	((tos)&IPTOS_TOS_MASK)
+/* sysctl route_tos_as_dscp = 1 */
+#define RT_DS(tos)	((tos)&IPTOS_DS_MASK)
 
 #endif /* _LINUX_IN_ROUTE_H */
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index e42d13b55cf3..4a6b01e03cab 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -20,6 +20,8 @@
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
+#define IPTOS_DS_MASK		0xFC
+#define IPTOS_DS(tos)		((tos)&IPTOS_DS_MASK)
 #define IPTOS_TOS_MASK		0x1E
 #define IPTOS_TOS(tos)		((tos)&IPTOS_TOS_MASK)
 #define	IPTOS_LOWDELAY		0x10
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 3e5f4f2e705e..61b1e2bd6bc5 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -790,6 +790,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra2		= SYSCTL_ONE,
 	},
 #endif
+	{
+		.procname	= "route_tos_as_dscp",
+		.data		= &init_net.ipv4.sysctl_route_tos_as_dscp,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	{
 		.procname	= "tcp_mtu_probing",
 		.data		= &init_net.ipv4.sysctl_tcp_mtu_probing,
-- 
2.26.2



