Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFAF12A3B7
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 18:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLXR4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 12:56:18 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46488 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfLXR4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 12:56:17 -0500
Received: by mail-pg1-f195.google.com with SMTP id z124so10660860pgb.13
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 09:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vgOEHh/r9AnW0zteGfQROPvpmkcboX3iI3FCKIWRyrU=;
        b=dFEBnZQpCzgxZ2nFcMgJmGQDNoAdMmYRtASsFm3MsrknIAXhVtl8OakZq6fUDYpVTF
         Mj9Jq50aMJyyV4wmCTKkx2q1zvTvrwr+nNoWKcZRauNqbcENjXfX5Q1hR0bVeu249MBB
         Pf7wmj5nMtJZCUVXlRwf5tvpEwI8NJ7ro0fALC930PkAzMmqCMp8IM15uTJQiSbH3ceT
         jqTuz7EPCnLuKiHFEC16O0yBPXGkIgPo5E3reoFBdwVbhVnR7MzTSQh/zt7ePzTr3Dut
         UZOtdj6T/dWDRjIt3owg4OmDGwEEsfJ3m2HyfgifFXpk/Jdf2kC/oPk5eQ7O36vOYOvA
         AgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vgOEHh/r9AnW0zteGfQROPvpmkcboX3iI3FCKIWRyrU=;
        b=Hueh7ZEoooPvnUz/q3h/6eZBqfphjczsRpEg9L8hA2kegDX1iBiXWOu9/XdFbpGAuu
         QGT6DpUKH8NqXfQpO5CrhEUyJnoLRWp6l3S1BCf+hbeZNdcR5SFNgUBO+OxLgMpDQJTG
         IVEkzxewLQHaze6NzkDvulQeHEAryjrtC5S0/S+I4iYpSAacurci3Kd0Whk1DkWwRe1F
         e2YXlEBHo4bqDpobU57pA5rL/QyNQqlTJuZgHBcAnHLyHQS6wLRKE+QKeDaoefwAVlCr
         Q5IcnRvlUSKJNQ++C72tv7qBhS73NZgcG5T1WvefxVxyAbsY0xXwDuYbKzQeGdXVkFef
         JWvg==
X-Gm-Message-State: APjAAAWOOp4YyLQqQ/UPMvWMqZkV9vHLc3FC5QPQ2DcSj6Go+nHhjm3x
        sCFz8FfudocnSqQKsy2T+GBo0kU7u+Q=
X-Google-Smtp-Source: APXvYqweaIk7Su6/wZYAkt+CaeDBX2aoetMn1h4QYZOP8FPXLPzdIVkI3jOuFNEp826gpqWhbY2huA==
X-Received: by 2002:aa7:9111:: with SMTP id 17mr13424450pfh.163.1577210176447;
        Tue, 24 Dec 2019 09:56:16 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id l22sm4410433pjc.0.2019.12.24.09.56.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 24 Dec 2019 09:56:15 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        simon.horman@netronome.com, willemdebruijn.kernel@gmail.com
Cc:     Tom Herbert <tom@quantonium.net>, Tom Herbert <tom@herbertland.com>
Subject: [PATCH v7 net-next 2/9] ipeh: Create exthdrs_options.c and ipeh.h
Date:   Tue, 24 Dec 2019 09:55:41 -0800
Message-Id: <1577210148-7328-3-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577210148-7328-1-git-send-email-tom@herbertland.com>
References: <1577210148-7328-1-git-send-email-tom@herbertland.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@quantonium.net>

Create exthdrs_options.c to hold code related to specific Hop-by-Hop
and Destination extension header options. Move related functions in
exthdrs.c to the new file.

Create include net/ipeh.h to contain common definitions for IP extension
headers.

Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Tom Herbert <tom@herbertland.com>
---
 include/net/ipeh.h         |  22 +++++
 include/net/ipv6.h         |   1 +
 net/ipv6/Makefile          |   2 +-
 net/ipv6/exthdrs.c         | 204 ---------------------------------------------
 net/ipv6/exthdrs_options.c | 201 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 225 insertions(+), 205 deletions(-)
 create mode 100644 include/net/ipeh.h
 create mode 100644 net/ipv6/exthdrs_options.c

diff --git a/include/net/ipeh.h b/include/net/ipeh.h
new file mode 100644
index 0000000..ec2d186
--- /dev/null
+++ b/include/net/ipeh.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NET_IPEH_H
+#define _NET_IPEH_H
+
+#include <linux/skbuff.h>
+
+/*
+ *     Parsing tlv encoded headers.
+ *
+ *     Parsing function "func" returns true, if parsing succeed
+ *     and false, if it failed.
+ *     It MUST NOT touch skb->h.
+ */
+struct tlvtype_proc {
+	int	type;
+	bool	(*func)(struct sk_buff *skb, int offset);
+};
+
+extern const struct tlvtype_proc tlvprocdestopt_lst[];
+extern const struct tlvtype_proc tlvprochopopt_lst[];
+
+#endif /* _NET_IPEH_H */
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 4e95f6d..1d84394 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -20,6 +20,7 @@
 #include <net/flow_dissector.h>
 #include <net/snmp.h>
 #include <net/netns/hash.h>
