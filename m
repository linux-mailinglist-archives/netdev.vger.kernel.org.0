Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE0B49718F
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 13:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbiAWM5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 07:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236358AbiAWM5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 07:57:30 -0500
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A481C06173D
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 04:57:28 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:20cc:b383:efc8:c1b8])
        by baptiste.telenet-ops.be with bizsmtp
        id mCxK2600D4688xB01CxKR4; Sun, 23 Jan 2022 13:57:27 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nBcQp-00B8uY-Fz; Sun, 23 Jan 2022 13:57:19 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nBcQo-00B9ed-Uy; Sun, 23 Jan 2022 13:57:18 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] netfilter: Remove flowtable relics
Date:   Sun, 23 Jan 2022 13:57:17 +0100
Message-Id: <20220123125717.2658676-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NF_FLOW_TABLE_IPV4 and NF_FLOW_TABLE_IPV6 are invisble, selected by
nothing (so they can no longer be enabled), and their last real users
have been removed (nf_flow_table_ipv6.c is empty).

Clean up the leftovers.

Fixes: c42ba4290b2147aa ("netfilter: flowtable: remove ipv4/ipv6 modules")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/ipv4/netfilter/Kconfig              | 4 ----
 net/ipv6/netfilter/Kconfig              | 4 ----
 net/ipv6/netfilter/Makefile             | 3 ---
 net/ipv6/netfilter/nf_flow_table_ipv6.c | 0
 4 files changed, 11 deletions(-)
 delete mode 100644 net/ipv6/netfilter/nf_flow_table_ipv6.c

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 67087f95579fdea6..aab384126f61ffb9 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -58,10 +58,6 @@ config NF_TABLES_ARP
 
 endif # NF_TABLES
 
-config NF_FLOW_TABLE_IPV4
-	tristate
-	select NF_FLOW_TABLE_INET
-
 config NF_DUP_IPV4
 	tristate "Netfilter IPv4 packet duplication to alternate destination"
 	depends on !NF_CONNTRACK || NF_CONNTRACK
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 97d3d1b36dbceb60..0ba62f4868f97695 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -47,10 +47,6 @@ config NFT_FIB_IPV6
 endif # NF_TABLES_IPV6
 endif # NF_TABLES
 
-config NF_FLOW_TABLE_IPV6
-	tristate
-	select NF_FLOW_TABLE_INET
-
 config NF_DUP_IPV6
 	tristate "Netfilter IPv6 packet duplication to alternate destination"
 	depends on !NF_CONNTRACK || NF_CONNTRACK
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index b85383606df71b5c..b8d6dc9aeeb6f403 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -28,9 +28,6 @@ obj-$(CONFIG_NFT_REJECT_IPV6) += nft_reject_ipv6.o
 obj-$(CONFIG_NFT_DUP_IPV6) += nft_dup_ipv6.o
 obj-$(CONFIG_NFT_FIB_IPV6) += nft_fib_ipv6.o
 
-# flow table support
-obj-$(CONFIG_NF_FLOW_TABLE_IPV6) += nf_flow_table_ipv6.o
-
 # matches
 obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
 obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
deleted file mode 100644
index e69de29bb2d1d643..0000000000000000
-- 
2.25.1

