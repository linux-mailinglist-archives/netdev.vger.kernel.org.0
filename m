Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2398573515
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiGMLO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbiGMLOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:14:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F041FF597
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657710883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+fSAWDEGpl8ZiSP+HMH8zwUMV3ceUvwVsG+k+DjufDg=;
        b=E8brxe9adHb442jLgJpf+rXHEWgK29Od9XSfVAdzDB4Ti+dKUxkFxCFL2xM6YdsOL2zDUE
        xx6PJU0NykFQl+uWKCf7DyMafvn3vE13r/GPaurWywDhKltutIHgbveJwLtiK9rlu5+/kL
        54xk5UbG1qGvMbE2xiS+K+aponZ24eg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-sFHY2ZHqOSiCJjS559drCg-1; Wed, 13 Jul 2022 07:14:42 -0400
X-MC-Unique: sFHY2ZHqOSiCJjS559drCg-1
Received: by mail-ej1-f69.google.com with SMTP id sh39-20020a1709076ea700b0072aa3156a68so3239169ejc.19
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+fSAWDEGpl8ZiSP+HMH8zwUMV3ceUvwVsG+k+DjufDg=;
        b=rNQSMH0uc3K7EgJzZQ77Bq+UzYe4H7VYSFdwHBTTr3GzUNK4yNuBvvwwXvInIaNQ1/
         qjMKLX2vKVgEDUTSjUFIrpoxD+MYoE5DUDprIbUJWI9Q/y/5ZULfLeUscRIMQ2a74TYV
         XLznn7yYXwnnvzevRQYrdHtuMJ0bnIn9Tc67xKUMy5YnAT1jYf56/G4rTfxzogYdMMRX
         C1yf1WujPXlNtzby+R+xFG/cFwwxL79BGec6MMNTvG92lCkt25ucVAPUjUeiocW04vna
         LCu2z8sdhkb87gqwswAwMkJ9yN/qCWPwJCQDY7hVxj3M3zEAFek02fjy40pB0X/4sjgQ
         +81w==
X-Gm-Message-State: AJIora/QPJzxKIkoHktZ1xCiugYg3BZBtRqWiWPxhfRuIdfVbhvwOU3H
        WwfQKyKCuH98cxWFe2kkzeVeCrxArE+0mm19a1Njp185G4mufmr9FjCdWQmPG+FCsbEuep2Jofq
        +ezSRre559zM5md9e
X-Received: by 2002:a17:906:6a0f:b0:72b:64ce:289d with SMTP id qw15-20020a1709066a0f00b0072b64ce289dmr2770262ejc.663.1657710879458;
        Wed, 13 Jul 2022 04:14:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sCdKO4zWgqJ8EJISzFR2q6vt/cCdrOMboNj75zsLVfKWzKMpG+zCuE3s699AavLwI24PA7pg==
X-Received: by 2002:a17:906:6a0f:b0:72b:64ce:289d with SMTP id qw15-20020a1709066a0f00b0072b64ce289dmr2770210ejc.663.1657710879048;
        Wed, 13 Jul 2022 04:14:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 26-20020a170906311a00b0070e238ff66fsm4825119ejx.96.2022.07.13.04.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:14:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3A14F4D9907; Wed, 13 Jul 2022 13:14:36 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC PATCH 06/17] xdp: Add dequeue program type for getting packets from a PIFO
Date:   Wed, 13 Jul 2022 13:14:14 +0200
Message-Id: <20220713111430.134810-7-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new BPF_PROG_TYPE_DEQUEUE, which will be executed by a new device
hook to retrieve queued packets for transmission. The API of the dequeue
program is simple: it takes a context object containing as its sole member
the ifindex of the device it is being executed on. The program can return a
pointer to a packet, or NULL to indicate it has nothing to transmit at this
time. Packet pointers are obtained by dequeueing them from a PIFO
map (using a helper added in a subsequent commit).

