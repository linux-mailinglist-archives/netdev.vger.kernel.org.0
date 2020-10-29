Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A061329DF31
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403939AbgJ2A7q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Oct 2020 20:59:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20796 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728750AbgJ2A7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 20:59:38 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09T0od9C004473
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 17:59:38 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34esepr272-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 17:59:38 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 28 Oct 2020 17:59:33 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DA1922EC875F; Wed, 28 Oct 2020 17:59:30 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 11/11] tools/bpftool: add bpftool support for split BTF
Date:   Wed, 28 Oct 2020 17:59:02 -0700
Message-ID: <20201029005902.1706310-12-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201029005902.1706310-1-andrii@kernel.org>
References: <20201029005902.1706310-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_09:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1034 priorityscore=1501
 suspectscore=25 phishscore=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to work with split BTF by providing extra -B flag, which allows to
specify the path to the base BTF file.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/btf.c  |  9 ++++++---
 tools/bpf/bpftool/main.c | 15 ++++++++++++++-
 tools/bpf/bpftool/main.h |  1 +
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 8ab142ff5eac..c96b56e8e3a4 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -358,8 +358,12 @@ static int dump_btf_raw(const struct btf *btf,
 		}
 	} else {
 		int cnt = btf__get_nr_types(btf);
+		int start_id = 1;
 
-		for (i = 1; i <= cnt; i++) {
+		if (base_btf)
+			start_id = btf__get_nr_types(base_btf) + 1;
+
+		for (i = start_id; i <= cnt; i++) {
 			t = btf__type_by_id(btf, i);
 			dump_btf_type(btf, i, t);
 		}
@@ -438,7 +442,6 @@ static int do_dump(int argc, char **argv)
 		return -1;
 	}
 	src = GET_ARG();
-
 	if (is_prefix(src, "map")) {
 		struct bpf_map_info info = {};
 		__u32 len = sizeof(info);
@@ -499,7 +502,7 @@ static int do_dump(int argc, char **argv)
 		}
 		NEXT_ARG();
 	} else if (is_prefix(src, "file")) {
-		btf = btf__parse(*argv, NULL);
+		btf = btf__parse_split(*argv, base_btf);
 		if (IS_ERR(btf)) {
 			err = -PTR_ERR(btf);
 			btf = NULL;
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 682daaa49e6a..b86f450e6fce 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -11,6 +11,7 @@
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
+#include <bpf/btf.h>
 
 #include "main.h"
 
@@ -28,6 +29,7 @@ bool show_pinned;
 bool block_mount;
 bool verifier_logs;
 bool relaxed_maps;
+struct btf *base_btf;
 struct pinned_obj_table prog_table;
 struct pinned_obj_table map_table;
 struct pinned_obj_table link_table;
@@ -391,6 +393,7 @@ int main(int argc, char **argv)
 		{ "mapcompat",	no_argument,	NULL,	'm' },
 		{ "nomount",	no_argument,	NULL,	'n' },
 		{ "debug",	no_argument,	NULL,	'd' },
+		{ "base-btf",	required_argument, NULL, 'B' },
 		{ 0 }
 	};
 	int opt, ret;
@@ -407,7 +410,7 @@ int main(int argc, char **argv)
 	hash_init(link_table.table);
 
 	opterr = 0;
-	while ((opt = getopt_long(argc, argv, "Vhpjfmnd",
+	while ((opt = getopt_long(argc, argv, "VhpjfmndB:",
 				  options, NULL)) >= 0) {
 		switch (opt) {
 		case 'V':
@@ -441,6 +444,15 @@ int main(int argc, char **argv)
 			libbpf_set_print(print_all_levels);
 			verifier_logs = true;
 			break;
+		case 'B':
+			base_btf = btf__parse(optarg, NULL);
+			if (libbpf_get_error(base_btf)) {
+				p_err("failed to parse base BTF at '%s': %ld\n",
+				      optarg, libbpf_get_error(base_btf));
+				base_btf = NULL;
+				return -1;
+			}
+			break;
 		default:
 			p_err("unrecognized option '%s'", argv[optind - 1]);
 			if (json_output)
@@ -465,6 +477,7 @@ int main(int argc, char **argv)
 		delete_pinned_obj_table(&map_table);
 		delete_pinned_obj_table(&link_table);
 	}
+	btf__free(base_btf);
 
 	return ret;
 }
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index c46e52137b87..76e91641262b 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -90,6 +90,7 @@ extern bool show_pids;
 extern bool block_mount;
 extern bool verifier_logs;
 extern bool relaxed_maps;
+extern struct btf *base_btf;
 extern struct pinned_obj_table prog_table;
 extern struct pinned_obj_table map_table;
 extern struct pinned_obj_table link_table;
-- 
2.24.1

