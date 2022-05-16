Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BA7527C89
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbiEPDrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239861AbiEPDqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:46:43 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97AA35DED;
        Sun, 15 May 2022 20:46:07 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id o13-20020a17090a9f8d00b001df3fc52ea7so2229113pjp.3;
        Sun, 15 May 2022 20:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eeSAfRyNvnP/TdQc5OMyFSo01wW4QwMt+0XEbCl9m0E=;
        b=YfTjVboom9TrBWNfo/rDEYbjnSrvXbHcAHzZOCfUCk92xf0IUP789Qb66C1vEhyhaR
         D/ak42L9grxe3wqLQbkTuUp2iqb8ZIPBWYFPVLysjR8gzH8nBRvMwCjiwoIflgVKhAtQ
         IFOxXRwlSOmIwcnsY66N8pNBi5USUSsiKFg9cN5ZQRO+fLYoomNl5qLI19GUeKYcSX6A
         cqBAicJXn3X/8pPo8TrhHhkCfKE0MuUtb6hn/lT3ke/awAgEecWzlTug5sCWlOLogXpS
         eDFp8fRr623luU5aPZnS96deTJglRJ6QeE2mrlpfElXS+s+2V7+DZ3bzuUJ/m/cQBDFZ
         WIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eeSAfRyNvnP/TdQc5OMyFSo01wW4QwMt+0XEbCl9m0E=;
        b=MPkiAswmKSTUZ4ZHBz/YXtbsF+cZ+liHZ9ZbzLnYOmDWuyLVMRfZzCcNVhVPuupPQw
         c7pNixtDcLRgjFqa3S6K8ZPm19w+YkGShxnive1Nx/4zzWbpslQZ1xHoVSv8VRnynEUp
         STky9dsDGE/0MItvv2U8rbVgEBa5h+EBHZCweyKFhgqd+FBaG1I2H1oG0jBQP1v2bSIk
         WP5AtUpLBtKRqt1KDQ66Bo3966sOS1PdgCuIF8MKebLCFonUBd8wNRNIftcnF1klp/eO
         SBkDCpmqYDWNIQr6S3kA+SNg+QXVeH6Lc6L1iV0COlZn9c1bznHrh1WQESbl9HGW2AWc
         nJyw==
X-Gm-Message-State: AOAM532WzOPu0JVH/Cu9VUfzQ11iFxO+no+HWUmKOME/8XSjtFpFgXW6
        jleXNCrXafeWU2Xhb3QLRJY=
X-Google-Smtp-Source: ABdhPJwKKPCsLdx8E52HUKI5yp/Jn0UaOs9i4fH0uBx0lYCQwtbaOLKN5BIg6ElgmdgD5jQ9qBc7Fw==
X-Received: by 2002:a17:903:1205:b0:15e:804c:fab4 with SMTP id l5-20020a170903120500b0015e804cfab4mr15976460plh.112.1652672766606;
        Sun, 15 May 2022 20:46:06 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id x184-20020a6286c1000000b0050dc762819bsm5636854pfd.117.2022.05.15.20.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 20:46:06 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 7/9] net: tcp: add skb drop reasons to tcp connect requesting
Date:   Mon, 16 May 2022 11:45:17 +0800
Message-Id: <20220516034519.184876-8-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516034519.184876-1-imagedong@tencent.com>
References: <20220516034519.184876-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In order to get skb drop reasons during tcp connect requesting code path,
we have to pass the pointer of the 'reason' as a new function argument of
conn_request() in 'struct inet_connection_sock_af_ops'. As the return
value of conn_request() can be positive or negative or 0, it's not
flexible to make it return drop reasons.

As the return value of tcp_conn_request() is 0, so we can treat it as bool
and make it return the skb drop reasons.

The new drop reasons 'LISTENOVERFLOWS' and 'TCP_REQQFULLDROP' are added,
which are used for 'accept queue' and 'request queue' full.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h             | 10 ++++++++++
 include/net/inet_connection_sock.h |  3 ++-
 include/net/tcp.h                  |  9 +++++----
 net/dccp/input.c                   |  3 ++-
 net/dccp/ipv4.c                    |  3 ++-
 net/dccp/ipv6.c                    |  3 ++-
 net/ipv4/tcp_input.c               | 27 ++++++++++++++++++---------
 net/ipv4/tcp_ipv4.c                |  9 ++++++---
 net/ipv6/tcp_ipv6.c                | 12 ++++++++----
 net/mptcp/subflow.c                |  6 ++++--
 10 files changed, 59 insertions(+), 26 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 736899cc6a13..4578bbab5a3e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -552,6 +552,14 @@ struct sk_buff;
  * SKB_DROP_REASON_SOCKET_DESTROYED
  *	socket is destroyed and the skb in its receive or send queue
  *	are all dropped
+ *
+ * SKB_DROP_REASON_LISTENOVERFLOWS
+ *	accept queue of the listen socket is full, corresponding to
+ *	LINUX_MIB_LISTENOVERFLOWS
+ *
+ * SKB_DROP_REASON_TCP_REQQFULLDROP
+ *	request queue of the listen socket is full, corresponding to
+ *	LINUX_MIB_TCPREQQFULLDROP
  */
 #define __DEFINE_SKB_DROP_REASON(FN)	\
 	FN(NOT_SPECIFIED)		\
