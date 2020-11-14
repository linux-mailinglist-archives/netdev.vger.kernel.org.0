Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1572B3142
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 23:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgKNWyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 17:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgKNWyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 17:54:31 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E29C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 14:54:31 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4CYVyX3ZyszQjgg;
        Sat, 14 Nov 2020 23:54:28 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605394466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dUS9jOOAuzSoUyy/xwxRj5MFhtbHRbp7RM71rXERF2I=;
        b=IrcqDivV4IWznSQpr8b/JlwnhVE58deuJY2J9+Y4tkZyC1knfwkYsIbc39f+ov0UxVLi4z
        R0QjpBzHfHy0p8LnQgS0BCEDmC+C3zNrffXKc2l6wouxSEdRJEJpNCAC3goyTjuZ72jL4u
        5CpL1G9gmwWCcbcS8kx6PQHz0N7tOJDtdLal6eqmzRoQIwirr9GlBnum4Nr6BWlFS69lO+
        WTvNdA9XFqnTfANwrzC3dhmL1ujhvsKElFl9iKh5HmTW3xq6ni7b50PbJsP4Vnhq3X0sLu
        VTEFhRVh8j9v1toBZuucACigcxm+s46Tb5RcGf8TiDDCluWlbLuX+ZLLYUlc2A==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id cFlkO0XL31jK; Sat, 14 Nov 2020 23:54:25 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 1/7] bridge: link: Port over to parse_on_off()
Date:   Sat, 14 Nov 2020 23:53:55 +0100
Message-Id: <97d607c78f923b30a09f11d008b4fcda742c02d4.1605393324.git.me@pmachata.org>
In-Reply-To: <cover.1605393324.git.me@pmachata.org>
References: <cover.1605393324.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -0.36 / 15.00 / 15.00
X-Rspamd-Queue-Id: 812E31825
X-Rspamd-UID: 92a9b1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert bridge/link.c from a custom on_off parser to the new global one.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 bridge/link.c | 79 ++++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 42 deletions(-)

diff --git a/bridge/link.c b/bridge/link.c
index 3bc7af209b8b..fa6eda849b32 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -275,22 +275,6 @@ static void usage(void)
 	exit(-1);
 }
 
-static bool on_off(char *arg, __s8 *attr, char *val)
-{
-	if (strcmp(val, "on") == 0)
-		*attr = 1;
-	else if (strcmp(val, "off") == 0)
-		*attr = 0;
-	else {
-		fprintf(stderr,
-			"Error: argument of \"%s\" must be \"on\" or \"off\"\n",
-			arg);
-		return false;
-	}
-
-	return true;
-}
-
 static int brlink_modify(int argc, char **argv)
 {
 	struct {
@@ -323,6 +307,7 @@ static int brlink_modify(int argc, char **argv)
 	__s16 mode = -1;
 	__u16 flags = 0;
 	struct rtattr *nest;
+	int ret;
 
 	while (argc > 0) {
 		if (strcmp(*argv, "dev") == 0) {
@@ -330,40 +315,49 @@ static int brlink_modify(int argc, char **argv)
 			d = *argv;
 		} else if (strcmp(*argv, "guard") == 0) {
 			NEXT_ARG();
-			if (!on_off("guard", &bpdu_guard, *argv))
-				return -1;
+			bpdu_guard = parse_on_off("guard", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "hairpin") == 0) {
 			NEXT_ARG();
-			if (!on_off("hairpin", &hairpin, *argv))
-				return -1;
+			hairpin = parse_on_off("hairpin", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "fastleave") == 0) {
 			NEXT_ARG();
-			if (!on_off("fastleave", &fast_leave, *argv))
-				return -1;
+			fast_leave = parse_on_off("fastleave", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "root_block") == 0) {
 			NEXT_ARG();
-			if (!on_off("root_block", &root_block, *argv))
-				return -1;
+			root_block = parse_on_off("root_block", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "learning") == 0) {
 			NEXT_ARG();
-			if (!on_off("learning", &learning, *argv))
-				return -1;
+			learning = parse_on_off("learning", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "learning_sync") == 0) {
 			NEXT_ARG();
-			if (!on_off("learning_sync", &learning_sync, *argv))
-				return -1;
+			learning_sync = parse_on_off("learning_sync", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "flood") == 0) {
 			NEXT_ARG();
-			if (!on_off("flood", &flood, *argv))
-				return -1;
+			flood = parse_on_off("flood", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "mcast_flood") == 0) {
 			NEXT_ARG();
-			if (!on_off("mcast_flood", &mcast_flood, *argv))
-				return -1;
+			mcast_flood = parse_on_off("mcast_flood", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "mcast_to_unicast") == 0) {
 			NEXT_ARG();
-			if (!on_off("mcast_to_unicast", &mcast_to_unicast, *argv))
-				return -1;
+			mcast_to_unicast = parse_on_off("mcast_to_unicast", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "cost") == 0) {
 			NEXT_ARG();
 			cost = atoi(*argv);
@@ -404,18 +398,19 @@ static int brlink_modify(int argc, char **argv)
 			flags |= BRIDGE_FLAGS_MASTER;
 		} else if (strcmp(*argv, "neigh_suppress") == 0) {
 			NEXT_ARG();
-			if (!on_off("neigh_suppress", &neigh_suppress,
-				    *argv))
-				return -1;
+			neigh_suppress = parse_on_off("neigh_suppress", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "vlan_tunnel") == 0) {
 			NEXT_ARG();
-			if (!on_off("vlan_tunnel", &vlan_tunnel,
-				    *argv))
-				return -1;
+			vlan_tunnel = parse_on_off("vlan_tunnel", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "isolated") == 0) {
 			NEXT_ARG();
-			if (!on_off("isolated", &isolated, *argv))
-				return -1;
+			isolated = parse_on_off("isolated", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "backup_port") == 0) {
 			NEXT_ARG();
 			backup_port_idx = ll_name_to_index(*argv);
-- 
2.25.1

