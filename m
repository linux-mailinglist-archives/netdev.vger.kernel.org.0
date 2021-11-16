Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834BC452BA3
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhKPHlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:41:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:42900 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhKPHl1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 02:41:27 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="231099049"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="231099049"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 23:38:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="671857311"
Received: from silpixa00401086.ir.intel.com (HELO localhost.localdomain) ([10.55.129.110])
  by orsmga005.jf.intel.com with ESMTP; 15 Nov 2021 23:38:28 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [RFC PATCH bpf-next 2/8] bpf: add bpf_redirect_xsk helper and XDP_REDIRECT_XSK action
Date:   Tue, 16 Nov 2021 07:37:36 +0000
Message-Id: <20211116073742.7941-3-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211116073742.7941-1-ciara.loftus@intel.com>
References: <20211116073742.7941-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new XDP redirect helper called bpf_redirect_xsk which simply
returns the new XDP_REDIRECT_XSK action if the xsk refcnt for the
netdev_rx_queue is equal to one. Checking this value verifies that the
AF_XDP socket Rx ring is configured and there is exactly one xsk attached
to the queue.

XDP_REDIRECT_XSK indicates to the driver that the XSKMAP lookup can be
skipped and the pointer to the socket to redirect to can instead be
retrieved from the netdev_rx_queue on which the packet was received.
If the aforementioned conditions are not met, fallback to the behavior of
xdp_redirect_map which returns XDP_REDIRECT for a successful XSKMAP lookup.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 include/uapi/linux/bpf.h | 13 +++++++++++++
 kernel/bpf/verifier.c    |  7 ++++++-
 net/core/filter.c        | 22 ++++++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6297eafdc40f..a33cc63c8e6f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4957,6 +4957,17 @@ union bpf_attr {
  *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
  *		**-EBUSY** if failed to try lock mmap_lock.
  *		**-EINVAL** for invalid **flags**.
+ *
+ * long bpf_redirect_xsk(void *ctx, struct bpf_map *map, u32 key, u64 flags)
+ *	Description
+ *		Redirect the packet to the XDP socket associated with the netdev queue if
+ *		the socket has an rx ring configured and is the only socket attached to the
+ *		queue. Fall back to bpf_redirect_map behavior if either condition is not met.
+ *	Return
+ *		**XDP_REDIRECT_XSK** if successful.
+ *
+ *		**XDP_REDIRECT** if the fall back was successful, or the value of the
+ *		two lower bits of the *flags* argument on error
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5140,6 +5151,7 @@ union bpf_attr {
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
+	FN(redirect_xsk),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -5520,6 +5532,7 @@ enum xdp_action {
 	XDP_PASS,
 	XDP_TX,
 	XDP_REDIRECT,
+	XDP_REDIRECT_XSK,
 };
 
 /* user accessible metadata for XDP packet hook
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d31a031ab377..59a973f43965 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5526,7 +5526,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		break;
 	case BPF_MAP_TYPE_XSKMAP:
 		if (func_id != BPF_FUNC_redirect_map &&
-		    func_id != BPF_FUNC_map_lookup_elem)
+		    func_id != BPF_FUNC_map_lookup_elem &&
+		    func_id != BPF_FUNC_redirect_xsk)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
@@ -5629,6 +5630,10 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    map->map_type != BPF_MAP_TYPE_XSKMAP)
 			goto error;
 		break;
+	case BPF_FUNC_redirect_xsk:
+		if (map->map_type != BPF_MAP_TYPE_XSKMAP)
+			goto error;
+		break;
 	case BPF_FUNC_sk_redirect_map:
 	case BPF_FUNC_msg_redirect_map:
 	case BPF_FUNC_sock_map_update:
diff --git a/net/core/filter.c b/net/core/filter.c
index 46f09a8fba20..4497ad046790 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4140,6 +4140,26 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
 	.arg3_type      = ARG_ANYTHING,
 };
 
+BPF_CALL_4(bpf_xdp_redirect_xsk, struct xdp_buff *, xdp, struct bpf_map *, map,
+	   u32, ifindex, u64, flags)
+{
+#ifdef CONFIG_XDP_SOCKETS
+	if (likely(refcount_read(&xdp->rxq->dev->_rx[xdp->rxq->queue_index].xsk_refcnt) == 1))
+		return XDP_REDIRECT_XSK;
+#endif
+	return map->ops->map_redirect(map, ifindex, flags);
+}
+
+static const struct bpf_func_proto bpf_xdp_redirect_xsk_proto = {
+	.func           = bpf_xdp_redirect_xsk,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_CONST_MAP_PTR,
+	.arg3_type      = ARG_ANYTHING,
+	.arg4_type      = ARG_ANYTHING,
+};
+
 static unsigned long bpf_skb_copy(void *dst_buff, const void *skb,
 				  unsigned long off, unsigned long len)
 {
@@ -7469,6 +7489,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_proto;
 	case BPF_FUNC_redirect_map:
 		return &bpf_xdp_redirect_map_proto;
+	case BPF_FUNC_redirect_xsk:
+		return &bpf_xdp_redirect_xsk_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
 	case BPF_FUNC_fib_lookup:
-- 
2.17.1

