Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAA06EA2C0
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 06:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjDUEYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 00:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjDUEYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 00:24:16 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC835FE6;
        Thu, 20 Apr 2023 21:24:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0VgbJvYw_1682051049;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VgbJvYw_1682051049)
          by smtp.aliyun-inc.com;
          Fri, 21 Apr 2023 12:24:09 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, pabeni@redhat.com, song@kernel.org,
        sdf@google.com, haoluo@google.com, yhs@fb.com, edumazet@google.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [RFC PATCH bpf-next v3 4/5] bpf: add smc negotiator support in BPF struct_ops
Date:   Fri, 21 Apr 2023 12:23:52 +0800
Message-Id: <1682051033-66125-5-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1682051033-66125-1-git-send-email-alibuda@linux.alibaba.com>
References: <1682051033-66125-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This PATCH attempts to introduce BPF injection capability for SMC.
Considering that the SMC protocol is not suitable for all scenarios,
especially for short-lived. However, for most applications, they cannot
guarantee that there are no such scenarios at all. Therefore, apps
may need some specific strategies to decide shall we need to use SMC
or not, for example, apps can limit the scope of the SMC to a specific
IP address or port.

Based on the consideration of transparent replacement, we hope that apps
can remain transparent even if they need to formulate some specific
strategies for SMC using. That is, do not need to recompile their code.

On the other hand, we need to ensure the scalability of strategies
implementation. Although it is simple to use socket options or sysctl,
it will bring more complexity to subsequent expansion.

Fortunately, BPF can solve these concerns very well, users can write
thire own strategies in eBPF to choose whether to use SMC or not.
And it's quite easy for them to modify their strategies in the future.

This PATCH implement injection capability for SMC via struct_ops.
In that way, we can add new injection scenarios in the future.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 kernel/bpf/bpf_struct_ops_types.h |   4 +
 net/smc/bpf_smc.c                 | 159 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 163 insertions(+)

diff --git a/kernel/bpf/bpf_struct_ops_types.h b/kernel/bpf/bpf_struct_ops_types.h
index 5678a9d..d952b85 100644
--- a/kernel/bpf/bpf_struct_ops_types.h
+++ b/kernel/bpf/bpf_struct_ops_types.h
@@ -9,4 +9,8 @@
 #include <net/tcp.h>
 BPF_STRUCT_OPS_TYPE(tcp_congestion_ops)
 #endif
+#if IS_ENABLED(CONFIG_SMC_BPF)
+#include <net/smc.h>
+BPF_STRUCT_OPS_TYPE(smc_sock_negotiator_ops)
+#endif
 #endif
diff --git a/net/smc/bpf_smc.c b/net/smc/bpf_smc.c
index 0c0ec05..37307ea 100644
--- a/net/smc/bpf_smc.c
+++ b/net/smc/bpf_smc.c
@@ -7,14 +7,20 @@
  *  Author(s):  D. Wythe <alibuda@linux.alibaba.com>
  */
 
+#include <linux/bpf_verifier.h>
+#include <linux/btf_ids.h>
 #include <linux/kernel.h>
 #include <linux/bpf.h>
+#include <linux/btf.h>
 #include <linux/smc.h>
 #include <net/sock.h>
 #include "smc.h"
 
+struct bpf_struct_ops bpf_smc_sock_negotiator_ops;
+
 static DEFINE_SPINLOCK(smc_sock_negotiator_list_lock);
 static LIST_HEAD(smc_sock_negotiator_list);
+static u32 smc_sock_id, sock_id;
 
 /* required smc_sock_negotiator_list_lock locked */
 static struct smc_sock_negotiator_ops *smc_negotiator_ops_get_by_key(u32 key)
@@ -199,3 +205,156 @@ void smc_sock_clone_negotiator_ops(struct sock *parent, struct sock *child)
 }
 EXPORT_SYMBOL_GPL(smc_sock_clone_negotiator_ops);
 
