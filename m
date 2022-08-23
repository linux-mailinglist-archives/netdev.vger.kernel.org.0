Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8483659EBE0
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiHWTK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiHWTJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:09:54 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77CD85F8D
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661276902; x=1692812902;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KzABdGe6rWffTcmx0GIpwMdOdMit5XuZCprUqNsVCXE=;
  b=u63POraYi3nFsf2gAA/MDxYLPLRgWU+v2SskorrRJf2IHgfbNbvnCFdG
   57flDmCxmZf0NwYtfOe1NJL+FRjTOLRJx+GoXMLn6orbvOIK2fftJraOv
   BOH6Q1/KNEeu0H5UEvU0N6T1UJ6jEvnj5oQe8kRGZfWwa/PKyK+4qJz/7
   M=;
X-IronPort-AV: E=Sophos;i="5.93,258,1654560000"; 
   d="scan'208";a="220379853"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:48:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com (Postfix) with ESMTPS id 25B65123373;
        Tue, 23 Aug 2022 17:47:59 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 23 Aug 2022 17:47:56 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.160) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 23 Aug 2022 17:47:54 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 net 00/17] net: sysctl: Fix data-races around net.core.XXX
Date:   Tue, 23 Aug 2022 10:46:43 -0700
Message-ID: <20220823174700.88411-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.160]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes data-races around all knobs in net_core_table and
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
  v4:
    * Add mutex in patch 2
    * Add comments in patch 5

  v3: https://lore.kernel.org/netdev/20220818182653.38940-1-kuniyu@amazon.com/
    * Fix build failures of CONFIG_SYSCTL=n case in 13th & 14th patches

  v2: https://lore.kernel.org/netdev/20220818035227.81567-1-kuniyu@amazon.com/
    * Remove 4 bpf knobs and added 6 knobs

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
 include/linux/netdevice.h                | 20 +++++++++++++++++---
 include/net/busy_poll.h                  |  2 +-
 include/net/gro.h                        |  2 +-
 lib/ratelimit.c                          | 12 +++++++++---
 net/core/bpf_sk_storage.c                |  5 +++--
 net/core/dev.c                           | 20 ++++++++++----------
 net/core/filter.c                        | 13 +++++++------
 net/core/gro_cells.c                     |  2 +-
 net/core/skbuff.c                        |  2 +-
 net/core/sock.c                          | 18 ++++++++++--------
 net/core/sysctl_net_core.c               | 15 +++++++++------
 net/ipv4/devinet.c                       | 16 ++++++++++------
 net/ipv4/ip_output.c                     |  2 +-
 net/ipv4/ip_sockglue.c                   |  6 +++---
 net/ipv4/tcp.c                           |  4 ++--
 net/ipv4/tcp_output.c                    |  2 +-
 net/ipv6/addrconf.c                      |  5 ++---
 net/ipv6/ipv6_sockglue.c                 |  4 ++--
 net/mptcp/protocol.c                     |  2 +-
 net/netfilter/ipvs/ip_vs_sync.c          |  4 ++--
 net/sched/sch_generic.c                  |  2 +-
 net/socket.c                             |  2 +-
 net/xfrm/espintcp.c                      |  2 +-
 net/xfrm/xfrm_input.c                    |  2 +-
 25 files changed, 98 insertions(+), 68 deletions(-)

-- 
2.30.2

