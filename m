Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386BF625AF2
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 14:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiKKNGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 08:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiKKNGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 08:06:33 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8130862F4;
        Fri, 11 Nov 2022 05:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668171958; x=1699707958;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8XwoBqdgKoM5V3kbMOhCihQp2eLtKE9DTDcoUojaHV4=;
  b=RX8MhFQdVuAkumfqNqv1sBrTpXU7jlPYgZTTuypDpdw9O6E/KJi6HrUF
   kztBg2qCQ9VHhJAqDv3qbkucUMXB7k4WiPKHF664ps45s4v9hvsI0qzxM
   rG4RDbnNyR1jVF9g8T4ne/jwSoAKAdae82pk9ed+GNaD3L/NswqXsivKx
   Dl8EtUEU5x8mcptjfZ7ZO86weBjaw7RLl5f2tDzrZLVhA5X6SDAUhP39d
   2YmQcjvlaQ2l1qitTEESj51qNtDh+W0EUiZ+yjsKU5mLI5LaNBu+SMnx7
   UCdpLMG6wcqgcwV56pBxIzQwA4StR015a7ABOlxAj31LDGtirYy4mevvT
   w==;
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="123001275"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2022 06:05:57 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 11 Nov 2022 06:05:51 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 11 Nov 2022 06:05:47 -0700
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
Subject: [PATCH net-next 5/6] net: microchip: sparx5: Add support for TC flower filter statistics
Date:   Fri, 11 Nov 2022 14:05:18 +0100
Message-ID: <20221111130519.1459549-6-steen.hegelund@microchip.com>
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

This provides flower filter packet statistics (bytes are not supported) via
the dedicated IS2 counter feature.

All rules having the same TC cookie will contribute to the packet
statistics for the filter as they are considered to be part of the same TC
flower filter.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 68 +++++++++++++++++++
 .../net/ethernet/microchip/vcap/vcap_api.c    | 25 +++++++
 .../ethernet/microchip/vcap/vcap_api_client.h |  3 +
 3 files changed, 96 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index b76b8fc567bb..a48baeacc1d2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -21,6 +21,11 @@ struct sparx5_tc_flower_parse_usage {
 	unsigned int used_keys;
 };
 
+struct sparx5_tc_rule_pkt_cnt {
+	u64 cookie;
+	u32 pkts;
+};
+
 /* These protocols have dedicated keysets in IS2 and a TC dissector
  * ETH_P_ARP does not have a TC dissector
  */
@@ -605,6 +610,20 @@ static int sparx5_tc_flower_action_check(struct vcap_control *vctrl,
 	return 0;
 }
 
+/* Add a rule counter action - only IS2 is considered for now */
+static int sparx5_tc_add_rule_counter(struct vcap_admin *admin,
+				      struct vcap_rule *vrule)
+{
+	int err;
+
+	err = vcap_rule_add_action_u32(vrule, VCAP_AF_CNT_ID, vrule->id);
+	if (err)
+		return err;
+
+	vcap_rule_set_counter_id(vrule, vrule->id);
+	return err;
+}
+
 static int sparx5_tc_flower_replace(struct net_device *ndev,
 				    struct flow_cls_offload *fco,
 				    struct vcap_admin *admin)
@@ -630,6 +649,11 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 
 	vrule->cookie = fco->cookie;
 	sparx5_tc_use_dissectors(fco, admin, vrule, &l3_proto);
+
+	err = sparx5_tc_add_rule_counter(admin, vrule);
+	if (err)
+		goto out;
+
 	frule = flow_cls_offload_flow_rule(fco);
 	flow_action_for_each(idx, act, &frule->action) {
 		switch (act->id) {
@@ -708,6 +732,48 @@ static int sparx5_tc_flower_destroy(struct net_device *ndev,
 	return err;
 }
 
+/* Collect packet counts from all rules with the same cookie */
+static int sparx5_tc_rule_counter_cb(void *arg, struct vcap_rule *rule)
+{
+	struct sparx5_tc_rule_pkt_cnt *rinfo = arg;
+	struct vcap_counter counter;
+	int err = 0;
+
+	if (rule->cookie == rinfo->cookie) {
+		err = vcap_rule_get_counter(rule, &counter);
+		if (err)
+			return err;
+		rinfo->pkts += counter.value;
+		/* Reset the rule counter */
+		counter.value = 0;
+		vcap_rule_set_counter(rule, &counter);
+	}
+	return err;
+}
+
+static int sparx5_tc_flower_stats(struct net_device *ndev,
+				  struct flow_cls_offload *fco,
+				  struct vcap_admin *admin)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5_tc_rule_pkt_cnt rinfo = {};
+	struct vcap_control *vctrl;
+	ulong lastused = 0;
+	u64 drops = 0;
+	u32 pkts = 0;
+	int err;
+
+	rinfo.cookie = fco->cookie;
+	vctrl = port->sparx5->vcap_ctrl;
+	err = vcap_rule_iter(vctrl, sparx5_tc_rule_counter_cb, &rinfo);
+	if (err)
+		return err;
+	pkts = rinfo.pkts;
+	flow_stats_update(&fco->stats, 0x0, pkts, drops, lastused,
+			  FLOW_ACTION_HW_STATS_IMMEDIATE);
+	return err;
+}
+
 int sparx5_tc_flower(struct net_device *ndev, struct flow_cls_offload *fco,
 		     bool ingress)
 {
@@ -729,6 +795,8 @@ int sparx5_tc_flower(struct net_device *ndev, struct flow_cls_offload *fco,
 		return sparx5_tc_flower_replace(ndev, fco, admin);
 	case FLOW_CLS_DESTROY:
 		return sparx5_tc_flower_destroy(ndev, fco, admin);
+	case FLOW_CLS_STATS:
+		return sparx5_tc_flower_stats(ndev, fco, admin);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 9c660e718526..d12c8ec40fe2 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1729,6 +1729,31 @@ void vcap_rule_set_counter_id(struct vcap_rule *rule, u32 counter_id)
 }
 EXPORT_SYMBOL_GPL(vcap_rule_set_counter_id);
 
+/* Provide all rules via a callback interface */
+int vcap_rule_iter(struct vcap_control *vctrl,
+		   int (*callback)(void *, struct vcap_rule *), void *arg)
+{
+	struct vcap_rule_internal *ri;
+	struct vcap_admin *admin;
+	int ret;
+
+	ret = vcap_api_check(vctrl);
+	if (ret)
+		return ret;
+
+	/* Iterate all rules in each VCAP instance */
+	list_for_each_entry(admin, &vctrl->list, list) {
+		list_for_each_entry(ri, &admin->rules, list) {
+			ret = callback(arg, &ri->data);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vcap_rule_iter);
+
 int vcap_rule_set_counter(struct vcap_rule *rule, struct vcap_counter *ctr)
 {
 	struct vcap_rule_internal *ri = to_intrule(rule);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index c2655045d6d4..654ef8fa6d62 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -210,6 +210,9 @@ const struct vcap_field *vcap_lookup_keyfield(struct vcap_rule *rule,
 int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie);
 /* Is the next chain id in the following lookup, possible in another VCAP */
 bool vcap_is_next_lookup(struct vcap_control *vctrl, int cur_cid, int next_cid);
+/* Provide all rules via a callback interface */
+int vcap_rule_iter(struct vcap_control *vctrl,
+		   int (*callback)(void *, struct vcap_rule *), void *arg);
 
 /* Copy to host byte order */
 void vcap_netbytes_copy(u8 *dst, u8 *src, int count);
-- 
2.38.1

