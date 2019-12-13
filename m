Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B1411EDDD
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 23:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfLMWcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 17:32:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33406 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726613AbfLMWcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 17:32:41 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDMUsjx030795
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 14:32:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=M/4gSxflh5hFgfopv0ZBO5TY/XrU9VCCMqXCKg1PcXA=;
 b=nhQVN1z9R+pQyxkAS9EuTYY2buAjHz+3An2b4rhd7DPd+uUTzpvKMpSOfQlesq8ctij2
 Cn5gGwejXgWmUPnl3IiFtD5eaO6CJuU/CGWJNt/Y8UGgOyyff980XE6IFlZkuCXT3Zbg
 +QJgtD+058c5mttpkXkrqTTxmG3Nu3rpDmU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wv1r0vfae-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 14:32:40 -0800
Received: from intmgw004.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 14:32:39 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DCFC42EC1C8E; Fri, 13 Dec 2019 14:32:38 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 10/17] libbpf: postpone BTF ID finding for TRACING programs to load phase
Date:   Fri, 13 Dec 2019 14:32:07 -0800
Message-ID: <20191213223214.2791885-11-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191213223214.2791885-1-andriin@fb.com>
References: <20191213223214.2791885-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_08:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 suspectscore=9 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912130159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move BTF ID determination for BPF_PROG_TYPE_TRACING programs to a load phase.
Performing it at open step is inconvenient, because it prevents BPF skeleton
generation on older host kernel, which doesn't contain BTF_KIND_FUNCs
information in vmlinux BTF. This is a common set up, though, when, e.g.,
selftests are compiled on older host kernel, but the test program itself is
executed in qemu VM with bleeding edge kernel. Having this BTF searching
performed at load time allows to successfully use bpf_object__open() for
codegen and inspection of BPF object file.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a57a7623a5a0..2ffd132aa8d6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3812,11 +3812,22 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	return ret;
 }
 
-int
-bpf_program__load(struct bpf_program *prog,
-		  char *license, __u32 kern_version)
+static int libbpf_find_attach_btf_id(const char *name,
+				     enum bpf_attach_type attach_type,
+				     __u32 attach_prog_fd);
+
+int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 {
-	int err = 0, fd, i;
+	int err = 0, fd, i, btf_id;
+
+	if (prog->type == BPF_PROG_TYPE_TRACING) {
+		btf_id = libbpf_find_attach_btf_id(prog->section_name,
+						   prog->expected_attach_type,
+						   prog->attach_prog_fd);
+		if (btf_id <= 0)
+			return btf_id;
+		prog->attach_btf_id = btf_id;
+	}
 
 	if (prog->instances.nr < 0 || !prog->instances.fds) {
 		if (prog->preprocessor) {
@@ -3840,7 +3851,7 @@ bpf_program__load(struct bpf_program *prog,
 				prog->section_name, prog->instances.nr);
 		}
 		err = load_program(prog, prog->insns, prog->insns_cnt,
-				   license, kern_version, &fd);
+				   license, kern_ver, &fd);
 		if (!err)
 			prog->instances.fds[0] = fd;
 		goto out;
@@ -3869,9 +3880,7 @@ bpf_program__load(struct bpf_program *prog,
 		}
 
 		err = load_program(prog, result.new_insn_ptr,
-				   result.new_insn_cnt,
-				   license, kern_version, &fd);
-
+				   result.new_insn_cnt, license, kern_ver, &fd);
 		if (err) {
 			pr_warn("Loading the %dth instance of program '%s' failed\n",
 				i, prog->section_name);
@@ -3915,9 +3924,6 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 	return 0;
 }
 
-static int libbpf_find_attach_btf_id(const char *name,
-				     enum bpf_attach_type attach_type,
-				     __u32 attach_prog_fd);
 static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   const struct bpf_object_open_opts *opts)
@@ -3981,15 +3987,8 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 
 		bpf_program__set_type(prog, prog_type);
 		bpf_program__set_expected_attach_type(prog, attach_type);
-		if (prog_type == BPF_PROG_TYPE_TRACING) {
-			err = libbpf_find_attach_btf_id(prog->section_name,
-							attach_type,
-							attach_prog_fd);
-			if (err <= 0)
-				goto out;
-			prog->attach_btf_id = err;
+		if (prog_type == BPF_PROG_TYPE_TRACING)
 			prog->attach_prog_fd = attach_prog_fd;
-		}
 	}
 
 	return obj;
-- 
2.17.1

