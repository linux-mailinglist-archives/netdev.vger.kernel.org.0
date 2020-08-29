Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A41F256804
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 16:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgH2OAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 10:00:32 -0400
Received: from forward102j.mail.yandex.net ([5.45.198.243]:46277 "EHLO
        forward102j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728012AbgH2OAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 10:00:22 -0400
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward102j.mail.yandex.net (Yandex) with ESMTP id 60EBDF2083F;
        Sat, 29 Aug 2020 17:00:14 +0300 (MSK)
Received: from mxback5q.mail.yandex.net (mxback5q.mail.yandex.net [IPv6:2a02:6b8:c0e:1ba:0:640:b716:ad89])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id 5A3E761E0009;
        Sat, 29 Aug 2020 17:00:14 +0300 (MSK)
Received: from vla3-b0c95643f530.qloud-c.yandex.net (vla3-b0c95643f530.qloud-c.yandex.net [2a02:6b8:c15:341d:0:640:b0c9:5643])
        by mxback5q.mail.yandex.net (mxback/Yandex) with ESMTP id jpkCmE9VZ8-0Dv0NDrH;
        Sat, 29 Aug 2020 17:00:14 +0300
Received: by vla3-b0c95643f530.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id fTzMuIFaS8-09mq9T7d;
        Sat, 29 Aug 2020 17:00:12 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Yaroslav Bolyukin <iam@lach.pw>
To:     ja@ssi.bg
Cc:     iam@lach.pw, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCHv5 net-next] ipvs: remove dependency on ip6_tables
Date:   Sat, 29 Aug 2020 18:59:53 +0500
Message-Id: <20200829135953.20228-1-iam@lach.pw>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <alpine.LFD.2.23.451.2008291233110.3043@ja.home.ssi.bg>
References: <alpine.LFD.2.23.451.2008291233110.3043@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This dependency was added because ipv6_find_hdr was in iptables specific
code but is no longer required

Fixes: f8f626754ebe ("ipv6: Move ipv6_find_hdr() out of Netfilter code.")
Fixes: 63dca2c0b0e7 ("ipvs: Fix faulty IPv6 extension header handling in IPVS").
Signed-off-by: Yaroslav Bolyukin <iam@lach.pw>
---
 Missed canonical patch format section, subsystem is now spevified

 include/net/ip_vs.h        | 3 ---
 net/netfilter/ipvs/Kconfig | 1 -
 2 files changed, 4 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 9a59a3378..d609e957a 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -25,9 +25,6 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>			/* for struct ipv6hdr */
 #include <net/ipv6.h>
-#if IS_ENABLED(CONFIG_IP_VS_IPV6)
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#endif
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack.h>
 #endif
diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index 2c1593089..eb0e329f9 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -29,7 +29,6 @@ if IP_VS
 config	IP_VS_IPV6
 	bool "IPv6 support for IPVS"
 	depends on IPV6 = y || IP_VS = IPV6
-	select IP6_NF_IPTABLES
 	select NF_DEFRAG_IPV6
 	help
 	  Add IPv6 support to IPVS.
--
2.28.0

