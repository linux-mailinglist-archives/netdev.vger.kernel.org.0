Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485AD126051
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfLSLAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:00:33 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:41125 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbfLSLA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:00:29 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 3067B1C0013;
        Thu, 19 Dec 2019 11:00:25 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v4 10/15] net: macsec: PN wrap callback
Date:   Thu, 19 Dec 2019 11:55:10 +0100
Message-Id: <20191219105515.78400-11-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219105515.78400-1-antoine.tenart@bootlin.com>
References: <20191219105515.78400-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to call macsec_pn_wrapped from hardware drivers to notify when a
PN rolls over. Some drivers might used an interrupt to implement this.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/macsec.c | 24 ++++++++++++++++++------
 include/net/macsec.h |  2 ++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index ace7fc98e8dd..fc481616632c 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -423,6 +423,22 @@ static struct macsec_eth_header *macsec_ethhdr(struct sk_buff *skb)
 	return (struct macsec_eth_header *)skb_mac_header(skb);
 }
 
+static void __macsec_pn_wrapped(struct macsec_secy *secy,
+				struct macsec_tx_sa *tx_sa)
+{
+	pr_debug("PN wrapped, transitioning to !oper\n");
+	tx_sa->active = false;
+	if (secy->protect_frames)
+		secy->operational = false;
+}
+
+void macsec_pn_wrapped(struct macsec_secy *secy, struct macsec_tx_sa *tx_sa)
+{
+	spin_lock_bh(&tx_sa->lock);
+	__macsec_pn_wrapped(secy, tx_sa);
+	spin_unlock_bh(&tx_sa->lock);
+}
+
 static u32 tx_sa_update_pn(struct macsec_tx_sa *tx_sa, struct macsec_secy *secy)
 {
 	u32 pn;
@@ -431,12 +447,8 @@ static u32 tx_sa_update_pn(struct macsec_tx_sa *tx_sa, struct macsec_secy *secy)
 	pn = tx_sa->next_pn;
 
 	tx_sa->next_pn++;
-	if (tx_sa->next_pn == 0) {
-		pr_debug("PN wrapped, transitioning to !oper\n");
-		tx_sa->active = false;
-		if (secy->protect_frames)
-			secy->operational = false;
-	}
+	if (tx_sa->next_pn == 0)
+		__macsec_pn_wrapped(secy, tx_sa);
 	spin_unlock_bh(&tx_sa->lock);
 
 	return pn;
diff --git a/include/net/macsec.h b/include/net/macsec.h
index 4d0afb79259e..a08f19099c7a 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -220,4 +220,6 @@ struct macsec_ops {
 	int (*mdo_del_txsa)(struct macsec_context *ctx);
 };
 
+void macsec_pn_wrapped(struct macsec_secy *secy, struct macsec_tx_sa *tx_sa);
+
 #endif /* _NET_MACSEC_H_ */
-- 
2.24.1

