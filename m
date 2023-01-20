Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9035A675049
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjATJJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjATJJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:09:42 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC338B74E;
        Fri, 20 Jan 2023 01:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674205754; x=1705741754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K4TKEkB6VfBAugRRdQPgdPkApu6jLVETu9WzeMkcmJo=;
  b=IaithlPDa1kVtZWuCr9SiOtqQZBi2WMHD0xs632MvwuqFfc8zv3OpYVZ
   vhWKCloRGdiXPkU9gg6n8yvDelAGSsCpWG3m50F8566QfpWjKQF0aG30V
   hJTf5E1n0tvdFK9LvsmAkse6330o0eBDW3fxGroFx3lPkCzEpnf+q8bM5
   xeltZihzgt1QY7Qy9U5c5wYQLOcbXVEQWe68eQ660f7+Yb3kn6yEEvy0V
   CgtdSr5SKOgwWO1XTT1WBW/ijrRDDfEorC3hlsTPGRCV3n6CsPHD/NssB
   i2gA3179WuXWdLku5NYwemFe3hd83U+YdKt+f2x5OeMpouUfK1wFW4nQI
   A==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="193122608"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 02:09:11 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 02:09:10 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 02:09:06 -0700
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
Subject: [PATCH net-next 8/8] net: microchip: sparx5: Add support for IS0 VCAP CVLAN TC keys
Date:   Fri, 20 Jan 2023 10:08:31 +0100
Message-ID: <20230120090831.20032-9-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230120090831.20032-1-steen.hegelund@microchip.com>
References: <20230120090831.20032-1-steen.hegelund@microchip.com>
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

This adds support for parsing and matching on the CVLAN tags in the Sparx5
IS0 VCAP.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 9e613dc5b868..14145fbf6ddd 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -308,6 +308,51 @@ sparx5_tc_flower_handler_basic_usage(struct sparx5_tc_flower_parse_usage *st)
 	return err;
 }
 
+static int
+sparx5_tc_flower_handler_cvlan_usage(struct sparx5_tc_flower_parse_usage *st)
+{
+	enum vcap_key_field vid_key = VCAP_KF_8021Q_VID0;
+	enum vcap_key_field pcp_key = VCAP_KF_8021Q_PCP0;
+	struct flow_match_vlan mt;
+	u16 tpid;
+	int err;
+
+	if (st->admin->vtype != VCAP_TYPE_IS0)
+		return -EINVAL;
+
+	flow_rule_match_cvlan(st->frule, &mt);
+
+	tpid = be16_to_cpu(mt.key->vlan_tpid);
+
+	if (tpid == ETH_P_8021Q) {
+		vid_key = VCAP_KF_8021Q_VID1;
+		pcp_key = VCAP_KF_8021Q_PCP1;
+	}
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
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_CVLAN);
+
+	return 0;
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "cvlan parse error");
+	return err;
+}
+
 static int
 sparx5_tc_flower_handler_vlan_usage(struct sparx5_tc_flower_parse_usage *st)
 {
@@ -318,6 +363,11 @@ sparx5_tc_flower_handler_vlan_usage(struct sparx5_tc_flower_parse_usage *st)
 
 	flow_rule_match_vlan(st->frule, &mt);
 
+	if (st->admin->vtype == VCAP_TYPE_IS0) {
+		vid_key = VCAP_KF_8021Q_VID0;
+		pcp_key = VCAP_KF_8021Q_PCP0;
+	}
+
 	if (mt.mask->vlan_id) {
 		err = vcap_rule_add_key_u32(st->vrule, vid_key,
 					    mt.key->vlan_id,
@@ -513,6 +563,7 @@ static int (*sparx5_tc_flower_usage_handlers[])(struct sparx5_tc_flower_parse_us
 	[FLOW_DISSECTOR_KEY_CONTROL] = sparx5_tc_flower_handler_control_usage,
 	[FLOW_DISSECTOR_KEY_PORTS] = sparx5_tc_flower_handler_portnum_usage,
 	[FLOW_DISSECTOR_KEY_BASIC] = sparx5_tc_flower_handler_basic_usage,
+	[FLOW_DISSECTOR_KEY_CVLAN] = sparx5_tc_flower_handler_cvlan_usage,
 	[FLOW_DISSECTOR_KEY_VLAN] = sparx5_tc_flower_handler_vlan_usage,
 	[FLOW_DISSECTOR_KEY_TCP] = sparx5_tc_flower_handler_tcp_usage,
 	[FLOW_DISSECTOR_KEY_ARP] = sparx5_tc_flower_handler_arp_usage,
-- 
2.39.1

