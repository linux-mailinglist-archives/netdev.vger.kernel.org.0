Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5D4622ACE
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiKILmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiKILl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:41:59 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A402286D0;
        Wed,  9 Nov 2022 03:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667994116; x=1699530116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uPN3W5+v1im5EeV7Ncc0SXsbH8fsiOrxMDzdGbScGJI=;
  b=xo0obiB9FpQRpVNcbxR4UvRA2sUn/o75ahjwIjMRCcEsUiFRpai1vVji
   yH+bnKsxyHOeoCUar+J+wPZ31kKh3vgYFGlAcEgg9CHOrF/d2HzOizTI9
   dYXGAgJ/UdXutiELGkrWKBEcyBLvJkM+vQ/OIuEo9OLX5I95L8Oje4c3H
   HDX0WBngflra3G6ajvAb/QsOmrIQiqvjImvM/kDY08k95MhTKUIEtJS8n
   WJ77o1ZSTF6tijBrg8LGgD4jWvZkHL4JT5ky7Ya4YG078JhBi/RoDLSRi
   A7KwK7wNp+P/LJlZS+VADWTQVn6VB6d5vmid2tXGy0i0rnHsxpwyJYc+4
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="122545109"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Nov 2022 04:41:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 9 Nov 2022 04:41:51 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 9 Nov 2022 04:41:47 -0700
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
        Lars Povlsen <lars.povlsen@microchip.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v6 8/8] net: microchip: sparx5: Adding KUNIT tests of key/action values in VCAP API
Date:   Wed, 9 Nov 2022 12:41:16 +0100
Message-ID: <20221109114116.3612477-9-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109114116.3612477-1-steen.hegelund@microchip.com>
References: <20221109114116.3612477-1-steen.hegelund@microchip.com>
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

This tests that the available keyfield and actionfield add methods are
doing the exepected work: adding the value (and mask) to the
keyfield/actionfield list item in the rule.

The test also covers the functionality that matches a rule to a keyset.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 .../ethernet/microchip/vcap/vcap_api_kunit.c  | 592 ++++++++++++++++++
 1 file changed, 592 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index d142ed660338..b0ec51b37683 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -22,6 +22,7 @@ static u32 test_init_start;
 static u32 test_init_count;
 static u32 test_hw_counter_id;
 static struct vcap_cache_data test_hw_cache;
