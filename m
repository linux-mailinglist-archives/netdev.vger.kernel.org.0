Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A210928A5BA
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 07:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgJKFJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 01:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgJKFJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 01:09:56 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C157BC0613CE;
        Sat, 10 Oct 2020 22:09:56 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id y16so8796768ila.7;
        Sat, 10 Oct 2020 22:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=V6mwX+muNcv/XcHDj8h7DFbbHyZjF4hrggVn+CX0LZg=;
        b=OL/74TFWs8ziv8y7nebcDjRG1NLXeARdkHEzOsiHb2W1PsuActmOK18eAcxKmQsB1m
         stLTuoClc6xyig4LmwA7Oe2dQcRppl/nMAkQadQLtf9jQ28X6lDI3CqttbAT6qb6iQjx
         22+S+Clv2UljLD4T4CSOc8v/QuGHcklwoVRfjFI9XVzycUZ7mrF6zsFxAPbU6Wae49q1
         sTf0/eysrepXgMobPYxPtaExtpkDbzvXVw+ZQwbEyEN6IO+XFO8VNpN8aHkAhDurAS5w
         ToiOcbCp436lGldldy0wyCtVqblxQrx/yK/oxlglnGawBjQGm04aMXEpa5PiYgobfnPS
         85aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=V6mwX+muNcv/XcHDj8h7DFbbHyZjF4hrggVn+CX0LZg=;
        b=d0LI9Gc2GO0EBi21Quk7WerF5XKrvyuqR5sH+ql3GKUYJa+J7jwygpQyNSLbxDhzNf
         XAenfLXnkhvJTwTUAmZuY/wQUKw8kaKykK9Wwn3NxEuykMDrN2u5L38MowAaFZPgPvzi
         tWmd3zTW8jyAbw7+5JFk5XynENqQPGbKcGYtkcM5rxkB1Et6q0qBNf+AiW+1SAYQpW8J
         vbd5HPjx3KEAxX1wmgbTDhX5wLhGqaKBqCjNx7iqpG5A5x9F6ZS4gO+NeoGTH1/EmjuA
         d9J4ZMYonUjVqRBLEL7vvdtoTvvD9pJe09bbGXQKX1UdRv+0JCofRgd02NhnNtzS3SZ4
         4B8g==
X-Gm-Message-State: AOAM5318RSVli1xKwDXhwYT8EaQiYPgf/s2RRaH6yg6HFBVvayRMnHIY
        kuuQD/Wo3mcWiWFy5yXVR8MvQo1wEYo=
X-Google-Smtp-Source: ABdhPJwBItcvFsUdlTLWxqAcjC0R81eS9BflMgjm/x2bdVLVrDPpQR349Z25hRDcM+KS17lfFc96Tg==
X-Received: by 2002:a92:484e:: with SMTP id v75mr15418023ila.293.1602392995992;
        Sat, 10 Oct 2020 22:09:55 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y12sm7030578ilk.56.2020.10.10.22.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 22:09:55 -0700 (PDT)
Subject: [bpf-next PATCH 2/4] bpf,
 sockmap: Allow skipping sk_skb parser program
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Sat, 10 Oct 2020 22:09:38 -0700
Message-ID: <160239297866.8495.13345662302749219672.stgit@john-Precision-5820-Tower>
In-Reply-To: <160239226775.8495.15389345509643354423.stgit@john-Precision-5820-Tower>
References: <160239226775.8495.15389345509643354423.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we often run with a nop parser namely one that just does
this, 'return skb->len'. This happens when either our verdict program
can handle streaming data or it is only looking at socket data such
as IP addresses and other metadata associated with the flow. The second
case is common for a L3/L4 proxy for instance.

So lets allow loading programs without the parser then we can skip
the stream parser logic and avoid having to add a BPF program that
is effectively a nop.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h |    2 +
 net/core/skmsg.c      |   78 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/core/sock_map.c   |   22 +++++++++-----
 3 files changed, 95 insertions(+), 7 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 3119928fc103..fec0c5ac1c4f 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -308,6 +308,8 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node);
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
 void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock);
 void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock);
+void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock);
+void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock);
 
 int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 			 struct sk_msg *msg);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 881a5b290946..654182ecf87b 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -627,6 +627,8 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 	rcu_assign_sk_user_data(sk, NULL);
 	if (psock->progs.skb_parser)
 		sk_psock_stop_strp(sk, psock);
+	else if (psock->progs.skb_verdict)
+		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
 
@@ -871,6 +873,57 @@ static void sk_psock_strp_data_ready(struct sock *sk)
 	rcu_read_unlock();
 }
 
