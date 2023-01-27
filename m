Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEE167E637
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbjA0NLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbjA0NKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:10:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1314C80FAC;
        Fri, 27 Jan 2023 05:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674824992; x=1706360992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rdMyTPDncd3MNKOu21c8aMfAJ7isk97ZKoRLQsOkhN0=;
  b=hsIigfLkq0hlClRdc/LzLvp45WmuTObc0favZteqwTgUohp2LJmA6FEV
   oW3j6ITgtliS7HLTBcx4tLWykzcBxM8pRQTBlfCOFZd7UhMpjIByaLTXe
   muUNUsTb3y6QId7ygEkGZfW8dToXemu9zcf5qxqUoIUmCsE9Ttzf8Jdnr
   UuuQXHdsb5inWiFwpwmhXx5vIPrx3es6LVlW0FFWbrRgyY1y5L9ToEl8g
   Ka1rA0X+E7z/jzOvjs2hJa6FsumtKa89oBo6ZwiGJwo/I330IKd4G4/AX
   Khg+cg7Q3xKFKy2mIKqBjx3v2quJxUTYtHrm29ZSna4UthaVRq0dW7qx6
   w==;
X-IronPort-AV: E=Sophos;i="5.97,251,1669100400"; 
   d="scan'208";a="134303314"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2023 06:09:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 06:09:27 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 06:09:22 -0700
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
Subject: [PATCH net-next 8/8] net: microchip: sparx5: Add  KUNIT tests for enabling/disabling chains
Date:   Fri, 27 Jan 2023 14:08:30 +0100
Message-ID: <20230127130830.1481526-9-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230127130830.1481526-1-steen.hegelund@microchip.com>
References: <20230127130830.1481526-1-steen.hegelund@microchip.com>
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

This enhances the KUNIT test of the VCAP API with tests of the chaining
functionality.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../ethernet/microchip/vcap/vcap_api_kunit.c  | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index a31cd08e3752..b2753aac8ad2 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -2145,6 +2145,71 @@ static void vcap_api_filter_keylist_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, 26, idx);
 }
 
+static void vcap_api_rule_chain_path_test(struct kunit *test)
+{
+	struct vcap_admin admin1 = {
+		.vtype = VCAP_TYPE_IS0,
+		.vinst = 0,
+		.first_cid = 1000000,
+		.last_cid =  1199999,
+		.lookups = 6,
+		.lookups_per_instance = 2,
+	};
+	struct vcap_enabled_port eport3 = {
+		.ndev = &test_netdev,
+		.cookie = 0x100,
+		.src_cid = 0,
+		.dst_cid = 1000000,
+	};
+	struct vcap_enabled_port eport2 = {
+		.ndev = &test_netdev,
+		.cookie = 0x200,
+		.src_cid = 1000000,
+		.dst_cid = 1100000,
+	};
+	struct vcap_enabled_port eport1 = {
+		.ndev = &test_netdev,
+		.cookie = 0x300,
+		.src_cid = 1100000,
+		.dst_cid = 8000000,
+	};
+	bool ret;
+	int chain;
+
+	vcap_test_api_init(&admin1);
+	list_add_tail(&eport1.list, &admin1.enabled);
+	list_add_tail(&eport2.list, &admin1.enabled);
+	list_add_tail(&eport3.list, &admin1.enabled);
+
+	ret = vcap_path_exist(&test_vctrl, &test_netdev, 1000000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+
+	ret = vcap_path_exist(&test_vctrl, &test_netdev, 1100000);
+	KUNIT_EXPECT_EQ(test, true, ret);
+
+	ret = vcap_path_exist(&test_vctrl, &test_netdev, 1200000);
+	KUNIT_EXPECT_EQ(test, false, ret);
+
+	chain = vcap_get_next_chain(&test_vctrl, &test_netdev, 0);
+	KUNIT_EXPECT_EQ(test, 1000000, chain);
+
+	chain = vcap_get_next_chain(&test_vctrl, &test_netdev, 1000000);
+	KUNIT_EXPECT_EQ(test, 1100000, chain);
+
+	chain = vcap_get_next_chain(&test_vctrl, &test_netdev, 1100000);
+	KUNIT_EXPECT_EQ(test, 8000000, chain);
+}
+
+static struct kunit_case vcap_api_rule_enable_test_cases[] = {
+	KUNIT_CASE(vcap_api_rule_chain_path_test),
+	{}
+};
+
+static struct kunit_suite vcap_api_rule_enable_test_suite = {
+	.name = "VCAP_API_Rule_Enable_Testsuite",
+	.test_cases = vcap_api_rule_enable_test_cases,
+};
+
 static struct kunit_suite vcap_api_rule_remove_test_suite = {
 	.name = "VCAP_API_Rule_Remove_Testsuite",
 	.test_cases = vcap_api_rule_remove_test_cases,
@@ -2235,6 +2300,7 @@ static struct kunit_suite vcap_api_encoding_test_suite = {
 	.test_cases = vcap_api_encoding_test_cases,
 };
 
+kunit_test_suite(vcap_api_rule_enable_test_suite);
 kunit_test_suite(vcap_api_rule_remove_test_suite);
 kunit_test_suite(vcap_api_rule_insert_test_suite);
 kunit_test_suite(vcap_api_rule_counter_test_suite);
-- 
2.39.1

