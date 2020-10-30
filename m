Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00D62A0BC6
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgJ3QvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:51:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27478 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726461AbgJ3QvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:51:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604076673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vyfw7oek04FKhqJUsdSMylvAHLFcKQ4smTigkY9XGjk=;
        b=iDTYGSlArfZQvWh3Idy67Pf53/nvePk92a997af6tkY+FCSt7ZL0Ca1nR5DYwyYnggs8lA
        /gmMyim9OpGAmY/+70td4OGScwHccvNA6G6lv1lBcw+/MPiSU+EtUOIY3hdZbxxrW8thaV
        FkzBEQf+qwjSgl0qdzsFqbDM5Y0OrOw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-WPU3gNegPmuhD6yjC4vk-w-1; Fri, 30 Oct 2020 12:51:11 -0400
X-MC-Unique: WPU3gNegPmuhD6yjC4vk-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CE2F760C0;
        Fri, 30 Oct 2020 16:51:08 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7437660BE2;
        Fri, 30 Oct 2020 16:51:03 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 72ECD30736C93;
        Fri, 30 Oct 2020 17:51:02 +0100 (CET)
Subject: [PATCH bpf-next V5 3/5] bpf: add BPF-helper for MTU checking
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Date:   Fri, 30 Oct 2020 17:51:02 +0100
Message-ID: <160407666238.1525159.9197344855524540198.stgit@firesoul>
In-Reply-To: <160407661383.1525159.12855559773280533146.stgit@firesoul>
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.

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

V4: Lot of changes
 - ifindex 0 now use current netdev for MTU lookup
 - rename helper from bpf_mtu_check to bpf_check_mtu
 - fix bug for GSO pkt length (as skb->len is total len)
 - remove __bpf_len_adj_positive, simply allow negative len adj

V3: Take L2/ETH_HLEN header size into account and document it.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/uapi/linux/bpf.h       |   70 +++++++++++++++++++++++
 net/core/filter.c              |  120 ++++++++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |   70 +++++++++++++++++++++++
 3 files changed, 260 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 01b2b17c645a..8f0fee2df3a6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3745,6 +3745,63 @@ union bpf_attr {
  * 	Return
  * 		The helper returns **TC_ACT_REDIRECT** on success or
  * 		**TC_ACT_SHOT** on error.
+ *
+ * int bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_result, s32 len_diff, u64 flags)
+ *	Description
+ *		Check ctx packet size against MTU of net device (based on
+ *		*ifindex*).  This helper will likely be used in combination with
+ *		helpers that adjust/change the packet size.  The argument
+ *		*len_diff* can be used for querying with a planned size
+ *		change. This allows to check MTU prior to changing packet ctx.
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
+ *              **BPF_MTU_CHK_RELAX**
+ *			This flag relax or increase the MTU with room for one
+ *			VLAN header (4 bytes). This relaxation is also used by
+ *			the kernels own forwarding MTU checks.
+ *
+ *		**BPF_MTU_CHK_SEGS**
+ *			This flag will only works for *ctx* **struct sk_buff**.
+ *			If packet context contains extra packet segment buffers
+ *			(often knows as GSO skb), then MTU check is partly
+ *			skipped, because in transmit path it is possible for the
+ *			skb packet to get re-segmented (depending on net device
+ *			features).  This could still be a MTU violation, so this
+ *			flag enables performing MTU check against segments, with
+ *			a different violation return code to tell it apart.
+ *
+ *		The *mtu_result* pointer contains the MTU value of the net
+ *		device including the L2 header size (usually 14 bytes Ethernet
+ *		header). The net device configured MTU is the L3 size, but as
+ *		XDP and TX length operate at L2 this helper include L2 header
+ *		size in reported MTU.
+ *
+ *	Return
+ *		* 0 on success, and populate MTU value in *mtu_result* pointer.
+ *
+ *		* < 0 if any input argument is invalid (*mtu_result* not updated)
+ *
+ *		MTU violations return positive values, but also populate MTU
+ *		value in *mtu_result* pointer, as this can be needed for
+ *		implementing PMTU handing:
+ *
+ *		* **BPF_MTU_CHK_RET_FRAG_NEEDED**
+ *		* **BPF_MTU_CHK_RET_SEGS_TOOBIG**
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3903,6 +3960,7 @@ union bpf_attr {
 	FN(bpf_per_cpu_ptr),            \
 	FN(bpf_this_cpu_ptr),		\
 	FN(redirect_peer),		\
+	FN(check_mtu),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -4927,6 +4985,18 @@ struct bpf_redir_neigh {
 	};
 };
 
