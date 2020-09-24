Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DAC277B99
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgIXWXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgIXWXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 18:23:48 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD487C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 15:23:48 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d6so935719pfn.9
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 15:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1XxpUh3mZjFjsI9WiV8/x9jB6VQWOXBQlJkNUuC7rqI=;
        b=kPL3po9CDeW5eWy5bROqK8/0ApOFRhCKgyi9Naw32X/kWvgBmE6Lzuv3/HAzXTpzDy
         vSrnW36fPZwrlaVnVmbpI6JGr2RNFzYY69taYAVS/5hIwolaT4aFes/igcCY1Nz8PdMI
         VXB+nUWQj+CWIVIXksUOmLWXUwoI8a2YduDfYHEr+ts+OKKPGfEvDXZ4+TPrKtY7dcU1
         oDzS0fudmCiOFNqOTkjSHYKKu0PMM0zjOT8jdtpAPYRA5dWsYLw+F1WF+n4cbOcbj1zd
         EI8TZTC/RbMPtJ6lpwX8Q4nWNNisufSadx8X1o5kguN4ZTgeAeByI/rESuqB3jIahkuu
         HhFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1XxpUh3mZjFjsI9WiV8/x9jB6VQWOXBQlJkNUuC7rqI=;
        b=c8G/41Tb7MKnGE/zs6kNGPWPymoUcfOyozVUrDzTeacr54HcYsDeA/Qvw8BW4IrpBR
         81TwNKgG599JXWndpm1L96jiDeLJeU2RTkrDwALiOi/lEMGtA6vVazgcd/i4Y4pZkd+l
         b0zdgQ6ftDhJmmbZMkdx5hlPjEY4Ogw2QketDtB1CqgYHEDJpWaT5wEOK54Fq1nuDmWr
         gq3Pmmu4zKoPOWO9bh6XBwCtSNRvRl5c0Z85uocq34iMpMVKobOdd+rujeBkU2nodiuD
         6n0rFIa1D7+CkMItPOl5UV9s7UGB3GpkB1vuf1mqiZzdp8RiMIV8svUiZnzLYKmLPJiZ
         tP7w==
X-Gm-Message-State: AOAM530821qZ4MdNzZPXNs8G7vYglkyk+GXWwfGAoMTN/6Kr0R7Ep1ud
        J3U9Tuk/1EJTQSSCZRknNif8EBsm0cg=
X-Google-Smtp-Source: ABdhPJwpGL57N3e32ycu7C2eqrffiLHwXb7xJgj3jSCSuw3Hp44qVsJSI4ivNtptaI8Z/+etvllInQ==
X-Received: by 2002:a17:902:d311:b029:d1:e598:3ff8 with SMTP id b17-20020a170902d311b02900d1e5983ff8mr1276992plc.50.1600986228227;
        Thu, 24 Sep 2020 15:23:48 -0700 (PDT)
Received: from priyarjha.svl.corp.google.com ([2620:15c:2c4:201:a28c:fdff:fee3:2bbe])
        by smtp.gmail.com with ESMTPSA id c185sm449555pfb.123.2020.09.24.15.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 15:23:47 -0700 (PDT)
From:   Priyaranjan Jha <priyarjha.kernel@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Priyaranjan Jha <priyarjha@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] tcp: skip DSACKs with dubious sequence ranges
Date:   Thu, 24 Sep 2020 15:23:14 -0700
Message-Id: <20200924222314.3198543-1-priyarjha.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Priyaranjan Jha <priyarjha@google.com>

Currently, we use length of DSACKed range to compute number of
delivered packets. And if sequence range in DSACK is corrupted,
we can get bogus dsacked/acked count, and bogus cwnd.

This patch put bounds on DSACKed range to skip update of data
delivery and spurious retransmission information, if the DSACK
is unlikely caused by sender's action:
- DSACKed range shouldn't be greater than maximum advertised rwnd.
- Total no. of DSACKed segments shouldn't be greater than total
  no. of retransmitted segs. Unlike spurious retransmits, network
  duplicates or corrupted DSACKs shouldn't be counted as delivery.

