Return-Path: <netdev+bounces-7300-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F22D71F93F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 06:20:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9F2A1C21194
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94074185A;
	Fri,  2 Jun 2023 04:20:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF1617EE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 04:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A69BC433EF;
	Fri,  2 Jun 2023 04:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685679645;
	bh=Pe0QdSQELFT4UssZ7PzgR16P5m3tS2P0+wxp1GZ38R8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LowUN665zQHa0uvTb3FnPncpJmTOU6V2ezCMk2A4eHRfj+xwdSDVcHJs4RdFlpstW
	 zW3i/m8g7NW8lAW9X3/pjRFZ5jvXN2qa8OSBxZvXmoWoRJw3+8TRANQ3xS2EqdRI6G
	 L07LXvfPQZsAb6LuqM0HiliMdKF4y3H91+NyH5SlFkozs7p4OZuDlRGs4H1brxJmvG
	 VZ32nd0UfpnzlyFdYqrLLJiX+t9MYpAO+lGLsBVWMfsGU1qC6L0gob7FBrQ8EgnKj7
	 kNccbpYblBEcC2jhymk1mzJ9+SZ/RPV5NBQngac++E/466iVqdsGurLMrvvir2Cue4
	 p5HuUQAOL7BFQ==
Date: Thu, 1 Jun 2023 21:20:43 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, David Ahern <dsahern@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Chuck Lever
 <chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>, John
 Fastabend <john.fastabend@gmail.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: Bug in short splice to socket?
Message-ID: <20230601212043.720f85c2@kernel.org>
In-Reply-To: <909595.1685639680@warthog.procyon.org.uk>
References: <CAHk-=wji_2UwFMkUYkygsYRek05NwaQkH-vA=yKQtQS9Js+urQ@mail.gmail.com>
	<20230524153311.3625329-1-dhowells@redhat.com>
	<20230524153311.3625329-10-dhowells@redhat.com>
	<20230526180844.73745d78@kernel.org>
	<499791.1685485603@warthog.procyon.org.uk>
	<CAHk-=wgeixW3cc=Ys8eL0_+22FUhqeEru=nzRrSXy1U4YQdE-w@mail.gmail.com>
	<CAHk-=wghhHghtvU_SzXxAzfaX35BkNs-x91-Vj6+6tnVEhPrZg@mail.gmail.com>
	<832277.1685630048@warthog.procyon.org.uk>
	<909595.1685639680@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 01 Jun 2023 18:14:40 +0100 David Howells wrote:
> The answer then might be to make TLS handle a zero-length send()

IDK. Eric added MSG_SENDPAGE_NOTLAST 11 years ago, to work around 
this exact problem. Your refactoring happens to break it and what
you're saying sounds to me more or less like "MSG_SENDPAGE_NOTLAST 
is unnecessary, it's user's fault".

A bit unconvincing. Maybe Eric would chime in, I'm not too familiar
with the deadly mess of the unchecked sendmsg()/sendpage() flags.

