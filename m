Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDA127BAA9
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 04:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgI2CGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 22:06:53 -0400
Received: from mga17.intel.com ([192.55.52.151]:55749 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgI2CGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 22:06:53 -0400
IronPort-SDR: FxwIKK6rjtqMf/7qmsZDB1UusjeKw+rrPbtbUSD+rwaitF/MKdrA+qAEEOF1bOQbl199TwJhnF
 a4+d3TqqI7kw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="142086326"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="142086326"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:29 -0700
IronPort-SDR: se60/geBokPOklM5WtFyvISDOSzCF4WFkjY5z5F3bT6rhsuK1ZPU2Hfyx8OVxbpPWcvyWUaOta
 6APToiqsXVEg==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="311962115"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 07/15] igc: Clean RX descriptor error flags
Date:   Mon, 28 Sep 2020 14:50:10 -0700
Message-Id: <20200928215018.952991-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
References: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

i225 advanced receive descriptor doesn't have the following extend error
bits: CE, SE, SEQ, CXE. In addition to that, the bit TCPE is called L4E
in the datasheet.

Clean up the code accordingly, and get rid of the macro
IGC_RXDEXT_ERR_FRAME_ERR_MASK since it doesn't make much sense anymore.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 14 +-------------
 drivers/net/ethernet/intel/igc/igc_main.c    |  5 ++---
 2 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 3f5a201bda89..32f5fd684139 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -324,22 +324,10 @@
 /* Advanced Receive Descriptor bit definitions */
 #define IGC_RXDADV_STAT_TSIP	0x08000 /* timestamp in packet */
 
-#define IGC_RXDEXT_STATERR_CE		0x01000000
-#define IGC_RXDEXT_STATERR_SE		0x02000000
-#define IGC_RXDEXT_STATERR_SEQ		0x04000000
-#define IGC_RXDEXT_STATERR_CXE		0x10000000
-#define IGC_RXDEXT_STATERR_TCPE		0x20000000
+#define IGC_RXDEXT_STATERR_L4E		0x20000000
 #define IGC_RXDEXT_STATERR_IPE		0x40000000
 #define IGC_RXDEXT_STATERR_RXE		0x80000000
 
-/* Same mask, but for extended and packet split descriptors */
-#define IGC_RXDEXT_ERR_FRAME_ERR_MASK ( \
-	IGC_RXDEXT_STATERR_CE  |	\
-	IGC_RXDEXT_STATERR_SE  |	\
-	IGC_RXDEXT_STATERR_SEQ |	\
-	IGC_RXDEXT_STATERR_CXE |	\
-	IGC_RXDEXT_STATERR_RXE)
-
 #define IGC_MRQC_RSS_FIELD_IPV4_TCP	0x00010000
 #define IGC_MRQC_RSS_FIELD_IPV4		0x00020000
 #define IGC_MRQC_RSS_FIELD_IPV6_TCP_EX	0x00040000
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index b46bc8ded836..7a46b22413f2 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1433,7 +1433,7 @@ static void igc_rx_checksum(struct igc_ring *ring,
 
 	/* TCP/UDP checksum error bit is set */
 	if (igc_test_staterr(rx_desc,
-			     IGC_RXDEXT_STATERR_TCPE |
+			     IGC_RXDEXT_STATERR_L4E |
 			     IGC_RXDEXT_STATERR_IPE)) {
 		/* work around errata with sctp packets where the TCPE aka
 		 * L4E bit is set incorrectly on 64 byte (60 byte w/o crc)
@@ -1742,8 +1742,7 @@ static bool igc_cleanup_headers(struct igc_ring *rx_ring,
 				union igc_adv_rx_desc *rx_desc,
 				struct sk_buff *skb)
 {
-	if (unlikely((igc_test_staterr(rx_desc,
-				       IGC_RXDEXT_ERR_FRAME_ERR_MASK)))) {
+	if (unlikely(igc_test_staterr(rx_desc, IGC_RXDEXT_STATERR_RXE))) {
 		struct net_device *netdev = rx_ring->netdev;
 
 		if (!(netdev->features & NETIF_F_RXALL)) {
-- 
2.26.2

