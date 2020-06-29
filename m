Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E5F20D2DF
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgF2SxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:53:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24048 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729188AbgF2SxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:53:07 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05T5nfa4023840
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 22:55:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=88tuhr3f1pOLl7SRW3iPo3wFtlQPZ7DRy59Ann1oPKE=;
 b=dUyEO0+CmvVEyMvVr+xqTgpLvDgo6cZq05eDao4RAXKvodS44Z6BpnRH/fCy6aO+uDR6
 eiw2DYEiF1Rb3V9b7ImAcQdyZMowNU5rmNZspP4bkbZl3k22VymituVW68hUNX6aQ2gF
 LaiPaJjOW8cldyiqgIlXqjdhLCj/ca0qgpk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 31x1kynpt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 22:55:34 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 28 Jun 2020 22:55:33 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 8F4CA62E505E; Sun, 28 Jun 2020 22:55:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 0/4] bpf: introduce bpf_get_task_stack()
Date:   Sun, 28 Jun 2020 22:55:26 -0700
Message-ID: <20200629055530.3244342-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-29_04:2020-06-26,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 cotscore=-2147483648 spamscore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006290042
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

Changes v3 =3D> v4:
1. Simplify the selftests with bpf_iter.h. (Yonghong)
2. Add example output to commit log of 4/4. (Yonghong)

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
 .../selftests/bpf/progs/bpf_iter_task_stack.c | 37 +++++++++
 11 files changed, 220 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack=
.c

--
2.24.1
