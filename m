Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A454B207A21
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405493AbgFXRTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405486AbgFXRTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:19:43 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE02C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:42 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id h22so1421788pjf.1
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2OQX8d52ytdpe1I2jFepdSnY7MQ3IgjSgV7EDnS0Lvk=;
        b=gmhtc1+MV80WWG0qj3axJDEtLOorRgPozciZiqL3nxVjJaIMql+Ed5k4JxwLkez+jX
         /r8IZk7SIhmCggN+pk0x7s0nt0nzjW83K9nzKuq+M0DNR2exUew/QAc3P/AmuBR/RuVZ
         5/1cueb+Iv1vrdi2dQUYRVRVWHeWupsC/2+G3jVCuJ85yT2iQsltRD3/+5HQceix75bx
         Cl85qB7jmQbjBppmOHynl90RGjmiPYbSq7dcZk2opNRP/lv3FfVWHgMXqqdWVwUQnJ6F
         hMdwbo2k+EtjfhUQaKaMNHCgPfO/PvBxnqkZYPAOC60Kp6HV9wCcm0hEb0U3tqUKPHLE
         AtyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2OQX8d52ytdpe1I2jFepdSnY7MQ3IgjSgV7EDnS0Lvk=;
        b=NEbWIThuyvgqSqpEeqxLv0OxedYYIASq71lAhJcxeOCrOlg9AaoMWoMjbu61y4ETYo
         wB0WST2jR5Jidudu6dKsnTnINpOJfL2tkNDeYvlZUnZubLj6jejeJKVGarKdssrZ8iFz
         lEeEktCdFPUouUWib1wYuvA8t74tzLHdY5f1X3YwUR/e2AEBFjijDcdWoaW9tUtx0FCV
         IzAaPUSX68MEaE7DwN/B40c/iPeoIwRthqma7YP8i/SgB0wDqnLJ2pP7r43/JEPulQN8
         ciQnIJXjxIYQkwhu9ZwIUv96PqmI+JQWiirlLL7KhbkX4sRmU0tSAqye3XQYcQ4E2A87
         ikZg==
X-Gm-Message-State: AOAM530oUawO+eeHwdYg6O3pWoLNmrjcio4h6LIulxYXUbzFOOx74wN6
        5kmpKkF5KZlJnAKcCiENpc7fWzerwtg=
X-Google-Smtp-Source: ABdhPJxBY+EJ+1WlNxRYRcW9/DQ3X+LXUb6EKTotiex2pfRuujuWNtWYlvu87p0OHHBbXwPm70hnbQ==
X-Received: by 2002:a17:902:ab98:: with SMTP id f24mr30802753plr.154.1593019181924;
        Wed, 24 Jun 2020 10:19:41 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id w18sm17490241pgj.31.2020.06.24.10.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:19:41 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH 09/11] ptq: Hook up transmit side of Per Queue Threads
Date:   Wed, 24 Jun 2020 10:17:48 -0700
Message-Id: <20200624171749.11927-10-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624171749.11927-1-tom@herbertland.com>
References: <20200624171749.11927-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support to select device queue for transmit based on the per thread
transmit queue.

Patch includes:
	- Add a global queue (gqid) mapping to sock
	- Function to convert gqid in a sock to a device queue (dqid) by
	  calling sk_tx_gqid_to_dqid_get
	- Function sock_record_tx_queue to record a queue in a socket
	  taken from ptq_threads in struct task
	- Call sock_record_tx_queue from af_inet send, listen, and accept
	  functions to populate the socket's gqid for steerig
	- In netdev_pick_tx try to take the queue index from the socket
	  using sk_tx_gqid_to_dqid_get
---
 include/net/sock.h | 63 ++++++++++++++++++++++++++++++++++++++++++++++
 net/core/dev.c     |  9 ++++---
 net/ipv4/af_inet.c |  6 +++++
 3 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index acb76cfaae1b..5ec9d02e7ad0 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -140,6 +140,7 @@ typedef __u64 __bitwise __addrpair;
  *	@skc_node: main hash linkage for various protocol lookup tables
  *	@skc_nulls_node: main hash linkage for TCP/UDP/UDP-Lite protocol
  *	@skc_tx_queue_mapping: tx queue number for this connection
+ *	@skc_tx_gqid_mapping: global tx queue number for sending
  *	@skc_rx_queue_mapping: rx queue number for this connection
  *	@skc_flags: place holder for sk_flags
  *		%SO_LINGER (l_onoff), %SO_BROADCAST, %SO_KEEPALIVE,
@@ -225,6 +226,9 @@ struct sock_common {
 		struct hlist_nulls_node skc_nulls_node;
 	};
 	unsigned short		skc_tx_queue_mapping;
+#ifdef CONFIG_RPS
+	unsigned short		skc_tx_gqid_mapping;
+#endif
 #ifdef CONFIG_XPS
 	unsigned short		skc_rx_queue_mapping;
 #endif
