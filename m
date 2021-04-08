Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EB33583AC
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhDHMvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhDHMvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 08:51:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DE5561131;
        Thu,  8 Apr 2021 12:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617886288;
        bh=x/bnimrSQNrXGtz0rtMVsvILqLT6pAr/8ATxhTrO2D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkxITIDAKm97HJw3nBRYWXPe5fWDhG/NS/tLwa60X8OnagUDayZMAlMex/HhUcs8F
         xbs8jIGejHbMOQ7S7I0dCBlsX8JSC8Tj5OAvzCkmiKeQfmtG7bcPd6N7xxSPLuRYoy
         Lzcp9heYRUHd0JVsdBPhW85xDDZqg83G6syMnt1VtujWh6PwF4Xb1ehyCKaVlA3M/t
         JJz6+v9UHpXvTp/cuRJLcpgRK8EcoRrHtSwx3J1DFg/ssV2gxqzJvHuR3qk212MqTo
         qJWATWmq2sktMlLLktK+rt/8cqLNbKlWxrMx20KJuVwTd0hE/TwtFUVxIL2V9ts2n2
         /Z/O0CklGqOHg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: [PATCH v8 bpf-next 01/14] xdp: introduce mb in xdp_buff/xdp_frame
Date:   Thu,  8 Apr 2021 14:50:53 +0200
Message-Id: <eef58418ab78408f4a5fbd3d3b0071f30ece2ccd.1617885385.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617885385.git.lorenzo@kernel.org>
References: <cover.1617885385.git.lorenzo@kernel.org>
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
 include/net/xdp.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index a5bc214a49d9..842580a61563 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -73,7 +73,10 @@ struct xdp_buff {
 	void *data_hard_start;
 	struct xdp_rxq_info *rxq;
 	struct xdp_txq_info *txq;
-	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved
+			  * tailroom
+			  */
+	u32 mb:1; /* xdp non-linear buffer */
 };
 
 static __always_inline void
@@ -81,6 +84,7 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 {
 	xdp->frame_sz = frame_sz;
 	xdp->rxq = rxq;
+	xdp->mb = 0;
 }
 
 static __always_inline void
@@ -116,7 +120,8 @@ struct xdp_frame {
 	u16 len;
 	u16 headroom;
 	u32 metasize:8;
-	u32 frame_sz:24;
+	u32 frame_sz:23;
+	u32 mb:1; /* xdp non-linear frame */
 	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
 	 * while mem info is valid on remote CPU.
 	 */
@@ -179,6 +184,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
 	xdp->data_end = frame->data + frame->len;
 	xdp->data_meta = frame->data - frame->metasize;
 	xdp->frame_sz = frame->frame_sz;
+	xdp->mb = frame->mb;
 }
 
 static inline
@@ -205,6 +211,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
 	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
 	xdp_frame->metasize = metasize;
 	xdp_frame->frame_sz = xdp->frame_sz;
+	xdp_frame->mb = xdp->mb;
 
 	return 0;
 }
-- 
2.30.2

