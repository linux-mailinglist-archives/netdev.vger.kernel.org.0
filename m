Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8972F4A5A72
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 11:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbiBAKqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 05:46:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59010 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiBAKqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 05:46:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D608B614DE;
        Tue,  1 Feb 2022 10:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A03C340EB;
        Tue,  1 Feb 2022 10:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643712397;
        bh=aqJLcfRFPPnFHHfAnyiHuR9KRapvF+nByXTbBwuCq70=;
        h=From:To:Cc:Subject:Date:From;
        b=G/Ndha+nsr8HIs0ZPRwNLoqXQ5a4YTVJno32NDpoQt2iB3tYE4Oci9F054tnjw6/I
         sbKakGpaTZcM1IYA1ecgmFDri3Z617itidxPU5PSLZXDnxCq7UfebQW92RgtIG4Hx7
         XQRipBWotjggLQGlG9waN865Pi/qS3M1vwUCzlr1fPRBzaPBFkBZSli+T+/koSww85
         Leq6Tnh5Bi3ghic3Vj9+Qq3PPrahzdSmMfGZmYFpQ5qcif2IjMs5rMJRpGTdjU8YMl
         66vwS5DaNnzFuq/Hq8zvTngoE3b276rbbinu5VE1xT5ISpEiLB4fcn89r2xuLzH4i3
         xPkaw1WHMpNJw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        andrii@kernel.org, pabeni@redhat.com, toshiaki.makita1@gmail.com
Subject: [PATCH bpf-next] net: veth: account total xdp_frame len running ndo_xdp_xmit
Date:   Tue,  1 Feb 2022 11:46:00 +0100
Message-Id: <705a05194508bc0c1b0c1a5de081bbb60f2693a5.1643712078.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_get_frame_len utility routine to get the xdp_frame full
length and account total frame size running XDP_REDIRECT of a
non-linear xdp frame into a veth device.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c |  4 ++--
 include/net/xdp.h  | 14 ++++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 354a963075c5..22ecaf8b8f98 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -493,7 +493,7 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 		struct xdp_frame *frame = frames[i];
 		void *ptr = veth_xdp_to_ptr(frame);
 
-		if (unlikely(frame->len > max_len ||
+		if (unlikely(xdp_get_frame_len(frame) > max_len ||
 			     __ptr_ring_produce(&rq->xdp_ring, ptr)))
 			break;
 		nxmit++;
@@ -854,7 +854,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 			/* ndo_xdp_xmit */
 			struct xdp_frame *frame = veth_ptr_to_xdp(ptr);
 
-			stats->xdp_bytes += frame->len;
+			stats->xdp_bytes += xdp_get_frame_len(frame);
 			frame = veth_xdp_rcv_one(rq, frame, bq, stats);
 			if (frame) {
 				/* XDP_PASS */
diff --git a/include/net/xdp.h b/include/net/xdp.h
index b7721c3e4d1f..04c852c7a77f 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -343,6 +343,20 @@ static inline void xdp_release_frame(struct xdp_frame *xdpf)
 	__xdp_release_frame(xdpf->data, mem);
 }
 
+static __always_inline unsigned int xdp_get_frame_len(struct xdp_frame *xdpf)
+{
+	struct skb_shared_info *sinfo;
+	unsigned int len = xdpf->len;
+
+	if (likely(!xdp_frame_has_frags(xdpf)))
+		goto out;
+
+	sinfo = xdp_get_shared_info_from_frame(xdpf);
+	len += sinfo->xdp_frags_size;
+out:
+	return len;
+}
+
 int __xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
 		       struct net_device *dev, u32 queue_index,
 		       unsigned int napi_id, u32 frag_size);
-- 
2.34.1