@@ -621,6 +629,8 @@ struct sk_buff;
 	FN(SOCKET_DESTROYED)		\
 	FN(TCP_PAWSACTIVEREJECTED)	\
 	FN(TCP_ABORTONDATA)		\
+	FN(LISTENOVERFLOWS)		\
+	FN(TCP_REQQFULLDROP)		\
 	FN(MAX)
 
 /* The reason of skb drop, which is used in kfree_skb_reason().
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 3908296d103f..0600280f308e 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -36,7 +36,8 @@ struct inet_connection_sock_af_ops {
 	void	    (*send_check)(struct sock *sk, struct sk_buff *skb);
 	int	    (*rebuild_header)(struct sock *sk);
 	void	    (*sk_rx_dst_set)(struct sock *sk, const struct sk_buff *skb);
-	int	    (*conn_request)(struct sock *sk, struct sk_buff *skb);
+	int	    (*conn_request)(struct sock *sk, struct sk_buff *skb,
+				    enum skb_drop_reason *reason);
 	struct sock *(*syn_recv_sock)(const struct sock *sk, struct sk_buff *skb,
 				      struct request_sock *req,
 				      struct dst_entry *dst,
diff --git a/include/net/tcp.h b/include/net/tcp.h
index ea0eb2d4a743..082dd0627e2e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -445,7 +445,8 @@ void tcp_v4_send_check(struct sock *sk, struct sk_buff *skb);
 void tcp_v4_mtu_reduced(struct sock *sk);
 void tcp_req_err(struct sock *sk, u32 seq, bool abort);
 void tcp_ld_RTO_revert(struct sock *sk, u32 seq);
-int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb);
+int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb,
+			enum skb_drop_reason *reason);
 struct sock *tcp_create_openreq_child(const struct sock *sk,
 				      struct request_sock *req,
 				      struct sk_buff *skb);
@@ -2036,9 +2037,9 @@ void tcp4_proc_exit(void);
 #endif
 
 int tcp_rtx_synack(const struct sock *sk, struct request_sock *req);
-int tcp_conn_request(struct request_sock_ops *rsk_ops,
-		     const struct tcp_request_sock_ops *af_ops,
-		     struct sock *sk, struct sk_buff *skb);
+enum skb_drop_reason tcp_conn_request(struct request_sock_ops *rsk_ops,
+				      const struct tcp_request_sock_ops *af_ops,
+				      struct sock *sk, struct sk_buff *skb);
 
 /* TCP af-specific functions */
 struct tcp_sock_af_ops {
diff --git a/net/dccp/input.c b/net/dccp/input.c
index 2cbb757a894f..e12baa56ca59 100644
--- a/net/dccp/input.c
+++ b/net/dccp/input.c
@@ -576,6 +576,7 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	const int old_state = sk->sk_state;
 	bool acceptable;
 	int queued = 0;
+	SKB_DR(reason);
 
 	/*
 	 *  Step 3: Process LISTEN state
@@ -606,7 +607,7 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 			 */
 			rcu_read_lock();
 			local_bh_disable();
-			acceptable = inet_csk(sk)->icsk_af_ops->conn_request(sk, skb) >= 0;
+			acceptable = inet_csk(sk)->icsk_af_ops->conn_request(sk, skb, &reason) >= 0;
 			local_bh_enable();
 			rcu_read_unlock();
 			if (!acceptable)
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 82696ab86f74..c689385229f0 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -581,7 +581,8 @@ static struct request_sock_ops dccp_request_sock_ops __read_mostly = {
 	.syn_ack_timeout = dccp_syn_ack_timeout,
 };
 
-int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
+int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb,
+			 enum skb_drop_reason *reason)
 {
 	struct inet_request_sock *ireq;
 	struct request_sock *req;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 4d95b6400915..abc82dda4b5b 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -314,7 +314,8 @@ static struct request_sock_ops dccp6_request_sock_ops = {
 	.syn_ack_timeout = dccp_syn_ack_timeout,
 };
 
-static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
+static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb,
+				enum skb_drop_reason *reason)
 {
 	struct request_sock *req;
 	struct dccp_request_sock *dreq;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4717af0eaea7..be6275c56b59 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6455,13 +6455,17 @@ enum skb_drop_reason tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			 */
 			rcu_read_lock();
 			local_bh_disable();
-			acceptable = icsk->icsk_af_ops->conn_request(sk, skb) >= 0;
+			reason = SKB_NOT_DROPPED_YET;
+			acceptable = icsk->icsk_af_ops->conn_request(sk, skb, &reason) >= 0;
 			local_bh_enable();
 			rcu_read_unlock();
 
 			if (!acceptable)
-				return SKB_DROP_REASON_NOT_SPECIFIED;
-			consume_skb(skb);
+				return reason ?: SKB_DROP_REASON_NOT_SPECIFIED;
+			if (reason)
+				kfree_skb_reason(skb, reason);
+			else
+				consume_skb(skb);
 			return SKB_NOT_DROPPED_YET;
 		}
 		SKB_DR_SET(reason, TCP_FLAGS);
