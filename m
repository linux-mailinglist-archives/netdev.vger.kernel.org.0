Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022CE28C9F
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388246AbfEWVru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:47:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51582 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388145AbfEWVru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:47:50 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NLWlsI003544
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 14:47:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=wRXpeskYHyGA7Lvutw2Fn2O9K0LmbXu3hSdjY4e448o=;
 b=lwBzdLzxvqK8BXps0GgAbEYj9c8lK7DyPq/MFDLF+klAIqB4A7UW3MJmm/plPXG93xpr
 zVkFKjbe8g7etF/NNEc+N1lhBcYGUpNwe06LNot+1wE8hmOEU2mkftdHjg++Bw+Va+m+
 q/yEnKYlg13bCeVwcMGkYA2mqlHyTKKzf9U= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2snx7s99k1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 14:47:49 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 23 May 2019 14:47:47 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 558923701F86; Thu, 23 May 2019 14:47:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v5 0/3] bpf: implement bpf_send_signal() helper
Date:   Thu, 23 May 2019 14:47:45 -0700
Message-ID: <20190523214745.854300-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_17:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230138
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

Patch #1 implemented the bpf_send_helper() in the kernel.
Patch #2 synced uapi header bpf.h to tools directory.
Patch #3 added a self test which covers tracepoint
and perf_event bpf programs. 

Changelogs:
  v4 => v5:
    . pass the "current" task struct to irq_work as well
      since the current task struct may change between
      nmi and subsequent irq_work_interrupt.
      Discovered by Daniel.
  v3 => v4:
    . fix one typo and declare "const char *id_path = ..."
      to avoid directly use the long string in the func body 
      in Patch #3.
  v2 => v3:
    . change the standalone test to be part of prog_tests.
  RFC v1 => v2:
    . previous version allows to send signal to an arbitrary 
      pid. This version just sends the signal to current
      task to avoid unstable pid and potential races between
      sending signals and task state changes for the pid.

Yonghong Song (3):
  bpf: implement bpf_send_signal() helper
  tools/bpf: sync bpf uapi header bpf.h to tools directory
  tools/bpf: add selftest in test_progs for bpf_send_signal() helper

 include/uapi/linux/bpf.h                      |  17 +-
 kernel/trace/bpf_trace.c                      |  72 +++++++
 tools/include/uapi/linux/bpf.h                |  17 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   1 +
 .../selftests/bpf/prog_tests/send_signal.c    | 198 ++++++++++++++++++
 .../bpf/progs/test_send_signal_kern.c         |  51 +++++
 6 files changed, 354 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/send_signal.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_send_signal_kern.c

-- 
2.17.1

