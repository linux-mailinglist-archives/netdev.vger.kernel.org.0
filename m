Return-Path: <netdev+bounces-11709-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B129F734011
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 12:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 966C01C20AF7
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 10:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 220E97481;
	Sat, 17 Jun 2023 10:15:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AAA63D7
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 10:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F83EC433C9;
	Sat, 17 Jun 2023 10:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686996917;
	bh=wmiarHLZGvZh4nRHX8waapvF4RGqM14UH7gyOSP6LOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HnI4tTPFT/OEvorQ1DLtz2Ot9cHWY55D5w7VKvqa/soXuWO46ROLyf6spePLdM9NX
	 S6PQllylUJ7b1usqcYG+clqGW/BorEhHTvsy5JUKiET+74LLgrwm1/AUYIZqBDb8q7
	 TLoqyQnvXqWBKIjOQRk0fSbLSfwPiSJNT67loZOM=
Date: Sat, 17 Jun 2023 12:15:14 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Alice Ryhl <alice@ryhl.io>
Cc: Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>, netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org, aliceryhl@google.com,
	miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <2023061743-reverb-movie-969e@gregkh>
References: <20230614230128.199724bd@kernel.org>
 <8e9e2908-c0da-49ec-86ef-b20fb3bd71c3@lunn.ch>
 <20230615190252.4e010230@kernel.org>
 <20230616.220220.1985070935510060172.ubuntu@gmail.com>
 <20230616114006.3a2a09e5@kernel.org>
 <66dcc87e-e03f-1043-c91d-25d6fa7130a1@ryhl.io>
 <20230616121041.4010f51b@kernel.org>
 <053cb4c3-aab1-23b3-56e3-4f1741e69404@ryhl.io>
 <7dbf3c85-02ca-4c9b-b40d-adcdb85305dd@lunn.ch>
 <c1b23f21-d161-6241-26fb-7a2cbc4c059c@ryhl.io>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1b23f21-d161-6241-26fb-7a2cbc4c059c@ryhl.io>

On Sat, Jun 17, 2023 at 12:08:26PM +0200, Alice Ryhl wrote:
> On 6/16/23 22:04, Andrew Lunn wrote:
> > > Yes, you can certainly put a WARN_ON in the destructor.
> > > 
> > > Another possibility is to use a scope to clean up. I don't know anything
> > > about these skb objects are used, but you could have the user define a
> > > "process this socket" function that you pass a pointer to the skb, then make
> > > the return value be something that explains what should be done with the
> > > packet. Since you must return a value of the right type, this forces you to
> > > choose.
> > > 
> > > Of course, this requires that the processing of packets can be expressed as
> > > a function call, where it only inspects the packet for the duration of that
> > > function call. (Lifetimes can ensure that the skb pointer does not escape
> > > the function.)
> > > 
> > > Would something like that work?
> > 
> > I don't think so, at least not in the contest of an Rust Ethernet
> > driver.
> > 
> > There are two main flows.
> > 
> > A packet is received. An skb is allocated and the received packet is
> > placed into the skb. The Ethernet driver then hands the packet over to
> > the network stack. The network stack is free to do whatever it wants
> > with the packet. Things can go wrong within the driver, so at times it
> > needs to free the skb rather than pass it to the network stack, which
> > would be a drop.
> > 
> > The second flow is that the network stack has a packet it wants sent
> > out an Ethernet port, in the form of an skb. The skb gets passed to
> > the Ethernet driver. The driver will do whatever it needs to do to
> > pass the contents of the skb to the hardware. Once the hardware has
> > it, the driver frees the skb. Again, things can go wrong and it needs
> > to free the skb without sending it, which is a drop.
> > 
> > So the lifetime is not a simple function call.
> > 
> > The drop reason indicates why the packet was dropped. It should give
> > some indication of what problem occurred which caused the drop. So
> > ideally we don't want an anonymous drop. The C code does not enforce
> > that, but it would be nice if the rust wrapper to dispose of an skb
> > did enforce it.
> 
> It sounds like a destructor with WARN_ON is the best approach right now.

Note, if that WARN_ON fires, you just rebooted the machine as the huge
majority of all Linux systems in the world run with "panic on warn"
enabled :(

So almost NEVER do a WARN* call if at all possible, unless there is no
way back, and you can not recover from the mess, and crashing the system
is your only recourse (instead of locking it up.)

So please, don't do that, recover and report an error to the caller if
possible and let them handle it properly.  Yes, in a descructor that's
almost impossible, but then perhaps if this is a real problem, something
needs to be changed somewhere else in the callpath.

thanks,

greg k-h

