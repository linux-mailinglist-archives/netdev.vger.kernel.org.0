Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44685595464
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiHPIDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiHPICj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:02:39 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE853105204;
        Mon, 15 Aug 2022 22:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660627464; x=1692163464;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n8bWLRAjIHlbdQt28PJjzumM4XdGGn+8swvssjGZUGI=;
  b=lUXmOJK1xCbUbIy4WxeGzoFaP3AwvlFgP0hy2ZDTXqMRyDk3MMS4X+je
   ywWJYAtO6sBoZi7qsUEURM3MdsJqn+E/V9vvK0Ze+8hjROTmXcGxbHZde
   IL0IBD1NaFr8CMujaun0d/1h/jFW4euWRfu1RF85FOv7tMmoqEi351LMA
   A=;
X-IronPort-AV: E=Sophos;i="5.93,240,1654560000"; 
   d="scan'208";a="230038836"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 05:24:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com (Postfix) with ESMTPS id 9E48C81280;
        Tue, 16 Aug 2022 05:24:10 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 16 Aug 2022 05:24:09 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 16 Aug 2022 05:24:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 net 00/15] sysctl: Fix data-races around net.core.XXX (Round 1)
Date:   Mon, 15 Aug 2022 22:23:32 -0700
Message-ID: <20220816052347.70042-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D24UWB003.ant.amazon.com (10.43.161.222) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes data-races around 22 knobs in net_core_table.
These knobs are skipped:

  - netdev_rss_key: Written only once by net_get_random_once() and
                    read-only knob
  - rps_sock_flow_entries: Protected with sock_flow_mutex
  - flow_limit_cpu_bitmap: Protected with flow_limit_update_mutex
  - flow_limit_table_len: Protected with flow_limit_update_mutex
  - default_qdisc: Protected with qdisc_mod_lock
  - warnings: Unused

Note 9th patch fixes net.core.message_cost and net.core.message_burst,
and lib/ratelimit.c does not have an explicit maintainer.

The next round is the final round for net.core.XXX and starts from
netdev_budget_usecs.


Kuniyuki Iwashima (15):
  net: Fix data-races around sysctl_[rw]mem_(max|default).
  net: Fix data-races around weight_p and dev_weight_[rt]x_bias.
  net: Fix data-races around netdev_max_backlog.
  bpf: Fix data-races around bpf_jit_enable.
  bpf: Fix data-races around bpf_jit_harden.
  bpf: Fix data-races around bpf_jit_kallsyms.
  bpf: Fix a data-race around bpf_jit_limit.
  net: Fix data-races around netdev_tstamp_prequeue.
  ratelimit: Fix data-races in ___ratelimit().
  net: Fix data-races around sysctl_optmem_max.
  net: Fix a data-race around sysctl_tstamp_allow_data.
  net: Fix a data-race around sysctl_net_busy_poll.
  net: Fix a data-race around sysctl_net_busy_read.
  net: Fix a data-race around netdev_budget.
  net: Fix data-races around sysctl_max_skb_frags.

 Documentation/admin-guide/sysctl/net.rst |  2 +-
 arch/arm/net/bpf_jit_32.c                |  2 +-
 arch/arm64/net/bpf_jit_comp.c            |  2 +-
 arch/mips/net/bpf_jit_comp.c             |  2 +-
 arch/powerpc/net/bpf_jit_comp.c          |  5 +++--
 arch/riscv/net/bpf_jit_core.c            |  2 +-
 arch/s390/net/bpf_jit_comp.c             |  2 +-
 arch/sparc/net/bpf_jit_comp_32.c         |  5 +++--
 arch/sparc/net/bpf_jit_comp_64.c         |  5 +++--
 arch/x86/net/bpf_jit_comp.c              |  2 +-
 arch/x86/net/bpf_jit_comp32.c            |  2 +-
 include/linux/filter.h                   | 16 ++++++++++------
 include/net/busy_poll.h                  |  2 +-
 kernel/bpf/core.c                        |  2 +-
 lib/ratelimit.c                          |  8 +++++---
 net/core/bpf_sk_storage.c                |  5 +++--
 net/core/dev.c                           | 16 ++++++++--------
 net/core/filter.c                        | 13 +++++++------
 net/core/gro_cells.c                     |  2 +-
 net/core/skbuff.c                        |  2 +-
 net/core/sock.c                          | 18 ++++++++++--------
 net/core/sysctl_net_core.c               | 10 ++++++----
 net/ipv4/ip_output.c                     |  2 +-
 net/ipv4/ip_sockglue.c                   |  6 +++---
 net/ipv4/tcp.c                           |  4 ++--
 net/ipv4/tcp_output.c                    |  2 +-
 net/ipv6/ipv6_sockglue.c                 |  4 ++--
 net/mptcp/protocol.c                     |  2 +-
 net/netfilter/ipvs/ip_vs_sync.c          |  4 ++--
 net/sched/sch_generic.c                  |  2 +-
 net/xfrm/espintcp.c                      |  2 +-
 net/xfrm/xfrm_input.c                    |  2 +-
 32 files changed, 85 insertions(+), 70 deletions(-)

-- 
2.30.2