+#include <net/ipeh.h>
 
 #define SIN6_LEN_RFC2133	24
 
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 8ccf355..df3919b 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -10,7 +10,7 @@ ipv6-objs :=	af_inet6.o anycast.o ip6_output.o ip6_input.o addrconf.o \
 		route.o ip6_fib.o ipv6_sockglue.o ndisc.o udp.o udplite.o \
 		raw.o icmp.o mcast.o reassembly.o tcp_ipv6.o ping.o \
 		exthdrs.o datagram.o ip6_flowlabel.o inet6_connection_sock.o \
-		udp_offload.o seg6.o fib6_notifier.o
+		udp_offload.o seg6.o fib6_notifier.o exthdrs_options.o
 
 ipv6-offload :=	ip6_offload.o tcpv6_offload.o exthdrs_offload.o
 
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index e7eacc4..4709cc1 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -39,7 +39,6 @@
 #include <net/ndisc.h>
 #include <net/ip6_route.h>
 #include <net/addrconf.h>
-#include <net/calipso.h>
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
 #include <net/xfrm.h>
 #endif
@@ -51,19 +50,6 @@
 
 #include <linux/uaccess.h>
 
-/*
- *	Parsing tlv encoded headers.
- *
- *	Parsing function "func" returns true, if parsing succeed
- *	and false, if it failed.
- *	It MUST NOT touch skb->h.
- */
-
-struct tlvtype_proc {
-	int	type;
-	bool	(*func)(struct sk_buff *skb, int offset);
-};
-
 /*********************
   Generic functions
  *********************/
@@ -200,80 +186,6 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 	return false;
 }
 
