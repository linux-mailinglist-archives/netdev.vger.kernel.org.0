Return-Path: <netdev+bounces-5843-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C84713214
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 05:12:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A60F81C21122
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 03:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A458C394;
	Sat, 27 May 2023 03:12:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749A8389
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 03:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E27C433EF;
	Sat, 27 May 2023 03:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685157124;
	bh=LJQ/LuDu59EMiwcWT0lcrMyGH/81VTyAMGBUL/u1fKA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t3dIWnQNEST7MNFSz4icE8NVqDhbPpHnw8eb4RXLNyS9UTdk7URq350RkrKZt+tXp
	 woikm0rkQ0G1YHfk/zPYUNd68o5tAoJttofuqbjod8mcLvwxmoH0wUUmlg/jFe2bR9
	 0ltAzLHQRdpEZf1DYtdB1RUp/xsvLwj/SGx2+GWt3EN33Tz0X5zluYdcinHH4MI8M9
	 FN47eZfNVpSSLZW3hdESDHnGb7SIoU7Hstiyb2JHk+ohE6m0g5lgTlpVItUEwOIpex
	 kYXmc2AdjUVacPlwo4POLe0UPLlg/T2hngINzf0e65/lP3ec+0gH7QMJdFyEPI/xEv
	 Lf5AYVSqtOc0w==
Date: Fri, 26 May 2023 20:12:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>, David Ahern <dsahern@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Tom Herbert
 <tom@herbertland.com>, Tom Herbert <tom@quantonium.net>
Subject: Re: [PATCH net-next 3/4] kcm: Support MSG_SPLICE_PAGES
Message-ID: <20230526201202.1cd35fe9@kernel.org>
In-Reply-To: <20230524144923.3623536-4-dhowells@redhat.com>
References: <20230524144923.3623536-1-dhowells@redhat.com>
	<20230524144923.3623536-4-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 15:49:22 +0100 David Howells wrote:
> +			err = skb_splice_from_iter(skb, &msg->msg_iter, copy,
> +						   sk->sk_allocation);
> +			if (err < 0) {
> +				if (err == -EMSGSIZE)
> +					goto wait_for_memory;
> +				goto out_error;
> +			}
>  

should there be a:

		copy = err;
or:
		copy -= msg_data_left(msg);

or some such here? Can we safely assume that skb_splice_from_iter() will
copy all or nothing? 

> -		err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
> -					       pfrag->page,
> -					       pfrag->offset,
> -					       copy);
> -		if (err)
> -			goto out_error;
> +			skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;

