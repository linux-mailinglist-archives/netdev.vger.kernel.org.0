Return-Path: <netdev+bounces-11555-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF18733941
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:10:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 076D1281845
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41E671DDC9;
	Fri, 16 Jun 2023 19:10:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F352D1B914
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B1CC433C0;
	Fri, 16 Jun 2023 19:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686942642;
	bh=vQP8RpU0TBh50UzUbBTbdS49nrwA/MnxyXUEhhLwNbg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AKQoc7AXdc/EFusTGnAlBCUfHAdkKR7enXuFMx6h6aQ+chzS4gQHK9Whg0vVWmZlK
	 9wFshMjL8VnU/KzadHlpqWE0ETUSHWFxEdlwzbJZZbeORmEhjwEgHnt/nCGWeLLJJ2
	 7pYg+0ccfRUYIW7QF1M5PyS7OVPrgh+9uwMlA9l2PYYHJfLD5hZKLbFHdoUcs6J4lF
	 8++ZjJmdE1r/b+v6uqTNyZ6TZTrG1rNe4bOj+Fs1kpeazOWtQiIsr1Z3gQNsL8ab0n
	 o5AiGcw/eX4/LaVtxOSYJ+SWhKnN/e4/VDv9ycqDGBBCRDeC3gFo6HKzKJby4XTiHz
	 M/0NL+NyAO7Gg==
Date: Fri, 16 Jun 2023 12:10:41 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Alice Ryhl <alice@ryhl.io>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>, andrew@lunn.ch,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
 aliceryhl@google.com, miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <20230616121041.4010f51b@kernel.org>
In-Reply-To: <66dcc87e-e03f-1043-c91d-25d6fa7130a1@ryhl.io>
References: <20230614230128.199724bd@kernel.org>
	<8e9e2908-c0da-49ec-86ef-b20fb3bd71c3@lunn.ch>
	<20230615190252.4e010230@kernel.org>
	<20230616.220220.1985070935510060172.ubuntu@gmail.com>
	<20230616114006.3a2a09e5@kernel.org>
	<66dcc87e-e03f-1043-c91d-25d6fa7130a1@ryhl.io>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jun 2023 21:00:36 +0200 Alice Ryhl wrote:
> A Rust method can be defined to take the struct "by value", which 
> consumes the struct and prevents you from using it again. This can let 
> you provide many different cleanup methods that each clean it up in 
> different ways.
> 
> However, you cannot force the user to use one of those methods. They 
> always have the option of letting the value go out of scope, which calls 
> the destructor. And they can do this at any time.
> 
> That said, the destructor of the value does not necessarily *have* to 
> translate to immediately freeing the value. If the value if refcounted, 
> the destructor could just drop the refcount. It would also be possible 
> for a destructor to schedule the cleanup operation to a workqueue. Or 
> you could do something more clever.

Can we put a WARN_ON() in the destructor and expect object to never be
implicitly freed?  skbs represent packets (most of the time) and for
tracking which part of the stack is dropping packets we try to provide
a drop reason along the freed skb. It'd be great if for Rust we could
from the get-go direct everyone towards the APIs with an explicit reason
code.

