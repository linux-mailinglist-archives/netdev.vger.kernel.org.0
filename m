Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BFC24C837
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgHTXM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:12:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59538 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728631AbgHTXM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:12:58 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KNAxZq017476
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:12:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=UjiYYODqTU9DVS54QS0wa1xD4O6cpO9DsOp5tF2t1iU=;
 b=ovSt14daOWvg6AflIg313KyvwXXZ12p3kAGxW+xP1707zHurM0KsmVS0iGWet/mKZqnE
 Tve8GmiD3lvZeky79YQC976MIb8BGhZtwLtF/DUhLMBiDsQtbk0fzNtehQu/wPEQJu3q
 FawFKYDwjfOjM0+WgWmZoQ9Qz3sRclwL2L0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3s7xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:12:57 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 16:12:56 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0CCC22EC5F42; Thu, 20 Aug 2020 16:12:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 00/16] Add libbpf full support for BPF-to-BPF calls
Date:   Thu, 20 Aug 2020 16:12:34 -0700
Message-ID: <20200820231250.1293069-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_07:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=842
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=8 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, libbpf supports a limited form of BPF-to-BPF subprogram calls.=
 The
restriction is that entry-point BPF program should use *all* of defined
sub-programs in BPF .o file. If any of the subprograms is not used, such
entry-point BPF program will be rejected by verifier as containing unreac=
hable
dead code. This is not a big limitation for cases with single entry-point=
 BPF
programs, but is quite a havy restriction for multi-programs that use onl=
y
partially overlapping set of subprograms.

This patch sets removes all such restrictions and adds complete support f=
or
using BPF sub-program calls on BPF side. This is achieved through libbpf
tracking subprograms individually and detecting which subprograms are use=
d by
any given entry-point BPF program, and subsequently only appending and
relocating code for just those used subprograms.

In addition, libbpf now also supports multiple entry-point BPF programs w=
ithin
the same ELF section. This allows to structure code so that there are few
variants of BPF programs of the same type and attaching to the same targe=
t
(e.g., for tracepoints and kprobes) without the need to worry about ELF
section name clashes.

This patch set opens way for more wider adoption of BPF subprogram calls,
especially for real-world production use-cases with complicated net of
subprograms. This will allow to further scale BPF verification process th=
rough
good use of global functions, which can be verified independently. This i=
s
also important prerequisite for static linking which allows static BPF
libraries to not worry about naming clashes for section names, as well as=
 use
static non-inlined functions (subprograms) without worries of verifier
rejecting program due to dead code.

Patch set is structured as follows:
- patches 1-5 contain various smaller improvements to logging and selftes=
ts;
- patched 6-11 contain all the libbpf changes necessary to support multi-=
prog
  sections and bpf2bpf subcalls;
- patch 12 adds dedicated selftests validating all combinations of possib=
le
  sub-calls (within and across sections, static vs global functions);
- patch 13 deprecated bpf_program__title() in favor of
  bpf_program__section_name(). The intent was to also deprecate
  bpf_object__find_program_by_title() as it's now non-sensical with multi=
ple
  programs per section. But there were too many selftests uses of this an=
d
  I didn't want to delay this patches further and make it even bigger, so=
 left
  it for a follow up cleanup;
- patches 14-15 remove uses for title-related APIs from bpftool and
  bpf_program__title() use from selftests;
- patch 16 is converting fexit_bpf2bpf to have explicit subtest (it does
  contain 4 subtests, which are not handled as sub-tests).
=20
Andrii Nakryiko (16):
  selftests/bpf: BPF object files should depend only on libbpf headers
  libbpf: factor out common ELF operations and improve logging
  libbpf: add __noinline macro to bpf_helpers.h
  libbpf: skip well-known ELF sections when iterating ELF
  libbpf: normalize and improve logging across few functions
  libbpf: ensure ELF symbols table is found before further ELF
    processing
  libbpf: parse multi-function sections into multiple BPF programs
  libbpf: support CO-RE relocations for multi-prog sections
  libbpf: make RELO_CALL work for multi-prog sections and sub-program
    calls
  libbpf: implement generalized .BTF.ext func/line info adjustment
  libbpf: add multi-prog section support for struct_ops
  selftests/bpf: add selftest for multi-prog sections and bpf-to-bpf
    calls
  tools/bpftool: replace bpf_program__title() with
    bpf_program__section_name()
  selftests/bpf: don't use deprecated libbpf APIs
  libbpf: deprecate notion of BPF program "title" in favor of "section
    name"
  selftests/bpf: turn fexit_bpf2bpf into test with subtests

 tools/bpf/bpftool/prog.c                      |    4 +-
 tools/lib/bpf/bpf_helpers.h                   |    3 +
 tools/lib/bpf/btf.h                           |   18 +-
 tools/lib/bpf/libbpf.c                        | 1695 ++++++++++-------
 tools/lib/bpf/libbpf.h                        |    5 +-
 tools/lib/bpf/libbpf.map                      |    5 +
 tools/lib/bpf/libbpf_common.h                 |    2 +
 tools/testing/selftests/bpf/Makefile          |    2 +-
 .../selftests/bpf/flow_dissector_load.h       |    8 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |   12 +-
 .../bpf/prog_tests/reference_tracking.c       |    2 +-
 .../selftests/bpf/prog_tests/subprogs.c       |   31 +
 .../selftests/bpf/progs/test_subprogs.c       |   92 +
 .../selftests/bpf/test_socket_cookie.c        |    2 +-
 14 files changed, 1218 insertions(+), 663 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/subprogs.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subprogs.c

--=20
2.24.1

