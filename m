Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681921DDC66
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 03:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgEVBFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 21:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgEVBFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 21:05:32 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11FE72088E;
        Fri, 22 May 2020 01:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590109531;
        bh=+aGFbupzLZyQediooWfzkrMBDXvnUxrZGOZcEIUB5VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZtgtADvPvvmuHqo7R9rPZSr3MQAOunqkyXWcKatdCwC/P1YDg052e78fQLbUzjnU
         M9J3IgmaxN0gL5MmrOo3qoSnUyh9WxPJrrMOtsImSjZqB5tQmC7H1YTRI7gL642Osy
         U4xOB5JsFdj8QgxWrSErhqcKxVCvxnmw9Tn6ov0A=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH RFC bpf-next 3/4] xdp: Add xdp_txq_info to xdp_buff
Date:   Thu, 21 May 2020 19:05:25 -0600
Message-Id: <20200522010526.14649-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200522010526.14649-1-dsahern@kernel.org>
References: <20200522010526.14649-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add xdp_txq_info as the Tx counterpart to xdp_rxq_info. At the
moment only the device is added. Other fields (queue_index)
can be added as use cases arise.

From a UAPI perspective, add egress_ifindex to xdp context.

Update the verifier to only allow accesses to egress_ifindex by
XDP programs with BPF_XDP_DEVMAP expected attach type.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 include/net/xdp.h              |  5 +++++
 include/uapi/linux/bpf.h       |  2 ++
 kernel/bpf/devmap.c            |  3 +++
 net/core/filter.c              | 17 +++++++++++++++++
 tools/include/uapi/linux/bpf.h |  2 ++
 5 files changed, 29 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 3094fccf5a88..fd60ab3d401f 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -65,6 +65,10 @@ struct xdp_rxq_info {
 	struct xdp_mem_info mem;
 } ____cacheline_aligned; /* perf critical, avoid false-sharing */
 
+struct xdp_txq_info {
+	struct net_device *dev;
+};
+
 struct xdp_buff {
 	void *data;
 	void *data_end;
@@ -72,6 +76,7 @@ struct xdp_buff {
 	void *data_hard_start;
 	unsigned long handle;
 	struct xdp_rxq_info *rxq;
+	struct xdp_txq_info *txq;
 	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
 };
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8c2c0d0c9a0e..264de1484a66 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3624,6 +3624,8 @@ struct xdp_md {
 	/* Below access go through struct xdp_rxq_info */
 	__u32 ingress_ifindex; /* rxq->dev->ifindex */
 	__u32 rx_queue_index;  /* rxq->queue_index  */
+
+	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
 enum sk_action {
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 06f4c746fa7c..240c1aeca7ef 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -471,8 +471,11 @@ static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
 					 struct xdp_buff *xdp,
 					 struct bpf_prog *xdp_prog)
 {
+	struct xdp_txq_info txq = { .dev = dev };
 	u32 act;
 
+	xdp->txq = &txq;
+
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_DROP:
diff --git a/net/core/filter.c b/net/core/filter.c
index bd2853d23b50..199e02a30381 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6994,6 +6994,13 @@ static bool xdp_is_valid_access(int off, int size,
 				const struct bpf_prog *prog,
 				struct bpf_insn_access_aux *info)
 {
+	if (prog->expected_attach_type != BPF_XDP_DEVMAP) {
+		switch (off) {
+		case offsetof(struct xdp_md, egress_ifindex):
+			return false;
+		}
+	}
+
 	if (type == BPF_WRITE) {
 		if (bpf_prog_is_dev_bound(prog->aux)) {
 			switch (off) {
@@ -7942,6 +7949,16 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
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
index 8c2c0d0c9a0e..264de1484a66 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3624,6 +3624,8 @@ struct xdp_md {
 	/* Below access go through struct xdp_rxq_info */
 	__u32 ingress_ifindex; /* rxq->dev->ifindex */
 	__u32 rx_queue_index;  /* rxq->queue_index  */
+
+	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
 enum sk_action {
-- 
2.21.1 (Apple Git-122.3)

