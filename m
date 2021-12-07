Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CE546C524
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 21:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbhLGVAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 16:00:11 -0500
Received: from mga04.intel.com ([192.55.52.120]:31627 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233640AbhLGVAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 16:00:05 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="236423611"
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="236423611"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 12:56:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="515821867"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 07 Dec 2021 12:56:18 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1B7Ku9kj018910;
        Tue, 7 Dec 2021 20:56:16 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v3 net-next 6/9] igc: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Date:   Tue,  7 Dec 2021 21:55:33 +0100
Message-Id: <20211207205536.563550-7-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211207205536.563550-1-alexandr.lobakin@intel.com>
References: <20211207205536.563550-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
speed-up memcpy() a little and better match igc_costruct_skb().

Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 142c57b7a451..a2e8d43be3a1 100644
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
2.33.1

