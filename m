Return-Path: <netdev+bounces-11540-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8BA0733841
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:40:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFF641C20EBA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4134718B0A;
	Fri, 16 Jun 2023 18:40:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CDE171DE
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396E9C433C0;
	Fri, 16 Jun 2023 18:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686940807;
	bh=088HNGSAcbeWBieFKsLLgWtQKc4989L0mbHIDYWXp7k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BtOvvcAWcFQUREDqtwlp9064kAwfQjkUP664e+jg8rpPNCQ9Lf7I1gStMkuczob8D
	 dE1yHfWWZQ+cGS2jwPN08HrajpMQMRL1Q0NfdXC9HNpw3eb7xtNMSq1LsLO8Pk5Kij
	 CFBEuWl0hqJIQk/IM7FjPeN/ixQ5ypYSCOznAACRowQwoWWRKKK5oZbCRrAfgmupU/
	 ydxwCU1cfVroUMdmmIdg/nPiODX2UMrrZ5wLJD7Fp/dZGQSh0ofzcyqSvB/DImeYPS
	 PG5/+5NCkrE4gbu2HLKKjV4rJMCxVXJSoAbYCtB6yXrke1qQw/zEgexD2hMLVQNTND
	 q5BgflSZl3S5g==
Date: Fri, 16 Jun 2023 11:40:06 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: andrew@lunn.ch, netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
 aliceryhl@google.com, miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <20230616114006.3a2a09e5@kernel.org>
In-Reply-To: <20230616.220220.1985070935510060172.ubuntu@gmail.com>
References: <20230614230128.199724bd@kernel.org>
	<8e9e2908-c0da-49ec-86ef-b20fb3bd71c3@lunn.ch>
	<20230615190252.4e010230@kernel.org>
	<20230616.220220.1985070935510060172.ubuntu@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jun 2023 22:02:20 +0900 (JST) FUJITA Tomonori wrote:
> > The skb freeing looks shady from functional perspective.
> > I'm guessing some form of destructor frees the skb automatically
> > in xmit handler(?), but (a) no reason support, (b) kfree_skb_reason()
> > is most certainly not safe to call on all xmit paths...  
> 
> Yeah, I assume that a driver keeps a skb in private data structure
> (such as tx ring) then removes the skb from it after the completion of
> tx; automatically the drop() method runs (where we need to free the
> skb).
> 
> I thought that calling dev_kfree_skb() is fine but no? We also need
> something different for drivers that use other ways to free the skb
> though.
> 
> I use kfree_skb_reason() because dev_kfree_skb() is a macro so it
> can't be called directly from Rust. But I should have used
> dev_kfree_skb() with a helper function.

skbs (generally) can't be freed in an interrupt context.
dev_kfree_skb_any_reason() is probably the most general implementation.
But then we also have a set of functions used in known contexts for fast
object recycling like napi_consume_skb().
How would complex object destruction rules fit in in the Rust world?

