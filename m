Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72342440F2
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 23:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgHMVzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 17:55:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31694 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726205AbgHMVzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 17:55:22 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07DLniZI005108
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 14:55:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=9jFR/swBR6mIfdI4hHm84HOYzfseczN9Kk5L2k0LtvY=;
 b=D5XfHhNOpsvSOtGwaXVwpEuS4DS0UhBKsaVD61ZBcFU4wXwJfaGmiV6AY1Im/2OATDbp
 N/42wt8BppkYq6nNvoVoAON/49qIZMBRXVddCGXHvluUP6/usiB0eXff9cOmurfaT2IL
 encD5ZnIHfg5U5IjbMK7xOolwuj26bTClcQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32v0khc5s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 14:55:21 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 13 Aug 2020 14:55:20 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1F7F12EC597F; Thu, 13 Aug 2020 13:49:51 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf 0/9] Fix various issues with 32-bit libbpf
Date:   Thu, 13 Aug 2020 13:49:36 -0700
Message-ID: <20200813204945.1020225-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_17:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=8 mlxlogscore=999 priorityscore=1501
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008130155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set contains fixes to libbpf, bpftool, and selftests that were
found while testing libbpf and selftests built in 32-bit mode. 64-bit nat=
ure
of BPF target and 32-bit host environment don't always mix together well
without extra care, so there were a bunch of problems discovered and fixe=
d.

Each individual patch contains additional explanations, where necessary.

v2->v3:
  - don't give up if failed to determine ELF class;
v1->v2:
  - guess_ptr_sz -> determine_ptr_sz as per Alexei;
  - added pointer size determination by ELF class.

Andrii Nakryiko (9):
  tools/bpftool: fix compilation warnings in 32-bit mode
  selftest/bpf: fix compilation warnings in 32-bit mode
  libbpf: fix BTF-defined map-in-map initialization on 32-bit host
    arches
  libbpf: handle BTF pointer sizes more carefully
  selftests/bpf: fix btf_dump test cases on 32-bit arches
  libbpf: enforce 64-bitness of BTF for BPF object files
  selftests/bpf: correct various core_reloc 64-bit assumptions
  tools/bpftool: generate data section struct with conservative
    alignment
  selftests/bpf: make test_varlen work with 32-bit user-space arch

 tools/bpf/bpftool/btf_dumper.c                |  2 +-
 tools/bpf/bpftool/gen.c                       | 14 ++++
 tools/bpf/bpftool/link.c                      |  4 +-
 tools/bpf/bpftool/main.h                      | 10 ++-
 tools/bpf/bpftool/prog.c                      | 16 ++--
 tools/lib/bpf/btf.c                           | 83 ++++++++++++++++++-
 tools/lib/bpf/btf.h                           |  2 +
 tools/lib/bpf/btf_dump.c                      |  4 +-
 tools/lib/bpf/libbpf.c                        | 20 +++--
 tools/lib/bpf/libbpf.map                      |  2 +
 .../selftests/bpf/prog_tests/bpf_obj_id.c     |  8 +-
 .../selftests/bpf/prog_tests/btf_dump.c       | 27 ++++--
 .../selftests/bpf/prog_tests/core_extern.c    |  4 +-
 .../selftests/bpf/prog_tests/core_reloc.c     | 20 ++---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |  6 +-
 .../selftests/bpf/prog_tests/flow_dissector.c |  2 +-
 .../selftests/bpf/prog_tests/global_data.c    |  6 +-
 .../selftests/bpf/prog_tests/prog_run_xattr.c |  2 +-
 .../selftests/bpf/prog_tests/skb_ctx.c        |  2 +-
 .../testing/selftests/bpf/prog_tests/varlen.c |  8 +-
 .../selftests/bpf/progs/core_reloc_types.h    | 69 ++++++++-------
 .../testing/selftests/bpf/progs/test_varlen.c |  6 +-
 tools/testing/selftests/bpf/test_btf.c        |  8 +-
 tools/testing/selftests/bpf/test_progs.h      |  5 ++
 24 files changed, 233 insertions(+), 97 deletions(-)

--=20
2.24.1

