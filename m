Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7864825616B
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 21:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgH1Tgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 15:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgH1TgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 15:36:21 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B17C06123A
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:36:15 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id c67so112478qkd.0
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=zBAe1FVufzoZpYTUTqiD804lLPIX6uCCT1yy+dgE1R0=;
        b=KddCvohZ56o2AVqqwXHkreAu5TqUzxOPbr24pE24K7DzR01RvFXwmCOlfOs9aDDXJH
         1Iep7lvJr0v8uXSQoyNz4oSw77YKZRtY+iK9bUJzo7CUKcy+/Nci2cg8i8I+t5s7w/Gq
         55KSTmPErCfB4gC9lo9VIynDwlFgogKCKrGnW1d6yqLNdlsxqArVdMqNsJ3q83fD4IvG
         zJQyN6QwGw2HppVeLsAAj2Cdz5Oez7V64BdVi+ulD53Bz0oWBfbdx1NuohIFiWVUIZs3
         fiQowoObbFpvQVGvSe+m24XyuoLr2ob1ufRmoQimUUS1v7TgfWyEqqbekIBiR6muthy/
         Iolw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zBAe1FVufzoZpYTUTqiD804lLPIX6uCCT1yy+dgE1R0=;
        b=l2E07p1TaLvXNTjLnKuC3AMZFl8qFi+QUWXoe5gfXrKpdixpIgYTaH3a4JCCVfwg26
         wZyAMBgxXjvg5TLcbvIcQu/d7DeG36ioXSxO32G0ZRGalV6zqw7uVvufNMjR42L+jB1f
         Dxc93ynuJ5gKrl6j0XXMgdR2I19r+QEX8rIiwpfhL7jrX17jO5DBNnEkjCceKsegL0yF
         1aP+UgV2QpTNbEoo+lPG7j/WeYq3FhPCB4E0GHuzTOjpGlkz+HhUqjNpzn+bhsOCs6aZ
         Ux57OmMCbvvrXm/tFece5aUa06c7QTHFvPjozYlYCgm9pEAri12ZSvgBJ9jdBNd3SrDw
         TIXg==
X-Gm-Message-State: AOAM533jhNUUo/l3DZ1+mLFH+rfoIpE98AGaiwjjZg2Vj8Sr9mQ2Na55
        WMIqvIGeLBnfR2Lj8HIl7Ash2Oa5CKOlRAzLPCa8F1zukL8Xr2tK56batiBsVPo8KWW0tdblKgQ
        7ACY0CyXzV9CFIjNpLQr9WbUY3uLIGo/q6TLg2xY2mMlwIWiG1AMoFw==
X-Google-Smtp-Source: ABdhPJyu6SsQjLtQW2oPoP8elya5iZ2x/CAWBmuOtKU9ApWz33BUmLgX2ZiWysjht3J5TmAOfnjQYo0=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:ad4:458e:: with SMTP id x14mr86689qvu.111.1598643374913;
 Fri, 28 Aug 2020 12:36:14 -0700 (PDT)
Date:   Fri, 28 Aug 2020 12:36:00 -0700
In-Reply-To: <20200828193603.335512-1-sdf@google.com>
Message-Id: <20200828193603.335512-6-sdf@google.com>
Mime-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH bpf-next v3 5/8] bpftool: support dumping metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YiFei Zhu <zhuyifei@google.com>

Added a flag "--metadata" to `bpftool prog list` to dump the metadata
contents. For some formatting some BTF code is put directly in the
metadata dumping. Sanity checks on the map and the kind of the btf_type
to make sure we are actually dumping what we are expecting.

A helper jsonw_reset is added to json writer so we can reuse the same
json writer without having extraneous commas.

Sample output:

  $ bpftool prog --metadata
  6: cgroup_skb  name prog  tag bcf7977d3b93787c  gpl
  [...]
  	btf_id 4
  	metadata:
  		metadata_a = "foo"
  		metadata_b = 1

  $ bpftool prog --metadata --json --pretty
  [{
          "id": 6,
  [...]
          "btf_id": 4,
          "metadata": {
              "metadata_a": "foo",
              "metadata_b": 1
          }
      }
  ]

Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/json_writer.c |   6 ++
 tools/bpf/bpftool/json_writer.h |   3 +
 tools/bpf/bpftool/main.c        |  10 +++
 tools/bpf/bpftool/main.h        |   1 +
 tools/bpf/bpftool/prog.c        | 130 ++++++++++++++++++++++++++++++++
 5 files changed, 150 insertions(+)

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
 
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 4a191fcbeb82..a681d568cfa7 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -28,6 +28,7 @@ bool show_pinned;
 bool block_mount;
 bool verifier_logs;
 bool relaxed_maps;
+bool dump_metadata;
 struct pinned_obj_table prog_table;
 struct pinned_obj_table map_table;
 struct pinned_obj_table link_table;
@@ -351,6 +352,10 @@ static int do_batch(int argc, char **argv)
 	return err;
 }
 
