Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B932A2C91ED
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbgK3XDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgK3XDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:03:20 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9F9C061A04
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:02:25 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4ClLMp4jDGzQlNl;
        Tue,  1 Dec 2020 00:01:58 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1606777316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+3OlJCBeFvKdbWv8Aag5SrkaHDSuMwSfuCcA7AweXnQ=;
        b=Vn/CpGzKdmttmlacD0sKFExTL1x3BEvlSWLCPLxOGlk2DnBkT1JlDQ0ToMTkyC64yrl//Z
        huWS1QaSDztlRo2njKHjKT28EReNOpxy8qMcQSVIF2Zs9kG6iImll/5cTOLDxV6nMmbz8Q
        nu3JTgdDHvv50lcpqV2XINHO9Gg3pK7lzmvuBMVUldBXC1Z0tGa9y7JeJzuobFyaB0KNf9
        3R1RQS3Kqmz/A+jmassdttQVMKRNhMFDDgI01mU6tJPZyJrNqS0JyhYo18mArl83E2bRYi
        OIUbfF/mu8+q1PtP7opm0wLA+Iw+Z/9vIBHHP1gHU51DFnf+hDq5izv291JT0w==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id rep_y_lVx11X; Tue,  1 Dec 2020 00:01:55 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, vtlam@google.com,
        leon@kernel.org, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 6/6] lib: print_rate(): Fix formatting small rates in IEC mode
Date:   Mon, 30 Nov 2020 23:59:42 +0100
Message-Id: <33d80a1bc452700952c56b21b1f4418632ba792d.1606774951.git.me@pmachata.org>
In-Reply-To: <cover.1606774951.git.me@pmachata.org>
References: <cover.1606774951.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: ***
X-Rspamd-Score: 3.27 / 15.00 / 15.00
X-Rspamd-Queue-Id: A5F151835
X-Rspamd-UID: 3a215d
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
index c1df637642fd..625a98e35591 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -333,7 +333,8 @@ int print_color_rate(bool use_iec, enum output_type type, enum color_attr color,
 		rate /= kilo;
 	}
 
-	rc = asprintf(&buf, "%.0f%s%sbit", (double)rate, units[i], str);
+	rc = asprintf(&buf, "%.0f%s%sbit", (double)rate, units[i],
+		 i > 0 ? str : "");
 	if (rc < 0)
 		return -1;
 
-- 
2.25.1

