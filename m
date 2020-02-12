Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6D615B2CD
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 22:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgBLVeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 16:34:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:42951 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728603AbgBLVeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 16:34:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 13:34:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,434,1574150400"; 
   d="scan'208";a="233911686"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga003.jf.intel.com with ESMTP; 12 Feb 2020 13:34:00 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 04/15] ice: Don't allow same value for Rx tail to be written twice
Date:   Wed, 12 Feb 2020 13:33:46 -0800
Message-Id: <20200212213357.2198911-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
References: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently we compare the value we are about to write to the Rx tail
register with the previous value of next_to_use. The problem with this
is we only write tail on 8 descriptor boundaries, but next_to_use is
updated whenever we clean Rx descriptors. Fix this by comparing the
value we are about to write to tail with the previously written tail
value. This will prevent duplicate Rx tail bumps.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 35bbc4ff603c..6da048a6ca7c 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -10,7 +10,7 @@
  */
 void ice_release_rx_desc(struct ice_ring *rx_ring, u32 val)
 {
-	u16 prev_ntu = rx_ring->next_to_use;
+	u16 prev_ntu = rx_ring->next_to_use & ~0x7;
 
 	rx_ring->next_to_use = val;
 
-- 
2.24.1

