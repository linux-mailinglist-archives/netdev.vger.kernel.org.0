Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9A7531333
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238525AbiEWQBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238513AbiEWQBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:01:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACD8193F7;
        Mon, 23 May 2022 09:01:26 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1B7B421B83;
        Mon, 23 May 2022 16:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653321685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc;
        bh=fi+V34PTkWcZoMwWtG2mVa3bYbZ61n1jXy1FWg8+OfA=;
        b=qkTWvOigKviuXOzACz+miEgbMCqrJEgK2Rkvn1kyMAuRDybQMaofRPWHhBB6LIse1Aq7V8
        Nzm2QpBxCkK27n1rPgdL5j6RPt3hEhu3g7/E9fmfsaC2UbDOxBiKmvxe5yJ2DoHdqLsNo0
        hPuKBmEbMU340r2kwtNWfggcyGkArs4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653321685;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc;
        bh=fi+V34PTkWcZoMwWtG2mVa3bYbZ61n1jXy1FWg8+OfA=;
        b=BGbNCSotJVuECgCwOhKCmpNAuEZ0QJMVaI8dsNrVkK+Yw+LHkypAJEEUtoPBs6fOis/Nl/
        r00N60Xj1bJJdeBw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0663A2C141;
        Mon, 23 May 2022 16:01:24 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A413860294; Mon, 23 May 2022 18:01:24 +0200 (CEST)
Message-Id: <fbb31dc72fb38a69a2aca6c25f1be71d6a8bcc96.1653321424.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ipsec] Revert "net: af_key: add check for pfkey_broadcast in
 function pfkey_process"
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Date:   Mon, 23 May 2022 18:01:24 +0200 (CEST)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 4dc2a5a8f6754492180741facf2a8787f2c415d7.

A non-zero return value from pfkey_broadcast() does not necessarily mean
an error occurred as this function returns -ESRCH when no registered
listener received the message. In particular, a call with
BROADCAST_PROMISC_ONLY flag and null one_sk argument can never return
zero so that this commit in fact prevents processing any PF_KEY message.
One visible effect is that racoon daemon fails to find encryption
algorithms like aes and refuses to start.

Excluding -ESRCH return value would fix this but it's not obvious that
we really want to bail out here and most other callers of
pfkey_broadcast() also ignore the return value. Also, as pointed out by
Steffen Klassert, PF_KEY is kind of deprecated and newer userspace code
should use netlink instead so that we should only disturb the code for
really important fixes.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/key/af_key.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 339d95df19d3..fbb2c16693ad 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2826,10 +2826,8 @@ static int pfkey_process(struct sock *sk, struct sk_buff *skb, const struct sadb
 	void *ext_hdrs[SADB_EXT_MAX];
 	int err;
 
-	err = pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
-			      BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
-	if (err)
-		return err;
+	pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
+			BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
 
 	memset(ext_hdrs, 0, sizeof(ext_hdrs));
 	err = parse_exthdrs(skb, hdr, ext_hdrs);
-- 
2.36.1

