Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A648C1B6B1A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgDXCLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbgDXCLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:11:53 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4262921556;
        Fri, 24 Apr 2020 02:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587694312;
        bh=gOe6xfSoB9Y0L82Uq8k70E6AaaX0Ms7CPw8ZPtmGWnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmlBwUiInqINR43oFM8Bi0l7gt45JmUZ7bPLs8CdckmqMt01MqRRwmP3GrTtJwwz1
         kzQ1+1h8rmAB9TFxg/+RW5RrPr3jE5ku8RfPalG6NLvjRmQk7+zVJ5/zr4jMwst4Ze
         BAlS5Ai1hvAVMcYwM0Hyih2aFGyv38yeT5Do3GIQ=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v2 bpf-next 01/17] net: Refactor convert_to_xdp_frame
Date:   Thu, 23 Apr 2020 20:11:32 -0600
Message-Id: <20200424021148.83015-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200424021148.83015-1-dsahern@kernel.org>
References: <20200424021148.83015-1-dsahern@kernel.org>
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

