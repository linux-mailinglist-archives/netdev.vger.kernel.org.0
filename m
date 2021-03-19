Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4C53427FF
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhCSVsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhCSVsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:48:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E872760232;
        Fri, 19 Mar 2021 21:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616190485;
        bh=ExAlW84/WSpkNfqL/U3ioSZicNGQ0fFikhwvLVW4W0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sljBTMft/0aiDTJ6Jk7ScsSsLUq1sIKvQMVYaIIK1G3KXgaXwwvFO7RUNO9aRcVEy
         7nLH+WyFp/N9rYC1CbVBGKKIa2i8X6+A3sVCigIKbWLBBpScO/TqQWlED35J/qqAt7
         3kS3RcL2GKUK28xLli9d9nx8X0H8h2z1Ggie3XsUrn91AHHmkhbWWuWLHUmTvyanMk
         vCz1GJ1Bl6BXYwn0X2hEy0fZawP461Pswa1xNPcKqIMiAM6Sg81CETQf9bKxSR0RR5
         pG4+rwBD+NGq4IU7PefA2vOWwB6Yfmj+rgumr1O9o5uV+Z2S9RlVRTxgauG/rMR5ZH
         HYX+iKX/EdRAw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v7 bpf-next 01/14] xdp: introduce mb in xdp_buff/xdp_frame
Date:   Fri, 19 Mar 2021 22:47:15 +0100
Message-Id: <dd3e6f016991507636e4eefdb8c83486818617cf.1616179034.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616179034.git.lorenzo@kernel.org>
References: <cover.1616179034.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer data structure
in order to specify if this is a linear buffer (mb = 0) or a multi-buffer
frame (mb = 1). In the latter case the shared_info area at the end of the
first buffer will be properly initialized to link together subsequent
buffers.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index a5bc214a49d9..b57ff2c81e7c 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -73,7 +73,8 @@ struct xdp_buff {
 	void *data_hard_start;
 	struct xdp_rxq_info *rxq;
 	struct xdp_txq_info *txq;
-	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u32 mb:1; /* xdp non-linear buffer */
 };
 
 static __always_inline void
@@ -81,6 +82,7 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 {
 	xdp->frame_sz = frame_sz;
 	xdp->rxq = rxq;
+	xdp->mb = 0;
 }
 
 static __always_inline void
@@ -116,7 +118,8 @@ struct xdp_frame {
 	u16 len;
 	u16 headroom;
 	u32 metasize:8;
-	u32 frame_sz:24;
+	u32 frame_sz:23;
+	u32 mb:1; /* xdp non-linear frame */
 	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
 	 * while mem info is valid on remote CPU.
 	 */
@@ -179,6 +182,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
 	xdp->data_end = frame->data + frame->len;
 	xdp->data_meta = frame->data - frame->metasize;
 	xdp->frame_sz = frame->frame_sz;
+	xdp->mb = frame->mb;
 }
 
 static inline
@@ -205,6 +209,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
 	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
 	xdp_frame->metasize = metasize;
 	xdp_frame->frame_sz = xdp->frame_sz;
+	xdp_frame->mb = xdp->mb;
 
 	return 0;
 }
-- 
2.30.2

