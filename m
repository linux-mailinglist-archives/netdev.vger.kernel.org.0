Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7492C569FC6
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 12:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbiGGK0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 06:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbiGGK0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 06:26:40 -0400
X-Greylist: delayed 434 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Jul 2022 03:26:39 PDT
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A42F2982D
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 03:26:39 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:41240.191444406
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-36.111.140.9 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 2EBCD2800C7;
        Thu,  7 Jul 2022 18:19:18 +0800 (CST)
X-189-SAVE-TO-SEND: +liyonglong@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 90fc782b4f3549a9b98a73d7ae15e3bc for netdev@vger.kernel.org;
        Thu, 07 Jul 2022 18:19:20 CST
X-Transaction-ID: 90fc782b4f3549a9b98a73d7ae15e3bc
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
From:   Yonglong Li <liyonglong@chinatelecom.cn>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, liyonglong@chinatelecom.cn
Subject: [PATCH] tcp: make retransmitted SKB fit into the send window
Date:   Thu,  7 Jul 2022 18:19:15 +0800
Message-Id: <1657189155-38222-1-git-send-email-liyonglong@chinatelecom.cn>
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

From: liyonglong <liyonglong@chinatelecom.cn>

current code of __tcp_retransmit_skb only check TCP_SKB_CB(skb)->seq
in send window, it will cause retransmit more than send window data.

Signed-off-by: liyonglong <liyonglong@chinatelecom.cn>
---
 net/ipv4/tcp_output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 18c913a..3530d1f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3176,7 +3176,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	    TCP_SKB_CB(skb)->seq != tp->snd_una)
 		return -EAGAIN;
 
-	len = cur_mss * segs;
+	len = min_t(int, tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq, cur_mss * segs);
 	if (skb->len > len) {
 		if (tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb, len,
 				 cur_mss, GFP_ATOMIC))
@@ -3190,7 +3190,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 		diff -= tcp_skb_pcount(skb);
 		if (diff)
 			tcp_adjust_pcount(sk, skb, diff);
-		if (skb->len < cur_mss)
+		if (skb->len < cur_mss && len >= cur_mss)
 			tcp_retrans_try_collapse(sk, skb, cur_mss);
 	}
 
-- 
1.8.3.1

