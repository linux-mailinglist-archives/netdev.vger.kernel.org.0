Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BD766D8E6
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbjAQI5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbjAQI4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:56:32 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB4410ABE;
        Tue, 17 Jan 2023 00:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673945772; x=1705481772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qQNh55ZgYhBc07wztLVkY1eS2Pi1LYlQR49lenb2Z8M=;
  b=JD1sTN5yeQN/UWlraeVKKZpD/TBSnMbmXVrXhlXo4tI+jGy5H0R3rnHt
   4njkp4u9GitCsWZ82Do+S5t3cLteAZoOb8mOQm+HUx2bjc0HFxaypOBvq
   w67rKW+kWN2UT1tG6kr4Oct1XXs6/Uwx5QqEMMJWMWleA3YS95GdexDuH
   sivZixqCowzTy/dSsUfRRwcYhUyHudOrx7QCv+d9P9mem/8OI6dDgo/w8
   Oc2K6Q4CxM3QVdHkq0hGL7GNgJouz2U/0OS7cFkdtz7KT5gZe50wYfcsQ
   gWbLkAgxggtbTfFisGSNfQXrWlSC2/D8q6hvotIURchyxpE8cwb4kSxn1
   g==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669100400"; 
   d="scan'208";a="208096731"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 01:56:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 01:56:09 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 01:56:06 -0700
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
Subject: [PATCH net-next 5/5] net: microchip: sparx5: Add lock initialization to the KUNIT tests
Date:   Tue, 17 Jan 2023 09:55:44 +0100
Message-ID: <20230117085544.591523-6-steen.hegelund@microchip.com>
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

Ensure that the KUNIT tests lock instance is initialized before the test is
executed.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c | 1 +
 drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
index 9211cb453a3d..cbf7e0f110b8 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
@@ -246,6 +246,7 @@ static void vcap_test_api_init(struct vcap_admin *admin)
 	INIT_LIST_HEAD(&admin->list);
 	INIT_LIST_HEAD(&admin->rules);
 	INIT_LIST_HEAD(&admin->enabled);
+	mutex_init(&admin->lock);
 	list_add_tail(&admin->list, &test_vctrl.list);
 	memset(test_updateaddr, 0, sizeof(test_updateaddr));
 	test_updateaddridx = 0;
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index 22690c669028..82981176218c 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -236,6 +236,7 @@ static void vcap_test_api_init(struct vcap_admin *admin)
 	INIT_LIST_HEAD(&admin->list);
 	INIT_LIST_HEAD(&admin->rules);
 	INIT_LIST_HEAD(&admin->enabled);
+	mutex_init(&admin->lock);
 	list_add_tail(&admin->list, &test_vctrl.list);
 	memset(test_updateaddr, 0, sizeof(test_updateaddr));
 	test_updateaddridx = 0;
-- 
2.39.0

