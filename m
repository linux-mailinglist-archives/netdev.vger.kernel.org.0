Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D664DD9F
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 01:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfFTXKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 19:10:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3212 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbfFTXKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 19:10:13 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5KN9EV2016759
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:10:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=RnLy4sqnK36QnV4nRge6edPCKvHBGHk32kZOjq8y8/I=;
 b=fiZwf+YxwIHi+ZUMHqLE6Dkv3fiFiAzyxse0PFHpEnUs8n08rEtoNu+djf0xWYWvLmC0
 KwEOCU1de+PAGFYYiHV3lWATu56qlYNQFEuCcUmoH0KEqxhgIaUZlIF01hv7saLb7I8q
 mWLkUhkpFFeuViAxjpqndSXljZtg95/qiXU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t8d3e9gvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:10:11 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 20 Jun 2019 16:10:10 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 4807B86173D; Thu, 20 Jun 2019 16:10:07 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/7] libbpf: add tracing attach APIs 
Date:   Thu, 20 Jun 2019 16:09:44 -0700
Message-ID: <20190620230951.3155955-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-20_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=625 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906200164
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

Andrii Nakryiko (7):
  libbpf: make libbpf_strerror_r agnostic to sign of error
  libbpf: add ability to attach/detach BPF to perf event
  libbpf: add kprobe/uprobe attach API
  libbpf: add tracepoint/raw tracepoint attach API
  selftests/bpf: switch test to new attach_perf_event API
  selftests/bpf: add kprobe/uprobe selftests
  selftests/bpf: convert existing tracepoint tests to new APIs

 tools/lib/bpf/libbpf.c                        | 347 ++++++++++++++++++
 tools/lib/bpf/libbpf.h                        |  17 +
 tools/lib/bpf/libbpf.map                      |   6 +
 tools/lib/bpf/str_error.c                     |   2 +-
 .../selftests/bpf/prog_tests/attach_probe.c   | 151 ++++++++
 .../bpf/prog_tests/stacktrace_build_id.c      |  49 +--
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |  16 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c |  42 +--
 .../bpf/prog_tests/stacktrace_map_raw_tp.c    |  14 +-
 .../bpf/prog_tests/task_fd_query_rawtp.c      |  10 +-
 .../bpf/prog_tests/task_fd_query_tp.c         |  51 +--
 .../bpf/prog_tests/tp_attach_query.c          |  56 +--
 .../selftests/bpf/progs/test_attach_probe.c   |  55 +++
 13 files changed, 650 insertions(+), 166 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/attach_probe.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_attach_probe.c

-- 
2.17.1

