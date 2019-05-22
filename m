Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D82C25DB5
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 07:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfEVFjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 01:39:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49994 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727284AbfEVFjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 01:39:12 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4M5ZFhs020489
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 22:39:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=4XcjYewWSwgYkRjzUtZdBoQW5AGgzw4iFMY1kru+Vs4=;
 b=ey5UBAoZTRdmWxSoFkr+vt7SieMiLaBOooovkdBXFVKPyCmZKLTubZu+jXp4Zf+d4Yd3
 6u0npxlVfSnFEjgu9SOV/XAwStfHKoZINg5la3+/K/4r8lU0p2zmAAYPPWTC+KuTioHS
 CbUQ5vK8Y7mZgpgNOTyd5NU2bYQF1httOoE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2smp0wt0ns-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 22:39:10 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 May 2019 22:39:03 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id BB89C3702E2B; Tue, 21 May 2019 22:39:00 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 0/3] bpf: implement bpf_send_signal() helper
Date:   Tue, 21 May 2019 22:39:00 -0700
Message-ID: <20190522053900.1663459-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=969 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch tries to solve the following specific use case.

Currently, bpf program can already collect stack traces
through kernel function get_perf_callchain()
when certain events happens (e.g., cache miss counter or
cpu clock counter overflows). But such stack traces are
not enough for jitted programs, e.g., hhvm (jited php).
To get real stack trace, jit engine internal data structures
need to be traversed in order to get the real user functions.

bpf program itself may not be the best place to traverse
the jit engine as the traversing logic could be complex and
it is not a stable interface either.

Instead, hhvm implements a signal handler,
e.g. for SIGALARM, and a set of program locations which
it can dump stack traces. When it receives a signal, it will
dump the stack in next such program location.

This patch implements bpf_send_signal() helper to send
a signal to hhvm in real time, resulting in intended stack traces.

Patch #1 implemented the bpf_send_helper() in the kernel,
Patch #2 synced uapi header bpf.h to tools directory.
Patch #3 added a self test which covers tracepoint
and perf_event bpf programs.

Changelogs:
  RFC v1 => v2:
    . previous version allows to send signal to an arbitrary
      pid. This version just sends the signal to current
      task to avoid unstable pid and potential races between
      sending signals and task state changes for the pid.

Yonghong Song (3):
  bpf: implement bpf_send_signal() helper
  tools/bpf: sync bpf uapi header bpf.h to tools directory
  tools/bpf: add a selftest for bpf_send_signal() helper

 include/uapi/linux/bpf.h                      |  17 +-
 kernel/trace/bpf_trace.c                      |  67 ++++++
 tools/include/uapi/linux/bpf.h                |  17 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   1 +
 .../bpf/progs/test_send_signal_kern.c         |  51 +++++
 .../selftests/bpf/test_send_signal_user.c     | 212 ++++++++++++++++++
 7 files changed, 365 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_send_signal_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_send_signal_user.c

-- 
2.17.1

