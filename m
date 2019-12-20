Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA8391273D3
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 04:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfLTDZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 22:25:45 -0500
Received: from mail-pg1-f171.google.com ([209.85.215.171]:38000 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfLTDZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 22:25:44 -0500
Received: by mail-pg1-f171.google.com with SMTP id a33so4220663pgm.5
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 19:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IEWhTYycrVegHrngrlACxexQty9OMAf/7oz+Uv3kbS4=;
        b=h4iIohH+KVCUZ43BcKUCnONqpCrDz8QNJ7kyl7lCEznlFeQXrzBCs9sIVyquby+M+b
         rNIvYJqVuACdVzxCexKxkUyDrODNM/9bLsg5og2p4PqRwo5UzlWLDzpGKfIvRUrbHRvD
         fBGxYqzXr2K05gVzDPp9MLB0WhAUliXu/rRBU+vXiH2u+/T+VHJI8RdM781XvgwCNl10
         //kkpxbWEUaZQNIXsawKOrxQMQiGkrChekOuyKWKdYfvi4Y7nEMBgCaPf5fJNnmIeJuM
         hpWVybB+OAIPqb5Ajexxd3pfdG6Kg+PdmIL5WqJuNw3te9yupFHvXcS1gY5GmSsHb9Yg
         W/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IEWhTYycrVegHrngrlACxexQty9OMAf/7oz+Uv3kbS4=;
        b=t5ESq4koKbuXVMBChUFPejG6nZVfzr2ZI9PFonium2fCuJ/kKRY2+xkSdXERPDdnte
         2JzQsfgf/eecEt4vqia43Vckkse1FD8h6pl3R6Mq34rYwNolkUOTSpdqilidTxhoBREy
         iWc3KB1CeOgGft0rpnhJ9asQdfbQMCKh0qym2Bp8y+m+bm1EAAU9Ed58B9cC9iugBNjg
         4Dx7qfMsNQIQIBMw6r9QHwo9rM9Dwc17xOBAsGKhd26LhsD3Q5sq/FhLX0egB09EdIDu
         LLscoXfz2PVhD5d9jFQTJJONNCXpVAMXXa6ZqndFGp2YnYUqPhjSmmb0zCPuTGdhuTW0
         G9Rg==
X-Gm-Message-State: APjAAAXc5J7uvoBeSbc8Ju3tU5a3jJguE/q9vvw7NnUJ/dWWRwffysch
        +vuZyUBSSRSO4sriQL8tjx6zn0tabmk=
X-Google-Smtp-Source: APXvYqx6kdF6qBla0fUlx2grTCaVt1cFt6XuSjWCtBl0ugy83btyPliWhuOfaIG/YOWRtayn+XSyrg==
X-Received: by 2002:a65:678f:: with SMTP id e15mr12654110pgr.130.1576812343530;
        Thu, 19 Dec 2019 19:25:43 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gc1sm7954265pjb.20.2019.12.19.19.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 19:25:42 -0800 (PST)
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
Subject: [PATCHv4 net 0/8] disable neigh update for tunnels during pmtu update
Date:   Fri, 20 Dec 2019 11:25:17 +0800
Message-Id: <20191220032525.26909-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191218115313.19352-1-liuhangbin@gmail.com>
References: <20191218115313.19352-1-liuhangbin@gmail.com>
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

v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

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

