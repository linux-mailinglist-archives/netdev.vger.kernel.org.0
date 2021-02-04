Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD3630FED9
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhBDUuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:50:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20042 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229986AbhBDUuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 15:50:52 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 114KkRss015925
        for <netdev@vger.kernel.org>; Thu, 4 Feb 2021 12:50:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=lXa7f3BdrIgby0kW++xbXBVSeOLBc2Pdxm/WmJbuD2k=;
 b=ERuynqQIdM4zDe4aUNCIt1HoL5ou5ble71iB+0UoBmo2VrHWen8OTdY3Vy+ZlYlfA7dQ
 TkAt/wuni1/mqXcmrHNpUPHvde+yqzGyLZgwkxmwXNXPa2vC6k7CTVFgk+TTEcGJN5Sl
 L3Y7qnKTLOGcflEufXH80/AY2scmi/q9lvI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36gfa1k8cr-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 12:50:11 -0800
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 4 Feb 2021 12:50:08 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 10C2C62E1750; Thu,  4 Feb 2021 12:50:06 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v4 bpf-next 0/4] introduce bpf_iter for task_vma
Date:   Thu, 4 Feb 2021 12:49:57 -0800
Message-ID: <20210204205002.4075937-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_10:2021-02-04,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxlogscore=760 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040128
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

 kernel/bpf/task_iter.c                        | 215 +++++++++++++++++-
 kernel/trace/bpf_trace.c                      |   5 +
 tools/lib/bpf/libbpf.c                        |   5 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 114 +++++++++-
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   8 +
 .../selftests/bpf/progs/bpf_iter_task_vma.c   |  58 +++++
 6 files changed, 394 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c

--
2.24.1