+enum bpftool_longonly_opts {
+	OPT_METADATA = 256,
+};
+
 int main(int argc, char **argv)
 {
 	static const struct option options[] = {
@@ -362,6 +367,7 @@ int main(int argc, char **argv)
 		{ "mapcompat",	no_argument,	NULL,	'm' },
 		{ "nomount",	no_argument,	NULL,	'n' },
 		{ "debug",	no_argument,	NULL,	'd' },
+		{ "metadata",	no_argument,	NULL,	OPT_METADATA },
 		{ 0 }
 	};
 	int opt, ret;
@@ -371,6 +377,7 @@ int main(int argc, char **argv)
 	json_output = false;
 	show_pinned = false;
 	block_mount = false;
+	dump_metadata = false;
 	bin_name = argv[0];
 
 	hash_init(prog_table.table);
@@ -412,6 +419,9 @@ int main(int argc, char **argv)
 			libbpf_set_print(print_all_levels);
 			verifier_logs = true;
 			break;
+		case OPT_METADATA:
+			dump_metadata = true;
+			break;
 		default:
 			p_err("unrecognized option '%s'", argv[optind - 1]);
 			if (json_output)
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index c46e52137b87..8750758e9150 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -90,6 +90,7 @@ extern bool show_pids;
 extern bool block_mount;
 extern bool verifier_logs;
 extern bool relaxed_maps;
+extern bool dump_metadata;
 extern struct pinned_obj_table prog_table;
 extern struct pinned_obj_table map_table;
 extern struct pinned_obj_table link_table;
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index d393eb8263a6..5d626c134e7d 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -151,6 +151,130 @@ static void show_prog_maps(int fd, __u32 num_maps)
 	}
 }
 
+static void show_prog_metadata(int fd, __u32 num_maps)
+{
+	const struct btf_type *t_datasec, *t_var;
+	struct bpf_map_info map_info = {};
+	struct btf_var_secinfo *vsi;
+	struct btf *btf = NULL;
+	unsigned int i, vlen;
+	__u32 map_info_len;
+	void *value = NULL;
+	int key = 0;
+	int map_id;
+	int map_fd;
+	int err;
+
+	if (!num_maps)
+		return;
+
+	map_id = bpf_prog_find_metadata(fd);
+	if (map_id < 0)
+		return;
+
+	map_fd = bpf_map_get_fd_by_id(map_id);
+	if (map_fd < 0) {
+		p_err("can't get map by id (%u): %s", map_id, strerror(errno));
+		return;
+	}
+
+	map_info_len = sizeof(map_info);
+	err = bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
+	if (err) {
+		p_err("can't get map info of id (%u): %s", map_id,
+		      strerror(errno));
+		goto out_close;
+	}
+
+	value = malloc(map_info.value_size);
+	if (!value) {
+		p_err("mem alloc failed");
+		goto out_close;
+	}
+
+	if (bpf_map_lookup_elem(map_fd, &key, value)) {
+		p_err("metadata map lookup failed: %s", strerror(errno));
+		goto out_free;
+	}
+
+	err = btf__get_from_id(map_info.btf_id, &btf);
+	if (err || !btf) {
+		p_err("metadata BTF get failed: %s", strerror(-err));
+		goto out_free;
+	}
+
+	t_datasec = btf__type_by_id(btf, map_info.btf_value_type_id);
+	if (BTF_INFO_KIND(t_datasec->info) != BTF_KIND_DATASEC) {
+		p_err("bad metadata BTF");
+		goto out_free;
+	}
+
+	vlen = BTF_INFO_VLEN(t_datasec->info);
+	vsi = (struct btf_var_secinfo *)(t_datasec + 1);
+
+	/* We don't proceed to check the kinds of the elements of the DATASEC.
+	 * The verifier enforce then to be BTF_KIND_VAR.
+	 */
+
+	if (json_output) {
+		struct btf_dumper d = {
+			.btf = btf,
+			.jw = json_wtr,
+			.is_plain_text = false,
+		};
+
+		jsonw_name(json_wtr, "metadata");
+
+		jsonw_start_object(json_wtr);
+		for (i = 0; i < vlen; i++) {
+			t_var = btf__type_by_id(btf, vsi[i].type);
+
+			jsonw_name(json_wtr, btf__name_by_offset(btf, t_var->name_off));
+			err = btf_dumper_type(&d, t_var->type, value + vsi[i].offset);
+			if (err) {
+				p_err("btf dump failed");
+				break;
+			}
+		}
+		jsonw_end_object(json_wtr);
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
+		printf("\tmetadata:");
+
+		for (i = 0; i < vlen; i++) {
+			t_var = btf__type_by_id(btf, vsi[i].type);
+
+			printf("\n\t\t%s = ", btf__name_by_offset(btf, t_var->name_off));
+
+			jsonw_reset(btf_wtr);
+			err = btf_dumper_type(&d, t_var->type, value + vsi[i].offset);
+			if (err) {
+				p_err("btf dump failed");
+				break;
+			}
+		}
+
+		jsonw_destroy(&btf_wtr);
+	}
+
+out_free:
+	btf__free(btf);
+	free(value);
+
+out_close:
+	close(map_fd);
+}
+
 static void print_prog_header_json(struct bpf_prog_info *info)
 {
 	jsonw_uint_field(json_wtr, "id", info->id);
@@ -228,6 +352,9 @@ static void print_prog_json(struct bpf_prog_info *info, int fd)
 
 	emit_obj_refs_json(&refs_table, info->id, json_wtr);
 
+	if (dump_metadata)
+		show_prog_metadata(fd, info->nr_map_ids);
+
 	jsonw_end_object(json_wtr);
 }
 
@@ -297,6 +424,9 @@ static void print_prog_plain(struct bpf_prog_info *info, int fd)
 	emit_obj_refs_plain(&refs_table, info->id, "\n\tpids ");
 
 	printf("\n");
+
+	if (dump_metadata)
+		show_prog_metadata(fd, info->nr_map_ids);
 }
 
 static int show_prog(int fd)
-- 
2.28.0.402.g5ffc5be6b7-goog

