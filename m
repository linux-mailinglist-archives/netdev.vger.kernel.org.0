Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73E7625AEB
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 14:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbiKKNFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 08:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiKKNFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 08:05:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D267C8F1;
        Fri, 11 Nov 2022 05:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668171939; x=1699707939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MwMrFBuJYmXmypJ56eKGRvFX0VICWHsAbwpGcGNvxjw=;
  b=ThkIGyP9k7AmriEtKJcYIoOHDXvrt/RNTkmTkbEnYQpu5wtCwDhcpS+B
   BT+6KWvJwIiRBhRrITRzqRY1E3gO0If3N/j5yVA8PEgG6xGP1OBZCYorE
   iQP7rviKAP5Z7AA+qQxVV1JemIIBwDEYWAEKX4IcdAgam3MzhgiiLszJL
   NPi5AwFDyxmVHPhMaRPGRe/JvC5csQ7P2bKtpj6uaBlrBNbmwAgPlY5JL
   U9pcmLZWt9QGC+85+8e5AikDq2zl5tZ4D/HlO9sRGhwSMqZH6x65uKWbQ
   c/uUAM6OPlR78VfyCEknbWnpL17yx4OwGDUyZ41OYM81pidEhMdELYZhK
   w==;
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="123000930"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2022 06:05:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 11 Nov 2022 06:05:37 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 11 Nov 2022 06:05:33 -0700
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
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Simon Horman <simon.horman@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        "Wojciech Drewek" <wojciech.drewek@intel.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 2/6] net: microchip: sparx5: Add support for TC flower ARP dissector
Date:   Fri, 11 Nov 2022 14:05:15 +0100
Message-ID: <20221111130519.1459549-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111130519.1459549-1-steen.hegelund@microchip.com>
References: <20221111130519.1459549-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This add support for Sparx5 for dissecting TC ARP flower filter keys and
sets up the Sparx5 IS2 VCAP to generate the ARP keyset for ARP frames.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 76 +++++++++++++++++++
 .../microchip/sparx5/sparx5_vcap_impl.c       |  2 +-
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 7b364f6b4546..b76b8fc567bb 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -26,10 +26,24 @@ struct sparx5_tc_flower_parse_usage {
  */
 static u16 sparx5_tc_known_etypes[] = {
 	ETH_P_ALL,
+	ETH_P_ARP,
 	ETH_P_IP,
 	ETH_P_IPV6,
 };
 
+enum sparx5_is2_arp_opcode {
+	SPX5_IS2_ARP_REQUEST,
+	SPX5_IS2_ARP_REPLY,
+	SPX5_IS2_RARP_REQUEST,
+	SPX5_IS2_RARP_REPLY,
+};
+
+enum tc_arp_opcode {
+	TC_ARP_OP_RESERVED,
+	TC_ARP_OP_REQUEST,
+	TC_ARP_OP_REPLY,
+};
+
 static bool sparx5_tc_is_known_etype(u16 etype)
 {
 	int idx;
@@ -404,6 +418,67 @@ sparx5_tc_flower_handler_tcp_usage(struct sparx5_tc_flower_parse_usage *st)
 	return err;
 }
 
+static int
+sparx5_tc_flower_handler_arp_usage(struct sparx5_tc_flower_parse_usage *st)
+{
+	struct flow_match_arp mt;
+	u16 value, mask;
+	u32 ipval, ipmsk;
+	int err;
+
+	flow_rule_match_arp(st->frule, &mt);
+
+	if (mt.mask->op) {
+		mask = 0x3;
+		if (st->l3_proto == ETH_P_ARP) {
+			value = mt.key->op == TC_ARP_OP_REQUEST ?
+					SPX5_IS2_ARP_REQUEST :
+					SPX5_IS2_ARP_REPLY;
+		} else { /* RARP */
+			value = mt.key->op == TC_ARP_OP_REQUEST ?
+					SPX5_IS2_RARP_REQUEST :
+					SPX5_IS2_RARP_REPLY;
+		}
+		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_ARP_OPCODE,
+					    value, mask);
+		if (err)
+			goto out;
+	}
+
+	/* The IS2 ARP keyset does not support ARP hardware addresses */
+	if (!is_zero_ether_addr(mt.mask->sha) ||
+	    !is_zero_ether_addr(mt.mask->tha))
+		goto out;
+
+	if (mt.mask->sip) {
+		ipval = be32_to_cpu((__force __be32)mt.key->sip);
+		ipmsk = be32_to_cpu((__force __be32)mt.mask->sip);
+
+		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L3_IP4_SIP,
+					    ipval, ipmsk);
+		if (err)
+			goto out;
+	}
+
+	if (mt.mask->tip) {
+		ipval = be32_to_cpu((__force __be32)mt.key->tip);
+		ipmsk = be32_to_cpu((__force __be32)mt.mask->tip);
+
+		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L3_IP4_DIP,
+					    ipval, ipmsk);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_ARP);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "arp parse error");
+	return err;
+}
+
 static int
 sparx5_tc_flower_handler_ip_usage(struct sparx5_tc_flower_parse_usage *st)
 {
@@ -438,6 +513,7 @@ static int (*sparx5_tc_flower_usage_handlers[])(struct sparx5_tc_flower_parse_us
 	[FLOW_DISSECTOR_KEY_BASIC] = sparx5_tc_flower_handler_basic_usage,
 	[FLOW_DISSECTOR_KEY_VLAN] = sparx5_tc_flower_handler_vlan_usage,
 	[FLOW_DISSECTOR_KEY_TCP] = sparx5_tc_flower_handler_tcp_usage,
+	[FLOW_DISSECTOR_KEY_ARP] = sparx5_tc_flower_handler_arp_usage,
 	[FLOW_DISSECTOR_KEY_IP] = sparx5_tc_flower_handler_ip_usage,
 };
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index 10bc56cd0045..db73e2b19dc5 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -540,7 +540,7 @@ static void sparx5_vcap_port_key_selection(struct sparx5 *sparx5,
 				 VCAP_IS2_PS_IPV4_UC_IP4_TCP_UDP_OTHER,
 				 VCAP_IS2_PS_IPV6_MC_IP_7TUPLE,
 				 VCAP_IS2_PS_IPV6_UC_IP_7TUPLE,
-				 VCAP_IS2_PS_ARP_MAC_ETYPE);
+				 VCAP_IS2_PS_ARP_ARP);
 	for (lookup = 0; lookup < admin->lookups; ++lookup) {
 		for (portno = 0; portno < SPX5_PORTS; ++portno) {
 			spx5_wr(keysel, sparx5,
-- 
2.38.1

