Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F32301159
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbhAWACh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:02:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:38713 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726459AbhAWAA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 19:00:58 -0500
IronPort-SDR: 6frxyBkCrxl2W9tcoec4ya/oglv45HoX+FF3vPb2+DDFUwTQsXrgOMkK716gEfl3Kgoj3mEAos
 G45fRIazFr4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="179670514"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="179670514"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:57:02 -0800
IronPort-SDR: STgDH/MkYBp8prCUqKR+m+XnicC4mWyuLPdFEi+BqjEb71ByLuFbDfLrhMM/18XVQXGfi3IlTE
 LyirPbzJLFpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="428258688"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 22 Jan 2021 15:57:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Piotr Raczynski <piotr.raczynski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net 4/7] ice: use correct xdp_ring with XDP_TX action
Date:   Fri, 22 Jan 2021 15:57:31 -0800
Message-Id: <20210122235734.447240-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
References: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Raczynski <piotr.raczynski@intel.com>

XDP queue number for XDP_TX action is used inconsistently
and may result with no packets transmitted. Fix queue number
used by the driver when doing XDP_TX, i.e. use receive queue
number as in ice_finalize_xdp_rx.

Also, using smp_processor_id() is wrong here and won't
work with less queues.

Fixes: efc2214b6047 ("ice: Add support for XDP")
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index b6fa83c619dd..7946a90b2da7 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -546,7 +546,7 @@ ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
 	case XDP_PASS:
 		break;
 	case XDP_TX:
-		xdp_ring = rx_ring->vsi->xdp_rings[smp_processor_id()];
+		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->q_index];
 		result = ice_xmit_xdp_buff(xdp, xdp_ring);
 		break;
 	case XDP_REDIRECT:
-- 
2.26.2

