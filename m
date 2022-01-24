Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D9D498570
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243992AbiAXQzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:55:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:29653 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243985AbiAXQzx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 11:55:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643043353; x=1674579353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NghxkmY3f87twgZB5ZuXp/dUUlTQG84K+mbarO6dMS4=;
  b=F6YEKNx51kvMkd59orEApHSCQtDPrDl4DmElq294sGGSmuDUeurbsmSJ
   IczfWHAPcFcLfvWuwP15PcNj7jn0hHLzcOTMFGxFXRPRf1qfSNBUFLMsE
   rtZ51mkKYQtO2xib7QVtbrobqc5tagSnYtWJ/EAUA3sL5wDDSN2dCGMm0
   FD61SgBL8Jr2p2HTemVwY4W8VsW2epB/ESxEzybWBw4dT/RQPImM6FxoT
   nH37BAK1ZHbvtKWiHRjEq99LUGeD87dd0VGipT5MvJf6/jI4433X6m5bb
   XLqee87NsuH/53x3W8SrLABnnqxbQG/xYbBq/aO23VIl6rZPpekwNPdTY
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="309411416"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="309411416"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 08:55:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="617311978"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Jan 2022 08:55:51 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v4 1/8] ice: remove likely for napi_complete_done
Date:   Mon, 24 Jan 2022 17:55:40 +0100
Message-Id: <20220124165547.74412-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220124165547.74412-1-maciej.fijalkowski@intel.com>
References: <20220124165547.74412-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the likely before napi_complete_done as this is the unlikely case
when busy-poll is used. Removing this has a positive performance impact
for busy-poll and no negative impact to the regular case.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 3e38695f1c9d..e661d0e45b9b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1513,7 +1513,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	/* Exit the polling mode, but don't re-enable interrupts if stack might
 	 * poll us due to busy-polling
 	 */
-	if (likely(napi_complete_done(napi, work_done))) {
+	if (napi_complete_done(napi, work_done)) {
 		ice_net_dim(q_vector);
 		ice_enable_interrupt(q_vector);
 	} else {
-- 
2.33.1

