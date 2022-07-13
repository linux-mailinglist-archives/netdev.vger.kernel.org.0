Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044E3573E33
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237220AbiGMUwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiGMUwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:52:42 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F85A31386
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657745562; x=1689281562;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uSVlv/XH9yPey7VpaaLtoxtBuwjTbqjOelAaonXXg00=;
  b=MdBMiLYvBXQbwh1dGB7Zh1+eMhM1aps1DiXifMhKwnEfq0HR5s5834nn
   cv+2WZiGmXx2mGq9ZiCY6UINLhfazMg2I4EdH69kNaWlCDsx8gB3N3m0m
   tb9AS5HMvZaKNylb/HhYYZ+mSEchj+rqCxlHeggyqpFcCHujIfQQQ6ZYw
   g=;
X-IronPort-AV: E=Sophos;i="5.92,269,1650931200"; 
   d="scan'208";a="217996655"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 13 Jul 2022 20:52:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com (Postfix) with ESMTPS id 09F80C089E;
        Wed, 13 Jul 2022 20:52:30 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 13 Jul 2022 20:52:29 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 13 Jul 2022 20:52:27 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 00/15] sysctl: Fix data-races around ipv4_net_table (Round 2).
Date:   Wed, 13 Jul 2022 13:51:50 -0700
Message-ID: <20220713205205.15735-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.222]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes data-races around 15 knobs after ip_default_ttl in
ipv4_net_table.

These two knobs are skipped.
  - ip_local_port_range is safe with its own lock.
  - ip_local_reserved_ports uses proc_do_large_bitmap(), which will need
    an additional lock and can be fixed later.

So, the next round will start with igmp_link_local_mcast_reports.


Kuniyuki Iwashima (15):
  ip: Fix data-races around sysctl_ip_default_ttl.
  ip: Fix data-races around sysctl_ip_no_pmtu_disc.
  ip: Fix data-races around sysctl_ip_fwd_use_pmtu.
  ip: Fix data-races around sysctl_ip_fwd_update_priority.
  ip: Fix data-races around sysctl_ip_nonlocal_bind.
  ip: Fix a data-race around sysctl_ip_autobind_reuse.
  ip: Fix a data-race around sysctl_fwmark_reflect.
  tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.
  tcp: Fix data-races around sysctl_tcp_l3mdev_accept.
  tcp: Fix data-races around sysctl_tcp_mtu_probing.
  tcp: Fix data-races around sysctl_tcp_base_mss.
  tcp: Fix data-races around sysctl_tcp_min_snd_mss.
  tcp: Fix a data-race around sysctl_tcp_mtu_probe_floor.
  tcp: Fix a data-race around sysctl_tcp_probe_threshold.
  tcp: Fix a data-race around sysctl_tcp_probe_interval.

 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |  3 ++-
 drivers/net/ethernet/netronome/nfp/flower/action.c    |  2 +-
 include/net/inet_hashtables.h                         |  2 +-
 include/net/inet_sock.h                               |  9 +++++----
 include/net/ip.h                                      |  4 ++--
 include/net/route.h                                   |  2 +-
 net/ipv4/af_inet.c                                    |  2 +-
 net/ipv4/icmp.c                                       |  2 +-
 net/ipv4/inet_connection_sock.c                       |  2 +-
 net/ipv4/ip_forward.c                                 |  2 +-
 net/ipv4/ip_sockglue.c                                |  2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                   |  4 ++--
 net/ipv4/proc.c                                       |  2 +-
 net/ipv4/route.c                                      |  2 +-
 net/ipv4/tcp_output.c                                 | 11 ++++++-----
 net/ipv4/tcp_timer.c                                  |  8 ++++----
 net/ipv6/af_inet6.c                                   |  2 +-
 net/netfilter/nf_synproxy_core.c                      |  2 +-
 net/sctp/protocol.c                                   |  2 +-
 net/xfrm/xfrm_state.c                                 |  2 +-
 20 files changed, 35 insertions(+), 32 deletions(-)

-- 
2.30.2

