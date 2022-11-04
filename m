Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64947619611
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiKDMUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiKDMUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:20:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909D0120A0;
        Fri,  4 Nov 2022 05:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667564400; x=1699100400;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b8IIA3P7AcrfkQStqWsci42IpheCko9C3MblZ4EP9F4=;
  b=difmHZFwsa3K6yjqdkzC51muIYFiozjRCDA/5JyXCp6CGTs9iTVBhc7G
   8f4M+MjzvLyF06SKHWLb3M+nAMzdXjVF3OcAj4xga3LytJmUo563Nl85n
   lBWLW3k22XYaw3VCpbsDAEMBHjYh5Kig6/9QFOLu4WPRGHckvKSh4L6yE
   yZD2667C+QE0DKMx1KtoEVce1M1Ah3SyqOZIbUSTzr84/Vubd2T2u/YZq
   bqYCRyjAHYB8/IUJnzFgUCHlu9tJGdMqFpre4mwpwR1j4N+iAQQnZw+QH
   MUd26TBM5zD441PWVZ+E+laOhQXMQIEoC7x+06dkRdN16aEzc5uvITpe1
   A==;
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="121821692"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Nov 2022 05:19:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 4 Nov 2022 05:19:44 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 4 Nov 2022 05:19:41 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Louis Peens <louis.peens@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: flow_offload: add support for ARP frame matching
Date:   Fri, 4 Nov 2022 13:19:15 +0100
Message-ID: <20221104121915.1317246-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

flow_rule_match_arp allows drivers to dissect APR frames

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

