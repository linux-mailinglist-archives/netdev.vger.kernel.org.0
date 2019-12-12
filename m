Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8DA11D284
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbfLLQl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:41:58 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44144 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729915AbfLLQl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 11:41:58 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBCGXRSD028606
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 08:41:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=r8MfPnPH+YcvK2KcbXQTSd9Vpfm0+TjKGe4K6sHPfuI=;
 b=agTMaEViJYn8b2eh8wtr3CFXyofMPwiQZQ1hyk5Hc+cKb8kbCDnz+PGIioZPsNp4313k
 +VJq13gVirRqel8fEfFMpWEP0DaUpVX7edqPslFWf5Kbdb7yKSVkkSvpOaXx2hibxvzr
 72ErC9lMQlcjRjopWzIc6kvnkokO3YsL6FE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2wu5w94rn0-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 08:41:57 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 12 Dec 2019 08:41:52 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CA5662EC1AD2; Thu, 12 Dec 2019 08:41:51 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 08/15] libbpf: postpone BTF ID finding for TRACING programs to load phase
Date:   Thu, 12 Dec 2019 08:41:21 -0800
Message-ID: <20191212164129.494329-9-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212164129.494329-1-andriin@fb.com>
References: <20191212164129.494329-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_04:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 suspectscore=9 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120129
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
index ff00a767adfb..f4a3ed73c9f5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3811,11 +3811,22 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
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
@@ -3839,7 +3850,7 @@ bpf_program__load(struct bpf_program *prog,
 				prog->section_name, prog->instances.nr);
 		}
 		err = load_program(prog, prog->insns, prog->insns_cnt,
-				   license, kern_version, &fd);
+				   license, kern_ver, &fd);
 		if (!err)
 			prog->instances.fds[0] = fd;
 		goto out;
@@ -3868,9 +3879,7 @@ bpf_program__load(struct bpf_program *prog,
 		}
 
 		err = load_program(prog, result.new_insn_ptr,
-				   result.new_insn_cnt,
-				   license, kern_version, &fd);
-
+				   result.new_insn_cnt, license, kern_ver, &fd);
 		if (err) {
 			pr_warn("Loading the %dth instance of program '%s' failed\n",
 				i, prog->section_name);
@@ -3914,9 +3923,6 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 	return 0;
 }
 
-static int libbpf_find_attach_btf_id(const char *name,
-				     enum bpf_attach_type attach_type,
-				     __u32 attach_prog_fd);
 static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   const struct bpf_object_open_opts *opts)
@@ -3980,15 +3986,8 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 
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

