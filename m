Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D16B32238A
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 02:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhBWBWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 20:22:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37746 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230296AbhBWBV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 20:21:57 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11N14hph007839
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 17:21:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=pEbi9RE7Rh3I3wGDeQBFrv7VjBYIcCKe7RkNvOrCedE=;
 b=fAPLx0LhGcoLaRz0PeLG734VzQTYTmQtR0NoGW4WcxqeEyFhfk1BZatXAJglqNuIfJo3
 NeyhrIxxSked+u473LdTUQDW42y9k5YhR42NtCU+RvpoYeiGXRsFBM1x64YtlwVKqNyf
 1nyfI1QHU20PSI2bokBTMKGWAd4fWQg3VeI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36v9gn4nhk-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 17:21:13 -0800
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Feb 2021 17:21:11 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id C050762E0887; Mon, 22 Feb 2021 17:21:07 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v4 bpf-next 0/6] bpf: enable task local storage for tracing programs
Date:   Mon, 22 Feb 2021 17:20:08 -0800
Message-ID: <20210223012014.2087583-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_08:2021-02-22,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=862
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set enables task local storage for non-BPF_LSM programs.

It is common for tracing BPF program to access per-task data. Currently,
these data are stored in hash tables with pid as the key. In
bcc/libbpftools [1], 9 out of 23 tools use such hash tables. However,
hash table is not ideal for many use case. Task local storage provides
better usability and performance for BPF programs. Please refer to 4/4 fo=
r
some performance comparison of task local storage vs. hash table.

Changes v3 =3D> v4:
1. Prevent deadlock from recursive calls of bpf_task_storage_[get|delete]=
.
   (2/6 checks potential deadlock and fails over, 4/6 adds a selftest).

Changes v2 =3D> v3:
1. Make the selftest more robust. (Andrii)
2. Small changes with runqslower. (Andrii)
3. Shortern CC list to make it easy for vger.

Changes v1 =3D> v2:
1. Do not allocate task local storage when the task is being freed.
2. Revise the selftest and added a new test for a task being freed.
3. Minor changes in runqslower.

Song Liu (6):
  bpf: enable task local storage for tracing programs
  bpf: prevent deadlock from recursive bpf_task_storage_[get|delete]
  selftests/bpf: add non-BPF_LSM test for task local storage
  selftests/bpf: test deadlock from recursive
    bpf_task_storage_[get|delete]
  bpf: runqslower: prefer using local vmlimux to generate vmlinux.h
  bpf: runqslower: use task local storage

 include/linux/bpf.h                           |  7 ++
 include/linux/bpf_lsm.h                       | 22 -----
 include/linux/bpf_types.h                     |  2 +-
 include/linux/sched.h                         |  5 +
 kernel/bpf/Makefile                           |  3 +-
 kernel/bpf/bpf_local_storage.c                | 28 +++---
 kernel/bpf/bpf_lsm.c                          |  4 -
 kernel/bpf/bpf_task_storage.c                 | 89 +++++++++++-------
 kernel/fork.c                                 |  5 +
 kernel/trace/bpf_trace.c                      |  4 +
 tools/bpf/runqslower/Makefile                 |  5 +-
 tools/bpf/runqslower/runqslower.bpf.c         | 33 ++++---
 .../bpf/prog_tests/task_local_storage.c       | 92 +++++++++++++++++++
 .../selftests/bpf/progs/task_local_storage.c  | 64 +++++++++++++
 .../bpf/progs/task_local_storage_exit_creds.c | 32 +++++++
 .../selftests/bpf/progs/task_ls_recursion.c   | 70 ++++++++++++++
 16 files changed, 381 insertions(+), 84 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_local_sto=
rage.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage_=
exit_creds.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_ls_recursion.c

--
2.24.1
