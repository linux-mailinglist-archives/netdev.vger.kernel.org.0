Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 718D4F089
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfD3Ghm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:42 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48808 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbfD3Ghl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2310420277;
        Tue, 30 Apr 2019 08:37:38 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BUmX7wrTtCfx; Tue, 30 Apr 2019 08:37:36 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4064C2027C;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 387303180630;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 12/18] xfrm: make xfrm modes builtin
Date:   Tue, 30 Apr 2019 08:37:21 +0200
Message-ID: <20190430063727.10908-13-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430063727.10908-1-steffen.klassert@secunet.com>
References: <20190430063727.10908-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 83442F88-8C8B-4754-959A-0709CBE15F18
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

after previous changes, xfrm_mode contains no function pointers anymore
and all modules defining such struct contain no code except an init/exit
functions to register the xfrm_mode struct with the xfrm core.

Just place the xfrm modes core and remove the modules,
the run-time xfrm_mode register/unregister functionality is removed.

Before:

    text    data     bss      dec filename
    7523     200    2364    10087 net/xfrm/xfrm_input.o
   40003     628     440    41071 net/xfrm/xfrm_state.o
15730338 6937080 4046908 26714326 vmlinux

    7389     200    2364    9953  net/xfrm/xfrm_input.o
   40574     656     440   41670  net/xfrm/xfrm_state.o
15730084 6937068 4046908 26714060 vmlinux

The xfrm*_mode_{transport,tunnel,beet} modules are gone.

