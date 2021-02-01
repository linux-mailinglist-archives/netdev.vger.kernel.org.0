Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B721330A38B
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 09:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhBAIsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 03:48:22 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:35344 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhBAIsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 03:48:19 -0500
Received: by mail-wr1-f51.google.com with SMTP id l12so15636087wry.2;
        Mon, 01 Feb 2021 00:48:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2T72/t+gfWjspMOi6fY4znoktPBAWMpk+HQYetTKm2Y=;
        b=tFy5WzVFZcHMsWTvCE7GlfHtbkm60E6C6XC0MTswlH6+uM5cm+dhVivHv07esvr/AE
         DObLt2RnBdlyjyHEeZP17YJpFf2MtO9eyh4qHGSYNxJI4uXjiYGca5j2aBuc1xrefD72
         sYG1sQzF6WZGfKUhicdc+2DPB8GmKhBmOL8yhKRw678r9ll+e/TNL6qVOovIp6OZHkaO
         Y463tIePzusIT7sEYOpbHCnU1ClbPrXvIFYdbV1MvWTIbsMBztb8EiR4D7EqHf26zMOT
         7PRWgRw0ktUQ0LAP6QHJHt2323bCpt4LB/4vm1+opDHcezlQ9hXYmygiwwa+q+ERF4yw
         w0PQ==
X-Gm-Message-State: AOAM530Nyj1czC9F1pKNdKvd2mwKGF8AtRS5JXOtFdXzazxgiE6ZucA8
        rbFOmDXgmCxSdOwdAJ0wYIg=
X-Google-Smtp-Source: ABdhPJxndKuKJsR3M9TqgEi2Op1P+n3n3buAS1LlFPuolSj3NEmxlPjtI4Np2XjwkqUnpgL6Nx1KUw==
X-Received: by 2002:a05:6000:1082:: with SMTP id y2mr16236652wrw.27.1612169254477;
        Mon, 01 Feb 2021 00:47:34 -0800 (PST)
Received: from localhost.localdomain ([46.166.128.205])
        by smtp.gmail.com with ESMTPSA id k131sm20860189wmb.37.2021.02.01.00.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 00:47:33 -0800 (PST)
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
Subject: [PATCH v2 1/1] vsock: fix the race conditions in multi-transport support
Date:   Mon,  1 Feb 2021 11:47:19 +0300
Message-Id: <20210201084719.2257066-1-alex.popov@linux.com>
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

Fixes: c0cfa2d8a788fcf4 ("vsock: add multi-transports support")

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 net/vmw_vsock/af_vsock.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d10916ab4526..f64e681493a5 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -997,9 +997,12 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 			mask |= EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
 
 	} else if (sock->type == SOCK_STREAM) {
-		const struct vsock_transport *transport = vsk->transport;
+		const struct vsock_transport *transport;
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

