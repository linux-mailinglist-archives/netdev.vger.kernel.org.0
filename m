Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FCB611F3E
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 04:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiJ2CEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 22:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJ2CEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 22:04:37 -0400
X-Greylist: delayed 1062 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 28 Oct 2022 19:04:34 PDT
Received: from mx.treblig.org (mx.treblig.org [46.43.15.161])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CC2D74
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 19:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
        ; s=bytemarkmx; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kXrSw5CRFHg3ideg5TbwtiGG5a7qvoQu+xbgIOl14Io=; b=V6QYyT9NL2DX56U/ep+qVZTb+y
        RDGqbssC2tMRc54A23xrI6W0vwgSLo/8n8thjLVk6lYcSDbVJVR+w1C/s03mv7+z7365ggfn7zuUL
        cd3Wf/qnOjpYr6o+tqFbUi/hOzdJKfK+8D21q6CWCcNmrlS4wGAM64IiGVSCpMT3/2KH7ALNmsUEj
        OW2SqeYrUVEQg3Sw6w5zIAeMW7YVxs3zbowb6eDe7BzpypNRVqQKgTrV4VxfucdPNbk0SM0vydhDd
        gL9OmCHFHdiW7RmtFQzs8/huo8Q5i4vOmfihijHA4YQZANC5BcikXAWzix2rbaRcL6WmSI6gtGYn8
        ayllSOTg==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
        by mx.treblig.org with esmtp (Exim 4.94.2)
        (envelope-from <linux@treblig.org>)
        id 1ooavl-00ArpV-As; Sat, 29 Oct 2022 02:46:36 +0100
From:   linux@treblig.org
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, linux@treblig.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: core:  inet[46]_pton strlen len types
Date:   Sat, 29 Oct 2022 02:46:04 +0100
Message-Id: <20221029014604.114024-1-linux@treblig.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Dr. David Alan Gilbert" <linux@treblig.org>

inet[46]_pton check the input length against
a sane length limit (INET[6]_ADDRSTRLEN), but
the strlen value gets truncated due to being stored in an int,
so there's a theoretical potential for a >4G string to pass
the limit test.
Use size_t since that's what strlen actually returns.

I've had a hunt for callers that could hit this, but
I've not managed to find anything that doesn't get checked with
some other limit first; but it's possible that I've missed
something in the depth of the storage target paths.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 net/core/utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/utils.c b/net/core/utils.c
index 938495bc1d348..c994e95172acf 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -302,7 +302,7 @@ static int inet4_pton(const char *src, u16 port_num,
 		struct sockaddr_storage *addr)
 {
 	struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
-	int srclen = strlen(src);
+	size_t srclen = strlen(src);
 
 	if (srclen > INET_ADDRSTRLEN)
 		return -EINVAL;
@@ -322,7 +322,7 @@ static int inet6_pton(struct net *net, const char *src, u16 port_num,
 {
 	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
 	const char *scope_delim;
-	int srclen = strlen(src);
+	size_t srclen = strlen(src);
 
 	if (srclen > INET6_ADDRSTRLEN)
 		return -EINVAL;
-- 
2.37.3

