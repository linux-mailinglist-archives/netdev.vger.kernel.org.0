Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48C620291A
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 08:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgFUGVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 02:21:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40064 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729296AbgFUGVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 02:21:35 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05L6G27e029600
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 23:21:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=WtbHcKoo9zgpNdU92esspKAW4w/WK00h84H8CdkSglw=;
 b=J/05DqK1uhkY91OohTdKKj0FxvlUd5kEI25aYYhsQEbjtY9tORTtSm2JnO2w2qLkInMr
 kL1YHfOgo6/+UmeAC7/oFcZhKP8tsyN0LXTfcmHnxft+jNLDKRkKlSYx9jp9WUrik8fE
 oPbQTeXoKnPvaWsfjrFQquSKMvwwepp8ubQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31sfykjm1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 23:21:33 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 20 Jun 2020 23:21:32 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id ACCF12EC154D; Sat, 20 Jun 2020 23:21:21 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: add a bunch of attribute getters/setters for map definitions
Date:   Sat, 20 Jun 2020 23:21:12 -0700
Message-ID: <20200621062112.3006313-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-20_16:2020-06-19,2020-06-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=8 adultscore=0 cotscore=-2147483648 impostorscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006210051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a bunch of getter for various aspects of BPF map. Some of these attri=
bute
(e.g., key_size, value_size, type, etc) are available right now in struct
bpf_map_def, but this patch adds getter allowing to fetch them individual=
ly.
bpf_map_def approach isn't very scalable, when ABI stability requirements=
 are
taken into account. It's much easier to extend libbpf and add support for=
 new
features, when each aspect of BPF map has separate getter/setter.

Getters follow the common naming convention of not explicitly having "get=
" in
its name: bpf_map__type() returns map type, bpf_map__key_size() returns
key_size. Setters, though, explicitly have set in their name:
bpf_map__set_type(), bpf_map__set_key_size().

This patch ensures we now have a getter and a setter for the following
map attributes:
  - type;
  - max_entries;
  - map_flags;
  - numa_node;
  - key_size;
  - value_size;
  - ifindex.

bpf_map__resize() enforces unnecessary restriction of max_entries > 0. It=
 is
unnecessary, because libbpf actually supports zero max_entries for some c=
ases
(e.g., for PERF_EVENT_ARRAY map) and treats it specially during map creat=
ion
time. To allow setting max_entries=3D0, new bpf_map__set_max_entries() se=
tter is
added. bpf_map__resize()'s behavior is preserved for backwards compatibil=
ity
reasons.

Map ifindex getter is added as well. There is a setter already, but no
corresponding getter. Fix this assymetry as well. bpf_map__set_ifindex()
itself is converted from void function into error-returning one, similar =
to
other setters. The only error returned right now is -EBUSY, if BPF map is
already loaded and has corresponding FD.

One lacking attribute with no ability to get/set or even specify it
declaratively is numa_node. This patch fixes this gap and both adds
programmatic getter/setter, as well as adds support for numa_node field i=
n
BTF-defined map.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 100 ++++++++++++++++++++++++++++++++++++---
 tools/lib/bpf/libbpf.h   |  30 ++++++++++--
 tools/lib/bpf/libbpf.map |  14 ++++++
 3 files changed, 134 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 477c679ed945..259a6360475f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -310,6 +310,7 @@ struct bpf_map {
 	int map_ifindex;
 	int inner_map_fd;
 	struct bpf_map_def def;
+	__u32 numa_node;
 	__u32 btf_var_idx;
 	__u32 btf_key_type_id;
 	__u32 btf_value_type_id;
@@ -1957,6 +1958,10 @@ static int parse_btf_map_def(struct bpf_object *ob=
j,
 				return -EINVAL;
 			pr_debug("map '%s': found map_flags =3D %u.\n",
 				 map->name, map->def.map_flags);
+		} else if (strcmp(name, "numa_node") =3D=3D 0) {
+			if (!get_map_field_int(map->name, obj->btf, m, &map->numa_node))
+				return -EINVAL;
+			pr_debug("map '%s': found numa_node =3D %u.\n", map->name, map->numa_=
node);
 		} else if (strcmp(name, "key_size") =3D=3D 0) {
 			__u32 sz;
=20
@@ -3222,20 +3227,27 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd=
)
 	return err;
 }
