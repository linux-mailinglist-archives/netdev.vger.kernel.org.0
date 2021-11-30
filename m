Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C926463D93
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 19:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245413AbhK3SVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 13:21:03 -0500
Received: from mga17.intel.com ([192.55.52.151]:22722 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245423AbhK3SVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 13:21:01 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="216976654"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="216976654"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 10:00:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="654258449"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 30 Nov 2021 10:00:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        andrii@kernel.org, kpsingh@kernel.org, kafai@fb.com, yhs@fb.com,
        songliubraving@fb.com,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net-next 1/2] igc: AF_XDP zero-copy metadata adjust breaks SKBs on XDP_PASS
Date:   Tue, 30 Nov 2021 09:59:17 -0800
Message-Id: <20211130175918.3705966-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211130175918.3705966-1-anthony.l.nguyen@intel.com>
References: <20211130175918.3705966-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

Driver already implicitly supports XDP metadata access in AF_XDP
zero-copy mode, as xsk_buff_pool's xp_alloc() naturally set xdp_buff
data_meta equal data.

This works fine for XDP and AF_XDP, but if a BPF-prog adjust via
bpf_xdp_adjust_meta() and choose to call XDP_PASS, then igc function
igc_construct_skb_zc() will construct an invalid SKB packet. The
function correctly include the xdp->data_meta area in the memcpy, but
forgot to pull header to take metasize into account.

Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 8e448288ee26..76b0a7311369 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2448,8 +2448,10 @@ static struct sk_buff *igc_construct_skb_zc(struct igc_ring *ring,
 
 	skb_reserve(skb, xdp->data_meta - xdp->data_hard_start);
 	memcpy(__skb_put(skb, totalsize), xdp->data_meta, totalsize);
-	if (metasize)
+	if (metasize) {
 		skb_metadata_set(skb, metasize);
+		__skb_pull(skb, metasize);
+	}
 
 	return skb;
 }
-- 
2.31.1

