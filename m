Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90558622AC5
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiKILlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiKILlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:41:39 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8247D2E9F8;
        Wed,  9 Nov 2022 03:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667994095; x=1699530095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zg1ZOB9VAKT8wYILwCnjHS5DdA5dyjtXwq8br0fWHdo=;
  b=rKT7aekojRocC4YtKUAryk08JT75RnMpgcIjVNipp9BHPNMR7s9TZlhx
   VUUpDRgwy1sivVintA2oROsRjnlEZG4U/S1SRuefLuv8C+qfl8DygyLPc
   axbuQVfEY1SDL+SIOQVV7mFCpJ+eP/7Ziy7zq3bjmX79drY+fnyjawWkX
   +ERyNs4viYcMiw6eShyMJU4Hm0uZNZTudzTtc/CLDVhP+blsNLHlQhg6b
   CwGZk12cWY/B7nWy+VpAs+bORQoUywjrlDadP6gytKajIXRZeuzWp2Ied
   J49dCGuYqcLmfP5bqG8q3gGbGbr/k6gilmYa9LsKe6NE6aJnGhJbIasyC
   w==;
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="186099239"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Nov 2022 04:41:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 9 Nov 2022 04:41:33 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 9 Nov 2022 04:41:29 -0700
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
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v6 3/8] net: microchip: sparx5: Find VCAP lookup from chain id
Date:   Wed, 9 Nov 2022 12:41:11 +0100
Message-ID: <20221109114116.3612477-4-steen.hegelund@microchip.com>
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

Add a helper function that finds the lookup index in a VCAP instance from
the chain id.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api.c  | 17 +++++++++++++++++
 .../ethernet/microchip/vcap/vcap_api_client.h   |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index ace2582d8552..d5b62e43d83f 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -644,6 +644,23 @@ static int vcap_write_rule(struct vcap_rule_internal *ri)
 	return 0;
 }
 
+/* Convert a chain id to a VCAP lookup index */
+int vcap_chain_id_to_lookup(struct vcap_admin *admin, int cur_cid)
+{
+	int lookup_first = admin->vinst * admin->lookups_per_instance;
+	int lookup_last = lookup_first + admin->lookups_per_instance;
+	int cid_next = admin->first_cid + VCAP_CID_LOOKUP_SIZE;
+	int cid = admin->first_cid;
+	int lookup;
+
+	for (lookup = lookup_first; lookup < lookup_last; ++lookup,
+	     cid += VCAP_CID_LOOKUP_SIZE, cid_next += VCAP_CID_LOOKUP_SIZE)
+		if (cur_cid >= cid && cur_cid < cid_next)
+			return lookup;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vcap_chain_id_to_lookup);
+
 /* Lookup a vcap instance using chain id */
 struct vcap_admin *vcap_find_admin(struct vcap_control *vctrl, int cid)
 {
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 577395402a9a..7d9a227ef834 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -184,6 +184,8 @@ int vcap_rule_add_action_u32(struct vcap_rule *rule,
 			     enum vcap_action_field action, u32 value);
 
 /* VCAP lookup operations */
+/* Convert a chain id to a VCAP lookup index */
+int vcap_chain_id_to_lookup(struct vcap_admin *admin, int cur_cid);
 /* Lookup a vcap instance using chain id */
 struct vcap_admin *vcap_find_admin(struct vcap_control *vctrl, int cid);
 /* Find information on a key field in a rule */
-- 
2.38.1

