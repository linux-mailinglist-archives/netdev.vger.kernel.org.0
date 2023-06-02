Return-Path: <netdev+bounces-7519-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24785720878
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A83F281A1D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C4353331E;
	Fri,  2 Jun 2023 17:38:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAB033310
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 17:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384C4C433D2;
	Fri,  2 Jun 2023 17:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685727490;
	bh=tyuyaCyjpf6CROtQXm79S5ChlAu2Sqryhr8g2REUdQI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OkZuTHOvmvkHSYWNZMlE7mwqLosImfDDfrsWQwVZEt1PW9x8yqvsU/y+qzsyfX36D
	 0lgkUg1kORMnRV4vlez4UR3Ghj4EGv0STHXHKqNsl2J+yx4Gg3RqM0GVYcywzDpY97
	 HJ0cUkHQeAskSvO4l7K8JEm7n8HzO19LeTxFN35AY3fDbHh4y188VeNuTdoL0QaS8R
	 heVG85eO6WDEuH45YiVfHXqNtKq80eZTDfyfyVjnhG9cUVF8Je0J1QSPCG+mQP7P3P
	 SCZh7s/JDdVcVH3jYwYfiknVvqvJbklEIkWvtKDXFgw/R4kF9k7RQ7jioL17MicYcC
	 CRchZsA3eOoWg==
Date: Fri, 2 Jun 2023 10:38:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, David Ahern <dsahern@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Chuck Lever
 <chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>, John
 Fastabend <john.fastabend@gmail.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: Bug in short splice to socket?
Message-ID: <20230602103809.1510cbef@kernel.org>
In-Reply-To: <CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com>
References: <CAHk-=wji_2UwFMkUYkygsYRek05NwaQkH-vA=yKQtQS9Js+urQ@mail.gmail.com>
	<20230524153311.3625329-1-dhowells@redhat.com>
	<20230524153311.3625329-10-dhowells@redhat.com>
	<20230526180844.73745d78@kernel.org>
	<499791.1685485603@warthog.procyon.org.uk>
	<CAHk-=wgeixW3cc=Ys8eL0_+22FUhqeEru=nzRrSXy1U4YQdE-w@mail.gmail.com>
	<CAHk-=wghhHghtvU_SzXxAzfaX35BkNs-x91-Vj6+6tnVEhPrZg@mail.gmail.com>
	<832277.1685630048@warthog.procyon.org.uk>
	<909595.1685639680@warthog.procyon.org.uk>
	<20230601212043.720f85c2@kernel.org>
	<952877.1685694220@warthog.procyon.org.uk>
	<CAHk-=wjvgL5nyZmpYRWBfab4NKvfQ7NjUvUhE3a3wYTyTEHdfQ@mail.gmail.com>
	<1227123.1685706296@warthog.procyon.org.uk>
	<CAHk-=wgyAGUMHmQM-5Eb556z5xiHZB7cF05qjrtUH4F7P-1rSA@mail.gmail.com>
	<20230602093929.29fd447d@kernel.org>
	<CAHk-=whgpCNzmQfTAUY7D8P6t9TgzoLx9Uauu7YGQpgZtg-SYg@mail.gmail.com>
	<CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Jun 2023 13:05:14 -0400 Linus Torvalds wrote:
> Just to harp some more on this - if SPLICE_F_MORE is seen as purely a
> performance hit, with no real semantic value, and will still set
> random packet boundaries but we want big packets for all the _usual_
> cases, then I think something like "splice_end()" can be a fine
> solution regardless of exact semantics.
> 
> Alternatively, if we make it the rule that "splice_end()" is only
> called on EOF situations - so signals etc do not matter - then the
> semantics would be stable and sound fine to me too.
> 
> In that second case, I'd like to literally name it that way, and
> actually call it "splice_eof()". Because I'd like to really make it
> very clear what the semantics would be.
> 
> So a "splice_eof()" sounds fine to me, and we'd make the semantics be
> the current behavior:
> 
>  - splice() sets SPLICE_F_MORE if 'len > read_len'
> 
>  - splice() _clears_ SPLICE_F_MORE if we have hit 'len'
> 
>  - splice always sets SPLICE_F_MORE if it was passed by the user
> 
> BUT with the small new 'splice_eof()' rule that:
> 
>  - if the user did *not* set SPLICE_F_MORE *and* we didn't hit that
> "use all of len" case that cleared SPLICE_F_MORE, *and* we did a
> "->splice_in()" that returned EOF (ie zero), *then* we will also do
> that ->splice_eof() call.
> 
> The above sounds like "stable and possibly useful semantics" to me. It
> would just have to be documented.
> 
> Is that what people want?

->splice_eof() with the proposed semantics sounds perfect for the cases
testers complained about it the past, IMHO. We can pencil that in as the
contingency plan. Actually I like these semantics so much I'm tempted to
ask David to implement it already and save users potential debugging :D

> I don't think it's conceptually any different from my suggestion of
> saying "->splice_read() can set SPLICE_F_MORE if it has more to give",
> just a different implementation that doesn't require changes on the
> splice_read() side.

Setting SPLICE_F_MORE from the input side does feel much cleaner than
guessing in splice.c. But we may end up needing the eof() callback for 
the corner cases, anyway :(

