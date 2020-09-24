Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F231127660A
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgIXBuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:50:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54380 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725208AbgIXBuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:50:00 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08O1JqNn022575
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:20:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=AkCqPZr91SmqckdCfsq4yzXPiVRrgGIzdA1H0KFySSQ=;
 b=QfrVURb9U1yhobl3lyxWN3EtSf7O4Yj69GG/lAOjTzYJMZVVj1DXMHjWtfwtPZggmO44
 sw2qze11ugI/XrAWcrfkTUh/93DJhcrSSmmf9+LcnN5uKUtjpIJJhj/empspA46fqjOg
 RhTvBvAJViWMtJ8Pc3x3Te67E3+ELZFa/F8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp5y5g5-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:20:04 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 18:19:58 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 5CFC962E54C3; Wed, 23 Sep 2020 18:19:56 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v4 bpf-next 0/3] enable BPF_PROG_TEST_RUN for raw_tp
Date:   Wed, 23 Sep 2020 18:19:48 -0700
Message-ID: <20200924011951.408313-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_19:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=801 clxscore=1015 suspectscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240007
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
  libbpf: introduce bpf_prog_test_run_xattr_opts
  selftests/bpf: add raw_tp_test_run

Song Liu (3):
  bpf: enable BPF_PROG_TEST_RUN for raw_tracepoint
  libbpf: support test run of raw tracepoint programs
  selftests/bpf: add raw_tp_test_run

 include/linux/bpf.h                           |  3 +
 include/uapi/linux/bpf.h                      |  7 ++
 kernel/bpf/syscall.c                          |  2 +-
 kernel/trace/bpf_trace.c                      |  1 +
 net/bpf/test_run.c                            | 89 +++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  7 ++
 tools/lib/bpf/bpf.c                           | 31 +++++++
 tools/lib/bpf/bpf.h                           | 26 ++++++
 tools/lib/bpf/libbpf.map                      |  1 +
 tools/lib/bpf/libbpf_internal.h               |  5 ++
 .../bpf/prog_tests/raw_tp_test_run.c          | 80 +++++++++++++++++
 .../bpf/progs/test_raw_tp_test_run.c          | 25 ++++++
 12 files changed, 276 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_test_ru=
n.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_raw_tp_test_ru=
n.c

--
2.24.1
