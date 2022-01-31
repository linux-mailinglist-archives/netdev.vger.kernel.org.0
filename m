Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587484A4E60
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356304AbiAaScS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:32:18 -0500
Received: from mga07.intel.com ([134.134.136.100]:38004 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356230AbiAaScQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 13:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643653936; x=1675189936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5H2m/KKRTfsdBHydEynvggHXDKRrrN8WJG60adGgbwI=;
  b=I5uCDxqqi3BVlH4zBDHacYvVDojEBVVJovUXirAGjfbD1fr+le02bbcs
   UCzXcv45qK6SewdMEIdhjh6+9MA8pnhKk3WSKPndX6n3Tx0c5gtc13mdx
   WU3OKkxba5yyqasRTTWzLByUNg6MLjHEZO9TMEKIETwHqgBLQbGr8JD98
   JS0AtqRREzaKw0Ew0QY2uFxMNNgm1NaZhLKfmSzTj73pFsjoGOtzMzKND
   B3cEY1nkzq0u0ftE8/MN9+AI6rl1HoliUnLTfwteAUzNjt80u69GEMMcT
   la2eZIaUDl0/BEyezNxS2RhcDt32k649kpVqX7497UpS7YZwSYJdFCRAy
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="310833047"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="310833047"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:32:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="598920398"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jan 2022 10:32:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bjorn@kernel.org, maciej.fijalkowski@intel.com,
        michal.swiatkowski@linux.intel.com, kafai@fb.com,
        songliubraving@fb.com, kpsingh@kernel.org, yhs@fb.com,
        andrii@kernel.org, bpf@vger.kernel.org, sassmann@redhat.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net-next 1/9] i40e: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Date:   Mon, 31 Jan 2022 10:31:44 -0800
Message-Id: <20220131183152.3085432-2-anthony.l.nguyen@intel.com>
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
OTOH, i40e_construct_skb_zc() currently allocates and reserves
additional `xdp->data - xdp->data_hard_start`, which is
XDP_PACKET_HEADROOM for XSK frames.
There's no need for that at all as the frame is post-XDP and will
go only to the networking stack core.
Pass the size of the actual data only to __napi_alloc_skb() and
don't reserve anything. This will give enough headroom for stack
processing.

Fixes: 0a714186d3c0 ("i40e: add AF_XDP zero-copy Rx support")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 945b1bb9c6f4..a449c84fe357 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -246,13 +246,11 @@ static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* allocate a skb to store the frags */
-	skb = __napi_alloc_skb(&rx_ring->q_vector->napi,
-			       xdp->data_end - xdp->data_hard_start,
+	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, datasize,
 			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		goto out;
 
-	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
-- 
2.31.1

