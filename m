Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F22C4401CC
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 20:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhJ2SWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 14:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhJ2SWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 14:22:46 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAF5C061570;
        Fri, 29 Oct 2021 11:20:17 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d5so2409159wrc.1;
        Fri, 29 Oct 2021 11:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JrKE40jJOcWo0fIdLsvXpuS6N1Sj0pGnPElzdqlDGZ8=;
        b=kAv06qM53dCLnAXqIPfDocbqpwYm9tezeOpnU63hqurwBJ0hfh2M7wlsQ5AKTiXaDB
         PV8J96653SL0bh3jPxVNibcFKPYT3UIj+OtvRGtkKt6EZqB/fY7ZZeAX3lyfGOaaOV34
         Ird9Hlm0RXdmFDuCsZjDFFsoWXK7mQBaSSQILppLdGIS41/11Uioy/vttOdQsbNeLq6N
         QUosKdLq7+WDM9jT4TAuevqd2Pxeuu7jaxG4KXCQiylY4z7EqpnF8DLWB6qYfc53EwIg
         5xjow0kw1zJciD5j0HDjySU++HuggaN/6CjWg3Ko7VhEhFYn1Pg3I7LEC5VO7smoujwA
         +87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JrKE40jJOcWo0fIdLsvXpuS6N1Sj0pGnPElzdqlDGZ8=;
        b=salkeMIq37uHQyiTzvOItkvZk5YDhyT2Envw39SUIGPJpRLAA59AROzPGeBhusLVTy
         mMpTVvAGCQDTljD+9QqCUpn5u4UCSj9V68sfUUD07tLrH8gQwAqR4JYs4ktWdiR07TUq
         1hOuKOMA87rogNqjTRm00e+q8bqTP7Hp1tWJhMaJ8BKFfrJMS5vefqaiqw3mO0dyVzMa
         aaxFkgQvc9GpfHvEWDsffZX1zyorgpwarSIfp3ngikdMTvwQTa467wQ1tblDLlb17y5X
         Cf/j9dLvauiFjzwmZJJFyLrI95SReyw3DUxX60TIZB8mqT0DC9oabFT/cmpujzIOiO5f
         PQOg==
X-Gm-Message-State: AOAM532AGXJiLIHtXk0PjT+SPV5A+zGgHBY2GO9P5XoZJx4fCwRtNHwv
        G6gHRBiQGtCUt73eX1X6O8pf/y1/SU0=
X-Google-Smtp-Source: ABdhPJzjA4O9azwWSgErX8c213Bc+/YdNbNrtUf3rIylrqQggX0H19u9Q0jVoYkjiEwHP23EdTd2MQ==
X-Received: by 2002:a05:600c:1548:: with SMTP id f8mr13213216wmg.35.1635531616375;
        Fri, 29 Oct 2021 11:20:16 -0700 (PDT)
Received: from ubuntu.localdomain ([85.254.74.216])
        by smtp.googlemail.com with ESMTPSA id d8sm2887076wrm.76.2021.10.29.11.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 11:20:15 -0700 (PDT)
