Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D4D2E4C2
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfE2SsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:48:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:45225 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfE2Srp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:47:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:47:44 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 29 May 2019 11:47:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] ice: Resolve static analysis warning
Date:   Wed, 29 May 2019 11:47:43 -0700
Message-Id: <20190529184754.12693-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
References: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Some static analysis tools can complain when doing a bitop assignment using
operands of different sizes. Fix that.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 2364eaf33d23..8e552a43681a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1874,10 +1874,10 @@ int ice_tso(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 	cd_mss = skb_shinfo(skb)->gso_size;
 
 	/* record cdesc_qw1 with TSO parameters */
-	off->cd_qw1 |= ICE_TX_DESC_DTYPE_CTX |
-			 (ICE_TX_CTX_DESC_TSO << ICE_TXD_CTX_QW1_CMD_S) |
-			 (cd_tso_len << ICE_TXD_CTX_QW1_TSO_LEN_S) |
-			 (cd_mss << ICE_TXD_CTX_QW1_MSS_S);
+	off->cd_qw1 |= (u64)(ICE_TX_DESC_DTYPE_CTX |
+			     (ICE_TX_CTX_DESC_TSO << ICE_TXD_CTX_QW1_CMD_S) |
+			     (cd_tso_len << ICE_TXD_CTX_QW1_TSO_LEN_S) |
+			     (cd_mss << ICE_TXD_CTX_QW1_MSS_S));
 	first->tx_flags |= ICE_TX_FLAGS_TSO;
 	return 1;
 }
-- 
2.21.0

