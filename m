Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A643513E73
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 00:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352835AbiD1WVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 18:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237230AbiD1WVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 18:21:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8710BF32A
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 15:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DA5E62052
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 22:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F07FC385AD;
        Thu, 28 Apr 2022 22:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651184310;
        bh=3or4zvgjQHVHwI4vaMEOnJsoXlHwYbfcqtfNxpwdQ18=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GaEQnt4ABN1laqc6e9j4/87FT/oBLi4tcck21E14wBG/MTYxfSXtaiYfhHTaD1EPk
         2F9lbLAjBKo1wI2rr3yedVak7GyzuBnuxzvf3iXVCsbnUjbtAT8mCzGAemLNHM8GFF
         587jhTnbtHqEHZ72/OM7qjXrq7mbgC9PUoNnnea9D5dH859O7jhQdZicdEk8ar/9iT
         6CMIGNUSJxYI9kYVQ8fRstrELzv5vqUZ5N8enEM42N0hpqXmjChqHklgM7eLRY753x
         lKQy+NWtAZJc1AWCq/C5pc8NQ1SUZQ/uUSqXo3djDJ3vAoRMr766v3RjWlxFMZhkfM
         k+6T2VIkPJSlw==
Date:   Thu, 28 Apr 2022 15:18:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: pass back data left in socket after receive
Message-ID: <20220428151829.675f78b4@kernel.org>
In-Reply-To: <064c8731-e7f9-c415-5d4d-141a559e2017@kernel.dk>
References: <064c8731-e7f9-c415-5d4d-141a559e2017@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Apr 2022 13:49:34 -0600 Jens Axboe wrote:
> This is currently done for CMSG_INQ, add an ability to do so via struct
> msghdr as well and have CMSG_INQ use that too. If the caller sets
> msghdr->msg_get_inq, then we'll pass back the hint in msghdr->msg_inq.
> 
> Rearrange struct msghdr a bit so we can add this member while shrinking
> it at the same time. On a 64-bit build, it was 96 bytes before this
> change and 88 bytes afterwards.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

LGTM, but I said that once before..  Eric?

FWIW the io_uring patch that uses it is here:
https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-flags2

> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 6f85f5d957ef..12085c9a8544 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -50,6 +50,9 @@ struct linger {
>  struct msghdr {
>  	void		*msg_name;	/* ptr to socket address structure */
>  	int		msg_namelen;	/* size of socket address structure */
> +
> +	int		msg_inq;	/* output, data left in socket */
> +
>  	struct iov_iter	msg_iter;	/* data */
>  
>  	/*
> @@ -62,8 +65,9 @@ struct msghdr {
>  		void __user	*msg_control_user;
>  	};
>  	bool		msg_control_is_user : 1;
> -	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
> +	bool		msg_get_inq : 1;/* return INQ after receive */
>  	unsigned int	msg_flags;	/* flags on received message */
> +	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
>  	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
>  };
>  
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index cf18fbcbf123..78d79e26fb4d 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2335,8 +2335,10 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
>  	if (sk->sk_state == TCP_LISTEN)
>  		goto out;
>  
> -	if (tp->recvmsg_inq)
> +	if (tp->recvmsg_inq) {
>  		*cmsg_flags = TCP_CMSG_INQ;
> +		msg->msg_get_inq = 1;
> +	}
>  	timeo = sock_rcvtimeo(sk, nonblock);
>  
>  	/* Urgent data needs to be handled specially. */
> @@ -2559,7 +2561,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
>  int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
>  		int flags, int *addr_len)
>  {
> -	int cmsg_flags = 0, ret, inq;
> +	int cmsg_flags = 0, ret;
>  	struct scm_timestamping_internal tss;
>  
>  	if (unlikely(flags & MSG_ERRQUEUE))
> @@ -2576,12 +2578,14 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
>  	release_sock(sk);
>  	sk_defer_free_flush(sk);
>  
> -	if (cmsg_flags && ret >= 0) {
> +	if ((cmsg_flags || msg->msg_get_inq) && ret >= 0) {
>  		if (cmsg_flags & TCP_CMSG_TS)
>  			tcp_recv_timestamp(msg, sk, &tss);
> +		if (msg->msg_get_inq)
> +			msg->msg_inq = tcp_inq_hint(sk);
>  		if (cmsg_flags & TCP_CMSG_INQ) {
> -			inq = tcp_inq_hint(sk);
> -			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
> +			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(msg->msg_inq),
> +				 &msg->msg_inq);
>  		}
>  	}
>  	return ret;
> 

