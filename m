Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559A92566EB
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 12:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgH2Kyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 06:54:32 -0400
Received: from forward105p.mail.yandex.net ([77.88.28.108]:43743 "EHLO
        forward105p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728070AbgH2Kx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 06:53:59 -0400
X-Greylist: delayed 7360 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Aug 2020 06:53:31 EDT
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward105p.mail.yandex.net (Yandex) with ESMTP id C036A4D41A1A;
        Sat, 29 Aug 2020 13:52:44 +0300 (MSK)
Received: from mxback7q.mail.yandex.net (mxback7q.mail.yandex.net [IPv6:2a02:6b8:c0e:41:0:640:cbbf:d618])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id BAC61CF40002;
        Sat, 29 Aug 2020 13:52:44 +0300 (MSK)
Received: from vla1-00787b9b359d.qloud-c.yandex.net (vla1-00787b9b359d.qloud-c.yandex.net [2a02:6b8:c0d:2915:0:640:78:7b9b])
        by mxback7q.mail.yandex.net (mxback/Yandex) with ESMTP id gCYnzgL8Ka-qh8iouRw;
        Sat, 29 Aug 2020 13:52:44 +0300
Received: by vla1-00787b9b359d.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 8pPW436arS-qelORpTN;
        Sat, 29 Aug 2020 13:52:42 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Yaroslav Bolyukin <iam@lach.pw>
To:     ja@ssi.bg
Cc:     iam@lach.pw, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCHv4 net-next] Remove ipvs v6 dependency on iptables
Date:   Sat, 29 Aug 2020 15:51:37 +0500
Message-Id: <20200829105136.3533-1-iam@lach.pw>
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

