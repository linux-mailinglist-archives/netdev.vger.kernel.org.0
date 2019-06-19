Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA564BF20
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfFSRAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:00:03 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:43987 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfFSRAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:00:03 -0400
Received: by mail-yw1-f74.google.com with SMTP id b188so114862ywb.10
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 10:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V97UXRGrDSL5aUIbqQL48DExMGq9kR9xQCbQB33t1IE=;
        b=MH9a+LvdXS4Q72Ij235JGUSTpabM+RXVHa1Kqy5HHEkjCMTc4/ZdCN8HysaNvJ0Ybr
         yC9tblte5x7LkZquNPm2ivlTyYNkVeHFxYgBEVniZymStxFgNoo93wK8ZYHUwX7ys39f
         2BS/tEwcGmTKucloRKvdBaS/gw6puY0c6yDY+Xm4lWlzWTHaMwceLvQAbshVqH3EP+zq
         NDuzZyAjk/CjQXTbHZGxX5UyveG4jQY9diIhLXaHifBRvyHVCsKTMoq+KgHHiDcGRRXf
         vUB5bSVrohwStovkQb9Ri9XsUVhpghzAjzphzb/tgEfbkCBrsOJuzarqeWrBX/isKNHR
         aEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V97UXRGrDSL5aUIbqQL48DExMGq9kR9xQCbQB33t1IE=;
        b=BynMxmT4tGPO9qmGv8n2Znxf2vSv/m1J1OEcpr0Vr/N4vI3KCk3ILGzrWlOZVQBgcn
         ucrTxcpSht+BoUvD6oKfSxfyQcSk1CH9lfUuIygMHnRjXDDSf2GCju4hV9mZ2nqHeFk1
         xR7GfWjwsBz9TISKMbyNMADhmO1pPXCLDSvWUp9axnvEK67eN95g0RCdgAw8mqcYGsTg
         Y9dY1ifqAbTDdxK8hwLOX8U0T8K1ZHGDZ5X5hSkYtHT2dW5FYnTjbWHoai1LFgs5RSO6
         XlNI+8T+LAc4L0P1WumX5owoYppQ+Hzh3NvFooo5boGhh6lucGPbPBx9fU1bgU5hfafk
         oNWg==
X-Gm-Message-State: APjAAAV1FlHSaITE3ye/WYMp8/LIhmtnYA+5drZsTldF7WNZ32GFtWhA
        JH7G5Bj+N9zvpjgG7qxRpp5yBWSGBnOz5txwbIFA5juUS8hniaJvLfftC3gaWiSLZIyxFYTFK5e
        Cv6GxY7J5ZN13HFFNRNsykJ4xz5ZfDHuCCCWXuFlCpIHi6gcDQuXF4Q==
X-Google-Smtp-Source: APXvYqx5YW1pW1Mct4rd713rohCBaye9EcpPpyX+cGm0MLkA9mrHEreSpxVbD8JoxNl8b02XzbAF8bA=
X-Received: by 2002:a81:5e44:: with SMTP id s65mr45528175ywb.441.1560963602151;
 Wed, 19 Jun 2019 10:00:02 -0700 (PDT)
Date:   Wed, 19 Jun 2019 09:59:49 -0700
In-Reply-To: <20190619165957.235580-1-sdf@google.com>
Message-Id: <20190619165957.235580-2-sdf@google.com>
Mime-Version: 1.0
References: <20190619165957.235580-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v7 1/9] bpf: implement getsockopt and setsockopt hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.

BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.

The buffer memory is pre-allocated (because I don't think there is
a precedent for working with __user memory from bpf). This might be
slow to do for each {s,g}etsockopt call, that's why I've added
__cgroup_bpf_prog_array_is_empty that exits early if there is nothing
attached to a cgroup. Note, however, that there is a race between
__cgroup_bpf_prog_array_is_empty and BPF_PROG_RUN_ARRAY where cgroup
program layout might have changed; this should not be a problem
because in general there is a race between multiple calls to
{s,g}etsocktop and user adding/removing bpf progs from a cgroup.

