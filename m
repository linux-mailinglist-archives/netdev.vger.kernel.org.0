Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF1340BF22
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 07:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbhIOFLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 01:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhIOFLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 01:11:08 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60608C061574;
        Tue, 14 Sep 2021 22:09:49 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j16so1645835pfc.2;
        Tue, 14 Sep 2021 22:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dtosK1VKmzTHpkbVxMlwnj1Z7A67tAUA3Ttfcj79Sbw=;
        b=jSAZXzQuJUp99idKxRbDj9zcpH/vG5E8RHuSwNl91ER72gYI95vtFq6hQp9yWU7GlO
         GdsgEKpqjEhrDlssNWeZSPKxN1DyIpV+fsJhqp4h7o6oi6CKEmx48JTuhzShq/NKozqR
         2lldaNQGnnbvaRLI96BaRLTROs3Aj3Cy7WfWovUIlaVnnjNupUH0xZYUbYtuqwY1+Y+K
         SqQsVhxrF3dhU8JK17lpi8GIdCwg+1hH4Rak1E/9v5A+sRWIcGBY/BzhWNfnsVDQBxcG
         P90W8fPayP7UX0QFzUfrHSIAsVC3rDSG14pQ+G13jol4pULMKfuGp2eavn+iAVon2cBh
         5xYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dtosK1VKmzTHpkbVxMlwnj1Z7A67tAUA3Ttfcj79Sbw=;
        b=nziA/+14tJ8CRT/+3u0jACeK1EhaWfO52Dkazv6h6A/clXavbVLtzbRnNVccyHxWGk
         idWZ14G8LeeYqDCsuusYstDTbIHb86m/T6zjfx2xYZoI8zJIG4EFH+NWiMUJigy9Ve4C
         d3xVi1mHdMwWVu0jQN3haeqIeWjeW5IJVVjyFa2yh+xdBkjsTXWEifdk33wobpm75Heg
         DQRwxzDKJuPb2wfA7imiPwp/sQs0UXQy9uMFhKZNv3wpZjX8cxbTQ6OgeLLH0ndMLTg8
         1W6UG/jLYiHPUCEjZu9qRgP9VljgtxJascpIrtCHqzwl9Hx8kipQac7KJZ0R3HP/rPoj
         Ue4w==
X-Gm-Message-State: AOAM532BeX6bz3JtFuumFdQ8UBsdTEJlJCOgnP4oz05D6Em8Q59Uqqma
        3OSTHl1YA/+BwK98dv91hBmdFI6Kiws3Rg==
X-Google-Smtp-Source: ABdhPJyTnyPdjzc4Hqw6pr+OySRdqx/BM2G2/mAERn55XUldNRzlDcSa2ESgSSJKTLIlXbV5DZ40nA==
X-Received: by 2002:aa7:84d6:0:b0:43d:fe64:e8c0 with SMTP id x22-20020aa784d6000000b0043dfe64e8c0mr7438136pfn.48.1631682588638;
        Tue, 14 Sep 2021 22:09:48 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id 207sm9498298pfu.56.2021.09.14.22.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 22:09:48 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 00/10] Support kernel module function calls from eBPF
