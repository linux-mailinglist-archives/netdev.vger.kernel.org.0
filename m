Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D492366230
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 00:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhDTWgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 18:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbhDTWgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 18:36:11 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07B8C06138A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 15:35:38 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id CD193891AF;
        Wed, 21 Apr 2021 10:35:34 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1618958134;
        bh=Nac5D54a3tXWq61DtQmDaf8njXoCW4AbJshwHb0ztGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=A+WsXn9PMGCS+a+FYFJ+sKcSkZCpUiCqFLPp/FUjXLWDi939GyqF+bmskBhp5Ory7
         AqvVBO9mShMLRnKix8zSk1D9ZOIsnUSHUSUUptpEQ3u9gMxcS23bqtH8U8gyIdSwlt
         UkU+sR+eBtKX+LdFk08LvcEtQrEK81u1wejnOUEAmnPTjPwIUjPzKVPKsjQjCj1C2z
         xUcgvkiIXpM6oHnqNorSjQo70M9ojxpg/UpN84dQFkq/RZ7mLzs3FaYhr909UqBGQS
         ZmszAnPIiPFNj0CG+6thSXkaatZhmxcLw3JoKsXd6LKL2FJwhkFmUN+Q7I8E9lZh6h
         u3zJzLme7WT5Q==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B607f57360000>; Wed, 21 Apr 2021 10:35:34 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by smtp (Postfix) with ESMTP id 521AD13EED2;
        Wed, 21 Apr 2021 10:35:56 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id 5A1F024294A; Wed, 21 Apr 2021 10:35:34 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     fw@strlen.de
Cc:     pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
        kuba@kernel.org, Cole.Dishington@alliedtelesis.co.nz,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH] netfilter: nf_conntrack: Add conntrack helper for ESP/IPsec
Date:   Wed, 21 Apr 2021 10:35:13 +1200
Message-Id: <20210420223514.10827-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210414154021.GE14932@breakpoint.cc>
References: <20210414154021.GE14932@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=B+jHL9lM c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=3YhXtTcJ-WEA:10 a=0hR8lASslYw_v_cNunYA:9
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

Notes:
    changes in v2:
    - Move from homegrown hashtables to rhashtables and rhltable.
    - Add net_hash_mix to hashtable key to share hashtables over netns.
    - Move the _esp_table and hashtables from per net nf_esp_net structur=
e to
      static within nf_conntrack_proto_esp.c.
    - Move from rwlock_t for _esp_table to spinlock, as no read locks wer=
e taken.
    - Add IPv6 support.
    - Print the local and remote SPIs (as seen on the wire) for proc in e=
sp_print_conntrack().
    - Removed ct->proto.esp.{timeout,stream_timeout} as it was only used =
by esp_print_conntrack().
      It looks like it may have been copied from gre but gre's is used by=
 pptp.
    - Use 32-bit jiffies and fix counter wrap in search_esp_entry_init_re=
mote().
    - Add NULL check on alloc_esp_entry() kmalloc().
    - Replace custom DEBUGP macro with pr_debug().
    - Rename spi on tuple and tspi to esp.id and esp_id, respectively.
    - Remove __KERNEL__ ifdef from header as it is not in include/uapi/

 .../linux/netfilter/nf_conntrack_proto_esp.h  |  21 +
 .../net/netfilter/ipv4/nf_conntrack_ipv4.h    |   3 +
 include/net/netfilter/nf_conntrack.h          |   2 +
 include/net/netfilter/nf_conntrack_l4proto.h  |  16 +
 include/net/netfilter/nf_conntrack_tuple.h    |   3 +
 include/net/netns/conntrack.h                 |  15 +
 .../netfilter/nf_conntrack_tuple_common.h     |   3 +
 .../linux/netfilter/nfnetlink_conntrack.h     |   2 +
 net/netfilter/Kconfig                         |  10 +
 net/netfilter/Makefile                        |   1 +
 net/netfilter/nf_conntrack_core.c             |  23 +
 net/netfilter/nf_conntrack_netlink.c          |   4 +-
 net/netfilter/nf_conntrack_proto.c            |  12 +
 net/netfilter/nf_conntrack_proto_esp.c        | 736 ++++++++++++++++++
 net/netfilter/nf_conntrack_standalone.c       |   8 +
 net/netfilter/nf_internals.h                  |   4 +-
 16 files changed, 861 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/netfilter/nf_conntrack_proto_esp.h
 create mode 100644 net/netfilter/nf_conntrack_proto_esp.c

