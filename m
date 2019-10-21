Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A64EDF3B4
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 18:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfJUQ5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 12:57:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18002 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbfJUQ5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 12:57:49 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9LGobkq004851
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 09:57:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=bGEvpg0+Lvux21Cr6KSmJq0IJGFokFMqS6E6Pe6CQkM=;
 b=cbR6k9pwUkj6qiIgtiT7i4EKuAw4ksyQ4iez8zfL6wdd7dUcGMiZxK+LD0egGunvvBuS
 bHT/MVtZs8uAKbe+rZRXDrXnTgaoDUkTzek19fF9XlA8Z8jGpc7z8Gpcloh0EgdAdXk4
 VQxfxQ2UqfsvIxms996G2g/bgo2KJwyLVFQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vrj5dw61m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 09:57:47 -0700
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 21 Oct 2019 09:57:46 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 46673861996; Mon, 21 Oct 2019 09:57:46 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] libbpf: make LIBBPF_OPTS macro strictly a variable declaration
Date:   Mon, 21 Oct 2019 09:57:44 -0700
Message-ID: <20191021165744.2116648-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-21_04:2019-10-21,2019-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8 mlxscore=0
 clxscore=1015 mlxlogscore=933 impostorscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910210160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LIBBPF_OPTS is implemented as a mix of field declaration and memset
+ assignment. This makes it neither variable declaration nor purely
statements, which is a problem, because you can't mix it with either
other variable declarations nor other function statements, because C90
compiler mode emits warning on mixing all that together.

This patch changes LIBBPF_OPTS into a strictly declaration of variable
and solves this problem, as can be seen in case of bpftool, which
previously would emit compiler warning, if done this way (LIBBPF_OPTS as
part of function variables declaration block).

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/prog.c |  6 +++---
 tools/lib/bpf/libbpf.h   | 13 +++++++------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 27da96a797ab..1a7e8ddf8232 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1093,6 +1093,9 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 {
 	struct bpf_object_load_attr load_attr = { 0 };
 	enum bpf_prog_type common_prog_type = BPF_PROG_TYPE_UNSPEC;
+	LIBBPF_OPTS(bpf_object_open_opts, open_opts,
+		.relaxed_maps = relaxed_maps,
+	);
 	enum bpf_attach_type expected_attach_type;
 	struct map_replace *map_replace = NULL;
 	struct bpf_program *prog = NULL, *pos;
@@ -1106,9 +1109,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 	const char *file;
 	int idx, err;
 
-	LIBBPF_OPTS(bpf_object_open_opts, open_opts,
-		.relaxed_maps = relaxed_maps,
-	);
 
 	if (!REQ_ARGS(2))
 		return -1;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 0fdf086beba7..bf105e9e866f 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -77,12 +77,13 @@ struct bpf_object_open_attr {
  * bytes, but that's the best way I've found and it seems to work in practice.
  */
 #define LIBBPF_OPTS(TYPE, NAME, ...)					    \
-	struct TYPE NAME;						    \
-	memset(&NAME, 0, sizeof(struct TYPE));				    \
-	NAME = (struct TYPE) {						    \
-		.sz = sizeof(struct TYPE),				    \
-		__VA_ARGS__						    \
-	}
+	struct TYPE NAME = ({ 						    \
+		memset(&NAME, 0, sizeof(struct TYPE));			    \
+		(struct TYPE) {						    \
+			.sz = sizeof(struct TYPE),			    \
+			__VA_ARGS__					    \
+		};							    \
+	})
 
 struct bpf_object_open_opts {
 	/* size of this struct, for forward/backward compatiblity */
-- 
2.17.1

