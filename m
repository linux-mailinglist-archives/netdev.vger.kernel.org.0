Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119BC30A397
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 09:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhBAIxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 03:53:12 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:38710 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbhBAIxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 03:53:11 -0500
Received: by mail-wr1-f49.google.com with SMTP id s7so12645987wru.5;
        Mon, 01 Feb 2021 00:52:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jMiLttWqqTJ5WmFvPS0D+kagf6eWZd/IjbHZVvAPBKI=;
        b=KpelRSqooBDjlr3OWCFeFlDtffbT8MEpTPeruoGT7bT2hH5tHm7+kQxeX4m+t5UVfD
         VmYs13kNcXNOMtlt8wbkcduXM3A4ebUnZRokcyOIcoVpnTrNjhNZkliPmGKyyzXGgX8g
         7UKm2oWlhgfxQuIJWp51l7nnVUToaRZuidIL4I3DsD++mAR7wiBDxkupCsqmsHBF76It
         MREqV0wC7XAk1fkjbWKBJtUif1syutKlNSG5v+5Nc5H7rdsrHMzBpU/urrHyPeqOtpL6
         FU7CjjNDRthLSo+qAdUaTgYT5nj5tR5xm4+mjT8UR0UiT2sHrPxUP7fpRKLhnIy2Swxv
         OlPg==
X-Gm-Message-State: AOAM531NsxdFGuywjCGaU2ycF2UBPEyFj/l5WRPlMvMVZP3uEczO6EQO
        nhJ4JaTsfbavrLDMMhAQqRV273gMarQ=
X-Google-Smtp-Source: ABdhPJxzaUkV93oMuplL5J+vCmnhIQMtSBTXtfs3GMQ0dFHejr123BlLM+fOjw9mePVE+oHBM9g5OA==
X-Received: by 2002:a5d:4386:: with SMTP id i6mr16415370wrq.411.1612169549189;
        Mon, 01 Feb 2021 00:52:29 -0800 (PST)
Received: from [10.9.0.22] ([46.166.128.205])
        by smtp.gmail.com with ESMTPSA id p17sm20479142wmg.46.2021.02.01.00.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 00:52:28 -0800 (PST)
Reply-To: alex.popov@linux.com
Subject: Re: [PATCH 1/1] vsock: fix the race conditions in multi-transport
 support
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Greg KH <greg@kroah.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210131105914.2217229-1-alex.popov@linux.com>
 <20210201082643.zh3d7x7qzyf4hmfa@steredhat>
From:   Alexander Popov <alex.popov@linux.com>
Message-ID: <81c0e04f-cf50-8101-b024-16cd8526bec4@linux.com>
Date:   Mon, 1 Feb 2021 11:52:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210201082643.zh3d7x7qzyf4hmfa@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.02.2021 11:26, Stefano Garzarella wrote:
> On Sun, Jan 31, 2021 at 01:59:14PM +0300, Alexander Popov wrote:
>> There are multiple similar bugs implicitly introduced by the
>> commit c0cfa2d8a788fcf4 ("vsock: add multi-transports support") and
>> commit 6a2c0962105ae8ce ("vsock: prevent transport modules unloading").
>>
>> The bug pattern:
>> [1] vsock_sock.transport pointer is copied to a local variable,
>> [2] lock_sock() is called,
>> [3] the local variable is used.
>> VSOCK multi-transport support introduced the race condition:
>> vsock_sock.transport value may change between [1] and [2].
>>
>> Let's copy vsock_sock.transport pointer to local variables after
>> the lock_sock() call.
> 
> We can add:
> 
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> 
>>
>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>> ---
>> net/vmw_vsock/af_vsock.c | 17 ++++++++++++-----
>> 1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index d10916ab4526..28edac1f9aa6 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -997,9 +997,12 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
>> 			mask |= EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
>>
>> 	} else if (sock->type == SOCK_STREAM) {
>> -		const struct vsock_transport *transport = vsk->transport;
>> +		const struct vsock_transport *transport = NULL;
> 
> I think we can avoid initializing to NULL since we assign it shortly 
> after.
> 
>> +
>> 		lock_sock(sk);
>>
>> +		transport = vsk->transport;
>> +
>> 		/* Listening sockets that have connections in their accept
>> 		 * queue can be read.
>> 		 */
>> @@ -1082,10 +1085,11 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>> 	err = 0;
>> 	sk = sock->sk;
>> 	vsk = vsock_sk(sk);
>> -	transport = vsk->transport;
>>
>> 	lock_sock(sk);
>>
>> +	transport = vsk->transport;
>> +
>> 	err = vsock_auto_bind(vsk);
>> 	if (err)
>> 		goto out;
>> @@ -1544,10 +1548,11 @@ static int vsock_stream_setsockopt(struct 
>> socket *sock,
>> 	err = 0;
>> 	sk = sock->sk;
>> 	vsk = vsock_sk(sk);
>> -	transport = vsk->transport;
>>
>> 	lock_sock(sk);
>>
>> +	transport = vsk->transport;
>> +
>> 	switch (optname) {
>> 	case SO_VM_SOCKETS_BUFFER_SIZE:
>> 		COPY_IN(val);
>> @@ -1680,7 +1685,6 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>>
>> 	sk = sock->sk;
>> 	vsk = vsock_sk(sk);
>> -	transport = vsk->transport;
>> 	total_written = 0;
>> 	err = 0;
>>
>> @@ -1689,6 +1693,8 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>>
>> 	lock_sock(sk);
>>
>> +	transport = vsk->transport;
>> +
>> 	/* Callers should not provide a destination with stream sockets. */
>> 	if (msg->msg_namelen) {
>> 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
>> @@ -1823,11 +1829,12 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>>
>> 	sk = sock->sk;
>> 	vsk = vsock_sk(sk);
>> -	transport = vsk->transport;
>> 	err = 0;
>>
>> 	lock_sock(sk);
>>
>> +	transport = vsk->transport;
>> +
>> 	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
>> 		/* Recvmsg is supposed to return 0 if a peer performs an
>> 		 * orderly shutdown. Differentiate between that case and when a
>> -- 
>> 2.26.2
>>
> 
> Thanks for fixing this issues. With the small changes applied:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Hello Stefano,

Thanks for the review.

I've just sent the v2.

Best regards,
Alexander
