Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819744FA7DD
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 15:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241804AbiDINCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 09:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241797AbiDINCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 09:02:23 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A0B25EA8;
        Sat,  9 Apr 2022 06:00:16 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id z16so10723646pfh.3;
        Sat, 09 Apr 2022 06:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FUfKzssZgsZcsfEgZuklPwa4eiqM1i27WAbOrDmuSaU=;
        b=Cb5MplZdEwMUcE124VwGrQKSwcDlwKQXQhXK3ANgI/Tmel/dD/vvawYMRjpgmLdBj2
         JsSeFDfrldhAjJqsjENG34I7JQYHGs+rELHFS/6oDo0hX1YVxOldBTOFU1d6VY+xne03
         /COOoZmAt23VceyUS2KcK2YIeNFvRV4fH6FfZYAwruAK3FoORlH6iPrmDTeefL/iFhgq
         BBVNxZOlJNr14OF+YE6Q+0/HUnaypPoXAYvllPzjgSTE71W45nw8bS4MlgWWKm8DF9Yo
         Tc4TTWRLLwDyBShueyH4afW8JpIHtz0WT6PILw2jyCovv8Kj2uKoLiCwvXgxWosI5dgX
         VUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FUfKzssZgsZcsfEgZuklPwa4eiqM1i27WAbOrDmuSaU=;
        b=0K0Kq17wtweny6Q07yktC9E+vVYZpfbt9n6n/c0i+bCUpVl9l3r+PpVTpnWlJf/9li
         jOYqk1fihSzBBcp7D2DbPnobnt5e7ymsv0hgqHAp/oCn7qCSNP/3uJhZHERDuX/cVFgE
         mS0xsP31UtGPx4rgHOU19rB7JzLdD5oxDpLHJfR+F+sUihoarowtrRh6ZnDUOHQ802/T
         6u6qQDo9NhHS1qT7mQcWOjogMUqQ/+iRrZG5dymDOrzAPpXqsCVUwP8+9H0rmae/LoF+
         ink3bKL99p1ciYMK+fjPihlzqV92U3KVFrqQmWprqelohq+Jb18GK+E6r3YdsIYGNGrJ
         1neg==
X-Gm-Message-State: AOAM530HJajBdU0IOMBalzOiQCIB+iv2f7kC6YSNl+BvisdD2ftMCK+N
        rEnZexERzZj7lfmtREi6SAE=
X-Google-Smtp-Source: ABdhPJwTbMte2I6ohmz09z4oq0vqeIe1qFVXt+7kFfZTBBfwnT7evqM9hcNzKSdIx3DHlJd/qeZRSg==
X-Received: by 2002:aa7:88c5:0:b0:4fb:821:4017 with SMTP id k5-20020aa788c5000000b004fb08214017mr24102090pff.22.1649509211490;
        Sat, 09 Apr 2022 06:00:11 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s10-20020a63a30a000000b003987eaef296sm24671871pge.44.2022.04.09.06.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 06:00:10 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v4 0/4] bpf: RLIMIT_MEMLOCK cleanups
Date:   Sat,  9 Apr 2022 12:59:54 +0000
Message-Id: <20220409125958.92629-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have switched to memcg-based memory accouting and thus the rlimit is
not needed any more. LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK was introduced in
libbpf for backward compatibility, so we can use it instead now.

This patchset cleanups the usage of RLIMIT_MEMLOCK in tools/bpf/,
tools/testing/selftests/bpf and samples/bpf. The file
tools/testing/selftests/bpf/bpf_rlimit.h is removed. The included header
sys/resource.h is removed from many files as it is useless in these files.

- v4: Squash patches and use customary subject prefixes. (Andrii)
- v3: Get rid of bpf_rlimit.h and fix some typos (Andrii)
- v2: Use libbpf_set_strict_mode instead. (Andrii)
- v1: https://lore.kernel.org/bpf/20220320060815.7716-2-laoar.shao@gmail.com/

