Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578C549AC75
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 07:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345046AbiAYGid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 01:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S250008AbiAYENm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 23:13:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341B8C038AEB
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 18:45:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43E62B8160E
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 02:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73364C340E4;
        Tue, 25 Jan 2022 02:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643078715;
        bh=H8ypNzemf6M24UnLiB3XifisMaHbaxNEj4wM+Or5/ew=;
        h=From:To:Cc:Subject:Date:From;
        b=AowtDQLQSAIoJofcFgVSrHW3Gc1o8cOAkf7jh4OrKWoVGoxPIfpV3bDa6K+qfRg9M
         7ar0jnlQTGPAp8feQ43tP+i1ld+UR5Y8m+DTIp+YAUxbyq13mqhZOb1ju/qhI+WtEY
         K/epMQLyNoZJk96ePmcAgZtfdXCF31LziBhEH6xsg0d7C51UsRVUMjbdDqfS67leO1
         yrttnwCmMP3StF/uSRWWwwA8ek84a10yHB1EgUKL5DQdQNiLsYZstcrZ1X3Qy9y2im
         AKAyblhWmgBKMgCd6zKjjxka5tld/n5hhHuPgwOpXvKikodwI7Bxmxkls4XjK9kONW
         jK/R4orzmN5oQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next] net: Adjust sk_gso_max_size once when set
Date:   Mon, 24 Jan 2022 19:45:11 -0700
Message-Id: <20220125024511.27480-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_gso_max_size is set based on the dst dev. Both users of it
adjust the value by the same offset - (MAX_TCP_HEADER + 1). Rather
than compute the same adjusted value on each call do the adjustment
once when set.

Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c       | 1 +
 net/ipv4/tcp.c        | 3 +--
 net/ipv4/tcp_output.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index e21485ab285d..114a6e220ba9 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2261,6 +2261,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
 			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
+			sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
 			max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);
 		}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3b75836db19b..1afa3f2f9a6d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -893,8 +893,7 @@ static unsigned int tcp_xmit_size_goal(struct sock *sk, u32 mss_now,
 		return mss_now;
 
 	/* Note : tcp_tso_autosize() will eventually split this later */
-	new_size_goal = sk->sk_gso_max_size - 1 - MAX_TCP_HEADER;
-	new_size_goal = tcp_bound_to_half_wnd(tp, new_size_goal);
+	new_size_goal = tcp_bound_to_half_wnd(tp, sk->sk_gso_max_size);
 
 	/* We try hard to avoid divides here */
 	size_goal = tp->gso_segs * mss_now;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5079832af5c1..11c06b9db801 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1960,7 +1960,7 @@ static u32 tcp_tso_autosize(const struct sock *sk, unsigned int mss_now,
 
 	bytes = min_t(unsigned long,
 		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift),
-		      sk->sk_gso_max_size - 1 - MAX_TCP_HEADER);
+		      sk->sk_gso_max_size);
 
 	/* Goal is to send at least one packet per ms,
 	 * not one big TSO packet every 100 ms.
-- 
2.25.1

