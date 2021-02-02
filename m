Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADD630B539
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhBBCZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:25:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:11689 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230122AbhBBCZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 21:25:25 -0500
IronPort-SDR: O2+WR2+27qk3Odp9ldkZbtgVioWiR6kktFkP/yUiUFQlUlx/2eD+BzSJkKX47AqTlFi8TRgXI6
 LV0YQOnG9LEw==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="180929271"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="180929271"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 18:23:40 -0800
IronPort-SDR: +DsLSya6oP8e9yDQBB7bbhbxBQ0QVOLRPYNbetlVh9CI3SlNLL5/CwCLHMy9vj3z99+1MjNiwK
 EOzwPwAv8tGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="581782145"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2021 18:23:39 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net-next 5/6] i40e: Add info trace at loading XDP program
Date:   Mon,  1 Feb 2021 18:24:19 -0800
Message-Id: <20210202022420.1328397-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
References: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

New trace indicates that the XDP program was loaded.
The trace has a note that in case of using XDP_REDIRECT,
number of queues on both interfaces shall be the same.
This is required for optimal performance of XDP_REDIRECT,
if interface used for TX has lower number of queues than
a RX interface, the packets may be dropped (depending on
RSS queue assignment).

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 521ea9df38d5..f35bd9164106 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12489,11 +12489,14 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
 	/* Kick start the NAPI context if there is an AF_XDP socket open
 	 * on that queue id. This so that receiving will start.
 	 */
-	if (need_reset && prog)
+	if (need_reset && prog) {
+		dev_info(&pf->pdev->dev,
+			 "Loading XDP program, please note: XDP_REDIRECT action requires the same number of queues on both interfaces\n");
 		for (i = 0; i < vsi->num_queue_pairs; i++)
 			if (vsi->xdp_rings[i]->xsk_pool)
 				(void)i40e_xsk_wakeup(vsi->netdev, i,
 						      XDP_WAKEUP_RX);
+	}
 
 	return 0;
 }
-- 
2.26.2

