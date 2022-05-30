Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B595380BB
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbiE3Nrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238343AbiE3NpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:45:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4BC8FD5F;
        Mon, 30 May 2022 06:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF3F060F22;
        Mon, 30 May 2022 13:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E880C3411E;
        Mon, 30 May 2022 13:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917568;
        bh=Y5TfIR57pQIvdobT2yvCU/JqS/K7zygsgLVkFeCYq5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuL7CXILodRAPhOzCLcNKxkqlpp7HtqzXYv7Mwo0jIiJ1jyFkN6xrJSdFPkVm+GZd
         F7ac8JXbpdKAgwHoZy7evp6TdH+DRYp5nGgPlwPgD2DXwFECyv8m0M8TwC9LXrYkVD
         Gc2/Y31mBkceFZ3aPcwEVLBJLSQbNheoXfGIt8yzX+57xY3skosfsyZXp+zGix489W
         Tioa181hZnc1oO0qsDZtl/LEWIwisyTshk6o8Z+mpIsLSwyzk/59QX0WexV0OQFSHH
         zyOjoQCZrWWroBiloR1tE4xbSNDz1s6bKfgSlZDtYLy7Qu6ZgYISMSyfq82zbw8jWo
         DwfqpwOWGvrCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 029/135] tcp: consume incoming skb leading to a reset
Date:   Mon, 30 May 2022 09:29:47 -0400
Message-Id: <20220530133133.1931716-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d9d024f96609016628d750ebc8ee4a6f0d80e6e1 ]

Whenever tcp_validate_incoming() handles a valid RST packet,
we should not pretend the packet was dropped.

Create a special section at the end of tcp_validate_incoming()
to handle this case.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7bf84ce34d9e..96c25c97ee56 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5694,7 +5694,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 						  &tp->last_oow_ack_time))
 				tcp_send_dupack(sk, skb);
 		} else if (tcp_reset_check(sk, skb)) {
-			tcp_reset(sk, skb);
+			goto reset;
 		}
 		goto discard;
 	}
@@ -5730,17 +5730,16 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		}
 
 		if (rst_seq_match)
-			tcp_reset(sk, skb);
-		else {
-			/* Disable TFO if RST is out-of-order
-			 * and no data has been received
-			 * for current active TFO socket
-			 */
-			if (tp->syn_fastopen && !tp->data_segs_in &&
-			    sk->sk_state == TCP_ESTABLISHED)
-				tcp_fastopen_active_disable(sk);
-			tcp_send_challenge_ack(sk);
-		}
+			goto reset;
+
+		/* Disable TFO if RST is out-of-order
+		 * and no data has been received
+		 * for current active TFO socket
+		 */
+		if (tp->syn_fastopen && !tp->data_segs_in &&
+		    sk->sk_state == TCP_ESTABLISHED)
+			tcp_fastopen_active_disable(sk);
+		tcp_send_challenge_ack(sk);
 		goto discard;
 	}
 
@@ -5765,6 +5764,11 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 discard:
 	tcp_drop(sk, skb);
 	return false;
+
+reset:
+	tcp_reset(sk, skb);
+	__kfree_skb(skb);
+	return false;
 }
 
 /*
-- 
2.35.1

