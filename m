Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B0B4B92F
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 14:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731931AbfFSMzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 08:55:22 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:52609 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731770AbfFSMzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 08:55:22 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M2w4S-1hcUib3o9k-003KN8; Wed, 19 Jun 2019 14:55:06 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        wenxu <wenxu@ucloud.cn>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] netfilter: synproxy: fix building syncookie calls
Date:   Wed, 19 Jun 2019 14:54:36 +0200
Message-Id: <20190619125500.1054426-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:xZ3TMz67ZOJPH0ye7NMGfik9gT3NNsynu5AzNJdutOeiOL4FIS+
 WAWs6+suEpnTzZ0LzUoZyVkCVr1RxNHd20j4ksTpwlFIPQxcMO5a9ZcyxLcotOgwe3uGlOB
 1rUhA3r55CeT4b39lG/fNvkOu+NH9MlldXRpHp+zIZHBl1jlpZXUFAeA7s2aAzOnrbYgInB
 CM/7zqvrJ+PwsLR9lYTaA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QNzBUpn2b2I=:HHSLfW4VycGyqlqjJGBf1q
 fdgoN5ybxex4s6O5gaO7m7glXbbkeG+zpqnv/+J7PcPaAZsuJI4jX0awEBftE3tWXouk5AFBQ
 7wGCEYH8Krmv7DfRx/lRWw/NT2Ud9NaS89PZ30JNeHPpPcGcMoYvGOXp4wBoVFOuLXlwLPRaw
 k6p4G94DRpiD1U2mzw5j0Gw0aQJHIG0IeC7kpwrmdgwc2Kf9+tu0wnUI3EzSHccyelPMn7fyo
 LPlyIcZOUcjRrjhO+rBz1w03EOWL6TAFzMJMJYJkB3u0SaGz0OzeLyf82QM0o79WOxMRSIR1L
 MT57jVBhuAdsTmoV+sesjbAgvjAHdSx1tOd+OmFFVTd/UNTEmKFSYA4EDlrB1IH0g9aaRX2bB
 oV6debd+6899coOTyIyk95qQzAYbdhIe/Rpf5mpimOfki6Tefm9mP7xFoG4y4EjEl/OqbhzVC
 0SbQJc8NNXij6OMRadEflf+DZ2FgdNF7F6pCBV19bmV0Rzb87yl+hTeGvSphxSxvi5JobW5pC
 Umgre0T3SfAhvELEsXFq4m51iCssETNixScH3NREJc4kHeexV+g3T96PfeTxk7o3KR2YcuA6R
 PCrVKn+sFcl2xO7yqHKc2UWl1zjkegg8D+h3k5QkksWlDhU7slSUB9VMqbdRBRzpe+j3MpziH
 dUf3TFpYKj0d7WmJnQ37eH7enuwxokIPfPARLkLtvkU/CBQiEF+Un91ncd7TjWboRs/r44J6/
 C4qzRdDKXLFuITe/kDDoYHGEjFZ0JXQtp7bbFw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When either CONFIG_IPV6 or CONFIG_SYN_COOKIES are disabled, the kernel
fails to build:

include/linux/netfilter_ipv6.h:180:9: error: implicit declaration of function '__cookie_v6_init_sequence'
      [-Werror,-Wimplicit-function-declaration]
        return __cookie_v6_init_sequence(iph, th, mssp);
include/linux/netfilter_ipv6.h:194:9: error: implicit declaration of function '__cookie_v6_check'
      [-Werror,-Wimplicit-function-declaration]
        return __cookie_v6_check(iph, th, cookie);
net/ipv6/netfilter.c:237:26: error: use of undeclared identifier '__cookie_v6_init_sequence'; did you mean 'cookie_init_sequence'?
net/ipv6/netfilter.c:238:21: error: use of undeclared identifier '__cookie_v6_check'; did you mean '__cookie_v4_check'?

Fix the IS_ENABLED() checks to match the function declaration
and definitions for these.

Fixes: 3006a5224f15 ("netfilter: synproxy: remove module dependency on IPv6 SYNPROXY")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/netfilter_ipv6.h | 14 ++++++++------
 net/ipv6/netfilter.c           |  2 ++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 1aa3a23744df..7beb681e1ce5 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -171,31 +171,33 @@ static inline u32 nf_ipv6_cookie_init_sequence(const struct ipv6hdr *iph,
 					       const struct tcphdr *th,
 					       u16 *mssp)
 {
+#if IS_ENABLED(CONFIG_SYN_COOKIES)
 #if IS_MODULE(CONFIG_IPV6)
 	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
 
 	if (v6_ops)
 		return v6_ops->cookie_init_sequence(iph, th, mssp);
-
-	return 0;
-#else
+#elif IS_BUILTIN(CONFIG_IPV6)
 	return __cookie_v6_init_sequence(iph, th, mssp);
 #endif
+#endif
+	return 0;
 }
 
 static inline int nf_cookie_v6_check(const struct ipv6hdr *iph,
 				     const struct tcphdr *th, __u32 cookie)
 {
+#if IS_ENABLED(CONFIG_SYN_COOKIES)
 #if IS_MODULE(CONFIG_IPV6)
 	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
 
 	if (v6_ops)
 		return v6_ops->cookie_v6_check(iph, th, cookie);
-
-	return 0;
-#else
+#elif IS_BUILTIN(CONFIG_IPV6)
 	return __cookie_v6_check(iph, th, cookie);
 #endif
+#endif
+	return 0;
 }
 
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index dffb10fdc3e8..61819ed858b1 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -234,8 +234,10 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.route_me_harder	= ip6_route_me_harder,
 	.dev_get_saddr		= ipv6_dev_get_saddr,
 	.route			= __nf_ip6_route,
+#if IS_ENABLED(CONFIG_SYN_COOKIES)
 	.cookie_init_sequence	= __cookie_v6_init_sequence,
 	.cookie_v6_check	= __cookie_v6_check,
+#endif
 #endif
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
-- 
2.20.0

