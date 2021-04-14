Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0890635EB93
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 05:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhDNDyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 23:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbhDNDyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 23:54:12 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B7AC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 20:53:50 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 172F2806A8;
        Wed, 14 Apr 2021 15:53:47 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1618372427;
        bh=BnIdbUld0KNW3h7+2X6S2LnA8Jji+MPRvwsDclDrNP4=;
        h=From:To:Cc:Subject:Date;
        b=PgZ0JoClnEMCd77KNp2f1x/brhhCEf51Ah5klqU/xv98kMZnhC1ezgMdy+G0BQ5bc
         gqGu2mvtZkEDHET7kemAZpgKwf6Blobdaqjr/x53ToFdD+ECv5hL99KV9+wdD8OLjB
         OMFpSqTIn+WmoCpfIw1JPXsSQXdy8QJx3sQrO9kjcKMv3fptZ/MnSd0Hv6Qo8QQdfF
         tC5Rba4RxmdVOsfi7KPsG9iIV7B9ZUeEk89cGdbhi0/6sxaxsEXbHqnj5HlavDk1xE
         5u0EfFkbNKKFEj9/cy5+8uYSl2HkLSi5p+UYWztgYZqcSwOKqay2l1TPzzOqPsgulC
         rXWuy+cMEVttw==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6076674a0000>; Wed, 14 Apr 2021 15:53:46 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by smtp (Postfix) with ESMTP id 26E9B13EED4;
        Wed, 14 Apr 2021 15:54:07 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id AA9642429BC; Wed, 14 Apr 2021 15:53:46 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Subject: [PATCH] netfilter: nf_conntrack: Add conntrack helper for ESP/IPsec
Date:   Wed, 14 Apr 2021 15:53:26 +1200
Message-Id: <20210414035327.31018-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=NaGYKFL4 c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=3YhXtTcJ-WEA:10 a=_iQIIRdOukCLgYTII2UA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce changes to add ESP connection tracking helper to netfilter
conntrack. The connection tracking of ESP is based on IPsec SPIs. The
underlying motivation for this patch was to allow multiple VPN ESP
clients to be distinguished when using NAT.

Added config flag CONFIG_NF_CT_PROTO_ESP to enable the ESP/IPsec
conntrack helper.

Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
---
 .../linux/netfilter/nf_conntrack_proto_esp.h  |  25 +
 .../net/netfilter/ipv4/nf_conntrack_ipv4.h    |   3 +
 include/net/netfilter/nf_conntrack.h          |   2 +
 include/net/netfilter/nf_conntrack_l4proto.h  |  15 +
 include/net/netfilter/nf_conntrack_tuple.h    |   3 +
 include/net/netns/conntrack.h                 |  24 +
 .../netfilter/nf_conntrack_tuple_common.h     |   3 +
 .../linux/netfilter/nfnetlink_conntrack.h     |   2 +
 net/netfilter/Kconfig                         |  10 +
 net/netfilter/Makefile                        |   1 +
 net/netfilter/nf_conntrack_core.c             |  23 +
 net/netfilter/nf_conntrack_netlink.c          |   4 +-
 net/netfilter/nf_conntrack_proto.c            |   6 +
 net/netfilter/nf_conntrack_proto_esp.c        | 535 ++++++++++++++++++
 net/netfilter/nf_conntrack_standalone.c       |   5 +
 net/netfilter/nf_internals.h                  |   4 +-
 16 files changed, 663 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/netfilter/nf_conntrack_proto_esp.h
 create mode 100644 net/netfilter/nf_conntrack_proto_esp.c

diff --git a/include/linux/netfilter/nf_conntrack_proto_esp.h b/include/l=
inux/netfilter/nf_conntrack_proto_esp.h
new file mode 100644
index 000000000000..2441e031c68e
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_proto_esp.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _CONNTRACK_PROTO_ESP_H
+#define _CONNTRACK_PROTO_ESP_H
+#include <asm/byteorder.h>
+
+/* ESP PROTOCOL HEADER */
+
+struct esphdr {
+	__u32 spi;
+};
+
+struct nf_ct_esp {
+	unsigned int stream_timeout;
+	unsigned int timeout;
+};
+
+#ifdef __KERNEL__
+#include <net/netfilter/nf_conntrack_tuple.h>
+
+void destroy_esp_conntrack_entry(struct nf_conn *ct);
+
+bool esp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+		      struct net *net, struct nf_conntrack_tuple *tuple);
+#endif /* __KERNEL__ */
+#endif /* _CONNTRACK_PROTO_ESP_H */
diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net=
/netfilter/ipv4/nf_conntrack_ipv4.h
index 2c8c2b023848..1aee91592639 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -25,5 +25,8 @@ extern const struct nf_conntrack_l4proto nf_conntrack_l=
4proto_udplite;
 #ifdef CONFIG_NF_CT_PROTO_GRE
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre;
 #endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_esp;
