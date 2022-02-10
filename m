Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147574B0306
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiBJCGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiBJCGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:06:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBD33101B;
        Wed,  9 Feb 2022 18:01:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32279B80E19;
        Thu, 10 Feb 2022 00:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C485C340ED;
        Thu, 10 Feb 2022 00:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644453415;
        bh=k5nOaZvkcoJ1nvw3IodVvNYhe4/Eh+Uo1hrPiXsvZ2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGXJmWd/iKgcDtZu38dqnGlbnszo17yDUi/THH6biq1ZhKmMyEyEPEganLzNHAKlt
         Y7AZsk1WzwI0g7vpQ3FXC32XWwrvhe5Hg6sG8q0keT4vrG6MZyJrD3pHwNqF6DG8Qj
         9CAnxR4QsbXErLYvO9MeyrFbT9qPsK548IB6jfYGnxdvztlKP72c6l+axmDaNAmtGn
         iibJqz2nFzAgyBbQTT+Y2/5aq5t4Vmp8AGaYG0tIogKjxfr652rv/wBt05HDBrq/CK
         h0KtqopUzYu9A5ZqqgyfUR1JnHVMdDFk8zwM5rJk+3CwmEQn4iXQ2aC6ZcZjqFpsdf
         T+Kn7lTXu8C5Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/11] net: ping6: support packet timestamping
Date:   Wed,  9 Feb 2022 16:36:40 -0800
Message-Id: <20220210003649.3120861-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210003649.3120861-1-kuba@kernel.org>
References: <20220210003649.3120861-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nothing prevents the user from requesting timestamping
on ping6 sockets, yet timestamps are not going to be reported.
Plumb the flags through.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv6/ping.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 86a72f7a61cf..3228ccd8abf1 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -113,6 +113,7 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	ipcm6_init_sk(&ipc6, np);
 	ipc6.sockc.mark = sk->sk_mark;
+	ipc6.sockc.tsflags = sk->sk_tsflags;
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
 	dst = ip6_sk_dst_lookup_flow(sk, &fl6, daddr, false);
-- 
2.34.1

