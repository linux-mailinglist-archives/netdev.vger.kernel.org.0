Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5CF5782EB
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbiGRM70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiGRM7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:59:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DD010A2;
        Mon, 18 Jul 2022 05:59:22 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LmhlT5bmbzVftZ;
        Mon, 18 Jul 2022 20:55:33 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 18 Jul 2022 20:59:20 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 18 Jul 2022 20:59:20 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next v2 0/5] cleanup for data casting
Date:   Mon, 18 Jul 2022 21:29:33 +0800
Message-ID: <20220718132938.1031864-1-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, we found that memory address casting in libbpf
was not appropriate [0]. Memory addresses are conceptually
unsigned, (unsigned long) casting makes more sense. With the
suggestion of Daniel, we applied this cleanup to the entire
bpf, and there is no functional change.

[0] https://lore.kernel.org/bpf/a31efed5-a436-49c9-4126-902303df9766@iogearbox.net/

v2:
- update subject and commit msg of patch 5.
- attach ack of Yonghong.

v1: https://lore.kernel.org/bpf/20220716125108.1011206-1-pulehui@huawei.com/

Pu Lehui (5):
  bpf: Unify memory address casting operation style
  libbpf: Unify memory address casting operation style
  selftests: bpf: Unify memory address casting operation style
  samples: bpf: Unify memory address casting operation style
  selftests/bpf: Change the casting about jited_ksyms and jited_linfo

 kernel/bpf/core.c                             |  2 +-
 kernel/bpf/helpers.c                          |  6 +--
 kernel/bpf/syscall.c                          |  2 +-
 kernel/bpf/verifier.c                         |  6 +--
 samples/bpf/parse_simple.c                    |  4 +-
 samples/bpf/parse_varlen.c                    |  4 +-
 samples/bpf/tc_l2_redirect_kern.c             | 16 +++----
 samples/bpf/test_cgrp2_tc_kern.c              |  4 +-
 samples/bpf/test_lwt_bpf.c                    |  4 +-
 samples/bpf/xdp_adjust_tail_kern.c            | 12 ++---
 samples/bpf/xdp_fwd_kern.c                    |  4 +-
 samples/bpf/xdp_redirect.bpf.c                |  4 +-
 samples/bpf/xdp_redirect_cpu.bpf.c            | 48 +++++++++----------
 samples/bpf/xdp_redirect_map.bpf.c            |  8 ++--
 samples/bpf/xdp_redirect_map_multi.bpf.c      |  4 +-
 samples/bpf/xdp_router_ipv4.bpf.c             |  4 +-
 samples/bpf/xdp_rxq_info_kern.c               |  4 +-
 samples/bpf/xdp_sample_pkts_kern.c            |  4 +-
 samples/bpf/xdp_tx_iptunnel_kern.c            | 20 ++++----
 tools/lib/bpf/bpf_prog_linfo.c                |  8 ++--
 tools/lib/bpf/btf.c                           |  7 +--
 tools/lib/bpf/skel_internal.h                 |  4 +-
 tools/lib/bpf/usdt.c                          |  4 +-
 tools/testing/selftests/bpf/bench.c           |  4 +-
 .../selftests/bpf/prog_tests/bpf_obj_id.c     | 10 ++--
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |  2 +-
 tools/testing/selftests/bpf/prog_tests/btf.c  | 20 ++++----
 .../bpf/prog_tests/core_read_macros.c         |  8 ++--
 .../selftests/bpf/prog_tests/hashmap.c        |  8 ++--
 .../selftests/bpf/prog_tests/ringbuf.c        |  4 +-
 .../selftests/bpf/prog_tests/ringbuf_multi.c  |  4 +-
 .../bpf/prog_tests/sockopt_inherit.c          |  2 +-
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 10 ++--
 tools/testing/selftests/bpf/progs/core_kern.c |  4 +-
 .../selftests/bpf/progs/fexit_bpf2bpf.c       |  8 ++--
 tools/testing/selftests/bpf/progs/pyperf.h    |  4 +-
 .../testing/selftests/bpf/progs/skb_pkt_end.c |  4 +-
 .../selftests/bpf/progs/sockmap_parse_prog.c  |  8 ++--
 .../bpf/progs/sockmap_verdict_prog.c          |  4 +-
 .../bpf/progs/test_btf_skc_cls_ingress.c      |  8 ++--
 .../selftests/bpf/progs/test_check_mtu.c      | 16 +++----
 .../selftests/bpf/progs/test_cls_redirect.c   |  8 ++--
 tools/testing/selftests/bpf/progs/test_l4lb.c |  6 +--
 .../selftests/bpf/progs/test_l4lb_noinline.c  |  6 +--
 .../selftests/bpf/progs/test_lwt_seg6local.c  | 10 ++--
 .../bpf/progs/test_migrate_reuseport.c        |  4 +-
 .../selftests/bpf/progs/test_pkt_access.c     |  8 ++--
 .../bpf/progs/test_queue_stack_map.h          |  4 +-
 .../selftests/bpf/progs/test_seg6_loop.c      |  8 ++--
 .../selftests/bpf/progs/test_sk_assign.c      |  8 ++--
 .../selftests/bpf/progs/test_sk_lookup_kern.c |  4 +-
 .../selftests/bpf/progs/test_sockmap_kern.h   | 12 ++---
 .../selftests/bpf/progs/test_tc_dtime.c       |  2 +-
 .../testing/selftests/bpf/progs/test_tc_edt.c |  6 +--
 .../selftests/bpf/progs/test_tc_neigh.c       |  2 +-
 .../selftests/bpf/progs/test_tc_neigh_fib.c   |  2 +-
 .../bpf/progs/test_tcp_check_syncookie_kern.c |  8 ++--
 .../selftests/bpf/progs/test_tunnel_kern.c    | 12 ++---
 .../selftests/bpf/progs/test_verif_scale1.c   |  4 +-
 .../selftests/bpf/progs/test_verif_scale2.c   |  4 +-
 .../selftests/bpf/progs/test_verif_scale3.c   |  4 +-
 tools/testing/selftests/bpf/progs/test_xdp.c  | 20 ++++----
 .../bpf/progs/test_xdp_adjust_tail_grow.c     |  4 +-
 .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  4 +-
 .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |  4 +-
 .../bpf/progs/test_xdp_context_test_run.c     |  4 +-
 .../bpf/progs/test_xdp_devmap_helpers.c       |  4 +-
 .../bpf/progs/test_xdp_do_redirect.c          | 14 +++---
 .../selftests/bpf/progs/test_xdp_loop.c       | 20 ++++----
 .../selftests/bpf/progs/test_xdp_noinline.c   | 28 +++++------
 .../bpf/progs/test_xdp_update_frags.c         |  4 +-
 .../selftests/bpf/progs/test_xdp_vlan.c       | 16 +++----
 .../bpf/progs/test_xdp_with_devmap_helpers.c  |  4 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  8 ++--
 .../selftests/bpf/progs/xdp_synproxy_kern.c   | 16 +++----
 .../testing/selftests/bpf/progs/xdping_kern.c | 12 ++---
 tools/testing/selftests/bpf/progs/xdpwall.c   |  4 +-
 77 files changed, 301 insertions(+), 298 deletions(-)

-- 
2.25.1

