Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC1138F925
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 06:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhEYEBe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 May 2021 00:01:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6228 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230411AbhEYEBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 00:01:23 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14P3jQrl008069
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 20:59:54 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38rh3sk3ge-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 20:59:53 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 20:59:48 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 28CA62EDBE05; Mon, 24 May 2021 20:59:47 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH v2 bpf-next 4/5] libbpf: streamline error reporting for high-level APIs
Date:   Mon, 24 May 2021 20:59:34 -0700
Message-ID: <20210525035935.1461796-5-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210525035935.1461796-1-andrii@kernel.org>
References: <20210525035935.1461796-1-andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-FB-Internal: Safe
X-Proofpoint-GUID: oALoHD3a6cZlIuQWINZhtdWAQZscSIar
X-Proofpoint-ORIG-GUID: oALoHD3a6cZlIuQWINZhtdWAQZscSIar
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_02:2021-05-24,2021-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement changes to error reporting for high-level libbpf APIs to make them
less surprising and less error-prone to users:
  - in all the cases when error happens, errno is set to an appropriate error
    value;
  - in libbpf 1.0 mode, all pointer-returning APIs return NULL on error and
    error code is communicated through errno; this applies both to APIs that
    already returned NULL before (so now they communicate more detailed error
    codes), as well as for many APIs that used ERR_PTR() macro and encoded
    error numbers as fake pointers.
  - in legacy (default) mode, those APIs that were returning ERR_PTR(err),
    continue doing so, but still set errno.

With these changes, errno can be always used to extract actual error,
regardless of legacy or libbpf 1.0 modes. This is utilized internally in
libbpf in places where libbpf uses it's own high-level APIs.
libbpf_get_error() is adapted to handle both cases completely transparently to
end-users (and is used by libbpf consistently as well).

More context, justification, and discussion can be found in "Libbpf: the road
to v1.0" document ([0]).

  [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_iaRuec6U-ZESZ54nNTY

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/bpf_prog_linfo.c  |  18 +-
 tools/lib/bpf/btf.c             | 302 +++++++++----------
 tools/lib/bpf/btf_dump.c        |  14 +-
 tools/lib/bpf/libbpf.c          | 502 +++++++++++++++++---------------
 tools/lib/bpf/libbpf_errno.c    |   7 +-
 tools/lib/bpf/libbpf_internal.h |  27 ++
 tools/lib/bpf/linker.c          |  22 +-
 tools/lib/bpf/netlink.c         |  81 +++---
 tools/lib/bpf/ringbuf.c         |  26 +-
 9 files changed, 531 insertions(+), 468 deletions(-)

diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
index 3ed1a27b5f7c..5c503096ef43 100644
--- a/tools/lib/bpf/bpf_prog_linfo.c
+++ b/tools/lib/bpf/bpf_prog_linfo.c
@@ -106,7 +106,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 	nr_linfo = info->nr_line_info;
 
 	if (!nr_linfo)
-		return NULL;
+		return errno = EINVAL, NULL;
 
 	/*
 	 * The min size that bpf_prog_linfo has to access for
@@ -114,11 +114,11 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 	 */
 	if (info->line_info_rec_size <
 	    offsetof(struct bpf_line_info, file_name_off))
-		return NULL;
+		return errno = EINVAL, NULL;
 
 	prog_linfo = calloc(1, sizeof(*prog_linfo));
 	if (!prog_linfo)
-		return NULL;
+		return errno = ENOMEM, NULL;
 
 	/* Copy xlated line_info */
 	prog_linfo->nr_linfo = nr_linfo;
@@ -174,7 +174,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 
 err_free:
 	bpf_prog_linfo__free(prog_linfo);
-	return NULL;
+	return errno = EINVAL, NULL;
 }
 
 const struct bpf_line_info *
@@ -186,11 +186,11 @@ bpf_prog_linfo__lfind_addr_func(const struct bpf_prog_linfo *prog_linfo,
 	const __u64 *jited_linfo;
 
 	if (func_idx >= prog_linfo->nr_jited_func)
-		return NULL;
+		return errno = ENOENT, NULL;
 
 	nr_linfo = prog_linfo->nr_jited_linfo_per_func[func_idx];
 	if (nr_skip >= nr_linfo)
-		return NULL;
+		return errno = ENOENT, NULL;
 
 	start = prog_linfo->jited_linfo_func_idx[func_idx] + nr_skip;
 	jited_rec_size = prog_linfo->jited_rec_size;
@@ -198,7 +198,7 @@ bpf_prog_linfo__lfind_addr_func(const struct bpf_prog_linfo *prog_linfo,
 		(start * jited_rec_size);
 	jited_linfo = raw_jited_linfo;
 	if (addr < *jited_linfo)
-		return NULL;
+		return errno = ENOENT, NULL;
 
 	nr_linfo -= nr_skip;
 	rec_size = prog_linfo->rec_size;
@@ -225,13 +225,13 @@ bpf_prog_linfo__lfind(const struct bpf_prog_linfo *prog_linfo,
 
 	nr_linfo = prog_linfo->nr_linfo;
 	if (nr_skip >= nr_linfo)
-		return NULL;
+		return errno = ENOENT, NULL;
 
 	rec_size = prog_linfo->rec_size;
 	raw_linfo = prog_linfo->raw_linfo + (nr_skip * rec_size);
 	linfo = raw_linfo;
 	if (insn_off < linfo->insn_off)
-		return NULL;
+		return errno = ENOENT, NULL;
 
 	nr_linfo -= nr_skip;
 	for (i = 0; i < nr_linfo; i++) {
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index d57e13a13798..b46760b93bb4 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -443,7 +443,7 @@ struct btf_type *btf_type_by_id(struct btf *btf, __u32 type_id)
 const struct btf_type *btf__type_by_id(const struct btf *btf, __u32 type_id)
 {
 	if (type_id >= btf->start_id + btf->nr_types)
-		return NULL;
+		return errno = EINVAL, NULL;
 	return btf_type_by_id((struct btf *)btf, type_id);
 }
 
@@ -510,7 +510,7 @@ size_t btf__pointer_size(const struct btf *btf)
 int btf__set_pointer_size(struct btf *btf, size_t ptr_sz)
 {
 	if (ptr_sz != 4 && ptr_sz != 8)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	btf->ptr_sz = ptr_sz;
 	return 0;
 }
@@ -537,7 +537,7 @@ enum btf_endianness btf__endianness(const struct btf *btf)
 int btf__set_endianness(struct btf *btf, enum btf_endianness endian)
 {
 	if (endian != BTF_LITTLE_ENDIAN && endian != BTF_BIG_ENDIAN)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	btf->swapped_endian = is_host_big_endian() != (endian == BTF_BIG_ENDIAN);
 	if (!btf->swapped_endian) {
@@ -568,8 +568,7 @@ __s64 btf__resolve_size(const struct btf *btf, __u32 type_id)
 	int i;
 
 	t = btf__type_by_id(btf, type_id);
-	for (i = 0; i < MAX_RESOLVE_DEPTH && !btf_type_is_void_or_null(t);
-	     i++) {
+	for (i = 0; i < MAX_RESOLVE_DEPTH && !btf_type_is_void_or_null(t); i++) {
 		switch (btf_kind(t)) {
 		case BTF_KIND_INT:
 		case BTF_KIND_STRUCT:
@@ -592,12 +591,12 @@ __s64 btf__resolve_size(const struct btf *btf, __u32 type_id)
 		case BTF_KIND_ARRAY:
 			array = btf_array(t);
 			if (nelems && array->nelems > UINT32_MAX / nelems)
-				return -E2BIG;
+				return libbpf_err(-E2BIG);
 			nelems *= array->nelems;
 			type_id = array->type;
 			break;
 		default:
-			return -EINVAL;
+			return libbpf_err(-EINVAL);
 		}
 
 		t = btf__type_by_id(btf, type_id);
@@ -605,9 +604,9 @@ __s64 btf__resolve_size(const struct btf *btf, __u32 type_id)
 
 done:
 	if (size < 0)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	if (nelems && size > UINT32_MAX / nelems)
-		return -E2BIG;
+		return libbpf_err(-E2BIG);
 
 	return nelems * size;
 }
@@ -640,7 +639,7 @@ int btf__align_of(const struct btf *btf, __u32 id)
 		for (i = 0; i < vlen; i++, m++) {
 			align = btf__align_of(btf, m->type);
 			if (align <= 0)
-				return align;
+				return libbpf_err(align);
 			max_align = max(max_align, align);
 		}
 
@@ -648,7 +647,7 @@ int btf__align_of(const struct btf *btf, __u32 id)
 	}
 	default:
 		pr_warn("unsupported BTF_KIND:%u\n", btf_kind(t));
-		return 0;
+		return errno = EINVAL, 0;
 	}
 }
 
@@ -667,7 +666,7 @@ int btf__resolve_type(const struct btf *btf, __u32 type_id)
 	}
 
 	if (depth == MAX_RESOLVE_DEPTH || btf_type_is_void_or_null(t))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	return type_id;
 }
@@ -687,7 +686,7 @@ __s32 btf__find_by_name(const struct btf *btf, const char *type_name)
 			return i;
 	}
 
-	return -ENOENT;
+	return libbpf_err(-ENOENT);
 }
 
 __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
@@ -709,7 +708,7 @@ __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
 			return i;
 	}
 
-	return -ENOENT;
+	return libbpf_err(-ENOENT);
 }
 
 static bool btf_is_modifiable(const struct btf *btf)
@@ -785,12 +784,12 @@ static struct btf *btf_new_empty(struct btf *base_btf)
 
 struct btf *btf__new_empty(void)
 {
-	return btf_new_empty(NULL);
+	return libbpf_ptr(btf_new_empty(NULL));
 }
 
 struct btf *btf__new_empty_split(struct btf *base_btf)
 {
-	return btf_new_empty(base_btf);
+	return libbpf_ptr(btf_new_empty(base_btf));
 }
 
 static struct btf *btf_new(const void *data, __u32 size, struct btf *base_btf)
@@ -846,7 +845,7 @@ static struct btf *btf_new(const void *data, __u32 size, struct btf *base_btf)
 
 struct btf *btf__new(const void *data, __u32 size)
 {
-	return btf_new(data, size, NULL);
+	return libbpf_ptr(btf_new(data, size, NULL));
 }
 
 static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
@@ -937,7 +936,8 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
 		goto done;
 	}
 	btf = btf_new(btf_data->d_buf, btf_data->d_size, base_btf);
-	if (IS_ERR(btf))
+	err = libbpf_get_error(btf);
+	if (err)
 		goto done;
 
 	switch (gelf_getclass(elf)) {
@@ -953,9 +953,9 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
 	}
 
 	if (btf_ext && btf_ext_data) {
-		*btf_ext = btf_ext__new(btf_ext_data->d_buf,
-					btf_ext_data->d_size);
-		if (IS_ERR(*btf_ext))
+		*btf_ext = btf_ext__new(btf_ext_data->d_buf, btf_ext_data->d_size);
+		err = libbpf_get_error(*btf_ext);
+		if (err)
 			goto done;
 	} else if (btf_ext) {
 		*btf_ext = NULL;
@@ -965,30 +965,24 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
 		elf_end(elf);
 	close(fd);
 
-	if (err)
-		return ERR_PTR(err);
-	/*
-	 * btf is always parsed before btf_ext, so no need to clean up
-	 * btf_ext, if btf loading failed
-	 */
-	if (IS_ERR(btf))
+	if (!err)
 		return btf;
-	if (btf_ext && IS_ERR(*btf_ext)) {
-		btf__free(btf);
-		err = PTR_ERR(*btf_ext);
-		return ERR_PTR(err);
-	}
-	return btf;
+
+	if (btf_ext)
+		btf_ext__free(*btf_ext);
+	btf__free(btf);
+
+	return ERR_PTR(err);
 }
 
 struct btf *btf__parse_elf(const char *path, struct btf_ext **btf_ext)
 {
-	return btf_parse_elf(path, NULL, btf_ext);
+	return libbpf_ptr(btf_parse_elf(path, NULL, btf_ext));
 }
 
 struct btf *btf__parse_elf_split(const char *path, struct btf *base_btf)
 {
-	return btf_parse_elf(path, base_btf, NULL);
+	return libbpf_ptr(btf_parse_elf(path, base_btf, NULL));
 }
 
 static struct btf *btf_parse_raw(const char *path, struct btf *base_btf)
@@ -1056,36 +1050,39 @@ static struct btf *btf_parse_raw(const char *path, struct btf *base_btf)
 
 struct btf *btf__parse_raw(const char *path)
 {
-	return btf_parse_raw(path, NULL);
+	return libbpf_ptr(btf_parse_raw(path, NULL));
 }
 
 struct btf *btf__parse_raw_split(const char *path, struct btf *base_btf)
 {
-	return btf_parse_raw(path, base_btf);
+	return libbpf_ptr(btf_parse_raw(path, base_btf));
 }
 
 static struct btf *btf_parse(const char *path, struct btf *base_btf, struct btf_ext **btf_ext)
 {
 	struct btf *btf;
+	int err;
 
 	if (btf_ext)
 		*btf_ext = NULL;
 
 	btf = btf_parse_raw(path, base_btf);
-	if (!IS_ERR(btf) || PTR_ERR(btf) != -EPROTO)
+	err = libbpf_get_error(btf);
+	if (!err)
 		return btf;
-
+	if (err != -EPROTO)
+		return ERR_PTR(err);
 	return btf_parse_elf(path, base_btf, btf_ext);
 }
 
 struct btf *btf__parse(const char *path, struct btf_ext **btf_ext)
 {
-	return btf_parse(path, NULL, btf_ext);
+	return libbpf_ptr(btf_parse(path, NULL, btf_ext));
 }
 
 struct btf *btf__parse_split(const char *path, struct btf *base_btf)
 {
-	return btf_parse(path, base_btf, NULL);
+	return libbpf_ptr(btf_parse(path, base_btf, NULL));
 }
 
 static int compare_vsi_off(const void *_a, const void *_b)
