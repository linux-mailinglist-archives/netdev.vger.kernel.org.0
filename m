Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61FA49571
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfFQWtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:49:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17406 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbfFQWtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:49:13 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HMldwq016786
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:49:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=XWZ+ZEfIMG15jE9aNpgmQZIFqHrdMYU5D5Ikemg4Kek=;
 b=eEyEdliIGgt9G7h5/Gk8AP0R5q8gEct2KQAfm5UDaRlDI9uXWmv9SKSbKDFed6kIj1KP
 IYRYFmDgA9RQ85hd6iZ1pULQTiV0e2tldXA8fQN/TLp8ACiM4+AquFNUhH7SJfxz4lAD
 w7HZjjgsGjE6y1ty3q0n+38JTEmdxNFFjk8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t6bq9sy5r-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:49:10 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 17 Jun 2019 15:49:08 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id CCBC9861798; Mon, 17 Jun 2019 15:49:02 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] libbpf: constify getter APIs
Date:   Mon, 17 Jun 2019 15:48:58 -0700
Message-ID: <20190617224858.2891383-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170197
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add const qualifiers to bpf_object/bpf_program/bpf_map arguments for
getter APIs. There is no need for them to not be const pointers.

Verified that

make -C tools/lib/bpf
make -C tools/testing/selftests/bpf
make -C tools/perf

all build without warnings.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 80 ++++++++++++++++++++++--------------------
 tools/lib/bpf/libbpf.h | 62 ++++++++++++++++----------------
 2 files changed, 72 insertions(+), 70 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e725fa86b189..fbf2c6bee573 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1275,7 +1275,8 @@ bpf_object__find_prog_by_idx(struct bpf_object *obj, int idx)
 }
 
 struct bpf_program *
-bpf_object__find_program_by_title(struct bpf_object *obj, const char *title)
+bpf_object__find_program_by_title(const struct bpf_object *obj,
+				  const char *title)
 {
 	struct bpf_program *pos;
 
@@ -2192,8 +2193,8 @@ bpf_program__load(struct bpf_program *prog,
 	return err;
 }
 
-static bool bpf_program__is_function_storage(struct bpf_program *prog,
-					     struct bpf_object *obj)
+static bool bpf_program__is_function_storage(const struct bpf_program *prog,
+					     const struct bpf_object *obj)
 {
 	return prog->idx == obj->efile.text_shndx && obj->has_pseudo_calls;
 }
@@ -2899,17 +2900,17 @@ bpf_object__next(struct bpf_object *prev)
 	return next;
 }
 
-const char *bpf_object__name(struct bpf_object *obj)
+const char *bpf_object__name(const struct bpf_object *obj)
 {
 	return obj ? obj->path : ERR_PTR(-EINVAL);
 }
 
-unsigned int bpf_object__kversion(struct bpf_object *obj)
+unsigned int bpf_object__kversion(const struct bpf_object *obj)
 {
 	return obj ? obj->kern_version : 0;
 }
 
-struct btf *bpf_object__btf(struct bpf_object *obj)
+struct btf *bpf_object__btf(const struct bpf_object *obj)
 {
 	return obj ? obj->btf : NULL;
 }
@@ -2930,13 +2931,14 @@ int bpf_object__set_priv(struct bpf_object *obj, void *priv,
 	return 0;
 }
 
-void *bpf_object__priv(struct bpf_object *obj)
+void *bpf_object__priv(const struct bpf_object *obj)
 {
 	return obj ? obj->priv : ERR_PTR(-EINVAL);
 }
 
 static struct bpf_program *
-__bpf_program__iter(struct bpf_program *p, struct bpf_object *obj, bool forward)
+__bpf_program__iter(const struct bpf_program *p, const struct bpf_object *obj,
+		    bool forward)
 {
 	size_t nr_programs = obj->nr_programs;
 	ssize_t idx;
@@ -2961,7 +2963,7 @@ __bpf_program__iter(struct bpf_program *p, struct bpf_object *obj, bool forward)
 }
 
 struct bpf_program *
