Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44EC60FAAA
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbiJ0Onb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235580AbiJ0On0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:43:26 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B338918A509;
        Thu, 27 Oct 2022 07:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666881805; x=1698417805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EogV7kDffebmknKxkiQqvD0/UpxCaCmuGmNOortyWOc=;
  b=Ss2HdKNyvWmKSBmQVqgtvsSYh4qyoSgApbg5u0MGLmQtj8dVfOe1h+x8
   8YxCNIEqCC5L4EiwLoeMfJZSeZTqIHGmnajT3jwwVNkDsYuK7q0lD0LHW
   xWOKduzrqgO9kRTp3/icS1Qp+XvKiifVvrVhECGkb4ZsgRQfukLBaOkA9
   g5E9TAQhH3Ga8ZxJkOY8PJnmOuZlCyBhYE8r53vEJqqt3stbmIhhCm8EK
   p6IWWbHzhYHvwzJTZm3WeenFrzilFbCuL/Tpr4U8whaNdSeFaKXYE633Y
   JTctY9kXUThPf1sYzK7rGfk0in7gKpEvpkxAXMyGg0AfRaE4pU3RXcTUV
   g==;
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="186548704"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2022 07:43:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 27 Oct 2022 07:43:23 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 27 Oct 2022 07:43:20 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next 2/5] net: microchip: sparx5: Adding more tc flower keys for the IS2 VCAP
Date:   Thu, 27 Oct 2022 16:42:57 +0200
Message-ID: <20221027144300.2936955-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027144300.2936955-1-steen.hegelund@microchip.com>
References: <20221027144300.2936955-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the following TC flower filter keys to Sparx5 for IS2:

- ipv4_addr (sip and dip)
- ipv6_addr (sip and dip)
- control (IPv4 fragments)
- portnum (tcp and udp port numbers)
- basic (L3 and L4 protocol)
- vlan (outer vlan tag info)
- tcp (tcp flags)
- ip (tos field)

as well as an 128 bit keyfield interface on the VCAP API to set the IPv6
addresses.

IS2 supports the classified VLAN information which amounts to the outer
VLAN info in case of multiple tags.

Here are some examples of the tc flower filter operations that are now
supported for the IS2 VCAP:

- IPv4 Addresses
    tc filter add dev eth12 ingress chain 8000000 prio 12 handle 12 \
        protocol ip flower skip_sw dst_ip 1.0.1.1 src_ip 2.0.2.2    \
        action trap

- IPv6 Addresses
    tc filter add dev eth12 ingress chain 8000000 prio 13 handle 13 \
        protocol ipv6 flower skip_sw dst_ip 1::1:1 src_ip 2::2:2    \
        action trap

- IPv4 fragments
    tc filter add dev eth12 ingress chain 8000000 prio 14 handle 14 \
        protocol ip flower skip_sw dst_ip 3.0.3.3 src_ip 2.0.2.2    \
        ip_flags frag/nofirstfrag action trap

- TCP and UDP portnumbers
    tc filter add dev eth12 ingress chain 8000000 prio 21 handle 21 \
        protocol ip flower skip_sw dst_ip 8.8.8.8 src_ip 2.0.2.2    \
        ip_proto tcp dst_port 100 src_port 12000 action trap
    tc filter add dev eth12 ingress chain 8000000 prio 23 handle 23 \
        protocol ipv6 flower skip_sw dst_ip 5::5:5 src_ip 2::2:2    \
        ip_proto tcp dst_port 300 src_port 13000 action trap

- Layer 3 and Layer 4 protocol info
    tc filter add dev eth12 ingress chain 8000000 prio 28 handle 28 \
        protocol ipv4 flower skip_sw dst_ip 9.0.9.9 src_ip 2.0.2.2  \
        ip_proto icmp action trap

