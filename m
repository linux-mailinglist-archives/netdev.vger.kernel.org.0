Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A6A6940E5
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjBMJYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjBMJYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:24:47 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10061BDE6;
        Mon, 13 Feb 2023 01:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676280285; x=1707816285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fUqcEr8xiVVv9RpE+ICjO+IU3AQzgM8prfSvJBqKoi8=;
  b=Y4kir+J2lTpZpcK2gJj3fhJF9994owY3IsKNkTmnn7Jt61KN7KUzkqaP
   4CGpmFPEKwsUGiaXm6peYHgwuAUgm0V14Rmdy4Jhc0IgQE+pQm0ZBtTkj
   4W8xv4ywbpW2iAzTPHcOsQG2/wTc5qkWKS+yfIIDFZiluvIKidsNJTvwh
   lNIdmmLy47E541w4gX/ARUv/ghr5Qx5EyExAMSQJZLfitJJZcZPRWLhZm
   A0TWxLB2pB0bwn42LiXTk+zm9A0Nm96QbOkDoE0rLi5pG0Vb6nDe6jC/w
   GYhRYfc/FrLt5wEmEAx6rsLzKRYr7ksjqfiKRpJQjMs+4i2pa5sJEaTZu
   A==;
X-IronPort-AV: E=Sophos;i="5.97,293,1669100400"; 
   d="scan'208";a="136853329"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2023 02:24:45 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 02:24:43 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 02:24:39 -0700
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
Subject: [PATCH net-next 02/10] net: microchip: sparx5: Clear rule counter even if lookup is disabled
Date:   Mon, 13 Feb 2023 10:24:18 +0100
Message-ID: <20230213092426.1331379-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213092426.1331379-1-steen.hegelund@microchip.com>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
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

The rule counter must be cleared when creating a new rule, even if the VCAP
lookup is currently disabled.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api.c       | 7 +++++--
 drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c | 4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 6307d59f23da..68e04d47f6fd 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -2246,6 +2246,11 @@ int vcap_add_rule(struct vcap_rule *rule)
 	if (move.count > 0)
 		vcap_move_rules(ri, &move);
 
+	/* Set the counter to zero */
+	ret = vcap_write_counter(ri, &ctr);
+	if (ret)
+		goto out;
+
 	if (ri->state == VCAP_RS_DISABLED) {
 		/* Erase the rule area */
 		ri->vctrl->ops->init(ri->ndev, ri->admin, ri->addr, ri->size);
@@ -2264,8 +2269,6 @@ int vcap_add_rule(struct vcap_rule *rule)
 		pr_err("%s:%d: rule write error: %d\n", __func__, __LINE__, ret);
 		goto out;
 	}
-	/* Set the counter to zero */
-	ret = vcap_write_counter(ri, &ctr);
 out:
 	mutex_unlock(&ri->admin->lock);
 	return ret;
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index b2753aac8ad2..0a1d4d740567 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -1337,8 +1337,8 @@ static void vcap_api_encode_rule_test(struct kunit *test)
 	u32 port_mask_rng_mask = 0x0f;
 	u32 igr_port_mask_value = 0xffabcd01;
 	u32 igr_port_mask_mask = ~0;
-	/* counter is written as the last operation */
-	u32 expwriteaddr[] = {792, 793, 794, 795, 796, 797, 792};
+	/* counter is written as the first operation */
+	u32 expwriteaddr[] = {792, 792, 793, 794, 795, 796, 797};
 	int idx;
 
 	vcap_test_api_init(&is2_admin);
-- 
2.39.1

