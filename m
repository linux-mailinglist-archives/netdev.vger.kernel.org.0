Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54D3338775
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 09:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhCLIdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 03:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbhCLIdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 03:33:32 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E6AC061574;
        Fri, 12 Mar 2021 00:33:32 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 30so7032584ple.4;
        Fri, 12 Mar 2021 00:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kHe01k//eozg7NUQ6QVWsH0/MiPE4848fzfxFIaTxI0=;
        b=inoZpaSXefWJVTO9F+RRUxa6lAOwBPOXSxgInUhasIEbHnYntARL2tajVe8SwvE62d
         3chXyGt4mUldMIUqqiU84rJPboeRb5rkJ6TqHbyF06Jb0Iw+7ZURYw2KDYye3N2irhnF
         vNRA5clVwF+Ifz6vJl4+wTMZVGqyzukV7JYzsOzcOxDHFdmWT27MNSaQVoc8h4DC1eSP
         BbQ4SY/vno2KviP6cuDpkewsG/LfEtn2xOYXiBMYemgA76+lbKfOG7nM7j0Uwc/YcuEg
         cMYZPwCP4YNDKkDXNSoyY+1gZoBXjtanJ9jhA88Jv1ocDE3obagPnRwIMM6bOHWSbEdb
         1byw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kHe01k//eozg7NUQ6QVWsH0/MiPE4848fzfxFIaTxI0=;
        b=tWOqRs7vJDdj4ySH9N8W+EqnWnz4L4UecXKl/+2o9He9MpWhyfgIFKTS2GNo08J3I4
         yPTHnfQ3IsmeBd579NT75n/ymheL2FnTNSn8UxZ0fvOQ/VU5KbOjjkJZwQ/zTTcsK7tT
         3/3mT+rBh+M/djj6ROWskV26qiG2tDcDsEHZX2cVResOA9aC8PChF4r4589U+efa/1MQ
         R8m2UKTiDUXDxKmCtMhjPcSBbJGsvoZpraqJeEVrWrpxZZpTVZDwkmnlGy30DmuQgwsj
         xi58VJldpWFatctz594lvMZHRVWvhJIrzmmHbpnFtgmGaHiB7bNS0QuaiKH9R6Ccmhx6
         kDew==
X-Gm-Message-State: AOAM533LhORQdWfqysmx4POq2ujPdev+otlh8EO2hRV46H2B3ni+LhOo
        RmDtrNU3sKXB6GhkwTW8uZc=
X-Google-Smtp-Source: ABdhPJzqpUe2M5lXLkQCd42YT3pk/CVPyV1ZqXfTa9KL5Yr4hgUPf6WaguvvZ65AvsmnyE64jZZ7qg==
X-Received: by 2002:a17:903:1cb:b029:e5:f712:c13c with SMTP id e11-20020a17090301cbb02900e5f712c13cmr12286120plh.22.1615538011929;
        Fri, 12 Mar 2021 00:33:31 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5186:d796:2218:6442])
        by smtp.gmail.com with ESMTPSA id w1sm4258173pgs.15.2021.03.12.00.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 00:33:31 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 4.19-stable 1/3] tcp: annotate tp->copied_seq lockless reads
Date:   Fri, 12 Mar 2021 00:33:21 -0800
Message-Id: <20210312083323.3720479-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7db48e983930285b765743ebd665aecf9850582b ]

There are few places where we fetch tp->copied_seq while
this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make
sure write sides use corresponding WRITE_ONCE() to avoid
store-tearing.

