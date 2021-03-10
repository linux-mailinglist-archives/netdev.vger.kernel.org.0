Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318C633342A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 05:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhCJEFc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 9 Mar 2021 23:05:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12670 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231235AbhCJEEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 23:04:55 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12A42JJL027598
        for <netdev@vger.kernel.org>; Tue, 9 Mar 2021 20:04:54 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 376dq2ju8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 20:04:54 -0800
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Mar 2021 20:04:53 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D90BA2ED1C92; Tue,  9 Mar 2021 20:04:48 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 07/10] bpftool: add `gen bpfo` command to perform BPF static linking
Date:   Tue, 9 Mar 2021 20:04:28 -0800
Message-ID: <20210310040431.916483-8-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210310040431.916483-1-andrii@kernel.org>
References: <20210310040431.916483-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-10_03:2021-03-09,2021-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103100018
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add `bpftool gen bpfo <output-file> <input_file>...` command to statically
link multiple BPF object files into a single output BPF object file.

Similarly to existing '*.o' convention, bpftool is establishing a '*.bpfo'
convention for statically-linked BPF object files. Both .o and .bpfo suffixes
will be stripped out during BPF skeleton generation to infer BPF object name.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/gen.c | 46 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 4033c46d83e7..8b1ed6c0a62f 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -54,7 +54,9 @@ static void get_obj_name(char *name, const char *file)
 	strncpy(name, basename(file), MAX_OBJ_NAME_LEN - 1);
 	name[MAX_OBJ_NAME_LEN - 1] = '\0';
 	if (str_has_suffix(name, ".o"))
-		name[strlen(name) - 2] = '\0';
+		name[strlen(name) - sizeof(".o") + 1] = '\0';
+	else if (str_has_suffix(name, ".bpfo"))
+		name[strlen(name) - sizeof(".bpfo") + 1] = '\0';
 	sanitize_identifier(name);
 }
 
@@ -591,6 +593,47 @@ static int do_skeleton(int argc, char **argv)
 	return err;
 }
 
+static int do_bpfo(int argc, char **argv)
+{
+	struct bpf_linker *linker;
+	const char *output_file, *file;
+	int err;
+
+	if (!REQ_ARGS(2)) {
+		usage();
+		return -1;
+	}
+
+	output_file = GET_ARG();
+
+	linker = bpf_linker__new(output_file, NULL);
+	if (!linker) {
+		p_err("failed to create BPF linker instance");
+		return -1;
+	}
+
+	while (argc) {
+		file = GET_ARG();
+
+		err = bpf_linker__add_file(linker, file);
+		if (err) {
+			p_err("failed to link '%s': %d", file, err);
+			goto err_out;
+		}
+	}
+
+	err = bpf_linker__finalize(linker);
+	if (err) {
+		p_err("failed to finalize ELF file: %d", err);
+		goto err_out;
+	}
+
+	return 0;
+err_out:
+	bpf_linker__free(linker);
+	return -1;
+}
+
 static int do_help(int argc, char **argv)
 {
 	if (json_output) {
@@ -611,6 +654,7 @@ static int do_help(int argc, char **argv)
 
 static const struct cmd cmds[] = {
 	{ "skeleton",	do_skeleton },
+	{ "bpfo",	do_bpfo },
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.24.1

