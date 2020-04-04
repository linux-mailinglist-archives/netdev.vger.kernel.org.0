Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB8319E1DB
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 02:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgDDAK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 20:10:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726466AbgDDAK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 20:10:26 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03406LW9011378
        for <netdev@vger.kernel.org>; Fri, 3 Apr 2020 17:10:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=q8cXCgRahCZ6x9HbLe5dVkpJ78NJPvk5jNzMIGLRhmo=;
 b=ogsdh+M+wkfdiIWyGjC8gyIK+2jG7benboezA0XSUd2TiYjCzTvArzqijwwlTQX0uPRA
 LIoDN18LgJHDmlz6eVRssFhmLmL5vRDqtKPZQPVJBvf8wIJifHuDO/A34KwIPcPLO05l
 zJNup/cy/Oxy7rBdD2b9Cjs+F+MCgBviSFc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 305jfs05y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 17:10:24 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 3 Apr 2020 17:10:23 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 875D42EC2E64; Fri,  3 Apr 2020 17:10:16 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 8/8] bpftool: add bpf_link show and pin support
Date:   Fri, 3 Apr 2020 17:09:47 -0700
Message-ID: <20200404000948.3980903-9-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200404000948.3980903-1-andriin@fb.com>
References: <20200404000948.3980903-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_19:2020-04-03,2020-04-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=25 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpftool link show and bpftool link pin commands.

Example plain output for `link show`:

[vmuser@archvm bpf]$ sudo ~/local/linux/tools/bpf/bpftool/bpftool link
1: tracing  prog 12
        prog_type tracing  attach_type fentry
2: tracing  prog 13
        prog_type tracing  attach_type fentry
3: tracing  prog 14
        prog_type tracing  attach_type fentry
4: tracing  prog 15
        prog_type tracing  attach_type fentry
5: tracing  prog 16
        prog_type tracing  attach_type fentry
6: tracing  prog 17
        prog_type tracing  attach_type fentry
7: raw_tracepoint  prog 21
        tp 'sys_enter'
8: cgroup  prog 25
        cgroup_id 584  attach_type egress
9: cgroup  prog 25
        cgroup_id 599  attach_type egress
10: cgroup  prog 25
        cgroup_id 614  attach_type egress
