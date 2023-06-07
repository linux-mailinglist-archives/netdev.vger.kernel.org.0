Return-Path: <netdev+bounces-8981-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C838726784
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:34:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96FF12811AF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A9F38CA0;
	Wed,  7 Jun 2023 17:34:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAFF37355
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B558C4339B;
	Wed,  7 Jun 2023 17:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686159271;
	bh=ZvKkcdQ1lOUxF1b2GWrc8NYGJ2lVBPJVjPW9hRJYDeI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=f1DYw+dARGN05S/WBtv2Cv3qeGsq03nD/hjgdBmRuZn7tHofzqrcVc3qmxpX6RZ9N
	 xIiXWKferDCKJj3wBA163Od+ev9SAuMo2CRtKL4Oc+BFr+y/gHHwcPjLN7wRBGbZdr
	 DH0YrspVUj4s3jnJ8AvaiuflIIoreADBS+niNH8Akf62Svt4IQVHY5ziZhoHXXiqzg
	 cx7QTYjjdNi91iWHPWR1sg9fy0YZVA8mE5XT7KcioQ211J5NadouXr89vDn0H1UYtz
	 lCS8bvvAORmfeuLFBO9Yhk28Fum6KK3XHkF1CjzZNmuVffM8ro2wHac2l/3t5fJ5WO
	 U6m8y87qq73rA==
Date: Wed, 7 Jun 2023 10:34:29 -0700
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
Message-ID: <20230607103429.2f4162af@kernel.org>
In-Reply-To: <2293095.1686159070@warthog.procyon.org.uk>
References: <2291292.1686158954@warthog.procyon.org.uk>
	<20230607101945.65c5df51@kernel.org>
	<20230607140559.2263470-1-dhowells@redhat.com>
	<20230607140559.2263470-12-dhowells@redhat.com>
	<2293095.1686159070@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 07 Jun 2023 18:31:10 +0100 David Howells wrote:
> > > Why move pending-open-record-frags setting if it's also set before
> > > jumping?  
> > 
> > I should probably remove it from before the goto - unless you'd prefer to do
> > it in both places.  
> 
> Actually, I need to keep the one before the goto.

Yeah, feels like goes together with updating copied, really,
not no point passing it all the way to tls_sw_sendmsg_splice().
I'd drop the reshuffle next to the label.

