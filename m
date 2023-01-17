Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE2966D8D8
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbjAQI4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbjAQIz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:55:59 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64753C1D;
        Tue, 17 Jan 2023 00:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673945755; x=1705481755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=95uKSDc/UujjSLEnC0nCOkmJuk+JOEIElumqUJ28/IM=;
  b=AH1tE+AiAEUF384uwakdvrSERrlHgG6Pd4kr9HeiIU6qITILe1p9aSd4
   aI+q9/QUm1sZJEbBa3hQngfjcbxgOMTgc6UTGR7JtpMBOed5w4aLe4EYH
   XUCvmynQrNcNbaMYS7cjvECHtgNDUOlA0CV0Qm/moDdxDoyNYXwGPWH+0
   THTzuOqPX6mOgD8T4fShNGolOuKhX2c6ZAtcEl2UMex5I50vkoC695P0L
   CAWHsgIfkGMpuvEn+UbvEkndBnEzkUuOKqrbXVE3KOZPg535UBSBlk29p
   ZQ7YuOD8Ro5p2IgfzPgoWMCQWn/YqanRMUsvraYYQ6zenpZZGUr+bklXA
   w==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669100400"; 
   d="scan'208";a="208096662"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 01:55:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 01:55:54 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 01:55:51 -0700
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
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/5] net: microchip: sparx5: Add support for rule count by cookie
Date:   Tue, 17 Jan 2023 09:55:40 +0100
Message-ID: <20230117085544.591523-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230117085544.591523-1-steen.hegelund@microchip.com>
References: <20230117085544.591523-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for TC clients to get the packet count for a TC filter
identified by its cookie.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 34 +---------
 .../net/ethernet/microchip/vcap/vcap_api.c    | 67 ++++++++++++-------
 .../ethernet/microchip/vcap/vcap_api_client.h |  2 +
 3 files changed, 47 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 986e41d3bb28..affaa1656710 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -35,11 +35,6 @@ struct sparx5_tc_flower_parse_usage {
 	unsigned int used_keys;
 };
 
-struct sparx5_tc_rule_pkt_cnt {
-	u64 cookie;
-	u32 pkts;
-};
-
 /* These protocols have dedicated keysets in IS2 and a TC dissector
  * ETH_P_ARP does not have a TC dissector
  */
@@ -947,44 +942,21 @@ static int sparx5_tc_flower_destroy(struct net_device *ndev,
 	return err;
 }
 
-/* Collect packet counts from all rules with the same cookie */
-static int sparx5_tc_rule_counter_cb(void *arg, struct vcap_rule *rule)
-{
-	struct sparx5_tc_rule_pkt_cnt *rinfo = arg;
-	struct vcap_counter counter;
-	int err = 0;
-
-	if (rule->cookie == rinfo->cookie) {
-		err = vcap_rule_get_counter(rule, &counter);
-		if (err)
-			return err;
-		rinfo->pkts += counter.value;
-		/* Reset the rule counter */
-		counter.value = 0;
-		vcap_rule_set_counter(rule, &counter);
-	}
-	return err;
-}
-
 static int sparx5_tc_flower_stats(struct net_device *ndev,
 				  struct flow_cls_offload *fco,
 				  struct vcap_admin *admin)
 {
 	struct sparx5_port *port = netdev_priv(ndev);
-	struct sparx5_tc_rule_pkt_cnt rinfo = {};
+	struct vcap_counter ctr = {};
 	struct vcap_control *vctrl;
 	ulong lastused = 0;
-	u64 drops = 0;
-	u32 pkts = 0;
 	int err;
 
-	rinfo.cookie = fco->cookie;
 	vctrl = port->sparx5->vcap_ctrl;
-	err = vcap_rule_iter(vctrl, sparx5_tc_rule_counter_cb, &rinfo);
+	err = vcap_get_rule_count_by_cookie(vctrl, &ctr, fco->cookie);
 	if (err)
 		return err;
-	pkts = rinfo.pkts;
-	flow_stats_update(&fco->stats, 0x0, pkts, drops, lastused,
+	flow_stats_update(&fco->stats, 0x0, ctr.value, 0, lastused,
 			  FLOW_ACTION_HW_STATS_IMMEDIATE);
 	return err;
 }
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 0f9e0d735ae3..4e038f96a131 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -2989,31 +2989,6 @@ void vcap_rule_set_counter_id(struct vcap_rule *rule, u32 counter_id)
 }
 EXPORT_SYMBOL_GPL(vcap_rule_set_counter_id);
 
-/* Provide all rules via a callback interface */
-int vcap_rule_iter(struct vcap_control *vctrl,
-		   int (*callback)(void *, struct vcap_rule *), void *arg)
-{
-	struct vcap_rule_internal *ri;
-	struct vcap_admin *admin;
-	int ret;
-
-	ret = vcap_api_check(vctrl);
-	if (ret)
-		return ret;
-
-	/* Iterate all rules in each VCAP instance */
-	list_for_each_entry(admin, &vctrl->list, list) {
-		list_for_each_entry(ri, &admin->rules, list) {
-			ret = callback(arg, &ri->data);
-			if (ret)
-				return ret;
-		}
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vcap_rule_iter);
-
 int vcap_rule_set_counter(struct vcap_rule *rule, struct vcap_counter *ctr)
 {
 	struct vcap_rule_internal *ri = to_intrule(rule);
@@ -3105,6 +3080,48 @@ int vcap_rule_get_keysets(struct vcap_rule_internal *ri,
 	return -EINVAL;
 }
 
+/* Collect packet counts from all rules with the same cookie */
+int vcap_get_rule_count_by_cookie(struct vcap_control *vctrl,
+				  struct vcap_counter *ctr, u64 cookie)
+{
+	struct vcap_rule_internal *ri;
+	struct vcap_counter temp = {};
+	struct vcap_admin *admin;
+	int err;
+
+	err = vcap_api_check(vctrl);
+	if (err)
+		return err;
+
+	/* Iterate all rules in each VCAP instance */
+	list_for_each_entry(admin, &vctrl->list, list) {
+		mutex_lock(&admin->lock);
+		list_for_each_entry(ri, &admin->rules, list) {
+			if (ri->data.cookie != cookie)
+				continue;
+
+			err = vcap_read_counter(ri, &temp);
+			if (err)
+				goto unlock;
+			ctr->value += temp.value;
+
+			/* Reset the rule counter */
+			temp.value = 0;
+			temp.sticky = 0;
+			err = vcap_write_counter(ri, &temp);
+			if (err)
+				goto unlock;
+		}
+		mutex_unlock(&admin->lock);
+	}
+	return err;
+
+unlock:
+	mutex_unlock(&admin->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(vcap_get_rule_count_by_cookie);
+
 static int vcap_rule_mod_key(struct vcap_rule *rule,
 			     enum vcap_key_field key,
 			     enum vcap_field_type ftype,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index b8980b22352f..2cdcd3b56b30 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -202,6 +202,8 @@ int vcap_rule_add_action_u32(struct vcap_rule *rule,
 			     enum vcap_action_field action, u32 value);
 
 /* VCAP rule counter operations */
+int vcap_get_rule_count_by_cookie(struct vcap_control *vctrl,
+				  struct vcap_counter *ctr, u64 cookie);
 int vcap_rule_set_counter(struct vcap_rule *rule, struct vcap_counter *ctr);
 int vcap_rule_get_counter(struct vcap_rule *rule, struct vcap_counter *ctr);
 
-- 
2.39.0

