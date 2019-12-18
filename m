Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AF1124630
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfLRLxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:53:43 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46721 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLRLxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:53:43 -0500
Received: by mail-pf1-f193.google.com with SMTP id y14so1063207pfm.13
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9sPANbPAl+E3uP3x6sXINIt01H+sSnhfDdo/0WQiL+w=;
        b=YuOoAmM4l0NlLsXoO1UflGRHo18DIb+Tjj6z0TyhXGXzet/UmVkeoCefO8Px7qTyZk
         rIR0fN5Y7b4K3wRvZu4PP2vCx3zrInMKefJjdC6J3jzbuczAtQsAHiXHu++5gJ+CDDj9
         nBjYh9go9k/XRUJcQLTrTEsgC9sff957rr9xlVylLt8NVkW9oEctqPbmiu1eleIpUgbx
         IhQdvNaxOD5v8lG0J5MThLM41Cys5zEfNPjaFuXZTI4zJ/vzyOnnIKPRUdd80f2jBlFz
         0q71oiXJxk7xjs5/eMn+aFqmW3Myet/bgljk3A1FowAkjGCdaWAwE0b8iQqL0cngLVmu
         qTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9sPANbPAl+E3uP3x6sXINIt01H+sSnhfDdo/0WQiL+w=;
        b=JQ/1LsYnGaEA/rCDI130FRx/BDekeRB9F58TEJ/aNN+Be4jZmVHMCD+oUrW9T4nhpi
         qMvKG75hu74up+87+kn7uTXufu6386u0/6xjUlBSYLCmyTXF+QXqkbK0w4XQ1Fn+yyIy
         jbjxrqMY/0yodDH7omhlRaGQ5NAwtR+nvfQrbPoMpZBCn+ZcCPw6zmUEFNe2cIbzIjU+
         D7ovT4s0Htq/iSO1FQKkszVq41syktFTm4jkMxV4I23qu7y09txg8iuoHtIM7E0VTh04
         Y5kW9cnZlm35NityvR1/xiaIXMEy8RRmNe41W5Z2jiZuFtyS2ZHuigbvMRyzJILFFp/z
         W4lg==
X-Gm-Message-State: APjAAAVoRC8P2E4Hka4EE3b2hnYBnr9uT4ANF2KRTiDGg+iJhXAFapHk
        B335099pT/VpWnQtRIEGH1FdbyKLaDE=
X-Google-Smtp-Source: APXvYqxQX8l03OjfxuVXMrcngHYd+N9FVjYSROI7/F9aLM0wT1EVjohqXeCETL4Bu6JTOVC0swyW1A==
X-Received: by 2002:a63:1756:: with SMTP id 22mr2655055pgx.109.1576670021979;
        Wed, 18 Dec 2019 03:53:41 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x33sm2961067pga.86.2019.12.18.03.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:53:41 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 0/8] disable neigh update for tunnels during pmtu update
Date:   Wed, 18 Dec 2019 19:53:05 +0800
Message-Id: <20191218115313.19352-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191203021137.26809-1-liuhangbin@gmail.com>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we setup a pair of gretap, ping each other and create neighbour cache.
Then delete and recreate one side. We will never be able to ping6 to the new
created gretap.

The reason is when we ping6 remote via gretap, we will call like

gre_tap_xmit()
 - ip_tunnel_xmit()
   - tnl_update_pmtu()
     - skb_dst_update_pmtu()
       - ip6_rt_update_pmtu()
         - __ip6_rt_update_pmtu()
           - dst_confirm_neigh()
             - ip6_confirm_neigh()
               - __ipv6_confirm_neigh()
                 - n->confirmed = now

As the confirmed time updated, in neigh_timer_handler() the check for
NUD_DELAY confirm time will pass and the neigh state will back to
NUD_REACHABLE. So the old/wrong mac address will be used again.

If we do not update the confirmed time, the neigh state will go to
neigh->nud_state = NUD_PROBE; then go to NUD_FAILED and re-create the
neigh later, which is what IPv4 does.

We couldn't remove the ip6_confirm_neigh() directly as we still need it
for TCP flows. To fix it, we have to pass a bool parameter to
dst_ops.update_pmtu() and only disable neighbor update for tunnels.

