Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4774B170EF2
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgB0DUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:20:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbgB0DUY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 22:20:24 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53A3924683;
        Thu, 27 Feb 2020 03:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582773623;
        bh=8DyO73ah2sSQ+7z6iw3ngPHGBf/za0BH0CsjoDi5iK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKiBow1E+UZ+rF/hGlw2mP6ynn8zYh9BklwxgbGoLoOL8XNQ64CtU57jVpgFS/OW9
         pW17/KM08dmEibVCl/ysYWVwAlOmnCqvhKvHAg1YNjLwk2XylafcQARd7f+XcJL9aD
         F44sjfsxiWRiNBJQugFhqCxpviWq6vKQcbK3rCKM=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC v4 bpf-next 03/11] xdp: Add xdp_txq_info to xdp_buff
Date:   Wed, 26 Feb 2020 20:20:05 -0700
Message-Id: <20200227032013.12385-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200227032013.12385-1-dsahern@kernel.org>
References: <20200227032013.12385-1-dsahern@kernel.org>
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

From a UAPI perspective, egress_ifindex is a union with ingress_ifindex
since only one applies based on where the program is attached.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/net/xdp.h        |  5 +++++
 include/uapi/linux/bpf.h |  6 ++++--
 net/core/filter.c        | 27 +++++++++++++++++++--------
 3 files changed, 28 insertions(+), 10 deletions(-)

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
index 7850f8683b81..5e3f8aefad41 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3334,8 +3334,10 @@ struct xdp_md {
 	__u32 data;
 	__u32 data_end;
 	__u32 data_meta;
-	/* Below access go through struct xdp_rxq_info */
-	__u32 ingress_ifindex; /* rxq->dev->ifindex */
+	union {
+		__u32 ingress_ifindex; /* rxq->dev->ifindex */
+		__u32 egress_ifindex;  /* txq->dev->ifindex */
+	};
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 };
 
diff --git a/net/core/filter.c b/net/core/filter.c
index c7cc98c55621..d1c65dccd671 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7716,14 +7716,25 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 				      offsetof(struct xdp_buff, data_end));
 		break;
 	case offsetof(struct xdp_md, ingress_ifindex):
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, rxq),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct xdp_buff, rxq));
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_rxq_info, dev),
-				      si->dst_reg, si->dst_reg,
-				      offsetof(struct xdp_rxq_info, dev));
-		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
-				      offsetof(struct net_device, ifindex));
+		if (prog->expected_attach_type == BPF_XDP_EGRESS) {
+			*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, txq),
+					      si->dst_reg, si->src_reg,
+					      offsetof(struct xdp_buff, txq));
+			*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_txq_info, dev),
+					      si->dst_reg, si->dst_reg,
+					      offsetof(struct xdp_txq_info, dev));
+			*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
+					      offsetof(struct net_device, ifindex));
+		} else {
+			*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, rxq),
+					      si->dst_reg, si->src_reg,
+					      offsetof(struct xdp_buff, rxq));
+			*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_rxq_info, dev),
+					      si->dst_reg, si->dst_reg,
+					      offsetof(struct xdp_rxq_info, dev));
+			*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
+					      offsetof(struct net_device, ifindex));
+		}
 		break;
 	case offsetof(struct xdp_md, rx_queue_index):
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, rxq),
-- 
2.21.1 (Apple Git-122.3)

