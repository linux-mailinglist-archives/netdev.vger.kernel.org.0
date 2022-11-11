Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80573625AF5
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 14:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbiKKNGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 08:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbiKKNGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 08:06:35 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8972B7F540;
        Fri, 11 Nov 2022 05:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668171962; x=1699707962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XdjhR+G7HM1WgN1AxkmCczlXrxvdXA0GR7XUV8yUGCE=;
  b=06eQtBOxJ5MKZr6aA5jUsLgJ1w1U4yotZNYyVn5NKy8KvC6qO8OyqW7h
   9TW5uY4ygn6+Ho1puH/1rMY+V7Yc/vBrcX9X8H66tqf9UPMLDv3tm49f2
   lvDaLdJRakWqLzZfoNsxcB2pTBtSYI3AuygkJrBUizVVL3wUin96arj8W
   banhxR6BJGs0oEgI89VpUGd/GOruYJOlOeau3ob/PC/zDSJLYocwfUKir
   rIVzyLnzffiC6f08Jmwnhht+yQ8ZKDk9K8F9ftKcccq3vH5RVufItEaP+
   OH58Ld9WIQ0BETo3QQkR6hLms0YpFgey4mcqVzGhmZrAe+DGJJibVa6cO
   g==;
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="123001319"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2022 06:06:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 11 Nov 2022 06:05:55 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 11 Nov 2022 06:05:51 -0700
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
Subject: [PATCH net-next 6/6] net: microchip: sparx5: Add KUNIT test of counters and sorted rules
Date:   Fri, 11 Nov 2022 14:05:19 +0100
Message-ID: <20221111130519.1459549-7-steen.hegelund@microchip.com>
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

This tests the insert, move and deleting of rules and checks that the
unused VCAP addresses are initialized correctly.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../ethernet/microchip/vcap/vcap_api_kunit.c  | 526 ++++++++++++++++++
 1 file changed, 526 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index b0ec51b37683..6858e44ce4a5 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -23,6 +23,9 @@ static u32 test_init_count;
 static u32 test_hw_counter_id;
 static struct vcap_cache_data test_hw_cache;
 static struct net_device test_netdev = {};
+static int test_move_addr;
+static int test_move_offset;
+static int test_move_count;
 
 /* Callback used by the VCAP API */
 static enum vcap_keyfield_set test_val_keyset(struct net_device *ndev,
@@ -195,6 +198,9 @@ static void test_cache_update(struct net_device *ndev, struct vcap_admin *admin,
 static void test_cache_move(struct net_device *ndev, struct vcap_admin *admin,
 			    u32 addr, int offset, int count)
 {
+	test_move_addr = addr;
+	test_move_offset = offset;
+	test_move_count = count;
 }
 
 /* Provide port information via a callback interface */
@@ -242,6 +248,88 @@ static void vcap_test_api_init(struct vcap_admin *admin)
 	test_updateaddridx = 0;
 }
 
+/* Helper function to create a rule of a specific size */
+static struct vcap_rule *
+test_vcap_xn_rule_creator(struct kunit *test, int cid, enum vcap_user user,
+			  u16 priority,
+			  int id, int size, int expected_addr)
+{
+	struct vcap_rule *rule = 0;
+	struct vcap_rule_internal *ri = 0;
+	enum vcap_keyfield_set keyset = VCAP_KFS_NO_VALUE;
+	enum vcap_actionfield_set actionset = VCAP_AFS_NO_VALUE;
+	int ret;
+
+	/* init before testing */
+	memset(test_updateaddr, 0, sizeof(test_updateaddr));
+	test_updateaddridx = 0;
+	test_move_addr = 0;
+	test_move_offset = 0;
+	test_move_count = 0;
+
+	switch (size) {
+	case 2:
+		keyset = VCAP_KFS_ETAG;
+		actionset = VCAP_AFS_CLASS_REDUCED;
+		break;
+	case 3:
+		keyset = VCAP_KFS_PURE_5TUPLE_IP4;
+		actionset = VCAP_AFS_CLASSIFICATION;
+		break;
+	case 6:
+		keyset = VCAP_KFS_NORMAL_5TUPLE_IP4;
+		actionset = VCAP_AFS_CLASSIFICATION;
+		break;
+	case 12:
+		keyset = VCAP_KFS_NORMAL_7TUPLE;
+		actionset = VCAP_AFS_FULL;
+		break;
+	default:
+		break;
+	}
+
+	/* Check that a valid size was used */
+	KUNIT_ASSERT_NE(test, VCAP_KFS_NO_VALUE, keyset);
+
+	/* Allocate the rule */
+	rule = vcap_alloc_rule(&test_vctrl, &test_netdev, cid, user, priority,
+			       id);
+	KUNIT_EXPECT_PTR_NE(test, NULL, rule);
+
+	ri = (struct vcap_rule_internal *)rule;
+
+	/* Override rule keyset */
+	ret = vcap_set_rule_set_keyset(rule, keyset);
+
+	/* Add rule actions : there must be at least one action */
+	ret = vcap_rule_add_action_u32(rule, VCAP_AF_COSID_VAL, 0);
+
+	/* Override rule actionset */
+	ret = vcap_set_rule_set_actionset(rule, actionset);
+
+	ret = vcap_val_rule(rule, ETH_P_ALL);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, keyset, rule->keyset);
+	KUNIT_EXPECT_EQ(test, actionset, rule->actionset);
+	KUNIT_EXPECT_EQ(test, size, ri->size);
+
+	/* Add rule with write callback */
+	ret = vcap_add_rule(rule);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, expected_addr, ri->addr);
+	return rule;
+}
+
+/* Prepare testing rule deletion */
+static void test_init_rule_deletion(void)
+{
+	test_move_addr = 0;
+	test_move_offset = 0;
+	test_move_count = 0;
+	test_init_start = 0;
+	test_init_count = 0;
+}
+
 /* Define the test cases. */
 
 static void vcap_api_set_bit_1_test(struct kunit *test)
