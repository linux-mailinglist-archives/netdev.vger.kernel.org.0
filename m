Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BD9429775
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 21:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhJKTTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 15:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbhJKTTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 15:19:19 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552F3C061570;
        Mon, 11 Oct 2021 12:17:18 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id r134so9870639iod.11;
        Mon, 11 Oct 2021 12:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zWfw5yv/Wr4pji3ke4CQl5k7I1ej4+D5cKcPcTz5sWU=;
        b=UHsa6AC1ROttToJzWoKJzwREIQskjUaJO3EsvXhJ8oCf0hPSuoigc0UiohFFIre9sn
         Vq7h3vzgX0/oua759l+u7Bh/1q/iiI06g2MexwqYHQiC2fc9xlcXuGzFhMMBWJKnwjHX
         mDEIR5uWdWSTSaB1aJjJA3wlwno6EN3uEcazLBcb4xDb5pMi/tMcSE47mR6zX4UtBc22
         gQHI1aNqqbnr8rUiHAG43M7scWG1Owms3vxta12OBNv3c0awhuEB8pVwF60SisUIGzrc
         I9ugU0HNAPkyxJvqxAUHWU1iYn1f8qTQvA0K9iJxnVVJ5OqVLa5avV6tlg0QgVP5mDG7
         uZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zWfw5yv/Wr4pji3ke4CQl5k7I1ej4+D5cKcPcTz5sWU=;
        b=G3BSyF6WR+J4NFYMKbH59VpFaCM1BbNraeMW3eeCpZb1P0o3IOtOU6dZ+4PpcfQPB+
         fTedA+kGcqvF/+PpHCGsIx26bdM4a6CQbS2hQKI5qjKN/qlkB6P56SXAEDFZbHQOJWom
         Yw5JzaIIWo62AjI8acGBY5iHsTjluvNhiKo6UkvbcsxtGorXhl8nwUy+xWlo8Y/dV6jh
         W7KxKBaD7kmjcD8LgjrEgY6iA6EFBrSOlcUmEuiMR6DluE0wNrwN2a8gle++fJQwY6V3
         HZFg6DrEsX1BRgh7wxKeMKVauIi1Kt3LKwfHrQp4rsUrzXmVn4P9M+ocviXyuB5kDVBf
         hSjw==
X-Gm-Message-State: AOAM532qs482NE5ONOttS5YZhbOcLkYSHlyVoxh2eSZLUcHB+QnJBkJ3
        p8WhNFLhiu75VQ3Vg4k/2O4M1SSEKS2YUg==
X-Google-Smtp-Source: ABdhPJz70L0XmOvLLn5/WfkPb0zPBu/arcMMpYKzdbGbcIY8cKdpNeV5MwvuktvkLKKK264mDuw6hQ==
X-Received: by 2002:a05:6638:3052:: with SMTP id u18mr20029594jak.148.1633979837482;
        Mon, 11 Oct 2021 12:17:17 -0700 (PDT)
Received: from john.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id n12sm4460077ilj.8.2021.10.11.12.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 12:17:16 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net, joamaki@gmail.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH bpf 2/4] bpf, sockmap: Fix race in ingress receive verdict with redirect to self
Date:   Mon, 11 Oct 2021 12:16:45 -0700
Message-Id: <20211011191647.418704-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011191647.418704-1-john.fastabend@gmail.com>
References: <20211011191647.418704-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A socket in a sockmap may have different combinations of programs
attached depending on configuration. There can be no programs in which
case the socket acts as a sink only. There can be a TX program in this
case a BPF program is attached to sending side, but no RX program is
attached. There can be an RX program only where sends have no BPF
program attached, but receives are hooked with BPF. And finally,
both TX and RX programs may be attached. Giving us the permutations,

 None, Tx, Rx, and TxRx

To date most of our use cases have been TX case being used as a fast
datapath to directly copy between local application and a userspace
proxy. Or Rx cases and TxRX applications that are operating an in
kernel based proxy. The traffic in the first case where we hook
applications into a userspace application looks like this,

  AppA  redirect   AppB
   Tx <-----------> Rx
   |                |
   +                +
   TCP <--> lo <--> TCP

In this case all traffic from AppA (after 3whs) is copied into the
AppB ingress queue and no traffic is ever on the TCP recieive_queue.

In the second case the application never receives, except in some
rare error cases, traffic on the actual user space socket. Instead
the send happens in the kernel.

           AppProxy       socket pool
       sk0 ------------->{sk1,sk2, skn}
        ^                      |
        |                      |
        |                      v
       ingress              lb egress
       TCP                  TCP

