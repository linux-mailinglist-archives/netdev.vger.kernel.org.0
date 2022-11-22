Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956F5633882
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbiKVJbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiKVJbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:31:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0AF2FC2B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:31:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDAC8615CC
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257D8C433C1;
        Tue, 22 Nov 2022 09:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669109504;
        bh=tOywrxnKaX8HTdN1GoTyfQIBzAMYcTtznfVackzPprk=;
        h=From:To:Cc:Subject:Date:From;
        b=itN6qU1eI7SKrxLFMsObTCOSmrSz05oqpnZmgQHFl4zntZlSk4z27GMawTziS+rFk
         dTlFKTxwzze4vwCPtdfRS3XuSOqWJRITEEsDnwgXIdp8IoqPRvUgZaDDuvUEt2u9FV
         R6cfJj40z1TForcfkfYfsNtyOJchNNlmM5yRMWOjxeluAEre1EIQezfOKwzObUplLp
         mu0e66hIRrEwUrSeOLhBTTxQ+i5f2pxNNKfliHjO9Cz90zCeH7vqiSBGKvzEmRju+0
         yxq2j9QyuUxbRzeOWYh3lAfur3eKNvDlLjlL02UzP86fOqFRWNj1PHZUkN+G1tHl57
         TRWk4P/WCW91A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>
Subject: [PATCH net-next] tcp: Fix build break when CONFIG_IPV6=n
Date:   Tue, 22 Nov 2022 01:31:31 -0800
Message-Id: <20221122093131.161499-1-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

The cited commit caused the following build break when CONFIG_IPV6 was
disabled

net/ipv4/tcp_input.c: In function ‘tcp_syn_flood_action’:
include/net/sock.h:387:37: error: ‘const struct sock_common’ has no member named ‘skc_v6_rcv_saddr’; did you mean ‘skc_rcv_saddr’?

Fix by using inet6_rcv_saddr() macro which handles this situation
nicely.

Fixes: d9282e48c608 ("tcp: Add listening address to SYN flood message")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
CC: Matthieu Baerts <matthieu.baerts@tessares.net>
CC: Jamie Bainbridge <jamie.bainbridge@gmail.com>
---
 net/ipv4/tcp_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0ae291e53eab..f8548a57a17a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6843,9 +6843,9 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 
 	if (!READ_ONCE(queue->synflood_warned) && syncookies != 2 &&
 	    xchg(&queue->synflood_warned, 1) == 0) {
-		if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
+		if (sk->sk_family == AF_INET6) {
 			net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c]:%u. %s.\n",
-					proto, &sk->sk_v6_rcv_saddr,
+					proto, inet6_rcv_saddr(sk),
 					sk->sk_num, msg);
 		} else {
 			net_info_ratelimited("%s: Possible SYN flooding on port %pI4:%u. %s.\n",
-- 
2.38.1