-bpf_program__next(struct bpf_program *prev, struct bpf_object *obj)
+bpf_program__next(struct bpf_program *prev, const struct bpf_object *obj)
 {
 	struct bpf_program *prog = prev;
 
@@ -2973,7 +2975,7 @@ bpf_program__next(struct bpf_program *prev, struct bpf_object *obj)
 }
 
 struct bpf_program *
-bpf_program__prev(struct bpf_program *next, struct bpf_object *obj)
+bpf_program__prev(struct bpf_program *next, const struct bpf_object *obj)
 {
 	struct bpf_program *prog = next;
 
@@ -2995,7 +2997,7 @@ int bpf_program__set_priv(struct bpf_program *prog, void *priv,
 	return 0;
 }
 
-void *bpf_program__priv(struct bpf_program *prog)
+void *bpf_program__priv(const struct bpf_program *prog)
 {
 	return prog ? prog->priv : ERR_PTR(-EINVAL);
 }
@@ -3005,7 +3007,7 @@ void bpf_program__set_ifindex(struct bpf_program *prog, __u32 ifindex)
 	prog->prog_ifindex = ifindex;
 }
 
-const char *bpf_program__title(struct bpf_program *prog, bool needs_copy)
+const char *bpf_program__title(const struct bpf_program *prog, bool needs_copy)
 {
 	const char *title;
 
@@ -3021,7 +3023,7 @@ const char *bpf_program__title(struct bpf_program *prog, bool needs_copy)
 	return title;
 }
 
-int bpf_program__fd(struct bpf_program *prog)
+int bpf_program__fd(const struct bpf_program *prog)
 {
 	return bpf_program__nth_fd(prog, 0);
 }
@@ -3054,7 +3056,7 @@ int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
 	return 0;
 }
 
-int bpf_program__nth_fd(struct bpf_program *prog, int n)
+int bpf_program__nth_fd(const struct bpf_program *prog, int n)
 {
 	int fd;
 
@@ -3082,25 +3084,25 @@ void bpf_program__set_type(struct bpf_program *prog, enum bpf_prog_type type)
 	prog->type = type;
 }
 
-static bool bpf_program__is_type(struct bpf_program *prog,
+static bool bpf_program__is_type(const struct bpf_program *prog,
 				 enum bpf_prog_type type)
 {
 	return prog ? (prog->type == type) : false;
 }
 
-#define BPF_PROG_TYPE_FNS(NAME, TYPE)			\
-int bpf_program__set_##NAME(struct bpf_program *prog)	\
-{							\
-	if (!prog)					\
-		return -EINVAL;				\
-	bpf_program__set_type(prog, TYPE);		\
-	return 0;					\
-}							\
-							\
-bool bpf_program__is_##NAME(struct bpf_program *prog)	\
-{							\
-	return bpf_program__is_type(prog, TYPE);	\
-}							\
+#define BPF_PROG_TYPE_FNS(NAME, TYPE)				\
+int bpf_program__set_##NAME(struct bpf_program *prog)		\
+{								\
+	if (!prog)						\
+		return -EINVAL;					\
+	bpf_program__set_type(prog, TYPE);			\
+	return 0;						\
+}								\
+								\
+bool bpf_program__is_##NAME(const struct bpf_program *prog)	\
+{								\
+	return bpf_program__is_type(prog, TYPE);		\
+}								\
 
 BPF_PROG_TYPE_FNS(socket_filter, BPF_PROG_TYPE_SOCKET_FILTER);
 BPF_PROG_TYPE_FNS(kprobe, BPF_PROG_TYPE_KPROBE);
@@ -3295,17 +3297,17 @@ bpf_program__identify_section(struct bpf_program *prog,
 					expected_attach_type);
 }
 
-int bpf_map__fd(struct bpf_map *map)
+int bpf_map__fd(const struct bpf_map *map)
 {
 	return map ? map->fd : -EINVAL;
 }
 
-const struct bpf_map_def *bpf_map__def(struct bpf_map *map)
+const struct bpf_map_def *bpf_map__def(const struct bpf_map *map)
 {
 	return map ? &map->def : ERR_PTR(-EINVAL);
 }
 
