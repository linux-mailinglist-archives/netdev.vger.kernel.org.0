Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55A53946A8
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 19:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhE1Rp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 13:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhE1Rpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 13:45:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBABA61248;
        Fri, 28 May 2021 17:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622223858;
        bh=U/75aorPZzn/IjooJ9pxtYsQOLtdO7c8hdkxGWaE3UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9ErbdE+6bnwgst51xDLni9hqMBCs/foB4jhuyWZbJfzbvo4ktQje6a+YQY1RseVS
         OL3c1fMJ9ReFWW55Geop16jbPhpwe12PIuD3Q4HaAxtW5pmzrQVj4MR198HgCMTd8y
         JdadFo7x1VCPQZV9hRCuikeZpqqrCX8SYTfmSa6a33BEIG31BIhbval42Uopt74K7V
         XcZ9BLJUq07fu44/GrQL/sLWV+a71gfBVDRy5xSdIxS9A0ttsHXEaTqn7Pfki+8eoh
         LBepYUpDWKOPrg7IwAHx8YQEPIfBw5QxX+uREIa7LYvIpRN3XvUq2UtmCnCMo80j0c
         tC9SANx7GWNIw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, echaudro@redhat.com,
        dsahern@gmail.com, magnus.karlsson@intel.com, toke@redhat.com,
        brouer@redhat.com, bjorn@kernel.org, maciej.fijalkowski@intel.com,
        john.fastabend@gmail.com
Subject: [RFC bpf-next 4/4] net: xdp: update csum building the skb
Date:   Fri, 28 May 2021 19:43:44 +0200
Message-Id: <ed81f12a1e8804bb9fb207a2569d3086320869a7.1622222367.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622222367.git.lorenzo@kernel.org>
References: <cover.1622222367.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

update skb->ip_summed and skb->csum filed building the skb in
__xdp_build_skb_from_frame routine

Co-developed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/core/xdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 725d20f1b100..aadcbbc438c3 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -555,10 +555,10 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	skb->protocol = eth_type_trans(skb, dev);
 
 	/* Optional SKB info, currently missing:
-	 * - HW checksum info		(skb->ip_summed)
 	 * - HW RX hash			(skb_set_hash)
 	 * - RX ring dev queue index	(skb_record_rx_queue)
 	 */
+	xdp_frame_get_csum(xdpf, skb);
 
 	/* Until page_pool get SKB return path, release DMA here */
 	xdp_release_frame(xdpf);
-- 
2.31.1

