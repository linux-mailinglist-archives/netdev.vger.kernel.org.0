Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B3D598B19
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244348AbiHRS1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235520AbiHRS1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:27:21 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FC8CE486
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660847241; x=1692383241;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TAGy+BHGUqnNmP1NWPOu4uZjKfwq7SBuXfCWH+aC1D0=;
  b=cPt2cyClFXKnEiDjyJBxggh56oBVi2eK0lvuocBSKZCFpUPA2tLz/cB+
   t4D93pnJgvhfSPqx3jPHlKfTWsWCybx47lEe6al+G97bIDoPEuyP7iqU+
   XfsGaCdpCDw+vggWSfAbvZPwYemoLjf0ZNf8oa2jZnLm9T6RR7n9OAgbW
   I=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="231266004"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-72dc3927.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 18:27:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-72dc3927.us-west-2.amazon.com (Postfix) with ESMTPS id C1F3044AF7;
        Thu, 18 Aug 2022 18:27:07 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 18:27:06 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.85) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 18:27:04 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net 00/17] net: sysctl: Fix data-races around net.core.XXX
Date:   Thu, 18 Aug 2022 11:26:36 -0700
Message-ID: <20220818182653.38940-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D13UWB003.ant.amazon.com (10.43.161.233) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
  v3:
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
 lib/ratelimit.c                          |  8 +++++---
 net/core/bpf_sk_storage.c                |  5 +++--
 net/core/dev.c                           | 20 ++++++++++----------
 net/core/filter.c                        | 13 +++++++------
 net/core/gro_cells.c                     |  2 +-
 net/core/skbuff.c                        |  2 +-
 net/core/sock.c                          | 18 ++++++++++--------
 net/core/sysctl_net_core.c               |  6 ++++--
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
 25 files changed, 89 insertions(+), 64 deletions(-)

-- 
2.30.2

