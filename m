Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F155A4B6D0B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbiBONIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:08:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238112AbiBONIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:08:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D15C2499;
        Tue, 15 Feb 2022 05:08:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0346861701;
        Tue, 15 Feb 2022 13:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B175BC340EB;
        Tue, 15 Feb 2022 13:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644930521;
        bh=TdKJ5KtArW8oZdH6wJX2x4gsnFEh+MwA8zYwYPyPSXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H793LLeCabz9OuiNmr0iS5aTEff6gF+vDiZrih51JtuwIzUeEcWgl6/xGIbo66Rfj
         8XE2nJH4R9nhA+rx5cTBo7xlNTE5LJIhuYbmaeL6+94/RXV8vs7Bl/xf6Hr8+3a2hA
         RDfMBGbvNI/KzQPXB7P4bywb6KGW06kC/EB8rI4tluYR/TJ+yV5faDcE/A5s4zMP0j
         pboDMP4S0QBKcweA/2mzSy08sale4dArS+zOjxRMH3mgEcpHRUDr4VOSPvbT4BfNHJ
         xV491pGPoAcTNoP5jFlXOQmWimkQNiOZPVldo3Cbyl5aB0P5JDYmBn1ojF6ZPrdhiP
         ZXqpZeQxzaRyQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH v2 bpf-next 1/3] net: veth: account total xdp_frame len running ndo_xdp_xmit
Date:   Tue, 15 Feb 2022 14:08:09 +0100
Message-Id: <5bd9456d6d48f74515e835c7c4ec961b3dda2514.1644930125.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1644930124.git.lorenzo@kernel.org>
References: <cover.1644930124.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even if this is a theoretical issue since it is not possible to perform
XDP_REDIRECT on a non-linear xdp_frame, veth driver does not account
paged area in ndo_xdp_xmit function pointer.
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
2.35.1

