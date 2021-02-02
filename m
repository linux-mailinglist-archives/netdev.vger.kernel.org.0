Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A5C30C1F0
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbhBBOh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:37:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231499AbhBBORr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 09:17:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0966264FCD;
        Tue,  2 Feb 2021 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612274159;
        bh=uqEQxgxP/Gh6jkafzcZMwsNruCxCCpY2QrRHAchjz/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJZKCAkxo4iNw6GvoaohZFZ6alAc19sFBqoWDRu0qkz7f0ZiSqji/3BwP2DQizckW
         fRCRjI2NTiTh4HFtW09AF6rjvmTdGcbbCFqEdIZ0kAJYrmdiCtMrPEuD4IN5B0NoHN
         WQ7J+ebZG6SJdlu1w8kHoaIB0H2kINRmq+k14SML6PRIIMoJCf/mwHEc8g6Sn6uuPB
         9ztrCNZy9RseBE9g48WJ1yyI4PSypSHvbw6W7/XfdLfgT+1RiaEuTyEzr1DmCXFzvR
         +67DFBd9dAd0Yd7JEfyZgxSstDlupg0aeJVm+Fad5uyt/lyxFU43SDI3UNHASfsRej
         9xDdTDpTFlGOA==
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
Subject: [PATCH net 4/4] netfilter: move handlers to net/ip_vs.h
Date:   Tue,  2 Feb 2021 15:55:44 +0200
Message-Id: <20210202135544.3262383-5-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202135544.3262383-1-leon@kernel.org>
References: <20210202135544.3262383-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Fix the following compilation warnings:
net/netfilter/ipvs/ip_vs_proto_tcp.c:147:1: warning: no previous prototype for 'tcp_snat_handler' [-Wmissing-prototypes]
  147 | tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
      | ^~~~~~~~~~~~~~~~
net/netfilter/ipvs/ip_vs_proto_udp.c:136:1: warning: no previous prototype for 'udp_snat_handler' [-Wmissing-prototypes]
  136 | udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
      | ^~~~~~~~~~~~~~~~

Fixes: 6ecd754883da ("ipvs: use indirect call wrappers")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/ip_vs.h             | 11 +++++++++++
 net/netfilter/ipvs/ip_vs_core.c | 12 ------------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index d609e957a3ec..7cb5a1aace40 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1712,4 +1712,15 @@ ip_vs_dest_conn_overhead(struct ip_vs_dest *dest)
 		atomic_read(&dest->inactconns);
 }

+#ifdef CONFIG_IP_VS_PROTO_TCP
+INDIRECT_CALLABLE_DECLARE(int
+	tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
+			 struct ip_vs_conn *cp, struct ip_vs_iphdr *iph));
+#endif
+
+#ifdef CONFIG_IP_VS_PROTO_UDP
+INDIRECT_CALLABLE_DECLARE(int
+	udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
+			 struct ip_vs_conn *cp, struct ip_vs_iphdr *iph));
+#endif
 #endif	/* _NET_IP_VS_H */
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 54e086c65721..0c132ff9b446 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -68,18 +68,6 @@ EXPORT_SYMBOL(ip_vs_get_debug_level);
 #endif
 EXPORT_SYMBOL(ip_vs_new_conn_out);

-#ifdef CONFIG_IP_VS_PROTO_TCP
-INDIRECT_CALLABLE_DECLARE(int
-	tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
-			 struct ip_vs_conn *cp, struct ip_vs_iphdr *iph));
-#endif
-
-#ifdef CONFIG_IP_VS_PROTO_UDP
-INDIRECT_CALLABLE_DECLARE(int
-	udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
-			 struct ip_vs_conn *cp, struct ip_vs_iphdr *iph));
-#endif
-
 #if defined(CONFIG_IP_VS_PROTO_TCP) && defined(CONFIG_IP_VS_PROTO_UDP)
 #define SNAT_CALL(f, ...) \
 	INDIRECT_CALL_2(f, tcp_snat_handler, udp_snat_handler, __VA_ARGS__)
--
2.29.2

