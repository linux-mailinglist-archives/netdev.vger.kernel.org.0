Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A470ECEB
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbfD2Wqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:46:48 -0400
Received: from mail-ot1-f73.google.com ([209.85.210.73]:54065 "EHLO
        mail-ot1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729662AbfD2Wqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:46:47 -0400
Received: by mail-ot1-f73.google.com with SMTP id f11so6606097otl.20
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 15:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uMuen5efdqBvfuXFWl5+NzEu8kwv3fbxCMN6jpZXLvE=;
        b=SAeh4F9Gkfm+luM2TOlgbyswYWatWwLFXGNu2XI/saXh9ZR9rskiTDhYmMVz35iZVC
         HRJqfh6Ao/T3SDzR9FvoePP/nfFVJmqauKhN2WtnhP+k6dVEAxHviu9PtLDmKrVn6lyA
         Vtw02Bxbl4m3wef6PgwIdxd7ro4MVjLB2PLRpWuorr2jsUlESJAscLaC2SZcp18zrbZC
         JkGnCAZpIg7za8zGz5fyRbuASJHb5m+E76LcfdN+2Sbudqa3Lecrc4fZpGPVQyBGt61r
         c6RHC68QpGgWeRHzFSfxIkHwuXe62G7MRPYAaJyULtponRX1yFHNxmWWziyN3G0MPPvF
         YtfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uMuen5efdqBvfuXFWl5+NzEu8kwv3fbxCMN6jpZXLvE=;
        b=H4ebj0nYtrxpOXNtn2IsECnEcBUogZXEMdxesrH1bVm/WsiHejHTX5y0jAamtm4E/a
         VrEHsB9ln5sdZ3AGocvZ8Y5pm3NZWYIUf8DdT6SJQyvkJJMmaOie0jnOJpKg1mBVlHtu
         U4+5gy/VtwtsgSYyHgIDq5N7J1GxZlCvzIzoSu+uc/CKU5W0c7oUWqLKSlyXZh6D3f/X
         yBjFghZhXu57gEYyUENfTMCkmUyxvs0f13NhSVcSJRXEfwtW6t2HHuaDG6YFSiME3Nmc
         qZBRRf/fOh+/D7zw2iGZz29hq+s5qFjy6qoDMfIwFBLAJxGCf20DHX3cliush4YyIRr4
         taEQ==
X-Gm-Message-State: APjAAAWAdIN7u0WhC+EQ7C9/qEgtcYaGvxt7oj6y4qNdNO3cvQzGXkrm
        9+McuorVk2MJsgyvc563oFKnfHHnGMs=
X-Google-Smtp-Source: APXvYqw51wpXgPDhQqXdR5qQGPya3fzT65pKHDxkWsdV+iSnW9W7BdfGSIbapOCOcNauGUI6EoJohyyphBk=
X-Received: by 2002:a9d:70c1:: with SMTP id w1mr14254108otj.312.1556578006437;
 Mon, 29 Apr 2019 15:46:46 -0700 (PDT)
Date:   Mon, 29 Apr 2019 15:46:19 -0700
In-Reply-To: <20190429224620.151064-1-ycheng@google.com>
Message-Id: <20190429224620.151064-8-ycheng@google.com>
Mime-Version: 1.0
References: <20190429224620.151064-1-ycheng@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH net-next 7/8] tcp: refactor to consolidate TFO passive open code
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, soheil@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a helper to consolidate two identical code block for passive TFO.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 52 +++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3a40584cb473..706a99ec73f6 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5989,6 +5989,27 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 	return 1;
 }
 
+static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
+{
+	tcp_try_undo_loss(sk, false);
+	inet_csk(sk)->icsk_retransmits = 0;
+
+	/* Once we leave TCP_SYN_RECV or TCP_FIN_WAIT_1,
+	 * we no longer need req so release it.
+	 */
+	reqsk_fastopen_remove(sk, tcp_sk(sk)->fastopen_rsk, false);
+
+	/* Re-arm the timer because data may have been sent out.
+	 * This is similar to the regular data transmission case
+	 * when new data has just been ack'ed.
+	 *
+	 * (TFO) - we could try to be more aggressive and
+	 * retransmitting any data sooner based on when they
+	 * are sent out.
+	 */
+	tcp_rearm_rto(sk);
+}
+
 /*
  *	This function implements the receiving procedure of RFC 793 for
  *	all states except ESTABLISHED and TIME_WAIT.
@@ -6085,22 +6106,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (!tp->srtt_us)
 			tcp_synack_rtt_meas(sk, req);
 
-		/* Once we leave TCP_SYN_RECV, we no longer need req
-		 * so release it.
-		 */
 		if (req) {
-			tcp_try_undo_loss(sk, false);
-			inet_csk(sk)->icsk_retransmits = 0;
-			reqsk_fastopen_remove(sk, req, false);
-			/* Re-arm the timer because data may have been sent out.
-			 * This is similar to the regular data transmission case
-			 * when new data has just been ack'ed.
-			 *
-			 * (TFO) - we could try to be more aggressive and
-			 * retransmitting any data sooner based on when they
-			 * are sent out.
-			 */
-			tcp_rearm_rto(sk);
+			tcp_rcv_synrecv_state_fastopen(sk);
 		} else {
 			tcp_try_undo_spurious_syn(sk);
 			tp->retrans_stamp = 0;
@@ -6138,18 +6145,9 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	case TCP_FIN_WAIT1: {
 		int tmo;
 
-		/* If we enter the TCP_FIN_WAIT1 state and we are a
-		 * Fast Open socket and this is the first acceptable
-		 * ACK we have received, this would have acknowledged
-		 * our SYNACK so stop the SYNACK timer.
-		 */
-		if (req) {
-			tcp_try_undo_loss(sk, false);
-			inet_csk(sk)->icsk_retransmits = 0;
-			/* We no longer need the request sock. */
-			reqsk_fastopen_remove(sk, req, false);
-			tcp_rearm_rto(sk);
-		}
+		if (req)
+			tcp_rcv_synrecv_state_fastopen(sk);
+
 		if (tp->snd_una != tp->write_seq)
 			break;
 
-- 
2.21.0.593.g511ec345e18-goog

