Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3431316903B
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 17:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgBVQVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 11:21:19 -0500
Received: from mail-qv1-f73.google.com ([209.85.219.73]:47922 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgBVQVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 11:21:18 -0500
Received: by mail-qv1-f73.google.com with SMTP id dr18so3483384qvb.14
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 08:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vny/6Afl5ywHpcf9AtK1W+WKvgD2XxXsQnq8LJ8H39I=;
        b=gu0e21F4GPRNamKe56slOFqcrJc/Z8iusHwgcngE7Izsi1CF5sU086QsGzSL41pjs8
         gUdI6yAspW+OaxGhMAo/isbKIjEG+8DSaGqxyQY+ERK7Nsia4ByV5m3kwH/w52gHl3dQ
         uHSIhN8Q+2QlNljY0bBkn/gspfHBCipj8cSvaBuZwo+k2Z4VKSMIbj6Eha18WXHW3Ylr
         F8iZ0XAZBmPRCwmr97L9YNyMR5rD8HUDaTT7gLDFYM3NBSlkRiiwv6LYm3IneM1Nf1wk
         jNgDEkbZftR9MSq/TbzhcfHBQ5Cz/Jxb6Gqir/s9WN4S8wghjSYWT5QbDYCBWKITWv4l
         nDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vny/6Afl5ywHpcf9AtK1W+WKvgD2XxXsQnq8LJ8H39I=;
        b=T1agcS39PoakFTaqtzCvK46KW7Le7KIbQAMs6ZeHf6Q69uMxY2frV7eQlxXH8mX+2u
         PrjA4Mu0BO+OQsycz8+JbDBSwzNDMCVm15IBfnj+ZubV/92txYYPZ36q1dncjRe0PatU
         ekLh5sAYxIsnrHjXn8SahfbcSEJwY9vOZy+NLvZMs2KJzMOqEycRopwOvz1Uu3nq29kq
         +2/Hw9PTtAXeYt8vwB7nkAIT1nhHXFyrklMPdXRgcMfITmmqwRN1vIzVpVMVK+bMtiVu
         zlYDhUIce8VHjH/qoMXJ7T4XPlGzsfKqRgKkHGjPaCgNXrOiFqi8bJz8YjPOfMLoygBc
         RiDQ==
X-Gm-Message-State: APjAAAUxKnI3n0cGbuQYxhQnxW00FLNnL6qt8AirZiep7o6tXhnzyF2E
        M55GwR1VbrBbEEzLBUZaj8Widkz8OiCk6ZQ=
X-Google-Smtp-Source: APXvYqyciZKcyJOs1t39FkYngcoIq/9cvpXnSx5/9DShf7Tt3ElqDoHN18ENOPfoRZE17q90P7Z8EniL+Q0q/JI=
X-Received: by 2002:ad4:478b:: with SMTP id z11mr36094400qvy.185.1582388477266;
 Sat, 22 Feb 2020 08:21:17 -0800 (PST)
Date:   Sat, 22 Feb 2020 11:21:15 -0500
Message-Id: <20200222162116.148681-1-ncardwell@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH net] tcp: fix TFO SYNACK undo to avoid double-timestamp-undo
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a rare corner case the new logic for undo of SYNACK RTO could
result in triggering the warning in tcp_fastretrans_alert() that says:
        WARN_ON(tp->retrans_out != 0);

The warning looked like:

WARNING: CPU: 1 PID: 1 at net/ipv4/tcp_input.c:2818 tcp_ack+0x13e0/0x3270

The sequence that tickles this bug is:
 - Fast Open server receives TFO SYN with data, sends SYNACK
 - (client receives SYNACK and sends ACK, but ACK is lost)
 - server app sends some data packets
 - (N of the first data packets are lost)
 - server receives client ACK that has a TS ECR matching first SYNACK,
   and also SACKs suggesting the first N data packets were lost
    - server performs TS undo of SYNACK RTO, then immediately
      enters recovery
    - buggy behavior then performed a *second* undo that caused
      the connection to be in CA_Open with retrans_out != 0

Basically, the incoming ACK packet with SACK blocks causes us to first
undo the cwnd reduction from the SYNACK RTO, but then immediately
enters fast recovery, which then makes us eligible for undo again. And
then tcp_rcv_synrecv_state_fastopen() accidentally performs an undo
using a "mash-up" of state from two different loss recovery phases: it
uses the timestamp info from the ACK of the original SYNACK, and the
undo_marker from the fast recovery.

This fix refines the logic to only invoke the tcp_try_undo_loss()
inside tcp_rcv_synrecv_state_fastopen() if the connection is still in
CA_Loss.  If peer SACKs triggered fast recovery, then
tcp_rcv_synrecv_state_fastopen() can't safely undo.

Fixes: 794200d66273 ("tcp: undo cwnd on Fast Open spurious SYNACK retransmit")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 316ebdf8151d..6b6b57000dad 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6124,7 +6124,11 @@ static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
 {
 	struct request_sock *req;
 
-	tcp_try_undo_loss(sk, false);
+	/* If we are still handling the SYNACK RTO, see if timestamp ECR allows
+	 * undo. If peer SACKs triggered fast recovery, we can't undo here.
+	 */
+	if (inet_csk(sk)->icsk_ca_state == TCP_CA_Loss)
+		tcp_try_undo_loss(sk, false);
 
 	/* Reset rtx states to prevent spurious retransmits_timed_out() */
 	tcp_sk(sk)->retrans_stamp = 0;
-- 
2.25.0.265.gbab2e86ba0-goog

