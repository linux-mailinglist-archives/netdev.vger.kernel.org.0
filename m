Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB3C540DE3
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 20:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354650AbiFGSvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 14:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354571AbiFGSrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 14:47:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB85CBC6C7;
        Tue,  7 Jun 2022 11:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61365B82343;
        Tue,  7 Jun 2022 18:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D5FC385A5;
        Tue,  7 Jun 2022 18:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624936;
        bh=MoPOMp3HkRc27P0VlZQzSm3a57AYXjopJQxk/auGAOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYpHnhh4F8JkhSoyVrotvOM2B8nQybl3JJpgiNcOx+Vm7G6fdcdLIel0um9MTB9hR
         9FrmAeD7HcrovXet9PqGGL9+0U6KAHef6IGRhDrz5pDSdek41meiJVZpnUSjv7qpHC
         2pYO4adNZpfYeO8Sr/duIAy18FLWd1XGe1rgvpgcITB+3PL0HubC2WZhZttyImMZ89
         tjF3RIa8ujr05H58uzsSt4+HPQkeTagk1BoeoSSoClPUFF/ghrmGbbYdsK6tYHBGUX
         xKo+5YmVl0dgamusK9rm4ZCQMRu4h4O1Vv3kVbPn5m6ahVZ7G0LnlhVaKCnrvc4GvT
         tpr/i+k3RRASw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/27] Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"
Date:   Tue,  7 Jun 2022 14:01:24 -0400
Message-Id: <20220607180133.481701-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180133.481701-1-sashal@kernel.org>
References: <20220607180133.481701-1-sashal@kernel.org>
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
index 1bbb6ec89ff3..af67e0d265c0 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2836,10 +2836,12 @@ static int pfkey_process(struct sock *sk, struct sk_buff *skb, const struct sadb
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

