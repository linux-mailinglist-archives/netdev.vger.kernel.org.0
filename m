Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6E84DFD8
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 06:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfFUE4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 00:56:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13878 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbfFUE4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 00:56:02 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5L4nCCf015953
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:56:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=5Yn0ZDnb74de51fMxv2vGlGQO3iVays1fhgT8OicZog=;
 b=XBFyQCx9VILxUmd3nvTFfVwc+6fDMqwbEVi2vLNwwSfmwH+YrpfcGElmf9Ki7u602+B/
 oqvcGuIAJsRxvAnQoEQZbCM8aF5xxy9MDsfYqSlzpln1bVuA3zZlyeOl0nNlpg1ksHLf
 4jD++P9QB9/NFomGESiDX6X7q7ZhiFOkMls= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t8f1n1wrn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:56:01 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 20 Jun 2019 21:55:59 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 017F2861776; Thu, 20 Jun 2019 21:55:57 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <sdf@fomichev.me>, <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/7] libbpf: add tracing attach APIs
Date:   Thu, 20 Jun 2019 21:55:48 -0700
Message-ID: <20190621045555.4152743-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=694 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210041
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

Pre-patch #1 makes internal libbpf_strerror_r helper function work w/ negative
error codes, lifting the burder off callers to keep track of error sign.
Patch #2 adds attach_perf_event, which is the base for all other APIs.
Patch #3 adds kprobe/uprobe APIs.
Patch #4 adds tracepoint/raw_tracepoint APIs.
Patch #5 converts one existing test to use attach_perf_event.
Patch #6 adds new kprobe/uprobe tests.
Patch #7 converts all the selftests currently using tracepoint to new APIs.

v1->v2:
- preserve errno before close() call (Stanislav);
- use libbpf_perf_event_disable_and_close in selftest (Stanislav);
- remove unnecessary memset (Stanislav);

Andrii Nakryiko (7):
  libbpf: make libbpf_strerror_r agnostic to sign of error
  libbpf: add ability to attach/detach BPF to perf event
  libbpf: add kprobe/uprobe attach API
  libbpf: add tracepoint/raw tracepoint attach API
  selftests/bpf: switch test to new attach_perf_event API
  selftests/bpf: add kprobe/uprobe selftests
  selftests/bpf: convert existing tracepoint tests to new APIs

 tools/lib/bpf/libbpf.c                        | 346 ++++++++++++++++++
 tools/lib/bpf/libbpf.h                        |  17 +
 tools/lib/bpf/libbpf.map                      |   6 +
 tools/lib/bpf/str_error.c                     |   2 +-
 .../selftests/bpf/prog_tests/attach_probe.c   | 151 ++++++++
 .../bpf/prog_tests/stacktrace_build_id.c      |  49 +--
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |  24 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c |  42 +--
 .../bpf/prog_tests/stacktrace_map_raw_tp.c    |  14 +-
 .../bpf/prog_tests/task_fd_query_rawtp.c      |  10 +-
 .../bpf/prog_tests/task_fd_query_tp.c         |  51 +--
 .../bpf/prog_tests/tp_attach_query.c          |  56 +--
 .../selftests/bpf/progs/test_attach_probe.c   |  55 +++
 13 files changed, 651 insertions(+), 172 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/attach_probe.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_attach_probe.c

-- 
2.17.1

