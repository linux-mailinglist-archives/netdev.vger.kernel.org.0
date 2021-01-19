Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3D72FC132
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbhASUhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:37:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729933AbhASUWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E4DD23137;
        Tue, 19 Jan 2021 20:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087659;
        bh=qxAMkTcvy7a03HNUrSCHfTmOJmHHhmfl7L9icGtloug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5letdSC5mgmBS65iL+A0bmd8CrgN5P5NZp3pS01KNnsJUBqCi914T6aOrYnKAO8B
         jibj99qd31oZQQanPdMz9kcLhQzGn9/ZArxA3fmLCDkXS2AGqbMRF789P3glCJERVK
         oROPxRAUQ+ILZo+JRzy7SCktxiT9DRynxvo7fb88JHU4jO1pfxGLuthHoE6t956yca
         Qp0xN3NPdFb7xiK4KWHUyT7t4nMO6HLPIKGnwlmBjanQtsfe/oRMLKm9jKmVNdClf2
         3Z4jzi+dUYrEjdtK7di/iRQmjl7lirghP/590FPhMbkm6T2xr2+P1HrkA9G16ochhn
         nigNg2CkHcTVg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v6 bpf-next 7/8] net: xdp: add multi-buff support to xdp_build_skb_from_fram
Date:   Tue, 19 Jan 2021 21:20:13 +0100
Message-Id: <ad7adf43a8f90fa4176497215be7ee2b2ebe60af.1611086134.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611086134.git.lorenzo@kernel.org>
References: <cover.1611086134.git.lorenzo@kernel.org>
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
index af9b9c1194fc..a7cd1ffbab6b 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -592,9 +592,21 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
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
 
@@ -613,6 +625,20 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
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
2.29.2

