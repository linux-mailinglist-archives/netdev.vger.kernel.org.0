Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D584478269
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhLQBuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhLQBuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:50:35 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D830EC061574;
        Thu, 16 Dec 2021 17:50:34 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso4332796pji.0;
        Thu, 16 Dec 2021 17:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NhG7o+nsdY02iw3dYd2aTlPdsjbjsVvPHVIuGI/z9LY=;
        b=J0tVkkSnTUQy77P7W0kkVWnA2mLJkVeVkkBlXvG4npM00vmUcP9D+hd2ItAQ1pcs2z
         QjzDWOwAIMLhAFOIF1CarAl7AVnG0m4BB7Q9MhcyqKkxFVhalQ1lkSehl82+Pqwn8cOM
         NoKdnoRdjhtGmIVmiK3E1GnYaBwkeN58QS1qX+l+1FH3xrHqkmdZueG8K4Hjpvc4S33G
         pGl0hYWNouiR6JIu9+e/k3Yp8DTZKk/6J8RGzTF+COfrwBdcUB4dW2XvOK0VToAmCxte
         Bqsk+XLpOehaSeCxkasJttaoSoobG6/urywG5xdlyZ9n1YmAyTxKj792S2ttSDk8279N
         wjbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NhG7o+nsdY02iw3dYd2aTlPdsjbjsVvPHVIuGI/z9LY=;
        b=F7JORF9jW51/Rp3NHS6E9QRx8DZvsyaAlWT7cMC5nXxECS9rcKspUessoLylX+Lt+Z
         co6z/2w6V1gTGOt6tAYKXvYFlN9FYNEMV8tXMRlLP2K63pPORzXPyGjOh89IEYxiVsjY
         rtUVPjWdFlvpDyi6+HwOHYxoAJP/Z+xjsAiEgyNjhysON8aA1BgLFZ49QldfJFLlfRfF
         gXb5trKlWqtpLaDyhSDJmy1cvLSxkWbjEsmxjRjJZd7son1AhHEK0fMyBvjXZ52txQWj
         JHvDKc5pVryyEwi2MPF0cZK+upkJeDP3ah+FP0Lv9f5t1+Q6rnDYyy747TYvP+pQ3Ipt
         GyzA==
X-Gm-Message-State: AOAM5337VBziAset/e+/iaFKgIfPgnD1nR01KXNA+DTiNSFdd8o8khNW
        2Fj61LIDTsTtPJi7hgtZzVFa5JExrL4=
X-Google-Smtp-Source: ABdhPJxNhKz9WNazgJ2GytKgLvjRAzyA5K63evER/ZuvEsf43XpOrIcoWtrEkNuGbVwMEQSM1QAI4Q==
X-Received: by 2002:a17:902:728e:b0:143:a388:868b with SMTP id d14-20020a170902728e00b00143a388868bmr1007872pll.33.1639705834227;
        Thu, 16 Dec 2021 17:50:34 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id m11sm7474209pfk.27.2021.12.16.17.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 17:50:33 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 00/10] Introduce unstable CT lookup helpers
Date:   Fri, 17 Dec 2021 07:20:21 +0530
Message-Id: <20211217015031.1278167-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4546; h=from:subject; bh=YscigycUksLr/b9v4i2qq748xsHI9ClA1gn/zVo1vhI=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhu+vEbu5ewbqYbD1Sj47TTOLXK6zekpZRzxxQ2JtP nyzgwm2JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbvrxAAKCRBM4MiGSL8Ryi4vEA CQT/ziJvTSHR58gniy86vMkmf22hES0hs33kQ0VGNHNqEeVGiOLulbY08PfaJqCkWUkb0JO16D0vzq NZgYLZAonTrb3YjXihKlCdVhrNjxPX+pfhHKuQvgNtKt/zZIM9Q5R/sec+T6mB4NT6T1sdrd6qF0qQ LW6gWVRHxwYl6x/X5ch7H97wEg6+7V9euKvo3sRYTuljYJjnw8SOJ7+JgFow8fnRSIOBJtuRkH7CeO RbcXYkvqAPq2t/QEwVwgoO4hiTJKDS9yTKf1bFKOAUZYbWIlBJj1Bz8Vk6VnxWI0ny7mHXLkPHDNQe EnxoO08SjRRslmv9qRwsBEY5CYA1ggjOYmJ0wp3cZwKzSMqO7H4bdKlM4Z50V1ah0Bt4hJFtKBlXZu 3aF8NXN3DQ9h60Zc+5AFQua47HMTvVDn35KgNwOFhdWnFpv/nxJkyQ0KAa2d+4L7Gad0m986FQAM6O 0XEflb0A1TXpp7MYDIaPSiVpv6x+dnAaF/X08cj1D22ZEPwfM0nPD4TRA98Bn3H9pGsiIBGgRpSeS5 c3FnL03MN4XIYT+tv12CJEeEWPVDyY5DFz2rwvhD6Sb8X4HjlgMaL8a8T9JI8rOqIA+6mIMQAwOztl TuF/UouFEgnNINOdzKoPyH0BNP1KtjOJimsm2sv0bjelL2tHBMm/aNPKgg3w==
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

Note: BPF CI needs to add the following to config to test the set. I did update
the selftests config in patch 8, but not sure if that is enough.

	CONFIG_NETFILTER=y
	CONFIG_NF_DEFRAG_IPV4=y
	CONFIG_NF_DEFRAG_IPV6=y
	CONFIG_NF_CONNTRACK=y

Changelog:
----------
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
  bpf: Refactor bpf_check_mod_kfunc_call
  bpf: Remove DEFINE_KFUNC_BTF_ID_SET
  bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM argument support
  bpf: Introduce mem, size argument pair support for kfunc
  bpf: Add reference tracking support to kfunc
  bpf: Track provenance for pointers formed from referenced
    PTR_TO_BTF_ID
  net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF
  selftests/bpf: Add test for unstable CT lookup API
  selftests/bpf: Add test_verifier support to fixup kfunc call insns
  selftests/bpf: Extend kfunc selftests

 include/linux/bpf.h                           |  27 +-
 include/linux/bpf_verifier.h                  |  12 +
 include/linux/btf.h                           |  46 ++-
 kernel/bpf/btf.c                              | 216 ++++++++++++--
 kernel/bpf/verifier.c                         | 232 +++++++++++----
 net/bpf/test_run.c                            | 135 +++++++++
 net/core/filter.c                             |  27 ++
 net/core/net_namespace.c                      |   1 +
 net/ipv4/tcp_bbr.c                            |   5 +-
 net/ipv4/tcp_cubic.c                          |   5 +-
 net/ipv4/tcp_dctcp.c                          |   5 +-
 net/netfilter/nf_conntrack_core.c             | 278 ++++++++++++++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |   5 +-
 tools/testing/selftests/bpf/config            |   4 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  48 +++
 .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +
 .../selftests/bpf/progs/kfunc_call_test.c     |  52 +++-
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 105 +++++++
 tools/testing/selftests/bpf/test_verifier.c   |  28 ++
 tools/testing/selftests/bpf/verifier/calls.c  |  75 +++++
 .../selftests/bpf/verifier/ref_tracking.c     |  44 +++
 21 files changed, 1248 insertions(+), 108 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_nf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf.c

-- 
2.34.1

