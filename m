Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A20F209DBF
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 13:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404286AbgFYLvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 07:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404221AbgFYLvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 07:51:18 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD93C061573
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 04:51:18 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h19so6113554ljg.13
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 04:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0QqHGk/qmtjcNigqHj2v/hWPS+dyiDPxujTz8viwAno=;
        b=u9rg6WgBUv8ZgT0zv417EZjZFl9NzFgNSTfmACqALb5IiGG5cFcFo34UgObHeKazOK
         2uqjZqlEAufuP2YfRFqxRW3AF9OTYUGR+pZvYhk09J8Mey0JlloBtuKmUBhy2c70vUuE
         HjDUBmSqWZakM5Zt2ooRJGKbT+1RpQ8jYbyEllWua5AYo9BaWBWeSgInI37XV6drw9U1
         VdLQGGkUzDHXc06QJf5k/CpLnH3xUQGhALEEiOQOJMo8vhukuYTxdXL+effekCPlCe/t
         zzAg2zf9/Cf4+nUVu97Gc30/AFm1usbZQbQAyhVdku4jLRpUNTsxotHzrHfxy8xc5uH/
         WqXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0QqHGk/qmtjcNigqHj2v/hWPS+dyiDPxujTz8viwAno=;
        b=iuHxKUD6sFVzPQzXsGeDoqWf+bj1j2TSACEULXYbZTCYOvPZ11ibRwbzCqB48bv6I/
         Wa9M238bjcLrUf1GmVfVVLZ7Fu3R89+Gw3rZj3qMI2lGk7tGlzgScXW88WBNJdVEGfgB
         1k/fzPvtQD+juKqtHMZNTjdAPvQ3NFM6FDndRzPImS7E686/ahQlodpIgSNOl0+5raAz
         EIs1WoO/ru+Rxhw5XmMrc0zUEOLJI20OcOSsRGZaq9J4YvjBl9nCbbzdclx4O6nHtBPC
         Zahjg7DJA7NedG8MjZZpWWYLP7RG8q65el7b5n5e3VCqGQKRvfApetBecClvwaMJw8Pc
         Cocg==
X-Gm-Message-State: AOAM531ZKco2Rej6U8yf8z3Wm+0Vlsgi2WtZa1MRdLA9PKfvgMs+j9uU
        3ffSlD3Dr99e7hmbf6jsuUI7rlO2vej0ng==
X-Google-Smtp-Source: ABdhPJydYhqlqg9ux9nATuZsLbIth2Ay4ZdUpQTxbP50JBFpxzQRL94LqFhJgdQCgi7sUG5q24CQYg==
X-Received: by 2002:a2e:800c:: with SMTP id j12mr15480773ljg.218.1593085876281;
        Thu, 25 Jun 2020 04:51:16 -0700 (PDT)
Received: from localhost.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id f9sm3950484ljf.27.2020.06.25.04.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 04:51:15 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <denis.kirjanov@suse.com>
To:     netdev@vger.kernel.org
Cc:     ncardwell@google.com, edumazet@google.com, ycheng@google.com,
        Richard.Scheffenegger@netapp.com, ietf@bobbriscoe.net
Subject: [PATCH v3] tcp: don't ignore ECN CWR on pure ACK
Date:   Thu, 25 Jun 2020 14:51:06 +0300
Message-Id: <20200625115106.23370-1-denis.kirjanov@suse.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is a problem with the CWR flag set in an incoming ACK segment
and it leads to the situation when the ECE flag is latched forever

the following packetdrill script shows what happens:

// Stack receives incoming segments with CE set
+0.1 <[ect0]  . 11001:12001(1000) ack 1001 win 65535
+0.0 <[ce]    . 12001:13001(1000) ack 1001 win 65535
+0.0 <[ect0] P. 13001:14001(1000) ack 1001 win 65535

// Stack repsonds with ECN ECHO
+0.0 >[noecn]  . 1001:1001(0) ack 12001
+0.0 >[noecn] E. 1001:1001(0) ack 13001
+0.0 >[noecn] E. 1001:1001(0) ack 14001

// Write a packet
+0.1 write(3, ..., 1000) = 1000
+0.0 >[ect0] PE. 1001:2001(1000) ack 14001

// Pure ACK received
+0.01 <[noecn] W. 14001:14001(0) ack 2001 win 65535

// Since CWR was sent, this packet should NOT have ECE set

+0.1 write(3, ..., 1000) = 1000
+0.0 >[ect0]  P. 2001:3001(1000) ack 14001
// but Linux will still keep ECE latched here, with packetdrill
// flagging a missing ECE flag, expecting
// >[ect0] PE. 2001:3001(1000) ack 14001
// in the script

In the situation above we will continue to send ECN ECHO packets
and trigger the peer to reduce the congestion window. To avoid that
we can check CWR on pure ACKs received.

v3:
- Add a sequence check to avoid sending an ACK to an ACK

v2:
- Adjusted the comment
- move CWR check before checking for unacknowledged packets

Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
---
 net/ipv4/tcp_input.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 12fda8f27b08..f3a0eb139b76 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -261,7 +261,8 @@ static void tcp_ecn_accept_cwr(struct sock *sk, const struct sk_buff *skb)
 		 * cwnd may be very low (even just 1 packet), so we should ACK
 		 * immediately.
 		 */
-		inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
+		if (TCP_SKB_CB(skb)->seq != TCP_SKB_CB(skb)->end_seq)
+			inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
 	}
 }
 
@@ -3665,6 +3666,15 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		tcp_in_ack_event(sk, ack_ev_flags);
 	}
 
+	/* This is a deviation from RFC3168 since it states that:
+	 * "When the TCP data sender is ready to set the CWR bit after reducing
+	 * the congestion window, it SHOULD set the CWR bit only on the first
+	 * new data packet that it transmits."
+	 * We accept CWR on pure ACKs to be more robust
+	 * with widely-deployed TCP implementations that do this.
+	 */
+	tcp_ecn_accept_cwr(sk, skb);
+
 	/* We passed data and got it acked, remove any soft error
 	 * log. Something worked...
 	 */
@@ -4800,8 +4810,6 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 	skb_dst_drop(skb);
 	__skb_pull(skb, tcp_hdr(skb)->doff * 4);
 
-	tcp_ecn_accept_cwr(sk, skb);
-
 	tp->rx_opt.dsack = 0;
 
 	/*  Queue data for delivery to the user.
-- 
2.27.0

