Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC8E6CAC66
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbjC0RzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbjC0RzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:55:00 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D43C26A2;
        Mon, 27 Mar 2023 10:54:58 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q206so5645679pgq.9;
        Mon, 27 Mar 2023 10:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679939698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5HnEXOYmvzE8cKApqzizcKudiq0fvSHKWy9J37Q8ln4=;
        b=ZwW8SEt4LGFc6U/LUMlbh3Dqew+OucsAgxTqoklNX/CmG8nNiiS3MRuHZETlkWySL0
         W8sxc0tcKhv2hkSOnEGHqtlTj1LWOg7duu2p9vhhIP3jekPmfOitjLzOOxUGU7HH67XS
         p91n+DmqMSgcD1EB5fLWPqCtacmyqlwJwLxqIeYM6DHEnnbovPSX9G6myZMkkAgSVaPV
         B7ha7s7qx2hTZWvJpjeIboGIxKElJKCsNZsSoDlf484C5aJTJi8K99nlva+Qn+0ENW4M
         9ESqCK3nT6bdse1BtJPIuWdO7Zf9IeiiQv2ULMDvUFaGH77WEkpNa2VW5cJxTFbTGm0r
         h5NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679939698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5HnEXOYmvzE8cKApqzizcKudiq0fvSHKWy9J37Q8ln4=;
        b=TrQdnvS5Bq6UR61wA4vjaZjUTv2RD+a+MiVH3cMbb/fWvNLXaLsVAVXeidadZWw0hc
         oI9TVHAihhsCl6/vhv4MX9YC5qm9r7uUyUw9P28ccuKjaPDU2ULBdvmfMUOqzuo/HhC4
         1ZgDpKB/wq1uKx/l/wOWRYtt4ouTE2JOyr4bSa89EliTGZIQhRdw5ZwDPBZ45X2MnDa1
         7FroQxHzZnn040cix1ITf+oo7RNZB1Xcrv2/szrEHvMksZpiV7DJVULCkY16q/7e489Q
         lANbG3M2yW46kIKnsfn7Gym6zfejcN9qWGc0H72z2gjD02PHufFagdFP1pFVphyi83ze
         GMaw==
X-Gm-Message-State: AAQBX9eGKk2ISX93uZzAxhkM3XQmSJdBGoYEH4m2yzh2bbf3sAcbYxUw
        MURe0F4jxNavec75QIutC6Y=
X-Google-Smtp-Source: AKy350Yvq/+zoWDCU6gfg33ajI/1zCReghYPGkCdyPosCclz59VsPY/GiNFraRtveOFqpFa2T9YSLQ==
X-Received: by 2002:aa7:950d:0:b0:5a8:ad9d:83f with SMTP id b13-20020aa7950d000000b005a8ad9d083fmr11971485pfp.24.1679939698065;
        Mon, 27 Mar 2023 10:54:58 -0700 (PDT)
Received: from john.lan ([98.97.117.131])
        by smtp.gmail.com with ESMTPSA id r1-20020a62e401000000b005a8ba70315bsm19408316pfh.6.2023.03.27.10.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 10:54:57 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v2 05/12] bpf: sockmap, TCP data stall on recv before accept
Date:   Mon, 27 Mar 2023 10:54:39 -0700
Message-Id: <20230327175446.98151-6-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230327175446.98151-1-john.fastabend@gmail.com>
References: <20230327175446.98151-1-john.fastabend@gmail.com>
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
index 3a0f43f3afd8..2c75bbcbefed 100644
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

