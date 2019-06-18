Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99584A48B
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbfFROze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:55:34 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:55089 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729594AbfFROzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:55:32 -0400
X-Originating-IP: 90.88.23.150
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 5309240014;
        Tue, 18 Jun 2019 14:55:28 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 2/4] net: mvpp2: cls: Only select applicable flows of classification offload
Date:   Tue, 18 Jun 2019 16:55:17 +0200
Message-Id: <20190618145519.27705-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618145519.27705-1-maxime.chevallier@bootlin.com>
References: <20190618145519.27705-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The way we currently handle classification offload and RSS is by having
dedicated lookup sequences in the flow table, each being selected
depending on several fields being present in the packet header.

We need to make sure the classification operation we want to perform can
be done in each flow we want to insert it into. As an example,
classifying on VLAN tag can only be done on flows used for tagged
traffic.

This commit makes sure we don't insert rules in flows we aren't
compatible with.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 8af13316ecb1..7cd9d6da0319 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1201,6 +1201,9 @@ static int mvpp2_port_flt_rfs_rule_insert(struct mvpp2_port *port,
 		if (!flow)
 			return 0;
 
+		if ((rule->hek_fields & flow->supported_hash_opts) != rule->hek_fields)
+			continue;
+
 		index = MVPP2_CLS_FLT_C2_RFS(port->id, flow->flow_id, rule->loc);
 
 		mvpp2_cls_flow_read(priv, index, &fe);
-- 
2.20.1

