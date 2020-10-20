Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222AD293279
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389652AbgJTA64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389646AbgJTA6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:58:55 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92CCC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:58:54 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4CFZy53gdVzKmWR;
        Tue, 20 Oct 2020 02:58:53 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A567HYBTP4riCgYWHUPr/7lhUfri1B3/kpTiv7QPqqE=;
        b=qS9gqkwjO1IXA+s3wgY48O9DpduzGIVwna3/x5F+z0Sw8BDwqwy8kArJ3VZp8p42Ae780y
        07SU+8Jcp3/jRLH6JHIoBJhFpQZo3gOVofbHIO+4DB84ZsN+XSqcAO/fCOoIVPlnAG1uWr
        X84/4NlfW21Kx4ftOmAlhP56IApl1PMGDRKfw4d61bWHPP7BtbKgTf4+wbgoCOpxQHi1V8
        zVZ3cxmJU1RsyiJWcI6Fc72iSEeGAGLSf4DMQl967AEHTPX1PZ/w0GW7v+QigVz7NcPDJe
        46EEbf6Q+tQjygSDNXGu2DiD0GgZcI8WiVFmVto6QSYeE/DylHCfvzDiRIzl3g==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id E_9Q4i9odwgs; Tue, 20 Oct 2020 02:58:50 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 07/15] ip: iplink_bridge_slave: Port over to parse_on_off()
Date:   Tue, 20 Oct 2020 02:58:15 +0200
Message-Id: <5ffa0dd1e85549563a5d458f09bc1dfbc3e937a6.1603154867.git.me@pmachata.org>
In-Reply-To: <cover.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.53 / 15.00 / 15.00
X-Rspamd-Queue-Id: 8A4A917E0
X-Rspamd-UID: 16a04a
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

