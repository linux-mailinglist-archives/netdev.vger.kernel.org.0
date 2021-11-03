Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395B44449BE
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhKCUu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 16:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhKCUuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 16:50:55 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1075C061714;
        Wed,  3 Nov 2021 13:48:18 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id i79so4116804ioa.13;
        Wed, 03 Nov 2021 13:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aYqyw5Wb1F6fwkcRsbWLwzJSFh6wyQJt0oLb9vIykeo=;
        b=XdHmDK6q9h7mUBdJonpzvDHOxAbLFnGHryqLe2jKqQwPxJU5QLstI6YvAk+4p9QCVX
         WI6hs7AKJkxn4ggDeWS2lagISmFgktGVCCvyOsV4vZSfKSFle1qkGtIhDu1Biyspja6l
         6a/SimDK/wMIeBRUuxe8K3ZrUi9T7yQqPHcsycNFgE/1Naepkks7omjYymhUGg0++/B4
         9j8BUoDJ0pC1M/6qnFkNqd5G8CVSzJh/YddTp9ibrCN79AUnSshAAoXDcaJ7yF7KgcRW
         ja5imr2JYcneykM3E6Ss+qfeoYJqd+nwLJP8GQZFUMR7/MWqWdQkuDmPdqufXKWqNuak
         sbFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aYqyw5Wb1F6fwkcRsbWLwzJSFh6wyQJt0oLb9vIykeo=;
        b=3LEmh7CPXyaQ5rFgiGrxP+eLrgJeLMstHGmFWnigFT24mBIfbtbJ2oSZCNFRC68MuY
         6koxm6ccK31TSfq7AefJ0c6oB7Pge4UzzKBl5ZM+sWpY4CQe1u05wlg4TXkPutQPraty
         UPRo0nHuy9v5QLfzlHaB3vqWTd3Xz51f8vbBMDEw0RDWZq3VwoWwWTklAtRMonbLVzPn
         zOcRbueNkZjvmCtHTx1B/LImspo8r1GWkY4h2GIcOt70XnDWXFFVmBrCpZh6ZztEJ4bB
         UDzyVSwuK3l79d59XOCYjBKMYWySGNondRayUCJ/S6uiOnVi3muQF5tdrqHilzy5fNna
         VvXQ==
X-Gm-Message-State: AOAM533F4G2B+fJbQ8yKCelpAmwxQ5C/G7i7APhNKjHj1diO5YhqrDYL
        tDGfESHTFauif4SBSG+bHvYIwXWmQuqDDA==
X-Google-Smtp-Source: ABdhPJxgAe4NHkII8OudmkTXGthNogaywaZDcaFmXmdLCMSOSBDVwK2OBp2aOAU+aUPqDwzz6mkIPw==
X-Received: by 2002:a05:6602:1550:: with SMTP id h16mr31909068iow.125.1635972497834;
        Wed, 03 Nov 2021 13:48:17 -0700 (PDT)
Received: from john.lan ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id y11sm1507612ior.4.2021.11.03.13.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:48:17 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, joamaki@gmail.com, xiyou.wangcong@gmail.com,
        jakub@cloudflare.com, john.fastabend@gmail.com
Subject: [PATCH bpf v2 3/5] bpf, sockmap: Fix race in ingress receive verdict with redirect to self
Date:   Wed,  3 Nov 2021 13:47:34 -0700
Message-Id: <20211103204736.248403-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211103204736.248403-1-john.fastabend@gmail.com>
References: <20211103204736.248403-1-john.fastabend@gmail.com>
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
Tested-by: Jussi Maki <joamaki@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 246f725b78c9..f70aa0932bd6 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -172,6 +172,41 @@ static int tcp_msg_wait_data(struct sock *sk, struct sk_psock *psock,
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
@@ -464,6 +499,8 @@ enum {
 enum {
 	TCP_BPF_BASE,
 	TCP_BPF_TX,
+	TCP_BPF_RX,
+	TCP_BPF_TXRX,
 	TCP_BPF_NUM_CFGS,
 };
 
@@ -482,6 +519,12 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
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
@@ -519,6 +562,10 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
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