@@ -1178,7 +1175,7 @@ int btf__finalize_data(struct bpf_object *obj, struct btf *btf)
 		}
 	}
 
-	return err;
+	return libbpf_err(err);
 }
 
 static void *btf_get_raw_data(const struct btf *btf, __u32 *size, bool swap_endian);
@@ -1191,13 +1188,13 @@ int btf__load(struct btf *btf)
 	int err = 0;
 
 	if (btf->fd >= 0)
-		return -EEXIST;
+		return libbpf_err(-EEXIST);
 
 retry_load:
 	if (log_buf_size) {
 		log_buf = malloc(log_buf_size);
 		if (!log_buf)
-			return -ENOMEM;
+			return libbpf_err(-ENOMEM);
 
 		*log_buf = 0;
 	}
@@ -1229,7 +1226,7 @@ int btf__load(struct btf *btf)
 
 done:
 	free(log_buf);
-	return err;
+	return libbpf_err(err);
 }
 
 int btf__fd(const struct btf *btf)
@@ -1305,7 +1302,7 @@ const void *btf__get_raw_data(const struct btf *btf_ro, __u32 *size)
 
 	data = btf_get_raw_data(btf, &data_sz, btf->swapped_endian);
 	if (!data)
-		return NULL;
+		return errno = -ENOMEM, NULL;
 
 	btf->raw_size = data_sz;
 	if (btf->swapped_endian)
@@ -1323,7 +1320,7 @@ const char *btf__str_by_offset(const struct btf *btf, __u32 offset)
 	else if (offset - btf->start_str_off < btf->hdr->str_len)
 		return btf_strs_data(btf) + (offset - btf->start_str_off);
 	else
-		return NULL;
+		return errno = EINVAL, NULL;
 }
 
 const char *btf__name_by_offset(const struct btf *btf, __u32 offset)
@@ -1388,17 +1385,20 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
 int btf__get_from_id(__u32 id, struct btf **btf)
 {
 	struct btf *res;
-	int btf_fd;
+	int err, btf_fd;
 
 	*btf = NULL;
 	btf_fd = bpf_btf_get_fd_by_id(id);
 	if (btf_fd < 0)
-		return -errno;
+		return libbpf_err(-errno);
 
 	res = btf_get_from_fd(btf_fd, NULL);
+	err = libbpf_get_error(res);
+
 	close(btf_fd);
-	if (IS_ERR(res))
-		return PTR_ERR(res);
+
+	if (err)
+		return libbpf_err(err);
 
 	*btf = res;
 	return 0;
@@ -1415,31 +1415,30 @@ int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 	__s64 key_size, value_size;
 	__s32 container_id;
 
-	if (snprintf(container_name, max_name, "____btf_map_%s", map_name) ==
-	    max_name) {
+	if (snprintf(container_name, max_name, "____btf_map_%s", map_name) == max_name) {
 		pr_warn("map:%s length of '____btf_map_%s' is too long\n",
 			map_name, map_name);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	container_id = btf__find_by_name(btf, container_name);
 	if (container_id < 0) {
 		pr_debug("map:%s container_name:%s cannot be found in BTF. Missing BPF_ANNOTATE_KV_PAIR?\n",
 			 map_name, container_name);
-		return container_id;
+		return libbpf_err(container_id);
 	}
 
 	container_type = btf__type_by_id(btf, container_id);
 	if (!container_type) {
 		pr_warn("map:%s cannot find BTF type for container_id:%u\n",
 			map_name, container_id);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if (!btf_is_struct(container_type) || btf_vlen(container_type) < 2) {
 		pr_warn("map:%s container_name:%s is an invalid container struct\n",
 			map_name, container_name);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	key = btf_members(container_type);
@@ -1448,25 +1447,25 @@ int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 	key_size = btf__resolve_size(btf, key->type);
 	if (key_size < 0) {
 		pr_warn("map:%s invalid BTF key_type_size\n", map_name);
-		return key_size;
+		return libbpf_err(key_size);
 	}
 
 	if (expected_key_size != key_size) {
 		pr_warn("map:%s btf_key_type_size:%u != map_def_key_size:%u\n",
 			map_name, (__u32)key_size, expected_key_size);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	value_size = btf__resolve_size(btf, value->type);
 	if (value_size < 0) {
 		pr_warn("map:%s invalid BTF value_type_size\n", map_name);
-		return value_size;
+		return libbpf_err(value_size);
 	}
 
 	if (expected_value_size != value_size) {
 		pr_warn("map:%s btf_value_type_size:%u != map_def_value_size:%u\n",
 			map_name, (__u32)value_size, expected_value_size);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	*key_type_id = key->type;
@@ -1563,11 +1562,11 @@ int btf__find_str(struct btf *btf, const char *s)
 
 	/* BTF needs to be in a modifiable state to build string lookup index */
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	off = strset__find_str(btf->strs_set, s);
 	if (off < 0)
-		return off;
+		return libbpf_err(off);
 
 	return btf->start_str_off + off;
 }
@@ -1588,11 +1587,11 @@ int btf__add_str(struct btf *btf, const char *s)
 	}
 
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	off = strset__add_str(btf->strs_set, s);
 	if (off < 0)
-		return off;
+		return libbpf_err(off);
 
 	btf->hdr->str_len = strset__data_size(btf->strs_set);
 
@@ -1616,7 +1615,7 @@ static int btf_commit_type(struct btf *btf, int data_sz)
 
 	err = btf_add_type_idx_entry(btf, btf->hdr->type_len);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	btf->hdr->type_len += data_sz;
 	btf->hdr->str_off += data_sz;
@@ -1653,21 +1652,21 @@ int btf__add_type(struct btf *btf, const struct btf *src_btf, const struct btf_t
 
 	sz = btf_type_size(src_type);
 	if (sz < 0)
-		return sz;
+		return libbpf_err(sz);
 
 	/* deconstruct BTF, if necessary, and invalidate raw_data */
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	t = btf_add_type_mem(btf, sz);
 	if (!t)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	memcpy(t, src_type, sz);
 
 	err = btf_type_visit_str_offs(t, btf_rewrite_str, &p);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	return btf_commit_type(btf, sz);
 }
@@ -1688,21 +1687,21 @@ int btf__add_int(struct btf *btf, const char *name, size_t byte_sz, int encoding
 
 	/* non-empty name */
 	if (!name || !name[0])
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	/* byte_sz must be power of 2 */
 	if (!byte_sz || (byte_sz & (byte_sz - 1)) || byte_sz > 16)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	if (encoding & ~(BTF_INT_SIGNED | BTF_INT_CHAR | BTF_INT_BOOL))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	/* deconstruct BTF, if necessary, and invalidate raw_data */
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_type) + sizeof(int);
 	t = btf_add_type_mem(btf, sz);
 	if (!t)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	/* if something goes wrong later, we might end up with an extra string,
 	 * but that shouldn't be a problem, because BTF can't be constructed
@@ -1736,20 +1735,20 @@ int btf__add_float(struct btf *btf, const char *name, size_t byte_sz)
 
 	/* non-empty name */
 	if (!name || !name[0])
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	/* byte_sz must be one of the explicitly allowed values */
 	if (byte_sz != 2 && byte_sz != 4 && byte_sz != 8 && byte_sz != 12 &&
 	    byte_sz != 16)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_type);
 	t = btf_add_type_mem(btf, sz);
 	if (!t)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	name_off = btf__add_str(btf, name);
 	if (name_off < 0)
@@ -1780,15 +1779,15 @@ static int btf_add_ref_kind(struct btf *btf, int kind, const char *name, int ref
 	int sz, name_off = 0;
 
 	if (validate_type_id(ref_type_id))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_type);
 	t = btf_add_type_mem(btf, sz);
 	if (!t)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	if (name && name[0]) {
 		name_off = btf__add_str(btf, name);
@@ -1831,15 +1830,15 @@ int btf__add_array(struct btf *btf, int index_type_id, int elem_type_id, __u32 n
 	int sz;
 
 	if (validate_type_id(index_type_id) || validate_type_id(elem_type_id))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_type) + sizeof(struct btf_array);
 	t = btf_add_type_mem(btf, sz);
 	if (!t)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	t->name_off = 0;
 	t->info = btf_type_info(BTF_KIND_ARRAY, 0, 0);
@@ -1860,12 +1859,12 @@ static int btf_add_composite(struct btf *btf, int kind, const char *name, __u32
 	int sz, name_off = 0;
 
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_type);
 	t = btf_add_type_mem(btf, sz);
 	if (!t)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	if (name && name[0]) {
 		name_off = btf__add_str(btf, name);
@@ -1943,30 +1942,30 @@ int btf__add_field(struct btf *btf, const char *name, int type_id,
 
 	/* last type should be union/struct */
 	if (btf->nr_types == 0)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	t = btf_last_type(btf);
 	if (!btf_is_composite(t))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (validate_type_id(type_id))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	/* best-effort bit field offset/size enforcement */
 	is_bitfield = bit_size || (bit_offset % 8 != 0);
 	if (is_bitfield && (bit_size == 0 || bit_size > 255 || bit_offset > 0xffffff))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	/* only offset 0 is allowed for unions */
 	if (btf_is_union(t) && bit_offset)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	/* decompose and invalidate raw data */
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_member);
 	m = btf_add_type_mem(btf, sz);
 	if (!m)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	if (name && name[0]) {
 		name_off = btf__add_str(btf, name);
@@ -2008,15 +2007,15 @@ int btf__add_enum(struct btf *btf, const char *name, __u32 byte_sz)
 
 	/* byte_sz must be power of 2 */
 	if (!byte_sz || (byte_sz & (byte_sz - 1)) || byte_sz > 8)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_type);
 	t = btf_add_type_mem(btf, sz);
 	if (!t)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	if (name && name[0]) {
 		name_off = btf__add_str(btf, name);
@@ -2048,25 +2047,25 @@ int btf__add_enum_value(struct btf *btf, const char *name, __s64 value)
 
 	/* last type should be BTF_KIND_ENUM */
 	if (btf->nr_types == 0)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	t = btf_last_type(btf);
 	if (!btf_is_enum(t))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	/* non-empty name */
 	if (!name || !name[0])
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	if (value < INT_MIN || value > UINT_MAX)
-		return -E2BIG;
+		return libbpf_err(-E2BIG);
 
 	/* decompose and invalidate raw data */
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_enum);
 	v = btf_add_type_mem(btf, sz);
 	if (!v)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	name_off = btf__add_str(btf, name);
 	if (name_off < 0)
@@ -2096,7 +2095,7 @@ int btf__add_enum_value(struct btf *btf, const char *name, __s64 value)
 int btf__add_fwd(struct btf *btf, const char *name, enum btf_fwd_kind fwd_kind)
 {
 	if (!name || !name[0])
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	switch (fwd_kind) {
 	case BTF_FWD_STRUCT:
@@ -2117,7 +2116,7 @@ int btf__add_fwd(struct btf *btf, const char *name, enum btf_fwd_kind fwd_kind)
 		 */
 		return btf__add_enum(btf, name, sizeof(int));
 	default:
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 }
 
@@ -2132,7 +2131,7 @@ int btf__add_fwd(struct btf *btf, const char *name, enum btf_fwd_kind fwd_kind)
 int btf__add_typedef(struct btf *btf, const char *name, int ref_type_id)
 {
 	if (!name || !name[0])
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	return btf_add_ref_kind(btf, BTF_KIND_TYPEDEF, name, ref_type_id);
 }
@@ -2187,10 +2186,10 @@ int btf__add_func(struct btf *btf, const char *name,
 	int id;
 
 	if (!name || !name[0])
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	if (linkage != BTF_FUNC_STATIC && linkage != BTF_FUNC_GLOBAL &&
 	    linkage != BTF_FUNC_EXTERN)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	id = btf_add_ref_kind(btf, BTF_KIND_FUNC, name, proto_type_id);
 	if (id > 0) {
@@ -2198,7 +2197,7 @@ int btf__add_func(struct btf *btf, const char *name,
 
 		t->info = btf_type_info(BTF_KIND_FUNC, linkage, 0);
 	}
-	return id;
+	return libbpf_err(id);
 }
 
 /*
@@ -2219,15 +2218,15 @@ int btf__add_func_proto(struct btf *btf, int ret_type_id)
 	int sz;
 
 	if (validate_type_id(ret_type_id))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_type);
 	t = btf_add_type_mem(btf, sz);
 	if (!t)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	/* start out with vlen=0; this will be adjusted when adding enum
 	 * values, if necessary
@@ -2254,23 +2253,23 @@ int btf__add_func_param(struct btf *btf, const char *name, int type_id)
 	int sz, name_off = 0;
 
 	if (validate_type_id(type_id))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	/* last type should be BTF_KIND_FUNC_PROTO */
 	if (btf->nr_types == 0)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	t = btf_last_type(btf);
 	if (!btf_is_func_proto(t))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	/* decompose and invalidate raw data */
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_param);
 	p = btf_add_type_mem(btf, sz);
 	if (!p)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	if (name && name[0]) {
 		name_off = btf__add_str(btf, name);
@@ -2308,21 +2307,21 @@ int btf__add_var(struct btf *btf, const char *name, int linkage, int type_id)
 
 	/* non-empty name */
 	if (!name || !name[0])
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	if (linkage != BTF_VAR_STATIC && linkage != BTF_VAR_GLOBAL_ALLOCATED &&
 	    linkage != BTF_VAR_GLOBAL_EXTERN)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	if (validate_type_id(type_id))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	/* deconstruct BTF, if necessary, and invalidate raw_data */
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_type) + sizeof(struct btf_var);
 	t = btf_add_type_mem(btf, sz);
 	if (!t)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	name_off = btf__add_str(btf, name);
 	if (name_off < 0)
@@ -2357,15 +2356,15 @@ int btf__add_datasec(struct btf *btf, const char *name, __u32 byte_sz)
 
 	/* non-empty name */
 	if (!name || !name[0])
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_type);
 	t = btf_add_type_mem(btf, sz);
 	if (!t)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	name_off = btf__add_str(btf, name);
 	if (name_off < 0)
@@ -2397,22 +2396,22 @@ int btf__add_datasec_var_info(struct btf *btf, int var_type_id, __u32 offset, __
 
 	/* last type should be BTF_KIND_DATASEC */
 	if (btf->nr_types == 0)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	t = btf_last_type(btf);
 	if (!btf_is_datasec(t))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (validate_type_id(var_type_id))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	/* decompose and invalidate raw data */
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	sz = sizeof(struct btf_var_secinfo);
 	v = btf_add_type_mem(btf, sz);
 	if (!v)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	v->type = var_type_id;
 	v->offset = offset;
@@ -2614,11 +2613,11 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 size)
 
 	err = btf_ext_parse_hdr(data, size);
 	if (err)
-		return ERR_PTR(err);
+		return libbpf_err_ptr(err);
 
 	btf_ext = calloc(1, sizeof(struct btf_ext));
 	if (!btf_ext)
-		return ERR_PTR(-ENOMEM);
+		return libbpf_err_ptr(-ENOMEM);
 
 	btf_ext->data_size = size;
 	btf_ext->data = malloc(size);
@@ -2628,9 +2627,11 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 size)
 	}
 	memcpy(btf_ext->data, data, size);
 
-	if (btf_ext->hdr->hdr_len <
-	    offsetofend(struct btf_ext_header, line_info_len))
+	if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, line_info_len)) {
+		err = -EINVAL;
 		goto done;
+	}
+
 	err = btf_ext_setup_func_info(btf_ext);
 	if (err)
 		goto done;
@@ -2639,8 +2640,11 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 size)
 	if (err)
 		goto done;
 
-	if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_relo_len))
+	if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_relo_len)) {
+		err = -EINVAL;
 		goto done;
+	}
+
 	err = btf_ext_setup_core_relos(btf_ext);
 	if (err)
 		goto done;