@@ -1333,6 +1421,414 @@ static void vcap_api_encode_rule_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, true, ret);
 }
 
+static void vcap_api_set_rule_counter_test(struct kunit *test)
+{
+	struct vcap_admin is2_admin = {
+		.cache = {
+			.counter = 100,
+			.sticky = true,
+		},
+	};
+	struct vcap_rule_internal ri = {
+		.data = {
+			.id = 1001,
+		},
+		.addr = 600,
+		.admin = &is2_admin,
+		.counter_id = 1002,
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_rule_internal ri2 = {
+		.data = {
+			.id = 2001,
+		},
+		.addr = 700,
+		.admin = &is2_admin,
+		.counter_id = 2002,
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_counter ctr = { .value = 0, .sticky = false};
+	struct vcap_counter ctr2 = { .value = 101, .sticky = true};
+	int ret;
+
+	vcap_test_api_init(&is2_admin);
+	list_add_tail(&ri.list, &is2_admin.rules);
+	list_add_tail(&ri2.list, &is2_admin.rules);
+
+	pr_info("%s:%d\n", __func__, __LINE__);
+	ret = vcap_rule_set_counter(&ri.data, &ctr);
+	pr_info("%s:%d\n", __func__, __LINE__);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	KUNIT_EXPECT_EQ(test, 1002, test_hw_counter_id);
+	KUNIT_EXPECT_EQ(test, 0, test_hw_cache.counter);
+	KUNIT_EXPECT_EQ(test, false, test_hw_cache.sticky);
+	KUNIT_EXPECT_EQ(test, 600, test_updateaddr[0]);
+
+	ret = vcap_rule_set_counter(&ri2.data, &ctr2);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	KUNIT_EXPECT_EQ(test, 2002, test_hw_counter_id);
+	KUNIT_EXPECT_EQ(test, 101, test_hw_cache.counter);
+	KUNIT_EXPECT_EQ(test, true, test_hw_cache.sticky);
+	KUNIT_EXPECT_EQ(test, 700, test_updateaddr[1]);
+}
+
+static void vcap_api_get_rule_counter_test(struct kunit *test)
+{
+	struct vcap_admin is2_admin = {
+		.cache = {
+			.counter = 100,
+			.sticky = true,
+		},
+	};
+	struct vcap_rule_internal ri = {
+		.data = {
+			.id = 1010,
+		},
+		.addr = 400,
+		.admin = &is2_admin,
+		.counter_id = 1011,
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_rule_internal ri2 = {
+		.data = {
+			.id = 2011,
+		},
+		.addr = 300,
+		.admin = &is2_admin,
+		.counter_id = 2012,
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_counter ctr = {};
+	struct vcap_counter ctr2 = {};
+	int ret;
+
+	vcap_test_api_init(&is2_admin);
+	test_hw_cache.counter = 55;
+	test_hw_cache.sticky = true;
+
+	list_add_tail(&ri.list, &is2_admin.rules);
+	list_add_tail(&ri2.list, &is2_admin.rules);
+
+	ret = vcap_rule_get_counter(&ri.data, &ctr);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	KUNIT_EXPECT_EQ(test, 1011, test_hw_counter_id);
+	KUNIT_EXPECT_EQ(test, 55, ctr.value);
+	KUNIT_EXPECT_EQ(test, true, ctr.sticky);
+	KUNIT_EXPECT_EQ(test, 400, test_updateaddr[0]);
+
+	test_hw_cache.counter = 22;
+	test_hw_cache.sticky = false;
+
+	ret = vcap_rule_get_counter(&ri2.data, &ctr2);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	KUNIT_EXPECT_EQ(test, 2012, test_hw_counter_id);
+	KUNIT_EXPECT_EQ(test, 22, ctr2.value);
+	KUNIT_EXPECT_EQ(test, false, ctr2.sticky);
+	KUNIT_EXPECT_EQ(test, 300, test_updateaddr[1]);
+}
+
+static void vcap_api_rule_insert_in_order_test(struct kunit *test)
+{
+	/* Data used by VCAP Library callback */
+	static u32 keydata[32] = {};
+	static u32 mskdata[32] = {};
+	static u32 actdata[32] = {};
+
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS0,
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
+
+	vcap_test_api_init(&admin);
+
+	/* Create rules with different sizes and check that they are placed
+	 * at the correct address in the VCAP according to size
+	 */
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 10, 500, 12, 780);
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 20, 400, 6, 774);
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 30, 300, 3, 771);
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 40, 200, 2, 768);
+}
+
+static void vcap_api_rule_insert_reverse_order_test(struct kunit *test)
+{
+	/* Data used by VCAP Library callback */
+	static u32 keydata[32] = {};
+	static u32 mskdata[32] = {};
+	static u32 actdata[32] = {};
+
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS0,
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
+	struct vcap_rule_internal *elem;
+	u32 exp_addr[] = {780, 774, 771, 768, 767};
+	int idx;
+
+	vcap_test_api_init(&admin);
+
+	/* Create rules with different sizes and check that they are placed
+	 * at the correct address in the VCAP according to size
+	 */
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 20, 200, 2, 798);
+	KUNIT_EXPECT_EQ(test, 0, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 0, test_move_count);
+	KUNIT_EXPECT_EQ(test, 0, test_move_addr);
+
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 30, 300, 3, 795);
+	KUNIT_EXPECT_EQ(test, 6, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 3, test_move_count);
+	KUNIT_EXPECT_EQ(test, 798, test_move_addr);
+
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 40, 400, 6, 792);
+	KUNIT_EXPECT_EQ(test, 6, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 6, test_move_count);
+	KUNIT_EXPECT_EQ(test, 792, test_move_addr);
+
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 50, 500, 12, 780);
+	KUNIT_EXPECT_EQ(test, 18, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 12, test_move_count);
+	KUNIT_EXPECT_EQ(test, 786, test_move_addr);
+
+	idx = 0;
+	list_for_each_entry(elem, &admin.rules, list) {
+		KUNIT_EXPECT_EQ(test, exp_addr[idx], elem->addr);
+		++idx;
+	}
+	KUNIT_EXPECT_EQ(test, 768, admin.last_used_addr);
+}
+
+static void vcap_api_rule_remove_at_end_test(struct kunit *test)
+{
+	/* Data used by VCAP Library callback */
+	static u32 keydata[32] = {};
+	static u32 mskdata[32] = {};
+	static u32 actdata[32] = {};
+
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS0,
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
+	int ret;
+
+	vcap_test_api_init(&admin);
+	test_init_rule_deletion();
+
+	/* Create rules with different sizes and check that they are placed
+	 * at the correct address in the VCAP according to size
+	 */
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 10, 500, 12, 780);
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 20, 400, 6, 774);
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 30, 300, 3, 771);
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 40, 200, 2, 768);
+
+	/* Remove rules again from the end */
+	ret = vcap_del_rule(&test_vctrl, &test_netdev, 200);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, 0, test_move_addr);
+	KUNIT_EXPECT_EQ(test, 0, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 0, test_move_count);
+	KUNIT_EXPECT_EQ(test, 768, test_init_start);
+	KUNIT_EXPECT_EQ(test, 2, test_init_count);
+	KUNIT_EXPECT_EQ(test, 771, admin.last_used_addr);
+
+	ret = vcap_del_rule(&test_vctrl, &test_netdev, 300);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, 0, test_move_addr);
+	KUNIT_EXPECT_EQ(test, 0, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 0, test_move_count);
+	KUNIT_EXPECT_EQ(test, 771, test_init_start);
+	KUNIT_EXPECT_EQ(test, 3, test_init_count);
+	KUNIT_EXPECT_EQ(test, 774, admin.last_used_addr);
+
+	ret = vcap_del_rule(&test_vctrl, &test_netdev, 400);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, 0, test_move_addr);
+	KUNIT_EXPECT_EQ(test, 0, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 0, test_move_count);
+	KUNIT_EXPECT_EQ(test, 774, test_init_start);
+	KUNIT_EXPECT_EQ(test, 6, test_init_count);
+	KUNIT_EXPECT_EQ(test, 780, admin.last_used_addr);
+
+	ret = vcap_del_rule(&test_vctrl, &test_netdev, 500);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, 0, test_move_addr);
+	KUNIT_EXPECT_EQ(test, 0, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 0, test_move_count);
+	KUNIT_EXPECT_EQ(test, 780, test_init_start);
+	KUNIT_EXPECT_EQ(test, 12, test_init_count);
+	KUNIT_EXPECT_EQ(test, 3071, admin.last_used_addr);
+}
+
+static void vcap_api_rule_remove_in_middle_test(struct kunit *test)
+{
+	/* Data used by VCAP Library callback */
+	static u32 keydata[32] = {};
+	static u32 mskdata[32] = {};
+	static u32 actdata[32] = {};
+
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS0,
+		.first_cid = 10000,
+		.last_cid = 19999,
+		.lookups = 4,
+		.first_valid_addr = 0,
+		.last_used_addr = 800,
+		.last_valid_addr = 800 - 1,
+		.cache = {
+			.keystream = keydata,
+			.maskstream = mskdata,
+			.actionstream = actdata,
+		},
+	};
+	int ret;
+
+	vcap_test_api_init(&admin);
+
+	/* Create rules with different sizes and check that they are placed
+	 * at the correct address in the VCAP according to size
+	 */
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 10, 500, 12, 780);
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 20, 400, 6, 774);
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 30, 300, 3, 771);
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 40, 200, 2, 768);
+
+	/* Remove rules in the middle */
+	test_init_rule_deletion();
+	ret = vcap_del_rule(&test_vctrl, &test_netdev, 400);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, 768, test_move_addr);
+	KUNIT_EXPECT_EQ(test, -6, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 6, test_move_count);
+	KUNIT_EXPECT_EQ(test, 768, test_init_start);
+	KUNIT_EXPECT_EQ(test, 6, test_init_count);
+	KUNIT_EXPECT_EQ(test, 774, admin.last_used_addr);
+
+	test_init_rule_deletion();
+	ret = vcap_del_rule(&test_vctrl, &test_netdev, 300);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, 774, test_move_addr);
+	KUNIT_EXPECT_EQ(test, -4, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 2, test_move_count);
+	KUNIT_EXPECT_EQ(test, 774, test_init_start);
+	KUNIT_EXPECT_EQ(test, 4, test_init_count);
+	KUNIT_EXPECT_EQ(test, 778, admin.last_used_addr);
+
+	test_init_rule_deletion();
+	ret = vcap_del_rule(&test_vctrl, &test_netdev, 500);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, 778, test_move_addr);
+	KUNIT_EXPECT_EQ(test, -20, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 2, test_move_count);
+	KUNIT_EXPECT_EQ(test, 778, test_init_start);
+	KUNIT_EXPECT_EQ(test, 20, test_init_count);
+	KUNIT_EXPECT_EQ(test, 798, admin.last_used_addr);
+
+	test_init_rule_deletion();
+	ret = vcap_del_rule(&test_vctrl, &test_netdev, 200);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, 0, test_move_addr);
+	KUNIT_EXPECT_EQ(test, 0, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 0, test_move_count);
+	KUNIT_EXPECT_EQ(test, 798, test_init_start);
+	KUNIT_EXPECT_EQ(test, 2, test_init_count);
+	KUNIT_EXPECT_EQ(test, 799, admin.last_used_addr);
+}
+
+static void vcap_api_rule_remove_in_front_test(struct kunit *test)
+{
+	/* Data used by VCAP Library callback */
+	static u32 keydata[32] = {};
+	static u32 mskdata[32] = {};
+	static u32 actdata[32] = {};
+
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS0,
+		.first_cid = 10000,
+		.last_cid = 19999,
+		.lookups = 4,
+		.first_valid_addr = 0,
+		.last_used_addr = 800,
+		.last_valid_addr = 800 - 1,
+		.cache = {
+			.keystream = keydata,
+			.maskstream = mskdata,
+			.actionstream = actdata,
+		},
+	};
+	int ret;
+
+	vcap_test_api_init(&admin);
+
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 10, 500, 12, 780);
+	KUNIT_EXPECT_EQ(test, 780, admin.last_used_addr);
+
+	test_init_rule_deletion();
+	ret = vcap_del_rule(&test_vctrl, &test_netdev, 500);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, 0, test_move_addr);
+	KUNIT_EXPECT_EQ(test, 0, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 0, test_move_count);
+	KUNIT_EXPECT_EQ(test, 780, test_init_start);
+	KUNIT_EXPECT_EQ(test, 12, test_init_count);
+	KUNIT_EXPECT_EQ(test, 799, admin.last_used_addr);
+
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 20, 400, 6, 792);
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 30, 300, 3, 789);
+	test_vcap_xn_rule_creator(test, 10000, VCAP_USER_QOS, 40, 200, 2, 786);
+
+	test_init_rule_deletion();
+	ret = vcap_del_rule(&test_vctrl, &test_netdev, 400);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, 786, test_move_addr);
+	KUNIT_EXPECT_EQ(test, -8, test_move_offset);
+	KUNIT_EXPECT_EQ(test, 6, test_move_count);
+	KUNIT_EXPECT_EQ(test, 786, test_init_start);
+	KUNIT_EXPECT_EQ(test, 8, test_init_count);
+	KUNIT_EXPECT_EQ(test, 794, admin.last_used_addr);
+}
+
+static struct kunit_case vcap_api_rule_remove_test_cases[] = {
+	KUNIT_CASE(vcap_api_rule_remove_at_end_test),
+	KUNIT_CASE(vcap_api_rule_remove_in_middle_test),
+	KUNIT_CASE(vcap_api_rule_remove_in_front_test),
+	{}
+};
+
 static void vcap_api_next_lookup_basic_test(struct kunit *test)
 {
 	struct vcap_admin admin1 = {
@@ -1458,6 +1954,33 @@ static void vcap_api_next_lookup_advanced_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, true, ret);
 }
 
