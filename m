Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DDB4A4E6B
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356438AbiAaScW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:32:22 -0500
Received: from mga07.intel.com ([134.134.136.100]:38008 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356230AbiAaScS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 13:32:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643653938; x=1675189938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U6fypeuYpWWJTwM4MjWXNU55yNI4I6e6C9x30RiXJIw=;
  b=eeB/iq4ItbHgCeSOHnatitBCMU44o+obEGbOfns+7VIEte7roeuBqhu9
   wKixyX3wjNpjT4+qPodHzARinngGKz6o5ppbbgTd632aA7S+xk9x7B5o8
   Z+aGfevnPscs6dbR0pBURffVqOKcx/Pq2ra/RqbGWY1QjH++jNKUyAXGm
   ROtZ3OpmFfJ4gxbt3NOmA6yL2PInc5vACuqzQKpYP1hCY19JFC7Yhd5n7
   8gwoZfnlgtAbwIaUYpyLCQVaoZ+iAJmFRGQUFm1KY+6OGkthBvBSFIJNH
   w9lCWU069ku4hHmRnVVl87cIS3ebCnHZSgFa9iacXGwV+VfCTsB1DJiAj
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="310833072"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="310833072"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:32:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="598920424"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jan 2022 10:32:17 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bjorn@kernel.org, maciej.fijalkowski@intel.com,
        michal.swiatkowski@linux.intel.com, kafai@fb.com,
        songliubraving@fb.com, kpsingh@kernel.org, yhs@fb.com,
        andrii@kernel.org, bpf@vger.kernel.org,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net-next 6/9] igc: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Date:   Mon, 31 Jan 2022 10:31:49 -0800
Message-Id: <20220131183152.3085432-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220131183152.3085432-1-anthony.l.nguyen@intel.com>
References: <20220131183152.3085432-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

{__,}napi_alloc_skb() allocates and reserves additional NET_SKB_PAD
+ NET_IP_ALIGN for any skb.
OTOH, igc_construct_skb_zc() currently allocates and reserves
additional `xdp->data_meta - xdp->data_hard_start`, which is about
XDP_PACKET_HEADROOM for XSK frames.
There's no need for that at all as the frame is post-XDP and will
go only to the networking stack core.
Pass the size of the actual data only (+ meta) to
__napi_alloc_skb() and don't reserve anything. This will give
enough headroom for stack processing.
Also, net_prefetch() xdp->data_meta and align the copy size to
speed-up memcpy() a little and better match igc_construct_skb().

Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6b51baadee3d..b965fb809d84 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2446,19 +2446,20 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 static struct sk_buff *igc_construct_skb_zc(struct igc_ring *ring,
 					    struct xdp_buff *xdp)
 {
+	unsigned int totalsize = xdp->data_end - xdp->data_meta;
 	unsigned int metasize = xdp->data - xdp->data_meta;
-	unsigned int datasize = xdp->data_end - xdp->data;
-	unsigned int totalsize = metasize + datasize;
 	struct sk_buff *skb;
 
-	skb = __napi_alloc_skb(&ring->q_vector->napi,
-			       xdp->data_end - xdp->data_hard_start,
+	net_prefetch(xdp->data_meta);
+
+	skb = __napi_alloc_skb(&ring->q_vector->napi, totalsize,
 			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		return NULL;
 
-	skb_reserve(skb, xdp->data_meta - xdp->data_hard_start);
-	memcpy(__skb_put(skb, totalsize), xdp->data_meta, totalsize);
+	memcpy(__skb_put(skb, totalsize), xdp->data_meta,
+	       ALIGN(totalsize, sizeof(long)));
+
 	if (metasize) {
 		skb_metadata_set(skb, metasize);
 		__skb_pull(skb, metasize);
-- 
2.31.1

