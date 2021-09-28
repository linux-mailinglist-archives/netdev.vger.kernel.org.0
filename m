Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C960A41B7C3
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 21:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242554AbhI1TtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 15:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242390AbhI1TtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 15:49:12 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3129C06161C;
        Tue, 28 Sep 2021 12:47:32 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t8so324346wrq.4;
        Tue, 28 Sep 2021 12:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oxiy87b4L8fQW8Ca0r+F4zyg3mSFIr3gP51fafo4PN0=;
        b=CRiKqQNssMw1bH3XlR5L/9jjmaIp+QGm5REV/RCp8ja/n4EWniRo01x5XSnp3TnW+j
         YQ316ye3ShxBYqRRPDPu9Bzz52d/7PzYjSem0xysK+W3qBkMp86+NSK2neVJAE/8oWQl
         YbGNjuLma+jee/LF1jjmdMWH3FMsbqacBcDVHd0IxTqW/51RdN5nfKOhyKXUa9vCf6U4
         XWpz8fmlQKvbNANywhz56eu4W/vfO4JUoQFO/uYGV95sRU0anFrvt9KiBEx64fMhKII+
         41dG4ywNGeKNfrV9irE/6BAykV9Qwz3tvQRgvoqwEfvmW6mSE5wwCHTjMr96sWq0B0js
         lZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oxiy87b4L8fQW8Ca0r+F4zyg3mSFIr3gP51fafo4PN0=;
        b=np4WAKFO31ZyGlH+LF1/2Z9CXgZHUMnfvkPSdnK6/T+poysdHw0rvIu0+3IWjvuu32
         700s5icnhFDG+3W3j/MqQeJLWi1/GzpizJ0A6X79RHxj3s6tfTiGmaHezG89w9UWNetZ
         lZiPk5fYDW7P/P2BiMT/MdGNZjBu0mPuMQtS7trQBBzLIjQbh32uwMP9EavWbK7Ek+c7
         iBCPcknXIJcsJ47uO/DaQvLg7xM/6uU/uYuKm8afg0cdEltCzu0TyP9SUNQxBiiTFfEV
         eNlPYgC6N8J7FrN2mVly9DwCVu5pJwNKhf/jcSsjK/hhNB1a23DVzqxTuvkNteqxtfzk
         IHFA==
X-Gm-Message-State: AOAM532ELkfBP5ZsI7LDTOauSP6cbhbRdXbCXcl4yh+ixdllz1797++p
        UN0irGw6s07QBORXKxHga8st3+ul28pWKQ==
X-Google-Smtp-Source: ABdhPJwSyxg8GqN0Xl2e9lbPYRAwRuMJuKIZAkGnAdbu4ioEBYImPb9VwNwG7OGiDrJJUlFMujwl8w==
X-Received: by 2002:adf:e101:: with SMTP id t1mr2187974wrz.395.1632858451405;
        Tue, 28 Sep 2021 12:47:31 -0700 (PDT)
Received: from ubuntu.localdomain ([85.254.74.220])
        by smtp.googlemail.com with ESMTPSA id n14sm3513449wmc.38.2021.09.28.12.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 12:47:31 -0700 (PDT)
From:   Toms Atteka <cpp.code.lv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Toms Atteka <cpp.code.lv@gmail.com>
Subject: [PATCH net-next v6] net: openvswitch: IPv6: Add IPv6 extension header support
Date:   Tue, 28 Sep 2021 12:47:27 -0700
Message-Id: <20210928194727.1635106-1-cpp.code.lv@gmail.com>
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
 include/uapi/linux/openvswitch.h |  12 +++
 net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
 net/openvswitch/flow.h           |  14 ++++
 net/openvswitch/flow_netlink.c   |  24 +++++-
 4 files changed, 189 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index a87b44cd5590..dc6eb5f6399f 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -346,6 +346,13 @@ enum ovs_key_attr {
 #ifdef __KERNEL__
 	OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
 #endif
+
+#ifndef __KERNEL__
+	PADDING,  /* Padding so kernel and non kernel field count would match */
+#endif
+
+	OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
+
 	__OVS_KEY_ATTR_MAX
 };
 
@@ -421,6 +428,11 @@ struct ovs_key_ipv6 {
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
index 65c2e3458ff5..2fbf324fcfff 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
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

