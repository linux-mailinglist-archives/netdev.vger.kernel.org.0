Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44E765E680
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjAEIN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjAEINy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:13:54 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72385830B;
        Thu,  5 Jan 2023 00:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672906433; x=1704442433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Jn6Qh4EKzF9+AlWQ2VgROJSkdvNeDO0+z00VKMoS2gg=;
  b=fHQtNJN+Yae5vXnU+22lV6NcjVPAR5cvnfe1QYm7c5KDg1WB0xlhnf9x
   0TIwpqYbPiIICVx/u7A6gjytlYF84XjroBBQrtkcRWf6p2mYd2yVjcfH/
   8A+1J2rXp4g1R7+10nhoZKJCdjGNS2UMfi9P95LUBoocjCjn5dnMnzDSg
   0zCLEyH7SeADRbv8W4A6nxi3RDHmdkIZkgJaC/nVI4h9H0PjLqHOeUK+/
   v0/+1P64fArv0qzTHjTC/a6aek+M9j3Wh672PxvVJfr0+2koCXInF6YtJ
   2jzvb5rlKgqHW0ifUp2ZRBpUiAZtXKNv1eQmKmtZif5x0CVG+PhBxP0Md
   w==;
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="190835952"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jan 2023 01:13:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 01:13:49 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 01:13:46 -0700
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
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH net-next 2/8] net: microchip: sparx5: Reset VCAP counter for new rules
Date:   Thu, 5 Jan 2023 09:13:29 +0100
Message-ID: <20230105081335.1261636-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105081335.1261636-1-steen.hegelund@microchip.com>
References: <20230105081335.1261636-1-steen.hegelund@microchip.com>
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

When a rule counter is external to the VCAP such as the Sparx5 IS2 counters
are, then this counter must be reset when a new rule is created.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api.c       | 3 +++
 drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index b9b6432f4094..67e0a3d9103a 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1808,6 +1808,7 @@ int vcap_add_rule(struct vcap_rule *rule)
 {
 	struct vcap_rule_internal *ri = to_intrule(rule);
 	struct vcap_rule_move move = {0};
+	struct vcap_counter ctr = {0};
 	int ret;
 
 	ret = vcap_api_check(ri->vctrl);
@@ -1833,6 +1834,8 @@ int vcap_add_rule(struct vcap_rule *rule)
 	ret = vcap_write_rule(ri);
 	if (ret)
 		pr_err("%s:%d: rule write error: %d\n", __func__, __LINE__, ret);
+	/* Set the counter to zero */
+	ret = vcap_write_counter(ri, &ctr);
 out:
 	mutex_unlock(&ri->admin->lock);
 	return ret;
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index 76a31215ebfb..944de5cb9114 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -1343,8 +1343,8 @@ static void vcap_api_encode_rule_test(struct kunit *test)
 	u32 port_mask_rng_mask = 0x0f;
 	u32 igr_port_mask_value = 0xffabcd01;
 	u32 igr_port_mask_mask = ~0;
-	/* counter is not written yet, so it is not in expwriteaddr */
-	u32 expwriteaddr[] = {792, 793, 794, 795, 796, 797, 0};
+	/* counter is written as the last operation */
+	u32 expwriteaddr[] = {792, 793, 794, 795, 796, 797, 792};
 	int idx;
 
 	vcap_test_api_init(&is2_admin);
-- 
2.39.0

