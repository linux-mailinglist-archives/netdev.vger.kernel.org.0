Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4830E1E588B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgE1HZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:25:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:14682 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbgE1HZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:48 -0400
IronPort-SDR: oWL+bPP8QoOc3Cl0mStK/X/7Sr9+EbkQOMzxvfX+wY+3ifDVK1gsKR945Iqk/2S8TVXjLKf4P6
 n0M56YEJNa6w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:45 -0700
IronPort-SDR: eExHK+S/mF6NWNP6YQlufJ/q2R1JHTZqMQS2tmGw7JqAPvCcWubEobZK2njaQRB+lzWL5fKTY2
 xSuyLYbJOjAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831145"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/15] ice: Refactor Rx checksum checks
Date:   Thu, 28 May 2020 00:25:37 -0700
Message-Id: <20200528072538.1621790-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

We don't need both rx_status and rx_error parameters, as the latter is
a subset of the former. Remove rx_error completely and check the right bit
in rx_status.

Rename rx_status to rx_status0, and rx_status_err1 to
rx_status1. This naming more closely reflects the specification.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 27 ++++++++-----------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 1ba97172d8d0..ab2031b1c635 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -84,17 +84,12 @@ ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
 	    union ice_32b_rx_flex_desc *rx_desc, u8 ptype)
 {
 	struct ice_rx_ptype_decoded decoded;
-	u16 rx_error, rx_status;
-	u16 rx_stat_err1;
+	u16 rx_status0, rx_status1;
 	bool ipv4, ipv6;
 
-	rx_status = le16_to_cpu(rx_desc->wb.status_error0);
-	rx_error = rx_status & (BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_IPE_S) |
-				BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_L4E_S) |
-				BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_EIPE_S) |
-				BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_EUDPE_S));
+	rx_status0 = le16_to_cpu(rx_desc->wb.status_error0);
+	rx_status1 = le16_to_cpu(rx_desc->wb.status_error1);
 
-	rx_stat_err1 = le16_to_cpu(rx_desc->wb.status_error1);
 	decoded = ice_decode_rx_desc_ptype(ptype);
 
 	/* Start with CHECKSUM_NONE and by default csum_level = 0 */
@@ -106,7 +101,7 @@ ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
 		return;
 
 	/* check if HW has decoded the packet and checksum */
-	if (!(rx_status & BIT(ICE_RX_FLEX_DESC_STATUS0_L3L4P_S)))
+	if (!(rx_status0 & BIT(ICE_RX_FLEX_DESC_STATUS0_L3L4P_S)))
 		return;
 
 	if (!(decoded.known && decoded.outer_ip))
@@ -117,22 +112,22 @@ ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
 	ipv6 = (decoded.outer_ip == ICE_RX_PTYPE_OUTER_IP) &&
 	       (decoded.outer_ip_ver == ICE_RX_PTYPE_OUTER_IPV6);
 
-	if (ipv4 && (rx_error & (BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_IPE_S) |
-				 BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_EIPE_S))))
+	if (ipv4 && (rx_status0 & (BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_IPE_S) |
+				   BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_EIPE_S))))
 		goto checksum_fail;
-	else if (ipv6 && (rx_status &
-		 (BIT(ICE_RX_FLEX_DESC_STATUS0_IPV6EXADD_S))))
+
+	if (ipv6 && (rx_status0 & (BIT(ICE_RX_FLEX_DESC_STATUS0_IPV6EXADD_S))))
 		goto checksum_fail;
 
 	/* check for L4 errors and handle packets that were not able to be
 	 * checksummed due to arrival speed
 	 */
-	if (rx_error & BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_L4E_S))
+	if (rx_status0 & BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_L4E_S))
 		goto checksum_fail;
 
 	/* check for outer UDP checksum error in tunneled packets */
-	if ((rx_stat_err1 & BIT(ICE_RX_FLEX_DESC_STATUS1_NAT_S)) &&
-	    (rx_error & BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_EUDPE_S)))
+	if ((rx_status1 & BIT(ICE_RX_FLEX_DESC_STATUS1_NAT_S)) &&
+	    (rx_status0 & BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_EUDPE_S)))
 		goto checksum_fail;
 
 	/* If there is an outer header present that might contain a checksum
-- 
2.26.2