Date:   Wed, 15 Sep 2021 10:39:33 +0530
Message-Id: <20210915050943.679062-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4085; h=from:subject; bh=M3xfou/qUhrmj4bm/qug1DH61hLZMJIvVL0UceCG6AI=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQX4a+A7IQnjmGKq16V+Gy/76AkjxksW5z6+PfeYf +zNtSuGJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUF+GgAKCRBM4MiGSL8RygUMD/ wOOy0JNjG3ovEs0ij2geMlcBQ06jk8xwFg9dYagEnTZ3aR8IbGaoXr+O5ZjJPg4kNjSN7SkeomxEC5 yskmCPGYnRsPAAL+FHma4uzu97GIjFTwIZqRwRkxpCU3YHhKJ9D5g7D+vSin3kw1uyJ01E0MZnbcfy ECVeXLCaMJGr14Kn5jL6ttlcJT7EIP9qLSR+igtgLQGXbXVJBM9VZR+SCcs0D0if7rqKXHVGa99YV8 KZOkmesF/OS0ENUuuoDyd96zd/Jlnqq6Hp9iPKfN668E4uU0c2G6TlPE/WFi7uxmKfm9CgAHIl77LI 6/gV5z9dMQUstxbQpo94HC0jEbEfIzspQsJQomO2AS562vuUkf6XoLPSqMIuwxkDH9cbKqwVg6cQeh AuNmr90YaMj0cUP2A1+LtwTxNMuRoGl4/DOq4XjIPkgLr9eIXLf8KGruGlhoWJ1km5X/rV35XvD+Cm sHqu5RbiV4S28UvlhxGFsklMrVyvxP/phOxLv5NAFwwXKuLWpxuXgXVgGFort/1GaviHYr0Y9YH6EA kojkQbYdISemyd+j/6Q5X7jjBzCUdIlz0AGOy3PcJEWStHqyefhgmHsJz9B1k84VQrhyyMtxgc1C3d 4mLbqtC3UE+WS5h+DH+hA7NYqOedoIgEPbheELtNX8t0RQrjOIUTZNjJiU6g==
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
v2 -> v3:
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

Kumar Kartikeya Dwivedi (10):
  bpf: Introduce BPF support for kernel module function calls
  bpf: Be conservative while processing invalid kfunc calls
  bpf: btf: Introduce helpers for dynamic BTF set registration
  tools: Allow specifying base BTF file in resolve_btfids
  bpf: Enable TCP congestion control kfunc from modules
  bpf: Bump MAX_BPF_STACK size to 768 bytes
  libbpf: Support kernel module function calls
  libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
  libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
  bpf, selftests: Add basic test for module kfunc call

 include/linux/bpf.h                           |   8 +-
 include/linux/bpf_verifier.h                  |   2 +
 include/linux/bpfptr.h                        |   1 +
 include/linux/btf.h                           |  38 +++
 include/linux/filter.h                        |   4 +-
 kernel/bpf/btf.c                              |  56 +++++
 kernel/bpf/core.c                             |   4 +
 kernel/bpf/verifier.c                         | 217 +++++++++++++++---
 kernel/trace/bpf_trace.c                      |   1 +
 net/bpf/test_run.c                            |   2 +-
 net/ipv4/bpf_tcp_ca.c                         |  36 +--
 net/ipv4/tcp_bbr.c                            |  28 ++-
 net/ipv4/tcp_cubic.c                          |  26 ++-
 net/ipv4/tcp_dctcp.c                          |  26 ++-
 scripts/Makefile.modfinal                     |   1 +
 tools/bpf/resolve_btfids/main.c               |  19 +-
 tools/lib/bpf/bpf.c                           |   1 +
 tools/lib/bpf/bpf_gen_internal.h              |  12 +-
 tools/lib/bpf/gen_loader.c                    |  93 +++++++-
 tools/lib/bpf/libbpf.c                        |  81 +++++--
 tools/lib/bpf/libbpf_internal.h               |   1 +
 tools/testing/selftests/bpf/Makefile          |   1 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  23 +-
 .../selftests/bpf/prog_tests/ksyms_module.c   |  13 +-
 .../bpf/prog_tests/ksyms_module_libbpf.c      |  18 ++
 .../selftests/bpf/progs/test_ksyms_module.c   |   9 +
 .../bpf/progs/test_ksyms_module_libbpf.c      |  35 +++
 tools/testing/selftests/bpf/verifier/calls.c  |  22 +-
 .../selftests/bpf/verifier/raw_stack.c        |   4 +-
 .../selftests/bpf/verifier/stack_ptr.c        |   6 +-
 .../testing/selftests/bpf/verifier/var_off.c  |   4 +-
 31 files changed, 673 insertions(+), 119 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c

-- 
2.33.0

