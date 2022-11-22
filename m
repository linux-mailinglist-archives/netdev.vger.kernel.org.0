Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B644E6343C7
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbiKVSmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiKVSmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:42:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D9285A2C
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:42:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF381CE1EF5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 18:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BB2C433C1;
        Tue, 22 Nov 2022 18:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669142523;
        bh=dsT8v2Mr5+KDd0ZUjWADq4jzm8qtjwHHiOJppmpOiVM=;
        h=From:To:Cc:Subject:Date:From;
        b=BkPtGDHcVXyFwGN4r4DHLeTJigCOPxszU0Q3EHt9zEhIQRw/mguVLAXDTwRI1Mn4i
         5dDtnzG5r8KzTxgo8MFGkYAf8dejazZUPWUqI5cbCws4LkAgdBqb62R9A6PjA6eTtv
         tNcTu2rXrkt2L21omGGf6JUOw+Mi5Jaz7pcIB54gIBntC8v3HV3SMNIYRvGek2pfS+
         fX7H0Z+mEX1/LrV+XFBXfji46tRzdT751NZkzwoUoDYP+FNONbWrN9/IlarfDx5sjr
         gYOprbqU3KvSnHF/pxRSd9sohCsUjAAT6upkCqjpAV7qRHkxdKtI1KVwr1hLltIPhs
         mWUHYPSWnlWGA==
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
Subject: [PATCH net-next V2] tcp: Fix build break when CONFIG_IPV6=n
Date:   Tue, 22 Nov 2022 10:41:58 -0800
Message-Id: <20221122184158.170798-1-saeed@kernel.org>
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

v1->v2:
     - Keep IS_ENABLED(CONFIG_IPV6) in the if condition

 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0ae291e53eab..1efacbe948da 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6845,7 +6845,7 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 	    xchg(&queue->synflood_warned, 1) == 0) {
 		if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
 			net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c]:%u. %s.\n",
-					proto, &sk->sk_v6_rcv_saddr,
+					proto, inet6_rcv_saddr(sk),
 					sk->sk_num, msg);
 		} else {
 			net_info_ratelimited("%s: Possible SYN flooding on port %pI4:%u. %s.\n",
-- 
2.38.1

