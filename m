Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE1A4907A3
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbiAQLz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:55:26 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:56781 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbiAQLzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:18 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 88F00200009;
        Mon, 17 Jan 2022 11:55:15 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v3 17/41] net: ieee802154: at86rf230: Call the complete helper when a transmission is over
Date:   Mon, 17 Jan 2022 12:54:16 +0100
Message-Id: <20220117115440.60296-18-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee802154_xmit_complete() is the right helper to call when a
transmission is over. The fact that it completed or not is not really a
question, but drivers must tell the core that the completion is over,
even if it was canceled. Do not call ieee802154_wake_queue() manually,
in order to let full control of this task to the core.

By using the complete helper we also avoid leacking the skb structure.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 583f835c317a..1941e1f3d2ef 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -343,7 +343,7 @@ at86rf230_async_error_recover_complete(void *context)
 	if (ctx->free)
 		kfree(ctx);
 
-	ieee802154_wake_queue(lp->hw);
+	ieee802154_xmit_complete(lp->hw, lp->tx_skb, false);
 }
 
 static void
-- 
2.27.0

