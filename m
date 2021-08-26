Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E97D3F89A0
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 16:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242822AbhHZODN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 10:03:13 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:39641 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhHZODJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 10:03:09 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id A9334200C25B;
        Thu, 26 Aug 2021 16:02:17 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be A9334200C25B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1629986537;
        bh=tVHOUYKC6Bqb16kik+Pl3YtqCENndJJ03Hj5Zk6Om+I=;
        h=From:To:Cc:Subject:Date:From;
        b=opxpfxKctbIlI47poy0bwmrkaiiIuPhSEFrncu2fS5A64yBM+JJuq7s6pGqPB3I3I
         6meOcpoXdxthMEuuGT+RDF+Bg/K2WqHap7ChWii89icTVS3o8RtYRTZS69ubzKxwWg
         OiMjBrRdBD66Y9LpTH1YwtHOmxTwHHqEIPqzxdk6Bp3zya8S2now4nHX+Co+Xs6oAb
         TIjTa8EA38B5RG6rwogyxrlXZqSXw5nVFwWDLfvVXv4W7q6QsuCvF8DDIuesnqcPpJ
         079yxRxLwjL63QtTNgqF9Yba2OYDaX6vVFx87CiScHGximIr25gwbtHDl9pNUMWkRT
         eekVHvl/dAScA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tom@herbertland.com, edumazet@google.com,
        justin.iurman@uliege.be
Subject: [RFC net-next] ipv6: Support for anonymous tunnel decapsulation
Date:   Thu, 26 Aug 2021 16:01:50 +0200
Message-Id: <20210826140150.19920-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nowadays, there are more and more private domains where a lot of ingresses and
egresses must be linked altogether. Configuring each possible tunnel explicitly
could quickly become a nightmare in such use case. Therefore, introducing
support for ip6ip6 decapsulation without an explicit tunnel configuration looks
like the best solution (e.g., for IOAM). For now, this patch only adds support
for ip6ip6 decap, but ip6ip4 could probably be added too if needed.

Last year, we had an interesting discussion [1] with Tom about this topic, and
especially on how such solution could be implemented in a more generic way. Here
is the summary of the thread.

Tom said:
"This is just IP in IP encapsulation that happens to be terminated at
an egress node of the IOAM domain. The fact that it's IOAM isn't
germaine, this IP in IP is done in a variety of ways. We should be
using the normal protocol handler for NEXTHDR_IPV6  instead of special
case code."

He also said:
"The current implementation might not be what you're looking for since
ip6ip6 wants a tunnel configured. What we really want is more like
anonymous decapsulation, that is just decap the ip6ip6 packet and
resubmit the packet into the stack (this is what you patch is doing).
The idea has been kicked around before, especially in the use case
where we're tunneling across a domain and there could be hundreds of
such tunnels to some device. I think it's generally okay to do this,
although someone might raise security concerns since it sort of
obfuscates the "real packet". Probably makes sense to have a sysctl to
enable this and probably could default to on. Of course, if we do this
the next question is should we also implement anonymous decapsulation
for 44,64,46 tunnels."

Based on the above, here is a generic solution to introduce anonymous tunnels
for IPv6. We know that the tunnel6 module is, when loaded, already responsible
for handling IPPROTO_IPV6 from an IPv6 context (= ip6ip6). Therefore, when
tunnel6 is loaded, it handles ip6ip6 with its tunnel6_rcv handler. Inside the
handler, we add a check for anonymous tunnel decapsulation and, if enabled,
perform the decap. When tunnel6 is unloaded, it gives the responsability back to
tunnel6_anonymous and its own handler. Note that the introduced sysctl to
enable anonymous decapsulation is equal to 0 (= disabled) by default. Indeed,
as opposed to what Tom suggested, I think it should be disabled by default in
order to make sure that users won't have it enabled without knowing it (for
security reasons, obviously).

Thoughts?

Some feedback would be really appreciated, specifically on these points:
 - Should the anonymous decapsulation happen before (as it is right now) or
   after tunnel6 handlers? "Before" looks like the most logical solution as,
   even if you configure a tunnel and enable anonymous decap, the latter will
   take precedence.
 - Any comments on the choice of the sysctl name ("tunnel66_decap_enabled")?
 - Any comments on the patch in general?

[1] https://lore.kernel.org/netdev/CALx6S374PQ7GGA_ey6wCwc55hUzOx+2kWT=96TzyF0=g=8T=WA@mail.gmail.com

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/linux/ipv6.h            |  1 +
 include/net/tunnel6_anonymous.h | 23 +++++++++
 include/uapi/linux/ipv6.h       |  1 +
 net/ipv6/Makefile               |  3 +-
 net/ipv6/addrconf.c             | 12 +++++
 net/ipv6/af_inet6.c             |  7 +++
 net/ipv6/tunnel6.c              | 16 ++++++-
 net/ipv6/tunnel6_anonymous.c    | 83 +++++++++++++++++++++++++++++++++
 8 files changed, 143 insertions(+), 3 deletions(-)
 create mode 100644 include/net/tunnel6_anonymous.h
 create mode 100644 net/ipv6/tunnel6_anonymous.c

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index ef4a69865737..119bce49b254 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -79,6 +79,7 @@ struct ipv6_devconf {
 	__u32		ioam6_id;
 	__u32		ioam6_id_wide;
 	__u8		ioam6_enabled;
+	__u8		tunnel66_decap_enabled;
 
 	struct ctl_table_header *sysctl_header;
 };
