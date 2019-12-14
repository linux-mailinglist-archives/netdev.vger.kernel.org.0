Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8561111EF5E
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfLNAsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:48:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726890AbfLNAsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:48:06 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE0UUJo009121
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:48:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=ZTYK8LaX3K+RSkTNYO6iEs1RBSmx7LEmkFhZ38VrVeM=;
 b=DChBOHkoiFdtzbKe1jAQ8EDZgYg5A0DJ9nihaJSZDnBFlyK4fjWcoC3LN1szFBQ/ztJb
 Bq3fZLrM/MCL5DK6wE/YtritVOUW5alxFUfYRAj9/1/AO8+Ap4wzu0HUbJeAyXsBw+ZU
 y6oF5PLBLErrYtX10NpU0y5oQfl4JtWIacA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvkm20g25-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:48:06 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 16:48:04 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 32D662943AB4; Fri, 13 Dec 2019 16:48:03 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 11/13] bpf: libbpf: Add STRUCT_OPS support
Date:   Fri, 13 Dec 2019 16:48:03 -0800
Message-ID: <20191214004803.1653618-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214004737.1652076-1-kafai@fb.com>
References: <20191214004737.1652076-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 clxscore=1015 suspectscore=43 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912140001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds BPF STRUCT_OPS support to libbpf.

The only sec_name convention is SEC("struct_ops") to identify the
struct ops implemented in BPF, e.g.
SEC("struct_ops")
struct tcp_congestion_ops dctcp = {
	.init           = (void *)dctcp_init,  /* <-- a bpf_prog */
	/* ... some more func prts ... */
	.name           = "bpf_dctcp",
};

In the bpf_object__open phase, libbpf will look for the "struct_ops"
elf section and find out what is the btf-type the "struct_ops" is
implementing.  Note that the btf-type here is referring to
a type in the bpf_prog.o's btf.  It will then collect (through SHT_REL)
where are the bpf progs that the func ptrs are referring to.

In the bpf_object__load phase, the prepare_struct_ops() will load
the btf_vmlinux and obtain the corresponding kernel's btf-type.
With the kernel's btf-type, it can then set the prog->type,
prog->attach_btf_id and the prog->expected_attach_type.  Thus,
the prog's properties do not rely on its section name.

Currently, the bpf_prog's btf-type ==> btf_vmlinux's btf-type matching
process is as simple as: member-name match + btf-kind match + size match.
If these matching conditions fail, libbpf will reject.
The current targeting support is "struct tcp_congestion_ops" which
most of its members are function pointers.
The member ordering of the bpf_prog's btf-type can be different from
the btf_vmlinux's btf-type.

Once the prog's properties are all set,
the libbpf will proceed to load all the progs.

After that, register_struct_ops() will create a map, finalize the
map-value by populating it with the prog-fd, and then register this
"struct_ops" to the kernel by updating the map-value to the map.

