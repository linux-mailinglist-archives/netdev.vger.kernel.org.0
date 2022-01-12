Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA38B48C9E0
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355794AbiALRgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:36:37 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:42183 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355771AbiALReO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:34:14 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 766432000D;
        Wed, 12 Jan 2022 17:34:11 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-wireless@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next v2 27/27] net: ieee802154: ca8210: Refuse most of the scan operations
Date:   Wed, 12 Jan 2022 18:33:12 +0100
Message-Id: <20220112173312.764660-28-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173312.764660-1-miquel.raynal@bootlin.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Cascada 8210 hardware transceiver is kind of a hardMAC which
interfaces with the softMAC and in practice does not support sending
anything else than dataframes. This means we cannot send any BEACON_REQ
during active scans nor any BEACON in general. Refuse these operations
officially so that the user is aware of the limitation.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/ca8210.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index d3a9e4fe05f4..49c274280e3c 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2385,6 +2385,25 @@ static int ca8210_set_promiscuous_mode(struct ieee802154_hw *hw, const bool on)
 	return link_to_linux_err(status);
 }
 
+static int ca8210_enter_scan_mode(struct ieee802154_hw *hw,
+				  struct cfg802154_scan_request *request)
+{
+	/* This xceiver can only send dataframes */
+	if (request->type != NL802154_SCAN_PASSIVE)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int ca8210_enter_beacons_mode(struct ieee802154_hw *hw,
+				     struct cfg802154_beacons_request *request)
+{
+	/* This xceiver can only send dataframes */
+	return -EOPNOTSUPP;
+}
+
+static void ca8210_exit_scan_beacons_mode(struct ieee802154_hw *hw) { }
+
 static const struct ieee802154_ops ca8210_phy_ops = {
 	.start = ca8210_start,
 	.stop = ca8210_stop,
@@ -2397,7 +2416,11 @@ static const struct ieee802154_ops ca8210_phy_ops = {
 	.set_cca_ed_level = ca8210_set_cca_ed_level,
 	.set_csma_params = ca8210_set_csma_params,
 	.set_frame_retries = ca8210_set_frame_retries,
-	.set_promiscuous_mode = ca8210_set_promiscuous_mode
+	.set_promiscuous_mode = ca8210_set_promiscuous_mode,
+	.enter_scan_mode = ca8210_enter_scan_mode,
+	.exit_scan_mode = ca8210_exit_scan_beacons_mode,
+	.enter_beacons_mode = ca8210_enter_beacons_mode,
+	.exit_beacons_mode = ca8210_exit_scan_beacons_mode,
 };
 
 /* Test/EVBME Interface */
-- 
2.27.0

