Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB30813508F
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgAIAfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 19:35:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57924 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727746AbgAIAfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 19:35:45 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0090YpxX029975
        for <netdev@vger.kernel.org>; Wed, 8 Jan 2020 16:35:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=gKp5jvv6g16M0WE4VsQP3zN9tLOdz8ZJy21QQ7R8Spg=;
 b=m83j+vK0yOm6W7bY7ACXvT2lADzmiRrAjy02XbW3Y/nfCcTtG55Orgo3Jyhjiaoo/vuW
 mG4c0EuV7J9hQlM7FfOhElB1KxYHmVNSNrnsGUqrpg3haZEEBl12vNLmMpjZm9JAHa7w
 45SK23HUOun6UeN4L1BusVVJuKyGzxM+zpY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xdcnqm57a-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 16:35:43 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 8 Jan 2020 16:35:16 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id EF18B2942576; Wed,  8 Jan 2020 16:35:14 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 10/11] bpf: libbpf: Add STRUCT_OPS support
Date:   Wed, 8 Jan 2020 16:35:14 -0800
Message-ID: <20200109003514.3856730-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200109003453.3854769-1-kafai@fb.com>
References: <20200109003453.3854769-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_07:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 spamscore=0 impostorscore=0 malwarescore=0 suspectscore=43
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001090003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds BPF STRUCT_OPS support to libbpf.

The only sec_name convention is SEC(".struct_ops") to identify the
struct_ops implemented in BPF,
e.g. To implement a tcp_congestion_ops:

SEC(".struct_ops")
struct tcp_congestion_ops dctcp = {
	.init           = (void *)dctcp_init,  /* <-- a bpf_prog */
	/* ... some more func prts ... */
	.name           = "bpf_dctcp",
};

Each struct_ops is defined as a global variable under SEC(".struct_ops")
as above.  libbpf creates a map for each variable and the variable name
is the map's name.  Multiple struct_ops is supported under
SEC(".struct_ops").

In the bpf_object__open phase, libbpf will look for the SEC(".struct_ops")
section and find out what is the btf-type the struct_ops is
implementing.  Note that the btf-type here is referring to
a type in the bpf_prog.o's btf.  A "struct bpf_map" is added
by bpf_object__add_map() as other maps do.  It will then
collect (through SHT_REL) where are the bpf progs that the
func ptrs are referring to.  No btf_vmlinux is needed in
the open phase.

In the bpf_object__load phase, the map-fields, which depend
on the btf_vmlinux, are initialized (in bpf_map__init_kern_struct_ops()).
It will also set the prog->type, prog->attach_btf_id, and
prog->expected_attach_type.  Thus, the prog's properties do
not rely on its section name.
[ Currently, the bpf_prog's btf-type ==> btf_vmlinux's btf-type matching
  process is as simple as: member-name match + btf-kind match + size match.
  If these matching conditions fail, libbpf will reject.
  The current targeting support is "struct tcp_congestion_ops" which
  most of its members are function pointers.
  The member ordering of the bpf_prog's btf-type can be different from
  the btf_vmlinux's btf-type. ]

Then, all obj->maps are created as usual (in bpf_object__create_maps()).

Once the maps are created and prog's properties are all set,
the libbpf will proceed to load all the progs.

bpf_map__attach_struct_ops() is added to register a struct_ops
map to a kernel subsystem.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/bpf.c           |  10 +-
 tools/lib/bpf/bpf.h           |   5 +-
 tools/lib/bpf/libbpf.c        | 649 +++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.h        |   5 +-
 tools/lib/bpf/libbpf.map      |   3 +
 tools/lib/bpf/libbpf_probes.c |   2 +
 6 files changed, 661 insertions(+), 13 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index a787d53699c8..b0ecbe9ef2d4 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -95,7 +95,11 @@ int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr)
 	attr.btf_key_type_id = create_attr->btf_key_type_id;
 	attr.btf_value_type_id = create_attr->btf_value_type_id;
 	attr.map_ifindex = create_attr->map_ifindex;
-	attr.inner_map_fd = create_attr->inner_map_fd;
+	if (attr.map_type == BPF_MAP_TYPE_STRUCT_OPS)
+		attr.btf_vmlinux_value_type_id =
+			create_attr->btf_vmlinux_value_type_id;
+	else
+		attr.inner_map_fd = create_attr->inner_map_fd;
 
 	return sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
 }
@@ -228,7 +232,9 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_type = load_attr->prog_type;
 	attr.expected_attach_type = load_attr->expected_attach_type;