+/* bpf_check_mtu flags*/
+enum  bpf_check_mtu_flags {
+	BPF_MTU_CHK_RELAX = (1U << 0),
+	BPF_MTU_CHK_SEGS  = (1U << 1),
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
index edb543c477b6..bd4a416bd9ad 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5594,6 +5594,122 @@ static const struct bpf_func_proto bpf_skb_fib_lookup_proto = {
 	.arg4_type	= ARG_ANYTHING,
 };
 
+static int __bpf_lookup_mtu(struct net_device *dev_curr, u32 ifindex, u64 flags)
+{
+	struct net *netns = dev_net(dev_curr);
+	struct net_device *dev;
+	int mtu;
+
+	/* Non-redirect use-cases can use ifindex=0 and save ifindex lookup */
+	if (ifindex == 0)
+		dev = dev_curr;
+	else
+		dev = dev_get_by_index_rcu(netns, ifindex);
+
+	if (!dev)
+		return -ENODEV;
+
+	/* XDP+TC len is L2: Add L2-header as dev MTU is L3 size */
+	mtu = dev->mtu + dev->hard_header_len;
+
+	/*  Same relax as xdp_ok_fwd_dev() and is_skb_forwardable() */
+	if (flags & BPF_MTU_CHK_RELAX)
+		mtu += VLAN_HLEN;
+
+	return mtu;
+}
+
+BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
+	   u32, ifindex, u32 *, mtu_result, s32, len_diff, u64, flags)
+{
+	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
+	struct net_device *dev = skb->dev;
+	int len = skb->len;
+	int mtu;
+
+	if (flags & ~(BPF_MTU_CHK_RELAX | BPF_MTU_CHK_SEGS))
+		return -EINVAL;
+
+	mtu = __bpf_lookup_mtu(dev, ifindex, flags);
+	if (unlikely(mtu < 0))
+		return mtu; /* errno */
+
+	len += len_diff; /* len_diff can be negative, minus result pass check */
+	if (len <= mtu) {
+		ret = BPF_MTU_CHK_RET_SUCCESS;
+		goto out;
+	}
+	/* At this point, skb->len exceed MTU, but as it include length of all
+	 * segments, and SKB can get re-segmented in transmit path (see
+	 * validate_xmit_skb), we cannot reject MTU-check for GSO packets.
+	 */
+	if (skb_is_gso(skb)) {
+		ret = BPF_MTU_CHK_RET_SUCCESS;
+
+		/* SKB could get dropped later due to segs > MTU or lacking
+		 * features, thus allow BPF-prog to validate segs length here.
+		 */
+		if (flags & BPF_MTU_CHK_SEGS &&
+		    skb_gso_validate_network_len(skb, mtu)) {
+			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
+			goto out;
+		}
+	}
+out:
+	if (mtu_result)
+		*mtu_result = mtu;
+
+	return ret;
+}
+
+BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
+	   u32, ifindex, u32 *, mtu_result, s32, len_diff, u64, flags)
+{
+	struct net_device *dev = xdp->rxq->dev;
+	int len = xdp->data_end - xdp->data;
+	int ret = BPF_MTU_CHK_RET_SUCCESS;
+	int mtu;
+
+	/* XDP variant doesn't support multi-buffer segment check (yet) */
+	if (flags & ~BPF_MTU_CHK_RELAX)
+		return -EINVAL;
+
+	mtu = __bpf_lookup_mtu(dev, ifindex, flags);
+	if (unlikely(mtu < 0))
+		return mtu; /* errno */
+
+	len += len_diff; /* len_diff can be negative, minus result pass check */
+	if (len > mtu)
+		ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
+
+	if (mtu_result)
+		*mtu_result = mtu;
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
+	.arg3_type      = ARG_PTR_TO_MEM,
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
+	.arg3_type      = ARG_PTR_TO_MEM,
+	.arg4_type      = ARG_ANYTHING,
+	.arg5_type      = ARG_ANYTHING,
+};
+
 #if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
 static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len)
 {
@@ -7159,6 +7275,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_socket_uid_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_skb_fib_lookup_proto;
+	case BPF_FUNC_check_mtu:
+		return &bpf_skb_check_mtu_proto;
 	case BPF_FUNC_sk_fullsock:
 		return &bpf_sk_fullsock_proto;
 	case BPF_FUNC_sk_storage_get:
@@ -7228,6 +7346,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_adjust_tail_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
+	case BPF_FUNC_check_mtu:
+		return &bpf_xdp_check_mtu_proto;
 #ifdef CONFIG_INET
 	case BPF_FUNC_sk_lookup_udp:
 		return &bpf_xdp_sk_lookup_udp_proto;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 01b2b17c645a..8f0fee2df3a6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3745,6 +3745,63 @@ union bpf_attr {
  * 	Return
  * 		The helper returns **TC_ACT_REDIRECT** on success or
  * 		**TC_ACT_SHOT** on error.
+ *
+ * int bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_result, s32 len_diff, u64 flags)
+ *	Description
+ *		Check ctx packet size against MTU of net device (based on
+ *		*ifindex*).  This helper will likely be used in combination with
+ *		helpers that adjust/change the packet size.  The argument
+ *		*len_diff* can be used for querying with a planned size
+ *		change. This allows to check MTU prior to changing packet ctx.
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
+ *              **BPF_MTU_CHK_RELAX**
+ *			This flag relax or increase the MTU with room for one
+ *			VLAN header (4 bytes). This relaxation is also used by
+ *			the kernels own forwarding MTU checks.
+ *
+ *		**BPF_MTU_CHK_SEGS**
+ *			This flag will only works for *ctx* **struct sk_buff**.
+ *			If packet context contains extra packet segment buffers
+ *			(often knows as GSO skb), then MTU check is partly
+ *			skipped, because in transmit path it is possible for the
+ *			skb packet to get re-segmented (depending on net device
+ *			features).  This could still be a MTU violation, so this
+ *			flag enables performing MTU check against segments, with
+ *			a different violation return code to tell it apart.
+ *
+ *		The *mtu_result* pointer contains the MTU value of the net
+ *		device including the L2 header size (usually 14 bytes Ethernet
+ *		header). The net device configured MTU is the L3 size, but as
+ *		XDP and TX length operate at L2 this helper include L2 header
+ *		size in reported MTU.
+ *
+ *	Return
+ *		* 0 on success, and populate MTU value in *mtu_result* pointer.
+ *
+ *		* < 0 if any input argument is invalid (*mtu_result* not updated)
+ *
+ *		MTU violations return positive values, but also populate MTU
+ *		value in *mtu_result* pointer, as this can be needed for
+ *		implementing PMTU handing:
+ *
+ *		* **BPF_MTU_CHK_RET_FRAG_NEEDED**
+ *		* **BPF_MTU_CHK_RET_SEGS_TOOBIG**
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3903,6 +3960,7 @@ union bpf_attr {
 	FN(bpf_per_cpu_ptr),            \
 	FN(bpf_this_cpu_ptr),		\
 	FN(redirect_peer),		\
+	FN(check_mtu),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -4927,6 +4985,18 @@ struct bpf_redir_neigh {
 	};
 };
 
+/* bpf_check_mtu flags*/
+enum  bpf_check_mtu_flags {
+	BPF_MTU_CHK_RELAX = (1U << 0),
+	BPF_MTU_CHK_SEGS  = (1U << 1),
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


