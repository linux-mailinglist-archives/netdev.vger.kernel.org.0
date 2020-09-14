Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF2A26950E
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgINShY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgINSg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:36:26 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA5AC06178A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 11:36:26 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 135so334172pfu.9
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 11:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=9mF1wu9YAVbESEtRpES8F47zk2lYofif/6x6S14NsHU=;
        b=m/8naySINgNLFBdE9Eg5L1cny/nTj2yT4Ke2qBucrj/EmhaKkWqVqBw9DKcWuczucx
         wTSr3RxO+ryAmUWZ15bCuN5IUEy2gVkPaxuYCGY5k2YOjRCBVO308KeMAB1sAG3xxj/k
         ETsH/oGkimTNdEaLrIdyN4p4frKre1tq0yQQbCAPXq/eThq/lwSuzzMqsg+ehVPZBp7d
         1bZZMl0B7oyA3O78kYD0bIrMjmBPyDUfCl8S0rBDbYps/FU2TUkXhioYzM4LBj/zgmvK
         ra+DZmOmzONe26B54lQu+kcpWTEbnM/9+CeaVNaO4WIrcYIaJToeuJclnM39y6Efs8Vh
         K0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9mF1wu9YAVbESEtRpES8F47zk2lYofif/6x6S14NsHU=;
        b=GWSJ93hdB2lEXcacI5xy6B6axDR/ilcszPPEEmVA98/AZeVRTn+4ycNhaaXoH+6SG2
         RkjRqE0polMqRsujcXwmXfC1unnY7jif+5cDsBQHeHMKtjRdxhSZ8tlAPv8PeBGR/NqJ
         JD/5Ntn/GMGBMzJW0PT258Ge/xayn0+0Jny1toxJMZmQYhTo8Qvi3ppdGyR9hXR0pa89
         YpAkUDcb477ZYBqb43ke1nRa+VFt39giag6db03O+dhtbKZUuxYjSCH//mnfwQ2DoSs0
         n0N+YuPBJt/0INpJfrQ0tYMNJG7M5scYZqGulfRhBtl1/k2bNP3Duwrtmw+vOUYzB/iM
         YLMg==
X-Gm-Message-State: AOAM533NsHk4523Ka+KmcYbHHlR4fG06NN5jkNtDn5aCnUHOSrpYU+9g
        a8vQiuJY9KvG+sFHL3ie+FjTe1GL1AILUeEtd2MEiTmP89OmGMIUb6szfMhtpr+Upx7y3MTMMZC
        QuI1y0Ac4eXRGeE1PXNewxPHwhfxLs76zE5o+0rtANP3lM+kwowWz/g==
X-Google-Smtp-Source: ABdhPJxcD9nGOW9pSIN7Db9InDKHwxc992XoH5JXCbwh5oyGKceV3pMMSzmUqWkvVgpvsy+QAJtBF24=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a65:691a:: with SMTP id s26mr12105376pgq.103.1600108585092;
 Mon, 14 Sep 2020 11:36:25 -0700 (PDT)
Date:   Mon, 14 Sep 2020 11:36:14 -0700
In-Reply-To: <20200914183615.2038347-1-sdf@google.com>
Message-Id: <20200914183615.2038347-5-sdf@google.com>
Mime-Version: 1.0
References: <20200914183615.2038347-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH bpf-next v5 4/5] bpftool: support dumping metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YiFei Zhu <zhuyifei@google.com>

Dump metadata in the 'bpftool prog' list if it's present.
For some formatting some BTF code is put directly in the
metadata dumping. Sanity checks on the map and the kind of the btf_type
to make sure we are actually dumping what we are expecting.

A helper jsonw_reset is added to json writer so we can reuse the same
json writer without having extraneous commas.

Sample output:

  $ bpftool prog
  6: cgroup_skb  name prog  tag bcf7977d3b93787c  gpl
  [...]
  	btf_id 4
  	metadata:
  		a = "foo"
  		b = 1

  $ bpftool prog --json --pretty
  [{
          "id": 6,
  [...]
          "btf_id": 4,
          "metadata": {
              "a": "foo",
              "b": 1
          }
      }
  ]

Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/json_writer.c |   6 +
 tools/bpf/bpftool/json_writer.h |   3 +
 tools/bpf/bpftool/prog.c        | 232 ++++++++++++++++++++++++++++++++
 3 files changed, 241 insertions(+)

diff --git a/tools/bpf/bpftool/json_writer.c b/tools/bpf/bpftool/json_writer.c
index 86501cd3c763..7fea83bedf48 100644
--- a/tools/bpf/bpftool/json_writer.c
+++ b/tools/bpf/bpftool/json_writer.c
@@ -119,6 +119,12 @@ void jsonw_pretty(json_writer_t *self, bool on)
 	self->pretty = on;
 }
 
