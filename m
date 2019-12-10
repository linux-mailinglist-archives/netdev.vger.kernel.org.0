Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E10117CEB
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 02:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfLJBOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 20:14:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6432 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727350AbfLJBOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 20:14:50 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBA1CZLc019814
        for <netdev@vger.kernel.org>; Mon, 9 Dec 2019 17:14:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=miRau5+VJsH9JKRajjt8/XhGdNhygJx0xHfmp88I5a4=;
 b=Iuf5z6agaVu5UWPfUJ39MlFng/j2W0LKAnmMTQlBLueBkuyZYWa7MEiRgacrc7J6h3Ub
 73bOcSNMacpC3Ilzf5QfZkz6HMllBWvqHp/0jXDErUu32bBrTb40Al+BXX+tQkcMxspW
 McUdWtZaJXuxw64q3Dm8VtYJdfv/OMUbrlE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2wrbemkjg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 17:14:49 -0800
Received: from intmgw001.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 9 Dec 2019 17:14:48 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CA5E92EC16B5; Mon,  9 Dec 2019 17:14:46 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 00/15] Add code-generated BPF object skeleton support
Date:   Mon, 9 Dec 2019 17:14:23 -0800
Message-ID: <20191210011438.4182911-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_05:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=8 mlxlogscore=999 priorityscore=1501 clxscore=1015
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100009
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

A bunch of selftests are also converted to using skeletons, demonstrating
significant simplification of userspace part of test and reduction in amount
of code necessary.

rfc->v1:
- runqslower moved out into separate patch set waiting for vmlinux.h
  improvements;
- skeleton generation code deals with unknown internal maps more gracefully.

Andrii Nakryiko (15):
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
  selftests/bpf: add BPF skeletons selftests and convert attach_probe.c
  selftests/bpf: convert few more selftest to skeletons
  selftests/bpf: add test validating data section to struct convertion
    layout
  bpftool: add `gen skeleton` BASH completions

 tools/bpf/bpftool/Makefile                    |   2 +-
 tools/bpf/bpftool/bash-completion/bpftool     |  11 +
 tools/bpf/bpftool/gen.c                       | 530 ++++++++++++++++
 tools/bpf/bpftool/main.c                      |   3 +-
 tools/bpf/bpftool/main.h                      |   1 +
 tools/bpf/bpftool/net.c                       |   1 +
 tools/lib/bpf/btf_dump.c                      |  61 +-
 tools/lib/bpf/libbpf.c                        | 583 ++++++++++++++----
 tools/lib/bpf/libbpf.h                        |  63 +-
 tools/lib/bpf/libbpf.map                      |   4 +
 tools/lib/bpf/libbpf_internal.h               |  61 ++
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
 24 files changed, 1444 insertions(+), 600 deletions(-)
 create mode 100644 tools/bpf/bpftool/gen.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skeleton.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skeleton.c

-- 
2.17.1

