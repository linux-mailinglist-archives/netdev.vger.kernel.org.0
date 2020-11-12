Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C924C2B1175
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbgKLW0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgKLW0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:26:14 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192FFC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:26:14 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4CXGQq0cyMzQl1t;
        Thu, 12 Nov 2020 23:26:11 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605219969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFbtoKg0yNPTPNPiJU6eAQZTm+DpY3s42tO2xXgqpCA=;
        b=aml0QnCDvhNpi7qkKyz1897kWmSrssEmZyjrHpnSN10gOKOY0LWJnX4TmNM55Z8lC/nCAq
        cr4AfT0/aHCjgA2jRZ1L/gDeC2r8BOe7OYBPG0IsaIky6A39YWdv/+SmTrnAB1QJAnHJBa
        /60EgR0pOhMkDQwrftZDwcsaGhKefpUbr6qKMupYXgALqQkBip3/jR2OVRw1Sp+LVp4da+
        19+Poi/jPklJwcR0QdLR51AUEHtCAZZvcGfUqGF9v5r76FH5RLb4lLcN4txAf5NTR+dIO9
        SPXPjbNkOaV6qoguJYnG1FPUBLZ5WRKGl74yN5lRuSYXSpXBJMdJ2hWFu5qJgw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id AGDP6yLZAqw9; Thu, 12 Nov 2020 23:26:08 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v5 08/11] lib: parse_mapping: Update argc, argv on error
Date:   Thu, 12 Nov 2020 23:24:45 +0100
Message-Id: <7317b38aaed39a1a25cd2d4f8695869134362473.1605218735.git.me@pmachata.org>
In-Reply-To: <cover.1605218735.git.me@pmachata.org>
References: <cover.1605218735.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.17 / 15.00 / 15.00
X-Rspamd-Queue-Id: 007AB1718
X-Rspamd-UID: 67f630
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

