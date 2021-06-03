Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103FA39973A
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 02:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhFCAxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 20:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFCAxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 20:53:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA25C06174A
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 17:51:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s8-20020a5b04480000b029049fb35700b9so5552671ybp.5
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 17:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=27+oSo3aDt8nbxPojpTloqo7TEdVXgqrf0u4uCkBdnk=;
        b=NSZfkLKUvsBJt2TJbMjUp7VJDBvQJQ8l02X3BA9xPPiL2pBZ1ID4tF3WSHtpA4ZiV6
         ONMHiiQK4fsLG7bltHP6qWHQuK8MJAf2K2kRF215lemQG8RlbQ1nR3ebR66uAkGFKc47
         gjLE99WvW4Ic0mojl0m2Q7qNrITmucrVK2fsrDY0+3IxT1mBZOQnJHKZKLocNtMPWEI8
         4FBqtEfXsmFWGuMCFVCqg/aIbzm5ZaqzjnlDHcKa4Ar+nCmyYbw08OqmMFqA5tHCgssv
         6nDaR9f4sUHrH3wfmx7PWcSfp8+tqvLGLq2A3DCXxOyZ0q0EX1FOq5BwMCMWhxxFLa5t
         n/IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=27+oSo3aDt8nbxPojpTloqo7TEdVXgqrf0u4uCkBdnk=;
        b=LlCQW7YcsLPlRfdQTDy8EmBhsP1a/JRT5+cQiZ8Bwyf63m42NLWJkizn7gG4XO8/qv
         nwh/hcIScHzGZ1tYQzD0ATZRpjsjx4XK23YzwsqREoiL12TN9Cu2Z6J6P8Q9nZJyzqvL
         qACIiSf/deq2YbMCv5MsKLq0ZkFrIiAb76Y58VKhjSAZUCby89iunWaQI/WMaZEhXKqA
         f/sPRPDzMXYXlxaq9Gy5uURI3VzeXpME8ZlNXPFloI9EoE4NWyL0TQmm8j6Uu97kmhHE
         ekF/iqBSTrboPo49ONUSlMxIhXVNKSWuFDgdCouzAAhHuSODSSSw/1txSJlfxOzWqxpT
         rMng==
X-Gm-Message-State: AOAM5337orps/N61ELz3jIg+EProgOzbGmBvJi8LUbRp2/SxaghjMLzI
        M97u3vauHgWWMYwYI1y2ZDdwveVt4Jo=
X-Google-Smtp-Source: ABdhPJybEd18G/lHj1cyoibgE2qGmfXmmwBo6emNfqUd5OQoBr5r8v0urA1XNExi66SxqYqi1VFy6UBLW+M=
X-Received: from ycheng.svl.corp.google.com ([2620:15c:2c4:201:15f7:9523:c9b2:3f1a])
 (user=ycheng job=sendgmr) by 2002:a25:c202:: with SMTP id s2mr29534805ybf.352.1622681484761;
 Wed, 02 Jun 2021 17:51:24 -0700 (PDT)
Date:   Wed,  2 Jun 2021 17:51:21 -0700
Message-Id: <20210603005121.3438186-1-ycheng@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH net-next] net: tcp better handling of reordering then loss cases
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>,
        mingkun bian <bianmingkun@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch aims to improve the situation when reordering and loss are
ocurring in the same flight of packets.

Previously the reordering would first induce a spurious recovery, then
the subsequent ACK may undo the cwnd (based on the timestamps e.g.).
However the current loss recovery does not proceed to invoke
RACK to install a reordering timer. If some packets are also lost, this
may lead to a long RTO-based recovery. An example is
https://groups.google.com/g/bbr-dev/c/OFHADvJbTEI

The solution is to after reverting the recovery, always invoke RACK
to either mount the RACK timer to fast retransmit after the reordering
window, or restarts the recovery if new loss is identified. Hence
it is possible the sender may go from Recovery to Disorder/Open to
Recovery again in one ACK.

Reported-by: mingkun bian <bianmingkun@gmail.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 45 +++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cd52ce0a2a85..7d5e59f688de 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2816,8 +2816,17 @@ static void tcp_process_loss(struct sock *sk, int flag, int num_dupack,
 	*rexmit = REXMIT_LOST;
 }
 
+static bool tcp_force_fast_retransmit(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	return after(tcp_highest_sack_seq(tp),
+		     tp->snd_una + tp->reordering * tp->mss_cache);
+}
+
 /* Undo during fast recovery after partial ACK. */
-static bool tcp_try_undo_partial(struct sock *sk, u32 prior_snd_una)
+static bool tcp_try_undo_partial(struct sock *sk, u32 prior_snd_una,
+				 bool *do_lost)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -2842,7 +2851,9 @@ static bool tcp_try_undo_partial(struct sock *sk, u32 prior_snd_una)
 		tcp_undo_cwnd_reduction(sk, true);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPPARTIALUNDO);
 		tcp_try_keep_open(sk);
-		return true;
+	} else {
+		/* Partial ACK arrived. Force fast retransmit. */
+		*do_lost = tcp_force_fast_retransmit(sk);
 	}
 	return false;
 }
@@ -2866,14 +2877,6 @@ static void tcp_identify_packet_loss(struct sock *sk, int *ack_flag)
 	}
 }
 
-static bool tcp_force_fast_retransmit(struct sock *sk)
-{
-	struct tcp_sock *tp = tcp_sk(sk);
-
-	return after(tcp_highest_sack_seq(tp),
-		     tp->snd_una + tp->reordering * tp->mss_cache);
-}
-
 /* Process an event, which can update packets-in-flight not trivially.
  * Main goal of this function is to calculate new estimate for left_out,
  * taking into account both packets sitting in receiver's buffer and
@@ -2943,17 +2946,21 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		if (!(flag & FLAG_SND_UNA_ADVANCED)) {
 			if (tcp_is_reno(tp))
 				tcp_add_reno_sack(sk, num_dupack, ece_ack);
-		} else {
-			if (tcp_try_undo_partial(sk, prior_snd_una))
-				return;
-			/* Partial ACK arrived. Force fast retransmit. */
-			do_lost = tcp_force_fast_retransmit(sk);
-		}
-		if (tcp_try_undo_dsack(sk)) {
-			tcp_try_keep_open(sk);
+		} else if (tcp_try_undo_partial(sk, prior_snd_una, &do_lost))
 			return;
-		}
+
+		if (tcp_try_undo_dsack(sk))
+			tcp_try_keep_open(sk);
+
 		tcp_identify_packet_loss(sk, ack_flag);
+		if (icsk->icsk_ca_state != TCP_CA_Recovery) {
+			if (!tcp_time_to_recover(sk, flag))
+				return;
+			/* Undo reverts the recovery state. If loss is evident,
+			 * starts a new recovery (e.g. reordering then loss);
+			 */
+			tcp_enter_recovery(sk, ece_ack);
+		}
 		break;
 	case TCP_CA_Loss:
 		tcp_process_loss(sk, flag, num_dupack, rexmit);
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