diff --git a/include/net/tunnel6_anonymous.h b/include/net/tunnel6_anonymous.h
new file mode 100644
index 000000000000..990a0ca63edf
--- /dev/null
+++ b/include/net/tunnel6_anonymous.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ *  Anonymous tunnels for IPv6
+ *
+ *  Author:
+ *  Justin Iurman <justin.iurman@uliege.be>
+ */
+
+#ifndef _NET_TUNNEL6_ANONYMOUS_H
+#define _NET_TUNNEL6_ANONYMOUS_H
+
+#include <linux/skbuff.h>
+
+int tunnel6_anonymous_init(void);
+void tunnel6_anonymous_exit(void);
+
+int tunnel6_anonymous_register(void);
+int tunnel6_anonymous_unregister(void);
+
+bool anonymous66_enabled(struct sk_buff *skb);
+int anonymous66_decap(struct sk_buff *skb);
+
+#endif /* _NET_TUNNEL6_ANONYMOUS_H */
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index b243a53fa985..8b17a26ab661 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -193,6 +193,7 @@ enum {
 	DEVCONF_IOAM6_ENABLED,
 	DEVCONF_IOAM6_ID,
 	DEVCONF_IOAM6_ID_WIDE,
+	DEVCONF_TUNNEL66_DECAP_ENABLED,
 	DEVCONF_MAX
 };
 
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 1bc7e143217b..efeaeced17db 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -10,7 +10,8 @@ ipv6-objs :=	af_inet6.o anycast.o ip6_output.o ip6_input.o addrconf.o \
 		route.o ip6_fib.o ipv6_sockglue.o ndisc.o udp.o udplite.o \
 		raw.o icmp.o mcast.o reassembly.o tcp_ipv6.o ping.o \
 		exthdrs.o datagram.o ip6_flowlabel.o inet6_connection_sock.o \
-		udp_offload.o seg6.o fib6_notifier.o rpl.o ioam6.o
+		udp_offload.o seg6.o fib6_notifier.o rpl.o ioam6.o \
+		tunnel6_anonymous.o
 
 ipv6-offload :=	ip6_offload.o tcpv6_offload.o exthdrs_offload.o
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 8381288a0d6e..22e14f84b12e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -241,6 +241,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.ioam6_enabled		= 0,
 	.ioam6_id               = IOAM6_DEFAULT_IF_ID,
 	.ioam6_id_wide		= IOAM6_DEFAULT_IF_ID_WIDE,
+	.tunnel66_decap_enabled = 0,
 };
 
 static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
@@ -300,6 +301,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.ioam6_enabled		= 0,
 	.ioam6_id               = IOAM6_DEFAULT_IF_ID,
 	.ioam6_id_wide		= IOAM6_DEFAULT_IF_ID_WIDE,
+	.tunnel66_decap_enabled = 0,
 };
 
 /* Check if link is ready: is it up and is a valid qdisc available */
@@ -5532,6 +5534,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_IOAM6_ENABLED] = cnf->ioam6_enabled;
 	array[DEVCONF_IOAM6_ID] = cnf->ioam6_id;
 	array[DEVCONF_IOAM6_ID_WIDE] = cnf->ioam6_id_wide;
+	array[DEVCONF_TUNNEL66_DECAP_ENABLED] = cnf->tunnel66_decap_enabled;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -6965,6 +6968,15 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_douintvec,
 	},
+	{
+		.procname	= "tunnel66_decap_enabled",
+		.data		= &ipv6_devconf.tunnel66_decap_enabled,
+		.maxlen	= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+		.extra1	= (void *)SYSCTL_ZERO,
+		.extra2	= (void *)SYSCTL_ONE,
+	},
 	{
 		/* sentinel */
 	}
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index d92c90d97763..abb2e504b15e 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -63,6 +63,7 @@
 #include <net/compat.h>
 #include <net/xfrm.h>
 #include <net/ioam6.h>
+#include <net/tunnel6_anonymous.h>
 
 #include <linux/uaccess.h>
 #include <linux/mroute6.h>
@@ -1199,6 +1200,10 @@ static int __init inet6_init(void)
 	if (err)
 		goto ioam6_fail;
 
+	err = tunnel6_anonymous_init();
+	if (err)
+		goto tunnel6_anonymous_fail;
+
 	err = igmp6_late_init();
 	if (err)
 		goto igmp6_late_err;
@@ -1221,6 +1226,8 @@ static int __init inet6_init(void)
 	igmp6_late_cleanup();
 #endif
 igmp6_late_err:
+	tunnel6_anonymous_exit();
+tunnel6_anonymous_fail:
 	ioam6_exit();
 ioam6_fail:
 	rpl_exit();
