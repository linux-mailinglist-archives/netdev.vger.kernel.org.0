Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438F631A494
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhBLScE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:32:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27340 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231292AbhBLScC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 13:32:02 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11CIHvDH001574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 10:31:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=7JFSIGUJhHMizMDcRYz8h2Seo9CVxarDUUmp5pCFxUs=;
 b=VaNXSBLEfvSvZc8h7kUx53PHoFGV/av5VTvQQcRemp27/7f5N6AoiAQvjNnTLYAq97VW
 KkDEP4LiBHITTXlYPvIauVrbOYAnMoKMy6+DR02X0U+1i23Be1FTTiUwSIMg18Nf0a0D
 6cUKi5sppQT5SEmXBmBDz1h0COhi5OIrpmg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36mr6jbrbn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 10:31:22 -0800
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 12 Feb 2021 10:31:21 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 7780662E0BAC; Fri, 12 Feb 2021 10:31:14 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v7 bpf-next 0/3] introduce bpf_iter for task_vma
Date:   Fri, 12 Feb 2021 10:31:04 -0800
Message-ID: <20210212183107.50963-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_07:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=853 impostorscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102120135
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

Changes v6 =3D> v7:
  1. Let BPF iter program use bpf_d_path without specifying sleepable.
     (Alexei)

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

Song Liu (3):
  bpf: introduce task_vma bpf_iter
  bpf: allow bpf_d_path in bpf_iter program
  selftests/bpf: add test for bpf_iter_task_vma

 kernel/bpf/task_iter.c                        | 267 +++++++++++++++++-
 kernel/trace/bpf_trace.c                      |   4 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 118 +++++++-
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   8 +
 .../selftests/bpf/progs/bpf_iter_task_vma.c   |  58 ++++
 5 files changed, 444 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c

--
2.24.1
