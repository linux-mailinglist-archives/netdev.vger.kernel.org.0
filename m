Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185052B6EBE
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgKQTeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:34:21 -0500
Received: from mailout11.rmx.de ([94.199.88.76]:45111 "EHLO mailout11.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbgKQTeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 14:34:20 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout11.rmx.de (Postfix) with ESMTPS id 4CbGN723kJz3yZF;
        Tue, 17 Nov 2020 20:34:15 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CbGMD3QwMz2xFx;
        Tue, 17 Nov 2020 20:33:28 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.38) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 17 Nov
 2020 20:33:11 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>,
        "Ioana Ciornei" <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH net-next 3/4] dpaa2-eth: use enum ptp_msg_type
Date:   Tue, 17 Nov 2020 20:31:23 +0100
Message-ID: <20201117193124.9789-3-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201117193124.9789-1-ceggers@arri.de>
References: <20201117193124.9789-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.38]
X-RMX-ID: 20201117-203328-4CbGMD3QwMz2xFx-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new return type of ptp_get_msgtype(). Remove usage of magic numbers.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index cf9400a9886d..7e6084124f8f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -617,7 +617,7 @@ static int dpaa2_eth_consume_frames(struct dpaa2_eth_channel *ch,
 }
 
 static int dpaa2_eth_ptp_parse(struct sk_buff *skb,
-			       u8 *msgtype, u8 *twostep, u8 *udp,
+			       enum ptp_msg_type *msgtype, u8 *twostep, u8 *udp,
 			       u16 *correction_offset,
 			       u16 *origintimestamp_offset)
 {
@@ -659,7 +659,7 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
 {
 	struct ptp_tstamp origin_timestamp;
 	struct dpni_single_step_cfg cfg;
-	u8 msgtype, twostep, udp;
+	u8 twostep, udp;
 	struct dpaa2_faead *faead;
 	struct dpaa2_fas *fas;
 	struct timespec64 ts;
@@ -684,9 +684,11 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
 	faead->ctrl = cpu_to_le32(ctrl);
 
 	if (skb->cb[0] == TX_TSTAMP_ONESTEP_SYNC) {
+		enum ptp_msg_type msgtype;
+
 		if (dpaa2_eth_ptp_parse(skb, &msgtype, &twostep, &udp,
 					&offset1, &offset2) ||
-		    msgtype != 0 || twostep) {
+		    msgtype != PTP_MSGTYPE_SYNC || twostep) {
 			WARN_ONCE(1, "Bad packet for one-step timestamping\n");
 			return;
 		}
@@ -1195,7 +1197,7 @@ static void dpaa2_eth_tx_onestep_tstamp(struct work_struct *work)
 static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-	u8 msgtype, twostep, udp;
+	u8 twostep, udp;
 	u16 offset1, offset2;
 
 	/* Utilize skb->cb[0] for timestamping request per skb */
@@ -1210,9 +1212,11 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 
 	/* TX for one-step timestamping PTP Sync packet */
 	if (skb->cb[0] == TX_TSTAMP_ONESTEP_SYNC) {
+		enum ptp_msg_type msgtype;
+
 		if (!dpaa2_eth_ptp_parse(skb, &msgtype, &twostep, &udp,
 					 &offset1, &offset2))
-			if (msgtype == 0 && twostep == 0) {
+			if (msgtype == PTP_MSGTYPE_SYNC && twostep == 0) {
 				skb_queue_tail(&priv->tx_skbs, skb);
 				queue_work(priv->dpaa2_ptp_wq,
 					   &priv->tx_onestep_tstamp);
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

