Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCDC315CCD4
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 22:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgBMVBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 16:01:34 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15842 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727883AbgBMVBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 16:01:32 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 01DL0FV8020154
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:01:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Bcq6M5yh042zTYzMjqsK1nqYqbiBBnS+DDQ1QkdKo3g=;
 b=QkW2fsUUNStEYFTDLTHwIFV9ChDeGRVQnSe1utSQVAdcibYF1pPocOi6JqIz9QMIYkW2
 kvcq9FFRhSChJrdxoDFDmVWxKLON1sI4hZxVKVBBlyA8Z067qLuA1KgLzLl3/QJkYGq7
 0fUdLNWQ6RM843J43hWjNt1i/u4hn+az/4Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2y4a5g2832-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:01:26 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 13 Feb 2020 13:01:25 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 2F78462E1F68; Thu, 13 Feb 2020 13:01:22 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC bpf-next 3/4] bpftool: introduce "prog profile" command
Date:   Thu, 13 Feb 2020 13:01:14 -0800
Message-ID: <20200213210115.1455809-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200213210115.1455809-1-songliubraving@fb.com>
References: <20200213210115.1455809-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-13_08:2020-02-12,2020-02-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 mlxscore=0 impostorscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 suspectscore=2 priorityscore=1501 adultscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002130150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With fentry/fexit programs, it is possible to profile BPF program with
hardware counters. Introduce bpftool "prog profile", which measures key
metrics of a BPF program.

bpftool prog profile command creates per-cpu perf events. Then it attaches
fentry/fexit programs to the target BPF program. The fentry program saves
perf event value to a map. The fexit program reads the perf event again,
and calculates the difference, which is the instructions/cycles used by
the target program.

Example input and output:

  ./bpftool prog profile 20 id 810 cycles instructions
  cycles: duration 20 run_cnt 1368 miss_cnt 665
          counter 503377 enabled 668202 running 351857
  instructions: duration 20 run_cnt 1368 miss_cnt 707
          counter 398625 enabled 502330 running 272014

This command measures cycles and instructions for BPF program with id
810 for 20 seconds. The program has triggered 1368 times. cycles was not
measured in 665 out of these runs, because of perf event multiplexing
(some perf commands are running in the background). In these runs, the BPF
program consumed 503377 cycles. The perf_event enabled and running time
are 668202 and 351857 respectively.

Note that, this approach measures cycles and instructions in very small
increments. So the fentry/fexit programs introduce noticable errors to
the measurement results.

The fentry/fexit programs are generated with BPF skeleton. Currently,
generation of the skeleton requires some manual steps.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/bpftool/profiler.skel.h         | 820 ++++++++++++++++++++++
 tools/bpf/bpftool/prog.c                  | 387 +++++++++-
 tools/bpf/bpftool/skeleton/README         |   3 +
 tools/bpf/bpftool/skeleton/profiler.bpf.c | 185 +++++
 tools/bpf/bpftool/skeleton/profiler.h     |  47 ++
 5 files changed, 1441 insertions(+), 1 deletion(-)
 create mode 100644 tools/bpf/bpftool/profiler.skel.h
 create mode 100644 tools/bpf/bpftool/skeleton/README
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.h

