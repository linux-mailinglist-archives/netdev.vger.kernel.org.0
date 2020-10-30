Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFF42A056A
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgJ3MbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgJ3MbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:31:16 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6935C0613D2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 05:31:15 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CN1rK5QvRzQkJg;
        Fri, 30 Oct 2020 13:31:13 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604061071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BszT7JLDxFOvofg7/1xMCcph79s1fIPk1iSklTLrGvI=;
        b=FLTsRAtayvcYfsDC3hbQiJe+buB1PWPz+OOhkOWB5dvEmAPUCtxyNQCwaCJp/+ZgkvHTg+
        fIt/xOtNcSwMUG1YdxXve7EPZvePRlx/et/bZlcirczYnWbvHnY0vHda+Jia07B7GDdFE8
        bVoxK3Mz1b+1LrEuzXq8Qa8LYwct9GcBfYGC7r9gXyHN9vTZfwL4vGiwcd0exfKHVLlFya
        rUZAgGo2ls8yqKbKHgh1MPXltyFaNu9rcwiHCklZcxfTXtQaYxiqi0d5ubapZo3M0hkSOz
        hvjpf7K6n1o/N44H6l2KS+cq/BvjLYkcviVqP0dYC/gg+u10rYQVUumerc851g==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id zLOaPs6oujom; Fri, 30 Oct 2020 13:31:11 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 08/11] lib: parse_mapping: Update argc, argv on error
Date:   Fri, 30 Oct 2020 13:29:55 +0100
Message-Id: <4eaa2d34e2876a1901f4be565e21b482b9d55205.1604059429.git.me@pmachata.org>
In-Reply-To: <cover.1604059429.git.me@pmachata.org>
References: <cover.1604059429.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.64 / 15.00 / 15.00
X-Rspamd-Queue-Id: B1485171D
X-Rspamd-UID: 7b12ae
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
index aba7cc0960cd..089bbde715da 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1778,6 +1778,7 @@ int parse_mapping(int *argcp, char ***argvp,
 {
 	int argc = *argcp;
 	char **argv = *argvp;
+	int ret = 0;
 
 	while (argc > 0) {
 		char *colon = strchr(*argv, ':');
@@ -1787,15 +1788,19 @@ int parse_mapping(int *argcp, char ***argvp,
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