This commit adds dequeue program type and the ability to run it using the
bpf_prog_run() syscall (returning the dequeued packet to userspace); a
subsequent commit introduces the network stack hook to attach and execute
dequeue programs.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h            |  9 ++++++
 include/linux/bpf_types.h      |  2 ++
 include/net/xdp.h              |  4 +++
 include/uapi/linux/bpf.h       |  5 ++++
 kernel/bpf/syscall.c           |  1 +
 net/bpf/test_run.c             | 33 +++++++++++++++++++++
 net/core/filter.c              | 53 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  5 ++++
 8 files changed, 112 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ea994acebb81..6ea5d6d188cf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1864,6 +1864,8 @@ int array_map_alloc_check(union bpf_attr *attr);
 
 int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr);
+int bpf_prog_test_run_dequeue(struct bpf_prog *prog, const union bpf_attr *kattr,
+			      union bpf_attr __user *uattr);
 int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr);
 int bpf_prog_test_run_tracing(struct bpf_prog *prog,
@@ -2107,6 +2109,13 @@ static inline int bpf_prog_test_run_xdp(struct bpf_prog *prog,
 	return -ENOTSUPP;
 }
 
+static inline int bpf_prog_test_run_dequeue(struct bpf_prog *prog,
+					    const union bpf_attr *kattr,
+					    union bpf_attr __user *uattr)
+{
+	return -ENOTSUPP;
+}
+
 static inline int bpf_prog_test_run_skb(struct bpf_prog *prog,
 					const union bpf_attr *kattr,
 					union bpf_attr __user *uattr)
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 26ef981a8aa5..e6bc962befb7 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -10,6 +10,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_SCHED_ACT, tc_cls_act,
 	      struct __sk_buff, struct sk_buff)
 BPF_PROG_TYPE(BPF_PROG_TYPE_XDP, xdp,
 	      struct xdp_md, struct xdp_buff)
+BPF_PROG_TYPE(BPF_PROG_TYPE_DEQUEUE, dequeue,
+	      struct dequeue_ctx, struct dequeue_data)
 #ifdef CONFIG_CGROUP_BPF
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SKB, cg_skb,
 	      struct __sk_buff, struct sk_buff)
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 7c694fb26f34..728ce943d352 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -85,6 +85,10 @@ struct xdp_buff {
 	u32 flags; /* supported values defined in xdp_buff_flags */
 };
 
+struct dequeue_data {
+	struct xdp_txq_info *txq;
+};
+
 static __always_inline bool xdp_buff_has_frags(struct xdp_buff *xdp)
 {
 	return !!(xdp->flags & XDP_FLAGS_HAS_FRAGS);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f0947ddee784..974fb5882305 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -954,6 +954,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_DEQUEUE,
 };
 
 enum bpf_attach_type {
@@ -5961,6 +5962,10 @@ struct xdp_md {
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
+struct dequeue_ctx {
+	__u32 egress_ifindex;
+};
+
 /* DEVMAP map-value layout
  *
  * The struct data-layout of map-value is a configuration interface.
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 31899882e513..c4af9119b68a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2370,6 +2370,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		default:
 			return -EINVAL;
 		}
+	case BPF_PROG_TYPE_DEQUEUE:
 	case BPF_PROG_TYPE_SYSCALL:
 	case BPF_PROG_TYPE_EXT:
 		if (expected_attach_type)
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index f05d13717430..a7f479a19fe0 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1390,6 +1390,39 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	return ret;
 }
 
+int bpf_prog_test_run_dequeue(struct bpf_prog *prog, const union bpf_attr *kattr,
+			      union bpf_attr __user *uattr)
+{
+	struct xdp_txq_info txq = { .dev = current->nsproxy->net_ns->loopback_dev };
+	u32 repeat = kattr->test.repeat, duration, size;
+	struct dequeue_data ctx = { .txq = &txq };
+	struct xdp_buff xdp = {};
+	struct xdp_frame *pkt;
+	int ret = -EINVAL;
+	u64 retval;
+
+	if (prog->expected_attach_type)
+		return -EINVAL;
+
+	if (kattr->test.data_in || kattr->test.data_size_in ||
+	    kattr->test.ctx_in || kattr->test.ctx_out || repeat > 1)
+		return -EINVAL;
+
+	ret = bpf_test_run(prog, &ctx, repeat, &retval, &duration, false);
+	if (ret)
+		return ret;
+	if (!retval)
+		return bpf_test_finish(kattr, uattr, NULL, NULL, 0, retval, duration);
+
+	pkt = (void *)(unsigned long)retval;
+	xdp_convert_frame_to_buff(pkt, &xdp);
+	size = xdp.data_end - xdp.data_meta;
+	/* We set retval == 1 if pkt != NULL, otherwise 0 */
+	ret = bpf_test_finish(kattr, uattr, xdp.data_meta, NULL, size, !!retval, duration);
+	xdp_return_frame(pkt);
+	return ret;
+}
+
 static int verify_user_bpf_flow_keys(struct bpf_flow_keys *ctx)
 {
 	/* make sure the fields we don't use are zeroed */
diff --git a/net/core/filter.c b/net/core/filter.c
index 8e6ea17a29db..30bd3a6aedab 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8062,6 +8062,12 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	}
 }
 
