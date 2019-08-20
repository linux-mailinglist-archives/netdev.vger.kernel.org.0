Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2043495DBA
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 13:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbfHTLrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 07:47:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729801AbfHTLry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 07:47:54 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E045911A06
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 11:47:53 +0000 (UTC)
Received: by mail-ed1-f71.google.com with SMTP id r25so3990138edp.20
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 04:47:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e3hicCK+0LUzOIEFl1a9lvWpJ1r2chg7J2NEMGUmxfc=;
        b=bop3MP4JduSnj1nEXew2ZYUssODuZ+hpUAE6kzpIVSnBA0LDmK5oV4XW6grnpB/x0/
         RAbM/dcWqdvaeEntBoXiwDHLyi+hysDfPrMvc+0AnXLucJa5yR+Eq5lQ7gq1AElC4OsT
         MHawM2/Gkz1dcB96KKZlAQADyUPtQRjdwLg4lkOshxtJfkDACKF/1CpfQ6NQkqkz7lKi
         ggNu4NZD0pw74krVbUvNNansXb6yfB/nrVdFHq+01DSU70wAyWsWq4pxt2EBB2UJEC1x
         CofhaeMkAg3G7pvufDFxe6z57UDVTnGvsHphA1BshoqQdTpzVSOe59JHhbjh2h4L1LCG
         BioQ==
X-Gm-Message-State: APjAAAVHRddoUwXzqkdCUpgwyMxl/gesO0ivFkalF222UrlXmjockT/f
        fQP+25+3Ipf/6d1IP+AzG1U9AoJYmA2zchLY4H6OkIiheP6Uyh4ZoSB72iB44/WjS6Di3XvasG8
        CMCN/rSfKU566cGGp
X-Received: by 2002:a50:90c4:: with SMTP id d4mr30899582eda.107.1566301672611;
        Tue, 20 Aug 2019 04:47:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzX/55Z6rmNfk7pcnzfUrRPTlXmT5VYKM6lfC0cYCQGatrK7ElfM4sNtBOHnFeN/0JQzwrCgA==
X-Received: by 2002:a50:90c4:: with SMTP id d4mr30899558eda.107.1566301672322;
        Tue, 20 Aug 2019 04:47:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id k12sm3399451edr.84.2019.08.20.04.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 04:47:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3ADD1181CE4; Tue, 20 Aug 2019 13:47:51 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC bpf-next 2/5] libbpf: Add support for auto-pinning of maps with reuse on program load
Date:   Tue, 20 Aug 2019 13:47:03 +0200
Message-Id: <20190820114706.18546-3-toke@redhat.com>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20190820114706.18546-1-toke@redhat.com>
References: <20190820114706.18546-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for automatically pinning maps on program load to libbpf.
This is needed for porting iproute2 bpf support to libbpf, but is also
useful in other contexts.

The semantics are modelled on those of the same functionality in iproute2,
namely:

- A path can be supplied in bpf_prog_load_attr specifying the directory
  that maps should be pinned into.

- Only maps that specify a non-zero value in its 'pinning' definition
  attribute will be pinned in the automatic mode.

- If an existing pinning is found at the pinning destination, its
  attributes will be compared and if they match, the existing map will be
  reused instead of creating a new map.

A subsequent commit will expand the functionality to enable programs to
support different pinning paths for different values of the map pinning
attribute, similar to what iproute2 does today.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c | 161 ++++++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.h |   8 ++
 2 files changed, 168 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2233f919dd88..6d372a965c9d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -220,6 +220,7 @@ struct bpf_map {
 	size_t sec_offset;
 	int map_ifindex;
 	int inner_map_fd;
+	int pin_reused;
 	struct bpf_map_def def;
 	__u32 btf_key_type_id;
 	__u32 btf_value_type_id;
@@ -3994,8 +3995,10 @@ int bpf_map__unpin(struct bpf_map *map, const char *path)
 	return 0;
 }
 
