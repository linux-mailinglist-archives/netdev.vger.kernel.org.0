Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C87342815
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhCSVsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhCSVsg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:48:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F3661981;
        Fri, 19 Mar 2021 21:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616190516;
        bh=FX0T9Ki2KSKPSSzmHZg5ztIP24cIlfXORQB6kwUM4xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=heOHVBPbz+HJOJIRbQl/rBc+eELwMXmyYoyfjItggBsl5h8kq1I7rEXeJdtq+TKc3
         u9IQccLSoieM1N5p9czO9Ml/EYfaSBZEoC1uME+kkcq6wpB8s12AnkBzuQ8NYlIVf9
         f3yaqdHeydrexqXqb/6JAUuHMZaRooGvL92t846bsev6ISvzHMSfiw/SSfaGdr8jKv
         YXU7qSQEyQLC7nKxMN0U4tpD4KpQ5We8sbLKXHM1s79vP1z4fPWtsrPZNhb9ech8+A
         0KIInQUoTRYsySSD4aH1uEURd7+t92Mp6lWyCfQY0UcXzXpNi+M0zeBKit9HDvnRtG
         qEIMV8LY7yEgA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v7 bpf-next 10/14] bpf: add new frame_length field to the XDP ctx
Date:   Fri, 19 Mar 2021 22:47:24 +0100
Message-Id: <a31b2599948c8d8679c6454b9191e70c1c732c32.1616179034.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616179034.git.lorenzo@kernel.org>
References: <cover.1616179034.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

This patch adds a new field to the XDP context called frame_length,
which will hold the full length of the packet, including fragments
if existing.

eBPF programs can determine if fragments are present using something
like:

  if (ctx->data_end - ctx->data < ctx->frame_length) {
    /* Fragements exists. /*
  }

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/filter.h         |  7 +++++++
 include/net/xdp.h              | 12 ++++++++++++
 include/uapi/linux/bpf.h       |  1 +
 net/core/filter.c              |  8 ++++++++
 net/core/xdp.c                 |  1 +
 tools/include/uapi/linux/bpf.h |  1 +
 6 files changed, 30 insertions(+)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index b2b85b2cad8e..511d812fd18c 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -768,6 +768,13 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 	 * already takes rcu_read_lock() when fetching the program, so
 	 * it's not necessary here anymore.
 	 */
+	xdp->frame_length = xdp->data_end - xdp->data;
+	if (unlikely(xdp->mb)) {
+		struct xdp_shared_info *xdp_sinfo;
+
+		xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
+		xdp->frame_length += xdp_sinfo->data_length;
+	}
 	return __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
 }
 
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 19cd6642e087..e47d9e8da547 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -75,6 +75,10 @@ struct xdp_buff {
 	struct xdp_txq_info *txq;
 	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved tailroom*/
 	u32 mb:1; /* xdp non-linear buffer */
+	u32 frame_length; /* Total frame length across all buffers. Only needs
+			   * to be updated by helper functions, as it will be
+			   * initialized at XDP program start.
+			   */
 };
 
 static __always_inline void
@@ -235,6 +239,14 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
 	xdp->data_meta = frame->data - frame->metasize;
 	xdp->frame_sz = frame->frame_sz;
 	xdp->mb = frame->mb;
+	xdp->frame_length = frame->len;
+
+	if (unlikely(xdp->mb)) {
+		struct xdp_shared_info *xdp_sinfo;
+
+		xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
+		xdp->frame_length += xdp_sinfo->data_length;
+	}
 }
 
 static inline
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2d3036e292a9..4dcc5ad736b4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5213,6 +5213,7 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
+	__u32 frame_length;
 };
 
 /* DEVMAP map-value layout
diff --git a/net/core/filter.c b/net/core/filter.c
index a607ea8321bd..b047757bd839 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3873,6 +3873,7 @@ static int bpf_xdp_mb_adjust_tail(struct xdp_buff *xdp, int offset)
 		memset(xdp_get_frag_address(frag) + size, 0, offset);
 		xdp_set_frag_size(frag, size + offset);
 		xdp_sinfo->data_length += offset;
+		xdp->frame_length += offset;
 	} else {
 		int i, frags_to_free = 0;
 
@@ -3894,6 +3895,7 @@ static int bpf_xdp_mb_adjust_tail(struct xdp_buff *xdp, int offset)
 				 * to adjust the data_length in line.
 				 */
 				xdp_sinfo->data_length -= shrink;
+				xdp->frame_length -= shrink;
 				xdp_set_frag_size(frag, size - shrink);
 				break;
 			}
@@ -9126,6 +9128,12 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
 				      offsetof(struct net_device, ifindex));
 		break;
+	case offsetof(struct xdp_md, frame_length):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff,
+						       frame_length),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct xdp_buff, frame_length));
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 7388bc6d680b..fb7d0724a5b6 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -510,6 +510,7 @@ void xdp_return_num_frags_from_buff(struct xdp_buff *xdp, u16 num_frags)
 		struct page *page = xdp_get_frag_page(frag);
 
 		xdp_sinfo->data_length -= xdp_get_frag_size(frag);
+		xdp->frame_length -= xdp_get_frag_size(frag);
 		__xdp_return(page_address(page), &xdp->rxq->mem, false, NULL);
 	}
 	xdp_sinfo->nr_frags -= num_frags;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2d3036e292a9..4dcc5ad736b4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5213,6 +5213,7 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
+	__u32 frame_length;
 };
 
 /* DEVMAP map-value layout
-- 
2.30.2

