Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D070548B52B
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345992AbiAKSF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350398AbiAKSFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 13:05:09 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17D2C06175C;
        Tue, 11 Jan 2022 10:04:56 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id g5so9262592plo.12;
        Tue, 11 Jan 2022 10:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=djsNTpuyk+egjmhMtDXT1SCwXnpdzz5VxfkJIjUvmIs=;
        b=DcJSX2muaO2OxNRfJLuM7VPOXC4gMpcBNEc8sb/+/AawZWbMpGPiiajC7mg3qvkS1S
         JKNJ3yK0+JWbO74FPWBVs9jt87O83R0Vwpo90WW0H4sFsHaUwqMPvxSIh8Bb4Y0F28JV
         MTxDw32es/a82gByQr2IvAiDCxmDrD8/c7OUKApv5wTFejcZRVhrKDRB4EE8Ab0w46NJ
         rhRnM5NebJXvknGyUE6P4YbNVIVyKRi4oApE9SypNy+rNZnKnkCHmJ80OFyTnd5tDP49
         4uNadLu7V7UQTmTvFbw//5m/XE9yDyGFHq3IMJhXo4rtwFEkZ+QZpUdCJf2MASUniJWS
         ij5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=djsNTpuyk+egjmhMtDXT1SCwXnpdzz5VxfkJIjUvmIs=;
        b=zKjHmXLuSPaUf4CRdEBRX6xvE1rpqIWpIU+QzQEAZ1Gn1gFexuSewwGI3EgO8RVGKb
         ZgZukAiPywrHZvfVGE+hHCFXRuSGp75X6wwuZht8IIg7qQaK/HaZfsaUFjvqShyK2L/z
         dPnR6p2OT+7iuHP11zIeUHsTW09RzHlyWsDHm5MKVoz3Lec1aP3tbYMajudMfHCgfr7I
         2AXonLut99VmyhGMeFOIIvudssRxccQ/YUMFVNV5ec0JZ0MMzg6KXMrTccg39gUC0vUw
         USSE0jGNx89QK/+VCcI/HJeX4Q49J+ph0OVM2gsvKzvmxKD12Pc9pBgS6a8EbI1NBi2I
         tPEw==
X-Gm-Message-State: AOAM5332wJY65AvgITHWhpzd3pqPZOd0WpEn+VgKzSDp03sXbGgKF146
        ID5SlvaDhYBpfMF/FaPLUHATy6k4CsHAXw==
X-Google-Smtp-Source: ABdhPJz6D4sQIOY1mZbjZZExYcGQynGW20i4/hFBZPUv9/CWYq5WbdWxV6P3dT24xhcDAslMNUM4Ew==
X-Received: by 2002:a63:3fcd:: with SMTP id m196mr1285647pga.168.1641924295879;
        Tue, 11 Jan 2022 10:04:55 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id m3sm5092706pfa.183.2022.01.11.10.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 10:04:55 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v7 00/10] Introduce unstable CT lookup helpers
