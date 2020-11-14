Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DD72B3141
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 23:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgKNWyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 17:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbgKNWyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 17:54:31 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C56C0613D2
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 14:54:31 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4CYVyY1GFczQlKG;
        Sat, 14 Nov 2020 23:54:29 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605394467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+u5u3Lg0CbyjmAxM+CEeypcUZ93rxPfCkV/la1WmHw0=;
        b=ivSpC3R1psv8jBmvoGPQ7ZQf1UsdzCzVXjLmdN7yYqFcWN5LLkMvPb8ygdf0QYWMiidykp
        KFDQFheF6J6rVX/OksgBSs4oIW5H8WKVPLj3+vito66bRi8nnueISkMMagX3Gp10D4gq/F
        4WAmVPqcfnuYO4eSV6GQmGicUK5bO9xlQkH9m3AyLMnx/SaoQcySnFdoVXD4wacZ00TJn5
        QfW/T//+U9er5m4yo4KnpopM0om5Hje8mohfNagtJLb46yI9J3RQlHhK/AlJhqgEnkTMgO
        oabECd9djRxr3/18Ba7XL1qhSyw5z1YiGXfuxT8eaIP9ecgocmxPvi0HUlW68A==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id xNRU-9kNYod4; Sat, 14 Nov 2020 23:54:25 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 2/7] bridge: link: Convert to use print_on_off()
Date:   Sat, 14 Nov 2020 23:53:56 +0100
Message-Id: <60fb244156972652b22b3b5809a25b38c7502b39.1605393324.git.me@pmachata.org>
In-Reply-To: <cover.1605393324.git.me@pmachata.org>
References: <cover.1605393324.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.09 / 15.00 / 15.00
X-Rspamd-Queue-Id: 2FB0D17E7
X-Rspamd-UID: acc96c
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of rolling a custom on-off printer, use the one added to utils.c.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 bridge/link.c | 56 ++++++++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 32 deletions(-)

diff --git a/bridge/link.c b/bridge/link.c
index fa6eda849b32..d88c469db78e 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -78,14 +78,6 @@ static void print_portstate(__u8 state)
 			     "state (%d) ", state);
 }
 
-static void print_onoff(FILE *fp, const char *flag, __u8 val)
-{
-	if (is_json_context())
-		print_bool(PRINT_JSON, flag, NULL, val);
-	else
-		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
-}
-
 static void print_hwmode(__u16 mode)
 {
 	if (mode >= ARRAY_SIZE(hw_mode))
@@ -123,38 +115,38 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
 			fprintf(fp, "%s    ", _SL_);
 
 		if (prtb[IFLA_BRPORT_MODE])
-			print_onoff(fp, "hairpin",
-				    rta_getattr_u8(prtb[IFLA_BRPORT_MODE]));
+			print_on_off(PRINT_ANY, "hairpin", "hairpin %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_MODE]));
 		if (prtb[IFLA_BRPORT_GUARD])
-			print_onoff(fp, "guard",
-				    rta_getattr_u8(prtb[IFLA_BRPORT_GUARD]));
+			print_on_off(PRINT_ANY, "guard", "guard %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_GUARD]));
 		if (prtb[IFLA_BRPORT_PROTECT])
-			print_onoff(fp, "root_block",
-				    rta_getattr_u8(prtb[IFLA_BRPORT_PROTECT]));
+			print_on_off(PRINT_ANY, "root_block", "root_block %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_PROTECT]));
 		if (prtb[IFLA_BRPORT_FAST_LEAVE])
-			print_onoff(fp, "fastleave",
-				    rta_getattr_u8(prtb[IFLA_BRPORT_FAST_LEAVE]));
+			print_on_off(PRINT_ANY, "fastleave", "fastleave %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_FAST_LEAVE]));
 		if (prtb[IFLA_BRPORT_LEARNING])
-			print_onoff(fp, "learning",
-				    rta_getattr_u8(prtb[IFLA_BRPORT_LEARNING]));
+			print_on_off(PRINT_ANY, "learning", "learning %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_LEARNING]));
 		if (prtb[IFLA_BRPORT_LEARNING_SYNC])
-			print_onoff(fp, "learning_sync",
-				    rta_getattr_u8(prtb[IFLA_BRPORT_LEARNING_SYNC]));
+			print_on_off(PRINT_ANY, "learning_sync", "learning_sync %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_LEARNING_SYNC]));
 		if (prtb[IFLA_BRPORT_UNICAST_FLOOD])
-			print_onoff(fp, "flood",
-				    rta_getattr_u8(prtb[IFLA_BRPORT_UNICAST_FLOOD]));
+			print_on_off(PRINT_ANY, "flood", "flood %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_UNICAST_FLOOD]));
 		if (prtb[IFLA_BRPORT_MCAST_FLOOD])
-			print_onoff(fp, "mcast_flood",
-				    rta_getattr_u8(prtb[IFLA_BRPORT_MCAST_FLOOD]));
+			print_on_off(PRINT_ANY, "mcast_flood", "mcast_flood %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_MCAST_FLOOD]));
 		if (prtb[IFLA_BRPORT_MCAST_TO_UCAST])
-			print_onoff(fp, "mcast_to_unicast",
-				    rta_getattr_u8(prtb[IFLA_BRPORT_MCAST_TO_UCAST]));
+			print_on_off(PRINT_ANY, "mcast_to_unicast", "mcast_to_unicast %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_MCAST_TO_UCAST]));
 		if (prtb[IFLA_BRPORT_NEIGH_SUPPRESS])
-			print_onoff(fp, "neigh_suppress",
-				    rta_getattr_u8(prtb[IFLA_BRPORT_NEIGH_SUPPRESS]));
+			print_on_off(PRINT_ANY, "neigh_suppress", "neigh_suppress %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_NEIGH_SUPPRESS]));
 		if (prtb[IFLA_BRPORT_VLAN_TUNNEL])
-			print_onoff(fp, "vlan_tunnel",
-				    rta_getattr_u8(prtb[IFLA_BRPORT_VLAN_TUNNEL]));
+			print_on_off(PRINT_ANY, "vlan_tunnel", "vlan_tunnel %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_VLAN_TUNNEL]));
 
 		if (prtb[IFLA_BRPORT_BACKUP_PORT]) {
 			int ifidx;
@@ -166,8 +158,8 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
 		}
 
 		if (prtb[IFLA_BRPORT_ISOLATED])
-			print_onoff(fp, "isolated",
-				    rta_getattr_u8(prtb[IFLA_BRPORT_ISOLATED]));
+			print_on_off(PRINT_ANY, "isolated", "isolated %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_ISOLATED]));
 	} else
 		print_portstate(rta_getattr_u8(attr));
 }
-- 
2.25.1

