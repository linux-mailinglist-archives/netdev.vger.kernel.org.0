Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14A52550F7
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgH0WQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgH0WQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 18:16:11 -0400
X-Greylist: delayed 498 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Aug 2020 15:16:11 PDT
Received: from forward103o.mail.yandex.net (forward103o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFD7C061264;
        Thu, 27 Aug 2020 15:16:11 -0700 (PDT)
Received: from mxback19g.mail.yandex.net (mxback19g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:319])
        by forward103o.mail.yandex.net (Yandex) with ESMTP id 9AC325F80893;
        Fri, 28 Aug 2020 01:07:46 +0300 (MSK)
Received: from sas1-26681efc71ef.qloud-c.yandex.net (sas1-26681efc71ef.qloud-c.yandex.net [2a02:6b8:c08:37a4:0:640:2668:1efc])
        by mxback19g.mail.yandex.net (mxback/Yandex) with ESMTP id P9J391dcLH-7jtmO9Xh;
        Fri, 28 Aug 2020 01:07:46 +0300
Received: by sas1-26681efc71ef.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id A1zBdMv5Ry-7il8Afes;
        Fri, 28 Aug 2020 01:07:44 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Lach <iam@lach.pw>
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
Subject: [PATCH] Remove ipvs v6 dependency on iptables
Date:   Fri, 28 Aug 2020 03:07:15 +0500
Message-Id: <20200827220715.6508-1-iam@lach.pw>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <alpine.LFD.2.23.451.2008272357240.4567@ja.home.ssi.bg>
References: <alpine.LFD.2.23.451.2008272357240.4567@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This dependency was added in 63dca2c0b0e7a92cb39d1b1ecefa32ffda201975, because this commit had dependency on
ipv6_find_hdr, which was located in iptables-specific code

But it is no longer required, because f8f626754ebeca613cf1af2e6f890cfde0e74d5b moved them to a more common location
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

