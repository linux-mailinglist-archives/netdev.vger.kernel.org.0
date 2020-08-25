Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F76C251FE0
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 21:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgHYTW7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Aug 2020 15:22:59 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23162 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726090AbgHYTW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 15:22:58 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-VMol4-ZeNV28MIj4i6Zz4w-1; Tue, 25 Aug 2020 15:21:46 -0400
X-MC-Unique: VMol4-ZeNV28MIj4i6Zz4w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4766751AE;
        Tue, 25 Aug 2020 19:21:44 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9DD919C4F;
        Tue, 25 Aug 2020 19:21:40 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH v12 bpf-next 03/14] bpf: Move btf_resolve_size into __btf_resolve_size
Date:   Tue, 25 Aug 2020 21:21:13 +0200
Message-Id: <20200825192124.710397-4-jolsa@kernel.org>
In-Reply-To: <20200825192124.710397-1-jolsa@kernel.org>
References: <20200825192124.710397-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moving btf_resolve_size into __btf_resolve_size and
keeping btf_resolve_size public with just first 3
arguments, because the rest of the arguments are not
used by outside callers.

Following changes are adding more arguments, which
are not useful to outside callers. They will be added
to the __btf_resolve_size function.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/btf.h         |  3 +--
 kernel/bpf/bpf_struct_ops.c |  6 ++----
 kernel/bpf/btf.c            | 21 ++++++++++++++-------
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 8b81fbb4497c..a9af5e7a7ece 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -64,8 +64,7 @@ const struct btf_type *btf_type_resolve_func_ptr(const struct btf *btf,
 						 u32 id, u32 *res_id);
 const struct btf_type *
 btf_resolve_size(const struct btf *btf, const struct btf_type *type,
-		 u32 *type_size, const struct btf_type **elem_type,
-		 u32 *total_nelems);
+		 u32 *type_size);
 
 #define for_each_member(i, struct_type, member)			\
 	for (i = 0, member = btf_type_member(struct_type);	\
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 969c5d47f81f..4c3b543bb33b 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -298,8 +298,7 @@ static int check_zero_holes(const struct btf_type *t, void *data)
 			return -EINVAL;
 
 		mtype = btf_type_by_id(btf_vmlinux, member->type);
-		mtype = btf_resolve_size(btf_vmlinux, mtype, &msize,
-					 NULL, NULL);
+		mtype = btf_resolve_size(btf_vmlinux, mtype, &msize);
 		if (IS_ERR(mtype))
 			return PTR_ERR(mtype);
 		prev_mend = moff + msize;
@@ -396,8 +395,7 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 			u32 msize;
 
 			mtype = btf_type_by_id(btf_vmlinux, member->type);
-			mtype = btf_resolve_size(btf_vmlinux, mtype, &msize,
-						 NULL, NULL);
+			mtype = btf_resolve_size(btf_vmlinux, mtype, &msize);
 			if (IS_ERR(mtype)) {
 				err = PTR_ERR(mtype);
 				goto reset_unlock;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 91afdd4c82e3..6ed4ecc60381 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1088,10 +1088,10 @@ static const struct resolve_vertex *env_stack_peak(struct btf_verifier_env *env)
  * *elem_type: same as return type ("struct X")
  * *total_nelems: 1
  */
-const struct btf_type *
-btf_resolve_size(const struct btf *btf, const struct btf_type *type,
-		 u32 *type_size, const struct btf_type **elem_type,
-		 u32 *total_nelems)
+static const struct btf_type *
+__btf_resolve_size(const struct btf *btf, const struct btf_type *type,
+		   u32 *type_size, const struct btf_type **elem_type,
+		   u32 *total_nelems)
 {
 	const struct btf_type *array_type = NULL;
 	const struct btf_array *array;
@@ -1150,6 +1150,13 @@ btf_resolve_size(const struct btf *btf, const struct btf_type *type,
 	return array_type ? : type;
 }
 
+const struct btf_type *
+btf_resolve_size(const struct btf *btf, const struct btf_type *type,
+		 u32 *type_size)
+{
+	return __btf_resolve_size(btf, type, type_size, NULL, NULL);
+}
+
 /* The input param "type_id" must point to a needs_resolve type */
 static const struct btf_type *btf_type_id_resolve(const struct btf *btf,
 						  u32 *type_id)
@@ -3976,8 +3983,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		mtype = btf_type_by_id(btf_vmlinux, member->type);
 		mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
 
-		mtype = btf_resolve_size(btf_vmlinux, mtype, &msize,
-					 &elem_type, &total_nelems);
+		mtype = __btf_resolve_size(btf_vmlinux, mtype, &msize,
+					   &elem_type, &total_nelems);
 		if (IS_ERR(mtype)) {
 			bpf_log(log, "field %s doesn't have size\n", mname);
 			return -EFAULT;
@@ -3991,7 +3998,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		if (btf_type_is_array(mtype)) {
 			u32 elem_idx;
 
-			/* btf_resolve_size() above helps to
+			/* __btf_resolve_size() above helps to
 			 * linearize a multi-dimensional array.
 			 *
 			 * The logic here is treating an array
-- 
2.25.4

