Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751C6309C1D
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 13:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhAaMto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:49:44 -0500
Received: from mail-ed1-f49.google.com ([209.85.208.49]:45890 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhAaLdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 06:33:04 -0500
Received: by mail-ed1-f49.google.com with SMTP id f1so15565146edr.12;
        Sun, 31 Jan 2021 03:32:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFR29j/vsA/zbdAK5fWEslMn8zse+VTzbl584PXxRck=;
        b=dUD506MZwk1varukjzxiPRJGIg0PMgnhrT/UYUD1iP+6XgL25534IIJhV18nBC8Tgx
         kOF+ICm4aqbTqYCHfnmooF6cm5/tyBvygyCOY+2RnsriQfO1p102raBx/x4jTOKDDbtG
         LbymdfLU+qFLhi4qo28ixW84rxvNnyhFqAXCzk0Mq10IZyfdTlSIun7bTz5xRf0ChtUU
         oJa3mt+t5Gn9lmQOkkemC5dnRevYnXhE4FzF5FnMh7w5uk4dwzG4BdCgr+0exxDLmM2f
         hnt42dAizsa8rop56FoYQx4q4kgDTJkP8AHpthUi/wy9ULtG2DuDWiODp1v73MOoqAft
         83og==
X-Gm-Message-State: AOAM532fSv9b+EskXGqa4FknIHDwuMe6yP2en7bpoLGt5Mb2/VPHbGBh
        Hi3U2woosmmis/16OSGbZB2VsKtqTgo=
X-Google-Smtp-Source: ABdhPJyeRNNyZkV5EU+QgGthhBil9tgxhkp+m7+xL0UYUUKdpPRrLCR78Fjdf0cl7uFBTxURbgp9gQ==
X-Received: by 2002:a5d:4e0e:: with SMTP id p14mr13249625wrt.58.1612090770140;
        Sun, 31 Jan 2021 02:59:30 -0800 (PST)
Received: from localhost.localdomain ([46.166.128.205])
        by smtp.gmail.com with ESMTPSA id t205sm18031870wmt.28.2021.01.31.02.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 02:59:29 -0800 (PST)
From:   Alexander Popov <alex.popov@linux.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Greg KH <greg@kroah.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.popov@linux.com
Subject: [PATCH 1/1] vsock: fix the race conditions in multi-transport support
Date:   Sun, 31 Jan 2021 13:59:14 +0300
Message-Id: <20210131105914.2217229-1-alex.popov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are multiple similar bugs implicitly introduced by the
commit c0cfa2d8a788fcf4 ("vsock: add multi-transports support") and
commit 6a2c0962105ae8ce ("vsock: prevent transport modules unloading").

The bug pattern:
 [1] vsock_sock.transport pointer is copied to a local variable,
 [2] lock_sock() is called,
 [3] the local variable is used.
VSOCK multi-transport support introduced the race condition:
vsock_sock.transport value may change between [1] and [2].

Let's copy vsock_sock.transport pointer to local variables after
the lock_sock() call.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 net/vmw_vsock/af_vsock.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d10916ab4526..28edac1f9aa6 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -997,9 +997,12 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 			mask |= EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
 
 	} else if (sock->type == SOCK_STREAM) {
-		const struct vsock_transport *transport = vsk->transport;
+		const struct vsock_transport *transport = NULL;
+
 		lock_sock(sk);
 
+		transport = vsk->transport;
+
 		/* Listening sockets that have connections in their accept
 		 * queue can be read.
 		 */
@@ -1082,10 +1085,11 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	err = 0;
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
-	transport = vsk->transport;
 
 	lock_sock(sk);
 
+	transport = vsk->transport;
+
 	err = vsock_auto_bind(vsk);
 	if (err)
 		goto out;
@@ -1544,10 +1548,11 @@ static int vsock_stream_setsockopt(struct socket *sock,
 	err = 0;
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
-	transport = vsk->transport;
 
 	lock_sock(sk);
 
+	transport = vsk->transport;
+
 	switch (optname) {
 	case SO_VM_SOCKETS_BUFFER_SIZE:
 		COPY_IN(val);
@@ -1680,7 +1685,6 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
-	transport = vsk->transport;
 	total_written = 0;
 	err = 0;
 
@@ -1689,6 +1693,8 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	lock_sock(sk);
 
+	transport = vsk->transport;
+
 	/* Callers should not provide a destination with stream sockets. */
 	if (msg->msg_namelen) {
 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
@@ -1823,11 +1829,12 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
-	transport = vsk->transport;
 	err = 0;
 
 	lock_sock(sk);
 
+	transport = vsk->transport;
+
 	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
 		/* Recvmsg is supposed to return 0 if a peer performs an
 		 * orderly shutdown. Differentiate between that case and when a
-- 
2.26.2

