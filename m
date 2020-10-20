Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC0E29327F
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389696AbgJTA7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389668AbgJTA67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:58:59 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E6EC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:58:59 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CFZy95C0NzKmTX;
        Tue, 20 Oct 2020 02:58:57 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mHHIVdL+6fz/NZkeLc5Gyb+Y6vCPyyTwCsQNcTqYljc=;
        b=f2a+FcjfvDRXw4bXspW2Q8DQ3B45ahiS5OfY/yyQHcuf2kT4SyhaDnmVYxT69lbUp90bCl
        ajzqShvjT+vCgiGKhMvuJfjkr+nUTcaQ0fa0YFsJ9BRoZDqODj0KSZM5YP+Goc3mTd1Omm
        jMp5Ck8NNG9+9CkkBP5iGv66uxigAGvx+T9bSqfE6jOtkr8w2sTXS/YcS1KkIQ75GN4cJv
        dMJbUoxZcFZAijX6l+Xypj+Ry8E84fb9+HtWwXqGa13iG5hyNCDXqzIiYTT2LhhgeQ/z22
        ratEktKFap8HR0BMmfxcF3lbO58pbSWGuwcIwbn3Ap9T4b8PkN++EOA6fIjHzw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id f8QfjJZooIX5; Tue, 20 Oct 2020 02:58:54 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 12/15] lib: parse_mapping: Update argc, argv on error
Date:   Tue, 20 Oct 2020 02:58:20 +0200
Message-Id: <c6f436e13bde0132b4bb1ea85a4925098ad709ac.1603154867.git.me@pmachata.org>
In-Reply-To: <cover.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.52 / 15.00 / 15.00
X-Rspamd-Queue-Id: 9D6DE17DB
X-Rspamd-UID: 71bb46
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
index 93521a49eaec..87cc6ae0cfba 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1781,6 +1781,7 @@ int parse_mapping(int *argcp, char ***argvp,
 {
 	int argc = *argcp;
 	char **argv = *argvp;
+	int ret = 0;
 
 	while (argc > 0) {
 		char *colon = strchr(*argv, ':');
@@ -1790,15 +1791,19 @@ int parse_mapping(int *argcp, char ***argvp,
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