+static int bpf_smc_negotiator_init(struct btf *btf)
+{
+	s32 type_id;
+
+	type_id = btf_find_by_name_kind(btf, "sock", BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return -EINVAL;
+	sock_id = type_id;
+
+	type_id = btf_find_by_name_kind(btf, "smc_sock", BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return -EINVAL;
+	smc_sock_id = type_id;
+
+	return 0;
+}
+
+/* register ops */
+static int bpf_smc_negotiator_reg(void *kdata)
+{
+	return smc_sock_register_negotiator_ops(kdata);
+}
+
+/* unregister ops */
+static void bpf_smc_negotiator_unreg(void *kdata)
+{
+	smc_sock_unregister_negotiator_ops(kdata);
+}
+
+/* unregister ops */
+static int bpf_smc_negotiator_update(void *kdata, void *old_kdata)
+{
+	return smc_sock_update_negotiator_ops(kdata, old_kdata);
+}
+
+static int bpf_smc_negotiator_validate(void *kdata)
+{
+	return smc_sock_validate_negotiator_ops(kdata);
+}
+
+static int bpf_smc_negotiator_check_member(const struct btf_type *t,
+					   const struct btf_member *member,
+					   const struct bpf_prog *prog)
+{
+	return 0;
+}
+
+static int bpf_smc_negotiator_init_member(const struct btf_type *t,
+					  const struct btf_member *member,
+					  void *kdata, const void *udata)
+{
+	const struct smc_sock_negotiator_ops *uops;
+	struct smc_sock_negotiator_ops *ops;
+	u32 moff;
+
+	uops = (const struct smc_sock_negotiator_ops *)udata;
+	ops = (struct smc_sock_negotiator_ops *)kdata;
+
+	moff = __btf_member_bit_offset(t, member) / 8;
+
+	/* init name */
+	if (moff ==  offsetof(struct smc_sock_negotiator_ops, name)) {
+		if (bpf_obj_name_cpy(ops->name, uops->name,
+				     sizeof(uops->name)) <= 0)
+			return -EINVAL;
+		return 1;
+	}
+
+	return 0;
+}
+
+BPF_CALL_1(bpf_smc_skc_to_tcp_sock, struct sock *, sk)
+{
+	if (sk && sk_fullsock(sk) && sk->sk_family == AF_SMC)
+		return (unsigned long)((struct smc_sock *)(sk))->clcsock->sk;
+
+	return (unsigned long)NULL;
+}
+
+const struct bpf_func_proto bpf_smc_skc_to_tcp_sock_proto = {
+	.func			= bpf_smc_skc_to_tcp_sock,
+	.gpl_only		= false,
+	.ret_type		= RET_PTR_TO_BTF_ID_OR_NULL,
+	.arg1_type		= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_TCP],
+};
+
+static const struct bpf_func_proto *
+smc_negotiator_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	const struct btf_member *m;
+	const struct btf_type *t;
+	u32 midx, moff;
+
+	midx = prog->expected_attach_type;
+	t = bpf_smc_sock_negotiator_ops.type;
+	m = &btf_type_member(t)[midx];
+
+	moff = __btf_member_bit_offset(t, m) / 8;
+
+	switch (func_id) {
+	case BPF_FUNC_setsockopt:
+		switch (moff) {
+		/* Avoid potential deadloop risk */
+		case offsetof(struct smc_sock_negotiator_ops, init):
+			fallthrough;
+		/* Avoid potential leak risk */
+		case offsetof(struct smc_sock_negotiator_ops, release):
+			return NULL;
+		}
+		return &bpf_sk_setsockopt_proto;
+	case BPF_FUNC_getsockopt:
+		return &bpf_sk_getsockopt_proto;
+	case BPF_FUNC_skc_to_tcp_sock:
+		return &bpf_smc_skc_to_tcp_sock_proto;
+	default:
+		return bpf_base_func_proto(func_id);
+	}
+}
+
+static bool smc_negotiator_prog_is_valid_access(int off, int size, enum bpf_access_type type,
+						const struct bpf_prog *prog,
+						struct bpf_insn_access_aux *info)
+{
+	if (!bpf_tracing_btf_ctx_access(off, size, type, prog, info))
+		return false;
+
+	/* promote it to smc_sock */
+	if (base_type(info->reg_type) == PTR_TO_BTF_ID &&
+	    !bpf_type_has_unsafe_modifiers(info->reg_type) &&
+	    info->btf_id == sock_id)
+		info->btf_id = smc_sock_id;
+
+	return true;
+}
+
+static const struct bpf_verifier_ops bpf_smc_negotiator_verifier_ops = {
+	.get_func_proto  = smc_negotiator_prog_func_proto,
+	.is_valid_access = smc_negotiator_prog_is_valid_access,
+};
+
+struct bpf_struct_ops bpf_smc_sock_negotiator_ops = {
+	.verifier_ops = &bpf_smc_negotiator_verifier_ops,
+	.init = bpf_smc_negotiator_init,
+	.check_member = bpf_smc_negotiator_check_member,
+	.init_member = bpf_smc_negotiator_init_member,
+	.reg = bpf_smc_negotiator_reg,
+	.update = bpf_smc_negotiator_update,
+	.unreg = bpf_smc_negotiator_unreg,
+	.validate = bpf_smc_negotiator_validate,
+	.name = "smc_sock_negotiator_ops",
+};
+
-- 
1.8.3.1

