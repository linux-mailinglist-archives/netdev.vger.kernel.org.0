Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76EE213BFF
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 16:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgGCOp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 10:45:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34988 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgGCOp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 10:45:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063EgWdT010532;
        Fri, 3 Jul 2020 14:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=jAlHI7nujQDcm+MewjBseorEgs8Y6kyiq354ZRlVCiw=;
 b=bs3NE8v8ixykeBj9AT5ZGqzepRu/JZ6TkFw8fRgAwlAqStI/NVDd/ZWRImHnb8djDx6c
 nt9r9EOFgtE3g6kc4Q2yX9nQMVdd1FV+nWA/ztJHAk1aBvDr+ziGKqRfnOCm6zhF4kwz
 OCvu5UlhknguTwCpO9ZDnJ4XHlblbRf/GPng4hsd/Tay0cCWwh+4hcCMFThWbGnUIK0E
 FkAPjbY5bLEuaQCPQycp0S1S6BVY7E0GIrBztEase6+ryuAdsZWQIC4clh1qh6xYRtKg
 4gzSoW2RBb6UehzKcbBTWCpXcpVaQrRHIMXZXEygUyGaSvg3Eqqr6IzTXQ60RqI118Zl qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31xx1eawxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 14:44:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063Egsfw193726;
        Fri, 3 Jul 2020 14:44:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31xg1cjytw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 14:44:42 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 063Eie7P013218;
        Fri, 3 Jul 2020 14:44:40 GMT
Received: from localhost.uk.oracle.com (/10.175.204.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 14:44:40 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 0/2] bpf: fix use of trace_printk() in BPF
Date:   Fri,  3 Jul 2020 15:44:26 +0100
Message-Id: <1593787468-29931-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030102
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

Possible future work: ftrace supports trace instances, and one thing
that strikes me is that we could make use of these in BPF to separate
BPF program bpf_trace_printk() output from output of other tracing
activities.

I was thinking something like a sysctl net.core.bpf_trace_instance,
defaulting to an empty value signifying we use the root trace
instance.  This would preserve existing behaviour while giving a
way to separate BPF tracing output from other tracing output if wanted.

[1]  https://lore.kernel.org/r/20200628194334.6238b933@oasis.local.home

Alan Maguire (2):
  bpf: use dedicated bpf_trace_printk event instead of trace_printk()
  selftests/bpf: add selftests verifying bpf_trace_printk() behaviour

 kernel/trace/Makefile                              |  2 +
 kernel/trace/bpf_trace.c                           | 41 +++++++++++--
 kernel/trace/bpf_trace.h                           | 34 +++++++++++
 .../selftests/bpf/prog_tests/trace_printk.c        | 71 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/trace_printk.c   | 21 +++++++
 5 files changed, 165 insertions(+), 4 deletions(-)
 create mode 100644 kernel/trace/bpf_trace.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk.c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_printk.c

-- 
1.8.3.1

