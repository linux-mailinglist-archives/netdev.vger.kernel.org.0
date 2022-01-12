Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C6F48C9CD
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355803AbiALRf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:35:57 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:52489 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355772AbiALRfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:35:42 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 799B6C000A;
        Wed, 12 Jan 2022 17:35:39 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-wireless@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-tools v2 5/7] iwpan: Synchronize nl802154 header with the Linux kernel
Date:   Wed, 12 Jan 2022 18:35:27 +0100
Message-Id: <20220112173529.765170-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173529.765170-1-miquel.raynal@bootlin.com>
References: <20220112173529.765170-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The content of this file as evolved, reflect the changes accepted in the
mainline Linux kernel here.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 src/nl802154.h | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/src/nl802154.h b/src/nl802154.h
index ddcee12..9bb136a 100644
--- a/src/nl802154.h
+++ b/src/nl802154.h
@@ -56,6 +56,16 @@ enum nl802154_commands {
 
 	NL802154_CMD_SET_WPAN_PHY_NETNS,
 
+	NL802154_CMD_TRIGGER_SCAN,
+	NL802154_CMD_ABORT_SCAN,
+	NL802154_CMD_SCAN_DONE,
+	NL802154_CMD_DUMP_PANS,
+	NL802154_CMD_FLUSH_PANS,
+	NL802154_CMD_SET_MAX_PAN_ENTRIES,
+	NL802154_CMD_SET_PANS_EXPIRATION,
+	NL802154_CMD_SEND_BEACONS,
+	NL802154_CMD_STOP_BEACONS,
+
 	/* add new commands above here */
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
@@ -131,6 +141,15 @@ enum nl802154_attrs {
 	NL802154_ATTR_PID,
 	NL802154_ATTR_NETNS_FD,
 
+	NL802154_ATTR_SCAN_TYPE,
+	NL802154_ATTR_SCAN_FLAGS,
+	NL802154_ATTR_SCAN_CHANNELS,
+	NL802154_ATTR_SCAN_DURATION,
+	NL802154_ATTR_PAN,
+	NL802154_ATTR_MAX_PAN_ENTRIES,
+	NL802154_ATTR_PANS_EXPIRATION,
+	NL802154_ATTR_BEACON_INTERVAL,
+
 	/* add attributes here, update the policy in nl802154.c */
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
@@ -217,6 +236,86 @@ enum nl802154_wpan_phy_capability_attr {
 	NL802154_CAP_ATTR_MAX = __NL802154_CAP_ATTR_AFTER_LAST - 1
 };
 
+/**
+ * enum nl802154_scan_types - Scan types
+ *
+ * @__NL802154_SCAN_INVALID: scan type number 0 is reserved
+ * @NL802154_SCAN_ED: An ED scan allows a device to obtain a measure of the peak
+ *	energy in each requested channel
+ * @NL802154_SCAN_ACTIVE: Locate any coordinator transmitting Beacon frames using
+ *	a Beacon Request command
+ * @NL802154_SCAN_PASSIVE: Locate any coordinator transmitting Beacon frames
+ * @NL802154_SCAN_ORPHAN: Relocate coordinator following a loss of synchronisation
+ * @NL802154_SCAN_ENHANCED_ACTIVE: Same as Active using Enhanced Beacon Request
+ *	command instead of Beacon Request command
+ * @NL802154_SCAN_RIT_PASSIVE: Passive scan for RIT Data Request command frames
+ *	instead of Beacon frames
+ * @NL802154_SCAN_ATTR_MAX: Maximum SCAN attribute number
+ */
+enum nl802154_scan_types {
+	__NL802154_SCAN_INVALID,
+	NL802154_SCAN_ED,
+	NL802154_SCAN_ACTIVE,
+	NL802154_SCAN_PASSIVE,
+	NL802154_SCAN_ORPHAN,
+	NL802154_SCAN_ENHANCED_ACTIVE,
+	NL802154_SCAN_RIT_PASSIVE,
+
+	/* keep last */
+	NL802154_SCAN_ATTR_MAX,
+};
+
+/**
+ * enum nl802154_scan_flags - Scan request control flags
+ *
+ * @NL802154_SCAN_FLAG_RANDOM_ADDR: use a random MAC address for this scan (ie.
+ *	a different one for every scan iteration). When the flag is set, full
+ *	randomisation is assumed.
+ */
+enum nl802154_scan_flags {
+	NL802154_SCAN_FLAG_RANDOM_ADDR = 1 << 0,
+};
+
+/**
+ * enum nl802154_pan - Netlink attributes for a PAN
+ *
+ * @__NL802154_PAN_INVALID: invalid
+ * @NL802154_PAN_PANID: PANID of the PAN (2 bytes)
+ * @NL802154_PAN_COORD_ADDR: Coordinator address, (8 bytes or 2 bytes)
+ * @NL802154_PAN_CHANNEL: channel number, related to @NL802154_PAN_PAGE (u8)
+ * @NL802154_PAN_PAGE: channel page, related to @NL802154_PAN_CHANNEL (u8)
+ * @NL802154_PAN_PREAMBLE_CODE: Preamble code while the beacon was received,
+ *	this is PHY dependent and optional (4 bytes)
+ * @NL802154_PAN_SUPERFRAME_SPEC: superframe specification of the PAN (u16)
+ * @NL802154_PAN_LINK_QUALITY: signal quality of beacon in unspecified units,
+ *	scaled to 0..255 (u8)
+ * @NL802154_PAN_GTS_PERMIT: set to true if GTS is permitted on this PAN
+ * @NL802154_PAN_PAYLOAD_DATA: binary data containing the raw data from the
+ *	frame payload, (only if beacon or probe response had data)
+ * @NL802154_PAN_STATUS: status, if this PAN is "used"
+ * @NL802154_PAN_SEEN_MS_AGO: age of this PAN entry in ms
+ * @NL802154_PAN_PAD: attribute used for padding for 64-bit alignment
+ * @NL802154_PAN_MAX: highest PAN attribute
+ */
+enum nl802154_pan {
+	__NL802154_PAN_INVALID,
+	NL802154_PAN_PANID,
+	NL802154_PAN_COORD_ADDR,
+	NL802154_PAN_CHANNEL,
+	NL802154_PAN_PAGE,
+	NL802154_PAN_PREAMBLE_CODE,
+	NL802154_PAN_SUPERFRAME_SPEC,
+	NL802154_PAN_LINK_QUALITY,
+	NL802154_PAN_GTS_PERMIT,
+	NL802154_PAN_PAYLOAD_DATA,
+	NL802154_PAN_STATUS,
+	NL802154_PAN_SEEN_MS_AGO,
+	NL802154_PAN_PAD,
+
+	/* keep last */
+	NL802154_PAN_MAX,
+};
+
 /**
  * enum nl802154_cca_modes - cca modes
  *
-- 
2.27.0

