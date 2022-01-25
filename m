Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0E949B82F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358893AbiAYQHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:07:11 -0500
Received: from mga18.intel.com ([134.134.136.126]:4809 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376813AbiAYQFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 11:05:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643126741; x=1674662741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DIOeayhcVxc4Q9jofvJi0McRLVlw0/v+bHlq9Z2cYcA=;
  b=hYUVktP/s2QoPYtdBd3QAkascvMD5AKoZYa5SD9zY1C4EECI5peRTucC
   BwQ4r5g0zxLyluSNkWiB3MPc6JXX9/Qg0wZZvBTslNfgifniYlveorwL3
   McpjdiocE8pcFVTLgX9V69vEyRhEBb2jlvZ5VGUdCHlxlkZF3PNj04ibs
   xjxORFh1dZDQQIzpjB+i4WpuHlUfL7r+pQOwgE201Tv031z2gcArj4iGq
   QUzCpNFjd5GwhaZMI5oeUZgC2mDe9Zr0gKXL+/MinpeRCEXnv7FSeDCLy
   WuK7lhYbAPB0ktUGtr+UEs+JFi2rVZi4l2q9X7JcGuDz9fnlnIP0RMzXN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="229911586"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="229911586"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 08:04:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="534789217"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 25 Jan 2022 08:04:52 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v5 2/8] ice: xsk: force rings to be sized to power of 2
Date:   Tue, 25 Jan 2022 17:04:40 +0100
Message-Id: <20220125160446.78976-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
References: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the upcoming introduction of batching to XSK data path,
performance wise it will be the best to have the ring descriptor count
to be aligned to power of 2.

Check if ring sizes that user is going to attach the XSK socket fulfill
the condition above. For Tx side, although check is being done against
the Tx queue and in the end the socket will be attached to the XDP
queue, it is fine since XDP queues get the ring->count setting from Tx
queues.

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 2388837d6d6c..27b087808313 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -327,6 +327,13 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	bool if_running, pool_present = !!pool;
 	int ret = 0, pool_failure = 0;
 
+	if (!is_power_of_2(vsi->rx_rings[qid]->count) ||
+	    !is_power_of_2(vsi->tx_rings[qid]->count)) {
+		netdev_err(vsi->netdev, "Please align ring sizes to power of 2\n");
+		pool_failure = -EINVAL;
+		goto failure;
+	}
+
 	if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
 
 	if (if_running) {
@@ -349,6 +356,7 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 			netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
 	}
 
+failure:
 	if (pool_failure) {
 		netdev_err(vsi->netdev, "Could not %sable buffer pool, error = %d\n",
 			   pool_present ? "en" : "dis", pool_failure);
-- 
2.33.1

