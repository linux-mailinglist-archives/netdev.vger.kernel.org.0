Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D292785F
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 10:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbfEWIre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 04:47:34 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:58339 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfEWIrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 04:47:33 -0400
X-Originating-IP: 90.88.22.185
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-80-185.w90-88.abo.wanadoo.fr [90.88.22.185])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 309EC20008;
        Thu, 23 May 2019 08:47:22 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com
Subject: [PATCH net] net: mvpp2: cls: Fix leaked ethtool_rx_flow_rule
Date:   Thu, 23 May 2019 10:47:24 +0200
Message-Id: <20190523084724.14639-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flow_rule is only used when configuring the classification tables,
and should be free'd once we're done using it. The current code only
frees it in the error path.

Fixes: 90b509b39ac9 ("net: mvpp2: cls: Add Classification offload support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index d046f7a1dcf5..a57d17ab91f0 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1271,6 +1271,9 @@ int mvpp2_ethtool_cls_rule_ins(struct mvpp2_port *port,
 	if (ret)
 		goto clean_eth_rule;
 
+	ethtool_rx_flow_rule_destroy(ethtool_rule);
+	efs->rule.flow = NULL;
+
 	memcpy(&efs->rxnfc, info, sizeof(*info));
 	port->rfs_rules[efs->rule.loc] = efs;
 	port->n_rfs_rules++;
-- 
2.20.1

