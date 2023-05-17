Return-Path: <netdev+bounces-3198-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A65A705F41
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:25:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27D2D281574
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83DB7DDC7;
	Wed, 17 May 2023 05:23:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77019D2FF;
	Wed, 17 May 2023 05:23:13 +0000 (UTC)
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D238F40E8;
	Tue, 16 May 2023 22:23:00 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-24e16918323so341408a91.2;
        Tue, 16 May 2023 22:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684300980; x=1686892980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kZKE0BIR8kU5LZVmgLjnz2d1PSXb3yg4NzK45uW/48=;
        b=cRkWytBtiGaSGkZGb1lGO5EpFHKoDUYUuK5Oz8ieUPrXG/cEfhWcNmUTjiR2wv5/2Y
         dCe0wsOCy0EDiyByz4pTpVmTdrNIgpG0rwuvi44ao4b8pMgcr3k3tWtkpc9d3Bs1TpHm
         xtDTnadk1AUFUZKWGlZvlLQBksSKqj9jaTr5vZRASQf6kEVsxpd6WOBk6d18rU+GoIQG
         4Gomt8LUqcFrjfzOLHIhnoCrgM7NPD1lwa0oD49ek/Afxd492687Vhy+ddRs5c7QSmFa
         vGuphk3ZSON0WjGWKDVVTigQhcxI3xpsT1c/lf8mfRBTjxoD0oIKBl5f7hDXZ7bo16oe
         1lug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684300980; x=1686892980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0kZKE0BIR8kU5LZVmgLjnz2d1PSXb3yg4NzK45uW/48=;
        b=JyUZLh9O0yz1eu93+kwDCOWzdOQa/IhFIfEgb7B9+t5RyTbdklHjLu6sl+O7N4sN/A
         QTpJy3cPQG3v7TwwEuAEttOr8jd/lCaDEoSDkUHulhEso9PiYRAJEd0glmWxgRGkZmHG
         a9MU+MBM0eXE/pruu8rj9FsZKYFX/Z7hDIxBIY8C7jFOGctkbv0/+XBhkb0p4G3yB/e4
         nhe+gDDgsyeJIoCVXYYysg4NxUHXbo/uesWV20LjE50WssLJDTkKO4Ml3dvMgZBWQe2k
         QFFPFzmJ3iC6mIZctSlXI3fJ+UFWbtEoxc58a2ZGqyq08owuBhkr4NfT0cLIddoAMmWa
         vUXQ==
X-Gm-Message-State: AC+VfDxk0sMtOENQcDfFpaOvaaj+ACcvaLLVJkQhlcU04muXDnPgyKZ2
	cM13ZqvvrUIrSe36tzWoSzI=
X-Google-Smtp-Source: ACHHUZ6EF5kZ8TNSzipzeod/uXtreVo2wV1TRMEKut1mV+wuT1WLnTlpz7yRN0Tjh97K0epVBjbDXQ==
X-Received: by 2002:a17:90a:e545:b0:24e:2e86:5465 with SMTP id ei5-20020a17090ae54500b0024e2e865465mr39481099pjb.31.1684300980468;
        Tue, 16 May 2023 22:23:00 -0700 (PDT)
Received: from john.lan ([98.97.37.198])
        by smtp.gmail.com with ESMTPSA id n11-20020a17090a2fcb00b0023cfdbb6496sm581779pjm.1.2023.05.16.22.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 22:23:00 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v8 06/13] bpf: sockmap, TCP data stall on recv before accept
Date: Tue, 16 May 2023 22:22:37 -0700
Message-Id: <20230517052244.294755-7-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230517052244.294755-1-john.fastabend@gmail.com>
References: <20230517052244.294755-1-john.fastabend@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 804bd0c247d0..404857ab14cc 100644
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
+		 * let user know to retry.
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


