Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A93A49B838
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378496AbiAYQID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:08:03 -0500
Received: from mga18.intel.com ([134.134.136.126]:4805 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346846AbiAYQHH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 11:07:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643126825; x=1674662825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6T5/IoHsRo8fBpGFCMqevm9DsrHTuEd/m8MoI++MhFY=;
  b=Mt+zRyfrgZIVRRYza3A1wjQozh5pbbk8GqOsaBbfbbrPeevF4oRbrQgP
   IcUdVZurCyyjB9FFY5ByJRvymyZMwyRr7gPwPPfhpPNwI2IltEPUDi9YY
   myiDqcqAgg1oGT8BB8H5QpZ2fsZiR8CaBEoSPBrTww4gv7/9RTBZ5WwXN
   rGycPwXlMErzLoGPAsK/LNegkj9RrI/Gh7OM4e1guN9hgGcDGTNmP7UxA
   259zidP1m8MLroX4n5tknCntlrLY1CN41Vpq5ohmyFjn06+VaSLmcYaXa
   i2a1sCIY8cIG/mQRszo31od7Xh130dzA3HNUzJIzC28Vls9eaXbF1Uodf
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="229911651"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="229911651"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 08:05:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="534789281"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 25 Jan 2022 08:05:00 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v5 6/8] ice: xsk: avoid potential dead AF_XDP Tx processing
Date:   Tue, 25 Jan 2022 17:04:44 +0100
Message-Id: <20220125160446.78976-7-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
References: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9610bd988df9 ("ice: optimize XDP_TX workloads") introduced
@next_dd and @next_rs to ice_tx_ring struct. Currently, their state is
not restored in ice_clean_tx_ring(), which was not causing any troubles
as the XDP rings are gone after we're done with XDP prog on interface.

For upcoming usage of mentioned fields in AF_XDP, this might expose us
to a potential dead Tx side. Scenario would look like following (based
on xdpsock):

- two xdpsock instances are spawned in Tx mode
- one of them is killed
- XDP prog is kept on interface due to the other xdpsock still running
  * this means that XDP rings stayed in place
- xdpsock is launched again on same queue id that was terminated on
- @next_dd and @next_rs setting is bogus, therefore transmit side is
  broken

To protect us from the above, restore the initial @next_rs and @next_dd
values when cleaning the Tx ring.

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index e661d0e45b9b..73f60493209d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -173,6 +173,8 @@ void ice_clean_tx_ring(struct ice_tx_ring *tx_ring)
 
 	tx_ring->next_to_use = 0;
 	tx_ring->next_to_clean = 0;
+	tx_ring->next_dd = ICE_RING_QUARTER(tx_ring) - 1;
+	tx_ring->next_rs = ICE_RING_QUARTER(tx_ring) - 1;
 
 	if (!tx_ring->netdev)
 		return;
-- 
2.33.1

