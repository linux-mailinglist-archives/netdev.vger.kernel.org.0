Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20C74DBB75
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 00:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiCQAA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 20:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbiCQAA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 20:00:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44221C109
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 16:59:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67F64B81C82
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B16C340E9;
        Wed, 16 Mar 2022 23:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647475150;
        bh=RpkjUZ/O3itT2ZHl8ejByaXVHr9zH2IWT5jmA0AJh/s=;
        h=From:To:Cc:Subject:Date:From;
        b=aF9EXqDzU6z9GPRMvhhUf+4fS98/T5xRgpNKtvMil+edeFw3sjjgQdTbLhzejbRo5
         9ZAkrbBd5LZj8NlPZfrB64YELWLdAHVdO/RgWU8dHqh1ImVUSedbfBuWYHyu4leNKm
         4xXZ/z8JA/vjeHaIL1bp0QdrVzI7P6Y9oa+iae/eyITaUIi45Pxy/SPEPUa0qB0har
         2MLC50kZJA9lPt6VknAA/O1LqQ67lzG7mbgHllrDjDckpJ3XDyFUqAjoChDOqsmEQV
         CQ2f8rz/JXc19kXAQ6q6ZoSPAHlEjEL6grVKREhTxdx139TP7AvKCv0NVFy57KBjUM
         W0nywfzjDBPxA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, edumazet@google.com
Cc:     ycheng@google.com, weiwan@google.com, netdev@vger.kernel.org,
        ntspring@fb.com
Subject: [RFC net] tcp: ensure PMTU updates are processed during fastopen
Date:   Wed, 16 Mar 2022 16:59:08 -0700
Message-Id: <20220316235908.1246615-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

