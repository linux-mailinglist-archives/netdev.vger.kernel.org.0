Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EF921B885
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgGJOYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:24:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58382 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728544AbgGJOYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 10:24:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AEM74M028636;
        Fri, 10 Jul 2020 14:23:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=0Wdlwm4raGSymgpKP2Ty7pQ0EeMTWnHCuUjWg1PBerE=;
 b=Vt+j4s4YEx8RqaGNXtY65QkthAHBAD/9rZb8WGb5kpCWnsw8EDJtr0JSdKz9vlWshXaG
 tJGnjAMv3P6TV+ljWZSdBImSWliqUmF6Kw5BLdrgkruMWa6wT3/3koMJTJYTBOsGI5pZ
 YCwGxoP0j8tJfyk3ZdklJqjre4n/ouN0BNFrQ/ILJKtOrwz792XyOqVY9/TiB/W25jg+
 VqMjL8W0YkRk9SxLcgUA1Yt40kPpeEac66abdq5nRv4RUFbuMnJKkPQg1fLp0WDn3glP
 p2Ga6tvggKzppXecjnESb8PrgPzNCKloBQ07C+cybbdbHHHaFntMoA7b/Rs4bAXFBWX6 8w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 325y0aqrp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jul 2020 14:23:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AENKJf102332;
        Fri, 10 Jul 2020 14:23:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 325k3mfrd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jul 2020 14:23:20 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06AENGBb024188;
        Fri, 10 Jul 2020 14:23:16 GMT
Received: from localhost.uk.oracle.com (/10.175.190.31)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jul 2020 07:23:16 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andriin@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 0/2] bpf: fix use of trace_printk() in BPF
Date:   Fri, 10 Jul 2020 15:22:31 +0100
Message-Id: <1594390953-31757-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007100101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007100101
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
 kernel/trace/bpf_trace.c                           | 41 ++++++++++--
 kernel/trace/bpf_trace.h                           | 34 ++++++++++
 .../selftests/bpf/prog_tests/trace_printk.c        | 74 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/trace_printk.c   | 21 ++++++
 5 files changed, 167 insertions(+), 5 deletions(-)
 create mode 100644 kernel/trace/bpf_trace.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk.c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_printk.c

-- 
1.8.3.1

