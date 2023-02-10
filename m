Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1775692424
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbjBJRLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbjBJRLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:11:07 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDD161D24;
        Fri, 10 Feb 2023 09:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676049066; x=1707585066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mXC1wYdaWDPX2EEPCNoSTO5uSfNqkr0zYAv+i/Imnms=;
  b=kQ/SFTiko5LqtflSC6clRd9xw8XZpe6ZIwmI5+T15zt+XbgJRP6bN41k
   KvopP6qoj9Upm5pTxuAc4vnJpEbHvF7uMK4biYzA9E7Z5wGPvlKireqtP
   4gD/r84e4YSToOSqq+7g9pMb56ZwIUECQ1e6rw5/guSffDLCwheKD9IN2
   HeaCOUTxDZsv4G1GHqzgxUaQkT2m4NYd0CH252IU3NXiXRuGddtQjOjeo
   8kRmAAhEhFcqMINrZFFrNAyZw8vCogMHiiTweFjQUqCDivJvrqkUv+4oF
   jSZDlpQJvDlfPTsaggDkjAiJjSeFRlWOnnVH4E/S9neDy2v2m16ARu4Rg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="395076691"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="395076691"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 09:07:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="668107541"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="668107541"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga002.jf.intel.com with ESMTP; 10 Feb 2023 09:07:25 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id B8EB63C626;
        Fri, 10 Feb 2023 17:07:23 +0000 (GMT)
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 2/6] ice: fix XDP Tx ring overrun
Date:   Fri, 10 Feb 2023 18:06:14 +0100
Message-Id: <20230210170618.1973430-3-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
References: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes, under heavy XDP Tx traffic, e.g. when using XDP traffic
generator (%BPF_F_TEST_XDP_LIVE_FRAMES), the machine can catch OOM due
to the driver not freeing all of the pages passed to it by
.ndo_xdp_xmit().
Turned out that during the development of the tagged commit, the check,
which ensures that we have a free descriptor to queue a frame, moved
into the branch happening only when a buffer has frags. Otherwise, we
only run a cleaning cycle, but don't check anything.
ATST, there can be situations when the driver gets new frames to send,
but there are no buffers that can be cleaned/completed and the ring has
no free slots. It's very rare, but still possible (> 6.5 Mpps per ring).
The driver then fills the next buffer/descriptor, effectively
overwriting the data, which still needs to be freed.

Restore the check after the cleaning routine to make sure there is a
slot to queue a new frame. When there are frags, there still will be a
separate check that we can place all of them, but if the ring is full,
there's no point in wasting any more time.

(minor: make `!ready_frames` unlikely since it happens ~1-2 times per
 billion of frames)

Fixes: 3246a10752a7 ("ice: Add support for XDP multi-buffer on Tx side")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index d1a7171e618b..784f2f9ebb2d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -260,7 +260,7 @@ static u32 ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 			ready_frames = idx + cnt - ntc + 1;
 	}
 
-	if (!ready_frames)
+	if (unlikely(!ready_frames))
 		return 0;
 	ret = ready_frames;
 
@@ -322,17 +322,17 @@ int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring)
 	u32 frag = 0;
 
 	free_space = ICE_DESC_UNUSED(xdp_ring);
-
-	if (ICE_DESC_UNUSED(xdp_ring) < ICE_RING_QUARTER(xdp_ring))
+	if (free_space < ICE_RING_QUARTER(xdp_ring))
 		free_space += ice_clean_xdp_irq(xdp_ring);
 
+	if (unlikely(!free_space))
+		goto busy;
+
 	if (unlikely(xdp_buff_has_frags(xdp))) {
 		sinfo = xdp_get_shared_info_from_buff(xdp);
 		nr_frags = sinfo->nr_frags;
-		if (free_space < nr_frags + 1) {
-			xdp_ring->ring_stats->tx_stats.tx_busy++;
-			return ICE_XDP_CONSUMED;
-		}
+		if (free_space < nr_frags + 1)
+			goto busy;
 	}
 
 	tx_desc = ICE_TX_DESC(xdp_ring, ntu);
@@ -396,6 +396,11 @@ int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring)
 		ntu--;
 	}
 	return ICE_XDP_CONSUMED;
+
+busy:
+	xdp_ring->ring_stats->tx_stats.tx_busy++;
+
+	return ICE_XDP_CONSUMED;
 }
 
 /**
-- 
2.39.1

