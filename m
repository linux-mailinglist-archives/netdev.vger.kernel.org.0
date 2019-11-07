Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7FFF36A9
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 19:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbfKGSJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 13:09:20 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61110 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729816AbfKGSJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 13:09:19 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7HswlU018516
        for <netdev@vger.kernel.org>; Thu, 7 Nov 2019 10:09:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=/DeASfoBNR+LMqDiZv3ZdLSmqKbP61+am62oijhyMAI=;
 b=V9ooKzFNSfDE2m2VFIFF7ZTUNmoYxWB0x21/bs9hSqbDyh7ps/1oXMuYpbWiULHmhy5t
 jGYjQLS9bP+kMEqipPm9qb9A/JRBJJsf2+S7tMqpUw/TZmhAMwiLyGKvnQBv9naz12LU
 hHK3vjfzwVDPK98HRSgsOuUhfFl24I0Wj24= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vxxngh-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 10:09:18 -0800
Received: from 2401:db00:2050:5102:face:0:37:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 10:09:05 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 14EA3294193C; Thu,  7 Nov 2019 10:09:03 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 1/2] bpf: Add array support to btf_struct_access
Date:   Thu, 7 Nov 2019 10:09:03 -0800
Message-ID: <20191107180903.4097702-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107180901.4097452-1-kafai@fb.com>
References: <20191107180901.4097452-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_05:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=8 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds array support to btf_struct_access().
It supports array of int, array of struct and multidimensional
array.

It also allows using u8[] as a scratch space.  For example,
it allows access the "char cb[48]" with size larger than
the array's element "char".  Another potential use case is
"u64 icsk_ca_priv[]" in the tcp congestion control.

btf_resolve_size() is added to resolve the size of any type.
It will follow the modifier if there is any.  Please
see the function comment for details.

This patch also adds the "off < moff" check at the beginning
of the for loop.  It is to reject cases when "off" is pointing
to a "hole" in a struct.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/btf.c | 195 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 166 insertions(+), 29 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 128d89601d73..4639c4ba9a9b 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1036,6 +1036,82 @@ static const struct resolve_vertex *env_stack_peak(struct btf_verifier_env *env)
 	return env->top_stack ? &env->stack[env->top_stack - 1] : NULL;
 }
 