@@ -6881,9 +6885,9 @@ u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
 }
 EXPORT_SYMBOL_GPL(tcp_get_syncookie_mss);
 
-int tcp_conn_request(struct request_sock_ops *rsk_ops,
-		     const struct tcp_request_sock_ops *af_ops,
-		     struct sock *sk, struct sk_buff *skb)
+enum skb_drop_reason tcp_conn_request(struct request_sock_ops *rsk_ops,
+				      const struct tcp_request_sock_ops *af_ops,
+				      struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_fastopen_cookie foc = { .len = -1 };
 	__u32 isn = TCP_SKB_CB(skb)->tcp_tw_isn;
@@ -6895,6 +6899,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	bool want_cookie = false;
 	struct dst_entry *dst;
 	struct flowi fl;
+	SKB_DR(reason);
 
 	/* TW buckets are converted to open requests without
 	 * limitations, they conserve resources and peer is
@@ -6903,12 +6908,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	if ((net->ipv4.sysctl_tcp_syncookies == 2 ||
 	     inet_csk_reqsk_queue_is_full(sk)) && !isn) {
 		want_cookie = tcp_syn_flood_action(sk, rsk_ops->slab_name);
-		if (!want_cookie)
+		if (!want_cookie) {
+			SKB_DR_SET(reason, TCP_REQQFULLDROP);
 			goto drop;
+		}
 	}
 
 	if (sk_acceptq_is_full(sk)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
+		SKB_DR_SET(reason, LISTENOVERFLOWS);
 		goto drop;
 	}
 
@@ -6964,6 +6972,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 			 */
 			pr_drop_req(req, ntohs(tcp_hdr(skb)->source),
 				    rsk_ops->family);
+			SKB_DR_SET(reason, TCP_REQQFULLDROP);
 			goto drop_and_release;
 		}
 
@@ -7016,7 +7025,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		}
 	}
 	reqsk_put(req);
-	return 0;
+	return SKB_NOT_DROPPED_YET;
 
 drop_and_release:
 	dst_release(dst);
@@ -7024,6 +7033,6 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	__reqsk_free(req);
 drop:
 	tcp_listendrop(sk);
-	return 0;
+	return reason;
 }
 EXPORT_SYMBOL(tcp_conn_request);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 12a18c5035f4..708f92b03f42 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1458,17 +1458,20 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
 	.send_synack	=	tcp_v4_send_synack,
 };
 
-int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
+int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb,
+			enum skb_drop_reason *reason)
 {
 	/* Never answer to SYNs send to broadcast or multicast */
 	if (skb_rtable(skb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		goto drop;
 
-	return tcp_conn_request(&tcp_request_sock_ops,
-				&tcp_request_sock_ipv4_ops, sk, skb);
+	*reason = tcp_conn_request(&tcp_request_sock_ops,
+				   &tcp_request_sock_ipv4_ops, sk, skb);
+	return *reason;
 
 drop:
 	tcp_listendrop(sk);
+	*reason = SKB_DROP_REASON_IP_INADDRERRORS;
 	return 0;
 }
 EXPORT_SYMBOL(tcp_v4_conn_request);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d8236d51dd47..27c51991bd54 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1148,24 +1148,28 @@ u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
 	return mss;
 }
 
-static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
+static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb,
+			       enum skb_drop_reason *reason)
 {
 	if (skb->protocol == htons(ETH_P_IP))
-		return tcp_v4_conn_request(sk, skb);
+		return tcp_v4_conn_request(sk, skb, reason);
 
 	if (!ipv6_unicast_destination(skb))
 		goto drop;
 
 	if (ipv6_addr_v4mapped(&ipv6_hdr(skb)->saddr)) {
 		__IP6_INC_STATS(sock_net(sk), NULL, IPSTATS_MIB_INHDRERRORS);
+		*reason = SKB_DROP_REASON_IP_INADDRERRORS;
 		return 0;
 	}
 
-	return tcp_conn_request(&tcp6_request_sock_ops,
-				&tcp_request_sock_ipv6_ops, sk, skb);
+	*reason = tcp_conn_request(&tcp6_request_sock_ops,
+				   &tcp_request_sock_ipv6_ops, sk, skb);
+	return *reason;
 
 drop:
 	tcp_listendrop(sk);
+	*reason = SKB_DROP_REASON_IP_INADDRERRORS;
 	return 0; /* don't send reset */
 }
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6d59336a8e1e..267f4e47236a 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -532,7 +532,8 @@ static int subflow_v6_rebuild_header(struct sock *sk)
 struct request_sock_ops mptcp_subflow_request_sock_ops;
 static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
-static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
+static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb,
+				   enum skb_drop_reason *reason)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 
@@ -556,7 +557,8 @@ static struct inet_connection_sock_af_ops subflow_v6_specific __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6m_specific __ro_after_init;
 static struct proto tcpv6_prot_override;
 
-static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
+static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb,
+				   enum skb_drop_reason *reason)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 
-- 
2.36.1

