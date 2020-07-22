Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FE422A122
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732945AbgGVVNC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Jul 2020 17:13:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24306 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732896AbgGVVNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 17:13:01 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-xfrSFg_hPvCrTprMBR3CEQ-1; Wed, 22 Jul 2020 17:12:52 -0400
X-MC-Unique: xfrSFg_hPvCrTprMBR3CEQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75EA5800469;
        Wed, 22 Jul 2020 21:12:49 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C20719C4F;
        Wed, 22 Jul 2020 21:12:46 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v8 bpf-next 06/13] bpf: Factor btf_struct_access function
Date:   Wed, 22 Jul 2020 23:12:16 +0200
Message-Id: <20200722211223.1055107-7-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-1-jolsa@kernel.org>
References: <20200722211223.1055107-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding btf_struct_walk function that walks through the
struct type + given offset and returns following values:

  enum walk_return {
       /* < 0 error */
       walk_scalar = 0,
       walk_ptr,
       walk_struct,
  };

walk_scalar - when SCALAR_VALUE is found
walk_ptr    - when pointer value is found, its ID is stored
              in 'rid' output param
walk_struct - when nested struct object is found, its ID is stored
              in 'rid' output param

It will be used in following patches to get all nested
struct objects for given type and offset.

The btf_struct_access now calls btf_struct_walk function,
as long as it gets nested structs as return value.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/btf.c | 73 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 60 insertions(+), 13 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 841be6c49f11..1ab5fd5bf992 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3873,16 +3873,22 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	return true;
 }
 
-int btf_struct_access(struct bpf_verifier_log *log,
-		      const struct btf_type *t, int off, int size,
-		      enum bpf_access_type atype,
-		      u32 *next_btf_id)
+enum walk_return {
+	/* < 0 error */
+	walk_scalar = 0,
+	walk_ptr,
+	walk_struct,
+};
+
+static int btf_struct_walk(struct bpf_verifier_log *log,
+			   const struct btf_type *t, int off, int size,
+			   u32 *rid)
 {
 	u32 i, moff, mtrue_end, msize = 0, total_nelems = 0;
 	const struct btf_type *mtype, *elem_type = NULL;
 	const struct btf_member *member;
 	const char *tname, *mname;
-	u32 vlen;
+	u32 vlen, elem_id, mid;
 
 again:
 	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
@@ -3924,8 +3930,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			goto error;
 
 		off = (off - moff) % elem_type->size;
-		return btf_struct_access(log, elem_type, off, size, atype,
-					 next_btf_id);
+		return btf_struct_walk(log, elem_type, off, size, rid);
 
 error:
 		bpf_log(log, "access beyond struct %s at off %u size %u\n",
@@ -3954,7 +3959,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			 */
 			if (off <= moff &&
 			    BITS_ROUNDUP_BYTES(end_bit) <= off + size)
-				return SCALAR_VALUE;
+				return walk_scalar;
 
 			/* off may be accessing a following member
 			 *
@@ -3976,11 +3981,13 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			break;
 
 		/* type of the field */
+		mid = member->type;
 		mtype = btf_type_by_id(btf_vmlinux, member->type);
 		mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
 
 		mtype = __btf_resolve_size(btf_vmlinux, mtype, &msize,
-					   &elem_type, NULL, &total_nelems, NULL);
+					   &elem_type, &elem_id, &total_nelems,
+					   &mid);
 		if (IS_ERR(mtype)) {
 			bpf_log(log, "field %s doesn't have size\n", mname);
 			return -EFAULT;
@@ -4042,6 +4049,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			elem_idx = (off - moff) / msize;
 			moff += elem_idx * msize;
 			mtype = elem_type;
+			mid = elem_id;
 		}
 
 		/* the 'off' we're looking for is either equal to start
@@ -4051,6 +4059,12 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			/* our field must be inside that union or struct */
 			t = mtype;
 
+			/* return if the offset matches the member offset */
+			if (off == moff) {
+				*rid = mid;
+				return walk_struct;
+			}
+
 			/* adjust offset we're looking for */
 			off -= moff;
 			goto again;
@@ -4066,11 +4080,10 @@ int btf_struct_access(struct bpf_verifier_log *log,
 					mname, moff, tname, off, size);
 				return -EACCES;
 			}
-
 			stype = btf_type_skip_modifiers(btf_vmlinux, mtype->type, &id);
 			if (btf_type_is_struct(stype)) {
-				*next_btf_id = id;
-				return PTR_TO_BTF_ID;
+				*rid = id;
+				return walk_ptr;
 			}
 		}
 
@@ -4087,12 +4100,46 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			return -EACCES;
 		}
 
-		return SCALAR_VALUE;
+		return walk_scalar;
 	}
 	bpf_log(log, "struct %s doesn't have field at offset %d\n", tname, off);
 	return -EINVAL;
 }
 
+int btf_struct_access(struct bpf_verifier_log *log,
+		      const struct btf_type *t, int off, int size,
+		      enum bpf_access_type atype __maybe_unused,
+		      u32 *next_btf_id)
+{
+	int err;
+	u32 id;
+
+	do {
+		err = btf_struct_walk(log, t, off, size, &id);
+		if (err < 0)
+			return err;
+
+		/* We found the pointer or scalar on t+off,
+		 * we're done.
+		 */
+		if (err == walk_ptr) {
+			*next_btf_id = id;
+			return PTR_TO_BTF_ID;
+		}
+		if (err == walk_scalar)
+			return SCALAR_VALUE;
+
+		/* We found nested struct, so continue the search
+		 * by diving in it. At this point the offset is
+		 * aligned with the new type, so set it to 0.
+		 */
+		t = btf_type_by_id(btf_vmlinux, id);
+		off = 0;
+	} while (t);
+
+	return -EINVAL;
+}
+
 int btf_resolve_helper_id(struct bpf_verifier_log *log,
 			  const struct bpf_func_proto *fn, int arg)
 {
-- 
2.25.4