- VLAN tag info (outer tag)
    tc filter add dev eth12 ingress chain 8000000 prio 29 handle 29 \
        protocol 802.1q flower skip_sw vlan_id 600 vlan_prio 6      \
        vlan_ethtype ipv4 action trap
    tc filter add dev eth12 ingress chain 8000000 prio 31 handle 31 \
        protocol 802.1q flower skip_sw vlan_id 600 vlan_prio 5      \
        vlan_ethtype ipv6 action trap

- TCP flags
    tc filter add dev eth12 ingress chain 8000000 prio 15 handle 15 \
        protocol ip flower skip_sw dst_ip 4.0.4.4 src_ip 2.0.2.2    \
        ip_proto tcp tcp_flags 0x2a/0x3f action trap

- IP info (IPv4 TOS field)
    tc filter add dev eth12 ingress chain 8000000 prio 16 handle 16 \
        protocol ip flower skip_sw ip_tos 0x35 dst_ip 5.0.5.5       \
        src_ip 2.0.2.2 action trap

The "protocol all" selection is not supported yet.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 384 +++++++++++++++++-
 .../net/ethernet/microchip/vcap/vcap_api.c    |  11 +
 .../ethernet/microchip/vcap/vcap_api_client.h |   2 +
 3 files changed, 396 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 626558a5c850..13bc6bff4c1e 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -16,9 +16,32 @@ struct sparx5_tc_flower_parse_usage {
 	struct flow_cls_offload *fco;
 	struct flow_rule *frule;
 	struct vcap_rule *vrule;
+	u16 l3_proto;
+	u8 l4_proto;
 	unsigned int used_keys;
 };
 
