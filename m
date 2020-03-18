Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0357189828
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgCRJoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:44:07 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:51668 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727621AbgCRJn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:43:59 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9hpXk012899;
        Wed, 18 Mar 2020 11:43:51 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id 17298360F46; Wed, 18 Mar 2020 11:43:51 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 21/28] tcp: AccECN option beacon
Date:   Wed, 18 Mar 2020 11:43:25 +0200
Message-Id: <1584524612-24470-22-git-send-email-ilpo.jarvinen@helsinki.fi>
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

AccECN requires option to be sent a few times per RTT even
if nothing in the ECN state requires it.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 include/linux/tcp.h   |  1 +
 include/net/tcp.h     |  1 +
 net/ipv4/tcp.c        |  1 +
 net/ipv4/tcp_output.c | 16 +++++++++++-----
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index b3cf33af3eb0..c381aea5c764 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -330,6 +330,7 @@ struct tcp_sock {
 		prev_ecnfield:2,/* ECN bits from the previous segment */
 		accecn_opt_demand:2,/* Demand AccECN option for n next ACKs */
 		estimate_ecnfield:2;/* ECN field for AccECN delivered estimates */
+	u64	accecn_opt_tstamp;	/* Last AccECN option sent timestamp */
 	u32	lost;		/* Total data packets lost incl. rexmits */
 	u32	app_limited;	/* limited until "delivered" reaches this val */
 	u64	first_tx_mstamp;  /* start of window send phase */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4367e21b4521..52567d8fca33 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -224,6 +224,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 #define TCP_ACCECN_MAXSIZE		(TCPOLEN_EXP_ACCECN_BASE + \
 					 TCPOLEN_ACCECN_PERCOUNTER * \
 					 TCP_ACCECN_NUMCOUNTERS)
+#define TCP_ACCECN_BEACON_FREQ_SHIFT	2 /* Send option at least 2^2 times per RTT */
 
 /* Flags in tp->nonagle */
 #define TCP_NAGLE_OFF		1	/* Nagle's algo is disabled */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a966cfc0214e..cfbdc1468342 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2627,6 +2627,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->ecn_fail = 0;
 	tcp_accecn_init_counters(tp);
 	tp->prev_ecnfield = 0;
+	tp->accecn_opt_tstamp = 0;
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;
 	tcp_clear_retrans(tp);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 118d5c73bcb9..f070128b69e6 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -588,6 +588,7 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 		}
 		if (tp != NULL) {
 			tp->accecn_minlen = 0;
+			tp->accecn_opt_tstamp = tp->tcp_mstamp;
 			if (tp->accecn_opt_demand)
 				tp->accecn_opt_demand--;
 		}
@@ -988,12 +989,17 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 		}
 	}
 
-	if (tcp_ecn_mode_accecn(tp) && tp->accecn_opt_demand &&
+	if (tcp_ecn_mode_accecn(tp) &&
 	    !(sock_net(sk)->ipv4.sysctl_tcp_ecn & TCP_ACCECN_NO_OPT)) {
-		opts->ecn_bytes = tp->received_ecn_bytes;
-		size += tcp_options_fit_accecn(opts, tp->accecn_minlen,
-					       MAX_TCP_OPTION_SPACE - size,
-					       opts->num_sack_blocks > 0 ? 2 : 0);
+		if (tp->accecn_opt_demand ||
+		    (tcp_stamp_us_delta(tp->tcp_mstamp, tp->accecn_opt_tstamp) >=
+		     (tp->srtt_us >> (3 + TCP_ACCECN_BEACON_FREQ_SHIFT)))) {
+			opts->ecn_bytes = tp->received_ecn_bytes;
+			size += tcp_options_fit_accecn(opts, tp->accecn_minlen,
+						       MAX_TCP_OPTION_SPACE - size,
+						       opts->num_sack_blocks > 0 ?
+						       2 : 0);
+		}
 	}
 
 	return size;
-- 
2.20.1

