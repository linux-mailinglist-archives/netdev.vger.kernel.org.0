Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD7B48EE6C
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243495AbiANQkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243490AbiANQkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:40:40 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492A2C061574;
        Fri, 14 Jan 2022 08:40:40 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id l6-20020a17090a4d4600b001b44bb75a8bso2342874pjh.3;
        Fri, 14 Jan 2022 08:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rDznD3kPTrUrWGyo/lTDaUP2vve8plLKihHLXqkdBH8=;
        b=MAqambvjX5v/TdOSizWxA2LOHJm75xiiplhtepnhw5EY0wxMMLV7hsn73Upvw/Kp4g
         CzB95EsTiun1GZJkZk5Nbaf+NLFQW7+uZub0QxVYBmIElC70XCQ5JPtoHVY2HYUp1k2y
         TU5Q0pvgNrvKuSf7xI4UoPfW47IK6QGPJmbACg6/VgiaRtl7VKJNkYfl2SvhxYb6uwA1
         sS+NrpikdUS5GfEFbCWVidcqx4GZ5r57uak8VAwd+uMpB8HEd+78ylDgRGKhH7TDtRJa
         V0pFYrPUOLWsb/aOD8HoW4JdxQK7azqfK8FJIr9l0uEDEMJT/V01nlOycD76t8Ch0NtY
         1ndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rDznD3kPTrUrWGyo/lTDaUP2vve8plLKihHLXqkdBH8=;
        b=wTaXo5O32fkKcfxYfPBRG1ML539qBSDiAjAfxWcjSPKQ4UJuozBAtHUE0MQFI6ipHD
         miqAUlbBuZd5hedDsx0wiBCJDj4yKVxKC0fW6tbEs/E9IDp/VjP3rWGfZ7f2L6JTheO8
         5lsnvD5q5Fp/71sQYkfW4sTREd+wojuQ/+X6sZHFSrdmsy9JH6xn9XMUCXG/CTRFSYTW
         XkTRqIr2JEPFrq4pXTBurevaYd98vefInm6VY7Gp4vfnrh1nXzjc2K3t3TLqxAdZyD20
         W4tB5bPJf3pZJj8ru/BuWUjMuaDSz/zOXd24fe2Zqy5EnekcMMNaPzQU2/R6UmHwVhsn
         aE8w==
X-Gm-Message-State: AOAM5302DvLnxhattDumULW6tqryXoJPDkKu0vjnpZNdUcvXQs7sNS8R
        wnFhh2nwu4R+NFEkcnXPT6MkyNtEfp80wQ==
X-Google-Smtp-Source: ABdhPJwoWhVFbvqT9aLOVvhWrzS76MT+fjJq2FJ+B1iF6/gHD6BY5SPHLPSihVh2yn6V1IYeLi/xqQ==
X-Received: by 2002:a17:90a:e454:: with SMTP id jp20mr21257226pjb.53.1642178439447;
        Fri, 14 Jan 2022 08:40:39 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id 7sm1828858pfm.25.2022.01.14.08.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:40:39 -0800 (PST)
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
Subject: [PATCH bpf-next v8 00/10] Introduce unstable CT lookup helpers
Date:   Fri, 14 Jan 2022 22:09:43 +0530
Message-Id: <20220114163953.1455836-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6976; h=from:subject; bh=LLyb7MwFXiu0NeC4HFn+sW59HPxMOfDccUp+CXTflkk=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh4acUmvQ66go/ZCb3BKQRsYySvINIOWALL4MceUps J50+7CaJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYeGnFAAKCRBM4MiGSL8RysOdD/ 9iO0DbuX85TSoVYkfHn3nhw0yksiK7VjR20CLkwdmCl3r5lgFP9mBEoTnr180NbbiPOkWyWaYQhMvN mMHvpZ239WnDP9gyATNHfhBGDlzQtRJd3OmRWEC9JPALDNyFReoGrqaDOkCil9zHQVY2Mk0JaPRNcP 7I7PnCEU4x51jWEqNmeng7p/esnGLeT0oTk8N6Z/gNhMkiwfAcsxA3BC6hJ7s+S6x2SjNh/VT8//p0 wwRJM2qgg+GTrWPabxQbIVF+iRFOhnycJjsS9wYUjH0xCIbdC/4OlmokX4Z62DhIrlLCdycfflBMRW R0ANKV3jcNCt2BTMdzX77QDp+EZr5NJll6gjZOifQ8LcqGtqPc/7mZVWb2BcvC69bXZG2DxahJzsk3 HAQ4b5wsg1nTim1BQHgHgTdebZ7u9atNK+jimhpeYwQT1b2qupjbN20KBDLYcAyMLGdVQKLegSt2nJ x7UiS6HMtENATNIY9u3++h4GR8tp6iyDlJweT/VAkG7aLwMs/JXcVlcqMEg5uLPzDbTN6aqsk905jJ WCQubqpBIlE1mxqld6jrdae3U9pQxCIzgPj9X1+BAaFSqO3WHtD2V8kbvpDSgH+G1oQvyYhxUMc2V9 JRDcL933snTfiwS+uGDdVPggdMzHgVCyQS+MXrupKAOcscAVA1cyGlRALStQ==
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
v7 -> v8:
v7: https://lore.kernel.org/bpf/20220111180428.931466-1-memxor@gmail.com

 * Move enum btf_kfunc_hook to btf.c (Alexei)
 * Drop verbose log for unlikely failure case in __find_kfunc_desc_btf (Alexei)
 * Remove unnecessary barrier in register_btf_kfunc_id_set (Alexei)
 * Switch macro in bpf_nf test to __always_inline function (Alexei)

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
 include/linux/btf.h                           |  75 ++--
 include/linux/btf_ids.h                       |  13 +-
 include/net/netfilter/nf_conntrack_bpf.h      |  23 ++
 kernel/bpf/btf.c                              | 368 ++++++++++++++++--
 kernel/bpf/verifier.c                         | 196 ++++++----
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
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 109 ++++++
 tools/testing/selftests/bpf/test_verifier.c   |  28 ++
 tools/testing/selftests/bpf/verifier/calls.c  |  75 ++++
 29 files changed, 1674 insertions(+), 214 deletions(-)
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

