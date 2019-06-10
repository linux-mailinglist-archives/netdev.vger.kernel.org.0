Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE86A3B66D
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390500AbfFJNug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:50:36 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48157 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390324AbfFJNug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 09:50:36 -0400
X-Originating-IP: 90.88.159.246
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id E8BB6E0005;
        Mon, 10 Jun 2019 13:50:29 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Yuri Chipchev <yuric@marvell.com>
Subject: [PATCH net 2/2] net: mvpp2: prs: Use the correct helpers when removing all VID filters
Date:   Mon, 10 Jun 2019 15:50:08 +0200
Message-Id: <20190610135008.8077-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610135008.8077-1-maxime.chevallier@bootlin.com>
References: <20190610135008.8077-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When removing all VID filters, the mvpp2_prs_vid_entry_remove would be
called with the TCAM id incorrectly used as a VID, causing the wrong
TCAM entries to be invalidated.

Fix this by directly invalidating entries in the VID range.

Fixes: 56beda3db602 ("net: mvpp2: Add hardware offloading for VLAN filtering")
Suggested-by: Yuri Chipchev <yuric@marvell.com>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index e0da4db3bf56..ae2240074d8e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -2025,8 +2025,10 @@ void mvpp2_prs_vid_remove_all(struct mvpp2_port *port)
 
 	for (tid = MVPP2_PRS_VID_PORT_FIRST(port->id);
 	     tid <= MVPP2_PRS_VID_PORT_LAST(port->id); tid++) {
-		if (priv->prs_shadow[tid].valid)
-			mvpp2_prs_vid_entry_remove(port, tid);
+		if (priv->prs_shadow[tid].valid) {
+			mvpp2_prs_hw_inv(priv, tid);
+			priv->prs_shadow[tid].valid = false;
+		}
 	}
 }
 
-- 
2.20.1