+void jsonw_reset(json_writer_t *self)
+{
+	assert(self->depth == 0);
+	self->sep = '\0';
+}
+
 /* Basic blocks */
 static void jsonw_begin(json_writer_t *self, int c)
 {
diff --git a/tools/bpf/bpftool/json_writer.h b/tools/bpf/bpftool/json_writer.h
index 35cf1f00f96c..8ace65cdb92f 100644
--- a/tools/bpf/bpftool/json_writer.h
+++ b/tools/bpf/bpftool/json_writer.h
@@ -27,6 +27,9 @@ void jsonw_destroy(json_writer_t **self_p);
 /* Cause output to have pretty whitespace */
 void jsonw_pretty(json_writer_t *self, bool on);
 
+/* Reset separator to create new JSON */
+void jsonw_reset(json_writer_t *self);
+
 /* Add property name */
 void jsonw_name(json_writer_t *self, const char *name);
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index f7923414a052..f3eb4f53dd43 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -29,6 +29,9 @@
 #include "main.h"
 #include "xlated_dumper.h"
 
+#define BPF_METADATA_PREFIX "bpf_metadata_"
+#define BPF_METADATA_PREFIX_LEN (sizeof(BPF_METADATA_PREFIX) - 1)
+
 const char * const prog_type_name[] = {
 	[BPF_PROG_TYPE_UNSPEC]			= "unspec",
 	[BPF_PROG_TYPE_SOCKET_FILTER]		= "socket_filter",
@@ -151,6 +154,231 @@ static void show_prog_maps(int fd, __u32 num_maps)
 	}
 }
 
