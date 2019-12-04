Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA8711231F
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 08:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfLDHAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 02:00:35 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49972 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727166AbfLDHAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 02:00:33 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB46rol2024494
        for <netdev@vger.kernel.org>; Tue, 3 Dec 2019 23:00:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=d+6s1IYBvtZskDjVq/W946pQyMYRnrEmtQ1DNdqdcOY=;
 b=TeMGMsFdZil9w+9zTK4BUF0MLbt/Dn2NeXRpKTL9sDkt4Yjmjok1IomLKRTPCp/MZhsC
 774iyqN3AzVOy1BTkgahrIF8LQgcmOwg5/goE749eWOjw7iU+8oBGANCT7uzHCYaodsx
 avGX+cW1slK919zP8xQBnQ2tbLkRZE4kMN0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wp1gx1n9q-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 23:00:32 -0800
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 3 Dec 2019 23:00:18 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id F3A732EC1853; Tue,  3 Dec 2019 23:00:17 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 00/16] Add code-generated BPF object skeleton support
Date:   Tue, 3 Dec 2019 22:59:59 -0800
Message-ID: <20191204070015.3523523-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_01:2019-12-04,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=8 bulkscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912040050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set introduces an alternative and complimentary to existing libbpf
API interface for working with BPF objects, maps, programs, and global data
from userspace side. This approach is relying on code generation. bpftool
produces a struct (a.k.a. skeleton) tailored and specific to provided BPF
object file. It includes hard-coded fields and data structures for every map,
program, link, and global data present.

Altogether this approach significantly reduces amount of userspace boilerplate
code required to open, load, attach, and work with BPF objects. It improves
attach/detach story, by providing pre-allocated space for bpf_links, and
ensuring they are properly detached on shutdown. It allows to do away with by
name/title lookups of maps and programs, because libbpf's skeleton API, in
conjunction with generated code from bpftool, is filling in hard-coded fields
with actual pointers to corresponding struct bpf_map/bpf_program/bpf_link.

Also, thanks to BPF array mmap() support, working with global data (variables)
from userspace is now as natural as it is from BPF side: each variable is just
a struct field inside skeleton struct. Furthermore, this allows to have
a natural way for userspace to pre-initialize global data (including
previously impossible to initialize .rodata) by just assigning values to the
same per-variable fields. Libbpf will carefully take into account this
initialization image, will use it to pre-populate BPF maps at creation time,
and will re-mmap() BPF map's contents at exactly the same userspace memory
address such that it can continue working with all the same pointers without
any interruptions. If kernel doesn't support mmap(), global data will still be
successfully initialized, but after map creation global data structures inside
skeleton will be NULL-ed out. This allows userspace application to gracefully
handle lack of mmap() support, if necessary.

As a demonstration of BPF CO-RE, libbpf tracing APIs, and skeleton approach
working together, runqslower tool (originally BCC-based and distributed along
with BCC) is added under samples directory. It's a complete tool with 100%
feature parity with its BCC-based counterpart. But it doesn't require neither
Python, nor Clang/LLVM runtime. It's pre-compiled and can be distributed to
target machine in a compact binary form.

A bunch of selftests are also converted to using skeletons, demonstrating
significant simplification of userspace part of test and reduction in amount
of code necessary.

Andrii Nakryiko (16):
  libbpf: don't require root for bpf_object__open()
  libbpf: add generic bpf_program__attach()
  libbpf: move non-public APIs from libbpf.h to libbpf_internal.h
  libbpf: add BPF_EMBED_OBJ macro for embedding BPF .o files
  libbpf: expose field/var declaration emitting API internally
  libbpf: expose BPF program's function name
  libbpf: refactor global data map initialization
  libbpf: postpone BTF ID finding for TRACING programs to load phase
  libbpf: reduce log level of supported section names dump
  libbpf: add experimental BPF object skeleton support
  bpftool: add skeleton codegen command
  libbpf/samples: add runqslower sample to libbpf samples
  selftests/bpf: add BPF skeletons selftests and convert attach_probe.c
  selftests/bpf: convert few more selftest to skeletons
  selftests/bpf: add test validating data section to struct convertion
    layout
  bpftool: add `gen skeleton` BASH completions

 tools/bpf/bpftool/bash-completion/bpftool     |  11 +
 tools/bpf/bpftool/gen.c                       | 482 +++++++++++++++
 tools/bpf/bpftool/main.c                      |   3 +-
 tools/bpf/bpftool/main.h                      |   1 +
 tools/bpf/bpftool/net.c                       |   1 +
 tools/lib/bpf/btf_dump.c                      |  61 +-
 tools/lib/bpf/libbpf.c                        | 583 ++++++++++++++----
 tools/lib/bpf/libbpf.h                        |  63 +-
 tools/lib/bpf/libbpf.map                      |   7 +
 tools/lib/bpf/libbpf_internal.h               |  63 ++
 tools/lib/bpf/samples/runqslower/.gitignore   |   2 +
 tools/lib/bpf/samples/runqslower/Makefile     |  50 ++
 .../bpf/samples/runqslower/runqslower.bpf.c   | 105 ++++
 tools/lib/bpf/samples/runqslower/runqslower.c | 189 ++++++
 tools/lib/bpf/samples/runqslower/runqslower.h |  13 +
 tools/testing/selftests/bpf/.gitignore        |   2 +
 tools/testing/selftests/bpf/Makefile          |  36 +-
 .../selftests/bpf/prog_tests/attach_probe.c   | 154 +----
 .../selftests/bpf/prog_tests/fentry_fexit.c   | 105 ++--
 .../selftests/bpf/prog_tests/fentry_test.c    |  72 +--
 tools/testing/selftests/bpf/prog_tests/mmap.c |  58 +-
 .../selftests/bpf/prog_tests/probe_user.c     |   6 +-
 .../selftests/bpf/prog_tests/rdonly_maps.c    |  11 +-
 .../selftests/bpf/prog_tests/skeleton.c       |  47 ++
 .../bpf/prog_tests/stacktrace_build_id.c      |  79 +--
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |  84 +--
 .../selftests/bpf/progs/test_attach_probe.c   |  34 +-
 .../selftests/bpf/progs/test_skeleton.c       |  36 ++
 28 files changed, 1759 insertions(+), 599 deletions(-)
 create mode 100644 tools/bpf/bpftool/gen.c
 create mode 100644 tools/lib/bpf/samples/runqslower/.gitignore
 create mode 100644 tools/lib/bpf/samples/runqslower/Makefile
 create mode 100644 tools/lib/bpf/samples/runqslower/runqslower.bpf.c
 create mode 100644 tools/lib/bpf/samples/runqslower/runqslower.c
 create mode 100644 tools/lib/bpf/samples/runqslower/runqslower.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skeleton.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skeleton.c

-- 
2.17.1

