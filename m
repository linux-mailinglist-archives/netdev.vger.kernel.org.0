Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C832581C0
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbgHaT2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:28:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:51230 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbgHaT2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 15:28:17 -0400
IronPort-SDR: shvIAfuUNd2V+rMWoa+Xi+xjWaS1TYzmFjCcoTa/FEYUtacfG0/PxNxLoYnin+EDpNa7L2p8uz
 H19JIgd/c4LA==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="144733560"
X-IronPort-AV: E=Sophos;i="5.76,376,1592895600"; 
   d="scan'208";a="144733560"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 12:28:16 -0700
IronPort-SDR: wZug/5EMJ6aQzlL2zCJtM8GmASaol5XPpzL/Xq7COfQem+FA7n/OZWxS8wiqtKIwqXo/dqFDsF
 JgqfaZFNWmXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,376,1592895600"; 
   d="scan'208";a="476859639"
Received: from harshitha-linux4.jf.intel.com ([10.166.17.91])
  by orsmga005.jf.intel.com with ESMTP; 31 Aug 2020 12:28:16 -0700
From:   Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org
Cc:     dsahern@gmail.com, alexander.h.duyck@intel.com,
        tom.herbert@intel.com,
        Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
Subject: [PATCH bpf-next] bpf: add bpf_get_xdp_hash helper function
Date:   Mon, 31 Aug 2020 15:25:06 -0400
Message-Id: <20200831192506.28896-1-harshitha.ramamurthy@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a helper function called bpf_get_xdp_hash to calculate
the hash for a packet at the XDP layer. In the helper function, we call
the kernel flow dissector in non-skb mode by passing the net pointer
to calculate the hash.

Changes since RFC:
- accounted for vlans(David Ahern)
- return the correct hash by not using skb_get_hash(David Ahern)
- call __skb_flow_dissect in non-skb mode

Signed-off-by: Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
---
 include/uapi/linux/bpf.h       |  9 +++++++++
 net/core/filter.c              | 29 +++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  9 +++++++++
 3 files changed, 47 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a613750d5515..bffe93b526e7 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3576,6 +3576,14 @@ union bpf_attr {
  * 		the data in *dst*. This is a wrapper of copy_from_user().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * u32 bpf_get_xdp_hash(struct xdp_buff *xdp_md)
+ *	Description
+ *		Return the hash for the xdp context passed. This function
+ *		calls skb_flow_dissect in non-skb mode to calculate the
+ *		hash for the packet.
+ *	Return
+ *		The 32-bit hash.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3727,6 +3735,7 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(get_xdp_hash),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 47eef9a0be6a..cfb5a6aea6c3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3765,6 +3765,33 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
 	.arg3_type      = ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_get_xdp_hash, struct xdp_buff *, xdp)
+{
+	void *data_end = xdp->data_end;
+	struct ethhdr *eth = xdp->data;
+	void *data = xdp->data;
+	struct flow_keys keys;
+	u32 ret = 0;
+	int len;
+
+	len = data_end - data;
+	if (len <= 0)
+		return ret;
+	memset(&keys, 0, sizeof(keys));
+	__skb_flow_dissect(dev_net(xdp->rxq->dev), NULL, &flow_keys_dissector,
+			   &keys, data, eth->h_proto, sizeof(*eth), len,
+			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
+	ret = flow_hash_from_keys(&keys);
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_get_xdp_hash_proto = {
+	.func		= bpf_get_xdp_hash,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 static unsigned long bpf_skb_copy(void *dst_buff, const void *skb,
 				  unsigned long off, unsigned long len)
 {
@@ -6837,6 +6864,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_adjust_tail_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
+	case BPF_FUNC_get_xdp_hash:
+		return &bpf_get_xdp_hash_proto;
 #ifdef CONFIG_INET
 	case BPF_FUNC_sk_lookup_udp:
 		return &bpf_xdp_sk_lookup_udp_proto;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a613750d5515..bffe93b526e7 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3576,6 +3576,14 @@ union bpf_attr {
  * 		the data in *dst*. This is a wrapper of copy_from_user().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * u32 bpf_get_xdp_hash(struct xdp_buff *xdp_md)
+ *	Description
+ *		Return the hash for the xdp context passed. This function
+ *		calls skb_flow_dissect in non-skb mode to calculate the
+ *		hash for the packet.
+ *	Return
+ *		The 32-bit hash.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3727,6 +3735,7 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(get_xdp_hash),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.20.1