@@ -353,6 +357,9 @@ struct sock {
 #define sk_nulls_node		__sk_common.skc_nulls_node
 #define sk_refcnt		__sk_common.skc_refcnt
 #define sk_tx_queue_mapping	__sk_common.skc_tx_queue_mapping
+#ifdef CONFIG_RPS
+#define sk_tx_gqid_mapping	__sk_common.skc_tx_gqid_mapping
+#endif
 #ifdef CONFIG_XPS
 #define sk_rx_queue_mapping	__sk_common.skc_rx_queue_mapping
 #endif
@@ -1792,6 +1799,34 @@ static inline int sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 	return __sk_receive_skb(sk, skb, nested, 1, true);
 }
 
+static inline int sk_tx_gqid_get(const struct sock *sk)
+{
+#ifdef CONFIG_RPS
+	if (sk && sk->sk_tx_gqid_mapping != NO_QUEUE)
+		return sk->sk_tx_gqid_mapping;
+#endif
+
+	return -1;
+}
+
+static inline void sk_tx_gqid_set(struct sock *sk, int gqid)
+{
+#ifdef CONFIG_RPS
+	/* sk_tx_queue_mapping accept only up to RPS_MAX_QID (0x7ffe) */
+	if (WARN_ON_ONCE((unsigned int)gqid > RPS_MAX_QID &&
+			 gqid != NO_QUEUE))
+		return;
+	sk->sk_tx_gqid_mapping = gqid;
+#endif
+}
+
+static inline void sk_tx_gqid_clear(struct sock *sk)
+{
+#ifdef CONFIG_RPS
+	sk->sk_tx_gqid_mapping = NO_QUEUE;
+#endif
+}
+
 static inline void sk_tx_queue_set(struct sock *sk, int tx_queue)
 {
 	/* sk_tx_queue_mapping accept only upto a 16-bit value */
@@ -1803,6 +1838,9 @@ static inline void sk_tx_queue_set(struct sock *sk, int tx_queue)
 static inline void sk_tx_queue_clear(struct sock *sk)
 {
 	sk->sk_tx_queue_mapping = NO_QUEUE;
+
+	/* Clear tx_gqid at same points */
+	sk_tx_gqid_clear(sk);
 }
 
 static inline int sk_tx_queue_get(const struct sock *sk)
@@ -1813,6 +1851,31 @@ static inline int sk_tx_queue_get(const struct sock *sk)
 	return -1;
 }
 
+static inline int sk_tx_gqid_to_dqid_get(const struct net_device *dev,
+					 const struct sock *sk)
+{
+	int ret = -1;
+#ifdef CONFIG_RPS
+	int gqid;
+	u16 dqid;
+
+	gqid = sk_tx_gqid_get(sk);
+	if (gqid >= 0) {
+		dqid = netdev_tx_gqid_to_dqid(dev, gqid);
+		if (dqid != NO_QUEUE)
+			ret = dqid;
+	}
+#endif
+	return ret;
+}
+
+static inline void sock_record_tx_queue(struct sock *sk)
+{
+#ifdef CONFIG_PER_THREAD_QUEUES
+	sk_tx_gqid_set(sk, current->ptq_queues.txq_id);
+#endif
+}
+
 static inline void sk_rx_queue_set(struct sock *sk, const struct sk_buff *skb)
 {
 #ifdef CONFIG_XPS
diff --git a/net/core/dev.c b/net/core/dev.c
index f64bf6608775..f4478c9b1c9c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3982,10 +3982,13 @@ u16 netdev_pick_tx(struct net_device *dev, struct sk_buff *skb,
 
 	if (queue_index < 0 || skb->ooo_okay ||
 	    queue_index >= dev->real_num_tx_queues) {
-		int new_index = get_xps_queue(dev, sb_dev, skb);
+		int new_index = sk_tx_gqid_to_dqid_get(dev, sk);
 
-		if (new_index < 0)
-			new_index = skb_tx_hash(dev, sb_dev, skb);
+		if (new_index < 0) {
+			new_index = get_xps_queue(dev, sb_dev, skb);
+			if (new_index < 0)
+				new_index = skb_tx_hash(dev, sb_dev, skb);
+		}
 
 		if (queue_index != new_index && sk &&
 		    sk_fullsock(sk) &&
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 02aa5cb3a4fd..9b36aa3d1622 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -201,6 +201,8 @@ int inet_listen(struct socket *sock, int backlog)
 
 	lock_sock(sk);
 
+	sock_record_tx_queue(sk);
+
 	err = -EINVAL;
 	if (sock->state != SS_UNCONNECTED || sock->type != SOCK_STREAM)
 		goto out;
@@ -630,6 +632,8 @@ int __inet_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 		}
 	}
 
+	sock_record_tx_queue(sk);
+
 	switch (sock->state) {
 	default:
 		err = -EINVAL;
@@ -742,6 +746,7 @@ int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 	lock_sock(sk2);
 
 	sock_rps_record_flow(sk2);
+	sock_record_tx_queue(sk2);
 	WARN_ON(!((1 << sk2->sk_state) &
 		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
 		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));
@@ -794,6 +799,7 @@ EXPORT_SYMBOL(inet_getname);
 int inet_send_prepare(struct sock *sk)
 {
 	sock_rps_record_flow(sk);
+	sock_record_tx_queue(sk);
 
 	/* We may need to bind the socket. */
 	if (!inet_sk(sk)->inet_num && !sk->sk_prot->no_autobind &&
-- 
2.25.1

