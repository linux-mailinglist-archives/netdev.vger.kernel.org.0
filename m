Return-Path: <netdev+bounces-9258-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B64C7284B7
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:19:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78A231C21004
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4CA174C5;
	Thu,  8 Jun 2023 16:19:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8363B407
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D634BC433EF;
	Thu,  8 Jun 2023 16:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686241175;
	bh=TOwT0GuJCz2bKXbQWOs8IqmDNX1diLd0cKOY/ea6+9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TRW6izjx7+VO0YQ7ZXQ7nXFDTCyvOCxELhItwX4djo6jBb0usZ+WJ4ThHAzlHba9d
	 z85IjLzhK3CoEMQXIt6RJkx3nDPQE+FmFRJpUNpIgFfizrchWjnEY6eNH6FQMyWiu1
	 23uqEAjCd0U4Dz0N5FLleaTbsVmKEbaZoS9WJjLk=
Date: Thu, 8 Jun 2023 18:19:32 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Kees Cook <keescook@chromium.org>, Richard Weinberger <richard@nod.at>,
	linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [RFC PATCH 0/1] Integer overflows while scanning for integers
Message-ID: <2023060820-atom-doorstep-9442@gregkh>
References: <20230607223755.1610-1-richard@nod.at>
 <202306071634.51BBAFD14@keescook>
 <ZIHzbBXlxEz6As9N@alley>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIHzbBXlxEz6As9N@alley>

On Thu, Jun 08, 2023 at 05:27:40PM +0200, Petr Mladek wrote:
> On Wed 2023-06-07 16:36:12, Kees Cook wrote:
> > On Thu, Jun 08, 2023 at 12:37:54AM +0200, Richard Weinberger wrote:
> > > Hi!
> > > 
> > > Lately I wondered whether users of integer scanning functions check
> > > for overflows.
> > > To detect such overflows around scanf I came up with the following
> > > patch. It simply triggers a WARN_ON_ONCE() upon an overflow.
> > > 
> > > After digging into various scanf users I found that the network device
> > > naming code can trigger an overflow.
> > > 
> > > e.g:
> > > $ ip link add 1 type veth peer name 9999999999
> > > $ ip link set name "%d" dev 1
> > > 
> > > It will trigger the following WARN_ON_ONCE():
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 2 PID: 433 at lib/vsprintf.c:3701 vsscanf+0x6ce/0x990
> > 
> > Hm, it's considered a bug if a WARN or BUG can be reached from
> > userspace,
> 
> Good point. WARN() does not look like the right way in this case.
> 
> Another problem is that some users use panic_on_warn. In this case,
> the above "ip" command calls would trigger panic(). And it does not
> look like an optimal behavior.

"some users" == "most major cloud providers and a few billion Android
phones"  So in pure numbers, the huge majority of Linux systems running
in the world have that option enabled.

So please don't use WARN() to catch issues that can be triggered by
userspace, that can cause data loss and worse at times.

thanks,

greg k-h

