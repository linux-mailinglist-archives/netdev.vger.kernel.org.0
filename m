Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BA6189822
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgCRJn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:43:56 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:51566 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727574AbgCRJnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:43:55 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9hplH012907;
        Wed, 18 Mar 2020 11:43:51 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id 1F908360030; Wed, 18 Mar 2020 11:43:51 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 23/28] tcp: AccECN option ceb/cep heuristic
Date:   Wed, 18 Mar 2020 11:43:27 +0200
Message-Id: <1584524612-24470-24-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>

The heuristic algorithm from draft-09 Appendix A.2.2.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 include/net/tcp.h    |  1 +
 net/ipv4/tcp_input.c | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index a29109fa2ce2..54a640fed673 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -225,6 +225,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 					 TCPOLEN_ACCECN_PERCOUNTER * \
 					 TCP_ACCECN_NUMCOUNTERS)
 #define TCP_ACCECN_BEACON_FREQ_SHIFT	2 /* Send option at least 2^2 times per RTT */
+#define TCP_ACCECN_SAFETY_SHIFT	1	/* SAFETY_FACTOR in accecn draft */
 
 /* tp->saw_accecn_opt states, empty seen & orderbit are overloaded */
 #define TCP_ACCECN_OPT_EMPTY_SEEN	0x1
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 826dfd5bf114..6bc9995202c8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -518,14 +518,16 @@ static bool tcp_accecn_process_option(struct tcp_sock *tp,
 static u32 tcp_accecn_process(struct tcp_sock *tp, const struct sk_buff *skb,
 			      u32 delivered_pkts, u32 delivered_bytes, int flag)
 {
-	u32 delta, safe_delta;
+	u32 delta, safe_delta, d_ceb;
 	u32 corrected_ace;
+	u32 old_ceb = tp->delivered_ecn_bytes[INET_ECN_CE - 1];
+	bool opt_deltas_valid;
 
 	/* Reordered ACK? (...or uncertain due to lack of data to send and ts) */
 	if (!(flag & (FLAG_FORWARD_PROGRESS|FLAG_TS_PROGRESS)))
 		return 0;
 
-	tcp_accecn_process_option(tp, skb, delivered_bytes);
+	opt_deltas_valid = tcp_accecn_process_option(tp, skb, delivered_bytes);
 
 	if (!(flag & FLAG_SLOWPATH)) {
 		/* AccECN counter might overflow on large ACKs */
@@ -545,6 +547,16 @@ static u32 tcp_accecn_process(struct tcp_sock *tp, const struct sk_buff *skb,
 	safe_delta = delivered_pkts -
 		     ((delivered_pkts - delta) & TCP_ACCECN_CEP_ACE_MASK);
 
+	if (opt_deltas_valid) {
+		d_ceb = tp->delivered_ecn_bytes[INET_ECN_CE - 1] - old_ceb;
+		if (!d_ceb)
+			return delta;
+		if (d_ceb > delta * tp->mss_cache)
+			return safe_delta;
+		if (d_ceb < safe_delta * tp->mss_cache >> TCP_ACCECN_SAFETY_SHIFT)
+			return delta;
+	}
+
 	return safe_delta;
 }
 
-- 
2.20.1

