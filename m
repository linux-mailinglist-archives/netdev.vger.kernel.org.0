Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11B368D466
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjBGKgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjBGKgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:36:25 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44EF1631A;
        Tue,  7 Feb 2023 02:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675766168; x=1707302168;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vHSNyiO3uCWRDlOQR/JIYZQw91VFBIfdjH2VDsE2OzU=;
  b=ZaNO8ihyb2R69vsaUGExQwOajpNuZTdxCH2LtosHKHJ+68zPq2/WNikQ
   LKDvr+9uEnwAc1c6/lblIXVFCDvW3BxA9eABzcTf78OhT4k1ARAgyOn2p
   eU0RTp48FY63a82K+D4+mXU5IL9POdLQGmpqzLbpXQf0juJwGgM7IGf3v
   OJuEvRYMlcZJfCp1ooryQU2fBDgQY1fFrmfiE7fx0KByDaCHqD9v84zFg
   Hawj8GpkFJEJcKdm6lUPqno0TPNSzSVyHEEo0Jvwnle4IqswTmdek/e8W
   Qo1vRskChTjBLHXqpmjQtMpXb/8Wv5ypaB11DT3QYW5J6f1wTn6a73uku
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669100400"; 
   d="scan'208";a="135924608"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2023 03:36:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 03:36:07 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 03:36:05 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2] net: lan966x: Add support for TC flower filter statistics
Date:   Tue, 7 Feb 2023 11:35:49 +0100
Message-ID: <20230207103549.1273592-1-horatiu.vultur@microchip.com>
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
v1->v2:
- use {} to initialize count instead of memset
---
 .../microchip/lan966x/lan966x_tc_flower.c     | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
index 88c655d6318fa..1e464bb804ae0 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
@@ -234,6 +234,24 @@ static int lan966x_tc_flower_del(struct lan966x_port *port,
 	return err;
 }
 
+static int lan966x_tc_flower_stats(struct lan966x_port *port,
+				   struct flow_cls_offload *f,
+				   struct vcap_admin *admin)
+{
+	struct vcap_counter count = {};
+	int err;
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
@@ -252,6 +270,8 @@ int lan966x_tc_flower(struct lan966x_port *port,
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

