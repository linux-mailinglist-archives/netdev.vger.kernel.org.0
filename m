Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5843583C1
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhDHMwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231668AbhDHMwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 08:52:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84F1261131;
        Thu,  8 Apr 2021 12:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617886313;
        bh=tDqB0Ey7DwyVDYXMPU2eRxTOZD4Z/gsFYf6a8/8/tlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYfxkWFfNoumpu/x13hSgsKE+moyh+TEWz1GQ7b39RfAuiSig3qCw7lDAprdH6Dj+
         QFVI0BSX+a2HJo+4caKKSsq6CBddpEPKB6Bftoh0tfIHmkqBNnrrMf0QTfIh8Bntf5
         O/BSz1TIUnR2pAcHC778x3H7nfZoqzsG4VzTmFrnpgspBU/KGvVmpOP4b6C9lN4z3c
         MzjoR9qccTQfJH9IlDas6g8dTo1uxCAUmi8K6tjM4GrKOmt6ToRxpd25GBzxQxEioP
         2Q0Yof0KGcfFYXuvjbPW8fTapEHS86Jh8EkqzQh2/qlr/dSeQNWtnUlgOSw5Lmzsdt
         Xh4IbS36B1kIQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: [PATCH v8 bpf-next 07/14] net: xdp: add multi-buff support to xdp_build_skb_from_fram
Date:   Thu,  8 Apr 2021 14:50:59 +0200
Message-Id: <2ffe99be4545b01436f23405177c618916d84a19.1617885385.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617885385.git.lorenzo@kernel.org>
References: <cover.1617885385.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp multi-buff support to
__xdp_build_skb_from_frame/xdp_build_skb_from_fram utility
routines.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/core/xdp.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 430f516259d9..7388bc6d680b 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -603,9 +603,21 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 					   struct sk_buff *skb,
 					   struct net_device *dev)
 {
+	skb_frag_t frag_list[MAX_SKB_FRAGS];
 	unsigned int headroom, frame_size;
+	int i, num_frags = 0;
 	void *hard_start;
 
+	/* XDP multi-buff frame */
+	if (unlikely(xdpf->mb)) {
+		struct xdp_shared_info *xdp_sinfo;
+
+		xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
+		num_frags = xdp_sinfo->nr_frags;
+		memcpy(frag_list, xdp_sinfo->frags,
+		       sizeof(skb_frag_t) * num_frags);
+	}
+
 	/* Part of headroom was reserved to xdpf */
 	headroom = sizeof(*xdpf) + xdpf->headroom;
 
@@ -624,6 +636,20 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	if (xdpf->metasize)
 		skb_metadata_set(skb, xdpf->metasize);
 
+	/* Single-buff XDP frame */
+	if (likely(!num_frags))
+		goto out;
+
+	for (i = 0; i < num_frags; i++) {
+		struct page *page = xdp_get_frag_page(&frag_list[i]);
+
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+				page, xdp_get_frag_offset(&frag_list[i]),
+				xdp_get_frag_size(&frag_list[i]),
+				xdpf->frame_sz);
+	}
+
+out:
 	/* Essential SKB info: protocol and skb->dev */
 	skb->protocol = eth_type_trans(skb, dev);
 
-- 
2.30.2

