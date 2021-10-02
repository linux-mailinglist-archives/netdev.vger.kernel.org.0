Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF3741F908
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 03:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhJBBTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 21:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbhJBBTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 21:19:46 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C25DC061775;
        Fri,  1 Oct 2021 18:18:01 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id v19so7686368pjh.2;
        Fri, 01 Oct 2021 18:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=36q/Rc88oB6ghfxjXydoE9zt1oxyMeW10mVyYFbUZaU=;
        b=nw/fb+r45ay8mCX1wJYVtT3CvOSQcffX8d462+qX6LEGeSDlQ07gAbABaYvR4rovgW
         SdjoGtZ1i2EuSaSZ/K/vsy4wH1y9jV7L772d+YhyWuw33ld89X2/yJ2jaRuL/7+6Ml+1
         wfu9Nh/9UFy46C1RE4j/foj3sdruivvFp+wwccFIKQ73AcFJ0WEQB2gLzv8Xkx32kNaH
         5eS9tY4B62WZebcxlkhRVxVZrYXJPJvx6fs1GnrgKgca2h31Z4A4J4n2gl5Dbp23ZkGE
         IO4W3FqXiKLqDgMnFQidXftW1O/Y8nNtUxcLOJIRs1dMW0YrZyykrEPU/30lbGHwSvYi
         tz6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=36q/Rc88oB6ghfxjXydoE9zt1oxyMeW10mVyYFbUZaU=;
        b=zTfrEmLt6I17MUTERB36WI2AYXVHfzWHbz5vw2JZGM2r22kPwCJ0mmEnuY+aZwdL5X
         9TUwcesx80mjFd1aNbrVWUuJH6UBu2STniWTT85bVm7B1wCp79v2ECNBpqj+rSlF+UUp
         uNf1OnKVsg1ebLVDgc1JF5eHs1c7hUTHJTyO74lNtfg7YcdPwlpZPlvSKEFFIEMWqwdC
         EeEWuOrCRLcOdCiMp0aa20wZXDNEgniD8rZee7knN9rJ4c5eCiPygocO9NRqWetIhoM0
         huit2EvIFsTXK6L1oLNYVRI1hd3HdqQ2ts5jUvDfHEr9uQMPahzw39BUmMXmUwSupAjG
         UIPg==
X-Gm-Message-State: AOAM532WMZsN0JMc1osJIbu4eeii03UuYLrAwhb+B7NLcrJvnq7174KW
        QwgkJuFLDlssirqdPuJFzlukKZfxcps=
X-Google-Smtp-Source: ABdhPJxGari5oKfCDnXFHmwxGI5bGs3FhlvQSReoWWb+mqTlqDOdfQSyYU0Zi+iKAVH3SpxQ1eunXQ==
X-Received: by 2002:a17:902:a710:b029:12b:9b9f:c461 with SMTP id w16-20020a170902a710b029012b9b9fc461mr12059299plq.59.1633137480858;
        Fri, 01 Oct 2021 18:18:00 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id c3sm7499228pgn.76.2021.10.01.18.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:18:00 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 0/9] Support kernel module function calls from eBPF
Date:   Sat,  2 Oct 2021 06:47:48 +0530
Message-Id: <20211002011757.311265-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6984; h=from:subject; bh=5Ch0XQxWvTaXZN/7hZRuLBgWCIVHlHrvggUHUb09SPo=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhV7MQqfRci9IOPmyHPUbMG8m6rCgExKjdosZMK12Q sMWEOuSJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVezEAAKCRBM4MiGSL8RylCAEA CFewMT7R1qE/5J+175dRHQx7ajXKXneAQr9/8yNFYOYsLFIyLpkwNhUgT8hMB9ezu/gd7rBAmBURA4 aqwXdSNyEuAGw86gCsGheiTv+a4iOXbuv8v6m8738zl/6iG0X/t0TSv3oEEutgLndspLolgQVaThZM BKbAT2/m7kY4HWVv86oOi0SC/Gy/7203g3YJF/wSaREPhFa04cHEeC9MD+YTfVoxROuVZIn5xhE353 HR76w55cAfLnTxsxKb21dODERzS2TSvdzpmPSkq+dNcNkOfbflOq1c6DimpFw1E8d9s20Iqpsje4P3 eukq1j3d4utCbfnX/ZoHFwKQ8YvY5Pa7FWNSwovTUKOSq9wm2A1EHOveGxZf/qd+RbilFr/+6pKLWH gWBdHz6dat/PUU9ETUcJ5fbj2OV0DdOkZUg/6ACKb1/gqlx/ZHaJMHW1yVgNdabkffI1OiAS6BKHzZ MAf82X4m5Z2/eDRPyKtn43R/VUdPWC2Bc5xEtA3SQdhbynL+Xboz2euZ/dWXDp1XZ52N8Y3YrFp9WX OK3VMi0kCx3X3dHPvj++Ci0/ET2bp89QRcQSbKKCNSJFotETcD4lplh5CAeGFqwQjThSRCsa48Tfne rNfBAWNVnZ3x3k1PGQL28rGy1krRLQzfkqaYCTppDIYLvGvugdvIer6M0cNQ==
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
v6 -> v7
v6: https://lore.kernel.org/bpf/20210930062948.1843919-1-memxor@gmail.com

 * Let __bpf_check_kfunc_call take kfunc_btf_id_list instead of generating
   callbacks (Andrii)
 * Rename it to bpf_check_mod_kfunc_call to reflect usage
 * Remove OOM checks (Alexei)
 * Remove resolve_btfids invocation for bpf_testmod (Andrii)
 * Move fd_array_cnt initialization near fd_array alloc (Andrii)
 * Rename helper to btf_find_by_name_kind and pass start_id (Andrii)
 * memset when data is NULL in add_data (Alexei)
 * Fix other nits

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
 include/linux/btf.h                           |  39 +++
 kernel/bpf/btf.c                              |  55 +++
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
 tools/lib/bpf/btf.c                           |  18 +-
 tools/lib/bpf/gen_loader.c                    | 314 +++++++++++++++---
 tools/lib/bpf/libbpf.c                        | 104 ++++--
 tools/lib/bpf/libbpf_internal.h               |   3 +
 tools/testing/selftests/bpf/Makefile          |   9 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  23 +-
 .../selftests/bpf/prog_tests/ksyms_module.c   |  29 +-
 .../bpf/prog_tests/ksyms_module_libbpf.c      |  28 ++
 .../selftests/bpf/progs/test_ksyms_module.c   |  46 ++-
 tools/testing/selftests/bpf/verifier/calls.c  |  23 ++
 26 files changed, 896 insertions(+), 199 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c

-- 
2.33.0