-/*****************************
-  Destination options header.
- *****************************/
-
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
-{
-	struct ipv6_destopt_hao *hao;
-	struct inet6_skb_parm *opt = IP6CB(skb);
-	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-	int ret;
-
-	if (opt->dsthao) {
-		net_dbg_ratelimited("hao duplicated\n");
-		goto discard;
-	}
-	opt->dsthao = opt->dst1;
-	opt->dst1 = 0;
-
-	hao = (struct ipv6_destopt_hao *)(skb_network_header(skb) + optoff);
-
-	if (hao->length != 16) {
-		net_dbg_ratelimited("hao invalid option length = %d\n",
-				    hao->length);
-		goto discard;
-	}
-
-	if (!(ipv6_addr_type(&hao->addr) & IPV6_ADDR_UNICAST)) {
-		net_dbg_ratelimited("hao is not an unicast addr: %pI6\n",
-				    &hao->addr);
-		goto discard;
-	}
-
-	ret = xfrm6_input_addr(skb, (xfrm_address_t *)&ipv6h->daddr,
-			       (xfrm_address_t *)&hao->addr, IPPROTO_DSTOPTS);
-	if (unlikely(ret < 0))
-		goto discard;
-
-	if (skb_cloned(skb)) {
-		if (pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
-			goto discard;
-
-		/* update all variable using below by copied skbuff */
-		hao = (struct ipv6_destopt_hao *)(skb_network_header(skb) +
-						  optoff);
-		ipv6h = ipv6_hdr(skb);
-	}
-
-	if (skb->ip_summed == CHECKSUM_COMPLETE)
-		skb->ip_summed = CHECKSUM_NONE;
-
-	swap(ipv6h->saddr, hao->addr);
-
-	if (skb->tstamp == 0)
-		__net_timestamp(skb);
-
-	return true;
-
- discard:
-	kfree_skb(skb);
-	return false;
-}
-#endif
-
-static const struct tlvtype_proc tlvprocdestopt_lst[] = {
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-	{
-		.type	= IPV6_TLV_HAO,
-		.func	= ipv6_dest_hao,
-	},
-#endif
-	{-1,			NULL}
-};
-
 static int ipv6_destopt_rcv(struct sk_buff *skb)
 {
 	struct inet6_skb_parm *opt = IP6CB(skb);
@@ -701,122 +613,6 @@ void ipv6_exthdrs_exit(void)
 	inet6_del_protocol(&rthdr_protocol, IPPROTO_ROUTING);
 }
 
-/**********************************
-  Hop-by-hop options.
- **********************************/
-
-/*
- * Note: we cannot rely on skb_dst(skb) before we assign it in ip6_route_input().
- */
-static inline struct inet6_dev *ipv6_skb_idev(struct sk_buff *skb)
-{
-	return skb_dst(skb) ? ip6_dst_idev(skb_dst(skb)) : __in6_dev_get(skb->dev);
-}
-
-static inline struct net *ipv6_skb_net(struct sk_buff *skb)
-{
-	return skb_dst(skb) ? dev_net(skb_dst(skb)->dev) : dev_net(skb->dev);
-}
-
-/* Router Alert as of RFC 2711 */
-
-static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
-{
-	const unsigned char *nh = skb_network_header(skb);
-
-	if (nh[optoff + 1] == 2) {
-		IP6CB(skb)->flags |= IP6SKB_ROUTERALERT;
-		memcpy(&IP6CB(skb)->ra, nh + optoff + 2, sizeof(IP6CB(skb)->ra));
-		return true;
-	}
-	net_dbg_ratelimited("ipv6_hop_ra: wrong RA length %d\n",
-			    nh[optoff + 1]);
-	kfree_skb(skb);
-	return false;
-}
-
-/* Jumbo payload */
-
-static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
-{
-	const unsigned char *nh = skb_network_header(skb);
-	struct inet6_dev *idev = __in6_dev_get_safely(skb->dev);
-	struct net *net = ipv6_skb_net(skb);
-	u32 pkt_len;
-
-	if (nh[optoff + 1] != 4 || (optoff & 3) != 2) {
-		net_dbg_ratelimited("ipv6_hop_jumbo: wrong jumbo opt length/alignment %d\n",
-				    nh[optoff+1]);
-		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
-		goto drop;
-	}
-
-	pkt_len = ntohl(*(__be32 *)(nh + optoff + 2));
-	if (pkt_len <= IPV6_MAXPLEN) {
-		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
-		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff+2);
-		return false;
-	}
-	if (ipv6_hdr(skb)->payload_len) {
-		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
-		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff);
-		return false;
-	}
-
-	if (pkt_len > skb->len - sizeof(struct ipv6hdr)) {
-		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INTRUNCATEDPKTS);
-		goto drop;
-	}
-
-	if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr)))
-		goto drop;
-
-	IP6CB(skb)->flags |= IP6SKB_JUMBOGRAM;
-	return true;
-
-drop:
-	kfree_skb(skb);
-	return false;
-}
-
-/* CALIPSO RFC 5570 */
-
-static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
-{
-	const unsigned char *nh = skb_network_header(skb);
-
-	if (nh[optoff + 1] < 8)
-		goto drop;
-
-	if (nh[optoff + 6] * 4 + 8 > nh[optoff + 1])
-		goto drop;
-
-	if (!calipso_validate(skb, nh + optoff))
-		goto drop;
-
-	return true;
-
-drop:
-	kfree_skb(skb);
-	return false;
-}
-
-static const struct tlvtype_proc tlvprochopopt_lst[] = {
-	{
-		.type	= IPV6_TLV_ROUTERALERT,
-		.func	= ipv6_hop_ra,
-	},
-	{
-		.type	= IPV6_TLV_JUMBO,
-		.func	= ipv6_hop_jumbo,
-	},
-	{
-		.type	= IPV6_TLV_CALIPSO,
-		.func	= ipv6_hop_calipso,
-	},
-	{ -1, }
-};
-
 int ipv6_parse_hopopts(struct sk_buff *skb)
 {
 	struct inet6_skb_parm *opt = IP6CB(skb);
diff --git a/net/ipv6/exthdrs_options.c b/net/ipv6/exthdrs_options.c
new file mode 100644
index 0000000..032e072
--- /dev/null
+++ b/net/ipv6/exthdrs_options.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/errno.h>
+#include <linux/in6.h>
+#include <linux/net.h>
+#include <linux/netdevice.h>
+#include <linux/socket.h>
+#include <linux/types.h>
+#include <net/calipso.h>
+#include <net/ipv6.h>
+#include <net/ip6_route.h>
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+#include <net/xfrm.h>
+#endif
+
+/* Destination options header */
+
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
+{
+	struct ipv6_destopt_hao *hao;
+	struct inet6_skb_parm *opt = IP6CB(skb);
+	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+	int ret;
+
+	if (opt->dsthao) {
+		net_dbg_ratelimited("hao duplicated\n");
+		goto discard;
+	}
+	opt->dsthao = opt->dst1;
+	opt->dst1 = 0;
+
+	hao = (struct ipv6_destopt_hao *)(skb_network_header(skb) + optoff);
+
+	if (hao->length != 16) {
+		net_dbg_ratelimited("hao invalid option length = %d\n",
+				    hao->length);
+		goto discard;
+	}
+
+	if (!(ipv6_addr_type(&hao->addr) & IPV6_ADDR_UNICAST)) {
+		net_dbg_ratelimited("hao is not an unicast addr: %pI6\n",
+				    &hao->addr);
+		goto discard;
+	}
+
+	ret = xfrm6_input_addr(skb, (xfrm_address_t *)&ipv6h->daddr,
+			       (xfrm_address_t *)&hao->addr, IPPROTO_DSTOPTS);
+	if (unlikely(ret < 0))
+		goto discard;
+
+	if (skb_cloned(skb)) {
+		if (pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+			goto discard;
+
+		/* update all variable using below by copied skbuff */
+		hao = (struct ipv6_destopt_hao *)(skb_network_header(skb) +
+						  optoff);
+		ipv6h = ipv6_hdr(skb);
+	}
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		skb->ip_summed = CHECKSUM_NONE;
+
+	swap(ipv6h->saddr, hao->addr);
+
+	if (skb->tstamp == 0)
+		__net_timestamp(skb);
+
+	return true;
+
+ discard:
+	kfree_skb(skb);
+	return false;
+}
+#endif
+
+const struct tlvtype_proc tlvprocdestopt_lst[] = {
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+	{
+		.type	= IPV6_TLV_HAO,
+		.func	= ipv6_dest_hao,
+	},
+#endif
+	{-1,			NULL}
+};
+
+/* Hop-by-hop options */
+
+/* Note: we cannot rely on skb_dst(skb) before we assign it in
+ * ip6_route_input().
+ */
+static inline struct inet6_dev *ipv6_skb_idev(struct sk_buff *skb)
+{
+	return skb_dst(skb) ? ip6_dst_idev(skb_dst(skb)) :
+	    __in6_dev_get(skb->dev);
+}
+
+static inline struct net *ipv6_skb_net(struct sk_buff *skb)
+{
+	return skb_dst(skb) ? dev_net(skb_dst(skb)->dev) : dev_net(skb->dev);
+}
+
+/* Router Alert as of RFC 2711 */
+
+static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
+{
+	const unsigned char *nh = skb_network_header(skb);
+
+	if (nh[optoff + 1] == 2) {
+		IP6CB(skb)->flags |= IP6SKB_ROUTERALERT;
+		memcpy(&IP6CB(skb)->ra, nh + optoff + 2,
+		       sizeof(IP6CB(skb)->ra));
+		return true;
+	}
+	net_dbg_ratelimited("%s: wrong RA length %d\n",
+			    __func__, nh[optoff + 1]);
+	kfree_skb(skb);
+	return false;
+}
+
+/* Jumbo payload */
+
+static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
+{
+	const unsigned char *nh = skb_network_header(skb);
+	struct inet6_dev *idev = __in6_dev_get_safely(skb->dev);
+	struct net *net = ipv6_skb_net(skb);
+	u32 pkt_len;
+
+	if (nh[optoff + 1] != 4 || (optoff & 3) != 2) {
+		net_dbg_ratelimited("%s: wrong jumbo opt length/alignment %d\n",
+				    __func__, nh[optoff + 1]);
+		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
+		goto drop;
+	}
+
+	pkt_len = ntohl(*(__be32 *)(nh + optoff + 2));
+	if (pkt_len <= IPV6_MAXPLEN) {
+		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
+		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff + 2);
+		return false;
+	}
+	if (ipv6_hdr(skb)->payload_len) {
+		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
+		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff);
+		return false;
+	}
+
+	if (pkt_len > skb->len - sizeof(struct ipv6hdr)) {
+		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INTRUNCATEDPKTS);
+		goto drop;
+	}
+
+	if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr)))
+		goto drop;
+
+	IP6CB(skb)->flags |= IP6SKB_JUMBOGRAM;
+	return true;
+
+drop:
+	kfree_skb(skb);
+	return false;
+}
+
+/* CALIPSO RFC 5570 */
+
+static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
+{
+	const unsigned char *nh = skb_network_header(skb);
+
+	if (nh[optoff + 1] < 8)
+		goto drop;
+
+	if (nh[optoff + 6] * 4 + 8 > nh[optoff + 1])
+		goto drop;
+
+	if (!calipso_validate(skb, nh + optoff))
+		goto drop;
+
+	return true;
+
+drop:
+	kfree_skb(skb);
+	return false;
+}
+
+const struct tlvtype_proc tlvprochopopt_lst[] = {
+	{
+		.type	= IPV6_TLV_ROUTERALERT,
+		.func	= ipv6_hop_ra,
+	},
+	{
+		.type	= IPV6_TLV_JUMBO,
+		.func	= ipv6_hop_jumbo,
+	},
+	{
+		.type	= IPV6_TLV_CALIPSO,
+		.func	= ipv6_hop_calipso,
+	},
+	{ -1, }
+};
-- 
2.7.4