The return code of the BPF program is handled as follows:
* 0: EPERM
* 1: success, continue with next BPF program in the cgroup chain

v7:
* return only 0 or 1 (Alexei Starovoitov)
* always run all progs (Alexei Starovoitov)
* use optval=0 as kernel bypass in setsockopt (Alexei Starovoitov)
  (decided to use optval=-1 instead, optval=0 might be a valid input)
* call getsockopt hook after kernel handlers (Alexei Starovoitov)

v6:
* rework cgroup chaining; stop as soon as bpf program returns
  0 or 2; see patch with the documentation for the details
* drop Andrii's and Martin's Acked-by (not sure they are comfortable
  with the new state of things)

v5:
* skip copy_to_user() and put_user() when ret == 0 (Martin Lau)

v4:
* don't export bpf_sk_fullsock helper (Martin Lau)
* size != sizeof(__u64) for uapi pointers (Martin Lau)
* offsetof instead of bpf_ctx_range when checking ctx access (Martin Lau)

v3:
* typos in BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY comments (Andrii Nakryiko)
* reverse christmas tree in BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY (Andrii
  Nakryiko)
* use __bpf_md_ptr instead of __u32 for optval{,_end} (Martin Lau)
* use BPF_FIELD_SIZEOF() for consistency (Martin Lau)
* new CG_SOCKOPT_ACCESS macro to wrap repeated parts

v2:
* moved bpf_sockopt_kern fields around to remove a hole (Martin Lau)
* aligned bpf_sockopt_kern->buf to 8 bytes (Martin Lau)
* bpf_prog_array_is_empty instead of bpf_prog_array_length (Martin Lau)
* added [0,2] return code check to verifier (Martin Lau)
* dropped unused buf[64] from the stack (Martin Lau)
* use PTR_TO_SOCKET for bpf_sockopt->sk (Martin Lau)
* dropped bpf_target_off from ctx rewrites (Martin Lau)
* use return code for kernel bypass (Martin Lau & Andrii Nakryiko)

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup.h |  43 +++++
 include/linux/bpf.h        |   2 +
 include/linux/bpf_types.h  |   1 +
 include/linux/filter.h     |  14 ++
 include/uapi/linux/bpf.h   |  14 ++
 kernel/bpf/cgroup.c        | 317 +++++++++++++++++++++++++++++++++++++
 kernel/bpf/core.c          |   9 ++
 kernel/bpf/syscall.c       |  19 +++
 kernel/bpf/verifier.c      |  13 ++
 net/core/filter.c          |   2 +-
 net/socket.c               |  16 ++
 11 files changed, 449 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index b631ee75762d..84bc98ecaa59 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -124,6 +124,14 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 				   loff_t *ppos, void **new_buf,
 				   enum bpf_attach_type type);
 
+int __cgroup_bpf_run_filter_setsockopt(struct sock *sock, int level,
+				       int optname, char __user *optval,
+				       unsigned int optlen);
+int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
+				       int optname, char __user *optval,
+				       int __user *optlen, int max_optlen,
+				       int retval);
+
 static inline enum bpf_cgroup_storage_type cgroup_storage_type(
 	struct bpf_map *map)
 {
@@ -280,6 +288,36 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 	__ret;								       \
 })
 
