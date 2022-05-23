Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4085318E3
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbiEWUFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbiEWUFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:05:31 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F76F13;
        Mon, 23 May 2022 13:05:28 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8621721A26;
        Mon, 23 May 2022 20:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653336327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc;
        bh=ewuco7qpnjFa6pnlO7wOxhm6l4KQ3priZ8aA9J5KoQw=;
        b=mXdA2guetB0n/GK7JrXpr9jH8L3UJoxfN5AQ5q2wLFW+G5KEwNUV1QQ0XaieOWDlEHCXpl
        jpGzc/BwLBrNjOsm+WNrgR84uPdy1Ln+K+4VVHw5Eku8r8AIXXwrOODA4vnSimAPjHkqwS
        Ne3Me8sHbB7qXd9FppAJyK4IUhUmDK8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653336327;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc;
        bh=ewuco7qpnjFa6pnlO7wOxhm6l4KQ3priZ8aA9J5KoQw=;
        b=jx8UP0H0LMalaH9zzsP1IcPrpx0ava6S8R0GaZ/un6LBIRJP+DChvmDnXVv3Qp3beF2hjf
        5OGzD7eEyADJzoAQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6B3892C141;
        Mon, 23 May 2022 20:05:27 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8B7AE60299; Mon, 23 May 2022 22:05:24 +0200 (CEST)
Message-Id: <30ec3274c323de7c3a9b013b9bfb6c3418465d30.1653336079.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ipsec v2] Revert "net: af_key: add check for pfkey_broadcast
 in function pfkey_process"
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Date:   Mon, 23 May 2022 22:05:24 +0200 (CEST)
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

v2: add a comment explaining why is the return value ignored

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/key/af_key.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 339d95df19d3..d93bde657359 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2826,10 +2826,12 @@ static int pfkey_process(struct sock *sk, struct sk_buff *skb, const struct sadb
 	void *ext_hdrs[SADB_EXT_MAX];
 	int err;
 
-	err = pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
-			      BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
-	if (err)
-		return err;
+	/* Non-zero return value of pfkey_broadcast() does not always signal
+	 * an error and even on an actual error we may still want to process
+	 * the message so rather ignore the return value.
+	 */
+	pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
+			BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
 
 	memset(ext_hdrs, 0, sizeof(ext_hdrs));
 	err = parse_exthdrs(skb, hdr, ext_hdrs);
-- 
2.36.1

