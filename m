Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC9330A345
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 09:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbhBAI2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 03:28:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31168 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232353AbhBAI2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 03:28:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612168009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WP9i5DIvdYejvYtp42qhkZwaypP/VKlZOUHQkG/eOv0=;
        b=BtHMACEHw+f3Z8XnR3tlbMJ6XBf3dWSOSZwqSfzviYBkFdJWfP7VHjIaytGxUHab6A58EG
        dg92R6JnofrORhQaObVrOyXLbUTsqr06JAboM1B3977rLpWZiLn7biavdfp7fdNamxjE3g
        jm0RhPtOs14H4FL99NDP8EQzjlDGg2c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-SpMH98UeOuqhduJJDdCCRw-1; Mon, 01 Feb 2021 03:26:47 -0500
X-MC-Unique: SpMH98UeOuqhduJJDdCCRw-1
Received: by mail-wr1-f71.google.com with SMTP id b14so10007130wrw.12
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 00:26:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WP9i5DIvdYejvYtp42qhkZwaypP/VKlZOUHQkG/eOv0=;
        b=Niy4+PdHBS4VS4FkXKs30HW7oYWKdpkFXEa9V8gbk65fr7SmcNvD0mZLtJC8q4m+Kq
         YZ/MaJxxAXXkB75Ws4wv0VBa6CJMr3s9uyT7h8snPG9a0uG74X2FlzTkG6vsboaai3wU
         vG2oQ/U173NSFLJ9TfNpOUCDjqTwenWXOqYzKdBeZkD/Zu0z+OwCRSzYAgfOSdlt0u3g
         PKj1ph/nRXST8fCpLUNuuP7loAx1jakcBq/kxErm9Pe0zCB81huUZtCBhusH32YfpdIN
         0yeg34vZgYzue3zpi0oAQwEKkLJ14rRl37LtmYaP5cp80pBu/kgyMtBwdW+9vawaIkB7
         AviA==
X-Gm-Message-State: AOAM531bI4Z+SDg7gUx2PLFywq38efgAgq/T91DENiaM/RyjM4FCEzEQ
        VFpdBilcylYdGhA6P+WEPkpeUBCkQKGHjm8z9+MkWXBx3lisvVCqpC1QLBkvhAIRcBQDm76FfK5
        lUg1zbp3asb4E9Fhm
X-Received: by 2002:adf:8b47:: with SMTP id v7mr1034873wra.133.1612168006590;
        Mon, 01 Feb 2021 00:26:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+OODwzQPSOcg2L3vSHi/ykZA9ct3VWlUnxsnxU/YUFA+BviS0nwXHhsuxTR7QemSjltYmdg==
X-Received: by 2002:adf:8b47:: with SMTP id v7mr1034861wra.133.1612168006435;
        Mon, 01 Feb 2021 00:26:46 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id i6sm26543586wrs.71.2021.02.01.00.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 00:26:45 -0800 (PST)
Date:   Mon, 1 Feb 2021 09:26:43 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Alexander Popov <alex.popov@linux.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Greg KH <greg@kroah.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vsock: fix the race conditions in multi-transport
 support
Message-ID: <20210201082643.zh3d7x7qzyf4hmfa@steredhat>
References: <20210131105914.2217229-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210131105914.2217229-1-alex.popov@linux.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 01:59:14PM +0300, Alexander Popov wrote:
>There are multiple similar bugs implicitly introduced by the
>commit c0cfa2d8a788fcf4 ("vsock: add multi-transports support") and
>commit 6a2c0962105ae8ce ("vsock: prevent transport modules unloading").
>
>The bug pattern:
> [1] vsock_sock.transport pointer is copied to a local variable,
> [2] lock_sock() is called,
> [3] the local variable is used.
>VSOCK multi-transport support introduced the race condition:
>vsock_sock.transport value may change between [1] and [2].
>
>Let's copy vsock_sock.transport pointer to local variables after
>the lock_sock() call.

We can add:

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")

>
>Signed-off-by: Alexander Popov <alex.popov@linux.com>
>---
> net/vmw_vsock/af_vsock.c | 17 ++++++++++++-----
> 1 file changed, 12 insertions(+), 5 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index d10916ab4526..28edac1f9aa6 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -997,9 +997,12 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 			mask |= EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
>
> 	} else if (sock->type == SOCK_STREAM) {
>-		const struct vsock_transport *transport = vsk->transport;
>+		const struct vsock_transport *transport = NULL;

I think we can avoid initializing to NULL since we assign it shortly 
after.

>+
> 		lock_sock(sk);
>
>+		transport = vsk->transport;
>+
> 		/* Listening sockets that have connections in their accept
> 		 * queue can be read.
> 		 */
>@@ -1082,10 +1085,11 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> 	err = 0;
> 	sk = sock->sk;
> 	vsk = vsock_sk(sk);
>-	transport = vsk->transport;
>
> 	lock_sock(sk);
>
>+	transport = vsk->transport;
>+
> 	err = vsock_auto_bind(vsk);
> 	if (err)
> 		goto out;
>@@ -1544,10 +1548,11 @@ static int vsock_stream_setsockopt(struct 
>socket *sock,
> 	err = 0;
> 	sk = sock->sk;
> 	vsk = vsock_sk(sk);
>-	transport = vsk->transport;
>
> 	lock_sock(sk);
>
>+	transport = vsk->transport;
>+
> 	switch (optname) {
> 	case SO_VM_SOCKETS_BUFFER_SIZE:
> 		COPY_IN(val);
>@@ -1680,7 +1685,6 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>
> 	sk = sock->sk;
> 	vsk = vsock_sk(sk);
>-	transport = vsk->transport;
> 	total_written = 0;
> 	err = 0;
>
>@@ -1689,6 +1693,8 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>
> 	lock_sock(sk);
>
>+	transport = vsk->transport;
>+
> 	/* Callers should not provide a destination with stream sockets. */
> 	if (msg->msg_namelen) {
> 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
>@@ -1823,11 +1829,12 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>
> 	sk = sock->sk;
> 	vsk = vsock_sk(sk);
>-	transport = vsk->transport;
> 	err = 0;
>
> 	lock_sock(sk);
>
>+	transport = vsk->transport;
>+
> 	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
> 		/* Recvmsg is supposed to return 0 if a peer performs an
> 		 * orderly shutdown. Differentiate between that case and when a
>-- 
>2.26.2
>

Thanks for fixing this issues. With the small changes applied:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

