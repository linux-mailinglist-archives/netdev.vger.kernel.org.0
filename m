Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581C420A807
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407463AbgFYWNU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 18:13:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54034 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404284AbgFYWNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 18:13:18 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-sShIDDoUPDaa4RAhz2TmdQ-1; Thu, 25 Jun 2020 18:13:12 -0400
X-MC-Unique: sShIDDoUPDaa4RAhz2TmdQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13519804001;
        Thu, 25 Jun 2020 22:13:10 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3EFC7932F;
        Thu, 25 Jun 2020 22:13:05 +0000 (UTC)
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
Subject: [PATCH v4 bpf-next 00/14] bpf: Add d_path helper
Date:   Fri, 26 Jun 2020 00:12:50 +0200
Message-Id: <20200625221304.2817194-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

In a preparation for that, this patchset also adds support for BTF ID
whitelists, because d_path can't be called from any probe due to its
locks usage. The whitelists allow verifier to check if the caller is
one of the functions from the whitelist.

The whitelist is implemented in a generic way. This patchset introduces
macros that allow to define lists of BTF IDs, which are compiled in
the kernel image in a new .BTF.ids ELF section.

The generic way of BTF ID lists allows us to use them in other places
in kernel (than just for whitelists), that could use static BTF ID
values compiled in and it's also implemented in this patchset.

I originally added and used 'file_path' helper, which did the same,
but used 'struct file' object. Then realized that file_path is just
a wrapper for d_path, so we'd cover more calling sites if we add
d_path helper and allowed resolving BTF object within another object,
so we could call d_path also with file pointer, like:

  bpf_d_path(&file->f_path, buf, size);

This feature is mainly to be able to add dpath (filepath originally)
function to bpftrace:

  # bpftrace -e 'kfunc:vfs_open { printf("%s\n", dpath(args->path)); }'

v4 changes:
  - added ID sanity checks in btf_resolve_helper_id [Andrii]
  - resolve bpf_ctx_convert via BTF_ID [Andrii]
  - keep bpf_access_type in btf_struct_access [Andrii]
  - rename whitelist to se and use struct btf_id_set [Andrii]
  - several fixes for d_path prog/verifier tests [Andrii]
  - added union and typedefs types support [Andrii]
  - rename btfid to resolve_btfids [Andrii]
  - fix segfault in resolve_btfids [John]
  - rename section from .BTF_ids .BTF.ids (following .BTF.ext example)
  - add .BTF.ids section info into btf.rst [John]
  - updated over letter with more details [John]

Also available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/d_path

thanks,
jirka


---
Jiri Olsa (14):
      bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object
      bpf: Compile resolve_btfids tool at kernel compilation start
      bpf: Add BTF_ID_LIST/BTF_ID macros
      bpf: Resolve BTF IDs in vmlinux image
      bpf: Remove btf_id helpers resolving
      bpf: Use BTF_ID to resolve bpf_ctx_convert struct
      bpf: Allow nested BTF object to be refferenced by BTF object + offset
      bpf: Add BTF_SET_START/END macros
      bpf: Add info about .BTF.ids section to btf.rst
      bpf: Add d_path helper
      tools headers: Adopt verbatim copy of btf_ids.h from kernel sources
      selftests/bpf: Add verifier test for d_path helper
      selftests/bpf: Add test for d_path helper
      selftests/bpf: Add test for resolve_btfids

 Documentation/bpf/btf.rst                         |  53 ++++++++
 Makefile                                          |  25 +++-
 include/asm-generic/vmlinux.lds.h                 |   4 +
 include/linux/bpf.h                               |   7 +
 include/linux/btf_ids.h                           | 108 ++++++++++++++++
 include/uapi/linux/bpf.h                          |  14 +-
 kernel/bpf/btf.c                                  | 169 ++++++++++++------------
 kernel/bpf/verifier.c                             |  42 ++++--
 kernel/trace/bpf_trace.c                          |  56 +++++++-
 net/core/filter.c                                 |   9 +-
 scripts/bpf_helpers_doc.py                        |   2 +
 scripts/link-vmlinux.sh                           |   6 +
 tools/Makefile                                    |   3 +
 tools/bpf/Makefile                                |   5 +-
 tools/bpf/resolve_btfids/Build                    |  26 ++++
 tools/bpf/resolve_btfids/Makefile                 |  76 +++++++++++
 tools/bpf/resolve_btfids/main.c                   | 716 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/include/linux/btf_ids.h                     | 108 ++++++++++++++++
 tools/include/linux/compiler.h                    |   4 +
 tools/include/uapi/linux/bpf.h                    |  14 +-
 tools/testing/selftests/bpf/Makefile              |  20 ++-
 tools/testing/selftests/bpf/prog_tests/d_path.c   | 145 +++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_d_path.c   |  50 +++++++
 tools/testing/selftests/bpf/test_resolve_btfids.c | 201 +++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/test_verifier.c       |  19 ++-
 tools/testing/selftests/bpf/verifier/d_path.c     |  37 ++++++
 26 files changed, 1806 insertions(+), 113 deletions(-)
 create mode 100644 include/linux/btf_ids.h
 create mode 100644 tools/bpf/resolve_btfids/Build
 create mode 100644 tools/bpf/resolve_btfids/Makefile
 create mode 100644 tools/bpf/resolve_btfids/main.c
 create mode 100644 tools/include/linux/btf_ids.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c
 create mode 100644 tools/testing/selftests/bpf/test_resolve_btfids.c
 create mode 100644 tools/testing/selftests/bpf/verifier/d_path.c

