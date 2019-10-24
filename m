Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2331DE3397
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 15:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502405AbfJXNLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 09:11:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502397AbfJXNLq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 09:11:46 -0400
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C6D054ACA5
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 13:11:45 +0000 (UTC)
Received: by mail-lf1-f71.google.com with SMTP id l2so2965634lfk.21
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 06:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AoKPNZux9mcVwhG+QjHj+0kfUyilNCwK3MSTTEPXVeA=;
        b=fhpFdi1aCmu/TeMVlXdhjiQKjKWi5EQPjS/+HmFtRykv2Nwq08d/XGPv/nh8M6fe10
         mlXapEoVDBkihXFS1+bJaMptwjimtguukvFAxJOReLLNIxwmDGSc/v3qwDoWTT2NozdD
         lQf0M9nJEs2zWUQY6amC3zUo6SJy/8PEtLykWKEkIeQuPpn7YoDfUQiFp28nTVHX9fQd
         Z0BVyWXMcovvHwfn0qQbQ0fuIGDnZvlcOIcOU23l7mWk9JtL2C+v5KkWvCyha//OtTwW
         8Xp/iyUDn9hP7vCCsNr5SWYcruCN9hyhyUMMreXbOnlRBDktTy14Q58Yz+sLmeI+7KIW
         pfNw==
X-Gm-Message-State: APjAAAXb8HdJXy5+j8Dd1oCValioSizsmuqQx0Tl7yv1skfLy2qAxYhl
        DKHJYGyb46wxqdGz0yEkB/Fni8htczGI1CyCOgkJqNAd2J7QjrUZC8GwJ18AYXHqA13x7+PNw/V
        Rq0MXG/aB/CQu1Jhw
X-Received: by 2002:a19:ad4c:: with SMTP id s12mr27879626lfd.49.1571922704197;
        Thu, 24 Oct 2019 06:11:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwMtSa+DvlqjdaXfcoqOjeinX+L4dp2NS2PNE+1gTY3LuGEL0G6EKJ3RFsJVxWOG/4IxHAytw==
X-Received: by 2002:a19:ad4c:: with SMTP id s12mr27879611lfd.49.1571922703884;
        Thu, 24 Oct 2019 06:11:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id s7sm10287617ljs.16.2019.10.24.06.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:11:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F2CB51804B1; Thu, 24 Oct 2019 15:11:41 +0200 (CEST)
Subject: [PATCH bpf-next v2 4/4] libbpf: Add option to auto-pin maps when
 opening BPF object
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 24 Oct 2019 15:11:41 +0200
Message-ID: <157192270189.234778.14607584397750494265.stgit@toke.dk>
In-Reply-To: <157192269744.234778.11792009511322809519.stgit@toke.dk>
References: <157192269744.234778.11792009511322809519.stgit@toke.dk>
User-Agent: StGit/0.20
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

With the functions added in previous commits that can automatically pin
maps based on their 'pinning' setting, we can support auto-pinning of maps
by the simple setting of an option to bpf_object__open.

Since auto-pinning only does something if any maps actually have a
'pinning' BTF attribute set, we default the new option to enabled, on the
assumption that seamless pinning is what most callers want.

When a map has a pin_path set at load time, libbpf will compare the map
pinned at that location (if any), and if the attributes match, will re-use
that map instead of creating a new one. If no existing map is found, the
newly created map will instead be pinned at the location.

Programs wanting to customise the pinning can override the pinning paths
using bpf_map__set_pin_path() before calling bpf_object__load().

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c |  120 ++++++++++++++++++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf.h |    4 +-
 2 files changed, 119 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 179c9911458d..e911760cd7ff 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1378,7 +1378,29 @@ static int build_pin_path(char *buf, size_t buf_len,
 	return len;
 }
 
-static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps)
+static int bpf_object__build_map_pin_paths(struct bpf_object *obj)
+{
+	struct bpf_map *map;
+	int err, len;
+
+	bpf_object__for_each_map(map, obj) {
+		char buf[PATH_MAX];
+		len = build_pin_path(buf, sizeof(buf), map,
+				     "/sys/fs/bpf", false);
+		if (len == 0)
+			continue;
+		else if (len < 0)
+			return len;
+
+		err = bpf_map__set_pin_path(map, buf);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps,
+				 bool auto_pin_maps)
 {
 	bool strict = !relaxed_maps;
 	int err;
@@ -1395,6 +1417,12 @@ static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps)
 	if (err)
 		return err;
 
+	if (auto_pin_maps) {
+		err = bpf_object__build_map_pin_paths(obj);
+		if (err)
+			return err;
+	}
+
 	if (obj->nr_maps) {
 		qsort(obj->maps, obj->nr_maps, sizeof(obj->maps[0]),
 		      compare_bpf_map);
@@ -1577,7 +1605,8 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 	return 0;
 }
 
-static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps)
+static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
+				   bool auto_pin_maps)
 {
 	Elf *elf = obj->efile.elf;
 	GElf_Ehdr *ep = &obj->efile.ehdr;
@@ -1712,7 +1741,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps)
 	}
 	err = bpf_object__init_btf(obj, btf_data, btf_ext_data);
 	if (!err)
