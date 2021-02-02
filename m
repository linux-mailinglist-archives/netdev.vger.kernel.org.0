Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261F930C5D9
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbhBBQbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:31:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236464AbhBBQ3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 11:29:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612283228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mm9CEhrbAfM7iyL1pfsIP3UaoPypkagBKNPA54TuNaw=;
        b=EocRnVNVZiNxR5n+wGrG4Y3I5+qLD4CM3OsZd1KrnrxE+T8cMWQFoSiBVt9p9NeU383Mi0
        n2BUiAY7JoOtdaYLf9mhNYyBU8iZklPc7TTqCgqW4lM8IfP4CcGhO+iqSi+K0B9vnafGYP
        PuxKWVFuQe3Zl8XwAezAaMf5LnqpKBg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-Xhu3xgmnMLaATQlm0d_q-Q-1; Tue, 02 Feb 2021 11:27:06 -0500
X-MC-Unique: Xhu3xgmnMLaATQlm0d_q-Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59C988710E2;
        Tue,  2 Feb 2021 16:27:04 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26CDF62677;
        Tue,  2 Feb 2021 16:27:03 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id F16A630736C73;
        Tue,  2 Feb 2021 17:27:01 +0100 (CET)
Subject: [PATCH bpf-next V15 4/7] bpf: add BPF-helper for MTU checking
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Date:   Tue, 02 Feb 2021 17:27:01 +0100
Message-ID: <161228322191.576669.12248063504138330243.stgit@firesoul>
In-Reply-To: <161228314075.576669.15427172810948915572.stgit@firesoul>
References: <161228314075.576669.15427172810948915572.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.

The SKB object is complex and the skb->len value (accessible from
BPF-prog) also include the length of any extra GRO/GSO segments, but
without taking into account that these GRO/GSO segments get added
transport (L4) and network (L3) headers before being transmitted. Thus,
this BPF-helper is created such that the BPF-programmer don't need to
handle these details in the BPF-prog.

The API is designed to help the BPF-programmer, that want to do packet
context size changes, which involves other helpers. These other helpers
usually does a delta size adjustment. This helper also support a delta
size (len_diff), which allow BPF-programmer to reuse arguments needed by
these other helpers, and perform the MTU check prior to doing any actual
size adjustment of the packet context.

It is on purpose, that we allow the len adjustment to become a negative
result, that will pass the MTU check. This might seem weird, but it's not
this helpers responsibility to "catch" wrong len_diff adjustments. Other
helpers will take care of these checks, if BPF-programmer chooses to do
actual size adjustment.

V14:
 - Improve man-page desc of len_diff.

V13:
 - Enforce flag BPF_MTU_CHK_SEGS cannot use len_diff.

V12:
 - Simplify segment check that calls skb_gso_validate_network_len.
 - Helpers should return long

V9:
- Use dev->hard_header_len (instead of ETH_HLEN)
- Annotate with unlikely req from Daniel
- Fix logic error using skb_gso_validate_network_len from Daniel

V6:
- Took John's advice and dropped BPF_MTU_CHK_RELAX
- Returned MTU is kept at L3-level (like fib_lookup)

