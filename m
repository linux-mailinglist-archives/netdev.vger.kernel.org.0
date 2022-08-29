Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91B55A44E3
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiH2IVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiH2IVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:21:13 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25F843F32F
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 01:21:12 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:34160.1173022860
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-36.111.140.9 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id 2196A28008B;
        Mon, 29 Aug 2022 16:21:06 +0800 (CST)
X-189-SAVE-TO-SEND: +liyonglong@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 0b607f04c69241cd8899fda32561c1a3 for netdev@vger.kernel.org;
        Mon, 29 Aug 2022 16:21:10 CST
X-Transaction-ID: 0b607f04c69241cd8899fda32561c1a3
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
From:   Yonglong Li <liyonglong@chinatelecom.cn>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ycheng@google.com,
        liyonglong@chinatelecom.cn
Subject: [PATCH] tcp: del skb from tsorted_sent_queue after mark it as lost
Date:   Mon, 29 Aug 2022 16:20:42 +0800
Message-Id: <1661761242-7849-1-git-send-email-liyonglong@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if rack is enabled, when skb marked as lost we can remove it from
tsorted_sent_queue. It will reduces the iterations on tsorted_sent_queue
in tcp_rack_detect_loss

Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
---
 net/ipv4/tcp_input.c    | 15 +++++++++------
 net/ipv4/tcp_recovery.c |  1 -
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ab5f0ea..01bd644 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1082,6 +1082,12 @@ static void tcp_notify_skb_loss_event(struct tcp_sock *tp, const struct sk_buff
 	tp->lost += tcp_skb_pcount(skb);
 }
 
+static bool tcp_is_rack(const struct sock *sk)
+{
+	return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+		TCP_RACK_LOSS_DETECTION;
+}
+
 void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
 {
 	__u8 sacked = TCP_SKB_CB(skb)->sacked;
@@ -1105,6 +1111,9 @@ void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
 		TCP_SKB_CB(skb)->sacked |= TCPCB_LOST;
 		tcp_notify_skb_loss_event(tp, skb);
 	}
+
+	if (tcp_is_rack(sk))
+		list_del_init(&skb->tcp_tsorted_anchor);
 }
 
 /* Updates the delivered and delivered_ce counts */
@@ -2093,12 +2102,6 @@ static inline void tcp_init_undo(struct tcp_sock *tp)
 	tp->undo_retrans = tp->retrans_out ? : -1;
 }
 
-static bool tcp_is_rack(const struct sock *sk)
-{
-	return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
-		TCP_RACK_LOSS_DETECTION;
-}
-
 /* If we detect SACK reneging, forget all SACK information
  * and reset tags completely, otherwise preserve SACKs. If receiver
  * dropped its ofo queue, we will know this due to reneging detection.
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index 50abaa9..ba52ec9e 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -84,7 +84,6 @@ static void tcp_rack_detect_loss(struct sock *sk, u32 *reo_timeout)
 		remaining = tcp_rack_skb_timeout(tp, skb, reo_wnd);
 		if (remaining <= 0) {
 			tcp_mark_skb_lost(sk, skb);
-			list_del_init(&skb->tcp_tsorted_anchor);
 		} else {
 			/* Record maximum wait time */
 			*reo_timeout = max_t(u32, *reo_timeout, remaining);
-- 
1.8.3.1