+#define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen)   \
+({									       \
+	int __ret = 0;							       \
+	if (cgroup_bpf_enabled)						       \
+		__ret = __cgroup_bpf_run_filter_setsockopt(sock, level,	       \
+							   optname, optval,    \
+							   optlen);	       \
+	__ret;								       \
+})
+
+#define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen)			       \
+({									       \
+	int __ret = 0;							       \
+	if (cgroup_bpf_enabled)						       \
+		get_user(__ret, optlen);				       \
+	__ret;								       \
+})
+
+#define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, optlen,   \
+				       max_optlen, retval)		       \
+({									       \
+	int __ret = retval;						       \
+	if (cgroup_bpf_enabled)						       \
+		__ret = __cgroup_bpf_run_filter_getsockopt(sock, level,	       \
+							   optname, optval,    \
+							   optlen, max_optlen, \
+							   retval);	       \
+	__ret;								       \
+})
+
 int cgroup_bpf_prog_attach(const union bpf_attr *attr,
 			   enum bpf_prog_type ptype, struct bpf_prog *prog);
 int cgroup_bpf_prog_detach(const union bpf_attr *attr,
@@ -349,6 +387,11 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_RUN_PROG_SOCK_OPS(sock_ops) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_DEVICE_CGROUP(type,major,minor,access) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_SYSCTL(head,table,write,buf,count,pos,nbuf) ({ 0; })
+#define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, \
+				       optlen, max_optlen, retval) (retval)
+#define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, \
+				       optlen) ({ 0; })
 
 #define for_each_cgroup_storage_type(stype) for (; false; )
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b15fb5fcb741..c9d4625831f2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -521,6 +521,7 @@ struct bpf_prog_array {
 struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags);
 void bpf_prog_array_free(struct bpf_prog_array *progs);
 int bpf_prog_array_length(struct bpf_prog_array *progs);
+bool bpf_prog_array_is_empty(struct bpf_prog_array *array);
 int bpf_prog_array_copy_to_user(struct bpf_prog_array *progs,
 				__u32 __user *prog_ids, u32 cnt);
 
@@ -1055,6 +1056,7 @@ extern const struct bpf_func_proto bpf_spin_unlock_proto;
 extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
+extern const struct bpf_func_proto bpf_tcp_sock_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 5a9975678d6f..eec5aeeeaf92 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -30,6 +30,7 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE, raw_tracepoint_writable)
 #ifdef CONFIG_CGROUP_BPF
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev)
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SYSCTL, cg_sysctl)
+BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCKOPT, cg_sockopt)
 #endif
 #ifdef CONFIG_BPF_LIRC_MODE2
 BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 43b45d6db36d..f4274f6337f0 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1199,4 +1199,18 @@ struct bpf_sysctl_kern {
 	u64 tmp_reg;
 };
 
