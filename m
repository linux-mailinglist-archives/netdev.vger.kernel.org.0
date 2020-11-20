Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25C22BA4FC
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 09:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgKTInt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 03:43:49 -0500
Received: from mailout11.rmx.de ([94.199.88.76]:52256 "EHLO mailout11.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbgKTInq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 03:43:46 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout11.rmx.de (Postfix) with ESMTPS id 4Ccqp60Dzqz41pL;
        Fri, 20 Nov 2020 09:43:42 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4Ccqn71LHjz2TSBr;
        Fri, 20 Nov 2020 09:42:51 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.143) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 20 Nov
 2020 09:42:33 +0100
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
Subject: [PATCH net-next v3 2/3] dpaa2-eth: use new PTP_MSGTYPE_* define(s)
Date:   Fri, 20 Nov 2020 09:41:05 +0100
Message-ID: <20201120084106.10046-3-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120084106.10046-1-ceggers@arri.de>
References: <20201120084106.10046-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.143]
X-RMX-ID: 20201120-094259-4Ccqn71LHjz2TSBr-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove usage of magic numbers.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index cf9400a9886d..a0a30c721fe7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -686,7 +686,7 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
 	if (skb->cb[0] == TX_TSTAMP_ONESTEP_SYNC) {
 		if (dpaa2_eth_ptp_parse(skb, &msgtype, &twostep, &udp,
 					&offset1, &offset2) ||
-		    msgtype != 0 || twostep) {
+		    msgtype != PTP_MSGTYPE_SYNC || twostep) {
 			WARN_ONCE(1, "Bad packet for one-step timestamping\n");
 			return;
 		}
@@ -1212,7 +1212,7 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	if (skb->cb[0] == TX_TSTAMP_ONESTEP_SYNC) {
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