diff --git a/net/ipv6/tunnel6.c b/net/ipv6/tunnel6.c
index 00e8d8b1c9a7..b1a1cfd1e7f1 100644
--- a/net/ipv6/tunnel6.c
+++ b/net/ipv6/tunnel6.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <net/ipv6.h>
 #include <net/protocol.h>
+#include <net/tunnel6_anonymous.h>
 #include <net/xfrm.h>
 
 static struct xfrm6_tunnel __rcu *tunnel6_handlers __read_mostly;
@@ -144,6 +145,12 @@ static int tunnel6_rcv(struct sk_buff *skb)
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto drop;
 
+	/* Anonymous tunnel decapsulation
+	 * has a higher priority (if enabled)
+	 */
+	if (anonymous66_enabled(skb))
+		return anonymous66_decap(skb);
+
 	for_each_tunnel_rcu(tunnel6_handlers, handler)
 		if (!handler->handler(skb))
 			return 0;
@@ -257,8 +264,11 @@ static const struct inet6_protocol tunnelmpls6_protocol = {
 static int __init tunnel6_init(void)
 {
 	if (inet6_add_protocol(&tunnel6_protocol, IPPROTO_IPV6)) {
-		pr_err("%s: can't add protocol\n", __func__);
-		return -EAGAIN;
+		if (tunnel6_anonymous_unregister() ||
+		    inet6_add_protocol(&tunnel6_protocol, IPPROTO_IPV6)) {
+			pr_err("%s: can't add protocol\n", __func__);
+			return -EAGAIN;
+		}
 	}
 	if (inet6_add_protocol(&tunnel46_protocol, IPPROTO_IPIP)) {
 		pr_err("%s: can't add protocol\n", __func__);
@@ -295,6 +305,8 @@ static void __exit tunnel6_fini(void)
 		pr_err("%s: can't remove protocol\n", __func__);
 	if (inet6_del_protocol(&tunnel6_protocol, IPPROTO_IPV6))
 		pr_err("%s: can't remove protocol\n", __func__);
+	else
+		tunnel6_anonymous_register();
 	if (xfrm6_tunnel_mpls_supported() &&
 	    inet6_del_protocol(&tunnelmpls6_protocol, IPPROTO_MPLS))
 		pr_err("%s: can't remove protocol\n", __func__);
diff --git a/net/ipv6/tunnel6_anonymous.c b/net/ipv6/tunnel6_anonymous.c
new file mode 100644
index 000000000000..c28cfb090ef0
--- /dev/null
+++ b/net/ipv6/tunnel6_anonymous.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ *  Anonymous tunnels for IPv6
+ *
+ *  Handle the decapsulation process of anonymous tunnels (i.e., not
+ *  explicitly configured). This behavior is needed for architectures
+ *  where a lot of ingresses and egresses must be linked altogether,
+ *  leading to a solution to avoid configuring all possible tunnels.
+ *
+ *  Author:
+ *  Justin Iurman <justin.iurman@uliege.be>
+ */
+
+#include <linux/export.h>
+#include <linux/icmpv6.h>
+#include <linux/init.h>
+#include <linux/netdevice.h>
+#include <net/addrconf.h>
+#include <net/protocol.h>
+#include <net/tunnel6_anonymous.h>
+#include <uapi/linux/in.h>
+
+/* called with rcu_read_lock() */
+int anonymous66_rcv(struct sk_buff *skb)
+{
+	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		goto drop;
+
+	if (anonymous66_enabled(skb))
+		return anonymous66_decap(skb);
+
+	icmpv6_send(skb, ICMPV6_PARAMPROB, ICMPV6_UNK_NEXTHDR, 0);
+drop:
+	kfree_skb(skb);
+	return 0;
+}
+
+static const struct inet6_protocol anonymous66_protocol = {
+	.handler	=	anonymous66_rcv,
+	.flags		=	INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
+};
+
+bool anonymous66_enabled(struct sk_buff *skb)
+{
+	return __in6_dev_get(skb->dev)->cnf.tunnel66_decap_enabled;
+}
+EXPORT_SYMBOL(anonymous66_enabled);
+
+int anonymous66_decap(struct sk_buff *skb)
+{
+	skb_reset_network_header(skb);
+	skb_reset_transport_header(skb);
+	skb->encapsulation = 0;
+
+	__skb_tunnel_rx(skb, skb->dev, dev_net(skb->dev));
+	netif_rx(skb);
+
+	return 0;
+}
+EXPORT_SYMBOL(anonymous66_decap);
+
+int tunnel6_anonymous_register(void)
+{
+	return inet6_add_protocol(&anonymous66_protocol, IPPROTO_IPV6);
+}
+EXPORT_SYMBOL(tunnel6_anonymous_register);
+
+int tunnel6_anonymous_unregister(void)
+{
+	return inet6_del_protocol(&anonymous66_protocol, IPPROTO_IPV6);
+}
+EXPORT_SYMBOL(tunnel6_anonymous_unregister);
+
+int __init tunnel6_anonymous_init(void)
+{
+	tunnel6_anonymous_register();
+	return 0;
+}
+
+void tunnel6_anonymous_exit(void)
+{
+	tunnel6_anonymous_unregister();
+}
-- 
2.25.1

