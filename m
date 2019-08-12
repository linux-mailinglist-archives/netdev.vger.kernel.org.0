Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAA389BD1
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfHLKpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:45:54 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36728 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727691AbfHLKpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 06:45:50 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 00969200084;
        Mon, 12 Aug 2019 12:45:49 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5028320064C;
        Mon, 12 Aug 2019 12:45:46 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id A7464402D2;
        Mon, 12 Aug 2019 18:45:42 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 2/3] ocelot_ace: fix ingress ports setting for rule
Date:   Mon, 12 Aug 2019 18:48:26 +0800
Message-Id: <20190812104827.5935-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190812104827.5935-1-yangbo.lu@nxp.com>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ingress ports setting of rule should support covering all ports.
This patch is to use u16 ingress_port for ingress port mask setting
for ace rule. One bit corresponds one port.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c    | 2 +-
 drivers/net/ethernet/mscc/ocelot_ace.h    | 2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 5580a58..91250f3 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -352,7 +352,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	data.type = IS2_ACTION_TYPE_NORMAL;
 
 	VCAP_KEY_ANY_SET(PAG);
-	VCAP_KEY_SET(IGR_PORT_MASK, 0, ~BIT(ace->chip_port));
+	VCAP_KEY_SET(IGR_PORT_MASK, 0, ~ace->ingress_port);
 	VCAP_KEY_BIT_SET(FIRST, OCELOT_VCAP_BIT_1);
 	VCAP_KEY_BIT_SET(HOST_MATCH, OCELOT_VCAP_BIT_ANY);
 	VCAP_KEY_BIT_SET(L2_MC, ace->dmac_mc);
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index ce72f02..0fe23e0 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -193,7 +193,7 @@ struct ocelot_ace_rule {
 
 	enum ocelot_ace_action action;
 	struct ocelot_ace_stats stats;
-	int chip_port;
+	u16 ingress_port;
 
 	enum ocelot_vcap_bit dmac_mc;
 	enum ocelot_vcap_bit dmac_bc;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 7c60e8c..bfddc50 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -184,7 +184,7 @@ struct ocelot_ace_rule *ocelot_ace_rule_create(struct flow_cls_offload *f,
 		return NULL;
 
 	rule->ocelot = block->port->ocelot;
-	rule->chip_port = block->port->chip_port;
+	rule->ingress_port = BIT(block->port->chip_port);
 	return rule;
 }
 
-- 
2.7.4

