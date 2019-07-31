Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B781D7CEEF
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbfGaUmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:42:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:16007 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729114AbfGaUlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901013"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/16] ice: Always set prefena when configuring an Rx queue
Date:   Wed, 31 Jul 2019 13:41:35 -0700
Message-Id: <20190731204147.8582-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
References: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently we are always setting prefena to 0. This is causing the
hardware to only fetch descriptors when there are none free in the cache
for a received packet instead of prefetching when it has used the last
descriptor regardless of incoming packets. Fix this by allowing the
hardware to prefetch Rx descriptors.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c    | 9 ++++++++-
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 4be3559de207..01e5ecaaa322 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1078,6 +1078,7 @@ static const struct ice_ctx_ele ice_rlan_ctx_info[] = {
 	ICE_CTX_STORE(ice_rlan_ctx, tphdata_ena,	1,	195),
 	ICE_CTX_STORE(ice_rlan_ctx, tphhead_ena,	1,	196),
 	ICE_CTX_STORE(ice_rlan_ctx, lrxqthresh,		3,	198),
+	ICE_CTX_STORE(ice_rlan_ctx, prefena,		1,	201),
 	{ 0 }
 };
 
@@ -1088,7 +1089,8 @@ static const struct ice_ctx_ele ice_rlan_ctx_info[] = {
  * @rxq_index: the index of the Rx queue
  *
  * Converts rxq context from sparse to dense structure and then writes
- * it to HW register space
+ * it to HW register space and enables the hardware to prefetch descriptors
+ * instead of only fetching them on demand
  */
 enum ice_status
 ice_write_rxq_ctx(struct ice_hw *hw, struct ice_rlan_ctx *rlan_ctx,
@@ -1096,6 +1098,11 @@ ice_write_rxq_ctx(struct ice_hw *hw, struct ice_rlan_ctx *rlan_ctx,
 {
 	u8 ctx_buf[ICE_RXQ_CTX_SZ] = { 0 };
 
+	if (!rlan_ctx)
+		return ICE_ERR_BAD_PTR;
+
+	rlan_ctx->prefena = 1;
+
 	ice_set_ctx((u8 *)rlan_ctx, ctx_buf, ice_rlan_ctx_info);
 	return ice_copy_rxq_ctx_to_hw(hw, ctx_buf, rxq_index);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 510a8c900e61..57ea6811fe2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -290,6 +290,7 @@ struct ice_rlan_ctx {
 	u8 tphdata_ena;
 	u8 tphhead_ena;
 	u16 lrxqthresh; /* bigger than needed, see above for reason */
+	u8 prefena;	/* NOTE: normally must be set to 1 at init */
 };
 
 struct ice_ctx_ele {
-- 
2.21.0

