Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB782863A9
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgJGQXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:23:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55135 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728015AbgJGQXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:23:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602087778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KPTBQV/ukqdfS0FQlAcoi/IUW31HlO7s/oIdJpf8onY=;
        b=Gtsmryw+VadhDXluLw/CR0OdWn4Q/22bmf0TgqDHta4fELuaqWXvELAy+VlI1XI1uShlNO
        tMArndcB/gdHvtFae0atP9QefGOQ0FOhtF/hkMDaxFWw7YS+mOhRdJylDB5LcZd80JaBjg
        V45Qlel/HPbjCElViIINdqtDsc+L8Qw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-owCeDsKcOj6bOtQjVmIfmg-1; Wed, 07 Oct 2020 12:22:56 -0400
X-MC-Unique: owCeDsKcOj6bOtQjVmIfmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1BAC425D7;
        Wed,  7 Oct 2020 16:22:54 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A6B3702E7;
        Wed,  7 Oct 2020 16:22:51 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 91A0930736C8B;
        Wed,  7 Oct 2020 18:22:50 +0200 (CEST)
Subject: [PATCH bpf-next V2 3/6] bpf: add BPF-helper for MTU checking
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Date:   Wed, 07 Oct 2020 18:22:50 +0200
Message-ID: <160208777050.798237.15733498595654853619.stgit@firesoul>
In-Reply-To: <160208770557.798237.11181325462593441941.stgit@firesoul>
References: <160208770557.798237.11181325462593441941.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This BPF-helper bpf_mtu_check() works for both XDP and TC-BPF programs.