v2: replace CONFIG_INET6_XFRM_MODE_* IS_ENABLED guards with CONFIG_IPV6
    ones rather than removing them.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h                 |  13 +--
 net/ipv4/Kconfig                   |  29 +-----
 net/ipv4/Makefile                  |   3 -
 net/ipv4/ip_vti.c                  |   2 +-
 net/ipv4/xfrm4_mode_beet.c         |  41 --------
 net/ipv4/xfrm4_mode_transport.c    |  36 -------
 net/ipv4/xfrm4_mode_tunnel.c       |  38 -------
 net/ipv6/Kconfig                   |  35 +------
 net/ipv6/Makefile                  |   4 -
 net/ipv6/ip6_vti.c                 |   2 +-
 net/ipv6/xfrm6_mode_beet.c         |  42 --------
 net/ipv6/xfrm6_mode_ro.c           |  55 ----------
 net/ipv6/xfrm6_mode_transport.c    |  37 -------
 net/ipv6/xfrm6_mode_tunnel.c       |  45 --------
 net/xfrm/xfrm_input.c              |  13 +--
 net/xfrm/xfrm_interface.c          |   2 +-
 net/xfrm/xfrm_output.c             |  15 +--
 net/xfrm/xfrm_policy.c             |   2 +-
 net/xfrm/xfrm_state.c              | 158 +++++++++++------------------
 tools/testing/selftests/net/config |   2 -
 20 files changed, 81 insertions(+), 493 deletions(-)
 delete mode 100644 net/ipv4/xfrm4_mode_beet.c
 delete mode 100644 net/ipv4/xfrm4_mode_transport.c
 delete mode 100644 net/ipv4/xfrm4_mode_tunnel.c
 delete mode 100644 net/ipv6/xfrm6_mode_beet.c
 delete mode 100644 net/ipv6/xfrm6_mode_ro.c
 delete mode 100644 net/ipv6/xfrm6_mode_transport.c
 delete mode 100644 net/ipv6/xfrm6_mode_tunnel.c

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 8d1c9506bcf6..4ca79cdc3460 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -234,9 +234,9 @@ struct xfrm_state {
 	/* Reference to data common to all the instances of this
 	 * transformer. */
 	const struct xfrm_type	*type;
-	struct xfrm_mode	*inner_mode;
-	struct xfrm_mode	*inner_mode_iaf;
-	struct xfrm_mode	*outer_mode;
+	const struct xfrm_mode	*inner_mode;
+	const struct xfrm_mode	*inner_mode_iaf;
+	const struct xfrm_mode	*outer_mode;
 
 	const struct xfrm_type_offload	*type_offload;
 
@@ -347,7 +347,6 @@ struct xfrm_state_afinfo {
 	struct module			*owner;
 	const struct xfrm_type		*type_map[IPPROTO_MAX];
 	const struct xfrm_type_offload	*type_offload_map[IPPROTO_MAX];
-	struct xfrm_mode		*mode_map[XFRM_MODE_MAX];
 
 	int			(*init_flags)(struct xfrm_state *x);
 	void			(*init_tempsel)(struct xfrm_selector *sel,
@@ -423,7 +422,6 @@ int xfrm_register_type_offload(const struct xfrm_type_offload *type, unsigned sh
 int xfrm_unregister_type_offload(const struct xfrm_type_offload *type, unsigned short family);
 
 struct xfrm_mode {
-	struct module *owner;
 	u8 encap;
 	u8 family;
 	u8 flags;
@@ -434,9 +432,6 @@ enum {
 	XFRM_MODE_FLAG_TUNNEL = 1,
 };
 
-int xfrm_register_mode(struct xfrm_mode *mode);
-void xfrm_unregister_mode(struct xfrm_mode *mode);
-
 static inline int xfrm_af2proto(unsigned int family)
 {
 	switch(family) {
@@ -449,7 +444,7 @@ static inline int xfrm_af2proto(unsigned int family)
 	}
 }
 
-static inline struct xfrm_mode *xfrm_ip2inner_mode(struct xfrm_state *x, int ipproto)
+static inline const struct xfrm_mode *xfrm_ip2inner_mode(struct xfrm_state *x, int ipproto)
 {
 	if ((ipproto == IPPROTO_IPIP && x->props.family == AF_INET) ||
 	    (ipproto == IPPROTO_IPV6 && x->props.family == AF_INET6))
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 32cae39cdff6..8108e97d4285 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -304,7 +304,7 @@ config NET_IPVTI
 	tristate "Virtual (secure) IP: tunneling"
 	select INET_TUNNEL
 	select NET_IP_TUNNEL
-	depends on INET_XFRM_MODE_TUNNEL
+	select XFRM
 	---help---
 	  Tunneling means encapsulating data of one protocol type within
 	  another protocol and sending it over a channel that understands the
@@ -396,33 +396,6 @@ config INET_TUNNEL
 	tristate
 	default n
 
-config INET_XFRM_MODE_TRANSPORT
-	tristate "IP: IPsec transport mode"
-	default y
-	select XFRM
-	---help---
-	  Support for IPsec transport mode.
-
-	  If unsure, say Y.
-
-config INET_XFRM_MODE_TUNNEL
-	tristate "IP: IPsec tunnel mode"
-	default y
-	select XFRM
-	---help---
-	  Support for IPsec tunnel mode.
-
-	  If unsure, say Y.
-
-config INET_XFRM_MODE_BEET
-	tristate "IP: IPsec BEET mode"
-	default y
-	select XFRM
-	---help---
-	  Support for IPsec BEET mode.
-
-	  If unsure, say Y.
-
 config INET_DIAG
 	tristate "INET: socket monitoring interface"
 	default y
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 58629314eae9..000a61994c8f 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -37,10 +37,7 @@ obj-$(CONFIG_INET_ESP) += esp4.o
 obj-$(CONFIG_INET_ESP_OFFLOAD) += esp4_offload.o
 obj-$(CONFIG_INET_IPCOMP) += ipcomp.o
 obj-$(CONFIG_INET_XFRM_TUNNEL) += xfrm4_tunnel.o
-obj-$(CONFIG_INET_XFRM_MODE_BEET) += xfrm4_mode_beet.o
 obj-$(CONFIG_INET_TUNNEL) += tunnel4.o
-obj-$(CONFIG_INET_XFRM_MODE_TRANSPORT) += xfrm4_mode_transport.o
-obj-$(CONFIG_INET_XFRM_MODE_TUNNEL) += xfrm4_mode_tunnel.o
 obj-$(CONFIG_IP_PNP) += ipconfig.o
 obj-$(CONFIG_NETFILTER)	+= netfilter.o netfilter/
 obj-$(CONFIG_INET_DIAG) += inet_diag.o
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 3f3f6d6be318..91926c9a3bc9 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -107,7 +107,7 @@ static int vti_rcv_cb(struct sk_buff *skb, int err)
 	struct net_device *dev;
 	struct pcpu_sw_netstats *tstats;
 	struct xfrm_state *x;
-	struct xfrm_mode *inner_mode;
+	const struct xfrm_mode *inner_mode;
 	struct ip_tunnel *tunnel = XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4;
 	u32 orig_mark = skb->mark;
 	int ret;
diff --git a/net/ipv4/xfrm4_mode_beet.c b/net/ipv4/xfrm4_mode_beet.c
deleted file mode 100644
index ba84b278e627..000000000000
--- a/net/ipv4/xfrm4_mode_beet.c
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * xfrm4_mode_beet.c - BEET mode encapsulation for IPv4.
- *
- * Copyright (c) 2006 Diego Beltrami <diego.beltrami@gmail.com>
- *                    Miika Komu     <miika@iki.fi>
- *                    Herbert Xu     <herbert@gondor.apana.org.au>
- *                    Abhinav Pathak <abhinav.pathak@hiit.fi>
- *                    Jeff Ahrenholz <ahrenholz@gmail.com>
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/stringify.h>
-#include <net/dst.h>
-#include <net/ip.h>
-#include <net/xfrm.h>
-
-
-static struct xfrm_mode xfrm4_beet_mode = {
-	.owner = THIS_MODULE,
-	.encap = XFRM_MODE_BEET,
-	.flags = XFRM_MODE_FLAG_TUNNEL,
-	.family = AF_INET,
-};
-
-static int __init xfrm4_beet_init(void)
-{
-	return xfrm_register_mode(&xfrm4_beet_mode);
-}
-
-static void __exit xfrm4_beet_exit(void)
-{
-	xfrm_unregister_mode(&xfrm4_beet_mode);
-}
-
-module_init(xfrm4_beet_init);
-module_exit(xfrm4_beet_exit);
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_XFRM_MODE(AF_INET, XFRM_MODE_BEET);
diff --git a/net/ipv4/xfrm4_mode_transport.c b/net/ipv4/xfrm4_mode_transport.c
deleted file mode 100644
index 397863ea762b..000000000000
--- a/net/ipv4/xfrm4_mode_transport.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * xfrm4_mode_transport.c - Transport mode encapsulation for IPv4.
- *
- * Copyright (c) 2004-2006 Herbert Xu <herbert@gondor.apana.org.au>
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/stringify.h>
-#include <net/dst.h>
-#include <net/ip.h>
-#include <net/xfrm.h>
-#include <net/protocol.h>
-
-static struct xfrm_mode xfrm4_transport_mode = {
-	.owner = THIS_MODULE,
-	.encap = XFRM_MODE_TRANSPORT,
-	.family = AF_INET,
-};
-
-static int __init xfrm4_transport_init(void)
-{
-	return xfrm_register_mode(&xfrm4_transport_mode);
-}
-
-static void __exit xfrm4_transport_exit(void)
-{
-	xfrm_unregister_mode(&xfrm4_transport_mode);
-}
-
-module_init(xfrm4_transport_init);
-module_exit(xfrm4_transport_exit);
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_XFRM_MODE(AF_INET, XFRM_MODE_TRANSPORT);
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
deleted file mode 100644
index b2b132c800fc..000000000000
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * xfrm4_mode_tunnel.c - Tunnel mode encapsulation for IPv4.
- *
- * Copyright (c) 2004-2006 Herbert Xu <herbert@gondor.apana.org.au>
- */
-
-#include <linux/gfp.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/stringify.h>
-#include <net/dst.h>
-#include <net/inet_ecn.h>
-#include <net/ip.h>
-#include <net/xfrm.h>
-
-static struct xfrm_mode xfrm4_tunnel_mode = {
-	.owner = THIS_MODULE,
-	.encap = XFRM_MODE_TUNNEL,
-	.flags = XFRM_MODE_FLAG_TUNNEL,
-	.family = AF_INET,
-};
-
-static int __init xfrm4_mode_tunnel_init(void)
-{
-	return xfrm_register_mode(&xfrm4_tunnel_mode);
-}
-
-static void __exit xfrm4_mode_tunnel_exit(void)
-{
-	xfrm_unregister_mode(&xfrm4_tunnel_mode);
-}
-
-module_init(xfrm4_mode_tunnel_init);
-module_exit(xfrm4_mode_tunnel_exit);
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_XFRM_MODE(AF_INET, XFRM_MODE_TUNNEL);
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 613282c65a10..cd915e332c98 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -135,44 +135,11 @@ config INET6_TUNNEL
 	tristate
 	default n
 
-config INET6_XFRM_MODE_TRANSPORT
-	tristate "IPv6: IPsec transport mode"
-	default IPV6
-	select XFRM
-	---help---
-	  Support for IPsec transport mode.
-
-	  If unsure, say Y.
-
-config INET6_XFRM_MODE_TUNNEL
-	tristate "IPv6: IPsec tunnel mode"
-	default IPV6
-	select XFRM
-	---help---
-	  Support for IPsec tunnel mode.
-
-	  If unsure, say Y.
-
-config INET6_XFRM_MODE_BEET
-	tristate "IPv6: IPsec BEET mode"
-	default IPV6
-	select XFRM
-	---help---
-	  Support for IPsec BEET mode.
-
-	  If unsure, say Y.
-
-config INET6_XFRM_MODE_ROUTEOPTIMIZATION
-	tristate "IPv6: MIPv6 route optimization mode"
-	select XFRM
-	---help---
-	  Support for MIPv6 route optimization mode.
-
 config IPV6_VTI
 tristate "Virtual (secure) IPv6: tunneling"
 	select IPV6_TUNNEL
 	select NET_IP_TUNNEL
-	depends on INET6_XFRM_MODE_TUNNEL
+	select XFRM
 	---help---
 	Tunneling means encapsulating data of one protocol type within
 	another protocol and sending it over a channel that understands the
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index e0026fa1261b..8ccf35514015 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -35,10 +35,6 @@ obj-$(CONFIG_INET6_ESP_OFFLOAD) += esp6_offload.o
 obj-$(CONFIG_INET6_IPCOMP) += ipcomp6.o
 obj-$(CONFIG_INET6_XFRM_TUNNEL) += xfrm6_tunnel.o
 obj-$(CONFIG_INET6_TUNNEL) += tunnel6.o
-obj-$(CONFIG_INET6_XFRM_MODE_TRANSPORT) += xfrm6_mode_transport.o
-obj-$(CONFIG_INET6_XFRM_MODE_TUNNEL) += xfrm6_mode_tunnel.o
-obj-$(CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION) += xfrm6_mode_ro.o
-obj-$(CONFIG_INET6_XFRM_MODE_BEET) += xfrm6_mode_beet.o
 obj-$(CONFIG_IPV6_MIP6) += mip6.o
 obj-$(CONFIG_IPV6_ILA) += ila/
 obj-$(CONFIG_NETFILTER)	+= netfilter/
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 369803c581b7..71ec5e60cf8f 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -342,7 +342,7 @@ static int vti6_rcv_cb(struct sk_buff *skb, int err)
 	struct net_device *dev;
 	struct pcpu_sw_netstats *tstats;
 	struct xfrm_state *x;
-	struct xfrm_mode *inner_mode;
+	const struct xfrm_mode *inner_mode;
 	struct ip6_tnl *t = XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6;
 	u32 orig_mark = skb->mark;
 	int ret;
diff --git a/net/ipv6/xfrm6_mode_beet.c b/net/ipv6/xfrm6_mode_beet.c
deleted file mode 100644
index 1c4a76bdd889..000000000000
--- a/net/ipv6/xfrm6_mode_beet.c
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * xfrm6_mode_beet.c - BEET mode encapsulation for IPv6.
- *
- * Copyright (c) 2006 Diego Beltrami <diego.beltrami@gmail.com>
- *                    Miika Komu     <miika@iki.fi>
- *                    Herbert Xu     <herbert@gondor.apana.org.au>
- *                    Abhinav Pathak <abhinav.pathak@hiit.fi>
- *                    Jeff Ahrenholz <ahrenholz@gmail.com>
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/stringify.h>
-#include <net/dsfield.h>
-#include <net/dst.h>
-#include <net/inet_ecn.h>
-#include <net/ipv6.h>
-#include <net/xfrm.h>
-
-static struct xfrm_mode xfrm6_beet_mode = {
-	.owner = THIS_MODULE,
-	.encap = XFRM_MODE_BEET,
-	.flags = XFRM_MODE_FLAG_TUNNEL,
-	.family = AF_INET6,
-};
-
-static int __init xfrm6_beet_init(void)
-{
-	return xfrm_register_mode(&xfrm6_beet_mode);
-}
-
-static void __exit xfrm6_beet_exit(void)
-{
-	xfrm_unregister_mode(&xfrm6_beet_mode);
-}
-
-module_init(xfrm6_beet_init);
-module_exit(xfrm6_beet_exit);
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_XFRM_MODE(AF_INET6, XFRM_MODE_BEET);
diff --git a/net/ipv6/xfrm6_mode_ro.c b/net/ipv6/xfrm6_mode_ro.c
deleted file mode 100644
index d0a6a4dbd689..000000000000
--- a/net/ipv6/xfrm6_mode_ro.c
+++ /dev/null
@@ -1,55 +0,0 @@
-/*
- * xfrm6_mode_ro.c - Route optimization mode for IPv6.
- *
- * Copyright (C)2003-2006 Helsinki University of Technology
- * Copyright (C)2003-2006 USAGI/WIDE Project
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
-/*
- * Authors:
- *	Noriaki TAKAMIYA @USAGI
- *	Masahide NAKAMURA @USAGI
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/spinlock.h>
-#include <linux/stringify.h>
-#include <linux/time.h>
-#include <net/ipv6.h>
-#include <net/xfrm.h>
-
-static struct xfrm_mode xfrm6_ro_mode = {
-	.owner = THIS_MODULE,
-	.encap = XFRM_MODE_ROUTEOPTIMIZATION,
-	.family = AF_INET6,
-};
-
-static int __init xfrm6_ro_init(void)
-{
-	return xfrm_register_mode(&xfrm6_ro_mode);
-}
-
-static void __exit xfrm6_ro_exit(void)
-{
-	xfrm_unregister_mode(&xfrm6_ro_mode);
-}
-
-module_init(xfrm6_ro_init);
-module_exit(xfrm6_ro_exit);
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_XFRM_MODE(AF_INET6, XFRM_MODE_ROUTEOPTIMIZATION);
diff --git a/net/ipv6/xfrm6_mode_transport.c b/net/ipv6/xfrm6_mode_transport.c
deleted file mode 100644
index d90c934c2f1a..000000000000
--- a/net/ipv6/xfrm6_mode_transport.c
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * xfrm6_mode_transport.c - Transport mode encapsulation for IPv6.
- *
- * Copyright (C) 2002 USAGI/WIDE Project
- * Copyright (c) 2004-2006 Herbert Xu <herbert@gondor.apana.org.au>
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/stringify.h>
-#include <net/dst.h>
-#include <net/ipv6.h>
-#include <net/xfrm.h>
-#include <net/protocol.h>
-
-static struct xfrm_mode xfrm6_transport_mode = {
-	.owner = THIS_MODULE,
-	.encap = XFRM_MODE_TRANSPORT,
-	.family = AF_INET6,
-};
-
-static int __init xfrm6_transport_init(void)
-{
-	return xfrm_register_mode(&xfrm6_transport_mode);
-}
-
-static void __exit xfrm6_transport_exit(void)
-{
-	xfrm_unregister_mode(&xfrm6_transport_mode);
-}
-
-module_init(xfrm6_transport_init);
-module_exit(xfrm6_transport_exit);
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_XFRM_MODE(AF_INET6, XFRM_MODE_TRANSPORT);
diff --git a/net/ipv6/xfrm6_mode_tunnel.c b/net/ipv6/xfrm6_mode_tunnel.c
deleted file mode 100644
index e5c928dd70e3..000000000000
--- a/net/ipv6/xfrm6_mode_tunnel.c
+++ /dev/null
@@ -1,45 +0,0 @@
-/*
- * xfrm6_mode_tunnel.c - Tunnel mode encapsulation for IPv6.
- *
- * Copyright (C) 2002 USAGI/WIDE Project
- * Copyright (c) 2004-2006 Herbert Xu <herbert@gondor.apana.org.au>
- */
-
-#include <linux/gfp.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/stringify.h>
-#include <net/dsfield.h>
-#include <net/dst.h>
-#include <net/inet_ecn.h>
-#include <net/ip6_route.h>
-#include <net/ipv6.h>
-#include <net/xfrm.h>
-
-/* Add encapsulation header.
- *
- * The top IP header will be constructed per RFC 2401.
- */
-static struct xfrm_mode xfrm6_tunnel_mode = {
-	.owner = THIS_MODULE,
-	.encap = XFRM_MODE_TUNNEL,
-	.flags = XFRM_MODE_FLAG_TUNNEL,
-	.family = AF_INET6,
-};
-
-static int __init xfrm6_mode_tunnel_init(void)
-{
-	return xfrm_register_mode(&xfrm6_tunnel_mode);
-}
-
-static void __exit xfrm6_mode_tunnel_exit(void)
-{
-	xfrm_unregister_mode(&xfrm6_tunnel_mode);
-}
-
-module_init(xfrm6_mode_tunnel_init);
-module_exit(xfrm6_mode_tunnel_exit);
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_XFRM_MODE(AF_INET6, XFRM_MODE_TUNNEL);
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 74b53c13279b..b5a31c8e2088 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -351,7 +351,7 @@ xfrm_inner_mode_encap_remove(struct xfrm_state *x,
 
 static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 {
-	struct xfrm_mode *inner_mode = x->inner_mode;
+	const struct xfrm_mode *inner_mode = x->inner_mode;
 	const struct xfrm_state_afinfo *afinfo;
 	int err = -EAFNOSUPPORT;
 
@@ -394,7 +394,6 @@ static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
  */
 static int xfrm4_transport_input(struct xfrm_state *x, struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_INET_XFRM_MODE_TRANSPORT)
 	int ihl = skb->data - skb_transport_header(skb);
 
 	if (skb->transport_header != skb->network_header) {
@@ -405,14 +404,11 @@ static int xfrm4_transport_input(struct xfrm_state *x, struct sk_buff *skb)
 	ip_hdr(skb)->tot_len = htons(skb->len + ihl);
 	skb_reset_transport_header(skb);
 	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int xfrm6_transport_input(struct xfrm_state *x, struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_INET6_XFRM_MODE_TRANSPORT)
+#if IS_ENABLED(CONFIG_IPV6)
 	int ihl = skb->data - skb_transport_header(skb);
 
 	if (skb->transport_header != skb->network_header) {
@@ -425,7 +421,8 @@ static int xfrm6_transport_input(struct xfrm_state *x, struct sk_buff *skb)
 	skb_reset_transport_header(skb);
 	return 0;
 #else
-	return -EOPNOTSUPP;
+	WARN_ON_ONCE(1);
+	return -EAFNOSUPPORT;
 #endif
 }
 
@@ -458,12 +455,12 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 {
 	const struct xfrm_state_afinfo *afinfo;
 	struct net *net = dev_net(skb->dev);
+	const struct xfrm_mode *inner_mode;
 	int err;
 	__be32 seq;
 	__be32 seq_hi;
 	struct xfrm_state *x = NULL;
 	xfrm_address_t *daddr;
-	struct xfrm_mode *inner_mode;
 	u32 mark = skb->mark;
 	unsigned int family = AF_UNSPEC;
 	int decaps = 0;
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 93efb0965e7d..4fc49dbf3edf 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -244,8 +244,8 @@ static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
 
 static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 {
+	const struct xfrm_mode *inner_mode;
 	struct pcpu_sw_netstats *tstats;
-	struct xfrm_mode *inner_mode;
 	struct net_device *dev;
 	struct xfrm_state *x;
 	struct xfrm_if *xi;
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 17c4f58d28ea..3cb2a328a8ab 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -61,7 +61,6 @@ static struct dst_entry *skb_dst_pop(struct sk_buff *skb)
  */
 static int xfrm4_transport_output(struct xfrm_state *x, struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_INET_XFRM_MODE_TRANSPORT)
 	struct iphdr *iph = ip_hdr(skb);
 	int ihl = iph->ihl * 4;
 
@@ -74,10 +73,6 @@ static int xfrm4_transport_output(struct xfrm_state *x, struct sk_buff *skb)
 	__skb_pull(skb, ihl);
 	memmove(skb_network_header(skb), iph, ihl);
 	return 0;
-#else
-	WARN_ON_ONCE(1);
-	return -EOPNOTSUPP;
-#endif
 }
 
 /* Add encapsulation header.
@@ -87,7 +82,7 @@ static int xfrm4_transport_output(struct xfrm_state *x, struct sk_buff *skb)
  */
 static int xfrm6_transport_output(struct xfrm_state *x, struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_INET6_XFRM_MODE_TRANSPORT)
+#if IS_ENABLED(CONFIG_IPV6)
 	struct ipv6hdr *iph;
 	u8 *prevhdr;
 	int hdr_len;
@@ -107,7 +102,7 @@ static int xfrm6_transport_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 #else
 	WARN_ON_ONCE(1);
-	return -EOPNOTSUPP;
+	return -EAFNOSUPPORT;
 #endif
 }
 
@@ -118,7 +113,7 @@ static int xfrm6_transport_output(struct xfrm_state *x, struct sk_buff *skb)
  */
 static int xfrm6_ro_output(struct xfrm_state *x, struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION)
+#if IS_ENABLED(CONFIG_IPV6)
 	struct ipv6hdr *iph;
 	u8 *prevhdr;
 	int hdr_len;
@@ -140,7 +135,7 @@ static int xfrm6_ro_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 #else
 	WARN_ON_ONCE(1);
-	return -EOPNOTSUPP;
+	return -EAFNOSUPPORT;
 #endif
 }
 
@@ -624,7 +619,7 @@ EXPORT_SYMBOL_GPL(xfrm_output);
 static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 	const struct xfrm_state_afinfo *afinfo;
-	struct xfrm_mode *inner_mode;
+	const struct xfrm_mode *inner_mode;
 	int err = -EAFNOSUPPORT;
 
 	if (x->sel.family == AF_UNSPEC)
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 67122beb116c..1a5fd2296556 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2546,10 +2546,10 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 					    struct dst_entry *dst)
 {
 	const struct xfrm_state_afinfo *afinfo;
+	const struct xfrm_mode *inner_mode;
 	struct net *net = xp_net(policy);
 	unsigned long now = jiffies;
 	struct net_device *dev;
-	struct xfrm_mode *inner_mode;
 	struct xfrm_dst *xdst_prev = NULL;
 	struct xfrm_dst *xdst0 = NULL;
 	int i = 0;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 358b09f0d018..ace26f6dc790 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -330,92 +330,67 @@ static void xfrm_put_type_offload(const struct xfrm_type_offload *type)
 	module_put(type->owner);
 }
 
-static DEFINE_SPINLOCK(xfrm_mode_lock);
-int xfrm_register_mode(struct xfrm_mode *mode)
-{
-	struct xfrm_state_afinfo *afinfo;
-	struct xfrm_mode **modemap;
-	int err;
-
-	if (unlikely(mode->encap >= XFRM_MODE_MAX))
-		return -EINVAL;
-
-	afinfo = xfrm_state_get_afinfo(mode->family);
-	if (unlikely(afinfo == NULL))
-		return -EAFNOSUPPORT;
-
-	err = -EEXIST;
-	modemap = afinfo->mode_map;
-	spin_lock_bh(&xfrm_mode_lock);
-	if (modemap[mode->encap])
-		goto out;
-
-	err = -ENOENT;
-	if (!try_module_get(afinfo->owner))
-		goto out;
-
-	modemap[mode->encap] = mode;
-	err = 0;
-
-out:
-	spin_unlock_bh(&xfrm_mode_lock);
-	rcu_read_unlock();
-	return err;
-}
-EXPORT_SYMBOL(xfrm_register_mode);
-
-void xfrm_unregister_mode(struct xfrm_mode *mode)
-{
-	struct xfrm_state_afinfo *afinfo;
-	struct xfrm_mode **modemap;
-
-	afinfo = xfrm_state_get_afinfo(mode->family);
-	if (WARN_ON_ONCE(!afinfo))
-		return;
-
-	modemap = afinfo->mode_map;
-	spin_lock_bh(&xfrm_mode_lock);
-	if (likely(modemap[mode->encap] == mode)) {
-		modemap[mode->encap] = NULL;
-		module_put(afinfo->owner);
-	}
-
-	spin_unlock_bh(&xfrm_mode_lock);
-	rcu_read_unlock();
-}
-EXPORT_SYMBOL(xfrm_unregister_mode);
-
-static struct xfrm_mode *xfrm_get_mode(unsigned int encap, int family)
-{
-	struct xfrm_state_afinfo *afinfo;
-	struct xfrm_mode *mode;
-	int modload_attempted = 0;
+static const struct xfrm_mode xfrm4_mode_map[XFRM_MODE_MAX] = {
+	[XFRM_MODE_BEET] = {
+		.encap = XFRM_MODE_BEET,
+		.flags = XFRM_MODE_FLAG_TUNNEL,
+		.family = AF_INET,
+	},
+	[XFRM_MODE_TRANSPORT] = {
+		.encap = XFRM_MODE_TRANSPORT,
+		.family = AF_INET,
+	},
+	[XFRM_MODE_TUNNEL] = {
+		.encap = XFRM_MODE_TUNNEL,
+		.flags = XFRM_MODE_FLAG_TUNNEL,
+		.family = AF_INET,
+	},
+};
+
+static const struct xfrm_mode xfrm6_mode_map[XFRM_MODE_MAX] = {
+	[XFRM_MODE_BEET] = {
+		.encap = XFRM_MODE_BEET,
+		.flags = XFRM_MODE_FLAG_TUNNEL,
+		.family = AF_INET6,
+	},
+	[XFRM_MODE_ROUTEOPTIMIZATION] = {
+		.encap = XFRM_MODE_ROUTEOPTIMIZATION,
+		.family = AF_INET6,
+	},
+	[XFRM_MODE_TRANSPORT] = {
+		.encap = XFRM_MODE_TRANSPORT,
+		.family = AF_INET6,
+	},
+	[XFRM_MODE_TUNNEL] = {
+		.encap = XFRM_MODE_TUNNEL,
+		.flags = XFRM_MODE_FLAG_TUNNEL,
+		.family = AF_INET6,
+	},
+};
+
+static const struct xfrm_mode *xfrm_get_mode(unsigned int encap, int family)
+{
+	const struct xfrm_mode *mode;
 
 	if (unlikely(encap >= XFRM_MODE_MAX))
 		return NULL;
 
-retry:
-	afinfo = xfrm_state_get_afinfo(family);
-	if (unlikely(afinfo == NULL))
-		return NULL;
-
-	mode = READ_ONCE(afinfo->mode_map[encap]);
-	if (unlikely(mode && !try_module_get(mode->owner)))
-		mode = NULL;
-
-	rcu_read_unlock();
-	if (!mode && !modload_attempted) {
-		request_module("xfrm-mode-%d-%d", family, encap);
-		modload_attempted = 1;
-		goto retry;
+	switch (family) {
+	case AF_INET:
+		mode = &xfrm4_mode_map[encap];
+		if (mode->family == family)
+			return mode;
+		break;
+	case AF_INET6:
+		mode = &xfrm6_mode_map[encap];
+		if (mode->family == family)
+			return mode;
+		break;
+	default:
+		break;
 	}
 
-	return mode;
-}
-
-static void xfrm_put_mode(struct xfrm_mode *mode)
-{
-	module_put(mode->owner);
+	return NULL;
 }
 
 void xfrm_state_free(struct xfrm_state *x)
@@ -436,12 +411,6 @@ static void ___xfrm_state_destroy(struct xfrm_state *x)
 	kfree(x->coaddr);
 	kfree(x->replay_esn);
 	kfree(x->preplay_esn);
-	if (x->inner_mode)
-		xfrm_put_mode(x->inner_mode);
-	if (x->inner_mode_iaf)
-		xfrm_put_mode(x->inner_mode_iaf);
-	if (x->outer_mode)
-		xfrm_put_mode(x->outer_mode);
 	if (x->type_offload)
 		xfrm_put_type_offload(x->type_offload);
 	if (x->type) {
@@ -2235,8 +2204,8 @@ int xfrm_state_mtu(struct xfrm_state *x, int mtu)
 
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 {
-	struct xfrm_state_afinfo *afinfo;
-	struct xfrm_mode *inner_mode;
+	const struct xfrm_mode *inner_mode;
+	const struct xfrm_state_afinfo *afinfo;
 	int family = x->props.family;
 	int err;
 
@@ -2262,24 +2231,21 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 			goto error;
 
 		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL) &&
-		    family != x->sel.family) {
-			xfrm_put_mode(inner_mode);
+		    family != x->sel.family)
 			goto error;
-		}
 
 		x->inner_mode = inner_mode;
 	} else {
-		struct xfrm_mode *inner_mode_iaf;
+		const struct xfrm_mode *inner_mode_iaf;
 		int iafamily = AF_INET;
 
 		inner_mode = xfrm_get_mode(x->props.mode, x->props.family);
 		if (inner_mode == NULL)
 			goto error;
 
-		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL)) {
-			xfrm_put_mode(inner_mode);
+		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL))
 			goto error;
-		}
+
 		x->inner_mode = inner_mode;
 
 		if (x->props.family == AF_INET)
@@ -2289,8 +2255,6 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 		if (inner_mode_iaf) {
 			if (inner_mode_iaf->flags & XFRM_MODE_FLAG_TUNNEL)
 				x->inner_mode_iaf = inner_mode_iaf;
-			else
-				xfrm_put_mode(inner_mode_iaf);
 		}
 	}
 
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index e9c860d00416..474040448601 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -7,9 +7,7 @@ CONFIG_NET_L3_MASTER_DEV=y
 CONFIG_IPV6=y
 CONFIG_IPV6_MULTIPLE_TABLES=y
 CONFIG_VETH=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
 CONFIG_NET_IPVTI=y
-CONFIG_INET6_XFRM_MODE_TUNNEL=y
 CONFIG_IPV6_VTI=y
 CONFIG_DUMMY=y
 CONFIG_BRIDGE=y
-- 
2.17.1

