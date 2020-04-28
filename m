Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520981BB6ED
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 08:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgD1Glx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 02:41:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42002 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbgD1Glx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 02:41:53 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S6elJ0011353
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 23:41:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=rXRPnlyJ1Le4ql5j+itBzfEcDrNAoZksHEOkyDSEpHI=;
 b=Tkl/+9uznVQYjeEtjEYoDOT+HL+CIO1D1CdSVndjN54mREDBIjPPJqCC0k0BpwDo3ZTW
 mJJhjswc73dx+9iOldFM6RZZdKVANHDAQ/WgdJJLSpSvsZkw1zHmb2No7JmVY9oNv+bd
 9s3nQE/TdGBrni8JlTtdzBinFpMvr7TUAY8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30nq53qrdv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 23:41:50 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 23:41:49 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AD6852EC2FA7; Mon, 27 Apr 2020 23:41:46 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <toke@redhat.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/3] libbpf: refactor map creation logic and fix cleanup leak
Date:   Mon, 27 Apr 2020 23:41:38 -0700
Message-ID: <20200428064140.122796-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200428064140.122796-1-andriin@fb.com>
References: <20200428064140.122796-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_03:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 suspectscore=29 impostorscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280057
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out map creation and destruction logic to simplify code and especi=
ally
error handling. Also fix map FD leak in case of partially successful map
creation during bpf_object load operation.

Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF o=
bjects")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 226 ++++++++++++++++++++++-------------------
 1 file changed, 121 insertions(+), 105 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7d10436d7b58..9c845cf4cfcf 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3493,107 +3493,111 @@ bpf_object__populate_internal_map(struct bpf_ob=
ject *obj, struct bpf_map *map)
 	return 0;
 }
=20
+static void bpf_map__destroy(struct bpf_map *map);
+
+static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map=
 *map)
