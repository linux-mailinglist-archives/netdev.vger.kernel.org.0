Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2164033A154
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 22:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhCMVJv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 13 Mar 2021 16:09:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26930 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234385AbhCMVJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 16:09:36 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12DL6Es6030077
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 13:09:36 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 378uyfskg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 13:09:36 -0800
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 13 Mar 2021 13:09:35 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4D9752ED2050; Sat, 13 Mar 2021 13:09:27 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 2/4] bpftool: fix maybe-uninitialized warnings
Date:   Sat, 13 Mar 2021 13:09:18 -0800
Message-ID: <20210313210920.1959628-3-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210313210920.1959628-1-andrii@kernel.org>
References: <20210313210920.1959628-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-13_10:2021-03-12,2021-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103130165
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Somehow when bpftool is compiled in -Og mode, compiler produces new warnings
about possibly uninitialized variables. Fix all the reported problems.

Fixes: 2119f2189df1 ("bpftool: add C output format option to btf dump subcommand")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/btf.c  | 3 +++
 tools/bpf/bpftool/main.c | 3 +--
 tools/bpf/bpftool/map.c  | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 985610c3f193..62953bbf68b4 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -546,6 +546,7 @@ static int do_dump(int argc, char **argv)
 			NEXT_ARG();
 			if (argc < 1) {
 				p_err("expecting value for 'format' option\n");
+				err = -EINVAL;
 				goto done;
 			}
 			if (strcmp(*argv, "c") == 0) {
@@ -555,11 +556,13 @@ static int do_dump(int argc, char **argv)
 			} else {
 				p_err("unrecognized format specifier: '%s', possible values: raw, c",
 				      *argv);
+				err = -EINVAL;
 				goto done;
 			}
 			NEXT_ARG();
 		} else {
 			p_err("unrecognized option: '%s'", *argv);
+			err = -EINVAL;
 			goto done;
 		}
 	}
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index b86f450e6fce..d9afb730136a 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -276,7 +276,7 @@ static int do_batch(int argc, char **argv)
 	int n_argc;
 	FILE *fp;
 	char *cp;
-	int err;
+	int err = 0;
 	int i;
 
 	if (argc < 2) {
@@ -370,7 +370,6 @@ static int do_batch(int argc, char **argv)
 	} else {
 		if (!json_output)
 			printf("processed %d commands\n", lines);
-		err = 0;
 	}
 err_close:
 	if (fp != stdin)
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index b400364ee054..09ae0381205b 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -100,7 +100,7 @@ static int do_dump_btf(const struct btf_dumper *d,
 		       void *value)
 {
 	__u32 value_id;
-	int ret;
+	int ret = 0;
 
 	/* start of key-value pair */
 	jsonw_start_object(d->jw);
-- 
2.24.1