-	if (attr.prog_type == BPF_PROG_TYPE_TRACING) {
+	if (attr.prog_type == BPF_PROG_TYPE_STRUCT_OPS) {
+		attr.attach_btf_id = load_attr->attach_btf_id;
+	} else if (attr.prog_type == BPF_PROG_TYPE_TRACING) {
 		attr.attach_btf_id = load_attr->attach_btf_id;
 		attr.attach_prog_fd = load_attr->attach_prog_fd;
 	} else {
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index f0ab8519986e..56341d117e5b 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -46,7 +46,10 @@ struct bpf_create_map_attr {
 	__u32 btf_key_type_id;
 	__u32 btf_value_type_id;
 	__u32 map_ifindex;
-	__u32 inner_map_fd;
+	union {
+		__u32 inner_map_fd;
+		__u32 btf_vmlinux_value_type_id;
+	};
 };
 
 LIBBPF_API int
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7513165b104f..35a4422ef655 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -70,6 +70,13 @@
 
 #define __printf(a, b)	__attribute__((format(printf, a, b)))
 
+static struct btf *bpf_find_kernel_btf(void);
+static struct bpf_map *bpf_object__add_map(struct bpf_object *obj);
+static struct bpf_program *bpf_object__find_prog_by_idx(struct bpf_object *obj,
+							int idx);
+static const struct btf_type *
+skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id);
+
 static int __base_pr(enum libbpf_print_level level, const char *format,
 		     va_list args)
 {
@@ -229,10 +236,32 @@ struct bpf_program {
 	__u32 prog_flags;
 };
 
+struct bpf_struct_ops {
+	const char *tname;
+	const struct btf_type *type;
+	struct bpf_program **progs;
+	__u32 *kern_func_off;
+	/* e.g. struct tcp_congestion_ops in bpf_prog's btf format */
+	void *data;
+	/* e.g. struct bpf_struct_ops_tcp_congestion_ops in
+	 *      btf_vmlinux's format.
+	 * struct bpf_struct_ops_tcp_congestion_ops {
+	 *	[... some other kernel fields ...]
+	 *	struct tcp_congestion_ops data;
+	 * }
+	 * kern_vdata-size == sizeof(struct bpf_struct_ops_tcp_congestion_ops)
+	 * bpf_map__init_kern_struct_ops() will populate the "kern_vdata"
+	 * from "data".
+	 */
+	void *kern_vdata;
+	__u32 type_id;
+};
+
 #define DATA_SEC ".data"
 #define BSS_SEC ".bss"
 #define RODATA_SEC ".rodata"
 #define KCONFIG_SEC ".kconfig"
+#define STRUCT_OPS_SEC ".struct_ops"
 
 enum libbpf_map_type {
 	LIBBPF_MAP_UNSPEC,
@@ -259,10 +288,12 @@ struct bpf_map {
 	struct bpf_map_def def;
 	__u32 btf_key_type_id;
 	__u32 btf_value_type_id;
+	__u32 btf_vmlinux_value_type_id;
 	void *priv;
 	bpf_map_clear_priv_t clear_priv;
 	enum libbpf_map_type libbpf_type;
 	void *mmaped;
+	struct bpf_struct_ops *st_ops;
 	char *pin_path;
 	bool pinned;
 	bool reused;
@@ -326,6 +357,7 @@ struct bpf_object {
 		Elf_Data *data;
 		Elf_Data *rodata;
 		Elf_Data *bss;
+		Elf_Data *st_ops_data;
 		size_t strtabidx;
 		struct {
 			GElf_Shdr shdr;
@@ -339,6 +371,7 @@ struct bpf_object {
 		int data_shndx;
 		int rodata_shndx;
 		int bss_shndx;
+		int st_ops_shndx;
 	} efile;
 	/*
 	 * All loaded bpf_object is linked in a list, which is
@@ -566,6 +599,359 @@ static __u32 get_kernel_version(void)
 	return KERNEL_VERSION(major, minor, patch);
 }
 
+static const struct btf_member *
+find_member_by_offset(const struct btf_type *t, __u32 bit_offset)
+{
+	struct btf_member *m;
+	int i;
+
+	for (i = 0, m = btf_members(t); i < btf_vlen(t); i++, m++) {
+		if (btf_member_bit_offset(t, i) == bit_offset)
+			return m;
+	}
+
+	return NULL;
+}
+
+static const struct btf_member *
+find_member_by_name(const struct btf *btf, const struct btf_type *t,
+		    const char *name)
+{
+	struct btf_member *m;
+	int i;
+
+	for (i = 0, m = btf_members(t); i < btf_vlen(t); i++, m++) {
+		if (!strcmp(btf__name_by_offset(btf, m->name_off), name))
+			return m;
+	}
+
+	return NULL;
+}
+
+#define STRUCT_OPS_VALUE_PREFIX "bpf_struct_ops_"
+#define STRUCT_OPS_VALUE_PREFIX_LEN (sizeof(STRUCT_OPS_VALUE_PREFIX) - 1)
+
+static int
+find_struct_ops_kern_types(const struct btf *btf, const char *tname,
+			   const struct btf_type **type, __u32 *type_id,
+			   const struct btf_type **vtype, __u32 *vtype_id,
+			   const struct btf_member **data_member)
+{
+	const struct btf_type *kern_type, *kern_vtype;
+	const struct btf_member *kern_data_member;
+	__s32 kern_vtype_id, kern_type_id;
+	char vtname[128] = STRUCT_OPS_VALUE_PREFIX;
+	__u32 i;
+
+	kern_type_id = btf__find_by_name_kind(btf, tname, BTF_KIND_STRUCT);
+	if (kern_type_id < 0) {
+		pr_warn("struct_ops init_kern: struct %s is not found in kernel BTF\n",
+			tname);
+		return kern_type_id;
+	}
+	kern_type = btf__type_by_id(btf, kern_type_id);
+
+	/* Find the corresponding "map_value" type that will be used
+	 * in map_update(BPF_MAP_TYPE_STRUCT_OPS).  For example,
+	 * find "struct bpf_struct_ops_tcp_congestion_ops" from the
+	 * btf_vmlinux.
+	 */
+	strncat(vtname + STRUCT_OPS_VALUE_PREFIX_LEN, tname,
+		sizeof(vtname) - STRUCT_OPS_VALUE_PREFIX_LEN - 1);
+	kern_vtype_id = btf__find_by_name_kind(btf, vtname,
+					       BTF_KIND_STRUCT);
+	if (kern_vtype_id < 0) {
+		pr_warn("struct_ops init_kern: struct %s is not found in kernel BTF\n",
+			vtname);
+		return kern_vtype_id;
+	}
+	kern_vtype = btf__type_by_id(btf, kern_vtype_id);
+
+	/* Find "struct tcp_congestion_ops" from
+	 * struct bpf_struct_ops_tcp_congestion_ops {
+	 *	[ ... ]
+	 *	struct tcp_congestion_ops data;
+	 * }
+	 */
+	kern_data_member = btf_members(kern_vtype);
+	for (i = 0; i < btf_vlen(kern_vtype); i++, kern_data_member++) {
+		if (kern_data_member->type == kern_type_id)
+			break;
+	}
+	if (i == btf_vlen(kern_vtype)) {
+		pr_warn("struct_ops init_kern: struct %s data is not found in struct %s\n",
+			tname, vtname);
+		return -EINVAL;
+	}
+
+	*type = kern_type;
+	*type_id = kern_type_id;
+	*vtype = kern_vtype;
+	*vtype_id = kern_vtype_id;
+	*data_member = kern_data_member;
+
+	return 0;
+}
+
+static bool bpf_map__is_struct_ops(const struct bpf_map *map)
+{
+	return map->def.type == BPF_MAP_TYPE_STRUCT_OPS;
+}
+
+/* Init the map's fields that depend on kern_btf */
+static int bpf_map__init_kern_struct_ops(struct bpf_map *map,
+					 const struct btf *btf,
+					 const struct btf *kern_btf)
+{
+	const struct btf_member *member, *kern_member, *kern_data_member;
+	const struct btf_type *type, *kern_type, *kern_vtype;
+	__u32 i, kern_type_id, kern_vtype_id, kern_data_off;
+	struct bpf_struct_ops *st_ops;
+	void *data, *kern_data;
+	const char *tname;
+	int err;
+
+	st_ops = map->st_ops;
+	type = st_ops->type;
+	tname = st_ops->tname;
+	err = find_struct_ops_kern_types(kern_btf, tname,
+					 &kern_type, &kern_type_id,
+					 &kern_vtype, &kern_vtype_id,
+					 &kern_data_member);
+	if (err)
+		return err;
+
+	pr_debug("struct_ops init_kern %s: type_id:%u kern_type_id:%u kern_vtype_id:%u\n",
+		 map->name, st_ops->type_id, kern_type_id, kern_vtype_id);
+
+	map->def.value_size = kern_vtype->size;
+	map->btf_vmlinux_value_type_id = kern_vtype_id;
+
+	st_ops->kern_vdata = calloc(1, kern_vtype->size);
+	if (!st_ops->kern_vdata)
+		return -ENOMEM;
+
+	data = st_ops->data;
+	kern_data_off = kern_data_member->offset / 8;
+	kern_data = st_ops->kern_vdata + kern_data_off;
+
+	member = btf_members(type);
+	for (i = 0; i < btf_vlen(type); i++, member++) {
+		const struct btf_type *mtype, *kern_mtype;
+		__u32 mtype_id, kern_mtype_id;
+		void *mdata, *kern_mdata;
+		__s64 msize, kern_msize;
+		__u32 moff, kern_moff;
+		__u32 kern_member_idx;
+		const char *mname;
+
+		mname = btf__name_by_offset(btf, member->name_off);
+		kern_member = find_member_by_name(kern_btf, kern_type, mname);
+		if (!kern_member) {
+			pr_warn("struct_ops init_kern %s: Cannot find member %s in kernel BTF\n",
+				map->name, mname);
+			return -ENOTSUP;
+		}
+
+		kern_member_idx = kern_member - btf_members(kern_type);
+		if (btf_member_bitfield_size(type, i) ||
+		    btf_member_bitfield_size(kern_type, kern_member_idx)) {
+			pr_warn("struct_ops init_kern %s: bitfield %s is not supported\n",
+				map->name, mname);
+			return -ENOTSUP;
+		}
+
+		moff = member->offset / 8;
+		kern_moff = kern_member->offset / 8;
+
+		mdata = data + moff;
+		kern_mdata = kern_data + kern_moff;
+
+		mtype = skip_mods_and_typedefs(btf, member->type, &mtype_id);
+		kern_mtype = skip_mods_and_typedefs(kern_btf, kern_member->type,
+						    &kern_mtype_id);
+		if (BTF_INFO_KIND(mtype->info) !=
+		    BTF_INFO_KIND(kern_mtype->info)) {
+			pr_warn("struct_ops init_kern %s: Unmatched member type %s %u != %u(kernel)\n",
+				map->name, mname, BTF_INFO_KIND(mtype->info),
+				BTF_INFO_KIND(kern_mtype->info));
+			return -ENOTSUP;
+		}
+
+		if (btf_is_ptr(mtype)) {
+			struct bpf_program *prog;
+
+			mtype = skip_mods_and_typedefs(btf, mtype->type, &mtype_id);
+			kern_mtype = skip_mods_and_typedefs(kern_btf,
+							    kern_mtype->type,
+							    &kern_mtype_id);
+			if (!btf_is_func_proto(mtype) ||
+			    !btf_is_func_proto(kern_mtype)) {
+				pr_warn("struct_ops init_kern %s: non func ptr %s is not supported\n",
+					map->name, mname);
+				return -ENOTSUP;
+			}
+
+			prog = st_ops->progs[i];
+			if (!prog) {
+				pr_debug("struct_ops init_kern %s: func ptr %s is not set\n",
+					 map->name, mname);
+				continue;
+			}
+
+			prog->attach_btf_id = kern_type_id;
+			prog->expected_attach_type = kern_member_idx;
+
+			st_ops->kern_func_off[i] = kern_data_off + kern_moff;
+
+			pr_debug("struct_ops init_kern %s: func ptr %s is set to prog %s from data(+%u) to kern_data(+%u)\n",
+				 map->name, mname, prog->name, moff,
+				 kern_moff);
+
+			continue;
+		}
+
+		msize = btf__resolve_size(btf, mtype_id);
+		kern_msize = btf__resolve_size(kern_btf, kern_mtype_id);
+		if (msize < 0 || kern_msize < 0 || msize != kern_msize) {
+			pr_warn("struct_ops init_kern %s: Error in size of member %s: %zd != %zd(kernel)\n",
+				map->name, mname, (ssize_t)msize,
+				(ssize_t)kern_msize);
+			return -ENOTSUP;
+		}
+
+		pr_debug("struct_ops init_kern %s: copy %s %u bytes from data(+%u) to kern_data(+%u)\n",
+			 map->name, mname, (unsigned int)msize,
+			 moff, kern_moff);
+		memcpy(kern_mdata, mdata, msize);
+	}
+
+	return 0;
+}
+
+static int bpf_object__init_kern_struct_ops_maps(struct bpf_object *obj)
+{
+	struct btf *kern_btf = NULL;
+	struct bpf_map *map;
+	size_t i;
+	int err;
+
+	for (i = 0; i < obj->nr_maps; i++) {
+		map = &obj->maps[i];
+
+		if (!bpf_map__is_struct_ops(map))
+			continue;
+
+		if (!kern_btf) {
+			kern_btf = bpf_find_kernel_btf();
+			if (IS_ERR(kern_btf))
+				return PTR_ERR(kern_btf);
+		}
+
+		err = bpf_map__init_kern_struct_ops(map, obj->btf, kern_btf);
+		if (err) {
+			btf__free(kern_btf);
+			return err;
+		}
+	}
+
+	btf__free(kern_btf);
+	return 0;
+}
+
+static int bpf_object__init_struct_ops_maps(struct bpf_object *obj)
+{
+	const struct btf_type *type, *datasec;
+	const struct btf_var_secinfo *vsi;
+	struct bpf_struct_ops *st_ops;
+	const char *tname, *var_name;
+	__s32 type_id, datasec_id;
+	const struct btf *btf;
+	struct bpf_map *map;
+	__u32 i;
+
+	if (obj->efile.st_ops_shndx == -1)
+		return 0;
+
+	btf = obj->btf;
+	datasec_id = btf__find_by_name_kind(btf, STRUCT_OPS_SEC,
+					    BTF_KIND_DATASEC);
+	if (datasec_id < 0) {
+		pr_warn("struct_ops init: DATASEC %s not found\n",
+			STRUCT_OPS_SEC);
+		return -EINVAL;
+	}
+
+	datasec = btf__type_by_id(btf, datasec_id);
+	vsi = btf_var_secinfos(datasec);
+	for (i = 0; i < btf_vlen(datasec); i++, vsi++) {
+		type = btf__type_by_id(obj->btf, vsi->type);
+		var_name = btf__name_by_offset(obj->btf, type->name_off);
+
+		type_id = btf__resolve_type(obj->btf, vsi->type);
+		if (type_id < 0) {
+			pr_warn("struct_ops init: Cannot resolve var type_id %u in DATASEC %s\n",
+				vsi->type, STRUCT_OPS_SEC);
+			return -EINVAL;
+		}
+
+		type = btf__type_by_id(obj->btf, type_id);
+		tname = btf__name_by_offset(obj->btf, type->name_off);
+		if (!tname[0]) {
+			pr_warn("struct_ops init: anonymous type is not supported\n");
+			return -ENOTSUP;
+		}
+		if (!btf_is_struct(type)) {
+			pr_warn("struct_ops init: %s is not a struct\n", tname);
+			return -EINVAL;
+		}
+
+		map = bpf_object__add_map(obj);
+		if (IS_ERR(map))
+			return PTR_ERR(map);
+
+		map->sec_idx = obj->efile.st_ops_shndx;
+		map->sec_offset = vsi->offset;
+		map->name = strdup(var_name);
+		if (!map->name)
+			return -ENOMEM;
+
+		map->def.type = BPF_MAP_TYPE_STRUCT_OPS;
+		map->def.key_size = sizeof(int);
+		map->def.value_size = type->size;
+		map->def.max_entries = 1;
+
+		map->st_ops = calloc(1, sizeof(*map->st_ops));
+		if (!map->st_ops)
+			return -ENOMEM;
+		st_ops = map->st_ops;
+		st_ops->data = malloc(type->size);
+		st_ops->progs = calloc(btf_vlen(type), sizeof(*st_ops->progs));
+		st_ops->kern_func_off = malloc(btf_vlen(type) *
+					       sizeof(*st_ops->kern_func_off));
+		if (!st_ops->data || !st_ops->progs || !st_ops->kern_func_off)
+			return -ENOMEM;
+
+		if (vsi->offset + type->size > obj->efile.st_ops_data->d_size) {
+			pr_warn("struct_ops init: var %s is beyond the end of DATASEC %s\n",
+				var_name, STRUCT_OPS_SEC);
+			return -EINVAL;
+		}
+
+		memcpy(st_ops->data,
+		       obj->efile.st_ops_data->d_buf + vsi->offset,
+		       type->size);
+		st_ops->tname = tname;
+		st_ops->type = type;
+		st_ops->type_id = type_id;
+
+		pr_debug("struct_ops init: struct %s(type_id=%u) %s found at offset %u\n",
+			 tname, type_id, var_name, vsi->offset);
+	}
+
+	return 0;
+}
+
 static struct bpf_object *bpf_object__new(const char *path,
 					  const void *obj_buf,
 					  size_t obj_buf_sz,
@@ -607,6 +993,7 @@ static struct bpf_object *bpf_object__new(const char *path,
 	obj->efile.data_shndx = -1;
 	obj->efile.rodata_shndx = -1;
 	obj->efile.bss_shndx = -1;
+	obj->efile.st_ops_shndx = -1;
 	obj->kconfig_map_idx = -1;
 
 	obj->kern_version = get_kernel_version();
@@ -630,6 +1017,7 @@ static void bpf_object__elf_finish(struct bpf_object *obj)
 	obj->efile.data = NULL;
 	obj->efile.rodata = NULL;
 	obj->efile.bss = NULL;
+	obj->efile.st_ops_data = NULL;
 
 	zfree(&obj->efile.reloc_sects);
 	obj->efile.nr_reloc_sects = 0;
@@ -815,6 +1203,9 @@ int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 	} else if (!strcmp(name, RODATA_SEC)) {
 		if (obj->efile.rodata)
 			*size = obj->efile.rodata->d_size;
+	} else if (!strcmp(name, STRUCT_OPS_SEC)) {
+		if (obj->efile.st_ops_data)
+			*size = obj->efile.st_ops_data->d_size;
 	} else {
 		ret = bpf_object_search_section_size(obj, name, &d_size);
 		if (!ret)
@@ -1440,6 +1831,20 @@ skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)
 	return t;
 }
 
+static const struct btf_type *
+resolve_func_ptr(const struct btf *btf, __u32 id, __u32 *res_id)
+{
+	const struct btf_type *t;
+
+	t = skip_mods_and_typedefs(btf, id, NULL);
+	if (!btf_is_ptr(t))
+		return NULL;
+
+	t = skip_mods_and_typedefs(btf, t->type, res_id);
+
+	return btf_is_func_proto(t) ? t : NULL;
+}
+
 /*
  * Fetch integer attribute of BTF map definition. Such attributes are
  * represented using a pointer to an array, in which dimensionality of array
@@ -1787,6 +2192,7 @@ static int bpf_object__init_maps(struct bpf_object *obj,
 	err = err ?: bpf_object__init_user_btf_maps(obj, strict, pin_root_path);
 	err = err ?: bpf_object__init_global_data_maps(obj);
 	err = err ?: bpf_object__init_kconfig_map(obj);
+	err = err ?: bpf_object__init_struct_ops_maps(obj);
 	if (err)
 		return err;
 
@@ -1889,7 +2295,8 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
 static bool bpf_object__is_btf_mandatory(const struct bpf_object *obj)
 {
 	return obj->efile.btf_maps_shndx >= 0 ||
-	       obj->nr_extern > 0;
+		obj->efile.st_ops_shndx >= 0 ||
+		obj->nr_extern > 0;
 }
 
 static int bpf_object__init_btf(struct bpf_object *obj,
@@ -2088,6 +2495,9 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 			} else if (strcmp(name, RODATA_SEC) == 0) {
 				obj->efile.rodata = data;
 				obj->efile.rodata_shndx = idx;
+			} else if (strcmp(name, STRUCT_OPS_SEC) == 0) {
+				obj->efile.st_ops_data = data;
+				obj->efile.st_ops_shndx = idx;
 			} else {
 				pr_debug("skip section(%d) %s\n", idx, name);
 			}
@@ -2097,7 +2507,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 			int sec = sh.sh_info; /* points to other section */
 
 			/* Only do relo for section with exec instructions */
-			if (!section_have_execinstr(obj, sec)) {
+			if (!section_have_execinstr(obj, sec) &&
+			    strcmp(name, ".rel" STRUCT_OPS_SEC)) {
 				pr_debug("skip relo %s(%d) for section(%d)\n",
 					 name, idx, sec);
 				continue;
@@ -2599,8 +3010,12 @@ static int bpf_map_find_btf_info(struct bpf_object *obj, struct bpf_map *map)
 	__u32 key_type_id = 0, value_type_id = 0;
 	int ret;
 
-	/* if it's BTF-defined map, we don't need to search for type IDs */
-	if (map->sec_idx == obj->efile.btf_maps_shndx)
+	/* if it's BTF-defined map, we don't need to search for type IDs.
+	 * For struct_ops map, it does not need btf_key_type_id and
+	 * btf_value_type_id.
+	 */
+	if (map->sec_idx == obj->efile.btf_maps_shndx ||
+	    bpf_map__is_struct_ops(map))
 		return 0;
 
 	if (!bpf_map__is_internal(map)) {
@@ -3025,6 +3440,9 @@ bpf_object__create_maps(struct bpf_object *obj)
 		if (bpf_map_type__is_map_in_map(def->type) &&
 		    map->inner_map_fd >= 0)
 			create_attr.inner_map_fd = map->inner_map_fd;
+		if (bpf_map__is_struct_ops(map))
+			create_attr.btf_vmlinux_value_type_id =
+				map->btf_vmlinux_value_type_id;
 
 		if (obj->btf && !bpf_map_find_btf_info(obj, map)) {
 			create_attr.btf_fd = btf__fd(obj->btf);
@@ -3899,7 +4317,7 @@ static struct btf *btf_load_raw(const char *path)
  * Probe few well-known locations for vmlinux kernel image and try to load BTF
  * data out of it to use for target BTF.
  */
-static struct btf *bpf_core_find_kernel_btf(void)
+static struct btf *bpf_find_kernel_btf(void)
 {
 	struct {
 		const char *path_fmt;
@@ -4180,7 +4598,7 @@ bpf_core_reloc_fields(struct bpf_object *obj, const char *targ_btf_path)
 	if (targ_btf_path)
 		targ_btf = btf__parse_elf(targ_btf_path, NULL);
 	else
-		targ_btf = bpf_core_find_kernel_btf();
+		targ_btf = bpf_find_kernel_btf();
 	if (IS_ERR(targ_btf)) {
 		pr_warn("failed to get target BTF: %ld\n", PTR_ERR(targ_btf));
 		return PTR_ERR(targ_btf);
@@ -4379,6 +4797,10 @@ bpf_object__relocate(struct bpf_object *obj, const char *targ_btf_path)
 	return 0;
 }
 
+static int bpf_object__collect_struct_ops_map_reloc(struct bpf_object *obj,
+						    GElf_Shdr *shdr,
+						    Elf_Data *data);
+
 static int bpf_object__collect_reloc(struct bpf_object *obj)
 {
 	int i, err;
@@ -4399,6 +4821,15 @@ static int bpf_object__collect_reloc(struct bpf_object *obj)
 			return -LIBBPF_ERRNO__INTERNAL;
 		}
 
+		if (idx == obj->efile.st_ops_shndx) {
+			err = bpf_object__collect_struct_ops_map_reloc(obj,
+								       shdr,
+								       data);
+			if (err)
+				return err;
+			continue;
+		}
+
 		prog = bpf_object__find_prog_by_idx(obj, idx);
 		if (!prog) {
 			pr_warn("relocation failed: no section(%d)\n", idx);
@@ -4433,7 +4864,9 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.insns = insns;
 	load_attr.insns_cnt = insns_cnt;
 	load_attr.license = license;
-	if (prog->type == BPF_PROG_TYPE_TRACING) {
+	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS) {
+		load_attr.attach_btf_id = prog->attach_btf_id;
+	} else if (prog->type == BPF_PROG_TYPE_TRACING) {
 		load_attr.attach_prog_fd = prog->attach_prog_fd;
 		load_attr.attach_btf_id = prog->attach_btf_id;
 	} else {
@@ -4679,6 +5112,9 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		enum bpf_prog_type prog_type;
 		enum bpf_attach_type attach_type;
 
+		if (prog->type != BPF_PROG_TYPE_UNSPEC)
+			continue;
+
 		err = libbpf_prog_type_by_name(prog->section_name, &prog_type,
 					       &attach_type);
 		if (err == -ESRCH)
@@ -4774,8 +5210,11 @@ int bpf_object__unload(struct bpf_object *obj)
 	if (!obj)
 		return -EINVAL;
 
-	for (i = 0; i < obj->nr_maps; i++)
+	for (i = 0; i < obj->nr_maps; i++) {
 		zclose(obj->maps[i].fd);
+		if (obj->maps[i].st_ops)
+			zfree(&obj->maps[i].st_ops->kern_vdata);
+	}
 
 	for (i = 0; i < obj->nr_programs; i++)
 		bpf_program__unload(&obj->programs[i]);
@@ -4891,6 +5330,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
 	err = err ? : bpf_object__sanitize_and_load_btf(obj);
 	err = err ? : bpf_object__sanitize_maps(obj);
+	err = err ? : bpf_object__init_kern_struct_ops_maps(obj);
 	err = err ? : bpf_object__create_maps(obj);
 	err = err ? : bpf_object__relocate(obj, attr->target_btf_path);
 	err = err ? : bpf_object__load_progs(obj, attr->log_level);
@@ -5478,6 +5918,13 @@ void bpf_object__close(struct bpf_object *obj)
 			map->mmaped = NULL;
 		}
 
+		if (map->st_ops) {
+			zfree(&map->st_ops->data);
+			zfree(&map->st_ops->progs);
+			zfree(&map->st_ops->kern_func_off);
+			zfree(&map->st_ops);
+		}
+
 		zfree(&map->name);
 		zfree(&map->pin_path);
 	}
@@ -5746,6 +6193,7 @@ BPF_PROG_TYPE_FNS(raw_tracepoint, BPF_PROG_TYPE_RAW_TRACEPOINT);
 BPF_PROG_TYPE_FNS(xdp, BPF_PROG_TYPE_XDP);
 BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
 BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
+BPF_PROG_TYPE_FNS(struct_ops, BPF_PROG_TYPE_STRUCT_OPS);
 
 enum bpf_attach_type
 bpf_program__get_expected_attach_type(struct bpf_program *prog)
@@ -5899,6 +6347,7 @@ static const struct bpf_sec_def section_defs[] = {
 						BPF_CGROUP_GETSOCKOPT),
 	BPF_EAPROG_SEC("cgroup/setsockopt",	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 						BPF_CGROUP_SETSOCKOPT),
+	BPF_PROG_SEC("struct_ops",		BPF_PROG_TYPE_STRUCT_OPS),
 };
 
 #undef BPF_PROG_SEC_IMPL
@@ -5975,11 +6424,141 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 	return -ESRCH;
 }
 
+static struct bpf_map *find_struct_ops_map_by_offset(struct bpf_object *obj,
+						     size_t offset)
+{
+	struct bpf_map *map;
+	size_t i;
+
+	for (i = 0; i < obj->nr_maps; i++) {
+		map = &obj->maps[i];
+		if (!bpf_map__is_struct_ops(map))
+			continue;
+		if (map->sec_offset <= offset &&
+		    offset - map->sec_offset < map->def.value_size)
+			return map;
+	}
+
+	return NULL;
+}
+
+/* Collect the reloc from ELF and populate the st_ops->progs[] */
+static int bpf_object__collect_struct_ops_map_reloc(struct bpf_object *obj,
+						    GElf_Shdr *shdr,
+						    Elf_Data *data)
+{
+	const struct btf_member *member;
+	struct bpf_struct_ops *st_ops;
+	struct bpf_program *prog;
+	unsigned int shdr_idx;
+	const struct btf *btf;
+	struct bpf_map *map;
+	Elf_Data *symbols;
+	unsigned int moff;
+	const char *name;
+	u32 member_idx;
+	GElf_Sym sym;
+	GElf_Rel rel;
+	int i, nrels;
+
+	symbols = obj->efile.symbols;
+	btf = obj->btf;
+	nrels = shdr->sh_size / shdr->sh_entsize;
+	for (i = 0; i < nrels; i++) {
+		if (!gelf_getrel(data, i, &rel)) {
+			pr_warn("struct_ops reloc: failed to get %d reloc\n", i);
+			return -LIBBPF_ERRNO__FORMAT;
+		}
+
+		if (!gelf_getsym(symbols, GELF_R_SYM(rel.r_info), &sym)) {
+			pr_warn("struct_ops reloc: symbol %zx not found\n",
+				(size_t)GELF_R_SYM(rel.r_info));
+			return -LIBBPF_ERRNO__FORMAT;
+		}
+
+		name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
+				  sym.st_name) ? : "<?>";
+		map = find_struct_ops_map_by_offset(obj, rel.r_offset);
+		if (!map) {
+			pr_warn("struct_ops reloc: cannot find map at rel.r_offset %zu\n",
+				(size_t)rel.r_offset);
+			return -EINVAL;
+		}
+
+		moff = rel.r_offset - map->sec_offset;
+		shdr_idx = sym.st_shndx;
+		st_ops = map->st_ops;
+		pr_debug("struct_ops reloc %s: for %lld value %lld shdr_idx %u rel.r_offset %zu map->sec_offset %zu name %d (\'%s\')\n",
+			 map->name,
+			 (long long)(rel.r_info >> 32),
+			 (long long)sym.st_value,
+			 shdr_idx, (size_t)rel.r_offset,
+			 map->sec_offset, sym.st_name, name);
+
+		if (shdr_idx >= SHN_LORESERVE) {
+			pr_warn("struct_ops reloc %s: rel.r_offset %zu shdr_idx %u unsupported non-static function\n",
+				map->name, (size_t)rel.r_offset, shdr_idx);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+
+		member = find_member_by_offset(st_ops->type, moff * 8);
+		if (!member) {
+			pr_warn("struct_ops reloc %s: cannot find member at moff %u\n",
+				map->name, moff);
+			return -EINVAL;
+		}
+		member_idx = member - btf_members(st_ops->type);
+		name = btf__name_by_offset(btf, member->name_off);
+
+		if (!resolve_func_ptr(btf, member->type, NULL)) {
+			pr_warn("struct_ops reloc %s: cannot relocate non func ptr %s\n",
+				map->name, name);
+			return -EINVAL;
+		}
+
+		prog = bpf_object__find_prog_by_idx(obj, shdr_idx);
+		if (!prog) {
+			pr_warn("struct_ops reloc %s: cannot find prog at shdr_idx %u to relocate func ptr %s\n",
+				map->name, shdr_idx, name);
+			return -EINVAL;
+		}
+
+		if (prog->type == BPF_PROG_TYPE_UNSPEC) {
+			const struct bpf_sec_def *sec_def;
+
+			sec_def = find_sec_def(prog->section_name);
+			if (sec_def &&
+			    sec_def->prog_type != BPF_PROG_TYPE_STRUCT_OPS) {
+				/* for pr_warn */
+				prog->type = sec_def->prog_type;
+				goto invalid_prog;
+			}
+
+			prog->type = BPF_PROG_TYPE_STRUCT_OPS;
+			prog->attach_btf_id = st_ops->type_id;
+			prog->expected_attach_type = member_idx;
+		} else if (prog->type != BPF_PROG_TYPE_STRUCT_OPS ||
+			   prog->attach_btf_id != st_ops->type_id ||
+			   prog->expected_attach_type != member_idx) {
+			goto invalid_prog;
+		}
+		st_ops->progs[member_idx] = prog;
+	}
+
+	return 0;
+
+invalid_prog:
+	pr_warn("struct_ops reloc %s: cannot use prog %s in sec %s with type %u attach_btf_id %u expected_attach_type %u for func ptr %s\n",
+		map->name, prog->name, prog->section_name, prog->type,
+		prog->attach_btf_id, prog->expected_attach_type, name);
+	return -EINVAL;
+}
+
 #define BTF_PREFIX "btf_trace_"
 int libbpf_find_vmlinux_btf_id(const char *name,
 			       enum bpf_attach_type attach_type)
 {
-	struct btf *btf = bpf_core_find_kernel_btf();
+	struct btf *btf = bpf_find_kernel_btf();
 	char raw_tp_btf[128] = BTF_PREFIX;
 	char *dst = raw_tp_btf + sizeof(BTF_PREFIX) - 1;
 	const char *btf_name;
@@ -6805,6 +7384,58 @@ struct bpf_link *bpf_program__attach(struct bpf_program *prog)
 	return sec_def->attach_fn(sec_def, prog);
 }
 
+static int bpf_link__detach_struct_ops(struct bpf_link *link)
+{
+	struct bpf_link_fd *l = (void *)link;
+	__u32 zero = 0;
+
+	if (bpf_map_delete_elem(l->fd, &zero))
+		return -errno;
+
+	return 0;
+}
+
+struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *map)
+{
+	struct bpf_struct_ops *st_ops;
+	struct bpf_link_fd *link;
+	__u32 i, zero = 0;
+	int err;
+
+	if (!bpf_map__is_struct_ops(map) || map->fd == -1)
+		return ERR_PTR(-EINVAL);
+
+	link = calloc(1, sizeof(*link));
+	if (!link)
+		return ERR_PTR(-EINVAL);
+
+	st_ops = map->st_ops;
+	for (i = 0; i < btf_vlen(st_ops->type); i++) {
+		struct bpf_program *prog = st_ops->progs[i];
+		void *kern_data;
+		int prog_fd;
+
+		if (!prog)
+			continue;
+
+		prog_fd = bpf_program__fd(prog);
+		kern_data = st_ops->kern_vdata + st_ops->kern_func_off[i];
+		*(unsigned long *)kern_data = prog_fd;
+	}
+
+	err = bpf_map_update_elem(map->fd, &zero, st_ops->kern_vdata, 0);
+	if (err) {
+		err = -errno;
+		free(link);
+		return ERR_PTR(err);
+	}
+
+	link->link.detach = bpf_link__detach_struct_ops;
+	link->fd = map->fd;
+
+	return (struct bpf_link *)link;
+}
+
 enum bpf_perf_event_ret
 bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 			   void **copy_mem, size_t *copy_size,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 26bf539f1b3c..01639f9a1062 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -239,6 +239,8 @@ bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 
 LIBBPF_API struct bpf_link *
 bpf_program__attach_trace(struct bpf_program *prog);
+struct bpf_map;
+LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *map);
 struct bpf_insn;
 
 /*
@@ -315,6 +317,7 @@ LIBBPF_API int bpf_program__set_sched_act(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_xdp(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_tracing(struct bpf_program *prog);
+LIBBPF_API int bpf_program__set_struct_ops(struct bpf_program *prog);
 
 LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
 LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
@@ -335,6 +338,7 @@ LIBBPF_API bool bpf_program__is_sched_act(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_xdp(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_perf_event(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_tracing(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_struct_ops(const struct bpf_program *prog);
 
 /*
  * No need for __attribute__((packed)), all members of 'bpf_map_def'
@@ -354,7 +358,6 @@ struct bpf_map_def {
  * The 'struct bpf_map' in include/linux/bpf.h is internal to the kernel,
  * so no need to worry about a name clash.
  */
-struct bpf_map;
 LIBBPF_API struct bpf_map *
 bpf_object__find_map_by_name(const struct bpf_object *obj, const char *name);
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b300d74c921a..a19f04e6e3d9 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -213,6 +213,7 @@ LIBBPF_0.0.7 {
 	global:
 		btf_dump__emit_type_decl;
 		bpf_link__disconnect;
+		bpf_map__attach_struct_ops;
 		bpf_object__find_program_by_name;
 		bpf_object__attach_skeleton;
 		bpf_object__destroy_skeleton;
@@ -223,5 +224,7 @@ LIBBPF_0.0.7 {
 		bpf_prog_attach_xattr;
 		bpf_program__attach;
 		bpf_program__name;
+		bpf_program__is_struct_ops;
+		bpf_program__set_struct_ops;
 		btf__align_of;
 } LIBBPF_0.0.6;
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 221e6ad97012..320697f8e4c7 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -103,6 +103,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_TRACING:
+	case BPF_PROG_TYPE_STRUCT_OPS:
 	default:
 		break;
 	}
@@ -251,6 +252,7 @@ bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex)
 	case BPF_MAP_TYPE_XSKMAP:
 	case BPF_MAP_TYPE_SOCKHASH:
 	case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
+	case BPF_MAP_TYPE_STRUCT_OPS:
 	default:
 		break;
 	}
-- 
2.17.1

