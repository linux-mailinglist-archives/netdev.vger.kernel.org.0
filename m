Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F2246E4CB
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbhLIJGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:06:35 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:35273 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235471AbhLIJGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 04:06:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V-2Ao2r_1639040578;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V-2Ao2r_1639040578)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Dec 2021 17:02:58 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next 1/2] bpf: Use switch statement in _bpf_setsockopt
Date:   Thu,  9 Dec 2021 17:02:50 +0800
Message-Id: <20211209090250.73927-2-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209090250.73927-1-tonylu@linux.alibaba.com>
References: <20211209090250.73927-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces if with switch statement in _bpf_setsockopt() to make it
easy to extend more options.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Qiao Ma <mqaio@linux.alibaba.com>
---
 net/core/filter.c | 164 ++++++++++++++++++++++++----------------------
 1 file changed, 84 insertions(+), 80 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index fe27c91e3758..1e6b68ff13db 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4857,95 +4857,99 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 #endif
 	} else if (level == SOL_TCP &&
 		   sk->sk_prot->setsockopt == tcp_setsockopt) {
-		if (optname == TCP_CONGESTION) {
+		struct inet_connection_sock *icsk = inet_csk(sk);
+		struct tcp_sock *tp = tcp_sk(sk);
+		unsigned long timeout;
+
+		switch (optname) {
+		case TCP_CONGESTION: {
 			char name[TCP_CA_NAME_MAX];
 
 			strncpy(name, optval, min_t(long, optlen,
 						    TCP_CA_NAME_MAX-1));
 			name[TCP_CA_NAME_MAX-1] = 0;
-			ret = tcp_set_congestion_control(sk, name, false, true);
-		} else {
-			struct inet_connection_sock *icsk = inet_csk(sk);
-			struct tcp_sock *tp = tcp_sk(sk);
-			unsigned long timeout;
+			return tcp_set_congestion_control(sk, name, false, true);
+		}
+		default:
+			break;
+		}
 
-			if (optlen != sizeof(int))
-				return -EINVAL;
+		if (optlen != sizeof(int))
+			return -EINVAL;
 
-			val = *((int *)optval);
-			/* Only some options are supported */
-			switch (optname) {
-			case TCP_BPF_IW:
-				if (val <= 0 || tp->data_segs_out > tp->syn_data)
-					ret = -EINVAL;
-				else
-					tp->snd_cwnd = val;
-				break;
-			case TCP_BPF_SNDCWND_CLAMP:
-				if (val <= 0) {
-					ret = -EINVAL;
-				} else {
-					tp->snd_cwnd_clamp = val;
-					tp->snd_ssthresh = val;
-				}
-				break;
-			case TCP_BPF_DELACK_MAX:
-				timeout = usecs_to_jiffies(val);
-				if (timeout > TCP_DELACK_MAX ||
-				    timeout < TCP_TIMEOUT_MIN)
-					return -EINVAL;
-				inet_csk(sk)->icsk_delack_max = timeout;
-				break;
-			case TCP_BPF_RTO_MIN:
-				timeout = usecs_to_jiffies(val);
-				if (timeout > TCP_RTO_MIN ||
-				    timeout < TCP_TIMEOUT_MIN)
-					return -EINVAL;
-				inet_csk(sk)->icsk_rto_min = timeout;
-				break;
-			case TCP_SAVE_SYN:
-				if (val < 0 || val > 1)
-					ret = -EINVAL;
-				else
-					tp->save_syn = val;
-				break;
-			case TCP_KEEPIDLE:
-				ret = tcp_sock_set_keepidle_locked(sk, val);
-				break;
-			case TCP_KEEPINTVL:
-				if (val < 1 || val > MAX_TCP_KEEPINTVL)
-					ret = -EINVAL;
-				else
-					tp->keepalive_intvl = val * HZ;
-				break;
-			case TCP_KEEPCNT:
-				if (val < 1 || val > MAX_TCP_KEEPCNT)
-					ret = -EINVAL;
-				else
-					tp->keepalive_probes = val;
-				break;
-			case TCP_SYNCNT:
-				if (val < 1 || val > MAX_TCP_SYNCNT)
-					ret = -EINVAL;
-				else
-					icsk->icsk_syn_retries = val;
-				break;
-			case TCP_USER_TIMEOUT:
-				if (val < 0)
-					ret = -EINVAL;
-				else
-					icsk->icsk_user_timeout = val;
-				break;
-			case TCP_NOTSENT_LOWAT:
-				tp->notsent_lowat = val;
-				sk->sk_write_space(sk);
-				break;
-			case TCP_WINDOW_CLAMP:
-				ret = tcp_set_window_clamp(sk, val);
-				break;
-			default:
+		val = *((int *)optval);
+		/* Only some options are supported */
+		switch (optname) {
+		case TCP_BPF_IW:
+			if (val <= 0 || tp->data_segs_out > tp->syn_data)
+				ret = -EINVAL;
+			else
+				tp->snd_cwnd = val;
+			break;
+		case TCP_BPF_SNDCWND_CLAMP:
+			if (val <= 0) {
 				ret = -EINVAL;
+			} else {
+				tp->snd_cwnd_clamp = val;
+				tp->snd_ssthresh = val;
 			}
+			break;
+		case TCP_BPF_DELACK_MAX:
+			timeout = usecs_to_jiffies(val);
+			if (timeout > TCP_DELACK_MAX ||
+			    timeout < TCP_TIMEOUT_MIN)
+				return -EINVAL;
+			inet_csk(sk)->icsk_delack_max = timeout;
+			break;
+		case TCP_BPF_RTO_MIN:
+			timeout = usecs_to_jiffies(val);
+			if (timeout > TCP_RTO_MIN ||
+			    timeout < TCP_TIMEOUT_MIN)
+				return -EINVAL;
+			inet_csk(sk)->icsk_rto_min = timeout;
+			break;
+		case TCP_SAVE_SYN:
+			if (val < 0 || val > 1)
+				ret = -EINVAL;
+			else
+				tp->save_syn = val;
+			break;
+		case TCP_KEEPIDLE:
+			ret = tcp_sock_set_keepidle_locked(sk, val);
+			break;
+		case TCP_KEEPINTVL:
+			if (val < 1 || val > MAX_TCP_KEEPINTVL)
+				ret = -EINVAL;
+			else
+				tp->keepalive_intvl = val * HZ;
+			break;
+		case TCP_KEEPCNT:
+			if (val < 1 || val > MAX_TCP_KEEPCNT)
+				ret = -EINVAL;
+			else
+				tp->keepalive_probes = val;
+			break;
+		case TCP_SYNCNT:
+			if (val < 1 || val > MAX_TCP_SYNCNT)
+				ret = -EINVAL;
+			else
+				icsk->icsk_syn_retries = val;
+			break;
+		case TCP_USER_TIMEOUT:
+			if (val < 0)
+				ret = -EINVAL;
+			else
+				icsk->icsk_user_timeout = val;
+			break;
+		case TCP_NOTSENT_LOWAT:
+			tp->notsent_lowat = val;
+			sk->sk_write_space(sk);
+			break;
+		case TCP_WINDOW_CLAMP:
+			ret = tcp_set_window_clamp(sk, val);
+			break;
+		default:
+			ret = -EINVAL;
 		}
 #endif
 	} else {
-- 
2.32.0.3.g01195cf9f

