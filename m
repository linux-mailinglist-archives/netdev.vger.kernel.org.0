Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F0458D5AC
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 10:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241079AbiHIIsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 04:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241089AbiHIIr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 04:47:56 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0C8422283
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 01:47:54 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:50480.284727279
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-36.111.140.9 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 2211E2800D1;
        Tue,  9 Aug 2022 16:47:48 +0800 (CST)
X-189-SAVE-TO-SEND: +liyonglong@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id b258151eca38427b8cdfa05979fe4581 for netdev@vger.kernel.org;
        Tue, 09 Aug 2022 16:47:50 CST
X-Transaction-ID: b258151eca38427b8cdfa05979fe4581
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
From:   Yonglong Li <liyonglong@chinatelecom.cn>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, liyonglong@chinatelecom.cn
Subject: [PATCH] tcp: adjust rcvbuff according copied rate of user space
Date:   Tue,  9 Aug 2022 16:47:46 +0800
Message-Id: <1660034866-1844-1-git-send-email-liyonglong@chinatelecom.cn>
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

it is more reasonable to adjust rcvbuff by copied rate instead
of copied buff len.

Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
---
 include/linux/tcp.h  |  1 +
 net/ipv4/tcp_input.c | 16 +++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index a9fbe22..18e091c 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -410,6 +410,7 @@ struct tcp_sock {
 		u32	space;
 		u32	seq;
 		u64	time;
+		u32	prior_rate;
 	} rcvq_space;
 
 /* TCP-specific MTU probe information. */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ab5f0ea..2bdf2a5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -544,6 +544,7 @@ static void tcp_init_buffer_space(struct sock *sk)
 	tcp_mstamp_refresh(tp);
 	tp->rcvq_space.time = tp->tcp_mstamp;
 	tp->rcvq_space.seq = tp->copied_seq;
+	tp->rcvq_space.prior_rate = 0;
 
 	maxwin = tcp_full_space(sk);
 
@@ -701,6 +702,7 @@ static inline void tcp_rcv_rtt_measure_ts(struct sock *sk,
 void tcp_rcv_space_adjust(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
+	u64 pre_copied_rate, copied_rate;
 	u32 copied;
 	int time;
 
@@ -713,7 +715,14 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
 	/* Number of bytes copied to user in last RTT */
 	copied = tp->copied_seq - tp->rcvq_space.seq;
-	if (copied <= tp->rcvq_space.space)
+	copied_rate = copied * USEC_PER_SEC;
+	do_div(copied_rate, time);
+	pre_copied_rate = tp->rcvq_space.prior_rate;
+	if (!tp->rcvq_space.prior_rate) {
+		pre_copied_rate = tp->rcvq_space.space * USEC_PER_SEC;
+		do_div(pre_copied_rate, time);
+	}
+	if (copied_rate <= pre_copied_rate || !pre_copied_rate)
 		goto new_measure;
 
 	/* A bit of theory :
@@ -736,8 +745,8 @@ void tcp_rcv_space_adjust(struct sock *sk)
 		rcvwin = ((u64)copied << 1) + 16 * tp->advmss;
 
 		/* Accommodate for sender rate increase (eg. slow start) */
-		grow = rcvwin * (copied - tp->rcvq_space.space);
-		do_div(grow, tp->rcvq_space.space);
+		grow = rcvwin * (copied_rate - pre_copied_rate);
+		do_div(grow, pre_copied_rate);
 		rcvwin += (grow << 1);
 
 		rcvmem = SKB_TRUESIZE(tp->advmss + MAX_TCP_HEADER);
@@ -755,6 +764,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
 		}
 	}
 	tp->rcvq_space.space = copied;
+	tp->rcvq_space.prior_rate = pre_copied_rate;
 
 new_measure:
 	tp->rcvq_space.seq = tp->copied_seq;
-- 
1.8.3.1

