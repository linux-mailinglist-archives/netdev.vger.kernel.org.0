Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED7119AA7A
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732407AbgDALJX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Apr 2020 07:09:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59305 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732234AbgDALJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 07:09:22 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-0EkIty7hMGeNjH1wd9f-JQ-1; Wed, 01 Apr 2020 07:09:18 -0400
X-MC-Unique: 0EkIty7hMGeNjH1wd9f-JQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2887413FB;
        Wed,  1 Apr 2020 11:09:16 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F5C11001B09;
        Wed,  1 Apr 2020 11:09:12 +0000 (UTC)
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
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/3] bpf: Add support to check if BTF object is nested in another object
Date:   Wed,  1 Apr 2020 13:09:05 +0200
Message-Id: <20200401110907.2669564-2-jolsa@kernel.org>
In-Reply-To: <20200401110907.2669564-1-jolsa@kernel.org>
References: <20200401110907.2669564-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
 kernel/bpf/verifier.c | 18 +++++++++--
 3 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fd2b2322412d..d3bad7ee60c6 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1196,6 +1196,9 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
 		      u32 *next_btf_id);
+int btf_struct_address(struct bpf_verifier_log *log,
+		     const struct btf_type *t,
+		     u32 off, u32 exp_id);
 int btf_resolve_helper_id(struct bpf_verifier_log *log,
 			  const struct bpf_func_proto *fn, int);
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index d65c6912bdaf..9aafffa57d8b 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4002,6 +4002,75 @@ int btf_struct_access(struct bpf_verifier_log *log,
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
index 04c6630cc18f..6eb88bef4379 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3103,6 +3103,18 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	return 0;
 }
 
+static void check_ptr_in_btf(struct bpf_verifier_env *env,
+			     struct bpf_reg_state *reg,
+			     u32 exp_id)
+{
+	const struct btf_type *t = btf_type_by_id(btf_vmlinux, reg->btf_id);
+
+	if (!btf_struct_address(&env->log, t, reg->off, exp_id)) {
+		reg->btf_id = exp_id;
+		reg->off = 0;
+	}
+}
+
 /* check whether memory at (regno + off) is accessible for t = (read | write)
  * if t==write, value_regno is a register which value is stored into memory
  * if t==read, value_regno is a register which will receive the value from memory
@@ -3696,10 +3708,12 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 		expected_type = PTR_TO_BTF_ID;
 		if (type != expected_type)
 			goto err_type;
+		if (reg->off)
+			check_ptr_in_btf(env, reg, meta->btf_id);
 		if (reg->btf_id != meta->btf_id) {
-			verbose(env, "Helper has type %s got %s in R%d\n",
+			verbose(env, "Helper has type %s got %s in R%d, off %d\n",
 				kernel_type_name(meta->btf_id),
-				kernel_type_name(reg->btf_id), regno);
+				kernel_type_name(reg->btf_id), regno, reg->off);
 
 			return -EACCES;
 		}
-- 
2.25.2