diff --git a/tools/bpf/bpftool/profiler.skel.h b/tools/bpf/bpftool/profiler.skel.h
new file mode 100644
index 000000000000..10e99989c03e
--- /dev/null
+++ b/tools/bpf/bpftool/profiler.skel.h
@@ -0,0 +1,820 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+
+/* THIS FILE IS AUTOGENERATED! */
+#ifndef __PROFILER_BPF_SKEL_H__
+#define __PROFILER_BPF_SKEL_H__
+
+#include <stdlib.h>
+#include <bpf/libbpf.h>
+
+struct profiler_bpf {
+	struct bpf_object_skeleton *skeleton;
+	struct bpf_object *obj;
+	struct {
+		struct bpf_map *events;
+		struct bpf_map *fentry_readings;
+		struct bpf_map *accum_readings;
+		struct bpf_map *counts;
+		struct bpf_map *miss_counts;
+		struct bpf_map *rodata;
+	} maps;
+	struct {
+		struct bpf_program *fentry_XXX;
+		struct bpf_program *fexit_XXX;
+	} progs;
+	struct {
+		struct bpf_link *fentry_XXX;
+		struct bpf_link *fexit_XXX;
+	} links;
+	struct profiler_bpf__rodata {
+		__u32 num_cpu;
+		__u32 num_metric;
+	} *rodata;
+};
+
+static void
+profiler_bpf__destroy(struct profiler_bpf *obj)
+{
+	if (!obj)
+		return;
+	if (obj->skeleton)
+		bpf_object__destroy_skeleton(obj->skeleton);
+	free(obj);
+}
+
+static inline int
+profiler_bpf__create_skeleton(struct profiler_bpf *obj);
+
+static inline struct profiler_bpf *
+profiler_bpf__open_opts(const struct bpf_object_open_opts *opts)
+{
+	struct profiler_bpf *obj;
+
+	obj = (typeof(obj))calloc(1, sizeof(*obj));
+	if (!obj)
+		return NULL;
+	if (profiler_bpf__create_skeleton(obj))
+		goto err;
+	if (bpf_object__open_skeleton(obj->skeleton, opts))
+		goto err;
+
+	return obj;
+err:
+	profiler_bpf__destroy(obj);
+	return NULL;
+}
+
+static inline struct profiler_bpf *
+profiler_bpf__open(void)
+{
+	return profiler_bpf__open_opts(NULL);
+}
+
+static inline int
+profiler_bpf__load(struct profiler_bpf *obj)
+{
+	return bpf_object__load_skeleton(obj->skeleton);
+}
+
+static inline struct profiler_bpf *
+profiler_bpf__open_and_load(void)
+{
+	struct profiler_bpf *obj;
+
+	obj = profiler_bpf__open();
+	if (!obj)
+		return NULL;
+	if (profiler_bpf__load(obj)) {
+		profiler_bpf__destroy(obj);
+		return NULL;
+	}
+	return obj;
+}
+
+static inline int
+profiler_bpf__attach(struct profiler_bpf *obj)
+{
+	return bpf_object__attach_skeleton(obj->skeleton);
+}
+
+static inline void
+profiler_bpf__detach(struct profiler_bpf *obj)
+{
+	return bpf_object__detach_skeleton(obj->skeleton);
+}
+
+static inline int
+profiler_bpf__create_skeleton(struct profiler_bpf *obj)
+{
+	struct bpf_object_skeleton *s;
+
+	s = (typeof(s))calloc(1, sizeof(*s));
+	if (!s)
+		return -1;
+	obj->skeleton = s;
+
+	s->sz = sizeof(*s);
+	s->name = "profiler_bpf";
+	s->obj = &obj->obj;
+
+	/* maps */
+	s->map_cnt = 6;
+	s->map_skel_sz = sizeof(*s->maps);
+	s->maps = (typeof(s->maps))calloc(s->map_cnt, s->map_skel_sz);
+	if (!s->maps)
+		goto err;
+
+	s->maps[0].name = "events";
+	s->maps[0].map = &obj->maps.events;
+
+	s->maps[1].name = "fentry_readings";
+	s->maps[1].map = &obj->maps.fentry_readings;
+
+	s->maps[2].name = "accum_readings";
+	s->maps[2].map = &obj->maps.accum_readings;
+
+	s->maps[3].name = "counts";
+	s->maps[3].map = &obj->maps.counts;
+
+	s->maps[4].name = "miss_counts";
+	s->maps[4].map = &obj->maps.miss_counts;
+
+	s->maps[5].name = "profiler.rodata";
+	s->maps[5].map = &obj->maps.rodata;
+	s->maps[5].mmaped = (void **)&obj->rodata;
+
+	/* programs */
+	s->prog_cnt = 2;
+	s->prog_skel_sz = sizeof(*s->progs);
+	s->progs = (typeof(s->progs))calloc(s->prog_cnt, s->prog_skel_sz);
+	if (!s->progs)
+		goto err;
+
+	s->progs[0].name = "fentry_XXX";
+	s->progs[0].prog = &obj->progs.fentry_XXX;
+	s->progs[0].link = &obj->links.fentry_XXX;
+
+	s->progs[1].name = "fexit_XXX";
+	s->progs[1].prog = &obj->progs.fexit_XXX;
+	s->progs[1].link = &obj->links.fexit_XXX;
+
+	s->data_sz = 18256;
+	s->data = (void *)"\
+\x7f\x45\x4c\x46\x02\x01\x01\0\0\0\0\0\0\0\0\0\x01\0\xf7\0\x01\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\x50\x40\0\0\0\0\0\0\0\0\0\0\x40\0\0\0\0\0\x40\0\x1c\0\
+\x01\0\x85\0\0\0\x08\0\0\0\xbf\x06\0\0\0\0\0\0\x18\x01\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\x61\x11\0\0\0\0\0\0\x15\x01\x14\0\0\0\0\0\xbf\xa8\0\0\0\0\0\0\x07\x08\0\0\
+\xe0\xff\xff\xff\xb7\x09\0\0\0\0\0\0\xb7\x07\0\0\0\0\0\0\x63\x9a\xc8\xff\0\0\0\
+\0\xbf\xa2\0\0\0\0\0\0\x07\x02\0\0\xc8\xff\xff\xff\x18\x01\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\x85\0\0\0\x01\0\0\0\x7b\x08\0\0\0\0\0\0\x15\0\x23\0\0\0\0\0\x18\x01\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\x61\x11\0\0\0\0\0\0\x25\x07\x04\0\x02\0\0\0\x07\x07\
+\0\0\x01\0\0\0\x07\x09\0\0\x01\0\0\0\x07\x08\0\0\x08\0\0\0\x2d\x71\xf0\xff\0\0\
+\0\0\x18\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x61\x11\0\0\0\0\0\0\x15\x01\x17\0\0\0\
+\0\0\xb7\x07\0\0\0\0\0\0\xbf\xa8\0\0\0\0\0\0\x07\x08\0\0\xe0\xff\xff\xff\x18\
+\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x05\0\x13\0\0\0\0\0\x79\x81\0\0\0\0\0\0\x79\
+\xa2\xd8\xff\0\0\0\0\x7b\x21\x10\0\0\0\0\0\x79\xa2\xd0\xff\0\0\0\0\x7b\x21\x08\
+\0\0\0\0\0\x79\xa2\xc8\xff\0\0\0\0\x7b\x21\0\0\0\0\0\0\x18\x01\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\x61\x11\0\0\0\0\0\0\x61\x92\0\0\0\0\0\0\x25\x07\x05\0\x02\0\0\0\
+\x0f\x61\0\0\0\0\0\0\x07\x08\0\0\x08\0\0\0\x07\x07\0\0\x01\0\0\0\xbf\x16\0\0\0\
+\0\0\0\x2d\x72\x02\0\0\0\0\0\xb7\0\0\0\0\0\0\0\x95\0\0\0\0\0\0\0\xbf\x62\0\0\0\
+\0\0\0\x67\x02\0\0\x20\0\0\0\x77\x02\0\0\x20\0\0\0\xbf\xa3\0\0\0\0\0\0\x07\x03\
+\0\0\xc8\xff\xff\xff\x18\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xb7\x04\0\0\x18\0\0\0\
+\x85\0\0\0\x37\0\0\0\x67\0\0\0\x20\0\0\0\x77\0\0\0\x20\0\0\0\x15\0\xe1\xff\0\0\
+\0\0\x05\0\xf1\xff\0\0\0\0\x85\0\0\0\x08\0\0\0\xbf\x06\0\0\0\0\0\0\xb7\x08\0\0\
+\0\0\0\0\x63\x8a\x94\xff\0\0\0\0\x18\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x61\x11\0\
+\0\0\0\0\0\x15\x01\x1c\0\0\0\0\0\xbf\xa7\0\0\0\0\0\0\x07\x07\0\0\x98\xff\xff\
+\xff\xb7\x09\0\0\0\0\0\0\x05\0\x08\0\0\0\0\0\x18\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\x61\x11\0\0\0\0\0\0\x25\x09\x14\0\x02\0\0\0\x07\x09\0\0\x01\0\0\0\x07\x08\0\
+\0\x01\0\0\0\x07\x07\0\0\x18\0\0\0\x3d\x19\x10\0\0\0\0\0\x18\x01\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\x61\x12\0\0\0\0\0\0\x2f\x82\0\0\0\0\0\0\x0f\x62\0\0\0\0\0\0\x67\
+\x02\0\0\x20\0\0\0\x77\x02\0\0\x20\0\0\0\x18\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\xbf\x73\0\0\0\0\0\0\xb7\x04\0\0\x18\0\0\0\x85\0\0\0\x37\0\0\0\x67\0\0\0\x20\0\
+\0\0\x77\0\0\0\x20\0\0\0\x15\0\xe9\xff\0\0\0\0\x05\0\x1a\0\0\0\0\0\xbf\xa2\0\0\
+\0\0\0\0\x07\x02\0\0\x94\xff\xff\xff\x18\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85\0\
+\0\0\x01\0\0\0\x15\0\x14\0\0\0\0\0\x79\x01\0\0\0\0\0\0\x07\x01\0\0\x01\0\0\0\
+\x7b\x10\0\0\0\0\0\0\x18\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x61\x11\0\0\0\0\0\0\
+\x15\x01\x0d\0\0\0\0\0\xb7\x07\0\0\0\0\0\0\xbf\xa8\0\0\0\0\0\0\x07\x08\0\0\xa8\
+\xff\xff\xff\xb7\x09\0\0\0\0\0\0\x05\0\x0a\0\0\0\0\0\x18\x01\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\x61\x11\0\0\0\0\0\0\x25\x09\x04\0\x02\0\0\0\x07\x07\0\0\x01\0\0\0\
+\x07\x08\0\0\x18\0\0\0\x07\x09\0\0\x01\0\0\0\x2d\x91\x02\0\0\0\0\0\xb7\0\0\0\0\
+\0\0\0\x95\0\0\0\0\0\0\0\x63\x7a\xfc\xff\0\0\0\0\xbf\xa2\0\0\0\0\0\0\x07\x02\0\
+\0\xfc\xff\xff\xff\x18\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85\0\0\0\x01\0\0\0\x15\
+\0\xef\xff\0\0\0\0\x79\x01\0\0\0\0\0\0\x15\x01\xed\xff\0\0\0\0\x79\x02\x10\0\0\
+\0\0\0\x7b\x2a\x70\xff\0\0\0\0\x7b\x1a\x88\xff\0\0\0\0\x79\x81\0\0\0\0\0\0\x7b\
+\x1a\x80\xff\0\0\0\0\x79\x01\x08\0\0\0\0\0\x7b\x1a\x68\xff\0\0\0\0\x79\x81\xf8\
+\xff\0\0\0\0\x7b\x1a\x78\xff\0\0\0\0\x79\x86\xf0\xff\0\0\0\0\xbf\xa2\0\0\0\0\0\
+\0\x07\x02\0\0\xfc\xff\xff\xff\x18\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85\0\0\0\
+\x01\0\0\0\x79\xa1\x88\xff\0\0\0\0\x15\0\xdc\xff\0\0\0\0\x79\xa2\x80\xff\0\0\0\
+\0\x79\xa3\x70\xff\0\0\0\0\x1f\x32\0\0\0\0\0\0\x79\xa3\x78\xff\0\0\0\0\x79\xa4\
+\x68\xff\0\0\0\0\x1f\x43\0\0\0\0\0\0\x1f\x16\0\0\0\0\0\0\x79\x01\0\0\0\0\0\0\
+\x0f\x16\0\0\0\0\0\0\x7b\x60\0\0\0\0\0\0\x79\x01\x08\0\0\0\0\0\x0f\x31\0\0\0\0\
+\0\0\x7b\x10\x08\0\0\0\0\0\x79\x01\x10\0\0\0\0\0\x0f\x21\0\0\0\0\0\0\x7b\x10\
+\x10\0\0\0\0\0\x3d\x32\xcb\xff\0\0\0\0\xbf\xa2\0\0\0\0\0\0\x07\x02\0\0\xfc\xff\
+\xff\xff\x18\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85\0\0\0\x01\0\0\0\x15\0\xc5\xff\
+\0\0\0\0\x79\x01\0\0\0\0\0\0\x07\x01\0\0\x01\0\0\0\x7b\x10\0\0\0\0\0\0\x05\0\
+\xc1\xff\0\0\0\0\0\0\0\0\0\0\0\0\x47\x50\x4c\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x63\x6c\x61\x6e\
+\x67\x20\x76\x65\x72\x73\x69\x6f\x6e\x20\x31\x31\x2e\x30\x2e\x30\x20\x28\x68\
+\x74\x74\x70\x73\x3a\x2f\x2f\x67\x69\x74\x68\x75\x62\x2e\x63\x6f\x6d\x2f\x6c\
+\x6c\x76\x6d\x2f\x6c\x6c\x76\x6d\x2d\x70\x72\x6f\x6a\x65\x63\x74\x2e\x67\x69\
+\x74\x20\x61\x61\x62\x63\x33\x63\x35\x39\x65\x31\x33\x31\x61\x61\x30\x39\x63\
+\x37\x35\x35\x64\x38\x31\x66\x63\x31\x37\x31\x36\x64\x31\x64\x34\x38\x33\x33\
+\x64\x35\x32\x63\x29\0\x73\x6b\x65\x6c\x65\x74\x6f\x6e\x2f\x70\x72\x6f\x66\x69\
+\x6c\x65\x72\x2e\x62\x70\x66\x2e\x63\0\x2f\x68\x6f\x6d\x65\x2f\x73\x6f\x6e\x67\
+\x6c\x69\x75\x62\x72\x61\x76\x69\x6e\x67\x2f\x6c\x6f\x63\x61\x6c\x2f\x6b\x65\
+\x72\x6e\x65\x6c\x2f\x6c\x69\x6e\x75\x78\x2d\x67\x69\x74\x2f\x74\x6f\x6f\x6c\
+\x73\x2f\x62\x70\x66\x2f\x62\x70\x66\x74\x6f\x6f\x6c\0\x6e\x75\x6d\x5f\x63\x70\
+\x75\0\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x69\x6e\x74\0\x5f\x5f\x75\x33\x32\0\
+\x6e\x75\x6d\x5f\x6d\x65\x74\x72\x69\x63\0\x4c\x49\x43\x45\x4e\x53\x45\0\x63\
+\x68\x61\x72\0\x5f\x5f\x41\x52\x52\x41\x59\x5f\x53\x49\x5a\x45\x5f\x54\x59\x50\
+\x45\x5f\x5f\0\x65\x76\x65\x6e\x74\x73\0\x74\x79\x70\x65\0\x69\x6e\x74\0\x6b\
+\x65\x79\x5f\x73\x69\x7a\x65\0\x76\x61\x6c\x75\x65\x5f\x73\x69\x7a\x65\0\x66\
+\x65\x6e\x74\x72\x79\x5f\x72\x65\x61\x64\x69\x6e\x67\x73\0\x61\x63\x63\x75\x6d\
+\x5f\x72\x65\x61\x64\x69\x6e\x67\x73\0\x63\x6f\x75\x6e\x74\x73\0\x6d\x69\x73\
+\x73\x5f\x63\x6f\x75\x6e\x74\x73\0\x62\x70\x66\x5f\x67\x65\x74\x5f\x73\x6d\x70\
+\x5f\x70\x72\x6f\x63\x65\x73\x73\x6f\x72\x5f\x69\x64\0\x62\x70\x66\x5f\x6d\x61\
+\x70\x5f\x6c\x6f\x6f\x6b\x75\x70\x5f\x65\x6c\x65\x6d\0\x62\x70\x66\x5f\x70\x65\
+\x72\x66\x5f\x65\x76\x65\x6e\x74\x5f\x72\x65\x61\x64\x5f\x76\x61\x6c\x75\x65\0\
+\x6c\x6f\x6e\x67\x20\x6c\x6f\x6e\x67\x20\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\
+\x69\x6e\x74\0\x5f\x5f\x75\x36\x34\0\x63\x6f\x75\x6e\x74\x65\x72\0\x65\x6e\x61\
+\x62\x6c\x65\x64\0\x72\x75\x6e\x6e\x69\x6e\x67\0\x62\x70\x66\x5f\x70\x65\x72\
+\x66\x5f\x65\x76\x65\x6e\x74\x5f\x76\x61\x6c\x75\x65\0\x5f\x5f\x5f\x5f\x66\x65\
+\x6e\x74\x72\x79\x5f\x58\x58\x58\0\x63\x74\x78\0\x70\x74\x72\x73\0\x69\0\x75\
+\x33\x32\0\x6b\x65\x79\0\x66\x6c\x61\x67\0\x72\x65\x61\x64\x69\x6e\x67\0\x65\
+\x72\x72\0\x5f\x5f\x5f\x5f\x66\x65\x78\x69\x74\x5f\x58\x58\x58\0\x72\x65\x61\
+\x64\x69\x6e\x67\x73\0\x6f\x6e\x65\0\x63\x70\x75\0\x7a\x65\x72\x6f\0\x63\x6f\
+\x75\x6e\x74\0\x75\x36\x34\0\x66\x65\x78\x69\x74\x5f\x75\x70\x64\x61\x74\x65\
+\x5f\x6d\x61\x70\x73\0\x69\x64\0\x61\x66\x74\x65\x72\0\x62\x65\x66\x6f\x72\x65\
+\0\x64\x69\x66\x66\0\x61\x63\x63\x75\x6d\0\x6d\x69\x73\x73\x5f\x63\x6f\x75\x6e\
+\x74\0\x66\x65\x6e\x74\x72\x79\x5f\x58\x58\x58\0\x66\x65\x78\x69\x74\x5f\x58\
+\x58\x58\0\xff\xff\xff\xff\xff\xff\xff\xff\0\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\
+\x50\0\0\0\0\0\0\0\x02\0\x30\x9f\x50\0\0\0\0\0\0\0\x88\0\0\0\0\0\0\0\x01\0\x57\
+\xb0\0\0\0\0\0\0\0\xd0\0\0\0\0\0\0\0\x01\0\x57\xd0\0\0\0\0\0\0\0\x20\x01\0\0\0\
+\0\0\0\x02\0\x30\x9f\x20\x01\0\0\0\0\0\0\x70\x01\0\0\0\0\0\0\x01\0\x57\x80\x01\
+\0\0\0\0\0\0\xa8\x01\0\0\0\0\0\0\x01\0\x57\xb8\x01\0\0\0\0\0\0\x20\x02\0\0\0\0\
+\0\0\x01\0\x57\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xff\xff\xff\xff\xff\xff\xff\xff\
+\0\0\0\0\0\0\0\0\xd0\0\0\0\0\0\0\0\x70\x01\0\0\0\0\0\0\x01\0\x56\x78\x01\0\0\0\
+\0\0\0\xa0\x01\0\0\0\0\0\0\x01\0\x56\xb8\x01\0\0\0\0\0\0\x20\x02\0\0\0\0\0\0\
+\x01\0\x56\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xff\xff\xff\xff\xff\xff\xff\xff\0\0\
+\0\0\0\0\0\0\x50\0\0\0\0\0\0\0\x58\0\0\0\0\0\0\0\x01\0\x57\x58\0\0\0\0\0\0\0\
+\x90\0\0\0\0\0\0\0\x02\0\x7a\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xff\xff\xff\xff\
+\xff\xff\xff\xff\0\0\0\0\0\0\0\0\0\x02\0\0\0\0\0\0\x08\x02\0\0\0\0\0\0\x01\0\
+\x50\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xff\xff\xff\xff\xff\xff\xff\xff\0\0\0\0\0\
+\0\0\0\x10\0\0\0\0\0\0\0\xf0\x01\0\0\0\0\0\0\x02\0\x31\x9f\0\x02\0\0\0\0\0\0\
+\xa8\x03\0\0\0\0\0\0\x02\0\x31\x9f\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xff\xff\xff\
+\xff\xff\xff\xff\xff\0\0\0\0\0\0\0\0\x18\0\0\0\0\0\0\0\x20\x01\0\0\0\0\0\0\x02\
+\0\x30\x9f\x20\x01\0\0\0\0\0\0\xf0\x01\0\0\0\0\0\0\x02\0\x7a\x2c\0\x02\0\0\0\0\
+\0\0\xa8\x03\0\0\0\0\0\0\x02\0\x7a\x2c\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xff\xff\
+\xff\xff\xff\xff\xff\xff\0\0\0\0\0\0\0\0\x20\0\0\0\0\0\0\0\x60\0\0\0\0\0\0\0\
+\x02\0\x30\x9f\x60\0\0\0\0\0\0\0\x88\0\0\0\0\0\0\0\x01\0\x59\xa0\0\0\0\0\0\0\0\
+\0\x01\0\0\0\0\0\0\x01\0\x59\x68\x01\0\0\0\0\0\0\xb0\x01\0\0\0\0\0\0\x02\0\x30\
+\x9f\xb0\x01\0\0\0\0\0\0\xc8\x01\0\0\0\0\0\0\x01\0\x59\xd0\x01\0\0\0\0\0\0\xf0\
+\x01\0\0\0\0\0\0\x01\0\x59\0\x02\0\0\0\0\0\0\xa8\x03\0\0\0\0\0\0\x01\0\x59\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xff\xff\xff\xff\xff\xff\xff\xff\0\0\0\0\0\0\0\0\0\
+\x01\0\0\0\0\0\0\x08\x01\0\0\0\0\0\0\x01\0\x50\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\xff\xff\xff\xff\xff\xff\xff\xff\0\0\0\0\0\0\0\0\x48\x01\0\0\0\0\0\0\xb0\x01\0\
+\0\0\0\0\0\x01\0\x50\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xff\xff\xff\xff\xff\xff\
+\xff\xff\0\0\0\0\0\0\0\0\0\x02\0\0\0\0\0\0\x08\x02\0\0\0\0\0\0\x01\0\x59\x08\
+\x02\0\0\0\0\0\0\xa8\x03\0\0\0\0\0\0\x03\0\x7a\x94\x01\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\xff\xff\xff\xff\xff\xff\xff\xff\0\0\0\0\0\0\0\0\x30\x02\0\0\0\0\0\0\
+\xc0\x02\0\0\0\0\0\0\x01\0\x50\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xff\xff\xff\xff\
+\xff\xff\xff\xff\0\0\0\0\0\0\0\0\xe8\x02\0\0\0\0\0\0\0\x03\0\0\0\0\0\0\x05\0\
+\x93\x10\x52\x93\x08\0\x03\0\0\0\0\0\0\x08\x03\0\0\0\0\0\0\x08\0\x93\x08\x53\
+\x93\x08\x52\x93\x08\x08\x03\0\0\0\0\0\0\x18\x03\0\0\0\0\0\0\x09\0\x56\x93\x08\
+\x53\x93\x08\x52\x93\x08\x18\x03\0\0\0\0\0\0\x60\x03\0\0\0\0\0\0\x08\0\x93\x08\
+\x53\x93\x08\x52\x93\x08\x60\x03\0\0\0\0\0\0\x80\x03\0\0\0\0\0\0\x05\0\x93\x08\
+\x53\x93\x08\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xff\xff\xff\xff\xff\xff\xff\xff\0\
+\0\0\0\0\0\0\0\xc8\x02\0\0\0\0\0\0\x80\x03\0\0\0\0\0\0\x01\0\x50\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\xff\xff\xff\xff\xff\xff\xff\xff\0\0\0\0\0\0\0\0\x80\x03\0\0\
+\0\0\0\0\xa8\x03\0\0\0\0\0\0\x01\0\x50\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\x11\
+\x01\x25\x0e\x13\x05\x03\x0e\x10\x17\x1b\x0e\x11\x01\x55\x17\0\0\x02\x34\0\x03\
+\x0e\x49\x13\x3f\x19\x3a\x0b\x3b\x0b\x02\x18\0\0\x03\x26\0\x49\x13\0\0\x04\x35\
+\0\x49\x13\0\0\x05\x16\0\x49\x13\x03\x0e\x3a\x0b\x3b\x0b\0\0\x06\x24\0\x03\x0e\
+\x3e\x0b\x0b\x0b\0\0\x07\x01\x01\x49\x13\0\0\x08\x21\0\x49\x13\x37\x0b\0\0\x09\
+\x24\0\x03\x0e\x0b\x0b\x3e\x0b\0\0\x0a\x13\x01\x0b\x0b\x3a\x0b\x3b\x0b\0\0\x0b\
+\x0d\0\x03\x0e\x49\x13\x3a\x0b\x3b\x0b\x38\x0b\0\0\x0c\x0f\0\x49\x13\0\0\x0d\
+\x34\0\x03\x0e\x49\x13\x3a\x0b\x3b\x0b\0\0\x0e\x15\0\x49\x13\x27\x19\0\0\x0f\
+\x15\x01\x49\x13\x27\x19\0\0\x10\x05\0\x49\x13\0\0\x11\x0f\0\0\0\x12\x26\0\0\0\
+\x13\x34\0\x03\x0e\x49\x13\x3a\x0b\x3b\x05\0\0\x14\x13\x01\x03\x0e\x0b\x0b\x3a\
+\x0b\x3b\x05\0\0\x15\x0d\0\x03\x0e\x49\x13\x3a\x0b\x3b\x05\x38\x0b\0\0\x16\x2e\
+\x01\x03\x0e\x3a\x0b\x3b\x0b\x27\x19\x49\x13\x20\x0b\0\0\x17\x05\0\x03\x0e\x3a\
+\x0b\x3b\x0b\x49\x13\0\0\x18\x34\0\x03\x0e\x3a\x0b\x3b\x0b\x49\x13\0\0\x19\x0b\
+\x01\0\0\x1a\x2e\x01\x11\x01\x12\x06\x40\x18\x97\x42\x19\x03\x0e\x3a\x0b\x3b\
+\x0b\x27\x19\x49\x13\x3f\x19\0\0\x1b\x1d\x01\x31\x13\x55\x17\x58\x0b\x59\x0b\
+\x57\x0b\0\0\x1c\x05\0\x31\x13\0\0\x1d\x34\0\x02\x18\x31\x13\0\0\x1e\x34\0\x02\
+\x17\x31\x13\0\0\x1f\x0b\x01\x55\x17\0\0\x20\x2e\x01\x03\x0e\x3a\x0b\x3b\x0b\
+\x27\x19\x20\x0b\0\0\x21\x34\0\x31\x13\0\0\x22\x1d\x01\x31\x13\x11\x01\x12\x06\
+\x58\x0b\x59\x0b\x57\x0b\0\0\x23\x05\0\x02\x17\x31\x13\0\0\x24\x0b\x01\x11\x01\
+\x12\x06\0\0\0\x7a\x05\0\0\x04\0\0\0\0\0\x08\x01\0\0\0\0\x0c\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\x02\0\0\0\0\x3f\0\0\0\x02\x5f\x09\x03\0\0\0\
+\0\0\0\0\0\x03\x44\0\0\0\x04\x49\0\0\0\x05\x54\0\0\0\0\0\0\0\x01\x1a\x06\0\0\0\
+\0\x07\x04\x02\0\0\0\0\x3f\0\0\0\x02\x60\x09\x03\0\0\0\0\0\0\0\0\x02\0\0\0\0\
+\x85\0\0\0\x02\xb9\x09\x03\0\0\0\0\0\0\0\0\x07\x91\0\0\0\x08\x98\0\0\0\x04\0\
+\x06\0\0\0\0\x06\x01\x09\0\0\0\0\x08\x07\x02\0\0\0\0\xb4\0\0\0\x02\x41\x09\x03\
+\0\0\0\0\0\0\0\0\x0a\x18\x02\x3d\x0b\0\0\0\0\xdd\0\0\0\x02\x3e\0\x0b\0\0\0\0\
+\xdd\0\0\0\x02\x3f\x08\x0b\0\0\0\0\xdd\0\0\0\x02\x40\x10\0\x0c\xe2\0\0\0\x07\
+\xee\0\0\0\x08\x98\0\0\0\x04\0\x06\0\0\0\0\x05\x04\x02\0\0\0\0\x0a\x01\0\0\x02\
+\x48\x09\x03\0\0\0\0\0\0\0\0\x0a\x18\x02\x44\x0b\0\0\0\0\x33\x01\0\0\x02\x45\0\
+\x0b\0\0\0\0\xdd\0\0\0\x02\x46\x08\x0b\0\0\0\0\x44\x01\0\0\x02\x47\x10\0\x0c\
+\x38\x01\0\0\x07\xee\0\0\0\x08\x98\0\0\0\x06\0\x0c\x49\x01\0\0\x07\xee\0\0\0\
+\x08\x98\0\0\0\x18\0\x02\0\0\0\0\x6a\x01\0\0\x02\x4f\x09\x03\0\0\0\0\0\0\0\0\
+\x0a\x18\x02\x4b\x0b\0\0\0\0\x33\x01\0\0\x02\x4c\0\x0b\0\0\0\0\xdd\0\0\0\x02\
+\x4d\x08\x0b\0\0\0\0\x44\x01\0\0\x02\x4e\x10\0\x02\0\0\0\0\xa8\x01\0\0\x02\x56\
+\x09\x03\0\0\0\0\0\0\0\0\x0a\x18\x02\x52\x0b\0\0\0\0\x33\x01\0\0\x02\x53\0\x0b\
+\0\0\0\0\xdd\0\0\0\x02\x54\x08\x0b\0\0\0\0\xd1\x01\0\0\x02\x55\x10\0\x0c\xd6\
+\x01\0\0\x07\xee\0\0\0\x08\x98\0\0\0\x08\0\x02\0\0\0\0\xf7\x01\0\0\x02\x5d\x09\
+\x03\0\0\0\0\0\0\0\0\x0a\x18\x02\x59\x0b\0\0\0\0\x33\x01\0\0\x02\x5a\0\x0b\0\0\
+\0\0\xdd\0\0\0\x02\x5b\x08\x0b\0\0\0\0\xd1\x01\0\0\x02\x5c\x10\0\x0d\0\0\0\0\
+\x2b\x02\0\0\x03\xb5\x0c\x30\x02\0\0\x0e\x49\0\0\0\x0d\0\0\0\0\x40\x02\0\0\x03\
+\x21\x0c\x45\x02\0\0\x0f\x55\x02\0\0\x10\x55\x02\0\0\x10\x56\x02\0\0\0\x11\x0c\
+\x5b\x02\0\0\x12\x13\0\0\0\0\x68\x02\0\0\x03\x63\x05\x0c\x6d\x02\0\0\x0f\xee\0\
+\0\0\x10\x55\x02\0\0\x10\x87\x02\0\0\x10\x99\x02\0\0\x10\x49\0\0\0\0\x05\x92\
+\x02\0\0\0\0\0\0\x01\x1e\x06\0\0\0\0\x07\x08\x0c\x9e\x02\0\0\x14\0\0\0\0\x18\
+\x04\xf2\x03\x15\0\0\0\0\x87\x02\0\0\x04\xf3\x03\0\x15\0\0\0\0\x87\x02\0\0\x04\
+\xf4\x03\x08\x15\0\0\0\0\x87\x02\0\0\x04\xf5\x03\x10\0\x16\0\0\0\0\x02\x64\xee\
+\0\0\0\x01\x17\0\0\0\0\x02\x64\x2d\x03\0\0\x18\0\0\0\0\x02\x66\x32\x03\0\0\x18\
+\0\0\0\0\x02\x68\x3e\x03\0\0\x18\0\0\0\0\x02\x67\x3e\x03\0\0\x19\x18\0\0\0\0\
+\x02\x6c\x3e\x03\0\0\0\x19\x18\0\0\0\0\x02\x74\x9e\x02\0\0\x18\0\0\0\0\x02\x75\
+\xee\0\0\0\0\0\x0c\x92\x02\0\0\x07\x99\x02\0\0\x08\x98\0\0\0\x04\0\x05\x49\x03\
+\0\0\0\0\0\0\x05\x15\x05\x54\0\0\0\0\0\0\0\x05\x0c\x1a\0\0\0\0\0\0\0\0\x20\x02\
+\0\0\x01\x5a\0\0\0\0\x02\x64\xee\0\0\0\x17\0\0\0\0\x02\x64\x2d\x03\0\0\x1b\xcf\
+\x02\0\0\0\0\0\0\x02\x64\x05\x1c\xdb\x02\0\0\x1d\x02\x91\x18\xe6\x02\0\0\x1e\0\
+\0\0\0\xf1\x02\0\0\x1e\xa7\0\0\0\xfc\x02\0\0\x1f\x30\0\0\0\x1e\0\x01\0\0\x08\
+\x03\0\0\0\x1f\x60\0\0\0\x1d\x02\x91\0\x15\x03\0\0\x1e\x47\x01\0\0\x20\x03\0\0\
+\0\0\0\x16\0\0\0\0\x02\xa1\xee\0\0\0\x01\x17\0\0\0\0\x02\xa1\x2d\x03\0\0\x18\0\
+\0\0\0\x02\xa3\x30\x04\0\0\x18\0\0\0\0\x02\xa5\x3e\x03\0\0\x18\0\0\0\0\x02\xa4\
+\x3e\x03\0\0\x18\0\0\0\0\x02\xa5\x3e\x03\0\0\x18\0\0\0\0\x02\xa5\x3e\x03\0\0\
+\x18\0\0\0\0\x02\xa6\xee\0\0\0\x18\0\0\0\0\x02\xa7\x3c\x04\0\0\0\x07\x9e\x02\0\
+\0\x08\x98\0\0\0\x04\0\x0c\x41\x04\0\0\x05\x4c\x04\0\0\0\0\0\0\x05\x17\x05\x92\
+\x02\0\0\0\0\0\0\x05\x0e\x20\0\0\0\0\x02\x83\x01\x17\0\0\0\0\x02\x83\x3e\x03\0\
+\0\x17\0\0\0\0\x02\x83\x99\x02\0\0\x18\0\0\0\0\x02\x85\x99\x02\0\0\x18\0\0\0\0\
+\x02\x85\x9e\x02\0\0\x18\0\0\0\0\x02\x85\x99\x02\0\0\x19\x18\0\0\0\0\x02\x8a\
+\x99\x02\0\0\x19\x18\0\0\0\0\x02\x96\x3c\x04\0\0\0\0\0\x1a\0\0\0\0\0\0\0\0\xa8\
+\x03\0\0\x01\x5a\0\0\0\0\x02\xa1\xee\0\0\0\x17\0\0\0\0\x02\xa1\x2d\x03\0\0\x1b\
+\xcb\x03\0\0\xa0\0\0\0\x02\xa1\x05\x1c\xd7\x03\0\0\x1d\x02\x91\x30\xe2\x03\0\0\
+\x1e\x7a\x01\0\0\xed\x03\0\0\x21\xf8\x03\0\0\x1e\xc2\x01\0\0\x03\x04\0\0\x1e\
+\x1e\x02\0\0\x0e\x04\0\0\x1e\xc5\x02\0\0\x19\x04\0\0\x1e\xf8\x02\0\0\x24\x04\0\
+\0\x22\x57\x04\0\0\x18\x02\0\0\0\0\0\0\x90\x01\0\0\x02\xb4\x04\x23\x2b\x03\0\0\
+\x5f\x04\0\0\x1c\x6a\x04\0\0\x1e\x73\x03\0\0\x75\x04\0\0\x1e\xa6\x03\0\0\x80\
+\x04\0\0\x1f\xd0\0\0\0\x1e\x43\x04\0\0\x97\x04\0\0\x24\x68\x03\0\0\0\0\0\0\x40\
+\0\0\0\x1e\x76\x04\0\0\xa3\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xa8\x01\0\0\0\0\
+\0\0\xb8\x01\0\0\0\0\0\0\x18\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\x50\0\0\0\0\0\0\0\x60\0\0\0\0\0\0\0\x68\0\0\0\0\0\0\0\x90\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\x20\x01\0\0\0\0\0\0\x70\x01\0\0\0\0\0\0\xb8\x01\0\0\
+\0\0\0\0\xd8\x01\0\0\0\0\0\0\xe0\x01\0\0\0\0\0\0\x18\x02\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xf0\x01\0\0\0\0\0\0\x10\x02\0\0\0\0\0\0\
+\xa8\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x48\x02\0\0\0\0\0\0\x58\
+\x03\0\0\0\0\0\0\x68\x03\0\0\0\0\0\0\xa8\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\x20\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xa8\x03\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x9f\xeb\x01\0\x18\0\0\0\0\0\0\0\x5c\x03\0\
+\0\x5c\x03\0\0\xc8\x05\0\0\0\0\0\0\x03\0\0\x04\x18\0\0\0\x01\0\0\0\x02\0\0\0\0\
+\0\0\0\x06\0\0\0\x02\0\0\0\x40\0\0\0\x0f\0\0\0\x02\0\0\0\x80\0\0\0\0\0\0\0\0\0\
+\0\x02\x04\0\0\0\x1a\0\0\0\0\0\0\x01\x04\0\0\0\x20\0\0\x01\0\0\0\0\0\0\0\x03\0\
+\0\0\0\x03\0\0\0\x05\0\0\0\x04\0\0\0\x1e\0\0\0\0\0\0\x01\x04\0\0\0\x20\0\0\0\
+\x32\0\0\0\0\0\0\x0e\x01\0\0\0\x01\0\0\0\0\0\0\0\x03\0\0\x04\x18\0\0\0\x01\0\0\
+\0\x08\0\0\0\0\0\0\0\x06\0\0\0\x02\0\0\0\x40\0\0\0\x0f\0\0\0\x0a\0\0\0\x80\0\0\
+\0\0\0\0\0\0\0\0\x02\x09\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x03\0\0\0\x05\0\0\0\
+\x06\0\0\0\0\0\0\0\0\0\0\x02\x0b\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x03\0\0\0\x05\
+\0\0\0\x18\0\0\0\x39\0\0\0\0\0\0\x0e\x07\0\0\0\x01\0\0\0\0\0\0\0\x03\0\0\x04\
+\x18\0\0\0\x01\0\0\0\x08\0\0\0\0\0\0\0\x06\0\0\0\x02\0\0\0\x40\0\0\0\x0f\0\0\0\
+\x0a\0\0\0\x80\0\0\0\x49\0\0\0\0\0\0\x0e\x0d\0\0\0\x01\0\0\0\0\0\0\0\x03\0\0\
+\x04\x18\0\0\0\x01\0\0\0\x08\0\0\0\0\0\0\0\x06\0\0\0\x02\0\0\0\x40\0\0\0\x0f\0\
+\0\0\x10\0\0\0\x80\0\0\0\0\0\0\0\0\0\0\x02\x11\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\
+\x03\0\0\0\x05\0\0\0\x08\0\0\0\x58\0\0\0\0\0\0\x0e\x0f\0\0\0\x01\0\0\0\0\0\0\0\
+\x03\0\0\x04\x18\0\0\0\x01\0\0\0\x08\0\0\0\0\0\0\0\x06\0\0\0\x02\0\0\0\x40\0\0\
+\0\x0f\0\0\0\x10\0\0\0\x80\0\0\0\x5f\0\0\0\0\0\0\x0e\x13\0\0\0\x01\0\0\0\0\0\0\
+\0\0\0\0\x02\x16\0\0\0\x6b\0\0\0\0\0\0\x01\x08\0\0\0\x40\0\0\0\0\0\0\0\x01\0\0\
+\x0d\x03\0\0\0\x82\0\0\0\x15\0\0\0\x86\0\0\0\x01\0\0\x0c\x17\0\0\0\0\0\0\0\x01\
+\0\0\x0d\x03\0\0\0\x82\0\0\0\x15\0\0\0\x26\x02\0\0\x01\0\0\x0c\x19\0\0\0\0\0\0\
+\0\0\0\0\x0a\x1c\0\0\0\0\0\0\0\0\0\0\x09\x1d\0\0\0\x7f\x05\0\0\0\0\0\x08\x1e\0\
+\0\0\x85\x05\0\0\0\0\0\x01\x04\0\0\0\x20\0\0\0\x92\x05\0\0\0\0\0\x0e\x1b\0\0\0\
+\x01\0\0\0\x9a\x05\0\0\0\0\0\x0e\x1b\0\0\0\x01\0\0\0\xa5\x05\0\0\0\0\0\x01\x01\
+\0\0\0\x08\0\0\x01\0\0\0\0\0\0\0\x03\0\0\0\0\x21\0\0\0\x05\0\0\0\x04\0\0\0\xaa\
+\x05\0\0\0\0\0\x0e\x22\0\0\0\x01\0\0\0\xb2\x05\0\0\x05\0\0\x0f\0\0\0\0\x06\0\0\
+\0\0\0\0\0\x18\0\0\0\x0c\0\0\0\0\0\0\0\x18\0\0\0\x0e\0\0\0\0\0\0\0\x18\0\0\0\
+\x12\0\0\0\0\0\0\0\x18\0\0\0\x14\0\0\0\0\0\0\0\x18\0\0\0\xb8\x05\0\0\x02\0\0\
+\x0f\0\0\0\0\x1f\0\0\0\0\0\0\0\x04\0\0\0\x20\0\0\0\0\0\0\0\x04\0\0\0\xc0\x05\0\
+\0\x01\0\0\x0f\0\0\0\0\x23\0\0\0\0\0\0\0\x04\0\0\0\0\x74\x79\x70\x65\0\x6b\x65\
+\x79\x5f\x73\x69\x7a\x65\0\x76\x61\x6c\x75\x65\x5f\x73\x69\x7a\x65\0\x69\x6e\
+\x74\0\x5f\x5f\x41\x52\x52\x41\x59\x5f\x53\x49\x5a\x45\x5f\x54\x59\x50\x45\x5f\
+\x5f\0\x65\x76\x65\x6e\x74\x73\0\x66\x65\x6e\x74\x72\x79\x5f\x72\x65\x61\x64\
+\x69\x6e\x67\x73\0\x61\x63\x63\x75\x6d\x5f\x72\x65\x61\x64\x69\x6e\x67\x73\0\
+\x63\x6f\x75\x6e\x74\x73\0\x6d\x69\x73\x73\x5f\x63\x6f\x75\x6e\x74\x73\0\x6c\
+\x6f\x6e\x67\x20\x6c\x6f\x6e\x67\x20\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x69\
+\x6e\x74\0\x63\x74\x78\0\x66\x65\x6e\x74\x72\x79\x5f\x58\x58\x58\0\x66\x65\x6e\
+\x74\x72\x79\x2f\x58\x58\x58\0\x2f\x68\x6f\x6d\x65\x2f\x73\x6f\x6e\x67\x6c\x69\
+\x75\x62\x72\x61\x76\x69\x6e\x67\x2f\x6c\x6f\x63\x61\x6c\x2f\x6b\x65\x72\x6e\
+\x65\x6c\x2f\x6c\x69\x6e\x75\x78\x2d\x67\x69\x74\x2f\x74\x6f\x6f\x6c\x73\x2f\
+\x62\x70\x66\x2f\x62\x70\x66\x74\x6f\x6f\x6c\x2f\x73\x6b\x65\x6c\x65\x74\x6f\
+\x6e\x2f\x70\x72\x6f\x66\x69\x6c\x65\x72\x2e\x62\x70\x66\x2e\x63\0\x09\x75\x33\
+\x32\x20\x6b\x65\x79\x20\x3d\x20\x62\x70\x66\x5f\x67\x65\x74\x5f\x73\x6d\x70\
+\x5f\x70\x72\x6f\x63\x65\x73\x73\x6f\x72\x5f\x69\x64\x28\x29\x3b\0\x09\x66\x6f\
+\x72\x20\x28\x69\x20\x3d\x20\x30\x3b\x20\x69\x20\x3c\x20\x6e\x75\x6d\x5f\x6d\
+\x65\x74\x72\x69\x63\x20\x26\x26\x20\x69\x20\x3c\x20\x4d\x41\x58\x5f\x4e\x55\
+\x4d\x5f\x4d\x41\x54\x52\x49\x43\x53\x3b\x20\x69\x2b\x2b\x29\x20\x7b\0\x09\x09\
+\x75\x33\x32\x20\x66\x6c\x61\x67\x20\x3d\x20\x69\x3b\0\x09\x09\x70\x74\x72\x73\
+\x5b\x69\x5d\x20\x3d\x20\x62\x70\x66\x5f\x6d\x61\x70\x5f\x6c\x6f\x6f\x6b\x75\
+\x70\x5f\x65\x6c\x65\x6d\x28\x26\x66\x65\x6e\x74\x72\x79\x5f\x72\x65\x61\x64\
+\x69\x6e\x67\x73\x2c\x20\x26\x66\x6c\x61\x67\x29\x3b\0\x09\x09\x2a\x28\x70\x74\
+\x72\x73\x5b\x69\x5d\x29\x20\x3d\x20\x72\x65\x61\x64\x69\x6e\x67\x3b\0\x09\x09\
+\x6b\x65\x79\x20\x2b\x3d\x20\x6e\x75\x6d\x5f\x63\x70\x75\x3b\0\x69\x6e\x74\x20\
+\x42\x50\x46\x5f\x50\x52\x4f\x47\x28\x66\x65\x6e\x74\x72\x79\x5f\x58\x58\x58\
+\x29\0\x09\x09\x65\x72\x72\x20\x3d\x20\x62\x70\x66\x5f\x70\x65\x72\x66\x5f\x65\
+\x76\x65\x6e\x74\x5f\x72\x65\x61\x64\x5f\x76\x61\x6c\x75\x65\x28\x26\x65\x76\
+\x65\x6e\x74\x73\x2c\x20\x6b\x65\x79\x2c\x20\x26\x72\x65\x61\x64\x69\x6e\x67\
+\x2c\0\x09\x09\x69\x66\x20\x28\x65\x72\x72\x29\0\x66\x65\x78\x69\x74\x5f\x58\
+\x58\x58\0\x66\x65\x78\x69\x74\x2f\x58\x58\x58\0\x09\x75\x33\x32\x20\x63\x70\
+\x75\x20\x3d\x20\x62\x70\x66\x5f\x67\x65\x74\x5f\x73\x6d\x70\x5f\x70\x72\x6f\
+\x63\x65\x73\x73\x6f\x72\x5f\x69\x64\x28\x29\x3b\0\x09\x75\x33\x32\x20\x69\x2c\
+\x20\x6f\x6e\x65\x20\x3d\x20\x31\x2c\x20\x7a\x65\x72\x6f\x20\x3d\x20\x30\x3b\0\
+\x09\x09\x65\x72\x72\x20\x3d\x20\x62\x70\x66\x5f\x70\x65\x72\x66\x5f\x65\x76\
+\x65\x6e\x74\x5f\x72\x65\x61\x64\x5f\x76\x61\x6c\x75\x65\x28\x26\x65\x76\x65\
+\x6e\x74\x73\x2c\x20\x63\x70\x75\x20\x2b\x20\x69\x20\x2a\x20\x6e\x75\x6d\x5f\
+\x63\x70\x75\x2c\0\x09\x63\x6f\x75\x6e\x74\x20\x3d\x20\x62\x70\x66\x5f\x6d\x61\
+\x70\x5f\x6c\x6f\x6f\x6b\x75\x70\x5f\x65\x6c\x65\x6d\x28\x26\x63\x6f\x75\x6e\
+\x74\x73\x2c\x20\x26\x7a\x65\x72\x6f\x29\x3b\0\x09\x69\x66\x20\x28\x63\x6f\x75\
+\x6e\x74\x29\x20\x7b\0\x09\x09\x2a\x63\x6f\x75\x6e\x74\x20\x2b\x3d\x20\x31\x3b\
+\0\x09\x09\x66\x6f\x72\x20\x28\x69\x20\x3d\x20\x30\x3b\x20\x69\x20\x3c\x20\x6e\
+\x75\x6d\x5f\x6d\x65\x74\x72\x69\x63\x20\x26\x26\x20\x69\x20\x3c\x20\x4d\x41\
+\x58\x5f\x4e\x55\x4d\x5f\x4d\x41\x54\x52\x49\x43\x53\x3b\x20\x69\x2b\x2b\x29\0\
+\x69\x6e\x74\x20\x42\x50\x46\x5f\x50\x52\x4f\x47\x28\x66\x65\x78\x69\x74\x5f\
+\x58\x58\x58\x29\0\x09\x62\x65\x66\x6f\x72\x65\x20\x3d\x20\x62\x70\x66\x5f\x6d\
+\x61\x70\x5f\x6c\x6f\x6f\x6b\x75\x70\x5f\x65\x6c\x65\x6d\x28\x26\x66\x65\x6e\
+\x74\x72\x79\x5f\x72\x65\x61\x64\x69\x6e\x67\x73\x2c\x20\x26\x69\x64\x29\x3b\0\
+\x09\x69\x66\x20\x28\x62\x65\x66\x6f\x72\x65\x20\x26\x26\x20\x62\x65\x66\x6f\
+\x72\x65\x2d\x3e\x63\x6f\x75\x6e\x74\x65\x72\x29\x20\x7b\0\x09\x09\x64\x69\x66\
+\x66\x2e\x72\x75\x6e\x6e\x69\x6e\x67\x20\x3d\x20\x61\x66\x74\x65\x72\x2d\x3e\
+\x72\x75\x6e\x6e\x69\x6e\x67\x20\x2d\x20\x62\x65\x66\x6f\x72\x65\x2d\x3e\x72\
+\x75\x6e\x6e\x69\x6e\x67\x3b\0\x09\x09\x64\x69\x66\x66\x2e\x65\x6e\x61\x62\x6c\
+\x65\x64\x20\x3d\x20\x61\x66\x74\x65\x72\x2d\x3e\x65\x6e\x61\x62\x6c\x65\x64\
+\x20\x2d\x20\x62\x65\x66\x6f\x72\x65\x2d\x3e\x65\x6e\x61\x62\x6c\x65\x64\x3b\0\
+\x09\x09\x64\x69\x66\x66\x2e\x63\x6f\x75\x6e\x74\x65\x72\x20\x3d\x20\x61\x66\
+\x74\x65\x72\x2d\x3e\x63\x6f\x75\x6e\x74\x65\x72\x20\x2d\x20\x62\x65\x66\x6f\
+\x72\x65\x2d\x3e\x63\x6f\x75\x6e\x74\x65\x72\x3b\0\x09\x09\x61\x63\x63\x75\x6d\
+\x20\x3d\x20\x62\x70\x66\x5f\x6d\x61\x70\x5f\x6c\x6f\x6f\x6b\x75\x70\x5f\x65\
+\x6c\x65\x6d\x28\x26\x61\x63\x63\x75\x6d\x5f\x72\x65\x61\x64\x69\x6e\x67\x73\
+\x2c\x20\x26\x69\x64\x29\x3b\0\x09\x09\x69\x66\x20\x28\x61\x63\x63\x75\x6d\x29\
+\x20\x7b\0\x09\x09\x09\x61\x63\x63\x75\x6d\x2d\x3e\x63\x6f\x75\x6e\x74\x65\x72\
+\x20\x2b\x3d\x20\x64\x69\x66\x66\x2e\x63\x6f\x75\x6e\x74\x65\x72\x3b\0\x09\x09\
+\x09\x61\x63\x63\x75\x6d\x2d\x3e\x65\x6e\x61\x62\x6c\x65\x64\x20\x2b\x3d\x20\
+\x64\x69\x66\x66\x2e\x65\x6e\x61\x62\x6c\x65\x64\x3b\0\x09\x09\x09\x61\x63\x63\
+\x75\x6d\x2d\x3e\x72\x75\x6e\x6e\x69\x6e\x67\x20\x2b\x3d\x20\x64\x69\x66\x66\
+\x2e\x72\x75\x6e\x6e\x69\x6e\x67\x3b\0\x09\x09\x09\x69\x66\x20\x28\x64\x69\x66\
+\x66\x2e\x65\x6e\x61\x62\x6c\x65\x64\x20\x3e\x20\x64\x69\x66\x66\x2e\x72\x75\
+\x6e\x6e\x69\x6e\x67\x29\x20\x7b\0\x09\x09\x09\x09\x6d\x69\x73\x73\x5f\x63\x6f\
+\x75\x6e\x74\x20\x3d\x20\x62\x70\x66\x5f\x6d\x61\x70\x5f\x6c\x6f\x6f\x6b\x75\
+\x70\x5f\x65\x6c\x65\x6d\x28\x26\x6d\x69\x73\x73\x5f\x63\x6f\x75\x6e\x74\x73\
+\x2c\x20\x26\x69\x64\x29\x3b\0\x09\x09\x09\x09\x69\x66\x20\x28\x6d\x69\x73\x73\
+\x5f\x63\x6f\x75\x6e\x74\x29\0\x09\x09\x09\x09\x09\x2a\x6d\x69\x73\x73\x5f\x63\
+\x6f\x75\x6e\x74\x20\x2b\x3d\x20\x31\x3b\0\x5f\x5f\x75\x33\x32\0\x75\x6e\x73\
+\x69\x67\x6e\x65\x64\x20\x69\x6e\x74\0\x6e\x75\x6d\x5f\x63\x70\x75\0\x6e\x75\
+\x6d\x5f\x6d\x65\x74\x72\x69\x63\0\x63\x68\x61\x72\0\x4c\x49\x43\x45\x4e\x53\
+\x45\0\x2e\x6d\x61\x70\x73\0\x2e\x72\x6f\x64\x61\x74\x61\0\x6c\x69\x63\x65\x6e\
+\x73\x65\0\x9f\xeb\x01\0\x20\0\0\0\0\0\0\0\x24\0\0\0\x24\0\0\0\xb4\x04\0\0\xd8\
+\x04\0\0\0\0\0\0\x08\0\0\0\x91\0\0\0\x01\0\0\0\0\0\0\0\x18\0\0\0\x30\x02\0\0\
+\x01\0\0\0\0\0\0\0\x1a\0\0\0\x10\0\0\0\x91\0\0\0\x1a\0\0\0\0\0\0\0\x9c\0\0\0\
+\xf2\0\0\0\x0c\x9c\x01\0\x10\0\0\0\x9c\0\0\0\x19\x01\0\0\x12\xac\x01\0\x28\0\0\
+\0\x9c\0\0\0\x19\x01\0\0\x02\xac\x01\0\x50\0\0\0\x9c\0\0\0\x54\x01\0\0\x07\xb0\
+\x01\0\x60\0\0\0\x9c\0\0\0\0\0\0\0\0\0\0\0\x68\0\0\0\x9c\0\0\0\x64\x01\0\0\x0d\
+\xb8\x01\0\x80\0\0\0\x9c\0\0\0\x64\x01\0\0\x0b\xb8\x01\0\x90\0\0\0\x9c\0\0\0\
+\x19\x01\0\0\x12\xac\x01\0\xa8\0\0\0\x9c\0\0\0\x19\x01\0\0\x02\xac\x01\0\xb0\0\
+\0\0\x9c\0\0\0\0\0\0\0\0\0\0\0\xb8\0\0\0\x9c\0\0\0\x19\x01\0\0\x02\xac\x01\0\
+\xd0\0\0\0\x9c\0\0\0\x19\x01\0\0\x12\xcc\x01\0\xe8\0\0\0\x9c\0\0\0\x19\x01\0\0\
+\x02\xcc\x01\0\0\x01\0\0\x9c\0\0\0\0\0\0\0\0\0\0\0\x20\x01\0\0\x9c\0\0\0\x9e\
+\x01\0\0\x05\xec\x01\0\x28\x01\0\0\x9c\0\0\0\x9e\x01\0\0\x10\xec\x01\0\x58\x01\
+\0\0\x9c\0\0\0\xb6\x01\0\0\x0a\xf0\x01\0\x70\x01\0\0\x9c\0\0\0\x19\x01\0\0\x12\
+\xcc\x01\0\x78\x01\0\0\x9c\0\0\0\x19\x01\0\0\x02\xcc\x01\0\x80\x01\0\0\x9c\0\0\
+\0\0\0\0\0\0\0\0\0\xa0\x01\0\0\x9c\0\0\0\x19\x01\0\0\x02\xcc\x01\0\xa8\x01\0\0\
+\x9c\0\0\0\xc8\x01\0\0\x05\x90\x01\0\xb8\x01\0\0\x9c\0\0\0\xe1\x01\0\0\x2c\xdc\
+\x01\0\xd8\x01\0\0\x9c\0\0\0\0\0\0\0\0\0\0\0\xe0\x01\0\0\x9c\0\0\0\xe1\x01\0\0\
+\x09\xdc\x01\0\x10\x02\0\0\x9c\0\0\0\x1b\x02\0\0\x07\xe4\x01\0\x30\x02\0\0\x30\
+\0\0\0\0\0\0\0\x9c\0\0\0\x3a\x02\0\0\x0c\x90\x02\0\x18\0\0\0\x9c\0\0\0\x61\x02\
+\0\0\x12\x94\x02\0\x20\0\0\0\x9c\0\0\0\x19\x01\0\0\x12\xa8\x02\0\x38\0\0\0\x9c\
+\0\0\0\x19\x01\0\0\x02\xa8\x02\0\x60\0\0\0\x9c\0\0\0\x19\x01\0\0\x12\xa8\x02\0\
+\x78\0\0\0\x9c\0\0\0\x19\x01\0\0\x02\xa8\x02\0\x80\0\0\0\x9c\0\0\0\0\0\0\0\0\0\
+\0\0\x88\0\0\0\x9c\0\0\0\x19\x01\0\0\x02\xa8\x02\0\xa0\0\0\0\x9c\0\0\0\x7c\x02\
+\0\0\x36\xac\x02\0\xb8\0\0\0\x9c\0\0\0\x7c\x02\0\0\x34\xac\x02\0\xc0\0\0\0\x9c\
+\0\0\0\x7c\x02\0\0\x30\xac\x02\0\xc8\0\0\0\x9c\0\0\0\x7c\x02\0\0\x2c\xac\x02\0\
+\xd8\0\0\0\x9c\0\0\0\x7c\x02\0\0\x09\xac\x02\0\x10\x01\0\0\x9c\0\0\0\x1b\x02\0\
+\0\x07\xb4\x02\0\x28\x01\0\0\x9c\0\0\0\0\0\0\0\0\0\0\0\x30\x01\0\0\x9c\0\0\0\
+\xba\x02\0\0\x0a\xc0\x02\0\x48\x01\0\0\x9c\0\0\0\xe8\x02\0\0\x06\xc4\x02\0\x50\
+\x01\0\0\x9c\0\0\0\xf6\x02\0\0\x0a\xc8\x02\0\x68\x01\0\0\x9c\0\0\0\x05\x03\0\0\
+\x13\xcc\x02\0\x80\x01\0\0\x9c\0\0\0\x05\x03\0\0\x03\xcc\x02\0\xb0\x01\0\0\x9c\
+\0\0\0\x05\x03\0\0\x13\xcc\x02\0\xc8\x01\0\0\x9c\0\0\0\x05\x03\0\0\x03\xcc\x02\
+\0\xd0\x01\0\0\x9c\0\0\0\0\0\0\0\0\0\0\0\xe8\x01\0\0\x9c\0\0\0\x05\x03\0\0\x03\
+\xcc\x02\0\xf0\x01\0\0\x9c\0\0\0\x3f\x03\0\0\x05\x84\x02\0\x10\x02\0\0\x9c\0\0\
+\0\0\0\0\0\0\0\0\0\x18\x02\0\0\x9c\0\0\0\x57\x03\0\0\x0b\x1c\x02\0\x30\x02\0\0\
+\x9c\0\0\0\x8d\x03\0\0\x0d\x24\x02\0\x38\x02\0\0\x9c\0\0\0\x8d\x03\0\0\x18\x24\
+\x02\0\x40\x02\0\0\x9c\0\0\0\x8d\x03\0\0\x06\x24\x02\0\x48\x02\0\0\x9c\0\0\0\
+\xaf\x03\0\0\x2b\x38\x02\0\x60\x02\0\0\x9c\0\0\0\xaf\x03\0\0\x19\x38\x02\0\x68\
+\x02\0\0\x9c\0\0\0\xe2\x03\0\0\x2b\x34\x02\0\x78\x02\0\0\x9c\0\0\0\xe2\x03\0\0\
+\x19\x34\x02\0\x88\x02\0\0\x9c\0\0\0\x15\x04\0\0\x19\x30\x02\0\xa0\x02\0\0\x9c\
+\0\0\0\xaf\x03\0\0\x2b\x38\x02\0\xa8\x02\0\0\x9c\0\0\0\x48\x04\0\0\x0b\x40\x02\
+\0\xc8\x02\0\0\x9c\0\0\0\x7d\x04\0\0\x07\x44\x02\0\xd8\x02\0\0\x9c\0\0\0\0\0\0\
+\0\0\0\0\0\0\x03\0\0\x9c\0\0\0\x15\x04\0\0\x21\x30\x02\0\x08\x03\0\0\x9c\0\0\0\
+\x8c\x04\0\0\x13\x48\x02\0\x20\x03\0\0\x9c\0\0\0\xaf\x04\0\0\x13\x4c\x02\0\x38\
+\x03\0\0\x9c\0\0\0\xd2\x04\0\0\x13\x50\x02\0\x50\x03\0\0\x9c\0\0\0\xf5\x04\0\0\
+\x08\x54\x02\0\x60\x03\0\0\x9c\0\0\0\0\0\0\0\0\0\0\0\x68\x03\0\0\x9c\0\0\0\x1b\
+\x05\0\0\x12\x60\x02\0\x80\x03\0\0\x9c\0\0\0\x54\x05\0\0\x09\x64\x02\0\x88\x03\
+\0\0\x9c\0\0\0\x68\x05\0\0\x12\x68\x02\0\x0c\0\0\0\xff\xff\xff\xff\x04\0\x08\0\
+\x08\x7c\x0b\0\x14\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x20\x02\0\0\0\0\0\0\x14\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\xa8\x03\0\0\0\0\0\0\x71\x02\0\0\x04\0\xcf\0\0\0\x08\
+\x01\x01\xfb\x0e\x0d\0\x01\x01\x01\x01\0\0\0\x01\0\0\x01\x2f\x75\x73\x72\x2f\
+\x69\x6e\x63\x6c\x75\x64\x65\x2f\x61\x73\x6d\x2d\x67\x65\x6e\x65\x72\x69\x63\0\
+\x73\x6b\x65\x6c\x65\x74\x6f\x6e\0\x2f\x64\x61\x74\x61\x2f\x75\x73\x65\x72\x73\
+\x2f\x73\x6f\x6e\x67\x6c\x69\x75\x62\x72\x61\x76\x69\x6e\x67\x2f\x6b\x65\x72\
+\x6e\x65\x6c\x2f\x6c\x69\x6e\x75\x78\x2d\x67\x69\x74\x2f\x74\x6f\x6f\x6c\x73\
+\x2f\x6c\x69\x62\x2f\x62\x70\x66\0\x2f\x75\x73\x72\x2f\x69\x6e\x63\x6c\x75\x64\
+\x65\x2f\x6c\x69\x6e\x75\x78\0\0\x69\x6e\x74\x2d\x6c\x6c\x36\x34\x2e\x68\0\x01\
+\0\0\x70\x72\x6f\x66\x69\x6c\x65\x72\x2e\x62\x70\x66\x2e\x63\0\x02\0\0\x62\x70\
+\x66\x5f\x68\x65\x6c\x70\x65\x72\x5f\x64\x65\x66\x73\x2e\x68\0\x03\0\0\x62\x70\
+\x66\x2e\x68\0\x04\0\0\x70\x72\x6f\x66\x69\x6c\x65\x72\x2e\x68\0\x02\0\0\0\x04\
+\x02\0\x09\x02\0\0\0\0\0\0\0\0\x03\xe3\0\x01\x05\x0c\x0a\x15\x05\x12\x32\x05\
+\x02\x06\x3c\x03\x95\x7f\x20\x03\xeb\0\x20\x05\x07\x06\x3d\x06\x03\x94\x7f\x20\
+\x05\x0d\x06\x03\xee\0\x2e\x05\x0b\x06\x3c\x03\x92\x7f\x20\x05\x12\x06\x03\xeb\
+\0\x20\x05\x02\x06\x3c\x05\0\x03\x95\x7f\x20\x05\x02\x03\xeb\0\x20\x05\x12\x06\
+\x44\x05\x02\x06\x3c\x03\x8d\x7f\x20\x05\x05\x06\x03\xfb\0\x66\x05\x10\x06\x20\
+\x05\x0a\x06\x67\x05\x12\x03\x77\x3c\x05\x02\x06\x20\x05\0\x03\x8d\x7f\x20\x05\
+\x02\x03\xf3\0\x4a\x05\x05\x06\x03\x71\x20\x05\x2c\x03\x13\x2e\x05\0\x06\x03\
+\x89\x7f\x4a\x05\x09\x03\xf7\0\x20\x05\x07\x06\x68\x06\x03\x87\x7f\x20\x02\x01\
+\0\x01\x01\x04\x02\0\x09\x02\0\0\0\0\0\0\0\0\x03\xa0\x01\x01\x05\x0c\x0a\x15\
+\x06\x03\xdc\x7e\x2e\x05\x12\x06\x03\xa5\x01\x20\x25\x05\x02\x06\x3c\x03\xd6\
+\x7e\x20\x03\xaa\x01\x20\x05\x12\x3c\x05\x02\x3c\x05\0\x03\xd6\x7e\x20\x05\x02\
+\x03\xaa\x01\x20\x05\x36\x06\x3d\x05\x34\x06\x3c\x05\x30\x20\x05\x2c\x20\x05\
+\x09\x2e\x05\x07\x06\x76\x06\x03\xd3\x7e\x2e\x05\x0a\x06\x03\xb0\x01\x2e\x05\
+\x06\x3d\x05\x0a\x21\x05\x13\x3d\x05\x03\x06\x3c\x03\xcd\x7e\x20\x03\xb3\x01\
+\x20\x05\x13\x4a\x05\x03\x3c\x05\0\x03\xcd\x7e\x20\x05\x03\x03\xb3\x01\x3c\x05\
+\x05\x06\x03\x6e\x20\x06\x03\xdf\x7e\x2e\x05\x0b\x06\x03\x87\x01\x3c\x05\x0d\
+\x3e\x05\x18\x06\x20\x05\x06\x20\x05\x2b\x06\x25\x05\x19\x06\x3c\x05\x2b\x06\
+\x1f\x05\x19\x06\x2e\x06\x2d\x05\x2b\x3e\x05\x0b\x22\x06\x03\xf0\x7e\x3c\x05\
+\x07\x06\x03\x91\x01\x20\x06\x03\xef\x7e\x20\x05\x21\x06\x03\x8c\x01\x66\x05\
+\x13\x26\x3d\x3d\x05\x08\x3d\x06\x03\xeb\x7e\x20\x05\x12\x06\x03\x98\x01\x2e\
+\x05\x09\x3d\x05\x12\x21\x02\x04\0\x01\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\xe0\0\0\0\x04\0\xf1\xff\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\x0a\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x69\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x81\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\x0a\0\xbf\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\xc7\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\xd4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\x0a\0\xda\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\xe5\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\xed\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\x0a\0\xf2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x06\x01\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x0d\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\x0a\0\x12\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x16\x01\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x1f\x01\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\x0a\0\x2a\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\
+\x3a\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x49\x01\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x50\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\x0a\0\x5c\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x75\x01\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x89\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\x0a\0\xa3\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\xba\x01\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\xc0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\x0a\0\xc8\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\xd0\
+\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\xd8\x01\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\x0a\0\xed\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\
+\0\xfc\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\0\x02\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x05\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\x0a\0\x07\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x0b\x02\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x0f\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\x0a\0\x14\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x1c\x02\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x20\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\x0a\0\x2e\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x37\
+\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x3b\x02\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\x0a\0\x3f\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\
+\0\x44\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x4a\x02\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x4e\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\x0a\0\x60\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x63\x02\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x69\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\x0a\0\x70\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x75\x02\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x7b\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\x0a\0\x86\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0a\0\x91\
+\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x92\x01\0\0\0\0\x03\0\xa8\x01\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\x8b\x01\0\0\0\0\x03\0\x50\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x6e\x01\0\
+\0\0\0\x03\0\xd0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x58\x01\0\0\0\0\x03\0\xb8\x01\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\x4a\x01\0\0\0\0\x03\0\x20\x01\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\x7c\x01\0\0\0\0\x05\0\xb0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x5f\x01\0\0\0\
+\0\x05\0\xf0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x84\x01\0\0\0\0\x05\0\x60\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\x75\x01\0\0\0\0\x05\0\xa0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\x67\x01\0\0\0\0\x05\0\x20\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x51\x01\0\0\0\0\x05\
+\0\0\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\x03\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\x03\0\x05\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\
+\x0b\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\x0d\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\x03\0\x10\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\
+\x16\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\x18\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\x42\x01\0\0\x11\0\x08\0\0\0\0\0\0\0\0\0\x04\0\0\0\0\0\0\0\x53\0\0\
+\0\x11\0\x09\0\x30\0\0\0\0\0\0\0\x18\0\0\0\0\0\0\0\x2f\0\0\0\x11\0\x09\0\x48\0\
+\0\0\0\0\0\0\x18\0\0\0\0\0\0\0\x36\0\0\0\x11\0\x09\0\0\0\0\0\0\0\0\0\x18\0\0\0\
+\0\0\0\0\x07\x01\0\0\x12\0\x03\0\0\0\0\0\0\0\0\0\x20\x02\0\0\0\0\0\0\x43\0\0\0\
+\x11\0\x09\0\x18\0\0\0\0\0\0\0\x18\0\0\0\0\0\0\0\x12\x01\0\0\x12\0\x05\0\0\0\0\
+\0\0\0\0\0\xa8\x03\0\0\0\0\0\0\x2a\0\0\0\x11\0\x09\0\x60\0\0\0\0\0\0\0\x18\0\0\
+\0\0\0\0\0\x0f\0\0\0\x11\0\x07\0\0\0\0\0\0\0\0\0\x04\0\0\0\0\0\0\0\xd5\0\0\0\
+\x11\0\x07\0\x04\0\0\0\0\0\0\0\x04\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x01\0\0\0\
+\x52\0\0\0\x68\0\0\0\0\0\0\0\x01\0\0\0\x4e\0\0\0\x90\0\0\0\0\0\0\0\x01\0\0\0\
+\x52\0\0\0\xd0\0\0\0\0\0\0\0\x01\0\0\0\x52\0\0\0\x08\x01\0\0\0\0\0\0\x01\0\0\0\
+\x52\0\0\0\x58\x01\0\0\0\0\0\0\x01\0\0\0\x51\0\0\0\xe0\x01\0\0\0\0\0\0\x01\0\0\
+\0\x4c\0\0\0\x20\0\0\0\0\0\0\0\x01\0\0\0\x52\0\0\0\x60\0\0\0\0\0\0\0\x01\0\0\0\
+\x52\0\0\0\xa0\0\0\0\0\0\0\0\x01\0\0\0\x51\0\0\0\xd8\0\0\0\0\0\0\0\x01\0\0\0\
+\x4c\0\0\0\x30\x01\0\0\0\0\0\0\x01\0\0\0\x4b\0\0\0\x68\x01\0\0\0\0\0\0\x01\0\0\
+\0\x52\0\0\0\xb0\x01\0\0\0\0\0\0\x01\0\0\0\x52\0\0\0\x18\x02\0\0\0\0\0\0\x01\0\
+\0\0\x4e\0\0\0\xa8\x02\0\0\0\0\0\0\x01\0\0\0\x4a\0\0\0\x68\x03\0\0\0\0\0\0\x01\
+\0\0\0\x50\0\0\0\x08\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\xaf\0\0\0\0\0\0\0\x01\0\
+\0\0\x42\0\0\0\x08\x01\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\x4f\x01\0\0\0\0\0\0\x01\
+\0\0\0\x42\0\0\0\x82\x01\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\xca\x01\0\0\0\0\0\0\
+\x01\0\0\0\x43\0\0\0\x26\x02\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\xcd\x02\0\0\0\0\0\
+\0\x01\0\0\0\x43\0\0\0\0\x03\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\x33\x03\0\0\0\0\0\
+\0\x01\0\0\0\x43\0\0\0\x7b\x03\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\xae\x03\0\0\0\0\
+\0\0\x01\0\0\0\x43\0\0\0\x4b\x04\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\x7e\x04\0\0\0\
+\0\0\0\x01\0\0\0\x43\0\0\0\x06\0\0\0\0\0\0\0\x0a\0\0\0\x45\0\0\0\x0c\0\0\0\0\0\
+\0\0\x0a\0\0\0\x02\0\0\0\x12\0\0\0\0\0\0\0\x0a\0\0\0\x03\0\0\0\x16\0\0\0\0\0\0\
+\0\x0a\0\0\0\x48\0\0\0\x1a\0\0\0\0\0\0\0\x0a\0\0\0\x04\0\0\0\x26\0\0\0\0\0\0\0\
+\x0a\0\0\0\x46\0\0\0\x2b\0\0\0\0\0\0\0\x0a\0\0\0\x05\0\0\0\x37\0\0\0\0\0\0\0\
+\x01\0\0\0\x51\0\0\0\x4e\0\0\0\0\0\0\0\x0a\0\0\0\x07\0\0\0\x55\0\0\0\0\0\0\0\
+\x0a\0\0\0\x06\0\0\0\x5c\0\0\0\0\0\0\0\x0a\0\0\0\x08\0\0\0\x68\0\0\0\0\0\0\0\
+\x01\0\0\0\x52\0\0\0\x71\0\0\0\0\0\0\0\x0a\0\0\0\x09\0\0\0\x7d\0\0\0\0\0\0\0\
+\x01\0\0\0\x49\0\0\0\x92\0\0\0\0\0\0\0\x0a\0\0\0\x0a\0\0\0\x99\0\0\0\0\0\0\0\
+\x0a\0\0\0\x0b\0\0\0\xa0\0\0\0\0\0\0\0\x0a\0\0\0\x0c\0\0\0\xac\0\0\0\0\0\0\0\
+\x01\0\0\0\x4c\0\0\0\xb9\0\0\0\0\0\0\0\x0a\0\0\0\x0d\0\0\0\xc5\0\0\0\0\0\0\0\
+\x0a\0\0\0\x0f\0\0\0\xd1\0\0\0\0\0\0\0\x0a\0\0\0\x10\0\0\0\xef\0\0\0\0\0\0\0\
+\x0a\0\0\0\x0e\0\0\0\xf6\0\0\0\0\0\0\0\x0a\0\0\0\x11\0\0\0\x02\x01\0\0\0\0\0\0\
+\x01\0\0\0\x4e\0\0\0\x0f\x01\0\0\0\0\0\0\x0a\0\0\0\x0d\0\0\0\x1b\x01\0\0\0\0\0\
+\0\x0a\0\0\0\x0f\0\0\0\x27\x01\0\0\0\0\0\0\x0a\0\0\0\x10\0\0\0\x56\x01\0\0\0\0\
+\0\0\x0a\0\0\0\x12\0\0\0\x62\x01\0\0\0\0\0\0\x01\0\0\0\x4a\0\0\0\x6f\x01\0\0\0\
+\0\0\0\x0a\0\0\0\x0d\0\0\0\x7b\x01\0\0\0\0\0\0\x0a\0\0\0\x0f\0\0\0\x87\x01\0\0\
+\0\0\0\0\x0a\0\0\0\x10\0\0\0\x94\x01\0\0\0\0\0\0\x0a\0\0\0\x13\0\0\0\xa0\x01\0\
+\0\0\0\0\0\x01\0\0\0\x4b\0\0\0\xad\x01\0\0\0\0\0\0\x0a\0\0\0\x0d\0\0\0\xb9\x01\
+\0\0\0\0\0\0\x0a\0\0\0\x0f\0\0\0\xc5\x01\0\0\0\0\0\0\x0a\0\0\0\x10\0\0\0\xe3\
+\x01\0\0\0\0\0\0\x0a\0\0\0\x14\0\0\0\xef\x01\0\0\0\0\0\0\x01\0\0\0\x50\0\0\0\
+\xfc\x01\0\0\0\0\0\0\x0a\0\0\0\x0d\0\0\0\x08\x02\0\0\0\0\0\0\x0a\0\0\0\x0f\0\0\
+\0\x14\x02\0\0\0\0\0\0\x0a\0\0\0\x10\0\0\0\x21\x02\0\0\0\0\0\0\x0a\0\0\0\x15\0\
+\0\0\x36\x02\0\0\0\0\0\0\x0a\0\0\0\x16\0\0\0\x5d\x02\0\0\0\0\0\0\x0a\0\0\0\x17\
+\0\0\0\x8c\x02\0\0\0\0\0\0\x0a\0\0\0\x19\0\0\0\x93\x02\0\0\0\0\0\0\x0a\0\0\0\
+\x18\0\0\0\x9f\x02\0\0\0\0\0\0\x0a\0\0\0\x1d\0\0\0\xa8\x02\0\0\0\0\0\0\x0a\0\0\
+\0\x1a\0\0\0\xb5\x02\0\0\0\0\0\0\x0a\0\0\0\x1b\0\0\0\xc2\x02\0\0\0\0\0\0\x0a\0\
+\0\0\x1c\0\0\0\xd0\x02\0\0\0\0\0\0\x0a\0\0\0\x1e\0\0\0\xdc\x02\0\0\0\0\0\0\x0a\
+\0\0\0\x1f\0\0\0\xe7\x02\0\0\0\0\0\0\x0a\0\0\0\x20\0\0\0\xf2\x02\0\0\0\0\0\0\
+\x0a\0\0\0\x21\0\0\0\xfd\x02\0\0\0\0\0\0\x0a\0\0\0\x23\0\0\0\x09\x03\0\0\0\0\0\
+\0\x0a\0\0\0\x24\0\0\0\x16\x03\0\0\0\0\0\0\x0a\0\0\0\x25\0\0\0\x21\x03\0\0\0\0\
+\0\0\x0a\0\0\0\x26\0\0\0\x43\x03\0\0\0\0\0\0\x0a\0\0\0\x22\0\0\0\x4e\x03\0\0\0\
+\0\0\0\x0a\0\0\0\x07\0\0\0\x55\x03\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\x63\x03\0\0\
+\0\0\0\0\x0a\0\0\0\x35\0\0\0\x6e\x03\0\0\0\0\0\0\x0a\0\0\0\x1f\0\0\0\x7d\x03\0\
+\0\0\0\0\0\x0a\0\0\0\x46\0\0\0\x92\x03\0\0\0\0\0\0\x0a\0\0\0\x44\0\0\0\x9b\x03\
+\0\0\0\0\0\0\x0a\0\0\0\x44\0\0\0\xa4\x03\0\0\0\0\0\0\x0a\0\0\0\x46\0\0\0\xa9\
+\x03\0\0\0\0\0\0\x0a\0\0\0\x44\0\0\0\xb3\x03\0\0\0\0\0\0\x0a\0\0\0\x46\0\0\0\
+\xc0\x03\0\0\0\0\0\0\x0a\0\0\0\x44\0\0\0\xcc\x03\0\0\0\0\0\0\x0a\0\0\0\x27\0\0\
+\0\xd8\x03\0\0\0\0\0\0\x0a\0\0\0\x1f\0\0\0\xe3\x03\0\0\0\0\0\0\x0a\0\0\0\x28\0\
+\0\0\xee\x03\0\0\0\0\0\0\x0a\0\0\0\x29\0\0\0\xf9\x03\0\0\0\0\0\0\x0a\0\0\0\x2a\
+\0\0\0\x04\x04\0\0\0\0\0\0\x0a\0\0\0\x2b\0\0\0\x0f\x04\0\0\0\0\0\0\x0a\0\0\0\
+\x21\0\0\0\x1a\x04\0\0\0\0\0\0\x0a\0\0\0\x26\0\0\0\x25\x04\0\0\0\0\0\0\x0a\0\0\
+\0\x2c\0\0\0\x46\x04\0\0\0\0\0\0\x0a\0\0\0\x2d\0\0\0\x51\x04\0\0\0\0\0\0\x0a\0\
+\0\0\x19\0\0\0\x58\x04\0\0\0\0\0\0\x0a\0\0\0\x2e\0\0\0\x60\x04\0\0\0\0\0\0\x0a\
+\0\0\0\x2f\0\0\0\x6b\x04\0\0\0\0\0\0\x0a\0\0\0\x30\0\0\0\x76\x04\0\0\0\0\0\0\
+\x0a\0\0\0\x31\0\0\0\x81\x04\0\0\0\0\0\0\x0a\0\0\0\x32\0\0\0\x8c\x04\0\0\0\0\0\
+\0\x0a\0\0\0\x33\0\0\0\x98\x04\0\0\0\0\0\0\x0a\0\0\0\x33\0\0\0\xa4\x04\0\0\0\0\
+\0\0\x0a\0\0\0\x34\0\0\0\xb2\x04\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\xc0\x04\0\0\0\
+\0\0\0\x0a\0\0\0\x36\0\0\0\xcb\x04\0\0\0\0\0\0\x0a\0\0\0\x1f\0\0\0\xda\x04\0\0\
+\0\0\0\0\x0a\0\0\0\x46\0\0\0\xef\x04\0\0\0\0\0\0\x0a\0\0\0\x44\0\0\0\xfd\x04\0\
+\0\0\0\0\0\x0a\0\0\0\x44\0\0\0\x06\x05\0\0\0\0\0\0\x0a\0\0\0\x44\0\0\0\x0f\x05\
+\0\0\0\0\0\0\x0a\0\0\0\x44\0\0\0\x18\x05\0\0\0\0\0\0\x0a\0\0\0\x44\0\0\0\x25\
+\x05\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\x35\x05\0\0\0\0\0\0\x0a\0\0\0\x44\0\0\0\
+\x43\x05\0\0\0\0\0\0\x0a\0\0\0\x44\0\0\0\x4c\x05\0\0\0\0\0\0\x0a\0\0\0\x44\0\0\
+\0\x55\x05\0\0\0\0\0\0\x0a\0\0\0\x46\0\0\0\x5a\x05\0\0\0\0\0\0\x0a\0\0\0\x44\0\
+\0\0\x63\x05\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\x70\x05\0\0\0\0\0\0\x0a\0\0\0\x44\
+\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\x08\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\
+\0\x10\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\x18\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\
+\x30\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\x38\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\
+\x40\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\x48\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\
+\x60\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\x68\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\
+\x70\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\x78\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\
+\x80\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\x88\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\
+\xa0\0\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\xa8\0\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\
+\xb0\0\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\xb8\0\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\
+\xd0\0\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\xd8\0\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\
+\xe0\0\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\xe8\0\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\0\
+\x01\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\x08\x01\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\
+\x10\x01\0\0\0\0\0\0\x01\0\0\0\x43\0\0\0\x18\x01\0\0\0\0\0\0\x01\0\0\0\x43\0\0\
+\0\0\x03\0\0\0\0\0\0\0\0\0\0\x4c\0\0\0\x0c\x03\0\0\0\0\0\0\0\0\0\0\x4e\0\0\0\
+\x18\x03\0\0\0\0\0\0\0\0\0\0\x4a\0\0\0\x24\x03\0\0\0\0\0\0\0\0\0\0\x4b\0\0\0\
+\x30\x03\0\0\0\0\0\0\0\0\0\0\x50\0\0\0\x48\x03\0\0\0\0\0\0\x0a\0\0\0\x51\0\0\0\
+\x54\x03\0\0\0\0\0\0\x0a\0\0\0\x52\0\0\0\x6c\x03\0\0\0\0\0\0\0\0\0\0\x49\0\0\0\
+\x2c\0\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x3c\0\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x50\0\
+\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x60\0\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x70\0\0\0\0\
+\0\0\0\0\0\0\0\x42\0\0\0\x80\0\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x90\0\0\0\0\0\0\0\
+\0\0\0\0\x42\0\0\0\xa0\0\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\xb0\0\0\0\0\0\0\0\0\0\0\
+\0\x42\0\0\0\xc0\0\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\xd0\0\0\0\0\0\0\0\0\0\0\0\x42\
+\0\0\0\xe0\0\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\xf0\0\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\
+\0\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x10\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x20\
+\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x30\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x40\
+\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x50\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x60\
+\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x70\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x80\
+\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\x90\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\xa0\
+\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\xb0\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\xc0\
+\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\xd0\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\xe0\
+\x01\0\0\0\0\0\0\0\0\0\0\x42\0\0\0\xf8\x01\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x08\
+\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x18\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x28\
+\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x38\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x48\
+\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x58\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x68\
+\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x78\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x88\
+\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x98\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xa8\
+\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xb8\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xc8\
+\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xd8\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xe8\
+\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xf8\x02\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x08\
+\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x18\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x28\
+\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x38\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x48\
+\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x58\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x68\
+\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x78\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x88\
+\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x98\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xa8\
+\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xb8\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xc8\
+\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xd8\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xe8\
+\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xf8\x03\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x08\
+\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x18\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x28\
+\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x38\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x48\
+\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x58\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x68\
+\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x78\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x88\
+\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x98\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xa8\
+\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xb8\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xc8\
+\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xd8\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\xe8\
+\x04\0\0\0\0\0\0\0\0\0\0\x43\0\0\0\x14\0\0\0\0\0\0\0\x0a\0\0\0\x47\0\0\0\x18\0\
+\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\x2c\0\0\0\0\0\0\0\x0a\0\0\0\x47\0\0\0\x30\0\0\
+\0\0\0\0\0\x01\0\0\0\x43\0\0\0\xde\0\0\0\0\0\0\0\x01\0\0\0\x42\0\0\0\x87\x01\0\
+\0\0\0\0\0\x01\0\0\0\x43\0\0\0\x4d\x4f\x51\x52\x49\x4c\x4e\x4a\x4b\x50\0\x2e\
+\x64\x65\x62\x75\x67\x5f\x61\x62\x62\x72\x65\x76\0\x6e\x75\x6d\x5f\x63\x70\x75\
+\0\x2e\x74\x65\x78\x74\0\x2e\x72\x65\x6c\x2e\x42\x54\x46\x2e\x65\x78\x74\0\x6d\
+\x69\x73\x73\x5f\x63\x6f\x75\x6e\x74\x73\0\x65\x76\x65\x6e\x74\x73\0\x2e\x6d\
+\x61\x70\x73\0\x66\x65\x6e\x74\x72\x79\x5f\x72\x65\x61\x64\x69\x6e\x67\x73\0\
+\x61\x63\x63\x75\x6d\x5f\x72\x65\x61\x64\x69\x6e\x67\x73\0\x2e\x72\x65\x6c\x2e\
+\x64\x65\x62\x75\x67\x5f\x72\x61\x6e\x67\x65\x73\0\x2e\x64\x65\x62\x75\x67\x5f\
+\x73\x74\x72\0\x2e\x72\x65\x6c\x2e\x64\x65\x62\x75\x67\x5f\x69\x6e\x66\x6f\0\
+\x2e\x6c\x6c\x76\x6d\x5f\x61\x64\x64\x72\x73\x69\x67\0\x6c\x69\x63\x65\x6e\x73\
+\x65\0\x2e\x72\x65\x6c\x2e\x64\x65\x62\x75\x67\x5f\x6c\x69\x6e\x65\0\x2e\x72\
+\x65\x6c\x2e\x64\x65\x62\x75\x67\x5f\x66\x72\x61\x6d\x65\0\x2e\x72\x65\x6c\x2e\
+\x64\x65\x62\x75\x67\x5f\x6c\x6f\x63\0\x6e\x75\x6d\x5f\x6d\x65\x74\x72\x69\x63\
+\0\x70\x72\x6f\x66\x69\x6c\x65\x72\x2e\x62\x70\x66\x2e\x63\0\x2e\x73\x74\x72\
+\x74\x61\x62\0\x2e\x73\x79\x6d\x74\x61\x62\0\x2e\x72\x6f\x64\x61\x74\x61\0\x66\
+\x65\x6e\x74\x72\x79\x5f\x58\x58\x58\0\x66\x65\x78\x69\x74\x5f\x58\x58\x58\0\
+\x2e\x72\x65\x6c\x66\x65\x6e\x74\x72\x79\x2f\x58\x58\x58\0\x2e\x72\x65\x6c\x66\
+\x65\x78\x69\x74\x2f\x58\x58\x58\0\x2e\x72\x65\x6c\x2e\x42\x54\x46\0\x4c\x49\
+\x43\x45\x4e\x53\x45\0\x4c\x42\x42\x30\x5f\x39\0\x4c\x42\x42\x31\x5f\x38\0\x4c\
+\x42\x42\x30\x5f\x37\0\x4c\x42\x42\x31\x5f\x31\x36\0\x4c\x42\x42\x31\x5f\x35\0\
+\x4c\x42\x42\x30\x5f\x35\0\x4c\x42\x42\x31\x5f\x34\0\x4c\x42\x42\x31\x5f\x31\
+\x34\0\x4c\x42\x42\x31\x5f\x32\0\x4c\x42\x42\x30\x5f\x32\0\x4c\x42\x42\x30\x5f\
+\x31\x31\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xef\0\0\0\
+\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xb2\x3e\0\0\0\0\0\0\x9a\x01\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x17\0\0\0\x01\0\0\0\x06\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x40\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x20\x01\0\0\x01\0\0\0\x06\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\x40\0\0\0\0\0\0\0\x20\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x08\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\x1c\x01\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\xc8\x2e\0\0\0\0\0\0\x70\0\0\0\0\0\0\0\x1b\0\0\0\x03\0\0\0\x08\0\0\0\0\0\0\0\
+\x10\0\0\0\0\0\0\0\x2f\x01\0\0\x01\0\0\0\x06\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x60\
+\x02\0\0\0\0\0\0\xa8\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x08\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\x2b\x01\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x38\x2f\0\0\0\0\
+\0\0\xa0\0\0\0\0\0\0\0\x1b\0\0\0\x05\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\
+\xff\0\0\0\x01\0\0\0\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x08\x06\0\0\0\0\0\0\x08\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x9d\0\0\0\x01\
+\0\0\0\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x10\x06\0\0\0\0\0\0\x04\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x3d\0\0\0\x01\0\0\0\x03\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\x18\x06\0\0\0\0\0\0\x78\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\x08\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x74\0\0\0\x01\0\0\0\x30\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\x90\x06\0\0\0\0\0\0\x9b\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\
+\0\0\0\0\x01\0\0\0\0\0\0\0\xca\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\x2b\x09\0\0\0\0\0\0\xa9\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\xc6\0\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xd8\x2f\0\0\0\
+\0\0\0\xe0\0\0\0\0\0\0\0\x1b\0\0\0\x0b\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\
+\0\x01\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xd4\x0d\0\0\0\0\0\0\x92\
+\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x83\0\0\0\
+\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x66\x0f\0\0\0\0\0\0\x7e\x05\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x7f\0\0\0\x09\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xb8\x30\0\0\0\0\0\0\xb0\x06\0\0\0\0\0\0\x1b\0\0\0\
+\x0e\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x66\0\0\0\x01\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\xe4\x14\0\0\0\0\0\0\x30\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x62\0\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\x68\x37\0\0\0\0\0\0\xa0\x01\0\0\0\0\0\0\x1b\0\0\0\x10\0\0\0\x08\0\0\0\
+\0\0\0\0\x10\0\0\0\0\0\0\0\x3d\x01\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\x14\x16\0\0\0\0\0\0\x3c\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\x39\x01\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x08\x39\0\
+\0\0\0\0\0\x80\0\0\0\0\0\0\0\x1b\0\0\0\x12\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\
+\0\0\0\x21\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x50\x1f\0\0\0\0\0\0\
+\xf8\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x1d\0\0\
+\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x88\x39\0\0\0\0\0\0\xc0\x04\0\0\0\
+\0\0\0\x1b\0\0\0\x14\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\xb9\0\0\0\x01\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x48\x24\0\0\0\0\0\0\x40\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\x08\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xb5\0\0\0\x09\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\x48\x3e\0\0\0\0\0\0\x40\0\0\0\0\0\0\0\x1b\0\0\0\x16\0\0\0\
+\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\xa9\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\x88\x24\0\0\0\0\0\0\x75\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\xa5\0\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x88\
+\x3e\0\0\0\0\0\0\x20\0\0\0\0\0\0\0\x1b\0\0\0\x18\0\0\0\x08\0\0\0\0\0\0\0\x10\0\
+\0\0\0\0\0\0\x8f\0\0\0\x03\x4c\xff\x6f\0\0\0\x80\0\0\0\0\0\0\0\0\0\0\0\0\xa8\
+\x3e\0\0\0\0\0\0\x0a\0\0\0\0\0\0\0\x1b\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\xf7\0\0\0\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x27\0\0\0\0\0\0\
+\xc8\x07\0\0\0\0\0\0\x01\0\0\0\x49\0\0\0\x08\0\0\0\0\0\0\0\x18\0\0\0\0\0\0\0";
+
+	return 0;
+err:
+	bpf_object__destroy_skeleton(s);
+	return -1;
+}
+
+#endif /* __PROFILER_BPF_SKEL_H__ */
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index b352ab041160..faed6229935f 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -13,9 +13,12 @@
 #include <net/if.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <sys/syscall.h>
 
 #include <linux/err.h>
 #include <linux/sizes.h>
