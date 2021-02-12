Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33002319810
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 02:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhBLBnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 20:43:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24410 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhBLBn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 20:43:27 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11C1d9lU004454
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 17:42:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=UtuLx3WTMjSSGxzy7SrBCAV0KTEWZY8gpHt64S9m+YM=;
 b=VZUJCOaxPKWCUo8W3KC4YrrgiNdckmmtn+oSjzLqoUYtTH8FYmx3oak0t23eHQNfSqb0
 OZOJ513IY7TZX5bb/YrMTQA3vjajV6RMf4tQbiZu6m+ds7GWcNnQChwjP7Taqd6x4Dm6
 xUCQFV/2gdlToHEuVqHK9ZHBQFiNnuj03Tg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36n91fjtce-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 17:42:46 -0800
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 11 Feb 2021 17:42:44 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 3420A62E0B5D; Thu, 11 Feb 2021 17:42:39 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v6 bpf-next 0/4] introduce bpf_iter for task_vma
Date:   Thu, 11 Feb 2021 17:42:28 -0800
Message-ID: <20210212014232.414643-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 mlxlogscore=870
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120008
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

Changes v5 =3D> v6:
  1. Add more comments for task_vma_seq_get_next() to explain the logic
     of find_vma() calls. (Alexei)
  2. Skip vma found by find_vma() when both vm_start and vm_end matches
     prev_vm_[start|end]. Previous versions only compares vm_start.
     IOW, if vma of [4k, 8k] is replaced by [4k, 12k] after relocking
     mmap_lock, v5 will skip the new vma, while v6 will process it.

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

 kernel/bpf/task_iter.c                        | 267 +++++++++++++++++-
 kernel/trace/bpf_trace.c                      |   5 +
 tools/lib/bpf/libbpf.c                        |   5 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 118 +++++++-
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   8 +
 .../selftests/bpf/progs/bpf_iter_task_vma.c   |  58 ++++
 6 files changed, 450 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c

--
2.24.1