By default, libbpf does not unregister the struct_ops from the kernel
during bpf_object__close().  It can be changed by setting the new
"unreg_st_ops" in bpf_object_open_opts.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/bpf.c           |  10 +-
 tools/lib/bpf/bpf.h           |   5 +-
 tools/lib/bpf/libbpf.c        | 599 +++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.h        |   3 +-
 tools/lib/bpf/libbpf_probes.c |   2 +
 5 files changed, 612 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 98596e15390f..ebb9d7066173 100644
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
index 3c791fa8e68e..1ddbf7f33b83 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -48,7 +48,10 @@ struct bpf_create_map_attr {
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
index 27d5f7ecba32..ffb5cdd7db5a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -67,6 +67,10 @@
 
 #define __printf(a, b)	__attribute__((format(printf, a, b)))
 
+static struct btf *bpf_core_find_kernel_btf(void);
+static struct bpf_program *bpf_object__find_prog_by_idx(struct bpf_object *obj,
+							int idx);
+
 static int __base_pr(enum libbpf_print_level level, const char *format,
 		     va_list args)
 {
@@ -128,6 +132,8 @@ void libbpf_print(enum libbpf_print_level level, const char *format, ...)
 # define LIBBPF_ELF_C_READ_MMAP ELF_C_READ
 #endif
 
+#define BPF_STRUCT_OPS_SEC_NAME "struct_ops"
+
 static inline __u64 ptr_to_u64(const void *ptr)
 {
 	return (__u64) (unsigned long) ptr;
@@ -233,6 +239,32 @@ struct bpf_map {
 	bool reused;
 };
 
+struct bpf_struct_ops {
+	const char *var_name;
+	const char *tname;
+	const struct btf_type *type;
+	struct bpf_program **progs;
+	__u32 *kern_func_off;
+	/* e.g. struct tcp_congestion_ops in bpf_prog's btf format */
+	void *data;
+	/* e.g. struct __bpf_tcp_congestion_ops in btf_vmlinux's btf
+	 * format.
+	 * struct __bpf_tcp_congestion_ops {
+	 *	[... some other kernel fields ...]
+	 *	struct tcp_congestion_ops data;
+	 * }
+	 * kern_vdata in the sizeof(struct __bpf_tcp_congestion_ops).
+	 * prepare_struct_ops() will populate the "data" into
+	 * "kern_vdata".
+	 */
+	void *kern_vdata;
+	__u32 type_id;
+	__u32 kern_vtype_id;
+	__u32 kern_vtype_size;
+	int fd;
+	bool unreg;
+};
+
 struct bpf_secdata {
 	void *rodata;
 	void *data;
@@ -251,6 +283,7 @@ struct bpf_object {
 	size_t nr_maps;
 	size_t maps_cap;
 	struct bpf_secdata sections;
+	struct bpf_struct_ops st_ops;
 
 	bool loaded;
 	bool has_pseudo_calls;
@@ -270,6 +303,7 @@ struct bpf_object {
 		Elf_Data *data;
 		Elf_Data *rodata;
 		Elf_Data *bss;
+		Elf_Data *st_ops_data;
 		size_t strtabidx;
 		struct {
 			GElf_Shdr shdr;
@@ -282,6 +316,7 @@ struct bpf_object {
 		int data_shndx;
 		int rodata_shndx;
 		int bss_shndx;
+		int st_ops_shndx;
 	} efile;
 	/*
 	 * All loaded bpf_object is linked in a list, which is
@@ -509,6 +544,508 @@ static __u32 get_kernel_version(void)
 	return KERNEL_VERSION(major, minor, patch);
 }
 
+static int bpf_object__register_struct_ops(struct bpf_object *obj)
+{
+	struct bpf_create_map_attr map_attr = {};
+	struct bpf_struct_ops *st_ops;
+	const char *tname;
+	__u32 i, zero = 0;
+	int fd, err;
+
+	st_ops = &obj->st_ops;
+	if (!st_ops->kern_vdata)
+		return 0;
+
+	tname = st_ops->tname;
+	for (i = 0; i < btf_vlen(st_ops->type); i++) {
+		struct bpf_program *prog = st_ops->progs[i];
+		void *kern_data;
+		int prog_fd;
+
+		if (!prog)
+			continue;
+
+		prog_fd = bpf_program__nth_fd(prog, 0);
+		if (prog_fd < 0) {
+			pr_warn("struct_ops register %s: prog %s is not loaded\n",
+				tname, prog->name);
+			return -EINVAL;
+		}
+
+		kern_data = st_ops->kern_vdata + st_ops->kern_func_off[i];
+		*(unsigned long *)kern_data = prog_fd;
+	}
+
+	map_attr.map_type = BPF_MAP_TYPE_STRUCT_OPS;
+	map_attr.key_size = sizeof(unsigned int);
+	map_attr.value_size = st_ops->kern_vtype_size;
+	map_attr.max_entries = 1;
+	map_attr.btf_fd = btf__fd(obj->btf);
+	map_attr.btf_vmlinux_value_type_id = st_ops->kern_vtype_id;
+	map_attr.name = st_ops->var_name;
+
+	fd = bpf_create_map_xattr(&map_attr);
+	if (fd < 0) {
+		err = -errno;
+		pr_warn("struct_ops register %s: Error in creating struct_ops map\n",
+			tname);
+		return err;
+	}
+
+	err = bpf_map_update_elem(fd, &zero, st_ops->kern_vdata, 0);
+	if (err) {
+		err = -errno;
+		close(fd);
+		pr_warn("struct_ops register %s: Error in updating struct_ops map\n",
+			tname);
+		return err;
+	}
+
+	st_ops->fd = fd;
+
+	return 0;
+}
+
+static int bpf_struct_ops__unregister(struct bpf_struct_ops *st_ops)
+{
+	if (st_ops->fd != -1) {
+		__u32 zero = 0;
+		int err = 0;
+
+		if (bpf_map_delete_elem(st_ops->fd, &zero))
+			err = -errno;
+		zclose(st_ops->fd);
+
+		return err;
+	}
+
+	return 0;
+}
+
+static const struct btf_type *
+resolve_ptr(const struct btf *btf, __u32 id, __u32 *res_id);
+static const struct btf_type *
+resolve_func_ptr(const struct btf *btf, __u32 id, __u32 *res_id);
+
+static const struct btf_member *
+find_member_by_offset(const struct btf_type *t, __u32 offset)
+{
+	struct btf_member *m;
+	int i;
+
+	for (i = 0, m = btf_members(t); i < btf_vlen(t); i++, m++) {
+		if (btf_member_bit_offset(t, i) == offset)
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
+#define STRUCT_OPS_VALUE_PREFIX "__bpf_"
+#define STRUCT_OPS_VALUE_PREFIX_LEN (sizeof(STRUCT_OPS_VALUE_PREFIX) - 1)
+
+static int
+bpf_struct_ops__get_kern_types(const struct btf *btf, const char *tname,
+			       const struct btf_type **type, __u32 *type_id,
+			       const struct btf_type **vtype, __u32 *vtype_id,
+			       const struct btf_member **data_member)
+{
+	const struct btf_type *kern_type, *kern_vtype;
+	const struct btf_member *kern_data_member;
+	__s32 kern_vtype_id, kern_type_id;
+	char vtname[128] = STRUCT_OPS_VALUE_PREFIX;
+	__u32 i;
+
+	kern_type_id = btf__find_by_name_kind(btf, tname, BTF_KIND_STRUCT);
+	if (kern_type_id < 0) {
+		pr_warn("struct_ops prepare: struct %s is not found in kernel BTF\n",
+			tname);
+		return -ENOTSUP;
+	}
+	kern_type = btf__type_by_id(btf, kern_type_id);
+
+	/* Find the corresponding "map_value" type that will be used
+	 * in map_update(BPF_MAP_TYPE_STRUCT_OPS).  For example,
+	 * find "struct __bpf_tcp_congestion_ops" from the btf_vmlinux.
+	 */
+	strncat(vtname + STRUCT_OPS_VALUE_PREFIX_LEN, tname,
+		sizeof(vtname) - STRUCT_OPS_VALUE_PREFIX_LEN - 1);
+	kern_vtype_id = btf__find_by_name_kind(btf, vtname,
+					       BTF_KIND_STRUCT);
+	if (kern_vtype_id < 0) {
+		pr_warn("struct_ops prepare: struct %s is not found in kernel BTF\n",
+			vtname);
+		return -ENOTSUP;
+	}
+	kern_vtype = btf__type_by_id(btf, kern_vtype_id);
+
+	/* Find "struct tcp_congestion_ops" from
+	 * struct __bpf_tcp_congestion_ops {
+	 *	[ ... ]
+	 *	struct tcp_congestion_ops data;
+	 * }
+	 */
+	for (i = 0, kern_data_member = btf_members(kern_vtype);
+	     i < btf_vlen(kern_vtype);
+	     i++, kern_data_member++) {
+		if (kern_data_member->type == kern_type_id)
+			break;
+	}
+	if (i == btf_vlen(kern_vtype)) {
+		pr_warn("struct_ops prepare: struct %s data is not found in struct %s\n",
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
+static int bpf_object__prepare_struct_ops(struct bpf_object *obj)
+{
+	const struct btf_member *member, *kern_member, *kern_data_member;
+	const struct btf_type *type, *kern_type, *kern_vtype;
+	__u32 i, kern_type_id, kern_vtype_id, kern_data_off;
+	struct bpf_struct_ops *st_ops;
+	void *data, *kern_data;
+	const struct btf *btf;
+	struct btf *kern_btf;
+	const char *tname;
+	int err;
+
+	st_ops = &obj->st_ops;
+	if (!st_ops->data)
+		return 0;
+
+	btf = obj->btf;
+	type = st_ops->type;
+	tname = st_ops->tname;
+
+	kern_btf = bpf_core_find_kernel_btf();
+	if (IS_ERR(kern_btf))
+		return PTR_ERR(kern_btf);
+
+	err = bpf_struct_ops__get_kern_types(kern_btf, tname,
+					     &kern_type, &kern_type_id,
+					     &kern_vtype, &kern_vtype_id,
+					     &kern_data_member);
+	if (err)
+		goto done;
+
+	pr_debug("struct_ops prepare %s: type_id:%u kern_type_id:%u kern_vtype_id:%u\n",
+		 tname, st_ops->type_id, kern_type_id, kern_vtype_id);
+
+	kern_data_off = kern_data_member->offset / 8;
+	st_ops->kern_vtype_size = kern_vtype->size;
+	st_ops->kern_vtype_id = kern_vtype_id;
+
+	st_ops->kern_vdata = calloc(1, st_ops->kern_vtype_size);
+	if (!st_ops->kern_vdata) {
+		err = -ENOMEM;
+		goto done;
+	}
+
+	data = st_ops->data;
+	kern_data = st_ops->kern_vdata + kern_data_off;
+
+	err = -ENOTSUP;
+	for (i = 0, member = btf_members(type); i < btf_vlen(type);
+	     i++, member++) {
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
+			pr_warn("struct_ops prepare %s: Cannot find member %s in kernel BTF\n",
+				tname, mname);
+			goto done;
+		}
+
+		kern_member_idx = kern_member - btf_members(kern_type);
+		if (btf_member_bitfield_size(type, i) ||
+		    btf_member_bitfield_size(kern_type, kern_member_idx)) {
+			pr_warn("struct_ops prepare %s: bitfield %s is not supported\n",
+				tname, mname);
+			goto done;
+		}
+
+		moff = member->offset / 8;
+		kern_moff = kern_member->offset / 8;
+
+		mdata = data + moff;
+		kern_mdata = kern_data + kern_moff;
+
+		mtype_id = member->type;
+		kern_mtype_id = kern_member->type;
+
+		mtype = resolve_ptr(btf, mtype_id, NULL);
+		kern_mtype = resolve_ptr(kern_btf, kern_mtype_id, NULL);
+		if (mtype && kern_mtype) {
+			struct bpf_program *prog;
+
+			if (!btf_is_func_proto(mtype) ||
+			    !btf_is_func_proto(kern_mtype)) {
+				pr_warn("struct_ops prepare %s: non func ptr %s is not supported\n",
+					tname, mname);
+				goto done;
+			}
+
+			prog = st_ops->progs[i];
+			if (!prog) {
+				pr_debug("struct_ops prepare %s: func ptr %s is not set\n",
+					 tname, mname);
+				continue;
+			}
+
+			if (prog->type != BPF_PROG_TYPE_UNSPEC ||
+			    prog->attach_btf_id) {
+				pr_warn("struct_ops prepare %s: cannot use prog %s with attach_btf_id %d for func ptr %s\n",
+					tname, prog->name, prog->attach_btf_id, mname);
+				err = -EINVAL;
+				goto done;
+			}
+
+			prog->type = BPF_PROG_TYPE_STRUCT_OPS;
+			prog->attach_btf_id = kern_type_id;
+			/* expected_attach_type is the member index */
+			prog->expected_attach_type = kern_member_idx;
+
+			st_ops->kern_func_off[i] = kern_data_off + kern_moff;
+
+			pr_debug("struct_ops prepare %s: func ptr %s is set to prog %s from data(+%u) to kern_data(+%u)\n",
+				 tname, mname, prog->name, moff, kern_moff);
+
+			continue;
+		}
+
+		mtype_id = btf__resolve_type(btf, mtype_id);
+		kern_mtype_id = btf__resolve_type(kern_btf, kern_mtype_id);
+		if (mtype_id < 0 || kern_mtype_id < 0) {
+			pr_warn("struct_ops prepare %s: Cannot resolve the type for %s\n",
+				tname, mname);
+			goto done;
+		}
+
+		mtype = btf__type_by_id(btf, mtype_id);
+		kern_mtype = btf__type_by_id(kern_btf, kern_mtype_id);
+		if (BTF_INFO_KIND(mtype->info) !=
+		    BTF_INFO_KIND(kern_mtype->info)) {
+			pr_warn("struct_ops prepare %s: Unmatched member type %s %u != %u(kernel)\n",
+				tname, mname,
+				BTF_INFO_KIND(mtype->info),
+				BTF_INFO_KIND(kern_mtype->info));
+			goto done;
+		}
+
+		msize = btf__resolve_size(btf, mtype_id);
+		kern_msize = btf__resolve_size(kern_btf, kern_mtype_id);
+		if (msize < 0 || kern_msize < 0 || msize != kern_msize) {
+			pr_warn("struct_ops prepare %s: Error in size of member %s: %zd != %zd(kernel)\n",
+				tname, mname,
+				(ssize_t)msize, (ssize_t)kern_msize);
+			goto done;
+		}
+
+		pr_debug("struct_ops prepare %s: copy %s %u bytes from data(+%u) to kern_data(+%u)\n",
+			 tname, mname, (unsigned int)msize,
+			 moff, kern_moff);
+		memcpy(kern_mdata, mdata, msize);
+	}
+
+	err = 0;
+
+done:
+	/* On error case, bpf_object__unload() will free the
+	 * st_ops->kern_vdata.
+	 */
+	btf__free(kern_btf);
+	return err;
+}
+
+static int bpf_object__collect_struct_ops_reloc(struct bpf_object *obj,
+						GElf_Shdr *shdr,
+						Elf_Data *data)
+{
+	const struct btf_member *member;
+	struct bpf_struct_ops *st_ops;
+	struct bpf_program *prog;
+	const char *name, *tname;
+	unsigned int shdr_idx;
+	const struct btf *btf;
+	Elf_Data *symbols;
+	unsigned int moff;
+	GElf_Sym sym;
+	GElf_Rel rel;
+	int i, nrels;
+
+	symbols = obj->efile.symbols;
+	btf = obj->btf;
+	st_ops = &obj->st_ops;
+	tname = st_ops->tname;
+
+	nrels = shdr->sh_size / shdr->sh_entsize;
+	for (i = 0; i < nrels; i++) {
+		if (!gelf_getrel(data, i, &rel)) {
+			pr_warn("struct_ops reloc %s: failed to get %d reloc\n",
+				tname, i);
+			return -LIBBPF_ERRNO__FORMAT;
+		}
+
+		if (!gelf_getsym(symbols, GELF_R_SYM(rel.r_info), &sym)) {
+			pr_warn("struct_ops reloc %s: symbol %" PRIx64 " not found\n",
+				tname, GELF_R_SYM(rel.r_info));
+			return -LIBBPF_ERRNO__FORMAT;
+		}
+
+		name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
+				  sym.st_name) ? : "<?>";
+
+		pr_debug("%s relo for %lld value %lld name %d (\'%s\')\n",
+			 tname,
+			 (long long) (rel.r_info >> 32),
+			 (long long) sym.st_value, sym.st_name, name);
+
+		shdr_idx = sym.st_shndx;
+		moff = rel.r_offset;
+		pr_debug("struct_ops reloc %s: moff=%u, shdr_idx=%u\n",
+			 tname, moff, shdr_idx);
+
+		if (shdr_idx >= SHN_LORESERVE) {
+			pr_warn("struct_ops reloc %s: moff=%u shdr_idx=%u unsupported non-static function\n",
+				tname, moff, shdr_idx);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+
+		member = find_member_by_offset(st_ops->type, moff * 8);
+		if (!member) {
+			pr_warn("struct_ops reloc %s: cannot find member at moff=%u\n",
+				tname, moff);
+			return -EINVAL;
+		}
+		name = btf__name_by_offset(btf, member->name_off);
+
+		if (!resolve_func_ptr(btf, member->type, NULL)) {
+			pr_warn("struct_ops reloc %s: cannot relocate non func ptr %s\n",
+				tname, name);
+			return -EINVAL;
+		}
+
+		prog = bpf_object__find_prog_by_idx(obj, shdr_idx);
+		if (!prog) {
+			pr_warn("struct_ops reloc %s: cannot find prog at shdr_idx %u to relocate func ptr %s\n",
+				tname, shdr_idx, name);
+			return -EINVAL;
+		}
+
+		st_ops->progs[member - btf_members(st_ops->type)] = prog;
+	}
+
+	return 0;
+}
+
+static int bpf_object__init_struct_ops(struct bpf_object *obj)
+{
+	const struct btf_type *type, *datasec;
+	const struct btf_var_secinfo *vsi;
+	struct bpf_struct_ops *st_ops;
+	const char *tname, *var_name;
+	__s32 type_id, datasec_id;
+	const struct btf *btf;
+
+	if (obj->efile.st_ops_shndx == -1)
+		return 0;
+
+	btf = obj->btf;
+	st_ops = &obj->st_ops;
+	datasec_id = btf__find_by_name_kind(btf, BPF_STRUCT_OPS_SEC_NAME,
+					    BTF_KIND_DATASEC);
+	if (datasec_id < 0) {
+		pr_warn("struct_ops init: DATASEC %s not found\n",
+			BPF_STRUCT_OPS_SEC_NAME);
+		return -EINVAL;
+	}
+
+	datasec = btf__type_by_id(btf, datasec_id);
+	if (btf_vlen(datasec) != 1) {
+		pr_warn("struct_ops init: multiple VAR in DATASEC %s\n",
+			BPF_STRUCT_OPS_SEC_NAME);
+		return -ENOTSUP;
+	}
+	vsi = btf_var_secinfos(datasec);
+
+	type = btf__type_by_id(obj->btf, vsi->type);
+	if (!btf_is_var(type)) {
+		pr_warn("struct_ops init: vsi->type %u is not a VAR\n",
+			vsi->type);
+		return -EINVAL;
+	}
+	var_name = btf__name_by_offset(obj->btf, type->name_off);
+
+	type_id = btf__resolve_type(obj->btf, vsi->type);
+	if (type_id < 0) {
+		pr_warn("struct_ops init: Cannot resolve var type_id %u in DATASEC %s\n",
+			vsi->type, BPF_STRUCT_OPS_SEC_NAME);
+		return -EINVAL;
+	}
+
+	type = btf__type_by_id(obj->btf, type_id);
+	tname = btf__name_by_offset(obj->btf, type->name_off);
+	if (!btf_is_struct(type)) {
+		pr_warn("struct_ops init: %s is not a struct\n", tname);
+		return -EINVAL;
+	}
+
+	if (type->size != obj->efile.st_ops_data->d_size) {
+		pr_warn("struct_ops init: %s unmatched size %u (BTF DATASEC) != %zu (ELF)\n",
+			tname, type->size, obj->efile.st_ops_data->d_size);
+		return -EINVAL;
+	}
+
+	st_ops->data = malloc(type->size);
+	st_ops->progs = calloc(btf_vlen(type), sizeof(*st_ops->progs));
+	st_ops->kern_func_off = malloc(btf_vlen(type) *
+				       sizeof(*st_ops->kern_func_off));
+	/* bpf_object__close() will take care of the free-ings */
+	if (!st_ops->data || !st_ops->progs || !st_ops->kern_func_off)
+		return -ENOMEM;
+	memcpy(st_ops->data, obj->efile.st_ops_data->d_buf, type->size);
+
+	st_ops->tname = tname;
+	st_ops->type = type;
+	st_ops->type_id = type_id;
+	st_ops->var_name = var_name;
+
+	pr_debug("struct_ops init: %s found. type_id:%u\n", tname, type_id);
+
+	return 0;
+}
+
 static struct bpf_object *bpf_object__new(const char *path,
 					  const void *obj_buf,
 					  size_t obj_buf_sz,
@@ -550,6 +1087,9 @@ static struct bpf_object *bpf_object__new(const char *path,
 	obj->efile.data_shndx = -1;
 	obj->efile.rodata_shndx = -1;
 	obj->efile.bss_shndx = -1;
+	obj->efile.st_ops_shndx = -1;
+
+	obj->st_ops.fd = -1;
 
 	obj->kern_version = get_kernel_version();
 	obj->loaded = false;
@@ -572,6 +1112,7 @@ static void bpf_object__elf_finish(struct bpf_object *obj)
 	obj->efile.data = NULL;
 	obj->efile.rodata = NULL;
 	obj->efile.bss = NULL;
+	obj->efile.st_ops_data = NULL;
 
 	zfree(&obj->efile.reloc_sects);
 	obj->efile.nr_reloc_sects = 0;
@@ -757,6 +1298,9 @@ int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 	} else if (!strcmp(name, ".rodata")) {
 		if (obj->efile.rodata)
 			*size = obj->efile.rodata->d_size;
+	} else if (!strcmp(name, BPF_STRUCT_OPS_SEC_NAME)) {
+		if (obj->efile.st_ops_data)
+			*size = obj->efile.st_ops_data->d_size;
 	} else {
 		ret = bpf_object_search_section_size(obj, name, &d_size);
 		if (!ret)
@@ -1060,6 +1604,30 @@ skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)
 	return t;
 }
 
+static const struct btf_type *
+resolve_ptr(const struct btf *btf, __u32 id, __u32 *res_id)
+{
+	const struct btf_type *t;
+
+	t = skip_mods_and_typedefs(btf, id, NULL);
+	if (!btf_is_ptr(t))
+		return NULL;
+
+	return skip_mods_and_typedefs(btf, t->type, res_id);
+}
+
+static const struct btf_type *
+resolve_func_ptr(const struct btf *btf, __u32 id, __u32 *res_id)
+{
+	const struct btf_type *t;
+
+	t = resolve_ptr(btf, id, res_id);
+	if (t && btf_is_func_proto(t))
+		return t;
+
+	return NULL;
+}
+
 /*
  * Fetch integer attribute of BTF map definition. Such attributes are
  * represented using a pointer to an array, in which dimensionality of array
@@ -1509,7 +2077,7 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
 
 static bool bpf_object__is_btf_mandatory(const struct bpf_object *obj)
 {
-	return obj->efile.btf_maps_shndx >= 0;
+	return obj->efile.btf_maps_shndx >= 0 || obj->efile.st_ops_shndx >= 0;
 }
 
 static int bpf_object__init_btf(struct bpf_object *obj,
@@ -1689,6 +2257,9 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
 			} else if (strcmp(name, ".rodata") == 0) {
 				obj->efile.rodata = data;
 				obj->efile.rodata_shndx = idx;
+			} else if (strcmp(name, BPF_STRUCT_OPS_SEC_NAME) == 0) {
+				obj->efile.st_ops_data = data;
+				obj->efile.st_ops_shndx = idx;
 			} else {
 				pr_debug("skip section(%d) %s\n", idx, name);
 			}
@@ -1698,7 +2269,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
 			int sec = sh.sh_info; /* points to other section */
 
 			/* Only do relo for section with exec instructions */
-			if (!section_have_execinstr(obj, sec)) {
+			if (!section_have_execinstr(obj, sec) &&
+			    !strstr(name, BPF_STRUCT_OPS_SEC_NAME)) {
 				pr_debug("skip relo %s(%d) for section(%d)\n",
 					 name, idx, sec);
 				continue;
@@ -1735,6 +2307,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
 		err = bpf_object__sanitize_and_load_btf(obj);
 	if (!err)
 		err = bpf_object__init_prog_names(obj);
+	if (!err)
+		err = bpf_object__init_struct_ops(obj);
 	return err;
 }
 
@@ -3700,6 +4274,13 @@ static int bpf_object__collect_reloc(struct bpf_object *obj)
 			return -LIBBPF_ERRNO__INTERNAL;
 		}
 
+		if (idx == obj->efile.st_ops_shndx) {
+			err = bpf_object__collect_struct_ops_reloc(obj, shdr, data);
+			if (err)
+				return err;
+			continue;
+		}
+
 		prog = bpf_object__find_prog_by_idx(obj, idx);
 		if (!prog) {
 			pr_warn("relocation failed: no section(%d)\n", idx);
@@ -3734,7 +4315,9 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
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
@@ -3952,6 +4535,7 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	if (IS_ERR(obj))
 		return obj;
 
+	obj->st_ops.unreg = OPTS_GET(opts, unreg_st_ops, false);
 	obj->relaxed_core_relocs = OPTS_GET(opts, relaxed_core_relocs, false);
 	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
 	pin_root_path = OPTS_GET(opts, pin_root_path, NULL);
@@ -4077,6 +4661,10 @@ int bpf_object__unload(struct bpf_object *obj)
 	for (i = 0; i < obj->nr_programs; i++)
 		bpf_program__unload(&obj->programs[i]);
 
+	if (obj->st_ops.unreg)
+		bpf_struct_ops__unregister(&obj->st_ops);
+	zfree(&obj->st_ops.kern_vdata);
+
 	return 0;
 }
 
@@ -4100,7 +4688,9 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 
 	CHECK_ERR(bpf_object__create_maps(obj), err, out);
 	CHECK_ERR(bpf_object__relocate(obj, attr->target_btf_path), err, out);
+	CHECK_ERR(bpf_object__prepare_struct_ops(obj), err, out);
 	CHECK_ERR(bpf_object__load_progs(obj, attr->log_level), err, out);
+	CHECK_ERR(bpf_object__register_struct_ops(obj), err, out);
 
 	return 0;
 out:
@@ -4690,6 +5280,9 @@ void bpf_object__close(struct bpf_object *obj)
 			bpf_program__exit(&obj->programs[i]);
 	}
 	zfree(&obj->programs);
+	zfree(&obj->st_ops.data);
+	zfree(&obj->st_ops.progs);
+	zfree(&obj->st_ops.kern_func_off);
 
 	list_del(&obj->list);
 	free(obj);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 0dbf4bfba0c4..db255fce4948 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -109,8 +109,9 @@ struct bpf_object_open_opts {
 	 */
 	const char *pin_root_path;
 	__u32 attach_prog_fd;
+	bool unreg_st_ops;
 };
-#define bpf_object_open_opts__last_field attach_prog_fd
+#define bpf_object_open_opts__last_field unreg_st_ops
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index a9eb8b322671..7f06942e9574 100644
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

