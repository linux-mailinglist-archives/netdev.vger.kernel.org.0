Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBBE46D8A53
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbjDEWJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbjDEWJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:09:33 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEAD65A6;
        Wed,  5 Apr 2023 15:09:15 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x15so35440361pjk.2;
        Wed, 05 Apr 2023 15:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680732555; x=1683324555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZLeQQ1n11MV3iEBKLP57EKp7c8nx+XOI45qonfxXGc=;
        b=MgQevM8VmXFl1PLcKFPLTY2YHXt4G+Wb+xE8RzNJnQoSctq++tKV51e4l5NNz29GE6
         vFwD7x2L9d+kYAmnXpHIzDsAD3f9+hK2vzOqJ8US0E3prBsrFnjcRoydjSV+zh3MrYfx
         IpP7k/0o8lz/UJZCiicxZXY/H2aQFT1OOYUAKawYw/mOrpN6yiClmnryJJaaCBwKpJ+9
         8x3MTbO38NmpuSg+haovk25YBmIBvtcxaxanOOuWSdeuEsbP9iqKxsapcGrlqq70mvgM
         a6Yy+pxlUNfGaUJ7jdQUxCDumWdeccoR5avQpE9lm8rOIQtTgURVEZ1nNfaq5fUw5T6/
         ivMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680732555; x=1683324555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QZLeQQ1n11MV3iEBKLP57EKp7c8nx+XOI45qonfxXGc=;
        b=CM8MQ2YpK0wnZGBlhni8qocJuKT9AlEgTRxAYaIkQNvMcHAHcv6YfXE0hZcgFnWpm8
         /91j85gUNz91U9OLS2WCrEmjlRUavhgwFJCuYM6+blZ0m7tAJJ0U+gv45Ljxu6ygAGPe
         4VTifo1rmcOH8txRYpc6G+tuPt+1Qf10gwxlriFzsRtL5jVk07rL7xYCJaDz1VPMmmgi
         RPqDRgH3TkvtSoaQQM3QN3hNBkYu+kHmK+HDR0QaxN6AIRzovrcAUyE5bkivi/aSxPRf
         Dg+LAIU1Y6/hMfICf2ljbcT03HHJoirwE8JkH0Dj4yLyW7U78vpJFdabPgW5ZlKmmhie
         WTwg==
X-Gm-Message-State: AAQBX9dC7kyAp2dF2Vt29g8CzgeYTUVKYDoFBlJ+WXrikvw/odyN3vma
        TOjXgYG3sUXdM2o4m6utRck=
X-Google-Smtp-Source: AKy350Yn0UbdNjxjCibOvv3roV2sX3CRUJht0kZEUMzw/RqpbL6GEkseSnjZuGKcykRqUkxSaVtbyQ==
X-Received: by 2002:a17:90b:4c0a:b0:23f:1210:cea4 with SMTP id na10-20020a17090b4c0a00b0023f1210cea4mr8465206pjb.18.1680732555057;
        Wed, 05 Apr 2023 15:09:15 -0700 (PDT)
Received: from john.lan ([2605:59c8:4c5:7110:5120:4bff:95ea:9ce0])
        by smtp.gmail.com with ESMTPSA id gz11-20020a17090b0ecb00b00230ffcb2e24sm1865697pjb.13.2023.04.05.15.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 15:09:14 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v4 05/12] bpf: sockmap, TCP data stall on recv before accept
Date:   Wed,  5 Apr 2023 15:08:57 -0700
Message-Id: <20230405220904.153149-6-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230405220904.153149-1-john.fastabend@gmail.com>
References: <20230405220904.153149-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A common mechanism to put a TCP socket into the sockmap is to hook the
BPF_SOCK_OPS_{ACTIVE_PASSIVE}_ESTABLISHED_CB event with a BPF program
that can map the socket info to the correct BPF verdict parser. When
the user adds the socket to the map the psock is created and the new
ops are assigned to ensure the verdict program will 'see' the sk_buffs
as they arrive.

Part of this process hooks the sk_data_ready op with a BPF specific
handler to wake up the BPF verdict program when data is ready to read.
The logic is simple enough (posted here for easy reading)

 static void sk_psock_verdict_data_ready(struct sock *sk)
 {
	struct socket *sock = sk->sk_socket;

	if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
		return;
	sock->ops->read_skb(sk, sk_psock_verdict_recv);
 }

The oversight here is sk->sk_socket is not assigned until the application
accepts() the new socket. However, its entirely ok for the peer application
to do a connect() followed immediately by sends. The socket on the receiver
is sitting on the backlog queue of the listening socket until its accepted
and the data is queued up. If the peer never accepts the socket or is slow
it will eventually hit data limits and rate limit the session. But,
important for BPF sockmap hooks when this data is received TCP stack does
the sk_data_ready() call but the read_skb() for this data is never called
because sk_socket is missing. The data sits on the sk_receive_queue.

Then once the socket is accepted if we never receive more data from the
peer there will be no further sk_data_ready calls and all the data
is still on the sk_receive_queue(). Then user calls recvmsg after accept()
and for TCP sockets in sockmap we use the tcp_bpf_recvmsg_parser() handler.
The handler checks for data in the sk_msg ingress queue expecting that
the BPF program has already run from the sk_data_ready hook and enqueued
the data as needed. So we are stuck.

To fix do an unlikely check in recvmsg handler for data on the
sk_receive_queue and if it exists wake up data_ready. We have the sock
locked in both read_skb and recvmsg so should avoid having multiple
runners.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 804bd0c247d0..ae6c7130551c 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -212,6 +212,26 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 		return tcp_recvmsg(sk, msg, len, flags, addr_len);
 
 	lock_sock(sk);
+
+	/* We may have received data on the sk_receive_queue pre-accept and
+	 * then we can not use read_skb in this context because we haven't
+	 * assigned a sk_socket yet so have no link to the ops. The work-around
+	 * is to check the sk_receive_queue and in these cases read skbs off
+	 * queue again. The read_skb hook is not running at this point because
+	 * of lock_sock so we avoid having multiple runners in read_skb.
+	 */
+	if (unlikely(!skb_queue_empty(&sk->sk_receive_queue))) {
+		tcp_data_ready(sk);
+		/* This handles the ENOMEM errors if we both receive data
+		 * pre accept and are already under memory pressure. At least
+		 * let user no to retry.
+		 */
+		if (unlikely(!skb_queue_empty(&sk->sk_receive_queue))) {
+			copied = -EAGAIN;
+			goto out;
+		}
+	}
+
 msg_bytes_ready:
 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
 	/* The typical case for EFAULT is the socket was gracefully
-- 
2.33.0