+static struct kunit_suite vcap_api_rule_remove_test_suite = {
+	.name = "VCAP_API_Rule_Remove_Testsuite",
+	.test_cases = vcap_api_rule_remove_test_cases,
+};
+
+static struct kunit_case vcap_api_rule_insert_test_cases[] = {
+	KUNIT_CASE(vcap_api_rule_insert_in_order_test),
+	KUNIT_CASE(vcap_api_rule_insert_reverse_order_test),
+	{}
+};
+
+static struct kunit_suite vcap_api_rule_insert_test_suite = {
+	.name = "VCAP_API_Rule_Insert_Testsuite",
+	.test_cases = vcap_api_rule_insert_test_cases,
+};
+
+static struct kunit_case vcap_api_rule_counter_test_cases[] = {
+	KUNIT_CASE(vcap_api_set_rule_counter_test),
+	KUNIT_CASE(vcap_api_get_rule_counter_test),
+	{}
+};
+
+static struct kunit_suite vcap_api_rule_counter_test_suite = {
+	.name = "VCAP_API_Rule_Counter_Testsuite",
+	.test_cases = vcap_api_rule_counter_test_cases,
+};
+
 static struct kunit_case vcap_api_support_test_cases[] = {
 	KUNIT_CASE(vcap_api_next_lookup_basic_test),
 	KUNIT_CASE(vcap_api_next_lookup_advanced_test),
@@ -1519,6 +2042,9 @@ static struct kunit_suite vcap_api_encoding_test_suite = {
 	.test_cases = vcap_api_encoding_test_cases,
 };
 
+kunit_test_suite(vcap_api_rule_remove_test_suite);
+kunit_test_suite(vcap_api_rule_insert_test_suite);
+kunit_test_suite(vcap_api_rule_counter_test_suite);
 kunit_test_suite(vcap_api_support_test_suite);
 kunit_test_suite(vcap_api_full_rule_test_suite);
 kunit_test_suite(vcap_api_rule_value_test_suite);
-- 
2.38.1

