Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F038D593BF
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 07:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfF1FxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 01:53:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19834 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726572AbfF1FxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 01:53:14 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5S5q53r009111
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 22:53:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=kcgVow+Japyl8OUCty1QMFRnOjHk+AjMfXWJmFW+drs=;
 b=AeF/PWdLyyMBj+ZsDEU9RjFxo/Q29kVVTof2iV56hxbCcpKGqk1o5HPPnNExg2P+Pro2
 9cuCtuS98wtEL0qxDlYqZgNmyREGInD1YMxTsNevUkAPmfbEIz1H9BUKpACxK8RiA+KU
 j5XS/DuCqNNFb6MRoBhdfrfgP2B1FsuZN8M= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2td1bvjd9w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 22:53:12 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 27 Jun 2019 22:53:10 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 7D9FA861468; Thu, 27 Jun 2019 22:53:09 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <sdf@fomichev.me>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 0/9] libbpf: add bpf_link and tracing attach APIs
Date:   Thu, 27 Jun 2019 22:52:54 -0700
Message-ID: <20190628055303.1249758-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds the following APIs to allow attaching BPF programs to
tracing entities:
- bpf_program__attach_perf_event for attaching to any opened perf event FD,
  allowing users full control;
- bpf_program__attach_kprobe for attaching to kernel probes (both entry and
  return probes);
- bpf_program__attach_uprobe for attaching to user probes (both entry/return);
- bpf_program__attach_tracepoint for attaching to kernel tracepoints;
- bpf_program__attach_raw_tracepoint for attaching to raw kernel tracepoint
  (wrapper around bpf_raw_tracepoint_open);

This set of APIs makes libbpf more useful for tracing applications.

All attach APIs return abstract struct bpf_link that encapsulates logic of
detaching BPF program. See patch #2 for details. bpf_assoc was considered as
an alternative name for this opaque "handle", but bpf_link seems to be
appropriate semantically and is nice and short.

Pre-patch #1 makes internal libbpf_strerror_r helper function work w/ negative
error codes, lifting the burder off callers to keep track of error sign.
Patch #2 adds bpf_link abstraction.
Patch #3 adds attach_perf_event, which is the base for all other APIs.
Patch #4 adds kprobe/uprobe APIs.
Patch #5 adds tracepoint API.
Patch #6 adds raw_tracepoint API.
Patch #7 converts one existing test to use attach_perf_event.
Patch #8 adds new kprobe/uprobe tests.
Patch #9 converts some selftests currently using tracepoint to new APIs.

v2->v3:
- added bpf_link concept (Daniel);
- didn't add generic bpf_link__attach_program for reasons described in [0];
- dropped Stanislav's Reviewed-by from patches #2-#6, in case he doesn't like
  the change;

v1->v2:
- preserve errno before close() call (Stanislav);
- use libbpf_perf_event_disable_and_close in selftest (Stanislav);
- remove unnecessary memset (Stanislav);

[0] https://lore.kernel.org/bpf/CAEf4BzZ7EM5eP2eaZn7T2Yb5QgVRiwAs+epeLR1g01TTx-6m6Q@mail.gmail.com/

Andrii Nakryiko (9):
  libbpf: make libbpf_strerror_r agnostic to sign of error
  libbpf: introduce concept of bpf_link
  libbpf: add ability to attach/detach BPF program to perf event
  libbpf: add kprobe/uprobe attach API
  libbpf: add tracepoint attach API
  libbpf: add raw tracepoint attach API
  selftests/bpf: switch test to new attach_perf_event API
  selftests/bpf: add kprobe/uprobe selftests
  selftests/bpf: convert existing tracepoint tests to new APIs

 tools/lib/bpf/libbpf.c                        | 402 ++++++++++++++++++
 tools/lib/bpf/libbpf.h                        |  21 +
 tools/lib/bpf/libbpf.map                      |   8 +-
 tools/lib/bpf/str_error.c                     |   2 +-
 .../selftests/bpf/prog_tests/attach_probe.c   | 155 +++++++
 .../bpf/prog_tests/stacktrace_build_id.c      |  50 +--
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |  31 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c |  43 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c    |  15 +-
 .../selftests/bpf/progs/test_attach_probe.c   |  55 +++
 10 files changed, 687 insertions(+), 95 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/attach_probe.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_attach_probe.c

-- 
2.17.1

