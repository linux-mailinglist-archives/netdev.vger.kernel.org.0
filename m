Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7928597C73
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242931AbiHRDxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240154AbiHRDw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:52:57 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC65D5A2C1
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 20:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660794777; x=1692330777;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sRHQwGOzqmz2VL7LPSwSD+inAmzz1OJ9kOO5xGTrV6Q=;
  b=fnzxE3G1Zpk2sC/wkrOT0BZYqlBtNqFmryrnuWwkTpGgwp/PnbtfMkhr
   XZfcWwIWh6Cwmm16ud/z8oIG+y58nQphX+YM78gZxMejp9k3K4p1Mw65M
   UiEER9gKvpFgFTYgb6wP8r/dF8RiWFHRGvnN1ydH6FpiPbi98Q8Gy45V4
   s=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-f771ae83.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 03:52:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-f771ae83.us-east-1.amazon.com (Postfix) with ESMTPS id 431441200AB;
        Thu, 18 Aug 2022 03:52:44 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 03:52:43 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 03:52:41 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net 00/17] net: sysctl: Fix data-races around net.core.XXX
Date:   Wed, 17 Aug 2022 20:52:10 -0700
Message-ID: <20220818035227.81567-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes data-races around knobs in net_core_table and
netns_core_table except for bpf stuff.

These knobs are skipped:

  - 4 bpf knobs
  - netdev_rss_key: Written only once by net_get_random_once() and
                    read-only knob
  - rps_sock_flow_entries: Protected with sock_flow_mutex
  - flow_limit_cpu_bitmap: Protected with flow_limit_update_mutex
  - flow_limit_table_len: Protected with flow_limit_update_mutex
  - default_qdisc: Protected with qdisc_mod_lock
  - warnings: Unused
  - high_order_alloc_disable: Protected with static_key_mutex
  - skb_defer_max: Already using READ_ONCE()
  - sysctl_txrehash: Already using READ_ONCE()

Note 5th patch fixes net.core.message_cost and net.core.message_burst,
and lib/ratelimit.c does not have an explicit maintainer.


Changes:
  v2
    * Split 4 bpf knobs and added 6 net knobs.

  v1: https://lore.kernel.org/netdev/20220816052347.70042-1-kuniyu@amazon.com/


Kuniyuki Iwashima (17):
  net: Fix data-races around sysctl_[rw]mem_(max|default).
  net: Fix data-races around weight_p and dev_weight_[rt]x_bias.
  net: Fix data-races around netdev_max_backlog.
  net: Fix data-races around netdev_tstamp_prequeue.
  ratelimit: Fix data-races in ___ratelimit().
  net: Fix data-races around sysctl_optmem_max.
  net: Fix a data-race around sysctl_tstamp_allow_data.
  net: Fix a data-race around sysctl_net_busy_poll.
  net: Fix a data-race around sysctl_net_busy_read.
  net: Fix a data-race around netdev_budget.
  net: Fix data-races around sysctl_max_skb_frags.
  net: Fix a data-race around netdev_budget_usecs.
  net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.
  net: Fix data-races around sysctl_devconf_inherit_init_net.
  net: Fix a data-race around gro_normal_batch.
  net: Fix a data-race around netdev_unregister_timeout_secs.
  net: Fix a data-race around sysctl_somaxconn.

 Documentation/admin-guide/sysctl/net.rst |  2 +-
 include/linux/netdevice.h                |  6 ++++--
 include/net/busy_poll.h                  |  2 +-
 include/net/gro.h                        |  2 +-
 lib/ratelimit.c                          |  8 +++++---
 net/core/bpf_sk_storage.c                |  5 +++--
 net/core/dev.c                           | 20 ++++++++++----------
 net/core/filter.c                        | 13 +++++++------
 net/core/gro_cells.c                     |  2 +-
 net/core/skbuff.c                        |  2 +-
 net/core/sock.c                          | 18 ++++++++++--------
 net/core/sysctl_net_core.c               |  6 ++++--
 net/ipv4/devinet.c                       |  6 ++++--
 net/ipv4/ip_output.c                     |  2 +-
 net/ipv4/ip_sockglue.c                   |  6 +++---
 net/ipv4/tcp.c                           |  4 ++--
 net/ipv4/tcp_output.c                    |  2 +-
 net/ipv6/addrconf.c                      |  2 +-
 net/ipv6/ipv6_sockglue.c                 |  4 ++--
 net/mptcp/protocol.c                     |  2 +-
 net/netfilter/ipvs/ip_vs_sync.c          |  4 ++--
 net/sched/sch_generic.c                  |  2 +-
 net/socket.c                             |  2 +-
 net/xfrm/espintcp.c                      |  2 +-
 net/xfrm/xfrm_input.c                    |  2 +-
 25 files changed, 69 insertions(+), 57 deletions(-)

-- 
2.30.2

