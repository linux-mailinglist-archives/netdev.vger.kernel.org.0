Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4635692420
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbjBJRLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbjBJRLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:11:03 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACA961D14;
        Fri, 10 Feb 2023 09:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676049061; x=1707585061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pSwMio9dHbeElcd9EClSiOAjWsuea3W0mqj2c2eWgqs=;
  b=hyBYVTKb/EKE/S9lkbx2A1/NVnyaEQ/ZSarzPLi7waLZ05RyaNirnCbY
   J5/kShb8jcg0tTMf2Gd6ZZDoxntmq5tJSGRZCD0gN/hFsKbIGnIdskcGp
   m5meTPYtgx2KFZOWUk1Hlw4Q1E5FYRfgZDEsgHIKMCpl0smRlz+ufqTBM
   1A1yUqipaJt09bHK4iW0j5oIyfjjc9dlYT6WBsBx7bE6g4PRKQbKUetJu
   Cmc3MLIay05BksIOAm9Rzopm/++AZswyBB7c4aV5i7yGE4TFeo6a3zWbR
   Qhaumj9bC4k38svXxOBNRcq4v2EIW5JeERda4p1SLD+oxKCLR4B8J+N6M
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="395076700"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="395076700"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 09:07:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="668107543"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="668107543"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga002.jf.intel.com with ESMTP; 10 Feb 2023 09:07:26 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id A3ECF3C627;
        Fri, 10 Feb 2023 17:07:24 +0000 (GMT)
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
Subject: [PATCH bpf-next 3/6] ice: remove two impossible branches on XDP Tx cleaning
Date:   Fri, 10 Feb 2023 18:06:15 +0100
Message-Id: <20230210170618.1973430-4-alexandr.lobakin@intel.com>
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

The tagged commit started sending %XDP_TX frames from XSk Rx ring
directly without converting it to an &xdp_frame. However, when XSk is
enabled on a queue pair, it has its separate Tx cleaning functions, so
neither ice_clean_xdp_irq() nor ice_unmap_and_free_tx_buf() ever happens
there.
Remove impossible branches in order to reduce the diffstat of the
upcoming change.

Fixes: a24b4c6e9aab ("ice: xsk: Do not convert to buff to frame for XDP_TX")
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 5 +----
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 466113c86e6f..6b99adb695e7 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -116,10 +116,7 @@ ice_unmap_and_free_tx_buf(struct ice_tx_ring *ring, struct ice_tx_buf *tx_buf)
 		if (tx_buf->tx_flags & ICE_TX_FLAGS_DUMMY_PKT) {
 			devm_kfree(ring->dev, tx_buf->raw_buf);
 		} else if (ice_ring_is_xdp(ring)) {
-			if (ring->xsk_pool)
-				xsk_buff_free(tx_buf->xdp);
-			else
-				page_frag_free(tx_buf->raw_buf);
+			page_frag_free(tx_buf->raw_buf);
 		} else {
 			dev_kfree_skb_any(tx_buf->skb);
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 784f2f9ebb2d..6371acb0deb0 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -275,10 +275,7 @@ static u32 ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 		ready_frames -= frags + 1;
 		xdp_tx++;
 
-		if (xdp_ring->xsk_pool)
-			xsk_buff_free(tx_buf->xdp);
-		else
-			ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
+		ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
 		ntc++;
 		if (ntc == cnt)
 			ntc = 0;
-- 
2.39.1

