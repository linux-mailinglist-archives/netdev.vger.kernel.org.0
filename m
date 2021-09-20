Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D04E411698
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhITORG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbhITOQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:16:59 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F373C061574;
        Mon, 20 Sep 2021 07:15:32 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h3so17485931pgb.7;
        Mon, 20 Sep 2021 07:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QKSUQraS6iuG2zJuLzmHU4cr6K2UGSWLQeXVqO8AWbw=;
        b=Jp9iBtsrFlKOXP2h4aJuBhosmJLShS/J8XbzOnKUHpdVjehiVvoYV2zPaEOvfVpCuL
         DkGqCTNYMaWerCaNcHKd8ajTyB6jzPWlj8bYFXr3EEruNL6X+M6M+80ow4EPfW63zJud
         kkHaHe82h+xJFm6mgEXd6nZQLNS4LZv5C8zMUom3Zt8+6V1/qdE/gJ2+8PcmtReJ/WsX
         nE93DJlq8nBDinLdXRZ+dUCONmWefd3EIZfUGbjYRbg+wFXtE0tkOWWZeolwFnXBoNpf
         OdAmb/vl33tXuyaXDszy5XDYXSpEzCPY3aI/ocJHPz8HZhE02F9WesWUMb4Kcwppi62/
         7s1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QKSUQraS6iuG2zJuLzmHU4cr6K2UGSWLQeXVqO8AWbw=;
        b=JthgeR263kvfPHvlTidT0uQoSt3BkuMRXfxknlhjIF6TJVxJKSKmeVmEcq6easwKis
         x0UyGzwJhKxGl7vTGsXOxn3a6AVYayOqOYSrH7GShpZxjBLPrZ0QlKxw/GRruZl85ZfG
         I//5JWJ3huUq796CC2D33F1q+ahr0BAiUG9QppkSUSY57v/f8Y5c1EpsD1unInzCK5cl
         vbITYX3JtFv9gERjwyVvB1agaemDaXMFEm1d3L77G/zHDcRc/+tMDkLBwtURVE/Ri1T+
         KMVtis2jDrgkY7Tvtii6JP3GHRP1bCmnC/LjWSLnKqSBEjLllmp9pKUXHpffny1nn5Kn
         OKlA==
X-Gm-Message-State: AOAM533EBu0GcKUgdQjCJQPskkJ6Nr0cNlPHypK+ZIa2H5yq7mO79P8O
        fecRvM9lN+4n/49iWjIpiqN0bWKOSZUcew==
X-Google-Smtp-Source: ABdhPJxv1Vv43vQ9BXK+lAwNISvxmYCpPIjqnjnbAPW8VVpkhDp4rl8rFeRjSclzAWnI7v/ml20nTw==
X-Received: by 2002:a63:8c50:: with SMTP id q16mr10057464pgn.315.1632147331530;
        Mon, 20 Sep 2021 07:15:31 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id v9sm15590120pga.82.2021.09.20.07.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:15:31 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 00/11] Support kernel module function calls from eBPF
Date:   Mon, 20 Sep 2021 19:45:15 +0530
Message-Id: <20210920141526.3940002-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5125; h=from:subject; bh=fc6S96SkwpVg0narLCcJASaAPTiomC+NYhFq1Ws1Vwo=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhSJaDElvTdex9z90BKxo1fes7ZuFFcIOnYdtPE4Oi XamN9FqJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUiWgwAKCRBM4MiGSL8RynUqD/ 4iG2hBK6gOBjeNjbypeHsiKV8ZZUUejX2e2p2Z3KityM03c1EUUmT6tvJ3jU3dV9lU7fl93OD+VO2I /HkwG2arvHrjOI7A4QHN4MtIFkqL/UuxEYO+0k82nmLfTNXcgjwA+r89r7cPBE9XD9fwv20ZiIX8+y /luYLU/94qAN/a3xFcpi1rYToQ9Xe9MtPGoxUOxTOZTq+imhVHoAoY01hDZ72URZgdiIWmexfJ6HAK qY7jgk4QDA8We4Q0DkRnozEVNGYKy1vESCpev1mFp0TiNfRQA1b7Zedb34izokT95lIatmIVQYFlJl s5plWNfN6Ema4Cyeu0E8nxk51lyfYGbyx8XtCBWGRP4lbgyaJOb/FLZ0Zl2ji/UPu7rYKeJpjtMbxm d/kAQJJC856XswkddKMPGkBfrq5IMVYi4nnVE/+EGkGwXts/45raSTn+j8tW9Z90wj1p1CezSh8fRy UV8jakvTBFbVJHaD2hehnj8cFltF4RBGADjP5vrAZHRN87W8eHkoHt5tCjQMghqlyPaL0sDSeOgmCM LcKyUDFvo2x3AER0L/v+2byu/PuBb6CUhwxDHDMkgD4koX3GG0F0IfsOibHTRCPTFOqhRBNxvOgTQ0 PD/sx+v3GP44RQ1CIhJq++2u3FJCp+bn0HkofFLUS44+6DE7jZxAedYi31nw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set enables kernel module function calls, and also modifies verifier logic
to permit invalid kernel function calls as long as they are pruned as part of
dead code elimination. This is done to provide better runtime portability for
BPF objects, which can conditionally disable parts of code that are pruned later
by the verifier (e.g. const volatile vars, kconfig options). libbpf
modifications are made along with kernel changes to support module function
calls. The set includes gen_loader support for emitting kfunc relocations.