@@ -2648,7 +2652,7 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 size)
 done:
 	if (err) {
 		btf_ext__free(btf_ext);
-		return ERR_PTR(err);
+		return libbpf_err_ptr(err);
 	}
 
 	return btf_ext;
@@ -2687,7 +2691,7 @@ static int btf_ext_reloc_info(const struct btf *btf,
 		existing_len = (*cnt) * record_size;
 		data = realloc(*info, existing_len + records_len);
 		if (!data)
-			return -ENOMEM;
+			return libbpf_err(-ENOMEM);
 
 		memcpy(data + existing_len, sinfo->data, records_len);
 		/* adjust insn_off only, the rest data will be passed
@@ -2697,15 +2701,14 @@ static int btf_ext_reloc_info(const struct btf *btf,
 			__u32 *insn_off;
 
 			insn_off = data + existing_len + (i * record_size);
-			*insn_off = *insn_off / sizeof(struct bpf_insn) +
-				insns_cnt;
+			*insn_off = *insn_off / sizeof(struct bpf_insn) + insns_cnt;
 		}
 		*info = data;
 		*cnt += sinfo->num_info;
 		return 0;
 	}
 
-	return -ENOENT;
+	return libbpf_err(-ENOENT);
 }
 
 int btf_ext__reloc_func_info(const struct btf *btf,
@@ -2894,11 +2897,11 @@ int btf__dedup(struct btf *btf, struct btf_ext *btf_ext,
 
 	if (IS_ERR(d)) {
 		pr_debug("btf_dedup_new failed: %ld", PTR_ERR(d));
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if (btf_ensure_modifiable(btf))
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	err = btf_dedup_prep(d);
 	if (err) {
@@ -2938,7 +2941,7 @@ int btf__dedup(struct btf *btf, struct btf_ext *btf_ext,
 
 done:
 	btf_dedup_free(d);
-	return err;
+	return libbpf_err(err);
 }
 
 #define BTF_UNPROCESSED_ID ((__u32)-1)
@@ -4411,7 +4414,7 @@ struct btf *libbpf_find_kernel_btf(void)
 	char path[PATH_MAX + 1];
 	struct utsname buf;
 	struct btf *btf;
-	int i;
+	int i, err;
 
 	uname(&buf);
 
@@ -4425,17 +4428,16 @@ struct btf *libbpf_find_kernel_btf(void)
 			btf = btf__parse_raw(path);
 		else
 			btf = btf__parse_elf(path, NULL);
-
-		pr_debug("loading kernel BTF '%s': %ld\n",
-			 path, IS_ERR(btf) ? PTR_ERR(btf) : 0);
-		if (IS_ERR(btf))
+		err = libbpf_get_error(btf);
+		pr_debug("loading kernel BTF '%s': %d\n", path, err);
+		if (err)
 			continue;
 
 		return btf;
 	}
 
 	pr_warn("failed to find valid kernel BTF\n");
-	return ERR_PTR(-ESRCH);
+	return libbpf_err_ptr(-ESRCH);
 }
 
 int btf_type_visit_type_ids(struct btf_type *t, type_id_visit_fn visit, void *ctx)
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 5e2809d685bf..5dc6b5172bb3 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -128,7 +128,7 @@ struct btf_dump *btf_dump__new(const struct btf *btf,
 
 	d = calloc(1, sizeof(struct btf_dump));
 	if (!d)
-		return ERR_PTR(-ENOMEM);
+		return libbpf_err_ptr(-ENOMEM);
 
 	d->btf = btf;
 	d->btf_ext = btf_ext;
@@ -156,7 +156,7 @@ struct btf_dump *btf_dump__new(const struct btf *btf,
 	return d;
 err:
 	btf_dump__free(d);
-	return ERR_PTR(err);
+	return libbpf_err_ptr(err);
 }
 
 static int btf_dump_resize(struct btf_dump *d)
@@ -236,16 +236,16 @@ int btf_dump__dump_type(struct btf_dump *d, __u32 id)
 	int err, i;
 
 	if (id > btf__get_nr_types(d->btf))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	err = btf_dump_resize(d);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	d->emit_queue_cnt = 0;
 	err = btf_dump_order_type(d, id, false);
 	if (err < 0)
-		return err;
+		return libbpf_err(err);
 
 	for (i = 0; i < d->emit_queue_cnt; i++)
 		btf_dump_emit_type(d, d->emit_queue[i], 0 /*top-level*/);
@@ -1075,11 +1075,11 @@ int btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
 	int lvl, err;
 
 	if (!OPTS_VALID(opts, btf_dump_emit_type_decl_opts))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	err = btf_dump_resize(d);
 	if (err)
