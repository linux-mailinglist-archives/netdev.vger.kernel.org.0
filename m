Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4913B314342
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 23:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhBHWxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 17:53:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62900 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229623AbhBHWxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 17:53:46 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 118Mn3SC003817
        for <netdev@vger.kernel.org>; Mon, 8 Feb 2021 14:53:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=nkM0GdW9T6Kcb1ILKMXGgq9TA/Z8MFxSvHXscRjvoxs=;
 b=CRq94u0wjtnyRE/ICZ5KFNJ9l6tdqNCDdCvDxqIVRCijklNOj1DshXGNMvtVjpFs9qoI
 lz50kJ45zJPAvdcfVeBWdkEr/0WEduGCNH6htTpP7TxiCs4KMvKa+/h+vnODUZsTHEGi
 ubqxhYRIkTOrAaN8m0sNbjFxeJAAWGOgNYA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36hstpa7e5-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 14:53:03 -0800
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 8 Feb 2021 14:53:01 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 5E91B62E092E; Mon,  8 Feb 2021 14:52:59 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v5 bpf-next 0/4] introduce bpf_iter for task_vma
Date:   Mon, 8 Feb 2021 14:52:51 -0800
Message-ID: <20210208225255.3089073-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-08_16:2021-02-08,2021-02-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=810 mlxscore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102080127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set introduces bpf_iter for task_vma, which can be used to generate
information similar to /proc/pid/maps. Patch 4/4 adds an example that
mimics /proc/pid/maps.

Current /proc/<pid>/maps and /proc/<pid>/smaps provide information of
vma's of a process. However, these information are not flexible enough to
cover all use cases. For example, if a vma cover mixed 2MB pages and 4kB
pages (x86_64), there is no easy way to tell which address ranges are
backed by 2MB pages. task_vma solves the problem by enabling the user to
generate customize information based on the vma (and vma->vm_mm,
vma->vm_file, etc.).

Changes v4 =3D> v5:
  1. Fix a refcount leak on task_struct. (Yonghong)
  2. Fix the selftest. (Yonghong)

Changes v3 =3D> v4:
  1. Avoid skipping vma by assigning invalid prev_vm_start in
     task_vma_seq_stop(). (Yonghong)
  2. Move "again" label in task_vma_seq_get_next() save a check. (Yonghon=
g)

Changes v2 =3D> v3:
  1. Rewrite 1/4 so that we hold mmap_lock while calling BPF program. Thi=
s
     enables the BPF program to access the real vma with BTF. (Alexei)
  2. Fix the logic when the control is returned to user space. (Yonghong)
  3. Revise commit log and cover letter. (Yonghong)

Changes v1 =3D> v2:
  1. Small fixes in task_iter.c and the selftests. (Yonghong)

Song Liu (4):
  bpf: introduce task_vma bpf_iter
  bpf: allow bpf_d_path in sleepable bpf_iter program
  libbpf: introduce section "iter.s/" for sleepable bpf_iter program
  selftests/bpf: add test for bpf_iter_task_vma

 kernel/bpf/task_iter.c                        | 217 +++++++++++++++++-
 kernel/trace/bpf_trace.c                      |   5 +
 tools/lib/bpf/libbpf.c                        |   5 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 118 +++++++++-
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   8 +
 .../selftests/bpf/progs/bpf_iter_task_vma.c   |  58 +++++
 6 files changed, 400 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c

--
2.24.1
