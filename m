Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0D9446B2D
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 00:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhKEX0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 19:26:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16886 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231211AbhKEX0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 19:26:20 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5MF2cc022164
        for <netdev@vger.kernel.org>; Fri, 5 Nov 2021 16:23:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=ZEUdeNr9gwBvlnsHQnmM5N8E0ChiCeiYVQj/vzpJ4u4=;
 b=Cp4VH50VYwjU4iRWmvKHsETl/rfywes0F2n+JmpLCtXjLrh3F4EE+dUTXdCbuC44lfYB
 8PIWmcfJAExdEUBidx+iRYL2zLFFgGX25AxyLkvPpsnKxD7otEOeLK1OUGPRPD3gzEV4
 u9A1/D61Z3hcV0u/+rIbEfcVLe98JwfSq8A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c559umyx2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 16:23:40 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 5 Nov 2021 16:23:39 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id A6DF01E1DC8B6; Fri,  5 Nov 2021 16:23:36 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <kpsingh@kernel.org>,
        <hengqi.chen@gmail.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v5 bpf-next 0/2] introduce bpf_find_vma
Date:   Fri, 5 Nov 2021 16:23:28 -0700
Message-ID: <20211105232330.1936330-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: tSbBXsl0R5d0HYOMKK6x2XpHmTmEtc8k
X-Proofpoint-ORIG-GUID: tSbBXsl0R5d0HYOMKK6x2XpHmTmEtc8k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-05_03,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=626 suspectscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes v4 =3D> v5:
1. Clean up and style change in 2/2. (Andrii)

Changes v3 =3D> v4:
1. Move mmap_unlock_work to task_iter.c to fix build for .config without
   !CONFIG_PERF_EVENTS. (kernel test robot <lkp@intel.com>)

Changes v2 =3D> v3:
1. Avoid using x86 only function in selftests. (Yonghong)
2. Add struct file and struct vm_area_struct to btf_task_struct_ids, and
   use it in bpf_find_vma and stackmap.c. (Yonghong)
3. Fix inaccurate comments. (Yonghong)

Changes v1 =3D> v2:
1. Share irq_work with stackmap.c. (Daniel)
2. Add tests for illegal writes to task/vma from the callback function.
   (Daniel)
3. Other small fixes.

Add helper bpf_find_vma. This can be used in some profiling use cases. It
might also be useful for LSM.

Song Liu (2):
  bpf: introduce helper bpf_find_vma
  selftests/bpf: add tests for bpf_find_vma

 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  20 +++
 kernel/bpf/btf.c                              |   5 +-
 kernel/bpf/mmap_unlock_work.h                 |  65 ++++++++++
 kernel/bpf/stackmap.c                         |  80 ++----------
 kernel/bpf/task_iter.c                        |  76 ++++++++++--
 kernel/bpf/verifier.c                         |  34 +++++
 kernel/trace/bpf_trace.c                      |   2 +
 tools/include/uapi/linux/bpf.h                |  20 +++
 .../selftests/bpf/prog_tests/find_vma.c       | 117 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/find_vma.c  |  69 +++++++++++
 .../selftests/bpf/progs/find_vma_fail1.c      |  29 +++++
 .../selftests/bpf/progs/find_vma_fail2.c      |  29 +++++
 13 files changed, 466 insertions(+), 81 deletions(-)
 create mode 100644 kernel/bpf/mmap_unlock_work.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/find_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail1.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail2.c

--
2.30.2
