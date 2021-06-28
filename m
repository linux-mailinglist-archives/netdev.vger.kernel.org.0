Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5BE3B6A9B
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 23:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbhF1V5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 17:57:06 -0400
Received: from novek.ru ([213.148.174.62]:36880 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235780AbhF1V5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 17:57:05 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id BF4CD503CD1;
        Tue, 29 Jun 2021 00:52:35 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru BF4CD503CD1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1624917156; bh=Iw862VPJCxy+H4WREwQW8sv/O9Isck7ar3gZvPowT8k=;
        h=From:To:Cc:Subject:Date:From;
        b=L7qAPR5Iro+DfBcuoAqueUgwzJBthKrbuj1T9/vQ8sF49GITuhpEFX7em+om21eY/
         eBo3w55ZuhJYGhau4R1bEaFXYj2iIcXpap7vYa0q5Zjl1sFGis2O2akIsNTErI7cPN
         e/wXnf1uduyQ92pZmXDtCbaHqGek8K5dwdsIusi8=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net] net: ipv6: fix return value of ip6_skb_dst_mtu
Date:   Tue, 29 Jun 2021 00:54:31 +0300
Message-Id: <20210628215431.29156-1-vfedorenko@novek.ru>
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
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 include/net/ip6_route.h | 2 +-
 net/ipv6/xfrm6_output.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index f51a118bfce8..b931e413b7a4 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -263,7 +263,7 @@ static inline bool ipv6_anycast_destination(const struct dst_entry *dst,
 int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		 int (*output)(struct net *, struct sock *, struct sk_buff *));
 
-static inline int ip6_skb_dst_mtu(struct sk_buff *skb)
+static inline unsigned int ip6_skb_dst_mtu(struct sk_buff *skb)
 {
 	struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
 				inet6_sk(skb->sk) : NULL;
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

