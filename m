Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CBA249273
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgHSBgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:36:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726367AbgHSBgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:36:41 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J1aeFQ028059
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 18:36:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=HsZMAkYZ2GA05y59nepVuA6cGI8jV02CfVT/aMjDMck=;
 b=A6cj4PV+8JzfTrtw3HzOJYgMEqP8hE02CqrupSimKNRrerc8kHLac13eUoCelvmzWkLN
 jB/bbW4uB5TUx/3HECXAW3f8X6yH2D0jUcDchE1I9uq4553eGrC3oi52vy0Ad2hHKYVu
 qYpXsQsDEfEvpv+OFGLUKq021RooIIh1rHo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3e298-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 18:36:40 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 18:36:14 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 74B8F2EC5F07; Tue, 18 Aug 2020 18:36:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/4] libbpf: remove any use of reallocarray() in libbpf
Date:   Tue, 18 Aug 2020 18:36:04 -0700
Message-ID: <20200819013607.3607269-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200819013607.3607269-1-andriin@fb.com>
References: <20200819013607.3607269-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=8 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re-implement glibc's reallocarray() for libbpf internal-only use.
reallocarray(), unfortunately, is not available in all versions of glibc,=
 so
requires extra feature detection and using reallocarray() stub from
<tools/libc_compat.h> and COMPAT_NEED_REALLOCARRAY. All this complicates =
build
of libbpf unnecessarily and is just a maintenance burden. Instead, it's
trivial to implement libbpf-specific internal version and use it througho=
ut
libbpf.

Which is what this patch does, along with converting some realloc() uses =
that
should really have been reallocarray() in the first place.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/Makefile          |  6 +-----
 tools/lib/bpf/btf.c             | 11 +++++------
 tools/lib/bpf/btf_dump.c        |  6 ++----
 tools/lib/bpf/libbpf.c          | 21 ++++++++++-----------
 tools/lib/bpf/libbpf_internal.h | 25 +++++++++++++++++++++++++
 tools/lib/bpf/ringbuf.c         |  5 ++---
 6 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 95c946e94ca5..621ad96d06fd 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -56,7 +56,7 @@ ifndef VERBOSE
 endif
=20
 FEATURE_USER =3D .libbpf
-FEATURE_TESTS =3D libelf libelf-mmap zlib bpf reallocarray
+FEATURE_TESTS =3D libelf libelf-mmap zlib bpf
 FEATURE_DISPLAY =3D libelf zlib bpf
=20
 INCLUDES =3D -I. -I$(srctree)/tools/include -I$(srctree)/tools/arch/$(AR=
CH)/include/uapi -I$(srctree)/tools/include/uapi
@@ -102,10 +102,6 @@ ifeq ($(feature-libelf-mmap), 1)
   override CFLAGS +=3D -DHAVE_LIBELF_MMAP_SUPPORT
 endif
=20
-ifeq ($(feature-reallocarray), 0)
-  override CFLAGS +=3D -DCOMPAT_NEED_REALLOCARRAY
-endif
-
 # Append required CFLAGS
 override CFLAGS +=3D $(EXTRA_WARNINGS) -Wno-switch-enum
 override CFLAGS +=3D -Werror -Wall
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 1deedbd19c6c..1b7d85d94a07 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -61,7 +61,7 @@ static int btf_add_type(struct btf *btf, struct btf_typ=
e *t)
 		expand_by =3D max(btf->types_size >> 2, 16U);
 		new_size =3D min(BTF_MAX_NR_TYPES, btf->types_size + expand_by);
=20
-		new_types =3D realloc(btf->types, sizeof(*new_types) * new_size);
+		new_types =3D libbpf_reallocarray(btf->types, new_size, sizeof(*new_ty=
pes));
 		if (!new_types)
 			return -ENOMEM;
