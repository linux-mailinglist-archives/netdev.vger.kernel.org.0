Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6436214F6FE
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 08:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgBAHTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 02:19:14 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46101 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgBAHTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 02:19:14 -0500
Received: by mail-wr1-f68.google.com with SMTP id z7so11192360wrl.13;
        Fri, 31 Jan 2020 23:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eke5sBTLy6OgiheiuxHRk3qgDygD3NTMWAJknxyaymw=;
        b=TNKN/2nFPUQzkhyZmQ8cOlu4SKJUNAlhH5McodWv3mtwh59+UMcbd1TT2lP0NrGe6/
         lros/X9McKFfhCFJFT8LtYnvbXY5jVMHtUqH+RIffqj6Dv20gNnhU7K51d3kca1WmiYC
         hSoHbA906qPZXtGNzK5k8/QG0jP1FGIoDCHJazCvQHiui0FsjQjOkDW7UfE/tOzA9RIX
         3ZJjRqISoVNNOMWOXfSis+9q+/zTSwy1ohBXaKTgU2OibvJ7e94cKTs8oTgstFMcb9Ro
         2NsoZBpjc38tgIslJLsEuPJ7ngq3J7qIrb7FsKnox9DwRwD61FsX7mhVauVN5rjg3gI5
         6NOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eke5sBTLy6OgiheiuxHRk3qgDygD3NTMWAJknxyaymw=;
        b=Ab3te8aiyGbAKR1k/Sst0AYRTcCLqRjvi4N9MmODoCFrbdwN5nDflhIfis7tpsMLTS
         oFHrxOrBdqhYc0BUZmGa2hxCa0mtFj4LkEScyRKcSK22Lte5ajgwWzHScbJAnymo3cLW
         2NEd5rA22JSGYOsKo+Js+6zFM+DJt7sOaRMGW88GNQEDr/K2DWhtW/6QRtnSPCn4ifIg
         HD77UDH8Ov/ceN6CrQ+x6jc6Rq/imB5C5i3mZ7/C8vS/062m8YpDaj2CWxhIXKrBv8IR
         74JlpNI8tNTXcG82NMMeHh+syJ29VRdIhwn6DHR510WN2M4nvuSNxIBbVJS5p1RgopmL
         n3NA==
X-Gm-Message-State: APjAAAX5FOkEsptIKQFVpBE9fnAqK1Xsy+BD9W/ajJ42rE+ZFgCDNI4R
        PqMuqIsx8Jqs2tXtwsY7/MsKFNdR
X-Google-Smtp-Source: APXvYqwR0qofoMoeKrmpnjGW2PFx1dUNqMR4jfpQBbrzXP0deaIb/Wv+zKjuM8cyS6MMaXcofLQhbw==
X-Received: by 2002:a5d:66cc:: with SMTP id k12mr3052135wrw.72.1580541552100;
        Fri, 31 Jan 2020 23:19:12 -0800 (PST)
Received: from localhost.localdomain (cable-158-181-93-24.cust.telecolumbus.net. [158.181.93.24])
        by smtp.gmail.com with ESMTPSA id o4sm664286wrw.15.2020.01.31.23.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 23:19:11 -0800 (PST)
From:   sj38.park@gmail.com
To:     eric.dumazet@gmail.com, edumazet@google.com
Cc:     davem@davemloft.net, aams@amazon.com, ncardwell@google.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuah@kernel.org, ycheng@google.com,
        David.Laight@ACULAB.COM, sj38.park@gmail.com,
        SeongJae Park <sjpark@amazon.de>
Subject: [PATCH v2 1/2] tcp: Reduce SYN resend delay if a suspicous ACK is received
Date:   Sat,  1 Feb 2020 07:18:58 +0000
Message-Id: <20200201071859.4231-2-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200201071859.4231-1-sj38.park@gmail.com>
References: <20200201071859.4231-1-sj38.park@gmail.com>
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
index 2a976f57f7e7..980bd04b9d95 100644
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
+						ICSK_TIME_RETRANS, TCP_ATO_MIN,
+						TCP_RTO_MAX);
 			goto reset_and_undo;
+		}
 
 		if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
 		    !between(tp->rx_opt.rcv_tsecr, tp->retrans_stamp,
-- 
2.17.1

