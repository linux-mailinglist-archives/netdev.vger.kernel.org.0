Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3584F2B3145
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 23:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgKNWye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 17:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgKNWyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 17:54:32 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B36C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 14:54:31 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4CYVyZ3cl3zQlKL;
        Sat, 14 Nov 2020 23:54:30 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605394468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=psnMnySTzs3xL0FKfZSgeFXvwcu+gO0Vdoiema7tXgg=;
        b=n2A6MwkmfUDyZRDBkl10174Jqj2vqRF6bwuZZi3+pqevFBXHkz8bkoW2RkXuwSKemcT+t6
        aUg7eYrSU35coXDJjtDJ6nj2ITd1bM8MMzu6ZR0stxJd68pZADWd8vf9jKgXq9j6NO4m0q
        7TDnaLfjxwLftvxsLQ/9EoVWGOnO3/2TZvZZIjrQnDsQ7JKzRWRv3i1hLWytBNAn8DbCGq
        vtY+aC0BawJAj/hBUZbaRyz57VyhHsrxX7yVPR/rXIgon3hcyQA7X6hmWaZg2SlG0DsTUx
        zQNNfeYmdV6D17ByPlw2Pc5Qs1uVEOnkgeCUICFA6A2FsWrLm/GzPvnFsxd5Kw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id JBlAl97vwhRm; Sat, 14 Nov 2020 23:54:27 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 5/7] ip: iplink_bridge_slave: Convert to use print_on_off()
Date:   Sat, 14 Nov 2020 23:53:59 +0100
Message-Id: <edde03541654d6dc1a19f2805b34cbea82a85a4f.1605393324.git.me@pmachata.org>
In-Reply-To: <cover.1605393324.git.me@pmachata.org>
References: <cover.1605393324.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.06 / 15.00 / 15.00
X-Rspamd-Queue-Id: 7D61C17EB
X-Rspamd-UID: 37d9f7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of rolling a custom on-off printer, use the one added to utils.c.
Note that _print_onoff() has an extra parameter for a JSON-specific flag
name. However that argument is not used, and never was. Therefore when
moving over to print_on_off(), drop this argument.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 ip/iplink_bridge_slave.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/ip/iplink_bridge_slave.c b/ip/iplink_bridge_slave.c
index f7f6da0c79b7..717875864b18 100644
--- a/ip/iplink_bridge_slave.c
+++ b/ip/iplink_bridge_slave.c
@@ -76,14 +76,6 @@ static void print_portstate(FILE *f, __u8 state)
 		print_int(PRINT_ANY, "state_index", "state (%d) ", state);
 }
 
-static void _print_onoff(FILE *f, char *json_flag, char *flag, __u8 val)
-{
-	if (is_json_context())
-		print_bool(PRINT_JSON, flag, NULL, val);
-	else
-		fprintf(f, "%s %s ", flag, val ? "on" : "off");
-}
-
 static void _print_timer(FILE *f, const char *attr, struct rtattr *timer)
 {
 	struct timeval tv;
@@ -145,27 +137,27 @@ static void bridge_slave_print_opt(struct link_util *lu, FILE *f,
 			  rta_getattr_u32(tb[IFLA_BRPORT_COST]));
 
 	if (tb[IFLA_BRPORT_MODE])
-		_print_onoff(f, "mode", "hairpin",
+		print_on_off(PRINT_ANY, "hairpin", "hairpin %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_MODE]));
 
 	if (tb[IFLA_BRPORT_GUARD])
-		_print_onoff(f, "guard", "guard",
+		print_on_off(PRINT_ANY, "guard", "guard %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_GUARD]));
 
 	if (tb[IFLA_BRPORT_PROTECT])
-		_print_onoff(f, "protect", "root_block",
+		print_on_off(PRINT_ANY, "root_block", "root_block %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_PROTECT]));
 
 	if (tb[IFLA_BRPORT_FAST_LEAVE])
-		_print_onoff(f, "fast_leave", "fastleave",
+		print_on_off(PRINT_ANY, "fastleave", "fastleave %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_FAST_LEAVE]));
 
 	if (tb[IFLA_BRPORT_LEARNING])
-		_print_onoff(f, "learning", "learning",
+		print_on_off(PRINT_ANY, "learning", "learning %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_LEARNING]));
 
 	if (tb[IFLA_BRPORT_UNICAST_FLOOD])
-		_print_onoff(f, "unicast_flood", "flood",
+		print_on_off(PRINT_ANY, "flood", "flood %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_UNICAST_FLOOD]));
 
 	if (tb[IFLA_BRPORT_ID])
@@ -233,11 +225,11 @@ static void bridge_slave_print_opt(struct link_util *lu, FILE *f,
 			   rta_getattr_u8(tb[IFLA_BRPORT_CONFIG_PENDING]));
 
 	if (tb[IFLA_BRPORT_PROXYARP])
-		_print_onoff(f, "proxyarp", "proxy_arp",
+		print_on_off(PRINT_ANY, "proxy_arp", "proxy_arp %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_PROXYARP]));
 
 	if (tb[IFLA_BRPORT_PROXYARP_WIFI])
-		_print_onoff(f, "proxyarp_wifi", "proxy_arp_wifi",
+		print_on_off(PRINT_ANY, "proxy_arp_wifi", "proxy_arp_wifi %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_PROXYARP_WIFI]));
 
 	if (tb[IFLA_BRPORT_MULTICAST_ROUTER])
@@ -255,15 +247,15 @@ static void bridge_slave_print_opt(struct link_util *lu, FILE *f,
 			     rta_getattr_u8(tb[IFLA_BRPORT_FAST_LEAVE]) ? "on" : "off");
 
 	if (tb[IFLA_BRPORT_MCAST_FLOOD])
-		_print_onoff(f, "mcast_flood", "mcast_flood",
+		print_on_off(PRINT_ANY, "mcast_flood", "mcast_flood %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_MCAST_FLOOD]));
 
 	if (tb[IFLA_BRPORT_MCAST_TO_UCAST])
-		_print_onoff(f, "mcast_to_unicast", "mcast_to_unicast",
+		print_on_off(PRINT_ANY, "mcast_to_unicast", "mcast_to_unicast %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_MCAST_TO_UCAST]));
 
 	if (tb[IFLA_BRPORT_NEIGH_SUPPRESS])
-		_print_onoff(f, "neigh_suppress", "neigh_suppress",
+		print_on_off(PRINT_ANY, "neigh_suppress", "neigh_suppress %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_NEIGH_SUPPRESS]));
 
 	if (tb[IFLA_BRPORT_GROUP_FWD_MASK]) {
@@ -279,11 +271,11 @@ static void bridge_slave_print_opt(struct link_util *lu, FILE *f,
 	}
 
 	if (tb[IFLA_BRPORT_VLAN_TUNNEL])
-		_print_onoff(f, "vlan_tunnel", "vlan_tunnel",
+		print_on_off(PRINT_ANY, "vlan_tunnel", "vlan_tunnel %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_VLAN_TUNNEL]));
 
 	if (tb[IFLA_BRPORT_ISOLATED])
-		_print_onoff(f, "isolated", "isolated",
+		print_on_off(PRINT_ANY, "isolated", "isolated %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_ISOLATED]));
 
 	if (tb[IFLA_BRPORT_BACKUP_PORT]) {
-- 
2.25.1