-const char *bpf_map__name(struct bpf_map *map)
+const char *bpf_map__name(const struct bpf_map *map)
 {
 	return map ? map->name : NULL;
 }
@@ -3336,17 +3338,17 @@ int bpf_map__set_priv(struct bpf_map *map, void *priv,
 	return 0;
 }
 
-void *bpf_map__priv(struct bpf_map *map)
+void *bpf_map__priv(const struct bpf_map *map)
 {
 	return map ? map->priv : ERR_PTR(-EINVAL);
 }
 
-bool bpf_map__is_offload_neutral(struct bpf_map *map)
+bool bpf_map__is_offload_neutral(const struct bpf_map *map)
 {
 	return map->def.type == BPF_MAP_TYPE_PERF_EVENT_ARRAY;
 }
 
-bool bpf_map__is_internal(struct bpf_map *map)
+bool bpf_map__is_internal(const struct bpf_map *map)
 {
 	return map->libbpf_type != LIBBPF_MAP_UNSPEC;
 }
@@ -3371,7 +3373,7 @@ int bpf_map__set_inner_map_fd(struct bpf_map *map, int fd)
 }
 
 static struct bpf_map *
-__bpf_map__iter(struct bpf_map *m, struct bpf_object *obj, int i)
+__bpf_map__iter(const struct bpf_map *m, const struct bpf_object *obj, int i)
 {
 	ssize_t idx;
 	struct bpf_map *s, *e;
@@ -3395,7 +3397,7 @@ __bpf_map__iter(struct bpf_map *m, struct bpf_object *obj, int i)
 }
 
 struct bpf_map *
-bpf_map__next(struct bpf_map *prev, struct bpf_object *obj)
+bpf_map__next(const struct bpf_map *prev, const struct bpf_object *obj)
 {
 	if (prev == NULL)
 		return obj->maps;
@@ -3404,7 +3406,7 @@ bpf_map__next(struct bpf_map *prev, struct bpf_object *obj)
 }
 
 struct bpf_map *
