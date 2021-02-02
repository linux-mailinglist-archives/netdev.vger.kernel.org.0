Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E823630C1F5
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhBBOiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:38:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231600AbhBBORu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 09:17:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77DB264FCE;
        Tue,  2 Feb 2021 13:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612274163;
        bh=zu3Gt86SXPGyJWhY6nCI9luwiVCzfhk0z+r+Ls5Rfsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBcIfldF414TuIyses6UVoMzupyh9IaC8jGkXzEkvrIw6yjqvDx9iLphF60SKQIRm
         lKKxzJkgwuvIPZGq5oNzAPHmF9r87EVhenxbMmUE5SnQMujkPrdL71l6KZDJ7/hFSg
         SW8oDI8/Y4ck4lGfXsx6r2pEW9ZKdXmTLk8FdMIdj8mC4E17RunuRENEACZiDd5LXo
         i2b6MqkLDeBUw3SmWi1lYiCHpJaUY4Df6c/uFYWfTRFhR6oE+MGoYR/+Jpqh7FO6IK
         B1aVroWkbFqbzQi89Kf94TxN1Lq2CdgNFNOAF7IvipR5XlYH8iNvSoXTN2TKgR23m+
         BcNc+r+KE5Z4w==
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
Subject: [PATCH net 3/4] net/core: move ipv6 gro function declarations to net/ipv6
Date:   Tue,  2 Feb 2021 15:55:43 +0200
Message-Id: <20210202135544.3262383-4-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202135544.3262383-1-leon@kernel.org>
References: <20210202135544.3262383-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Fir the following compilation warnings:
 1031 | INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)

net/ipv6/ip6_offload.c:182:41: warning: no previous prototype for ‘ipv6_gro_receive’ [-Wmissing-prototypes]
  182 | INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
      |                                         ^~~~~~~~~~~~~~~~
net/ipv6/ip6_offload.c:320:29: warning: no previous prototype for ‘ipv6_gro_complete’ [-Wmissing-prototypes]
  320 | INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
      |                             ^~~~~~~~~~~~~~~~~
net/ipv6/ip6_offload.c:182:41: warning: no previous prototype for ‘ipv6_gro_receive’ [-Wmissing-prototypes]
  182 | INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
      |                                         ^~~~~~~~~~~~~~~~
net/ipv6/ip6_offload.c:320:29: warning: no previous prototype for ‘ipv6_gro_complete’ [-Wmissing-prototypes]
  320 | INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)

Fixes: aaa5d90b395a ("net: use indirect call wrappers at GRO network layer")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/ipv6.h | 3 +++
 net/core/dev.c     | 4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index bd1f396cc9c7..68676e6bd4b1 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1265,4 +1265,7 @@ static inline void ip6_sock_set_recvpktinfo(struct sock *sk)
 	release_sock(sk);
 }

+INDIRECT_CALLABLE_DECLARE(struct sk_buff *ipv6_gro_receive(struct list_head *,
+							   struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int ipv6_gro_complete(struct sk_buff *, int));
 #endif /* _NET_IPV6_H */
diff --git a/net/core/dev.c b/net/core/dev.c
index c360bb5367e2..9a3d8768524b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -101,6 +101,7 @@
 #include <net/dsa.h>
 #include <net/dst.h>
 #include <net/dst_metadata.h>
+#include <net/ipv6.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <net/checksum.h>
@@ -5743,7 +5744,6 @@ static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
 }

 INDIRECT_CALLABLE_DECLARE(int inet_gro_complete(struct sk_buff *, int));
-INDIRECT_CALLABLE_DECLARE(int ipv6_gro_complete(struct sk_buff *, int));
 static int napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 {
 	struct packet_offload *ptype;
@@ -5914,8 +5914,6 @@ static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)

 INDIRECT_CALLABLE_DECLARE(struct sk_buff *inet_gro_receive(struct list_head *,
 							   struct sk_buff *));
-INDIRECT_CALLABLE_DECLARE(struct sk_buff *ipv6_gro_receive(struct list_head *,
-							   struct sk_buff *));
 static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
 {
 	u32 hash = skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
--
2.29.2

