Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76FA1189827
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgCRJoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:44:05 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:51650 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727561AbgCRJn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:43:58 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9holr012869;
        Wed, 18 Mar 2020 11:43:50 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id E35E8360F45; Wed, 18 Mar 2020 11:43:50 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 13/28] tcp: Pass flags to tcp_send_ack
Date:   Wed, 18 Mar 2020 11:43:17 +0200
Message-Id: <1584524612-24470-14-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>

Accurate ECN reflector needs to send custom flags to handle
IP-ECN field reflector.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 include/net/tcp.h     |  4 ++--
 net/ipv4/bpf_tcp_ca.c |  2 +-
 net/ipv4/tcp.c        |  2 +-
 net/ipv4/tcp_dctcp.h  |  2 +-
 net/ipv4/tcp_input.c  | 14 +++++++-------
 net/ipv4/tcp_output.c | 10 +++++-----
 net/ipv4/tcp_timer.c  |  4 ++--
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index ee938066fd8c..ddeb11c01faa 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -640,8 +640,8 @@ void tcp_send_fin(struct sock *sk);
 void tcp_send_active_reset(struct sock *sk, gfp_t priority);
 int tcp_send_synack(struct sock *);
 void tcp_push_one(struct sock *, unsigned int mss_now);
-void __tcp_send_ack(struct sock *sk, u32 rcv_nxt);
-void tcp_send_ack(struct sock *sk);
+void __tcp_send_ack(struct sock *sk, u32 rcv_nxt, u16 flags);
+void tcp_send_ack(struct sock *sk, u16 flags);
 void tcp_send_delayed_ack(struct sock *sk);
 void tcp_send_loss_probe(struct sock *sk);
 bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto);
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 574972bc7299..55b78183fbd9 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -146,7 +146,7 @@ static int bpf_tcp_ca_btf_struct_access(struct bpf_verifier_log *log,
 BPF_CALL_2(bpf_tcp_send_ack, struct tcp_sock *, tp, u32, rcv_nxt)
 {
 	/* bpf_tcp_ca prog cannot have NULL tp */
-	__tcp_send_ack((struct sock *)tp, rcv_nxt);
+	__tcp_send_ack((struct sock *)tp, rcv_nxt, 0);
 	return 0;
 }
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2ee1e4794c7d..edc03a1bf704 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1572,7 +1572,7 @@ static void tcp_cleanup_rbuf(struct sock *sk, int copied)
 		}
 	}
 	if (time_to_ack)
-		tcp_send_ack(sk);
+		tcp_send_ack(sk, 0);
 }
 
 static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
diff --git a/net/ipv4/tcp_dctcp.h b/net/ipv4/tcp_dctcp.h
index d69a77cbd0c7..4b0259111d81 100644
--- a/net/ipv4/tcp_dctcp.h
+++ b/net/ipv4/tcp_dctcp.h
@@ -28,7 +28,7 @@ static inline void dctcp_ece_ack_update(struct sock *sk, enum tcp_ca_event evt,
 		 */
 		if (inet_csk(sk)->icsk_ack.pending & ICSK_ACK_TIMER) {
 			dctcp_ece_ack_cwr(sk, *ce_state);
-			__tcp_send_ack(sk, *prior_rcv_nxt);
+			__tcp_send_ack(sk, *prior_rcv_nxt, 0);
 		}
 		inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
 	}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 65bbfadbee67..dbe70a114b1d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3512,7 +3512,7 @@ static void tcp_send_challenge_ack(struct sock *sk, const struct sk_buff *skb)
 	if (count > 0) {
 		WRITE_ONCE(challenge_count, count - 1);
 		NET_INC_STATS(net, LINUX_MIB_TCPCHALLENGEACK);
-		tcp_send_ack(sk);
+		tcp_send_ack(sk, 0);
 	}
 }
 
@@ -4255,12 +4255,12 @@ void tcp_fin(struct sock *sk)
 		 * happens, we must ack the received FIN and
 		 * enter the CLOSING state.
 		 */
-		tcp_send_ack(sk);
+		tcp_send_ack(sk, 0);
 		tcp_set_state(sk, TCP_CLOSING);
 		break;
 	case TCP_FIN_WAIT2:
 		/* Received a FIN -- send ACK and enter TIME_WAIT. */
-		tcp_send_ack(sk);
+		tcp_send_ack(sk, 0);
 		tcp_time_wait(sk, TCP_TIME_WAIT, 0);
 		break;
 	default:
