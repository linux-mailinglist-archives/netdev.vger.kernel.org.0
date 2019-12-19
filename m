Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C18125BD9
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 08:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfLSHHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 02:07:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1426 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726648AbfLSHHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 02:07:10 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJ6xoJT020798
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 23:07:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Q4vvCUutaaXFPimTlJurDWpwGLVF7fCb81kHjUjtjyU=;
 b=SS2SZ7mzVEs6BbEeDJwUBI4vSPv2bpLVCIcQoV3IAZ+zOs4IKaj/F9tZIXGRcRBOsJ9r
 MRqC1cRhwju3gxmRLFaX1GMb8yEhh6PTsSDC5aDSkdRfeXRGjAAkcp3L/hXrmlcE8vPw
 P9vQXUHLRVjliield5D4XEkQUFdfuZyYLs4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wyqmckgsq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 23:07:09 -0800
Received: from intmgw001.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 18 Dec 2019 23:07:07 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 67BA92EC16E6; Wed, 18 Dec 2019 23:07:02 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] bpftool: add extra CO-RE mode to btf dump command
Date:   Wed, 18 Dec 2019 23:06:56 -0800
Message-ID: <20191219070659.424273-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191219070659.424273-1-andriin@fb.com>
References: <20191219070659.424273-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=25 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add special BPF CO-RE mode to `btf dump` sub-command, which emits C dump of
provided BTF data, but with additional provisions for use with BPF CO-RE.
The first special BPF CO-RE specific feature added is applying
preserve_access_index attribute to all structs/unions to make them
automatically relocatable. This is especially useful for tp_btf/fentry/fexit
BPF program types. They allow direct memory access, so BPF C code just uses
straightfoward a->b->c access pattern to read data from kernel. But without
kernel structs marked as CO-RE relocatable through preserve_access_index
attribute, one has to enclose all the data reads into a special
__builtin_preserve_access_index code block, like so:

__builtin_preserve_access_index(({
    x = p->pid; /* where p is struct task_struct *, for example */
}));

This is very inconvenient and obscures the logic quite a bit. By marking all
auto-generated types with preserve_access_index attribute the above code is
reduced to just clean and natural `x = p->pid;`.

Having a special `format core`, as opposed to extending existing `format c`
mode, allows us to do more improvements like above, knowing that intended use
case is for BPF CO-RE. And still have a clean and unassuming plain C mode for
any other generic use case.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/bpftool/Documentation/bpftool-btf.rst |  7 ++++--
 tools/bpf/bpftool/bash-completion/bpftool     |  2 +-
 tools/bpf/bpftool/btf.c                       | 24 +++++++++++++++----
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 39615f8e145b..101a91280f3d 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -24,7 +24,7 @@ BTF COMMANDS
 |	**bpftool** **btf help**
 |
 |	*BTF_SRC* := { **id** *BTF_ID* | **prog** *PROG* | **map** *MAP* [{**key** | **value** | **kv** | **all**}] | **file** *FILE* }
-|	*FORMAT* := { **raw** | **c** }
+|	*FORMAT* := { **raw** | **c** | **core** }
 |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
 |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
 
@@ -59,7 +59,10 @@ DESCRIPTION
 
 		  **format** option can be used to override default (raw)
 		  output format. Raw (**raw**) or C-syntax (**c**) output
-		  formats are supported.
+		  formats are supported. There is also a special BPF CO-RE
+		  mode (**core**), which emits types in valid C syntax, but
+		  with additional provisions for more seamless use with BPF
+		  CO-RE.
 
 	**bpftool btf help**
 		  Print short help message.
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 754d8395e451..8308ae5f5679 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -800,7 +800,7 @@ _bpftool()
                             return 0
                             ;;
                         format)
-                            COMPREPLY=( $( compgen -W "c raw" -- "$cur" ) )
+                            COMPREPLY=( $( compgen -W "c core raw" -- "$cur" ) )
                             ;;
                         *)
                             # emit extra options
diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index e5bc97b71ceb..a57494493fec 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -361,7 +361,7 @@ static void __printf(2, 0) btf_dump_printf(void *ctx,
 }
 
 static int dump_btf_c(const struct btf *btf,
-		      __u32 *root_type_ids, int root_type_cnt)
+		      __u32 *root_type_ids, int root_type_cnt, bool core_mode)
 {
 	struct btf_dump *d;
 	int err = 0, i;
@@ -370,6 +370,13 @@ static int dump_btf_c(const struct btf *btf,
 	if (IS_ERR(d))
 		return PTR_ERR(d);
 
+	if (core_mode) {
+		printf("#if defined(__has_attribute) && __has_attribute(preserve_access_index)\n");
+		printf("#define __CLANG_BPF_CORE_SUPPORTED\n");
+		printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
+		printf("#endif\n\n");
+	}
+
 	if (root_type_cnt) {
 		for (i = 0; i < root_type_cnt; i++) {
 			err = btf_dump__dump_type(d, root_type_ids[i]);
@@ -386,6 +393,12 @@ static int dump_btf_c(const struct btf *btf,
 		}
 	}
 
+	if (core_mode) {
+		printf("#ifdef __CLANG_BPF_CORE_SUPPORTED\n");
+		printf("#pragma clang attribute pop\n");
+		printf("#endif\n");
+	}
+
 done:
 	btf_dump__free(d);
 	return err;
@@ -441,10 +454,10 @@ static bool is_btf_raw(const char *file)
 
 static int do_dump(int argc, char **argv)
 {
+	bool dump_c = false, core_mode = false;
 	struct btf *btf = NULL;
 	__u32 root_type_ids[2];
 	int root_type_cnt = 0;
-	bool dump_c = false;
 	__u32 btf_id = -1;
 	const char *src;
 	int fd = -1;
@@ -544,6 +557,9 @@ static int do_dump(int argc, char **argv)
 			}
 			if (strcmp(*argv, "c") == 0) {
 				dump_c = true;
+			} else if (strcmp(*argv, "core") == 0) {
+				dump_c = true;
+				core_mode = true;
 			} else if (strcmp(*argv, "raw") == 0) {
 				dump_c = false;
 			} else {
@@ -577,7 +593,7 @@ static int do_dump(int argc, char **argv)
 			err = -ENOTSUP;
 			goto done;
 		}
-		err = dump_btf_c(btf, root_type_ids, root_type_cnt);
+		err = dump_btf_c(btf, root_type_ids, root_type_cnt, core_mode);
 	} else {
 		err = dump_btf_raw(btf, root_type_ids, root_type_cnt);
 	}
@@ -925,7 +941,7 @@ static int do_help(int argc, char **argv)
 		"       %s btf help\n"
 		"\n"
 		"       BTF_SRC := { id BTF_ID | prog PROG | map MAP [{key | value | kv | all}] | file FILE }\n"
-		"       FORMAT  := { raw | c }\n"
+		"       FORMAT  := { raw | c | core }\n"
 		"       " HELP_SPEC_MAP "\n"
 		"       " HELP_SPEC_PROGRAM "\n"
 		"       " HELP_SPEC_OPTIONS "\n"
-- 
2.17.1