+/* Resolve the size of a passed-in "type"
+ *
+ * type: is an array (e.g. u32 array[x][y])
+ * return type: type "u32[x][y]", i.e. BTF_KIND_ARRAY,
+ * *type_size: (x * y * sizeof(u32)).  Hence, *type_size always
+ *             corresponds to the return type.
+ * *elem_type: u32
+ * *total_nelems: (x * y).  Hence, individual elem size is
+ *                (*type_size / *total_nelems)
+ *
+ * type: is not an array (e.g. const struct X)
+ * return type: type "struct X"
+ * *type_size: sizeof(struct X)
+ * *elem_type: same as return type ("struct X")
+ * *total_nelems: 1
+ */
+static const struct btf_type *
+btf_resolve_size(const struct btf *btf, const struct btf_type *type,
+		 u32 *type_size, const struct btf_type **elem_type,
+		 u32 *total_nelems)
+{
+	const struct btf_type *array_type = NULL;
+	const struct btf_array *array;
+	u32 i, size, nelems = 1;
+
+	for (i = 0; i < MAX_RESOLVE_DEPTH; i++) {
+		switch (BTF_INFO_KIND(type->info)) {
+		/* type->size can be used */
+		case BTF_KIND_INT:
+		case BTF_KIND_STRUCT:
+		case BTF_KIND_UNION:
+		case BTF_KIND_ENUM:
+			size = type->size;
+			goto resolved;
+
+		case BTF_KIND_PTR:
+			size = sizeof(void *);
+			goto resolved;
+
+		/* Modifiers */
+		case BTF_KIND_TYPEDEF:
+		case BTF_KIND_VOLATILE:
+		case BTF_KIND_CONST:
+		case BTF_KIND_RESTRICT:
+			type = btf_type_by_id(btf, type->type);
+			break;
+
+		case BTF_KIND_ARRAY:
+			if (!array_type)
+				array_type = type;
+			array = btf_type_array(type);
+			if (nelems && array->nelems > U32_MAX / nelems)
+				return ERR_PTR(-EINVAL);
+			nelems *= array->nelems;
+			type = btf_type_by_id(btf, array->type);
+			break;
+
+		/* type without size */
+		default:
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	return ERR_PTR(-EINVAL);
+
+resolved:
+	if (nelems && size > U32_MAX / nelems)
+		return ERR_PTR(-EINVAL);
+
+	*type_size = nelems * size;
+	*total_nelems = nelems;
+	*elem_type = type;
+
+	return array_type ? : type;
+}
+
 /* The input param "type_id" must point to a needs_resolve type */
 static const struct btf_type *btf_type_id_resolve(const struct btf *btf,
 						  u32 *type_id)
@@ -3494,10 +3570,10 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		      enum bpf_access_type atype,
 		      u32 *next_btf_id)
 {
+	u32 i, moff, mtrue_end, msize = 0, total_nelems = 0;
+	const struct btf_type *mtype, *elem_type = NULL;
 	const struct btf_member *member;
-	const struct btf_type *mtype;
 	const char *tname, *mname;
-	int i, moff = 0, msize;
 
 again:
 	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
@@ -3507,40 +3583,88 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	}
 
 	for_each_member(i, t, member) {
-		/* offset of the field in bits */
-		moff = btf_member_bit_offset(t, member);
-
 		if (btf_member_bitfield_size(t, member))
 			/* bitfields are not supported yet */
 			continue;
 
-		if (off + size <= moff / 8)
+		/* offset of the field in bytes */
+		moff = btf_member_bit_offset(t, member) / 8;
+		if (off + size <= moff)
 			/* won't find anything, field is already too far */
 			break;
+		/* In case of "off" is pointing to holes of a struct */
+		if (off < moff)
+			continue;
 
 		/* type of the field */
 		mtype = btf_type_by_id(btf_vmlinux, member->type);
 		mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
 
-		/* skip modifiers */
-		while (btf_type_is_modifier(mtype))
-			mtype = btf_type_by_id(btf_vmlinux, mtype->type);
-
-		if (btf_type_is_array(mtype))
-			/* array deref is not supported yet */
-			continue;
-
-		if (!btf_type_has_size(mtype) && !btf_type_is_ptr(mtype)) {
+		mtype = btf_resolve_size(btf_vmlinux, mtype, &msize,
+					 &elem_type, &total_nelems);
+		if (IS_ERR(mtype)) {
 			bpf_log(log, "field %s doesn't have size\n", mname);
 			return -EFAULT;
 		}
-		if (btf_type_is_ptr(mtype))
-			msize = 8;
-		else
-			msize = mtype->size;
-		if (off >= moff / 8 + msize)
+
+		mtrue_end = moff + msize;
+		if (off >= mtrue_end)
 			/* no overlap with member, keep iterating */
 			continue;
+
+		if (btf_type_is_array(mtype)) {
+			u32 elem_idx;
+
+			/* btf_resolve_size() above helps to
+			 * linearize a multi-dimensional array.
+			 *
+			 * The logic here is treating an array
+			 * in a struct as the following way:
+			 *
+			 * struct outer {
+			 *	struct inner array[2][2];
+			 * };
+			 *
+			 * looks like:
+			 *
+			 * struct outer {
+			 *	struct inner array_elem0;
+			 *	struct inner array_elem1;
+			 *	struct inner array_elem2;
+			 *	struct inner array_elem3;
+			 * };
+			 *
+			 * When accessing outer->array[1][0], it moves
+			 * moff to "array_elem2", set mtype to
+			 * "struct inner", and msize also becomes
+			 * sizeof(struct inner).  Then most of the
+			 * remaining logic will fall through without
+			 * caring the current member is an array or
+			 * not.
+			 *
+			 * Unlike mtype/msize/moff, mtrue_end does not
+			 * change.  The naming difference ("_true") tells
+			 * that it is not always corresponding to
+			 * the current mtype/msize/moff.
+			 * It is the true end of the current
+			 * member (i.e. array in this case).  That
+			 * will allow an int array to be accessed like
+			 * a scratch space,
+			 * i.e. allow access beyond the size of
+			 *      the array's element as long as it is
+			 *      within the mtrue_end boundary.
+			 */
+
+			/* skip empty array */
+			if (moff == mtrue_end)
+				continue;
+
+			msize /= total_nelems;
+			elem_idx = (off - moff) / msize;
+			moff += elem_idx * msize;
+			mtype = elem_type;
+		}
+
 		/* the 'off' we're looking for is either equal to start
 		 * of this field or inside of this struct
 		 */
@@ -3549,20 +3673,20 @@ int btf_struct_access(struct bpf_verifier_log *log,
 			t = mtype;
 
 			/* adjust offset we're looking for */
-			off -= moff / 8;
+			off -= moff;
 			goto again;
 		}
-		if (msize != size) {
-			/* field access size doesn't match */
-			bpf_log(log,
-				"cannot access %d bytes in struct %s field %s that has size %d\n",
-				size, tname, mname, msize);
-			return -EACCES;
-		}
 
 		if (btf_type_is_ptr(mtype)) {
 			const struct btf_type *stype;
 
+			if (msize != size || off != moff) {
+				bpf_log(log,
+					"cannot access ptr member %s with moff %u in struct %s with off %u size %u\n",
+					mname, moff, tname, off, size);
+				return -EACCES;
+			}
+
 			stype = btf_type_by_id(btf_vmlinux, mtype->type);
 			/* skip modifiers */
 			while (btf_type_is_modifier(stype))
@@ -3572,7 +3696,20 @@ int btf_struct_access(struct bpf_verifier_log *log,
 				return PTR_TO_BTF_ID;
 			}
 		}
-		/* all other fields are treated as scalars */
+
+		/* Allow more flexible access within an int as long as
+		 * it is within mtrue_end.
+		 * Since mtrue_end could be the end of an array,
+		 * that also allows using an array of int as a scratch
+		 * space. e.g. skb->cb[].
+		 */
+		if (off + size > mtrue_end) {
+			bpf_log(log,
+				"access beyond the end of member %s (mend:%u) in struct %s with off %u size %u\n",
+				mname, mtrue_end, tname, off, size);
+			return -EACCES;
+		}
+
 		return SCALAR_VALUE;
 	}
 	bpf_log(log, "struct %s doesn't have field at offset %d\n", tname, off);
-- 
2.17.1

