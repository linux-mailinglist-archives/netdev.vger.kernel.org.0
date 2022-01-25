Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB0749B3C1
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 13:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444545AbiAYMRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 07:17:17 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:42567 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358563AbiAYMOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 07:14:44 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3059A10000E;
        Tue, 25 Jan 2022 12:14:30 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan v3 1/6] net: ieee802154: hwsim: Ensure proper channel selection at probe time
Date:   Tue, 25 Jan 2022 13:14:21 +0100
Message-Id: <20220125121426.848337-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220125121426.848337-1-miquel.raynal@bootlin.com>
References: <20220125121426.848337-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers are expected to set the PHY current_channel and current_page
according to their default state. The hwsim driver is advertising being
configured on channel 13 by default but that is not reflected in its own
internal pib structure. In order to ensure that this driver consider the
current channel as being 13 internally, we at least need to set the
pib->channel field to 13.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 8caa61ec718f..00ec188a3257 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -786,6 +786,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 		goto err_pib;
 	}
 
+	pib->page = 13;
 	rcu_assign_pointer(phy->pib, pib);
 	phy->idx = idx;
 	INIT_LIST_HEAD(&phy->edges);
-- 
2.27.0

