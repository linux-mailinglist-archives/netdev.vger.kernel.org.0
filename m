Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C9620BD6D
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 02:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgF0A0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 20:26:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52354 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726441AbgF0A0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 20:26:24 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05R0BZdu012712
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 17:26:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=u+5wtdmp3Tvnk/1za/1DcGzds4IKhvKQfhPjZHRVDEk=;
 b=payMvclmcG236Jcb/wPhGGLsuS16P9jRedPMsB8DPMuxPgZczcX8IS8mCWK3AmW6ACQ4
 psvjmVMyzqALb4bcviRjEVqe3Z0Zfr4IjpCH6e89CKCyxq/S62rUIHMTjcMMBq5kzY+j
 hVVEguR/Q6UOHVu6UDZ2gj3kVLnur/wXSDs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0w86qn-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 17:26:23 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 17:26:21 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 0A27F62E4DEC; Fri, 26 Jun 2020 17:26:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/4] perf: expose get/put_callchain_entry()
Date:   Fri, 26 Jun 2020 17:26:05 -0700
Message-ID: <20200627002609.3222870-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200627002609.3222870-1-songliubraving@fb.com>
References: <20200627002609.3222870-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 cotscore=-2147483648 mlxscore=0 suspectscore=8 adultscore=0
 phishscore=0 clxscore=1015 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006270000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sanitize and expose get/put_callchain_entry(). This would be used by bpf
stack map.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/perf_event.h |  2 ++
 kernel/events/callchain.c  | 13 ++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b4bb32082342c..00ab5efa38334 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1244,6 +1244,8 @@ get_perf_callchain(struct pt_regs *regs, u32 init_n=
r, bool kernel, bool user,
 extern struct perf_callchain_entry *perf_callchain(struct perf_event *ev=
ent, struct pt_regs *regs);
 extern int get_callchain_buffers(int max_stack);
 extern void put_callchain_buffers(void);
+extern struct perf_callchain_entry *get_callchain_entry(int *rctx);
+extern void put_callchain_entry(int rctx);
=20
 extern int sysctl_perf_event_max_stack;
 extern int sysctl_perf_event_max_contexts_per_stack;
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 334d48b16c36d..c6ce894e4ce94 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -149,7 +149,7 @@ void put_callchain_buffers(void)
 	}
 }
=20
-static struct perf_callchain_entry *get_callchain_entry(int *rctx)
+struct perf_callchain_entry *get_callchain_entry(int *rctx)
 {
 	int cpu;
 	struct callchain_cpus_entries *entries;
@@ -159,8 +159,10 @@ static struct perf_callchain_entry *get_callchain_en=
try(int *rctx)
 		return NULL;
=20
 	entries =3D rcu_dereference(callchain_cpus_entries);
-	if (!entries)
+	if (!entries) {
+		put_recursion_context(this_cpu_ptr(callchain_recursion), *rctx);
 		return NULL;
+	}
=20
 	cpu =3D smp_processor_id();
=20
@@ -168,7 +170,7 @@ static struct perf_callchain_entry *get_callchain_ent=
ry(int *rctx)
 		(*rctx * perf_callchain_entry__sizeof()));
 }
=20
-static void
+void
 put_callchain_entry(int rctx)
 {
 	put_recursion_context(this_cpu_ptr(callchain_recursion), rctx);
@@ -183,11 +185,8 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr=
, bool kernel, bool user,
 	int rctx;
=20
 	entry =3D get_callchain_entry(&rctx);
-	if (rctx =3D=3D -1)
-		return NULL;
-
 	if (!entry)
-		goto exit_put;
+		return NULL;
=20
 	ctx.entry     =3D entry;
 	ctx.max_stack =3D max_stack;
--=20
2.24.1

