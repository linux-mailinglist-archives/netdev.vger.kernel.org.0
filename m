Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF3F1FAD79
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgFPKGE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Jun 2020 06:06:04 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21457 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726805AbgFPKGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:06:03 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-tskNkK2nNAqO-yujiWa7jw-1; Tue, 16 Jun 2020 06:05:59 -0400
X-MC-Unique: tskNkK2nNAqO-yujiWa7jw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD3888A636E;
        Tue, 16 Jun 2020 10:05:53 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A15FB5D9D5;
        Tue, 16 Jun 2020 10:05:49 +0000 (UTC)
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
Subject: [PATCH 07/11] bpf: Allow nested BTF object to be refferenced by BTF object + offset
Date:   Tue, 16 Jun 2020 12:05:08 +0200
Message-Id: <20200616100512.2168860-8-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-1-jolsa@kernel.org>
References: <20200616100512.2168860-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

This function is be used when checking the helper function
PTR_TO_BTF_ID arguments. If the argument has an offset value,
the btf_struct_address will check if the final address is
the expected BTF ID.

This way we can access nested BTF objects under PTR_TO_BTF_ID
pointer type and pass them to helpers, while they still point
to valid kernel BTF objects.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h   |  3 +++
 kernel/bpf/btf.c      | 63 ++++++++++++++++++++++++++++++++++++++-----
 kernel/bpf/verifier.c | 32 ++++++++++++++--------
 3 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b7d3b5f3dc09..e98c113a5d27 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1283,6 +1283,9 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct btf_type *t, int off, int size,
 		      u32 *next_btf_id);
+int btf_struct_address(struct bpf_verifier_log *log,
+		     const struct btf_type *t,
+		     u32 off, u32 id);
 int btf_resolve_helper_id(struct bpf_verifier_log *log,
 			  const struct bpf_func_proto *fn, int);
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 304369a4c2e2..6924180a19c4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3829,9 +3829,22 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	return true;
 }
 
-int btf_struct_access(struct bpf_verifier_log *log,
-		      const struct btf_type *t, int off, int size,
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
@@ -3879,8 +3892,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			goto error;
 
 		off = (off - moff) % elem_type->size;
-		return btf_struct_access(log, elem_type, off, size,
-					 next_btf_id);
+		return struct_access(log, elem_type, off, size, data);
 
 error:
 		bpf_log(log, "access beyond struct %s at off %u size %u\n",
@@ -4008,9 +4020,21 @@ int btf_struct_access(struct bpf_verifier_log *log,
 
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
@@ -4024,7 +4048,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 
 			stype = btf_type_skip_modifiers(btf_vmlinux, mtype->type, &id);
 			if (btf_type_is_struct(stype)) {
-				*next_btf_id = id;
+				*data->next_btf_id = id;
 				return PTR_TO_BTF_ID;
 			}
 		}
@@ -4048,6 +4072,33 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	return -EINVAL;
 }
 
+int btf_struct_access(struct bpf_verifier_log *log,
+		      const struct btf_type *t, int off, int size,
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
+	struct access_data data = { .op = ACCESS_EXPECT };
+	const struct btf_type *type;
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
index b553e4523bd3..bee3da2cd945 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3741,6 +3741,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 {
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
 	enum bpf_reg_type expected_type, type = reg->type;
+	const struct btf_type *btf_type;
 	int err = 0;
 
 	if (arg_type == ARG_DONTCARE)
@@ -3820,17 +3821,26 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 		expected_type = PTR_TO_BTF_ID;
 		if (type != expected_type)
 			goto err_type;
-		if (reg->btf_id != meta->btf_id) {
-			verbose(env, "Helper has type %s got %s in R%d\n",
-				kernel_type_name(meta->btf_id),
-				kernel_type_name(reg->btf_id), regno);
-
-			return -EACCES;
-		}
-		if (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off) {
-			verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
-				regno);
-			return -EACCES;
+		if (reg->off) {
+			btf_type = btf_type_by_id(btf_vmlinux, reg->btf_id);
+			if (btf_struct_address(&env->log, btf_type, reg->off, meta->btf_id)) {
+				verbose(env, "Helper has type %s got %s in R%d, off %d\n",
+					kernel_type_name(meta->btf_id),
+					kernel_type_name(reg->btf_id), regno, reg->off);
+				return -EACCES;
+			}
+		} else {
+			if (reg->btf_id != meta->btf_id) {
+				verbose(env, "Helper has type %s got %s in R%d\n",
+					kernel_type_name(meta->btf_id),
+					kernel_type_name(reg->btf_id), regno);
+				return -EACCES;
+			}
+			if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
+				verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
+					regno);
+				return -EACCES;
+			}
 		}
 	} else if (arg_type == ARG_PTR_TO_SPIN_LOCK) {
 		if (meta->func_id == BPF_FUNC_spin_lock) {
-- 
2.25.4

