Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A44482BE9
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiABQVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbiABQVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:21:19 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22198C061761;
        Sun,  2 Jan 2022 08:21:19 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so30318163pjw.2;
        Sun, 02 Jan 2022 08:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DzBK87F7QZIll1WMaPdK83Kv7/hgUDudXTuVIROiUcI=;
        b=FsRiThMTy94VYM5cR+NDog1FGP/jyaZSCzhdDhja1YnmAUDdhIqexieEe3g+vpFw2t
         Z4U5bYPh5XntivEoJHRtYNMwcQthhouTGcD6bEj1TNV26ga4cJz4wGhZk8ygCcr5uAZL
         xgkCKVLpaRg1eF77TB4OnzVpe1UTl3H/2+kxqebqHocwU1S4pkiqzIIWR/3W6NPu/dTa
         j6Ful4NUdmJz1UFzgpQlJWwfEPThNvkA3KNr0hKGHtz9t59VHhrRiF18BlCRlZ35y0HK
         hkeZcJ5fJNJW5/HLzw4FnYmPRTtbobdCsI4D/WFw/RRH9ETC6pXO0znq6/2D2gb4X35X
         ZVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DzBK87F7QZIll1WMaPdK83Kv7/hgUDudXTuVIROiUcI=;
        b=pdM2+I3qs04mGN7145lP1dkmUcMg9hpYBWV+S+nDKuZhGHR+jdsrq+1QQm2RnPEUja
         shqvS2Z+fEz68fZZ7Oyya3CUVmBHSb7RLB7qbHCupl1fEGFtBWa0aNicE2Rpt3vMqyNd
         B0x/6IariVFofdZI1cWN33IjPCI/dK9bxWArZoMUFQ3zdeASEBhYw7MPvloG3df2FnxZ
         uv7mgSpWTU8y1XG4y2qORaPQY3XL7yPFu+ZEL4PeN1L9bcXVeJ2QTZEdTIPyw3ONjFlc
         oESRIj1n0YF6RI5Y5sjjsVbMArnQkgATNIzoLKoZe/oMR30My6LpH0oLAZ7vefV5YCLh
         Oheg==
X-Gm-Message-State: AOAM533U3tCTrr04hN6OWu9U6EOi1xveGfVsmOpg7vwIQU+wQjYofcGz
        +zYUypAci2tLU12FNvsiS1EK+plrWZ8=
X-Google-Smtp-Source: ABdhPJwapQSYeo8A7B6hkT4df4leVOnJQYPOV1dedkda8p5/hpktvm9/Mh91cggY6qJn1B9iu66ttw==
X-Received: by 2002:a17:90b:1d82:: with SMTP id pf2mr52017630pjb.96.1641140478445;
        Sun, 02 Jan 2022 08:21:18 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id i1sm10979896pgk.89.2022.01.02.08.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 08:21:18 -0800 (PST)
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
Subject: [PATCH bpf-next v6 00/11] Introduce unstable CT lookup helpers
Date:   Sun,  2 Jan 2022 21:51:04 +0530
Message-Id: <20220102162115.1506833-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6437; h=from:subject; bh=mB+i1BrL1/wa+kkQcT2Mp0Z7IphshbapPPWmeGkB5bM=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh0dCJAN+xWdAjBPpTi+zXD+pjj89NrA34IIpKCevC 2NZ0R0SJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYdHQiQAKCRBM4MiGSL8Ryg6kEA CnAoM59mlT1texWpwvX32iYgUJ/C/OqnAl8OCtJe1JGmFriXzh+WpIZ998rO4Fbww8FwYlT138/NvX hmlWwUvFumYWeE3/4hrvkumQxKlXaKZfkI1WGNtU8/qmemkM17TUpDE2ymcxnNrdo9YXqjXX1mh79k AxLKXaJEltkYNbZD28wLazFXlWbF+lJicEZeqH6kMnMreeyk89WI4lyxwNH6C89l6jc4Z2jv/Qptzg jMdx6P8Mub8MCMdZUTU4WhhT9sXW742GnkAxvyZzB8+C0Be7zoNbilbQ0qUeK1PMjg5n5toe7Oe0dF boKiiw6POEZSRUpq7KH5/Sv85FbG6BTmNYZnnX59wuDyYGyV8FXJOUytBYKhTpP/jwfsZ5AQh463PD EhRcCkOZGQZfmmm0gpUVOf2xIU4qZPfxwx7KN8O+egXUDyGQm5eZaeiGXVJYToatADay9in+2W6hVh E4nE/66+QNV521YRcCkyEUjudqmqhjZmF7kW3ZMRVu7tXRJeBnSsmf7khiZM2VubnSU86Kmnn1chzO Dvw79es4xlIGkuNcycpMJCgkaVG36qphSDVt0ptzfEnvkDFZKIUPNfR+Vp6mpX6VyB8hv/wjW9c9Tc 0AU9la6M/U4+J9DQNUbZhTOam3JItm/Y5e0Z2reDjkthc4fs5KR5q46+qebg==
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

Changelog:
----------
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

Kumar Kartikeya Dwivedi (11):
  kernel: Implement try_module_get_live
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
 include/linux/btf.h                           |  82 ++---
 include/linux/btf_ids.h                       |  13 +-
 include/linux/module.h                        |  26 +-
 include/net/netfilter/nf_conntrack_bpf.h      |  23 ++
 kernel/bpf/btf.c                              | 327 ++++++++++++++++--
 kernel/bpf/verifier.c                         | 197 +++++++----
 kernel/module.c                               |  20 +-
 net/bpf/test_run.c                            | 150 +++++++-
 net/core/filter.c                             |   1 -
 net/core/net_namespace.c                      |   1 +
 net/ipv4/bpf_tcp_ca.c                         |  22 +-
 net/ipv4/tcp_bbr.c                            |  18 +-
 net/ipv4/tcp_cubic.c                          |  17 +-
 net/ipv4/tcp_dctcp.c                          |  18 +-
 net/netfilter/Makefile                        |   5 +
 net/netfilter/nf_conntrack_bpf.c              | 257 ++++++++++++++
 net/netfilter/nf_conntrack_core.c             |   8 +
 tools/testing/selftests/bpf/Makefile          |  11 +-
 .../selftests/bpf/bpf_testmod/Makefile        |   5 +-
 .../bpf/bpf_testmod/bpf_mod_kfunc_race.c      |  50 +++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  17 +-
 tools/testing/selftests/bpf/config            |   4 +
 .../selftests/bpf/prog_tests/bpf_mod_race.c   | 221 ++++++++++++
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  48 +++
 .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +
 .../selftests/bpf/progs/bpf_mod_race.c        | 100 ++++++
 .../selftests/bpf/progs/kfunc_call_race.c     |  14 +
 .../selftests/bpf/progs/kfunc_call_test.c     |  52 ++-
 tools/testing/selftests/bpf/progs/ksym_race.c |  13 +
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 105 ++++++
 tools/testing/selftests/bpf/test_verifier.c   |  28 ++
 tools/testing/selftests/bpf/verifier/calls.c  |  75 ++++
 34 files changed, 1713 insertions(+), 236 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_bpf.h
 create mode 100644 net/netfilter/nf_conntrack_bpf.c
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/bpf_mod_kfunc_race.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_mod_race.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_nf.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_mod_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/ksym_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf.c

-- 
2.34.1

