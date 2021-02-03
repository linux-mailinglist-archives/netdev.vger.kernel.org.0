Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982F930DBDA
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 14:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbhBCNwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 08:52:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231803AbhBCNwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 08:52:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B71564DE8;
        Wed,  3 Feb 2021 13:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612360283;
        bh=2wOV7+W6rAll0XgIt3CapU4I+kcslY5MEhMOUMT8zTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4wjzRnDc10gXjh3m1oaDBmgJG/6uQh9Vt9iYEf61j+zKiSAYDTrzyHYEr5pu1sma
         mtf1WEGwP4n0VtdlKu9uDiuJW9m8pmQp/aLaiWpu5qJlFFaJADz90F2Esn3sTIWAdS
         1cz76MnILTNhQgmdahmXEiadI+qUib+FnjqZyiSGfk89RbJtQeesT4R1HqLZKDsqPF
         5PWRURsQ71D/lyE9InIjS2/dPvRYzVC0wV7GmJzQu/ptwjdftPDjH4wSvgU9mNE/6e
         CHsKmIyVAIyrSfiu3uKai88tGqxB86Qn9BljuPbGtvBdDyUQlM1Myw3cZ3iqrhIDO4
         weCkk3rVYef1w==
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
Subject: [PATCH net-next v2 1/4] ipv6: silence compilation warning for non-IPV6 builds
Date:   Wed,  3 Feb 2021 15:51:09 +0200
Message-Id: <20210203135112.4083711-2-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203135112.4083711-1-leon@kernel.org>
References: <20210203135112.4083711-1-leon@kernel.org>
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

Fix it by providing function declaration for builds with ipv6 as a module.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/icmpv6.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index 1b3371ae8193..452d8978ffc7 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -16,9 +16,9 @@ static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)

 typedef void ip6_icmp_send_t(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 			     const struct in6_addr *force_saddr);
-#if IS_BUILTIN(CONFIG_IPV6)
 void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 		const struct in6_addr *force_saddr);
+#if IS_BUILTIN(CONFIG_IPV6)
 static inline void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
 {
 	icmp6_send(skb, type, code, info, NULL);
--
2.29.2

