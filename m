Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A9E2E4B5
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfE2Srs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:47:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:2790 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbfE2Srp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:47:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:47:44 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 29 May 2019 11:47:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] ice: Set minimum default Rx descriptor count to 512
Date:   Wed, 29 May 2019 11:47:44 -0700
Message-Id: <20190529184754.12693-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
References: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently we set the default number of Rx descriptors per
queue to the system's page size divided by the number of bytes per
descriptor. For 4K page size systems this is resulting in 128 Rx
descriptors per queue. This is causing more dropped packets than desired
in the default configuration. Fix this by setting the minimum default
Rx descriptor count per queue to 512.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b5990ba0ee4c..0555d09614d8 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -46,13 +46,20 @@ extern const char ice_drv_ver[];
 #define ICE_REQ_DESC_MULTIPLE	32
 #define ICE_MIN_NUM_DESC	ICE_REQ_DESC_MULTIPLE
 #define ICE_MAX_NUM_DESC	8160
-/* set default number of Rx/Tx descriptors to the minimum between
- * ICE_MAX_NUM_DESC and the number of descriptors to fill up an entire page
+#define ICE_DFLT_MIN_RX_DESC	512
+/* if the default number of Rx descriptors between ICE_MAX_NUM_DESC and the
+ * number of descriptors to fill up an entire page is greater than or equal to
+ * ICE_DFLT_MIN_RX_DESC set it based on page size, otherwise set it to
+ * ICE_DFLT_MIN_RX_DESC
+ */
+#define ICE_DFLT_NUM_RX_DESC \
+	min_t(u16, ICE_MAX_NUM_DESC, \
+	      max_t(u16, ALIGN(PAGE_SIZE / sizeof(union ice_32byte_rx_desc), \
+			       ICE_REQ_DESC_MULTIPLE), \
+		    ICE_DFLT_MIN_RX_DESC))
+/* set default number of Tx descriptors to the minimum between ICE_MAX_NUM_DESC
+ * and the number of descriptors to fill up an entire page
  */
-#define ICE_DFLT_NUM_RX_DESC	min_t(u16, ICE_MAX_NUM_DESC, \
-				      ALIGN(PAGE_SIZE / \
-					    sizeof(union ice_32byte_rx_desc), \
-					    ICE_REQ_DESC_MULTIPLE))
 #define ICE_DFLT_NUM_TX_DESC	min_t(u16, ICE_MAX_NUM_DESC, \
 				      ALIGN(PAGE_SIZE / \
 					    sizeof(struct ice_tx_desc), \
-- 
2.21.0

