Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A242A2B3146
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 23:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgKNWye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 17:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbgKNWyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 17:54:32 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC80AC0617A6
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 14:54:32 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CYVyZ0RWvzQlWB;
        Sat, 14 Nov 2020 23:54:30 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605394468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A567HYBTP4riCgYWHUPr/7lhUfri1B3/kpTiv7QPqqE=;
        b=klb+247sSQx1ve97efp5MdHJ/0jW/cX2nWfnfpqq7kGWnmAYGHL513w8XvPMH8VWIgDU45
        lbfQ6vz7upyFyewMLvriFhvq2WUkhcuZdeHbZ8ctcLm4cVPCl0/CMEgAGgwc/vTG+3Uchz
        /B0wlMFtAhVKnsvfSyuN87SwVYhJth/dCz5SlGfZZ7hNVEoJ8sEFlwdXjQIkqXEfndm8vQ
        9GWchnWVbXryUPNdlin4nBLY9CEgUEgq1a28Zvww3FgfjEq6YDG6vw+V1On6PLJ/UKYnHN
        FKfAeK+8eKc84CnSRZ5eIZvfbQGq2cUq2iBdDBqgiiTwQweHKZE+iwrs0dbWLQ==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id CQ6gGUKqXW7m; Sat, 14 Nov 2020 23:54:26 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 4/7] ip: iplink_bridge_slave: Port over to parse_on_off()
Date:   Sat, 14 Nov 2020 23:53:58 +0100
Message-Id: <c25d7deab6c9933cf5b515ca84858d999f2caf90.1605393324.git.me@pmachata.org>
In-Reply-To: <cover.1605393324.git.me@pmachata.org>
References: <cover.1605393324.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -0.33 / 15.00 / 15.00
X-Rspamd-Queue-Id: 0D23314AF
X-Rspamd-UID: f18bcd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Invoke parse_on_off() from bridge_slave_parse_on_off() instead of
hand-rolling one. Exit on failure, because the invarg that was ivoked here
before would.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 ip/iplink_bridge_slave.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/ip/iplink_bridge_slave.c b/ip/iplink_bridge_slave.c
index 79a1d2f5f5b8..f7f6da0c79b7 100644
--- a/ip/iplink_bridge_slave.c
+++ b/ip/iplink_bridge_slave.c
@@ -297,15 +297,11 @@ static void bridge_slave_print_opt(struct link_util *lu, FILE *f,
 static void bridge_slave_parse_on_off(char *arg_name, char *arg_val,
 				      struct nlmsghdr *n, int type)
 {
-	__u8 val;
-
-	if (strcmp(arg_val, "on") == 0)
-		val = 1;
-	else if (strcmp(arg_val, "off") == 0)
-		val = 0;
-	else
-		invarg("should be \"on\" or \"off\"", arg_name);
+	int ret;
+	__u8 val = parse_on_off(arg_name, arg_val, &ret);
 
+	if (ret)
+		exit(1);
 	addattr8(n, 1024, type, val);
 }
 
-- 
2.25.1

