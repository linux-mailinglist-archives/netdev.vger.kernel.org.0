Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C6320A817
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436617AbgFYWNw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 18:13:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39552 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436601AbgFYWNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 18:13:51 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-cGODzpJzOOeMo_KVIzOkhA-1; Thu, 25 Jun 2020 18:13:43 -0400
X-MC-Unique: cGODzpJzOOeMo_KVIzOkhA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18EB0107B477;
        Thu, 25 Jun 2020 22:13:41 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAC4F79303;
        Thu, 25 Jun 2020 22:13:37 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v4 bpf-next 07/14] bpf: Allow nested BTF object to be refferenced by BTF object + offset
Date:   Fri, 26 Jun 2020 00:12:57 +0200
Message-Id: <20200625221304.2817194-8-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-1-jolsa@kernel.org>
References: <20200625221304.2817194-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding btf_struct_address function that takes 2 BTF objects
and offset as arguments and checks whether object A is nested
in object B on given offset.

This function will be used when checking the helper function
PTR_TO_BTF_ID arguments. If the argument has an offset value,
the btf_struct_address will check if the final address is
the expected BTF ID.

This way we can access nested BTF objects under PTR_TO_BTF_ID
pointer type and pass them to helpers, while they still point
to valid kernel BTF objects.

Using btf_struct_access to implement new btf_struct_address
function, because it already walks down the given BTF object.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h   |  3 ++
 kernel/bpf/btf.c      | 67 ++++++++++++++++++++++++++++++++++++++-----
 kernel/bpf/verifier.c | 37 +++++++++++++++---------
 3 files changed, 87 insertions(+), 20 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3d2ade703a35..c0fd1f3037dd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1300,6 +1300,9 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
 		      u32 *next_btf_id);
+int btf_struct_address(struct bpf_verifier_log *log,
+		     const struct btf_type *t,
+		     u32 off, u32 id);
 int btf_resolve_helper_id(struct bpf_verifier_log *log,
 			  const struct bpf_func_proto *fn, int);
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 701a2cb5dfb2..f87e5f1dc64d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3863,10 +3863,22 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	return true;
 }
 
-int btf_struct_access(struct bpf_verifier_log *log,
-		      const struct btf_type *t, int off, int size,
-		      enum bpf_access_type atype,
-		      u32 *next_btf_id)
+enum access_op {
+	ACCESS_NEXT,
+	ACCESS_EXPECT,
+};
+
+struct access_data {
+	enum access_op op;
+	union {
+		u32 *next_btf_id;
+		const struct btf_type *exp_type;
+	};
+};
+
+static int struct_access(struct bpf_verifier_log *log,
+			 const struct btf_type *t, int off, int size,
+			 struct access_data *data)
 {
 	u32 i, moff, mtrue_end, msize = 0, total_nelems = 0;
 	const struct btf_type *mtype, *elem_type = NULL;
@@ -3914,8 +3926,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			goto error;
 
 		off = (off - moff) % elem_type->size;
-		return btf_struct_access(log, elem_type, off, size, atype,
-					 next_btf_id);
+		return struct_access(log, elem_type, off, size, data);
 
 error:
 		bpf_log(log, "access beyond struct %s at off %u size %u\n",
@@ -4043,9 +4054,21 @@ int btf_struct_access(struct bpf_verifier_log *log,
 
 			/* adjust offset we're looking for */
 			off -= moff;
+
+			/* We are nexting into another struct,
+			 * check if we are crossing expected ID.
+			 */
+			if (data->op == ACCESS_EXPECT && !off && t == data->exp_type)
+				return 0;
 			goto again;
 		}
 
+		/* We are interested only in structs for expected ID,
+		 * bail out.
+		 */
+		if (data->op == ACCESS_EXPECT)
+			return -EINVAL;
+
 		if (btf_type_is_ptr(mtype)) {
 			const struct btf_type *stype;
 			u32 id;
@@ -4059,7 +4082,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 
 			stype = btf_type_skip_modifiers(btf_vmlinux, mtype->type, &id);
 			if (btf_type_is_struct(stype)) {
-				*next_btf_id = id;
+				*data->next_btf_id = id;
 				return PTR_TO_BTF_ID;
 			}
 		}
@@ -4083,6 +4106,36 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	return -EINVAL;
 }
 
+int btf_struct_access(struct bpf_verifier_log *log,
+		      const struct btf_type *t, int off, int size,
+		      enum bpf_access_type atype __maybe_unused,
+		      u32 *next_btf_id)
+{
+	struct access_data data = {
+		.op = ACCESS_NEXT,
+		.next_btf_id = next_btf_id,
+	};
+
+	return struct_access(log, t, off, size, &data);
+}
+
+int btf_struct_address(struct bpf_verifier_log *log,
+		       const struct btf_type *t,
+		       u32 off, u32 id)
+{
+	const struct btf_type *type;
+	struct access_data data = {
+		.op = ACCESS_EXPECT,
+	};
+
+	type = btf_type_by_id(btf_vmlinux, id);
+	if (!type)
+		return -EINVAL;
+
+	data.exp_type = type;
+	return struct_access(log, t, off, 1, &data);
+}
+
 int btf_resolve_helper_id(struct bpf_verifier_log *log,
 			  const struct bpf_func_proto *fn, int arg)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7de98906ddf4..da7351184295 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3808,6 +3808,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
 	enum bpf_reg_type expected_type, type = reg->type;
 	enum bpf_arg_type arg_type = fn->arg_type[arg];
+	const struct btf_type *btf_type;
 	int err = 0;
 
 	if (arg_type == ARG_DONTCARE)
@@ -3887,24 +3888,34 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		expected_type = PTR_TO_BTF_ID;
 		if (type != expected_type)
 			goto err_type;
-		if (!fn->check_btf_id) {
-			if (reg->btf_id != meta->btf_id) {
-				verbose(env, "Helper has type %s got %s in R%d\n",
+		if (reg->off) {
+			btf_type = btf_type_by_id(btf_vmlinux, reg->btf_id);
+			if (btf_struct_address(&env->log, btf_type, reg->off, meta->btf_id)) {
+				verbose(env, "Helper has type %s got %s in R%d, off %d\n",
 					kernel_type_name(meta->btf_id),
+					kernel_type_name(reg->btf_id), regno, reg->off);
+				return -EACCES;
+			}
+		} else {
+			if (!fn->check_btf_id) {
+				if (reg->btf_id != meta->btf_id) {
+					verbose(env, "Helper has type %s got %s in R%d\n",
+						kernel_type_name(meta->btf_id),
+						kernel_type_name(reg->btf_id), regno);
+
+					return -EACCES;
+				}
+			} else if (!fn->check_btf_id(reg->btf_id, arg)) {
+				verbose(env, "Helper does not support %s in R%d\n",
 					kernel_type_name(reg->btf_id), regno);
 
 				return -EACCES;
 			}
-		} else if (!fn->check_btf_id(reg->btf_id, arg)) {
-			verbose(env, "Helper does not support %s in R%d\n",
-				kernel_type_name(reg->btf_id), regno);
-
-			return -EACCES;
-		}
-		if (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off) {
-			verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
-				regno);
-			return -EACCES;
+			if (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off) {
+				verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
+					regno);
+				return -EACCES;
+			}
 		}
 	} else if (arg_type == ARG_PTR_TO_SPIN_LOCK) {
 		if (meta->func_id == BPF_FUNC_spin_lock) {
-- 
2.25.4

