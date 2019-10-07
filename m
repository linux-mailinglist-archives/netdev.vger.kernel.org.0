Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFFFCCEE60
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 23:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfJGVWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 17:22:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8516 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728702AbfJGVWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 17:22:52 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x97LLSp0022215
        for <netdev@vger.kernel.org>; Mon, 7 Oct 2019 14:22:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=+gwQlWljAS+f0QtmOz2gYz9NEvVPftQQPUADqEQKSF8=;
 b=hXdSIAzDcwD2N7cyo6cOYPj6DR++wpqOv4GTNTftWE6/MddhNhsk595XhNRZ08TPhNl5
 m2RVWipm4FaLKFuHaPEtjrL6CeAbJMdnnQoUt4+NfQkRpc0pO7Gr5YXgS3g4sKzWRaOc
 C7xZgWypc6DbahSkQBq7GzwVMaTu4CGwhrE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vfavexujf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 14:22:51 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 7 Oct 2019 14:22:50 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 6B0408618A5; Mon,  7 Oct 2019 14:22:48 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <sdf@google.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] bpftool: fix bpftool build by switching to bpf_object__open_file()
Date:   Mon, 7 Oct 2019 14:22:37 -0700
Message-ID: <20191007212237.1704211-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-07_03:2019-10-07,2019-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 mlxlogscore=999 suspectscore=25 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910070189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of libbpf in 5e61f2707029 ("libbpf: stop enforcing kern_version,
populate it for users") non-LIBBPF_API __bpf_object__open_xattr() API
was removed from libbpf.h header. This broke bpftool, which relied on
that function. This patch fixes the build by switching to newly added
bpf_object__open_file() which provides the same capabilities, but is
official and future-proof API.

Fixes: 5e61f2707029 ("libbpf: stop enforcing kern_version, populate it for users")
Reported-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/main.c |  4 ++--
 tools/bpf/bpftool/main.h |  2 +-
 tools/bpf/bpftool/prog.c | 22 ++++++++++++----------
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 93d008687020..4764581ff9ea 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -27,7 +27,7 @@ bool json_output;
 bool show_pinned;
 bool block_mount;
 bool verifier_logs;
-int bpf_flags;
+bool relaxed_maps;
 struct pinned_obj_table prog_table;
 struct pinned_obj_table map_table;
 
@@ -396,7 +396,7 @@ int main(int argc, char **argv)
 			show_pinned = true;
 			break;
 		case 'm':
-			bpf_flags = MAPS_RELAX_COMPAT;
+			relaxed_maps = true;
 			break;
 		case 'n':
 			block_mount = true;
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index af9ad56c303a..2899095f8254 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -94,7 +94,7 @@ extern bool json_output;
 extern bool show_pinned;
 extern bool block_mount;
 extern bool verifier_logs;
-extern int bpf_flags;
+extern bool relaxed_maps;
 extern struct pinned_obj_table prog_table;
 extern struct pinned_obj_table map_table;
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 43fdbbfe41bb..8191cd595963 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1092,9 +1092,7 @@ static int do_run(int argc, char **argv)
 static int load_with_options(int argc, char **argv, bool first_prog_only)
 {
 	struct bpf_object_load_attr load_attr = { 0 };
-	struct bpf_object_open_attr open_attr = {
-		.prog_type = BPF_PROG_TYPE_UNSPEC,
-	};
+	enum bpf_prog_type prog_type = BPF_PROG_TYPE_UNSPEC;
 	enum bpf_attach_type expected_attach_type;
 	struct map_replace *map_replace = NULL;
 	struct bpf_program *prog = NULL, *pos;
@@ -1105,11 +1103,16 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 	const char *pinfile;
 	unsigned int i, j;
 	__u32 ifindex = 0;
+	const char *file;
 	int idx, err;
 
+	LIBBPF_OPTS(bpf_object_open_opts, open_opts,
+		.relaxed_maps = relaxed_maps,
+	);
+
 	if (!REQ_ARGS(2))
 		return -1;
-	open_attr.file = GET_ARG();
+	file = GET_ARG();
 	pinfile = GET_ARG();
 
 	while (argc) {
@@ -1118,7 +1121,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 
 			NEXT_ARG();
 
-			if (open_attr.prog_type != BPF_PROG_TYPE_UNSPEC) {
+			if (prog_type != BPF_PROG_TYPE_UNSPEC) {
 				p_err("program type already specified");
 				goto err_free_reuse_maps;
 			}
@@ -1135,8 +1138,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 			strcat(type, *argv);
 			strcat(type, "/");
 
-			err = libbpf_prog_type_by_name(type,
-						       &open_attr.prog_type,
+			err = libbpf_prog_type_by_name(type, &prog_type,
 						       &expected_attach_type);
 			free(type);
 			if (err < 0)
@@ -1224,16 +1226,16 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 
 	set_max_rlimit();
 
-	obj = __bpf_object__open_xattr(&open_attr, bpf_flags);
+	obj = bpf_object__open_file(file, &open_opts);
 	if (IS_ERR_OR_NULL(obj)) {
 		p_err("failed to open object file");
 		goto err_free_reuse_maps;
 	}
 
 	bpf_object__for_each_program(pos, obj) {
-		enum bpf_prog_type prog_type = open_attr.prog_type;
+		enum bpf_prog_type prog_type = prog_type;
 
-		if (open_attr.prog_type == BPF_PROG_TYPE_UNSPEC) {
+		if (prog_type == BPF_PROG_TYPE_UNSPEC) {
 			const char *sec_name = bpf_program__title(pos, false);
 
 			err = libbpf_prog_type_by_name(sec_name, &prog_type,
-- 
2.17.1

