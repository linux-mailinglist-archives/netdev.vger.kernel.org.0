Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFA05A0C1A
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfH1VEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:04:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39368 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726583AbfH1VEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:04:31 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7SL0d6h015726
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=i/oSHlRUjt3br9XtRGjcR+sgJQT/s8b1f3GoHBUMabs=;
 b=jkN1S4DmbobYOJiiXdMeBp3WFNsWj95B6Ie9YQtNTjW+n94HW9WdJQh6yFKi0yHvffpR
 ZAKJht34PUK9RjCfi6uKURdlzWxMo2D2wpvq7V6vvZOAhy1sYeM7OtRTIpqhlUILWrcd
 V9iJECrQ8UlJ8SNK2KX8OKDe5mB6cVsI8jE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2un3vjr1f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:30 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 28 Aug 2019 14:04:29 -0700
Received: by devvm2868.prn3.facebook.com (Postfix, from userid 125878)
        id 37F5CA25D6B9; Wed, 28 Aug 2019 14:04:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Julia Kartseva <hex@fb.com>
Smtp-Origin-Hostname: devvm2868.prn3.facebook.com
To:     <rdna@fb.com>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: prn3c11
Subject: [PATCH bpf-next 10/10] tools/bpftool: use libbpf_attach_type_to_str helper
Date:   Wed, 28 Aug 2019 14:03:13 -0700
Message-ID: <558d1511b255eb38974162674e7e1687fbedb8b7.1567024943.git.hex@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1567024943.git.hex@fb.com>
References: <cover.1567024943.git.hex@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-28_11:2019-08-28,2019-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 clxscore=1015 phishscore=0 mlxlogscore=682 adultscore=0
 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908280205
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace lookup in `attach_type_strings` with
libbpf_attach_type_to_str helper for cgroup (cgroup.c)
and non-cgroup (prog.c) attach types.

Signed-off-by: Julia Kartseva <hex@fb.com>
---
 tools/bpf/bpftool/cgroup.c | 60 +++++++++++++++++++++-----------------
 tools/bpf/bpftool/prog.c   | 20 +++++++------
 2 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 1ef45e55039e..1b53218b06e7 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 
 #include <bpf.h>
+#include <libbpf.h>
 
 #include "main.h"
 
@@ -31,35 +32,37 @@
 
 static unsigned int query_flags;
 
