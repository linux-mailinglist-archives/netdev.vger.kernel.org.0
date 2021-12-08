Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F196B46D51D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbhLHOLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:11:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:2741 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234754AbhLHOLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 09:11:07 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="261912441"
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="261912441"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 06:07:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,189,1635231600"; 
   d="scan'208";a="606303931"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 08 Dec 2021 06:07:29 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1B8E7Qud009548;
        Wed, 8 Dec 2021 14:07:27 GMT
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
        Jithu Joseph <jithu.joseph@intel.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v4 net-next 1/9] i40e: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Date:   Wed,  8 Dec 2021 15:06:54 +0100
Message-Id: <20211208140702.642741-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211208140702.642741-1-alexandr.lobakin@intel.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index f08d19b8c554..9564906b7da8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -245,13 +245,11 @@ static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
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
2.33.1

