Return-Path: <netdev+bounces-5838-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B81F713162
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 03:13:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42AFA2819CE
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 01:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E130380;
	Sat, 27 May 2023 01:13:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB7037D
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 01:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EE4C433EF;
	Sat, 27 May 2023 01:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685150019;
	bh=bnZn/fQHYsSl0pv4U7PItA9rlBxxlQgsJQwYXNj4rNk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=T0S4ZXibwLE948S8DRkzaDSL0v6FqP/y6telzB9wrL9huYI6cKGaMzFhOr+Pgqhyr
	 L52M64xyEB3qyUrRqc9lOSlGxwf8O/Evs//Dr8tmDSQ5zDmrZSjnSFtpG+SvcbGg21
	 AlC2Dd7CT/iaW9EuBn6kFNvboA3TIQ+KXblFHF/ZJWEAvn8cEmp2EQmcyMYtlxhJGH
	 znZxp/KUtnS5hM/pWGE7sp+VZD+tvEC2616y+RGcnb2UuXbhkalLlcRbIuArJ6AKs/
	 vLIopOHNRkuWFx1VTcwciH0SAVhfg8LT6eOvHa0PhwGMsvVJXNSOHDEr7blO/kBIep
	 049T+tKPBZfvQ==
Date: Fri, 26 May 2023 18:13:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>, David Ahern <dsahern@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Chuck Lever
 <chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>, John
 Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next 10/12] tls/sw: Convert tls_sw_sendpage() to use
 MSG_SPLICE_PAGES
Message-ID: <20230526181338.03a99016@kernel.org>
In-Reply-To: <20230524153311.3625329-11-dhowells@redhat.com>
References: <20230524153311.3625329-1-dhowells@redhat.com>
	<20230524153311.3625329-11-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 16:33:09 +0100 David Howells wrote:
> Convert tls_sw_sendpage() and tls_sw_sendpage_locked() to use sendmsg()
> with MSG_SPLICE_PAGES rather than directly splicing in the pages itself.
> 
> [!] Note that tls_sw_sendpage_locked() appears to have the wrong locking
>     upstream.  I think the caller will only hold the socket lock, but it
>     should hold tls_ctx->tx_lock too.

Lock ordering, as you probably discovered. It is what it is :|

> +	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
> +			       MSG_CMSG_COMPAT | MSG_SPLICE_PAGES |
> +			       MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
> +		return -EOPNOTSUPP;

Now MSG_SENDPAGE_* can leak in thru the sendmsg() call?
Letting MSG_SENDPAGE_NOPOLICY in seems pretty suspicious, no?

