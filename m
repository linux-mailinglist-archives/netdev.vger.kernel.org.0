Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46A2495EC1
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 13:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350293AbiAUMAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 07:00:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:36384 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350222AbiAUMAm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 07:00:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642766442; x=1674302442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a186eXNPkax1sNYDYG0nbWrG9jTaVQGIxQl2OdizbmY=;
  b=kP5xFdiE7GsAGKJwMF4agfsELMeO9Et47MPIjkLkFGLxHbQYri1XZl9U
   YlHit1zsJWndvVHHpyyqavnMT9x3u5RAHWoSPQlljd3DHdyLHhFeLlNZ6
   U/YUZzSQSZ/Kt74DFNvsxUSJDprmUgIWm5juArRUwgjN7KBj0zSdK498n
   IuYMw8TIXjRtKaJ4fEYObgoEu4Sna3RhR/DvIGW+ztZgx4I+P6J1M46p/
   D4XwSgoyY04J24dduAChDVspKmwgI7KOkKE1rE1kZ2oIKmFg7qa408Yz9
   C0EXAyehNuv/29zlBoCqbq4iWDmlNxg+ArqDKAUDhuwvK7I/OSQSTVJ2g
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="270059003"
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="270059003"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 04:00:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="475924984"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 21 Jan 2022 04:00:38 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v3 5/7] ice: xsk: avoid potential dead AF_XDP Tx processing
Date:   Fri, 21 Jan 2022 13:00:09 +0100
Message-Id: <20220121120011.49316-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220121120011.49316-1-maciej.fijalkowski@intel.com>
References: <20220121120011.49316-1-maciej.fijalkowski@intel.com>
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

To protect us from the above, restore the default @next_rs and @next_dd
values when cleaning the Tx ring.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index e661d0e45b9b..bfb9158b10a4 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -173,6 +173,9 @@ void ice_clean_tx_ring(struct ice_tx_ring *tx_ring)
 
 	tx_ring->next_to_use = 0;
 	tx_ring->next_to_clean = 0;
+	tx_ring->tx_thresh = ice_get_tx_threshold(tx_ring);
+	tx_ring->next_dd = tx_ring->tx_thresh - 1;
+	tx_ring->next_rs = tx_ring->tx_thresh - 1;
 
 	if (!tx_ring->netdev)
 		return;
-- 
2.33.1

