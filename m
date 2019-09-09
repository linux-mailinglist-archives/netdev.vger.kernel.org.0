Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82BAAE014
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 22:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfIIU4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 16:56:06 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:48277 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfIIU4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 16:56:06 -0400
Received: by mail-qt1-f202.google.com with SMTP id o13so11700429qtr.15
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 13:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=EGp68VpaX6cWGyY6ngQL3v4AwpHmz/ufl+z8JevC3Q8=;
        b=iDGH4mur1t3RRWxXM7ljk6+fmOhA9GB+3EhIo8dZoi+CriMUTWdnX/orHznIOlc02l
         U+eL8kEcM1gKEWm/942vXgO90CfYfsmi6HgvlSQ4t8s344xTQZEGaFVfwr1EZOR8l9e/
         Rv8vo/ITmH72JluxH2zMGQXyYqtR2tCp3wMz71XLbQ9KtbY7yvFG2foSocthN2utKInU
         oddYKCvg3vzSJvW3x76zYXzOH96XI7B+CmMTDmVilOGrY/2gSzEJQ2nuD5UpLtfudTna
         hln4+pLu8vuvWyU7Kn1Qgmt/WBJK5f26L9b9PjQBPJjyXsGYhYbXfaMaWEmLERubE2Ic
         hlag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=EGp68VpaX6cWGyY6ngQL3v4AwpHmz/ufl+z8JevC3Q8=;
        b=CTSq9Ec1PmEeTVHJrVt795uIOe2glOYmMYhuMoK5iezg68OegcQAc2hpwLZ5fNTeOw
         gW/qaiirf+WhrwOEYR19pRmmyUSI9jw8uRngkDzxnwTKG36fZUx26cwp4Id4m7vdb+bI
         l8stx0CoZfMQ2HUx2DGpD/4zyTPb0DUE6fVgK0TD0zUi7tAPe6V2e74RW62zIKKhMDdo
         lQcg232Y76ho0I6doRNqtHG3MDq3EWBWqZiKIdgFrWe2oEM758bq4E81CjQVeumk0Skx
         DrZfuVkLTmGuj5SCwUlIf0uB2ROPfciNNWBrzbud+/R64RBb7z4rFI8IbUEE3hU+KaGK
         jTig==
X-Gm-Message-State: APjAAAVQ5wPgCGTo6CJ4vXgjs2oObSGTu8TiSnVleb1cQwjE3QTjpLpv
        /Z15kyOHnnAGfSFcKdizWSy+gOGZb7KdYVY=
X-Google-Smtp-Source: APXvYqxWlZsCHUAniaGGnkYc/2u2aJS99/DnTGaKIjiXtKa61MbDsuvjoKVdedwJZiPaBOvPoyAtkjOY3gc7N6M=
X-Received: by 2002:ac8:e8d:: with SMTP id v13mr23856477qti.96.1568062564621;
 Mon, 09 Sep 2019 13:56:04 -0700 (PDT)
Date:   Mon,  9 Sep 2019 16:56:02 -0400
Message-Id: <20190909205602.248472-1-ncardwell@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.162.g0b9fbb3734-goog
Subject: [PATCH net] tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix tcp_ecn_withdraw_cwr() to clear the correct bit:
TCP_ECN_QUEUE_CWR.

Rationale: basically, TCP_ECN_DEMAND_CWR is a bit that is purely about
the behavior of data receivers, and deciding whether to reflect
incoming IP ECN CE marks as outgoing TCP th->ece marks. The
TCP_ECN_QUEUE_CWR bit is purely about the behavior of data senders,
and deciding whether to send CWR. The tcp_ecn_withdraw_cwr() function
is only called from tcp_undo_cwnd_reduction() by data senders during
an undo, so it should zero the sender-side state,
TCP_ECN_QUEUE_CWR. It does not make sense to stop the reflection of
incoming CE bits on incoming data packets just because outgoing
packets were spuriously retransmitted.

The bug has been reproduced with packetdrill to manifest in a scenario
with RFC3168 ECN, with an incoming data packet with CE bit set and
carrying a TCP timestamp value that causes cwnd undo. Before this fix,
the IP CE bit was ignored and not reflected in the TCP ECE header bit,
and sender sent a TCP CWR ('W') bit on the next outgoing data packet,
even though the cwnd reduction had been undone.  After this fix, the
sender properly reflects the CE bit and does not set the W bit.

Note: the bug actually predates 2005 git history; this Fixes footer is
chosen to be the oldest SHA1 I have tested (from Sep 2007) for which
the patch applies cleanly (since before this commit the code was in a
.h file).

Fixes: bdf1ee5d3bd3 ("[TCP]: Move code from tcp_ecn.h to tcp*.c and tcp.h & remove it")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c21e8a22fb3b..8a1cd93dbb09 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -266,7 +266,7 @@ static void tcp_ecn_accept_cwr(struct sock *sk, const struct sk_buff *skb)
 
 static void tcp_ecn_withdraw_cwr(struct tcp_sock *tp)
 {
-	tp->ecn_flags &= ~TCP_ECN_DEMAND_CWR;
+	tp->ecn_flags &= ~TCP_ECN_QUEUE_CWR;
 }
 
 static void __tcp_ecn_check_ce(struct sock *sk, const struct sk_buff *skb)
-- 
2.23.0.162.g0b9fbb3734-goog

