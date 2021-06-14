Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA33E3A670C
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhFNMxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233673AbhFNMxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:53:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C8CB61350;
        Mon, 14 Jun 2021 12:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623675063;
        bh=1UOgEyiGSzIUDPSteKTTfU0RTqIkE7EXXb81wVVqdFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgOdreFYTddnBvWkpARrfeHfnZOxmhTq/Ym8m9WbcGFx+dJeJ6zvqdOyB6fdVSopO
         ezbLtvIfdImYKxfdcCthNShWrY1mMZAmxH9opZ3tDxITGOMEsDOS0bFLUoIA5fd9j8
         v05tQKAUYTi37IOIkXMJkFyf0fXoVtd2GXlTdsL+yzdVLrbQXvEL/WHIRm/TND629O
         Zp5FpTJhBSzkadwDZD7VhgHlJqfBV+kuIKFZvYahAuNbacs/Fm0ZOj8HffK0ZQy5Nn
         TwyDReL4rHugLz9Qp7TcMlqI4iUM62RJj/Foqpg4b0kncWCJmAbx+11F03fH9jNPQt
         5YmeSXlmgNfug==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH v9 bpf-next 07/14] net: xdp: add multi-buff support to xdp_build_skb_from_frame
Date:   Mon, 14 Jun 2021 14:49:45 +0200
Message-Id: <7f61f8f7d38cf819383db739c14c874ccd3b53e2.1623674025.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp multi-buff support to
__xdp_build_skb_from_frame/xdp_build_skb_from_frame
utility routines.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/core/xdp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index f61c63115c95..71bedf6049a1 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -582,9 +582,15 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 					   struct sk_buff *skb,
 					   struct net_device *dev)
 {
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
 	unsigned int headroom, frame_size;
+	int i, num_frags = 0;
 	void *hard_start;
 
+	/* xdp multi-buff frame */
+	if (unlikely(xdp_frame_is_mb(xdpf)))
+		num_frags = sinfo->nr_frags;
+
 	/* Part of headroom was reserved to xdpf */
 	headroom = sizeof(*xdpf) + xdpf->headroom;
 
@@ -603,6 +609,13 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	if (xdpf->metasize)
 		skb_metadata_set(skb, xdpf->metasize);
 
+	for (i = 0; i < num_frags; i++)
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+				skb_frag_page(&sinfo->frags[i]),
+				skb_frag_off(&sinfo->frags[i]),
+				skb_frag_size(&sinfo->frags[i]),
+				xdpf->frame_sz);
+
 	/* Essential SKB info: protocol and skb->dev */
 	skb->protocol = eth_type_trans(skb, dev);
 
-- 
2.31.1