-bpf_map__prev(struct bpf_map *next, struct bpf_object *obj)
+bpf_map__prev(const struct bpf_map *next, const struct bpf_object *obj)
 {
 	if (next == NULL) {
 		if (!obj->nr_maps)
@@ -3416,7 +3418,7 @@ bpf_map__prev(struct bpf_map *next, struct bpf_object *obj)
 }
 
 struct bpf_map *
-bpf_object__find_map_by_name(struct bpf_object *obj, const char *name)
+bpf_object__find_map_by_name(const struct bpf_object *obj, const char *name)
 {
 	struct bpf_map *pos;
 
@@ -3428,7 +3430,7 @@ bpf_object__find_map_by_name(struct bpf_object *obj, const char *name)
 }
 
 int
-bpf_object__find_map_fd_by_name(struct bpf_object *obj, const char *name)
+bpf_object__find_map_fd_by_name(const struct bpf_object *obj, const char *name)
 {
 	return bpf_map__fd(bpf_object__find_map_by_name(obj, name));
 }
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 2e594a0fa961..d639f47e3110 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -98,15 +98,16 @@ struct bpf_object_load_attr {
 LIBBPF_API int bpf_object__load(struct bpf_object *obj);
 LIBBPF_API int bpf_object__load_xattr(struct bpf_object_load_attr *attr);
 LIBBPF_API int bpf_object__unload(struct bpf_object *obj);
-LIBBPF_API const char *bpf_object__name(struct bpf_object *obj);
-LIBBPF_API unsigned int bpf_object__kversion(struct bpf_object *obj);
+LIBBPF_API const char *bpf_object__name(const struct bpf_object *obj);
+LIBBPF_API unsigned int bpf_object__kversion(const struct bpf_object *obj);
 
 struct btf;
-LIBBPF_API struct btf *bpf_object__btf(struct bpf_object *obj);
+LIBBPF_API struct btf *bpf_object__btf(const struct bpf_object *obj);
 LIBBPF_API int bpf_object__btf_fd(const struct bpf_object *obj);
 
 LIBBPF_API struct bpf_program *
-bpf_object__find_program_by_title(struct bpf_object *obj, const char *title);
+bpf_object__find_program_by_title(const struct bpf_object *obj,
+				  const char *title);
 
 LIBBPF_API struct bpf_object *bpf_object__next(struct bpf_object *prev);
 #define bpf_object__for_each_safe(pos, tmp)			\
@@ -118,7 +119,7 @@ LIBBPF_API struct bpf_object *bpf_object__next(struct bpf_object *prev);
 typedef void (*bpf_object_clear_priv_t)(struct bpf_object *, void *);
 LIBBPF_API int bpf_object__set_priv(struct bpf_object *obj, void *priv,
 				    bpf_object_clear_priv_t clear_priv);
-LIBBPF_API void *bpf_object__priv(struct bpf_object *prog);
+LIBBPF_API void *bpf_object__priv(const struct bpf_object *prog);
 
 LIBBPF_API int
 libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
@@ -129,7 +130,7 @@ LIBBPF_API int libbpf_attach_type_by_name(const char *name,
 /* Accessors of bpf_program */
 struct bpf_program;
 LIBBPF_API struct bpf_program *bpf_program__next(struct bpf_program *prog,
-						 struct bpf_object *obj);
+						 const struct bpf_object *obj);
 
 #define bpf_object__for_each_program(pos, obj)		\
 	for ((pos) = bpf_program__next(NULL, (obj));	\
@@ -137,24 +138,23 @@ LIBBPF_API struct bpf_program *bpf_program__next(struct bpf_program *prog,
 	     (pos) = bpf_program__next((pos), (obj)))
 
 LIBBPF_API struct bpf_program *bpf_program__prev(struct bpf_program *prog,
-						 struct bpf_object *obj);
+						 const struct bpf_object *obj);
 
-typedef void (*bpf_program_clear_priv_t)(struct bpf_program *,
-					 void *);
+typedef void (*bpf_program_clear_priv_t)(struct bpf_program *, void *);
 
 LIBBPF_API int bpf_program__set_priv(struct bpf_program *prog, void *priv,
 				     bpf_program_clear_priv_t clear_priv);
 
-LIBBPF_API void *bpf_program__priv(struct bpf_program *prog);
+LIBBPF_API void *bpf_program__priv(const struct bpf_program *prog);
 LIBBPF_API void bpf_program__set_ifindex(struct bpf_program *prog,
 					 __u32 ifindex);
 
-LIBBPF_API const char *bpf_program__title(struct bpf_program *prog,
+LIBBPF_API const char *bpf_program__title(const struct bpf_program *prog,
 					  bool needs_copy);
 
 LIBBPF_API int bpf_program__load(struct bpf_program *prog, char *license,
 				 __u32 kern_version);
-LIBBPF_API int bpf_program__fd(struct bpf_program *prog);
+LIBBPF_API int bpf_program__fd(const struct bpf_program *prog);
 LIBBPF_API int bpf_program__pin_instance(struct bpf_program *prog,
 					 const char *path,
 					 int instance);
@@ -227,7 +227,7 @@ typedef int (*bpf_program_prep_t)(struct bpf_program *prog, int n,
 LIBBPF_API int bpf_program__set_prep(struct bpf_program *prog, int nr_instance,
 				     bpf_program_prep_t prep);
 
-LIBBPF_API int bpf_program__nth_fd(struct bpf_program *prog, int n);
+LIBBPF_API int bpf_program__nth_fd(const struct bpf_program *prog, int n);
 
 /*
  * Adjust type of BPF program. Default is kprobe.
@@ -246,14 +246,14 @@ LIBBPF_API void
 bpf_program__set_expected_attach_type(struct bpf_program *prog,
 				      enum bpf_attach_type type);
 
-LIBBPF_API bool bpf_program__is_socket_filter(struct bpf_program *prog);
-LIBBPF_API bool bpf_program__is_tracepoint(struct bpf_program *prog);
-LIBBPF_API bool bpf_program__is_raw_tracepoint(struct bpf_program *prog);
-LIBBPF_API bool bpf_program__is_kprobe(struct bpf_program *prog);
-LIBBPF_API bool bpf_program__is_sched_cls(struct bpf_program *prog);
-LIBBPF_API bool bpf_program__is_sched_act(struct bpf_program *prog);
-LIBBPF_API bool bpf_program__is_xdp(struct bpf_program *prog);
-LIBBPF_API bool bpf_program__is_perf_event(struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_socket_filter(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_tracepoint(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_raw_tracepoint(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_kprobe(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_sched_cls(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_sched_act(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_xdp(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_perf_event(const struct bpf_program *prog);
 
 /*
  * No need for __attribute__((packed)), all members of 'bpf_map_def'
@@ -275,10 +275,10 @@ struct bpf_map_def {
  */
 struct bpf_map;
 LIBBPF_API struct bpf_map *
-bpf_object__find_map_by_name(struct bpf_object *obj, const char *name);
+bpf_object__find_map_by_name(const struct bpf_object *obj, const char *name);
 
 LIBBPF_API int
-bpf_object__find_map_fd_by_name(struct bpf_object *obj, const char *name);
+bpf_object__find_map_fd_by_name(const struct bpf_object *obj, const char *name);
 
 /*
  * Get bpf_map through the offset of corresponding struct bpf_map_def
@@ -288,7 +288,7 @@ LIBBPF_API struct bpf_map *
 bpf_object__find_map_by_offset(struct bpf_object *obj, size_t offset);
 
 LIBBPF_API struct bpf_map *
-bpf_map__next(struct bpf_map *map, struct bpf_object *obj);
+bpf_map__next(const struct bpf_map *map, const struct bpf_object *obj);
 #define bpf_object__for_each_map(pos, obj)		\
 	for ((pos) = bpf_map__next(NULL, (obj));	\
 	     (pos) != NULL;				\
@@ -296,22 +296,22 @@ bpf_map__next(struct bpf_map *map, struct bpf_object *obj);
 #define bpf_map__for_each bpf_object__for_each_map
 
 LIBBPF_API struct bpf_map *
-bpf_map__prev(struct bpf_map *map, struct bpf_object *obj);
+bpf_map__prev(const struct bpf_map *map, const struct bpf_object *obj);
 
-LIBBPF_API int bpf_map__fd(struct bpf_map *map);
-LIBBPF_API const struct bpf_map_def *bpf_map__def(struct bpf_map *map);
-LIBBPF_API const char *bpf_map__name(struct bpf_map *map);
+LIBBPF_API int bpf_map__fd(const struct bpf_map *map);
+LIBBPF_API const struct bpf_map_def *bpf_map__def(const struct bpf_map *map);
+LIBBPF_API const char *bpf_map__name(const struct bpf_map *map);
 LIBBPF_API __u32 bpf_map__btf_key_type_id(const struct bpf_map *map);
 LIBBPF_API __u32 bpf_map__btf_value_type_id(const struct bpf_map *map);
 
 typedef void (*bpf_map_clear_priv_t)(struct bpf_map *, void *);
 LIBBPF_API int bpf_map__set_priv(struct bpf_map *map, void *priv,
 				 bpf_map_clear_priv_t clear_priv);
-LIBBPF_API void *bpf_map__priv(struct bpf_map *map);
+LIBBPF_API void *bpf_map__priv(const struct bpf_map *map);
 LIBBPF_API int bpf_map__reuse_fd(struct bpf_map *map, int fd);
 LIBBPF_API int bpf_map__resize(struct bpf_map *map, __u32 max_entries);
-LIBBPF_API bool bpf_map__is_offload_neutral(struct bpf_map *map);
-LIBBPF_API bool bpf_map__is_internal(struct bpf_map *map);
+LIBBPF_API bool bpf_map__is_offload_neutral(const struct bpf_map *map);
+LIBBPF_API bool bpf_map__is_internal(const struct bpf_map *map);
 LIBBPF_API void bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex);
 LIBBPF_API int bpf_map__pin(struct bpf_map *map, const char *path);
 LIBBPF_API int bpf_map__unpin(struct bpf_map *map, const char *path);
-- 
2.17.1

