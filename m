Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632F3689ADD
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbjBCN6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbjBCN6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:58:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EB6367C2;
        Fri,  3 Feb 2023 05:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675432526; x=1706968526;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rIIg/IhlSVLPsYHvAR3Cvku2ssnOgIgRQx10yRFmoAM=;
  b=eril3ttfAskTZId75yc/tIeuE34nAsg0iovXXl1grp+NVn6AtoiA2H7Q
   w3VcQNbDh+hmvsKP1wBF+SPwiB6ziM/7Tp2Nx7svC6Uor9qjr8Kis82Wu
   a+nTh+NNHQ16PBSNDEbsW+ujS8J7AvDotDb/weckVOg7rwOtxAlwH5OXh
   FqjnVZfXJNAhK2RHTPKIUigDZWJ5dXvLu54Gk9PW3rPiOXbOz28mTghMl
   kjg1GIifEN6SsIRPOna5d40Jlw+QjC66DckQ3jxtrP27cIUA+Qmel5v1m
   XMnk/sF8qNbuWPwHKFwvJabeP86UKJFlYavQY6tGWBk9R3ahd+m3WlYWP
   A==;
X-IronPort-AV: E=Sophos;i="5.97,270,1669100400"; 
   d="scan'208";a="195249582"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2023 06:54:07 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 06:53:57 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 06:53:56 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Add support for TC flower filter statistics
Date:   Fri, 3 Feb 2023 14:53:49 +0100
Message-ID: <20230203135349.547933-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
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

Add flower filter packet statistics. This will just read the TCAM
counter of the rule, which mention how many packages were hit by this
rule.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_tc_flower.c     | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
index 88c655d6318fa..aac3d7c87f1d5 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
@@ -234,6 +234,26 @@ static int lan966x_tc_flower_del(struct lan966x_port *port,
 	return err;
 }
 
+static int lan966x_tc_flower_stats(struct lan966x_port *port,
+				   struct flow_cls_offload *f,
+				   struct vcap_admin *admin)
+{
+	struct vcap_counter count;
+	int err;
+
+	memset(&count, 0, sizeof(count));
+
+	err = vcap_get_rule_count_by_cookie(port->lan966x->vcap_ctrl,
+					    &count, f->cookie);
+	if (err)
+		return err;
+
+	flow_stats_update(&f->stats, 0x0, count.value, 0, 0,
+			  FLOW_ACTION_HW_STATS_IMMEDIATE);
+
+	return err;
+}
+
 int lan966x_tc_flower(struct lan966x_port *port,
 		      struct flow_cls_offload *f,
 		      bool ingress)
@@ -252,6 +272,8 @@ int lan966x_tc_flower(struct lan966x_port *port,
 		return lan966x_tc_flower_add(port, f, admin, ingress);
 	case FLOW_CLS_DESTROY:
 		return lan966x_tc_flower_del(port, f, admin);
+	case FLOW_CLS_STATS:
+		return lan966x_tc_flower_stats(port, f, admin);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.38.0

