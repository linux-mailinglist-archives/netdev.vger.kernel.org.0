Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECFD498572
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243991AbiAXQ4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:56:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:29653 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243999AbiAXQz5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 11:55:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643043357; x=1674579357;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xu1phWClHMgfxsN8cMvgKt5cUBB927FdJjZQTefcICw=;
  b=Tej5qsELjZOJxCHI3+UYP4UO7SWnU23WRBzQyAIpxN8yEORRo4jbEqp3
   XWMbe226+Ovz25kG/2fuvG6tgrfbJC3opZ2p87KRykbDtlkrWJgvK/HhJ
   JRaA6kPl7TZfi+gLZ6LEVjVsPeoIkqVkzg10whew3nb60tmZR6TXOMc5O
   ldlkELuRwsKNLVRZyZX6+QnmE1pxYNtCqPdTY9aTEpJmuubMMk/A6eWOA
   G5aHecM/YfmCgyvpw1oYK5YlVqUv8AmDyAUUaonk2VVGnqV3FDD4XQxQ9
   9cqthm1pTTZ/rJz0ykBoUgJtfPZRl/mlaD6n6Y7wGfiy5VClAwyzk9PDE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="309411436"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="309411436"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 08:55:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="617312001"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Jan 2022 08:55:53 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v4 2/8] ice: xsk: force rings to be sized to power of 2
Date:   Mon, 24 Jan 2022 17:55:41 +0100
Message-Id: <20220124165547.74412-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220124165547.74412-1-maciej.fijalkowski@intel.com>
References: <20220124165547.74412-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the upcoming introduction of batching to XSK data path,
performance wise it will be the best to have the ring descriptor count
to be aligned to power of 2.

Check if rings sizes that user is going to attach the XSK socket fulfill
the condition above. For Tx side, although check is being done against
the Tx queue and in the end the socket will be attached to the XDP
queue, it is fine since XDP queues get the ring->count setting from Tx
queues.

Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 2388837d6d6c..0350f9c22c62 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -327,6 +327,14 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	bool if_running, pool_present = !!pool;
 	int ret = 0, pool_failure = 0;
 
+	if (!is_power_of_2(vsi->rx_rings[qid]->count) ||
+	    !is_power_of_2(vsi->tx_rings[qid]->count)) {
+		netdev_err(vsi->netdev,
+			   "Please align ring sizes at idx %d to power of 2\n", qid);
+		pool_failure = -EINVAL;
+		goto failure;
+	}
+
 	if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
 
 	if (if_running) {
@@ -349,6 +357,7 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 			netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
 	}
 
+failure:
 	if (pool_failure) {
 		netdev_err(vsi->netdev, "Could not %sable buffer pool, error = %d\n",
 			   pool_present ? "en" : "dis", pool_failure);
-- 
2.33.1