+static int find_metadata_map_id(int prog_fd, int *map_id)
+{
+	struct bpf_prog_info prog_info = {};
+	struct bpf_map_info map_info;
+	__u32 prog_info_len;
+	__u32 map_info_len;
+	__u32 *map_ids;
+	int nr_maps;
+	int map_fd;
+	int ret;
+	__u32 i;
+
+	prog_info_len = sizeof(prog_info);
+
+	ret = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
+	if (ret)
+		return -errno;
+
+	if (!prog_info.nr_map_ids)
+		return -ENOENT;
+
+	map_ids = calloc(prog_info.nr_map_ids, sizeof(__u32));
+	if (!map_ids)
+		return -ENOMEM;
+
+	nr_maps = prog_info.nr_map_ids;
+	memset(&prog_info, 0, sizeof(prog_info));
+	prog_info.nr_map_ids = nr_maps;
+	prog_info.map_ids = ptr_to_u64(map_ids);
+	prog_info_len = sizeof(prog_info);
+
+	ret = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
+	if (ret) {
+		ret = -errno;
+		goto free_map_ids;
+	}
+
+	for (i = 0; i < prog_info.nr_map_ids; i++) {
+		map_fd = bpf_map_get_fd_by_id(map_ids[i]);
+		if (map_fd < 0) {
+			ret = -errno;
+			goto free_map_ids;
+		}
+
+		memset(&map_info, 0, sizeof(map_info));
+		map_info_len = sizeof(map_info);
+		ret = bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
+		if (ret < 0) {
+			ret = -errno;
+			close(map_fd);
+			goto free_map_ids;
+		}
+		close(map_fd);
+
+		if (map_info.type != BPF_MAP_TYPE_ARRAY)
+			continue;
+		if (map_info.key_size != sizeof(int))
+			continue;
+		if (map_info.max_entries != 1)
+			continue;
+		if (!map_info.btf_value_type_id)
+			continue;
+		if (!strstr(map_info.name, ".rodata"))
+			continue;
+
+		*map_id = map_ids[i];
+		goto free_map_ids;
+	}
+
+	ret = -ENOENT;
+
+free_map_ids:
+	free(map_ids);
+	return ret;
+}
+
+static void *find_metadata(int prog_fd, struct bpf_map_info *map_info)
+{
+	__u32 map_info_len;
+	void *value = NULL;
+	int map_id = 0;
+	int key = 0;
+	int map_fd;
+	int err;
+
+	err = find_metadata_map_id(prog_fd, &map_id);
+	if (err < 0)
+		return NULL;
+
+	map_fd = bpf_map_get_fd_by_id(map_id);
+	if (map_fd < 0)
+		return NULL;
+
+	map_info_len = sizeof(*map_info);
+	err = bpf_obj_get_info_by_fd(map_fd, map_info, &map_info_len);
+	if (err)
+		goto out_close;
+
+	value = malloc(map_info->value_size);
+	if (!value)
+		goto out_close;
+
+	if (bpf_map_lookup_elem(map_fd, &key, value))
+		goto out_free;
+
+	close(map_fd);
+	return value;
+
+out_free:
+	free(value);
+out_close:
+	close(map_fd);
+	return NULL;
+}
+
+static bool has_metadata_prefix(const char *s)
+{
+	return strstr(s, BPF_METADATA_PREFIX) == s;
+}
+
+static void show_prog_metadata(int fd, __u32 num_maps)
+{
+	const struct btf_type *t_datasec, *t_var;
+	struct bpf_map_info map_info = {};
+	struct btf_var_secinfo *vsi;
+	bool printed_header = false;
+	struct btf *btf = NULL;
+	unsigned int i, vlen;
+	void *value = NULL;
+	const char *name;
+	int err;
+
+	if (!num_maps)
+		return;
+
+	value = find_metadata(fd, &map_info);
+	if (!value)
+		return;
+
+	err = btf__get_from_id(map_info.btf_id, &btf);
+	if (err || !btf)
+		goto out_free;
+
+	t_datasec = btf__type_by_id(btf, map_info.btf_value_type_id);
+	if (!btf_is_datasec(t_datasec))
+		goto out_free;
+
+	vlen = btf_vlen(t_datasec);
+	vsi = btf_var_secinfos(t_datasec);
+
+	/* We don't proceed to check the kinds of the elements of the DATASEC.
+	 * The verifier enforces them to be BTF_KIND_VAR.
+	 */
+
+	if (json_output) {
+		struct btf_dumper d = {
+			.btf = btf,
+			.jw = json_wtr,
+			.is_plain_text = false,
+		};
+
+		for (i = 0; i < vlen; i++, vsi++) {
+			t_var = btf__type_by_id(btf, vsi->type);
+			name = btf__name_by_offset(btf, t_var->name_off);
+
+			if (!has_metadata_prefix(name))
+				continue;
+
+			if (!printed_header) {
+				jsonw_name(json_wtr, "metadata");
+				jsonw_start_object(json_wtr);
+				printed_header = true;
+			}
+
+			jsonw_name(json_wtr, name + BPF_METADATA_PREFIX_LEN);
+			err = btf_dumper_type(&d, t_var->type, value + vsi->offset);
+			if (err) {
+				p_err("btf dump failed: %d", err);
+				break;
+			}
+		}
+		if (printed_header)
+			jsonw_end_object(json_wtr);
+	} else {
+		json_writer_t *btf_wtr = jsonw_new(stdout);
+		struct btf_dumper d = {
+			.btf = btf,
+			.jw = btf_wtr,
+			.is_plain_text = true,
+		};
+		if (!btf_wtr) {
+			p_err("jsonw alloc failed");
+			goto out_free;
+		}
+
+		for (i = 0; i < vlen; i++, vsi++) {
+			t_var = btf__type_by_id(btf, vsi->type);
+			name = btf__name_by_offset(btf, t_var->name_off);
+
+			if (!has_metadata_prefix(name))
+				continue;
+
+			if (!printed_header) {
+				printf("\tmetadata:");
+				printed_header = true;
+			}
+
+			printf("\n\t\t%s = ", name + BPF_METADATA_PREFIX_LEN);
+
+			jsonw_reset(btf_wtr);
+			err = btf_dumper_type(&d, t_var->type, value + vsi->offset);
+			if (err) {
+				p_err("btf dump failed: %d", err);
+				break;
+			}
+		}
+		if (printed_header)
+			jsonw_destroy(&btf_wtr);
+	}
+
+out_free:
+	btf__free(btf);
+	free(value);
+}
+
 static void print_prog_header_json(struct bpf_prog_info *info)
 {
 	jsonw_uint_field(json_wtr, "id", info->id);
@@ -228,6 +456,8 @@ static void print_prog_json(struct bpf_prog_info *info, int fd)
 
 	emit_obj_refs_json(&refs_table, info->id, json_wtr);
 
+	show_prog_metadata(fd, info->nr_map_ids);
+
 	jsonw_end_object(json_wtr);
 }
 
@@ -297,6 +527,8 @@ static void print_prog_plain(struct bpf_prog_info *info, int fd)
 	emit_obj_refs_plain(&refs_table, info->id, "\n\tpids ");
 
 	printf("\n");
+
+	show_prog_metadata(fd, info->nr_map_ids);
 }
 
 static int show_prog(int fd)
-- 
2.28.0.618.gf4bc123cb7-goog

