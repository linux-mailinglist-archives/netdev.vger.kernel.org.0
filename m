Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7B74F40F6
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbiDEO03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237937AbiDEOUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:20:46 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A719151E6F;
        Tue,  5 Apr 2022 06:09:15 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso2482461pju.1;
        Tue, 05 Apr 2022 06:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3FFNV87EXG2IlcFtQbV+gadr6ihjV5o7kcHPrr2ZxtU=;
        b=FxPklN7jYnofqaoSYi333INbk7S+qlkPuoG3q10/dDTQlILeiP1skMTiNiDboGCM1n
         A4xDwzz55OV0SIbgYdBp8BPudlw+uNqz6cv5Lp1Si8tEbMihoEWfu6pCAsCR2RhDBV4w
         XeMFvARIZ2RGOSNx818CBfe9UC7aofw9MQAKc3q9kZP+atdLEe9Ju8PllDEVyrTUu9QB
         oRkGErEFf02jHiqCGZs1ocM5jyGW0vmah8tMcLqpykUF+Ug4lB7Yaubsa5fDF2Zg7sID
         f1vFStdOBOTwVraoNYhRRoMgH2a82oe8Aovj/CyNmROkYHdwtuJt9vjhbzutYYM9bfse
         fCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3FFNV87EXG2IlcFtQbV+gadr6ihjV5o7kcHPrr2ZxtU=;
        b=6G/RaupNQ8V8s3zj4dGKvXN2dPACv63H8jLbrvqrsF9rYbk0yS2VaX1lfxS2db6eC6
         ihf4qhIZuASaFOWmn7iYZUFjiYrgxL6aLFDwtlFofBOL6YOqoA4iws2pEHEl8inB44kA
         VVdrDe/tXOmMUq5nqCQat7ax1ycK/JvmLINd1yqvKTSIXs0U/aXuNgCdik+lboi2LG11
         aRt+9SzFXSvBxibZwVOkIwWil9N75CRf9Fz2UePayAC8iozfK39FWe36aEiEwXdO5Gkj
         8mA/diibjma7nu91/VSXU344+zhixbno96ki50FA2xdzmli5hyzByDwwXQCpzbDtUDhp
         etyA==
X-Gm-Message-State: AOAM533Kl/emhvIKxMkaYCPJ6842bdB6B9r73OH8QIwfdfLmqyBOVI42
        ducwL6dlZSvJIES9T82vG4MixNozG5WTYtkR6/8=
X-Google-Smtp-Source: ABdhPJxjXPmjPJSkSoXv0dy9HmEmQGpx4g7jQasQCdfUTD1cvhaoUI41tRvAsvCGUmKHXpBwxUUFWg==
X-Received: by 2002:a17:902:cecb:b0:154:68b6:cf61 with SMTP id d11-20020a170902cecb00b0015468b6cf61mr3333777plg.12.1649164155020;
        Tue, 05 Apr 2022 06:09:15 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:14 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 00/27] bpf: RLIMIT_MEMLOCK cleanups 
Date:   Tue,  5 Apr 2022 13:08:31 +0000
Message-Id: <20220405130858.12165-1-laoar.shao@gmail.com>
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

We have switched to memcg based memory accouting and thus the rlimit is
not needed any more. LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK was introduced in
libbpf for backward compatibility, so we can use it instead now.

This patchset cleanups the usage of RLIMIT_MEMLOCK in tools/bpf/,
tools/testing/selftests/bpf and samples/bpf. The file
tools/testing/selftests/bpf/bpf_rlimit.h is removed. The included header
sys/resource.h is removed from many files as it is useless in these files.

- v3: Get rid of bpf_rlimit.h and fix some typos (Andrii)
- v2: Use libbpf_set_strict_mode instead. (Andrii)
- v1: https://lore.kernel.org/bpf/20220320060815.7716-2-laoar.shao@gmail.com/

Yafang Shao (27):
  bpf: selftests: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in
    xdping
  bpf: selftests: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in
    xdpxceiver
  bpf: selftests: No need to include bpf_rlimit.h in test_tcpnotify_user
  bpf: selftests: No need to include bpf_rlimit.h in flow_dissector_load
  bpf: selftests: Set libbpf 1.0 API mode explicitly in
    get_cgroup_id_user
  bpf: selftests: Set libbpf 1.0 API mode explicitly in
    test_cgroup_storage
  bpf: selftests: Set libbpf 1.0 API mode explicitly in
    get_cgroup_id_user
  bpf: selftests: Set libbpf 1.0 API mode explicitly in test_lpm_map
  bpf: selftests: Set libbpf 1.0 API mode explicitly in test_lru_map
  bpf: selftests: Set libbpf 1.0 API mode explicitly in
    test_skb_cgroup_id_user
  bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sock_addr
  bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sock
  bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sockmap
  bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sysctl
  bpf: selftests: Set libbpf 1.0 API mode explicitly in test_tag
  bpf: selftests: Set libbpf 1.0 API mode explicitly in
    test_tcp_check_syncookie_user
  bpf: selftests: Set libbpf 1.0 API mode explicitly in
    test_verifier_log
  bpf: samples: Set libbpf 1.0 API mode explicitly in hbm
  bpf: selftests: Get rid of bpf_rlimit.h
  bpf: selftests: No need to include sys/resource.h in some files
  bpf: samples: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in
    xdpsock_user
  bpf: samples: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in
    xsk_fwd
  bpf: samples: No need to include sys/resource.h in many files
  bpf: bpftool: Remove useless return value of libbpf_set_strict_mode
  bpf: bpftool: Set LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK for legacy libbpf
  bpf: bpftool: remove RLIMIT_MEMLOCK
  bpf: runqslower: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK

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

