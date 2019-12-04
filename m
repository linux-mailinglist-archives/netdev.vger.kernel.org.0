Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17DC5112322
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 08:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfLDHAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 02:00:39 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50014 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727154AbfLDHAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 02:00:35 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB46rol7024494
        for <netdev@vger.kernel.org>; Tue, 3 Dec 2019 23:00:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Mw4NsOzp8fqbY+x/0jHxQTYsSClbFieCRE32QQeu670=;
 b=j5ZhKAVwVOEditdqNQhDwqJQf2rlnhzTjC5v44S/OTqGQqwdjtHBM7rBqdAqwbaH7RSC
 ktaioIPdfZCI9dnAC4eZRSnfhnEFSQ0RKnYTeJYpI2O60Qk4q0niwa9/ciZr9rdGNYqg
 ZAM9uB9n+EC0BQzMWatCsHDa8m0b/OztYGM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wp1gx1n9q-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 23:00:33 -0800
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 3 Dec 2019 23:00:22 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 613AA2EC1853; Tue,  3 Dec 2019 23:00:20 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 01/16] libbpf: don't require root for bpf_object__open()
Date:   Tue, 3 Dec 2019 23:00:00 -0800
Message-ID: <20191204070015.3523523-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191204070015.3523523-1-andriin@fb.com>
References: <20191204070015.3523523-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_01:2019-12-04,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=25 bulkscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912040050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorganize bpf_object__open and bpf_object__load steps such that
bpf_object__open doesn't need root access. This was previously done for
feature probing and BTF sanitization. This doesn't have to happen on open,
though, so move all those steps into the load phase.

This is important, because it makes it possible for tools like bpftool, to
just open BPF object file and inspect their contents: programs, maps, BTF,
etc. For such operations it is prohibitive to require root access. On the
other hand, there is a lot of custom libbpf logic in those steps, so its best
avoided for tools to reimplement all that on their own.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 83 +++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 42 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3f09772192f1..1e29a47da4f5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -101,13 +101,6 @@ void libbpf_print(enum libbpf_print_level level, const char *format, ...)
 
 #define STRERR_BUFSIZE  128
 
-#define CHECK_ERR(action, err, out) do {	\
-	err = action;			\
-	if (err)			\
-		goto out;		\
-} while (0)
-
-
 /* Copied from tools/perf/util/util.h */
 #ifndef zfree
 # define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
@@ -864,8 +857,7 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 	def->value_size = data->d_size;
 	def->max_entries = 1;
 	def->map_flags = type == LIBBPF_MAP_RODATA ? BPF_F_RDONLY_PROG : 0;
-	if (obj->caps.array_mmap)
-		def->map_flags |= BPF_F_MMAPABLE;
+	def->map_flags |= BPF_F_MMAPABLE;
 
 	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu, flags %x.\n",
 		 map_name, map->sec_idx, map->sec_offset, def->map_flags);
@@ -888,8 +880,6 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
 {
 	int err;
 
-	if (!obj->caps.global_data)
-		return 0;
 	/*
 	 * Populate obj->maps with libbpf internal maps.
 	 */
@@ -1393,10 +1383,11 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 	return 0;
 }
 
-static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps,
-				 const char *pin_root_path)
+static int bpf_object__init_maps(struct bpf_object *obj,
+				 struct bpf_object_open_opts *opts)
 {
-	bool strict = !relaxed_maps;
+	const char *pin_root_path = OPTS_GET(opts, pin_root_path, NULL);
+	bool strict = !OPTS_GET(opts, relaxed_maps, false);
 	int err;
 
 	err = bpf_object__init_user_maps(obj, strict);
@@ -1592,8 +1583,7 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 	return 0;
 }
 
-static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
-				   const char *pin_root_path)
+static int bpf_object__elf_collect(struct bpf_object *obj)
 {
 	Elf *elf = obj->efile.elf;
 	GElf_Ehdr *ep = &obj->efile.ehdr;
@@ -1728,14 +1718,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
 		pr_warn("Corrupted ELF file: index of strtab invalid\n");
 		return -LIBBPF_ERRNO__FORMAT;
 	}
