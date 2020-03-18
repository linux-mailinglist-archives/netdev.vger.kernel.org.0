Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 157D3189835
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbgCRJo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:44:26 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:51676 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727631AbgCRJoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:44:00 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9hoes012845;
        Wed, 18 Mar 2020 11:43:51 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id 2CCA6360F46; Wed, 18 Mar 2020 11:43:51 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 26/28] tcp: to prevent runaway AccECN cep/ACE deficit, limit GSO size
Date:   Wed, 18 Mar 2020 11:43:30 +0200
Message-Id: <1584524612-24470-27-git-send-email-ilpo.jarvinen@helsinki.fi>
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

It could occur that GSO sends segments in so large blocks
that ACE deficit keeps growing because ACE field can only
update in each super skb.

Put some limit into sending large super skbs in case the ACE
deficit is there and could go on indefinitely. Once the bool
becomes false, it's no longer necessary to recheck it during
further sending.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 net/ipv4/tcp_output.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0aec2c57a9cc..4de6510532f2 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2124,6 +2124,23 @@ static bool tcp_snd_wnd_test(const struct tcp_sock *tp,
 	return !after(end_seq, tcp_wnd_end(tp));
 }
 
+/* Runaway ACE deficit possible? */
+static bool tcp_accecn_deficit_runaway_test(const struct tcp_sock *tp,
+					    int cwnd_quota)
+{
+	return (tcp_accecn_ace_deficit(tp) >= 2 * TCP_ACCECN_ACE_MAX_DELTA) &&
+	       (cwnd_quota > TCP_ACCECN_ACE_MAX_DELTA - 1);
+}
+
+static u32 tcp_accecn_gso_limit(struct tcp_sock *tp,
+				const struct sk_buff *skb, int cwnd_quota)
+{
+	if (unlikely(tcp_accecn_deficit_runaway_test(tp, cwnd_quota)))
+		return TCP_ACCECN_ACE_MAX_DELTA - 1;
+
+	return 0;
+}
+
 /* Trim TSO SKB to LEN bytes, put the remaining data into a new packet
  * which is put after SKB on the list.  It is very much like
  * tcp_fragment() except that it may make several kinds of assumptions
@@ -2623,6 +2640,8 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 	int cwnd_quota;
 	int result;
 	bool is_cwnd_limited = false, is_rwnd_limited = false;
+	/* AccECN limit will be lifted below if not needed */
+	bool accecn_gso_limit = tcp_ecn_mode_accecn(tp);
 	u32 max_segs;
 
 	sent_pkts = 0;
@@ -2676,7 +2695,16 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 						      nonagle : TCP_NAGLE_PUSH))))
 				break;
 		} else {
-			if (!push_one &&
+			if (accecn_gso_limit) {
+				u32 limit = tcp_accecn_gso_limit(tp, skb,
+								 cwnd_quota);
+				if (limit > 0)
+					cwnd_quota = limit;
+				else
+					accecn_gso_limit = false;
+			}
+
+			if (!push_one && !accecn_gso_limit &&
 			    tcp_tso_should_defer(sk, skb, &is_cwnd_limited,
 						 &is_rwnd_limited, max_segs))
 				break;
-- 
2.20.1

