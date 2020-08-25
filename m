Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8247A251FC2
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 21:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgHYTVl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Aug 2020 15:21:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37391 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726066AbgHYTVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 15:21:41 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-x7u3CpNmO2yfhTvhXpyEoQ-1; Tue, 25 Aug 2020 15:21:34 -0400
X-MC-Unique: x7u3CpNmO2yfhTvhXpyEoQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE3F63FE7;
        Tue, 25 Aug 2020 19:21:32 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96A6819C4F;
        Tue, 25 Aug 2020 19:21:25 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH v12 bpf-next 00/14] bpf: Add d_path helper
Date:   Tue, 25 Aug 2020 21:21:10 +0200
Message-Id: <20200825192124.710397-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
adding d_path helper function that returns full path for
given 'struct path' object, which needs to be the kernel
BTF 'path' object. The path is returned in buffer provided
'buf' of size 'sz' and is zero terminated.

  long bpf_d_path(struct path *path, char *buf, u32 sz);

The helper calls directly d_path function, so there's only
limited set of function it can be called from.

The patchset also adds support to add set of BTF IDs for
a helper to define functions that the helper is allowed
to be called from.

Also available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/d_path

v12 changes:
  - added acks
  - rebased on latest bpf-next
  - reposted without RFC tag

thanks,
jirka


---
Jiri Olsa (14):
      tools resolve_btfids: Add size check to get_id function
      tools resolve_btfids: Add support for set symbols
      bpf: Move btf_resolve_size into __btf_resolve_size
      bpf: Add elem_id pointer as argument to __btf_resolve_size
      bpf: Add type_id pointer as argument to __btf_resolve_size
      bpf: Remove recursion call in btf_struct_access
      bpf: Factor btf_struct_access function
      bpf: Add btf_struct_ids_match function
      bpf: Add BTF_SET_START/END macros
      bpf: Add d_path helper
      bpf: Update .BTF_ids section in btf.rst with sets info
      selftests/bpf: Add verifier test for d_path helper
      selftests/bpf: Add test for d_path helper
      selftests/bpf: Add set test to resolve_btfids

 Documentation/bpf/btf.rst                               |  25 +++++++++++++++
 include/linux/bpf.h                                     |   6 ++++
 include/linux/btf.h                                     |   3 +-
 include/linux/btf_ids.h                                 |  51 +++++++++++++++++++++++++++++-
 include/uapi/linux/bpf.h                                |  16 +++++++++-
 kernel/bpf/bpf_struct_ops.c                             |   6 ++--
 kernel/bpf/btf.c                                        | 163 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------
 kernel/bpf/verifier.c                                   |  22 +++++++++----
 kernel/trace/bpf_trace.c                                |  48 ++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py                              |   2 ++
 tools/bpf/resolve_btfids/main.c                         |  29 +++++++++++++++--
 tools/include/linux/btf_ids.h                           |  51 +++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h                          |  16 +++++++++-
 tools/testing/selftests/bpf/prog_tests/d_path.c         | 147 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/resolve_btfids.c |  39 ++++++++++++++++++++++-
 tools/testing/selftests/bpf/progs/test_d_path.c         |  58 ++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/test_verifier.c             |  19 ++++++++++-
 tools/testing/selftests/bpf/verifier/d_path.c           |  37 ++++++++++++++++++++++
 18 files changed, 694 insertions(+), 44 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c
 create mode 100644 tools/testing/selftests/bpf/verifier/d_path.c

