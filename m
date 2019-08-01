Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 196CC7E594
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 00:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbfHAWZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 18:25:53 -0400
Received: from mga07.intel.com ([134.134.136.100]:14634 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729012AbfHAWZu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 18:25:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 15:25:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="324384881"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 01 Aug 2019 15:25:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/11] fm10k: reduce the scope of the tx_buffer variable
Date:   Thu,  1 Aug 2019 15:25:43 -0700
Message-Id: <20190801222548.15975-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801222548.15975-1-jeffrey.t.kirsher@intel.com>
References: <20190801222548.15975-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The tx_buffer local variable in the function fm10k_clean_tx_ring is not
used except inside a smaller block scope. Reduce the scope to its point
of use.

This was detected by cppcheck and resolves the following style warning
produced by that tool:

[fm10k_netdev.c:179]: (style) The scope of the variable 'tx_buffer' can
be reduced.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 538a8467f434..c73fb38be678 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -169,7 +169,6 @@ void fm10k_unmap_and_free_tx_resource(struct fm10k_ring *ring,
  **/
 static void fm10k_clean_tx_ring(struct fm10k_ring *tx_ring)
 {
-	struct fm10k_tx_buffer *tx_buffer;
 	unsigned long size;
 	u16 i;
 
@@ -179,7 +178,8 @@ static void fm10k_clean_tx_ring(struct fm10k_ring *tx_ring)
 
 	/* Free all the Tx ring sk_buffs */
 	for (i = 0; i < tx_ring->count; i++) {
-		tx_buffer = &tx_ring->tx_buffer[i];
+		struct fm10k_tx_buffer *tx_buffer = &tx_ring->tx_buffer[i];
+
 		fm10k_unmap_and_free_tx_resource(tx_ring, tx_buffer);
 	}
 
-- 
2.21.0

