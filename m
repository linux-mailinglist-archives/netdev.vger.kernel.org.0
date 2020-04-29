Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADDB1BD19A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgD2BVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:21:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18392 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726355AbgD2BVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:21:18 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T1KBL9032080
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=xKoTfbAxvxDOpmLqrdt/rqPdBdcEqv8Ozq2WH8UCyVU=;
 b=VSBWNgyngfpfcZ8Rj9n9IHt2yWORfljhh/nzfQKAXpSH0EUe0/SYaPIkKtCbTOLSXfrd
 UhUWm6UTVHn1E1yhDm3UkBWV0GPf92GH7Fa/qI8LhIKIC4cB4Exd3Vote4JTWGmFLsjX
 Vt7u7JVL8G6pGVc7oKNwzzQSg3Kcrfm9Ti0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57pkart-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:18 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:21:16 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BCBA62EC30E4; Tue, 28 Apr 2020 18:21:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 00/11] Fix libbpf and selftest issues detected by ASAN
Date:   Tue, 28 Apr 2020 18:21:00 -0700
Message-ID: <20200429012111.277390-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=25 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add necessary infra to build selftests with ASAN (or any other sanitizer)=
. Fix
a bunch of found memory leaks and other memory access issues.

v1->v2:
  - don't add ASAN flavor, but allow extra flags for build (Alexei);
  - fix few more found issues, which somehow were missed first time.

Andrii Nakryiko (11):
  selftests/bpf: ensure test flavors use correct skeletons
  selftests/bpf: add SAN_CFLAGS param to selftests build to allow
    sanitizers
  selftests/bpf: convert test_hashmap into test_progs test
  libbpf: fix memory leak and possible double-free in hashmap__clear
  selftests/bpf: fix memory leak in test selector
  selftests/bpf: fix memory leak in extract_build_id()
  selftests/bpf: fix invalid memory reads in core_relo selftest
  libbpf: fix huge memory leak in libbpf_find_vmlinux_btf_id()
  selftests/bpf: disable ASAN instrumentation for mmap()'ed memory read
  selftests/bpf: fix bpf_link leak in ns_current_pid_tgid selftest
  selftests/bpf: add runqslower binary to .gitignore

 tools/lib/bpf/hashmap.c                       |   7 +
 tools/lib/bpf/libbpf.c                        |   5 +-
 tools/testing/selftests/bpf/.gitignore        |   4 +-
 tools/testing/selftests/bpf/Makefile          |  11 +-
 .../selftests/bpf/prog_tests/core_reloc.c     |   2 +-
 .../{test_hashmap.c =3D> prog_tests/hashmap.c}  | 280 +++++++++---------
 .../bpf/prog_tests/ns_current_pid_tgid.c      |   5 +-
 .../selftests/bpf/prog_tests/perf_buffer.c    |   5 +
 tools/testing/selftests/bpf/test_progs.c      |  21 +-
 9 files changed, 181 insertions(+), 159 deletions(-)
 rename tools/testing/selftests/bpf/{test_hashmap.c =3D> prog_tests/hashm=
ap.c} (53%)

--=20
2.24.1

