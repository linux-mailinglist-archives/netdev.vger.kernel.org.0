Return-Path: <netdev+bounces-8973-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7ABA72670F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00CAF1C20BD5
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52C637348;
	Wed,  7 Jun 2023 17:19:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC5F3732E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBBBC433D2;
	Wed,  7 Jun 2023 17:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686158387;
	bh=sM9s5rM2STlzlaVPLAL0I0uiZASg+eSmYmdRpfR8XhA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kQpZB91nZiuTOirqxWJgBPdqf25i2CyhejL+gKom8fvSGnOZB68iLEp89ML4qSTP3
	 hgwvsrMX1Jp0GbQxXzphYLAOQ2fxK+zcFoMMpkH7y24R0H6rKfb32NpUzBk75yYtra
	 6VinNPwHhS5cBbHrTF3ghHOKNqlhYUPKbmEKReGrIVcs77JYGON8x1Dela4expLhLB
	 E6LCB7JcQzcTsW4VEMfKmUBiMyE/Hr4bAutkwbRfaJY4HZN8asyExxWnKGpKPNwBQa
	 0D5dJ3z2PHDmZcCZ0ENLuquMg3jkHsxe6+k+/RpFWNvu3E8wAdx8FhPvDIhCZOdEwC
	 glFM3AnwMbSrA==
Date: Wed, 7 Jun 2023 10:19:45 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
 Chuck Lever <chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>,
 John Fastabend <john.fastabend@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 11/14] tls/sw: Support MSG_SPLICE_PAGES
Message-ID: <20230607101945.65c5df51@kernel.org>
In-Reply-To: <20230607140559.2263470-12-dhowells@redhat.com>
References: <20230607140559.2263470-1-dhowells@redhat.com>
	<20230607140559.2263470-12-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 15:05:56 +0100 David Howells wrote:
> +static int tls_sw_sendmsg_splice(struct sock *sk, struct msghdr *msg,
> +				 struct sk_msg *msg_pl, size_t try_to_copy,
> +				 ssize_t *copied)
> +{
> +	struct page *page = NULL, **pages = &page;
> +
> +	do {
> +		ssize_t part;
> +		size_t off;
> +		bool put = false;
> +
> +		part = iov_iter_extract_pages(&msg->msg_iter, &pages,
> +					      try_to_copy, 1, 0, &off);
> +		if (part <= 0)
> +			return part ?: -EIO;
> +
> +		if (WARN_ON_ONCE(!sendpage_ok(page))) {
> +			iov_iter_revert(&msg->msg_iter, part);
> +			return -EIO;
> +		}
> +
> +		sk_msg_page_add(msg_pl, page, part, off);
> +		sk_mem_charge(sk, part);
> +		if (put)
> +			put_page(page);

is put ever set to true?

> +		*copied += part;
> +		try_to_copy -= part;
> +	} while (try_to_copy && !sk_msg_full(msg_pl));
> +
> +	return 0;
> +}
> +
>  int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  {
>  	long timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
> @@ -1020,6 +1052,17 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  			full_record = true;
>  		}
>  
> +		if (try_to_copy && (msg->msg_flags & MSG_SPLICE_PAGES)) {
> +			ret = tls_sw_sendmsg_splice(sk, msg, msg_pl,
> +						    try_to_copy, &copied);
> +			if (ret < 0)
> +				goto send_end;
> +			tls_ctx->pending_open_record_frags = true;
> +			if (full_record || eor || sk_msg_full(msg_pl))
> +				goto copied;
> +			continue;
> +		}
> +
>  		if (!is_kvec && (full_record || eor) && !async_capable) {
>  			u32 first = msg_pl->sg.end;
>  
> @@ -1082,8 +1125,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  		/* Open records defined only if successfully copied, otherwise
>  		 * we would trim the sg but not reset the open record frags.
>  		 */
> -		tls_ctx->pending_open_record_frags = true;
>  		copied += try_to_copy;
> +copied:
> +		tls_ctx->pending_open_record_frags = true;

Why move pending-open-record-frags setting if it's also set before
jumping?

>  		if (full_record || eor) {
>  			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
>  						  record_type, &copied,