+#endif
=20
 #endif /*_NF_CONNTRACK_IPV4_H*/
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter=
/nf_conntrack.h
index 439379ca9ffa..2bd1d94de138 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -21,6 +21,7 @@
 #include <linux/netfilter/nf_conntrack_dccp.h>
 #include <linux/netfilter/nf_conntrack_sctp.h>
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
+#include <linux/netfilter/nf_conntrack_proto_esp.h>
=20
 #include <net/netfilter/nf_conntrack_tuple.h>
=20
@@ -36,6 +37,7 @@ union nf_conntrack_proto {
 	struct ip_ct_tcp tcp;
 	struct nf_ct_udp udp;
 	struct nf_ct_gre gre;
+	struct nf_ct_esp esp;
 	unsigned int tmpl_padto;
 };
=20
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/n=
etfilter/nf_conntrack_l4proto.h
index 96f9cf81f46b..ec89e83ff20e 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -75,6 +75,8 @@ bool nf_conntrack_invert_icmp_tuple(struct nf_conntrack=
_tuple *tuple,
 				    const struct nf_conntrack_tuple *orig);
 bool nf_conntrack_invert_icmpv6_tuple(struct nf_conntrack_tuple *tuple,
 				      const struct nf_conntrack_tuple *orig);
+bool nf_conntrack_invert_esp_tuple(struct nf_conntrack_tuple *tuple,
+				   const struct nf_conntrack_tuple *orig);
=20
 int nf_conntrack_inet_error(struct nf_conn *tmpl, struct sk_buff *skb,
 			    unsigned int dataoff,
@@ -132,6 +134,11 @@ int nf_conntrack_gre_packet(struct nf_conn *ct,
 			    unsigned int dataoff,
 			    enum ip_conntrack_info ctinfo,
 			    const struct nf_hook_state *state);
+int nf_conntrack_esp_packet(struct nf_conn *ct,
+			    struct sk_buff *skb,
+			    unsigned int dataoff,
+			    enum ip_conntrack_info ctinfo,
+			    const struct nf_hook_state *state);
=20
 void nf_conntrack_generic_init_net(struct net *net);
 void nf_conntrack_tcp_init_net(struct net *net);
@@ -141,6 +148,7 @@ void nf_conntrack_dccp_init_net(struct net *net);
 void nf_conntrack_sctp_init_net(struct net *net);
 void nf_conntrack_icmp_init_net(struct net *net);
 void nf_conntrack_icmpv6_init_net(struct net *net);
+void nf_conntrack_esp_init_net(struct net *net);
=20
 /* Existing built-in generic protocol */
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
@@ -240,4 +248,11 @@ static inline struct nf_gre_net *nf_gre_pernet(struc=
t net *net)
 }
 #endif
=20
+#ifdef CONFIG_NF_CT_PROTO_ESP
+static inline struct nf_esp_net *nf_esp_pernet(struct net *net)
+{
+	return &net->ct.nf_ct_proto.esp;
+}
+#endif
+
 #endif /*_NF_CONNTRACK_PROTOCOL_H*/
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/net=
filter/nf_conntrack_tuple.h
index 9334371c94e2..7b9c3b5ae8cc 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -62,6 +62,9 @@ struct nf_conntrack_tuple {
 			struct {
 				__be16 key;
 			} gre;
+			struct {
+				__be16 spi;
+			} esp;
 		} u;
=20
 		/* The protocol. */
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.=
h
index 806454e767bf..c6f21c6316f0 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -69,6 +69,27 @@ struct nf_gre_net {
 };
 #endif
