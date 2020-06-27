Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECC620BD75
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 02:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgF0A0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 20:26:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35670 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbgF0A0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 20:26:22 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05R0BZdq012712
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 17:26:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=GM6A8UjAF0fo4iVW+BpkuaPZ8qEq48fS4fEZOdfNKXk=;
 b=dj5nFQ0sYN0px8jy4hratYAGTN6L8Fd/FIVQ9J/TiJJcdCZLQDxruZdCOYgGktwqzgNh
 90sDK3MsGCGjA70GT86M+2m8jI6wrFWtsD8oe0W9N5R0sG7xMyvv6xFGIJ2ASqjHHq0f
 3fYeAfZqDweRbfrQLq9HnWIyWkGGXIrQwr0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0w86qn-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 17:26:22 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 17:26:19 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id B00FE62E4DEC; Fri, 26 Jun 2020 17:26:15 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/4] bpf: introduce bpf_get_task_stack()
Date:   Fri, 26 Jun 2020 17:26:04 -0700
Message-ID: <20200627002609.3222870-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 cotscore=-2147483648 mlxscore=0 suspectscore=0 adultscore=0
 phishscore=0 clxscore=1015 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006270000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set introduces a new helper bpf_get_task_stack(). The primary use ca=
se
is to dump all /proc/*/stack to seq_file via bpf_iter__task.

A few different approaches have been explored and compared:

  1. A simple wrapper around stack_trace_save_tsk(), as v1 [1].

     This approach introduces new syntax, which is different to existing
     helper bpf_get_stack(). Therefore, this is not ideal.

  2. Extend get_perf_callchain() to support "task" as argument.

     This approach reuses most of bpf_get_stack(). However, extending
     get_perf_callchain() requires non-trivial changes to architecture
     specific code. Which is error prone.

  3. Current (v2) approach, leverages most of existing bpf_get_stack(), a=
nd
     uses stack_trace_save_tsk() to handle architecture specific logic.

[1] https://lore.kernel.org/netdev/20200623070802.2310018-1-songliubravin=
g@fb.com/

Changes v2 =3D> v3:
1. Rebase on top of bpf-next. (Yonghong)
2. Sanitize get_callchain_entry(). (Peter)
3. Use has_callchain_buf for bpf_get_task_stack. (Andrii)
4. Other small clean up. (Yonghong, Andrii).

Changes v1 =3D> v2:
1. Reuse most of bpf_get_stack() logic. (Andrii)
2. Fix unsigned long vs. u64 mismatch for 32-bit systems. (Yonghong)
3. Add %pB support in bpf_trace_printk(). (Daniel)
4. Fix buffer size to bytes.

Song Liu (4):
  perf: expose get/put_callchain_entry()
  bpf: introduce helper bpf_get_task_stack()
  bpf: allow %pB in bpf_seq_printf() and bpf_trace_printk()
  selftests/bpf: add bpf_iter test with bpf_get_task_stack()

 include/linux/bpf.h                           |  1 +
 include/linux/perf_event.h                    |  2 +
 include/uapi/linux/bpf.h                      | 36 ++++++++-
 kernel/bpf/stackmap.c                         | 75 ++++++++++++++++++-
 kernel/bpf/verifier.c                         |  4 +-
 kernel/events/callchain.c                     | 13 ++--
 kernel/trace/bpf_trace.c                      | 12 ++-
 scripts/bpf_helpers_doc.py                    |  2 +
 tools/include/uapi/linux/bpf.h                | 36 ++++++++-
 .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++
 .../selftests/bpf/progs/bpf_iter_task_stack.c | 53 +++++++++++++
 11 files changed, 236 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack=
.c

--
2.24.1
