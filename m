Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04397537BEE
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbiE3N2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236889AbiE3N1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:27:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BEC880DF;
        Mon, 30 May 2022 06:25:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B68360DD4;
        Mon, 30 May 2022 13:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B788CC36AE5;
        Mon, 30 May 2022 13:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917142;
        bh=G8Lr5tC7exO+P44JmMYxw/QCR5EsrdoyP32XeHj5qcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azgwy2XgnueZBDFbq2VNvwtEDz/Hldp3DkSO7lrN2osFCE7iToarxTJaHCfJcm8Se
         dXzfj7v4W3gSiC4UaYcvzsvudhX3Bo7RHO0vWQytCNI+IDJMlFUZ5nwHJNPBDGrvSU
         ujoouTcMhBMrcYc7QpSXyR4pDkAb5/DPIsrJkh651pSe3xJx+epiO70iS952ipsBMo
         x853pTcWl5HRMwSGcQlxzycUOlPxIzc3XwbkadoJiLt253RGORW43sqmoXSH57WKun
         3/bddcIZk4T2A1vFH7JGwMYEzaio0RrLI+zmcz4kQ1SROkVnXQZOTJc6sYGkdRIrur
         TDPAzo4m4Ncag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 033/159] tcp: consume incoming skb leading to a reset
Date:   Mon, 30 May 2022 09:22:18 -0400
Message-Id: <20220530132425.1929512-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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
index 60f99e9fb6d1..1f3ce7aea716 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5711,7 +5711,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 						  &tp->last_oow_ack_time))
 				tcp_send_dupack(sk, skb);
 		} else if (tcp_reset_check(sk, skb)) {
-			tcp_reset(sk, skb);
+			goto reset;
 		}
 		goto discard;
 	}
@@ -5747,17 +5747,16 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
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
 
@@ -5782,6 +5781,11 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
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