+static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
+				 unsigned int offset, size_t orig_len)
+{
+	struct sock *sk = (struct sock *)desc->arg.data;
+	struct sk_psock *psock;
+	struct bpf_prog *prog;
+	int ret = __SK_DROP;
+	int len = skb->len;
+
+	/* clone here so sk_eat_skb() in tcp_read_sock does not drop our data */
+	skb = skb_clone(skb, GFP_ATOMIC);
+	if (!skb) {
+		desc->error = -ENOMEM;
+		return 0;
+	}
+
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (unlikely(!psock)) {
+		len = 0;
+		kfree_skb(skb);
+		goto out;
+	}
+	skb_set_owner_r(skb, sk);
+	prog = READ_ONCE(psock->progs.skb_verdict);
+	if (likely(prog)) {
+		tcp_skb_bpf_redirect_clear(skb);
+		ret = sk_psock_bpf_run(psock, prog, skb);
+		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+	}
+	sk_psock_verdict_apply(psock, skb, ret);
+out:
+	rcu_read_unlock();
+	return len;
+}
+
+static void sk_psock_verdict_data_ready(struct sock *sk)
+{
+	struct socket *sock = sk->sk_socket;
+	read_descriptor_t desc;
+
+	if (unlikely(!sock || !sock->ops || !sock->ops->read_sock))
+		return;
+
+	desc.arg.data = sk;
+	desc.error = 0;
+	desc.count = 1;
+
+	sock->ops->read_sock(sk, &desc, sk_psock_verdict_recv);
+}
+
 static void sk_psock_write_space(struct sock *sk)
 {
 	struct sk_psock *psock;
@@ -900,6 +953,19 @@ int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
 	return strp_init(&psock->parser.strp, sk, &cb);
 }
 
+void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
+{
+	struct sk_psock_parser *parser = &psock->parser;
+
+	if (parser->enabled)
+		return;
+
+	parser->saved_data_ready = sk->sk_data_ready;
+	sk->sk_data_ready = sk_psock_verdict_data_ready;
+	sk->sk_write_space = sk_psock_write_space;
+	parser->enabled = true;
+}
+
 void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
 {
 	struct sk_psock_parser *parser = &psock->parser;
@@ -925,3 +991,15 @@ void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
 	strp_stop(&parser->strp);
 	parser->enabled = false;
 }
+
+void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock)
+{
+	struct sk_psock_parser *parser = &psock->parser;
+
+	if (!parser->enabled)
+		return;
+
+	sk->sk_data_ready = parser->saved_data_ready;
+	parser->saved_data_ready = NULL;
+	parser->enabled = false;
+}
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index a2ed5b6223b9..df09c39a4dd2 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -148,8 +148,8 @@ static void sock_map_add_link(struct sk_psock *psock,
 static void sock_map_del_link(struct sock *sk,
 			      struct sk_psock *psock, void *link_raw)
 {
+	bool strp_stop = false, verdict_stop = false;
 	struct sk_psock_link *link, *tmp;
-	bool strp_stop = false;
 
 	spin_lock_bh(&psock->link_lock);
 	list_for_each_entry_safe(link, tmp, &psock->link, list) {
@@ -159,14 +159,19 @@ static void sock_map_del_link(struct sock *sk,
 							     map);
 			if (psock->parser.enabled && stab->progs.skb_parser)
 				strp_stop = true;
+			if (psock->parser.enabled && stab->progs.skb_verdict)
+				verdict_stop = true;
 			list_del(&link->list);
 			sk_psock_free_link(link);
 		}
 	}
 	spin_unlock_bh(&psock->link_lock);
-	if (strp_stop) {
+	if (strp_stop || verdict_stop) {
 		write_lock_bh(&sk->sk_callback_lock);
-		sk_psock_stop_strp(sk, psock);
+		if (strp_stop)
+			sk_psock_stop_strp(sk, psock);
+		else
+			sk_psock_stop_verdict(sk, psock);
 		write_unlock_bh(&sk->sk_callback_lock);
 	}
 }
@@ -288,16 +293,19 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 	write_lock_bh(&sk->sk_callback_lock);
 	if (skb_parser && skb_verdict && !psock->parser.enabled) {
 		ret = sk_psock_init_strp(sk, psock);
-		if (ret) {
-			write_unlock_bh(&sk->sk_callback_lock);
-			goto out_drop;
-		}
+		if (ret)
+			goto out_unlock_drop;
 		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
 		psock_set_prog(&psock->progs.skb_parser, skb_parser);
 		sk_psock_start_strp(sk, psock);
+	} else if (!skb_parser && skb_verdict && !psock->parser.enabled) {
+		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
+		sk_psock_start_verdict(sk,psock);
 	}
 	write_unlock_bh(&sk->sk_callback_lock);
 	return 0;
+out_unlock_drop:
+	write_unlock_bh(&sk->sk_callback_lock);
 out_drop:
 	sk_psock_put(sk, psock);
 out_progs:

