Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3586269A8BA
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjBQJ6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjBQJ63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:58:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD9D5D3F6;
        Fri, 17 Feb 2023 01:58:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1113BB829D4;
        Fri, 17 Feb 2023 09:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE47C433EF;
        Fri, 17 Feb 2023 09:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676627898;
        bh=E6nFewQMaVlGYl0OfOEuXN1Fg79X7FB9WqZzgH27jnQ=;
        h=From:To:Cc:Subject:Date:From;
        b=dRiFspviTHdLJZOlwy02XZiK6KGyDDBd6YJmpjSdfbmeAMqoy0fkJZEjcpYJyzuFY
         BQs/WoIftectoCh1PA0a0u9V6bg2PpEATkiSdmXtvEYtRwd6U6RLM0ttxj+CMCkXtl
         +8KA8DyjJxWc7it8soU7OyrxsrZsrnBsrOudIUur3sG+x3OPI0iTUr39Fea9IH+o9X
         BEumZ3IJFprNDZ6TX1v1oiC4J0s1+NAKa44y5uK7yx+depJDQn76uHV4q35NAo+0Vh
         Aw4AxhpqHrqkbUHFUyH4+HYUepp27CBhFYLPgTCyt2z068yqYjvrdi612DxOx/ijOv
         aDvBwLANJbspg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: microchip: sparx5: reduce stack usage
Date:   Fri, 17 Feb 2023 10:58:06 +0100
Message-Id: <20230217095815.2407377-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The vcap_admin structures in vcap_api_next_lookup_advanced_test()
take several hundred bytes of stack frame, but when CONFIG_KASAN_STACK
is enabled, each one of them also has extra padding before and after
it, which ends up blowing the warning limit:

In file included from drivers/net/ethernet/microchip/vcap/vcap_api.c:3521:
drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c: In function 'vcap_api_next_lookup_advanced_test':
drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:1954:1: error: the frame size of 1448 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]
 1954 | }

Reduce the total stack usage by replacing the five structures with
an array that only needs one pair of padding areas.

Fixes: 1f741f001160 ("net: microchip: sparx5: Add KUNIT tests for enabling/disabling chains")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../ethernet/microchip/vcap/vcap_api_kunit.c  | 26 +++++++++----------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index 0a1d4d740567..c07f25e791c7 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -1876,53 +1876,51 @@ static void vcap_api_next_lookup_basic_test(struct kunit *test)
 
 static void vcap_api_next_lookup_advanced_test(struct kunit *test)
 {
-	struct vcap_admin admin1 = {
+	struct vcap_admin admin[] = {
+	{
 		.vtype = VCAP_TYPE_IS0,
 		.vinst = 0,
 		.first_cid = 1000000,
 		.last_cid =  1199999,
 		.lookups = 6,
 		.lookups_per_instance = 2,
-	};
-	struct vcap_admin admin2 = {
+	}, {
 		.vtype = VCAP_TYPE_IS0,
 		.vinst = 1,
 		.first_cid = 1200000,
 		.last_cid =  1399999,
 		.lookups = 6,
 		.lookups_per_instance = 2,
-	};
-	struct vcap_admin admin3 = {
+	}, {
 		.vtype = VCAP_TYPE_IS0,
 		.vinst = 2,
 		.first_cid = 1400000,
 		.last_cid =  1599999,
 		.lookups = 6,
 		.lookups_per_instance = 2,
-	};
-	struct vcap_admin admin4 = {
+	}, {
 		.vtype = VCAP_TYPE_IS2,
 		.vinst = 0,
 		.first_cid = 8000000,
 		.last_cid = 8199999,
 		.lookups = 4,
 		.lookups_per_instance = 2,
-	};
-	struct vcap_admin admin5 = {
+	}, {
 		.vtype = VCAP_TYPE_IS2,
 		.vinst = 1,
 		.first_cid = 8200000,
 		.last_cid = 8399999,
 		.lookups = 4,
 		.lookups_per_instance = 2,
+	}
 	};
 	bool ret;
 
-	vcap_test_api_init(&admin1);
-	list_add_tail(&admin2.list, &test_vctrl.list);
-	list_add_tail(&admin3.list, &test_vctrl.list);
-	list_add_tail(&admin4.list, &test_vctrl.list);
-	list_add_tail(&admin5.list, &test_vctrl.list);
+	vcap_test_api_init(&admin[0]);
+	list_add_tail(&admin[1].list, &test_vctrl.list);
+	list_add_tail(&admin[2].list, &test_vctrl.list);
+	list_add_tail(&admin[3].list, &test_vctrl.list);
+	list_add_tail(&admin[4].list, &test_vctrl.list);
 
 	ret = vcap_is_next_lookup(&test_vctrl, 1000000, 1001000);
 	KUNIT_EXPECT_EQ(test, false, ret);
-- 
2.39.1

