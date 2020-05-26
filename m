Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0408F1BB6F0
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 08:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgD1Gl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 02:41:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48208 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbgD1Gly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 02:41:54 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S6dvp7009610
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 23:41:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zrzAaP8tP2BEIjWxLbVLOvqBX7ZWqOs4TNdnfvzsZxw=;
 b=opN8w6DS1Dv8wtYDDo/6lS95rXbFF8dwFnq/7f2Fh0QVmOqX8HMOv+UBdlSvFtlq92Ap
 x2ZXv+ZDIbI0e5YwKf2sFpimdVp27TvVCI4BVPnATaI4O5A4QlQ+o5b9QxE+SU30wz89
 /+CGDTkwhsXP2X9LBb1i5iTWmBgx8zahQ4Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57pd1wt-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 23:41:52 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 23:41:51 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E54F52EC2FA7; Mon, 27 Apr 2020 23:41:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <toke@redhat.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/3] libbpf: add BTF-defined map-in-map support
Date:   Mon, 27 Apr 2020 23:41:39 -0700
Message-ID: <20200428064140.122796-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200428064140.122796-1-andriin@fb.com>
References: <20200428064140.122796-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_03:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280057
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed at LPC 2019 ([0]), this patch brings (a quite belated) suppo=
rt
for declarative BTF-defined map-in-map support in libbpf. It allows to de=
fine
ARRAY_OF_MAPS and HASH_OF_MAPS BPF maps without any user-space initializa=
tion
code involved.

Additionally, it allows to initialize outer map's slots with references t=
o
respective inner maps at load time, also completely declaratively.

Despite a weak type system of C, the way BTF-defined map-in-map definitio=
n
works, it's actually quite hard to accidentally initialize outer map with
incompatible inner maps. This being C, of course, it's still possible, bu=
t
even that would be caught at load time and error returned with helpful de=
bug
log pointing exactly to the slot that failed to be initialized.

As an example, here's a rather advanced HASH_OF_MAPS declaration and
initialization example, filling slots #0 and #4 with two inner maps:

  #include <bpf/bpf_helpers.h>

  struct inner_map {
          __uint(type, BPF_MAP_TYPE_ARRAY);
          __uint(max_entries, 1);
          __type(key, int);
          __type(value, int);
  } inner_map1 SEC(".maps"),
    inner_map2 SEC(".maps");

  struct outer_hash {
          __uint(type, BPF_MAP_TYPE_HASH_OF_MAPS);
          __uint(max_entries, 5);
          __uint(key_size, sizeof(int));
          __inner(values, struct inner_map);
  } outer_hash SEC(".maps") =3D {
          .values =3D {
                  [0] =3D &inner_map2,
                  [4] =3D &inner_map1,
          },
  };

Here's the relevant part of libbpf debug log showing pretty clearly of wh=
at's
going on with map-in-map initialization:

  libbpf: .maps relo #0: for 6 value 0 rel.r_offset 96 name 260 ('inner_m=
ap1')
  libbpf: .maps relo #0: map 'outer_arr' slot [0] points to map 'inner_ma=
p1'
  libbpf: .maps relo #1: for 7 value 32 rel.r_offset 112 name 249 ('inner=
_map2')
  libbpf: .maps relo #1: map 'outer_arr' slot [2] points to map 'inner_ma=
p2'
  libbpf: .maps relo #2: for 7 value 32 rel.r_offset 144 name 249 ('inner=
_map2')
  libbpf: .maps relo #2: map 'outer_hash' slot [0] points to map 'inner_m=
ap2'
  libbpf: .maps relo #3: for 6 value 0 rel.r_offset 176 name 260 ('inner_=
map1')
  libbpf: .maps relo #3: map 'outer_hash' slot [4] points to map 'inner_m=
ap1'
  libbpf: map 'inner_map1': created successfully, fd=3D4
  libbpf: map 'inner_map2': created successfully, fd=3D5
  libbpf: map 'outer_hash': created successfully, fd=3D7
  libbpf: map 'outer_hash': slot [0] set to map 'inner_map2' fd=3D5
  libbpf: map 'outer_hash': slot [4] set to map 'inner_map1' fd=3D4

Notice from the log above that fd=3D6 (not logged explicitly) is used for=
 inner
"prototype" map, necessary for creation of outer map. It is destroyed
immediately after outer map is created.

