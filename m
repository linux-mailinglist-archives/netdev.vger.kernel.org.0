Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EB63B99B7
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 01:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhGAXtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 19:49:41 -0400
Received: from novek.ru ([213.148.174.62]:56146 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234194AbhGAXtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 19:49:41 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id E5FAA503D1E;
        Fri,  2 Jul 2021 02:45:02 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru E5FAA503D1E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1625183104; bh=LxJw3lBEtC/K81eQ1xS6EnOP6QvMurYUi7ifuZ3YkN8=;
        h=From:To:Cc:Subject:Date:From;
        b=A/jY5RwY4bvuUYp9D2Mj6clCem5csOCOvyOMyMFGX+zYqD0hjNGeJSSqNEknMbU3I
         +Q647NuBD2LnhzKz8xZ0uRKMlp3C+587+UwPF6pvtY5SXQQMZfFkvZ05MI52euu4Dl
         CGSrnKNnT7/kkQSNHb+Z2FbzXw5oonJbgctDt3uU=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net v2] net: ipv6: fix return value of ip6_skb_dst_mtu
Date:   Fri,  2 Jul 2021 02:47:00 +0300
Message-Id: <20210701234700.22762-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 628a5c561890 ("[INET]: Add IP(V6)_PMTUDISC_RPOBE") introduced
ip6_skb_dst_mtu with return value of signed int which is inconsistent
with actually returned values. Also 2 users of this function actually
assign its value to unsigned int variable and only __xfrm6_output
assigns result of this function to signed variable but actually uses
as unsigned in further comparisons and calls. Change this function
to return unsigned int value.

Fixes: 628a5c561890 ("[INET]: Add IP(V6)_PMTUDISC_RPOBE")
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 v2: rebase on top current net

 Actually I'm not sure why it could not be applied last time
---
 include/net/ip6_route.h | 2 +-
 net/ipv6/xfrm6_output.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index f14149df5a65..625a38ccb5d9 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -263,7 +263,7 @@ static inline bool ipv6_anycast_destination(const struct dst_entry *dst,
 int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		 int (*output)(struct net *, struct sock *, struct sk_buff *));
 
-static inline int ip6_skb_dst_mtu(struct sk_buff *skb)
+static inline unsigned int ip6_skb_dst_mtu(struct sk_buff *skb)
 {
 	int mtu;
 
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index 57fa27c1cdf9..d0d280077721 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -49,7 +49,7 @@ static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct xfrm_state *x = dst->xfrm;
-	int mtu;
+	unsigned int mtu;
 	bool toobig;
 
 #ifdef CONFIG_NETFILTER
-- 
2.18.4

