Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD97320EE76
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgF3G25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:28:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13146 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730096AbgF3G24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 02:28:56 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05U6StX8018789
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:28:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=ATAIZRyF5LF5Ymt6TlkUCcEq7zggg+i+C8LAuUJjSjU=;
 b=fY7q+dyrU9O3KHHf1c7Dkel+wQFs1sj9DvNCBMuaxaShpdAzRCEKa7QAoVLxxRwtOEnJ
 e8dDtpYsgQn9xmnvbe1HuUVONKA0vlnYw6ygCU7LEXRGma+K8i8CIKan7U1LD9rKPzsY
 4S/N6Qfows/1fJs8wnBKfw8X78I1W5dnPPQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31xp398gmb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:28:55 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 23:28:55 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 593F062E51C7; Mon, 29 Jun 2020 23:28:50 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v5 bpf-next 0/4] bpf: introduce bpf_get_task_stack()
Date:   Mon, 29 Jun 2020 23:28:42 -0700
Message-ID: <20200630062846.664389-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_01:2020-06-30,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 phishscore=0 cotscore=-2147483648 malwarescore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 mlxlogscore=999 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300048
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

Changes v4 =3D> v5:
1. Rebase and work around git-am issue. (Alexei)
2. Update commit log for 4/4. (Yonghong)

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
 kernel/bpf/stackmap.c                         | 77 ++++++++++++++++++-
 kernel/bpf/verifier.c                         |  4 +-
 kernel/events/callchain.c                     | 13 ++--
 kernel/trace/bpf_trace.c                      | 12 ++-
 scripts/bpf_helpers_doc.py                    |  2 +
 tools/include/uapi/linux/bpf.h                | 36 ++++++++-
 .../selftests/bpf/prog_tests/bpf_iter.c       | 17 ++++
 .../selftests/bpf/progs/bpf_iter_task_stack.c | 37 +++++++++
 11 files changed, 221 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack=
.c

--
2.24.1