Signed-off-by: Priyaranjan Jha <priyarjha@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/uapi/linux/snmp.h |  1 +
 net/ipv4/proc.c           |  1 +
 net/ipv4/tcp_input.c      | 32 +++++++++++++++++++++++++-------
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index cee9f8e6fce3..f84e7bcad6de 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -288,6 +288,7 @@ enum
 	LINUX_MIB_TCPTIMEOUTREHASH,		/* TCPTimeoutRehash */
 	LINUX_MIB_TCPDUPLICATEDATAREHASH,	/* TCPDuplicateDataRehash */
 	LINUX_MIB_TCPDSACKRECVSEGS,		/* TCPDSACKRecvSegs */
+	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
 	__LINUX_MIB_MAX
 };
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 1074df726ec0..8d5e1695b9aa 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -293,6 +293,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TcpTimeoutRehash", LINUX_MIB_TCPTIMEOUTREHASH),
 	SNMP_MIB_ITEM("TcpDuplicateDataRehash", LINUX_MIB_TCPDUPLICATEDATAREHASH),
 	SNMP_MIB_ITEM("TCPDSACKRecvSegs", LINUX_MIB_TCPDSACKRECVSEGS),
+	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 184ea556f50e..b1ce2054291d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -885,21 +885,34 @@ struct tcp_sacktag_state {
 	struct rate_sample *rate;
 };
 
-/* Take a notice that peer is sending D-SACKs */
+/* Take a notice that peer is sending D-SACKs. Skip update of data delivery
+ * and spurious retransmission information if this DSACK is unlikely caused by
+ * sender's action:
+ * - DSACKed sequence range is larger than maximum receiver's window.
+ * - Total no. of DSACKed segments exceed the total no. of retransmitted segs.
+ */
 static u32 tcp_dsack_seen(struct tcp_sock *tp, u32 start_seq,
 			  u32 end_seq, struct tcp_sacktag_state *state)
 {
 	u32 seq_len, dup_segs = 1;
 
-	if (before(start_seq, end_seq)) {
-		seq_len = end_seq - start_seq;
-		if (seq_len > tp->mss_cache)
-			dup_segs = DIV_ROUND_UP(seq_len, tp->mss_cache);
-	}
+	if (!before(start_seq, end_seq))
+		return 0;
+
+	seq_len = end_seq - start_seq;
+	/* Dubious DSACK: DSACKed range greater than maximum advertised rwnd */
+	if (seq_len > tp->max_window)
+		return 0;
+	if (seq_len > tp->mss_cache)
+		dup_segs = DIV_ROUND_UP(seq_len, tp->mss_cache);
+
+	tp->dsack_dups += dup_segs;
+	/* Skip the DSACK if dup segs weren't retransmitted by sender */
+	if (tp->dsack_dups > tp->total_retrans)
+		return 0;
 
 	tp->rx_opt.sack_ok |= TCP_DSACK_SEEN;
 	tp->rack.dsack_seen = 1;
-	tp->dsack_dups += dup_segs;
 
 	state->flag |= FLAG_DSACKING_ACK;
 	/* A spurious retransmission is delivered */
@@ -1153,6 +1166,11 @@ static bool tcp_check_dsack(struct sock *sk, const struct sk_buff *ack_skb,
 	}
 
 	dup_segs = tcp_dsack_seen(tp, start_seq_0, end_seq_0, state);
+	if (!dup_segs) {	/* Skip dubious DSACK */
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPDSACKIGNOREDDUBIOUS);
+		return false;
+	}
+
 	NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPDSACKRECVSEGS, dup_segs);
 
 	/* D-SACK for already forgotten data... Do dumb counting. */
-- 
2.28.0.681.g6f77f65b4e-goog

