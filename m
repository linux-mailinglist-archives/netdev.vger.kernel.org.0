Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D554A488
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbfFROza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:55:30 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:50303 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728881AbfFROz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:55:29 -0400
X-Originating-IP: 90.88.23.150
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 17D6D4000B;
        Tue, 18 Jun 2019 14:55:25 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 1/4] net: mvpp2: cls: Use a dedicated lu_type for the RSS lookup
Date:   Tue, 18 Jun 2019 16:55:16 +0200
Message-Id: <20190618145519.27705-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618145519.27705-1-maxime.chevallier@bootlin.com>
References: <20190618145519.27705-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When performing a TCAM lookup in the C2 engine, it's possible that
multiple entries match the packet. To make sure the correct entry match
when performing a lookup, the Flow Table can set a lookup type, which
will be used in the TCAM lookup, thus preventing such false-positives.

We need to make sure the RSS match doesn't interfere with other
classification lookups, hence we use a dedicated lookup_type for it.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 4 ++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index e47c00c5f829..8af13316ecb1 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -596,7 +596,7 @@ static void mvpp2_cls_flow_init(struct mvpp2 *priv,
 
 	mvpp2_cls_flow_eng_set(&fe, MVPP22_CLS_ENGINE_C2);
 	mvpp2_cls_flow_port_id_sel(&fe, true);
-	mvpp2_cls_flow_lu_type_set(&fe, MVPP22_FLOW_ETHERNET);
+	mvpp2_cls_flow_lu_type_set(&fe, MVPP22_CLS_LU_TYPE_ALL);
 
 	/* Add all ports */
 	for (i = 0; i < MVPP2_MAX_PORTS; i++)
@@ -861,7 +861,7 @@ static void mvpp2_port_c2_cls_init(struct mvpp2_port *port)
 
 	/* Match on Lookup Type */
 	c2.tcam[4] |= MVPP22_CLS_C2_TCAM_EN(MVPP22_CLS_C2_LU_TYPE(MVPP2_CLS_LU_TYPE_MASK));
-	c2.tcam[4] |= MVPP22_CLS_C2_LU_TYPE(MVPP22_FLOW_ETHERNET);
+	c2.tcam[4] |= MVPP22_CLS_C2_LU_TYPE(MVPP22_CLS_LU_TYPE_ALL);
 
 	/* Update RSS status after matching this entry */
 	c2.act = MVPP22_CLS_C2_ACT_RSS_EN(MVPP22_C2_UPD_LOCK);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
index 26cc1176e758..957f80b31743 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
@@ -180,6 +180,11 @@ enum mvpp2_prs_flow {
 /* LU Type defined for all engines, and specified in the flow table */
 #define MVPP2_CLS_LU_TYPE_MASK			0x3f
 
+enum mvpp2_cls_lu_type {
+	/* rule->loc is used as a lu-type for the entries 0 - 62. */
+	MVPP22_CLS_LU_TYPE_ALL = 63,
+};
+
 #define MVPP2_N_FLOWS		(MVPP2_FL_LAST - MVPP2_FL_START)
 
 struct mvpp2_cls_flow {
-- 
2.20.1

