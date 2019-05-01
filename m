Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 250E9105A5
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 08:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfEAG4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 02:56:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50782 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbfEAG4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 02:56:25 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x416n4OE027110
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 23:56:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=yFoUxjZ74/vhOj4o3Qjs+87UjWX1X2tDPf6SvcZ0ujE=;
 b=lIQq5baLaWHHF1YCfgTJGhBvJsNSZJEwSVxFd3z/w2cSrb6Qwf1p8fkHaUaNF+cgqSFp
 9oVVJFsdRCPeMfzYY1iZylBxKM+86HJg7y2I+313n05gIkbDVV+AwAUhdc8R7aU9jEfM
 9bAwDBED40nlY0Hh74JA7UNk4CYSyZ4RKNA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2s6xhth6f1-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 23:56:24 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 30 Apr 2019 23:56:23 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id ECE303702FB8; Tue, 30 Apr 2019 23:56:21 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 0/3] implement bpf_send_signal() helper
Date:   Tue, 30 Apr 2019 23:56:21 -0700
Message-ID: <20190501065621.2599742-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_03:,,
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