11: cgroup  prog 25
        cgroup_id 629  attach_type egress

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/link.c | 403 +++++++++++++++++++++++++++++++++++++++
 tools/bpf/bpftool/main.c |   2 +
 tools/bpf/bpftool/main.h |   5 +
 3 files changed, 410 insertions(+)
 create mode 100644 tools/bpf/bpftool/link.c

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
new file mode 100644
index 000000000000..3f708c29e3eb
--- /dev/null
+++ b/tools/bpf/bpftool/link.c
@@ -0,0 +1,403 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2020 Facebook */
+
+#include <errno.h>
+#include <net/if.h>
+#include <stdio.h>
+#include <unistd.h>
+
+#include <bpf/bpf.h>
+
+#include "json_writer.h"
+#include "main.h"
+
+const char * const link_type_name[] =3D {
+	[BPF_LINK_TYPE_UNSPEC]			=3D "unspec",
+	[BPF_LINK_TYPE_RAW_TRACEPOINT]		=3D "raw_tracepoint",
+	[BPF_LINK_TYPE_TRACING]			=3D "tracing",
+	[BPF_LINK_TYPE_CGROUP]			=3D "cgroup",
+};
+
+const size_t link_type_name_size =3D ARRAY_SIZE(link_type_name);
+
+static int link_parse_fds(int *argc, char ***argv, int **fds)
+{
+	if (is_prefix(**argv, "id")) {
+		unsigned int id;
+		char *endptr;
+
+		NEXT_ARGP();
+
+		id =3D strtoul(**argv, &endptr, 0);
+		if (*endptr) {
+			p_err("can't parse %s as ID", **argv);
+			return -1;
+		}
+		NEXT_ARGP();
+
+		(*fds)[0] =3D bpf_link_get_fd_by_id(id);
+		if ((*fds)[0] < 0) {
+			p_err("get link by id (%u): %s", id, strerror(errno));
+			return -1;
+		}
+		return 1;
+	} else if (is_prefix(**argv, "pinned")) {
+		char *path;
+
+		NEXT_ARGP();
+
+		path =3D **argv;
+		NEXT_ARGP();
+
+		(*fds)[0] =3D open_obj_pinned_any(path, BPF_OBJ_LINK);
+		if ((*fds)[0] < 0)
+			return -1;
+		return 1;
+	}
+
+	p_err("expected 'id' or 'pinned', got: '%s'?", **argv);
+	return -1;
+}
+
+static int link_parse_fd(int *argc, char ***argv)
+{
+	int *fds =3D NULL;
+	int nb_fds, fd;
+
+	fds =3D malloc(sizeof(int));
+	if (!fds) {
+		p_err("mem alloc failed");
+		return -1;
+	}
+	nb_fds =3D link_parse_fds(argc, argv, &fds);
+	if (nb_fds !=3D 1) {
+		if (nb_fds > 1) {
+			p_err("several links match this handle");
+			while (nb_fds--)
+				close(fds[nb_fds]);
+		}
+		fd =3D -1;
+		goto exit_free;
+	}
+
+	fd =3D fds[0];
+exit_free:
+	free(fds);
+	return fd;
+}
+
+static void
+show_link_header_json(struct bpf_link_info *info, json_writer_t *wtr)
+{
+	jsonw_uint_field(wtr, "id", info->id);
+	if (info->type < ARRAY_SIZE(link_type_name))
+		jsonw_string_field(wtr, "type", link_type_name[info->type]);
+	else
+		jsonw_uint_field(wtr, "type", info->type);
+
+	jsonw_uint_field(json_wtr, "prog_id", info->prog_id);
+}
+
+static int get_prog_info(int prog_id, struct bpf_prog_info *info)
+{
+	__u32 len =3D sizeof(*info);
+	int err, prog_fd;
+
+	prog_fd =3D bpf_prog_get_fd_by_id(prog_id);
+	if (prog_fd < 0)
+		return prog_fd;
+
+	memset(info, 0, sizeof(*info));
+	err =3D bpf_obj_get_info_by_fd(prog_fd, info, &len);
+	if (err) {
+		p_err("can't get prog info: %s", strerror(errno));
+		close(prog_fd);
+		return err;
+	}
+
+	close(prog_fd);
+	return 0;
+}
+
+static int show_link_close_json(int fd, struct bpf_link_info *info)
+{
+	struct bpf_prog_info prog_info;
+	int err;
+
+	jsonw_start_object(json_wtr);
+
+	show_link_header_json(info, json_wtr);
+
+	switch (info->type) {
+	case BPF_LINK_TYPE_RAW_TRACEPOINT:
+		jsonw_string_field(json_wtr, "tp_name",
+				   (const char *)info->raw_tracepoint.tp_name);
+		break;
+	case BPF_LINK_TYPE_TRACING:
+		err =3D get_prog_info(info->prog_id, &prog_info);
+		if (err)
+			return err;
+
+		if (prog_info.type < ARRAY_SIZE(prog_type_name))
+			jsonw_string_field(json_wtr, "prog_type",
+					   prog_type_name[prog_info.type]);
+		else
+			jsonw_uint_field(json_wtr, "prog_type",
+					 prog_info.type);
+
+		if (info->tracing.attach_type < ARRAY_SIZE(attach_type_name))
+			jsonw_string_field(json_wtr, "attach_type",
+			       attach_type_name[info->tracing.attach_type]);
+		else
+			jsonw_uint_field(json_wtr, "attach_type",
+					 info->tracing.attach_type);
+		break;
+	case BPF_LINK_TYPE_CGROUP:
+		jsonw_lluint_field(json_wtr, "cgroup_id",
+				   info->cgroup.cgroup_id);
+		if (info->cgroup.attach_type < ARRAY_SIZE(attach_type_name))
+			jsonw_string_field(json_wtr, "attach_type",
+			       attach_type_name[info->cgroup.attach_type]);
+		else
+			jsonw_uint_field(json_wtr, "attach_type",
+					 info->cgroup.attach_type);
+		break;
+	default:
+		break;
+	}
+
+	if (!hash_empty(link_table.table)) {
+		struct pinned_obj *obj;
+
+		jsonw_name(json_wtr, "pinned");
+		jsonw_start_array(json_wtr);
+		hash_for_each_possible(link_table.table, obj, hash, info->id) {
+			if (obj->id =3D=3D info->id)
+				jsonw_string(json_wtr, obj->path);
+		}
+		jsonw_end_array(json_wtr);
+	}
+	jsonw_end_object(json_wtr);
+
+	return 0;
+}
+
+static void show_link_header_plain(struct bpf_link_info *info)
+{
+	printf("%u: ", info->id);
+	if (info->type < ARRAY_SIZE(link_type_name))
+		printf("%s  ", link_type_name[info->type]);
+	else
+		printf("type %u  ", info->type);
+
+	printf("prog %u  ", info->prog_id);
+}
+
+static int show_link_close_plain(int fd, struct bpf_link_info *info)
+{
+	struct bpf_prog_info prog_info;
+	int err;
+
+	show_link_header_plain(info);
+
+	switch (info->type) {
+	case BPF_LINK_TYPE_RAW_TRACEPOINT:
+		printf("\n\ttp '%s'  ", (const char *)info->raw_tracepoint.tp_name);
+		break;
+	case BPF_LINK_TYPE_TRACING:
+		err =3D get_prog_info(info->prog_id, &prog_info);
+		if (err)
+			return err;
+
+		if (prog_info.type < ARRAY_SIZE(prog_type_name))
+			printf("\n\tprog_type %s  ",
+			       prog_type_name[prog_info.type]);
+		else
+			printf("\n\tprog_type %u  ", prog_info.type);
+
+		if (info->tracing.attach_type < ARRAY_SIZE(attach_type_name))
+			printf("attach_type %s  ",
+			       attach_type_name[info->tracing.attach_type]);
+		else
+			printf("attach_type %u  ", info->tracing.attach_type);
+		break;
+	case BPF_LINK_TYPE_CGROUP:
+		printf("\n\tcgroup_id %zu  ", (size_t)info->cgroup.cgroup_id);
+		if (info->cgroup.attach_type < ARRAY_SIZE(attach_type_name))
+			printf("attach_type %s  ",
+			       attach_type_name[info->cgroup.attach_type]);
+		else
+			printf("attach_type %u  ", info->cgroup.attach_type);
+		break;
+	default:
+		break;
+	}
+
+	if (!hash_empty(link_table.table)) {
+		struct pinned_obj *obj;
+
+		hash_for_each_possible(link_table.table, obj, hash, info->id) {
+			if (obj->id =3D=3D info->id)
+				printf("\n\tpinned %s", obj->path);
+		}
+	}
+
+	printf("\n");
+
+	return 0;
+}
+
+static int do_show_link(int fd)
+{
+	struct bpf_link_info info;
+	__u32 len =3D sizeof(info);
+	char raw_tp_name[256];
+	int err;
+
+	memset(&info, 0, sizeof(info));
+again:
+	err =3D bpf_obj_get_info_by_fd(fd, &info, &len);
+	if (err) {
+		p_err("can't get link info: %s",
+		      strerror(errno));
+		close(fd);
+		return err;
+	}
+	if (info.type =3D=3D BPF_LINK_TYPE_RAW_TRACEPOINT &&
+	    !info.raw_tracepoint.tp_name) {
+		info.raw_tracepoint.tp_name =3D (unsigned long)&raw_tp_name;
+		info.raw_tracepoint.tp_name_len =3D sizeof(raw_tp_name);
+		goto again;
+	}
+
+	if (json_output)
+		show_link_close_json(fd, &info);
+	else
+		show_link_close_plain(fd, &info);
+
+	close(fd);
+	return 0;
+}
+
+static int do_show_subset(int argc, char **argv)
+{
+	int *fds =3D NULL;
+	int nb_fds, i;
+	int err =3D -1;
+
+	fds =3D malloc(sizeof(int));
+	if (!fds) {
+		p_err("mem alloc failed");
+		return -1;
+	}
+	nb_fds =3D link_parse_fds(&argc, &argv, &fds);
+	if (nb_fds < 1)
+		goto exit_free;
+
+	if (json_output && nb_fds > 1)
+		jsonw_start_array(json_wtr);	/* root array */
+	for (i =3D 0; i < nb_fds; i++) {
+		err =3D do_show_link(fds[i]);
+		if (err) {
+			for (; i + 1 < nb_fds; i++)
+				close(fds[i]);
+			break;
+		}
+	}
+	if (json_output && nb_fds > 1)
+		jsonw_end_array(json_wtr);	/* root array */
+
+exit_free:
+	free(fds);
+	return err;
+}
+
+static int do_show(int argc, char **argv)
+{
+	__u32 id =3D 0;
+	int err;
+	int fd;
+
+	if (show_pinned)
+		build_pinned_obj_table(&link_table, BPF_OBJ_LINK);
+
+	if (argc =3D=3D 2)
+		return do_show_subset(argc, argv);
+
+	if (argc)
+		return BAD_ARG();
+
+	if (json_output)
+		jsonw_start_array(json_wtr);
+	while (true) {
+		err =3D bpf_link_get_next_id(id, &id);
+		if (err) {
+			if (errno =3D=3D ENOENT)
+				break;
+			p_err("can't get next link: %s%s", strerror(errno),
+			      errno =3D=3D EINVAL ? " -- kernel too old?" : "");
+			break;
+		}
+
+		fd =3D bpf_link_get_fd_by_id(id);
+		if (fd < 0) {
+			if (errno =3D=3D ENOENT)
+				continue;
+			p_err("can't get link by id (%u): %s",
+			      id, strerror(errno));
+			break;
+		}
+
+		err =3D do_show_link(fd);
+		if (err)
+			break;
+	}
+	if (json_output)
+		jsonw_end_array(json_wtr);
+
+	return errno =3D=3D ENOENT ? 0 : -1;
+}
+
+static int do_pin(int argc, char **argv)
+{
+	int err;
+
+	err =3D do_pin_any(argc, argv, link_parse_fd);
+	if (!err && json_output)
+		jsonw_null(json_wtr);
+	return err;
+}
+
+static int do_help(int argc, char **argv)
+{
+	if (json_output) {
+		jsonw_null(json_wtr);
+		return 0;
+	}
+
+	fprintf(stderr,
+		"Usage: %1$s %2$s { show | list }   [LINK]\n"
+		"       %1$s %2$s pin        LINK  FILE\n"
+		"       %1$s %2$s help\n"
+		"\n"
+		"       " HELP_SPEC_LINK "\n"
+		"       " HELP_SPEC_PROGRAM "\n"
+		"       " HELP_SPEC_OPTIONS "\n"
+		"",
+		bin_name, argv[-2]);
+
+	return 0;
+}
+
+static const struct cmd cmds[] =3D {
+	{ "show",	do_show },
+	{ "list",	do_show },
+	{ "help",	do_help },
+	{ "pin",	do_pin },
+	{ 0 }
+};
+
+int do_link(int argc, char **argv)
+{
+	return cmd_select(cmds, argc, argv, do_help);
+}
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 466c269eabdd..4b2f74941625 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -30,6 +30,7 @@ bool verifier_logs;
 bool relaxed_maps;
 struct pinned_obj_table prog_table;
 struct pinned_obj_table map_table;
