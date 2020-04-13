Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156F21A6B3C
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732571AbgDMRTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732636AbgDMRS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 13:18:29 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 004662076D;
        Mon, 13 Apr 2020 17:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586798308;
        bh=0o+4W8h5yBDTtQIJUYk4Lds2BNWHR9UR7Tww6x6/zPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/wiL+w8uc9EUYFZzM+MxhCWiXCWL0WFaN/nY3OHiYAF3mFtOg76q/FETgRgJ8LgN
         +zzMki5qnB/LC12+jNcaMcnzFeW6Oa+QhOuYOpVWuDuMyqXpgU1bX/tl8hoIltWRxX
         Nr210Uv/xJ7Mb5RJOygWbEcnkhvnPgGE5IVKjPUg=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC-v5 bpf-next 03/12] xdp: Add xdp_txq_info to xdp_buff
Date:   Mon, 13 Apr 2020 11:17:52 -0600
Message-Id: <20200413171801.54406-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200413171801.54406-1-dsahern@kernel.org>
References: <20200413171801.54406-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Add xdp_txq_info as the Tx counterpart to xdp_rxq_info. At the
moment only the device is added. Other fields (queue_index)
can be added as use cases arise.

From a UAPI perspective, add egress_ifindex to xdp context.

Update the verifier to reject accesses to egress_ifindex by
rx programs.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/net/xdp.h              |  5 +++++
 include/uapi/linux/bpf.h       |  2 ++
 net/core/filter.c              | 15 +++++++++++++++
 tools/include/uapi/linux/bpf.h |  2 ++
 4 files changed, 24 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 40c6d3398458..5584b9db86fe 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -63,6 +63,10 @@ struct xdp_rxq_info {
 	struct xdp_mem_info mem;
 } ____cacheline_aligned; /* perf critical, avoid false-sharing */
 
+struct xdp_txq_info {
+	struct net_device *dev;
+};
+
 struct xdp_buff {
 	void *data;
 	void *data_end;
@@ -70,6 +74,7 @@ struct xdp_buff {
 	void *data_hard_start;
 	unsigned long handle;
 	struct xdp_rxq_info *rxq;
+	struct xdp_txq_info *txq;
 };
 
 struct xdp_frame {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a9d384998e8b..35e3aab97dd4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3487,6 +3487,8 @@ struct xdp_md {
 	/* Below access go through struct xdp_rxq_info */
 	__u32 ingress_ifindex; /* rxq->dev->ifindex */
 	__u32 rx_queue_index;  /* rxq->queue_index  */
+
+	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
 enum sk_action {
diff --git a/net/core/filter.c b/net/core/filter.c
index c4e0e044722f..d8839d07acad 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6941,6 +6941,11 @@ static bool xdp_is_valid_access(int off, int size,
 		case offsetof(struct xdp_md, rx_queue_index):
 			return false;
 		}
+	} else {
+		switch (off) {
+		case offsetof(struct xdp_md, egress_ifindex):
+			return false;
+		}
 	}
 
 	if (type == BPF_WRITE) {
@@ -7890,6 +7895,16 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 				      offsetof(struct xdp_rxq_info,
 					       queue_index));
 		break;
+	case offsetof(struct xdp_md, egress_ifindex):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, txq),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct xdp_buff, txq));
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_txq_info, dev),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct xdp_txq_info, dev));
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
+				      offsetof(struct net_device, ifindex));
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a9d384998e8b..35e3aab97dd4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3487,6 +3487,8 @@ struct xdp_md {
 	/* Below access go through struct xdp_rxq_info */
 	__u32 ingress_ifindex; /* rxq->dev->ifindex */
 	__u32 rx_queue_index;  /* rxq->queue_index  */
+
+	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
 enum sk_action {
-- 
2.21.1 (Apple Git-122.3)

