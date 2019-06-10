Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1953B66F
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390461AbfFJNue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:50:34 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45579 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390324AbfFJNue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 09:50:34 -0400
X-Originating-IP: 90.88.159.246
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id C700BE0002;
        Mon, 10 Jun 2019 13:50:23 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Yuri Chipchev <yuric@marvell.com>
Subject: [PATCH net 1/2] net: mvpp2: prs: Fix parser range for VID filtering
Date:   Mon, 10 Jun 2019 15:50:07 +0200
Message-Id: <20190610135008.8077-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VID filtering is implemented in the Header Parser, with one range of 11
vids being assigned for each no-loopback port.

Make sure we use the per-port range when looking for existing entries in
the Parser.

Since we used a global range instead of a per-port one, this causes VIDs
to be removed from the whitelist from all ports of the same PPv2
instance.

Fixes: 56beda3db602 ("net: mvpp2: Add hardware offloading for VLAN filtering")
Suggested-by: Yuri Chipchev <yuric@marvell.com>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 392fd895f278..e0da4db3bf56 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -1905,8 +1905,7 @@ static int mvpp2_prs_ip6_init(struct mvpp2 *priv)
 }
 
 /* Find tcam entry with matched pair <vid,port> */
-static int mvpp2_prs_vid_range_find(struct mvpp2 *priv, int pmap, u16 vid,
-				    u16 mask)
+static int mvpp2_prs_vid_range_find(struct mvpp2_port *port, u16 vid, u16 mask)
 {
 	unsigned char byte[2], enable[2];
 	struct mvpp2_prs_entry pe;
@@ -1914,13 +1913,13 @@ static int mvpp2_prs_vid_range_find(struct mvpp2 *priv, int pmap, u16 vid,
 	int tid;
 
 	/* Go through the all entries with MVPP2_PRS_LU_VID */
-	for (tid = MVPP2_PE_VID_FILT_RANGE_START;
-	     tid <= MVPP2_PE_VID_FILT_RANGE_END; tid++) {
-		if (!priv->prs_shadow[tid].valid ||
-		    priv->prs_shadow[tid].lu != MVPP2_PRS_LU_VID)
+	for (tid = MVPP2_PRS_VID_PORT_FIRST(port->id);
+	     tid <= MVPP2_PRS_VID_PORT_LAST(port->id); tid++) {
+		if (!port->priv->prs_shadow[tid].valid ||
+		    port->priv->prs_shadow[tid].lu != MVPP2_PRS_LU_VID)
 			continue;
 
-		mvpp2_prs_init_from_hw(priv, &pe, tid);
+		mvpp2_prs_init_from_hw(port->priv, &pe, tid);
 
 		mvpp2_prs_tcam_data_byte_get(&pe, 2, &byte[0], &enable[0]);
 		mvpp2_prs_tcam_data_byte_get(&pe, 3, &byte[1], &enable[1]);
@@ -1950,7 +1949,7 @@ int mvpp2_prs_vid_entry_add(struct mvpp2_port *port, u16 vid)
 	memset(&pe, 0, sizeof(pe));
 
 	/* Scan TCAM and see if entry with this <vid,port> already exist */
-	tid = mvpp2_prs_vid_range_find(priv, (1 << port->id), vid, mask);
+	tid = mvpp2_prs_vid_range_find(port, vid, mask);
 
 	reg_val = mvpp2_read(priv, MVPP2_MH_REG(port->id));
 	if (reg_val & MVPP2_DSA_EXTENDED)
@@ -2008,7 +2007,7 @@ void mvpp2_prs_vid_entry_remove(struct mvpp2_port *port, u16 vid)
 	int tid;
 
 	/* Scan TCAM and see if entry with this <vid,port> already exist */
-	tid = mvpp2_prs_vid_range_find(priv, (1 << port->id), vid, 0xfff);
+	tid = mvpp2_prs_vid_range_find(port, vid, 0xfff);
 
 	/* No such entry */
 	if (tid < 0)
-- 
2.20.1