+struct pinned_obj_table link_table;
=20
 static void __noreturn clean_and_exit(int i)
 {
@@ -215,6 +216,7 @@ static const struct cmd cmds[] =3D {
 	{ "batch",	do_batch },
 	{ "prog",	do_prog },
 	{ "map",	do_map },
+	{ "link",	do_link },
 	{ "cgroup",	do_cgroup },
 	{ "perf",	do_perf },
 	{ "net",	do_net },
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index dd212d2af923..ff00a91982f7 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -50,6 +50,8 @@
 	"\t            {-m|--mapcompat} | {-n|--nomount} }"
 #define HELP_SPEC_MAP							\
 	"MAP :=3D { id MAP_ID | pinned FILE | name MAP_NAME }"
+#define HELP_SPEC_LINK							\
+	"LINK :=3D { id LINK_ID | pinned FILE }"
=20
 static const char * const prog_type_name[] =3D {
 	[BPF_PROG_TYPE_UNSPEC]			=3D "unspec",
@@ -122,6 +124,7 @@ enum bpf_obj_type {
 	BPF_OBJ_UNKNOWN,
 	BPF_OBJ_PROG,
 	BPF_OBJ_MAP,
+	BPF_OBJ_LINK,
 };
=20
 extern const char *bin_name;
@@ -134,6 +137,7 @@ extern bool verifier_logs;
 extern bool relaxed_maps;
 extern struct pinned_obj_table prog_table;
 extern struct pinned_obj_table map_table;
+extern struct pinned_obj_table link_table;
=20
 void __printf(1, 2) p_err(const char *fmt, ...);
 void __printf(1, 2) p_info(const char *fmt, ...);
@@ -185,6 +189,7 @@ int do_pin_fd(int fd, const char *name);
=20
 int do_prog(int argc, char **arg);
 int do_map(int argc, char **arg);
+int do_link(int argc, char **arg);
 int do_event_pipe(int argc, char **argv);
 int do_cgroup(int argc, char **arg);
 int do_perf(int argc, char **arg);
--=20
2.24.1

