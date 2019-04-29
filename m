Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F088AECE5
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbfD2Wqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:46:32 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:40875 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbfD2Wqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:46:31 -0400
Received: by mail-vk1-f202.google.com with SMTP id d64so5743636vkg.7
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 15:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=plNUA467evcpbX0Jvwc1MwzwvAtD58IABMxUeIU1Hns=;
        b=oG0unzBRsfwKV8/5ZtRpv/Ma8jl5d4w+MKXRb3brItRkkGCzp9kbKgw3yIRg9scBWo
         CuNlLGEkgiUzm1gJ+RFcJQQ6ET/DQlqgoG0CukyCiWzUOXA2y/GKOXTExh2fDZSzVILm
         y1keiJglGWKkWpeJisSpxxtpuO7gq+H9A+0W0E2Pb6Hf4N0m9b1zFdxclx9MIHN0XTxT
         o88pnaRoUpKvNYEQSrZTUOt5rqZd5sCyIucGlw6wajOvOJE2EmsEsn+xSAswoFTkewxI
         4vl6KdA1Ktm9can9CGT1htEwFtnkSiuJK0DZcvQlCrbH9Sw250vbCFN2wQLsrZt3uTuz
         1AHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=plNUA467evcpbX0Jvwc1MwzwvAtD58IABMxUeIU1Hns=;
        b=d0qd4hjF2+82NSWcbadxMfZGZzb7myx1jkZIMgp1iN1rDyJQzcnngnxUAUqY72ouOa
         d/BOH8R9TBk51klE2m6Nk9dT3BAyTTpCXS4SoBUxtqQo1AQQMYyXNq2VoIz3MsLE+3V/
         R2zoLPAXYY2YjLg7pp7VESbEKxvwc7c9Xgz/HTobj+gKPTnPz1s3UPsXJVeZtOrcKqs9
         OD8oF7ptstL8pMOxixD9Dh00RqLfkL1p5hBTqIPZeTlK7lKhdayAe1g0T916FdkXhkWq
         PuIbMgnHcsdlMAzbvrkw4bf1n/oNbub/iGdXsXcjDZJKj5qmLzd+ds5EzEJRWHK0KbVt
         OT/A==
X-Gm-Message-State: APjAAAXzb/bt0ud3Vp1jKyFV9kKqQzkAgH6fwLBWcjGR0eWgijozlnCt
        DG/zdcFWiTr1o4ohpbLg/19yXDhgL0I=
X-Google-Smtp-Source: APXvYqzo3TgSr7GZalDiSoxcrZTlG4XAGUtZGcMUU88HxZ31ybdig1zZZfZgLlV0iOxTkZMRPhQWziF8XcA=
X-Received: by 2002:a67:c508:: with SMTP id e8mr4386047vsk.230.1556577990672;
 Mon, 29 Apr 2019 15:46:30 -0700 (PDT)
Date:   Mon, 29 Apr 2019 15:46:13 -0700
In-Reply-To: <20190429224620.151064-1-ycheng@google.com>
Message-Id: <20190429224620.151064-2-ycheng@google.com>
Mime-Version: 1.0
References: <20190429224620.151064-1-ycheng@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH net-next 1/8] tcp: avoid unconditional congestion window undo
 on SYN retransmit
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, soheil@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously if an active TCP open has SYN timeout, it always undo the
cwnd upon receiving the SYNACK. This is because tcp_clean_rtx_queue
would reset tp->retrans_stamp when SYN is acked, which fools then
tcp_try_undo_loss and tcp_packet_delayed. Addressing this issue is
required to properly support undo for spurious SYN timeout.

Fixing this is tricky -- for active TCP open tp->retrans_stamp
records the time when the handshake starts, not the first
retransmission time as the name may suggest. The simplest fix is
for tcp_packet_delayed to ensure it is valid before comparing with
other timestamp.

One side effect of this change is active TCP Fast Open that incurred
SYN timeout. Upon receiving a SYN-ACK that only acknowledged
the SYN, it would immediately retransmit unacknowledged data in
tcp_ack() because the data is marked lost after SYN timeout. But
the retransmission would have an incorrect ack sequence number since
rcv_nxt has not been updated yet tcp_rcv_synsent_state_process(), the
retransmission needs to properly handed by tcp_rcv_fastopen_synack()
like before.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 97671bff597a..e2cbfc3ffa3f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2252,7 +2252,7 @@ static bool tcp_skb_spurious_retrans(const struct tcp_sock *tp,
  */
 static inline bool tcp_packet_delayed(const struct tcp_sock *tp)
 {
-	return !tp->retrans_stamp ||
+	return tp->retrans_stamp &&
 	       tcp_tsopt_ecr_before(tp, tp->retrans_stamp);
 }
 
@@ -3521,7 +3521,7 @@ static void tcp_xmit_recovery(struct sock *sk, int rexmit)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (rexmit == REXMIT_NONE)
+	if (rexmit == REXMIT_NONE || sk->sk_state == TCP_SYN_SENT)
 		return;
 
 	if (unlikely(rexmit == 2)) {
-- 
2.21.0.593.g511ec345e18-goog

