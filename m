Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2812557
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 02:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfECAIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 20:08:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56266 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725995AbfECAIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 20:08:16 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4308DJj022556
        for <netdev@vger.kernel.org>; Thu, 2 May 2019 17:08:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Tg8XFQ3Yq15syv0X/O52D7ZwekWNS/AsJ1YTN270L2M=;
 b=PmOSSncPxufxaXa5zCAklJDJO6y+1ZoIkh+tydls+khAJdIjJaRLDlc75IhE6W11hxD5
 nYsce3JjfHv/wJs3Lo3fKYS7DVywdz9UrDcS6JKhvpf4fKv060U3n9VY+A/HcpAcWb0p
 dGYXYG+3lmsPKb05FzoNrQtTICVDBaZx+iM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2s86r1gsnf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 17:08:14 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 2 May 2019 17:08:07 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id C51D03702ACB; Thu,  2 May 2019 17:08:06 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 0/3] bpf: implement bpf_send_signal() helper
Date:   Thu, 2 May 2019 17:08:06 -0700
Message-ID: <20190503000806.1340927-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-02_13:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, bpf program can already collect stack traces 
when certain events happens (e.g., cache miss counter or
cpu clock counter overflows). These stack traces can be 
used for performance analysis. For jitted programs, e.g.,
hhvm (jited php), it is very hard to get the true stack 
trace in the bpf program due to jit complexity.         

To resolve this issue, hhvm implements a signal handler,
e.g. for SIGALARM, and a set of program locations which 
it can dump stack traces. When it receives a signal, it will
dump the stack in next such program location.           

The following is the current way to handle this use case:
  . profiler installs a bpf program and polls on a map.
    When certain event happens, bpf program writes to a map.
  . Once receiving the information from the map, the profiler
    sends a signal to hhvm.
This method could have large delays and cause profiling
results skewed.

This patch implements bpf_send_signal() helper to send a signal to
hhvm in real time, resulting in intended stack traces.

The patch is sent out as RFC as (1). I have not found a simple
solution to return error code from irq_work, and (2). I would
like some general feedback about the approach.

Changelogs:
  v1 -> v2:
    . fixed a compilation error/warning (missing return value in one
      error branch) discovered by kbuild bot.

Yonghong Song (3):
  bpf: implement bpf_send_signal() helper
  tools/bpf: sync bpf uapi header bpf.h
  tools/bpf: add a selftest for bpf_send_signal() helper

 include/uapi/linux/bpf.h                      |  15 +-
 kernel/trace/bpf_trace.c                      |  85 ++++++++
 tools/include/uapi/linux/bpf.h                |  15 +-
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   2 +
 .../bpf/progs/test_send_signal_kern.c         |  50 +++++
 .../selftests/bpf/test_send_signal_user.c     | 186 ++++++++++++++++++
 7 files changed, 354 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_send_signal_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_send_signal_user.c

-- 
2.17.1

