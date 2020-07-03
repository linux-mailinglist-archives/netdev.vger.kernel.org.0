Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64D521380A
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 11:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgGCJv0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Jul 2020 05:51:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37486 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725796AbgGCJvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 05:51:25 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-szJDNIuGMyuT3Wq-PL38Mg-1; Fri, 03 Jul 2020 05:51:19 -0400
X-MC-Unique: szJDNIuGMyuT3Wq-PL38Mg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24F91186A206;
        Fri,  3 Jul 2020 09:51:17 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD3C29CA0;
        Fri,  3 Jul 2020 09:51:12 +0000 (UTC)
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
Subject: [PATCH v5 bpf-next 0/9] bpf: Add d_path helper - preparation changes
Date:   Fri,  3 Jul 2020 11:51:02 +0200
Message-Id: <20200703095111.3268961-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
this patchset does preparation work for adding d_path helper,
which still needs more work, but the initial set of patches
is ready and useful to have.

This patchset adds:
  - support to generate BTF ID lists that are resolved during
    kernel linking and usable within kernel code with following
    macros:

      BTF_ID_LIST(bpf_skb_output_btf_ids)
      BTF_ID(struct, sk_buff)

    and access it in kernel code via:
      extern u32 bpf_skb_output_btf_ids[];

  - resolve_btfids tool that scans elf object for .BTF_ids
    section and resolves its symbols with BTF ID values
  - resolving of bpf_ctx_convert struct and several other
    objects with BTF_ID_LIST


v5 changes:
  - added acks to patches I did not change in this version
  - split the original patchset into 2 parts and sending the first one
    where the support to define BTF list is added, the BTF set support
    will be posted later on [Andrii]
  - used u32 instead of int in btf_ids.h [Andrii]
  - changed the btf_ids.h define guard [Andrii]
  - added resolve_btfids_clean target [Andrii]
  - moved resolve_btfids test into prog_tests suite [Andrii]
  - fixed BTF type iteration index in test [Andrii]
  - removed btf_id checks in bpf_ctx_convert resolve code [Yonghong]
  - removed WARN_ON_ONCE from btf_resolve_helper_id [Yonghong]
  - added BTF_ID_UNUSED macro [Yonghong]
  - fixed out of the tree build failure [0day bot]

Also available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/d_path

thanks,
jirka


---
Jiri Olsa (9):
      bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object
      bpf: Compile resolve_btfids tool at kernel compilation start
      bpf: Add BTF_ID_LIST/BTF_ID/BTF_ID_UNUSED macros
      bpf: Resolve BTF IDs in vmlinux image
      bpf: Remove btf_id helpers resolving
      bpf: Use BTF_ID to resolve bpf_ctx_convert struct
      bpf: Add info about .BTF.ids section to btf.rst
      tools headers: Adopt verbatim copy of btf_ids.h from kernel sources
      selftests/bpf: Add test for resolve_btfids

 Documentation/bpf/btf.rst                               |  36 +++++
 Makefile                                                |  25 +++-
 include/asm-generic/vmlinux.lds.h                       |   4 +
 include/linux/btf_ids.h                                 |  87 ++++++++++++
 kernel/bpf/btf.c                                        | 103 ++------------
 kernel/trace/bpf_trace.c                                |   9 +-
 net/core/filter.c                                       |   9 +-
 scripts/link-vmlinux.sh                                 |   6 +
 tools/Makefile                                          |   3 +
 tools/bpf/Makefile                                      |   9 +-
 tools/bpf/resolve_btfids/Build                          |  26 ++++
 tools/bpf/resolve_btfids/Makefile                       |  77 +++++++++++
 tools/bpf/resolve_btfids/main.c                         | 716 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/include/linux/btf_ids.h                           |  87 ++++++++++++
 tools/include/linux/compiler.h                          |   4 +
 tools/testing/selftests/bpf/Makefile                    |  22 ++-
 tools/testing/selftests/bpf/prog_tests/resolve_btfids.c | 170 +++++++++++++++++++++++
 17 files changed, 1289 insertions(+), 104 deletions(-)
 create mode 100644 include/linux/btf_ids.h
 create mode 100644 tools/bpf/resolve_btfids/Build
 create mode 100644 tools/bpf/resolve_btfids/Makefile
 create mode 100644 tools/bpf/resolve_btfids/main.c
 create mode 100644 tools/include/linux/btf_ids.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/resolve_btfids.c

