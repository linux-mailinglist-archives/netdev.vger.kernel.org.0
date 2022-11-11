Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EC7625AE9
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 14:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbiKKNFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 08:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbiKKNFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 08:05:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455F16DCE3;
        Fri, 11 Nov 2022 05:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668171938; x=1699707938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AR+nmO2jQEhSBw5v3+UnruUyhkqnIBsLZ30bfGwKdWA=;
  b=ZojA2esy/GsQl/ZpPl6SiQSgbK7vqetcAxG2OJgF1fYHBaWxoV26MNAG
   sunciPA41HVrX/gKhvRPlhVwivRwD6gXzEBjfNiRopVESI/VbFVcfGwlF
   Kj8qkY+Zd74/GimNxWnIt82l4WH/qz5aPTNDW1QrPj70h1XXasnVm7Wbs
   0+YqiGxR10rJ2t9YlwvaS+8BTFT04NDxLmnvMeeMeraI+tf3XAuaDPyOf
   SCp2EWC0+PgCsWlA3S/5CbrazLNGo7ivOvybTN12FSFuA40unHr400iSa
   kDo/x79DxI9aaaVoFqOaXR3cTKQHCnqnMHsp7oueHJIkzgQvmbBN4EwTe
   g==;
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="123000911"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2022 06:05:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 11 Nov 2022 06:05:33 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 11 Nov 2022 06:05:29 -0700
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
Subject: [PATCH net-next 1/6] net: flow_offload: add support for ARP frame matching
Date:   Fri, 11 Nov 2022 14:05:14 +0100
Message-ID: <20221111130519.1459549-2-steen.hegelund@microchip.com>
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

This adds a new flow_rule_match_arp function that allows drivers
to be able to dissect ARP frames.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 include/net/flow_offload.h | 6 ++++++
 net/core/flow_offload.c    | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 7a60bc6d72c9..0400a0ac8a29 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -32,6 +32,10 @@ struct flow_match_vlan {
 	struct flow_dissector_key_vlan *key, *mask;
 };
 
+struct flow_match_arp {
+	struct flow_dissector_key_arp *key, *mask;
+};
+
 struct flow_match_ipv4_addrs {
 	struct flow_dissector_key_ipv4_addrs *key, *mask;
 };
@@ -98,6 +102,8 @@ void flow_rule_match_vlan(const struct flow_rule *rule,
 			  struct flow_match_vlan *out);
 void flow_rule_match_cvlan(const struct flow_rule *rule,
 			   struct flow_match_vlan *out);
+void flow_rule_match_arp(const struct flow_rule *rule,
+			 struct flow_match_arp *out);
 void flow_rule_match_ipv4_addrs(const struct flow_rule *rule,
 				struct flow_match_ipv4_addrs *out);
 void flow_rule_match_ipv6_addrs(const struct flow_rule *rule,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index abe423fd5736..acfc1f88ea79 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -97,6 +97,13 @@ void flow_rule_match_cvlan(const struct flow_rule *rule,
 }
 EXPORT_SYMBOL(flow_rule_match_cvlan);
 
+void flow_rule_match_arp(const struct flow_rule *rule,
+			 struct flow_match_arp *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ARP, out);
+}
+EXPORT_SYMBOL(flow_rule_match_arp);
+
 void flow_rule_match_ipv4_addrs(const struct flow_rule *rule,
 				struct flow_match_ipv4_addrs *out)
 {
-- 
2.38.1