+struct bpf_sockopt_kern {
+	struct sock	*sk;
+	u8		*optval;
+	u8		*optval_end;
+	s32		level;
+	s32		optname;
+	u32		optlen;
+	s32		retval;
+
+	/* Small on-stack optval buffer to avoid small allocations.
+	 */
+	u8 buf[64] __aligned(8);
+};
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d0a23476f887..67059b4c663f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -170,6 +170,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_FLOW_DISSECTOR,
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
+	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 };
 
 enum bpf_attach_type {
@@ -192,6 +193,8 @@ enum bpf_attach_type {
 	BPF_LIRC_MODE2,
 	BPF_FLOW_DISSECTOR,
 	BPF_CGROUP_SYSCTL,
+	BPF_CGROUP_GETSOCKOPT,
+	BPF_CGROUP_SETSOCKOPT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3539,4 +3542,15 @@ struct bpf_sysctl {
 				 */
 };
 
+struct bpf_sockopt {
+	__bpf_md_ptr(struct bpf_sock *, sk);
+	__bpf_md_ptr(void *, optval);
+	__bpf_md_ptr(void *, optval_end);
+
+	__s32	level;
+	__s32	optname;
+	__u32	optlen;
+	__s32	retval;
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 1b65ab0df457..24e36e66689e 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -18,6 +18,7 @@
 #include <linux/bpf.h>
 #include <linux/bpf-cgroup.h>
 #include <net/sock.h>
+#include <net/bpf_sk_storage.h>
 
 DEFINE_STATIC_KEY_FALSE(cgroup_bpf_enabled_key);
 EXPORT_SYMBOL(cgroup_bpf_enabled_key);
@@ -924,6 +925,185 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sysctl);
 
+static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
+					     enum bpf_attach_type attach_type)
+{
+	struct bpf_prog_array *prog_array;
+	bool empty;
+
+	rcu_read_lock();
+	prog_array = rcu_dereference(cgrp->bpf.effective[attach_type]);
+	empty = bpf_prog_array_is_empty(prog_array);
+	rcu_read_unlock();
+
+	return empty;
+}
+
+static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
+{
+	if (unlikely(max_optlen > PAGE_SIZE))
+		return -EINVAL;
+
+	if (likely(max_optlen <= sizeof(ctx->buf))) {
+		ctx->optval = ctx->buf;
+	} else {
+		ctx->optval = kzalloc(max_optlen, GFP_USER);
+		if (!ctx->optval)
+			return -ENOMEM;
+	}
+
+	ctx->optval_end = ctx->optval + max_optlen;
+	ctx->optlen = max_optlen;
+
+	return 0;
+}
+
+static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
+{
+	if (unlikely(ctx->optval != ctx->buf))
+		kfree(ctx->optval);
+}
+
+int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int level,
+				       int optname, char __user *optval,
+				       unsigned int optlen)
+{
+	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	struct bpf_sockopt_kern ctx = {
+		.sk = sk,
+		.level = level,
+		.optname = optname,
+	};
+	int ret;
+
+	/* Opportunistic check to see whether we have any BPF program
+	 * attached to the hook so we don't waste time allocating
+	 * memory and locking the socket.
+	 */
+	if (!cgroup_bpf_enabled ||
+	    __cgroup_bpf_prog_array_is_empty(cgrp, BPF_CGROUP_SETSOCKOPT))
+		return 0;
+
+	ret = sockopt_alloc_buf(&ctx, optlen);
+	if (ret)
+		return ret;
+
+	if (copy_from_user(ctx.optval, optval, optlen) != 0) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	lock_sock(sk);
+	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[BPF_CGROUP_SETSOCKOPT],
+				 &ctx, BPF_PROG_RUN);
+	release_sock(sk);
+
+	if (!ret) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	if (ctx.optlen == -1)
+		/* optlen set to -1, bypass kernel */
+		ret = 1;
+	else if (ctx.optlen == optlen)
+		/* optlen not changed, run kernel handler */
+		ret = 0;
+	else
+		/* any other value is rejected */
+		ret = -EFAULT;
+
+out:
+	sockopt_free_buf(&ctx);
+	return ret;
+}
+EXPORT_SYMBOL(__cgroup_bpf_run_filter_setsockopt);
+
+int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
+				       int optname, char __user *optval,
+				       int __user *optlen, int max_optlen,
+				       int retval)
+{
+	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	struct bpf_sockopt_kern ctx = {
+		.sk = sk,
+		.level = level,
+		.optname = optname,
+		.retval = retval,
+	};
+	int ret;
+
+	/* Opportunistic check to see whether we have any BPF program
+	 * attached to the hook so we don't waste time allocating
+	 * memory and locking the socket.
+	 */
+	if (!cgroup_bpf_enabled ||
+	    __cgroup_bpf_prog_array_is_empty(cgrp, BPF_CGROUP_GETSOCKOPT))
+		return retval;
+
+	ret = sockopt_alloc_buf(&ctx, max_optlen);
+	if (ret)
+		return ret;
+
+	if (!retval) {
+		/* If kernel getsockopt finished successfully,
+		 * copy whatever was returned to the user back
+		 * into our temporary buffer. Set optlen to the
+		 * one that kernel returned as well to let
+		 * BPF programs inspect the value.
+		 */
+
+		if (get_user(ctx.optlen, optlen)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (ctx.optlen > max_optlen)
+			ctx.optlen = max_optlen;
+
+		if (copy_from_user(ctx.optval, optval, ctx.optlen) != 0) {
+			ret = -EFAULT;
+			goto out;
+		}
+	}
+
+	lock_sock(sk);
+	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[BPF_CGROUP_GETSOCKOPT],
+				 &ctx, BPF_PROG_RUN);
+	release_sock(sk);
+
+	if (!ret) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	if (ctx.optlen > max_optlen) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/* BPF programs only allowed to set retval to 0, not some
+	 * arbitrary value.
+	 */
+	if (ctx.retval != 0 && ctx.retval != retval) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (copy_to_user(optval, ctx.optval, ctx.optlen) ||
+	    put_user(ctx.optlen, optlen)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = ctx.retval;
+
+out:
+	sockopt_free_buf(&ctx);
+	return ret;
+}
+EXPORT_SYMBOL(__cgroup_bpf_run_filter_getsockopt);
+
 static ssize_t sysctl_cpy_dir(const struct ctl_dir *dir, char **bufp,
 			      size_t *lenp)
 {
@@ -1184,3 +1364,140 @@ const struct bpf_verifier_ops cg_sysctl_verifier_ops = {
 
 const struct bpf_prog_ops cg_sysctl_prog_ops = {
 };
+
+static const struct bpf_func_proto *
+cg_sockopt_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_sk_storage_get:
+		return &bpf_sk_storage_get_proto;
+	case BPF_FUNC_sk_storage_delete:
+		return &bpf_sk_storage_delete_proto;
+#ifdef CONFIG_INET
+	case BPF_FUNC_tcp_sock:
+		return &bpf_tcp_sock_proto;
+#endif
+	default:
+		return cgroup_base_func_proto(func_id, prog);
+	}
+}
+
+static bool cg_sockopt_is_valid_access(int off, int size,
+				       enum bpf_access_type type,
+				       const struct bpf_prog *prog,
+				       struct bpf_insn_access_aux *info)
+{
+	const int size_default = sizeof(__u32);
+
+	if (off < 0 || off >= sizeof(struct bpf_sockopt))
+		return false;
+
+	if (off % size != 0)
+		return false;
+
+	if (type == BPF_WRITE) {
+		switch (off) {
+		case offsetof(struct bpf_sockopt, retval):
+			if (size != size_default)
+				return false;
+			return prog->expected_attach_type ==
+				BPF_CGROUP_GETSOCKOPT;
+		case offsetof(struct bpf_sockopt, optlen):
+			return size == size_default;
+		default:
+			return false;
+		}
+	}
+
+	switch (off) {
+	case offsetof(struct bpf_sockopt, sk):
+		if (size != sizeof(__u64))
+			return false;
+		info->reg_type = PTR_TO_SOCKET;
+		break;
+	case offsetof(struct bpf_sockopt, optval):
+		if (size != sizeof(__u64))
+			return false;
+		info->reg_type = PTR_TO_PACKET;
+		break;
+	case offsetof(struct bpf_sockopt, optval_end):
+		if (size != sizeof(__u64))
+			return false;
+		info->reg_type = PTR_TO_PACKET_END;
+		break;
+	case offsetof(struct bpf_sockopt, retval):
+		if (size != size_default)
+			return false;
+		return prog->expected_attach_type == BPF_CGROUP_GETSOCKOPT;
+	default:
+		if (size != size_default)
+			return false;
+		break;
+	}
+	return true;
+}
+
+#define CG_SOCKOPT_ACCESS_FIELD(T, F)					\
+	T(BPF_FIELD_SIZEOF(struct bpf_sockopt_kern, F),			\
+	  si->dst_reg, si->src_reg,					\
+	  offsetof(struct bpf_sockopt_kern, F))
+
+static u32 cg_sockopt_convert_ctx_access(enum bpf_access_type type,
+					 const struct bpf_insn *si,
+					 struct bpf_insn *insn_buf,
+					 struct bpf_prog *prog,
+					 u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+
+	switch (si->off) {
+	case offsetof(struct bpf_sockopt, sk):
+		*insn++ = CG_SOCKOPT_ACCESS_FIELD(BPF_LDX_MEM, sk);
+		break;
+	case offsetof(struct bpf_sockopt, level):
+		*insn++ = CG_SOCKOPT_ACCESS_FIELD(BPF_LDX_MEM, level);
+		break;
+	case offsetof(struct bpf_sockopt, optname):
+		*insn++ = CG_SOCKOPT_ACCESS_FIELD(BPF_LDX_MEM, optname);
+		break;
+	case offsetof(struct bpf_sockopt, optlen):
+		if (type == BPF_WRITE)
+			*insn++ = CG_SOCKOPT_ACCESS_FIELD(BPF_STX_MEM, optlen);
+		else
+			*insn++ = CG_SOCKOPT_ACCESS_FIELD(BPF_LDX_MEM, optlen);
+		break;
+	case offsetof(struct bpf_sockopt, retval):
+		if (type == BPF_WRITE)
+			*insn++ = CG_SOCKOPT_ACCESS_FIELD(BPF_STX_MEM, retval);
+		else
+			*insn++ = CG_SOCKOPT_ACCESS_FIELD(BPF_LDX_MEM, retval);
+		break;
+	case offsetof(struct bpf_sockopt, optval):
+		*insn++ = CG_SOCKOPT_ACCESS_FIELD(BPF_LDX_MEM, optval);
+		break;
+	case offsetof(struct bpf_sockopt, optval_end):
+		*insn++ = CG_SOCKOPT_ACCESS_FIELD(BPF_LDX_MEM, optval_end);
+		break;
+	}
+
+	return insn - insn_buf;
+}
+
+static int cg_sockopt_get_prologue(struct bpf_insn *insn_buf,
+				   bool direct_write,
+				   const struct bpf_prog *prog)
+{
+	/* Nothing to do for sockopt argument. The data is kzalloc'ated.
+	 */
+	return 0;
+}
+
+const struct bpf_verifier_ops cg_sockopt_verifier_ops = {
+	.get_func_proto		= cg_sockopt_func_proto,
+	.is_valid_access	= cg_sockopt_is_valid_access,
+	.convert_ctx_access	= cg_sockopt_convert_ctx_access,
+	.gen_prologue		= cg_sockopt_get_prologue,
+};
+
+const struct bpf_prog_ops cg_sockopt_prog_ops = {
+};
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 33fb292f2e30..e9152ebd66bc 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1813,6 +1813,15 @@ int bpf_prog_array_length(struct bpf_prog_array *array)
 	return cnt;
 }
 
