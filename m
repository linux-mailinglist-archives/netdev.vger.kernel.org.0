Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4580235344
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgHAQSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:12 -0400
Received: from mga05.intel.com ([192.55.52.43]:19614 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbgHAQSJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:09 -0400
IronPort-SDR: nRozRdIVjNlbAMlIyqGyOYojhapk8e+M1abhuKeXbv1cTo4wwWc+6zxgYzzaoJGsDZZlkxjkKh
 5sHlU+ANhj0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810850"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810850"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:07 -0700
IronPort-SDR: NBAZYNvtqdHOg+mZ8sP1gnRdcubzHo+G1xGt4iS5dIK5WtDg8AN2ja4lM2CRWDfUgUYoxF6p/G
 IkB/Tiv2IDpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457702"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 05/14] ice: remove page_reuse statistic
Date:   Sat,  1 Aug 2020 09:17:53 -0700
Message-Id: <20200801161802.867645-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
References: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The page reuse statistic wasn't even being displayed to the user, even
though the driver counted it. Don't waste the struct space and hot-path
cycles since the driver doesn't display it.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 --
 drivers/net/ethernet/intel/ice/ice_txrx.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index a508d4f463e9..53c67eeec2fa 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -632,7 +632,6 @@ ice_alloc_mapped_page(struct ice_ring *rx_ring, struct ice_rx_buf *bi)
 
 	/* since we are recycling buffers we should seldom need to alloc */
 	if (likely(page)) {
-		rx_ring->rx_stats.page_reuse_count++;
 		return true;
 	}
 
@@ -1033,7 +1032,6 @@ static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 	if (ice_can_reuse_rx_page(rx_buf)) {
 		/* hand second half of page back to the ring */
 		ice_reuse_rx_page(rx_ring, rx_buf);
-		rx_ring->rx_stats.page_reuse_count++;
 	} else {
 		/* we are not reusing the buffer so unmap it */
 		dma_unmap_page_attrs(rx_ring->dev, rx_buf->dma,
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index e70c4619edc3..77c94daeb434 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -193,7 +193,6 @@ struct ice_rxq_stats {
 	u64 non_eop_descs;
 	u64 alloc_page_failed;
 	u64 alloc_buf_failed;
-	u64 page_reuse_count;
 };
 
 /* this enum matches hardware bits and is meant to be used by DYN_CTLN
-- 
2.26.2

