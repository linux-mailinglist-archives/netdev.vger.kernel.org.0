Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658E022F807
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbgG0Spc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:45:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731732AbgG0Sp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:45:29 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RIf4Ne020170
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=tOTnKQ9hJ/6vyBiLFhDflnCJN3o7B64H4g4vYAd3Q5c=;
 b=LVgXSAU53KXF78qUM6C8wHDIXnH6ytSFvFqJzC3bsWfPUsmUDq5Q7IgFnKpG7HkwpNVf
 TfoLnBQTABJqjFG+lln1tqaPJ4p3ybs2/vGjQ2CStjoltvNlUM2rryqVUSeQA/pYIfrR
 PUrvVd3X86ng4uwU/7fTqL814Vh7teUuNJI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4k25uym-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:29 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 11:45:22 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 451681DAFEB7; Mon, 27 Jul 2020 11:45:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v2 35/35] perf: don't touch RLIMIT_MEMLOCK
Date:   Mon, 27 Jul 2020 11:45:06 -0700
Message-ID: <20200727184506.2279656-36-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727184506.2279656-1-guro@fb.com>
References: <20200727184506.2279656-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_13:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 malwarescore=0 bulkscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=13
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since bpf stopped using memlock rlimit to limit the memory usage,
there is no more reason for perf to alter its own limit.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 tools/perf/builtin-trace.c      | 10 ----------
 tools/perf/tests/builtin-test.c |  6 ------
 tools/perf/util/Build           |  1 -
 tools/perf/util/rlimit.c        | 29 -----------------------------
 tools/perf/util/rlimit.h        |  6 ------
 5 files changed, 52 deletions(-)
 delete mode 100644 tools/perf/util/rlimit.c
 delete mode 100644 tools/perf/util/rlimit.h

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 4cbb64edc998..3d6a98a12537 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -19,7 +19,6 @@
 #include <api/fs/tracing_path.h>
 #include <bpf/bpf.h>
 #include "util/bpf_map.h"
-#include "util/rlimit.h"
 #include "builtin.h"
 #include "util/cgroup.h"
 #include "util/color.h"
@@ -4838,15 +4837,6 @@ int cmd_trace(int argc, const char **argv)
 		goto out;
 	}
=20
-	/*
-	 * Parsing .perfconfig may entail creating a BPF event, that may need
-	 * to create BPF maps, so bump RLIM_MEMLOCK as the default 64K setting
-	 * is too small. This affects just this process, not touching the
-	 * global setting. If it fails we'll get something in 'perf trace -v'
-	 * to help diagnose the problem.
-	 */
-	rlimit__bump_memlock();
-
 	err =3D perf_config(trace__config, &trace);
 	if (err)
 		goto out;
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-t=
est.c
index da5b6cc23f25..e4efbba8202b 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -22,7 +22,6 @@
 #include <subcmd/parse-options.h>
 #include "string2.h"
 #include "symbol.h"
-#include "util/rlimit.h"
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <subcmd/exec-cmd.h>
@@ -794,11 +793,6 @@ int cmd_test(int argc, const char **argv)
=20
 	if (skip !=3D NULL)
 		skiplist =3D intlist__new(skip);
-	/*
-	 * Tests that create BPF maps, for instance, need more than the 64K
-	 * default:
-	 */
-	rlimit__bump_memlock();
=20
 	return __cmd_test(argc, argv, skiplist);
 }
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index 8d18380ecd10..4902cd3b3b58 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -26,7 +26,6 @@ perf-y +=3D parse-events.o
 perf-y +=3D perf_regs.o
 perf-y +=3D path.o
 perf-y +=3D print_binary.o
-perf-y +=3D rlimit.o
 perf-y +=3D argv_split.o
 perf-y +=3D rbtree.o
 perf-y +=3D libstring.o
diff --git a/tools/perf/util/rlimit.c b/tools/perf/util/rlimit.c
deleted file mode 100644
index 13521d392a22..000000000000
--- a/tools/perf/util/rlimit.c
+++ /dev/null
@@ -1,29 +0,0 @@
-/* SPDX-License-Identifier: LGPL-2.1 */
-
-#include "util/debug.h"
-#include "util/rlimit.h"
-#include <sys/time.h>
-#include <sys/resource.h>
-
-/*
- * Bump the memlock so that we can get bpf maps of a reasonable size,
- * like the ones used with 'perf trace' and with 'perf test bpf',
- * improve this to some specific request if needed.
- */
-void rlimit__bump_memlock(void)
-{
-	struct rlimit rlim;
-
-	if (getrlimit(RLIMIT_MEMLOCK, &rlim) =3D=3D 0) {
-		rlim.rlim_cur *=3D 4;
-		rlim.rlim_max *=3D 4;
-
-		if (setrlimit(RLIMIT_MEMLOCK, &rlim) < 0) {
-			rlim.rlim_cur /=3D 2;
-			rlim.rlim_max /=3D 2;
-
-			if (setrlimit(RLIMIT_MEMLOCK, &rlim) < 0)
-				pr_debug("Couldn't bump rlimit(MEMLOCK), failures may take place whe=
n creating BPF maps, etc\n");
-		}
-	}
-}
diff --git a/tools/perf/util/rlimit.h b/tools/perf/util/rlimit.h
deleted file mode 100644
index 9f59d8e710a3..000000000000
--- a/tools/perf/util/rlimit.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __PERF_RLIMIT_H_
-#define __PERF_RLIMIT_H_
-/* SPDX-License-Identifier: LGPL-2.1 */
-
-void rlimit__bump_memlock(void);
-#endif // __PERF_RLIMIT_H_
--=20
2.26.2

