Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27CF929565
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390504AbfEXKGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:06:16 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:59927 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390330AbfEXKGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:06:14 -0400
X-Originating-IP: 90.88.147.134
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id BBE524001F;
        Fri, 24 May 2019 10:06:10 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 4/5] net: mvpp2: cls: Extract the RSS context when parsing the ethtool rule
Date:   Fri, 24 May 2019 12:05:53 +0200
Message-Id: <20190524100554.8606-5-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool_rx_flow_rule_create takes into parameter the ethtool flow spec,
which doesn't contain the rss context id. We therefore need to extract
it ourself before parsing the ethtool rule.

The FLOW_RSS flag is only set in info->fs.flow_type, and not
info->flow_type.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index c16e343ccbbf..c1a83e9cb80a 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1281,6 +1281,12 @@ int mvpp2_ethtool_cls_rule_ins(struct mvpp2_port *port,
 
 	input.fs = &info->fs;
 
+	/* We need to manually set the rss_ctx, since this info isn't present
+	 * in info->fs
+	 */
+	if (info->fs.flow_type & FLOW_RSS)
+		input.rss_ctx = info->rss_context;
+
 	ethtool_rule = ethtool_rx_flow_rule_create(&input);
 	if (IS_ERR(ethtool_rule)) {
 		ret = PTR_ERR(ethtool_rule);
-- 
2.20.1

