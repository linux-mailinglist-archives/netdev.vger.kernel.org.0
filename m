Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5611BB196
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgD0Wqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgD0Wqh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:46:37 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 462BD2087E;
        Mon, 27 Apr 2020 22:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588027597;
        bh=QmSY0DTkfhy13FYDnKDgFH45jP01Djrm+1DRtCEGZA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4J0+vjGlmOiVWkDynVS7SDj0fS+AF3pS5oqWwgAdRcizfn4bUnhy03TqV0y3C81j
         gaD+LPlFAruk3L0cND4jRjIFm3d+aZpJ0DqC7pVQp9Z3jXMai9cSufTVue3WhF7T14
         55NuK/1Rm8irjPyZ656YV7WU8kVcq9eerDMk2x+4=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v4 bpf-next 01/15] net: Refactor convert_to_xdp_frame
Date:   Mon, 27 Apr 2020 16:46:19 -0600
Message-Id: <20200427224633.15627-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200427224633.15627-1-dsahern@kernel.org>
References: <20200427224633.15627-1-dsahern@kernel.org>
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
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/xdp.h | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 3cc6d5d84aa4..3264fa882de3 100644
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

