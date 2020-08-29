Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BA2256624
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 10:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgH2I61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 04:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgH2I6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 04:58:25 -0400
X-Greylist: delayed 472 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 29 Aug 2020 01:58:24 PDT
Received: from forward101p.mail.yandex.net (forward101p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6EFC061236;
        Sat, 29 Aug 2020 01:58:24 -0700 (PDT)
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward101p.mail.yandex.net (Yandex) with ESMTP id A9F2C2643EB6;
        Sat, 29 Aug 2020 11:50:23 +0300 (MSK)
Received: from mxback5q.mail.yandex.net (mxback5q.mail.yandex.net [IPv6:2a02:6b8:c0e:1ba:0:640:b716:ad89])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id A3CB6CF40002;
        Sat, 29 Aug 2020 11:50:23 +0300 (MSK)
Received: from vla5-e763f15c6769.qloud-c.yandex.net (vla5-e763f15c6769.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:e763:f15c])
        by mxback5q.mail.yandex.net (mxback/Yandex) with ESMTP id xwsiBp6pc0-oMv0uHXm;
        Sat, 29 Aug 2020 11:50:23 +0300
Received: by vla5-e763f15c6769.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id QISoGxxgDy-oIHmt0XR;
        Sat, 29 Aug 2020 11:50:21 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Yaroslav Bolyukin <iam@lach.pw>
To:     ja@ssi.bg, Nicolas Dichtel <nicolas.dichtel@6wind.com>
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
Subject: [PATCH] Remove ipvs v6 dependency on iptables
Date:   Sat, 29 Aug 2020 13:50:05 +0500
Message-Id: <20200829085005.24931-1-iam@lach.pw>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <e4765a73-e6a1-f5ba-dd8b-7c1ee1e5883d@6wind.com>
References: <e4765a73-e6a1-f5ba-dd8b-7c1ee1e5883d@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This dependency was added as part of commit ecefa32ffda201975
("ipvs: Fix faulty IPv6 extension header handling in IPVS"), because it
had dependency on ipv6_find_hdr, which was located in iptables-specific
code

But it is no longer required after commit e6f890cfde0e74d5b
("ipv6:Move ipv6_find_hdr() out of Netfilter code.")

Also remove ip6tables include from ip_vs

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