The API is designed to help the BPF-programmer, that want to do packet
context size changes, which involves other helpers. These other helpers
usually does a delta size adjustment. This helper also support a delta
size (len_diff), which allow BPF-programmer to reuse arguments needed by
these other helpers, and perform the MTU check prior to doing any actual
size adjustment of the packet context.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/uapi/linux/bpf.h |   57 ++++++++++++++++++++++
 net/core/filter.c        |  117 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 174 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 50ce65e37b16..64cdad06135e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3718,6 +3718,50 @@ union bpf_attr {
  *		never return NULL.
  *	Return
  *		A pointer pointing to the kernel percpu variable on this cpu.
+ *
+ * int bpf_mtu_check(void *ctx, u32 ifindex, u32 *mtu_result, s32 len_diff, u64 flags)
+ *	Description
+ *		Check ctx packet size against MTU of net device (based on
+ *		*ifindex*).  This helper will likely be used in combination with
+ *		helpers that adjust/change the packet size.  The argument
+ *		*len_diff* can be used for querying with a planned size
+ *		change. This allows to check MTU prior to changing packet ctx.
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
+ *			VLAN header (4 bytes) and take into account net device
+ *			hard_header_len.  This relaxation is also used by the
+ *			kernels own forwarding MTU checks.
+ *
+ *		**BPF_MTU_CHK_GSO**
+ *			This flag will only works for *ctx* **struct sk_buff**.
+ *			If packet context contains extra packet segment buffers
+ *			(often knows as frags), then those are also checked
+ *			against the MTU size.
+ *
+ *	Return
+ *		* 0 on success, and populate MTU value in *mtu_result* pointer.
+ *
+ *		* < 0 if any input argument is invalid (*mtu_result* not updated)
+ *
+ *		MTU violations return positive values, but also populate MTU
+ *		value in *mtu_result* pointer, as this can be needed for
+ *		implemeting PMTU handing:
+ *
+ *		* **BPF_MTU_CHK_RET_FRAG_NEEDED**
+ *		* **BPF_MTU_CHK_RET_GSO_TOOBIG**
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3875,6 +3919,7 @@ union bpf_attr {
 	FN(redirect_neigh),		\
 	FN(bpf_per_cpu_ptr),            \
 	FN(bpf_this_cpu_ptr),		\
+	FN(mtu_check),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -4889,6 +4934,18 @@ struct bpf_fib_lookup {
 	__u8	dmac[6];     /* ETH_ALEN */
 };
 
+/* bpf_mtu_check flags*/
+enum  bpf_mtu_check_flags {
+	BPF_MTU_CHK_RELAX = (1U << 0),
+	BPF_MTU_CHK_GSO   = (1U << 1),
+};
+
+enum bpf_mtu_check_ret {
+	BPF_MTU_CHK_RET_SUCCESS,      /* check and lookup successful */
+	BPF_MTU_CHK_RET_FRAG_NEEDED,  /* fragmentation required to fwd */
+	BPF_MTU_CHK_RET_GSO_TOOBIG,   /* GSO re-segmentation needed to fwd */
+};
+
 enum bpf_task_fd_type {
 	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
 	BPF_FD_TYPE_TRACEPOINT,		/* tp name */
diff --git a/net/core/filter.c b/net/core/filter.c
index d84723f347c0..54b779e34f83 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5512,6 +5512,119 @@ static const struct bpf_func_proto bpf_skb_fib_lookup_proto = {
 	.arg4_type	= ARG_ANYTHING,
 };
 
+static int bpf_mtu_lookup(struct net *netns, u32 ifindex, u64 flags)
+{
+	struct net_device *dev;
+	int mtu;
+
+	dev = dev_get_by_index_rcu(netns, ifindex);
+	if (!dev)
+		return -ENODEV;
+
+	mtu = dev->mtu;
+
+	/*  Same relax as xdp_ok_fwd_dev() and is_skb_forwardable() */
+	if (flags & BPF_MTU_CHK_RELAX)
+		mtu += dev->hard_header_len + VLAN_HLEN;
+
+	return mtu;
+}
+
+static unsigned int __bpf_len_adjust_positive(unsigned int len, int len_diff)
+{
+	int len_new = len + len_diff; /* notice len_diff can be negative */
+
+	if (len_new > 0)
+		return len_new;
+
+	return 0;
+}
+
+BPF_CALL_5(bpf_skb_mtu_check, struct sk_buff *, skb,
+	   u32, ifindex, u32 *, mtu_result, s32, len_diff, u64, flags)
+{
+	struct net *netns = dev_net(skb->dev);
+	int ret = BPF_MTU_CHK_RET_SUCCESS;
+	unsigned int len = skb->len;
+	int mtu;
+
+	if (flags & ~(BPF_MTU_CHK_RELAX|BPF_MTU_CHK_GSO))
+		return -EINVAL;
+
+	mtu = bpf_mtu_lookup(netns, ifindex, flags);
+	if (unlikely(mtu < 0))
+		return mtu;  /* errno */
+
+	len = __bpf_len_adjust_positive(len, len_diff);
+	if (len > mtu) {
+		ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
+		goto out;
+	}
+
+	if (flags & BPF_MTU_CHK_GSO &&
+	    skb_is_gso(skb) &&
+	    skb_gso_validate_network_len(skb, mtu)) {
+		ret = BPF_MTU_CHK_RET_GSO_TOOBIG;
+		goto out;
+	}
+
+out:
+	if (mtu_result)
+		*mtu_result = mtu;
+
+	return ret;
+}
+
+BPF_CALL_5(bpf_xdp_mtu_check, struct xdp_buff *, xdp,
+	   u32, ifindex, u32 *, mtu_result, s32, len_diff, u64, flags)
+{
+	unsigned int len = xdp->data_end - xdp->data;
+	struct net_device *dev = xdp->rxq->dev;
+	struct net *netns = dev_net(dev);
+	int ret = BPF_MTU_CHK_RET_SUCCESS;
+	int mtu;
+
+	/* XDP variant doesn't support multi-buffer segment check (yet) */
+	if (flags & ~BPF_MTU_CHK_RELAX)
+		return -EINVAL;
+
+	mtu = bpf_mtu_lookup(netns, ifindex, flags);
+	if (unlikely(mtu < 0))
+		return mtu; /* errno */
+
+	len = __bpf_len_adjust_positive(len, len_diff);
+	if (len > mtu) {
+		ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
+		goto out;
+	}
+out:
+	if (mtu_result)
+		*mtu_result = mtu;
+
+	return ret;}
+
+static const struct bpf_func_proto bpf_skb_mtu_check_proto = {
+	.func		= bpf_skb_mtu_check,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_ANYTHING,
+	.arg3_type      = ARG_PTR_TO_MEM,
+	.arg4_type      = ARG_ANYTHING,
+	.arg5_type      = ARG_ANYTHING,
+};
+
+static const struct bpf_func_proto bpf_xdp_mtu_check_proto = {
+	.func		= bpf_xdp_mtu_check,
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
@@ -7075,6 +7188,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_socket_uid_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_skb_fib_lookup_proto;
+	case BPF_FUNC_mtu_check:
+		return &bpf_skb_mtu_check_proto;
 	case BPF_FUNC_sk_fullsock:
 		return &bpf_sk_fullsock_proto;
 	case BPF_FUNC_sk_storage_get:
@@ -7144,6 +7259,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_adjust_tail_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
+	case BPF_FUNC_mtu_check:
+		return &bpf_xdp_mtu_check_proto;
 #ifdef CONFIG_INET
 	case BPF_FUNC_sk_lookup_udp:
 		return &bpf_xdp_sk_lookup_udp_proto;


