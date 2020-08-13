Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09794244030
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 22:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHMU6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 16:58:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54450 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726499AbgHMU6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 16:58:40 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DKu3nj001550
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 13:58:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=O/bzyNo30iVi/kfn/8M5IRjkRIIw2PD5x+N/2VunSA0=;
 b=MHbwBEXsJKB3orBaiNk1ypnhMD/tZ2UMMOC3u8yT4OcLl6nR96qdBGS1IIgSdBjdgIAp
 iooYBcCt1iUTuJPBCFR9agShlVELUvkrxflNUgq7iEzEwdp65tn8VhIGibOHbXPnk4CN
 O2j8divRWPXbnkO3iuNS4NkancjBbLWd6gY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32v0kj3x5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 13:58:40 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 13 Aug 2020 13:58:39 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 16FA32EC596D; Thu, 13 Aug 2020 13:39:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf 0/9] Fix various issues with 32-bit libbpf
Date:   Thu, 13 Aug 2020 13:39:20 -0700
Message-ID: <20200813203930.978141-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_17:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0 suspectscore=8
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130149
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

