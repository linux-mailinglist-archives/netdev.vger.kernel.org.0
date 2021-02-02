Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA78E30C1EC
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbhBBOha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231270AbhBBORr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 09:17:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88C1564FC9;
        Tue,  2 Feb 2021 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612274156;
        bh=DR0Ao7cYzAFwiQZi+Sf24cz1CDI9PHhlVdfFgDadyMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlcB7nd4RJe57D3/ViU+Q+KQbLURKQKpBZsn7jgpVKIgMv2prrmmdqfKm2pEonFv3
         PuXfa/TBYbqB1pVYfj1h+o17M1UxS2U8jvkMNdfYHrvNFYlY0JBrdXiIx5/++tq39I
         Pk9rn1X0SfZUIrnYl/PArrVQR/6ITsoHxSK0z6EH+t4m5ceeSApG46QYfryT0rLPKo
         08sR2h8/LWZacRA/KbS0Gnhojjy7ZpWCwgPov8xsmcUUbAGjnP0jPbIIOvHG+jxJsm
         s02UNd9nSYDcD0nfv19UqvbDP2uGhU+cTZGyj0sMDtDkitroGXGQApYZ6mGeviUkKp
         59IXCB/MIr3rg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, coreteam@netfilter.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH net 2/4] ipv6: move udp declarations to net/udp.h
Date:   Tue,  2 Feb 2021 15:55:42 +0200
Message-Id: <20210202135544.3262383-3-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202135544.3262383-1-leon@kernel.org>
References: <20210202135544.3262383-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Fix the following compilation warning:

net/ipv6/udp.c:1031:30: warning: no previous prototype for 'udp_v6_early_demux' [-Wmissing-prototypes]
 1031 | INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)
      |                              ^~~~~~~~~~~~~~~~~~
net/ipv6/udp.c:1072:29: warning: no previous prototype for 'udpv6_rcv' [-Wmissing-prototypes]
 1072 | INDIRECT_CALLABLE_SCOPE int udpv6_rcv(struct sk_buff *skb)
      |                             ^~~~~~~~~

Fixes: 97ff7ffb11fe ("net: use indirect calls helpers at early demux stage")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/udp.h    | 3 +++
 net/ipv6/ip6_input.c | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 877832bed471..ff2de866bca4 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -173,6 +173,9 @@ INDIRECT_CALLABLE_DECLARE(int udp4_gro_complete(struct sk_buff *, int));
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp6_gro_receive(struct list_head *,
 							   struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(int udp6_gro_complete(struct sk_buff *, int));
+INDIRECT_CALLABLE_DECLARE(void udp_v6_early_demux(struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int udpv6_rcv(struct sk_buff *));
+
 struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 				struct udphdr *uh, struct sock *sk);
 int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index e96304d8a4a7..e9d2a4a409aa 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -32,6 +32,7 @@

 #include <net/sock.h>
 #include <net/snmp.h>
+#include <net/udp.h>

 #include <net/ipv6.h>
 #include <net/protocol.h>
@@ -44,7 +45,6 @@
 #include <net/inet_ecn.h>
 #include <net/dst_metadata.h>

-INDIRECT_CALLABLE_DECLARE(void udp_v6_early_demux(struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *));
 static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
 				struct sk_buff *skb)
@@ -352,7 +352,6 @@ void ipv6_list_rcv(struct list_head *head, struct packet_type *pt,
 		ip6_sublist_rcv(&sublist, curr_dev, curr_net);
 }

-INDIRECT_CALLABLE_DECLARE(int udpv6_rcv(struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff *));

 /*
--
2.29.2

