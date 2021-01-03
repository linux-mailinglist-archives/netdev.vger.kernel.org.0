Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46742E8E25
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 21:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbhACUu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 15:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbhACUu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 15:50:26 -0500
Received: from forward100o.mail.yandex.net (forward100o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A30DC061573;
        Sun,  3 Jan 2021 12:49:45 -0800 (PST)
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward100o.mail.yandex.net (Yandex) with ESMTP id 18D7B4AC077A;
        Sun,  3 Jan 2021 23:49:43 +0300 (MSK)
Received: from vla1-3189804b1249.qloud-c.yandex.net (vla1-3189804b1249.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:901:0:640:3189:804b])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id 12C4461E0010;
        Sun,  3 Jan 2021 23:49:43 +0300 (MSK)
Received: from vla3-ed9353d06502.qloud-c.yandex.net (vla3-ed9353d06502.qloud-c.yandex.net [2a02:6b8:c15:2588:0:640:ed93:53d0])
        by vla1-3189804b1249.qloud-c.yandex.net (mxback/Yandex) with ESMTP id M44tFIzjG2-nhEeG5CB;
        Sun, 03 Jan 2021 23:49:43 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1609706983;
        bh=9ckIwmy9PSnfQ/tym4LhTsJrHE234hYs4s+7MtEUwSk=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=W/kggSRwDaMv1B1YkMru3ZS7Rqk6zezZmJTAZ8+J8AhtM0BZmmmz6QoqnRCjr3E6a
         5eT76sdZb3if+kklnF8aYF64tn1+y3d/1AW3u0Pxcx9ybidG5O/4qoShJyX6+XuGCp
         MVwOEsOm6mvOXJf6YtETKuBltYw7AULLWF+Chdmc=
Authentication-Results: vla1-3189804b1249.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla3-ed9353d06502.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id YkpNk0ZYt0-nfjKDElL;
        Sun, 03 Jan 2021 23:49:41 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH 3/5] af_vsock: send/receive loops for SOCK_SEQPACKET.
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arseniy Krasnov <oxffffaa@gmail.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210103195454.1954169-1-arseny.krasnov@kaspersky.com>
 <20210103200347.1956354-1-arseny.krasnov@kaspersky.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <8ffb1753-c95b-c8f3-6ed9-112bf35623be@yandex.ru>
Date:   Sun, 3 Jan 2021 23:49:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210103200347.1956354-1-arseny.krasnov@kaspersky.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny!

