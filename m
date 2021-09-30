Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E90C41D35A
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348340AbhI3Gbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348305AbhI3Gbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:31:33 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7958EC06161C;
        Wed, 29 Sep 2021 23:29:51 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y8so4057417pfa.7;
        Wed, 29 Sep 2021 23:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SuR2esL/DVyACI8gILFVJl3aPnvnv8X4/G5cIGEopdM=;
        b=mst7batWlDyi2OYipnKAmvwF8Hm/1qA3bjoVhrJjyD02S7JJVLrECXH2U6WpUQZd9y
         kE9Tkt5n2JJUCwAqDnmDjzYYPx0QL085dBms9mUhhNkoi+4f7u0kAb5nR55q0dinqPZl
         azuah1XYFYEwUHgvhV1efT27Sr8rUOJnbj2xNEfGdCWo2YJfDxTaY2NaQ7BdTyLkS6KP
         Y/oSydWNXbXnV14C+vBBZkqAt44QDCpOe2QlAF/UcuphOsR7BlLEInTzswWicnTqcSCp
         ZM+2KmcAqr6lBWdZJWibts1vcJDzLtI5gjOsviIqGJLQCk43ecN+yHMJPyi5VM22lVgu
         gXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SuR2esL/DVyACI8gILFVJl3aPnvnv8X4/G5cIGEopdM=;
        b=zzX3qES8r1b2QvdzIoo5rdo4USq2089IaVTYBuX8L2wP91D+AHg38n2Bxb8poKwaON
         99KMrt/FIQ1DwmyKqKE8Jku0xobdubeDEysIcbar+THXIKfCD1nQaUjcVCzFew4zdOQm
         brxqxKg2/rka/9cbV9lBfn4mxzKpynCNKPhXN8EfUQ1S4JEV7l9oO7vQBVLZiiQq3d3H
         NscMA/IS03m5nxeRULhPGDxt3q8ujfS+Y8EjnIbdk1DT0uNlhWNb3HKlZyGF0PD5IchY
         Gr1NjivUYRO05K/QO1TOTPxLJltFqAySfj88aOGVp249q2ZjHkOPQfX1RSW2kTVzcnVy
         9nwg==
X-Gm-Message-State: AOAM531xqFkEm0sEFw3afTH6KS0ejqTmFXbTqtf7qpa2sOXcJ89loqSo
        BhfBwGXyyzxXEGhofztSv3p96B4NKuU=
X-Google-Smtp-Source: ABdhPJyqiFLWm9NNbifVIuQgxFHDit8zqPF8/C6/mm2dvbbP5tP7/tY3t66mISemOZ8ffyLmY9eB+Q==
X-Received: by 2002:a62:7806:0:b0:440:448c:f662 with SMTP id t6-20020a627806000000b00440448cf662mr3865860pfc.57.1632983390630;
        Wed, 29 Sep 2021 23:29:50 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id v7sm1457000pjk.37.2021.09.29.23.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 23:29:50 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v6 0/9] Support kernel module function calls from eBPF
Date:   Thu, 30 Sep 2021 11:59:39 +0530
Message-Id: <20210930062948.1843919-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6438; h=from:subject; bh=5iV6LkgSd6UasFJhR4DyEVHb3Vub5hWO2Li2jwGi2Bg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhVVlBhnb2dzwCe0usJJPF0UK6SgnOngVjzuCOYlPI 1rUrJHmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVVZQQAKCRBM4MiGSL8Ryr2ND/ wIZBiu49PRApe1ydYz0SC4ojmlYjaI0UjZPPOXNmafqUaSSbmXeszGWNoWMX9JqnJej35Pr6QgSkd4 FbQO3w3dceQD+0ClK9PbA26IX7QASP315DpOoDaoWVADky5KDkpnnR8Zf4eLGnIGeG0h5sLBt0npRN QrfXEbOL/he47Ptd0yx3xhOD2vBhrwjVccMpW6dMDpqMCXOeGPDbYTrNZtO0enkDBSzQu9htvfVGIZ 1YNEIH6iDvWn/Nfx79cIl6NaEhJSK3Z5aHhNiFgZlVdvqLefK0OPIfo6XzLd1zcaluZEW+1MDXG3zY 81l/evapVx3nYjxR5tJu6En00erRFaL/kKMUYGtI2UihDB5/8Gf4V8+BD82cGtlLmbnQXmYdywjjvh aNNwgeoz2UabzfgN92sw2f3PztL76AhS9scbhRs5RtJ0r8O9Kog+rgQrPyyBzYRuFU0QLyLsmq6VTG RoBaT6CkyWu36ESLyQpIZ3ZihBnS/y7WJLlieNoaPGT5iEupp2x7dXuncMbOAQFtBoWQUvyHnO9suv xyIwvzWoNbd7lD1Jt2xapJtwMZT8mjUrFpv/lFHgnJfVvOQ/Bh/jqsuUKPWiQGrtQMPkVwfL2KU0L/ L5UFR9ERS9GSkOnrwMOxJ9GNtgxFcjSWgmh9jsUdcQfOm5kr8w8WOkOdMsWg==
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
calls.