+#include <linux/perf_event.h>
 
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
@@ -24,6 +27,7 @@
 #include "cfg.h"
 #include "main.h"
 #include "xlated_dumper.h"
+#include "profiler.skel.h"
 
 enum dump_mode {
 	DUMP_JITED,
@@ -1537,6 +1541,384 @@ static int do_loadall(int argc, char **argv)
 	return load_with_options(argc, argv, false);
 }
 
+#define SAMPLE_PERIOD  0x7fffffffffffffffULL
+struct profile_metric {
+	const char *name;
+	struct perf_event_attr attr;
+	bool selected;
+	struct bpf_perf_event_value val;
+	u64 misses;
+} metrics[] = {
+	{
+		.name = "cycles",
+		.attr = {
+			.freq = 0,
+			.sample_period = SAMPLE_PERIOD,
+			.inherit = 0,
+			.type = PERF_TYPE_HARDWARE,
+			.read_format = 0,
+			.sample_type = 0,
+			.config = PERF_COUNT_HW_CPU_CYCLES,
+		},
+	},
+	{
+		.name = "instructions",
+		.attr = {
+			.freq = 0,
+			.sample_period = SAMPLE_PERIOD,
+			.inherit = 0,
+			.type = PERF_TYPE_HARDWARE,
+			.read_format = 0,
+			.sample_type = 0,
+			.config = PERF_COUNT_HW_INSTRUCTIONS,
+		},
+	},
+	{
+		.name = "l1d_loads",
+		.attr = {
+			.freq = 0,
+			.sample_period = SAMPLE_PERIOD,
+			.inherit = 0,
+			.type = PERF_TYPE_HW_CACHE,
+			.read_format = 0,
+			.sample_type = 0,
+			.config =
+				PERF_COUNT_HW_CACHE_L1D |
+				(PERF_COUNT_HW_CACHE_OP_READ << 8) |
+				(PERF_COUNT_HW_CACHE_RESULT_ACCESS << 16),
+		},
+	},
+	{
+		.name = "llc_misses",
+		.attr = {
+			.freq = 0,
+			.sample_period = SAMPLE_PERIOD,
+			.inherit = 0,
+			.type = PERF_TYPE_HW_CACHE,
+			.read_format = 0,
+			.sample_type = 0,
+			.config =
+				PERF_COUNT_HW_CACHE_LL |
+				(PERF_COUNT_HW_CACHE_OP_READ << 8) |
+				(PERF_COUNT_HW_CACHE_RESULT_MISS << 16),
+		},
+	},
+};
+u64 profile_total_count;
+
+#define MAX_NUM_PROFILE_METRICS 4
+
+static int profile_parse_metrics(int argc, char **argv)
+{
+	unsigned int metric_cnt;
+	int selected_cnt = 0;
+	unsigned int i;
+
+	metric_cnt = sizeof(metrics) / sizeof(struct profile_metric);
+
+	while (argc > 0) {
+		for (i = 0; i < metric_cnt; i++) {
+			if (strcmp(argv[0], metrics[i].name) == 0) {
+				if (!metrics[i].selected)
+					selected_cnt++;
+				metrics[i].selected = true;
+				break;
+			}
+		}
+		if (i == metric_cnt) {
+			p_err("unknown metric %s", argv[0]);
+			return -1;
+		}
+		NEXT_ARG();
+	}
+	if (selected_cnt > MAX_NUM_PROFILE_METRICS) {
+		p_err("too many (%d) metrics, please specify no more than %d metrics at at time",
+		      selected_cnt, MAX_NUM_PROFILE_METRICS);
+		return -1;
+	}
+	return selected_cnt;
+}
+
+static void profile_read_values(struct profiler_bpf *obj)
+{
+	u32 m, cpu, num_cpu = obj->rodata->num_cpu;
+	u64 counts[num_cpu];
+	int reading_map_fd, count_map_fd, miss_map_fd;
+	u32 key = 0;
+
+	reading_map_fd = bpf_map__fd(obj->maps.accum_readings);
+	count_map_fd = bpf_map__fd(obj->maps.counts);
+	miss_map_fd = bpf_map__fd(obj->maps.miss_counts);
+	if (reading_map_fd < 0 || count_map_fd < 0 || miss_map_fd < 0) {
+		p_err("failed to get fd for map");
+		return;
+	}
+
+	assert(bpf_map_lookup_elem(count_map_fd, &key, counts) == 0);
+	profile_total_count = 0;
+	for (cpu = 0; cpu < num_cpu; cpu++)
+		profile_total_count += counts[cpu];
+
+	for (m = 0; m < sizeof(metrics) / sizeof(metrics[0]); m++) {
+		struct bpf_perf_event_value values[obj->rodata->num_cpu];
+		u64 miss_counts[num_cpu];
+
+		if (!metrics[m].selected)
+			continue;
+
+		assert(bpf_map_lookup_elem(reading_map_fd, &key, values) == 0);
+		assert(bpf_map_lookup_elem(miss_map_fd, &key, miss_counts) == 0);
+		for (cpu = 0; cpu < num_cpu; cpu++) {
+			metrics[m].val.counter += values[cpu].counter;
+			metrics[m].val.enabled += values[cpu].enabled;
+			metrics[m].val.running += values[cpu].running;
+			metrics[m].misses += miss_counts[cpu];
+		}
+		key++;
+	}
+}
+
+static void profile_print_readings_json(unsigned long duration)
+{
+	u32 m;
+
+	jsonw_start_array(json_wtr);
+	for (m = 0; m < sizeof(metrics) / sizeof(metrics[0]); m++) {
+		if (!metrics[m].selected)
+			continue;
+		jsonw_start_object(json_wtr);
+		jsonw_lluint_field(json_wtr, "duration", duration);
+		jsonw_string_field(json_wtr, "metric", metrics[m].name);
+		jsonw_lluint_field(json_wtr, "run_cnt", profile_total_count);
+		jsonw_lluint_field(json_wtr, "miss_cnt", metrics[m].misses);
+		jsonw_lluint_field(json_wtr, "value", metrics[m].val.counter);
+		jsonw_lluint_field(json_wtr, "enabled", metrics[m].val.enabled);
+		jsonw_lluint_field(json_wtr, "running", metrics[m].val.running);
+
+		jsonw_end_object(json_wtr);
+	}
+	jsonw_end_array(json_wtr);
+}
+
+static void profile_print_readings_plain(unsigned long duration)
+{
+	u32 m;
+
+	for (m = 0; m < sizeof(metrics) / sizeof(metrics[0]); m++) {
+		if (!metrics[m].selected)
+			continue;
+		printf("%s: duration %lu run_cnt %lu miss_cnt %lu\n",
+		       metrics[m].name, duration, profile_total_count,
+		       metrics[m].misses);
+		printf("\tcounter %llu enabled %llu running %llu\n",
+		       metrics[m].val.counter, metrics[m].val.enabled,
+		       metrics[m].val.running);
+	}
+}
+
+static void profile_print_readings(unsigned long duration)
+{
+	if (json_output)
+		profile_print_readings_json(duration);
+	else
+		profile_print_readings_plain(duration);
+}
+
+static void profile_close_perf_events(struct profiler_bpf *obj)
+{
+	int map_fd, pmu_fd;
+	u32 i;
+
+	map_fd = bpf_map__fd(obj->maps.events);
+	if (map_fd < 0) {
+		p_err("failed to get fd for events map");
+		return;
+	}
+
+	for (i = 0; i < obj->rodata->num_cpu * obj->rodata->num_metric; i++) {
+		bpf_map_lookup_elem(map_fd, &i, &pmu_fd);
+		close(pmu_fd);
+	}
+}
+
+static int profile_open_perf_events(struct profiler_bpf *obj)
+{
+	int map_fd, pmu_fd, i, key = 0;
+	unsigned int cpu, m;
+
+	map_fd = bpf_map__fd(obj->maps.events);
+	if (map_fd < 0) {
+		p_err("failed to get fd for events map");
+		return -1;
+	}
+
+	for (m = 0; m < sizeof(metrics) / sizeof(metrics[0]); m++) {
+		if (!metrics[m].selected)
+			continue;
+		for (cpu = 0; cpu < obj->rodata->num_cpu; cpu++) {
+			pmu_fd = syscall(__NR_perf_event_open, &metrics[m].attr,
+					 -1/*pid*/, cpu, -1/*group_fd*/, 0);
+			if (pmu_fd < 0 ||
+			    bpf_map_update_elem(map_fd, &key, &pmu_fd, BPF_ANY) ||
+			    ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0)) {
+				p_err("failed to create event %s on cpu %d",
+				      metrics[m].name, cpu);
+				goto err;
+			}
+			key++;
+		}
+	}
+	return 0;
+err:
+	for (i = key - 1; i >= 0; i--) {
+		bpf_map_lookup_elem(map_fd, &i, &pmu_fd);
+		close(pmu_fd);
+	}
+	return -1;
+}
+
+static char *profile_target_name(int tgt_fd)
+{
+	struct bpf_prog_info_linear *info_linear;
+	struct bpf_func_info *func_info;
+	const struct btf_type *t;
+	char *name = NULL;
+	struct btf *btf;
+
+	info_linear = bpf_program__get_prog_info_linear(
+		tgt_fd, 1UL << BPF_PROG_INFO_FUNC_INFO);
+	if (IS_ERR_OR_NULL(info_linear)) {
+		p_err("failed to get info_linear for prog FD %d", tgt_fd);
+		return NULL;
+	}
+
+	if (info_linear->info.btf_id == 0 ||
+	    btf__get_from_id(info_linear->info.btf_id, &btf)) {
+		p_err("prog FD %d doesn't have valid btf", tgt_fd);
+		goto out;
+	}
+
+	func_info = (struct bpf_func_info *)(info_linear->info.func_info);
+	t = btf__type_by_id(btf, func_info[0].type_id);
+	if (!t) {
+		p_err("btf %d doesn't have type %d",
+		      info_linear->info.btf_id, func_info[0].type_id);
+		goto out;
+	}
+	name = strdup(btf__name_by_offset(btf, t->name_off));
+out:
+	free(info_linear);
+	return name;
+}
+
+static int do_profile(int argc, char **argv)
+{
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts);
+	int num_metric, num_cpu, tgt_fd, err = -1, i;
+	char *new_section_names[2] = {};
+	char *endptr, *tgt_name = NULL;
+	struct bpf_program *prog;
+	struct profiler_bpf *obj;
+	unsigned long duration;
+	u32 name_len;
+
+	/* we at least need: <duration>, "id", <id>, <metric> */
+	if (argc < 4)
+		usage();
+
+	/* parse profiling duration */
+	duration = strtoul(*argv, &endptr, 0);
+	if (*endptr) {
+		p_err("can't parse %s as duration", *argv);
+		return -1;
+	}
+	NEXT_ARG();
+
+	/* parse target fd */
+	tgt_fd = prog_parse_fd(&argc, &argv);
+	if (tgt_fd < 0) {
+		p_err("failed to parse fd");
+		return -1;
+	}
+	opts.attach_prog_fd = tgt_fd;
+
+	num_metric = profile_parse_metrics(argc, argv);
+	if (num_metric <= 0)
+		goto out;
+
+	num_cpu = libbpf_num_possible_cpus();
+	if (num_cpu <= 0) {
+		p_err("failed to identify number of CPUs");
+		goto out;
+	}
+
+	obj = profiler_bpf__open_opts(&opts);
+	if (!obj) {
+		p_err("failed to open and/or load BPF object");
+		goto out;
+	}
+
+	obj->rodata->num_cpu = num_cpu;
+	obj->rodata->num_metric = num_metric;
+
+	/* adjust map sizes */
+	bpf_map__resize(obj->maps.events, num_metric * num_cpu);
+	bpf_map__resize(obj->maps.fentry_readings, num_metric);
+	bpf_map__resize(obj->maps.accum_readings, num_metric);
+	bpf_map__resize(obj->maps.counts, 1);
+	bpf_map__resize(obj->maps.miss_counts, num_metric);
+
+	/* change target name */
+	tgt_name = profile_target_name(tgt_fd);
+	if (!tgt_name) {
+		p_err("failed to load target function name");
+		return -1;
+	}
+
+	name_len = strlen(tgt_name) + strlen("fentry/") + 1;
+	new_section_names[0] = malloc(name_len);
+	new_section_names[1] = malloc(name_len);
+	if (!new_section_names[0] || !new_section_names[1]) {
+		p_err("mem alloc failed");
+		goto out;
+	}
+	snprintf(new_section_names[0], name_len, "fentry/%s", tgt_name);
+	snprintf(new_section_names[1], name_len, "fexit/%s", tgt_name);
+	i = 0;
+	bpf_object__for_each_program(prog, obj->obj)
+		if (bpf_program__overwrite_section_name(
+			    prog, new_section_names[i++]) == NULL)
+			goto out;
+
+	set_max_rlimit();
+	err = profiler_bpf__load(obj);
+	if (err) {
+		p_err("failed to load obj");
+		goto out;
+	}
+
+	profile_open_perf_events(obj);
+
+	err = profiler_bpf__attach(obj);
+	if (err) {
+		p_err("failed to attach obj");
+		goto out;
+	}
+	sleep(duration);
+
+	profile_close_perf_events(obj);
+	profiler_bpf__detach(obj);
+	profile_read_values(obj);
+	profiler_bpf__destroy(obj);
+	profile_print_readings(duration);
+out:
+	close(tgt_fd);
+	free(tgt_name);
+	free(new_section_names[0]);
+	free(new_section_names[1]);
+	return err;
+}
+
 static int do_help(int argc, char **argv)
 {
 	if (json_output) {
@@ -1560,6 +1942,7 @@ static int do_help(int argc, char **argv)
 		"                         [data_out FILE [data_size_out L]] \\\n"
 		"                         [ctx_in FILE [ctx_out FILE [ctx_size_out M]]] \\\n"
 		"                         [repeat N]\n"
+		"       %s %s profile DURATION PROG METRICs\n"
 		"       %s %s tracelog\n"
 		"       %s %s help\n"
 		"\n"
@@ -1578,11 +1961,12 @@ static int do_help(int argc, char **argv)
 		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
 		"                        flow_dissector }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
+		"       METRIC := { cycles | instructions | l1d_loads | llc_misses }\n"
 		"",
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2]);
 
 	return 0;
 }
