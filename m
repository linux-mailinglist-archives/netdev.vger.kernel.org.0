Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992E43583CC
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhDHMw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231710AbhDHMwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 08:52:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D4A061166;
        Thu,  8 Apr 2021 12:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617886326;
        bh=SokJ3OMWnh0RmhMaqwFWNjyMLZlUhr6TcL0yCP3BT94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbY6olmNELg46kvYNb5v9JgVGG4L6nHFc/IZGyJbM3RAYAVX6kevnKRqbjYqdNiXk
         TUiCYhC/2E0d7XZHPnfyUZeg0xDq11Lbm7sVpTlmhYt9ev8hoZRuPTMNQhwqQtaCQn
         rUOdfQAxYV7v6BiXzwDhFR8vzkRBmncRkLR5T514dI//CnpU3qFDvYHQQ6WEpQFT04
         1skPp2aa63W+IgsdddeELjFJtYXnVRHOkKDA+qkPS3JOdW+LwrTGvoQqizx23QdelD
         NPKHSfl7TFJKrJkkBJ9/EEPSLA19aeUo/gSybokLrS91xePk6IPE/ugevCvaOkHISo
         oIl2qZfBa8+GQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: [PATCH v8 bpf-next 10/14] bpf: add new frame_length field to the XDP ctx
Date:   Thu,  8 Apr 2021 14:51:02 +0200
Message-Id: <ef8be9a1431875a6bce84dd07149c6e8eb874403.1617885385.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617885385.git.lorenzo@kernel.org>
References: <cover.1617885385.git.lorenzo@kernel.org>
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
 include/net/xdp.h              | 15 +++++++++++++++
 include/uapi/linux/bpf.h       |  1 +
 net/core/filter.c              |  8 ++++++++
 net/core/xdp.c                 |  1 +
 tools/include/uapi/linux/bpf.h |  1 +
 6 files changed, 33 insertions(+)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 9a09547bc7ba..d378a448f673 100644
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
index 55751cf2badf..e41022894770 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -77,6 +77,13 @@ struct xdp_buff {
 			  * tailroom
 			  */
 	u32 mb:1; /* xdp non-linear buffer */
+	u32 frame_length; /* Total frame length across all buffers. Only needs
+			   * to be updated by helper functions, as it will be
+			   * initialized at XDP program start. This field only
+			   * needs 17-bits (128kB). In case the remaining bits
+			   * need to be re-purposed, please make sure the
+			   * xdp_convert_ctx_access() function gets updated.
+			   */
 };
 
 static __always_inline void
@@ -237,6 +244,14 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
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
index 49371eba98ba..643ef5979d42 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5224,6 +5224,7 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
+	__u32 frame_length;
 };
 
 /* DEVMAP map-value layout
diff --git a/net/core/filter.c b/net/core/filter.c
index c00f52ab2532..8f8613745f0e 100644
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
@@ -9137,6 +9139,12 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
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
index 69902603012c..5c2a497bfcf1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5218,6 +5218,7 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
+	__u32 frame_length;
 };
 
 /* DEVMAP map-value layout
-- 
2.30.2