+{
+	struct bpf_create_map_attr create_attr;
+	struct bpf_map_def *def =3D &map->def;
+
+	memset(&create_attr, 0, sizeof(create_attr));
+
+	if (obj->caps.name)
+		create_attr.name =3D map->name;
+	create_attr.map_ifindex =3D map->map_ifindex;
+	create_attr.map_type =3D def->type;
+	create_attr.map_flags =3D def->map_flags;
+	create_attr.key_size =3D def->key_size;
+	create_attr.value_size =3D def->value_size;
+
+	if (def->type =3D=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY && !def->max_entries=
) {
+		int nr_cpus;
+
+		nr_cpus =3D libbpf_num_possible_cpus();
+		if (nr_cpus < 0) {
+			pr_warn("map '%s': failed to determine number of system CPUs: %d\n",
+				map->name, nr_cpus);
+			return nr_cpus;
+		}
+		pr_debug("map '%s': setting size to %d\n", map->name, nr_cpus);
+		create_attr.max_entries =3D nr_cpus;
+	} else {
+		create_attr.max_entries =3D def->max_entries;
+	}
+
+	if (bpf_map__is_struct_ops(map))
+		create_attr.btf_vmlinux_value_type_id =3D
+			map->btf_vmlinux_value_type_id;
+
+	create_attr.btf_fd =3D 0;
+	create_attr.btf_key_type_id =3D 0;
+	create_attr.btf_value_type_id =3D 0;
+	if (obj->btf && !bpf_map_find_btf_info(obj, map)) {
+		create_attr.btf_fd =3D btf__fd(obj->btf);
+		create_attr.btf_key_type_id =3D map->btf_key_type_id;
+		create_attr.btf_value_type_id =3D map->btf_value_type_id;
+	}
+
+	map->fd =3D bpf_create_map_xattr(&create_attr);
+	if (map->fd < 0 && (create_attr.btf_key_type_id ||
+			    create_attr.btf_value_type_id)) {
+		char *cp, errmsg[STRERR_BUFSIZE];
+		int err =3D -errno;
+
+		cp =3D libbpf_strerror_r(err, errmsg, sizeof(errmsg));
+		pr_warn("Error in bpf_create_map_xattr(%s):%s(%d). Retrying without BT=
F.\n",
+			map->name, cp, err);
+		create_attr.btf_fd =3D 0;
+		create_attr.btf_key_type_id =3D 0;
+		create_attr.btf_value_type_id =3D 0;
+		map->btf_key_type_id =3D 0;
+		map->btf_value_type_id =3D 0;
+		map->fd =3D bpf_create_map_xattr(&create_attr);
+	}
+
+	if (map->fd < 0)
+		return -errno;
+
+	return 0;
+}
+
 static int
 bpf_object__create_maps(struct bpf_object *obj)
 {
-	struct bpf_create_map_attr create_attr =3D {};
-	int nr_cpus =3D 0;
-	unsigned int i;
+	struct bpf_map *map;
+	char *cp, errmsg[STRERR_BUFSIZE];
+	unsigned int i, j;
 	int err;
=20
 	for (i =3D 0; i < obj->nr_maps; i++) {
-		struct bpf_map *map =3D &obj->maps[i];
-		struct bpf_map_def *def =3D &map->def;
-		char *cp, errmsg[STRERR_BUFSIZE];
-		int *pfd =3D &map->fd;
+		map =3D &obj->maps[i];
=20
 		if (map->pin_path) {
 			err =3D bpf_object__reuse_map(map);
 			if (err) {
-				pr_warn("error reusing pinned map %s\n",
+				pr_warn("map '%s': error reusing pinned map\n",
 					map->name);
-				return err;
+				goto err_out;
 			}
 		}
=20
 		if (map->fd >=3D 0) {
-			pr_debug("skip map create (preset) %s: fd=3D%d\n",
+			pr_debug("map '%s': skipping creation (preset fd=3D%d)\n",
 				 map->name, map->fd);
 			continue;
 		}
=20
-		if (obj->caps.name)
-			create_attr.name =3D map->name;
-		create_attr.map_ifindex =3D map->map_ifindex;
-		create_attr.map_type =3D def->type;
-		create_attr.map_flags =3D def->map_flags;
-		create_attr.key_size =3D def->key_size;
-		create_attr.value_size =3D def->value_size;
-		if (def->type =3D=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY &&
-		    !def->max_entries) {
-			if (!nr_cpus)
-				nr_cpus =3D libbpf_num_possible_cpus();
-			if (nr_cpus < 0) {
-				pr_warn("failed to determine number of system CPUs: %d\n",
-					nr_cpus);
-				err =3D nr_cpus;
-				goto err_out;
-			}
-			pr_debug("map '%s': setting size to %d\n",
-				 map->name, nr_cpus);
-			create_attr.max_entries =3D nr_cpus;
-		} else {
-			create_attr.max_entries =3D def->max_entries;
-		}
-		create_attr.btf_fd =3D 0;
-		create_attr.btf_key_type_id =3D 0;
-		create_attr.btf_value_type_id =3D 0;
-		if (bpf_map_type__is_map_in_map(def->type) &&
-		    map->inner_map_fd >=3D 0)
-			create_attr.inner_map_fd =3D map->inner_map_fd;
-		if (bpf_map__is_struct_ops(map))
-			create_attr.btf_vmlinux_value_type_id =3D
-				map->btf_vmlinux_value_type_id;
-
-		if (obj->btf && !bpf_map_find_btf_info(obj, map)) {
-			create_attr.btf_fd =3D btf__fd(obj->btf);
-			create_attr.btf_key_type_id =3D map->btf_key_type_id;
-			create_attr.btf_value_type_id =3D map->btf_value_type_id;
-		}
-
-		*pfd =3D bpf_create_map_xattr(&create_attr);
-		if (*pfd < 0 && (create_attr.btf_key_type_id ||
-				 create_attr.btf_value_type_id)) {
-			err =3D -errno;
-			cp =3D libbpf_strerror_r(err, errmsg, sizeof(errmsg));
-			pr_warn("Error in bpf_create_map_xattr(%s):%s(%d). Retrying without B=
TF.\n",
-				map->name, cp, err);
-			create_attr.btf_fd =3D 0;
-			create_attr.btf_key_type_id =3D 0;
-			create_attr.btf_value_type_id =3D 0;
-			map->btf_key_type_id =3D 0;
-			map->btf_value_type_id =3D 0;
-			*pfd =3D bpf_create_map_xattr(&create_attr);
-		}
-
-		if (*pfd < 0) {
-			size_t j;
+		err =3D bpf_object__create_map(obj, map);
+		if (err)
+			goto err_out;
=20
-			err =3D -errno;
-err_out:
-			cp =3D libbpf_strerror_r(err, errmsg, sizeof(errmsg));
-			pr_warn("failed to create map (name: '%s'): %s(%d)\n",
-				map->name, cp, err);
-			pr_perm_msg(err);
-			for (j =3D 0; j < i; j++)
-				zclose(obj->maps[j].fd);
-			return err;
-		}
+		pr_debug("map '%s': created successfully, fd=3D%d\n", map->name,
+			 map->fd);
=20
 		if (bpf_map__is_internal(map)) {
 			err =3D bpf_object__populate_internal_map(obj, map);
 			if (err < 0) {
-				zclose(*pfd);
+				zclose(map->fd);
 				goto err_out;
 			}
 		}
@@ -3601,16 +3605,23 @@ bpf_object__create_maps(struct bpf_object *obj)
 		if (map->pin_path && !map->pinned) {
 			err =3D bpf_map__pin(map, NULL);
 			if (err) {
-				pr_warn("failed to auto-pin map name '%s' at '%s'\n",
-					map->name, map->pin_path);
-				return err;
+				pr_warn("map '%s': failed to auto-pin at '%s': %d\n",
+					map->name, map->pin_path, err);
+				zclose(map->fd);
+				goto err_out;
 			}
 		}
-
-		pr_debug("created map %s: fd=3D%d\n", map->name, *pfd);
 	}
=20
 	return 0;
+
+err_out:
+	cp =3D libbpf_strerror_r(err, errmsg, sizeof(errmsg));
+	pr_warn("map '%s': failed to create: %s(%d)\n", map->name, cp, err);
+	pr_perm_msg(err);
+	for (j =3D 0; j < i; j++)
+		zclose(obj->maps[j].fd);
+	return err;
 }
=20
 static int
@@ -5966,6 +5977,32 @@ int bpf_object__pin(struct bpf_object *obj, const =
char *path)
 	return 0;
 }
=20
+static void bpf_map__destroy(struct bpf_map *map)
+{
+	if (map->clear_priv)
+		map->clear_priv(map, map->priv);
+	map->priv =3D NULL;
+	map->clear_priv =3D NULL;
+
+	if (map->mmaped) {
+		munmap(map->mmaped, bpf_map_mmap_sz(map));
+		map->mmaped =3D NULL;
+	}
+
+	if (map->st_ops) {
+		zfree(&map->st_ops->data);
+		zfree(&map->st_ops->progs);
+		zfree(&map->st_ops->kern_func_off);
+		zfree(&map->st_ops);
+	}
+
+	zfree(&map->name);
+	zfree(&map->pin_path);
+
+	if (map->fd >=3D 0)
+		zclose(map->fd);
+}
+
 void bpf_object__close(struct bpf_object *obj)
 {
 	size_t i;
@@ -5981,29 +6018,8 @@ void bpf_object__close(struct bpf_object *obj)
 	btf__free(obj->btf);
 	btf_ext__free(obj->btf_ext);
=20
-	for (i =3D 0; i < obj->nr_maps; i++) {
-		struct bpf_map *map =3D &obj->maps[i];
-
-		if (map->clear_priv)
-			map->clear_priv(map, map->priv);
-		map->priv =3D NULL;
-		map->clear_priv =3D NULL;
-
-		if (map->mmaped) {
-			munmap(map->mmaped, bpf_map_mmap_sz(map));
-			map->mmaped =3D NULL;
-		}
-
-		if (map->st_ops) {
-			zfree(&map->st_ops->data);
-			zfree(&map->st_ops->progs);
-			zfree(&map->st_ops->kern_func_off);
-			zfree(&map->st_ops);
-		}
-
-		zfree(&map->name);
-		zfree(&map->pin_path);
-	}
+	for (i =3D 0; i < obj->nr_maps; i++)
+		bpf_map__destroy(&obj->maps[i]);
=20
 	zfree(&obj->kconfig);
 	zfree(&obj->externs);
--=20
2.24.1

