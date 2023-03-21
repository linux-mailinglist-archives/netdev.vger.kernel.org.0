Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F646C3D0A
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjCUVwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjCUVwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:52:30 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8C93B3E9;
        Tue, 21 Mar 2023 14:52:26 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id kc4so2898673plb.10;
        Tue, 21 Mar 2023 14:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679435546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bTfLE6aG3j8MrgJYsS7RufQHedEAG+l/eLAgkkBvx1s=;
        b=GOzMVSK7KZMcxlss9S2efi2Z3EDc2QXiBqzAEOMZzXnYw3b9Z3w9EkffTAmKyABR6Q
         isfmi9fWsMvlNMGNfMfag040+STSSBawMdcIErdQswFGsidvjFR5l2hbq+4wTfl4ZFQa
         SRwedbnQ4cxCFAlvIVZYcp2Z0baMX2i5tAh+Ajsqd0oBvV5Byh04aB8ViklzEhrFXVO5
         H50mF6l6DJlsAgubsBbmAf0pMpRZt5spSu0qBru9EbP2l9Hf4cFhAGytgsnWxDCPrKXd
         qq8XrMl2IdY18wDAcGrgb+bUXkgr0fiAbu3tdUQj3TPWvPz661agbM7pU0pXwV7IvoC7
         gkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679435546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bTfLE6aG3j8MrgJYsS7RufQHedEAG+l/eLAgkkBvx1s=;
        b=IWxpXpZRufB8IlSzVKLVL9O+5Tcyx7LU2BPHJFvC4mdlLdaMPkc5Mxky9Gd/03NktL
         44pZq/84qQViTXmfPXtiy+ltnjDRgXLYuOGAi3r8dMMIjjnszW3mPMknaDAqiHjhQWcN
         r09ZsSEWRSVg3Xg7FaZesr02cYl3eGLQ+TnL1oq4HTv39Z2Ca3t44UL+M4ggaRe2jZnt
         SfkQ0FPraRgRmKzq9ukyJSZnMVg139R+hA6TpUrjdy/aMU0B4zgACJZM38k6Aee4lMTh
         3ASVFQQpV+PGN1wr1OXi31b3WQG0VF5CfM+jnK6OS6N+75JvMC0I5TjW/ydI9rJj5K6B
         muUQ==
X-Gm-Message-State: AO0yUKVWhNx6F2ZIklqvxOqZSj/YA8+CJf3D62wA6Wxc1gMlgLWCEccB
        UMyQ0ImguMtqfX3laNRX8Iw=
X-Google-Smtp-Source: AK7set/WyUzFNRXXiRp29CxSOP05m0wlFuuJ8mA50HWlxjDVT/HhUTHVzw49cT7oCdeiXPv0kf0EkQ==
X-Received: by 2002:a17:902:e293:b0:19f:1c79:8b21 with SMTP id o19-20020a170902e29300b0019f1c798b21mr391727plc.42.1679435545814;
        Tue, 21 Mar 2023 14:52:25 -0700 (PDT)
Received: from john.lan ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id m3-20020a63fd43000000b004facdf070d6sm8661331pgj.39.2023.03.21.14.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:52:25 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: [PATCH bpf 05/11] bpf: sockmap, TCP data stall on recv before accept
Date:   Tue, 21 Mar 2023 14:52:06 -0700
Message-Id: <20230321215212.525630-6-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230321215212.525630-1-john.fastabend@gmail.com>
References: <20230321215212.525630-1-john.fastabend@gmail.com>
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
index 3a0f43f3afd8..b1ba58be0c5a 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -209,6 +209,26 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
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
+	if (unlikely(!skb_queue_empty_lockless(&sk->sk_receive_queue))) {
+		tcp_data_ready(sk);
+		/* This handles the ENOMEM errors if we both receive data
+		 * pre accept and are already under memory pressure. At least
+		 * let user no to retry.
+		 */
+		if (unlikely(!skb_queue_empty_lockless(&sk->sk_receive_queue))) {
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