-int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
+int bpf_object__pin_maps2(struct bpf_object *obj, const char *path,
+			  enum bpf_pin_mode mode)
 {
+	int explicit = (mode == BPF_PIN_MODE_EXPLICIT);
 	struct bpf_map *map;
 	int err;
 
@@ -4015,6 +4018,9 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 		char buf[PATH_MAX];
 		int len;
 
+		if ((explicit && !map->def.pinning) || map->pin_reused)
+			continue;
+
 		len = snprintf(buf, PATH_MAX, "%s/%s", path,
 			       bpf_map__name(map));
 		if (len < 0) {
@@ -4037,6 +4043,9 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 		char buf[PATH_MAX];
 		int len;
 
+		if ((explicit && !map->def.pinning) || map->pin_reused)
+			continue;
+
 		len = snprintf(buf, PATH_MAX, "%s/%s", path,
 			       bpf_map__name(map));
 		if (len < 0)
@@ -4050,6 +4059,11 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 	return err;
 }
 
+int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
+{
+	return bpf_object__pin_maps2(obj, path, BPF_PIN_MODE_ALL);
+}
+
 int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
 {
 	struct bpf_map *map;
@@ -4802,6 +4816,141 @@ int bpf_prog_load(const char *file, enum bpf_prog_type type,
 	return bpf_prog_load_xattr(&attr, pobj, prog_fd);
 }
 
+static int bpf_read_map_info(int fd, struct bpf_map_def *map,
+			     enum bpf_prog_type *type)
+{
+	unsigned int val, owner_type = 0;
+	char file[PATH_MAX], buff[4096];
+	FILE *fp;
+
+	snprintf(file, sizeof(file), "/proc/%d/fdinfo/%d", getpid(), fd);
+	memset(map, 0, sizeof(*map));
+
+	fp = fopen(file, "r");
+	if (!fp) {
+		pr_warning("No procfs support?!\n");
+		return -EIO;
+	}
+
+	while (fgets(buff, sizeof(buff), fp)) {
+		if (sscanf(buff, "map_type:\t%u", &val) == 1)
+			map->type = val;
+		else if (sscanf(buff, "key_size:\t%u", &val) == 1)
+			map->key_size = val;
+		else if (sscanf(buff, "value_size:\t%u", &val) == 1)
+			map->value_size = val;
+		else if (sscanf(buff, "max_entries:\t%u", &val) == 1)
+			map->max_entries = val;
+		else if (sscanf(buff, "map_flags:\t%i", &val) == 1)
+			map->map_flags = val;
+		else if (sscanf(buff, "owner_prog_type:\t%i", &val) == 1)
+			owner_type = val;
+	}
+
+	fclose(fp);
+	if (type)
+		*type  = owner_type;
+
+	return 0;
+}
+
+static void bpf_map_pin_report(const struct bpf_map_def *pin,
+			       const struct bpf_map_def *obj)
+{
+	pr_warning("Map specification differs from pinned file!\n");
+
+	if (obj->type != pin->type)
+		pr_warning(" - Type:         %u (obj) != %u (pin)\n",
+			   obj->type, pin->type);
+	if (obj->key_size != pin->key_size)
+		pr_warning(" - Key size:     %u (obj) != %u (pin)\n",
+			   obj->key_size, pin->key_size);
+	if (obj->value_size != pin->value_size)
+		pr_warning(" - Value size:   %u (obj) != %u (pin)\n",
+			   obj->value_size, pin->value_size);
+	if (obj->max_entries != pin->max_entries)
+		pr_warning(" - Max entries:    %u (obj) != %u (pin)\n",
+			   obj->max_entries, pin->max_entries);
+	if (obj->map_flags != pin->map_flags)
+		pr_warning(" - Flags:        %#x (obj) != %#x (pin)\n",
+			   obj->map_flags, pin->map_flags);
+
+	pr_warning("\n");
+}
+
+
+
+static int bpf_map_selfcheck_pinned(int fd, const struct bpf_map_def *map,
+				    int length, enum bpf_prog_type type)
+{
+	enum bpf_prog_type owner_type = 0;
+	struct bpf_map_def tmp, zero = {};
+	int ret;
+
+	ret = bpf_read_map_info(fd, &tmp, &owner_type);
+	if (ret < 0)
+		return ret;
+
+	/* The decision to reject this is on kernel side eventually, but
+	 * at least give the user a chance to know what's wrong.
+	 */
+	if (owner_type && owner_type != type)
+		pr_warning("Program array map owner types differ: %u (obj) != %u (pin)\n",
+			   type, owner_type);
+
+	if (!memcmp(&tmp, map, length)) {
+		return 0;
+	} else {
+		/* If kernel doesn't have eBPF-related fdinfo, we cannot do much,
+		 * so just accept it. We know we do have an eBPF fd and in this
+		 * case, everything is 0. It is guaranteed that no such map exists
+		 * since map type of 0 is unloadable BPF_MAP_TYPE_UNSPEC.
+		 */
+		if (!memcmp(&tmp, &zero, length))
+			return 0;
+
+		bpf_map_pin_report(&tmp, map);
+		return -EINVAL;
+	}
+}
+
+
+int bpf_probe_pinned(const struct bpf_map *map,
+		     const struct bpf_prog_load_attr *attr)
+{
+	const char *name = bpf_map__name(map);
+	char buf[PATH_MAX];
+	int fd, len, ret;
+
+	if (!attr->auto_pin_path)
+		return -ENOENT;
+
+	len = snprintf(buf, PATH_MAX, "%s/%s", attr->auto_pin_path,
+		       name);
+	if (len < 0)
+		return -EINVAL;
+	else if (len >= PATH_MAX)
+		return -ENAMETOOLONG;
+
+	fd = bpf_obj_get(buf);
+	if (fd <= 0)
+		return fd;
+
+	ret = bpf_map_selfcheck_pinned(fd, &map->def,
+				       offsetof(struct bpf_map_def,
+						map_id),
+				       attr->prog_type);
+	if (ret < 0) {
+		close(fd);
+		pr_warning("Map \'%s\' self-check failed!\n", name);
+		return ret;
+	}
+	if (attr->log_level)
+		pr_debug("Map \'%s\' loaded as pinned!\n", name);
+
+	return fd;
+}
+
 int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 			struct bpf_object **pobj, int *prog_fd)
 {
@@ -4853,8 +5002,14 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 	}
 
 	bpf_object__for_each_map(map, obj) {
+		int fd;
+
 		if (!bpf_map__is_offload_neutral(map))
 			map->map_ifindex = attr->ifindex;
+
+		fd = bpf_probe_pinned(map, attr);
+		if (fd > 0 && !bpf_map__reuse_fd(map, fd))
+			map->pin_reused = 1;
 	}
 
 	if (!first_prog) {
@@ -4869,6 +5024,10 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 		return -EINVAL;
 	}
 
+	if (attr->auto_pin_path)
+		bpf_object__pin_maps2(obj, attr->auto_pin_path,
+				      BPF_PIN_MODE_EXPLICIT);
+
 	*pobj = obj;
 	*prog_fd = bpf_program__fd(first_prog);
 	return 0;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 5facba6ea1e1..3c5c3256e22d 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -67,6 +67,11 @@ struct bpf_object_open_attr {
 	enum bpf_prog_type prog_type;
 };
 
+enum bpf_pin_mode {
+	BPF_PIN_MODE_ALL = 0,
+	BPF_PIN_MODE_EXPLICIT,
+};
+
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
 bpf_object__open_xattr(struct bpf_object_open_attr *attr);
@@ -79,6 +84,8 @@ int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 			     __u32 *size);
 int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
 				__u32 *off);
+LIBBPF_API int bpf_object__pin_maps2(struct bpf_object *obj, const char *path,
+				     enum bpf_pin_mode mode);
 LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const char *path);
 LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
 				      const char *path);
@@ -353,6 +360,7 @@ struct bpf_prog_load_attr {
 	int ifindex;
 	int log_level;
 	int prog_flags;
+	const char *auto_pin_path;
 };
 
 LIBBPF_API int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
-- 
2.22.1

