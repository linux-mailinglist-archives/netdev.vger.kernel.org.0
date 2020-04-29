Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E9C1BD4F7
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgD2Gp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:45:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47802 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726484AbgD2Gpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:45:55 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T6jq48029579
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 23:45:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=ybuRTXUnxPqWX8KhhYbwh6iMsPQvXIaHJYGqJJ8jjmg=;
 b=h1uvOaU9ZodCXBFHOH3eiChLBNLEmnrKbJz75ZOa5DmNsWtwLFXS6j2wQYvvQkYwFcAq
 OEZPRA3ZEYLg++Kq5fPwLsH0AmBSdc7xSJ0hhEjoY+8po9AxoXpIiJ2ALP+AT8NCh7gb
 +7WB5WySvEkmTLsdAIWi99jnZgd7DUCPEJ0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n5bxd5he-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 23:45:54 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 23:45:48 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9CC2962E4C2D; Tue, 28 Apr 2020 23:45:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v8 bpf-next 0/3] bpf: sharing bpf runtime stats with
Date:   Tue, 28 Apr 2020 23:45:40 -0700
Message-ID: <20200429064543.634465-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_02:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=8 bulkscore=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

run_time_ns is a useful stats for BPF programs. However, it is gated by
sysctl kernel.bpf_stats_enabled. When multiple user space tools are
toggling kernl.bpf_stats_enabled at the same time, they may confuse each
other.

Solve this problem with a new BPF command BPF_ENABLE_STATS.

Changes v7 =3D> v8:
  1. Change name BPF_STATS_RUNTIME_CNT =3D> BPF_STATS_RUN_TIME (Alexei).
  2. Add CHECK_ATTR to bpf_enable_stats() (Alexei).
  3. Rebase (Andrii).
  4. Simplfy the selftest (Alexei).

Changes v6 =3D> v7:
  1. Add test to verify run_cnt matches count measured by the program.

Changes v5 =3D> v6:
  1. Simplify test program (Yonghong).
  2. Rebase (with some conflicts).

Changes v4 =3D> v5:
  1. Use memset to zero bpf_attr in bpf_enable_stats() (Andrii).

Changes v3 =3D> v4:
  1. Add libbpf support and selftest;
  2. Avoid cleaning trailing space.

Changes v2 =3D> v3:
  1. Rename the command to BPF_ENABLE_STATS, and make it extendible.
  2. fix commit log;
  3. remove unnecessary headers.

Song Liu (3):
  bpf: sharing bpf runtime stats with BPF_ENABLE_STATS
  libbpf: add support for command BPF_ENABLE_STATS
  bpf: add selftest for BPF_ENABLE_STATS

 include/linux/bpf.h                           |  1 +
 include/uapi/linux/bpf.h                      | 11 ++++
 kernel/bpf/syscall.c                          | 57 +++++++++++++++++++
 kernel/sysctl.c                               | 36 +++++++++++-
 tools/include/uapi/linux/bpf.h                | 11 ++++
 tools/lib/bpf/bpf.c                           | 10 ++++
 tools/lib/bpf/bpf.h                           |  1 +
 tools/lib/bpf/libbpf.map                      |  1 +
 .../selftests/bpf/prog_tests/enable_stats.c   | 46 +++++++++++++++
 .../selftests/bpf/progs/test_enable_stats.c   | 18 ++++++
 10 files changed, 191 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c

--
2.24.1
