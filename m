Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16367258554
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 03:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgIABuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 21:50:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41916 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbgIABuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 21:50:09 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0811nNSe011717
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Tn9kbjor7JCXB+E1hJYuKek36wNObuVYYEln4h0RKl8=;
 b=UcFytlJ7a9c7WsiaaM0Q6YVP4jk0iR/P8p91eNxjOIb2v0BCjSmMkrWzFR6JWlh8L02+
 ND+VDDu5OjFf4IHDkUqAiaSFMd3PakxkfNFl0YGDDa459vwLi/CIiS+Kja+afNbk2ply
 vfxmb58NKMzF+B5NX3t1c8tx4rnf6/zzZhM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33879ng0rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:08 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 18:50:08 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2D7182EC663B; Mon, 31 Aug 2020 18:50:05 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 00/14] Add libbpf full support for BPF-to-BPF calls
Date:   Mon, 31 Aug 2020 18:49:49 -0700
Message-ID: <20200901015003.2871861-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_01:2020-08-31,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=817 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 mlxscore=0
 clxscore=1015 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009010014
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
programs, but is quite a heavy restriction for multi-programs that use on=
ly
partially overlapping set of subprograms.

This patch set removes all such restrictions and adds complete support fo=
r
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
- patched 1-6 contain all the libbpf changes necessary to support multi-p=
rog
  sections and bpf2bpf subcalls;
- patch 7 adds dedicated selftests validating all combinations of possibl=
e
  sub-calls (within and across sections, static vs global functions);
- patch 8 deprecated bpf_program__title() in favor of
  bpf_program__section_name(). The intent was to also deprecate
  bpf_object__find_program_by_title() as it's now non-sensical with multi=
ple
  programs per section. But there were too many selftests uses of this an=
d
  I didn't want to delay this patches further and make it even bigger, so=
 left
  it for a follow up cleanup;
- patches 9-10 remove uses for title-related APIs from bpftool and
  bpf_program__title() use from selftests;
- patch 11 is converting fexit_bpf2bpf to have explicit subtest (it does
  contain 4 subtests, which are not handled as sub-tests);
- patches 12-14 convert few complicated BPF selftests to use __noinline
  functions to further validate correctness of libbpf's bpf2bpf processin=
g
  logic.
=20
v1->v2:
  - rename DEPRECATED to LIBBPF_DEPRECATED to avoid name clashes;
  - fix test_subprogs build;
  - convert a bunch of complicated selftests to __noinline (Alexei).

Andrii Nakryiko (14):
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
  selftests/bpf: convert pyperf, strobemeta, and l4lb_noinline to
    __noinline
  selftests/bpf: modernize xdp_noinline test w/ skeleton and __noinline
  selftests/bpf: convert cls_redirect selftest to use __noinline

 tools/bpf/bpftool/prog.c                      |    4 +-
 tools/lib/bpf/btf.h                           |   18 +-
 tools/lib/bpf/libbpf.c                        | 1198 +++++++++++------
 tools/lib/bpf/libbpf.h                        |    5 +-
 tools/lib/bpf/libbpf.map                      |    1 +
 tools/lib/bpf/libbpf_common.h                 |    2 +
 .../selftests/bpf/flow_dissector_load.h       |    8 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |   21 +-
 .../selftests/bpf/prog_tests/l4lb_all.c       |    9 +-
 .../bpf/prog_tests/reference_tracking.c       |    2 +-
 .../selftests/bpf/prog_tests/subprogs.c       |   31 +
 .../selftests/bpf/prog_tests/xdp_noinline.c   |   49 +-
 tools/testing/selftests/bpf/progs/pyperf.h    |   10 +-
 .../testing/selftests/bpf/progs/strobemeta.h  |   15 +-
 .../selftests/bpf/progs/test_cls_redirect.c   |   99 +-
 .../selftests/bpf/progs/test_l4lb_noinline.c  |   41 +-
 .../selftests/bpf/progs/test_subprogs.c       |  103 ++
 .../selftests/bpf/progs/test_xdp_noinline.c   |   36 +-
 .../selftests/bpf/test_socket_cookie.c        |    2 +-
 19 files changed, 1054 insertions(+), 600 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/subprogs.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subprogs.c

--=20
2.24.1

