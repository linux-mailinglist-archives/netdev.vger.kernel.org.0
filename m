Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC198D37CF
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfJKDSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:18:17 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:47233 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfJKDSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:18:17 -0400
Received: by mail-pf1-f201.google.com with SMTP id t65so6372403pfd.14
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DR6p6pPBsMy/n4W/A3CTmQlW/665jTAxhgTq8IyUH9I=;
        b=dbBRba3A3c5ownJNZyupqZqev6GU77ga9wp7BAyhVzysbLSI1sFI5KApKONb1U+V2S
         tNEVJRWKj92VbJ5kFrmfCxeNHk3HRlWuQqi/b8vgfecF8wmb1xiRw+DbDl5vfHLpgU/v
         m2eOMZyHD9/pJdzaggmHTwAxh7ZETSFfe7uonNb0XQrsniWE3futnyBkguQ4XAhRQizc
         +MjsEFQRdWebHthRxovmDQ8MYr3xvyvLND4n1G6xem8noGpuF3ZhijhDJy/jzWq4stQv
         AUJyHvhJg2yEHGSmwwVV7idgrRyONUMB/DOLgUV0eN6yCvjLUsAWDpdlvR09RmmzHmnX
         X/ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DR6p6pPBsMy/n4W/A3CTmQlW/665jTAxhgTq8IyUH9I=;
        b=AWkmLaX8/fJGiAqyP3UVbMeNCbQdj0PFPvureOlo3e2sbLYjhc47mskjVL5yqChkrI
         uRCp5VDuhMjBDJ9AFfmCgCi8e33h1iNVZ0vX0lcdKC+gFbFoGtNMk+0DxrD3fbLve7lK
         B6sxR/3DAg1bd5OLxVE5ZcWkXgxq1aD63WbzEvuB5dlQCmLdzmRC6n/4VRp9DqlH9tzl
         0bd5qrc/lueJPg+Z5nlxcfcV7vp2eMxxyvh9iEPiFnVn0oUHhYFfnhKjDpOK2eROoJj9
         pJgHgbp16tkFfghQBahXOUtfvojZyvn61m7Ta19dQEP1D1XQNdkA2ZQxNdzhq2m7JvB3
         Rivg==
X-Gm-Message-State: APjAAAUKDB3HThflvkpMC7Zq5B36hi1iV5mkuh+OOtj3V8P6qV41I3t/
        2K9f0du+CgF8gaNzPyBFbhJQMOvkorfRkA==
X-Google-Smtp-Source: APXvYqztrVxexrTm6hwIUZq4FLG0kxH8WQIoQ/TT0rZcNxxI5Y61LjLCWPUZS3TRPmPETt4HacT+NJ96UO3H8A==
X-Received: by 2002:a63:ec18:: with SMTP id j24mr13094623pgh.99.1570763896673;
 Thu, 10 Oct 2019 20:18:16 -0700 (PDT)
Date:   Thu, 10 Oct 2019 20:17:42 -0700
In-Reply-To: <20191011031746.16220-1-edumazet@google.com>
Message-Id: <20191011031746.16220-6-edumazet@google.com>
Mime-Version: 1.0
References: <20191011031746.16220-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net 5/9] tcp: annotate tp->snd_nxt lockless reads
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are few places where we fetch tp->snd_nxt while
this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make
sure write sides use corresponding WRITE_ONCE() to avoid
store-tearing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h        |  3 ++-
 net/ipv4/tcp.c           |  3 ++-
 net/ipv4/tcp_minisocks.c |  6 ++++--
 net/ipv4/tcp_output.c    | 10 +++++-----
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 8e7c3f6801a935c2ef4c76e7e3790ce39adcf5cb..e1d08f69fd39f7c06c246a6f871400ad4cda6aed 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1917,7 +1917,8 @@ static inline u32 tcp_notsent_lowat(const struct tcp_sock *tp)
 static inline bool tcp_stream_memory_free(const struct sock *sk, int wake)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
