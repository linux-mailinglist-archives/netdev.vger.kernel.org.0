Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648BC4773D4
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 15:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbhLPOAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 09:00:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:12146 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237296AbhLPOAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 09:00:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639663206; x=1671199206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sa/yWGN3x5/+UAkTXPVaHrZREKWoZi4dHa4axyyjInQ=;
  b=Wf6OuqcnaEzxiHuJAsNHH8qHUqFZ1f4MY9omBTma3gUFZkFzBieGydPG
   5T0JcUO4DCttI1uiAR/+lhVeJGOjAe6EiJbZwH0kj1l7BqQfwUqRONna+
   WKgHy3SBujhJN7CCZHWUFY9hpprOmMUp6hNBMvLcbvCyeVbAUtJ51QtCi
   b8Bq0C7HWy5uphf8jgxQEnLzCLIa7wcZaa6DkCY/aW7AvgjnHd7zbVPej
   4MKqsqMaORlbPpO5065qsrkUUSJwtG5Y2hgqRUT1z2fFUQsm5BSjph/0k
   KT6JGDM3IkZMV1OBA9gr7Bmm87oqrrGiW+NhLPnjW3CEb9gOMdAUoyWr3
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226779264"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="226779264"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 06:00:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="545988226"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga001.jf.intel.com with ESMTP; 16 Dec 2021 06:00:05 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v2 2/4] ice: xsk: avoid potential dead AF_XDP Tx processing
Date:   Thu, 16 Dec 2021 14:59:56 +0100
Message-Id: <20211216135958.3434-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211216135958.3434-1-maciej.fijalkowski@intel.com>
References: <20211216135958.3434-1-maciej.fijalkowski@intel.com>
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
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index bc3ba19dc88f..0f3f92ce8a95 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -172,6 +172,8 @@ void ice_clean_tx_ring(struct ice_tx_ring *tx_ring)
 
 	tx_ring->next_to_use = 0;
 	tx_ring->next_to_clean = 0;
+	tx_ring->next_dd = ICE_TX_THRESH - 1;
+	tx_ring->next_rs = ICE_TX_THRESH - 1;
 
 	if (!tx_ring->netdev)
 		return;
-- 
2.33.1

