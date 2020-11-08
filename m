Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F032AAD94
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 22:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgKHVOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 16:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbgKHVOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 16:14:48 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAA2C0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 13:14:47 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CTn2F5DrLzQkZy;
        Sun,  8 Nov 2020 22:14:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604870083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFbtoKg0yNPTPNPiJU6eAQZTm+DpY3s42tO2xXgqpCA=;
        b=MdGUtWZ8Cgmus7B/ZA9s6dEjnlz9/15/ld4GwgAtsh7rg3z8/OKOGz/+79YRvX/JYshbS/
        r/ntmK3KgzCmMja849D7aR59jIHt0CWje60DY9+zuvIQd82IphYQ2vLNbaIU11MP6xK7OL
        GrEmY1NMaffRjcSEkLfU276oTJeE15/d4/Y1HfEH4IdCmL6/iqUt9ec4FqX6TnmgkZYx9T
        6XUFNnDdryrqqvzB/iIJAkttctK4u248U5m2S0CUyHLb2TQFavhCmYn6SrMnNLJ1hMrtoG
        Nzzni/WcHZ2Y08O/qSGCDMEZUvIux+4D+rR2YcGn2i/AlkF1Mrm/CzVME3e8JQ==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id pW_USuaWyQCB; Sun,  8 Nov 2020 22:14:42 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v4 08/11] lib: parse_mapping: Update argc, argv on error
Date:   Sun,  8 Nov 2020 22:14:13 +0100
Message-Id: <c7f122316070b78c1dccf23c86585d03be55d633.1604869679.git.me@pmachata.org>
In-Reply-To: <cover.1604869679.git.me@pmachata.org>
References: <cover.1604869679.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.24 / 15.00 / 15.00
X-Rspamd-Queue-Id: B4235171D
X-Rspamd-UID: 66e810
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently argc and argv are not updated unless parsing of all of the
mapping was successful. However in that case, "ip link" will point at the
wrong argument when complaining:

    # ip link add name eth0.100 link eth0 type vlan id 100 egress 1:1 2:foo
    Error: argument "1" is wrong: invalid egress-qos-map

Update argc and argv even in the case of parsing error, so that the right
element is indicated.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 lib/utils.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/lib/utils.c b/lib/utils.c
index 1dfaaf564915..67d64df7e3e6 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1770,6 +1770,7 @@ int parse_mapping(int *argcp, char ***argvp,
 {
 	int argc = *argcp;
 	char **argv = *argvp;
+	int ret = 0;
 
 	while (argc > 0) {
 		char *colon = strchr(*argv, ':');
@@ -1779,15 +1780,19 @@ int parse_mapping(int *argcp, char ***argvp,
 			break;
 		*colon = '\0';
 
-		if (get_u32(&key, *argv, 0))
-			return 1;
-		if (mapping_cb(key, colon + 1, mapping_cb_data))
-			return 1;
+		if (get_u32(&key, *argv, 0)) {
+			ret = 1;
+			break;
+		}
+		if (mapping_cb(key, colon + 1, mapping_cb_data)) {
+			ret = 1;
+			break;
+		}
 
 		argc--, argv++;
 	}
 
 	*argcp = argc;
 	*argvp = argv;
-	return 0;
+	return ret;
 }
-- 
2.25.1