See also included selftest with some extra comments explaining extra deta=
ils
of usage. Additionally, similar initialization syntax and libbpf function=
ality
can be used to do initialization of BPF_PROG_ARRAY with references to BPF
sub-programs. This can be done in follow up patches, if there will be a d=
emand
for this.

  [0] https://linuxplumbersconf.org/event/4/contributions/448/

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_helpers.h                   |   1 +
 tools/lib/bpf/libbpf.c                        | 281 ++++++++++++++++--
 .../selftests/bpf/prog_tests/btf_map_in_map.c |  49 +++
 .../selftests/bpf/progs/test_btf_map_in_map.c |  76 +++++
 4 files changed, 384 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_map_in_map=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_btf_map_in_map=
.c

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 60aad054eea1..e3a6e9a1f5b4 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -12,6 +12,7 @@
=20
 #define __uint(name, val) int (*name)[val]
 #define __type(name, val) typeof(val) *name
+#define __inner(name, val) typeof(val) *name[]
=20
 /* Helper macro to print out debug messages */
 #define bpf_printk(fmt, ...)				\
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9c845cf4cfcf..445ee903f9cd 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -310,6 +310,7 @@ struct bpf_map {
 	int map_ifindex;
 	int inner_map_fd;
 	struct bpf_map_def def;
+	__u32 btf_var_idx;
 	__u32 btf_key_type_id;
 	__u32 btf_value_type_id;
 	__u32 btf_vmlinux_value_type_id;
@@ -318,6 +319,9 @@ struct bpf_map {
 	enum libbpf_map_type libbpf_type;
 	void *mmaped;
 	struct bpf_struct_ops *st_ops;
+	struct bpf_map *inner_map;
+	void **init_slots;
+	int init_slots_sz;
 	char *pin_path;
 	bool pinned;
 	bool reused;
@@ -389,6 +393,7 @@ struct bpf_object {
 		int nr_reloc_sects;
 		int maps_shndx;
 		int btf_maps_shndx;
+		__u32 btf_maps_sec_btf_id;
 		int text_shndx;
 		int symbols_shndx;
 		int data_shndx;
@@ -1918,7 +1923,7 @@ static int build_map_pin_path(struct bpf_map *map, =
const char *path)
 static int parse_btf_map_def(struct bpf_object *obj,
 			     struct bpf_map *map,
 			     const struct btf_type *def,
-			     bool strict,
+			     bool strict, bool is_inner,
 			     const char *pin_root_path)
 {
 	const struct btf_type *t;
@@ -2036,10 +2041,79 @@ static int parse_btf_map_def(struct bpf_object *o=
bj,
 			}
 			map->def.value_size =3D sz;
 			map->btf_value_type_id =3D t->type;
+		}
+		else if (strcmp(name, "values") =3D=3D 0) {
+			int err;
+
+			if (is_inner) {
+				pr_warn("map '%s': multi-level inner maps not supported.\n",
+					map->name);
+				return -ENOTSUP;
+			}
+			if (i !=3D vlen - 1) {
+				pr_warn("map '%s': '%s' member should be last.\n",
+					map->name, name);
+				return -EINVAL;
+			}
+			if (!bpf_map_type__is_map_in_map(map->def.type)) {
+				pr_warn("map '%s': should be map-in-map.\n",
+					map->name);
+				return -ENOTSUP;
+			}
+			if (map->def.value_size && map->def.value_size !=3D 4) {
+				pr_warn("map '%s': conflicting value size %u !=3D 4.\n",
+					map->name, map->def.value_size);
+				return -EINVAL;
+			}
+			map->def.value_size =3D 4;
+			t =3D btf__type_by_id(obj->btf, m->type);
+			if (!t) {
+				pr_warn("map '%s': map-in-map inner type [%d] not found.\n",
+					map->name, m->type);
+				return -EINVAL;
+			}
+			if (!btf_is_array(t) || btf_array(t)->nelems) {
+				pr_warn("map '%s': map-in-map inner spec is not a zero-sized array.\=
n",
+					map->name);
+				return -EINVAL;
+			}
+			t =3D skip_mods_and_typedefs(obj->btf, btf_array(t)->type,
+						   NULL);
+			if (!btf_is_ptr(t)) {
+				pr_warn("map '%s': map-in-map inner def is of unexpected kind %u.\n"=
,
+					map->name, btf_kind(t));
+				return -EINVAL;
+			}
+			t =3D skip_mods_and_typedefs(obj->btf, t->type, NULL);
+			if (!btf_is_struct(t)) {
+				pr_warn("map '%s': map-in-map inner def is of unexpected kind %u.\n"=
,
+					map->name, btf_kind(t));
+				return -EINVAL;
+			}
+
+			map->inner_map =3D calloc(1, sizeof(*map->inner_map));
+			if (!map->inner_map)
+				return -ENOMEM;
+			map->inner_map->sec_idx =3D obj->efile.btf_maps_shndx;
+			map->inner_map->name =3D malloc(strlen(map->name) +
+						      sizeof(".inner") + 1);
+			if (!map->inner_map->name)
+				return -ENOMEM;
+			sprintf(map->inner_map->name, "%s.inner", map->name);
+
+			err =3D parse_btf_map_def(obj, map->inner_map, t, strict,
+						true /* is_inner */, NULL);
+			if (err)
+				return err;
 		} else if (strcmp(name, "pinning") =3D=3D 0) {
 			__u32 val;
 			int err;
=20
+			if (is_inner) {
+				pr_debug("map '%s': inner def can't be pinned.\n",
+					 map->name);
+				return -EINVAL;
+			}
 			if (!get_map_field_int(map->name, obj->btf, m, &val))
 				return -EINVAL;
 			pr_debug("map '%s': found pinning =3D %u.\n",
@@ -2138,10 +2212,11 @@ static int bpf_object__init_user_btf_map(struct b=
pf_object *obj,
 	map->def.type =3D BPF_MAP_TYPE_UNSPEC;
 	map->sec_idx =3D sec_idx;
 	map->sec_offset =3D vi->offset;
+	map->btf_var_idx =3D var_idx;
 	pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
 		 map_name, map->sec_idx, map->sec_offset);
=20
-	return parse_btf_map_def(obj, map, def, strict, pin_root_path);
+	return parse_btf_map_def(obj, map, def, strict, false, pin_root_path);
 }
=20
 static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool s=
trict,
@@ -2174,6 +2249,7 @@ static int bpf_object__init_user_btf_maps(struct bp=
f_object *obj, bool strict,
 		name =3D btf__name_by_offset(obj->btf, t->name_off);
 		if (strcmp(name, MAPS_ELF_SEC) =3D=3D 0) {
 			sec =3D t;
+			obj->efile.btf_maps_sec_btf_id =3D i;
 			break;
 		}
 	}
@@ -2560,7 +2636,8 @@ static int bpf_object__elf_collect(struct bpf_objec=
t *obj)
=20
 			/* Only do relo for section with exec instructions */
 			if (!section_have_execinstr(obj, sec) &&
-			    strcmp(name, ".rel" STRUCT_OPS_SEC)) {
+			    strcmp(name, ".rel" STRUCT_OPS_SEC) &&
+			    strcmp(name, ".rel" MAPS_ELF_SEC)) {
 				pr_debug("skip relo %s(%d) for section(%d)\n",
 					 name, idx, sec);
 				continue;
@@ -3538,6 +3615,22 @@ static int bpf_object__create_map(struct bpf_objec=
t *obj, struct bpf_map *map)
 		create_attr.btf_value_type_id =3D map->btf_value_type_id;
 	}
=20
+	if (bpf_map_type__is_map_in_map(def->type)) {
+		if (map->inner_map) {
+			int err;
+
+			err =3D bpf_object__create_map(obj, map->inner_map);
+			if (err) {
+				pr_warn("map '%s': failed to create inner map: %d\n",
+					map->name, err);
+				return err;
+			}
+			map->inner_map_fd =3D bpf_map__fd(map->inner_map);
+		}
+		if (map->inner_map_fd >=3D 0)
+			create_attr.inner_map_fd =3D map->inner_map_fd;
+	}
+
 	map->fd =3D bpf_create_map_xattr(&create_attr);
 	if (map->fd < 0 && (create_attr.btf_key_type_id ||
 			    create_attr.btf_value_type_id)) {
@@ -3558,6 +3651,11 @@ static int bpf_object__create_map(struct bpf_objec=
t *obj, struct bpf_map *map)
 	if (map->fd < 0)
 		return -errno;
=20
+	if (bpf_map_type__is_map_in_map(def->type) && map->inner_map) {
+		bpf_map__destroy(map->inner_map);
+		zfree(&map->inner_map);
+	}
+
 	return 0;
 }
=20
@@ -3602,6 +3700,31 @@ bpf_object__create_maps(struct bpf_object *obj)
 			}
 		}
=20
+		if (map->init_slots_sz) {
+			for (j =3D 0; j < map->init_slots_sz; j++) {
+				const struct bpf_map *targ_map;
+				int fd;
+
+				if (!map->init_slots[j])
+					continue;
+
+				targ_map =3D map->init_slots[j];
+				fd =3D bpf_map__fd(targ_map);
+				err =3D bpf_map_update_elem(map->fd, &j, &fd, 0);
+				if (err) {
+					err =3D -errno;
+					pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=3D=
%d: %d\n",
+						map->name, j, targ_map->name,
+						fd, err);
+					goto err_out;
+				}
+				pr_debug("map '%s': slot [%d] set to map '%s' fd=3D%d\n",
+					 map->name, j, targ_map->name, fd);
+			}
+			zfree(&map->init_slots);
+			map->init_slots_sz =3D 0;
+		}
+
 		if (map->pin_path && !map->pinned) {
 			err =3D bpf_map__pin(map, NULL);
 			if (err) {
@@ -4873,9 +4996,118 @@ bpf_object__relocate(struct bpf_object *obj, cons=
t char *targ_btf_path)
 	return 0;
 }
=20
-static int bpf_object__collect_struct_ops_map_reloc(struct bpf_object *o=
bj,
-						    GElf_Shdr *shdr,
-						    Elf_Data *data);
+static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
+					    GElf_Shdr *shdr, Elf_Data *data);
+
+static int bpf_object__collect_map_relos(struct bpf_object *obj,
+					 GElf_Shdr *shdr, Elf_Data *data)
+{
+	int i, j, nrels, new_sz, ptr_sz =3D sizeof(void *);
+	const struct btf_type *sec, *var, *def;
+	const struct btf_var_secinfo *vi;
+	const struct btf_member *member;
+	struct bpf_map *map, *targ_map;
+	const char *name, *mname;
+	Elf_Data *symbols;
+	unsigned int moff;
+	GElf_Sym sym;
+	GElf_Rel rel;
+	void *tmp;
+
+	if (!obj->efile.btf_maps_sec_btf_id || !obj->btf)
+		return -EINVAL;
+	sec =3D btf__type_by_id(obj->btf, obj->efile.btf_maps_sec_btf_id);
+	if (!sec)
+		return -EINVAL;
+
+	symbols =3D obj->efile.symbols;
+	nrels =3D shdr->sh_size / shdr->sh_entsize;
+	for (i =3D 0; i < nrels; i++) {
+		if (!gelf_getrel(data, i, &rel)) {
+			pr_warn(".maps relo #%d: failed to get ELF relo\n", i);
+			return -LIBBPF_ERRNO__FORMAT;
+		}
+		if (!gelf_getsym(symbols, GELF_R_SYM(rel.r_info), &sym)) {
+			pr_warn(".maps relo #%d: symbol %zx not found\n",
+				i, (size_t)GELF_R_SYM(rel.r_info));
+			return -LIBBPF_ERRNO__FORMAT;
+		}
+		name =3D elf_strptr(obj->efile.elf, obj->efile.strtabidx,
+				  sym.st_name) ? : "<?>";
+		if (sym.st_shndx !=3D obj->efile.btf_maps_shndx) {
+			pr_warn(".maps relo #%d: '%s' isn't a BTF-defined map\n",
+				i, name);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+
+		pr_debug(".maps relo #%d: for %zd value %zd rel.r_offset %zu name %d (=
'%s')\n",
+			 i, (ssize_t)(rel.r_info >> 32), (size_t)sym.st_value,
+			 (size_t)rel.r_offset, sym.st_name, name);
+
+		for (j =3D 0; j < obj->nr_maps; j++) {
+			map =3D &obj->maps[j];
+			if (map->sec_idx !=3D obj->efile.btf_maps_shndx)
+				continue;
+
+			vi =3D btf_var_secinfos(sec) + map->btf_var_idx;
+			if (vi->offset <=3D rel.r_offset &&
+			    rel.r_offset + sizeof(void *) <=3D vi->offset + vi->size)
+				break;
+		}
+		if (j =3D=3D obj->nr_maps) {
+			pr_warn(".maps relo #%d: cannot find map '%s' at rel.r_offset %zu\n",
+				i, name, (size_t)rel.r_offset);
+			return -EINVAL;
+		}
+
+		if (!bpf_map_type__is_map_in_map(map->def.type))
+			return -EINVAL;
+		if (map->def.type =3D=3D BPF_MAP_TYPE_HASH_OF_MAPS &&
+		    map->def.key_size !=3D sizeof(int)) {
+			pr_warn(".maps relo #%d: hash-of-maps '%s' should have key size %zu.\=
n",
+				i, map->name, sizeof(int));
+			return -EINVAL;
+		}
+
+		targ_map =3D bpf_object__find_map_by_name(obj, name);
+		if (!targ_map)
+			return -ESRCH;
+
+		var =3D btf__type_by_id(obj->btf, vi->type);
+		def =3D skip_mods_and_typedefs(obj->btf, var->type, NULL);
+		if (btf_vlen(def) =3D=3D 0)
+			return -EINVAL;
+		member =3D btf_members(def) + btf_vlen(def) - 1;
+		mname =3D btf__name_by_offset(obj->btf, member->name_off);
+		if (strcmp(mname, "values"))
+			return -EINVAL;
+
+		moff =3D btf_member_bit_offset(def, btf_vlen(def) - 1) / 8;
+		if (rel.r_offset - vi->offset < moff)
+			return -EINVAL;
+
+		moff =3D rel.r_offset - vi->offset - moff;
+		if (moff % ptr_sz)
+			return -EINVAL;
+		moff /=3D ptr_sz;
+		if (moff >=3D map->init_slots_sz) {
+			new_sz =3D moff + 1;
+			tmp =3D realloc(map->init_slots, new_sz * ptr_sz);
+			if (!tmp)
+				return -ENOMEM;
+			map->init_slots =3D tmp;
+			memset(map->init_slots + map->init_slots_sz, 0,
+			       (new_sz - map->init_slots_sz) * ptr_sz);
+			map->init_slots_sz =3D new_sz;
+		}
+		map->init_slots[moff] =3D targ_map;
+
+		pr_debug(".maps relo #%d: map '%s' slot [%d] points to map '%s'\n",
+			 i, map->name, moff, name);
+	}
+
+	return 0;
+}
=20
 static int bpf_object__collect_reloc(struct bpf_object *obj)
 {
@@ -4898,21 +5130,17 @@ static int bpf_object__collect_reloc(struct bpf_o=
bject *obj)
 		}
=20
 		if (idx =3D=3D obj->efile.st_ops_shndx) {
-			err =3D bpf_object__collect_struct_ops_map_reloc(obj,
-								       shdr,
-								       data);
-			if (err)
-				return err;
-			continue;
-		}
-
-		prog =3D bpf_object__find_prog_by_idx(obj, idx);
-		if (!prog) {
-			pr_warn("relocation failed: no section(%d)\n", idx);
-			return -LIBBPF_ERRNO__RELOC;
+			err =3D bpf_object__collect_st_ops_relos(obj, shdr, data);
+		} else if (idx =3D=3D obj->efile.btf_maps_shndx) {
+			err =3D bpf_object__collect_map_relos(obj, shdr, data);
+		} else {
+			prog =3D bpf_object__find_prog_by_idx(obj, idx);
+			if (!prog) {
+				pr_warn("relocation failed: no prog in section(%d)\n", idx);
+				return -LIBBPF_ERRNO__RELOC;
+			}
+			err =3D bpf_program__collect_reloc(prog, shdr, data, obj);
 		}
-
-		err =3D bpf_program__collect_reloc(prog, shdr, data, obj);
 		if (err)
 			return err;
 	}