From:   Toms Atteka <cpp.code.lv@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        kuba@kernel.org, dev@openvswitch.org, linux-kernel@vger.kernel.org
Cc:     Toms Atteka <cpp.code.lv@gmail.com>
Subject: [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6 extension header support
Date:   Fri, 29 Oct 2021 11:20:08 -0700
Message-Id: <20211029182008.382113-1-cpp.code.lv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
packets can be filtered using ipv6_ext flag.

Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
---
 include/uapi/linux/openvswitch.h |   6 ++
 net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
 net/openvswitch/flow.h           |  14 ++++
 net/openvswitch/flow_netlink.c   |  26 +++++-
 4 files changed, 184 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index a87b44cd5590..43790f07e4a2 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -342,6 +342,7 @@ enum ovs_key_attr {
 	OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
 	OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
 	OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
+	OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
 
 #ifdef __KERNEL__
 	OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
@@ -421,6 +422,11 @@ struct ovs_key_ipv6 {
 	__u8   ipv6_frag;	/* One of OVS_FRAG_TYPE_*. */
 };
 
+/* separate structure to support backward compatibility with older user space */
+struct ovs_key_ipv6_exthdrs {
+	__u16  hdrs;
+};
+
 struct ovs_key_tcp {
 	__be16 tcp_src;
 	__be16 tcp_dst;
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 9d375e74b607..28acb40437ca 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -239,6 +239,144 @@ static bool icmphdr_ok(struct sk_buff *skb)
 				  sizeof(struct icmphdr));
 }
 
+/**
+ * get_ipv6_ext_hdrs() - Parses packet and sets IPv6 extension header flags.
+ *
+ * @skb: buffer where extension header data starts in packet
+ * @nh: ipv6 header
+ * @ext_hdrs: flags are stored here
+ *
+ * OFPIEH12_UNREP is set if more than one of a given IPv6 extension header
+ * is unexpectedly encountered. (Two destination options headers may be
+ * expected and would not cause this bit to be set.)
+ *
+ * OFPIEH12_UNSEQ is set if IPv6 extension headers were not in the order
+ * preferred (but not required) by RFC 2460:
+ *
+ * When more than one extension header is used in the same packet, it is
+ * recommended that those headers appear in the following order:
+ *      IPv6 header
+ *      Hop-by-Hop Options header
+ *      Destination Options header
+ *      Routing header
+ *      Fragment header
+ *      Authentication header
+ *      Encapsulating Security Payload header
+ *      Destination Options header
+ *      upper-layer header
+ */
+static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
+			      u16 *ext_hdrs)
+{
+	u8 next_type = nh->nexthdr;
+	unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
+	int dest_options_header_count = 0;
+
+	*ext_hdrs = 0;
+
+	while (ipv6_ext_hdr(next_type)) {
+		struct ipv6_opt_hdr _hdr, *hp;
+
+		switch (next_type) {
+		case IPPROTO_NONE:
+			*ext_hdrs |= OFPIEH12_NONEXT;
+			/* stop parsing */
+			return;
+
+		case IPPROTO_ESP:
+			if (*ext_hdrs & OFPIEH12_ESP)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs & ~(OFPIEH12_HOP | OFPIEH12_DEST |
+					   OFPIEH12_ROUTER | IPPROTO_FRAGMENT |
+					   OFPIEH12_AUTH | OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2) {
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			}
+			*ext_hdrs |= OFPIEH12_ESP;
+			break;
+
+		case IPPROTO_AH:
+			if (*ext_hdrs & OFPIEH12_AUTH)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs &
+			     ~(OFPIEH12_HOP | OFPIEH12_DEST | OFPIEH12_ROUTER |
+			       IPPROTO_FRAGMENT | OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2) {
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			}
+			*ext_hdrs |= OFPIEH12_AUTH;
+			break;
+
+		case IPPROTO_DSTOPTS:
+			if (dest_options_header_count == 0) {
+				if (*ext_hdrs &
+				    ~(OFPIEH12_HOP | OFPIEH12_UNREP))
+					*ext_hdrs |= OFPIEH12_UNSEQ;
+				*ext_hdrs |= OFPIEH12_DEST;
+			} else if (dest_options_header_count == 1) {
+				if (*ext_hdrs &
+				    ~(OFPIEH12_HOP | OFPIEH12_DEST |
+				      OFPIEH12_ROUTER | OFPIEH12_FRAG |
+				      OFPIEH12_AUTH | OFPIEH12_ESP |
+				      OFPIEH12_UNREP)) {
+					*ext_hdrs |= OFPIEH12_UNSEQ;
+				}
+			} else {
+				*ext_hdrs |= OFPIEH12_UNREP;
+			}
+			dest_options_header_count++;
+			break;
+
+		case IPPROTO_FRAGMENT:
+			if (*ext_hdrs & OFPIEH12_FRAG)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs & ~(OFPIEH12_HOP |
+					   OFPIEH12_DEST |
+					   OFPIEH12_ROUTER |
+					   OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2) {
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			}
+			*ext_hdrs |= OFPIEH12_FRAG;
+			break;
+
+		case IPPROTO_ROUTING:
+			if (*ext_hdrs & OFPIEH12_ROUTER)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			if ((*ext_hdrs & ~(OFPIEH12_HOP |
+					   OFPIEH12_DEST |
+					   OFPIEH12_UNREP)) ||
+			    dest_options_header_count >= 2) {
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			}
+			*ext_hdrs |= OFPIEH12_ROUTER;
+			break;
+
+		case IPPROTO_HOPOPTS:
+			if (*ext_hdrs & OFPIEH12_HOP)
+				*ext_hdrs |= OFPIEH12_UNREP;
+			/* OFPIEH12_HOP is set to 1 if a hop-by-hop IPv6
+			 * extension header is present as the first
+			 * extension header in the packet.
+			 */
+			if (*ext_hdrs == 0)
+				*ext_hdrs |= OFPIEH12_HOP;
+			else
+				*ext_hdrs |= OFPIEH12_UNSEQ;
+			break;
+
+		default:
+			return;
+		}
+
+		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
+		if (!hp)
+			break;
+		next_type = hp->nexthdr;
+		start += ipv6_optlen(hp);
+	};
+}
+
 static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
 {
 	unsigned short frag_off;
@@ -254,6 +392,8 @@ static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
 
 	nh = ipv6_hdr(skb);
 
+	get_ipv6_ext_hdrs(skb, nh, &key->ipv6.exthdrs);
+
 	key->ip.proto = NEXTHDR_NONE;
 	key->ip.tos = ipv6_get_dsfield(nh);
 	key->ip.ttl = nh->hop_limit;
diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index 758a8c77f736..073ab73ffeaa 100644
--- a/net/openvswitch/flow.h
+++ b/net/openvswitch/flow.h
@@ -32,6 +32,19 @@ enum sw_flow_mac_proto {
 #define SW_FLOW_KEY_INVALID	0x80
 #define MPLS_LABEL_DEPTH       3
 
+/* Bit definitions for IPv6 Extension Header pseudo-field. */
+enum ofp12_ipv6exthdr_flags {
+	OFPIEH12_NONEXT = 1 << 0,   /* "No next header" encountered. */
+	OFPIEH12_ESP    = 1 << 1,   /* Encrypted Sec Payload header present. */
+	OFPIEH12_AUTH   = 1 << 2,   /* Authentication header present. */
+	OFPIEH12_DEST   = 1 << 3,   /* 1 or 2 dest headers present. */
+	OFPIEH12_FRAG   = 1 << 4,   /* Fragment header present. */
+	OFPIEH12_ROUTER = 1 << 5,   /* Router header present. */
+	OFPIEH12_HOP    = 1 << 6,   /* Hop-by-hop header present. */
+	OFPIEH12_UNREP  = 1 << 7,   /* Unexpected repeats encountered. */
+	OFPIEH12_UNSEQ  = 1 << 8    /* Unexpected sequencing encountered. */
+};
+
 /* Store options at the end of the array if they are less than the
  * maximum size. This allows us to get the benefits of variable length
  * matching for small options.
@@ -121,6 +134,7 @@ struct sw_flow_key {
 				struct in6_addr dst;	/* IPv6 destination address. */
 			} addr;
 			__be32 label;			/* IPv6 flow label. */
+			u16 exthdrs;	/* IPv6 extension header flags */
 			union {
 				struct {
 					struct in6_addr src;
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 65c2e3458ff5..0aeaf28594ce 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -344,7 +344,7 @@ size_t ovs_key_attr_size(void)
 	/* Whenever adding new OVS_KEY_ FIELDS, we should consider
 	 * updating this function.
 	 */
-	BUILD_BUG_ON(OVS_KEY_ATTR_TUNNEL_INFO != 29);
+	BUILD_BUG_ON(OVS_KEY_ATTR_TUNNEL_INFO != 30);
 
 	return    nla_total_size(4)   /* OVS_KEY_ATTR_PRIORITY */
 		+ nla_total_size(0)   /* OVS_KEY_ATTR_TUNNEL */
@@ -367,7 +367,8 @@ size_t ovs_key_attr_size(void)
 		+ nla_total_size(2)   /* OVS_KEY_ATTR_ETHERTYPE */
 		+ nla_total_size(40)  /* OVS_KEY_ATTR_IPV6 */
 		+ nla_total_size(2)   /* OVS_KEY_ATTR_ICMPV6 */
-		+ nla_total_size(28); /* OVS_KEY_ATTR_ND */
+		+ nla_total_size(28)  /* OVS_KEY_ATTR_ND */
+		+ nla_total_size(2);  /* OVS_KEY_ATTR_IPV6_EXTHDRS */
 }
 
 static const struct ovs_len_tbl ovs_vxlan_ext_key_lens[OVS_VXLAN_EXT_MAX + 1] = {
@@ -435,6 +436,8 @@ static const struct ovs_len_tbl ovs_key_lens[OVS_KEY_ATTR_MAX + 1] = {
 		.len = sizeof(struct ovs_key_ct_tuple_ipv6) },
 	[OVS_KEY_ATTR_NSH]       = { .len = OVS_ATTR_NESTED,
 				     .next = ovs_nsh_key_attr_lens, },
+	[OVS_KEY_ATTR_IPV6_EXTHDRS] = {
+		.len = sizeof(struct ovs_key_ipv6_exthdrs) },
 };
 
 static bool check_attr_len(unsigned int attr_len, unsigned int expected_len)
@@ -1595,6 +1598,17 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
 		attrs &= ~(1 << OVS_KEY_ATTR_IPV6);
 	}
 
+	if (attrs & (1ULL << OVS_KEY_ATTR_IPV6_EXTHDRS)) {
+		const struct ovs_key_ipv6_exthdrs *ipv6_exthdrs_key;
+
+		ipv6_exthdrs_key = nla_data(a[OVS_KEY_ATTR_IPV6_EXTHDRS]);
+
+		SW_FLOW_KEY_PUT(match, ipv6.exthdrs,
+				ipv6_exthdrs_key->hdrs, is_mask);
+
+		attrs &= ~(1ULL << OVS_KEY_ATTR_IPV6_EXTHDRS);
+	}
+
 	if (attrs & (1 << OVS_KEY_ATTR_ARP)) {
 		const struct ovs_key_arp *arp_key;
 
@@ -2097,6 +2111,7 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 		ipv4_key->ipv4_frag = output->ip.frag;
 	} else if (swkey->eth.type == htons(ETH_P_IPV6)) {
 		struct ovs_key_ipv6 *ipv6_key;
+		struct ovs_key_ipv6_exthdrs *ipv6_exthdrs_key;
 
 		nla = nla_reserve(skb, OVS_KEY_ATTR_IPV6, sizeof(*ipv6_key));
 		if (!nla)
@@ -2111,6 +2126,13 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 		ipv6_key->ipv6_tclass = output->ip.tos;
 		ipv6_key->ipv6_hlimit = output->ip.ttl;
 		ipv6_key->ipv6_frag = output->ip.frag;
+
+		nla = nla_reserve(skb, OVS_KEY_ATTR_IPV6_EXTHDRS,
+				  sizeof(*ipv6_exthdrs_key));
+		if (!nla)
+			goto nla_put_failure;
+		ipv6_exthdrs_key = nla_data(nla);
+		ipv6_exthdrs_key->hdrs = output->ipv6.exthdrs;
 	} else if (swkey->eth.type == htons(ETH_P_NSH)) {
 		if (nsh_key_to_nlattr(&output->nsh, is_mask, skb))
 			goto nla_put_failure;
-- 
2.25.1

