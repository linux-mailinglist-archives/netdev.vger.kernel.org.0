Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0953B8ACDB
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 04:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfHMCtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 22:49:43 -0400
Received: from inva021.nxp.com ([92.121.34.21]:32804 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbfHMCtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 22:49:41 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A342020015A;
        Tue, 13 Aug 2019 04:49:39 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 93208200732;
        Tue, 13 Aug 2019 04:49:36 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 76AB940305;
        Tue, 13 Aug 2019 10:49:32 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v2, 4/4] ocelot: add VCAP IS2 rule to trap PTP Ethernet frames
Date:   Tue, 13 Aug 2019 10:52:14 +0800
Message-Id: <20190813025214.18601-5-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190813025214.18601-1-yangbo.lu@nxp.com>
References: <20190813025214.18601-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the PTP messages over Ethernet have etype 0x88f7 on them.
Use etype as the key to trap PTP messages.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Added this patch.
---
 drivers/net/ethernet/mscc/ocelot.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 6932e61..40f4e0d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1681,6 +1681,33 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 }
 EXPORT_SYMBOL(ocelot_probe_port);
 
+static int ocelot_ace_add_ptp_rule(struct ocelot *ocelot)
+{
+	struct ocelot_ace_rule *rule;
+
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule)
+		return -ENOMEM;
+
+	/* Entry for PTP over Ethernet (etype 0x88f7)
+	 * Action: trap to CPU port
+	 */
+	rule->ocelot = ocelot;
+	rule->prio = 1;
+	rule->type = OCELOT_ACE_TYPE_ETYPE;
+	/* Available on all ingress port except CPU port */
+	rule->ingress_port = ~BIT(ocelot->num_phys_ports);
+	rule->dmac_mc = OCELOT_VCAP_BIT_1;
+	rule->frame.etype.etype.value[0] = 0x88;
+	rule->frame.etype.etype.value[1] = 0xf7;
+	rule->frame.etype.etype.mask[0] = 0xff;
+	rule->frame.etype.etype.mask[1] = 0xff;
+	rule->action = OCELOT_ACL_ACTION_TRAP;
+
+	ocelot_ace_rule_offload_add(rule);
+	return 0;
+}
+
 int ocelot_init(struct ocelot *ocelot)
 {
 	u32 port;
@@ -1708,6 +1735,7 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
 	ocelot_ace_init(ocelot);
+	ocelot_ace_add_ptp_rule(ocelot);
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		/* Clear all counters (5 groups) */
-- 
2.7.4

