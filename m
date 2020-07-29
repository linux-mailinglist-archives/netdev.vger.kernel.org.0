Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A71D23229B
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgG2QYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:20 -0400
Received: from mga06.intel.com ([134.134.136.31]:42163 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgG2QYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:16 -0400
IronPort-SDR: gLOE120BEMBTgslZZHGA/+yNhtzkp2Pw2v2aE5lkC4/bum9njt/FeLA+QWuBiphHGH7gIpG/9z
 Vy+RqIRNjZYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="212982331"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212982331"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:14 -0700
IronPort-SDR: NTMx+VrlXOkgmjVTGeNFOytlM/RJGiBE9rfy+GojpwCvDdlAEBCcNV4ct5JYkHQV/9FQIvcTUU
 Q8AUzw9d8XwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087568"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 06/15] ice: fix overwriting TX/RX descriptor values when rebuilding VSI
Date:   Wed, 29 Jul 2020 09:23:56 -0700
Message-Id: <20200729162405.1596435-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

If a user sets the value of the TX or RX descriptors to some non-default
value using 'ethtool -G' then we need to not overwrite the values when
we rebuild the VSI. The VSI rebuild could happen as a result of a user
setting the number of queues via the 'ethtool -L' command. Fix this by
checking to see if the value we have stored is non-zero and if it is
then don't change the value.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8f6a191839f1..84202c814c3b 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -127,8 +127,14 @@ static void ice_vsi_set_num_desc(struct ice_vsi *vsi)
 	case ICE_VSI_PF:
 	case ICE_VSI_CTRL:
 	case ICE_VSI_LB:
-		vsi->num_rx_desc = ICE_DFLT_NUM_RX_DESC;
-		vsi->num_tx_desc = ICE_DFLT_NUM_TX_DESC;
+		/* a user could change the values of num_[tr]x_desc using
+		 * ethtool -G so we should keep those values instead of
+		 * overwriting them with the defaults.
+		 */
+		if (!vsi->num_rx_desc)
+			vsi->num_rx_desc = ICE_DFLT_NUM_RX_DESC;
+		if (!vsi->num_tx_desc)
+			vsi->num_tx_desc = ICE_DFLT_NUM_TX_DESC;
 		break;
 	default:
 		dev_dbg(ice_pf_to_dev(vsi->back), "Not setting number of Tx/Rx descriptors for VSI type %d\n",
-- 
2.26.2