+/* These protocols have dedicated keysets in IS2 and a TC dissector
+ * ETH_P_ARP does not have a TC dissector
+ */
+static u16 sparx5_tc_known_etypes[] = {
+	ETH_P_ALL,
+	ETH_P_IP,
+	ETH_P_IPV6,
+};
+
+static bool sparx5_tc_is_known_etype(u16 etype)
+{
+	int idx;
+
+	/* For now this only knows about IS2 traffic classification */
+	for (idx = 0; idx < ARRAY_SIZE(sparx5_tc_known_etypes); ++idx)
+		if (sparx5_tc_known_etypes[idx] == etype)
+			return true;
+
+	return false;
+}
+
 static int sparx5_tc_flower_handler_ethaddr_usage(struct sparx5_tc_flower_parse_usage *st)
 {
 	enum vcap_key_field smac_key = VCAP_KF_L2_SMAC;
@@ -54,9 +77,368 @@ static int sparx5_tc_flower_handler_ethaddr_usage(struct sparx5_tc_flower_parse_
 	return err;
 }
 
+static int
+sparx5_tc_flower_handler_ipv4_usage(struct sparx5_tc_flower_parse_usage *st)
+{
+	int err = 0;
+
+	if (st->l3_proto == ETH_P_IP) {
+		struct flow_match_ipv4_addrs mt;
+
+		flow_rule_match_ipv4_addrs(st->frule, &mt);
+		if (mt.mask->src) {
+			err = vcap_rule_add_key_u32(st->vrule,
+						    VCAP_KF_L3_IP4_SIP,
+						    be32_to_cpu(mt.key->src),
+						    be32_to_cpu(mt.mask->src));
+			if (err)
+				goto out;
+		}
+		if (mt.mask->dst) {
+			err = vcap_rule_add_key_u32(st->vrule,
+						    VCAP_KF_L3_IP4_DIP,
+						    be32_to_cpu(mt.key->dst),
+						    be32_to_cpu(mt.mask->dst));
+			if (err)
+				goto out;
+		}
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ipv4_addr parse error");
+	return err;
+}
+
+static int
+sparx5_tc_flower_handler_ipv6_usage(struct sparx5_tc_flower_parse_usage *st)
+{
+	int err = 0;
+
+	if (st->l3_proto == ETH_P_IPV6) {
+		struct flow_match_ipv6_addrs mt;
+		struct vcap_u128_key sip;
+		struct vcap_u128_key dip;
+
+		flow_rule_match_ipv6_addrs(st->frule, &mt);
+		/* Check if address masks are non-zero */
+		if (!ipv6_addr_any(&mt.mask->src)) {
+			vcap_netbytes_copy(sip.value, mt.key->src.s6_addr, 16);
+			vcap_netbytes_copy(sip.mask, mt.mask->src.s6_addr, 16);
+			err = vcap_rule_add_key_u128(st->vrule,
+						     VCAP_KF_L3_IP6_SIP, &sip);
+			if (err)
+				goto out;
+		}
+		if (!ipv6_addr_any(&mt.mask->dst)) {
+			vcap_netbytes_copy(dip.value, mt.key->dst.s6_addr, 16);
+			vcap_netbytes_copy(dip.mask, mt.mask->dst.s6_addr, 16);
+			err = vcap_rule_add_key_u128(st->vrule,
+						     VCAP_KF_L3_IP6_DIP, &dip);
+			if (err)
+				goto out;
+		}
+	}
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS);
+	return err;
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ipv6_addr parse error");
+	return err;
+}
+
+static int
+sparx5_tc_flower_handler_control_usage(struct sparx5_tc_flower_parse_usage *st)
+{
+	struct flow_match_control mt;
+	u32 value, mask;
+	int err = 0;
+
+	flow_rule_match_control(st->frule, &mt);
+
+	if (mt.mask->flags) {
+		if (mt.mask->flags & FLOW_DIS_FIRST_FRAG) {
+			if (mt.key->flags & FLOW_DIS_FIRST_FRAG) {
+				value = 1; /* initial fragment */
+				mask = 0x3;
+			} else {
+				if (mt.mask->flags & FLOW_DIS_IS_FRAGMENT) {
+					value = 3; /* follow up fragment */
+					mask = 0x3;
+				} else {
+					value = 0; /* no fragment */
+					mask = 0x3;
+				}
+			}
+		} else {
+			if (mt.mask->flags & FLOW_DIS_IS_FRAGMENT) {
+				value = 3; /* follow up fragment */
+				mask = 0x3;
+			} else {
+				value = 0; /* no fragment */
+				mask = 0x3;
+			}
+		}
+
+		err = vcap_rule_add_key_u32(st->vrule,
+					    VCAP_KF_L3_FRAGMENT_TYPE,
+					    value, mask);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ip_frag parse error");
+	return err;
+}
+
+static int
+sparx5_tc_flower_handler_portnum_usage(struct sparx5_tc_flower_parse_usage *st)
+{
+	struct flow_match_ports mt;
+	u16 value, mask;
+	int err = 0;
+
+	flow_rule_match_ports(st->frule, &mt);
+
+	if (mt.mask->src) {
+		value = be16_to_cpu(mt.key->src);
+		mask = be16_to_cpu(mt.mask->src);
+		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L4_SPORT, value,
+					    mask);
+		if (err)
+			goto out;
+	}
+
+	if (mt.mask->dst) {
+		value = be16_to_cpu(mt.key->dst);
+		mask = be16_to_cpu(mt.mask->dst);
+		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L4_DPORT, value,
+					    mask);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_PORTS);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "port parse error");
+	return err;
+}
+
+static int
+sparx5_tc_flower_handler_basic_usage(struct sparx5_tc_flower_parse_usage *st)
+{
+	struct flow_match_basic mt;
+	int err = 0;
+
+	flow_rule_match_basic(st->frule, &mt);
+
+	if (mt.mask->n_proto) {
+		st->l3_proto = be16_to_cpu(mt.key->n_proto);
+		if (!sparx5_tc_is_known_etype(st->l3_proto)) {
+			err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_ETYPE,
+						    st->l3_proto, ~0);
+			if (err)
+				goto out;
+		} else if (st->l3_proto == ETH_P_IP) {
+			err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_IP4_IS,
+						    VCAP_BIT_1);
+			if (err)
+				goto out;
+		} else if (st->l3_proto == ETH_P_IPV6) {
+			err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_IP4_IS,
+						    VCAP_BIT_0);
+			if (err)
+				goto out;
+		}
+	}
+
+	if (mt.mask->ip_proto) {
+		st->l4_proto = mt.key->ip_proto;
+		if (st->l4_proto == IPPROTO_TCP) {
+			err = vcap_rule_add_key_bit(st->vrule,
+						    VCAP_KF_TCP_IS,
+						    VCAP_BIT_1);
+			if (err)
+				goto out;
+		} else if (st->l4_proto == IPPROTO_UDP) {
+			err = vcap_rule_add_key_bit(st->vrule,
+						    VCAP_KF_TCP_IS,
+						    VCAP_BIT_0);
+			if (err)
+				goto out;
+		} else {
+			err = vcap_rule_add_key_u32(st->vrule,
+						    VCAP_KF_L3_IP_PROTO,
+						    st->l4_proto, ~0);
+			if (err)
+				goto out;
+		}
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_BASIC);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ip_proto parse error");
+	return err;
+}
+
+static int
+sparx5_tc_flower_handler_vlan_usage(struct sparx5_tc_flower_parse_usage *st)
+{
+	enum vcap_key_field vid_key = VCAP_KF_8021Q_VID_CLS;
+	enum vcap_key_field pcp_key = VCAP_KF_8021Q_PCP_CLS;
+	struct flow_match_vlan mt;
+	int err;
+
+	flow_rule_match_vlan(st->frule, &mt);
+
+	if (mt.mask->vlan_id) {
+		err = vcap_rule_add_key_u32(st->vrule, vid_key,
+					    mt.key->vlan_id,
+					    mt.mask->vlan_id);
+		if (err)
+			goto out;
+	}
+
+	if (mt.mask->vlan_priority) {
+		err = vcap_rule_add_key_u32(st->vrule, pcp_key,
+					    mt.key->vlan_priority,
+					    mt.mask->vlan_priority);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_VLAN);
+
+	return err;
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "vlan parse error");
+	return err;
+}
+
+static int
+sparx5_tc_flower_handler_tcp_usage(struct sparx5_tc_flower_parse_usage *st)
+{
+	struct flow_match_tcp mt;
+	u16 tcp_flags_mask;
+	u16 tcp_flags_key;
+	enum vcap_bit val;
+	int err = 0;
+
+	flow_rule_match_tcp(st->frule, &mt);
+	tcp_flags_key = be16_to_cpu(mt.key->flags);
+	tcp_flags_mask = be16_to_cpu(mt.mask->flags);
+
+	if (tcp_flags_mask & TCPHDR_FIN) {
+		val = VCAP_BIT_0;
+		if (tcp_flags_key & TCPHDR_FIN)
+			val = VCAP_BIT_1;
+		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_FIN, val);
+		if (err)
+			goto out;
+	}
+
+	if (tcp_flags_mask & TCPHDR_SYN) {
+		val = VCAP_BIT_0;
+		if (tcp_flags_key & TCPHDR_SYN)
+			val = VCAP_BIT_1;
+		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_SYN, val);
+		if (err)
+			goto out;
+	}
+
+	if (tcp_flags_mask & TCPHDR_RST) {
+		val = VCAP_BIT_0;
+		if (tcp_flags_key & TCPHDR_RST)
+			val = VCAP_BIT_1;
+		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_RST, val);
+		if (err)
+			goto out;
+	}
+
+	if (tcp_flags_mask & TCPHDR_PSH) {
+		val = VCAP_BIT_0;
+		if (tcp_flags_key & TCPHDR_PSH)
+			val = VCAP_BIT_1;
+		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_PSH, val);
+		if (err)
+			goto out;
+	}
+
+	if (tcp_flags_mask & TCPHDR_ACK) {
+		val = VCAP_BIT_0;
+		if (tcp_flags_key & TCPHDR_ACK)
+			val = VCAP_BIT_1;
+		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_ACK, val);
+		if (err)
+			goto out;
+	}
+
+	if (tcp_flags_mask & TCPHDR_URG) {
+		val = VCAP_BIT_0;
+		if (tcp_flags_key & TCPHDR_URG)
+			val = VCAP_BIT_1;
+		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_URG, val);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "tcp_flags parse error");
+	return err;
+}
+
+static int
+sparx5_tc_flower_handler_ip_usage(struct sparx5_tc_flower_parse_usage *st)
+{
+	struct flow_match_ip mt;
+	int err = 0;
+
+	flow_rule_match_ip(st->frule, &mt);
+
+	if (mt.mask->tos) {
+		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L3_TOS,
+					    mt.key->tos,
+					    mt.mask->tos);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_IP);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ip_tos parse error");
+	return err;
+}
+
 static int (*sparx5_tc_flower_usage_handlers[])(struct sparx5_tc_flower_parse_usage *st) = {
-	/* More dissector handlers will be added here later */
 	[FLOW_DISSECTOR_KEY_ETH_ADDRS] = sparx5_tc_flower_handler_ethaddr_usage,
+	[FLOW_DISSECTOR_KEY_IPV4_ADDRS] = sparx5_tc_flower_handler_ipv4_usage,
+	[FLOW_DISSECTOR_KEY_IPV6_ADDRS] = sparx5_tc_flower_handler_ipv6_usage,
+	[FLOW_DISSECTOR_KEY_CONTROL] = sparx5_tc_flower_handler_control_usage,
+	[FLOW_DISSECTOR_KEY_PORTS] = sparx5_tc_flower_handler_portnum_usage,
+	[FLOW_DISSECTOR_KEY_BASIC] = sparx5_tc_flower_handler_basic_usage,
+	[FLOW_DISSECTOR_KEY_VLAN] = sparx5_tc_flower_handler_vlan_usage,
+	[FLOW_DISSECTOR_KEY_TCP] = sparx5_tc_flower_handler_tcp_usage,
+	[FLOW_DISSECTOR_KEY_IP] = sparx5_tc_flower_handler_ip_usage,
 };
 
 static int sparx5_tc_use_dissectors(struct flow_cls_offload *fco,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index d255bc7deae7..ace2582d8552 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1073,6 +1073,17 @@ int vcap_rule_add_key_u72(struct vcap_rule *rule, enum vcap_key_field key,
 }
 EXPORT_SYMBOL_GPL(vcap_rule_add_key_u72);
 
+/* Add a 128 bit key with value and mask to the rule */
+int vcap_rule_add_key_u128(struct vcap_rule *rule, enum vcap_key_field key,
+			   struct vcap_u128_key *fieldval)
+{
+	struct vcap_client_keyfield_data data;
+
+	memcpy(&data.u128, fieldval, sizeof(data.u128));
+	return vcap_rule_add_key(rule, key, VCAP_FIELD_U128, &data);
+}
+EXPORT_SYMBOL_GPL(vcap_rule_add_key_u128);
+
 static void vcap_copy_from_client_actionfield(struct vcap_rule *rule,
 					      struct vcap_client_actionfield *field,
 					      struct vcap_client_actionfield_data *data)
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 5df6808679ff..577395402a9a 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -176,6 +176,8 @@ int vcap_rule_add_key_u48(struct vcap_rule *rule, enum vcap_key_field key,
 			  struct vcap_u48_key *fieldval);
 int vcap_rule_add_key_u72(struct vcap_rule *rule, enum vcap_key_field key,
 			  struct vcap_u72_key *fieldval);
+int vcap_rule_add_key_u128(struct vcap_rule *rule, enum vcap_key_field key,
+			   struct vcap_u128_key *fieldval);
 int vcap_rule_add_action_bit(struct vcap_rule *rule,
 			     enum vcap_action_field action, enum vcap_bit val);
 int vcap_rule_add_action_u32(struct vcap_rule *rule,
-- 
2.38.1