+static const struct bpf_func_proto *
+dequeue_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id);
+}
+
 const struct bpf_func_proto bpf_sock_map_update_proto __weak;
 const struct bpf_func_proto bpf_sock_hash_update_proto __weak;
 
@@ -8776,6 +8782,20 @@ void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog,
 }
 EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
 
+static bool dequeue_is_valid_access(int off, int size,
+				    enum bpf_access_type type,
+				    const struct bpf_prog *prog,
+				    struct bpf_insn_access_aux *info)
+{
+	if (type == BPF_WRITE)
+		return false;
+	switch (off) {
+	case offsetof(struct dequeue_ctx, egress_ifindex):
+		return true;
+	}
+	return false;
+}
+
 static bool sock_addr_is_valid_access(int off, int size,
 				      enum bpf_access_type type,
 				      const struct bpf_prog *prog,
@@ -9835,6 +9855,28 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 	return insn - insn_buf;
 }
 
+static u32 dequeue_convert_ctx_access(enum bpf_access_type type,
+				      const struct bpf_insn *si,
+				      struct bpf_insn *insn_buf,
+				      struct bpf_prog *prog, u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+
+	switch (si->off) {
+	case offsetof(struct dequeue_ctx, egress_ifindex):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct dequeue_data, txq),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct dequeue_data, txq));
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_txq_info, dev),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct xdp_txq_info, dev));
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
+				      offsetof(struct net_device, ifindex));
+		break;
+	}
+	return insn - insn_buf;
+}
+
 /* SOCK_ADDR_LOAD_NESTED_FIELD() loads Nested Field S.F.NF where S is type of
  * context Structure, F is Field in context structure that contains a pointer
  * to Nested Structure of type NS that has the field NF.
@@ -10687,6 +10729,17 @@ const struct bpf_prog_ops xdp_prog_ops = {
 	.test_run		= bpf_prog_test_run_xdp,
 };
 
+const struct bpf_verifier_ops dequeue_verifier_ops = {
+	.get_func_proto		= dequeue_func_proto,
+	.is_valid_access	= dequeue_is_valid_access,
+	.convert_ctx_access	= dequeue_convert_ctx_access,
+	.gen_prologue		= bpf_noop_prologue,
+};
+
+const struct bpf_prog_ops dequeue_prog_ops = {
+	.test_run		= bpf_prog_test_run_dequeue,
+};
+
 const struct bpf_verifier_ops cg_skb_verifier_ops = {
 	.get_func_proto		= cg_skb_func_proto,
 	.is_valid_access	= cg_skb_is_valid_access,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 623421377f6e..4dd8a563f85d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -954,6 +954,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_DEQUEUE,
 };
 
 enum bpf_attach_type {
@@ -5961,6 +5962,10 @@ struct xdp_md {
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
+struct dequeue_ctx {
+	__u32 egress_ifindex;
+};
+
 /* DEVMAP map-value layout
  *
  * The struct data-layout of map-value is a configuration interface.
-- 
2.37.0

