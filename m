Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65A121D54C
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgGMLxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:53:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57796 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728950AbgGMLxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:53:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DBq4hP030666;
        Mon, 13 Jul 2020 11:52:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=4izpwHKKMvRnbjuHNXeJZ7HUs0gTe7+RGmJG7LzOJj0=;
 b=Rg+UJMXC2Cxnu5R6b5pbXPjSI+14yq8It1GYRjhC9ytpuBOQ1pN7K+uhzwQ9hqieheAN
 ctSA8zeYXAnoqJ62HsmiYEFQopOu2f1ZtJgz/+1It/IE7uAS7X+LG32TYGJD9EU0pxFr
 fsjO2a/Kx/30IRioysQv0DyB6+7RK+x09uhFtngsjNnb6zzm6Hm826oxUfLzczj5+aXu
 TN++0t8PgGz/TPOBGiXebbofIvCk0dJbscfJr5YbzeM/gavznp3NzlOzZLnNBGHPHc7b
 AfZKhfylpPuSq1lE/Sz31k96ca+9FPN5HEKwPh/hI29zF3ijqlVZ0VSoi9mQreRTTOJl Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274uqxk1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 11:52:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DBhhQP104260;
        Mon, 13 Jul 2020 11:52:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 327qb0epdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 11:52:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06DBqkju020260;
        Mon, 13 Jul 2020 11:52:46 GMT
Received: from localhost.uk.oracle.com (/10.175.215.251)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 04:52:46 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v3 bpf-next 0/2] bpf: fix use of trace_printk() in BPF
Date:   Mon, 13 Jul 2020 12:52:32 +0100
Message-Id: <1594641154-18897-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130089
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steven suggested a way to resolve the appearance of the warning banner
that appears as a result of using trace_printk() in BPF [1].
Applying the patch and testing reveals all works as expected; we
can call bpf_trace_printk() and see the trace messages in
/sys/kernel/debug/tracing/trace_pipe and no banner message appears.

Also add a test prog to verify basic bpf_trace_printk() helper behaviour.

Changes since v2:

- fixed stray newline in bpf_trace_printk(), use sizeof(buf)
  rather than #defined value in vsnprintf() (Daniel, patch 1)
- Daniel also pointed out that vsnprintf() returns 0 on error rather
  than a negative value; also turns out that a null byte is not
  appended if the length of the string written is zero, so to fix
  for cases where the string to be traced is zero length we set the
  null byte explicitly (Daniel, patch 1)
- switch to using getline() for retrieving lines from trace buffer
  to ensure we don't read a portion of the search message in one
  read() operation and then fail to find it (Andrii, patch 2)

Changes since v1:

- reorder header inclusion in bpf_trace.c (Steven, patch 1)
- trace zero-length messages also (Andrii, patch 1)
- use a raw spinlock to ensure there are no issues for PREMMPT_RT
  kernels when using bpf_trace_printk() within other raw spinlocks
  (Steven, patch 1)
- always enable bpf_trace_printk() tracepoint when loading programs
  using bpf_trace_printk() as this will ensure that a user disabling
  that tracepoint will not prevent tracing output from being logged
  (Steven, patch 1)
- use "tp/raw_syscalls/sys_enter" and a usleep(1) to trigger events
  in the selftest ensuring test runs faster (Andrii, patch 2)

[1]  https://lore.kernel.org/r/20200628194334.6238b933@oasis.local.home

Alan Maguire (2):
  bpf: use dedicated bpf_trace_printk event instead of trace_printk()
  selftests/bpf: add selftests verifying bpf_trace_printk() behaviour

 kernel/trace/Makefile                              |  2 +
 kernel/trace/bpf_trace.c                           | 42 ++++++++++--
 kernel/trace/bpf_trace.h                           | 34 ++++++++++
 .../selftests/bpf/prog_tests/trace_printk.c        | 75 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/trace_printk.c   | 21 ++++++
 5 files changed, 169 insertions(+), 5 deletions(-)
 create mode 100644 kernel/trace/bpf_trace.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk.c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_printk.c

-- 
1.8.3.1

