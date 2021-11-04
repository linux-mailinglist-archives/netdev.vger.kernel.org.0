Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0069444F67
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 08:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhKDHDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 03:03:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54314 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230108AbhKDHDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 03:03:02 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A422xpQ005419
        for <netdev@vger.kernel.org>; Thu, 4 Nov 2021 00:00:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=++gSyi54JJHnSvOMM2x6PtcyKV4rJwmGq2kQyJWI8y0=;
 b=H+BR1psXeRLmHgruyHoZm10S4/N6Def0LtkohJLkvDwr9bb1qTqlKqSVF6GNajJat29c
 xDhQl9xw4TOkM/iohQSDLaWpHlP+ZsfiFnB3GcZAEgr6xr+qKEFm2r+CQDNc2n4IwIQ2
 NZ/lpw132hiVTat4P1QiDeUOexMPj9xjKZ0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c42t0u1c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 00:00:25 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 00:00:23 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 808071DC16563; Thu,  4 Nov 2021 00:00:19 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <kpsingh@kernel.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 0/2] introduce bpf_find_vma
Date:   Thu, 4 Nov 2021 00:00:14 -0700
Message-ID: <20211104070016.2463668-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: Hc1O7p7iZCGuatMXOLaS7kPZXq0vF7ey
X-Proofpoint-GUID: Hc1O7p7iZCGuatMXOLaS7kPZXq0vF7ey
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_01,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 spamscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=456 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 kernel/bpf/mmap_unlock_work.h                 |  65 ++++++++++
 kernel/bpf/stackmap.c                         |  71 +++--------
 kernel/bpf/task_iter.c                        |  49 ++++++++
 kernel/bpf/verifier.c                         |  36 ++++++
 kernel/trace/bpf_trace.c                      |   2 +
 tools/include/uapi/linux/bpf.h                |  20 +++
 .../selftests/bpf/prog_tests/find_vma.c       | 115 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/find_vma.c  |  70 +++++++++++
 .../selftests/bpf/progs/find_vma_fail1.c      |  30 +++++
 .../selftests/bpf/progs/find_vma_fail2.c      |  30 +++++
 12 files changed, 454 insertions(+), 55 deletions(-)
 create mode 100644 kernel/bpf/mmap_unlock_work.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/find_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail1.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail2.c

--
2.30.2