v2: remove dst_confirm_neigh directly
v3: add bool confirm_neigh parameter for all dst_ops.update_pmtu and
    disable neigh update on each tunnel device.

---
Reproducer:

#!/bin/bash
set -x
ip -a netns del
modprobe -r veth
modprobe -r bridge

ip netns add ha
ip netns add hb
ip link add br0 type bridge
ip link set br0 up
ip link add br_ha type veth peer name veth0 netns ha
ip link add br_hb type veth peer name veth0 netns hb
ip link set br_ha up
ip link set br_hb up
ip link set br_ha master br0
ip link set br_hb master br0
ip netns exec ha ip link set veth0 up
ip netns exec hb ip link set veth0 up
ip netns exec ha ip addr add 192.168.0.1/24 dev veth0
ip netns exec hb ip addr add 192.168.0.2/24 dev veth0

ip netns exec ha ip link add gretap1 type gretap local 192.168.0.1 remote 192.168.0.2
ip netns exec ha ip link set gretap1 up
ip netns exec ha ip addr add 1.1.1.1/24 dev gretap1
ip netns exec ha ip addr add 1111::1/64 dev gretap1

ip netns exec hb ip link add gretap1 type gretap local 192.168.0.2 remote 192.168.0.1
ip netns exec hb ip link set gretap1 up
ip netns exec hb ip addr add 1.1.1.2/24 dev gretap1
ip netns exec hb ip addr add 1111::2/64 dev gretap1

ip netns exec ha ping 1.1.1.2 -c 4
ip netns exec ha ping6 1111::2 -c 4
sleep 30

# recreate gretap
ip netns exec hb ip link del gretap1
ip netns exec hb ip link add gretap1 type gretap local 192.168.0.2 remote 192.168.0.1
ip netns exec hb ip link set gretap1 up
ip netns exec hb ip addr add 1.1.1.2/24 dev gretap1
ip netns exec hb ip addr add 1111::2/64 dev gretap1
ip netns exec hb ip link show dev gretap1

ip netns exec ha ip neigh show dev gretap1
ip netns exec ha ping 1.1.1.2 -c 4
ip netns exec ha ping6 1111::2 -c 4
ip netns exec ha ip neigh show dev gretap1
sleep 10
ip netns exec ha ip neigh show dev gretap1
ip netns exec ha ping 1.1.1.2 -c 4
ip netns exec ha ping6 1111::2 -c 4
ip netns exec ha ip neigh show dev gretap1
---

Hangbin Liu (8):
  net: add bool confirm_neigh parameter for dst_ops.update_pmtu
  ip6_gre: do not confirm neighbor when do pmtu update
  gtp: do not confirm neighbor when do pmtu update
  net/dst: add new function skb_dst_update_pmtu_no_confirm
  tunnel: do not confirm neighbor when do pmtu update
  vti: do not confirm neighbor when do pmtu update
  sit: do not confirm neighbor when do pmtu update
  net/dst: do not confirm neighbor for vxlan and geneve pmtu update

 drivers/net/gtp.c                |  2 +-
 include/net/dst.h                | 13 +++++++++++--
 include/net/dst_ops.h            |  3 ++-
 net/bridge/br_nf_core.c          |  3 ++-
 net/decnet/dn_route.c            |  6 ++++--
 net/ipv4/inet_connection_sock.c  |  2 +-
 net/ipv4/ip_tunnel.c             |  2 +-
 net/ipv4/ip_vti.c                |  2 +-
 net/ipv4/route.c                 |  9 ++++++---
 net/ipv4/xfrm4_policy.c          |  5 +++--
 net/ipv6/inet6_connection_sock.c |  2 +-
 net/ipv6/ip6_gre.c               |  2 +-
 net/ipv6/ip6_tunnel.c            |  4 ++--
 net/ipv6/ip6_vti.c               |  2 +-
 net/ipv6/route.c                 | 22 +++++++++++++++-------
 net/ipv6/sit.c                   |  2 +-
 net/ipv6/xfrm6_policy.c          |  5 +++--
 net/netfilter/ipvs/ip_vs_xmit.c  |  2 +-
 net/sctp/transport.c             |  2 +-
 19 files changed, 58 insertions(+), 32 deletions(-)

-- 
2.19.2