-	u32 notsent_bytes = READ_ONCE(tp->write_seq) - tp->snd_nxt;
+	u32 notsent_bytes = READ_ONCE(tp->write_seq) -
+			    READ_ONCE(tp->snd_nxt);
 
 	return (notsent_bytes << wake) < tcp_notsent_lowat(tp);
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 96dd65cbeb85732cb14dd30b73b97c9aca4e26c3..652568750cb17268509efc83bfa4bae0a23be83d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -625,7 +625,8 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
 			answ = 0;
 		else
-			answ = READ_ONCE(tp->write_seq) - tp->snd_nxt;
+			answ = READ_ONCE(tp->write_seq) -
+			       READ_ONCE(tp->snd_nxt);
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 33994469032936bc1ff36bc95bf22fba7cdfa180..c802bc80c4006f82c2e9189ef1fc11b8f321e70d 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -482,8 +482,10 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	WRITE_ONCE(newtp->rcv_nxt, seq);
 	newtp->segs_in = 1;
 
-	newtp->snd_sml = newtp->snd_una =
-	newtp->snd_nxt = newtp->snd_up = treq->snt_isn + 1;
+	seq = treq->snt_isn + 1;
+	newtp->snd_sml = newtp->snd_una = seq;
+	WRITE_ONCE(newtp->snd_nxt, seq);
+	newtp->snd_up = seq;
 
 	INIT_LIST_HEAD(&newtp->tsq_node);
 	INIT_LIST_HEAD(&newtp->tsorted_sent_queue);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c17c2a78809d3daf9a5b44ffe1fa286582729273..a115a991dfb5b36c5b3dafd8c9ad94d07685f3a0 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -67,7 +67,7 @@ static void tcp_event_new_data_sent(struct sock *sk, struct sk_buff *skb)
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int prior_packets = tp->packets_out;
 
-	tp->snd_nxt = TCP_SKB_CB(skb)->end_seq;
+	WRITE_ONCE(tp->snd_nxt, TCP_SKB_CB(skb)->end_seq);
 
 	__skb_unlink(skb, &sk->sk_write_queue);
 	tcp_rbtree_insert(&sk->tcp_rtx_queue, skb);
@@ -3142,7 +3142,7 @@ void tcp_send_fin(struct sock *sk)
 			 * if FIN had been sent. This is because retransmit path
 			 * does not change tp->snd_nxt.
 			 */
-			tp->snd_nxt++;
+			WRITE_ONCE(tp->snd_nxt, tp->snd_nxt + 1);
 			return;
 		}
 	} else {
@@ -3426,7 +3426,7 @@ static void tcp_connect_init(struct sock *sk)
 	tp->snd_una = tp->write_seq;
 	tp->snd_sml = tp->write_seq;
 	tp->snd_up = tp->write_seq;
-	tp->snd_nxt = tp->write_seq;
+	WRITE_ONCE(tp->snd_nxt, tp->write_seq);
 
 	if (likely(!tp->repair))
 		tp->rcv_nxt = 0;
@@ -3586,11 +3586,11 @@ int tcp_connect(struct sock *sk)
 	/* We change tp->snd_nxt after the tcp_transmit_skb() call
 	 * in order to make this packet get counted in tcpOutSegs.
 	 */
-	tp->snd_nxt = tp->write_seq;
+	WRITE_ONCE(tp->snd_nxt, tp->write_seq);
 	tp->pushed_seq = tp->write_seq;
 	buff = tcp_send_head(sk);
 	if (unlikely(buff)) {
-		tp->snd_nxt	= TCP_SKB_CB(buff)->seq;
+		WRITE_ONCE(tp->snd_nxt, TCP_SKB_CB(buff)->seq);
 		tp->pushed_seq	= TCP_SKB_CB(buff)->seq;
 	}
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_ACTIVEOPENS);
-- 
2.23.0.700.g56cf767bdb-goog

