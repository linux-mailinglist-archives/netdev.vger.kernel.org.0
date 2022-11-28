Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3992663AACB
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbiK1OZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiK1OZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:25:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAC02AEF;
        Mon, 28 Nov 2022 06:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669645547; x=1701181547;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xfwC3aiQPGwe4e2msPr9Ryy3fEIzoLV82RQR4LmlxKU=;
  b=VMZeeZxHYn02vlRVMQqfSXS2k00/17rWEl2WsKDODQoMugG3haTEy/Ou
   AMDJSaH8brGpDmK8OanSbXo334VBrcUmMG5l3t0IbXvQ6cW4YyP4yHzQi
   oWj9aX6dBSeEO/zC3sTgHumk88NPwHf28Fx72NS9W78uL3fluej+thYQK
   HEZz97zNdriGZ8pykxhArHRo4tMxziGh2LLWJXzlT6t/3QJvv8fHI3B1a
   yz3MzQtuJPv4jO4m2F+caTOcojBqY0cQHocf9UJXHDeLUZd1ceTSxf8lU
   UXLOcyJzRcvI3MrU+2WQXRLGrPezVwxF0zzToD49C+qIVRNPoFW+G6j8A
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="188964067"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2022 07:25:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 28 Nov 2022 07:25:39 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 28 Nov 2022 07:25:37 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <casper.casan@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: microchip: vcap: Change how the rule id is generated
Date:   Mon, 28 Nov 2022 15:29:59 +0100
Message-ID: <20221128142959.8325-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
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

Currently whenever a new rule id is generated, it picks up the next
number bigger than previous id. So it would always be 1, 2, 3, etc.
When the rule with id 1 will be deleted and a new rule will be added,
it will have the id 4 and not id 1.
In theory this can be a problem if at some point a rule will be added
and removed ~0 times. Then no more rules can be added because there
are no more ids.

Change this such that when a new rule is added, search for an empty
rule id starting with value of 1 as value 0 is reserved.

Fixes: c9da1ac1c212 ("net: microchip: sparx5: Adding initial tc flower support for VCAP API")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api.c | 7 +------
 drivers/net/ethernet/microchip/vcap/vcap_api.h | 1 -
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index b50d002b646dc..b65819f3a927f 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -974,17 +974,12 @@ static u32 vcap_next_rule_addr(u32 addr, struct vcap_rule_internal *ri)
 /* Assign a unique rule id and autogenerate one if id == 0 */
 static u32 vcap_set_rule_id(struct vcap_rule_internal *ri)
 {
-	u32 next_id;
-
 	if (ri->data.id != 0)
 		return ri->data.id;
 
-	next_id = ri->vctrl->rule_id + 1;
-
-	for (next_id = ri->vctrl->rule_id + 1; next_id < ~0; ++next_id) {
+	for (u32 next_id = 1; next_id < ~0; ++next_id) {
 		if (!vcap_lookup_rule(ri->vctrl, next_id)) {
 			ri->data.id = next_id;
-			ri->vctrl->rule_id = next_id;
 			break;
 		}
 	}
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.h b/drivers/net/ethernet/microchip/vcap/vcap_api.h
index ca4499838306f..689c7270f2a89 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.h
@@ -268,7 +268,6 @@ struct vcap_operations {
 
 /* VCAP API Client control interface */
 struct vcap_control {
-	u32 rule_id; /* last used rule id (unique across VCAP instances) */
 	struct vcap_operations *ops;  /* client supplied operations */
 	const struct vcap_info *vcaps; /* client supplied vcap models */
 	const struct vcap_statistics *stats; /* client supplied vcap stats */
-- 
2.38.0

