Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9B514F828
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 15:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgBAOyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 09:54:14 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50221 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgBAOyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 09:54:13 -0500
Received: by mail-wm1-f67.google.com with SMTP id a5so11144236wmb.0;
        Sat, 01 Feb 2020 06:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bx34vcvVs2uZr1BGwZtV+jTy58r/Vj2Gp5eXW5kioAo=;
        b=VzfglUOSXI5Jgmtbp6KJiEFH9laPxxO5QaUP1kddvLe5pvVnC1rBi5h3wkjYEF4HXv
         qjaIAxxRhfj1tMZa4rPv+PWm5v4uG1nyIod3ceg3U3XdiGWWVyyQR21zuTAjhdFtIFvh
         SwXgn98PskgdrOe7fg3BqNyI3rJwj+hMMD85CJ/8UIze600xLuf0zOVEWOyhJ3uKs+Nb
         bPbncbWgCwIrcN6aj3RhuuFUo8G62b/1fLfp4YYkKzOOdRvTfP/FoTGcQERSG/sYCrSz
         GUzpqUxb4eOI9noLkQlFKjQoR3NqIbsLtROugxw9mr66BWS7IGX0u9mU9eFTpdP7p6Lu
         eNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bx34vcvVs2uZr1BGwZtV+jTy58r/Vj2Gp5eXW5kioAo=;
        b=rKVlVayTL1LO8yfoKq7y93fS7JtCStW4ok67QWz98ZkC0UpWptt/e1KLFuxlqCz5JJ
         3hv67vwKItIfNOqFr/n3b9qx4DEHJVybSWuRxMnRrmNS5hZ9i7gyXbZw4rSADcd7OY+t
         CIMok1UwnGGzitnYq0PDFpofiUiQtbDHAUguGswVYpNUex82rsBsYBKhHlYsR9k5AHRo
         wDtpS5OCVgFwfOw21tf24HgamdFxbTOdf0ro2xPTJimkCgTg8Ki1ZvtiJSa81tzPVpNw
         CH5wpSn8EJI2mD1h2kWe6UkElKq5fxfzXktLLqDd3qWGoNJ5+UcyROWzNAkVIQZR+rJP
         BL3A==
X-Gm-Message-State: APjAAAWieGiLWaKNWmhHA0H4V88LNDrsV7zhp1Skirq30bx4ehyCz+DL
        4Ogop1kcAxyI1EQFtzHAz5I=
X-Google-Smtp-Source: APXvYqwJ6EF10ix0SUXZRsnMvd1srZiHQeOYKBpJQHcN9PjmSEe+c9saMBQUOwfdVcWmKzUfxEAeag==
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr18305920wmg.20.1580568851157;
        Sat, 01 Feb 2020 06:54:11 -0800 (PST)
Received: from localhost.localdomain ([88.128.88.116])
        by smtp.gmail.com with ESMTPSA id 11sm16534882wmb.14.2020.02.01.06.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 06:54:10 -0800 (PST)
From:   sj38.park@gmail.com
To:     sj38.park@gmail.com
Cc:     David.Laight@aculab.com, aams@amazon.com, davem@davemloft.net,
        edumazet@google.com, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        ncardwell@google.com, netdev@vger.kernel.org, shuah@kernel.org,
        sjpark@amazon.de
Subject: [PATCH v2.1 1/2] tcp: Reduce SYN resend delay if a suspicous ACK is received
Date:   Sat,  1 Feb 2020 14:53:53 +0000
Message-Id: <20200201145353.2607-1-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200201143608.6742-1-sj38.park@gmail.com>
References: <20200201143608.6742-1-sj38.park@gmail.com>
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

