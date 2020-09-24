Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B25277C17
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 01:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIXXCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 19:02:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbgIXXCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 19:02:25 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08OMxP6R005513
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 16:02:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=nTyej35x+vQc0suiILaFyXO+N4NlgC9CbfcA7q2vywA=;
 b=Xi8u0BH6vBmD3l0o73VoBFBY14sjlNdJS2IZnBtWYoKDSPmdSrNwZxY2xfPGBomRsZ00
 uZv/9npzYi/FamTCUIhJZr6cP606cP/cZWWwJu5VQEZhk6AxgXNmC6l6DtuYxuYH0Owo
 bb5eI1AN4JgPZ9+d9cfJV2h7uoWCyrKGTMU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp54k4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 16:02:25 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 16:02:24 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 4FBFD62E542E; Thu, 24 Sep 2020 16:02:12 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v5 bpf-next 0/3] enable BPF_PROG_TEST_RUN for raw_tp
Date:   Thu, 24 Sep 2020 16:02:06 -0700
Message-ID: <20200924230209.2561658-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=672 suspectscore=0 bulkscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240166
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set enables BPF_PROG_TEST_RUN for raw_tracepoint type programs. This
set also enables running the raw_tp program on a specific CPU. This featu=
re
can be used by user space to trigger programs that access percpu resource=
s,
e.g. perf_event, percpu variables.

Changes v4 =3D> v5:
1.Fail test_run with non-zero test.cpu but no BPF_F_TEST_RUN_ON_CPU.
  (Andrii)
2. Add extra check for invalid test.cpu value. (Andrii)
3. Shuffle bpf_test_run_opts to remove holes. (Andrii)
4. Fixes in selftests. (Andrii)

Changes v3 =3D> v4:
1. Use cpu+flags instead of cpu_plus. (Andrii)
2. Rework libbpf support. (Andrii)

Changes v2 =3D> v3:
1. Fix memory leak in the selftest. (Andrii)
2. Use __u64 instead of unsigned long long. (Andrii)

Changes v1 =3D> v2:
1. More checks for retval in the selftest. (John)
2. Remove unnecessary goto in bpf_prog_test_run_raw_tp. (John)

Song Liu (3):
  bpf: enable BPF_PROG_TEST_RUN for raw_tracepoint
  libbpf: support test run of raw tracepoint programs
  selftests/bpf: add raw_tp_test_run

 include/linux/bpf.h                           |  3 +
 include/uapi/linux/bpf.h                      |  7 ++
 kernel/bpf/syscall.c                          |  2 +-
 kernel/trace/bpf_trace.c                      |  1 +
 net/bpf/test_run.c                            | 91 +++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  7 ++
 tools/lib/bpf/bpf.c                           | 31 ++++++
 tools/lib/bpf/bpf.h                           | 26 +++++
 tools/lib/bpf/libbpf.map                      |  1 +
 tools/lib/bpf/libbpf_internal.h               |  5 +
 .../bpf/prog_tests/raw_tp_test_run.c          | 98 +++++++++++++++++++
 .../bpf/progs/test_raw_tp_test_run.c          | 24 +++++
 12 files changed, 295 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_test_ru=
n.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_raw_tp_test_ru=
n.c

--
2.24.1