=20
+#ifdef CONFIG_NF_CT_PROTO_ESP
+#define ESP_MAX_PORTS      1000
+#define HASH_TAB_SIZE  ESP_MAX_PORTS
+
+enum esp_conntrack {
+	ESP_CT_UNREPLIED,
+	ESP_CT_REPLIED,
+	ESP_CT_MAX
+};
+
+struct nf_esp_net {
+	rwlock_t esp_table_lock;
+	struct hlist_head ltable[HASH_TAB_SIZE];
+	struct hlist_head rtable[HASH_TAB_SIZE];
+	/* Initial lookup for remote end until rspi is known */
+	struct hlist_head incmpl_rtable[HASH_TAB_SIZE];
+	struct _esp_table *esp_table[ESP_MAX_PORTS];
+	unsigned int esp_timeouts[ESP_CT_MAX];
+};
+#endif
+
 struct nf_ip_net {
 	struct nf_generic_net   generic;
 	struct nf_tcp_net	tcp;
@@ -84,6 +105,9 @@ struct nf_ip_net {
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	struct nf_gre_net	gre;
 #endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	struct nf_esp_net	esp;
+#endif
 };
=20
 struct ct_pcpu {
diff --git a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h b/i=
nclude/uapi/linux/netfilter/nf_conntrack_tuple_common.h
index 64390fac6f7e..9bbd76c325d2 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
@@ -39,6 +39,9 @@ union nf_conntrack_man_proto {
 	struct {
 		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
 	} gre;
+	struct {
+		__be16 spi;
+	} esp;
 };
=20
 #define CTINFO2DIR(ctinfo) ((ctinfo) >=3D IP_CT_IS_REPLY ? IP_CT_DIR_REP=
LY : IP_CT_DIR_ORIGINAL)
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include=
/uapi/linux/netfilter/nfnetlink_conntrack.h
index d8484be72fdc..f9f81be7a163 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -90,6 +90,8 @@ enum ctattr_l4proto {
 	CTA_PROTO_ICMPV6_ID,
 	CTA_PROTO_ICMPV6_TYPE,
 	CTA_PROTO_ICMPV6_CODE,
+	CTA_PROTO_SRC_ESP_SPI,
+	CTA_PROTO_DST_ESP_SPI,
 	__CTA_PROTO_MAX
 };
 #define CTA_PROTO_MAX (__CTA_PROTO_MAX - 1)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1a92063c73a4..7269312d322e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -199,6 +199,16 @@ config NF_CT_PROTO_UDPLITE
=20
 	  If unsure, say Y.
=20
+config NF_CT_PROTO_ESP
+	bool "ESP protocol support"
+	depends on NETFILTER_ADVANCED
+	help
+	  ESP connection tracking helper. Provides connection tracking for IPse=
c
+	  clients behind this device based on SPI, especially useful for
+	  distinguishing multiple clients when using NAT.
+
+	  If unsure, say N.
+
 config NF_CONNTRACK_AMANDA
 	tristate "Amanda backup protocol support"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 33da7bf1b68e..0942f2c48ddb 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -14,6 +14,7 @@ nf_conntrack-$(CONFIG_NF_CONNTRACK_LABELS) +=3D nf_conn=
track_labels.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_DCCP) +=3D nf_conntrack_proto_dccp.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_SCTP) +=3D nf_conntrack_proto_sctp.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_GRE) +=3D nf_conntrack_proto_gre.o
+nf_conntrack-$(CONFIG_NF_CT_PROTO_ESP) +=3D nf_conntrack_proto_esp.o
=20
 obj-$(CONFIG_NETFILTER) =3D netfilter.o
=20
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntra=
ck_core.c
index ff0168736f6e..3bef361d19ce 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -295,6 +295,10 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	case IPPROTO_GRE:
 		return gre_pkt_to_tuple(skb, dataoff, net, tuple);
+#endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	case IPPROTO_ESP:
+		return esp_pkt_to_tuple(skb, dataoff, net, tuple);
 #endif
 	case IPPROTO_TCP:
 	case IPPROTO_UDP: /* fallthrough */
@@ -439,6 +443,10 @@ nf_ct_invert_tuple(struct nf_conntrack_tuple *invers=
e,
 #if IS_ENABLED(CONFIG_IPV6)
 	case IPPROTO_ICMPV6:
 		return nf_conntrack_invert_icmpv6_tuple(inverse, orig);
+#endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	case IPPROTO_ESP:
+		return nf_conntrack_invert_esp_tuple(inverse, orig);
 #endif
 	}
=20
@@ -593,6 +601,13 @@ static void destroy_gre_conntrack(struct nf_conn *ct=
)
 #endif
 }
=20
+static void destroy_esp_conntrack(struct nf_conn *ct)
+{
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	destroy_esp_conntrack_entry(ct);
+#endif
+}
+
 static void
 destroy_conntrack(struct nf_conntrack *nfct)
 {
@@ -609,6 +624,9 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	if (unlikely(nf_ct_protonum(ct) =3D=3D IPPROTO_GRE))
 		destroy_gre_conntrack(ct);
=20
+	if (unlikely(nf_ct_protonum(ct) =3D=3D IPPROTO_ESP))
+		destroy_esp_conntrack(ct);
+
 	local_bh_disable();
 	/* Expectations will have been removed in clean_from_lists,
 	 * except TFTP can create an expectation on the first packet,
@@ -1783,6 +1801,11 @@ static int nf_conntrack_handle_packet(struct nf_co=
nn *ct,
 	case IPPROTO_GRE:
 		return nf_conntrack_gre_packet(ct, skb, dataoff,
 					       ctinfo, state);
+#endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	case IPPROTO_ESP:
+		return nf_conntrack_esp_packet(ct, skb, dataoff,
+					       ctinfo, state);
 #endif
 	}
=20
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conn=
track_netlink.c
index 1d519b0e51a5..f4a18a9c8ad4 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1382,7 +1382,9 @@ static const struct nla_policy tuple_nla_policy[CTA=
_TUPLE_MAX+1] =3D {
    CTA_FILTER_F_CTA_PROTO_ICMP_ID | \
    CTA_FILTER_F_CTA_PROTO_ICMPV6_TYPE | \
    CTA_FILTER_F_CTA_PROTO_ICMPV6_CODE | \
-   CTA_FILTER_F_CTA_PROTO_ICMPV6_ID)
+   CTA_FILTER_F_CTA_PROTO_ICMPV6_ID | \
+   CTA_FILTER_F_CTA_PROTO_SRC_ESP_SPI | \
+   CTA_FILTER_F_CTA_PROTO_DST_ESP_SPI)
=20
 static int
 ctnetlink_parse_tuple_filter(const struct nlattr * const cda[],
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntr=
ack_proto.c
index 47e9319d2cf3..37beb8ce085c 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -112,6 +112,9 @@ const struct nf_conntrack_l4proto *nf_ct_l4proto_find=
(u8 l4proto)
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	case IPPROTO_GRE: return &nf_conntrack_l4proto_gre;
 #endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	case IPPROTO_ESP: return &nf_conntrack_l4proto_esp;
+#endif
 #if IS_ENABLED(CONFIG_IPV6)
 	case IPPROTO_ICMPV6: return &nf_conntrack_l4proto_icmpv6;
 #endif /* CONFIG_IPV6 */
@@ -691,6 +694,9 @@ void nf_conntrack_proto_pernet_init(struct net *net)
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	nf_conntrack_gre_init_net(net);
 #endif
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	nf_conntrack_esp_init_net(net);
+#endif
 }
