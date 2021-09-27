Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2070E4196E1
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbhI0PBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbhI0PBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:01:24 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB8EC061575;
        Mon, 27 Sep 2021 07:59:46 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id g2so12013017pfc.6;
        Mon, 27 Sep 2021 07:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m+RwZlE1TfRdFyzl4vqV8idiKcqZEJlxqqylshlABQA=;
        b=T1IR7Lwn2tm0XfBHf/ufiY2LZpP/61yuc4ajPqsh+d3tQ1/ck/YFRg3RNwWU09Oi9/
         pUB7XesTKlLVjaXR3LWetJIyD3gOEbRiq1d9kqJWzqSt/sXYwdrYwDQ4ELJdjTexFbMI
         AtWyoMA2r++eQF3K/dDARZYmxQ7+NPRdroFPK+laeXxX+4n3+b7tASReLzbBhM0qhfDB
         dXgUPdWyvLdVuVrOXuGMXrtLcV8RF//J8h9yTG74pDZOc98e09Dt4OkBhZpyTZZT4Y3v
         QjFVBKhmXfQdPGcDlJgBKxpigr7486Z64+SDJkRRixDhD/nEVZwRGmb9GHlFGxu75Fej
         ANRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m+RwZlE1TfRdFyzl4vqV8idiKcqZEJlxqqylshlABQA=;
        b=IYi3Ixe8een2dVETJtpHzqKUJ1yhBCKN6Y9XY4cQdYlfrufbnVbRdzJ86DCFOWZ9lB
         wEk/IpM037Npn6Zo2+4z14aTXv7wq9TsbDYLVWFhhLj6bnTGSkV0+hoow28lobQ2zIOM
         mrljljNZ5S8sPv60SYNsN53mL5NQUsZjNSlLfZyvA9HYKSud4OtVvF2inSLFME1EIyY9
         8Rv1Tnmo71ZFCpE5dH7V72k889em4dF3R8Vfba+/60txy5HsNmMOp4+iujQyMvDJEaKf
         Iqo9c3waAJ4Htwf3pUfXNW+cLBnZH5pFLpi59w1FPrFmH1RssPyPAJQauNv1KuEFvEo8
         Ctrg==
X-Gm-Message-State: AOAM530HllSnmNOGIL3E1jM7vHNGuDu537SC5l2hrGutRE9hzPlseqpy
        nuL1F+2zuZZ9OTp4REVK7agmccEw804=
X-Google-Smtp-Source: ABdhPJxqdnASnjkHDFLEict0BDes1N6lVx/u099ou6AAslUXAd+O6yXYu0hnGK/GxKoExcEb+D4V0Q==
X-Received: by 2002:aa7:95a1:0:b0:43d:dbc5:c0af with SMTP id a1-20020aa795a1000000b0043ddbc5c0afmr101630pfk.37.1632754785947;
        Mon, 27 Sep 2021 07:59:45 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id q3sm19318492pgf.18.2021.09.27.07.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 07:59:45 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 00/12] Support kernel module function calls from eBPF