-		return -EINVAL;
+		return libbpf_err(err);
 
 	fname = OPTS_GET(opts, field_name, "");
 	lvl = OPTS_GET(opts, indent_level, 0);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1425d7ed0f2f..1c4e20e75237 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2579,16 +2579,14 @@ static int bpf_object__init_btf(struct bpf_object *obj,
 
 	if (btf_data) {
 		obj->btf = btf__new(btf_data->d_buf, btf_data->d_size);
-		if (IS_ERR(obj->btf)) {
-			err = PTR_ERR(obj->btf);
+		err = libbpf_get_error(obj->btf);
+		if (err) {
 			obj->btf = NULL;
-			pr_warn("Error loading ELF section %s: %d.\n",
-				BTF_ELF_SEC, err);
+			pr_warn("Error loading ELF section %s: %d.\n", BTF_ELF_SEC, err);
 			goto out;
 		}
 		/* enforce 8-byte pointers for BPF-targeted BTFs */
 		btf__set_pointer_size(obj->btf, 8);
-		err = 0;
 	}
 	if (btf_ext_data) {
 		if (!obj->btf) {
@@ -2596,11 +2594,11 @@ static int bpf_object__init_btf(struct bpf_object *obj,
 				 BTF_EXT_ELF_SEC, BTF_ELF_SEC);
 			goto out;
 		}
-		obj->btf_ext = btf_ext__new(btf_ext_data->d_buf,
-					    btf_ext_data->d_size);
-		if (IS_ERR(obj->btf_ext)) {
-			pr_warn("Error loading ELF section %s: %ld. Ignored and continue.\n",
-				BTF_EXT_ELF_SEC, PTR_ERR(obj->btf_ext));
+		obj->btf_ext = btf_ext__new(btf_ext_data->d_buf, btf_ext_data->d_size);
+		err = libbpf_get_error(obj->btf_ext);
+		if (err) {
+			pr_warn("Error loading ELF section %s: %d. Ignored and continue.\n",
+				BTF_EXT_ELF_SEC, err);
 			obj->btf_ext = NULL;
 			goto out;
 		}
@@ -2684,8 +2682,8 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj, bool force)
 		return 0;
 
 	obj->btf_vmlinux = libbpf_find_kernel_btf();
-	if (IS_ERR(obj->btf_vmlinux)) {
-		err = PTR_ERR(obj->btf_vmlinux);
+	err = libbpf_get_error(obj->btf_vmlinux);
+	if (err) {
 		pr_warn("Error loading vmlinux BTF: %d\n", err);
 		obj->btf_vmlinux = NULL;
 		return err;
@@ -2751,8 +2749,9 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 		/* clone BTF to sanitize a copy and leave the original intact */
 		raw_data = btf__get_raw_data(obj->btf, &sz);
 		kern_btf = btf__new(raw_data, sz);
-		if (IS_ERR(kern_btf))
-			return PTR_ERR(kern_btf);
+		err = libbpf_get_error(kern_btf);
+		if (err)
+			return err;
 
 		/* enforce 8-byte pointers for BPF-targeted BTFs */
 		btf__set_pointer_size(obj->btf, 8);
@@ -3523,7 +3522,7 @@ bpf_object__find_program_by_title(const struct bpf_object *obj,
 		if (pos->sec_name && !strcmp(pos->sec_name, title))
 			return pos;
 	}
-	return NULL;
+	return errno = ENOENT, NULL;
 }
 
 static bool prog_is_subprog(const struct bpf_object *obj,
@@ -3556,7 +3555,7 @@ bpf_object__find_program_by_name(const struct bpf_object *obj,
 		if (!strcmp(prog->name, name))
 			return prog;
 	}
-	return NULL;
+	return errno = ENOENT, NULL;
 }
 
 static bool bpf_object__shndx_is_data(const struct bpf_object *obj,
@@ -3903,11 +3902,11 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 
 	err = bpf_obj_get_info_by_fd(fd, &info, &len);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	new_name = strdup(info.name);
 	if (!new_name)
-		return -errno;
+		return libbpf_err(-errno);
 
 	new_fd = open("/", O_RDONLY | O_CLOEXEC);
 	if (new_fd < 0) {
@@ -3945,7 +3944,7 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 	close(new_fd);
 err_free_new_name:
 	free(new_name);
-	return err;
+	return libbpf_err(err);
 }
 
 __u32 bpf_map__max_entries(const struct bpf_map *map)
@@ -3956,7 +3955,7 @@ __u32 bpf_map__max_entries(const struct bpf_map *map)
 struct bpf_map *bpf_map__inner_map(struct bpf_map *map)
 {
 	if (!bpf_map_type__is_map_in_map(map->def.type))
-		return NULL;
+		return errno = EINVAL, NULL;
 
 	return map->inner_map;
 }
@@ -3964,7 +3963,7 @@ struct bpf_map *bpf_map__inner_map(struct bpf_map *map)
 int bpf_map__set_max_entries(struct bpf_map *map, __u32 max_entries)
 {
 	if (map->fd >= 0)
-		return -EBUSY;
+		return libbpf_err(-EBUSY);
 	map->def.max_entries = max_entries;
 	return 0;
 }
@@ -3972,7 +3971,7 @@ int bpf_map__set_max_entries(struct bpf_map *map, __u32 max_entries)
 int bpf_map__resize(struct bpf_map *map, __u32 max_entries)
 {
 	if (!map || !max_entries)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	return bpf_map__set_max_entries(map, max_entries);
 }
@@ -5103,10 +5102,10 @@ static int load_module_btfs(struct bpf_object *obj)
 		}
 
 		btf = btf_get_from_fd(fd, obj->btf_vmlinux);
-		if (IS_ERR(btf)) {
-			pr_warn("failed to load module [%s]'s BTF object #%d: %ld\n",
-				name, id, PTR_ERR(btf));
-			err = PTR_ERR(btf);
+		err = libbpf_get_error(btf);
+		if (err) {
+			pr_warn("failed to load module [%s]'s BTF object #%d: %d\n",
+				name, id, err);
 			goto err_out;
 		}
 
@@ -6366,8 +6365,8 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 
 	if (targ_btf_path) {
 		obj->btf_vmlinux_override = btf__parse(targ_btf_path, NULL);
-		if (IS_ERR_OR_NULL(obj->btf_vmlinux_override)) {
-			err = PTR_ERR(obj->btf_vmlinux_override);
+		err = libbpf_get_error(obj->btf_vmlinux_override);
+		if (err) {
 			pr_warn("failed to parse target BTF: %d\n", err);
 			return err;
 		}
@@ -7424,7 +7423,7 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 
 	if (prog->obj->loaded) {
 		pr_warn("prog '%s': can't load after object was loaded\n", prog->name);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if ((prog->type == BPF_PROG_TYPE_TRACING ||
@@ -7434,7 +7433,7 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 
 		err = libbpf_find_attach_btf_id(prog, &btf_obj_fd, &btf_type_id);
 		if (err)
-			return err;
+			return libbpf_err(err);
 
 		prog->attach_btf_obj_fd = btf_obj_fd;
 		prog->attach_btf_id = btf_type_id;
@@ -7444,13 +7443,13 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 		if (prog->preprocessor) {
 			pr_warn("Internal error: can't load program '%s'\n",
 				prog->name);
-			return -LIBBPF_ERRNO__INTERNAL;
+			return libbpf_err(-LIBBPF_ERRNO__INTERNAL);
 		}
 
 		prog->instances.fds = malloc(sizeof(int));
 		if (!prog->instances.fds) {
 			pr_warn("Not enough memory for BPF fds\n");
-			return -ENOMEM;
+			return libbpf_err(-ENOMEM);
 		}
 		prog->instances.nr = 1;
 		prog->instances.fds[0] = -1;
@@ -7509,7 +7508,7 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 		pr_warn("failed to load program '%s'\n", prog->name);
 	zfree(&prog->insns);
 	prog->insns_cnt = 0;
-	return err;
+	return libbpf_err(err);
 }
 
 static int
@@ -7642,7 +7641,7 @@ __bpf_object__open_xattr(struct bpf_object_open_attr *attr, int flags)
 
 struct bpf_object *bpf_object__open_xattr(struct bpf_object_open_attr *attr)
 {
-	return __bpf_object__open_xattr(attr, 0);
+	return libbpf_ptr(__bpf_object__open_xattr(attr, 0));
 }
 
 struct bpf_object *bpf_object__open(const char *path)
@@ -7652,18 +7651,18 @@ struct bpf_object *bpf_object__open(const char *path)
 		.prog_type	= BPF_PROG_TYPE_UNSPEC,
 	};
 
-	return bpf_object__open_xattr(&attr);
+	return libbpf_ptr(__bpf_object__open_xattr(&attr, 0));
 }
 
 struct bpf_object *
 bpf_object__open_file(const char *path, const struct bpf_object_open_opts *opts)
 {
 	if (!path)
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 
 	pr_debug("loading %s\n", path);
 
-	return __bpf_object__open(path, NULL, 0, opts);
+	return libbpf_ptr(__bpf_object__open(path, NULL, 0, opts));
 }
 
 struct bpf_object *
@@ -7671,9 +7670,9 @@ bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
 		     const struct bpf_object_open_opts *opts)
 {
 	if (!obj_buf || obj_buf_sz == 0)
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 
-	return __bpf_object__open(NULL, obj_buf, obj_buf_sz, opts);
+	return libbpf_ptr(__bpf_object__open(NULL, obj_buf, obj_buf_sz, opts));
 }
 
 struct bpf_object *
@@ -7688,9 +7687,9 @@ bpf_object__open_buffer(const void *obj_buf, size_t obj_buf_sz,
 
 	/* returning NULL is wrong, but backwards-compatible */
 	if (!obj_buf || obj_buf_sz == 0)
-		return NULL;
+		return errno = EINVAL, NULL;
 
-	return bpf_object__open_mem(obj_buf, obj_buf_sz, &opts);
+	return libbpf_ptr(__bpf_object__open(NULL, obj_buf, obj_buf_sz, &opts));
 }
 
 int bpf_object__unload(struct bpf_object *obj)
@@ -7698,7 +7697,7 @@ int bpf_object__unload(struct bpf_object *obj)
 	size_t i;
 
 	if (!obj)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	for (i = 0; i < obj->nr_maps; i++) {
 		zclose(obj->maps[i].fd);
@@ -8031,14 +8030,14 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 	int err, i;
 
 	if (!attr)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	obj = attr->obj;
 	if (!obj)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (obj->loaded) {
 		pr_warn("object '%s': load can't be attempted twice\n", obj->name);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if (obj->gen_loader)
@@ -8089,7 +8088,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 
 	bpf_object__unload(obj);
 	pr_warn("failed to load object '%s'\n", obj->path);
-	return err;
+	return libbpf_err(err);
 }
 
 int bpf_object__load(struct bpf_object *obj)
@@ -8161,28 +8160,28 @@ int bpf_program__pin_instance(struct bpf_program *prog, const char *path,
 
 	err = make_parent_dir(path);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	err = check_path(path);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	if (prog == NULL) {
 		pr_warn("invalid program pointer\n");
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if (instance < 0 || instance >= prog->instances.nr) {
 		pr_warn("invalid prog instance %d of prog %s (max %d)\n",
 			instance, prog->name, prog->instances.nr);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if (bpf_obj_pin(prog->instances.fds[instance], path)) {
 		err = -errno;
 		cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
 		pr_warn("failed to pin program: %s\n", cp);
-		return err;
+		return libbpf_err(err);
 	}
 	pr_debug("pinned program '%s'\n", path);
 
@@ -8196,22 +8195,23 @@ int bpf_program__unpin_instance(struct bpf_program *prog, const char *path,
 
 	err = check_path(path);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	if (prog == NULL) {
 		pr_warn("invalid program pointer\n");
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if (instance < 0 || instance >= prog->instances.nr) {
 		pr_warn("invalid prog instance %d of prog %s (max %d)\n",
 			instance, prog->name, prog->instances.nr);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	err = unlink(path);
 	if (err != 0)
-		return -errno;
+		return libbpf_err(-errno);
+
 	pr_debug("unpinned program '%s'\n", path);
 
 	return 0;
@@ -8223,20 +8223,20 @@ int bpf_program__pin(struct bpf_program *prog, const char *path)
 
 	err = make_parent_dir(path);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	err = check_path(path);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	if (prog == NULL) {
 		pr_warn("invalid program pointer\n");
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if (prog->instances.nr <= 0) {
 		pr_warn("no instances of prog %s to pin\n", prog->name);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if (prog->instances.nr == 1) {
@@ -8280,7 +8280,7 @@ int bpf_program__pin(struct bpf_program *prog, const char *path)
 
 	rmdir(path);
 
-	return err;
+	return libbpf_err(err);
 }
 
 int bpf_program__unpin(struct bpf_program *prog, const char *path)
@@ -8289,16 +8289,16 @@ int bpf_program__unpin(struct bpf_program *prog, const char *path)
 
 	err = check_path(path);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	if (prog == NULL) {
 		pr_warn("invalid program pointer\n");
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if (prog->instances.nr <= 0) {
 		pr_warn("no instances of prog %s to pin\n", prog->name);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if (prog->instances.nr == 1) {
@@ -8312,9 +8312,9 @@ int bpf_program__unpin(struct bpf_program *prog, const char *path)
 
 		len = snprintf(buf, PATH_MAX, "%s/%d", path, i);
 		if (len < 0)
-			return -EINVAL;
+			return libbpf_err(-EINVAL);
 		else if (len >= PATH_MAX)
-			return -ENAMETOOLONG;
+			return libbpf_err(-ENAMETOOLONG);
 
 		err = bpf_program__unpin_instance(prog, buf, i);
 		if (err)
@@ -8323,7 +8323,7 @@ int bpf_program__unpin(struct bpf_program *prog, const char *path)
 
 	err = rmdir(path);
 	if (err)
-		return -errno;
+		return libbpf_err(-errno);
 
 	return 0;
 }
@@ -8335,14 +8335,14 @@ int bpf_map__pin(struct bpf_map *map, const char *path)
 
 	if (map == NULL) {
 		pr_warn("invalid map pointer\n");
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if (map->pin_path) {
 		if (path && strcmp(path, map->pin_path)) {
 			pr_warn("map '%s' already has pin path '%s' different from '%s'\n",
 				bpf_map__name(map), map->pin_path, path);
-			return -EINVAL;
+			return libbpf_err(-EINVAL);
 		} else if (map->pinned) {
 			pr_debug("map '%s' already pinned at '%s'; not re-pinning\n",
 				 bpf_map__name(map), map->pin_path);
@@ -8352,10 +8352,10 @@ int bpf_map__pin(struct bpf_map *map, const char *path)
 		if (!path) {
 			pr_warn("missing a path to pin map '%s' at\n",
 				bpf_map__name(map));
-			return -EINVAL;
+			return libbpf_err(-EINVAL);
 		} else if (map->pinned) {
 			pr_warn("map '%s' already pinned\n", bpf_map__name(map));
-			return -EEXIST;
+			return libbpf_err(-EEXIST);
 		}
 
 		map->pin_path = strdup(path);
@@ -8367,11 +8367,11 @@ int bpf_map__pin(struct bpf_map *map, const char *path)
 
 	err = make_parent_dir(map->pin_path);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	err = check_path(map->pin_path);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	if (bpf_obj_pin(map->fd, map->pin_path)) {
 		err = -errno;
@@ -8386,7 +8386,7 @@ int bpf_map__pin(struct bpf_map *map, const char *path)
 out_err:
 	cp = libbpf_strerror_r(-err, errmsg, sizeof(errmsg));
 	pr_warn("failed to pin map: %s\n", cp);
-	return err;
+	return libbpf_err(err);
 }
 
 int bpf_map__unpin(struct bpf_map *map, const char *path)
@@ -8395,29 +8395,29 @@ int bpf_map__unpin(struct bpf_map *map, const char *path)
 
 	if (map == NULL) {
 		pr_warn("invalid map pointer\n");
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	if (map->pin_path) {
 		if (path && strcmp(path, map->pin_path)) {
 			pr_warn("map '%s' already has pin path '%s' different from '%s'\n",
 				bpf_map__name(map), map->pin_path, path);
-			return -EINVAL;
+			return libbpf_err(-EINVAL);
 		}
 		path = map->pin_path;
 	} else if (!path) {
 		pr_warn("no path to unpin map '%s' from\n",
 			bpf_map__name(map));
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	err = check_path(path);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	err = unlink(path);
 	if (err != 0)
-		return -errno;
+		return libbpf_err(-errno);
 
 	map->pinned = false;
 	pr_debug("unpinned map '%s' from '%s'\n", bpf_map__name(map), path);
@@ -8432,7 +8432,7 @@ int bpf_map__set_pin_path(struct bpf_map *map, const char *path)
 	if (path) {
 		new = strdup(path);
 		if (!new)
-			return -errno;
+			return libbpf_err(-errno);
 	}
 
 	free(map->pin_path);
@@ -8466,11 +8466,11 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 	int err;
 
 	if (!obj)
-		return -ENOENT;
+		return libbpf_err(-ENOENT);
 
 	if (!obj->loaded) {
 		pr_warn("object not yet loaded; load it first\n");
-		return -ENOENT;
+		return libbpf_err(-ENOENT);
 	}
 
 	bpf_object__for_each_map(map, obj) {
@@ -8510,7 +8510,7 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 		bpf_map__unpin(map, NULL);
 	}
 
-	return err;
+	return libbpf_err(err);
 }
 
 int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
@@ -8519,7 +8519,7 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
 	int err;
 
 	if (!obj)
-		return -ENOENT;
+		return libbpf_err(-ENOENT);
 
 	bpf_object__for_each_map(map, obj) {
 		char *pin_path = NULL;
@@ -8531,9 +8531,9 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
 			len = snprintf(buf, PATH_MAX, "%s/%s", path,
 				       bpf_map__name(map));
 			if (len < 0)
-				return -EINVAL;
+				return libbpf_err(-EINVAL);
 			else if (len >= PATH_MAX)
-				return -ENAMETOOLONG;
+				return libbpf_err(-ENAMETOOLONG);
 			sanitize_pin_path(buf);
 			pin_path = buf;
 		} else if (!map->pin_path) {
@@ -8542,7 +8542,7 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
 
 		err = bpf_map__unpin(map, pin_path);
 		if (err)
-			return err;
+			return libbpf_err(err);
 	}
 
 	return 0;
@@ -8554,11 +8554,11 @@ int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
 	int err;
 
 	if (!obj)
-		return -ENOENT;
+		return libbpf_err(-ENOENT);
 
 	if (!obj->loaded) {
 		pr_warn("object not yet loaded; load it first\n");
-		return -ENOENT;
+		return libbpf_err(-ENOENT);
 	}
 
 	bpf_object__for_each_program(prog, obj) {
@@ -8597,7 +8597,7 @@ int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
 		bpf_program__unpin(prog, buf);
 	}
 
-	return err;
+	return libbpf_err(err);
 }
 
 int bpf_object__unpin_programs(struct bpf_object *obj, const char *path)
@@ -8606,7 +8606,7 @@ int bpf_object__unpin_programs(struct bpf_object *obj, const char *path)
 	int err;
 
 	if (!obj)
-		return -ENOENT;
+		return libbpf_err(-ENOENT);
 
 	bpf_object__for_each_program(prog, obj) {
 		char buf[PATH_MAX];
@@ -8615,13 +8615,13 @@ int bpf_object__unpin_programs(struct bpf_object *obj, const char *path)
 		len = snprintf(buf, PATH_MAX, "%s/%s", path,
 			       prog->pin_name);
 		if (len < 0)
-			return -EINVAL;
+			return libbpf_err(-EINVAL);
 		else if (len >= PATH_MAX)
-			return -ENAMETOOLONG;
+			return libbpf_err(-ENAMETOOLONG);
 
 		err = bpf_program__unpin(prog, buf);
 		if (err)
-			return err;
+			return libbpf_err(err);
 	}
 
 	return 0;
@@ -8633,12 +8633,12 @@ int bpf_object__pin(struct bpf_object *obj, const char *path)
 
 	err = bpf_object__pin_maps(obj, path);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	err = bpf_object__pin_programs(obj, path);
 	if (err) {
 		bpf_object__unpin_maps(obj, path);
-		return err;
+		return libbpf_err(err);
 	}
 
 	return 0;
@@ -8735,7 +8735,7 @@ bpf_object__next(struct bpf_object *prev)
 
 const char *bpf_object__name(const struct bpf_object *obj)
 {
-	return obj ? obj->name : ERR_PTR(-EINVAL);
+	return obj ? obj->name : libbpf_err_ptr(-EINVAL);
 }
 
 unsigned int bpf_object__kversion(const struct bpf_object *obj)
@@ -8756,7 +8756,7 @@ int bpf_object__btf_fd(const struct bpf_object *obj)
 int bpf_object__set_kversion(struct bpf_object *obj, __u32 kern_version)
 {
 	if (obj->loaded)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	obj->kern_version = kern_version;
 
@@ -8776,7 +8776,7 @@ int bpf_object__set_priv(struct bpf_object *obj, void *priv,
 
 void *bpf_object__priv(const struct bpf_object *obj)
 {
-	return obj ? obj->priv : ERR_PTR(-EINVAL);
+	return obj ? obj->priv : libbpf_err_ptr(-EINVAL);
 }
 
 int bpf_object__gen_loader(struct bpf_object *obj, struct gen_loader_opts *opts)
@@ -8812,7 +8812,7 @@ __bpf_program__iter(const struct bpf_program *p, const struct bpf_object *obj,
 
 	if (p->obj != obj) {
 		pr_warn("error: program handler doesn't match object\n");
-		return NULL;
+		return errno = EINVAL, NULL;
 	}
 
 	idx = (p - obj->programs) + (forward ? 1 : -1);
@@ -8858,7 +8858,7 @@ int bpf_program__set_priv(struct bpf_program *prog, void *priv,
 
 void *bpf_program__priv(const struct bpf_program *prog)
 {
-	return prog ? prog->priv : ERR_PTR(-EINVAL);
+	return prog ? prog->priv : libbpf_err_ptr(-EINVAL);
 }
 
 void bpf_program__set_ifindex(struct bpf_program *prog, __u32 ifindex)
@@ -8885,7 +8885,7 @@ const char *bpf_program__title(const struct bpf_program *prog, bool needs_copy)
 		title = strdup(title);
 		if (!title) {
 			pr_warn("failed to strdup program title\n");
-			return ERR_PTR(-ENOMEM);
+			return libbpf_err_ptr(-ENOMEM);
 		}
 	}
 
@@ -8900,7 +8900,7 @@ bool bpf_program__autoload(const struct bpf_program *prog)
 int bpf_program__set_autoload(struct bpf_program *prog, bool autoload)
 {
 	if (prog->obj->loaded)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	prog->load = autoload;
 	return 0;
@@ -8922,17 +8922,17 @@ int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
 	int *instances_fds;
 
 	if (nr_instances <= 0 || !prep)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (prog->instances.nr > 0 || prog->instances.fds) {
 		pr_warn("Can't set pre-processor after loading\n");
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	instances_fds = malloc(sizeof(int) * nr_instances);
 	if (!instances_fds) {
 		pr_warn("alloc memory failed for fds\n");
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 	}
 
 	/* fill all fd with -1 */
@@ -8949,19 +8949,19 @@ int bpf_program__nth_fd(const struct bpf_program *prog, int n)
 	int fd;
 
 	if (!prog)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (n >= prog->instances.nr || n < 0) {
 		pr_warn("Can't get the %dth fd from program %s: only %d instances\n",
 			n, prog->name, prog->instances.nr);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	fd = prog->instances.fds[n];
 	if (fd < 0) {
 		pr_warn("%dth instance of program '%s' is invalid\n",
 			n, prog->name);
-		return -ENOENT;
+		return libbpf_err(-ENOENT);
 	}
 
 	return fd;
@@ -8987,7 +8987,7 @@ static bool bpf_program__is_type(const struct bpf_program *prog,
 int bpf_program__set_##NAME(struct bpf_program *prog)		\
 {								\
 	if (!prog)						\
-		return -EINVAL;					\
+		return libbpf_err(-EINVAL);			\
 	bpf_program__set_type(prog, TYPE);			\
 	return 0;						\
 }								\
@@ -9274,7 +9274,7 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 	char *type_names;
 
 	if (!name)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	sec_def = find_sec_def(name);
 	if (sec_def) {
@@ -9290,7 +9290,7 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 		free(type_names);
 	}
 
-	return -ESRCH;
+	return libbpf_err(-ESRCH);
 }
 
 static struct bpf_map *find_struct_ops_map_by_offset(struct bpf_object *obj,
@@ -9488,9 +9488,10 @@ int libbpf_find_vmlinux_btf_id(const char *name,
 	int err;
 
 	btf = libbpf_find_kernel_btf();
-	if (IS_ERR(btf)) {
+	err = libbpf_get_error(btf);
+	if (err) {
 		pr_warn("vmlinux BTF is not found\n");
-		return -EINVAL;
+		return libbpf_err(err);
 	}
 
 	err = find_attach_btf_id(btf, name, attach_type);
@@ -9498,7 +9499,7 @@ int libbpf_find_vmlinux_btf_id(const char *name,
 		pr_warn("%s is not found in vmlinux BTF\n", name);
 
 	btf__free(btf);
-	return err;
+	return libbpf_err(err);
 }
 
 static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
@@ -9509,10 +9510,11 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
 	int err = -EINVAL;
 
 	info_linear = bpf_program__get_prog_info_linear(attach_prog_fd, 0);
-	if (IS_ERR_OR_NULL(info_linear)) {
+	err = libbpf_get_error(info_linear);
+	if (err) {
 		pr_warn("failed get_prog_info_linear for FD %d\n",
 			attach_prog_fd);
-		return -EINVAL;
+		return err;
 	}
 	info = &info_linear->info;
 	if (!info->btf_id) {
@@ -9633,13 +9635,13 @@ int libbpf_attach_type_by_name(const char *name,
 	int i;
 
 	if (!name)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	for (i = 0; i < ARRAY_SIZE(section_defs); i++) {
 		if (strncmp(name, section_defs[i].sec, section_defs[i].len))
 			continue;
 		if (!section_defs[i].is_attachable)
-			return -EINVAL;
+			return libbpf_err(-EINVAL);
 		*attach_type = section_defs[i].expected_attach_type;
 		return 0;
 	}
@@ -9650,17 +9652,17 @@ int libbpf_attach_type_by_name(const char *name,
 		free(type_names);
 	}
 
-	return -EINVAL;
+	return libbpf_err(-EINVAL);
 }
 
 int bpf_map__fd(const struct bpf_map *map)
 {
-	return map ? map->fd : -EINVAL;
+	return map ? map->fd : libbpf_err(-EINVAL);
 }
 
 const struct bpf_map_def *bpf_map__def(const struct bpf_map *map)
 {
-	return map ? &map->def : ERR_PTR(-EINVAL);
+	return map ? &map->def : libbpf_err_ptr(-EINVAL);
 }
 
 const char *bpf_map__name(const struct bpf_map *map)
@@ -9676,7 +9678,7 @@ enum bpf_map_type bpf_map__type(const struct bpf_map *map)
 int bpf_map__set_type(struct bpf_map *map, enum bpf_map_type type)
 {
 	if (map->fd >= 0)
-		return -EBUSY;
+		return libbpf_err(-EBUSY);
 	map->def.type = type;
 	return 0;
 }
@@ -9689,7 +9691,7 @@ __u32 bpf_map__map_flags(const struct bpf_map *map)
 int bpf_map__set_map_flags(struct bpf_map *map, __u32 flags)
 {
 	if (map->fd >= 0)
-		return -EBUSY;
+		return libbpf_err(-EBUSY);
 	map->def.map_flags = flags;
 	return 0;
 }
@@ -9702,7 +9704,7 @@ __u32 bpf_map__numa_node(const struct bpf_map *map)
 int bpf_map__set_numa_node(struct bpf_map *map, __u32 numa_node)
 {
 	if (map->fd >= 0)
-		return -EBUSY;
+		return libbpf_err(-EBUSY);
 	map->numa_node = numa_node;
 	return 0;
 }
@@ -9715,7 +9717,7 @@ __u32 bpf_map__key_size(const struct bpf_map *map)
 int bpf_map__set_key_size(struct bpf_map *map, __u32 size)
 {
 	if (map->fd >= 0)
-		return -EBUSY;
+		return libbpf_err(-EBUSY);
 	map->def.key_size = size;
 	return 0;
 }
@@ -9728,7 +9730,7 @@ __u32 bpf_map__value_size(const struct bpf_map *map)
 int bpf_map__set_value_size(struct bpf_map *map, __u32 size)
 {
 	if (map->fd >= 0)
-		return -EBUSY;
+		return libbpf_err(-EBUSY);
 	map->def.value_size = size;
 	return 0;
 }
@@ -9747,7 +9749,7 @@ int bpf_map__set_priv(struct bpf_map *map, void *priv,
 		     bpf_map_clear_priv_t clear_priv)
 {
 	if (!map)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (map->priv) {
 		if (map->clear_priv)
@@ -9761,7 +9763,7 @@ int bpf_map__set_priv(struct bpf_map *map, void *priv,
 
 void *bpf_map__priv(const struct bpf_map *map)
 {
-	return map ? map->priv : ERR_PTR(-EINVAL);
+	return map ? map->priv : libbpf_err_ptr(-EINVAL);
 }
 
 int bpf_map__set_initial_value(struct bpf_map *map,
@@ -9769,7 +9771,7 @@ int bpf_map__set_initial_value(struct bpf_map *map,
 {
 	if (!map->mmaped || map->libbpf_type == LIBBPF_MAP_KCONFIG ||
 	    size != map->def.value_size || map->fd >= 0)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	memcpy(map->mmaped, data, size);
 	return 0;
@@ -9801,7 +9803,7 @@ __u32 bpf_map__ifindex(const struct bpf_map *map)
 int bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex)
 {
 	if (map->fd >= 0)
-		return -EBUSY;
+		return libbpf_err(-EBUSY);
 	map->map_ifindex = ifindex;
 	return 0;
 }
@@ -9810,11 +9812,11 @@ int bpf_map__set_inner_map_fd(struct bpf_map *map, int fd)
 {
 	if (!bpf_map_type__is_map_in_map(map->def.type)) {
 		pr_warn("error: unsupported map type\n");
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 	if (map->inner_map_fd != -1) {
 		pr_warn("error: inner_map_fd already specified\n");
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 	zfree(&map->inner_map);
 	map->inner_map_fd = fd;
@@ -9828,7 +9830,7 @@ __bpf_map__iter(const struct bpf_map *m, const struct bpf_object *obj, int i)
 	struct bpf_map *s, *e;
 
 	if (!obj || !obj->maps)
-		return NULL;
+		return errno = EINVAL, NULL;
 
 	s = obj->maps;
 	e = obj->maps + obj->nr_maps;
@@ -9836,7 +9838,7 @@ __bpf_map__iter(const struct bpf_map *m, const struct bpf_object *obj, int i)
 	if ((m < s) || (m >= e)) {
 		pr_warn("error in %s: map handler doesn't belong to object\n",
 			 __func__);
-		return NULL;
+		return errno = EINVAL, NULL;
 	}
 
 	idx = (m - obj->maps) + i;
@@ -9875,7 +9877,7 @@ bpf_object__find_map_by_name(const struct bpf_object *obj, const char *name)
 		if (pos->name && !strcmp(pos->name, name))
 			return pos;
 	}
-	return NULL;
+	return errno = ENOENT, NULL;
 }
 
 int
@@ -9887,12 +9889,23 @@ bpf_object__find_map_fd_by_name(const struct bpf_object *obj, const char *name)
 struct bpf_map *
 bpf_object__find_map_by_offset(struct bpf_object *obj, size_t offset)
 {
-	return ERR_PTR(-ENOTSUP);
+	return libbpf_err_ptr(-ENOTSUP);
 }
 
 long libbpf_get_error(const void *ptr)
 {
-	return PTR_ERR_OR_ZERO(ptr);
+	if (!IS_ERR_OR_NULL(ptr))
+		return 0;
+
+	if (IS_ERR(ptr))
+		errno = -PTR_ERR(ptr);
+
+	/* If ptr == NULL, then errno should be already set by the failing
+	 * API, because libbpf never returns NULL on success and it now always
+	 * sets errno on error. So no extra errno handling for ptr == NULL
+	 * case.
+	 */
+	return -errno;
 }
 
 int bpf_prog_load(const char *file, enum bpf_prog_type type,
@@ -9918,16 +9931,17 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 	int err;
 
 	if (!attr)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	if (!attr->file)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	open_attr.file = attr->file;
 	open_attr.prog_type = attr->prog_type;
 
 	obj = bpf_object__open_xattr(&open_attr);
-	if (IS_ERR_OR_NULL(obj))
-		return -ENOENT;
+	err = libbpf_get_error(obj);
+	if (err)
+		return libbpf_err(-ENOENT);
 
 	bpf_object__for_each_program(prog, obj) {
 		enum bpf_attach_type attach_type = attr->expected_attach_type;
@@ -9947,7 +9961,7 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 			 * didn't provide a fallback type, too bad...
 			 */
 			bpf_object__close(obj);
-			return -EINVAL;
+			return libbpf_err(-EINVAL);
 		}
 
 		prog->prog_ifindex = attr->ifindex;
@@ -9965,13 +9979,13 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 	if (!first_prog) {
 		pr_warn("object file doesn't contain bpf program\n");
 		bpf_object__close(obj);
-		return -ENOENT;
+		return libbpf_err(-ENOENT);
 	}
 
 	err = bpf_object__load(obj);
 	if (err) {
 		bpf_object__close(obj);
-		return err;
+		return libbpf_err(err);
 	}
 
 	*pobj = obj;
@@ -9990,7 +10004,10 @@ struct bpf_link {
 /* Replace link's underlying BPF program with the new one */
 int bpf_link__update_program(struct bpf_link *link, struct bpf_program *prog)
 {
-	return bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog), NULL);
+	int ret;
+	
+	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog), NULL);
+	return libbpf_err_errno(ret);
 }
 
 /* Release "ownership" of underlying BPF resource (typically, BPF program
@@ -10023,7 +10040,7 @@ int bpf_link__destroy(struct bpf_link *link)
 		free(link->pin_path);
 	free(link);
 
-	return err;
+	return libbpf_err(err);
 }
 
 int bpf_link__fd(const struct bpf_link *link)
@@ -10038,7 +10055,7 @@ const char *bpf_link__pin_path(const struct bpf_link *link)
 
 static int bpf_link__detach_fd(struct bpf_link *link)
 {
-	return close(link->fd);
+	return libbpf_err_errno(close(link->fd));
 }
 
 struct bpf_link *bpf_link__open(const char *path)
@@ -10050,13 +10067,13 @@ struct bpf_link *bpf_link__open(const char *path)
 	if (fd < 0) {
 		fd = -errno;
 		pr_warn("failed to open link at %s: %d\n", path, fd);
-		return ERR_PTR(fd);
+		return libbpf_err_ptr(fd);
 	}
 
 	link = calloc(1, sizeof(*link));
 	if (!link) {
 		close(fd);
-		return ERR_PTR(-ENOMEM);
+		return libbpf_err_ptr(-ENOMEM);
 	}
 	link->detach = &bpf_link__detach_fd;
 	link->fd = fd;
@@ -10064,7 +10081,7 @@ struct bpf_link *bpf_link__open(const char *path)
 	link->pin_path = strdup(path);
 	if (!link->pin_path) {
 		bpf_link__destroy(link);
-		return ERR_PTR(-ENOMEM);
+		return libbpf_err_ptr(-ENOMEM);
 	}
 
 	return link;
@@ -10080,22 +10097,22 @@ int bpf_link__pin(struct bpf_link *link, const char *path)
 	int err;
 
 	if (link->pin_path)
-		return -EBUSY;
+		return libbpf_err(-EBUSY);
 	err = make_parent_dir(path);
 	if (err)
-		return err;
+		return libbpf_err(err);
 	err = check_path(path);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	link->pin_path = strdup(path);
 	if (!link->pin_path)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 
 	if (bpf_obj_pin(link->fd, link->pin_path)) {
 		err = -errno;
 		zfree(&link->pin_path);
-		return err;
+		return libbpf_err(err);
 	}
 
 	pr_debug("link fd=%d: pinned at %s\n", link->fd, link->pin_path);
@@ -10107,11 +10124,11 @@ int bpf_link__unpin(struct bpf_link *link)
 	int err;
 
 	if (!link->pin_path)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	err = unlink(link->pin_path);
 	if (err != 0)
-		return -errno;
+		return libbpf_err_errno(err);
 
 	pr_debug("link fd=%d: unpinned from %s\n", link->fd, link->pin_path);
 	zfree(&link->pin_path);
@@ -10127,11 +10144,10 @@ static int bpf_link__detach_perf_event(struct bpf_link *link)
 		err = -errno;
 
 	close(link->fd);
-	return err;
+	return libbpf_err(err);
 }
 
-struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
-						int pfd)
+struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog, int pfd)
 {
 	char errmsg[STRERR_BUFSIZE];
 	struct bpf_link *link;
@@ -10140,18 +10156,18 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
 	if (pfd < 0) {
 		pr_warn("prog '%s': invalid perf event FD %d\n",
 			prog->name, pfd);
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 	}
 	prog_fd = bpf_program__fd(prog);
 	if (prog_fd < 0) {
 		pr_warn("prog '%s': can't attach BPF program w/o FD (did you load it?)\n",
 			prog->name);
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 	}
 
 	link = calloc(1, sizeof(*link));
 	if (!link)
-		return ERR_PTR(-ENOMEM);
+		return libbpf_err_ptr(-ENOMEM);
 	link->detach = &bpf_link__detach_perf_event;
 	link->fd = pfd;
 
@@ -10163,14 +10179,14 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
 		if (err == -EPROTO)
 			pr_warn("prog '%s': try add PERF_SAMPLE_CALLCHAIN to or remove exclude_callchain_[kernel|user] from pfd %d\n",
 				prog->name, pfd);
-		return ERR_PTR(err);
+		return libbpf_err_ptr(err);
 	}
 	if (ioctl(pfd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
 		err = -errno;
 		free(link);
 		pr_warn("prog '%s': failed to enable pfd %d: %s\n",
 			prog->name, pfd, libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
-		return ERR_PTR(err);
+		return libbpf_err_ptr(err);
 	}
 	return link;
 }
@@ -10294,16 +10310,16 @@ struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
 		pr_warn("prog '%s': failed to create %s '%s' perf event: %s\n",
 			prog->name, retprobe ? "kretprobe" : "kprobe", func_name,
 			libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
-		return ERR_PTR(pfd);
+		return libbpf_err_ptr(pfd);
 	}
 	link = bpf_program__attach_perf_event(prog, pfd);
-	if (IS_ERR(link)) {
+	err = libbpf_get_error(link);
+	if (err) {
 		close(pfd);
-		err = PTR_ERR(link);
 		pr_warn("prog '%s': failed to attach to %s '%s': %s\n",
 			prog->name, retprobe ? "kretprobe" : "kprobe", func_name,
 			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
-		return link;
+		return libbpf_err_ptr(err);
 	}
 	return link;
 }
@@ -10336,17 +10352,17 @@ struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
 			prog->name, retprobe ? "uretprobe" : "uprobe",
 			binary_path, func_offset,
 			libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
-		return ERR_PTR(pfd);
+		return libbpf_err_ptr(pfd);
 	}
 	link = bpf_program__attach_perf_event(prog, pfd);
-	if (IS_ERR(link)) {
+	err = libbpf_get_error(link);
+	if (err) {
 		close(pfd);
-		err = PTR_ERR(link);
 		pr_warn("prog '%s': failed to attach to %s '%s:0x%zx': %s\n",
 			prog->name, retprobe ? "uretprobe" : "uprobe",
 			binary_path, func_offset,
 			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
-		return link;
+		return libbpf_err_ptr(err);
 	}
 	return link;
 }
@@ -10414,16 +10430,16 @@ struct bpf_link *bpf_program__attach_tracepoint(struct bpf_program *prog,
 		pr_warn("prog '%s': failed to create tracepoint '%s/%s' perf event: %s\n",
 			prog->name, tp_category, tp_name,
 			libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
-		return ERR_PTR(pfd);
+		return libbpf_err_ptr(pfd);
 	}
 	link = bpf_program__attach_perf_event(prog, pfd);
-	if (IS_ERR(link)) {
+	err = libbpf_get_error(link);
+	if (err) {
 		close(pfd);
-		err = PTR_ERR(link);
 		pr_warn("prog '%s': failed to attach to tracepoint '%s/%s': %s\n",
 			prog->name, tp_category, tp_name,
 			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
-		return link;
+		return libbpf_err_ptr(err);
 	}
 	return link;
 }
@@ -10436,20 +10452,19 @@ static struct bpf_link *attach_tp(const struct bpf_sec_def *sec,
 
 	sec_name = strdup(prog->sec_name);
 	if (!sec_name)
-		return ERR_PTR(-ENOMEM);
+		return libbpf_err_ptr(-ENOMEM);
 
 	/* extract "tp/<category>/<name>" */
 	tp_cat = sec_name + sec->len;
 	tp_name = strchr(tp_cat, '/');
 	if (!tp_name) {
-		link = ERR_PTR(-EINVAL);
-		goto out;
+		free(sec_name);
+		return libbpf_err_ptr(-EINVAL);
 	}
 	*tp_name = '\0';
 	tp_name++;
 
 	link = bpf_program__attach_tracepoint(prog, tp_cat, tp_name);
-out:
 	free(sec_name);
 	return link;
 }
@@ -10464,12 +10479,12 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 	prog_fd = bpf_program__fd(prog);
 	if (prog_fd < 0) {
 		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 	}
 
 	link = calloc(1, sizeof(*link));
 	if (!link)
-		return ERR_PTR(-ENOMEM);
+		return libbpf_err_ptr(-ENOMEM);
 	link->detach = &bpf_link__detach_fd;
 
 	pfd = bpf_raw_tracepoint_open(tp_name, prog_fd);
@@ -10478,7 +10493,7 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 		free(link);
 		pr_warn("prog '%s': failed to attach to raw tracepoint '%s': %s\n",
 			prog->name, tp_name, libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
-		return ERR_PTR(pfd);
+		return libbpf_err_ptr(pfd);
 	}
 	link->fd = pfd;
 	return link;
@@ -10502,12 +10517,12 @@ static struct bpf_link *bpf_program__attach_btf_id(struct bpf_program *prog)
 	prog_fd = bpf_program__fd(prog);
 	if (prog_fd < 0) {
 		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 	}
 
 	link = calloc(1, sizeof(*link));
 	if (!link)
-		return ERR_PTR(-ENOMEM);
+		return libbpf_err_ptr(-ENOMEM);
 	link->detach = &bpf_link__detach_fd;
 
 	pfd = bpf_raw_tracepoint_open(NULL, prog_fd);
@@ -10516,7 +10531,7 @@ static struct bpf_link *bpf_program__attach_btf_id(struct bpf_program *prog)
 		free(link);
 		pr_warn("prog '%s': failed to attach: %s\n",
 			prog->name, libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
-		return ERR_PTR(pfd);
+		return libbpf_err_ptr(pfd);
 	}
 	link->fd = pfd;
 	return (struct bpf_link *)link;
@@ -10544,12 +10559,6 @@ static struct bpf_link *attach_lsm(const struct bpf_sec_def *sec,
 	return bpf_program__attach_lsm(prog);
 }
 
-static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
-				    struct bpf_program *prog)
-{
-	return bpf_program__attach_iter(prog, NULL);
-}
-
 static struct bpf_link *
 bpf_program__attach_fd(struct bpf_program *prog, int target_fd, int btf_id,
 		       const char *target_name)
@@ -10564,12 +10573,12 @@ bpf_program__attach_fd(struct bpf_program *prog, int target_fd, int btf_id,
 	prog_fd = bpf_program__fd(prog);
 	if (prog_fd < 0) {
 		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 	}
 
 	link = calloc(1, sizeof(*link));
 	if (!link)
-		return ERR_PTR(-ENOMEM);
+		return libbpf_err_ptr(-ENOMEM);
 	link->detach = &bpf_link__detach_fd;
 
 	attach_type = bpf_program__get_expected_attach_type(prog);
@@ -10580,7 +10589,7 @@ bpf_program__attach_fd(struct bpf_program *prog, int target_fd, int btf_id,
 		pr_warn("prog '%s': failed to attach to %s: %s\n",
 			prog->name, target_name,
 			libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
-		return ERR_PTR(link_fd);
+		return libbpf_err_ptr(link_fd);
 	}
 	link->fd = link_fd;
 	return link;
@@ -10613,19 +10622,19 @@ struct bpf_link *bpf_program__attach_freplace(struct bpf_program *prog,
 	if (!!target_fd != !!attach_func_name) {
 		pr_warn("prog '%s': supply none or both of target_fd and attach_func_name\n",
 			prog->name);
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 	}
 
 	if (prog->type != BPF_PROG_TYPE_EXT) {
 		pr_warn("prog '%s': only BPF_PROG_TYPE_EXT can attach as freplace",
 			prog->name);
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 	}
 
 	if (target_fd) {
 		btf_id = libbpf_find_prog_btf_id(attach_func_name, target_fd);
 		if (btf_id < 0)
-			return ERR_PTR(btf_id);
+			return libbpf_err_ptr(btf_id);
 
 		return bpf_program__attach_fd(prog, target_fd, btf_id, "freplace");
 	} else {
@@ -10647,7 +10656,7 @@ bpf_program__attach_iter(struct bpf_program *prog,
 	__u32 target_fd = 0;
 
 	if (!OPTS_VALID(opts, bpf_iter_attach_opts))
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 
 	link_create_opts.iter_info = OPTS_GET(opts, link_info, (void *)0);
 	link_create_opts.iter_info_len = OPTS_GET(opts, link_info_len, 0);
@@ -10655,12 +10664,12 @@ bpf_program__attach_iter(struct bpf_program *prog,
 	prog_fd = bpf_program__fd(prog);
 	if (prog_fd < 0) {
 		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 	}
 
 	link = calloc(1, sizeof(*link));
 	if (!link)
-		return ERR_PTR(-ENOMEM);
+		return libbpf_err_ptr(-ENOMEM);
 	link->detach = &bpf_link__detach_fd;
 
 	link_fd = bpf_link_create(prog_fd, target_fd, BPF_TRACE_ITER,
@@ -10670,19 +10679,25 @@ bpf_program__attach_iter(struct bpf_program *prog,
 		free(link);
 		pr_warn("prog '%s': failed to attach to iterator: %s\n",
 			prog->name, libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
-		return ERR_PTR(link_fd);
+		return libbpf_err_ptr(link_fd);
 	}
 	link->fd = link_fd;
 	return link;
 }
 
+static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
+				    struct bpf_program *prog)
+{
+	return bpf_program__attach_iter(prog, NULL);
+}
+
 struct bpf_link *bpf_program__attach(struct bpf_program *prog)
 {
 	const struct bpf_sec_def *sec_def;
 
 	sec_def = find_sec_def(prog->sec_name);
 	if (!sec_def || !sec_def->attach_fn)
-		return ERR_PTR(-ESRCH);
+		return libbpf_err_ptr(-ESRCH);
 
 	return sec_def->attach_fn(sec_def, prog);
 }
@@ -10705,11 +10720,11 @@ struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *map)
 	int err;
 
 	if (!bpf_map__is_struct_ops(map) || map->fd == -1)
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 
 	link = calloc(1, sizeof(*link));
 	if (!link)
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 
 	st_ops = map->st_ops;
 	for (i = 0; i < btf_vlen(st_ops->type); i++) {
@@ -10729,7 +10744,7 @@ struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *map)
 	if (err) {
 		err = -errno;
 		free(link);
-		return ERR_PTR(err);
+		return libbpf_err_ptr(err);
 	}
 
 	link->detach = bpf_link__detach_struct_ops;
@@ -10783,7 +10798,7 @@ bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 	}
 
 	ring_buffer_write_tail(header, data_tail);
-	return ret;
+	return libbpf_err(ret);
 }
 
 struct perf_buffer;
@@ -10936,7 +10951,7 @@ struct perf_buffer *perf_buffer__new(int map_fd, size_t page_cnt,
 	p.lost_cb = opts ? opts->lost_cb : NULL;
 	p.ctx = opts ? opts->ctx : NULL;
 
-	return __perf_buffer__new(map_fd, page_cnt, &p);
+	return libbpf_ptr(__perf_buffer__new(map_fd, page_cnt, &p));
 }
 
 struct perf_buffer *
@@ -10952,7 +10967,7 @@ perf_buffer__new_raw(int map_fd, size_t page_cnt,
 	p.cpus = opts->cpus;
 	p.map_keys = opts->map_keys;
 
-	return __perf_buffer__new(map_fd, page_cnt, &p);
+	return libbpf_ptr(__perf_buffer__new(map_fd, page_cnt, &p));
 }
 
 static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
@@ -11173,16 +11188,19 @@ int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms)
 	int i, cnt, err;
 
 	cnt = epoll_wait(pb->epoll_fd, pb->events, pb->cpu_cnt, timeout_ms);
+	if (cnt < 0)
+		return libbpf_err_errno(cnt);
+
 	for (i = 0; i < cnt; i++) {
 		struct perf_cpu_buf *cpu_buf = pb->events[i].data.ptr;
 
 		err = perf_buffer__process_records(pb, cpu_buf);
 		if (err) {
 			pr_warn("error while processing records: %d\n", err);
-			return err;
+			return libbpf_err(err);
 		}
 	}
-	return cnt < 0 ? -errno : cnt;
+	return cnt;
 }
 
 /* Return number of PERF_EVENT_ARRAY map slots set up by this perf_buffer
@@ -11203,11 +11221,11 @@ int perf_buffer__buffer_fd(const struct perf_buffer *pb, size_t buf_idx)
 	struct perf_cpu_buf *cpu_buf;
 
 	if (buf_idx >= pb->cpu_cnt)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	cpu_buf = pb->cpu_bufs[buf_idx];
 	if (!cpu_buf)
-		return -ENOENT;
+		return libbpf_err(-ENOENT);
 
 	return cpu_buf->fd;
 }
@@ -11225,11 +11243,11 @@ int perf_buffer__consume_buffer(struct perf_buffer *pb, size_t buf_idx)
 	struct perf_cpu_buf *cpu_buf;
 
 	if (buf_idx >= pb->cpu_cnt)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	cpu_buf = pb->cpu_bufs[buf_idx];
 	if (!cpu_buf)
-		return -ENOENT;
+		return libbpf_err(-ENOENT);
 
 	return perf_buffer__process_records(pb, cpu_buf);
 }
@@ -11247,7 +11265,7 @@ int perf_buffer__consume(struct perf_buffer *pb)
 		err = perf_buffer__process_records(pb, cpu_buf);
 		if (err) {
 			pr_warn("perf_buffer: failed to process records in buffer #%d: %d\n", i, err);
-			return err;
+			return libbpf_err(err);
 		}
 	}
 	return 0;
@@ -11359,13 +11377,13 @@ bpf_program__get_prog_info_linear(int fd, __u64 arrays)
 	void *ptr;
 
 	if (arrays >> BPF_PROG_INFO_LAST_ARRAY)
-		return ERR_PTR(-EINVAL);
+		return libbpf_err_ptr(-EINVAL);
 
 	/* step 1: get array dimensions */
 	err = bpf_obj_get_info_by_fd(fd, &info, &info_len);
 	if (err) {
 		pr_debug("can't get prog info: %s", strerror(errno));
-		return ERR_PTR(-EFAULT);
+		return libbpf_err_ptr(-EFAULT);
 	}
 
 	/* step 2: calculate total size of all arrays */
@@ -11397,7 +11415,7 @@ bpf_program__get_prog_info_linear(int fd, __u64 arrays)
 	data_len = roundup(data_len, sizeof(__u64));
 	info_linear = malloc(sizeof(struct bpf_prog_info_linear) + data_len);
 	if (!info_linear)
-		return ERR_PTR(-ENOMEM);
+		return libbpf_err_ptr(-ENOMEM);
 
 	/* step 4: fill data to info_linear->info */
 	info_linear->arrays = arrays;
@@ -11429,7 +11447,7 @@ bpf_program__get_prog_info_linear(int fd, __u64 arrays)
 	if (err) {
 		pr_debug("can't get prog info: %s", strerror(errno));
 		free(info_linear);
-		return ERR_PTR(-EFAULT);
+		return libbpf_err_ptr(-EFAULT);
 	}
 
 	/* step 6: verify the data */
@@ -11508,26 +11526,26 @@ int bpf_program__set_attach_target(struct bpf_program *prog,
 	int btf_obj_fd = 0, btf_id = 0, err;
 
 	if (!prog || attach_prog_fd < 0 || !attach_func_name)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (prog->obj->loaded)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (attach_prog_fd) {
 		btf_id = libbpf_find_prog_btf_id(attach_func_name,
 						 attach_prog_fd);
 		if (btf_id < 0)
-			return btf_id;
+			return libbpf_err(btf_id);
 	} else {
 		/* load btf_vmlinux, if not yet */
 		err = bpf_object__load_vmlinux_btf(prog->obj, true);
 		if (err)
-			return err;
+			return libbpf_err(err);
 		err = find_kernel_btf_id(prog->obj, attach_func_name,
 					 prog->expected_attach_type,
 					 &btf_obj_fd, &btf_id);
 		if (err)
-			return err;
+			return libbpf_err(err);
 	}
 
 	prog->attach_btf_id = btf_id;
@@ -11626,7 +11644,7 @@ int libbpf_num_possible_cpus(void)
 
 	err = parse_cpu_mask_file(fcpu, &mask, &n);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	tmp_cpus = 0;
 	for (i = 0; i < n; i++) {
@@ -11646,7 +11664,7 @@ int bpf_object__open_skeleton(struct bpf_object_skeleton *s,
 		.object_name = s->name,
 	);
 	struct bpf_object *obj;
-	int i;
+	int i, err;
 
 	/* Attempt to preserve opts->object_name, unless overriden by user
 	 * explicitly. Overwriting object name for skeletons is discouraged,
@@ -11661,10 +11679,11 @@ int bpf_object__open_skeleton(struct bpf_object_skeleton *s,
 	}
 
 	obj = bpf_object__open_mem(s->data, s->data_sz, &skel_opts);
-	if (IS_ERR(obj)) {
-		pr_warn("failed to initialize skeleton BPF object '%s': %ld\n",
-			s->name, PTR_ERR(obj));
-		return PTR_ERR(obj);
+	err = libbpf_get_error(obj);
+	if (err) {
+		pr_warn("failed to initialize skeleton BPF object '%s': %d\n",
+			s->name, err);
+		return libbpf_err(err);
 	}
 
 	*s->obj = obj;
@@ -11677,7 +11696,7 @@ int bpf_object__open_skeleton(struct bpf_object_skeleton *s,
 		*map = bpf_object__find_map_by_name(obj, name);
 		if (!*map) {
 			pr_warn("failed to find skeleton map '%s'\n", name);
-			return -ESRCH;
+			return libbpf_err(-ESRCH);
 		}
 
 		/* externs shouldn't be pre-setup from user code */
@@ -11692,7 +11711,7 @@ int bpf_object__open_skeleton(struct bpf_object_skeleton *s,
 		*prog = bpf_object__find_program_by_name(obj, name);
 		if (!*prog) {
 			pr_warn("failed to find skeleton program '%s'\n", name);
-			return -ESRCH;
+			return libbpf_err(-ESRCH);
 		}
 	}
 
@@ -11706,7 +11725,7 @@ int bpf_object__load_skeleton(struct bpf_object_skeleton *s)
 	err = bpf_object__load(*s->obj);
 	if (err) {
 		pr_warn("failed to load BPF skeleton '%s': %d\n", s->name, err);
-		return err;
+		return libbpf_err(err);
 	}
 
 	for (i = 0; i < s->map_cnt; i++) {
@@ -11745,7 +11764,7 @@ int bpf_object__load_skeleton(struct bpf_object_skeleton *s)
 			*mmaped = NULL;
 			pr_warn("failed to re-mmap() map '%s': %d\n",
 				 bpf_map__name(map), err);
-			return err;
+			return libbpf_err(err);
 		}
 	}
 
@@ -11754,7 +11773,7 @@ int bpf_object__load_skeleton(struct bpf_object_skeleton *s)
 
 int bpf_object__attach_skeleton(struct bpf_object_skeleton *s)
 {
-	int i;
+	int i, err;
 
 	for (i = 0; i < s->prog_cnt; i++) {
 		struct bpf_program *prog = *s->progs[i].prog;
@@ -11769,10 +11788,11 @@ int bpf_object__attach_skeleton(struct bpf_object_skeleton *s)
 			continue;
 
 		*link = sec_def->attach_fn(sec_def, prog);
-		if (IS_ERR(*link)) {
-			pr_warn("failed to auto-attach program '%s': %ld\n",
-				bpf_program__name(prog), PTR_ERR(*link));
-			return PTR_ERR(*link);
+		err = libbpf_get_error(*link);
+		if (err) {
+			pr_warn("failed to auto-attach program '%s': %d\n",
+				bpf_program__name(prog), err);
+			return libbpf_err(err);
 		}
 	}
 
diff --git a/tools/lib/bpf/libbpf_errno.c b/tools/lib/bpf/libbpf_errno.c
index 0afb51f7a919..96f67a772a1b 100644
--- a/tools/lib/bpf/libbpf_errno.c
+++ b/tools/lib/bpf/libbpf_errno.c
@@ -12,6 +12,7 @@
 #include <string.h>
 
 #include "libbpf.h"
+#include "libbpf_internal.h"
 
 /* make sure libbpf doesn't use kernel-only integer typedefs */
 #pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
@@ -39,7 +40,7 @@ static const char *libbpf_strerror_table[NR_ERRNO] = {
 int libbpf_strerror(int err, char *buf, size_t size)
 {
 	if (!buf || !size)
-		return -1;
+		return libbpf_err(-EINVAL);
 
 	err = err > 0 ? err : -err;
 
@@ -48,7 +49,7 @@ int libbpf_strerror(int err, char *buf, size_t size)
 
 		ret = strerror_r(err, buf, size);
 		buf[size - 1] = '\0';
-		return ret;
+		return libbpf_err_errno(ret);
 	}
 
 	if (err < __LIBBPF_ERRNO__END) {
@@ -62,5 +63,5 @@ int libbpf_strerror(int err, char *buf, size_t size)
 
 	snprintf(buf, size, "Unknown libbpf error %d", err);
 	buf[size - 1] = '\0';
-	return -1;
+	return libbpf_err(-ENOENT);
 }
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 04a0cc8da06e..ce9c1186b9a3 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -456,4 +456,31 @@ static inline int libbpf_err_errno(int ret)
 	return ret;
 }
 
+/* handle error for pointer-returning APIs, err is assumed to be < 0 always */
+static inline void *libbpf_err_ptr(int err)
+{
+	/* set errno on error, this doesn't break anything */
+	errno = -err;
+
+	if (libbpf_mode & LIBBPF_STRICT_CLEAN_PTRS)
+		return NULL;
+
+	/* legacy: encode err as ptr */
+	return ERR_PTR(err);
+}
+
+/* handle pointer-returning APIs' error handling */
+static inline void *libbpf_ptr(void *ret)
+{
+	/* set errno on error, this doesn't break anything */
+	if (IS_ERR(ret))
+		errno = -PTR_ERR(ret);
+
+	if (libbpf_mode & LIBBPF_STRICT_CLEAN_PTRS)
+		return IS_ERR(ret) ? NULL : ret;
+
+	/* legacy: pass-through original pointer */
+	return ret;
+}
+
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index b594a88620ce..7e6e8265551e 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -220,16 +220,16 @@ struct bpf_linker *bpf_linker__new(const char *filename, struct bpf_linker_opts
 	int err;
 
 	if (!OPTS_VALID(opts, bpf_linker_opts))
-		return NULL;
+		return errno = EINVAL, NULL;
 
 	if (elf_version(EV_CURRENT) == EV_NONE) {
 		pr_warn_elf("libelf initialization failed");
-		return NULL;
+		return errno = EINVAL, NULL;
 	}
 
 	linker = calloc(1, sizeof(*linker));
 	if (!linker)
-		return NULL;
+		return errno = ENOMEM, NULL;
 
 	linker->fd = -1;
 
@@ -241,7 +241,7 @@ struct bpf_linker *bpf_linker__new(const char *filename, struct bpf_linker_opts
 
 err_out:
 	bpf_linker__free(linker);
-	return NULL;
+	return errno = -err, NULL;
 }
 
 static struct dst_sec *add_dst_sec(struct bpf_linker *linker, const char *sec_name)
@@ -444,10 +444,10 @@ int bpf_linker__add_file(struct bpf_linker *linker, const char *filename,
 	int err = 0;
 
 	if (!OPTS_VALID(opts, bpf_linker_file_opts))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (!linker->elf)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	err = err ?: linker_load_obj_file(linker, filename, opts, &obj);
 	err = err ?: linker_append_sec_data(linker, &obj);
@@ -467,7 +467,7 @@ int bpf_linker__add_file(struct bpf_linker *linker, const char *filename,
 	if (obj.fd >= 0)
 		close(obj.fd);
 
-	return err;
+	return libbpf_err(err);
 }
 
 static bool is_dwarf_sec_name(const char *name)
@@ -2547,11 +2547,11 @@ int bpf_linker__finalize(struct bpf_linker *linker)
 	int err, i;
 
 	if (!linker->elf)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	err = finalize_btf(linker);
 	if (err)
-		return err;
+		return libbpf_err(err);
 
 	/* Finalize strings */
 	strs_sz = strset__data_size(linker->strtab_strs);
@@ -2583,14 +2583,14 @@ int bpf_linker__finalize(struct bpf_linker *linker)
 	if (elf_update(linker->elf, ELF_C_NULL) < 0) {
 		err = -errno;
 		pr_warn_elf("failed to finalize ELF layout");
-		return err;
+		return libbpf_err(err);
 	}
 
 	/* Write out final ELF contents */
 	if (elf_update(linker->elf, ELF_C_WRITE) < 0) {
 		err = -errno;
 		pr_warn_elf("failed to write ELF contents");
-		return err;
+		return libbpf_err(err);
 	}
 
 	elf_end(linker->elf);
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 47444588e0d2..d743c8721aa7 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -225,22 +225,26 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
 			     const struct bpf_xdp_set_link_opts *opts)
 {
-	int old_fd = -1;
+	int old_fd = -1, ret;
 
 	if (!OPTS_VALID(opts, bpf_xdp_set_link_opts))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (OPTS_HAS(opts, old_fd)) {
 		old_fd = OPTS_GET(opts, old_fd, -1);
 		flags |= XDP_FLAGS_REPLACE;
 	}
 
-	return __bpf_set_link_xdp_fd_replace(ifindex, fd, old_fd, flags);
+	ret = __bpf_set_link_xdp_fd_replace(ifindex, fd, old_fd, flags);
+	return libbpf_err(ret);
 }
 
 int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 {
-	return __bpf_set_link_xdp_fd_replace(ifindex, fd, 0, flags);
+	int ret;
+
+	ret = __bpf_set_link_xdp_fd_replace(ifindex, fd, 0, flags);
+	return libbpf_err(ret);
 }
 
 static int __dump_link_nlmsg(struct nlmsghdr *nlh,
@@ -321,13 +325,13 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 	};
 
 	if (flags & ~XDP_FLAGS_MASK || !info_size)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	/* Check whether the single {HW,DRV,SKB} mode is set */
 	flags &= (XDP_FLAGS_SKB_MODE | XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE);
 	mask = flags - 1;
 	if (flags && flags & mask)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	xdp_id.ifindex = ifindex;
 	xdp_id.flags = flags;
@@ -341,7 +345,7 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 		memset((void *) info + sz, 0, info_size - sz);
 	}
 
-	return ret;
+	return libbpf_err(ret);
 }
 
 static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
@@ -369,7 +373,7 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
 	if (!ret)
 		*prog_id = get_xdp_id(&info, flags);
 
-	return ret;
+	return libbpf_err(ret);
 }
 
 typedef int (*qdisc_config_t)(struct nlmsghdr *nh, struct tcmsg *t,
@@ -463,11 +467,14 @@ static int tc_qdisc_delete(struct bpf_tc_hook *hook)
 
 int bpf_tc_hook_create(struct bpf_tc_hook *hook)
 {
+	int ret;
+
 	if (!hook || !OPTS_VALID(hook, bpf_tc_hook) ||
 	    OPTS_GET(hook, ifindex, 0) <= 0)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
-	return tc_qdisc_create_excl(hook);
+	ret = tc_qdisc_create_excl(hook);
+	return libbpf_err(ret);
 }
 
 static int __bpf_tc_detach(const struct bpf_tc_hook *hook,
@@ -478,18 +485,18 @@ int bpf_tc_hook_destroy(struct bpf_tc_hook *hook)
 {
 	if (!hook || !OPTS_VALID(hook, bpf_tc_hook) ||
 	    OPTS_GET(hook, ifindex, 0) <= 0)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	switch (OPTS_GET(hook, attach_point, 0)) {
 	case BPF_TC_INGRESS:
 	case BPF_TC_EGRESS:
-		return __bpf_tc_detach(hook, NULL, true);
+		return libbpf_err(__bpf_tc_detach(hook, NULL, true));
 	case BPF_TC_INGRESS | BPF_TC_EGRESS:
-		return tc_qdisc_delete(hook);
+		return libbpf_err(tc_qdisc_delete(hook));
 	case BPF_TC_CUSTOM:
-		return -EOPNOTSUPP;
+		return libbpf_err(-EOPNOTSUPP);
 	default:
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 }
 
@@ -574,7 +581,7 @@ int bpf_tc_attach(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
 	if (!hook || !opts ||
 	    !OPTS_VALID(hook, bpf_tc_hook) ||
 	    !OPTS_VALID(opts, bpf_tc_opts))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	ifindex      = OPTS_GET(hook, ifindex, 0);
 	parent       = OPTS_GET(hook, parent, 0);
@@ -587,11 +594,11 @@ int bpf_tc_attach(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
 	flags        = OPTS_GET(opts, flags, 0);
 
 	if (ifindex <= 0 || !prog_fd || prog_id)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	if (priority > UINT16_MAX)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	if (flags & ~BPF_TC_F_REPLACE)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	flags = (flags & BPF_TC_F_REPLACE) ? NLM_F_REPLACE : NLM_F_EXCL;
 	protocol = ETH_P_ALL;
@@ -608,32 +615,32 @@ int bpf_tc_attach(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
 
 	ret = tc_get_tcm_parent(attach_point, &parent);
 	if (ret < 0)
-		return ret;
+		return libbpf_err(ret);
 	req.tc.tcm_parent = parent;
 
 	ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
 	if (ret < 0)
-		return ret;
+		return libbpf_err(ret);
 	nla = nlattr_begin_nested(&req.nh, sizeof(req), TCA_OPTIONS);
 	if (!nla)
-		return -EMSGSIZE;
+		return libbpf_err(-EMSGSIZE);
 	ret = tc_add_fd_and_name(&req.nh, sizeof(req), prog_fd);
 	if (ret < 0)
-		return ret;
+		return libbpf_err(ret);
 	bpf_flags = TCA_BPF_FLAG_ACT_DIRECT;
 	ret = nlattr_add(&req.nh, sizeof(req), TCA_BPF_FLAGS, &bpf_flags,
 			 sizeof(bpf_flags));
 	if (ret < 0)
-		return ret;
+		return libbpf_err(ret);
 	nlattr_end_nested(&req.nh, nla);
 
 	info.opts = opts;
 
 	ret = libbpf_netlink_send_recv(&req.nh, get_tc_info, NULL, &info);
 	if (ret < 0)
-		return ret;
+		return libbpf_err(ret);
 	if (!info.processed)
-		return -ENOENT;
+		return libbpf_err(-ENOENT);
 	return ret;
 }
 
@@ -708,7 +715,13 @@ static int __bpf_tc_detach(const struct bpf_tc_hook *hook,
 int bpf_tc_detach(const struct bpf_tc_hook *hook,
 		  const struct bpf_tc_opts *opts)
 {
-	return !opts ? -EINVAL : __bpf_tc_detach(hook, opts, false);
+	int ret;
+
+	if (!opts)
+		return libbpf_err(-EINVAL);
+
+	ret = __bpf_tc_detach(hook, opts, false);
+	return libbpf_err(ret);
 }
 
 int bpf_tc_query(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
@@ -725,7 +738,7 @@ int bpf_tc_query(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
 	if (!hook || !opts ||
 	    !OPTS_VALID(hook, bpf_tc_hook) ||
 	    !OPTS_VALID(opts, bpf_tc_opts))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	ifindex      = OPTS_GET(hook, ifindex, 0);
 	parent       = OPTS_GET(hook, parent, 0);
@@ -739,9 +752,9 @@ int bpf_tc_query(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
 
 	if (ifindex <= 0 || flags || prog_fd || prog_id ||
 	    !handle || !priority)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	if (priority > UINT16_MAX)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	protocol = ETH_P_ALL;
 
@@ -756,19 +769,19 @@ int bpf_tc_query(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
 
 	ret = tc_get_tcm_parent(attach_point, &parent);
 	if (ret < 0)
-		return ret;
+		return libbpf_err(ret);
 	req.tc.tcm_parent = parent;
 
 	ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
 	if (ret < 0)
-		return ret;
+		return libbpf_err(ret);
 
 	info.opts = opts;
 
 	ret = libbpf_netlink_send_recv(&req.nh, get_tc_info, NULL, &info);
 	if (ret < 0)
-		return ret;
+		return libbpf_err(ret);
 	if (!info.processed)
-		return -ENOENT;
+		return libbpf_err(-ENOENT);
 	return ret;
 }
diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index 1d80ad4e0de8..8bc117bcc7bc 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -69,23 +69,23 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 		err = -errno;
 		pr_warn("ringbuf: failed to get map info for fd=%d: %d\n",
 			map_fd, err);
-		return err;
+		return libbpf_err(err);
 	}
 
 	if (info.type != BPF_MAP_TYPE_RINGBUF) {
 		pr_warn("ringbuf: map fd=%d is not BPF_MAP_TYPE_RINGBUF\n",
 			map_fd);
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 	}
 
 	tmp = libbpf_reallocarray(rb->rings, rb->ring_cnt + 1, sizeof(*rb->rings));
 	if (!tmp)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 	rb->rings = tmp;
 
 	tmp = libbpf_reallocarray(rb->events, rb->ring_cnt + 1, sizeof(*rb->events));
 	if (!tmp)
-		return -ENOMEM;
+		return libbpf_err(-ENOMEM);
 	rb->events = tmp;
 
 	r = &rb->rings[rb->ring_cnt];
@@ -103,7 +103,7 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 		err = -errno;
 		pr_warn("ringbuf: failed to mmap consumer page for map fd=%d: %d\n",
 			map_fd, err);
-		return err;
+		return libbpf_err(err);
 	}
 	r->consumer_pos = tmp;
 
@@ -118,7 +118,7 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 		ringbuf_unmap_ring(rb, r);
 		pr_warn("ringbuf: failed to mmap data pages for map fd=%d: %d\n",
 			map_fd, err);
-		return err;
+		return libbpf_err(err);
 	}
 	r->producer_pos = tmp;
 	r->data = tmp + rb->page_size;
@@ -133,7 +133,7 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 		ringbuf_unmap_ring(rb, r);
 		pr_warn("ringbuf: failed to epoll add map fd=%d: %d\n",
 			map_fd, err);
-		return err;
+		return libbpf_err(err);
 	}
 
 	rb->ring_cnt++;
@@ -165,11 +165,11 @@ ring_buffer__new(int map_fd, ring_buffer_sample_fn sample_cb, void *ctx,
 	int err;
 
 	if (!OPTS_VALID(opts, ring_buffer_opts))
-		return NULL;
+		return errno = EINVAL, NULL;
 
 	rb = calloc(1, sizeof(*rb));
 	if (!rb)
-		return NULL;
+		return errno = ENOMEM, NULL;
 
 	rb->page_size = getpagesize();
 
@@ -188,7 +188,7 @@ ring_buffer__new(int map_fd, ring_buffer_sample_fn sample_cb, void *ctx,
 
 err_out:
 	ring_buffer__free(rb);
-	return NULL;
+	return errno = -err, NULL;
 }
 
 static inline int roundup_len(__u32 len)
@@ -260,7 +260,7 @@ int ring_buffer__consume(struct ring_buffer *rb)
 
 		err = ringbuf_process_ring(ring);
 		if (err < 0)
-			return err;
+			return libbpf_err(err);
 		res += err;
 	}
 	if (res > INT_MAX)
@@ -279,7 +279,7 @@ int ring_buffer__poll(struct ring_buffer *rb, int timeout_ms)
 
 	cnt = epoll_wait(rb->epoll_fd, rb->events, rb->ring_cnt, timeout_ms);
 	if (cnt < 0)
-		return -errno;
+		return libbpf_err(-errno);
 
 	for (i = 0; i < cnt; i++) {
 		__u32 ring_id = rb->events[i].data.fd;
@@ -287,7 +287,7 @@ int ring_buffer__poll(struct ring_buffer *rb, int timeout_ms)
 
 		err = ringbuf_process_ring(ring);
 		if (err < 0)
-			return err;
+			return libbpf_err(err);
 		res += err;
 	}
 	if (res > INT_MAX)
-- 
2.30.2