+bool bpf_prog_array_is_empty(struct bpf_prog_array *array)
+{
+	struct bpf_prog_array_item *item;
+
+	for (item = array->items; item->prog; item++)
+		if (item->prog != &dummy_bpf_prog.prog)
+			return false;
+	return true;
+}
 
 static bool bpf_prog_array_copy_core(struct bpf_prog_array *array,
 				     u32 *prog_ids,
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4c53cbd3329d..4ad2b5f1905f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1596,6 +1596,14 @@ bpf_prog_load_check_attach_type(enum bpf_prog_type prog_type,
 		default:
 			return -EINVAL;
 		}
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+		switch (expected_attach_type) {
+		case BPF_CGROUP_SETSOCKOPT:
+		case BPF_CGROUP_GETSOCKOPT:
+			return 0;
+		default:
+			return -EINVAL;
+		}
 	default:
 		return 0;
 	}
@@ -1846,6 +1854,7 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 	switch (prog->type) {
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 		return attach_type == prog->expected_attach_type ? 0 : -EINVAL;
 	case BPF_PROG_TYPE_CGROUP_SKB:
 		return prog->enforce_expected_attach_type &&
@@ -1916,6 +1925,10 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_CGROUP_SYSCTL:
 		ptype = BPF_PROG_TYPE_CGROUP_SYSCTL;
 		break;
+	case BPF_CGROUP_GETSOCKOPT:
+	case BPF_CGROUP_SETSOCKOPT:
+		ptype = BPF_PROG_TYPE_CGROUP_SOCKOPT;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1997,6 +2010,10 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_CGROUP_SYSCTL:
 		ptype = BPF_PROG_TYPE_CGROUP_SYSCTL;
 		break;
+	case BPF_CGROUP_GETSOCKOPT:
+	case BPF_CGROUP_SETSOCKOPT:
+		ptype = BPF_PROG_TYPE_CGROUP_SOCKOPT;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2031,6 +2048,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_SOCK_OPS:
 	case BPF_CGROUP_DEVICE:
 	case BPF_CGROUP_SYSCTL:
+	case BPF_CGROUP_GETSOCKOPT:
+	case BPF_CGROUP_SETSOCKOPT:
 		break;
 	case BPF_LIRC_MODE2:
 		return lirc_prog_query(attr, uattr);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8d1786357a09..95ce6cea2e23 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1720,6 +1720,18 @@ static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
 
 		env->seen_direct_write = true;
 		return true;
+
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+		if (t == BPF_WRITE) {
+			if (env->prog->expected_attach_type ==
+			    BPF_CGROUP_GETSOCKOPT) {
+				env->seen_direct_write = true;
+				return true;
+			}
+			return false;
+		}
+		return true;
+
 	default:
 		return false;
 	}