V4: Lot of changes
 - ifindex 0 now use current netdev for MTU lookup
 - rename helper from bpf_mtu_check to bpf_check_mtu
 - fix bug for GSO pkt length (as skb->len is total len)
 - remove __bpf_len_adj_positive, simply allow negative len adj

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 include/uapi/linux/bpf.h       |   75 ++++++++++++++++++++++++++
 net/core/filter.c              |  114 ++++++++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |   75 ++++++++++++++++++++++++++
 3 files changed, 264 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 05bfc8c843dc..0fde9c24c312 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3839,6 +3839,69 @@ union bpf_attr {
  *	Return
  *		A pointer to a struct socket on success or NULL if the file is
  *		not a socket.
+ *
+ * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
+ *	Description
+
+ *		Check ctx packet size against exceeding MTU of net device (based
+ *		on *ifindex*).  This helper will likely be used in combination
+ *		with helpers that adjust/change the packet size.
+ *
+ *		The argument *len_diff* can be used for querying with a planned
+ *		size change. This allows to check MTU prior to changing packet
+ *		ctx. Providing an *len_diff* adjustment that is larger than the
+ *		actual packet size (resulting in negative packet size) will in
+ *		principle not exceed the MTU, why it is not considered a
+ *		failure.  Other BPF-helpers are needed for performing the
+ *		planned size change, why the responsability for catch a negative
+ *		packet size belong in those helpers.
+ *
+ *		Specifying *ifindex* zero means the MTU check is performed
+ *		against the current net device.  This is practical if this isn't
+ *		used prior to redirect.
+ *
+ *		The Linux kernel route table can configure MTUs on a more
+ *		specific per route level, which is not provided by this helper.
+ *		For route level MTU checks use the **bpf_fib_lookup**\ ()
+ *		helper.
+ *
+ *		*ctx* is either **struct xdp_md** for XDP programs or
+ *		**struct sk_buff** for tc cls_act programs.
+ *
+ *		The *flags* argument can be a combination of one or more of the
+ *		following values:
+ *
+ *		**BPF_MTU_CHK_SEGS**
+ *			This flag will only works for *ctx* **struct sk_buff**.
+ *			If packet context contains extra packet segment buffers
+ *			(often knows as GSO skb), then MTU check is harder to
+ *			check at this point, because in transmit path it is
+ *			possible for the skb packet to get re-segmented
+ *			(depending on net device features).  This could still be
+ *			a MTU violation, so this flag enables performing MTU
+ *			check against segments, with a different violation
+ *			return code to tell it apart. Check cannot use len_diff.
+ *
+ *		On return *mtu_len* pointer contains the MTU value of the net
+ *		device.  Remember the net device configured MTU is the L3 size,
+ *		which is returned here and XDP and TX length operate at L2.
+ *		Helper take this into account for you, but remember when using
+ *		MTU value in your BPF-code.  On input *mtu_len* must be a valid
+ *		pointer and be initialized (to zero), else verifier will reject
+ *		BPF program.
+ *
+ *	Return
+ *		* 0 on success, and populate MTU value in *mtu_len* pointer.
+ *
+ *		* < 0 if any input argument is invalid (*mtu_len* not updated)
+ *
+ *		MTU violations return positive values, but also populate MTU
+ *		value in *mtu_len* pointer, as this can be needed for
+ *		implementing PMTU handing:
+ *
+ *		* **BPF_MTU_CHK_RET_FRAG_NEEDED**
+ *		* **BPF_MTU_CHK_RET_SEGS_TOOBIG**
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4004,6 +4067,7 @@ union bpf_attr {
 	FN(ktime_get_coarse_ns),	\
 	FN(ima_inode_hash),		\
 	FN(sock_from_file),		\
+	FN(check_mtu),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -5036,6 +5100,17 @@ struct bpf_redir_neigh {
 	};
 };
 
+/* bpf_check_mtu flags*/
+enum  bpf_check_mtu_flags {
+	BPF_MTU_CHK_SEGS  = (1U << 0),
+};
+
+enum bpf_check_mtu_ret {
+	BPF_MTU_CHK_RET_SUCCESS,      /* check and lookup successful */
+	BPF_MTU_CHK_RET_FRAG_NEEDED,  /* fragmentation required to fwd */
+	BPF_MTU_CHK_RET_SEGS_TOOBIG,  /* GSO re-segmentation needed to fwd */
+};
+
 enum bpf_task_fd_type {
 	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
 	BPF_FD_TYPE_TRACEPOINT,		/* tp name */
diff --git a/net/core/filter.c b/net/core/filter.c
index 7b1b9baaabd5..f6777e8f9ff7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5624,6 +5624,116 @@ static const struct bpf_func_proto bpf_skb_fib_lookup_proto = {
 	.arg4_type	= ARG_ANYTHING,
 };
 
+static struct net_device *__dev_via_ifindex(struct net_device *dev_curr,
+					    u32 ifindex)
+{
+	struct net *netns = dev_net(dev_curr);
+
+	/* Non-redirect use-cases can use ifindex=0 and save ifindex lookup */
+	if (ifindex == 0)
+		return dev_curr;
+
+	return dev_get_by_index_rcu(netns, ifindex);
+}
+
+BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
+	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)
+{
+	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
+	struct net_device *dev = skb->dev;
+	int skb_len, dev_len;
+	int mtu;
+
+	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS)))
+		return -EINVAL;
+
+	if (unlikely(flags & BPF_MTU_CHK_SEGS && len_diff))
+		return -EINVAL;
+
+	dev = __dev_via_ifindex(dev, ifindex);
+	if (unlikely(!dev))
+		return -ENODEV;
+
+	mtu = READ_ONCE(dev->mtu);
+
+	dev_len = mtu + dev->hard_header_len;
+	skb_len = skb->len + len_diff; /* minus result pass check */
+	if (skb_len <= dev_len) {
+		ret = BPF_MTU_CHK_RET_SUCCESS;
+		goto out;
+	}
+	/* At this point, skb->len exceed MTU, but as it include length of all
+	 * segments, it can still be below MTU.  The SKB can possibly get
+	 * re-segmented in transmit path (see validate_xmit_skb).  Thus, user
+	 * must choose if segs are to be MTU checked.
+	 */
+	if (skb_is_gso(skb)) {
+		ret = BPF_MTU_CHK_RET_SUCCESS;
+
+		if (flags & BPF_MTU_CHK_SEGS &&
+		    !skb_gso_validate_network_len(skb, mtu))
+			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
+	}
+out:
+	/* BPF verifier guarantees valid pointer */
+	*mtu_len = mtu;
+
+	return ret;
+}
+
+BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
+	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)
+{
+	struct net_device *dev = xdp->rxq->dev;
+	int xdp_len = xdp->data_end - xdp->data;
+	int ret = BPF_MTU_CHK_RET_SUCCESS;
+	int mtu, dev_len;
+
+	/* XDP variant doesn't support multi-buffer segment check (yet) */
+	if (unlikely(flags))
+		return -EINVAL;
+
+	dev = __dev_via_ifindex(dev, ifindex);
+	if (unlikely(!dev))
+		return -ENODEV;
+
+	mtu = READ_ONCE(dev->mtu);
+
+	/* Add L2-header as dev MTU is L3 size */
+	dev_len = mtu + dev->hard_header_len;
+
+	xdp_len += len_diff; /* minus result pass check */
+	if (xdp_len > dev_len)
+		ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
+
+	/* BPF verifier guarantees valid pointer */
+	*mtu_len = mtu;
+
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_skb_check_mtu_proto = {
+	.func		= bpf_skb_check_mtu,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_ANYTHING,
+	.arg3_type      = ARG_PTR_TO_INT,
+	.arg4_type      = ARG_ANYTHING,
+	.arg5_type      = ARG_ANYTHING,
+};
+
+static const struct bpf_func_proto bpf_xdp_check_mtu_proto = {
+	.func		= bpf_xdp_check_mtu,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_ANYTHING,
+	.arg3_type      = ARG_PTR_TO_INT,
+	.arg4_type      = ARG_ANYTHING,
+	.arg5_type      = ARG_ANYTHING,
+};
+
 #if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
 static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len)
 {
@@ -7193,6 +7303,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_socket_uid_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_skb_fib_lookup_proto;
+	case BPF_FUNC_check_mtu:
+		return &bpf_skb_check_mtu_proto;
 	case BPF_FUNC_sk_fullsock:
 		return &bpf_sk_fullsock_proto;
 	case BPF_FUNC_sk_storage_get:
@@ -7262,6 +7374,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_adjust_tail_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
+	case BPF_FUNC_check_mtu:
+		return &bpf_xdp_check_mtu_proto;
 #ifdef CONFIG_INET
 	case BPF_FUNC_sk_lookup_udp:
 		return &bpf_xdp_sk_lookup_udp_proto;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 05bfc8c843dc..0fde9c24c312 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3839,6 +3839,69 @@ union bpf_attr {
  *	Return
  *		A pointer to a struct socket on success or NULL if the file is
  *		not a socket.
+ *
+ * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
+ *	Description
+
+ *		Check ctx packet size against exceeding MTU of net device (based
+ *		on *ifindex*).  This helper will likely be used in combination
+ *		with helpers that adjust/change the packet size.
+ *
+ *		The argument *len_diff* can be used for querying with a planned
+ *		size change. This allows to check MTU prior to changing packet
+ *		ctx. Providing an *len_diff* adjustment that is larger than the
+ *		actual packet size (resulting in negative packet size) will in
+ *		principle not exceed the MTU, why it is not considered a
+ *		failure.  Other BPF-helpers are needed for performing the
+ *		planned size change, why the responsability for catch a negative
+ *		packet size belong in those helpers.
+ *
+ *		Specifying *ifindex* zero means the MTU check is performed
+ *		against the current net device.  This is practical if this isn't
+ *		used prior to redirect.
+ *
+ *		The Linux kernel route table can configure MTUs on a more
+ *		specific per route level, which is not provided by this helper.
+ *		For route level MTU checks use the **bpf_fib_lookup**\ ()
+ *		helper.
+ *
+ *		*ctx* is either **struct xdp_md** for XDP programs or
+ *		**struct sk_buff** for tc cls_act programs.
+ *
+ *		The *flags* argument can be a combination of one or more of the
+ *		following values:
+ *
+ *		**BPF_MTU_CHK_SEGS**
+ *			This flag will only works for *ctx* **struct sk_buff**.
+ *			If packet context contains extra packet segment buffers
+ *			(often knows as GSO skb), then MTU check is harder to
+ *			check at this point, because in transmit path it is
+ *			possible for the skb packet to get re-segmented
+ *			(depending on net device features).  This could still be
+ *			a MTU violation, so this flag enables performing MTU
+ *			check against segments, with a different violation
+ *			return code to tell it apart. Check cannot use len_diff.
+ *
+ *		On return *mtu_len* pointer contains the MTU value of the net
+ *		device.  Remember the net device configured MTU is the L3 size,
+ *		which is returned here and XDP and TX length operate at L2.
+ *		Helper take this into account for you, but remember when using
+ *		MTU value in your BPF-code.  On input *mtu_len* must be a valid
+ *		pointer and be initialized (to zero), else verifier will reject
+ *		BPF program.
+ *
+ *	Return
+ *		* 0 on success, and populate MTU value in *mtu_len* pointer.
+ *
+ *		* < 0 if any input argument is invalid (*mtu_len* not updated)
+ *
+ *		MTU violations return positive values, but also populate MTU
+ *		value in *mtu_len* pointer, as this can be needed for
+ *		implementing PMTU handing:
+ *
+ *		* **BPF_MTU_CHK_RET_FRAG_NEEDED**
+ *		* **BPF_MTU_CHK_RET_SEGS_TOOBIG**
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4004,6 +4067,7 @@ union bpf_attr {
 	FN(ktime_get_coarse_ns),	\
 	FN(ima_inode_hash),		\
 	FN(sock_from_file),		\
+	FN(check_mtu),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -5036,6 +5100,17 @@ struct bpf_redir_neigh {
 	};
 };
 
+/* bpf_check_mtu flags*/
+enum  bpf_check_mtu_flags {
+	BPF_MTU_CHK_SEGS  = (1U << 0),
+};
+
+enum bpf_check_mtu_ret {
+	BPF_MTU_CHK_RET_SUCCESS,      /* check and lookup successful */
+	BPF_MTU_CHK_RET_FRAG_NEEDED,  /* fragmentation required to fwd */
+	BPF_MTU_CHK_RET_SEGS_TOOBIG,  /* GSO re-segmentation needed to fwd */
+};
+
 enum bpf_task_fd_type {
 	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
 	BPF_FD_TYPE_TRACEPOINT,		/* tp name */


