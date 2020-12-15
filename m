Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491042DB7A8
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgLPABR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:01:17 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26964 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725891AbgLOXhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 18:37:50 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFNXs4M014559
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 15:37:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=hVyq3HKrK0Kj2ubm+BrL8q5u+GsKxQh011dEhg13BoU=;
 b=dUWUZYdwBXf1XpeQ7m1xF2ElI5Q3bbSuumWRPwao+PaoafxoG7DStYhx1Yla1dCUj1tc
 b/jv9b52xD9W+WcVqLNfvJXvuU+PvbvZhqTUnrxofKOkPu1fCTKxYjqmOPoYki7/N3sM
 XLC62FM4KTk2IHwdeiRuZaQsbBbi4luhFaA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35descp5xv-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 15:37:10 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Dec 2020 15:37:06 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 23F3962E56FB; Tue, 15 Dec 2020 15:37:05 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 0/4] introduce bpf_iter for task_vma
Date:   Tue, 15 Dec 2020 15:36:58 -0800
Message-ID: <20201215233702.3301881-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_13:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 mlxlogscore=540 phishscore=0 impostorscore=0 clxscore=1015
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150159
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set introduces bpf_iter for task_vma, which can be used to generate
information similar to /proc/pid/maps or /proc/pid/smaps. Patch 4/4 adds
an example that mimics /proc/pid/maps.

Changes v1 =3D> v2:
  1. Small fixes in task_iter.c and the selftests. (Yonghong)

Song Liu (4):
  bpf: introduce task_vma bpf_iter
  bpf: allow bpf_d_path in sleepable bpf_iter program
  libbpf: introduce section "iter.s/" for sleepable bpf_iter program
  selftests/bpf: add test for bpf_iter_task_vma

 include/linux/bpf.h                           |   2 +-
 kernel/bpf/task_iter.c                        | 205 +++++++++++++++++-
 kernel/trace/bpf_trace.c                      |   5 +
 tools/lib/bpf/libbpf.c                        |   5 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 106 ++++++++-
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   9 +
 .../selftests/bpf/progs/bpf_iter_task_vma.c   |  55 +++++
 7 files changed, 375 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c

--
2.24.1