Date:   Tue, 11 Jan 2022 23:34:18 +0530
Message-Id: <20220111180428.931466-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6796; h=from:subject; bh=rIWND0XdTlB8jROZtBH2YOsY12pFU6pmftF856PeGpA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh3caiTFRYJ9KAK93mSgp51C6DIxhTNf/HsS/8NG04 AImSM9iJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYd3GogAKCRBM4MiGSL8RyqW7D/ 9evGLWRO6wOGw9aEHCIjxU2I+mNOEt+cqEQbZdiQVxPf5tzWhKeQJduT5Ukz1CiXr5UhhIkFQ/dJ0K mHL5L8XFuLOPSDsPFZYMo6RZPI7YCaDW6F87EQsoP1k7bX/z9wYFxaSR15531UrHlzUHeR6WBuHYZ2 EM+9i5mKI0/8SxvAQiKnDn4eoVHsOKbJ+mPxRU4OokaeFbByHLq2c/KQ0kY0O3f5JugUDixnA0bxyq U6PRZSwGPFOxXY5vDCtYg3czV3UiasNPi9IQBM42EVZuwBAsg0q5z8/Eu+kTZW30GHYX1xLHGBd2vs VS/hN016cK+cHFV1/rn2ojE0QByqyFeLfSIK4PBa0LdK1jFp7g1DGpu9AQjPA3/v40bnrRln4g6t75 ubJU6MXIPiwh1XNY0OpGflvvhSvKOcfspB1avnyKby95Emc5ot7b8EeHGWRgWINJsBglDxd7gX8oiW jUWQ/v4xhZyLYsyjIpPgI+DcqNQ9CxVclUJOcAsqtYwfaEQH77a6raNB6o37dLW4gz0bDdPaHDFGiw 7s4a22xCmcSUw++LCGXhm4Vltta2ArOdGqsNDKD70qXW66dBDuVOzBMcyyQXQjDTl16z8v5c3XAEly G7R6yOoOTNwwJaseY0CNZfHjRtEKYTraCI5tcVEHkdWfECLlxvLOgJIPHeaw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds unstable conntrack lookup helpers using BPF kfunc support.  The
patch adding the lookup helper is based off of Maxim's recent patch to aid in
rebasing their series on top of this, all adjusted to work with module kfuncs [0].

  [0]: https://lore.kernel.org/bpf/20211019144655.3483197-8-maximmi@nvidia.com

To enable returning a reference to struct nf_conn, the verifier is extended to
support reference tracking for PTR_TO_BTF_ID, and kfunc is extended with support
for working as acquire/release functions, similar to existing BPF helpers. kfunc
returning pointer (limited to PTR_TO_BTF_ID in the kernel) can also return a
PTR_TO_BTF_ID_OR_NULL now, typically needed when acquiring a resource can fail.
kfunc can also receive PTR_TO_CTX and PTR_TO_MEM (with some limitations) as
arguments now. There is also support for passing a mem, len pair as argument
to kfunc now. In such cases, passing pointer to unsized type (void) is also
permitted.

Please see individual commits for details.

NOTE: [0] and [1] are needed to make BPF CI green for this series.

 [0]: https://github.com/libbpf/libbpf/pull/437
 [1]: https://github.com/kernel-patches/vmtest/pull/59

Changelog:
----------
v6 -> v7:
v6: https://lore.kernel.org/bpf/20220102162115.1506833-1-memxor@gmail.com

 * Drop try_module_get_live patch, use flag in btf_module struct (Alexei)
 * Add comments and expand commit message detailing why we have to concatenate
   and sort vmlinux kfunc BTF ID sets (Alexei)
 * Use bpf_testmod for testing btf_try_get_module race (Alexei)
 * Use bpf_prog_type for both btf_kfunc_id_set_contains and
   register_btf_kfunc_id_set calls (Alexei)
 * In case of module set registration, directly assign set (Alexei)
 * Add CONFIG_USERFAULTFD=y to selftest config
 * Fix other nits

v5 -> v6:
v5: https://lore.kernel.org/bpf/20211230023705.3860970-1-memxor@gmail.com

 * Fix for a bug in btf_try_get_module leading to use-after-free
 * Drop *kallsyms_on_each_symbol loop, reinstate register_btf_kfunc_id_set (Alexei)
 * btf_free_kfunc_set_tab now takes struct btf, and handles resetting tab to NULL
 * Check return value btf_name_by_offset for param_name
 * Instead of using tmp_set, use btf->kfunc_set_tab directly, and simplify cleanup

v4 -> v5:
v4: https://lore.kernel.org/bpf/20211217015031.1278167-1-memxor@gmail.com

 * Move nf_conntrack helpers code to its own separate file (Toke, Pablo)
 * Remove verifier callbacks, put btf_id_sets in struct btf (Alexei)
  * Convert the in-kernel users away from the old API
 * Change len__ prefix convention to __sz suffix (Alexei)
 * Drop parent_ref_obj_id patch (Alexei)

