Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A319C636381
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237720AbiKWP1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237852AbiKWP0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:26:47 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523ACA6590;
        Wed, 23 Nov 2022 07:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669217190; x=1700753190;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aWK/w3O8H43VBVicVuiR2cJT/wFQ8uPk13PWRF6aQ9M=;
  b=IAd51jm1doyBzUtRUXL4G12lJ3RkisiBtZtpalUnWFYwRv5w9KM/JhoY
   Xb7mgD9mxKXDK7GsWrcNAtbgJTI3b0lqOsQd+IgRIuQtyZGObS5IDau4m
   y53TrO1BDhe0zXeIvXh3dTPkR1yjNuIY4dNRZnS/FE1cXJyxpQBEKAkFi
   8JM4j1x2BN1sTG8YS1eLqUh+QqSsLR/vhD6GiS0B2InDYqyeER9F92SYn
   tBYyw0ggiHfmE8817Y8g6ARfuh1sitCMSfMDGOBPkLmAWGXXA9XGsGcNM
   ypzPh9kt6cvLO49gaBU1Cd77Q3iRoEgygjhd3pMS/PjIcdk8D1WkCGtBb
   A==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="184877312"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 08:26:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 08:26:05 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 08:26:02 -0700
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
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v2 4/4] net: microchip: sparx5: Add VCAP filter keys KUNIT test
Date:   Wed, 23 Nov 2022 16:25:45 +0100
Message-ID: <20221123152545.1997266-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123152545.1997266-1-steen.hegelund@microchip.com>
References: <20221123152545.1997266-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tests the filtering of keys, either dropping unsupported keys or
dropping keys specified in a list.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../ethernet/microchip/vcap/vcap_api_kunit.c  | 194 ++++++++++++++++++
 1 file changed, 194 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index 875068e484c9..76a31215ebfb 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -1954,6 +1954,198 @@ static void vcap_api_next_lookup_advanced_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, true, ret);
 }
 
