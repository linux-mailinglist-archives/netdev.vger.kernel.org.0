Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A63614EC76
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 13:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgAaMZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 07:25:07 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:19839 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgAaMZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 07:25:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580473506; x=1612009506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Zk3wI8pneK5JMxV2EImoUPA7OfrNe6Lhhf3JHIUUWqY=;
  b=hRQnojC/oaqgQ+X76gJT6GVaCC/0OKnYU0nwztqm9rz8wrFtEhQX5+7C
   u97T80bi05uYAJkRAgiYDOH85FtouhpnaGDYdR5JtxzYa6MiVes0Uuwo6
   jAcmnaDnhTdwwmDcQyDXcUdulNZXxplOq3fcSTMoPqq8osGA/GWeEMasC
   E=;
IronPort-SDR: Np1qsOA8+sTvpoqKlzTfcuNbFkT0rEFe4IoX6P/b3gjbU+BnT4Ox6rykIMoLiQr3zVcW4JyFiH
 ndG8wwzXOpvQ==
X-IronPort-AV: E=Sophos;i="5.70,385,1574121600"; 
   d="scan'208";a="22232066"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 31 Jan 2020 12:24:54 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id C9323A1E27;
        Fri, 31 Jan 2020 12:24:53 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Fri, 31 Jan 2020 12:24:53 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.50) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 Jan 2020 12:24:48 +0000
From:   <sjpark@amazon.com>
To:     <edumazet@google.com>, <davem@davemloft.net>
CC:     <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sj38.park@gmail.com>, <aams@amazon.com>,
        SeongJae Park <sjpark@amazon.de>
Subject: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous ACK is received
Date:   Fri, 31 Jan 2020 13:24:20 +0100
Message-ID: <20200131122421.23286-3-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131122421.23286-1-sjpark@amazon.com>
References: <20200131122421.23286-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D24UWA003.ant.amazon.com (10.43.160.195) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

When closing a connection, the two acks that required to change closing
socket's status to FIN_WAIT_2 and then TIME_WAIT could be processed in
reverse order.  This is possible in RSS disabled environments such as a
connection inside a host.

For example, expected state transitions and required packets for the
disconnection will be similar to below flow.

	 00 (Process A)				(Process B)
	 01 ESTABLISHED				ESTABLISHED
	 02 close()
	 03 FIN_WAIT_1
	 04 		---FIN-->
	 05 					CLOSE_WAIT
	 06 		<--ACK---
	 07 FIN_WAIT_2
	 08 		<--FIN/ACK---
	 09 TIME_WAIT
	 10 		---ACK-->
	 11 					LAST_ACK
	 12 CLOSED				CLOSED

The acks in lines 6 and 8 are the acks.  If the line 8 packet is
processed before the line 6 packet, it will be just ignored as it is not
a expected packet, and the later process of the line 6 packet will
change the status of Process A to FIN_WAIT_2, but as it has already
handled line 8 packet, it will not go to TIME_WAIT and thus will not
send the line 10 packet to Process B.  Thus, Process B will left in
CLOSE_WAIT status, as below.

	 00 (Process A)				(Process B)
	 01 ESTABLISHED				ESTABLISHED
	 02 close()
	 03 FIN_WAIT_1
	 04 		---FIN-->
	 05 					CLOSE_WAIT
	 06 				(<--ACK---)
	 07	  			(<--FIN/ACK---)
	 08 				(fired in right order)
	 09 		<--FIN/ACK---
	 10 		<--ACK---
	 11 		(processed in reverse order)
	 12 FIN_WAIT_2

Later, if the Process B sends SYN to Process A for reconnection using
the same port, Process A will responds with an ACK for the last flow,
which has no increased sequence number.  Thus, Process A will send RST,
wait for TIMEOUT_INIT (one second in default), and then try
reconnection.  If reconnections are frequent, the one second latency
spikes can be a big problem.  Below is a tcpdump results of the problem:

    14.436259 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644
    14.436266 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5, win 512
    14.436271 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R], seq 2541101298
    /* ONE SECOND DELAY */
    15.464613 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644

This commit mitigates the problem by reducing the delay for the next SYN
if the suspicous ACK is received while in SYN_SENT state.

Following commit will add a selftest, which can be also helpful for
understanding of this issue.

Signed-off-by: SeongJae Park <sjpark@amazon.de>
---
 net/ipv4/tcp_input.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2a976f57f7e7..b168e29e1ad1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5893,8 +5893,12 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 *        the segment and return)"
 		 */
 		if (!after(TCP_SKB_CB(skb)->ack_seq, tp->snd_una) ||
-		    after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
+		    after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
+			/* Previous FIN/ACK or RST/ACK might be ignore. */
+			inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
+						  TCP_ATO_MIN, TCP_RTO_MAX);
 			goto reset_and_undo;
+		}
 
 		if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
 		    !between(tp->rx_opt.rcv_tsecr, tp->retrans_stamp,
-- 
2.17.1