03.01.2021 23:03, Arseny Krasnov пишет:
> From: Arseniy Krasnov <oxffffaa@gmail.com>
>
>    For send, this patch adds:
>    1) Send of record begin marker with record length.
>    2) Return error if send of whole record is failed.
>
>    For receive, this patch adds another loop, it looks like
>    stream loop, but:
>    1) It doesn't call notify callbacks.
>    2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT'
>       values.
>    3) It waits until whole record is received or error is
>       found during receiving.
>    3) It processes and sets 'MSG_TRUNC' flag.
> ---
>   net/vmw_vsock/af_vsock.c | 319 +++++++++++++++++++++++++++++++--------
>   1 file changed, 256 insertions(+), 63 deletions(-)
>
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index b12d3a322242..7ff00449a9a2 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -1683,8 +1683,8 @@ static int vsock_stream_getsockopt(struct socket *sock,
>   	return 0;
>   }
>   
> -static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
> -				size_t len)
> +static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> +				     size_t len)
>   {
>   	struct sock *sk;
>   	struct vsock_sock *vsk;
> @@ -1737,6 +1737,12 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>   	if (err < 0)
>   		goto out;
>   
> +	if (sk->sk_type == SOCK_SEQPACKET) {
> +		err = transport->seqpacket_seq_send_len(vsk, len);
> +		if (err < 0)
> +			goto out;
> +	}
> +
>   	while (total_written < len) {
>   		ssize_t written;
>   
> @@ -1796,10 +1802,8 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>   		 * smaller than the queue size.  It is the caller's
>   		 * responsibility to check how many bytes we were able to send.
>   		 */
> -
> -		written = transport->stream_enqueue(
> -				vsk, msg,
> -				len - total_written);
> +		written = transport->stream_enqueue(vsk, msg,
> +						    len - total_written);

White-space change?


>   		if (written < 0) {
>   			err = -ENOMEM;
>   			goto out_err;
> @@ -1815,36 +1819,96 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>   	}
>   
>   out_err:
> -	if (total_written > 0)
> -		err = total_written;
> +	if (total_written > 0) {
> +		/* Return number of written bytes only if:
> +		 * 1) SOCK_STREAM socket.
> +		 * 2) SOCK_SEQPACKET socket when whole buffer is sent.
> +		 */
> +		if (sk->sk_type == SOCK_STREAM || total_written == len)
> +			err = total_written;
> +	}
>   out:
>   	release_sock(sk);
>   	return err;
>   }
>   
> +static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
> +				size_t len)
> +{
> +	return vsock_connectible_sendmsg(sock, msg, len);
> +}
>   
> -static int
> -vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> -		     int flags)
> +static int vsock_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
> +				   size_t len)
>   {
> -	struct sock *sk;
> +	return vsock_connectible_sendmsg(sock, msg, len);
> +}
> +
> +static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
> +			   long timeout,
> +			   struct vsock_transport_recv_notify_data *recv_data,
> +			   size_t target)
> +{

You patch looks quite large because
of this, so would it make sense to separate
out the refactoring part (vsock_wait_data()
and friends that you seem to copy out of
recvmsg() code) as the separate patch?
Currently its a bit difficult to see what was
added and what was "refactored".


> +	int err = 0;
>   	struct vsock_sock *vsk;
>   	const struct vsock_transport *transport;
> -	int err;
> -	size_t target;
> -	ssize_t copied;
> -	long timeout;
> -	struct vsock_transport_recv_notify_data recv_data;
> -
> -	DEFINE_WAIT(wait);
>   
> -	sk = sock->sk;
>   	vsk = vsock_sk(sk);
>   	transport = vsk->transport;
> -	err = 0;
>   
> +	if (sk->sk_err != 0 ||
> +	    (sk->sk_shutdown & RCV_SHUTDOWN) ||
> +	    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
> +		finish_wait(sk_sleep(sk), wait);
> +		return -1;
> +	}
> +	/* Don't wait for non-blocking sockets. */
> +	if (timeout == 0) {
> +		err = -EAGAIN;
> +		finish_wait(sk_sleep(sk), wait);
> +		return err;
> +	}
> +
> +	if (sk->sk_type == SOCK_STREAM) {
> +		err = transport->notify_recv_pre_block(vsk, target, recv_data);
> +		if (err < 0) {
> +			finish_wait(sk_sleep(sk), wait);
> +			return err;
> +		}
> +	}
> +
> +	release_sock(sk);
> +	timeout = schedule_timeout(timeout);
>   	lock_sock(sk);
>   
> +	if (signal_pending(current)) {
> +		err = sock_intr_errno(timeout);
> +		finish_wait(sk_sleep(sk), wait);
> +	} else if (timeout == 0) {
> +		err = -EAGAIN;
> +		finish_wait(sk_sleep(sk), wait);
> +	}
> +
> +	return err;
> +}
> +
> +static int vsock_wait_data_seqpacket(struct sock *sk, struct wait_queue_entry *wait,
> +				     long timeout)
> +{
> +	return vsock_wait_data(sk, wait, timeout, NULL, 0);

Would it make sense to structure that
differently? If vsock_wait_data() does
"more things" than vsock_wait_data_seqpacket(),
then would it be possible to make
vsock_wait_data() to call vsock_wait_data_seqpacket()
(or some common part of both), rather
than to null out unused arguments?


> +}
> +
> +static int vsock_pre_recv_check(struct socket *sock,
> +				int flags, size_t len, int *err)
> +{
> +	struct sock *sk;
> +	struct vsock_sock *vsk;
> +	const struct vsock_transport *transport;
> +
> +	sk = sock->sk;
> +	vsk = vsock_sk(sk);
> +	transport = vsk->transport;
> +
>   	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
>   		/* Recvmsg is supposed to return 0 if a peer performs an
>   		 * orderly shutdown. Differentiate between that case and when a
> @@ -1852,16 +1916,16 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>   		 * SOCK_DONE flag.
>   		 */
>   		if (sock_flag(sk, SOCK_DONE))
> -			err = 0;
> +			*err = 0;
>   		else
> -			err = -ENOTCONN;
> +			*err = -ENOTCONN;
>   
> -		goto out;
> +		return false;

Hmm, are you sure you need to convert
"err" to the pointer, just to return true/false
as the return value?
How about still returning "err" itself?


>   	}
>   
>   	if (flags & MSG_OOB) {
> -		err = -EOPNOTSUPP;
> -		goto out;
> +		*err = -EOPNOTSUPP;
> +		return false;
>   	}
>   
>   	/* We don't check peer_shutdown flag here since peer may actually shut
> @@ -1869,17 +1933,143 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>   	 * receive.
>   	 */
>   	if (sk->sk_shutdown & RCV_SHUTDOWN) {
> -		err = 0;
> -		goto out;
> +		*err = 0;
> +		return false;
>   	}
>   
>   	/* It is valid on Linux to pass in a zero-length receive buffer.  This
>   	 * is not an error.  We may as well bail out now.
>   	 */
>   	if (!len) {
> +		*err = 0;
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
> +				     size_t len, int flags)
> +{
> +	int err = 0;
> +	size_t record_len;
> +	struct vsock_sock *vsk;
> +	const struct vsock_transport *transport;
> +	long timeout;
> +	ssize_t dequeued_total = 0;
> +	unsigned long orig_nr_segs;
> +	const struct iovec *orig_iov;
> +	DEFINE_WAIT(wait);
> +
> +	vsk = vsock_sk(sk);
> +	transport = vsk->transport;
> +
> +	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
> +	msg->msg_flags &= ~MSG_EOR;
> +	orig_nr_segs = msg->msg_iter.nr_segs;
> +	orig_iov = msg->msg_iter.iov;
> +
> +	while (1) {
> +		s64 ready;
> +
> +		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
> +		ready = vsock_stream_has_data(vsk);
> +
> +		if (ready == 0) {
> +			if (vsock_wait_data_seqpacket(sk, &wait, timeout)) {
> +				/* In case of any loop break(timeout, signal
> +				 * interrupt or shutdown), we report user that
> +				 * nothing was copied.
> +				 */
> +				dequeued_total = 0;
> +				break;
> +			}
> +		} else {
> +			ssize_t dequeued;
> +
> +			finish_wait(sk_sleep(sk), &wait);
> +
> +			if (ready < 0) {
> +				err = -ENOMEM;
> +				goto out;
> +			}
> +
> +			if (dequeued_total == 0) {
> +				record_len =
> +					transport->seqpacket_seq_get_len(vsk);
> +
> +				if (record_len == 0)
> +					continue;
> +			}
> +
> +			/* 'msg_iter.count' is number of unused bytes in iov.
> +			 * On every copy to iov iterator it is decremented at
> +			 * size of data.
> +			 */
> +			dequeued = transport->stream_dequeue(vsk, msg,
> +						msg->msg_iter.count, flags);
> +
> +			if (dequeued < 0) {
> +				dequeued_total = 0;
> +
> +				if (dequeued == -EAGAIN) {
> +					iov_iter_init(&msg->msg_iter, READ,
> +						      orig_iov, orig_nr_segs,
> +						      len);
> +					msg->msg_flags &= ~MSG_EOR;
> +					continue;
> +				}
> +
> +				err = -ENOMEM;
> +				break;
> +			}
> +
> +			dequeued_total += dequeued;
> +
> +			if (dequeued_total >= record_len)
> +				break;
> +		}
> +	}
> +
> +	if (sk->sk_err)
> +		err = -sk->sk_err;
> +	else if (sk->sk_shutdown & RCV_SHUTDOWN)
>   		err = 0;
> -		goto out;
> +
> +	if (dequeued_total > 0) {
> +		/* User sets MSG_TRUNC, so return real length of
> +		 * packet.
> +		 */
> +		if (flags & MSG_TRUNC)
> +			err = record_len;
> +		else
> +			err = len - msg->msg_iter.count;

Its not very clear (only for me perhaps) how
dequeue_total and len correlate. Are they
equal here? Would you need to check that
dequeued_total >= record_len?
I mean, its just a bit strange that you check
dequeued_total>0 and no longer use that var
inside the block.

