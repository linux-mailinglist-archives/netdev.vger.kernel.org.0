Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974B849857B
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbiAXQ4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:56:09 -0500
Received: from mga07.intel.com ([134.134.136.100]:29684 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244005AbiAXQ4G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 11:56:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643043366; x=1674579366;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XbnC0b/daGUu/26547IxKSqKtd7oKX/Z7dRfT7gTGDw=;
  b=VhEZEclmMcsLBt2sPN8AraeAjDLXi7kj7I8ure/OcJ+y2yo9+an3evvc
   mBBkEhmDY8cV+WZXXU1Wac2zHJfw+PjuydG2EcESuATiBFnVOiEtL6noD
   DnG+25J44XpcPmJiDPmXzDldGRO9HiNzMa0krSxhvkFfx1x8C+cD6O+QR
   BX69GX0gwnR4iiYlpqdN0Cg9P9qY2O82Sh+yTE4NKnihPvuVT2JoLKEX6
   tNz7GTaCMMTgR3FhzLnMZz3cZHkVIkmgHRNNXmJmnyftjaqLScFZRBNjq
   HTa4cphuo5veqsR+6xIHQGMgomFqle5XoGF2vc1Bj80sYx1qfjAahWqMO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="309411464"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="309411464"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 08:56:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="617312056"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Jan 2022 08:56:04 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v4 6/8] ice: xsk: avoid potential dead AF_XDP Tx processing
Date:   Mon, 24 Jan 2022 17:55:45 +0100
Message-Id: <20220124165547.74412-7-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220124165547.74412-1-maciej.fijalkowski@intel.com>
References: <20220124165547.74412-1-maciej.fijalkowski@intel.com>
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