diff --git a/include/linux/netfilter/nf_conntrack_proto_esp.h b/include/l=
inux/netfilter/nf_conntrack_proto_esp.h
new file mode 100644
index 000000000000..2e8aa99c5fcc
--- /dev/null
+++ b/include/linux/netfilter/nf_conntrack_proto_esp.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _CONNTRACK_PROTO_ESP_H
+#define _CONNTRACK_PROTO_ESP_H
+#include <asm/byteorder.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+
+/* ESP PROTOCOL HEADER */
+
+struct esphdr {
+	__u32 spi;
+};
+
+struct nf_ct_esp {
+	__u32 l_spi, r_spi;
+};
+
+void destroy_esp_conntrack_entry(struct nf_conn *ct);
+
+bool esp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+		      struct net *net, struct nf_conntrack_tuple *tuple);
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
index 96f9cf81f46b..f700de0b9059 100644
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
@@ -141,6 +148,8 @@ void nf_conntrack_dccp_init_net(struct net *net);
 void nf_conntrack_sctp_init_net(struct net *net);
 void nf_conntrack_icmp_init_net(struct net *net);
 void nf_conntrack_icmpv6_init_net(struct net *net);
+int nf_conntrack_esp_init(void);
+void nf_conntrack_esp_init_net(struct net *net);
=20
 /* Existing built-in generic protocol */
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
@@ -240,4 +249,11 @@ static inline struct nf_gre_net *nf_gre_pernet(struc=
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
index 9334371c94e2..60279ffabe36 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -62,6 +62,9 @@ struct nf_conntrack_tuple {
 			struct {
 				__be16 key;
 			} gre;
+			struct {
+				__be16 id;
+			} esp;
 		} u;
=20
 		/* The protocol. */
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.=
h
index 806454e767bf..29f7e779265a 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -69,6 +69,18 @@ struct nf_gre_net {
 };
 #endif
=20
+#ifdef CONFIG_NF_CT_PROTO_ESP
+enum esp_conntrack {
+	ESP_CT_UNREPLIED,
+	ESP_CT_REPLIED,
+	ESP_CT_MAX
+};
+
+struct nf_esp_net {
+	unsigned int esp_timeouts[ESP_CT_MAX];
+};
+#endif
+
 struct nf_ip_net {
 	struct nf_generic_net   generic;
 	struct nf_tcp_net	tcp;
@@ -84,6 +96,9 @@ struct nf_ip_net {
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
index 64390fac6f7e..78600cb4bfff 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
@@ -39,6 +39,9 @@ union nf_conntrack_man_proto {
 	struct {
 		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
 	} gre;
+	struct {
+		__be16 id;
+	} esp;
 };
=20
 #define CTINFO2DIR(ctinfo) ((ctinfo) >=3D IP_CT_IS_REPLY ? IP_CT_DIR_REP=
LY : IP_CT_DIR_ORIGINAL)
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include=
/uapi/linux/netfilter/nfnetlink_conntrack.h
index d8484be72fdc..744d8931adeb 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -90,6 +90,8 @@ enum ctattr_l4proto {
 	CTA_PROTO_ICMPV6_ID,
 	CTA_PROTO_ICMPV6_TYPE,
 	CTA_PROTO_ICMPV6_CODE,
+	CTA_PROTO_SRC_ESP_ID,
+	CTA_PROTO_DST_ESP_ID,
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
index 1d519b0e51a5..8df33dbbf5a3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1382,7 +1382,9 @@ static const struct nla_policy tuple_nla_policy[CTA=
_TUPLE_MAX+1] =3D {
    CTA_FILTER_F_CTA_PROTO_ICMP_ID | \
    CTA_FILTER_F_CTA_PROTO_ICMPV6_TYPE | \
    CTA_FILTER_F_CTA_PROTO_ICMPV6_CODE | \
-   CTA_FILTER_F_CTA_PROTO_ICMPV6_ID)
+   CTA_FILTER_F_CTA_PROTO_ICMPV6_ID | \
+   CTA_FILTER_F_CTA_PROTO_SRC_ESP_ID | \
+   CTA_FILTER_F_CTA_PROTO_DST_ESP_ID)
=20
 static int
 ctnetlink_parse_tuple_filter(const struct nlattr * const cda[],
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntr=
ack_proto.c
index 47e9319d2cf3..abba94f782c1 100644
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
@@ -656,6 +659,12 @@ int nf_conntrack_proto_init(void)
 		goto cleanup_sockopt;
 #endif
=20
+#ifdef CONFIG_NF_CT_PROTO_ESP
+	ret =3D nf_conntrack_esp_init();
+	if (ret < 0)
+		goto cleanup_sockopt;
+#endif
+
 	return ret;
=20
 #if IS_ENABLED(CONFIG_IPV6)
@@ -691,6 +700,9 @@ void nf_conntrack_proto_pernet_init(struct net *net)
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
index 000000000000..f17ce8a9439f
--- /dev/null
+++ b/net/netfilter/nf_conntrack_proto_esp.c
@@ -0,0 +1,736 @@
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
+ * Implements the ESP ALG connectiontracking via soft-splicing two ESP
+ * connections together using each connections SPI. The connection is
+ * then identified with a generated esp id.
+ *
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
+ *	  replace prinks with DEBUGPs. (Anthony Lineham)
+ *	- Extend ESP connection tracking to allow conntrack ESP entry matchin=
g
+ *	  of tuple values. (Matt Bennett)
+ * Updates to ESP conntracking on March 3,2021 by Allied Telesis Labs NZ=
 (Cole Dishington):
+ *	- Migrate from homegrown hashtables per netns to rhashtable and
+ *	  rhltables shared between all netns.
+ *	- Move esp_table and hashtables to be shared over netns, rather than =
one per netns.
+ *	- Added IPv6 support.
+ *	- Added fixups for upstream including comments, DEBUGP -> pr_debug,
+ *	  64b -> 32 bit jiffies, and l_spi/r_spi exposed to procfs.
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
+#include <net/netns/hash.h>
+#include <linux/rhashtable.h>
+#include <net/ipv6.h>
+
+#include "nf_internals.h"
+
+#define ESP_MAX_CONNECTIONS      1000
+#define HASH_TAB_MAX_SIZE  ESP_MAX_CONNECTIONS
+/* esp_id of 0 is left for unassigned values */
+#define TEMP_SPI_START 1
+#define TEMP_SPI_MAX   (TEMP_SPI_START + ESP_MAX_CONNECTIONS - 1)
+
+struct _esp_table {
+       /* Hash table nodes for each required lookup
+	* lnode: net->hash_mix, l_spi, l_ip, r_ip
+	* rnode: net->hash_mix, r_spi, r_ip
+	* incmpl_rlist: net->hash_mix, r_ip
+	*/
+	struct rhash_head lnode;
+	struct rhash_head rnode;
+	struct rhlist_head incmpl_rlist;
+
+	u16 esp_id;
+
+	u32 l_spi;
+	u32 r_spi;
+
+	u16 l3num;
+	union nf_inet_addr l_ip;
+	union nf_inet_addr r_ip;
+
+	u32 alloc_time_jiffies;
+	struct net *net;
+};
+
+struct _esp_hkey {
+	u16 l3num;
+	union nf_inet_addr src_ip;
+	union nf_inet_addr dst_ip;
+	u32 net_hmix;
+	u32 spi;
+};
+
+static DEFINE_SPINLOCK(esp_table_lock);
+static struct _esp_table *esp_table[ESP_MAX_CONNECTIONS];
+static struct rhashtable ltable;
+static struct rhashtable rtable;
+static struct rhltable incmpl_rtable;
+static unsigned int esp_timeouts[ESP_CT_MAX] =3D {
+	[ESP_CT_UNREPLIED] =3D 60 * HZ,
+	[ESP_CT_REPLIED] =3D 3600 * HZ,
+};
+
+static inline void esp_ip_addr_set_any(int af, union nf_inet_addr *a)
+{
+	if (af =3D=3D AF_INET6)
+		ipv6_addr_set(&a->in6, 0, 0, 0, 0);
+	else
+		a->ip =3D 0;
+}
+
+static inline void esp_ip_addr_copy(int af, union nf_inet_addr *dst,
+				    const union nf_inet_addr *src)
+{
+	if (af =3D=3D AF_INET6)
+		ipv6_addr_prefix_copy(&dst->in6, &src->in6, 128);
+	else
+		dst->ip =3D src->ip;
+}
+
+static inline int esp_ip_addr_equal(int af, const union nf_inet_addr *a,
+				    const union nf_inet_addr *b)
+{
+	if (af =3D=3D AF_INET6)
+		return ipv6_addr_equal(&a->in6, &b->in6);
+	return a->ip =3D=3D b->ip;
+}
+
+static inline struct nf_esp_net *esp_pernet(struct net *net)
+{
+	return &net->ct.nf_ct_proto.esp;
+}
+
+static inline void calculate_key(const u32 net_hmix, const u32 spi,
+				 const u16 l3num,
+				 const union nf_inet_addr *src_ip,
+				 const union nf_inet_addr *dst_ip,
+				 struct _esp_hkey *key)
+{
+	key->net_hmix =3D net_hmix;
+	key->spi =3D spi;
+	key->l3num =3D l3num;
+	esp_ip_addr_copy(l3num, &key->src_ip, src_ip);
+	esp_ip_addr_copy(l3num, &key->dst_ip, dst_ip);
+}
+
+static inline u32 calculate_hash(const void *data, u32 len, u32 seed)
+{
+	return jhash(data, len, seed);
+}
+
+static int ltable_obj_cmpfn(struct rhashtable_compare_arg *arg, const vo=
id *obj)
+{
+	struct _esp_hkey obj_key =3D {};
+	const struct _esp_hkey *key =3D (const struct _esp_hkey *)arg->key;
+	const struct _esp_table *eobj =3D (const struct _esp_table *)obj;
+	u32 net_hmix =3D net_hash_mix(eobj->net);
+
+	calculate_key(net_hmix, eobj->l_spi, eobj->l3num, &eobj->l_ip,
+		      &eobj->r_ip, &obj_key);
+	return memcmp(key, &obj_key, sizeof(struct _esp_hkey));
+}
+
+static int rtable_obj_cmpfn(struct rhashtable_compare_arg *arg, const vo=
id *obj)
+{
+	union nf_inet_addr any;
+	struct _esp_hkey obj_key =3D {};
+	const struct _esp_hkey *key =3D (const struct _esp_hkey *)arg->key;
+	const struct _esp_table *eobj =3D (const struct _esp_table *)obj;
+	u32 net_hmix =3D net_hash_mix(eobj->net);
+
+	esp_ip_addr_set_any(eobj->l3num, &any);
+	calculate_key(net_hmix, eobj->r_spi, eobj->l3num, &any, &eobj->r_ip,
+		      &obj_key);
+	return memcmp(key, &obj_key, sizeof(struct _esp_hkey));
+}
+
+static int incmpl_table_obj_cmpfn(struct rhashtable_compare_arg *arg, co=
nst void *obj)
+{
+	union nf_inet_addr any;
+	struct _esp_hkey obj_key =3D {};
+	const struct _esp_hkey *key =3D (const struct _esp_hkey *)arg->key;
+	const struct _esp_table *eobj =3D (const struct _esp_table *)obj;
+	u32 net_hmix =3D net_hash_mix(eobj->net);
+
+	esp_ip_addr_set_any(eobj->l3num, &any);
+	calculate_key(net_hmix, 0, eobj->l3num, &any, &eobj->r_ip, &obj_key);
+	return memcmp(key, &obj_key, sizeof(struct _esp_hkey));
+}
+
+static u32 ltable_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	struct _esp_hkey key =3D {};
+	const struct _esp_table *eobj =3D (const struct _esp_table *)data;
+	u32 net_hmix =3D net_hash_mix(eobj->net);
+
+	calculate_key(net_hmix, eobj->l_spi, eobj->l3num, &eobj->l_ip,
+		      &eobj->r_ip, &key);
+	return calculate_hash(&key, len, seed);
+}
+
+static u32 rtable_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	union nf_inet_addr any;
+	struct _esp_hkey key =3D {};
+	const struct _esp_table *eobj =3D (const struct _esp_table *)data;
+	u32 net_hmix =3D net_hash_mix(eobj->net);
+
+	esp_ip_addr_set_any(eobj->l3num, &any);
+	calculate_key(net_hmix, eobj->r_spi, eobj->l3num, &any, &eobj->r_ip, &k=
ey);
+	return calculate_hash(&key, len, seed);
+}
+
+static u32 incmpl_table_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	union nf_inet_addr any;
+	struct _esp_hkey key =3D {};
+	const struct _esp_table *eobj =3D (const struct _esp_table *)data;
+	u32 net_hmix =3D net_hash_mix(eobj->net);
+
+	esp_ip_addr_set_any(eobj->l3num, &any);
+	calculate_key(net_hmix, 0, eobj->l3num, &any, &eobj->r_ip, &key);
+	return calculate_hash(&key, len, seed);
+}
+
+static const struct rhashtable_params ltable_params =3D {
+	.key_len     =3D sizeof(struct _esp_hkey),
+	.head_offset =3D offsetof(struct _esp_table, lnode),
+	.max_size =3D HASH_TAB_MAX_SIZE,
+	.hashfn      =3D calculate_hash,
+	.obj_hashfn =3D ltable_obj_hashfn,
+	.obj_cmpfn   =3D ltable_obj_cmpfn,
+};
+
+static const struct rhashtable_params rtable_params =3D {
+	.key_len     =3D sizeof(struct _esp_hkey),
+	.head_offset =3D offsetof(struct _esp_table, rnode),
+	.max_size =3D HASH_TAB_MAX_SIZE,
+	.hashfn      =3D calculate_hash,
+	.obj_hashfn =3D rtable_obj_hashfn,
+	.obj_cmpfn   =3D rtable_obj_cmpfn,
+};
+
+static const struct rhashtable_params incmpl_rtable_params =3D {
+	.key_len     =3D sizeof(struct _esp_hkey),
+	.head_offset =3D offsetof(struct _esp_table, incmpl_rlist),
+	.max_size =3D HASH_TAB_MAX_SIZE,
+	.hashfn      =3D calculate_hash,
+	.obj_hashfn =3D incmpl_table_obj_hashfn,
+	.obj_cmpfn   =3D incmpl_table_obj_cmpfn,
+};
+
+int nf_conntrack_esp_init(void)
+{
+	int i;
+	int ret =3D 0;
+
+	spin_lock_bh(&esp_table_lock);
+
+	for (i =3D 0; i < ESP_MAX_CONNECTIONS; i++)
+		memset(&esp_table[i], 0, sizeof(struct _esp_table *));
+
+	ret =3D rhashtable_init(&ltable, &ltable_params);
+	if (ret)
+		return ret;
+
+	ret =3D rhashtable_init(&rtable, &rtable_params);
+	if (ret)
+		goto err_free_ltable;
+
+	ret =3D rhltable_init(&incmpl_rtable, &incmpl_rtable_params);
+	if (ret)
+		goto err_free_rtable;
+
+	spin_unlock_bh(&esp_table_lock);
+
+	return ret;
+
+err_free_rtable:
+	rhashtable_destroy(&rtable);
+err_free_ltable:
+	rhashtable_destroy(&ltable);
+
+	spin_unlock_bh(&esp_table_lock);
+	return ret;
+}
+
+void nf_conntrack_esp_init_net(struct net *net)
+{
+	int i;
+	struct nf_esp_net *net_esp =3D esp_pernet(net);
+
+	for (i =3D 0; i < ESP_CT_MAX; i++)
+		net_esp->esp_timeouts[i] =3D esp_timeouts[i];
+}
+
+/* Free an entry referred to by esp_id.
+ *
+ * NOTE:
+ * Entry table locking and unlocking is the responsibility of the callin=
g function.
+ * Range checking is the responsibility of the calling function.
+ */
+static void esp_table_free_entry_by_esp_id(struct net *net, u16 esp_id)
+{
+	struct _esp_table *esp_entry;
+
+	esp_entry =3D esp_table[esp_id - TEMP_SPI_START];
+	if (esp_entry) {
+		/* Remove from all the hash tables.
+		 */
+		pr_debug("Removing entry %x from all tables", esp_entry->esp_id);
+		rhashtable_remove_fast(&ltable, &esp_entry->lnode, ltable_params);
+		rhashtable_remove_fast(&rtable, &esp_entry->rnode, rtable_params);
+		rhltable_remove(&incmpl_rtable, &esp_entry->incmpl_rlist, incmpl_rtabl=
e_params);
+		esp_table[esp_id - TEMP_SPI_START] =3D NULL;
+		kfree(esp_entry);
+	}
+}
+
+/* Allocate the first available IPSEC table entry.
+ * NOTE: The ESP entry table must be locked prior to calling this functi=
on.
+ */
+struct _esp_table *alloc_esp_entry(struct net *net)
+{
+	int idx;
+	struct _esp_table *esp_entry =3D NULL;
+
+	/* Find the first unused slot */
+	for (idx =3D 0; idx < ESP_MAX_CONNECTIONS; idx++) {
+		if (esp_table[idx])
+			continue;
+
+		esp_table[idx] =3D kmalloc(sizeof(*esp_entry), GFP_ATOMIC);
+		if (!esp_table[idx])
+			return NULL;
+		memset(esp_table[idx], 0, sizeof(struct _esp_table));
+		esp_table[idx]->esp_id =3D idx + TEMP_SPI_START;
+		esp_table[idx]->alloc_time_jiffies =3D nfct_time_stamp;
+		esp_table[idx]->net =3D net;
+		esp_entry =3D esp_table[idx];
+		break;
+	}
+	return esp_entry;
+}
+
+/* Search for an ESP entry in the initial state based on the IP address =
of
+ * the remote peer.
+ * NOTE: The ESP entry table must be locked prior to calling this functi=
on.
+ */
+static struct _esp_table *search_esp_entry_init_remote(struct net *net,
+						       u16 l3num,
+						       const union nf_inet_addr *src_ip)
+{
+	union nf_inet_addr any;
+	u32 net_hmix =3D net_hash_mix(net);
+	struct _esp_table *esp_entry =3D NULL;
+	struct _esp_hkey key =3D {};
+	int first_entry =3D -1;
+	struct rhlist_head *pos, *list;
+
+	esp_ip_addr_set_any(l3num, &any);
+
+	calculate_key(net_hmix, 0, l3num, &any, src_ip, &key);
+	list =3D rhltable_lookup(&incmpl_rtable, (const void *)&key, incmpl_rta=
ble_params);
+	rhl_for_each_entry_rcu(esp_entry, pos, list, incmpl_rlist) {
+		if (net_eq(net, esp_entry->net) &&
+		    l3num =3D=3D esp_entry->l3num &&
+		    esp_ip_addr_equal(l3num, src_ip, &esp_entry->r_ip) &&
+		    esp_entry->r_spi =3D=3D 0) {
+			if (first_entry =3D=3D -1) {
+				first_entry =3D esp_entry->esp_id - TEMP_SPI_START;
+			} else if (esp_table[first_entry]->alloc_time_jiffies - esp_entry->al=
loc_time_jiffies <=3D 0) {
+				/* This entry is older than the last one found so treat this
+				 * as a better match.
+				 */
+				first_entry =3D esp_entry->esp_id - TEMP_SPI_START;
+			}
+		}
+	}
+
+	if (first_entry !=3D -1) {
+		if (esp_entry->l3num =3D=3D AF_INET) {
+			pr_debug("Matches incmpl_rtable entry %x with l_spi %x r_spi %x r_ip =
%pI4\n",
+				 esp_entry->esp_id, esp_entry->l_spi, esp_entry->r_spi,
+				 &esp_entry->r_ip.in);
+		} else {
+			pr_debug("Matches incmpl_rtable entry %x with l_spi %x r_spi %x r_ip =
%pI6\n",
+				 esp_entry->esp_id, esp_entry->l_spi, esp_entry->r_spi,
+				 &esp_entry->r_ip.in6);
+		}
+		esp_entry =3D esp_table[first_entry];
+		return esp_entry;
+	}
+
+	return NULL;
+}
+
+/* Search for an ESP entry by SPI, source and destination IP addresses.
+ * NOTE: The ESP entry table must be locked prior to calling this functi=
on.
+ */
+static struct _esp_table *search_esp_entry_by_spi(struct net *net, const=
 __u32 spi,
+						  u16 l3num,
+						  const union nf_inet_addr *src_ip,
+						  const union nf_inet_addr *dst_ip)
+{
+	union nf_inet_addr any;
+	u32 net_hmix =3D net_hash_mix(net);
+	struct _esp_table *esp_entry;
+	struct _esp_hkey key =3D {};
+
+	esp_ip_addr_set_any(l3num, &any);
+
+	/* Check for matching established session or repeated initial LAN side =
*/
+	/* LAN side first */
+	calculate_key(net_hmix, spi, l3num, src_ip, dst_ip, &key);
+	esp_entry =3D rhashtable_lookup_fast(&ltable, (const void *)&key, ltabl=
e_params);
+	if (esp_entry) {
+		/* When r_spi is set this is an established session. When not set it's
+		 * a repeated initial packet from LAN side. But both cases are treated
+		 * the same.
+		 */
+		if (esp_entry->l3num =3D=3D AF_INET) {
+			pr_debug("Matches ltable entry %x with l_spi %x l_ip %pI4 r_ip %pI4\n=
",
+				 esp_entry->esp_id, esp_entry->l_spi,
+				 &esp_entry->l_ip.in, &esp_entry->r_ip.in);
+		} else {
+			pr_debug("Matches ltable entry %x with l_spi %x l_ip %pI6 r_ip %pI6\n=
",
+				 esp_entry->esp_id, esp_entry->l_spi,
+				 &esp_entry->l_ip.in6, &esp_entry->r_ip.in6);
+		}
+		return esp_entry;
+	}
+
+	/* Established remote side */
+	calculate_key(net_hmix, spi, l3num, &any, src_ip, &key);
+	esp_entry =3D rhashtable_lookup_fast(&rtable, (const void *)&key, rtabl=
e_params);
+	if (esp_entry) {
+		if (esp_entry->l3num =3D=3D AF_INET) {
+			pr_debug("Matches rtable entry %x with l_spi %x r_spi %x l_ip %pI4 r_=
ip %pI4\n",
+				 esp_entry->esp_id, esp_entry->l_spi, esp_entry->r_spi,
+				 &esp_entry->l_ip.in, &esp_entry->r_ip.in);
+		} else {
+			pr_debug("Matches rtable entry %x with l_spi %x r_spi %x l_ip %pI6 r_=
ip %pI6\n",
+				 esp_entry->esp_id, esp_entry->l_spi, esp_entry->r_spi,
+				 &esp_entry->l_ip.in6, &esp_entry->r_ip.in6);
+		}
+		return esp_entry;
+	}
+
+	/* Incomplete remote side, check if packet has a missing r_spi */
+	esp_entry =3D search_esp_entry_init_remote(net, l3num, src_ip);
+	if (esp_entry) {
+		int err;
+
+		esp_entry->r_spi =3D spi;
+		/* Remove entry from incmpl_rtable and add to rtable */
+		rhltable_remove(&incmpl_rtable, &esp_entry->incmpl_rlist, incmpl_rtabl=
e_params);
+		/* Error will not be due to duplicate as established remote side looku=
p
+		 * above would have found it. Delete entry.
+		 */
+		err =3D rhashtable_insert_fast(&rtable, &esp_entry->rnode, rtable_para=
ms);
+		if (err) {
+			esp_table_free_entry_by_esp_id(net, esp_entry->esp_id);
+			return NULL;
+		}
+		return esp_entry;
+	}
+
+	if (l3num =3D=3D AF_INET) {
+		pr_debug("No entry matches for spi %x src_ip %pI4 dst_ip %pI4\n",
+			 spi, &src_ip->in, &dst_ip->in);
+	} else {
+		pr_debug("No entry matches for spi %x src_ip %pI6 dst_ip %pI6\n",
+			 spi, &src_ip->in6, &dst_ip->in6);
+	}
+	return NULL;
+}
+
+/* invert esp part of tuple */
+bool nf_conntrack_invert_esp_tuple(struct nf_conntrack_tuple *tuple,
+				   const struct nf_conntrack_tuple *orig)
+{
+	tuple->dst.u.esp.id =3D orig->dst.u.esp.id;
+	tuple->src.u.esp.id =3D orig->src.u.esp.id;
+	return true;
+}
+
+/* esp hdr info to tuple */
+bool esp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+		      struct net *net, struct nf_conntrack_tuple *tuple)
+{
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
+	/* Check if esphdr already associated with a pre-existing connection:
+	 *   if no, create a new connection, missing the r_spi;
+	 *   if yes, check if we have seen the source IP:
+	 *             if no, fill in r_spi in the pre-existing connection.
+	 */
+	spin_lock_bh(&esp_table_lock);
+	esp_entry =3D search_esp_entry_by_spi(net, spi, tuple->src.l3num,
+					    &tuple->src.u3, &tuple->dst.u3);
+	if (!esp_entry) {
+		struct _esp_hkey key =3D {};
+		union nf_inet_addr any;
+		u32 net_hmix =3D net_hash_mix(net);
+		int err;
+
+		esp_entry =3D alloc_esp_entry(net);
+		if (!esp_entry) {
+			pr_debug("All esp connection slots in use\n");
+			spin_unlock_bh(&esp_table_lock);
+			return false;
+		}
+		esp_entry->l_spi =3D spi;
+		esp_entry->l3num =3D tuple->src.l3num;
+		esp_ip_addr_copy(esp_entry->l3num, &esp_entry->l_ip, &tuple->src.u3);
+		esp_ip_addr_copy(esp_entry->l3num, &esp_entry->r_ip, &tuple->dst.u3);
+
+		/* Add entries to the hash tables */
+
+		err =3D rhashtable_insert_fast(&ltable, &esp_entry->lnode, ltable_para=
ms);
+		if (err) {
+			esp_table_free_entry_by_esp_id(net, esp_entry->esp_id);
+			return false;
+		}
+
+		esp_ip_addr_set_any(esp_entry->l3num, &any);
+		calculate_key(net_hmix, 0, esp_entry->l3num, &any, &esp_entry->r_ip, &=
key);
+		err =3D rhltable_insert_key(&incmpl_rtable, (const void *)&key,
+					  &esp_entry->incmpl_rlist, incmpl_rtable_params);
+		if (err) {
+			esp_table_free_entry_by_esp_id(net, esp_entry->esp_id);
+			return false;
+		}
+
+		if (esp_entry->l3num =3D=3D AF_INET) {
+			pr_debug("New entry %x with l_spi %x l_ip %pI4 r_ip %pI4\n",
+				 esp_entry->esp_id, esp_entry->l_spi,
+				 &esp_entry->l_ip.in, &esp_entry->r_ip.in);
+		} else {
+			pr_debug("New entry %x with l_spi %x l_ip %pI6 r_ip %pI6\n",
+				 esp_entry->esp_id, esp_entry->l_spi,
+				 &esp_entry->l_ip.in6, &esp_entry->r_ip.in6);
+		}
+	}
+
+	tuple->dst.u.esp.id =3D esp_entry->esp_id;
+	tuple->src.u.esp.id =3D esp_entry->esp_id;
+	spin_unlock_bh(&esp_table_lock);
+	return true;
+}
+
+#ifdef CONFIG_NF_CONNTRACK_PROCFS
+/* print private data for conntrack */
+static void esp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
+{
+	seq_printf(s, "l_spi=3D%x, r_spi=3D%x ", ct->proto.esp.l_spi, ct->proto=
.esp.r_spi);
+}
+#endif
+
+/* Returns verdict for packet, and may modify conntrack */
+int nf_conntrack_esp_packet(struct nf_conn *ct, struct sk_buff *skb,
+			    unsigned int dataoff,
+			    enum ip_conntrack_info ctinfo,
+			    const struct nf_hook_state *state)
+{
+	u16 esp_id;
+	struct nf_conntrack_tuple *tuple;
+	struct _esp_table *esp_entry;
+	unsigned int *timeouts =3D nf_ct_timeout_lookup(ct);
+
+	if (!timeouts)
+		timeouts =3D esp_pernet(nf_ct_net(ct))->esp_timeouts;
+
+	/* If we've seen traffic both ways, this is some kind of ESP
+	 * stream.  Extend timeout.
+	 */
+	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[ESP_CT_REPLIED]);
+		/* Also, more likely to be important, and not a probe */
+		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status)) {
+			/* Was originally IPCT_STATUS but this is no longer an option.
+			 * GRE uses assured for same purpose
+			 */
+			nf_conntrack_event_cache(IPCT_ASSURED, ct);
+
+			/* Retrieve SPIs of original and reply from esp_entry.
+			 * Both directions should contain the same esp_entry,
+			 * so just check the first one.
+			 */
+			tuple =3D nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL);
+			esp_id =3D tuple->src.u.esp.id;
+			if (esp_id >=3D TEMP_SPI_START && esp_id <=3D TEMP_SPI_MAX) {
+				spin_lock_bh(&esp_table_lock);
+				esp_entry =3D esp_table[esp_id - TEMP_SPI_START];
+				if (esp_entry) {
+					ct->proto.esp.l_spi =3D esp_entry->l_spi;
+					ct->proto.esp.r_spi =3D esp_entry->r_spi;
+				}
+				spin_unlock_bh(&esp_table_lock);
+			}
+		}
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
+	u16 esp_id =3D 0;
+	struct net *net =3D nf_ct_net(ct);
+
+	spin_lock_bh(&esp_table_lock);
+
+	/* Probably all the ESP entries referenced in this connection are the s=
ame,
+	 * but the free function handles repeated frees, so best to do them all=
.
+	 */
+	for (dir =3D IP_CT_DIR_ORIGINAL; dir < IP_CT_DIR_MAX; dir++) {
+		tuple =3D nf_ct_tuple(ct, dir);
+
+		esp_id =3D tuple->src.u.esp.id;
+		if (esp_id >=3D TEMP_SPI_START && esp_id <=3D TEMP_SPI_MAX) {
+			pr_debug("Deleting src esp_id %x (dir %i)\n", esp_id, dir);
+			esp_table_free_entry_by_esp_id(net, esp_id);
+		}
+		tuple->src.u.esp.id =3D 0;
+		esp_id =3D tuple->dst.u.esp.id;
+		if (esp_id >=3D TEMP_SPI_START && esp_id <=3D TEMP_SPI_MAX) {
+			pr_debug("Deleting dst esp_id %x (dir %i)\n", esp_id, dir);
+			esp_table_free_entry_by_esp_id(net, esp_id);
+		}
+		tuple->dst.u.esp.id =3D 0;
+	}
+
+	spin_unlock_bh(&esp_table_lock);
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
+	if (nla_put_be16(skb, CTA_PROTO_SRC_ESP_ID, t->src.u.esp.id) ||
+	    nla_put_be16(skb, CTA_PROTO_DST_ESP_ID, t->dst.u.esp.id))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static const struct nla_policy esp_nla_policy[CTA_PROTO_MAX + 1] =3D {
+	[CTA_PROTO_SRC_ESP_ID] =3D { .type =3D NLA_U16 },
+	[CTA_PROTO_DST_ESP_ID] =3D { .type =3D NLA_U16 },
+};
+
+static int esp_nlattr_to_tuple(struct nlattr *tb[],
+			       struct nf_conntrack_tuple *t,
+			       u32 flags)
+{
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_SRC_ESP_ID)) {
+		if (!tb[CTA_PROTO_SRC_ESP_ID])
+			return -EINVAL;
+
+		t->src.u.esp.id =3D nla_get_be16(tb[CTA_PROTO_SRC_ESP_ID]);
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_DST_ESP_ID)) {
+		if (!tb[CTA_PROTO_DST_ESP_ID])
+			return -EINVAL;
+
+		t->dst.u.esp.id =3D nla_get_be16(tb[CTA_PROTO_DST_ESP_ID]);
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
index c6c0cb465664..7922ff6cf5a4 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -88,6 +88,14 @@ print_tuple(struct seq_file *s, const struct nf_conntr=
ack_tuple *tuple,
 			   ntohs(tuple->src.u.gre.key),
 			   ntohs(tuple->dst.u.gre.key));
 		break;
+	case IPPROTO_ESP:
+		/* Both src and dest esp.id should be equal but showing both
+		 * will help find errors.
+		 */
+		seq_printf(s, "srcid=3D0x%x dstid=3D0x%x ",
+			   ntohs(tuple->src.u.esp.id),
+			   ntohs(tuple->dst.u.esp.id));
+		break;
 	default:
 		break;
 	}
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index 832ae64179f0..4fd8956aec65 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -19,7 +19,9 @@
 #define CTA_FILTER_F_CTA_PROTO_ICMPV6_TYPE	(1 << 9)
 #define CTA_FILTER_F_CTA_PROTO_ICMPV6_CODE	(1 << 10)
 #define CTA_FILTER_F_CTA_PROTO_ICMPV6_ID	(1 << 11)
-#define CTA_FILTER_F_MAX			(1 << 12)
+#define CTA_FILTER_F_CTA_PROTO_SRC_ESP_ID	(1 << 12)
+#define CTA_FILTER_F_CTA_PROTO_DST_ESP_ID	(1 << 13)
+#define CTA_FILTER_F_MAX			(1 << 14)
 #define CTA_FILTER_F_ALL			(CTA_FILTER_F_MAX-1)
 #define CTA_FILTER_FLAG(ctattr) CTA_FILTER_F_ ## ctattr
=20
--=20
2.31.1

