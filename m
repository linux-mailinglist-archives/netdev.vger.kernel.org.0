Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFFC25CB9D
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgICU7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbgICU7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 16:59:15 -0400
Received: from lore-desk.redhat.com (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B53C6206C0;
        Thu,  3 Sep 2020 20:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599166754;
        bh=jGFg9HepHezzAGnfdT1zopmNIIsBMcFzzfvdUYqTGvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHOX3U+/ytTB9CvsUP3j3x+dZF8ttjSFfq29cSyAAWFZ+Yf68+pIotIcc+tXz9ZPm
         fvrFSvBw6kdvN/SgKUKs/dy8HydKFBwOzj2N3Cwfj+c0kd3NcZslWagzh01zymzSAU
         TZzN5nhUJ8/CHGllxNkOgXUUtSPQABgWSW/Eh+LU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: [PATCH v2 net-next 1/9] xdp: introduce mb in xdp_buff/xdp_frame
Date:   Thu,  3 Sep 2020 22:58:45 +0200
Message-Id: <1e8e82f72e46264b7a7a1ac704d24e163ebed100.1599165031.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1599165031.git.lorenzo@kernel.org>
References: <cover.1599165031.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify
if shared_info area has been properly initialized for non-linear
xdp buffers

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 8 ++++++--
 net/core/xdp.c    | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 3814fb631d52..42f439f9fcda 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -72,7 +72,8 @@ struct xdp_buff {
 	void *data_hard_start;
 	struct xdp_rxq_info *rxq;
 	struct xdp_txq_info *txq;
-	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u32 mb:1; /* xdp non-linear buffer */
 };
 
 /* Reserve memory area at end-of data area.
@@ -96,7 +97,8 @@ struct xdp_frame {
 	u16 len;
 	u16 headroom;
 	u32 metasize:8;
-	u32 frame_sz:24;
+	u32 frame_sz:23;
+	u32 mb:1; /* xdp non-linear frame */
 	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
 	 * while mem info is valid on remote CPU.
 	 */
@@ -141,6 +143,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
 	xdp->data_end = frame->data + frame->len;
 	xdp->data_meta = frame->data - frame->metasize;
 	xdp->frame_sz = frame->frame_sz;
+	xdp->mb = frame->mb;
 }
 
 static inline
@@ -167,6 +170,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
 	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
 	xdp_frame->metasize = metasize;
 	xdp_frame->frame_sz = xdp->frame_sz;
+	xdp_frame->mb = xdp->mb;
 
 	return 0;
 }
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 48aba933a5a8..884f140fc3be 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -454,6 +454,7 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp)
 	xdpf->headroom = 0;
 	xdpf->metasize = metasize;
 	xdpf->frame_sz = PAGE_SIZE;
+	xdpf->mb = xdp->mb;
 	xdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
 
 	xsk_buff_free(xdp);
-- 
2.26.2

