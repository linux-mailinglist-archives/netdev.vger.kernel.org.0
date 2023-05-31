Return-Path: <netdev+bounces-6633-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80471717271
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:32:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 126601C20DED
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA66650;
	Wed, 31 May 2023 00:32:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEFE1641B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D875C433D2;
	Wed, 31 May 2023 00:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685493134;
	bh=R71oU/0C7O8aZ1Fo65yDpnqy1TpGhfrRouAYxvAjdW8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OUzgd5vhGClmDKAEtoIbqwLsQS0UPyIv9zBCQ5Ph80pA8CbxCAJoXLCUZjfxEsmj7
	 PgTvwepq7y4uuHCcIpViRQhnOV+J8SuU5K1zrY+2j54yrHw/X8REBwzUBj8eqGRrM6
	 pEHx97BTFBdADQPYE82kZ5igqX4LDL7AzYZELUfpd5lNNlBZtEgaatqMi9I5EZYHC1
	 tDUVfAVWLMfSBDb9LfdAr9FmihzxuO+r5Kwl7Pnsd1ZWBjjh98avBnsP7Lqm43iFTS
	 bjvK9giC87TxwLMoTpme192nFucxCXdbfUIxehZ0GyPv7hkeqtIfftVQFWK5Do8Izr
	 oz0lrJhs7RgQw==
Date: Tue, 30 May 2023 17:32:12 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>, David Ahern <dsahern@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Chuck Lever
 <chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>, John
 Fastabend <john.fastabend@gmail.com>, Christoph Hellwig
 <hch@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Bug in short splice to socket?
Message-ID: <20230530173212.5fec9fc3@kernel.org>
In-Reply-To: <499791.1685485603@warthog.procyon.org.uk>
References: <20230526180844.73745d78@kernel.org>
	<20230524153311.3625329-1-dhowells@redhat.com>
	<20230524153311.3625329-10-dhowells@redhat.com>
	<499791.1685485603@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 May 2023 23:26:43 +0100 David Howells wrote:
> Interesting.  Now that you've pointed me at it, I've tried running it.  Mostly
> it passes, but I'm having some problems with the multi_chunk_sendfile tests
> that time out.  I think that splice_direct_to_actor() has a bug.  The problem
> is this bit of code:
> 
> 		/*
> 		 * If more data is pending, set SPLICE_F_MORE
> 		 * If this is the last data and SPLICE_F_MORE was not set
> 		 * initially, clears it.
> 		 */
> 		if (read_len < len)
> 			sd->flags |= SPLICE_F_MORE;
> 		else if (!more)
> 			sd->flags &= ~SPLICE_F_MORE;
> 
> When used with sendfile(), it sets SPLICE_F_MORE (which causes MSG_MORE to be
> passed to the network protocol) if we haven't yet read everything that the
> user requested and clears it if we fulfilled what the user requested.
> 
> This has the weird effect that MSG_MORE gets kind of inverted.  It's never
> seen by the actor if we can read the entire request into the pipe - except if
> we hit the EOF first.  If we hit the EOF before we fulfil the entire request,
> we get a short read and SPLICE_F_MORE and thus MSG_MORE *is* set.  The
> upstream TLS code ignores it - but I'm changing this with my patches as
> sendmsg() then uses it to mark the EOR.
> 
> I think we probably need to fix this in some way to check the size of source
> file - which may not be a regular file:-/  With the attached change, all tests
> pass; without it, a bunch of tests fail with timeouts.

Yeah.. it's one of those 'known warts' which we worked around in TLS
because I don't know enough about VFS to confidently fix it in fs/.
Proper fix would be pretty nice to have.

The original-original report of the problem is here, FWIW:
https://lore.kernel.org/netdev/1591392508-14592-1-git-send-email-pooja.trivedi@stackpath.com/

And my somewhat hacky fix was d452d48b9f8.

