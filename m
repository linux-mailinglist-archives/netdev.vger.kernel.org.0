Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA572445BAF
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 22:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhKDVen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 17:34:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18318 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231142AbhKDVem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 17:34:42 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4ESW3J014720
        for <netdev@vger.kernel.org>; Thu, 4 Nov 2021 14:32:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=DT4eG9ZsnKYAAtbQxwqM8KrdgMVWK2IDvGFYv5Nh4is=;
 b=Mt4bKpr60+hOY3a4C9DDBwsIUL6eIOMBIFeF3fy/2CAd605gdH7ZtEL8VPdqv/UgIb/5
 wJFV2Rbd4gmZ7mTIDbLTK74y0AqTcY1RE/GGYU3Dk2pJ5UevhrR3+mDtnpDNMCSSzuJk
 75yCUJ1ZRgiY9I7H36DVopLGD7WsREsfuD4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c43a4rwws-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 14:32:04 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 14:31:43 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 005611DEB640B; Thu,  4 Nov 2021 14:31:40 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <kpsingh@kernel.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v4 bpf-next 0/2] introduce bpf_find_vma
Date:   Thu, 4 Nov 2021 14:31:36 -0700
Message-ID: <20211104213138.2779620-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: zrMPqxTPzWaIoxzUlL79k6l3T6tFOHGi
X-Proofpoint-GUID: zrMPqxTPzWaIoxzUlL79k6l3T6tFOHGi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_07,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=631
 impostorscore=0 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040082
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes v3 =3D> v4:
1. Move mmap_unlock_work to task_iter.c to fix build for .config without
   !CONFIG_PERF_EVENTS. (kernel test robot)

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
 kernel/bpf/verifier.c                         |  34 ++++++
 kernel/trace/bpf_trace.c                      |   2 +
 tools/include/uapi/linux/bpf.h                |  20 +++
 .../selftests/bpf/prog_tests/find_vma.c       | 115 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/find_vma.c  |  69 +++++++++++
 .../selftests/bpf/progs/find_vma_fail1.c      |  29 +++++
 .../selftests/bpf/progs/find_vma_fail2.c      |  29 +++++
 13 files changed, 464 insertions(+), 81 deletions(-)
 create mode 100644 kernel/bpf/mmap_unlock_work.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/find_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail1.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail2.c

--
2.30.2