Note that tcp_inq_hint() was already using READ_ONCE(tp->copied_seq)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp.c           | 18 +++++++++---------
 net/ipv4/tcp_diag.c      |  3 ++-
 net/ipv4/tcp_input.c     |  6 +++---
 net/ipv4/tcp_ipv4.c      |  2 +-
 net/ipv4/tcp_minisocks.c |  2 +-
 net/ipv4/tcp_output.c    |  2 +-
 net/ipv6/tcp_ipv6.c      |  2 +-
 7 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 98e8ee8bb7593a30442c2e8d9694424c818840ed..f639c7d6083821c8725f5e28312eff3cbfa82e54 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -567,7 +567,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	    (state != TCP_SYN_RECV || tp->fastopen_rsk)) {
 		int target = sock_rcvlowat(sk, 0, INT_MAX);
 
-		if (tp->urg_seq == tp->copied_seq &&
+		if (tp->urg_seq == READ_ONCE(tp->copied_seq) &&
 		    !sock_flag(sk, SOCK_URGINLINE) &&
 		    tp->urg_data)
 			target++;
@@ -628,7 +628,7 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		unlock_sock_fast(sk, slow);
 		break;
 	case SIOCATMARK:
-		answ = tp->urg_data && tp->urg_seq == tp->copied_seq;
+		answ = tp->urg_data && tp->urg_seq == READ_ONCE(tp->copied_seq);
 		break;
 	case SIOCOUTQ:
 		if (sk->sk_state == TCP_LISTEN)
@@ -1696,9 +1696,9 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		sk_eat_skb(sk, skb);
 		if (!desc->count)
 			break;
-		tp->copied_seq = seq;
+		WRITE_ONCE(tp->copied_seq, seq);
 	}
-	tp->copied_seq = seq;
+	WRITE_ONCE(tp->copied_seq, seq);
 
 	tcp_rcv_space_adjust(sk);
 
@@ -1835,7 +1835,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 out:
 	up_read(&current->mm->mmap_sem);
 	if (length) {
-		tp->copied_seq = seq;
+		WRITE_ONCE(tp->copied_seq, seq);
 		tcp_rcv_space_adjust(sk);
 
 		/* Clean up data we have read: This will do ACK frames. */
@@ -2112,7 +2112,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 			if (urg_offset < used) {
 				if (!urg_offset) {
 					if (!sock_flag(sk, SOCK_URGINLINE)) {
-						++*seq;
+						WRITE_ONCE(*seq, *seq + 1);
 						urg_hole++;
 						offset++;
 						used--;
@@ -2134,7 +2134,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 			}
 		}
 
-		*seq += used;
+		WRITE_ONCE(*seq, *seq + used);
 		copied += used;
 		len -= used;
 
@@ -2163,7 +2163,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 
 	found_fin_ok:
 		/* Process the FIN. */
-		++*seq;
+		WRITE_ONCE(*seq, *seq + 1);
 		if (!(flags & MSG_PEEK))
 			sk_eat_skb(sk, skb);
 		break;
@@ -2578,7 +2578,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 
 	tcp_clear_xmit_timers(sk);
 	__skb_queue_purge(&sk->sk_receive_queue);
-	tp->copied_seq = tp->rcv_nxt;
+	WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 	tp->urg_data = 0;
 	tcp_write_queue_purge(sk);
 	tcp_fastopen_active_disable_ofo_check(sk);
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index c9e97f304f984b9339a683c45dea85a84ccba5bf..a96b252c742cb58108123a5ccad15511634dcfc5 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -30,7 +30,8 @@ static void tcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 	} else if (sk->sk_type == SOCK_STREAM) {
 		const struct tcp_sock *tp = tcp_sk(sk);
 
-		r->idiag_rqueue = max_t(int, READ_ONCE(tp->rcv_nxt) - tp->copied_seq, 0);
+		r->idiag_rqueue = max_t(int, READ_ONCE(tp->rcv_nxt) -
+					     READ_ONCE(tp->copied_seq), 0);
 		r->idiag_wqueue = tp->write_seq - tp->snd_una;
 	}
 	if (info)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5ffc85c8952a04905af7e560ce83135e73980bd3..36bff9291530b19539936609f001a6674acc8f72 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5889,7 +5889,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		/* Remember, tcp_poll() does not lock socket!
 		 * Change state from SYN-SENT only after copied_seq
 		 * is initialized. */
-		tp->copied_seq = tp->rcv_nxt;
+		WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 
 		smc_check_reset_syn(tp);
 
@@ -5964,7 +5964,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		}
 
 		WRITE_ONCE(tp->rcv_nxt, TCP_SKB_CB(skb)->seq + 1);
-		tp->copied_seq = tp->rcv_nxt;
+		WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 		tp->rcv_wup = TCP_SKB_CB(skb)->seq + 1;
 
 		/* RFC1323: The window in SYN & SYN/ACK segments is
@@ -6126,7 +6126,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			tcp_rearm_rto(sk);
 		} else {
 			tcp_init_transfer(sk, BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB);
-			tp->copied_seq = tp->rcv_nxt;
+			WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 		}
 		smp_mb();
 		tcp_set_state(sk, TCP_ESTABLISHED);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7536f4c0bbf4f4b9ff60be4e4c83bca71945382b..627b5fb1eac8ecf808ea33d2994198b4551f3fc9 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2340,7 +2340,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 		 * we might find a transient negative value.
 		 */
 		rx_queue = max_t(int, READ_ONCE(tp->rcv_nxt) -
-				      tp->copied_seq, 0);
+				      READ_ONCE(tp->copied_seq), 0);
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
 			"%08X %5u %8d %lu %d %pK %lu %lu %u %u %d",
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 7ba8a90772b0a631e9d6af29699f99039fbce705..0b1a04fa54392fdb3325d45fd1d5e0aaa3170b6c 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -470,7 +470,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 
 	seq = treq->rcv_isn + 1;
 	newtp->rcv_wup = seq;
-	newtp->copied_seq = seq;
+	WRITE_ONCE(newtp->copied_seq, seq);
 	WRITE_ONCE(newtp->rcv_nxt, seq);
 	newtp->segs_in = 1;
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 3cfefec819758989c225b131d845ad1e76552ea7..662aa48173b8197e006127e4d84fb2c1961836a4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3381,7 +3381,7 @@ static void tcp_connect_init(struct sock *sk)
 	else
 		tp->rcv_tstamp = tcp_jiffies32;
 	tp->rcv_wup = tp->rcv_nxt;
-	tp->copied_seq = tp->rcv_nxt;
+	WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 
 	inet_csk(sk)->icsk_rto = tcp_timeout_init(sk);
 	inet_csk(sk)->icsk_retransmits = 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 2e76ebfdc907dde33475310b42fac7fd56eee3a8..de9b9c0bf18f721f44d7ee0e4eec74c0b5576947 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1839,7 +1839,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 		 * we might find a transient negative value.
 		 */
 		rx_queue = max_t(int, READ_ONCE(tp->rcv_nxt) -
-				      tp->copied_seq, 0);
+				      READ_ONCE(tp->copied_seq), 0);
 
 	seq_printf(seq,
 		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-- 
2.31.0.rc2.261.g7f71774620-goog

