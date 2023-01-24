Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BC16795A6
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbjAXKq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbjAXKqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:46:16 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A36F43463;
        Tue, 24 Jan 2023 02:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674557149; x=1706093149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O6++UIi+uStla/I8Q52TXjPqjRRlKPYrRiakFVdUI4Q=;
  b=eKpxkKevyjFWtBCshmk9Z8+VAMx2dIS8rTmWI5eXEccJHVkFLiJnWV3S
   5e9P9R5VdnqFjj4EELwx9lfQLBhL8APGXL4ErZwRTzjxv1bdp5g+jZWM8
   R3e0GKrJjZh91Hpbf85CfM28/d4GexNK8ygSIy9wqtpMApgbIoRnzkc8z
   WJSUAKZP0fh2usV0udintuhyrwWwkXSzQK9M9gKSKIq7NW3kD37ibSiHH
   Xy4Tg15uAt9aRSP1bQe+ZhuJVdH9nmKqe7jlxzU3RamTpYcVhwL14vKfD
   95wkJHT3noTwFgq/i3FjlEFvsXhqpq0UzyUyZPmTsqhlrwG7b8A+lBOkU
   A==;
X-IronPort-AV: E=Sophos;i="5.97,242,1669100400"; 
   d="scan'208";a="197853153"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jan 2023 03:45:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 03:45:49 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 03:45:45 -0700
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
Subject: [PATCH net-next v2 8/8] net: microchip: sparx5: Add support for IS0 VCAP CVLAN TC keys
Date:   Tue, 24 Jan 2023 11:45:11 +0100
Message-ID: <20230124104511.293938-9-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124104511.293938-1-steen.hegelund@microchip.com>
References: <20230124104511.293938-1-steen.hegelund@microchip.com>
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
index 59dfe420add9..59d6ed6f4191 100644
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

