Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82FE5409EB
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 20:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348716AbiFGSSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 14:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352253AbiFGSRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 14:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5936FA38;
        Tue,  7 Jun 2022 10:51:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9605616B6;
        Tue,  7 Jun 2022 17:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCE9C341C0;
        Tue,  7 Jun 2022 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624274;
        bh=3TszrS3lAtEjZ2rupo4rzyU9qtS2/kAgbkhSgz7ytFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZEvebjtMkPxMJkb03CD2dOqJT8SJsnzbKiPr4bruTzhySHNkLNws/8kB4PwGq/cZ
         o6pMYfc6iTAy/HB8rFoqcwRY2bCbC/tYfhexlsgmyr3t3/T3aUhTv/edK6X5zEyqej
         T6bm8q2o+b3I9RZ/lWtxF08xjxHrKun3PW5miuQzH+eCNK8zmh8QQiznVoO4Z3Q5Ur
         yE51FNUSRBQYWd4ocjRi8kUVGmre/DgaBoDlBj+enKijiyLcXJDOULKnftQnnC/yWF
         lHlKJUWKmKZSGZP19hU976MCZzBedf6Pffk7XrdhI63NDYX6AEmHm9IQIYL3dAsU4W
         jlrjLybGVxacw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 40/68] Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"
Date:   Tue,  7 Jun 2022 13:48:06 -0400
Message-Id: <20220607174846.477972-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>

[ Upstream commit 9c90c9b3e50e16d03c7f87d63e9db373974781e0 ]

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
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.35.1