=20
@@ -1574,7 +1574,7 @@ static int btf_dedup_hypot_map_add(struct btf_dedup=
 *d,
 		__u32 *new_list;
=20
 		d->hypot_cap +=3D max((size_t)16, d->hypot_cap / 2);
-		new_list =3D realloc(d->hypot_list, sizeof(__u32) * d->hypot_cap);
+		new_list =3D libbpf_reallocarray(d->hypot_list, d->hypot_cap, sizeof(_=
_u32));
 		if (!new_list)
 			return -ENOMEM;
 		d->hypot_list =3D new_list;
@@ -1870,8 +1870,7 @@ static int btf_dedup_strings(struct btf_dedup *d)
 			struct btf_str_ptr *new_ptrs;
=20
 			strs.cap +=3D max(strs.cnt / 2, 16U);
-			new_ptrs =3D realloc(strs.ptrs,
-					   sizeof(strs.ptrs[0]) * strs.cap);
+			new_ptrs =3D libbpf_reallocarray(strs.ptrs, strs.cap, sizeof(strs.ptr=
s[0]));
 			if (!new_ptrs) {
 				err =3D -ENOMEM;
 				goto done;
@@ -2956,8 +2955,8 @@ static int btf_dedup_compact_types(struct btf_dedup=
 *d)
 	d->btf->nr_types =3D next_type_id - 1;
 	d->btf->types_size =3D d->btf->nr_types;
 	d->btf->hdr->type_len =3D p - types_start;
-	new_types =3D realloc(d->btf->types,
-			    (1 + d->btf->nr_types) * sizeof(struct btf_type *));
+	new_types =3D libbpf_reallocarray(d->btf->types, (1 + d->btf->nr_types)=
,
+					sizeof(struct btf_type *));
 	if (!new_types)
 		return -ENOMEM;
 	d->btf->types =3D new_types;
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index fe39bd774697..1ad852ad0a86 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -323,8 +323,7 @@ static int btf_dump_add_emit_queue_id(struct btf_dump=
 *d, __u32 id)
=20
 	if (d->emit_queue_cnt >=3D d->emit_queue_cap) {
 		new_cap =3D max(16, d->emit_queue_cap * 3 / 2);
-		new_queue =3D realloc(d->emit_queue,
-				    new_cap * sizeof(new_queue[0]));
+		new_queue =3D libbpf_reallocarray(d->emit_queue, new_cap, sizeof(new_q=
ueue[0]));
 		if (!new_queue)
 			return -ENOMEM;
 		d->emit_queue =3D new_queue;
@@ -1003,8 +1002,7 @@ static int btf_dump_push_decl_stack_id(struct btf_d=
ump *d, __u32 id)
=20
 	if (d->decl_stack_cnt >=3D d->decl_stack_cap) {
 		new_cap =3D max(16, d->decl_stack_cap * 3 / 2);
-		new_stack =3D realloc(d->decl_stack,
-				    new_cap * sizeof(new_stack[0]));
+		new_stack =3D libbpf_reallocarray(d->decl_stack, new_cap, sizeof(new_s=
tack[0]));
 		if (!new_stack)
 			return -ENOMEM;
 		d->decl_stack =3D new_stack;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0276cf85d763..2653bcee73b7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -44,7 +44,6 @@
 #include <sys/vfs.h>
 #include <sys/utsname.h>
 #include <sys/resource.h>
-#include <tools/libc_compat.h>
 #include <libelf.h>
 #include <gelf.h>
 #include <zlib.h>
@@ -567,7 +566,7 @@ bpf_object__add_program(struct bpf_object *obj, void =
*data, size_t size,
 	progs =3D obj->programs;
 	nr_progs =3D obj->nr_programs;
=20
-	progs =3D reallocarray(progs, nr_progs + 1, sizeof(progs[0]));
+	progs =3D libbpf_reallocarray(progs, nr_progs + 1, sizeof(progs[0]));
 	if (!progs) {
 		/*
 		 * In this case the original obj->programs
@@ -1292,7 +1291,7 @@ static struct bpf_map *bpf_object__add_map(struct b=
pf_object *obj)
 		return &obj->maps[obj->nr_maps++];
=20
 	new_cap =3D max((size_t)4, obj->maps_cap * 3 / 2);
-	new_maps =3D realloc(obj->maps, new_cap * sizeof(*obj->maps));
+	new_maps =3D libbpf_reallocarray(obj->maps, new_cap, sizeof(*obj->maps)=
);
 	if (!new_maps) {
 		pr_warn("alloc maps for object failed\n");
 		return ERR_PTR(-ENOMEM);
@@ -2721,8 +2720,8 @@ static int bpf_object__elf_collect(struct bpf_objec=
t *obj)
 				continue;
 			}
=20
-			sects =3D reallocarray(sects, nr_sects + 1,
-					     sizeof(*obj->efile.reloc_sects));
+			sects =3D libbpf_reallocarray(sects, nr_sects + 1,
+						    sizeof(*obj->efile.reloc_sects));
 			if (!sects) {
 				pr_warn("reloc_sects realloc failed\n");
 				return -ENOMEM;
@@ -2925,7 +2924,7 @@ static int bpf_object__collect_externs(struct bpf_o=
bject *obj)
 			continue;
=20
 		ext =3D obj->externs;
-		ext =3D reallocarray(ext, obj->nr_extern + 1, sizeof(*ext));
+		ext =3D libbpf_reallocarray(ext, obj->nr_extern + 1, sizeof(*ext));
 		if (!ext)
 			return -ENOMEM;
 		obj->externs =3D ext;
@@ -4362,9 +4361,9 @@ static struct ids_vec *bpf_core_find_cands(const st=
ruct btf *local_btf,
 			pr_debug("CO-RE relocating [%d] %s %s: found target candidate [%d] %s=
 %s\n",
 				 local_type_id, btf_kind_str(local_t),
 				 local_name, i, targ_kind, targ_name);
-			new_ids =3D reallocarray(cand_ids->data,
-					       cand_ids->len + 1,
-					       sizeof(*cand_ids->data));
+			new_ids =3D libbpf_reallocarray(cand_ids->data,
+						      cand_ids->len + 1,
+						      sizeof(*cand_ids->data));
 			if (!new_ids) {
 				err =3D -ENOMEM;
 				goto err_out;
@@ -5231,7 +5230,7 @@ bpf_program__reloc_text(struct bpf_program *prog, s=
truct bpf_object *obj,
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		new_cnt =3D prog->insns_cnt + text->insns_cnt;
-		new_insn =3D reallocarray(prog->insns, new_cnt, sizeof(*insn));
+		new_insn =3D libbpf_reallocarray(prog->insns, new_cnt, sizeof(*insn));
 		if (!new_insn) {
 			pr_warn("oom in prog realloc\n");
 			return -ENOMEM;
@@ -5473,7 +5472,7 @@ static int bpf_object__collect_map_relos(struct bpf=
_object *obj,
 		moff /=3D bpf_ptr_sz;
 		if (moff >=3D map->init_slots_sz) {
 			new_sz =3D moff + 1;
-			tmp =3D realloc(map->init_slots, new_sz * host_ptr_sz);
+			tmp =3D libbpf_reallocarray(map->init_slots, new_sz, host_ptr_sz);
 			if (!tmp)
 				return -ENOMEM;
 			map->init_slots =3D tmp;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
index b776a7125c92..954bc2bd040c 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -9,6 +9,7 @@
 #ifndef __LIBBPF_LIBBPF_INTERNAL_H
 #define __LIBBPF_LIBBPF_INTERNAL_H
=20
+#include <stdlib.h>
 #include "libbpf.h"
=20
 #define BTF_INFO_ENC(kind, kind_flag, vlen) \
@@ -23,6 +24,12 @@
 #define BTF_PARAM_ENC(name, type) (name), (type)
 #define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)
=20
+#ifndef likely
+#define likely(x) __builtin_expect(!!(x), 1)
+#endif
+#ifndef unlikely
+#define unlikely(x) __builtin_expect(!!(x), 0)
+#endif
 #ifndef min
 # define min(x, y) ((x) < (y) ? (x) : (y))
 #endif
@@ -63,6 +70,24 @@ do {				\
 #define pr_info(fmt, ...)	__pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
 #define pr_debug(fmt, ...)	__pr(LIBBPF_DEBUG, fmt, ##__VA_ARGS__)
=20
+/*
+ * Re-implement glibc's reallocarray() for libbpf internal-only use.
+ * reallocarray(), unfortunately, is not available in all versions of gl=
ibc,
+ * so requires extra feature detection and using reallocarray() stub fro=
m
+ * <tools/libc_compat.h> and COMPAT_NEED_REALLOCARRAY. All this complica=
tes
+ * build of libbpf unnecessarily and is just a maintenance burden. Inste=
ad,
+ * it's trivial to implement libbpf-specific internal version and use it
+ * throughout libbpf.
+ */
+static inline void *libbpf_reallocarray(void *ptr, size_t nmemb, size_t =
size)
+{
+	size_t total;
+
+	if (unlikely(__builtin_mul_overflow(nmemb, size, &total)))
+		return NULL;
+	return realloc(ptr, total);
+}
+
 static inline bool libbpf_validate_opts(const char *opts,
 					size_t opts_sz, size_t user_sz,
 					const char *type_name)
diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index 4fc6c6cbb4eb..5bd234be8a14 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -16,7 +16,6 @@
 #include <asm/barrier.h>
 #include <sys/mman.h>
 #include <sys/epoll.h>
-#include <tools/libc_compat.h>
=20
 #include "libbpf.h"
 #include "libbpf_internal.h"
@@ -82,12 +81,12 @@ int ring_buffer__add(struct ring_buffer *rb, int map_=
fd,
 		return -EINVAL;
 	}
=20
-	tmp =3D reallocarray(rb->rings, rb->ring_cnt + 1, sizeof(*rb->rings));
+	tmp =3D libbpf_reallocarray(rb->rings, rb->ring_cnt + 1, sizeof(*rb->ri=
ngs));
 	if (!tmp)
 		return -ENOMEM;
 	rb->rings =3D tmp;
=20
-	tmp =3D reallocarray(rb->events, rb->ring_cnt + 1, sizeof(*rb->events))=
;
+	tmp =3D libbpf_reallocarray(rb->events, rb->ring_cnt + 1, sizeof(*rb->e=
vents));
 	if (!tmp)
 		return -ENOMEM;
 	rb->events =3D tmp;
--=20
2.24.1