=20
 void nf_conntrack_proto_pernet_fini(struct net *net)
diff --git a/net/netfilter/nf_conntrack_proto_esp.c b/net/netfilter/nf_co=
nntrack_proto_esp.c
new file mode 100644
index 000000000000..2924bd82c78c
--- /dev/null
+++ b/net/netfilter/nf_conntrack_proto_esp.c
@@ -0,0 +1,535 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * <:copyright-gpl
+ * Copyright 2008 Broadcom Corp. All Rights Reserved.
+ * Copyright (C) 2021 Allied Telesis Labs NZ
+ *
+ * This program is free software; you can distribute it and/or modify it
+ * under the terms of the GNU General Public License (Version 2) as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOU=
T
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License alo=
ng
+ * with this program.
+ * :>
+ */
+/***********************************************************************=
*******
+ * Filename:       nf_conntrack_proto_esp.c
+ * Author:         Pavan Kumar
+ * Creation Date:  05/27/04
+ *
+ * Description:
+ * Implements the ESP ALG connectiontracking.
+ * Migrated to kernel 2.6.21.5 on April 16, 2008 by Dan-Han Tsai.
+ * Migrated to kernel 5.11.0-rc2+ on March 3, 2021 by Allied Telesis Lab=
s NZ (Cole Dishington).
+ *
+ * Updates to ESP conntracking on October,2010,by Manamohan,Lantiq Deuts=
chland GmbH:
+ *	- Added the support for sessions with two or more different remote se=
rvers
+ *    from single or multiple lan clients with same lan and remote SPI I=
ds
+ *	- Support for associating the multiple LAN side sessions waiting
+ *    for the reply from same remote server with the one which is create=
d first
+ * Updates to ESP conntracking on August,2015,by Allied Telesis Labs NZ:
+ *	- Improve ESP entry lookup performance by adding hashtable. (Anthony =
Lineham)
+ *	- Add locking around ESP connection table. (Anthony Lineham)
+ *	- Fixups including adding destroy function, endian-safe SPIs and IPs,
+ *	  replace prinks with DEBUGs. (Anthony Lineham)
+ *	- Extend ESP connection tracking to allow conntrack ESP entry matchin=
g
+ *	  of tuple values. (Matt Bennett)
+ ***********************************************************************=
*****/
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/timer.h>
+#include <linux/list.h>
+#include <linux/seq_file.h>
+#include <linux/in.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/dst.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_timeout.h>
+#include <linux/netfilter/nf_conntrack_proto_esp.h>
+
+#include "nf_internals.h"
+
+#if 0
+#define ESP_DEBUG 1
+#define DEBUGP(format, args...) printk(KERN_DEBUG "%s: " format, __func_=
_, ## args)
+#else
+#undef ESP_DEBUG
+#define DEBUGP(x, args...)
+#endif
+
+#define TEMP_SPI_START 1500
+#define TEMP_SPI_MAX   (TEMP_SPI_START + ESP_MAX_PORTS - 1)
+
+struct _esp_table {
+	/* Hash table nodes for each required lookup
+	 * lnode: l_spi, l_ip, r_ip
+	 * rnode: r_spi, r_ip
+	 * incmpl_rnode: r_ip
+	 */
+	struct hlist_node lnode;
+	struct hlist_node rnode;
+	struct hlist_node incmpl_rnode;
+
+	u32 l_spi;
+	u32 r_spi;
+	u32 l_ip;
+	u32 r_ip;
+	u16 tspi;
+	unsigned long allocation_time;
+	struct net *net;
+};
+
+static unsigned int esp_timeouts[ESP_CT_MAX] =3D {
+	[ESP_CT_UNREPLIED] =3D 60 * HZ,
+	[ESP_CT_REPLIED] =3D 3600 * HZ,
+};
+
+static inline struct nf_esp_net *esp_pernet(struct net *net)
+{
+	return &net->ct.nf_ct_proto.esp;
+}
+
+static void esp_init_esp_tables(struct nf_esp_net *net_esp)
+{
+	struct _esp_table **esp_table;
+	int i;
+
+	rwlock_init(&net_esp->esp_table_lock);
+
+	write_lock_bh(&net_esp->esp_table_lock);
+	esp_table =3D net_esp->esp_table;
+	for (i =3D 0; i < ESP_MAX_PORTS; i++)
+		memset(&esp_table[i], 0, sizeof(struct _esp_table *));
+
+	for (i =3D 0; i < HASH_TAB_SIZE; i++) {
+		INIT_HLIST_HEAD(&net_esp->ltable[i]);
+		INIT_HLIST_HEAD(&net_esp->rtable[i]);
+		INIT_HLIST_HEAD(&net_esp->incmpl_rtable[i]);
+	}
+	DEBUGP("Initialized %i ESP table entries\n", i);
+	write_unlock_bh(&net_esp->esp_table_lock);
+}
+
+void nf_conntrack_esp_init_net(struct net *net)
+{
+	struct nf_esp_net *net_esp =3D esp_pernet(net);
+	int i;
+
+	esp_init_esp_tables(net_esp);
+	for (i =3D 0; i < ESP_CT_MAX; i++)
+		net_esp->esp_timeouts[i] =3D esp_timeouts[i];
+}
+
+/* Free an entry referred to by TSPI.
+ * Entry table locking and unlocking is the responsibility of the callin=
g function.
+ * Range checking is the responsibility of the calling function.
+ */
+static void esp_table_free_entry_by_tspi(struct net *net, u16 tspi)
+{
+	struct nf_esp_net *esp_net =3D esp_pernet(net);
+	struct _esp_table *esp_entry =3D NULL;
+
+	esp_entry =3D esp_net->esp_table[tspi - TEMP_SPI_START];
+	if (esp_entry) {
+		/* Remove from all the hash tables. Hlist utility can handle items
+		 * that aren't actually in the list, so just try removing from
+		 * each list
+		 */
+		DEBUGP("Removing entry %x (%p) from all tables",
+		       esp_entry->tspi, esp_entry);
+		hlist_del_init(&esp_entry->lnode);
+		hlist_del_init(&esp_entry->incmpl_rnode);
+		hlist_del_init(&esp_entry->rnode);
+		kfree(esp_entry);
+		esp_net->esp_table[tspi - TEMP_SPI_START] =3D NULL;
+	}
+}
+
+/* Allocate a free IPSEC table entry.
+ * NOTE: The ESP entry table must be locked prior to calling this functi=
on.
+ */
+struct _esp_table *alloc_esp_entry(struct net *net)
+{
+	struct nf_esp_net *net_esp =3D esp_pernet(net);
+	struct _esp_table **esp_table =3D net_esp->esp_table;
+	struct _esp_table *esp_entry =3D NULL;
+	int idx =3D 0;
+
+	/* Find the first unused slot */
+	for (; idx < ESP_MAX_PORTS; idx++) {
+		if (esp_table[idx])
+			continue;
+
+		esp_table[idx] =3D kmalloc(sizeof(*esp_entry), GFP_ATOMIC);
+		memset(esp_table[idx], 0, sizeof(struct _esp_table));
+		esp_table[idx]->tspi =3D idx + TEMP_SPI_START;
+
+		DEBUGP("   New esp_entry (%p) at idx %d tspi %u\n",
+		       esp_table[idx], idx, esp_table[idx]->tspi);
+
+		esp_table[idx]->allocation_time =3D jiffies;
+		esp_table[idx]->net =3D net;
+		esp_entry =3D esp_table[idx];
+		break;
+	}
+	return esp_entry;
+}
+
+static u32 calculate_hash(const u32 spi, const u32 src_ip,
+			  const u32 dst_ip)
+{
+	u32 hash;
+
+	/* Simple combination */
+	hash =3D spi + src_ip + dst_ip;
+	/* Reduce to an index to fit the table size */
+	hash %=3D HASH_TAB_SIZE;
+
+	DEBUGP("Generated hash %x from spi %x srcIP %x dstIP %x\n", hash, spi,
+	       src_ip, dst_ip);
+	return hash;
+}
+
+/*	Search for an ESP entry in the initial state based the IP address of =
the
+ *	remote peer.
+ *	NOTE: The ESP entry table must be locked prior to calling this functi=
on.
+ */
+static struct _esp_table *search_esp_entry_init_remote(struct nf_esp_net=
 *net_esp,
+						       const u32 src_ip)
+{
+	struct _esp_table **esp_table =3D net_esp->esp_table;
+	struct _esp_table *esp_entry =3D NULL;
+	u32 hash =3D 0;
+	int first_entry =3D -1;
+
+	hash =3D calculate_hash(0, src_ip, 0);
+	hlist_for_each_entry(esp_entry, &net_esp->incmpl_rtable[hash],
+			     incmpl_rnode) {
+		DEBUGP("Checking against incmpl_rtable entry %x (%p) with l_spi %x r_s=
pi %x r_ip %x\n",
+		       esp_entry->tspi, esp_entry, esp_entry->l_spi,
+		       esp_entry->r_spi, esp_entry->r_ip);
+		if (src_ip =3D=3D esp_entry->r_ip && esp_entry->l_spi !=3D 0 &&
+		    esp_entry->r_spi =3D=3D 0) {
+			DEBUGP("Matches entry %x", esp_entry->tspi);
+			if (first_entry =3D=3D -1) {
+				DEBUGP("First match\n");
+				first_entry =3D esp_entry->tspi - TEMP_SPI_START;
+			} else if (esp_table[first_entry]->allocation_time >
+				   esp_entry->allocation_time) {
+				/* This entry is older than the last one found so treat this
+				 * as a better match.
+				 */
+				DEBUGP("Older/better match\n");
+				first_entry =3D esp_entry->tspi - TEMP_SPI_START;
+			}
+		}
+	}
+
+	if (first_entry !=3D -1) {
+		DEBUGP("returning esp entry\n");
+		esp_entry =3D esp_table[first_entry];
+		return esp_entry;
+	}
+
+	DEBUGP("No init entry found\n");
+	return NULL;
+}
+
+/*	Search for an ESP entry by SPI and source and destination IP addresse=
s.
+ *	NOTE: The ESP entry table must be locked prior to calling this functi=
on.
+ */
+struct _esp_table *search_esp_entry_by_spi(struct net *net, const __u32 =
spi,
+					   const __u32 src_ip, const __u32 dst_ip)
+{
+	struct nf_esp_net *net_esp =3D esp_pernet(net);
+	struct _esp_table *esp_entry =3D NULL;
+	u32 hash =3D 0;
+
+	/* Check for matching established session or repeated initial LAN side =
*/
+	/* LAN side first */
+	hash =3D calculate_hash(spi, src_ip, dst_ip);
+	hlist_for_each_entry(esp_entry, &net_esp->ltable[hash], lnode) {
+		DEBUGP
+		    ("Checking against ltable entry %x (%p) with l_spi %x l_ip %x r_ip=
 %x\n",
+		     esp_entry->tspi, esp_entry, esp_entry->l_spi,
+		     esp_entry->l_ip, esp_entry->r_ip);
+		if (spi =3D=3D esp_entry->l_spi && src_ip =3D=3D esp_entry->l_ip &&
+		    dst_ip =3D=3D esp_entry->r_ip) {
+			/* When r_spi is set this is an established session. When not set it'=
s
+			 * a repeated initial packet from LAN side. But both cases are treate=
d
+			 * the same.
+			 */
+			DEBUGP("Matches entry %x", esp_entry->tspi);
+			return esp_entry;
+		}
+	}
+
+	/* Established remote side */
+	hash =3D calculate_hash(spi, src_ip, 0);
+	hlist_for_each_entry(esp_entry, &net_esp->rtable[hash], rnode) {
+		DEBUGP
+		    ("Checking against rtable entry %x (%p) with l_spi %x r_spi %x r_i=
p %x\n",
+		     esp_entry->tspi, esp_entry, esp_entry->l_spi,
+		     esp_entry->r_spi, esp_entry->r_ip);
+		if (spi =3D=3D esp_entry->r_spi && src_ip =3D=3D esp_entry->r_ip &&
+		    esp_entry->l_spi !=3D 0) {
+			DEBUGP("Matches entry %x", esp_entry->tspi);
+			return esp_entry;
+		}
+	}
+
+	/* Incomplete remote side */
+	esp_entry =3D search_esp_entry_init_remote(net_esp, src_ip);
+	if (esp_entry) {
+		esp_entry->r_spi =3D spi;
+		/* Remove entry from incmpl_rtable and add to rtable */
+		DEBUGP("Completing entry %x with remote SPI info",
+		       esp_entry->tspi);
+		hlist_del_init(&esp_entry->incmpl_rnode);
+		hash =3D calculate_hash(spi, src_ip, 0);
+		hlist_add_head(&esp_entry->rnode, &net_esp->rtable[hash]);
+		return esp_entry;
+	}
+
+	DEBUGP("No Entry\n");
+	return NULL;
+}
+
+/* invert esp part of tuple */
+bool nf_conntrack_invert_esp_tuple(struct nf_conntrack_tuple *tuple,
+				   const struct nf_conntrack_tuple *orig)
+{
+	tuple->dst.u.esp.spi =3D orig->dst.u.esp.spi;
+	tuple->src.u.esp.spi =3D orig->src.u.esp.spi;
+	return true;
+}
+
+/* esp hdr info to tuple */
+bool esp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+		      struct net *net, struct nf_conntrack_tuple *tuple)
+{
+	struct nf_esp_net *net_esp =3D esp_pernet(net);
+	struct esphdr _esphdr, *esphdr;
+	struct _esp_table *esp_entry =3D NULL;
+	u32 spi =3D 0;
+
+	esphdr =3D skb_header_pointer(skb, dataoff, sizeof(_esphdr), &_esphdr);
+	if (!esphdr) {
+		/* try to behave like "nf_conntrack_proto_generic" */
+		tuple->src.u.all =3D 0;
+		tuple->dst.u.all =3D 0;
+		return true;
+	}
+	spi =3D ntohl(esphdr->spi);
+
+	DEBUGP("Enter pkt_to_tuple() with spi %x\n", spi);
+	/* check if esphdr has a new SPI:
+	 *   if no, update tuple with correct tspi;
+	 *   if yes, check if we have seen the source IP:
+	 *             if yes, update the ESP tables update the tuple with corr=
ect tspi
+	 *             if no, create a new entry
+	 */
+	write_lock_bh(&net_esp->esp_table_lock);
+	esp_entry =3D search_esp_entry_by_spi(net, spi, tuple->src.u3.ip,
+					    tuple->dst.u3.ip);
+	if (!esp_entry) {
+		u32 hash =3D 0;
+
+		esp_entry =3D alloc_esp_entry(net);
+		if (!esp_entry) {
+			DEBUGP("All entries in use\n");
+			write_unlock_bh(&net_esp->esp_table_lock);
+			return false;
+		}
+		esp_entry->l_spi =3D spi;
+		esp_entry->l_ip =3D tuple->src.u3.ip;
+		esp_entry->r_ip =3D tuple->dst.u3.ip;
+		/* Add entries to the hash tables */
+		hash =3D calculate_hash(spi, esp_entry->l_ip, esp_entry->r_ip);
+		hlist_add_head(&esp_entry->lnode, &net_esp->ltable[hash]);
+		hash =3D calculate_hash(0, 0, esp_entry->r_ip);
+		hlist_add_head(&esp_entry->incmpl_rnode,
+			       &net_esp->incmpl_rtable[hash]);
+	}
+
+	DEBUGP
+	    ("entry_info: tspi %u l_spi 0x%x r_spi 0x%x l_ip %x r_ip %x srcIP %=
x dstIP %x\n",
+	     esp_entry->tspi, esp_entry->l_spi, esp_entry->r_spi,
+	     esp_entry->l_ip, esp_entry->r_ip, tuple->src.u3.ip,
+	     tuple->dst.u3.ip);
+
+	tuple->dst.u.esp.spi =3D esp_entry->tspi;
+	tuple->src.u.esp.spi =3D esp_entry->tspi;
+	write_unlock_bh(&net_esp->esp_table_lock);
+	return true;
+}
+
+#ifdef CONFIG_NF_CONNTRACK_PROCFS
+/* print private data for conntrack */
+static void esp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
+{
+	seq_printf(s, "timeout=3D%u, stream_timeout=3D%u ",
+		   (ct->proto.esp.timeout / HZ),
+		   (ct->proto.esp.stream_timeout / HZ));
+}
+#endif
+
+/* Returns verdict for packet, and may modify conntrack */
+int nf_conntrack_esp_packet(struct nf_conn *ct, struct sk_buff *skb,
+			    unsigned int dataoff,
+			    enum ip_conntrack_info ctinfo,
+			    const struct nf_hook_state *state)
+{
+	unsigned int *timeouts =3D nf_ct_timeout_lookup(ct);
+#ifdef ESP_DEBUG
+	const struct iphdr *iph;
+	struct esphdr _esphdr, *esphdr;
+
+	iph =3D ip_hdr(skb);
+	esphdr =3D skb_header_pointer(skb, dataoff, sizeof(_esphdr), &_esphdr);
+	if (iph && esphdr) {
+		u32 spi;
+
+		spi =3D ntohl(esphdr->spi);
+		DEBUGP("(0x%x) %x <-> %x status %s info %d %s\n",
+		       spi, iph->saddr, iph->daddr,
+		       (ct->status & IPS_SEEN_REPLY) ? "SEEN" : "NOT_SEEN",
+		       ctinfo, (ctinfo =3D=3D IP_CT_NEW) ? "CT_NEW" : "SEEN_REPLY");
+	}
+#endif /* ESP_DEBUG */
+
+	if (!timeouts)
+		timeouts =3D esp_pernet(nf_ct_net(ct))->esp_timeouts;
+
+	if (!nf_ct_is_confirmed(ct)) {
+		ct->proto.esp.stream_timeout =3D timeouts[ESP_CT_REPLIED];
+		ct->proto.esp.timeout =3D timeouts[ESP_CT_UNREPLIED];
+	}
+
+	/* If we've seen traffic both ways, this is some kind of ESP
+	 * stream.  Extend timeout.
+	 */
+	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[ESP_CT_REPLIED]);
+		/* Also, more likely to be important, and not a probe */
+		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
+			/* Was originally IPCT_STATUS but this is no longer an option.
+			 * GRE uses assured for same purpose
+			 */
+			nf_conntrack_event_cache(IPCT_ASSURED, ct);
+	} else {
+		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[ESP_CT_UNREPLIED]);
+	}
+
+	return NF_ACCEPT;
+}
+
+/* Called when a conntrack entry has already been removed from the hashe=
s
+ * and is about to be deleted from memory
+ */
+void destroy_esp_conntrack_entry(struct nf_conn *ct)
+{
+	struct nf_conntrack_tuple *tuple =3D NULL;
+	enum ip_conntrack_dir dir;
+	u16 tspi =3D 0;
+	struct net *net =3D nf_ct_net(ct);
+	struct nf_esp_net *net_esp =3D esp_pernet(net);
+
+	write_lock_bh(&net_esp->esp_table_lock);
+
+	/* Probably all the ESP entries referenced in this connection are the s=
ame,
+	 * but the free function handles repeated frees, so best to do them all=
.
+	 */
+	for (dir =3D IP_CT_DIR_ORIGINAL; dir < IP_CT_DIR_MAX; dir++) {
+		tuple =3D nf_ct_tuple(ct, dir);
+
+		tspi =3D tuple->src.u.esp.spi;
+		if (tspi >=3D TEMP_SPI_START && tspi <=3D TEMP_SPI_MAX) {
+			DEBUGP("Deleting src tspi %x (dir %i)\n", tspi, dir);
+			esp_table_free_entry_by_tspi(net, tspi);
+		}
+		tuple->src.u.esp.spi =3D 0;
+		tspi =3D tuple->dst.u.esp.spi;
+		if (tspi >=3D TEMP_SPI_START && tspi <=3D TEMP_SPI_MAX) {
+			DEBUGP("Deleting dst tspi %x (dir %i)\n", tspi, dir);
+			esp_table_free_entry_by_tspi(net, tspi);
+		}
+		tuple->dst.u.esp.spi =3D 0;
+	}
+
+	write_unlock_bh(&net_esp->esp_table_lock);
+}
+
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
+static int esp_tuple_to_nlattr(struct sk_buff *skb,
+			       const struct nf_conntrack_tuple *t)
+{
+	if (nla_put_be16(skb, CTA_PROTO_SRC_ESP_SPI, t->src.u.esp.spi) ||
+	    nla_put_be16(skb, CTA_PROTO_DST_ESP_SPI, t->dst.u.esp.spi))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static const struct nla_policy esp_nla_policy[CTA_PROTO_MAX + 1] =3D {
+	[CTA_PROTO_SRC_ESP_SPI] =3D { .type =3D NLA_U16 },
+	[CTA_PROTO_DST_ESP_SPI] =3D { .type =3D NLA_U16 },
+};
+
+static int esp_nlattr_to_tuple(struct nlattr *tb[],
+			       struct nf_conntrack_tuple *t,
+				   u32 flags)
+{
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_SRC_ESP_SPI)) {
+		if (!tb[CTA_PROTO_SRC_ESP_SPI])
+			return -EINVAL;
+
+		t->src.u.esp.spi =3D nla_get_be16(tb[CTA_PROTO_SRC_ESP_SPI]);
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_DST_ESP_SPI)) {
+		if (!tb[CTA_PROTO_DST_ESP_SPI])
+			return -EINVAL;
+
+		t->dst.u.esp.spi =3D nla_get_be16(tb[CTA_PROTO_DST_ESP_SPI]);
+	}
+
+	return 0;
+}
+
+static unsigned int esp_nlattr_tuple_size(void)
+{
+	return nla_policy_len(esp_nla_policy, CTA_PROTO_MAX + 1);
+}
+#endif
+
+/* protocol helper struct */
+const struct nf_conntrack_l4proto nf_conntrack_l4proto_esp =3D {
+	.l4proto =3D IPPROTO_ESP,
+#ifdef CONFIG_NF_CONNTRACK_PROCFS
+	.print_conntrack =3D esp_print_conntrack,
+#endif
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
+	.tuple_to_nlattr =3D esp_tuple_to_nlattr,
+	.nlattr_tuple_size =3D esp_nlattr_tuple_size,
+	.nlattr_to_tuple =3D esp_nlattr_to_tuple,
+	.nla_policy =3D esp_nla_policy,
+#endif
+};
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_c=
onntrack_standalone.c
index c6c0cb465664..e8cd28b4e602 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -88,6 +88,11 @@ print_tuple(struct seq_file *s, const struct nf_conntr=
ack_tuple *tuple,
 			   ntohs(tuple->src.u.gre.key),
 			   ntohs(tuple->dst.u.gre.key));
 		break;
+	case IPPROTO_ESP:
+		seq_printf(s, "srcspi=3D0x%x dstspi=3D0x%x ",
+			   ntohs(tuple->src.u.esp.spi),
+			   ntohs(tuple->dst.u.esp.spi));
+		break;
 	default:
 		break;
 	}
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index 832ae64179f0..26db7333c801 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -19,7 +19,9 @@
 #define CTA_FILTER_F_CTA_PROTO_ICMPV6_TYPE	(1 << 9)
 #define CTA_FILTER_F_CTA_PROTO_ICMPV6_CODE	(1 << 10)
 #define CTA_FILTER_F_CTA_PROTO_ICMPV6_ID	(1 << 11)
-#define CTA_FILTER_F_MAX			(1 << 12)
+#define CTA_FILTER_F_CTA_PROTO_SRC_ESP_SPI	(1 << 12)
+#define CTA_FILTER_F_CTA_PROTO_DST_ESP_SPI	(1 << 13)
+#define CTA_FILTER_F_MAX			(1 << 14)
 #define CTA_FILTER_F_ALL			(CTA_FILTER_F_MAX-1)
 #define CTA_FILTER_FLAG(ctattr) CTA_FILTER_F_ ## ctattr
=20
--=20
2.31.1

