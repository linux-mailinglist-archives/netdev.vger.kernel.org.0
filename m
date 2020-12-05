Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FAD2CFF1F
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgLEVPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgLEVPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 16:15:05 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50355C061A4F
        for <netdev@vger.kernel.org>; Sat,  5 Dec 2020 13:14:25 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CpMlM6RQ2zQlKJ;
        Sat,  5 Dec 2020 22:14:23 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607202862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MOy+Jg0HfU7nTdZjUwcJ7pAVUCmm2te5eFX8paJ4Shg=;
        b=B581OOcs0gAGCqGn1fa499QzxAJH8OkK7Ks1Wk2eBS6aU+UGKxLNKN3TOg0bmiULZvFQqo
        T0QHTfuhSC3jKeJPyZIPmAAzEKF+OlT1x7QmhOyrz0EasW5vEbTLkdjRoJxY2bHPZf07eU
        /74nUY192XKw/dFXwz/bTegYk3wmvsZe2oMu5BPPKnqNOe2HhlLjwMIs8LxudvhrwuNM9H
        zOCUBkLGsMCpgNCRwmA5rcsRd+3ZV4PGjoy4SuG1Z8+6J02h7v5tkUoc5s6ZMdSsXp1Usp
        PDq9Sy0SFBPQj+7d1qs4CEXRnxs+q2qebqHIrDJVq3UqNYcbxSub5gyF9QjKAw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id jsVS3T50vNwH; Sat,  5 Dec 2020 22:14:20 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, leon@kernel.org,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 5/7] lib: print_color_rate(): Fix formatting small rates in IEC mode
Date:   Sat,  5 Dec 2020 22:13:33 +0100
Message-Id: <01ae308a04bd16c8671cfef2d14688f00bef4846.1607201857.git.me@pmachata.org>
In-Reply-To: <cover.1607201857.git.me@pmachata.org>
References: <cover.1607201857.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 2.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: D66BA171D
X-Rspamd-UID: 430b9f
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ISO/IEC units are distinguished from the decadic ones by using a prefixes
like "Ki", "Mi" instead of "K" and "M". The current code inserts the letter
"i" after the decadic unit when in IEC mode. However it does so even when
the prefix is an empty string, formatting 1Kbit in IEC mode as "1000ibit".
Fix by omitting the letter if there is no prefix.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 lib/json_print.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/json_print.c b/lib/json_print.c
index d28e957c9603..b086123ad1f4 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -333,7 +333,8 @@ int print_color_rate(bool use_iec, enum output_type type, enum color_attr color,
 		rate /= kilo;
 	}
 
-	rc = asprintf(&buf, "%.0f%s%sbit", (double)rate, units[i], str);
+	rc = asprintf(&buf, "%.0f%s%sbit", (double)rate, units[i],
+		      i > 0 ? str : "");
 	if (rc < 0)
 		return -1;
 
-- 
2.25.1