Here because traffic is never read off the socket with userspace
recv() APIs there is only ever one reader on the sk receive_queue.
Namely the BPF programs.

However, we've started to introduce a third configuration where the
BPF program on receive should process the data, but then the normal
case is to push the data into the receive queue of AppB.

       AppB
       recv()                (userspace)
     -----------------------
       tcp_bpf_recvmsg()     (kernel)
         |             |
         |             |
         |             |
       ingress_msgQ    |
         |             |
       RX_BPF          |
         |             |
         v             v
       sk->receive_queue


This is different from the App{A,B} redirect because traffic is
first received on the sk->receive_queue.

Now for the issue. The tcp_bpf_recvmsg() handler first checks the
ingress_msg queue for any data handled by the BPF rx program and
returned with PASS code so that it was enqueued on the ingress msg
queue. Then if no data exists on that queue it checks the socket
receive queue. Unfortunately, this is the same receive_queue the
BPF program is reading data off of. So we get a race. Its possible
for the recvmsg() hook to pull data off the receive_queue before
the BPF hook has a chance to read it. It typically happens when
an application is banging on recv() and getting EAGAINs. Until
they manage to race with the RX BPF program.

To fix this we note that before this patch at attach time when
the socket is loaded into the map we check if it needs a TX
program or just the base set of proto bpf hooks. Then it uses
the above general RX hook regardless of if we have a BPF program
attached at rx or not. This patch now extends this check to
handle all cases enumerated above, TX, RX, TXRX, and none. And
to fix above race when an RX program is attached we use a new
hook that is nearly identical to the old one except now we
do not let the recv() call skip the RX BPF program. Now only
the BPF program pulls data from sk->receive_queue and recv()
only pulls data from the ingress msgQ post BPF program handling.

With this resolved our AppB from above has been up and running
for many hours without detecting any errors. We do this by
correlating counters in RX BPF events and the AppB to ensure
data is never skipping the BPF program. Selftests, was not
able to detect this because we only run them for a short
period of time on well ordered send/recvs so we don't get any
of the noise we see in real application environments.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 35dcfb04f53d..0cc420c0e259 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -185,6 +185,41 @@ static int tcp_msg_wait_data(struct sock *sk, struct sk_psock *psock,
 	return ret;
 }
 
+static int tcp_bpf_recvmsg_parser(struct sock *sk,
+				  struct msghdr *msg,
+				  size_t len,
+				  int nonblock,
+				  int flags,
+				  int *addr_len)
+{
+	struct sk_psock *psock;
+	int copied;
+
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return inet_recv_error(sk, msg, len, addr_len);
+
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock))
+		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+
+	lock_sock(sk);
+msg_bytes_ready:
+	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
+	if (!copied) {
+		long timeo;
+		int data;
+
+		timeo = sock_rcvtimeo(sk, nonblock);
+		data = tcp_msg_wait_data(sk, psock, timeo);
+		if (data && !sk_psock_queue_empty(psock))
+			goto msg_bytes_ready;
+		copied = -EAGAIN;
+	}
+	release_sock(sk);
+	sk_psock_put(sk, psock);
+	return copied;
+}
+
 static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		    int nonblock, int flags, int *addr_len)
 {
@@ -465,6 +500,8 @@ enum {
 enum {
 	TCP_BPF_BASE,
 	TCP_BPF_TX,
+	TCP_BPF_RX,
+	TCP_BPF_TXRX,
 	TCP_BPF_NUM_CFGS,
 };
 
@@ -483,6 +520,12 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 	prot[TCP_BPF_TX]			= prot[TCP_BPF_BASE];
 	prot[TCP_BPF_TX].sendmsg		= tcp_bpf_sendmsg;
 	prot[TCP_BPF_TX].sendpage		= tcp_bpf_sendpage;
+
+	prot[TCP_BPF_RX]			= prot[TCP_BPF_BASE];
+	prot[TCP_BPF_RX].recvmsg		= tcp_bpf_recvmsg_parser;
+
+	prot[TCP_BPF_TXRX]			= prot[TCP_BPF_TX];
+	prot[TCP_BPF_TXRX].recvmsg		= tcp_bpf_recvmsg_parser;
 }
 
 static void tcp_bpf_check_v6_needs_rebuild(struct proto *ops)
@@ -520,6 +563,10 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
 	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
 
+	if (psock->progs.stream_verdict || psock->progs.skb_verdict) {
+		config = (config == TCP_BPF_TX) ? TCP_BPF_TXRX : TCP_BPF_RX;
+	}
+
 	if (restore) {
 		if (inet_csk_has_ulp(sk)) {
 			/* TLS does not have an unhash proto in SW cases,
-- 
2.33.0