+static void vcap_api_filter_unsupported_keys_test(struct kunit *test)
+{
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS2,
+	};
+	struct vcap_rule_internal ri = {
+		.admin = &admin,
+		.vctrl = &test_vctrl,
+		.data.keyset = VCAP_KFS_MAC_ETYPE,
+	};
+	enum vcap_key_field keylist[] = {
+		VCAP_KF_TYPE,
+		VCAP_KF_LOOKUP_FIRST_IS,
+		VCAP_KF_ARP_ADDR_SPACE_OK_IS,  /* arp keys are not in keyset */
+		VCAP_KF_ARP_PROTO_SPACE_OK_IS,
+		VCAP_KF_ARP_LEN_OK_IS,
+		VCAP_KF_ARP_TGT_MATCH_IS,
+		VCAP_KF_ARP_SENDER_MATCH_IS,
+		VCAP_KF_ARP_OPCODE_UNKNOWN_IS,
+		VCAP_KF_ARP_OPCODE,
+		VCAP_KF_8021Q_DEI_CLS,
+		VCAP_KF_8021Q_PCP_CLS,
+		VCAP_KF_8021Q_VID_CLS,
+		VCAP_KF_L2_MC_IS,
+		VCAP_KF_L2_BC_IS,
+	};
+	enum vcap_key_field expected[] = {
+		VCAP_KF_TYPE,
+		VCAP_KF_LOOKUP_FIRST_IS,
+		VCAP_KF_8021Q_DEI_CLS,
+		VCAP_KF_8021Q_PCP_CLS,
+		VCAP_KF_8021Q_VID_CLS,
+		VCAP_KF_L2_MC_IS,
+		VCAP_KF_L2_BC_IS,
+	};
+	struct vcap_client_keyfield *ckf, *next;
+	bool ret;
+	int idx;
+
+	/* Add all keys to the rule */
+	INIT_LIST_HEAD(&ri.data.keyfields);
+	for (idx = 0; idx < ARRAY_SIZE(keylist); idx++) {
+		ckf = kzalloc(sizeof(*ckf), GFP_KERNEL);
+		if (ckf) {
+			ckf->ctrl.key = keylist[idx];
+			list_add_tail(&ckf->ctrl.list, &ri.data.keyfields);
+		}
+	}
+
+	KUNIT_EXPECT_EQ(test, 14, ARRAY_SIZE(keylist));
+
+	/* Drop unsupported keys from the rule */
+	ret = vcap_filter_rule_keys(&ri.data, NULL, 0, true);
+
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	/* Check remaining keys in the rule */
+	idx = 0;
+	list_for_each_entry_safe(ckf, next, &ri.data.keyfields, ctrl.list) {
+		KUNIT_EXPECT_EQ(test, expected[idx], ckf->ctrl.key);
+		list_del(&ckf->ctrl.list);
+		kfree(ckf);
+		++idx;
+	}
+	KUNIT_EXPECT_EQ(test, 7, idx);
+}
+
+static void vcap_api_filter_keylist_test(struct kunit *test)
+{
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS0,
+	};
+	struct vcap_rule_internal ri = {
+		.admin = &admin,
+		.vctrl = &test_vctrl,
+		.data.keyset = VCAP_KFS_NORMAL_7TUPLE,
+	};
+	enum vcap_key_field keylist[] = {
+		VCAP_KF_TYPE,
+		VCAP_KF_LOOKUP_FIRST_IS,
+		VCAP_KF_LOOKUP_GEN_IDX_SEL,
+		VCAP_KF_LOOKUP_GEN_IDX,
+		VCAP_KF_IF_IGR_PORT_MASK_SEL,
+		VCAP_KF_IF_IGR_PORT_MASK,
+		VCAP_KF_L2_MC_IS,
+		VCAP_KF_L2_BC_IS,
+		VCAP_KF_8021Q_VLAN_TAGS,
+		VCAP_KF_8021Q_TPID0,
+		VCAP_KF_8021Q_PCP0,
+		VCAP_KF_8021Q_DEI0,
+		VCAP_KF_8021Q_VID0,
+		VCAP_KF_8021Q_TPID1,
+		VCAP_KF_8021Q_PCP1,
+		VCAP_KF_8021Q_DEI1,
+		VCAP_KF_8021Q_VID1,
+		VCAP_KF_8021Q_TPID2,
+		VCAP_KF_8021Q_PCP2,
+		VCAP_KF_8021Q_DEI2,
+		VCAP_KF_8021Q_VID2,
+		VCAP_KF_L2_DMAC,
+		VCAP_KF_L2_SMAC,
+		VCAP_KF_IP_MC_IS,
+		VCAP_KF_ETYPE_LEN_IS,
+		VCAP_KF_ETYPE,
+		VCAP_KF_IP_SNAP_IS,
+		VCAP_KF_IP4_IS,
+		VCAP_KF_L3_FRAGMENT_TYPE,
+		VCAP_KF_L3_FRAG_INVLD_L4_LEN,
+		VCAP_KF_L3_OPTIONS_IS,
+		VCAP_KF_L3_DSCP,
+		VCAP_KF_L3_IP6_DIP,
+		VCAP_KF_L3_IP6_SIP,
+		VCAP_KF_TCP_UDP_IS,
+		VCAP_KF_TCP_IS,
+		VCAP_KF_L4_SPORT,
+		VCAP_KF_L4_RNG,
+	};
+	enum vcap_key_field droplist[] = {
+		VCAP_KF_8021Q_TPID1,
+		VCAP_KF_8021Q_PCP1,
+		VCAP_KF_8021Q_DEI1,
+		VCAP_KF_8021Q_VID1,
+		VCAP_KF_8021Q_TPID2,
+		VCAP_KF_8021Q_PCP2,
+		VCAP_KF_8021Q_DEI2,
+		VCAP_KF_8021Q_VID2,
+		VCAP_KF_L3_IP6_DIP,
+		VCAP_KF_L3_IP6_SIP,
+		VCAP_KF_L4_SPORT,
+		VCAP_KF_L4_RNG,
+	};
+	enum vcap_key_field expected[] = {
+		VCAP_KF_TYPE,
+		VCAP_KF_LOOKUP_FIRST_IS,
+		VCAP_KF_LOOKUP_GEN_IDX_SEL,
+		VCAP_KF_LOOKUP_GEN_IDX,
+		VCAP_KF_IF_IGR_PORT_MASK_SEL,
+		VCAP_KF_IF_IGR_PORT_MASK,
+		VCAP_KF_L2_MC_IS,
+		VCAP_KF_L2_BC_IS,
+		VCAP_KF_8021Q_VLAN_TAGS,
+		VCAP_KF_8021Q_TPID0,
+		VCAP_KF_8021Q_PCP0,
+		VCAP_KF_8021Q_DEI0,
+		VCAP_KF_8021Q_VID0,
+		VCAP_KF_L2_DMAC,
+		VCAP_KF_L2_SMAC,
+		VCAP_KF_IP_MC_IS,
+		VCAP_KF_ETYPE_LEN_IS,
+		VCAP_KF_ETYPE,
+		VCAP_KF_IP_SNAP_IS,
+		VCAP_KF_IP4_IS,
+		VCAP_KF_L3_FRAGMENT_TYPE,
+		VCAP_KF_L3_FRAG_INVLD_L4_LEN,
+		VCAP_KF_L3_OPTIONS_IS,
+		VCAP_KF_L3_DSCP,
+		VCAP_KF_TCP_UDP_IS,
+		VCAP_KF_TCP_IS,
+	};
+	struct vcap_client_keyfield *ckf, *next;
+	bool ret;
+	int idx;
+
+	/* Add all keys to the rule */
+	INIT_LIST_HEAD(&ri.data.keyfields);
+	for (idx = 0; idx < ARRAY_SIZE(keylist); idx++) {
+		ckf = kzalloc(sizeof(*ckf), GFP_KERNEL);
+		if (ckf) {
+			ckf->ctrl.key = keylist[idx];
+			list_add_tail(&ckf->ctrl.list, &ri.data.keyfields);
+		}
+	}
+
+	KUNIT_EXPECT_EQ(test, 38, ARRAY_SIZE(keylist));
+
+	/* Drop listed keys from the rule */
+	ret = vcap_filter_rule_keys(&ri.data, droplist, ARRAY_SIZE(droplist),
+				    false);
+
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	/* Check remaining keys in the rule */
+	idx = 0;
+	list_for_each_entry_safe(ckf, next, &ri.data.keyfields, ctrl.list) {
+		KUNIT_EXPECT_EQ(test, expected[idx], ckf->ctrl.key);
+		list_del(&ckf->ctrl.list);
+		kfree(ckf);
+		++idx;
+	}
+	KUNIT_EXPECT_EQ(test, 26, idx);
+}
+
 static struct kunit_suite vcap_api_rule_remove_test_suite = {
 	.name = "VCAP_API_Rule_Remove_Testsuite",
 	.test_cases = vcap_api_rule_remove_test_cases,
@@ -1984,6 +2176,8 @@ static struct kunit_suite vcap_api_rule_counter_test_suite = {
 static struct kunit_case vcap_api_support_test_cases[] = {
 	KUNIT_CASE(vcap_api_next_lookup_basic_test),
 	KUNIT_CASE(vcap_api_next_lookup_advanced_test),
+	KUNIT_CASE(vcap_api_filter_unsupported_keys_test),
+	KUNIT_CASE(vcap_api_filter_keylist_test),
 	{}
 };
 
-- 
2.38.1

