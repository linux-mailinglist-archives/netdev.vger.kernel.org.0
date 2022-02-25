Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3CA4C48BC
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 16:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242025AbiBYPYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 10:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiBYPYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 10:24:38 -0500
Received: from mail.tintel.eu (mail.tintel.eu [51.83.127.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD9052E7B;
        Fri, 25 Feb 2022 07:24:02 -0800 (PST)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 2DD2D443B971;
        Fri, 25 Feb 2022 16:23:59 +0100 (CET)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id w5frC7GqIgB7; Fri, 25 Feb 2022 16:23:58 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 85E04443813E;
        Fri, 25 Feb 2022 16:23:58 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.tintel.eu 85E04443813E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux-ipv6.be;
        s=502B7754-045F-11E5-BBC5-64595FD46BE8; t=1645802638;
        bh=iD0jBu37ZJr9EscfZ+evIV/HBHbE8EFNFF4helr1Mt8=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=FW6BvRlvWP6FdiwJLoU9yE36O6SVnhAPoKMnhIHObYWEPqrmrZn+evVTXtzvqw3ak
         cx4iTsx58Q6ljV0EdlEBG7hOiqxuw6ssbmZ7+dm2Qy9yhsOKQpfkK/E01FaD59kiNA
         qShOihCn/O7s3YmfHGrqommDhD1DCooR105RwYS0=
X-Virus-Scanned: amavisd-new at mail.tintel.eu
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id KOsuI6pEIIqM; Fri, 25 Feb 2022 16:23:58 +0100 (CET)
Received: from taz.sof.bg.adlevio.net (unknown [IPv6:2001:67c:21bc:20::10])
        by mail.tintel.eu (Postfix) with ESMTPS id 39FAB42A43B9;
        Fri, 25 Feb 2022 16:23:58 +0100 (CET)
From:   Stijn Tintel <stijn@linux-ipv6.be>
To:     bpf@vger.kernel.org, songliubraving@fb.com, andrii@kernel.org,
        toke@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kpsingh@kernel.org, yhs@fb.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Subject: [PATCH v2] libbpf: fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning
Date:   Fri, 25 Feb 2022 17:23:55 +0200
Message-Id: <20220225152355.315204-1-stijn@linux-ipv6.be>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Rspamd-Pre-Result: action=no action;
        module=multimap;
        Matched map: IP_WHITELIST
X-Rspamd-Queue-Id: 39FAB42A43B9
X-Rspamd-Pre-Result: action=no action;
        module=multimap;
        Matched map: IP_WHITELIST
X-Spamd-Result: default: False [0.00 / 15.00];
        IP_WHITELIST(0.00)[2001:67c:21bc:20::10];
        ASN(0.00)[asn:200533, ipnet:2001:67c:21bc::/48, country:BG]
X-Rspamd-Server: skulls
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a BPF map of type BPF_MAP_TYPE_PERF_EVENT_ARRAY doesn't have the
max_entries parameter set, the map will be created with max_entries set
to the number of available CPUs. When we try to reuse such a pinned map,
map_is_reuse_compat will return false, as max_entries in the map
definition differs from max_entries of the existing map, causing the
following error:

libbpf: couldn't reuse pinned map at '/sys/fs/bpf/m_logging': parameter m=
ismatch

Fix this by overwriting max_entries in the map definition. For this to
work, we need to do this in bpf_object__create_maps, before calling
bpf_object__reuse_map.

Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF o=
bjects")
Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
---
v2: overwrite max_entries in the map definition instead of adding an
    extra check in map_is_reuse_compat, and introduce a helper function
    for this as suggested by Song.
---
 tools/lib/bpf/libbpf.c | 44 ++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7f10dd501a52..133462637b09 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4854,7 +4854,6 @@ static int bpf_object__create_map(struct bpf_object=
 *obj, struct bpf_map *map, b
 	LIBBPF_OPTS(bpf_map_create_opts, create_attr);
 	struct bpf_map_def *def =3D &map->def;
 	const char *map_name =3D NULL;
-	__u32 max_entries;
 	int err =3D 0;
=20
 	if (kernel_supports(obj, FEAT_PROG_NAME))
@@ -4864,21 +4863,6 @@ static int bpf_object__create_map(struct bpf_objec=
t *obj, struct bpf_map *map, b
 	create_attr.numa_node =3D map->numa_node;
 	create_attr.map_extra =3D map->map_extra;
=20
-	if (def->type =3D=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY && !def->max_entries=
) {
-		int nr_cpus;
-
-		nr_cpus =3D libbpf_num_possible_cpus();
-		if (nr_cpus < 0) {
-			pr_warn("map '%s': failed to determine number of system CPUs: %d\n",
-				map->name, nr_cpus);
-			return nr_cpus;
-		}
-		pr_debug("map '%s': setting size to %d\n", map->name, nr_cpus);
-		max_entries =3D nr_cpus;
-	} else {
-		max_entries =3D def->max_entries;
-	}
-
 	if (bpf_map__is_struct_ops(map))
 		create_attr.btf_vmlinux_value_type_id =3D map->btf_vmlinux_value_type_=
id;
=20
@@ -4928,7 +4912,7 @@ static int bpf_object__create_map(struct bpf_object=
 *obj, struct bpf_map *map, b
=20
 	if (obj->gen_loader) {
 		bpf_gen__map_create(obj->gen_loader, def->type, map_name,
-				    def->key_size, def->value_size, max_entries,
+				    def->key_size, def->value_size, def->max_entries,
 				    &create_attr, is_inner ? -1 : map - obj->maps);
 		/* Pretend to have valid FD to pass various fd >=3D 0 checks.
 		 * This fd =3D=3D 0 will not be used with any syscall and will be rese=
t to -1 eventually.
@@ -4937,7 +4921,7 @@ static int bpf_object__create_map(struct bpf_object=
 *obj, struct bpf_map *map, b
 	} else {
 		map->fd =3D bpf_map_create(def->type, map_name,
 					 def->key_size, def->value_size,
-					 max_entries, &create_attr);
+					 def->max_entries, &create_attr);
 	}
 	if (map->fd < 0 && (create_attr.btf_key_type_id ||
 			    create_attr.btf_value_type_id)) {
@@ -4954,7 +4938,7 @@ static int bpf_object__create_map(struct bpf_object=
 *obj, struct bpf_map *map, b
 		map->btf_value_type_id =3D 0;
 		map->fd =3D bpf_map_create(def->type, map_name,
 					 def->key_size, def->value_size,
-					 max_entries, &create_attr);
+					 def->max_entries, &create_attr);
 	}
=20
 	err =3D map->fd < 0 ? -errno : 0;
@@ -5058,6 +5042,24 @@ static int bpf_object_init_prog_arrays(struct bpf_=
object *obj)
 	return 0;
 }
=20
+static int map_set_def_max_entries(struct bpf_map *map)
+{
+	if (map->def.type =3D=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY && !map->def.max=
_entries) {
+		int nr_cpus;
+
+		nr_cpus =3D libbpf_num_possible_cpus();
+		if (nr_cpus < 0) {
+			pr_warn("map '%s': failed to determine number of system CPUs: %d\n",
+				map->name, nr_cpus);
+			return nr_cpus;
+		}
+		pr_debug("map '%s': setting size to %d\n", map->name, nr_cpus);
+		map->def.max_entries =3D nr_cpus;
+	}
+
+	return 0;
+}
+
 static int
 bpf_object__create_maps(struct bpf_object *obj)
 {
@@ -5090,6 +5092,10 @@ bpf_object__create_maps(struct bpf_object *obj)
 			continue;
 		}
=20
+		err =3D map_set_def_max_entries(map);
+		if (err)
+			goto err_out;
+
 		retried =3D false;
 retry:
 		if (map->pin_path) {
--=20
2.34.1

