Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9722353A4
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 19:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgHAREB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 1 Aug 2020 13:04:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41008 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727977AbgHARD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 13:03:58 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-MXP8HqSjOCejT4qHqayigQ-1; Sat, 01 Aug 2020 13:03:53 -0400
X-MC-Unique: MXP8HqSjOCejT4qHqayigQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D1C61DE1;
        Sat,  1 Aug 2020 17:03:51 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48E0C5F7D8;
        Sat,  1 Aug 2020 17:03:48 +0000 (UTC)
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
Subject: [PATCH v9 bpf-next 07/14] bpf: Factor btf_struct_access function
Date:   Sat,  1 Aug 2020 19:03:15 +0200
Message-Id: <20200801170322.75218-8-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-1-jolsa@kernel.org>
References: <20200801170322.75218-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

  enum bpf_struct_walk_result {
       /* < 0 error */
       WALK_SCALAR = 0,
       WALK_PTR,
       WALK_STRUCT,
  };

WALK_SCALAR - when SCALAR_VALUE is found
WALK_PTR    - when pointer value is found, its ID is stored
              in 'next_btf_id' output param
WALK_STRUCT - when nested struct object is found, its ID is stored
              in 'next_btf_id' output param

It will be used in following patches to get all nested
struct objects for given type and offset.

The btf_struct_access now calls btf_struct_walk function,
as long as it gets nested structs as return value.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/btf.c | 75 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 65 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0f995038b589..7bacc2f56061 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3886,16 +3886,22 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	return true;
 }
 
-int btf_struct_access(struct bpf_verifier_log *log,
-		      const struct btf_type *t, int off, int size,
-		      enum bpf_access_type atype,
-		      u32 *next_btf_id)
+enum bpf_struct_walk_result {
+	/* < 0 error */
+	WALK_SCALAR = 0,
+	WALK_PTR,
+	WALK_STRUCT,
+};
+
+static int btf_struct_walk(struct bpf_verifier_log *log,
+			   const struct btf_type *t, int off, int size,
+			   u32 *next_btf_id)
 {
 	u32 i, moff, mtrue_end, msize = 0, total_nelems = 0;
 	const struct btf_type *mtype, *elem_type = NULL;
 	const struct btf_member *member;
 	const char *tname, *mname;
-	u32 vlen;
+	u32 vlen, elem_id, mid;
 
 again:
 	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
@@ -3966,7 +3972,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			 */
 			if (off <= moff &&
 			    BITS_ROUNDUP_BYTES(end_bit) <= off + size)
-				return SCALAR_VALUE;
+				return WALK_SCALAR;
 
 			/* off may be accessing a following member
 			 *
@@ -3988,11 +3994,13 @@ int btf_struct_access(struct bpf_verifier_log *log,
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
@@ -4054,6 +4062,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			elem_idx = (off - moff) / msize;
 			moff += elem_idx * msize;
 			mtype = elem_type;
+			mid = elem_id;
 		}
 
 		/* the 'off' we're looking for is either equal to start
@@ -4063,6 +4072,12 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			/* our field must be inside that union or struct */
 			t = mtype;
 
+			/* return if the offset matches the member offset */
+			if (off == moff) {
+				*next_btf_id = mid;
+				return WALK_STRUCT;
+			}
+
 			/* adjust offset we're looking for */
 			off -= moff;
 			goto again;
@@ -4078,11 +4093,10 @@ int btf_struct_access(struct bpf_verifier_log *log,
 					mname, moff, tname, off, size);
 				return -EACCES;
 			}
-
 			stype = btf_type_skip_modifiers(btf_vmlinux, mtype->type, &id);
 			if (btf_type_is_struct(stype)) {
 				*next_btf_id = id;
-				return PTR_TO_BTF_ID;
+				return WALK_PTR;
 			}
 		}
 
@@ -4099,12 +4113,53 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			return -EACCES;
 		}
 
-		return SCALAR_VALUE;
+		return WALK_SCALAR;
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
+
+		switch (err) {
+		case WALK_PTR:
+			/* If we found the pointer or scalar on t+off,
+			 * we're done.
+			 */
+			*next_btf_id = id;
+			return PTR_TO_BTF_ID;
+		case WALK_SCALAR:
+			return SCALAR_VALUE;
+		case WALK_STRUCT:
+			/* We found nested struct, so continue the search
+			 * by diving in it. At this point the offset is
+			 * aligned with the new type, so set it to 0.
+			 */
+			t = btf_type_by_id(btf_vmlinux, id);
+			off = 0;
+			break;
+		default:
+			/* It's either error or unknown return value..
+			 * scream and leave.
+			 */
+			if (WARN_ONCE(err > 0, "unknown btf_struct_walk return value"))
+				return -EINVAL;
+			return err;
+		}
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

