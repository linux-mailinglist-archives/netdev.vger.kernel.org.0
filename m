Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255371FAD65
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgFPKF1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Jun 2020 06:05:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27344 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728153AbgFPKF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:05:26 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-OCvmRSPqMxW0ZITAZort3A-1; Tue, 16 Jun 2020 06:05:19 -0400
X-MC-Unique: OCvmRSPqMxW0ZITAZort3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98F74192FD50;
        Tue, 16 Jun 2020 10:05:17 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA17F5D98B;
        Tue, 16 Jun 2020 10:05:12 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCHv3 0/9] bpf: Add d_path helper
Date:   Tue, 16 Jun 2020 12:05:01 +0200
Message-Id: <20200616100512.2168860-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
adding d_path helper to return full path for 'path' object.

I originally added and used 'file_path' helper, which did the same,
but used 'struct file' object. Then realized that file_path is just
a wrapper for d_path, so we'd cover more calling sites if we add
d_path helper and allowed resolving BTF object within another object,
so we could call d_path also with file pointer, like:

  bpf_d_path(&file->f_path, buf, size);

This feature is mainly to be able to add dpath (filepath originally)
function to bpftrace:

  # bpftrace -e 'kfunc:vfs_open { printf("%s\n", dpath(args->path)); }'

v3 changes:
  - changed tests to use seleton and vmlinux.h [Andrii]
  - refactored to define ID lists in C object [Andrii]
  - changed btf_struct_access for nested ID check,
    instead of adding new function for that [Andrii]
  - fail build with CONFIG_DEBUG_INFO_BTF if libelf is not detected [Andrii]

Also available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/d_path

thanks,
jirka


---
Jiri Olsa (11):
      bpf: Add btfid tool to resolve BTF IDs in ELF object
      bpf: Compile btfid tool at kernel compilation start
      bpf: Add btf_ids object
      bpf: Resolve BTF IDs in vmlinux image
      bpf: Remove btf_id helpers resolving
      bpf: Do not pass enum bpf_access_type to btf_struct_access
      bpf: Allow nested BTF object to be refferenced by BTF object + offset
      bpf: Add BTF whitelist support
      bpf: Add d_path helper
      selftests/bpf: Add verifier test for d_path helper
      selftests/bpf: Add test for d_path helper

 Makefile                                        |  25 ++++-
 include/asm-generic/vmlinux.lds.h               |   4 +
 include/linux/bpf.h                             |  16 ++-
 include/uapi/linux/bpf.h                        |  14 ++-
 kernel/bpf/Makefile                             |   2 +-
 kernel/bpf/btf.c                                | 149 +++++++++++--------------
 kernel/bpf/btf_ids.c                            |  26 +++++
 kernel/bpf/btf_ids.h                            | 108 ++++++++++++++++++
 kernel/bpf/verifier.c                           |  39 +++++--
 kernel/trace/bpf_trace.c                        |  40 ++++++-
 net/core/filter.c                               |   2 -
 net/ipv4/bpf_tcp_ca.c                           |   2 +-
 scripts/bpf_helpers_doc.py                      |   2 +
 scripts/link-vmlinux.sh                         |   6 +
 tools/Makefile                                  |   3 +
 tools/bpf/Makefile                              |   5 +-
 tools/bpf/btfid/Build                           |  26 +++++
 tools/bpf/btfid/Makefile                        |  71 ++++++++++++
 tools/bpf/btfid/btfid.c                         | 627 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h                  |  14 ++-
 tools/testing/selftests/bpf/prog_tests/d_path.c | 153 +++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_d_path.c |  55 +++++++++
 tools/testing/selftests/bpf/test_verifier.c     |  13 ++-
 tools/testing/selftests/bpf/verifier/d_path.c   |  38 +++++++
 24 files changed, 1329 insertions(+), 111 deletions(-)
 create mode 100644 kernel/bpf/btf_ids.c
 create mode 100644 kernel/bpf/btf_ids.h
 create mode 100644 tools/bpf/btfid/Build
 create mode 100644 tools/bpf/btfid/Makefile
 create mode 100644 tools/bpf/btfid/btfid.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c
 create mode 100644 tools/testing/selftests/bpf/verifier/d_path.c

