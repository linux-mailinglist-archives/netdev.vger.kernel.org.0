Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BCC2CFF1C
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgLEVPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgLEVPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 16:15:05 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB91C0613D4
        for <netdev@vger.kernel.org>; Sat,  5 Dec 2020 13:14:24 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CpMlM0V4NzQjhF;
        Sat,  5 Dec 2020 22:14:23 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607202861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yQaGFvfsRhOWH7TTb/nTzNfIAJvbZkrgSJo810vo8sI=;
        b=IOhtZ7QB8dQFgL5g87ijsPKA3ziSAt1AYfp/TeZpBkAP+1OCemTlh5OfgpKAoe/i+FqtUa
        FKSin4HJBowvgqui12yrQYcI5A7eYHEyC2tGrPmOLtLf33wuQx4OgMN7y1niVc50A1Qv0w
        jueLARVI/18laH/bzkU2e7a2NNgFOgv7STZQeSSxw1NISE1M4suncCwfGUGVy2N51TRWgz
        t8ImuXGLUTuJc1XrJgUggT4PL4gWDdpxcDhWtDRnxRv3E6LNyX4d9MQ0yc+tFt6FywdBR9
        2NkE6Q7mHVd1U2KfawhvS+Q4gqqi36N9meK0hyOSmlVd3x8T+jMqawKIZJeRQw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id zmweDkFS7ub9; Sat,  5 Dec 2020 22:14:19 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, leon@kernel.org,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 4/7] lib: sprint_size(): Uncrustify the code a bit
Date:   Sat,  5 Dec 2020 22:13:32 +0100
Message-Id: <5de07d7849479adb8b660060d06004ab8582ed48.1607201857.git.me@pmachata.org>
In-Reply-To: <cover.1607201857.git.me@pmachata.org>
References: <cover.1607201857.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.69 / 15.00 / 15.00
X-Rspamd-Queue-Id: 04C4C17B0
X-Rspamd-UID: d88a34
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ideally this and the rate printing would both be converted to a common
helper, but unfortunately the two format differently and this would break
tests and scripts out there. So just make the code look less like a wad of
hay.

Signed-off-by: Petr Machata <me@pmachata.org>
---

Notes:
    v2:
    - This patch is new. It addresses a request from Stephen Hemminger to
      clean up the sprint_size() function.

 lib/json_print.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/json_print.c b/lib/json_print.c
index c1df637642fd..d28e957c9603 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -344,13 +344,15 @@ int print_color_rate(bool use_iec, enum output_type type, enum color_attr color,
 
 char *sprint_size(__u32 sz, char *buf)
 {
+	long kilo = 1024;
+	long mega = kilo * kilo;
 	size_t len = SPRINT_BSIZE - 1;
 	double tmp = sz;
 
-	if (sz >= 1024*1024 && fabs(1024*1024*rint(tmp/(1024*1024)) - sz) < 1024)
-		snprintf(buf, len, "%gMb", rint(tmp/(1024*1024)));
-	else if (sz >= 1024 && fabs(1024*rint(tmp/1024) - sz) < 16)
-		snprintf(buf, len, "%gKb", rint(tmp/1024));
+	if (sz >= mega && fabs(mega * rint(tmp / mega) - sz) < 1024)
+		snprintf(buf, len, "%gMb", rint(tmp / mega));
+	else if (sz >= kilo && fabs(kilo * rint(tmp / kilo) - sz) < 16)
+		snprintf(buf, len, "%gKb", rint(tmp / kilo));
 	else
 		snprintf(buf, len, "%ub", sz);
 
-- 
2.25.1