@@ -5984,6 +6212,14 @@ static void bpf_map__destroy(struct bpf_map *map)
 	map->priv =3D NULL;
 	map->clear_priv =3D NULL;
=20
+	if (map->inner_map) {
+		bpf_map__destroy(map->inner_map);
+		zfree(&map->inner_map);
+	}
+
+	zfree(&map->init_slots);
+	map->init_slots_sz =3D 0;
+
 	if (map->mmaped) {
 		munmap(map->mmaped, bpf_map_mmap_sz(map));
 		map->mmaped =3D NULL;
@@ -6543,9 +6779,8 @@ static struct bpf_map *find_struct_ops_map_by_offse=
t(struct bpf_object *obj,
 }
=20
 /* Collect the reloc from ELF and populate the st_ops->progs[] */
-static int bpf_object__collect_struct_ops_map_reloc(struct bpf_object *o=
bj,
-						    GElf_Shdr *shdr,
-						    Elf_Data *data)
+static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
+					    GElf_Shdr *shdr, Elf_Data *data)
 {
 	const struct btf_member *member;
 	struct bpf_struct_ops *st_ops;
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c b/to=
ols/testing/selftests/bpf/prog_tests/btf_map_in_map.c
new file mode 100644
index 000000000000..f7ee8fa377ad
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <test_progs.h>
+
+#include "test_btf_map_in_map.skel.h"
+
+void test_btf_map_in_map(void)
+{
+	int duration =3D 0, err, key =3D 0, val;
+	struct test_btf_map_in_map* skel;
+
+	skel =3D test_btf_map_in_map__open_and_load();
+	if (CHECK(!skel, "skel_open", "failed to open&load skeleton\n"))
+		return;
+
+	err =3D test_btf_map_in_map__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* inner1 =3D input, inner2 =3D input + 1 */
+	val =3D bpf_map__fd(skel->maps.inner_map1);
+	bpf_map_update_elem(bpf_map__fd(skel->maps.outer_arr), &key, &val, 0);
+	val =3D bpf_map__fd(skel->maps.inner_map2);
+	bpf_map_update_elem(bpf_map__fd(skel->maps.outer_hash), &key, &val, 0);
+	skel->bss->input =3D 1;
+	usleep(1);
+
+	bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map1), &key, &val);
+	CHECK(val !=3D 1, "inner1", "got %d !=3D exp %d\n", val, 1);
+	bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map2), &key, &val);
+	CHECK(val !=3D 2, "inner2", "got %d !=3D exp %d\n", val, 2);
+
+	/* inner1 =3D input + 1, inner2 =3D input */
+	val =3D bpf_map__fd(skel->maps.inner_map2);
+	bpf_map_update_elem(bpf_map__fd(skel->maps.outer_arr), &key, &val, 0);
+	val =3D bpf_map__fd(skel->maps.inner_map1);
+	bpf_map_update_elem(bpf_map__fd(skel->maps.outer_hash), &key, &val, 0);
+	skel->bss->input =3D 3;
+	usleep(1);
+
+	bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map1), &key, &val);
+	CHECK(val !=3D 4, "inner1", "got %d !=3D exp %d\n", val, 4);
+	bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map2), &key, &val);
+	CHECK(val !=3D 3, "inner2", "got %d !=3D exp %d\n", val, 3);
+
+cleanup:
+	test_btf_map_in_map__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_btf_map_in_map.c b/to=
ols/testing/selftests/bpf/progs/test_btf_map_in_map.c
new file mode 100644
index 000000000000..733d16352316
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_btf_map_in_map.c
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020 Facebook */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct inner_map {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, int);
+	__type(value, int);
+} inner_map1 SEC(".maps"),
+  inner_map2 SEC(".maps");
+
+struct outer_arr {
+	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
+	__uint(max_entries, 3);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	/* it's possible to use anonymous struct as inner map definition here *=
/
+	__inner(values, struct {
+		__uint(type, BPF_MAP_TYPE_ARRAY);
+		/* changing max_entries to 2 will fail during load
+		 * due to incompatibility with inner_map definition */
+		__uint(max_entries, 1);
+		__type(key, int);
+		__type(value, int);
+	});
+} outer_arr SEC(".maps") =3D {
+	/* (void *) cast is necessary because we didn't use `struct inner_map`
+	 * in __inner(values, ...)
+	 * Actually, a conscious effort is required to screw up initialization
+	 * of inner map slots, which is a great thing!
+	 */
+	.values =3D { (void *)&inner_map1, 0, (void *)&inner_map2 },
+};
+
+struct outer_hash {
+	__uint(type, BPF_MAP_TYPE_HASH_OF_MAPS);
+	__uint(max_entries, 5);
+	__uint(key_size, sizeof(int));
+	/* Here everything works flawlessly due to reuse of struct inner_map
+	 * and compiler will complain at the attempt to use non-inner_map
+	 * references below. This is great experience.
+	 */
+	__inner(values, struct inner_map);
+} outer_hash SEC(".maps") =3D {
+	.values =3D {
+		[0] =3D &inner_map2,
+		[4] =3D &inner_map1,
+	},
+};
+
+int input =3D 0;
+
+SEC("raw_tp/sys_enter")
+int handle__sys_enter(void *ctx)
+{
+	struct inner_map *inner_map;
+	int key =3D 0, val;
+
+	inner_map =3D bpf_map_lookup_elem(&outer_arr, &key);
+	if (!inner_map)
+		return 1;
+	val =3D input;
+	bpf_map_update_elem(inner_map, &key, &val, 0);
+
+	inner_map =3D bpf_map_lookup_elem(&outer_hash, &key);
+	if (!inner_map)
+		return 1;
+	val =3D input + 1;
+	bpf_map_update_elem(inner_map, &key, &val, 0);
+
+	return 0;
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.24.1

