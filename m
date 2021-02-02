Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D3330C1F4
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhBBOiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:38:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231262AbhBBORr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 09:17:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DECB64FC7;
        Tue,  2 Feb 2021 13:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612274152;
        bh=mfmlJHMI6yFr64wRzHKtS4W4P42yrVgDCbbvPMoKAGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NoxQLkdyV4FP7VWWxxoG8/TpmyzxT3yA3k6n03uZ+AzksrQbhchiBrL0NhXvDFzxX
         J/BnHcIiixqzcPJO7TacexxGvlXOdn00VtjHzki3C3raoE4xhGBL86KpbCu7aXaeJL
         jLkaVvgKWAuW20Vwh2Y8OR8KgxpN+ytCs5eaCwF+RZfhB2RM4xQrDN8xIqJqE7Qv86
         Ppmb4ReBz9zdnjA3O1akQqkydM7SMnhyBMuNCtugT7gbn3F5AwXY1Psr1Z8wEUesqe
         0NEpzOHWKs0rCYV9WDdyX1pAdrMm41aVkB8RjJSHkiun5AMUjYscnP0VDpU9TIKQxw
         KvUD2zgyqsnHQ==
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
Subject: [PATCH net 1/4] ipv6: silence compilation warning for non-IPV6 builds
Date:   Tue,  2 Feb 2021 15:55:41 +0200
Message-Id: <20210202135544.3262383-2-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202135544.3262383-1-leon@kernel.org>
References: <20210202135544.3262383-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The W=1 compilation of allmodconfig generates the following warning:

net/ipv6/icmp.c:448:6: warning: no previous prototype for 'icmp6_send' [-Wmissing-prototypes]
  448 | void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
      |      ^~~~~~~~~~

In such configuration, the icmp6_send() is not used outside of icmp.c, so close
its EXPORT_SYMBOL and add "static" word to limit the scope.

Fixes: cc7a21b6fbd9 ("ipv6: icmp6: avoid indirect call for icmpv6_send()")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/ipv6/icmp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index f3d05866692e..5d4232b492dc 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -445,6 +445,9 @@ static int icmp6_iif(const struct sk_buff *skb)
 /*
  *	Send an ICMP message in response to a packet in error
  */
+#if !IS_BUILTIN(CONFIG_IPV6)
+static
+#endif
 void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 		const struct in6_addr *force_saddr)
 {
@@ -634,7 +637,10 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 out_bh_enable:
 	local_bh_enable();
 }
+
+#if IS_BUILTIN(CONFIG_IPV6)
 EXPORT_SYMBOL(icmp6_send);
+#endif

 /* Slightly more convenient version of icmp6_send.
  */
--
2.29.2

