Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1882B3144
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 23:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgKNWye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 17:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgKNWyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 17:54:33 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A31C0617A7
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 14:54:33 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CYVyZ6n4SzQl1t;
        Sat, 14 Nov 2020 23:54:30 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605394469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zi8jG1Y9NOLgXzA1rQA/blRS5lcPOzUMR9gZLpM6Yxw=;
        b=znuRZJkfpZxfI4Ny7fGHXmvprdKuzrNXopikPjbEygzg1MzZecTskDL+g49zb6D6S1q2DY
        0xs/LuYflY1vqVgrPtpq9KyHLBwCnuULxHvgEgl1ULqAak3TH5ZwgKyYllLIT5oBupFUs5
        N39D2+Jahr0dL9EmW1s98Fksid3Yo/CmPfZnlXZeWDjIfgE51LlBPGxhsCv4Lch3TDl7+7
        tHia7Ta6Ww+Pujh1IClRvVHEibe9YQGxbEN4lgcTrHCnNdPs6CaMUNo7aw5D3iEJd4gH7e
        3Mg8ABTLpeeN9XUsu9Lx6cddr04YT2BWlaDbOGZ2nux2y1oNjateeFBTB/3DsA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id E3Y-khGL2H-u; Sat, 14 Nov 2020 23:54:28 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 6/7] ip: ipnetconf: Convert to use print_on_off()
Date:   Sat, 14 Nov 2020 23:54:00 +0100
Message-Id: <fda6f7d9c8cd7c8a5df9ace033bb737b7cb16747.1605393324.git.me@pmachata.org>
In-Reply-To: <cover.1605393324.git.me@pmachata.org>
References: <cover.1605393324.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.07 / 15.00 / 15.00
X-Rspamd-Queue-Id: 034991825
X-Rspamd-UID: 369208
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of rolling a custom on-off printer, use the one added to utils.c.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 ip/ipnetconf.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/ip/ipnetconf.c b/ip/ipnetconf.c
index 0e946ca34b4a..bb0ebe12da93 100644
--- a/ip/ipnetconf.c
+++ b/ip/ipnetconf.c
@@ -41,14 +41,6 @@ static void usage(void)
 	exit(-1);
 }
 
-static void print_onoff(FILE *fp, const char *flag, __u32 val)
-{
-	if (is_json_context())
-		print_bool(PRINT_JSON, flag, NULL, val);
-	else
-		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
-}
-
 static struct rtattr *netconf_rta(struct netconfmsg *ncm)
 {
 	return (struct rtattr *)((char *)ncm
@@ -117,8 +109,8 @@ int print_netconf(struct rtnl_ctrl_data *ctrl, struct nlmsghdr *n, void *arg)
 	}
 
 	if (tb[NETCONFA_FORWARDING])
-		print_onoff(fp, "forwarding",
-				rta_getattr_u32(tb[NETCONFA_FORWARDING]));
+		print_on_off(PRINT_ANY, "forwarding", "forwarding %s ",
+			     rta_getattr_u32(tb[NETCONFA_FORWARDING]));
 
 	if (tb[NETCONFA_RP_FILTER]) {
 		__u32 rp_filter = rta_getattr_u32(tb[NETCONFA_RP_FILTER]);
@@ -133,19 +125,21 @@ int print_netconf(struct rtnl_ctrl_data *ctrl, struct nlmsghdr *n, void *arg)
 	}
 
 	if (tb[NETCONFA_MC_FORWARDING])
-		print_onoff(fp, "mc_forwarding",
-				rta_getattr_u32(tb[NETCONFA_MC_FORWARDING]));
+		print_on_off(PRINT_ANY, "mc_forwarding", "mc_forwarding %s ",
+			     rta_getattr_u32(tb[NETCONFA_MC_FORWARDING]));
 
 	if (tb[NETCONFA_PROXY_NEIGH])
-		print_onoff(fp, "proxy_neigh",
-				rta_getattr_u32(tb[NETCONFA_PROXY_NEIGH]));
+		print_on_off(PRINT_ANY, "proxy_neigh", "proxy_neigh %s ",
+			     rta_getattr_u32(tb[NETCONFA_PROXY_NEIGH]));
 
 	if (tb[NETCONFA_IGNORE_ROUTES_WITH_LINKDOWN])
-		print_onoff(fp, "ignore_routes_with_linkdown",
-		     rta_getattr_u32(tb[NETCONFA_IGNORE_ROUTES_WITH_LINKDOWN]));
+		print_on_off(PRINT_ANY, "ignore_routes_with_linkdown",
+			     "ignore_routes_with_linkdown %s ",
+			     rta_getattr_u32(tb[NETCONFA_IGNORE_ROUTES_WITH_LINKDOWN]));
 
 	if (tb[NETCONFA_INPUT])
-		print_onoff(fp, "input", rta_getattr_u32(tb[NETCONFA_INPUT]));
+		print_on_off(PRINT_ANY, "input", "input %s ",
+			     rta_getattr_u32(tb[NETCONFA_INPUT]));
 
 	close_json_object();
 	print_string(PRINT_FP, NULL, "\n", NULL);
-- 
2.25.1

