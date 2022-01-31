Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F9E4A4E68
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356567AbiAaScV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:32:21 -0500
Received: from mga07.intel.com ([134.134.136.100]:38008 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356241AbiAaScR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 13:32:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643653937; x=1675189937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sh8FW1smDvfyULwhJ66JfV201HnD++KCqgtWvx4CG+4=;
  b=DIkiIG4xpIzVwfnLSAMOTIL+YG1/eNayn7ClCtGtkP9ZM//0utQ8SbxW
   cHOXaGgW3ZZVXiuVSQDMtZd6ePrFgd+clujJGe12XBjXykP9Vig/Q4xut
   a8q6KMQOfdGMz9Erh/tApHj7lIX2QKKd+dV5usRW6r/IDZ7pUhgjGIH9y
   fHr0tZufoR5n1aUu8KdEV4GkkW1f5JI7PkE2Y6XS7X2fZIgZwBOlt6dlQ
   ly2phsLD2Xu2CnN5NuIPDtiJ4XFhoK3x+W5A2nYSUlOmWcY0I5tbfE4Hr
   sefS3Fe9ZYaUM4fdcTSgjA7nLCMOrWUMSRnD7DpLmS9Hu178JJxyJWUDS
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="310833067"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="310833067"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:32:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="598920417"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jan 2022 10:32:16 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bjorn@kernel.org, maciej.fijalkowski@intel.com,
        michal.swiatkowski@linux.intel.com, kafai@fb.com,
        songliubraving@fb.com, kpsingh@kernel.org, yhs@fb.com,
        andrii@kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net-next 5/9] ice: respect metadata on XSK Rx to skb
Date:   Mon, 31 Jan 2022 10:31:48 -0800
Message-Id: <20220131183152.3085432-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220131183152.3085432-1-anthony.l.nguyen@intel.com>
References: <20220131183152.3085432-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

For now, if the XDP prog returns XDP_PASS on XSK, the metadata will
be lost as it doesn't get copied to the skb.

Copy it along with the frame headers. Account its size on skb
allocation, and when copying just treat it as a part of the frame
and do a pull after to "move" it to the "reserved" zone.

net_prefetch() xdp->data_meta and align the copy size to speed-up
memcpy() a little and better match ice_construct_skb().

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 8fd8052edf09..feb874bde171 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -428,18 +428,24 @@ static void ice_bump_ntc(struct ice_rx_ring *rx_ring)
 static struct sk_buff *
 ice_construct_skb_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
 {
+	unsigned int totalsize = xdp->data_end - xdp->data_meta;
 	unsigned int metasize = xdp->data - xdp->data_meta;
-	unsigned int datasize = xdp->data_end - xdp->data;
 	struct sk_buff *skb;
 
-	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, datasize,
+	net_prefetch(xdp->data_meta);
+
+	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, totalsize,
 			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		return NULL;
 
-	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
-	if (metasize)
+	memcpy(__skb_put(skb, totalsize), xdp->data_meta,
+	       ALIGN(totalsize, sizeof(long)));
+
+	if (metasize) {
 		skb_metadata_set(skb, metasize);
+		__skb_pull(skb, metasize);
+	}
 
 	xsk_buff_free(xdp);
 	return skb;
-- 
2.31.1

