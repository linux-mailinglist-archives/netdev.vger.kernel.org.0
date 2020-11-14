Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD912B3147
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 23:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgKNWyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 17:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgKNWye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 17:54:34 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E536AC0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 14:54:33 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4CYVyb4WmKzQjgg;
        Sat, 14 Nov 2020 23:54:31 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605394469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uqlQ23kdqZpfS+l2+AIpmp0Q53aI9litOdsPbB21G8A=;
        b=VMrJlSjjkI+WlTj2I9a+BUT8s0aQho4UEkE7uCpEzn3ChdYGZjbJilR+PuLZcj0R/HDP/L
        2YDM0pPlizTz1JYKOs2mZP8NWNkMCsFQt38Y/iPu1xW1CiQU3bDcFWbP2+OU6QHbMXlFxX
        CVhTtcfd5erap5YMDMs+tuGlFuOgaXUUZJdTjPqh3gWRrIn1qmrrShLKHWPnnetbeLusQa
        MFwotMoa/p6T5i6gnrQFuBUdlMA1k0JI3oOIU9UM5KEA5iL2iU9AFaGCww5786Rv/tnhBr
        rJsvWUlDt3LvFqqtVRW/CrBRlSX0hqLUziwEvS1nJfyN2744iXCn+5clpiPXtA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id LBHIUtYpVeQU; Sat, 14 Nov 2020 23:54:28 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 7/7] ip: iptuntap: Convert to use print_on_off()
Date:   Sat, 14 Nov 2020 23:54:01 +0100
Message-Id: <bae76c8201cefbcc7a5a3f3b6f65e84ccaed559e.1605393324.git.me@pmachata.org>
In-Reply-To: <cover.1605393324.git.me@pmachata.org>
References: <cover.1605393324.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.08 / 15.00 / 15.00
X-Rspamd-Queue-Id: A345317E7
X-Rspamd-UID: 204a0b
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of rolling a custom on-off printer, use the one added to utils.c.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 ip/iptuntap.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/ip/iptuntap.c b/ip/iptuntap.c
index 82e384998b1c..e9cc7c0f5f70 100644
--- a/ip/iptuntap.c
+++ b/ip/iptuntap.c
@@ -541,14 +541,6 @@ static void print_mq(FILE *f, struct rtattr *tb[])
 	}
 }
 
-static void print_onoff(FILE *f, const char *flag, __u8 val)
-{
-	if (is_json_context())
-		print_bool(PRINT_JSON, flag, NULL, !!val);
-	else
-		fprintf(f, "%s %s ", flag, val ? "on" : "off");
-}
-
 static void print_type(FILE *f, __u8 type)
 {
 	SPRINT_BUF(buf);
@@ -573,17 +565,19 @@ static void tun_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		print_type(f, rta_getattr_u8(tb[IFLA_TUN_TYPE]));
 
 	if (tb[IFLA_TUN_PI])
-		print_onoff(f, "pi", rta_getattr_u8(tb[IFLA_TUN_PI]));
+		print_on_off(PRINT_ANY, "pi", "pi %s ",
+			     rta_getattr_u8(tb[IFLA_TUN_PI]));
 
 	if (tb[IFLA_TUN_VNET_HDR]) {
-		print_onoff(f, "vnet_hdr",
-			    rta_getattr_u8(tb[IFLA_TUN_VNET_HDR]));
+		print_on_off(PRINT_ANY, "vnet_hdr", "vnet_hdr %s ",
+			     rta_getattr_u8(tb[IFLA_TUN_VNET_HDR]));
 	}
 
 	print_mq(f, tb);
 
 	if (tb[IFLA_TUN_PERSIST])
-		print_onoff(f, "persist", rta_getattr_u8(tb[IFLA_TUN_PERSIST]));
+		print_on_off(PRINT_ANY, "persist", "persist %s ",
+			     rta_getattr_u8(tb[IFLA_TUN_PERSIST]));
 
 	if (tb[IFLA_TUN_OWNER])
 		print_owner(f, rta_getattr_u32(tb[IFLA_TUN_OWNER]));
-- 
2.25.1

