Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3D92434AE
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 09:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgHMHRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 03:17:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34666 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726224AbgHMHRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 03:17:32 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07D7Es5M002125
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 00:17:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=paUf0/V/leLdAL4wM36Ts0KSKkUM8cGSC8otLvQHEmI=;
 b=kdoNlDwzSkIu5uuDKC/6ER5+95NkGqAprSjhPOKFipeuSgX1a9Rq8r1wUus1yrKo231V
 DvxY6TUtJtjPM+YWSjnB4JAFALkVkOSbLPGF3nYeSle/sx6KvOx9A+0J/z7u8EvuwCXi
 QqASfgSj88VRdHVhtKeybe3bR9aZ7N7Y2TY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32v0kd8e8g-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 00:17:31 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 13 Aug 2020 00:17:29 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E2A502EC5928; Thu, 13 Aug 2020 00:17:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 0/9] Fix various issues with 32-bit libbpf
Date:   Thu, 13 Aug 2020 00:17:13 -0700
Message-ID: <20200813071722.2213397-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_04:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=8 lowpriorityscore=0 bulkscore=0 mlxlogscore=990
 clxscore=1015 mlxscore=0 adultscore=0 priorityscore=1501 spamscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008130055
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

This series is really a mix of bpf tree fixes and patches that are better
landed into bpf-next, once it opens. This is due to a bit riskier changes=
 and
new APIs added to allow solving this 32/64-bit mix problem. It would be g=
reat
to apply patches #1 through #3 to bpf tree right now, and the rest into
bpf-next, but I would appreciate reviewing all of them, of course.

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
 tools/bpf/bpftool/prog.c                      | 16 ++---
 tools/lib/bpf/btf.c                           | 71 ++++++++++++++++++-
 tools/lib/bpf/btf.h                           |  2 +
 tools/lib/bpf/btf_dump.c                      |  4 +-
 tools/lib/bpf/libbpf.c                        | 20 ++++--
 tools/lib/bpf/libbpf.map                      |  2 +
 .../selftests/bpf/prog_tests/bpf_obj_id.c     |  8 +--
 .../selftests/bpf/prog_tests/btf_dump.c       | 27 +++++--
 .../selftests/bpf/prog_tests/core_extern.c    |  4 +-
 .../selftests/bpf/prog_tests/core_reloc.c     | 20 +++---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |  6 +-
 .../selftests/bpf/prog_tests/flow_dissector.c |  2 +-
 .../selftests/bpf/prog_tests/global_data.c    |  6 +-
 .../selftests/bpf/prog_tests/prog_run_xattr.c |  2 +-
 .../selftests/bpf/prog_tests/skb_ctx.c        |  2 +-
 .../testing/selftests/bpf/prog_tests/varlen.c |  8 +--
 .../selftests/bpf/progs/core_reloc_types.h    | 69 +++++++++---------
 .../testing/selftests/bpf/progs/test_varlen.c |  6 +-
 tools/testing/selftests/bpf/test_btf.c        |  8 +--
 tools/testing/selftests/bpf/test_progs.h      |  5 ++
 24 files changed, 221 insertions(+), 97 deletions(-)

--=20
2.24.1

