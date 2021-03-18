Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F9A33FFA2
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 07:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhCRGbt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Mar 2021 02:31:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20206 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229745AbhCRGbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 02:31:36 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12I6QC0Z028109
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 23:31:36 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37bgdhdvhn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 23:31:36 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 17 Mar 2021 23:31:35 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3A8C52ED24FA; Wed, 17 Mar 2021 23:31:34 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 08/12] bpftool: add ability to specify custom skeleton object name
Date:   Wed, 17 Mar 2021 23:31:11 -0700
Message-ID: <20210318063115.49613-9-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318063115.49613-1-andrii@kernel.org>
References: <20210318063115.49613-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_02:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 clxscore=1015 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 bulkscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180050
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add optional name OBJECT_NAME parameter to `gen skeleton` command to override
default object name, normally derived from input file name. This allows much
more flexibility during build time.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../bpf/bpftool/Documentation/bpftool-gen.rst | 13 +++++----
 tools/bpf/bpftool/bash-completion/bpftool     | 11 +++++++-
 tools/bpf/bpftool/gen.c                       | 27 +++++++++++++++++--
 3 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index 84cf0639696f..d4e7338e22e7 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -19,7 +19,7 @@ SYNOPSIS
 GEN COMMANDS
 =============
 
-|	**bpftool** **gen skeleton** *FILE*
+|	**bpftool** **gen skeleton** *FILE* [**name** *OBJECT_NAME*]
 |	**bpftool** **gen help**
 
 DESCRIPTION
@@ -75,10 +75,13 @@ DESCRIPTION
 		  specific maps, programs, etc.
 
 		  As part of skeleton, few custom functions are generated.
-		  Each of them is prefixed with object name, derived from
-		  object file name. I.e., if BPF object file name is
-		  **example.o**, BPF object name will be **example**. The
-		  following custom functions are provided in such case:
+		  Each of them is prefixed with object name. Object name can
+		  either be derived from object file name, i.e., if BPF object
+		  file name is **example.o**, BPF object name will be
+		  **example**. Object name can be also specified explicitly
+		  through **name** *OBJECT_NAME* parameter. The following
+		  custom functions are provided (assuming **example** as
+		  the object name):
 
 		  - **example__open** and **example__open_opts**.
 		    These functions are used to instantiate skeleton. It
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index fdffbc64c65c..bf7b4bdbb23a 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -982,7 +982,16 @@ _bpftool()
         gen)
             case $command in
                 skeleton)
-                    _filedir
+                    case $prev in
+                        $command)
+                            _filedir
+                            return 0
+                            ;;
+                        *)
+                            _bpftool_once_attr 'name'
+                            return 0
+                            ;;
+                    esac
                     ;;
                 *)
                     [[ $prev == $object ]] && \
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 4033c46d83e7..cd35163f2d08 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -288,6 +288,28 @@ static int do_skeleton(int argc, char **argv)
 	}
 	file = GET_ARG();
 
+	while (argc) {
+		if (!REQ_ARGS(2))
+			return -1;
+
+		if (is_prefix(*argv, "name")) {
+			NEXT_ARG();
+
+			if (obj_name[0] != '\0') {
+				p_err("object name already specified");
+				return -1;
+			}
+
+			strncpy(obj_name, *argv, MAX_OBJ_NAME_LEN - 1);
+			obj_name[MAX_OBJ_NAME_LEN - 1] = '\0';
+		} else {
+			p_err("unknown arg %s", *argv);
+			return -1;
+		}
+
+		NEXT_ARG();
+	}
+
 	if (argc) {
 		p_err("extra unknown arguments");
 		return -1;
@@ -310,7 +332,8 @@ static int do_skeleton(int argc, char **argv)
 		p_err("failed to mmap() %s: %s", file, strerror(errno));
 		goto out;
 	}
-	get_obj_name(obj_name, file);
+	if (obj_name[0] == '\0')
+		get_obj_name(obj_name, file);
 	opts.object_name = obj_name;
 	obj = bpf_object__open_mem(obj_data, file_sz, &opts);
 	if (IS_ERR(obj)) {
@@ -599,7 +622,7 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %1$s %2$s skeleton FILE\n"
+		"Usage: %1$s %2$s skeleton FILE [name OBJECT_NAME]\n"
 		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_OPTIONS "\n"
-- 
2.30.2

