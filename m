Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D711C71B8
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 15:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgEFNaU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 May 2020 09:30:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37191 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728483AbgEFNaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 09:30:20 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-w_mcWS0RPaiftR-2fN3aAQ-1; Wed, 06 May 2020 09:30:11 -0400
X-MC-Unique: w_mcWS0RPaiftR-2fN3aAQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65FCC460;
        Wed,  6 May 2020 13:30:09 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10A3F64430;
        Wed,  6 May 2020 13:30:02 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4/9] bpf: Allow nested BTF object to be refferenced by BTF object + offset
Date:   Wed,  6 May 2020 15:29:41 +0200
Message-Id: <20200506132946.2164578-5-jolsa@kernel.org>
In-Reply-To: <20200506132946.2164578-1-jolsa@kernel.org>
References: <20200506132946.2164578-1-jolsa@kernel.org>
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
and offset as arguments and checks wether object A is nested
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
 include/linux/bpf.h   |  3 ++
 kernel/bpf/btf.c      | 69 +++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c | 32 +++++++++++++-------
 3 files changed, 94 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1262ec460ab3..bc589cdd8c34 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1213,6 +1213,9 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
 		      u32 *next_btf_id);
+int btf_struct_address(struct bpf_verifier_log *log,
+		     const struct btf_type *t,
+		     u32 off, u32 exp_id);
 int btf_resolve_helper_id(struct bpf_verifier_log *log,
 			  const struct bpf_func_proto *fn, int);
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index a2cfba89a8e1..07f22469acab 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4004,6 +4004,75 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	return -EINVAL;
 }
 
+int btf_struct_address(struct bpf_verifier_log *log,
+		       const struct btf_type *t,
+		       u32 off, u32 exp_id)
+{
+	u32 i, moff, mtrue_end, msize = 0;
+	const struct btf_member *member;
+	const struct btf_type *mtype;
+	const char *tname, *mname;
+
+again:
+	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
+	if (!btf_type_is_struct(t)) {
+		bpf_log(log, "Type '%s' is not a struct\n", tname);
+		return -EINVAL;
+	}
+
+	if (off > t->size) {
+		bpf_log(log, "address beyond struct %s at off %u size %u\n",
+			tname, off, t->size);
+		return -EACCES;
+	}
+
+	for_each_member(i, t, member) {
+		/* offset of the field in bytes */
+		moff = btf_member_bit_offset(t, member) / 8;
+		if (off < moff)
+			/* won't find anything, field is already too far */
+			break;
+
+		/* we found the member */
+		if (off == moff && member->type == exp_id)
+			return 0;
+
+		/* type of the field */
+		mtype = btf_type_by_id(btf_vmlinux, member->type);
+		mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
+
+		mtype = btf_resolve_size(btf_vmlinux, mtype, &msize,
+					 NULL, NULL);
+		if (IS_ERR(mtype)) {
+			bpf_log(log, "field %s doesn't have size\n", mname);
+			return -EFAULT;
+		}
+
+		mtrue_end = moff + msize;
+		if (off >= mtrue_end)
+			/* no overlap with member, keep iterating */
+			continue;
+
+		/* the 'off' we're looking for is either equal to start
+		 * of this field or inside of this struct
+		 */
+		if (btf_type_is_struct(mtype)) {
+			/* our field must be inside that union or struct */
+			t = mtype;
+
+			/* adjust offset we're looking for */
+			off -= moff;
+			goto again;
+		}
+
+		bpf_log(log, "struct %s doesn't have struct field at offset %d\n", tname, off);
+		return -EACCES;
+	}
+
+	bpf_log(log, "struct %s doesn't have field at offset %d\n", tname, off);
+	return -EACCES;
+}
+
 static int __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
 				   int arg)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 70ad009577f8..b988df5ada20 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3665,6 +3665,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 {
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
 	enum bpf_reg_type expected_type, type = reg->type;
+	const struct btf_type *btf_type;
 	int err = 0;
 
 	if (arg_type == ARG_DONTCARE)
@@ -3743,17 +3744,28 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 		expected_type = PTR_TO_BTF_ID;
 		if (type != expected_type)
 			goto err_type;
-		if (reg->btf_id != meta->btf_id) {
-			verbose(env, "Helper has type %s got %s in R%d\n",
-				kernel_type_name(meta->btf_id),
-				kernel_type_name(reg->btf_id), regno);
+		if (reg->off) {
+			btf_type = btf_type_by_id(btf_vmlinux, reg->btf_id);
+			if (btf_struct_address(&env->log, btf_type, reg->off, meta->btf_id)) {
+				verbose(env, "Helper has type %s got %s in R%d, off %d\n",
+					kernel_type_name(meta->btf_id),
+					kernel_type_name(reg->btf_id), regno, reg->off);
 
-			return -EACCES;
-		}
-		if (!tnum_is_const(reg->var_off) || reg->var_off.value || reg->off) {
-			verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
-				regno);
-			return -EACCES;
+				return -EACCES;
+			}
+		} else {
+			if (reg->btf_id != meta->btf_id) {
+				verbose(env, "Helper has type %s got %s in R%d\n",
+					kernel_type_name(meta->btf_id),
+					kernel_type_name(reg->btf_id), regno);
+
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