It also converts TCP congestion control objects to use the module kfunc support
instead of relying on IS_BUILTIN ifdef.

Changelog:
----------
v5 -> v6
v5: https://lore.kernel.org/bpf/20210927145941.1383001-1-memxor@gmail.com

 * Rework gen_loader relocation emits
   * Only emit bpf_btf_find_by_name_kind call when required (Alexei)
   * Refactor code to emit ksym var and func relo into separate helpers, this
     will be easier to add future weak/typeless ksym support to (for my followup)
   * Count references for both ksym var and funcs, and avoid calling helpers
     unless required for both of them. This also means we share fds between
     ksym vars for the module BTFs. Also be careful with this when closing
     BTF fd so that we only close one instance of the fd for each ksym

v4 -> v5
v4: https://lore.kernel.org/bpf/20210920141526.3940002-1-memxor@gmail.com

 * Address comments from Alexei
   * Use reserved fd_array area in loader map instead of creating a new map
   * Drop selftest testing the 256 kfunc limit, however selftest testing reuse
     of BTF fd for same kfunc in gen_loader and libbpf is kept
 * Address comments from Andrii
   * Make --no-fail the default for resolve_btfids, i.e. only fail if we find
     BTF section and cannot process it
   * Use obj->btf_modules array to store index in the fd_array, so that we don't
     have to do any searching to reuse the index, instead only set it the first
     time a module BTF's fd is used
   * Make find_ksym_btf_id to return struct module_btf * in last parameter
   * Improve logging when index becomes bigger than INT16_MAX
   * Add btf__find_by_name_kind_own internal helper to only start searching for
     kfunc ID in module BTF, since find_ksym_btf_id already checks vmlinux BTF
     before iterating over module BTFs.
   * Fix various other nits
 * Fixes for failing selftests on BPF CI
 * Rearrange/cleanup selftests
   * Avoid testing kfunc limit (Alexei)
   * Do test gen_loader and libbpf BTF fd index dedup with 256 calls
   * Move invalid kfunc failure test to verifier selftest
   * Minimize duplication
 * Use consistent bpf_<type>_check_kfunc_call naming for module kfunc callback
 * Since we try to add fd using add_data while we can, cherry pick Alexei's
   patch from CO-RE RFC series to align gen_loader data.

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

Kumar Kartikeya Dwivedi (9):
  bpf: Introduce BPF support for kernel module function calls
  bpf: Be conservative while processing invalid kfunc calls
  bpf: btf: Introduce helpers for dynamic BTF set registration
  tools: Allow specifying base BTF file in resolve_btfids
  bpf: Enable TCP congestion control kfunc from modules
  libbpf: Support kernel module function calls
  libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
  libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
  bpf: selftests: Add selftests for module kfunc support

 include/linux/bpf.h                           |   8 +-
 include/linux/bpf_verifier.h                  |   2 +
 include/linux/bpfptr.h                        |   1 +
 include/linux/btf.h                           |  37 ++
 kernel/bpf/btf.c                              |  56 +++
 kernel/bpf/core.c                             |   4 +
 kernel/bpf/verifier.c                         | 220 ++++++++++--
 net/bpf/test_run.c                            |   7 +-
 net/ipv4/bpf_tcp_ca.c                         |  36 +-
 net/ipv4/tcp_bbr.c                            |  28 +-
 net/ipv4/tcp_cubic.c                          |  26 +-
 net/ipv4/tcp_dctcp.c                          |  26 +-
 scripts/Makefile.modfinal                     |   1 +
 tools/bpf/resolve_btfids/main.c               |  28 +-
 tools/lib/bpf/bpf.c                           |   1 +
 tools/lib/bpf/bpf_gen_internal.h              |  16 +-
 tools/lib/bpf/btf.c                           |  19 +-
 tools/lib/bpf/gen_loader.c                    | 323 +++++++++++++++---
 tools/lib/bpf/libbpf.c                        | 110 +++---
 tools/lib/bpf/libbpf_internal.h               |   3 +
 tools/testing/selftests/bpf/Makefile          |  10 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  23 +-
 .../selftests/bpf/prog_tests/ksyms_module.c   |  29 +-
 .../bpf/prog_tests/ksyms_module_libbpf.c      |  28 ++
 .../selftests/bpf/progs/test_ksyms_module.c   |  46 ++-
 tools/testing/selftests/bpf/verifier/calls.c  |  23 ++
 26 files changed, 912 insertions(+), 199 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c

-- 
2.33.0