+static struct net_device test_netdev = {};
 
 /* Callback used by the VCAP API */
 static enum vcap_keyfield_set test_val_keyset(struct net_device *ndev,
@@ -204,6 +205,13 @@ static int vcap_test_port_info(struct net_device *ndev, enum vcap_type vtype,
 	return 0;
 }
 
+static int vcap_test_enable(struct net_device *ndev,
+			    struct vcap_admin *admin,
+			    bool enable)
+{
+	return 0;
+}
+
 static struct vcap_operations test_callbacks = {
 	.validate_keyset = test_val_keyset,
 	.add_default_fields = test_add_def_fields,
@@ -214,6 +222,7 @@ static struct vcap_operations test_callbacks = {
 	.update = test_cache_update,
 	.move = test_cache_move,
 	.port_info = vcap_test_port_info,
+	.enable = vcap_test_enable,
 };
 
 static struct vcap_control test_vctrl = {
@@ -904,6 +913,586 @@ static void vcap_api_encode_rule_actionset_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, (u32)0x00000000, actwords[11]);
 }
 
+static void vcap_api_rule_add_keyvalue_test(struct kunit *test)
+{
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS2,
+	};
+	struct vcap_rule_internal ri = {
+		.admin = &admin,
+		.data = {
+			.keyset = VCAP_KFS_NO_VALUE,
+		},
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_rule *rule = (struct vcap_rule *)&ri;
+	struct vcap_client_keyfield *kf;
+	int ret;
+	struct vcap_u128_key dip = {
+		.value = {0x17, 0x26, 0x35, 0x44, 0x63, 0x62, 0x71},
+		.mask = {0xf1, 0xf2, 0xf3, 0xf4, 0x4f, 0x3f, 0x2f, 0x1f},
+	};
+	int idx;
+
+	INIT_LIST_HEAD(&rule->keyfields);
+	ret = vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS, VCAP_BIT_0);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = list_empty(&rule->keyfields);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	kf = list_first_entry(&rule->keyfields, struct vcap_client_keyfield,
+			      ctrl.list);
+	KUNIT_EXPECT_EQ(test, VCAP_KF_LOOKUP_FIRST_IS, kf->ctrl.key);
+	KUNIT_EXPECT_EQ(test, VCAP_FIELD_BIT, kf->ctrl.type);
+	KUNIT_EXPECT_EQ(test, 0x0, kf->data.u1.value);
+	KUNIT_EXPECT_EQ(test, 0x1, kf->data.u1.mask);
+
+	INIT_LIST_HEAD(&rule->keyfields);
+	ret = vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS, VCAP_BIT_1);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = list_empty(&rule->keyfields);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	kf = list_first_entry(&rule->keyfields, struct vcap_client_keyfield,
+			      ctrl.list);
+	KUNIT_EXPECT_EQ(test, VCAP_KF_LOOKUP_FIRST_IS, kf->ctrl.key);
+	KUNIT_EXPECT_EQ(test, VCAP_FIELD_BIT, kf->ctrl.type);
+	KUNIT_EXPECT_EQ(test, 0x1, kf->data.u1.value);
+	KUNIT_EXPECT_EQ(test, 0x1, kf->data.u1.mask);
+
+	INIT_LIST_HEAD(&rule->keyfields);
+	ret = vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS,
+				    VCAP_BIT_ANY);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = list_empty(&rule->keyfields);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	kf = list_first_entry(&rule->keyfields, struct vcap_client_keyfield,
+			      ctrl.list);
+	KUNIT_EXPECT_EQ(test, VCAP_KF_LOOKUP_FIRST_IS, kf->ctrl.key);
+	KUNIT_EXPECT_EQ(test, VCAP_FIELD_BIT, kf->ctrl.type);
+	KUNIT_EXPECT_EQ(test, 0x0, kf->data.u1.value);
+	KUNIT_EXPECT_EQ(test, 0x0, kf->data.u1.mask);
+
+	INIT_LIST_HEAD(&rule->keyfields);
+	ret = vcap_rule_add_key_u32(rule, VCAP_KF_TYPE, 0x98765432, 0xff00ffab);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = list_empty(&rule->keyfields);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	kf = list_first_entry(&rule->keyfields, struct vcap_client_keyfield,
+			      ctrl.list);
+	KUNIT_EXPECT_EQ(test, VCAP_KF_TYPE, kf->ctrl.key);
+	KUNIT_EXPECT_EQ(test, VCAP_FIELD_U32, kf->ctrl.type);
+	KUNIT_EXPECT_EQ(test, 0x98765432, kf->data.u32.value);
+	KUNIT_EXPECT_EQ(test, 0xff00ffab, kf->data.u32.mask);
+
+	INIT_LIST_HEAD(&rule->keyfields);
+	ret = vcap_rule_add_key_u128(rule, VCAP_KF_L3_IP6_SIP, &dip);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = list_empty(&rule->keyfields);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	kf = list_first_entry(&rule->keyfields, struct vcap_client_keyfield,
+			      ctrl.list);
+	KUNIT_EXPECT_EQ(test, VCAP_KF_L3_IP6_SIP, kf->ctrl.key);
+	KUNIT_EXPECT_EQ(test, VCAP_FIELD_U128, kf->ctrl.type);
+	for (idx = 0; idx < ARRAY_SIZE(dip.value); ++idx)
+		KUNIT_EXPECT_EQ(test, dip.value[idx], kf->data.u128.value[idx]);
+	for (idx = 0; idx < ARRAY_SIZE(dip.mask); ++idx)
+		KUNIT_EXPECT_EQ(test, dip.mask[idx], kf->data.u128.mask[idx]);
+}
+
+static void vcap_api_rule_add_actionvalue_test(struct kunit *test)
+{
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS2,
+	};
+	struct vcap_rule_internal ri = {
+		.admin = &admin,
+		.data = {
+			.actionset = VCAP_AFS_NO_VALUE,
+		},
+	};
+	struct vcap_rule *rule = (struct vcap_rule *)&ri;
+	struct vcap_client_actionfield *af;
+	int ret;
+
+	INIT_LIST_HEAD(&rule->actionfields);
+	ret = vcap_rule_add_action_bit(rule, VCAP_AF_POLICE_ENA, VCAP_BIT_0);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = list_empty(&rule->actionfields);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	af = list_first_entry(&rule->actionfields,
+			      struct vcap_client_actionfield, ctrl.list);
+	KUNIT_EXPECT_EQ(test, VCAP_AF_POLICE_ENA, af->ctrl.action);
+	KUNIT_EXPECT_EQ(test, VCAP_FIELD_BIT, af->ctrl.type);
+	KUNIT_EXPECT_EQ(test, 0x0, af->data.u1.value);
+
+	INIT_LIST_HEAD(&rule->actionfields);
+	ret = vcap_rule_add_action_bit(rule, VCAP_AF_POLICE_ENA, VCAP_BIT_1);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = list_empty(&rule->actionfields);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	af = list_first_entry(&rule->actionfields,
+			      struct vcap_client_actionfield, ctrl.list);
+	KUNIT_EXPECT_EQ(test, VCAP_AF_POLICE_ENA, af->ctrl.action);
+	KUNIT_EXPECT_EQ(test, VCAP_FIELD_BIT, af->ctrl.type);
+	KUNIT_EXPECT_EQ(test, 0x1, af->data.u1.value);
+
+	INIT_LIST_HEAD(&rule->actionfields);
+	ret = vcap_rule_add_action_bit(rule, VCAP_AF_POLICE_ENA, VCAP_BIT_ANY);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = list_empty(&rule->actionfields);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	af = list_first_entry(&rule->actionfields,
+			      struct vcap_client_actionfield, ctrl.list);
+	KUNIT_EXPECT_EQ(test, VCAP_AF_POLICE_ENA, af->ctrl.action);
+	KUNIT_EXPECT_EQ(test, VCAP_FIELD_BIT, af->ctrl.type);
+	KUNIT_EXPECT_EQ(test, 0x0, af->data.u1.value);
+
+	INIT_LIST_HEAD(&rule->actionfields);
+	ret = vcap_rule_add_action_u32(rule, VCAP_AF_TYPE, 0x98765432);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = list_empty(&rule->actionfields);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	af = list_first_entry(&rule->actionfields,
+			      struct vcap_client_actionfield, ctrl.list);
+	KUNIT_EXPECT_EQ(test, VCAP_AF_TYPE, af->ctrl.action);
+	KUNIT_EXPECT_EQ(test, VCAP_FIELD_U32, af->ctrl.type);
+	KUNIT_EXPECT_EQ(test, 0x98765432, af->data.u32.value);
+
+	INIT_LIST_HEAD(&rule->actionfields);
+	ret = vcap_rule_add_action_u32(rule, VCAP_AF_MASK_MODE, 0xaabbccdd);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = list_empty(&rule->actionfields);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	af = list_first_entry(&rule->actionfields,
+			      struct vcap_client_actionfield, ctrl.list);
+	KUNIT_EXPECT_EQ(test, VCAP_AF_MASK_MODE, af->ctrl.action);
+	KUNIT_EXPECT_EQ(test, VCAP_FIELD_U32, af->ctrl.type);
+	KUNIT_EXPECT_EQ(test, 0xaabbccdd, af->data.u32.value);
+}
+
+static void vcap_api_rule_find_keyset_basic_test(struct kunit *test)
+{
+	struct vcap_keyset_list matches = {};
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS2,
+	};
+	struct vcap_rule_internal ri = {
+		.admin = &admin,
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_client_keyfield ckf[] = {
+		{
+			.ctrl.key = VCAP_KF_TYPE,
+		}, {
+			.ctrl.key = VCAP_KF_LOOKUP_FIRST_IS,
+		}, {
+			.ctrl.key = VCAP_KF_IF_IGR_PORT_MASK_L3,
+		}, {
+			.ctrl.key = VCAP_KF_IF_IGR_PORT_MASK_RNG,
+		}, {
+			.ctrl.key = VCAP_KF_IF_IGR_PORT_MASK,
+		}, {
+			.ctrl.key = VCAP_KF_L2_DMAC,
+		}, {
+			.ctrl.key = VCAP_KF_ETYPE_LEN_IS,
+		}, {
+			.ctrl.key = VCAP_KF_ETYPE,
+		},
+	};
+	int idx;
+	bool ret;
+	enum vcap_keyfield_set keysets[10] = {};
+
+	matches.keysets = keysets;
+	matches.max = ARRAY_SIZE(keysets);
+
+	INIT_LIST_HEAD(&ri.data.keyfields);
+	for (idx = 0; idx < ARRAY_SIZE(ckf); idx++)
+		list_add_tail(&ckf[idx].ctrl.list, &ri.data.keyfields);
+
+	ret = vcap_rule_find_keysets(&ri, &matches);
+
+	KUNIT_EXPECT_EQ(test, true, ret);
+	KUNIT_EXPECT_EQ(test, 1, matches.cnt);
+	KUNIT_EXPECT_EQ(test, VCAP_KFS_MAC_ETYPE, matches.keysets[0]);
+}
+
+static void vcap_api_rule_find_keyset_failed_test(struct kunit *test)
+{
+	struct vcap_keyset_list matches = {};
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS2,
+	};
+	struct vcap_rule_internal ri = {
+		.admin = &admin,
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_client_keyfield ckf[] = {
+		{
+			.ctrl.key = VCAP_KF_TYPE,
+		}, {
+			.ctrl.key = VCAP_KF_LOOKUP_FIRST_IS,
+		}, {
+			.ctrl.key = VCAP_KF_ARP_OPCODE,
+		}, {
+			.ctrl.key = VCAP_KF_L3_IP4_SIP,
+		}, {
+			.ctrl.key = VCAP_KF_L3_IP4_DIP,
+		}, {
+			.ctrl.key = VCAP_KF_8021Q_PCP_CLS,
+		}, {
+			.ctrl.key = VCAP_KF_ETYPE_LEN_IS, /* Not with ARP */
+		}, {
+			.ctrl.key = VCAP_KF_ETYPE, /* Not with ARP */
+		},
+	};
+	int idx;
+	bool ret;
+	enum vcap_keyfield_set keysets[10] = {};
+
+	matches.keysets = keysets;
+	matches.max = ARRAY_SIZE(keysets);
+
+	INIT_LIST_HEAD(&ri.data.keyfields);
+	for (idx = 0; idx < ARRAY_SIZE(ckf); idx++)
+		list_add_tail(&ckf[idx].ctrl.list, &ri.data.keyfields);
+
+	ret = vcap_rule_find_keysets(&ri, &matches);
+
+	KUNIT_EXPECT_EQ(test, false, ret);
+	KUNIT_EXPECT_EQ(test, 0, matches.cnt);
+	KUNIT_EXPECT_EQ(test, VCAP_KFS_NO_VALUE, matches.keysets[0]);
+}
+
+static void vcap_api_rule_find_keyset_many_test(struct kunit *test)
+{
+	struct vcap_keyset_list matches = {};
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS2,
+	};
+	struct vcap_rule_internal ri = {
+		.admin = &admin,
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_client_keyfield ckf[] = {
+		{
+			.ctrl.key = VCAP_KF_TYPE,
+		}, {
+			.ctrl.key = VCAP_KF_LOOKUP_FIRST_IS,
+		}, {
+			.ctrl.key = VCAP_KF_8021Q_DEI_CLS,
+		}, {
+			.ctrl.key = VCAP_KF_8021Q_PCP_CLS,
+		}, {
+			.ctrl.key = VCAP_KF_8021Q_VID_CLS,
+		}, {
+			.ctrl.key = VCAP_KF_ISDX_CLS,
+		}, {
+			.ctrl.key = VCAP_KF_L2_MC_IS,
+		}, {
+			.ctrl.key = VCAP_KF_L2_BC_IS,
+		},
+	};
+	int idx;
+	bool ret;
+	enum vcap_keyfield_set keysets[10] = {};
+
+	matches.keysets = keysets;
+	matches.max = ARRAY_SIZE(keysets);
+
+	INIT_LIST_HEAD(&ri.data.keyfields);
+	for (idx = 0; idx < ARRAY_SIZE(ckf); idx++)
+		list_add_tail(&ckf[idx].ctrl.list, &ri.data.keyfields);
+
+	ret = vcap_rule_find_keysets(&ri, &matches);
+
+	KUNIT_EXPECT_EQ(test, true, ret);
+	KUNIT_EXPECT_EQ(test, 6, matches.cnt);
+	KUNIT_EXPECT_EQ(test, VCAP_KFS_ARP, matches.keysets[0]);
+	KUNIT_EXPECT_EQ(test, VCAP_KFS_IP4_OTHER, matches.keysets[1]);
+	KUNIT_EXPECT_EQ(test, VCAP_KFS_IP4_TCP_UDP, matches.keysets[2]);
+	KUNIT_EXPECT_EQ(test, VCAP_KFS_IP6_STD, matches.keysets[3]);
+	KUNIT_EXPECT_EQ(test, VCAP_KFS_IP_7TUPLE, matches.keysets[4]);
+	KUNIT_EXPECT_EQ(test, VCAP_KFS_MAC_ETYPE, matches.keysets[5]);
+}
+
+static void vcap_api_encode_rule_test(struct kunit *test)
+{
+	/* Data used by VCAP Library callback */
+	static u32 keydata[32] = {};
+	static u32 mskdata[32] = {};
+	static u32 actdata[32] = {};
+
+	struct vcap_admin is2_admin = {
+		.vtype = VCAP_TYPE_IS2,
+		.first_cid = 10000,
+		.last_cid = 19999,
+		.lookups = 4,
+		.last_valid_addr = 3071,
+		.first_valid_addr = 0,
+		.last_used_addr = 800,
+		.cache = {
+			.keystream = keydata,
+			.maskstream = mskdata,
+			.actionstream = actdata,
+		},
+	};
+	struct vcap_rule *rule = 0;
+	struct vcap_rule_internal *ri = 0;
+	int vcap_chain_id = 10005;
+	enum vcap_user user = VCAP_USER_VCAP_UTIL;
+	u16 priority = 10;
+	int id = 100;
+	int ret;
+	struct vcap_u48_key smac = {
+		.value = { 0x88, 0x75, 0x32, 0x34, 0x9e, 0xb1 },
+		.mask = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff }
+	};
+	struct vcap_u48_key dmac = {
+		.value = { 0x06, 0x05, 0x04, 0x03, 0x02, 0x01 },
+		.mask = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff }
+	};
+	u32 port_mask_rng_value = 0x05;
+	u32 port_mask_rng_mask = 0x0f;
+	u32 igr_port_mask_value = 0xffabcd01;
+	u32 igr_port_mask_mask = ~0;
+	/* counter is not written yet, so it is not in expwriteaddr */
+	u32 expwriteaddr[] = {792, 793, 794, 795, 796, 797, 0};
+	int idx;
+
+	vcap_test_api_init(&is2_admin);
+
+	/* Allocate the rule */
+	rule = vcap_alloc_rule(&test_vctrl, &test_netdev, vcap_chain_id, user,
+			       priority, id);
+	KUNIT_EXPECT_PTR_NE(test, NULL, rule);
+	ri = (struct vcap_rule_internal *)rule;
+
+	/* Add rule keys */
+	ret = vcap_rule_add_key_u48(rule, VCAP_KF_L2_DMAC, &dmac);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = vcap_rule_add_key_u48(rule, VCAP_KF_L2_SMAC, &smac);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = vcap_rule_add_key_bit(rule, VCAP_KF_ETYPE_LEN_IS, VCAP_BIT_1);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	/* Cannot add the same field twice */
+	ret = vcap_rule_add_key_bit(rule, VCAP_KF_ETYPE_LEN_IS, VCAP_BIT_1);
+	KUNIT_EXPECT_EQ(test, -EINVAL, ret);
+	ret = vcap_rule_add_key_bit(rule, VCAP_KF_IF_IGR_PORT_MASK_L3,
+				    VCAP_BIT_ANY);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = vcap_rule_add_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK_RNG,
+				    port_mask_rng_value, port_mask_rng_mask);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = vcap_rule_add_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK,
+				    igr_port_mask_value, igr_port_mask_mask);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	/* Add rule actions */
+	ret = vcap_rule_add_action_bit(rule, VCAP_AF_POLICE_ENA, VCAP_BIT_1);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = vcap_rule_add_action_u32(rule, VCAP_AF_CNT_ID, id);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = vcap_rule_add_action_u32(rule, VCAP_AF_MATCH_ID, 1);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	ret = vcap_rule_add_action_u32(rule, VCAP_AF_MATCH_ID_MASK, 1);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	/* For now the actionset is hardcoded */
+	ret = vcap_set_rule_set_actionset(rule, VCAP_AFS_BASE_TYPE);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	/* Validation with validate keyset callback */
+	ret = vcap_val_rule(rule, ETH_P_ALL);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, VCAP_KFS_MAC_ETYPE, rule->keyset);
+	KUNIT_EXPECT_EQ(test, VCAP_AFS_BASE_TYPE, rule->actionset);
+	KUNIT_EXPECT_EQ(test, 6, ri->size);
+	KUNIT_EXPECT_EQ(test, 2, ri->keyset_sw_regs);
+	KUNIT_EXPECT_EQ(test, 4, ri->actionset_sw_regs);
+
+	/* Add rule with write callback */
+	ret = vcap_add_rule(rule);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, 792, is2_admin.last_used_addr);
+	for (idx = 0; idx < ARRAY_SIZE(expwriteaddr); ++idx)
+		KUNIT_EXPECT_EQ(test, expwriteaddr[idx], test_updateaddr[idx]);
+
+	/* Check that the rule has been added */
+	ret = list_empty(&is2_admin.rules);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	vcap_free_rule(rule);
+
+	/* Check that the rule has been freed: tricky to access since this
+	 * memory should not be accessible anymore
+	 */
+	KUNIT_EXPECT_PTR_NE(test, NULL, rule);
+	ret = list_empty(&rule->keyfields);
+	KUNIT_EXPECT_EQ(test, true, ret);
+	ret = list_empty(&rule->actionfields);
+	KUNIT_EXPECT_EQ(test, true, ret);
+}
+
+static void vcap_api_next_lookup_basic_test(struct kunit *test)
+{
+	struct vcap_admin admin1 = {
+		.vtype = VCAP_TYPE_IS2,
+		.vinst = 0,
+		.first_cid = 8000000,
+		.last_cid = 8199999,
+		.lookups = 4,
+		.lookups_per_instance = 2,
+	};
+	struct vcap_admin admin2 = {
+		.vtype = VCAP_TYPE_IS2,
+		.vinst = 1,
+		.first_cid = 8200000,
+		.last_cid = 8399999,
+		.lookups = 4,
+		.lookups_per_instance = 2,
+	};
+	bool ret;
+
+	vcap_test_api_init(&admin1);
+	list_add_tail(&admin2.list, &test_vctrl.list);
+
+	ret = vcap_is_next_lookup(&test_vctrl, 8000000, 1001000);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 8000000, 8001000);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 8000000, 8101000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+
+	ret = vcap_is_next_lookup(&test_vctrl, 8100000, 8101000);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 8100000, 8201000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+
+	ret = vcap_is_next_lookup(&test_vctrl, 8200000, 8201000);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 8200000, 8301000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+
+	ret = vcap_is_next_lookup(&test_vctrl, 8300000, 8301000);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 8300000, 8401000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+}
+
+static void vcap_api_next_lookup_advanced_test(struct kunit *test)
+{
+	struct vcap_admin admin1 = {
+		.vtype = VCAP_TYPE_IS0,
+		.vinst = 0,
+		.first_cid = 1000000,
+		.last_cid =  1199999,
+		.lookups = 6,
+		.lookups_per_instance = 2,
+	};
+	struct vcap_admin admin2 = {
+		.vtype = VCAP_TYPE_IS0,
+		.vinst = 1,
+		.first_cid = 1200000,
+		.last_cid =  1399999,
+		.lookups = 6,
+		.lookups_per_instance = 2,
+	};
+	struct vcap_admin admin3 = {
+		.vtype = VCAP_TYPE_IS0,
+		.vinst = 2,
+		.first_cid = 1400000,
+		.last_cid =  1599999,
+		.lookups = 6,
+		.lookups_per_instance = 2,
+	};
+	struct vcap_admin admin4 = {
+		.vtype = VCAP_TYPE_IS2,
+		.vinst = 0,
+		.first_cid = 8000000,
+		.last_cid = 8199999,
+		.lookups = 4,
+		.lookups_per_instance = 2,
+	};
+	struct vcap_admin admin5 = {
+		.vtype = VCAP_TYPE_IS2,
+		.vinst = 1,
+		.first_cid = 8200000,
+		.last_cid = 8399999,
+		.lookups = 4,
+		.lookups_per_instance = 2,
+	};
+	bool ret;
+
+	vcap_test_api_init(&admin1);
+	list_add_tail(&admin2.list, &test_vctrl.list);
+	list_add_tail(&admin3.list, &test_vctrl.list);
+	list_add_tail(&admin4.list, &test_vctrl.list);
+	list_add_tail(&admin5.list, &test_vctrl.list);
+
+	ret = vcap_is_next_lookup(&test_vctrl, 1000000, 1001000);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 1000000, 1101000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+
+	ret = vcap_is_next_lookup(&test_vctrl, 1100000, 1201000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 1100000, 1301000);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 1100000, 8101000);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 1300000, 1401000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 1400000, 1501000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 1500000, 8001000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+
+	ret = vcap_is_next_lookup(&test_vctrl, 8000000, 8001000);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 8000000, 8101000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+
+	ret = vcap_is_next_lookup(&test_vctrl, 8300000, 8301000);
+	KUNIT_EXPECT_EQ(test, false, ret);
+	ret = vcap_is_next_lookup(&test_vctrl, 8300000, 8401000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+}
+
+static struct kunit_case vcap_api_support_test_cases[] = {
+	KUNIT_CASE(vcap_api_next_lookup_basic_test),
+	KUNIT_CASE(vcap_api_next_lookup_advanced_test),
+	{}
+};
+
+static struct kunit_suite vcap_api_support_test_suite = {
+	.name = "VCAP_API_Support_Testsuite",
+	.test_cases = vcap_api_support_test_cases,
+};
+
+static struct kunit_case vcap_api_full_rule_test_cases[] = {
+	KUNIT_CASE(vcap_api_rule_find_keyset_basic_test),
+	KUNIT_CASE(vcap_api_rule_find_keyset_failed_test),
+	KUNIT_CASE(vcap_api_rule_find_keyset_many_test),
+	KUNIT_CASE(vcap_api_encode_rule_test),
+	{}
+};
+
+static struct kunit_suite vcap_api_full_rule_test_suite = {
+	.name = "VCAP_API_Full_Rule_Testsuite",
+	.test_cases = vcap_api_full_rule_test_cases,
+};
+
+static struct kunit_case vcap_api_rule_value_test_cases[] = {
+	KUNIT_CASE(vcap_api_rule_add_keyvalue_test),
+	KUNIT_CASE(vcap_api_rule_add_actionvalue_test),
+	{}
+};
+
+static struct kunit_suite vcap_api_rule_value_test_suite = {
+	.name = "VCAP_API_Rule_Value_Testsuite",
+	.test_cases = vcap_api_rule_value_test_cases,
+};
+
 static struct kunit_case vcap_api_encoding_test_cases[] = {
 	KUNIT_CASE(vcap_api_set_bit_1_test),
 	KUNIT_CASE(vcap_api_set_bit_0_test),
@@ -930,4 +1519,7 @@ static struct kunit_suite vcap_api_encoding_test_suite = {
 	.test_cases = vcap_api_encoding_test_cases,
 };
 
+kunit_test_suite(vcap_api_support_test_suite);
+kunit_test_suite(vcap_api_full_rule_test_suite);
+kunit_test_suite(vcap_api_rule_value_test_suite);
 kunit_test_suite(vcap_api_encoding_test_suite);
-- 
2.38.1

