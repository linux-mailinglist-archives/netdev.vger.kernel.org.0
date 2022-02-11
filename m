Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809204B1B25
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 02:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346748AbiBKBVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 20:21:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240428AbiBKBVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 20:21:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737BB2651;
        Thu, 10 Feb 2022 17:21:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB03860ABC;
        Fri, 11 Feb 2022 01:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890CBC004E1;
        Fri, 11 Feb 2022 01:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644542472;
        bh=8770Oj26UtXzBN52MZUpylHLUJorxegIVxsI5PIxp4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ytmi+TFqSWxGu8CgpffH5Shl9pB+R1+HxMI46NDLKKlyEgUBWhni3M0tXTvdo1r+y
         Yz/P6FHW9NDPCfnTd9W0MXstJzBfPfD4JCuG4C7B0HuCVq1vl2X5AVljc5m93TtGWy
         h0s0QlU7BC/Uueu2VpIKRRkG+VrYRnBz3roNmKT617SX/6Cg8hnjsVgJ40dmn21tpo
         4AUbX2gg177K5LUdvgBtkxzkzARnamq6QRsqZZvpl2J1IYW8905QjyXZPZaKiZ4oEl
         z3MV0ENUSFLjyo+mgbTlprxQBIleODzD68EtlJzqDmdxmz6wOpms9P9bK5IWU/+69u
         obgtdukY8caGQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 1/3] net: veth: account total xdp_frame len running ndo_xdp_xmit
Date:   Fri, 11 Feb 2022 02:20:30 +0100
Message-Id: <e3fef9abdb8414e8d5b37920ecd0776b2e9578c7.1644541123.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1644541123.git.lorenzo@kernel.org>
References: <cover.1644541123.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
2.34.1

