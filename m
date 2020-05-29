Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9AE1E754C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 07:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgE2FVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 01:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgE2FVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 01:21:19 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B948421475;
        Fri, 29 May 2020 05:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590729678;
        bh=xGjLTqcdt42zReWFw2lYGCKLf/6cWp9a1aXwjd4OhFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSKYZld1tawg1LvOvQd4+9h47VeE2NFlAVZ06T5IndG1IIpzQJ0dbk4zLb0gL0SOP
         5lMeu5/x5pMDsPPc6V4HCSY0bay+2uIyafxMEEPXM1ihzXs6m8IoF0ND5kk+WLdnTH
         XZMNPqulEeS0qUrXul3JqHZAXsGM0oJtKPE58Yvk=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, toke@redhat.com, lorenzo@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH v3 bpf-next 3/5] xdp: Add xdp_txq_info to xdp_buff
Date:   Thu, 28 May 2020 23:20:55 -0600
Message-Id: <20200529052057.69378-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200529052057.69378-1-dsahern@kernel.org>
References: <20200529052057.69378-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add xdp_txq_info as the Tx counterpart to xdp_rxq_info. At the
moment only the device is added. Other fields (queue_index)
can be added as use cases arise.

From a UAPI perspective, add egress_ifindex to xdp context for
bpf programs to see the Tx device.

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
index 90f11760bd12..d54022959491 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -61,12 +61,17 @@ struct xdp_rxq_info {
 	struct xdp_mem_info mem;
 } ____cacheline_aligned; /* perf critical, avoid false-sharing */
 
+struct xdp_txq_info {
+	struct net_device *dev;
+};
+
 struct xdp_buff {
 	void *data;
 	void *data_end;
 	void *data_meta;
 	void *data_hard_start;
 	struct xdp_rxq_info *rxq;
+	struct xdp_txq_info *txq;
 	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
 };
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 02177049cf66..61ae81bf67de 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3624,6 +3624,8 @@ struct xdp_md {
 	/* Below access go through struct xdp_rxq_info */
 	__u32 ingress_ifindex; /* rxq->dev->ifindex */
 	__u32 rx_queue_index;  /* rxq->queue_index  */
+
+	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
 /* DEVMAP values */
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 3152151d3bb8..defdd22caa4b 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -467,8 +467,11 @@ static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
 					 struct xdp_buff *xdp,
 					 struct bpf_prog *xdp_prog)
 {
+	struct xdp_txq_info txq = { .dev = dev };
 	u32 act;
 
+	xdp->txq = &txq;
+
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
diff --git a/net/core/filter.c b/net/core/filter.c
index a6fc23447f12..2e9dbfd8e60c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7014,6 +7014,13 @@ static bool xdp_is_valid_access(int off, int size,
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
@@ -7967,6 +7974,16 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
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
index 02177049cf66..61ae81bf67de 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3624,6 +3624,8 @@ struct xdp_md {
 	/* Below access go through struct xdp_rxq_info */
 	__u32 ingress_ifindex; /* rxq->dev->ifindex */
 	__u32 rx_queue_index;  /* rxq->queue_index  */
+
+	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
 /* DEVMAP values */
-- 
2.21.1 (Apple Git-122.3)