@@ -1599,6 +1983,7 @@ static const struct cmd cmds[] = {
 	{ "detach",	do_detach },
 	{ "tracelog",	do_tracelog },
 	{ "run",	do_run },
+	{ "profile",	do_profile },
 	{ 0 }
 };
 
diff --git a/tools/bpf/bpftool/skeleton/README b/tools/bpf/bpftool/skeleton/README
new file mode 100644
index 000000000000..ed6a1f3058c6
--- /dev/null
+++ b/tools/bpf/bpftool/skeleton/README
@@ -0,0 +1,3 @@
+To generate profiler.skel.h:
+1. clang -g -O2 -target bpf -I../../tools/lib -c profiler.bpf.c -o profiler.bpf.o
+2. bpftool gen skeleton profiler.bpf.o > ../profiler.skel.h
diff --git a/tools/bpf/bpftool/skeleton/profiler.bpf.c b/tools/bpf/bpftool/skeleton/profiler.bpf.c
new file mode 100644
index 000000000000..0328fac5ed78
--- /dev/null
+++ b/tools/bpf/bpftool/skeleton/profiler.bpf.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+#include "profiler.h"
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+#define ___bpf_concat(a, b) a ## b
+#define ___bpf_apply(fn, n) ___bpf_concat(fn, n)
+#define ___bpf_nth(_, _1, _2, _3, _4, _5, _6, _7, _8, _9, _a, _b, _c, N, ...) N
+#define ___bpf_narg(...) \
+	___bpf_nth(_, ##__VA_ARGS__, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
+#define ___bpf_empty(...) \
+	___bpf_nth(_, ##__VA_ARGS__, N, N, N, N, N, N, N, N, N, N, 0)
+
+#define ___bpf_ctx_cast0() ctx
+#define ___bpf_ctx_cast1(x) ___bpf_ctx_cast0(), (void *)ctx[0]
+#define ___bpf_ctx_cast2(x, args...) ___bpf_ctx_cast1(args), (void *)ctx[1]
+#define ___bpf_ctx_cast3(x, args...) ___bpf_ctx_cast2(args), (void *)ctx[2]
+#define ___bpf_ctx_cast4(x, args...) ___bpf_ctx_cast3(args), (void *)ctx[3]
+#define ___bpf_ctx_cast5(x, args...) ___bpf_ctx_cast4(args), (void *)ctx[4]
+#define ___bpf_ctx_cast6(x, args...) ___bpf_ctx_cast5(args), (void *)ctx[5]
+#define ___bpf_ctx_cast7(x, args...) ___bpf_ctx_cast6(args), (void *)ctx[6]
+#define ___bpf_ctx_cast8(x, args...) ___bpf_ctx_cast7(args), (void *)ctx[7]
+#define ___bpf_ctx_cast9(x, args...) ___bpf_ctx_cast8(args), (void *)ctx[8]
+#define ___bpf_ctx_cast10(x, args...) ___bpf_ctx_cast9(args), (void *)ctx[9]
+#define ___bpf_ctx_cast11(x, args...) ___bpf_ctx_cast10(args), (void *)ctx[10]
+#define ___bpf_ctx_cast12(x, args...) ___bpf_ctx_cast11(args), (void *)ctx[11]
+#define ___bpf_ctx_cast(args...) \
+	___bpf_apply(___bpf_ctx_cast, ___bpf_narg(args))(args)
+
+/*
+ * BPF_PROG is a convenience wrapper for generic tp_btf/fentry/fexit and
+ * similar kinds of BPF programs, that accept input arguments as a single
+ * pointer to untyped u64 array, where each u64 can actually be a typed
+ * pointer or integer of different size. Instead of requring user to write
+ * manual casts and work with array elements by index, BPF_PROG macro
+ * allows user to declare a list of named and typed input arguments in the
+ * same syntax as for normal C function. All the casting is hidden and
+ * performed transparently, while user code can just assume working with
+ * function arguments of specified type and name.
+ *
+ * Original raw context argument is preserved as well as 'ctx' argument.
+ * This is useful when using BPF helpers that expect original context
+ * as one of the parameters (e.g., for bpf_perf_event_output()).
+ */
+#define BPF_PROG(name, args...)						    \
+name(unsigned long long *ctx);						    \
+static __always_inline typeof(name(0))					    \
+____##name(unsigned long long *ctx, ##args);				    \
+typeof(name(0)) name(unsigned long long *ctx)				    \
+{									    \
+	_Pragma("GCC diagnostic push")					    \
+	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
+	return ____##name(___bpf_ctx_cast(args));			    \
+	_Pragma("GCC diagnostic pop")					    \
+}									    \
+static __always_inline typeof(name(0))					    \
+____##name(unsigned long long *ctx, ##args)
+
+/* map of perf event fds, num_cpu * num_metric entries */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(int));
+} events SEC(".maps");
+
+/* readings at fentry */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(struct bpf_perf_event_value));
+} fentry_readings SEC(".maps");
+
+/* accumulated readings */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(struct bpf_perf_event_value));
+} accum_readings SEC(".maps");
+
+/* sample counts, one per cpu */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(u64));
+} counts SEC(".maps");
+
+/* missed (perf event not active) counts, one per perf_event.  */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(u64));
+} miss_counts SEC(".maps");
+
+const volatile __u32 num_cpu = 0;
+const volatile __u32 num_metric = 0;
+#define MAX_NUM_MATRICS 4
+
+SEC("fentry/XXX")
+int BPF_PROG(fentry_XXX)
+{
+	struct bpf_perf_event_value *ptrs[MAX_NUM_MATRICS];
+	u32 key = bpf_get_smp_processor_id();
+	u32 i;
+
+	/* look up before reading, to reduce error */
+	for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
+		u32 flag = i;
+
+		ptrs[i] = bpf_map_lookup_elem(&fentry_readings, &flag);
+		if (!ptrs[i])
+			return 0;
+	}
+
+	for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
+		struct bpf_perf_event_value reading;
+		int err;
+
+		err = bpf_perf_event_read_value(&events, key, &reading,
+						sizeof(reading));
+		if (err)
+			return 0;
+		*(ptrs[i]) = reading;
+		key += num_cpu;
+	}
+
+	return 0;
+}
+
+static inline void
+fexit_update_maps(u32 id, struct bpf_perf_event_value *after)
+{
+	struct bpf_perf_event_value *before, diff, *accum;
+
+	before = bpf_map_lookup_elem(&fentry_readings, &id);
+	/* only account samples with a valid fentry_reading */
+	if (before && before->counter) {
+		struct bpf_perf_event_value *accum;
+
+		diff.counter = after->counter - before->counter;
+		diff.enabled = after->enabled - before->enabled;
+		diff.running = after->running - before->running;
+
+		accum = bpf_map_lookup_elem(&accum_readings, &id);
+		if (accum) {
+			accum->counter += diff.counter;
+			accum->enabled += diff.enabled;
+			accum->running += diff.running;
+			if (diff.enabled > diff.running) {
+				u64 *miss_count;
+
+				miss_count = bpf_map_lookup_elem(&miss_counts, &id);
+				if (miss_count)
+					*miss_count += 1;
+			}
+		}
+	}
+}
+
+SEC("fexit/XXX")
+int BPF_PROG(fexit_XXX)
+{
+	struct bpf_perf_event_value readings[MAX_NUM_MATRICS];
+	u32 cpu = bpf_get_smp_processor_id();
+	u32 i, one = 1, zero = 0;
+	int err;
+	u64 *count;
+
+	/* read all events before updating the maps, to reduce error */
+	for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
+		err = bpf_perf_event_read_value(&events, cpu + i * num_cpu,
+						readings + i, sizeof(*readings));
+		if (err)
+			return 0;
+	}
+	count = bpf_map_lookup_elem(&counts, &zero);
+	if (count) {
+		*count += 1;
+		for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++)
+			fexit_update_maps(i, &readings[i]);
+	}
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/bpf/bpftool/skeleton/profiler.h b/tools/bpf/bpftool/skeleton/profiler.h
new file mode 100644
index 000000000000..ae15cb0c4d43
--- /dev/null
+++ b/tools/bpf/bpftool/skeleton/profiler.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+#ifndef __PROFILER_H
+#define __PROFILER_H
+
+/* useful typedefs from vimlinux.h */
+
+typedef signed char __s8;
+typedef unsigned char __u8;
+typedef short int __s16;
+typedef short unsigned int __u16;
+typedef int __s32;
+typedef unsigned int __u32;
+typedef long long int __s64;
+typedef long long unsigned int __u64;
+
+typedef __s8 s8;
+typedef __u8 u8;
+typedef __s16 s16;
+typedef __u16 u16;
+typedef __s32 s32;
+typedef __u32 u32;
+typedef __s64 s64;
+typedef __u64 u64;
+
+enum {
+	false = 0,
+	true = 1,
+};
+
+#ifdef __CHECKER__
+#define __bitwise__ __attribute__((bitwise))
+#else
+#define __bitwise__
+#endif
+#define __bitwise __bitwise__
+
+typedef __u16 __bitwise __le16;
+typedef __u16 __bitwise __be16;
+typedef __u32 __bitwise __le32;
+typedef __u32 __bitwise __be32;
+typedef __u64 __bitwise __le64;
+typedef __u64 __bitwise __be64;
+
+typedef __u16 __bitwise __sum16;
+typedef __u32 __bitwise __wsum;
+
+#endif /* __PROFILER_H */
-- 
2.17.1