Date:   Mon, 27 Sep 2021 20:29:29 +0530
Message-Id: <20210927145941.1383001-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6157; h=from:subject; bh=03Rhe30ZtOxU1FO9morLGivR5y7v62SMP9lWkVuVUII=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhUdxOvyxifdqvGTY29i0FtjWOk/QX+ZTum0Srpsqg UV6jzDKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVHcTgAKCRBM4MiGSL8RykaOD/ 98uOmnEDlyDj8Szg6AFZieWCmv85mMqmcODOxN1U0rGLo0oTq0/put3qq4ojMAcnoXL35pPpa4D/f4 qLc+vCwoz4+hu6Hss3+KAKX3BXwLVy3HOBYUPGndJIF0NHH0DenrgZh0oQu/62ePt4QGSe23FfMWZN pEeMQO82nLloEi1VVKCsUa98Gcm6Zh7K/kjRJXIx9ZksPjRRDnNcfm+jfqK9OOy26rixF/F6N2RFts 7xILUC8WZ4hfSh5N1jA8s3upB7oeOLKEV8+Kg8xxK1pBPPpcm0ceaFtfEVr8RChg+2VoLUpXS8L95L Jnfl11J+TxG75/bkQX30sMJwvKnBlp3RtGVfvKykqKum9Nt63nBbVpjn/YiKAA1FYu9e0YEjrkiS53 3wCwbpsrW51qnjRJLuC5Oqzw9CtC0X7gKYv0hKegscoFFeWQJ4NKQxm814JYhHebSD0GRNaA483Yqp MghMPflVUKDXdYHB4bK7cuPPcnJGbe+SGhsk56nUoWEa26HWoDFJ+JlobH9rsqBaxFhrWStsye24kb KOBgCqcRbYuuyCHgL29HcHiDg9uZIXDtQ/TB3fiFJ44Ccm802yU8+2kFfEVdIQgwAV2PdleCCBRdTE 1invCv4pb+Aa+Bv2zFnlX75ylVrTT7z5M7MjOrSHHRZJFcuZi8XsrGBte8vg==
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
 * Use consistent bpf_check_<type>_kfunc_call naming for module kfunc callback
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

Alexei Starovoitov (1):
  libbpf: Make gen_loader data aligned.

Kumar Kartikeya Dwivedi (11):
  bpf: Introduce BPF support for kernel module function calls
  bpf: Be conservative while processing invalid kfunc calls
  bpf: btf: Introduce helpers for dynamic BTF set registration
  tools: Allow specifying base BTF file in resolve_btfids
  bpf: Enable TCP congestion control kfunc from modules
  libbpf: Support kernel module function calls
  libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
  libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
  libbpf: Fix skel_internal.h to set errno on loader retval < 0
  bpf: selftests: Fix fd cleanup in get_branch_snapshot
  bpf: selftests: Add selftests for module kfunc support

 include/linux/bpf.h                           |   8 +-
 include/linux/bpf_verifier.h                  |   2 +
 include/linux/bpfptr.h                        |   1 +
 include/linux/btf.h                           |  37 +++
 kernel/bpf/btf.c                              |  56 ++++
 kernel/bpf/core.c                             |   4 +
 kernel/bpf/verifier.c                         | 220 +++++++++++++--
 net/bpf/test_run.c                            |   7 +-
 net/ipv4/bpf_tcp_ca.c                         |  36 +--
 net/ipv4/tcp_bbr.c                            |  28 +-
 net/ipv4/tcp_cubic.c                          |  26 +-
 net/ipv4/tcp_dctcp.c                          |  26 +-
 scripts/Makefile.modfinal                     |   1 +
 tools/bpf/resolve_btfids/main.c               |  28 +-
 tools/lib/bpf/bpf.c                           |   1 +
 tools/lib/bpf/bpf_gen_internal.h              |  14 +-
 tools/lib/bpf/btf.c                           |  19 +-
 tools/lib/bpf/gen_loader.c                    | 250 +++++++++++++++---
 tools/lib/bpf/libbpf.c                        | 110 +++++---
 tools/lib/bpf/libbpf_internal.h               |   3 +
 tools/lib/bpf/skel_internal.h                 |   6 +-
 tools/testing/selftests/bpf/Makefile          |  10 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  23 +-
 .../bpf/prog_tests/get_branch_snapshot.c      |   5 +-
 .../selftests/bpf/prog_tests/ksyms_module.c   |  29 +-
 .../bpf/prog_tests/ksyms_module_libbpf.c      |  28 ++
 .../selftests/bpf/progs/test_ksyms_module.c   |  46 +++-
 tools/testing/selftests/bpf/verifier/calls.c  |  23 ++
 28 files changed, 860 insertions(+), 187 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c

-- 
2.33.0