-static const char * const attach_type_strings[] = {
-	[BPF_CGROUP_INET_INGRESS] = "ingress",
-	[BPF_CGROUP_INET_EGRESS] = "egress",
-	[BPF_CGROUP_INET_SOCK_CREATE] = "sock_create",
-	[BPF_CGROUP_SOCK_OPS] = "sock_ops",
-	[BPF_CGROUP_DEVICE] = "device",
-	[BPF_CGROUP_INET4_BIND] = "bind4",
-	[BPF_CGROUP_INET6_BIND] = "bind6",
-	[BPF_CGROUP_INET4_CONNECT] = "connect4",
-	[BPF_CGROUP_INET6_CONNECT] = "connect6",
-	[BPF_CGROUP_INET4_POST_BIND] = "post_bind4",
-	[BPF_CGROUP_INET6_POST_BIND] = "post_bind6",
-	[BPF_CGROUP_UDP4_SENDMSG] = "sendmsg4",
-	[BPF_CGROUP_UDP6_SENDMSG] = "sendmsg6",
-	[BPF_CGROUP_SYSCTL] = "sysctl",
-	[BPF_CGROUP_UDP4_RECVMSG] = "recvmsg4",
-	[BPF_CGROUP_UDP6_RECVMSG] = "recvmsg6",
-	[BPF_CGROUP_GETSOCKOPT] = "getsockopt",
-	[BPF_CGROUP_SETSOCKOPT] = "setsockopt",
-	[__MAX_BPF_ATTACH_TYPE] = NULL,
+static const enum bpf_attach_type cgroup_attach_types[] = {
+	BPF_CGROUP_INET_INGRESS,
+	BPF_CGROUP_INET_EGRESS,
+	BPF_CGROUP_INET_SOCK_CREATE,
+	BPF_CGROUP_SOCK_OPS,
+	BPF_CGROUP_DEVICE,
+	BPF_CGROUP_INET4_BIND,
+	BPF_CGROUP_INET6_BIND,
+	BPF_CGROUP_INET4_CONNECT,
+	BPF_CGROUP_INET6_CONNECT,
+	BPF_CGROUP_INET4_POST_BIND,
+	BPF_CGROUP_INET6_POST_BIND,
+	BPF_CGROUP_UDP4_SENDMSG,
+	BPF_CGROUP_UDP6_SENDMSG,
+	BPF_CGROUP_SYSCTL,
+	BPF_CGROUP_UDP4_RECVMSG,
+	BPF_CGROUP_UDP6_RECVMSG,
+	BPF_CGROUP_GETSOCKOPT,
+	BPF_CGROUP_SETSOCKOPT,
 };
 
 static enum bpf_attach_type parse_attach_type(const char *str)
 {
 	enum bpf_attach_type type;
+	const char *atype_str;
+	unsigned int i;
 
-	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
-		if (attach_type_strings[type] &&
-		    is_prefix(str, attach_type_strings[type]))
+	for (i = 0; i < ARRAY_SIZE(cgroup_attach_types); i++) {
+		type = cgroup_attach_types[i];
+		if (!libbpf_attach_type_to_str(type, &atype_str) &&
+		    is_prefix(str, atype_str))
 			return type;
 	}
 
@@ -120,7 +123,7 @@ static int count_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type)
 static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 				   int level)
 {
-	const char *attach_flags_str;
+	const char *attach_flags_str, *atype_str;
 	__u32 prog_ids[1024] = {0};
 	__u32 prog_cnt, iter;
 	__u32 attach_flags;
@@ -136,6 +139,11 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 	if (prog_cnt == 0)
 		return 0;
 
+	ret = libbpf_attach_type_to_str(type, &atype_str);
+
+	if (ret)
+		return 0;
+
 	switch (attach_flags) {
 	case BPF_F_ALLOW_MULTI:
 		attach_flags_str = "multi";
@@ -152,8 +160,8 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 	}
 
 	for (iter = 0; iter < prog_cnt; iter++)
-		show_bpf_prog(prog_ids[iter], attach_type_strings[type],
-			      attach_flags_str, level);
+		show_bpf_prog(prog_ids[iter], atype_str, attach_flags_str,
+			      level);
 
 	return 0;
 }
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 8bbb24339a52..4dfec67e22fa 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -25,21 +25,23 @@
 #include "main.h"
 #include "xlated_dumper.h"
 
-static const char * const attach_type_strings[] = {
-	[BPF_SK_SKB_STREAM_PARSER] = "stream_parser",
-	[BPF_SK_SKB_STREAM_VERDICT] = "stream_verdict",
-	[BPF_SK_MSG_VERDICT] = "msg_verdict",
-	[BPF_FLOW_DISSECTOR] = "flow_dissector",
-	[__MAX_BPF_ATTACH_TYPE] = NULL,
+static const enum bpf_attach_type attach_types[] = {
+	BPF_SK_SKB_STREAM_PARSER,
+	BPF_SK_SKB_STREAM_VERDICT,
+	BPF_SK_MSG_VERDICT,
+	BPF_FLOW_DISSECTOR,
 };
 
 static enum bpf_attach_type parse_attach_type(const char *str)
 {
 	enum bpf_attach_type type;
+	const char *atype_str;
+	unsigned int i;
 
-	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
-		if (attach_type_strings[type] &&
-		    is_prefix(str, attach_type_strings[type]))
+	for (i = 0; type < ARRAY_SIZE(attach_types); i++) {
+		type = attach_types[i];
+		if (!libbpf_attach_type_to_str(type, &atype_str) &&
+		    is_prefix(str, atype_str))
 			return type;
 	}
 
-- 
2.17.1