@@ -5540,6 +5552,7 @@ static int check_return_code(struct bpf_verifier_env *env)
 	case BPF_PROG_TYPE_SOCK_OPS:
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 		break;
 	default:
 		return 0;
diff --git a/net/core/filter.c b/net/core/filter.c
index 8c18f2781afa..e2ad8144cf6e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5636,7 +5636,7 @@ BPF_CALL_1(bpf_tcp_sock, struct sock *, sk)
 	return (unsigned long)NULL;
 }
 
-static const struct bpf_func_proto bpf_tcp_sock_proto = {
+const struct bpf_func_proto bpf_tcp_sock_proto = {
 	.func		= bpf_tcp_sock,
 	.gpl_only	= false,
 	.ret_type	= RET_PTR_TO_TCP_SOCK_OR_NULL,
diff --git a/net/socket.c b/net/socket.c
index 72372dc5dd70..79eb12016685 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2069,6 +2069,15 @@ static int __sys_setsockopt(int fd, int level, int optname,
 		if (err)
 			goto out_put;
 
+		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, level, optname,
+						     optval, optlen);
+		if (err < 0) {
+			goto out_put;
+		} else if (err > 0) {
+			err = 0;
+			goto out_put;
+		}
+
 		if (level == SOL_SOCKET)
 			err =
 			    sock_setsockopt(sock, level, optname, optval,
@@ -2099,6 +2108,7 @@ static int __sys_getsockopt(int fd, int level, int optname,
 {
 	int err, fput_needed;
 	struct socket *sock;
+	int max_optlen;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock != NULL) {
@@ -2106,6 +2116,8 @@ static int __sys_getsockopt(int fd, int level, int optname,
 		if (err)
 			goto out_put;
 
+		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
+
 		if (level == SOL_SOCKET)
 			err =
 			    sock_getsockopt(sock, level, optname, optval,
@@ -2114,6 +2126,10 @@ static int __sys_getsockopt(int fd, int level, int optname,
 			err =
 			    sock->ops->getsockopt(sock, level, optname, optval,
 						  optlen);
+
+		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
+						     optval, optlen,
+						     max_optlen, err);
 out_put:
 		fput_light(sock->file, fput_needed);
 	}
-- 
2.22.0.410.gd8fdbe21b5-goog

