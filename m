Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E54B240D06
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 20:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgHJSbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 14:31:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:33924 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbgHJSbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 14:31:50 -0400
IronPort-SDR: ELbOaISeip/wdZ0TI1w+rm9BMUs6K+xoff8Wbhk7H3a47LFmPYiRpTXcZ5pYHa4VxjHY0kF0G2
 wwx1Swh6XKrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="154718384"
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="154718384"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 11:31:50 -0700
IronPort-SDR: xdkMhRzfpmCiNbx+C/LmrkaP6iLfVuJBLU/8kpyG7tdLhdEpcAbmxv59Mj99WBSlmWCdMEHLvg
 kiby3o6O76Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="494415959"
Received: from harshitha-linux4.jf.intel.com ([10.166.17.91])
  by fmsmga006.fm.intel.com with ESMTP; 10 Aug 2020 11:31:49 -0700
From:   Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, hawk@kernel.org
Cc:     tom.herbert@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@intel.com, carolyn.wyborny@intel.com,
        Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
Subject: [RFC PATCH bpf-next] bpf: add bpf_get_skb_hash helper function
Date:   Mon, 10 Aug 2020 14:28:41 -0400
Message-Id: <20200810182841.10953-1-harshitha.ramamurthy@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a helper function called bpf_get_skb_hash to calculate
the skb hash for a packet at the XDP layer. In the helper function,
a local skb is allocated and we populate the fields needed in the skb
before calling skb_get_hash. To avoid memory allocations for each packet,
we allocate an skb per CPU and use the same buffer for subsequent hash
calculations on the same CPU.

Signed-off-by: Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
---
 include/uapi/linux/bpf.h       |  8 ++++++
 net/core/filter.c              | 50 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  8 ++++++
 3 files changed, 66 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b134e679e9db..25aa850c8a40 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3394,6 +3394,13 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * u32 bpf_get_skb_hash(struct xdp_buff *xdp_md)
+ *	Description
+ *		Return the skb hash for the xdp context passed. This function
+ *		allocates a temporary skb and populates the fields needed. It
+ *		then calls skb_get_hash to calculate the skb hash for the packet.
+ *	Return
+ *		The 32-bit hash.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3538,6 +3545,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(get_skb_hash),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 7124f0fe6974..9f6ad7209b44 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3765,6 +3765,54 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
 	.arg3_type      = ARG_ANYTHING,
 };
 
+static DEFINE_PER_CPU(struct sk_buff *, hash_skb);
+
+BPF_CALL_1(bpf_get_skb_hash, struct xdp_buff *, xdp)
+{
+	void *data_end = xdp->data_end;
+	struct ethhdr *eth = xdp->data;
+	void *data = xdp->data;
+	unsigned long flags;
+	struct sk_buff *skb;
+	int nh_off, len;
+	u32 ret = 0;
+
+	/* disable interrupts to get the correct skb pointer */
+	local_irq_save(flags);
+
+	len = data_end - data;
+	skb = this_cpu_read(hash_skb);
+	if (!skb) {
+		skb = alloc_skb(len, GFP_ATOMIC);
+		if (!skb)
+			goto out;
+		this_cpu_write(hash_skb, skb);
+	}
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		goto out;
+
+	skb->data = data;
+	skb->head = data;
+	skb->network_header = nh_off;
+	skb->protocol = eth->h_proto;
+	skb->len = len;
+	skb->dev = xdp->rxq->dev;
+
+	ret = skb_get_hash(skb);
+out:
+	local_irq_restore(flags);
+	return ret;
+}
+
+const struct bpf_func_proto bpf_get_skb_hash_proto = {
+	.func		= bpf_get_skb_hash,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 static unsigned long bpf_skb_copy(void *dst_buff, const void *skb,
 				  unsigned long off, unsigned long len)
 {
@@ -6503,6 +6551,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_adjust_tail_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
+	case BPF_FUNC_get_skb_hash:
+		return &bpf_get_skb_hash_proto;
 #ifdef CONFIG_INET
 	case BPF_FUNC_sk_lookup_udp:
 		return &bpf_xdp_sk_lookup_udp_proto;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b134e679e9db..25aa850c8a40 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3394,6 +3394,13 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * u32 bpf_get_skb_hash(struct xdp_buff *xdp_md)
+ *	Description
+ *		Return the skb hash for the xdp context passed. This function
+ *		allocates a temporary skb and populates the fields needed. It
+ *		then calls skb_get_hash to calculate the skb hash for the packet.
+ *	Return
+ *		The 32-bit hash.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3538,6 +3545,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(get_skb_hash),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.20.1

