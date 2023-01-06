Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C1265FD1A
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 09:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbjAFIxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 03:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjAFIxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 03:53:39 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CCA669A5;
        Fri,  6 Jan 2023 00:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672995218; x=1704531218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TlE8JkFNzlYrrSINYDLNdYw3yFo8m325dlUNlSj6BFw=;
  b=CCUkmILeSLxyywnitSO/BzVQWUVpXMDw2NLqihB0jDlvJnKW+Sp6/OLJ
   Ev5nj0T3S7krmJRl16ry+NpUfp6XOSeqBaYEurJH2rr6IxtdHIOWKkFga
   s9n+Z6aiBsELabVOsVR95f94nwZRGKsT+RuFeL3vy7UvusjkCJ1849uXV
   DPP+XjlIqEGyOV0/YNTaLO6YKTZN7qUU8qQ1Rdx1f28IlY++/zLMR2bZB
   f/DQJLziNtAip70sy6/cDXCeG0oYJRKuBUdByMRhm+sx9qpuW5TEB/5bN
   4ICXlVCKQo+lRJovrP6BIWiPuMpbfBaW+Pu3CzAb4CYX9A8soZize9a4y
   g==;
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="194562841"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jan 2023 01:53:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 01:53:35 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 01:53:32 -0700
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
Subject: [PATCH net-next v2 2/8] net: microchip: sparx5: Reset VCAP counter for new rules
Date:   Fri, 6 Jan 2023 09:53:11 +0100
Message-ID: <20230106085317.1720282-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230106085317.1720282-1-steen.hegelund@microchip.com>
References: <20230106085317.1720282-1-steen.hegelund@microchip.com>
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
 drivers/net/ethernet/microchip/vcap/vcap_api.c       | 7 ++++++-
 drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c | 4 ++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index b9b6432f4094..8bbbd1b0b552 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1808,6 +1808,7 @@ int vcap_add_rule(struct vcap_rule *rule)
 {
 	struct vcap_rule_internal *ri = to_intrule(rule);
 	struct vcap_rule_move move = {0};
+	struct vcap_counter ctr = {0};
 	int ret;
 
 	ret = vcap_api_check(ri->vctrl);
@@ -1831,8 +1832,12 @@ int vcap_add_rule(struct vcap_rule *rule)
 	}
 
 	ret = vcap_write_rule(ri);
-	if (ret)
+	if (ret) {
 		pr_err("%s:%d: rule write error: %d\n", __func__, __LINE__, ret);
+		goto out;
+	}
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

