Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B4C206649
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388283AbgFWVkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393947AbgFWVj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:39:59 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0068B206E2;
        Tue, 23 Jun 2020 21:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592948399;
        bh=MAAIjogYPvF6bZtEPj7QH+K5jjnZ8/fLW8FlZpUuk6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ptVXjDv132lxrai9ONruLL7Esb3V3tcu037bRSTreRmOPsIy68ucoWIdjChhHQfl0
         +B1cioJkMn0YjHg0fyW5RjOeJ72ZqM82P5K5r9SnUbYWdttuR5D1S7m48eiESyJZuq
         0ukwLV8IWc83Ad2+u//grqo8/dEmjJ/2kkwSnOqQ=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com,
        David Ahern <dahern@digitalocean.com>
Subject: [PATCH v3 bpf-next 2/9] net: Refactor xdp_convert_buff_to_frame
Date:   Tue, 23 Jun 2020 23:39:27 +0200
Message-Id: <0f32f3dd1787f050b41ab1d32490b838544fe3e2.1592947694.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1592947694.git.lorenzo@kernel.org>
References: <cover.1592947694.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Move the guts of xdp_convert_buff_to_frame to a new helper,
xdp_update_frame_from_buff so it can be reused removing code duplication

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/net/xdp.h | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 609f819ed08b..5b383c450858 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -121,39 +121,48 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
 	xdp->frame_sz = frame->frame_sz;
 }
 
-/* Convert xdp_buff to xdp_frame */
 static inline
-struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
+int xdp_update_frame_from_buff(struct xdp_buff *xdp,
+			       struct xdp_frame *xdp_frame)
 {
-	struct xdp_frame *xdp_frame;
-	int metasize;
-	int headroom;
-
-	if (xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL)
-		return xdp_convert_zc_to_xdp_frame(xdp);
+	int metasize, headroom;
 
 	/* Assure headroom is available for storing info */
 	headroom = xdp->data - xdp->data_hard_start;
 	metasize = xdp->data - xdp->data_meta;
 	metasize = metasize > 0 ? metasize : 0;
 	if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
-		return NULL;
+		return -ENOSPC;
 
 	/* Catch if driver didn't reserve tailroom for skb_shared_info */
 	if (unlikely(xdp->data_end > xdp_data_hard_end(xdp))) {
 		XDP_WARN("Driver BUG: missing reserved tailroom");
-		return NULL;
+		return -ENOSPC;
 	}
 
-	/* Store info in top of packet */
-	xdp_frame = xdp->data_hard_start;
-
 	xdp_frame->data = xdp->data;
 	xdp_frame->len  = xdp->data_end - xdp->data;
 	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
 	xdp_frame->metasize = metasize;
 	xdp_frame->frame_sz = xdp->frame_sz;
 
+	return 0;
+}
+
+/* Convert xdp_buff to xdp_frame */
+static inline
+struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
+{
+	struct xdp_frame *xdp_frame;
+
+	if (xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL)
+		return xdp_convert_zc_to_xdp_frame(xdp);
+
+	/* Store info in top of packet */
+	xdp_frame = xdp->data_hard_start;
+	if (unlikely(xdp_update_frame_from_buff(xdp, xdp_frame) < 0))
+		return NULL;
+
 	/* rxq only valid until napi_schedule ends, convert to xdp_mem_info */
 	xdp_frame->mem = xdp->rxq->mem;
 
-- 
2.26.2

