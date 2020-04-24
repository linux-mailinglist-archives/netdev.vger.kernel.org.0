Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAD81B8040
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 22:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbgDXUOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 16:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728659AbgDXUOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 16:14:32 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 143A8215A4;
        Fri, 24 Apr 2020 20:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587759271;
        bh=0cK7BAcwG+LN56KdajxJRHtlJWGr1Z++kKa/PFq2mxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNCNYZjbWJXtRTsHL42KoEIGqQ1waaM/AuslMwaiOU7LrpvMc8ceslBj36vESgm1u
         wHFmM9jcB+pN/FROWRUeF0sTFSqlHTr8VIdZwPiaugThOP86Yams7jmdACdhOwfD1v
         fw70WAw1tosWr5XXKBvQoF/+O9gWx1cdLwwxkR3E=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v3 bpf-next 01/15] net: Refactor convert_to_xdp_frame
Date:   Fri, 24 Apr 2020 14:14:14 -0600
Message-Id: <20200424201428.89514-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200424201428.89514-1-dsahern@kernel.org>
References: <20200424201428.89514-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Move the guts of convert_to_xdp_frame to a new helper, update_xdp_frame
so it can be reused in a later patch.

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/xdp.h | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 40c6d3398458..779313862073 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -93,32 +93,42 @@ static inline void xdp_scrub_frame(struct xdp_frame *frame)
 
 struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
 
-/* Convert xdp_buff to xdp_frame */
 static inline
-struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
+bool update_xdp_frame(struct xdp_buff *xdp, struct xdp_frame *xdp_frame)
 {
-	struct xdp_frame *xdp_frame;
 	int metasize;
 	int headroom;
 
-	if (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY)
-		return xdp_convert_zc_to_xdp_frame(xdp);
-
 	/* Assure headroom is available for storing info */
 	headroom = xdp->data - xdp->data_hard_start;
 	metasize = xdp->data - xdp->data_meta;
 	metasize = metasize > 0 ? metasize : 0;
 	if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
-		return NULL;
-
-	/* Store info in top of packet */
-	xdp_frame = xdp->data_hard_start;
+		return false;
 
 	xdp_frame->data = xdp->data;
 	xdp_frame->len  = xdp->data_end - xdp->data;
 	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
 	xdp_frame->metasize = metasize;
 
+	return true;
+}
+
+/* Convert xdp_buff to xdp_frame */
+static inline
+struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
+{
+	struct xdp_frame *xdp_frame;
+
+	if (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY)
+		return xdp_convert_zc_to_xdp_frame(xdp);
+
+	/* Store info in top of packet */
+	xdp_frame = xdp->data_hard_start;
+
+	if (unlikely(!update_xdp_frame(xdp, xdp_frame)))
+		return NULL;
+
 	/* rxq only valid until napi_schedule ends, convert to xdp_mem_info */
 	xdp_frame->mem = xdp->rxq->mem;
 
-- 
2.21.1 (Apple Git-122.3)

