Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6DC30DBDD
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 14:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhBCNwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 08:52:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232432AbhBCNwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 08:52:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E209E64E40;
        Wed,  3 Feb 2021 13:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612360286;
        bh=FQkt9aarahMgC6DuLc3kolHgyqYqseLmc7XedkDhE+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcadbC9XwM0j8Xw5R/erHfZEqQOYLLn2X4PUsopvrS3Wx8BfiOrJYlVwwRrXaKCHr
         0G9yIknl+2yuqHp4q8h1lHaQggqzVHxTlu5SOMWshH8fjNsEQ7R/F9JX0P9lk9QgfD
         M1VRdN2B1w0GGh7zw63RCmqQnyQyI2kD4+Qk8JgCzTXT35HkPb7RZeclzVGqPDFQJ+
         kG4d5pOilgE8UrKG8EwFhM4apWQcSrw0kHaiJPtiC3veQsh53jjD47v4XA67WeD4xB
         8Kze5X7Kk43ctuL3OpKXjNJb2JedlzuX/69vHhLZe0YCFZrSsiTElKDIczbSi4BZJ3
         hrv5JcMxTi1lw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, coreteam@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>
Subject: [PATCH net-next v2 2/4] ipv6: move udp declarations to net/udp.h
Date:   Wed,  3 Feb 2021 15:51:10 +0200
Message-Id: <20210203135112.4083711-3-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203135112.4083711-1-leon@kernel.org>
References: <20210203135112.4083711-1-leon@kernel.org>
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

