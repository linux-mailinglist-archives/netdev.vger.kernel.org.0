Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B89B306894
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhA1AWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:22:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11320 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231316AbhA1AVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 19:21:19 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10S0DxiX003231
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 16:20:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=qSl0hIbsWjbdFiMIHrNNvB79aitkeKbYCX0qUJKiMOg=;
 b=nou/auOnrvK9wdWtTh5FEZxMFW7VjSk5o37UsPEVVVMrbMaFs2ra2jomWisZkD8N5R5k
 LAvgH0u41xtLxsFdICpy/EYM2hSUVYntmvlMOM/9xBJ5wt/BfEYoQ8R5p6058WVxP+EK
 5tnnuty3bVWCu/ifefN3foimkCbQDt5Ppbc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36awcpp7jw-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 16:20:38 -0800
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 16:20:35 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 8116762E0B6C; Wed, 27 Jan 2021 16:20:32 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <mingo@redhat.com>, <peterz@infradead.org>, <daniel@iogearbox.net>,
        <kpsingh@chromium.org>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 bpf-next 0/4] bpf: enable task local storage for tracing programs
Date:   Wed, 27 Jan 2021 16:19:44 -0800
Message-ID: <20210128001948.1637901-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_10:2021-01-27,2021-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxlogscore=800 priorityscore=1501 spamscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280000
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

Changes v2 =3D> v3:
1. Make the selftest more robust. (Andrii)
2. Small changes with runqslower. (Andrii)
3. Shortern CC list to make it easy for vger.

Changes v1 =3D> v2:
1. Do not allocate task local storage when the task is being freed.
2. Revise the selftest and added a new test for a task being freed.
3. Minor changes in runqslower.

Song Liu (4):
  bpf: enable task local storage for tracing programs
  selftests/bpf: add non-BPF_LSM test for task local storage
  bpf: runqslower: prefer using local vmlimux to generate vmlinux.h
  bpf: runqslower: use task local storage

 include/linux/bpf.h                           |  7 ++
 include/linux/bpf_lsm.h                       | 22 ------
 include/linux/bpf_types.h                     |  2 +-
 include/linux/sched.h                         |  5 ++
 kernel/bpf/Makefile                           |  3 +-
 kernel/bpf/bpf_local_storage.c                | 28 +++++---
 kernel/bpf/bpf_lsm.c                          |  4 --
 kernel/bpf/bpf_task_storage.c                 | 34 +++------
 kernel/fork.c                                 |  5 ++
 kernel/trace/bpf_trace.c                      |  4 ++
 tools/bpf/runqslower/Makefile                 |  5 +-
 tools/bpf/runqslower/runqslower.bpf.c         | 33 +++++----
 .../bpf/prog_tests/task_local_storage.c       | 69 +++++++++++++++++++
 .../selftests/bpf/progs/task_local_storage.c  | 64 +++++++++++++++++
 .../bpf/progs/task_local_storage_exit_creds.c | 32 +++++++++
 15 files changed, 239 insertions(+), 78 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_local_sto=
rage.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage_=
exit_creds.c

--
2.24.1
