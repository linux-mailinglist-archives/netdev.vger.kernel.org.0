Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D97275DFB
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgIWQyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:54:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32038 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgIWQyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:54:37 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NGpqQj015318
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:54:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=iUoxc+Lkrx/0SMdxBBkXPBqenVOqkw5WV4jWJvmH1gc=;
 b=LflGoW2hW+KuvSIWsxSOJZv/qTv4G4XvSJ+eXuWf+25wZTtNZHOze48bT2Pek9ZECKMr
 q69XzOoIBp9EzVQKad8H7MtlWzCqZUMoXF1CRyc9MjTM9DIUk0fqrEOx+qVE1LveJjr7
 UA0rZkfv85085d1uCTIp3wcxDWMVBpTIxnk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp7vnng-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:54:36 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 09:54:14 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 557B562E4F75; Wed, 23 Sep 2020 09:54:13 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 0/3] enable BPF_PROG_TEST_RUN for raw_tp
Date:   Wed, 23 Sep 2020 09:53:58 -0700
Message-ID: <20200923165401.2284447-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_13:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=805 spamscore=0 adultscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009230130
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

Changes v1 =3D> v2:
1. More checks for retval in the selftest. (John)
2. Remove unnecessary goto in bpf_prog_test_run_raw_tp. (John)

Song Liu (3):
  bpf: enable BPF_PROG_TEST_RUN for raw_tracepoint
  libbpf: introduce bpf_prog_test_run_xattr_opts
  selftests/bpf: add raw_tp_test_run

 include/linux/bpf.h                           |  3 +
 include/uapi/linux/bpf.h                      |  5 ++
 kernel/bpf/syscall.c                          |  2 +-
 kernel/trace/bpf_trace.c                      |  1 +
 net/bpf/test_run.c                            | 88 +++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  5 ++
 tools/lib/bpf/bpf.c                           | 13 ++-
 tools/lib/bpf/bpf.h                           | 11 +++
 tools/lib/bpf/libbpf.map                      |  1 +
 .../bpf/prog_tests/raw_tp_test_run.c          | 73 +++++++++++++++
 .../bpf/progs/test_raw_tp_test_run.c          | 26 ++++++
 11 files changed, 226 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_test_ru=
n.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_raw_tp_test_ru=
n.c

--
2.24.1
