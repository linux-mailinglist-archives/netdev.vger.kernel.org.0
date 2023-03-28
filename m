Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63396CC739
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbjC1P5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjC1P5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:57:51 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Mar 2023 08:57:46 PDT
Received: from mail.kmu-office.ch (mail.kmu-office.ch [IPv6:2a02:418:6a02::a2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FD31B8;
        Tue, 28 Mar 2023 08:57:46 -0700 (PDT)
Received: from allenwind.lan (unknown [IPv6:2a02:169:3df5:10::ed4])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id 03B275C2C8A;
        Tue, 28 Mar 2023 17:38:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1680017938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=KfTeWyZgRkVVCzSjkmUbvzItYG2kxlspDdquUfw+3s4=;
        b=guGB8+Rrwrpxv4DLYA35WaapR78I1JPZ9mpEwYONgOfnVFdSm1ELxdQ5fyNx+bepZvQ/Oo
        Eo7yF4YLKGCgLkvJHtgERA3jcgTAzsjRKNc2dRaFtKihjMHfJYZvydXI7Q2jGpL44EbO3c
        Get5VPGCwGUF9Ssj187KN2cYr0/DSW4=
From:   Stefan Agner <stefan@agner.ch>
To:     davem@davemloft.net, dsahern@kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, stefan@agner.ch, john.carr@unrouted.co.uk,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] ipv6: add option to explicitly enable reachability test
Date:   Tue, 28 Mar 2023 17:38:50 +0200
Message-Id: <b9182b02829b158d55acc53a0bcec1ed667b2668.1680000784.git.stefan@agner.ch>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Systems which act as host as well as router might prefer the host
behavior. Currently the kernel does not allow to use IPv6 forwarding
globally and at the same time use route reachability probing.

Add a compile time flag to enable route reachability probe in any
case.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
My use case is a OpenThread device which at the same time can also act as a
client communicating with Thread devices. Thread Border routers use the Route
Information mechanism to publish routes with a lifetime of up to 1800s. If
one of the Thread Border router goes offline, the lack of reachability probing
currenlty leads to outages of up to 30 minutes.

Not sure if the chosen method is acceptable. Maybe a runtime flag is preferred?

--
Stefan

 net/ipv6/Kconfig | 9 +++++++++
 net/ipv6/route.c | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 658bfed1df8b..5147fd4c93ff 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -48,6 +48,15 @@ config IPV6_OPTIMISTIC_DAD
 
 	  If unsure, say N.
 
+config IPV6_REACHABILITY_PROBE
+	bool "IPv6: Always use reachability probing (RFC 4191)"
+	help
+	  By default reachability probing is disabled on router devices (when
+	  IPv6 forwarding is enabled). This option explicitly enables
+	  reachability probing always.
+
+	  If unsure, say N.
+
 config INET6_AH
 	tristate "IPv6: AH transformation"
 	select XFRM_AH
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0fdb03df2287..5e1e1f02f400 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2210,7 +2210,8 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 
 	strict |= flags & RT6_LOOKUP_F_IFACE;
 	strict |= flags & RT6_LOOKUP_F_IGNORE_LINKSTATE;
-	if (net->ipv6.devconf_all->forwarding == 0)
+	if (net->ipv6.devconf_all->forwarding == 0 ||
+	    IS_ENABLED(IPV6_REACHABILITY_PROBE))
 		strict |= RT6_LOOKUP_F_REACHABLE;
 
 	rcu_read_lock();
-- 
2.40.0