@@ -4367,7 +4367,7 @@ static void tcp_send_dupack(struct sock *sk, const struct sk_buff *skb)
 		}
 	}
 
-	tcp_send_ack(sk);
+	tcp_send_ack(sk, 0);
 }
 
 /* These routines update the SACK block as out-of-order packets arrive or
@@ -4427,7 +4427,7 @@ static void tcp_sack_new_ofo_skb(struct sock *sk, u32 seq, u32 end_seq)
 	 */
 	if (this_sack >= TCP_NUM_SACKS) {
 		if (tp->compressed_ack > TCP_FASTRETRANS_THRESH)
-			tcp_send_ack(sk);
+			tcp_send_ack(sk, 0);
 		this_sack--;
 		tp->rx_opt.num_sacks--;
 		sp--;
@@ -5331,7 +5331,7 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 	    /* Protocol state mandates a one-time immediate ACK */
 	    inet_csk(sk)->icsk_ack.pending & ICSK_ACK_NOW) {
 send_now:
-		tcp_send_ack(sk);
+		tcp_send_ack(sk, 0);
 		return;
 	}
 
@@ -6126,7 +6126,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 			tcp_drop(sk, skb);
 			return 0;
 		} else {
-			tcp_send_ack(sk);
+			tcp_send_ack(sk, 0);
 		}
 		return -1;
 	}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a1414d1a8ef1..c8d0a7baf2d4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3741,7 +3741,7 @@ void tcp_send_delayed_ack(struct sock *sk)
 		 */
 		if (icsk->icsk_ack.blocked ||
 		    time_before_eq(icsk->icsk_ack.timeout, jiffies + (ato >> 2))) {
-			tcp_send_ack(sk);
+			tcp_send_ack(sk, 0);
 			return;
 		}
 
@@ -3754,7 +3754,7 @@ void tcp_send_delayed_ack(struct sock *sk)
 }
 
 /* This routine sends an ack and also updates the window. */
-void __tcp_send_ack(struct sock *sk, u32 rcv_nxt)
+void __tcp_send_ack(struct sock *sk, u32 rcv_nxt, u16 flags)
 {
 	struct sk_buff *buff;
 
@@ -3778,7 +3778,7 @@ void __tcp_send_ack(struct sock *sk, u32 rcv_nxt)
 
 	/* Reserve space for headers and prepare control bits. */
 	skb_reserve(buff, MAX_TCP_HEADER);
-	tcp_init_nondata_skb(buff, tcp_acceptable_seq(sk), TCPHDR_ACK);
+	tcp_init_nondata_skb(buff, tcp_acceptable_seq(sk), TCPHDR_ACK | flags);
 
 	/* We do not want pure acks influencing TCP Small Queues or fq/pacing
 	 * too much.
@@ -3791,9 +3791,9 @@ void __tcp_send_ack(struct sock *sk, u32 rcv_nxt)
 }
 EXPORT_SYMBOL_GPL(__tcp_send_ack);
 
-void tcp_send_ack(struct sock *sk)
+void tcp_send_ack(struct sock *sk, u16 flags)
 {
-	__tcp_send_ack(sk, tcp_sk(sk)->rcv_nxt);
+	__tcp_send_ack(sk, tcp_sk(sk)->rcv_nxt, flags);
 }
 
 /* This routine sends a packet with an out of date sequence
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index c3f26dcd6704..f37289216d37 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -302,7 +302,7 @@ void tcp_delack_timer_handler(struct sock *sk)
 			icsk->icsk_ack.ato      = TCP_ATO_MIN;
 		}
 		tcp_mstamp_refresh(tcp_sk(sk));
-		tcp_send_ack(sk);
+		tcp_send_ack(sk, 0);
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKS);
 	}
 
@@ -754,7 +754,7 @@ static enum hrtimer_restart tcp_compressed_ack_kick(struct hrtimer *timer)
 	bh_lock_sock(sk);
 	if (!sock_owned_by_user(sk)) {
 		if (tp->compressed_ack > TCP_FASTRETRANS_THRESH)
-			tcp_send_ack(sk);
+			tcp_send_ack(sk, 0);
 	} else {
 		if (!test_and_set_bit(TCP_DELACK_TIMER_DEFERRED,
 				      &sk->sk_tsq_flags))
-- 
2.20.1