It also converts TCP congestion control objects to use the module kfunc support
instead of relying on IS_BUILTIN ifdef.

Changelog:
----------
v3 -> v4
v3: https://lore.kernel.org/bpf/20210915050943.679062-1-memxor@gmail.com

 * Address comments from Alexei
   * Drop MAX_BPF_STACK change, instead move map_fd and BTF fd to BPF array map
     and pass fd_array using BPF_PSEUDO_MAP_IDX_VALUE
 * Address comments from Andrii
   * Fix selftest to store to variable for observing function call instead of
     printk and polluting CI logs
 * Drop use of raw_tp for testing, instead reuse classifier based prog_test_run
 * Drop index + 1 based insn->off convention for kfunc module calls
 * Expand selftests to cover more corner cases
 * Misc cleanups

v2 -> v3
v2: https://lore.kernel.org/bpf/20210914123750.460750-1-memxor@gmail.com

 * Fix issues pointed out by Kernel Test Robot
 * Fix find_kfunc_desc to also take offset into consideration when comparing

RFC v1 -> v2
v1: https://lore.kernel.org/bpf/20210830173424.1385796-1-memxor@gmail.com

 * Address comments from Alexei
   * Reuse fd_array instead of introducing kfunc_btf_fds array
   * Take btf and module reference as needed, instead of preloading
   * Add BTF_KIND_FUNC relocation support to gen_loader infrastructure
 * Address comments from Andrii
   * Drop hashmap in libbpf for finding index of existing BTF in fd_array
   * Preserve invalid kfunc calls only when the symbol is weak
 * Adjust verifier selftests

Kumar Kartikeya Dwivedi (11):
  bpf: Introduce BPF support for kernel module function calls
  bpf: Be conservative while processing invalid kfunc calls
  bpf: btf: Introduce helpers for dynamic BTF set registration
  tools: Allow specifying base BTF file in resolve_btfids
  bpf: Enable TCP congestion control kfunc from modules
  libbpf: Support kernel module function calls
  libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
  libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
  tools: bpftool: Add separate fd_array map support for light skeleton
  libbpf: Fix skel_internal.h to set errno on loader retval < 0
  bpf: selftests: Add selftests for module kfunc support

 include/linux/bpf.h                           |   8 +-
 include/linux/bpf_verifier.h                  |   2 +
 include/linux/bpfptr.h                        |   1 +
 include/linux/btf.h                           |  37 +++
 kernel/bpf/btf.c                              |  56 +++++
 kernel/bpf/core.c                             |   4 +
 kernel/bpf/verifier.c                         | 220 ++++++++++++++---
 net/bpf/test_run.c                            |   7 +-
 net/ipv4/bpf_tcp_ca.c                         |  36 +--
 net/ipv4/tcp_bbr.c                            |  28 ++-
 net/ipv4/tcp_cubic.c                          |  26 +-
 net/ipv4/tcp_dctcp.c                          |  26 +-
 scripts/Makefile.modfinal                     |   1 +
 tools/bpf/bpftool/gen.c                       |   3 +-
 tools/bpf/bpftool/prog.c                      |   1 +
 tools/bpf/resolve_btfids/main.c               |  19 +-
 tools/lib/bpf/bpf.c                           |   1 +
 tools/lib/bpf/bpf_gen_internal.h              |  16 +-
 tools/lib/bpf/gen_loader.c                    | 222 +++++++++++++++---
 tools/lib/bpf/libbpf.c                        |  83 +++++--
 tools/lib/bpf/libbpf.h                        |   1 +
 tools/lib/bpf/libbpf_internal.h               |   1 +
 tools/lib/bpf/skel_internal.h                 |  33 ++-
 tools/testing/selftests/bpf/Makefile          |   5 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  26 +-
 .../selftests/bpf/prog_tests/ksyms_module.c   |  52 ++--
 .../bpf/prog_tests/ksyms_module_libbpf.c      |  44 ++++
 .../selftests/bpf/progs/test_ksyms_module.c   |  41 +++-
 .../bpf/progs/test_ksyms_module_fail.c        |  29 +++
 .../progs/test_ksyms_module_fail_toomany.c    |  19 ++
 .../bpf/progs/test_ksyms_module_libbpf.c      |  71 ++++++
 .../bpf/progs/test_ksyms_module_util.h        |  48 ++++
 32 files changed, 1014 insertions(+), 153 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_fail_toomany.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_util.h

-- 
2.33.0

