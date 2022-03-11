Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692614D5E22
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 10:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345408AbiCKJQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 04:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbiCKJQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 04:16:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D4F1BB739;
        Fri, 11 Mar 2022 01:15:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59A5CB8299A;
        Fri, 11 Mar 2022 09:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4C2C340E9;
        Fri, 11 Mar 2022 09:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646990103;
        bh=rXL77Q12KqMeZVo0cFoB+g0xbu14At7FWgr78IMxYmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJTBIhalogwxLVq6h70/YhceHEGgNBRIEz5CU4p/+YsqAe9zCNcuVUAdU5ZNYy2+4
         4EATkO4l0FZg97ev1bj/yju5jCTl4nlkEC23YBJ/mhieyeSp7xMDCyzT8P6gr4Uq5l
         9XLzg5OFzQjtSRgiFc2I3Go8E0JLSQCy/z/N6JstMw5aASKU6gsL3uu0TXwcn3IFsy
         jLSt6wa+G3MB4sgjZEZtDgd6u+EfKhqEgwGQv1XWs5FFyfpg98c3nXHC0PLuXV2p3q
         pE0iTdWWPAkH6mG2G37lk3/MxR5/K92gApiHLSZU2Y0I1F2xuLXpq715fBxNiM6rZ4
         iUClQOorEEgiA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH v5 bpf-next 1/3] net: veth: account total xdp_frame len running ndo_xdp_xmit
Date:   Fri, 11 Mar 2022 10:14:18 +0100
Message-Id: <54f9fd3bb65d190daf2c0bbae2f852ff16cfbaa0.1646989407.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1646989407.git.lorenzo@kernel.org>
References: <cover.1646989407.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c |  4 ++--
 include/net/xdp.h  | 14 ++++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 58b20ea171dd..b77ce3fdcfe8 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -494,7 +494,7 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 		struct xdp_frame *frame = frames[i];
 		void *ptr = veth_xdp_to_ptr(frame);
 
-		if (unlikely(frame->len > max_len ||
+		if (unlikely(xdp_get_frame_len(frame) > max_len ||
 			     __ptr_ring_produce(&rq->xdp_ring, ptr)))
 			break;
 		nxmit++;
@@ -855,7 +855,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
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

