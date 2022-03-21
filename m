Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A254E2EA8
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 18:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351545AbiCURBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 13:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351544AbiCURBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 13:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92646D97C
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 09:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44ADA6143A
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D2FC340E8;
        Mon, 21 Mar 2022 16:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647881998;
        bh=R6rIpy355nqLjsDBshcsMBVnnQqtVycDCqLjAE4VaMM=;
        h=From:To:Cc:Subject:Date:From;
        b=Ca0MPj2LfmZqDArE5PA10k+YhboTcfaIBhlvIUzQUgkIsyMfcYC656aaeZ2umd06l
         aXnPev37D9+QxF+Ncgi6XZY5lE6shUWgWWKHOiG4qkkj9X/f13g00zQE4j00X9dGzO
         vSQZWl9nOqEcwi5UEz7bcYwhNzqSzVQI41hXE4+1cA5YZL2xzYB9VXua2GgTKNORdo
         dzVn4w9wPoUKqv3+6/yzNgX8rRa30szSNbzEU/UOYa9gELhYCTUsQtL6Yyacfiqsyk
         wj/V30w0bUhKg2Ht6Uh9sspCKIKgQWd5iciMWHLJxPNtZCyqFzSGM2B3oKKzAnidvG
         6AJh/8MWUDiog==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, edumazet@google.com
Cc:     ycheng@google.com, weiwan@google.com, netdev@vger.kernel.org,
        ntspring@fb.com
Subject: [PATCH net] tcp: ensure PMTU updates are processed during fastopen
Date:   Mon, 21 Mar 2022 09:59:57 -0700
Message-Id: <20220321165957.1769954-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
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

tp->rx_opt.mss_clamp is not populated, yet, during TFO send so we
rise it to the local MSS. tp->mss_cache is not updated, however:

tcp_v6_connect():
  tp->rx_opt.mss_clamp = IPV6_MIN_MTU - headers;
  tcp_connect():
     tcp_connect_init():
       tp->mss_cache = min(mtu, tp->rx_opt.mss_clamp)
     tcp_send_syn_data():
       tp->rx_opt.mss_clamp = tp->advmss

After recent fixes to ICMPv6 PTB handling we started dropping
PMTU updates higher than tp->mss_cache. Because of the stale
tp->mss_cache value PMTU updates during TFO are always dropped.

Thanks to Wei for helping zero in on the problem and the fix!

Fixes: c7bb4b89033b ("ipv6: tcp: drop silly ICMPv6 packet too big messages")
Reported-by: Andre Nash <alnash@fb.com>
Reported-by: Neil Spring <ntspring@fb.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/tcp_output.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5079832af5c1..257780f93305 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3719,6 +3719,7 @@ static void tcp_connect_queue_skb(struct sock *sk, struct sk_buff *skb)
  */
 static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_fastopen_request *fo = tp->fastopen_req;
 	int space, err = 0;
@@ -3733,8 +3734,10 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 	 * private TCP options. The cost is reduced data space in SYN :(
 	 */
 	tp->rx_opt.mss_clamp = tcp_mss_clamp(tp, tp->rx_opt.mss_clamp);
+	/* Sync mss_cache after updating the mss_clamp */
+	tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
 
-	space = __tcp_mtu_to_mss(sk, inet_csk(sk)->icsk_pmtu_cookie) -
+	space = __tcp_mtu_to_mss(sk, icsk->icsk_pmtu_cookie) -
 		MAX_TCP_OPTION_SPACE;
 
 	space = min_t(size_t, space, fo->size);
-- 
2.34.1

