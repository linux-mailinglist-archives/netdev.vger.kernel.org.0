Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95AC014FB57
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 04:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgBBDiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 22:38:54 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37854 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgBBDiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 22:38:54 -0500
Received: by mail-pg1-f193.google.com with SMTP id q127so5852896pga.4;
        Sat, 01 Feb 2020 19:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HqlOpqfDxlkvlmzjeW5jC7mYHnmnoACp+7MDfXGCRjk=;
        b=QDZVyZmc6a+j5r7LhYgz+9HrPZQrGeZ9S+Ai2TQCiODhsHhSnql4II0S4TL1P6lXZu
         zc+3bZJZzlfFU+z6nYQlxC8mfcTiPrm4AFDTVBARVzwGSQoL/W+pPJ/v3vsk5ZMyuRdo
         +BeOWRR6ZyRo0p461vhw+ORUjxugQRpMOYve4r+0QfQMfSJmPvDtx1tMcGB+lNSqRKhO
         qhQZ71ellBxdNPataR/zmWwlduV1EbJGiWFpCL4/tJXxWUkIbwbsEySQYNZbCpCtQ+qg
         ex9y4WTw8vBDFeVvNlbgc1uoqN4WEVn78bzGo2DkdZPCdQz0q0aZOJ3baYE1VKv+bxhU
         mnnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HqlOpqfDxlkvlmzjeW5jC7mYHnmnoACp+7MDfXGCRjk=;
        b=YWP0Ag66JjXdT9Do3sCkXE+fSAz2A/3Kko1K9NECJirMmKd0vP5WIXOvN2HdgPuPxZ
         NWyrLhYCI2Nl9ZaCc8tzM7x5XOPtFfjBdn2C/hFf+QXioSWh0XfgxTMHughrozifIx4E
         dy0GbKU7k7Qfn2c2XF7bn9tvZKqGT+WPIs8ArKfXPD55d9odEqPRyi089N4/aIlEtpUn
         2iOx8gmhoz6gAvLamzc7y8Er9h6iuKkJA1hUUHXFbt7mPMOZV6tI2rpyGpEVpApOJMBt
         wC/3xgCvJ8scbnXUS0dV/rH08ATwR5lkQatE3GKlDdZbcrdGx8QsWHdQjdyhd7qISb1R
         qE8g==
X-Gm-Message-State: APjAAAULVYNQCQx2I4pXOV6OcIINSMWfOKNMgYq2RCvBnysuxNv92YDJ
        hvAncLmgBD3HctOP6TnR8Hk=
X-Google-Smtp-Source: APXvYqyR2esvd01q2mklM6OsZY4/Xnwd3Bpmb2WGRxDsF2XF2T0wlX9R+sZFi9gNb997AXZvVCOG3Q==
X-Received: by 2002:a63:ff52:: with SMTP id s18mr18579544pgk.253.1580614731989;
        Sat, 01 Feb 2020 19:38:51 -0800 (PST)
Received: from localhost.localdomain ([116.84.110.10])
        by smtp.gmail.com with ESMTPSA id iq22sm15705334pjb.9.2020.02.01.19.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 19:38:51 -0800 (PST)
From:   sj38.park@gmail.com
To:     edumazet@google.com
Cc:     sj38.park@gmail.com, David.Laight@aculab.com, aams@amazon.com,
        davem@davemloft.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ncardwell@google.com,
        shuah@kernel.org, sjpark@amazon.de
Subject: [PATCH v3 1/2] tcp: Reduce SYN resend delay if a suspicous ACK is received
Date:   Sun,  2 Feb 2020 03:38:26 +0000
Message-Id: <20200202033827.16304-2-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200202033827.16304-1-sj38.park@gmail.com>
References: <20200202033827.16304-1-sj38.park@gmail.com>
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

In some cases such as LINGER option applied socket, the FIN and FIN/ACK
will be substituted to RST and RST/ACK, but there is no difference in
the main logic.

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

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: SeongJae Park <sjpark@amazon.de>
---
 net/ipv4/tcp_input.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2a976f57f7e7..baa4fee117f9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5893,8 +5893,14 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 *        the segment and return)"
 		 */
 		if (!after(TCP_SKB_CB(skb)->ack_seq, tp->snd_una) ||
-		    after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
+		    after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
+			/* Previous FIN/ACK or RST/ACK might be ignored. */
+			if (icsk->icsk_retransmits == 0)
+				inet_csk_reset_xmit_timer(sk,
+						ICSK_TIME_RETRANS,
+						TCP_TIMEOUT_MIN, TCP_RTO_MAX);
 			goto reset_and_undo;
+		}
 
 		if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
 		    !between(tp->rx_opt.rcv_tsecr, tp->retrans_stamp,
-- 
2.17.1