=20
-int bpf_map__resize(struct bpf_map *map, __u32 max_entries)
+__u32 bpf_map__max_entries(const struct bpf_map *map)
 {
-	if (!map || !max_entries)
-		return -EINVAL;
+	return map->def.max_entries;
+}
=20
-	/* If map already created, its attributes can't be changed. */
+int bpf_map__set_max_entries(struct bpf_map *map, __u32 max_entries)
+{
 	if (map->fd >=3D 0)
 		return -EBUSY;
-
 	map->def.max_entries =3D max_entries;
-
 	return 0;
 }
=20
+int bpf_map__resize(struct bpf_map *map, __u32 max_entries)
+{
+	if (!map || !max_entries)
+		return -EINVAL;
+
+	return bpf_map__set_max_entries(map, max_entries);
+}
+
 static int
 bpf_object__probe_loading(struct bpf_object *obj)
 {
@@ -3603,6 +3615,7 @@ static int bpf_object__create_map(struct bpf_object=
 *obj, struct bpf_map *map)
 	create_attr.map_flags =3D def->map_flags;
 	create_attr.key_size =3D def->key_size;
 	create_attr.value_size =3D def->value_size;
+	create_attr.numa_node =3D map->numa_node;
=20
 	if (def->type =3D=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY && !def->max_entries=
) {
 		int nr_cpus;
@@ -7088,6 +7101,71 @@ const char *bpf_map__name(const struct bpf_map *ma=
p)
 	return map ? map->name : NULL;
 }
=20
+enum bpf_map_type bpf_map__type(const struct bpf_map *map)
+{
+	return map->def.type;
+}
+
+int bpf_map__set_type(struct bpf_map *map, enum bpf_map_type type)
+{
+	if (map->fd >=3D 0)
+		return -EBUSY;
+	map->def.type =3D type;
+	return 0;
+}
+
+__u32 bpf_map__map_flags(const struct bpf_map *map)
+{
+	return map->def.map_flags;
+}
+
+int bpf_map__set_map_flags(struct bpf_map *map, __u32 flags)
+{
+	if (map->fd >=3D 0)
+		return -EBUSY;
+	map->def.map_flags =3D flags;
+	return 0;
+}
+
+__u32 bpf_map__numa_node(const struct bpf_map *map)
+{
+	return map->numa_node;
+}
+
+int bpf_map__set_numa_node(struct bpf_map *map, __u32 numa_node)
+{
+	if (map->fd >=3D 0)
+		return -EBUSY;
+	map->numa_node =3D numa_node;
+	return 0;
+}
+
+__u32 bpf_map__key_size(const struct bpf_map *map)
+{
+	return map->def.key_size;
+}
+
+int bpf_map__set_key_size(struct bpf_map *map, __u32 size)
+{
+	if (map->fd >=3D 0)
+		return -EBUSY;
+	map->def.key_size =3D size;
+	return 0;
+}
+
+__u32 bpf_map__value_size(const struct bpf_map *map)
+{
+	return map->def.value_size;
+}
+
+int bpf_map__set_value_size(struct bpf_map *map, __u32 size)
+{
+	if (map->fd >=3D 0)
+		return -EBUSY;
+	map->def.value_size =3D size;
+	return 0;
+}
+
 __u32 bpf_map__btf_key_type_id(const struct bpf_map *map)
 {
 	return map ? map->btf_key_type_id : 0;
@@ -7140,9 +7218,17 @@ bool bpf_map__is_internal(const struct bpf_map *ma=
p)
 	return map->libbpf_type !=3D LIBBPF_MAP_UNSPEC;
 }
=20
-void bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex)
+__u32 bpf_map__ifindex(const struct bpf_map *map)
+{
+	return map->map_ifindex;
+}
+
+int bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex)
 {
+	if (map->fd >=3D 0)
+		return -EBUSY;
 	map->map_ifindex =3D ifindex;
+	return 0;
 }
=20
 int bpf_map__set_inner_map_fd(struct bpf_map *map, int fd)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 334437af3014..fdd279fb1866 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -418,11 +418,38 @@ bpf_map__next(const struct bpf_map *map, const stru=
ct bpf_object *obj);
 LIBBPF_API struct bpf_map *
 bpf_map__prev(const struct bpf_map *map, const struct bpf_object *obj);