-	err = bpf_object__init_btf(obj, btf_data, btf_ext_data);
-	if (!err)
-		err = bpf_object__init_maps(obj, relaxed_maps, pin_root_path);
-	if (!err)
-		err = bpf_object__sanitize_and_load_btf(obj);
-	if (!err)
-		err = bpf_object__init_prog_names(obj);
-	return err;
+	return bpf_object__init_btf(obj, btf_data, btf_ext_data);
 }
 
 static struct bpf_program *
@@ -1875,11 +1858,6 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 		pr_warn("bad data relo against section %u\n", shdr_idx);
 		return -LIBBPF_ERRNO__RELOC;
 	}
-	if (!obj->caps.global_data) {
-		pr_warn("relocation: kernel does not support global \'%s\' variable access in insns[%d]\n",
-			name, insn_idx);
-		return -LIBBPF_ERRNO__RELOC;
-	}
 	for (map_idx = 0; map_idx < nr_maps; map_idx++) {
 		map = &obj->maps[map_idx];
 		if (map->libbpf_type != type)
@@ -3917,12 +3895,10 @@ static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   struct bpf_object_open_opts *opts)
 {
-	const char *pin_root_path;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	const char *obj_name;
 	char tmp_name[64];
-	bool relaxed_maps;
 	__u32 attach_prog_fd;
 	int err;
 
@@ -3952,16 +3928,16 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		return obj;
 
 	obj->relaxed_core_relocs = OPTS_GET(opts, relaxed_core_relocs, false);
-	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
-	pin_root_path = OPTS_GET(opts, pin_root_path, NULL);
 	attach_prog_fd = OPTS_GET(opts, attach_prog_fd, 0);
 
-	CHECK_ERR(bpf_object__elf_init(obj), err, out);
-	CHECK_ERR(bpf_object__check_endianness(obj), err, out);
-	CHECK_ERR(bpf_object__probe_caps(obj), err, out);
-	CHECK_ERR(bpf_object__elf_collect(obj, relaxed_maps, pin_root_path),
-		  err, out);
-	CHECK_ERR(bpf_object__collect_reloc(obj), err, out);
+	err = bpf_object__elf_init(obj);
+	err = err ? : bpf_object__check_endianness(obj);
+	err = err ? : bpf_object__elf_collect(obj);
+	err = err ? : bpf_object__init_maps(obj, opts);
+	err = err ? : bpf_object__init_prog_names(obj);
+	err = err ? : bpf_object__collect_reloc(obj);
+	if (err)
+		goto out;
 	bpf_object__elf_finish(obj);
 
 	bpf_object__for_each_program(prog, obj) {
@@ -4079,6 +4055,24 @@ int bpf_object__unload(struct bpf_object *obj)
 	return 0;
 }
 
+static int bpf_object__sanitize_maps(struct bpf_object *obj)
+{
+	struct bpf_map *m;
+
+	bpf_object__for_each_map(m, obj) {
+		if (!bpf_map__is_internal(m))
+			continue;
+		if (!obj->caps.global_data) {
+			pr_warn("kernel doesn't support global data\n");
+			return -ENOTSUP;
+		}
+		if (!obj->caps.array_mmap)
+			m->def.map_flags ^= BPF_F_MMAPABLE;
+	}
+
+	return 0;
+}
+
 int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 {
 	struct bpf_object *obj;
@@ -4097,9 +4091,14 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 
 	obj->loaded = true;
 
-	CHECK_ERR(bpf_object__create_maps(obj), err, out);
-	CHECK_ERR(bpf_object__relocate(obj, attr->target_btf_path), err, out);
-	CHECK_ERR(bpf_object__load_progs(obj, attr->log_level), err, out);
+	err = bpf_object__probe_caps(obj);
+	err = err ? : bpf_object__sanitize_and_load_btf(obj);
+	err = err ? : bpf_object__sanitize_maps(obj);
+	err = err ? : bpf_object__create_maps(obj);
+	err = err ? : bpf_object__relocate(obj, attr->target_btf_path);
+	err = err ? : bpf_object__load_progs(obj, attr->log_level);
+	if (err)
+		goto out;
 
 	return 0;
 out:
-- 
2.17.1

