Return-Path: <netdev+bounces-8974-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA344726714
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:20:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85938281403
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C2C37351;
	Wed,  7 Jun 2023 17:20:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95CD3732E;
	Wed,  7 Jun 2023 17:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17FDC433EF;
	Wed,  7 Jun 2023 17:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686158424;
	bh=adqvDA+1TjaAGnTMKfAosw2t+UHx0gdR3o+C9+WLfas=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QrgEDUrpuvtjtYYXyNXRk1dM2+tU5LatKXwXs/1xrXOOFssrCslRRsYtUyt3hdrkn
	 Dh+x3YRI3wjtLLcilrzbAlRVvaLYnG0rcVd/Zq5rTIqTJb/bk6b2AdJhN2Jwvr5VQy
	 Y+psu3Ozz53QvE8pkOaoGyFJra9fJeporG6xTn4ngLRRqX0uGjaWkRdg3rbA0NO/bn
	 Ou7iQI5PFw3OR4mfe5YqMygaocJk4FR2iqfVb4093jkA93CKs5hB+FL+jEI4h/LAmU
	 z/1SnG7PASoJh0YamOmuhju0WO98sy0xlKkuv/wDL7v5AV7XKcTVyZ4CA0JS3GEw1z
	 tKCVsbaX9/Elg==
Date: Wed, 7 Jun 2023 10:20:22 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
 Chuck Lever <chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>,
 John Fastabend <john.fastabend@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v5 12/14] tls/sw: Convert tls_sw_sendpage() to
 use MSG_SPLICE_PAGES
Message-ID: <20230607102022.42498d4d@kernel.org>
In-Reply-To: <20230607140559.2263470-13-dhowells@redhat.com>
References: <20230607140559.2263470-1-dhowells@redhat.com>
	<20230607140559.2263470-13-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 15:05:57 +0100 David Howells wrote:
> Convert tls_sw_sendpage() and tls_sw_sendpage_locked() to use sendmsg()
> with MSG_SPLICE_PAGES rather than directly splicing in the pages itself.
> 
> [!] Note that tls_sw_sendpage_locked() appears to have the wrong locking
>     upstream.  I think the caller will only hold the socket lock, but it
>     should hold tls_ctx->tx_lock too.
> 
> This allows ->sendpage() to be replaced by something that can handle
> multiple multipage folios in a single transaction.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