=20
+/* get/set map FD */
 LIBBPF_API int bpf_map__fd(const struct bpf_map *map);
+LIBBPF_API int bpf_map__reuse_fd(struct bpf_map *map, int fd);
+/* get map definition */
 LIBBPF_API const struct bpf_map_def *bpf_map__def(const struct bpf_map *=
map);
+/* get map name */
 LIBBPF_API const char *bpf_map__name(const struct bpf_map *map);
+/* get/set map type */
+LIBBPF_API enum bpf_map_type bpf_map__type(const struct bpf_map *map);
+LIBBPF_API int bpf_map__set_type(struct bpf_map *map, enum bpf_map_type =
type);
+/* get/set map size (max_entries) */
+LIBBPF_API __u32 bpf_map__max_entries(const struct bpf_map *map);
+LIBBPF_API int bpf_map__set_max_entries(struct bpf_map *map, __u32 max_e=
ntries);
+LIBBPF_API int bpf_map__resize(struct bpf_map *map, __u32 max_entries);
+/* get/set map flags */
+LIBBPF_API __u32 bpf_map__map_flags(const struct bpf_map *map);
+LIBBPF_API int bpf_map__set_map_flags(struct bpf_map *map, __u32 flags);
+/* get/set map NUMA node */
+LIBBPF_API __u32 bpf_map__numa_node(const struct bpf_map *map);
+LIBBPF_API int bpf_map__set_numa_node(struct bpf_map *map, __u32 numa_no=
de);
+/* get/set map key size */
+LIBBPF_API __u32 bpf_map__key_size(const struct bpf_map *map);
+LIBBPF_API int bpf_map__set_key_size(struct bpf_map *map, __u32 size);
+/* get/set map value size */
+LIBBPF_API __u32 bpf_map__value_size(const struct bpf_map *map);
+LIBBPF_API int bpf_map__set_value_size(struct bpf_map *map, __u32 size);
+/* get map key/value BTF type IDs */
 LIBBPF_API __u32 bpf_map__btf_key_type_id(const struct bpf_map *map);
 LIBBPF_API __u32 bpf_map__btf_value_type_id(const struct bpf_map *map);
+/* get/set map if_index */
+LIBBPF_API __u32 bpf_map__ifindex(const struct bpf_map *map);
+LIBBPF_API int bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex);
=20
 typedef void (*bpf_map_clear_priv_t)(struct bpf_map *, void *);
 LIBBPF_API int bpf_map__set_priv(struct bpf_map *map, void *priv,
@@ -430,11 +457,8 @@ LIBBPF_API int bpf_map__set_priv(struct bpf_map *map=
, void *priv,
 LIBBPF_API void *bpf_map__priv(const struct bpf_map *map);
 LIBBPF_API int bpf_map__set_initial_value(struct bpf_map *map,
 					  const void *data, size_t size);
-LIBBPF_API int bpf_map__reuse_fd(struct bpf_map *map, int fd);
-LIBBPF_API int bpf_map__resize(struct bpf_map *map, __u32 max_entries);
 LIBBPF_API bool bpf_map__is_offload_neutral(const struct bpf_map *map);
 LIBBPF_API bool bpf_map__is_internal(const struct bpf_map *map);
-LIBBPF_API void bpf_map__set_ifindex(struct bpf_map *map, __u32 ifindex)=
;
 LIBBPF_API int bpf_map__set_pin_path(struct bpf_map *map, const char *pa=
th);
 LIBBPF_API const char *bpf_map__get_pin_path(const struct bpf_map *map);
 LIBBPF_API bool bpf_map__is_pinned(const struct bpf_map *map);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index c914347f5065..9914e0db4859 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -272,4 +272,18 @@ LIBBPF_0.0.9 {
 } LIBBPF_0.0.8;
=20
 LIBBPF_0.1.0 {
+	global:
+		bpf_map__ifindex;
+		bpf_map__key_size;
+		bpf_map__map_flags;
+		bpf_map__max_entries;
+		bpf_map__numa_node;
+		bpf_map__set_key_size;
+		bpf_map__set_map_flags;
+		bpf_map__set_max_entries;
+		bpf_map__set_numa_node;
+		bpf_map__set_type;
+		bpf_map__set_value_size;
+		bpf_map__type;
+		bpf_map__value_size;
 } LIBBPF_0.0.9;
--=20
2.24.1

