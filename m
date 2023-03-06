Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4AD6ACFE0
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjCFVKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjCFVJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:09:45 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467E849888;
        Mon,  6 Mar 2023 13:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678136984; x=1709672984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VnhnkUoib1yzFtAHRHCxAqeWQV+3luRK3fGouYbL+TQ=;
  b=OQKd5zcEYLYiUn3K/72bl7Gw5083MCysmqy06XF+sS3GRVq10RW9Gnnd
   /a6s8dwbquhPjdmwMAzWIj3kfFztzz58M6OIC2vawT21KSD8AxrTYWSXZ
   qAwa1476ZkM1shcYa6HiWpAN/HRRFjB96R4YsUV+CogV+WRz5PrPd9/xB
   koe8musfNQuPilhDd2bE7qUin6gqmizXOY1j7jCK5EmTT9Sc/T3g9i/qc
   7ZanC8GEakCQRtuixeIXK0O3JLjzFmJ48iU1FT93iezpAlWOc2ciqhlw5
   RIwS/HKW4ELuumy35KWq4N9aIBreSCMOjn0lIrC0i7H+h9pOw1uff+8Ws
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="337999357"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="337999357"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 13:09:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="800137905"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="800137905"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga004.jf.intel.com with ESMTP; 06 Mar 2023 13:09:43 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH net-next 5/8] i40e: use frame_sz instead of recalculating truesize for building skb
Date:   Mon,  6 Mar 2023 13:08:19 -0800
Message-Id: <20230306210822.3381942-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230306210822.3381942-1-anthony.l.nguyen@intel.com>
References: <20230306210822.3381942-1-anthony.l.nguyen@intel.com>
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

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>

In skb path truesize is calculated while building skb. This is now
avoided and xdp->frame_is used instead for both i40e_build_skb() and
i40e_construct_skb().

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index fa44a2c353b2..e34595ca4fbe 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2113,11 +2113,6 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 					  struct xdp_buff *xdp)
 {
 	unsigned int size = xdp->data_end - xdp->data;
-#if (PAGE_SIZE < 8192)
-	unsigned int truesize = i40e_rx_pg_size(rx_ring) / 2;
-#else
-	unsigned int truesize = SKB_DATA_ALIGN(size);
-#endif
 	unsigned int headlen;
 	struct sk_buff *skb;
 
@@ -2162,10 +2157,10 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 	if (size) {
 		skb_add_rx_frag(skb, 0, rx_buffer->page,
 				rx_buffer->page_offset + headlen,
-				size, truesize);
+				size, xdp->frame_sz);
 
 		/* buffer is used by skb, update page_offset */
-		i40e_rx_buffer_flip(rx_buffer, truesize);
+		i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
 	} else {
 		/* buffer is unused, reset bias back to rx_buffer */
 		rx_buffer->pagecnt_bias++;
@@ -2188,13 +2183,6 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 				      struct xdp_buff *xdp)
 {
 	unsigned int metasize = xdp->data - xdp->data_meta;
-#if (PAGE_SIZE < 8192)
-	unsigned int truesize = i40e_rx_pg_size(rx_ring) / 2;
-#else
-	unsigned int truesize = SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
-				SKB_DATA_ALIGN(xdp->data_end -
-					       xdp->data_hard_start);
-#endif
 	struct sk_buff *skb;
 
 	/* Prefetch first cache line of first page. If xdp->data_meta
@@ -2205,7 +2193,7 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 	net_prefetch(xdp->data_meta);
 
 	/* build an skb around the page buffer */
-	skb = napi_build_skb(xdp->data_hard_start, truesize);
+	skb = napi_build_skb(xdp->data_hard_start, xdp->frame_sz);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -2216,7 +2204,7 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 		skb_metadata_set(skb, metasize);
 
 	/* buffer is used by skb, update page_offset */
-	i40e_rx_buffer_flip(rx_buffer, truesize);
+	i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
 
 	return skb;
 }
-- 
2.38.1

