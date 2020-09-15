Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66B426B58B
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgIOXq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbgIOXp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 19:45:58 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1749C061354
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:45:53 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id m203so4433823qke.16
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Ev9K1n9qT04CUG5E+ShNQsBapntGV8DeKquDB9rfUnM=;
        b=KHsu78kFhcZbomex5sfpJSnNxTNBMclo+U4m7DMF9UzkjhJmiFZNxjUpayb23WbpHH
         50HQMqfea+n/jz2S/Gw/fYrNW/qjbUQWdVtzniNMp36l/ornGdljBz9Fy+2eidLU1wVk
         n/R0EEZncwu5aQ06f1WfeclSYWNOie2JdARluDHhA6RDpRRrLUki7E+xq30JjVP2Fzcq
         0oBobVj4a+HFvtEBtQMR8SQtd2dVrHiYdSUQUgFRkourHEUZyyHVBi5A0I6RBBp9wgio
         oWSxivc94hJSnKfJvaru8WWuivLysk8jPG87yxZHtZkj7DQRSV1gUeaa3Pp+Pr5ENSg+
         kzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ev9K1n9qT04CUG5E+ShNQsBapntGV8DeKquDB9rfUnM=;
        b=acvVX7fKTcSrr4iDS2sZ3McaF8H4IITmNMMkqQSQXYPql0ZFH8o4hoOCZ/sAhwzz+Y
         f9qDNJev/vKmjeWJ8vXIaOYoMuOUQeJiMSHisa8Da1XV1reEZsYA24D7bDfhUsjHfhbL
         QVYo0sIsvuTAry4V6ySusk7s0d78tUHDmUBWGtkWswgfr9tU+logr/6nmq2Gg530iIu9
         jMaHx5El/C8d10JuxhXz5TylLvNd0LiLsAyhfGIUX+kn9TsZczXb5vw7qB1YRP2+AttN
         d0QeI4C1MvurJwefonVZtVZUbIYA7wAbe/gy9KznhuQflWsDhTa7TZvi8Qj0Mlvk5kh1
         R/Ew==
X-Gm-Message-State: AOAM533YEWMF8Me7FX1sc9bZpfpoMRdvKgVtJW4Psre3546dLwmt6OHg
        Woq42lX35CnM0snuolxlm+LvYIgxI4am6JCRFA8RcMutroz3oDU8QKeG8wnGO0LcSzFEamQisnT
        P/jt/5NYXIl60K6yyQgGsq1TzDxS5w3xD6tPkM0hH4NOvsCaqA20rRg==
X-Google-Smtp-Source: ABdhPJx3h9A1sCy6I79F0Fkl3zkP1TYBxdDJ9BpewoE+lCyNGQZyOsa8qXZGRlZuHb02FvVOxYioDBE=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:ad4:408f:: with SMTP id l15mr20575097qvp.4.1600213552821;
 Tue, 15 Sep 2020 16:45:52 -0700 (PDT)
Date:   Tue, 15 Sep 2020 16:45:42 -0700
In-Reply-To: <20200915234543.3220146-1-sdf@google.com>
Message-Id: <20200915234543.3220146-5-sdf@google.com>
Mime-Version: 1.0
References: <20200915234543.3220146-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH bpf-next v6 4/5] bpftool: support dumping metadata
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
 tools/bpf/bpftool/prog.c        | 199 ++++++++++++++++++++++++++++++++
 3 files changed, 208 insertions(+)

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
index f7923414a052..d942c1e3372c 100644
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
@@ -151,6 +154,198 @@ static void show_prog_maps(int fd, __u32 num_maps)
 	}
 }
 
+static void *find_metadata(int prog_fd, struct bpf_map_info *map_info)
+{
+	struct bpf_prog_info prog_info;
+	__u32 prog_info_len;
+	__u32 map_info_len;
+	void *value = NULL;
+	__u32 *map_ids;
+	int nr_maps;
+	int key = 0;
+	int map_fd;
+	int ret;
+	__u32 i;
+
+	memset(&prog_info, 0, sizeof(prog_info));
+	prog_info_len = sizeof(prog_info);
+	ret = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
+	if (ret)
+		return NULL;
+
+	if (!prog_info.nr_map_ids)
+		return NULL;
+
+	map_ids = calloc(prog_info.nr_map_ids, sizeof(__u32));
+	if (!map_ids)
+		return NULL;
+
+	nr_maps = prog_info.nr_map_ids;
+	memset(&prog_info, 0, sizeof(prog_info));
+	prog_info.nr_map_ids = nr_maps;
+	prog_info.map_ids = ptr_to_u64(map_ids);
+	prog_info_len = sizeof(prog_info);
+
+	ret = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
+	if (ret)
+		goto free_map_ids;
+
+	for (i = 0; i < prog_info.nr_map_ids; i++) {
+		map_fd = bpf_map_get_fd_by_id(map_ids[i]);
+		if (map_fd < 0)
+			goto free_map_ids;
+
+		memset(map_info, 0, sizeof(*map_info));
+		map_info_len = sizeof(*map_info);
+		ret = bpf_obj_get_info_by_fd(map_fd, map_info, &map_info_len);
+		if (ret < 0) {
+			close(map_fd);
+			goto free_map_ids;
+		}
+
+		if (map_info->type != BPF_MAP_TYPE_ARRAY ||
+		    map_info->key_size != sizeof(int) ||
+		    map_info->max_entries != 1 ||
+		    !map_info->btf_value_type_id ||
+		    !strstr(map_info->name, ".rodata")) {
+			close(map_fd);
+			continue;
+		}
+
+		value = malloc(map_info->value_size);
+		if (!value) {
+			close(map_fd);
+			goto free_map_ids;
+		}
+
+		if (bpf_map_lookup_elem(map_fd, &key, value)) {
+			close(map_fd);
+			free(value);
+			value = NULL;
+			goto free_map_ids;
+		}
+
+		close(map_fd);
+		break;
+	}
+
+free_map_ids:
+	free(map_ids);
+	return value;
+}
+
+static bool has_metadata_prefix(const char *s)
+{
+	return strncmp(s, BPF_METADATA_PREFIX, BPF_METADATA_PREFIX_LEN) == 0;
+}
+
+static void show_prog_metadata(int fd, __u32 num_maps)
+{
+	const struct btf_type *t_datasec, *t_var;
+	struct bpf_map_info map_info;
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
+	memset(&map_info, 0, sizeof(map_info));
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
+
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
@@ -228,6 +423,8 @@ static void print_prog_json(struct bpf_prog_info *info, int fd)
 
 	emit_obj_refs_json(&refs_table, info->id, json_wtr);
 
+	show_prog_metadata(fd, info->nr_map_ids);
+
 	jsonw_end_object(json_wtr);
 }
 
@@ -297,6 +494,8 @@ static void print_prog_plain(struct bpf_prog_info *info, int fd)
 	emit_obj_refs_plain(&refs_table, info->id, "\n\tpids ");
 
 	printf("\n");
+
+	show_prog_metadata(fd, info->nr_map_ids);
 }
 
 static int show_prog(int fd)
-- 
2.28.0.618.gf4bc123cb7-goog