v3 -> v4:
v3: https://lore.kernel.org/bpf/20211210130230.4128676-1-memxor@gmail.com

 * Guard unstable CT helpers with CONFIG_DEBUG_INFO_BTF_MODULES
 * Move addition of prog_test test kfuncs to selftest commit
 * Move negative kfunc tests to test_verifier suite
 * Limit struct nesting depth to 4, which should be enough for now

v2 -> v3:
v2: https://lore.kernel.org/bpf/20211209170929.3485242-1-memxor@gmail.com

 * Fix build error for !CONFIG_BPF_SYSCALL (Patchwork)

RFC v1 -> v2:
v1: https://lore.kernel.org/bpf/20211030144609.263572-1-memxor@gmail.com

 * Limit PTR_TO_MEM support to pointer to scalar, or struct with scalars (Alexei)
 * Use btf_id_set for checking acquire, release, ret type null (Alexei)
 * Introduce opts struct for CT helpers, move int err parameter to it
 * Add l4proto as parameter to CT helper's opts, remove separate tcp/udp helpers
 * Add support for mem, len argument pair to kfunc
 * Allow void * as pointer type for mem, len argument pair
 * Extend selftests to cover new additions to kfuncs
 * Copy ref_obj_id to PTR_TO_BTF_ID dst_reg on btf_struct_access, test it
 * Fix other misc nits, bugs, and expand commit messages

Kumar Kartikeya Dwivedi (10):
  bpf: Fix UAF due to race between btf_try_get_module and load_module
  bpf: Populate kfunc BTF ID sets in struct btf
  bpf: Remove check_kfunc_call callback and old kfunc BTF ID API
  bpf: Introduce mem, size argument pair support for kfunc
  bpf: Add reference tracking support to kfunc
  net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF
  selftests/bpf: Add test for unstable CT lookup API
  selftests/bpf: Add test_verifier support to fixup kfunc call insns
  selftests/bpf: Extend kfunc selftests
  selftests/bpf: Add test for race in btf_try_get_module

 include/linux/bpf.h                           |   8 -
 include/linux/bpf_verifier.h                  |   7 +
 include/linux/btf.h                           |  82 ++--
 include/linux/btf_ids.h                       |  13 +-
 include/net/netfilter/nf_conntrack_bpf.h      |  23 ++
 kernel/bpf/btf.c                              | 375 ++++++++++++++++--
 kernel/bpf/verifier.c                         | 197 +++++----
 net/bpf/test_run.c                            | 150 ++++++-
 net/core/filter.c                             |   1 -
 net/core/net_namespace.c                      |   1 +
 net/ipv4/bpf_tcp_ca.c                         |  22 +-
 net/ipv4/tcp_bbr.c                            |  18 +-
 net/ipv4/tcp_cubic.c                          |  17 +-
 net/ipv4/tcp_dctcp.c                          |  18 +-
 net/netfilter/Makefile                        |   5 +
 net/netfilter/nf_conntrack_bpf.c              | 257 ++++++++++++
 net/netfilter/nf_conntrack_core.c             |   8 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  21 +-
 tools/testing/selftests/bpf/config            |   5 +
 .../selftests/bpf/prog_tests/bpf_mod_race.c   | 230 +++++++++++
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  48 +++
 .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +
 .../selftests/bpf/progs/bpf_mod_race.c        | 100 +++++
 .../selftests/bpf/progs/kfunc_call_race.c     |  14 +
 .../selftests/bpf/progs/kfunc_call_test.c     |  52 ++-
 tools/testing/selftests/bpf/progs/ksym_race.c |  13 +
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 105 +++++
 tools/testing/selftests/bpf/test_verifier.c   |  28 ++
 tools/testing/selftests/bpf/verifier/calls.c  |  75 ++++
 29 files changed, 1685 insertions(+), 214 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_bpf.h
 create mode 100644 net/netfilter/nf_conntrack_bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_mod_race.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_nf.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_mod_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/ksym_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf.c

-- 
2.34.1