Yafang Shao (4):
  samples/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
  selftests/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
  bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
  tools/runqslower: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK

 samples/bpf/cpustat_user.c                    |  1 -
 samples/bpf/hbm.c                             |  5 ++--
 samples/bpf/ibumad_user.c                     |  1 -
 samples/bpf/map_perf_test_user.c              |  1 -
 samples/bpf/offwaketime_user.c                |  1 -
 samples/bpf/sockex2_user.c                    |  1 -
 samples/bpf/sockex3_user.c                    |  1 -
 samples/bpf/spintest_user.c                   |  1 -
 samples/bpf/syscall_tp_user.c                 |  1 -
 samples/bpf/task_fd_query_user.c              |  1 -
 samples/bpf/test_lru_dist.c                   |  1 -
 samples/bpf/test_map_in_map_user.c            |  1 -
 samples/bpf/test_overhead_user.c              |  1 -
 samples/bpf/tracex2_user.c                    |  1 -
 samples/bpf/tracex3_user.c                    |  1 -
 samples/bpf/tracex4_user.c                    |  1 -
 samples/bpf/tracex5_user.c                    |  1 -
 samples/bpf/tracex6_user.c                    |  1 -
 samples/bpf/xdp1_user.c                       |  1 -
 samples/bpf/xdp_adjust_tail_user.c            |  1 -
 samples/bpf/xdp_monitor_user.c                |  1 -
 samples/bpf/xdp_redirect_cpu_user.c           |  1 -
 samples/bpf/xdp_redirect_map_multi_user.c     |  1 -
 samples/bpf/xdp_redirect_user.c               |  1 -
 samples/bpf/xdp_router_ipv4_user.c            |  1 -
 samples/bpf/xdp_rxq_info_user.c               |  1 -
 samples/bpf/xdp_sample_pkts_user.c            |  1 -
 samples/bpf/xdp_sample_user.c                 |  1 -
 samples/bpf/xdp_tx_iptunnel_user.c            |  1 -
 samples/bpf/xdpsock_user.c                    |  9 ++----
 samples/bpf/xsk_fwd.c                         |  7 ++---
 tools/bpf/bpftool/common.c                    |  8 ------
 tools/bpf/bpftool/feature.c                   |  2 --
 tools/bpf/bpftool/main.c                      |  6 ++--
 tools/bpf/bpftool/main.h                      |  2 --
 tools/bpf/bpftool/map.c                       |  2 --
 tools/bpf/bpftool/pids.c                      |  1 -
 tools/bpf/bpftool/prog.c                      |  3 --
 tools/bpf/bpftool/struct_ops.c                |  2 --
 tools/bpf/runqslower/runqslower.c             | 18 ++----------
 tools/testing/selftests/bpf/bench.c           |  1 -
 tools/testing/selftests/bpf/bpf_rlimit.h      | 28 -------------------
 .../selftests/bpf/flow_dissector_load.c       |  6 ++--
 .../selftests/bpf/get_cgroup_id_user.c        |  4 ++-
 tools/testing/selftests/bpf/prog_tests/btf.c  |  1 -
 .../selftests/bpf/test_cgroup_storage.c       |  4 ++-
 tools/testing/selftests/bpf/test_dev_cgroup.c |  4 ++-
 tools/testing/selftests/bpf/test_lpm_map.c    |  4 ++-
 tools/testing/selftests/bpf/test_lru_map.c    |  4 ++-
 .../selftests/bpf/test_skb_cgroup_id_user.c   |  4 ++-
 tools/testing/selftests/bpf/test_sock.c       |  4 ++-
 tools/testing/selftests/bpf/test_sock_addr.c  |  4 ++-
 tools/testing/selftests/bpf/test_sockmap.c    |  5 ++--
 tools/testing/selftests/bpf/test_sysctl.c     |  4 ++-
 tools/testing/selftests/bpf/test_tag.c        |  4 ++-
 .../bpf/test_tcp_check_syncookie_user.c       |  4 ++-
 .../selftests/bpf/test_tcpnotify_user.c       |  1 -
 .../testing/selftests/bpf/test_verifier_log.c |  5 ++--
 .../selftests/bpf/xdp_redirect_multi.c        |  1 -
 tools/testing/selftests/bpf/xdping.c          |  8 ++----
 tools/testing/selftests/bpf/xdpxceiver.c      |  6 ++--
 61 files changed, 57 insertions(+), 142 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/bpf_rlimit.h

-- 
2.17.1