-		err = bpf_object__init_maps(obj, relaxed_maps);
+		err = bpf_object__init_maps(obj, relaxed_maps, auto_pin_maps);
 	if (!err)
 		err = bpf_object__sanitize_and_load_btf(obj);
 	if (!err)
@@ -2288,12 +2317,91 @@ bpf_object__create_maps(struct bpf_object *obj)
 			}
 		}
 
+		if (map->pin_path) {
+			err = bpf_map__pin(map, NULL);
+			if (err)
+				pr_warning("failed to auto-pin map name '%s' at '%s'\n",
+					   map->name, map->pin_path);
+		}
+
 		pr_debug("created map %s: fd=%d\n", map->name, *pfd);
 	}
 
 	return 0;
 }
 
+static int check_map_compat(const struct bpf_map *map,
+			    int map_fd)
+{
+	struct bpf_map_info map_info = {};
+	char msg[STRERR_BUFSIZE];
+	__u32 map_info_len;
+	int err;
+
+	map_info_len = sizeof(map_info);
+	err = bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
+	if (err) {
+		err = -errno;
+		pr_warning("failed to get map info for map FD %d: %s\n",
+			   map_fd, libbpf_strerror_r(err, msg, sizeof(msg)));
+		return err;
+	}
+
+	if (map_info.type != map->def.type ||
+	    map_info.key_size != map->def.key_size ||
+	    map_info.value_size != map->def.value_size ||
+	    map_info.max_entries != map->def.max_entries ||
+	    map_info.map_flags != map->def.map_flags ||
+	    map_info.btf_key_type_id != map->btf_key_type_id ||
+	    map_info.btf_value_type_id != map->btf_value_type_id)
+		return 1;
+
+	return 0;
+}
+
+static int
+bpf_object__check_map_reuse(struct bpf_object *obj)
+{
+	char *cp, errmsg[STRERR_BUFSIZE];
+	struct bpf_map *map;
+	int err;
+
+	bpf_object__for_each_map(map, obj) {
+		int pin_fd;
+
+		if (!map->pin_path)
+			continue;
+
+		pin_fd = bpf_obj_get(map->pin_path);
+		if (pin_fd < 0) {
+			if (errno == ENOENT)
+				continue;
+
+			cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+			pr_warning("Couldn't retrieve pinned map '%s': %s\n",
+				   map->pin_path, cp);
+			return pin_fd;
+		}
+
+		if (check_map_compat(map, pin_fd)) {
+			pr_warning("Couldn't reuse pinned map at '%s': "
+				   "parameter mismatch\n", map->pin_path);
+			close(pin_fd);
+			return -EINVAL;
+		}
+
+		err = bpf_map__reuse_fd(map, pin_fd);
+		if (err) {
+			close(pin_fd);
+			return err;
+		}
+		map->pinned = true;
+		pr_debug("Reused pinned map at '%s'\n", map->pin_path);
+	}
+
+	return 0;
+}
+
 static int
 check_btf_ext_reloc_err(struct bpf_program *prog, int err,
 			void *btf_prog_info, const char *info_name)
@@ -3664,6 +3772,7 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 {
 	struct bpf_object *obj;
 	const char *obj_name;
+	bool auto_pin_maps;
 	char tmp_name[64];
 	bool relaxed_maps;
 	int err;
@@ -3695,11 +3804,13 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 
 	obj->relaxed_core_relocs = OPTS_GET(opts, relaxed_core_relocs, false);
 	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
+	auto_pin_maps = OPTS_GET(opts, auto_pin_maps, true);
 
 	CHECK_ERR(bpf_object__elf_init(obj), err, out);
 	CHECK_ERR(bpf_object__check_endianness(obj), err, out);
 	CHECK_ERR(bpf_object__probe_caps(obj), err, out);
-	CHECK_ERR(bpf_object__elf_collect(obj, relaxed_maps), err, out);
+	CHECK_ERR(bpf_object__elf_collect(obj, relaxed_maps, auto_pin_maps),
+		  err, out);
 	CHECK_ERR(bpf_object__collect_reloc(obj), err, out);
 
 	bpf_object__elf_finish(obj);
@@ -3811,6 +3922,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 
 	obj->loaded = true;
 
+	CHECK_ERR(bpf_object__check_map_reuse(obj), err, out);
 	CHECK_ERR(bpf_object__create_maps(obj), err, out);
 	CHECK_ERR(bpf_object__relocate(obj, attr->target_btf_path), err, out);
 	CHECK_ERR(bpf_object__load_progs(obj, attr->log_level), err, out);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 26a4ed3856e7..d492920fedb3 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -98,8 +98,10 @@ struct bpf_object_open_opts {
 	bool relaxed_maps;
 	/* process CO-RE relocations non-strictly, allowing them to fail */
 	bool relaxed_core_relocs;
+	/* auto-pin maps with 'pinning' attribute set? */
+	bool auto_pin_maps;
 };
-#define bpf_object_open_opts__last_field relaxed_core_relocs
+#define bpf_object_open_opts__last_field auto_pin_maps
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *

