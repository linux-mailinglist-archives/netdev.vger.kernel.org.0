Return-Path: <netdev+bounces-11227-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40CEB7320C8
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:17:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A748E28159E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 20:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5BFFBE6;
	Thu, 15 Jun 2023 20:17:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79495EAD9
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 20:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A3EC433C0;
	Thu, 15 Jun 2023 20:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686860269;
	bh=QgnvQyjjWcdlS8O0BDvjeHWPxdiYm/PYIw8oYqRrYiM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CiDEKbRxotCed68pu3XjMkuu+8l61QG5n0CT9b+SMEeskGoyyRpLhc8ASiGMMMhKL
	 pWCGchjzIwkEyw08lghSCj8OQbeFlhPyLDKTv+XskS9WPrQWNHT7PLpvhQPqv0STKL
	 j+ElzmxwdAvJCrCDCGXgXh0u4PQj1EW0yKjxwGVi6RnAIAF19Q6mNE/RFfFckftA8l
	 l/AgTxLuJzlVYsJwkvc9aWG/xs+eXjD7ZNH1NJZus/MIKccvNDCz3PEWX0hMcGB3KL
	 tB6/TZf1SHrQ3iMsNhYAK4fMRz4hKGPWBt/FGjGn3h2Wff/Ahnql/YZVhuxEB76CmO
	 5rbdVq65lCCCQ==
Date: Thu, 15 Jun 2023 13:17:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: patchwork-bot+netdevbpf@kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 dsahern@gmail.com, "helpdesk@kernel.org" <helpdesk@kernel.org>
Subject: Re: [PATCH net-next v2 0/2] net: create device lookup API with
 reference tracking
Message-ID: <20230615131747.49e9238e@kernel.org>
In-Reply-To: <20230615-73rd-axle-trots-7e1c65@meerkat>
References: <20230612214944.1837648-1-kuba@kernel.org>
	<168681542074.22382.15571029013760079421.git-patchwork-notify@kernel.org>
	<20230615100021.43d2d041@kernel.org>
	<20230615-73rd-axle-trots-7e1c65@meerkat>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 15:41:07 -0400 Konstantin Ryabitsev wrote:
> On Thu, Jun 15, 2023 at 10:00:21AM -0700, Jakub Kicinski wrote:
> > Any recent changes to the pw-bot in commit matching?
> > We don't do any editing when applying, AFAIK, and it's 3rd or 4th case
> > within a week we get a no-match.  
> 
> Did you, by chance, set your diff.algorithm to "histogram"? I noticed that the
> diffs in your submission are very different from what I get when I run "git
> show". E.g. notice this block in your email:
> 
>     --- a/net/core/dev.c
>     +++ b/net/core/dev.c
>     @@ -758,18 +758,7 @@  struct net_device *dev_get_by_name_rcu(struct net *net, const char *name)
>      }
>      EXPORT_SYMBOL(dev_get_by_name_rcu);
>      
>     -/**
>     - *	dev_get_by_name		- find a device by its name
>     - *	@net: the applicable net namespace
>     - *	@name: name to find
>     - *
>     - *	Find an interface by name. This can be called from any
>     - *	context and does its own locking. The returned handle has
>     - *	the usage count incremented and the caller must use dev_put() to
>     - *	release it when it is no longer needed. %NULL is returned if no
>     - *	matching device is found.
>     - */
>     -
>     +/* Deprecated for new users, call netdev_get_by_name() instead */
>      struct net_device *dev_get_by_name(struct net *net, const char *name)
>      {
>         struct net_device *dev;
> 
> When I run "git show 70f7457ad6d655e65f1b93cbba2a519e4b11c946", I get a very
> different looking diff:
> 
>     --- a/net/core/dev.c
>     +++ b/net/core/dev.c
>     @@ -758,29 +758,43 @@ struct net_device *dev_get_by_name_rcu(struct net *net, const char *name)
>      }
>      EXPORT_SYMBOL(dev_get_by_name_rcu);
> 
>     +/* Deprecated for new users, call netdev_get_by_name() instead */
>     +struct net_device *dev_get_by_name(struct net *net, const char *name)
>     +{
>     + struct net_device *dev;
>     +
>     + rcu_read_lock();
>     + dev = dev_get_by_name_rcu(net, name);
>     + dev_hold(dev);
>     + rcu_read_unlock();
>     ...
> 
> Unless I pass --histogram, in which case it starts to match yours. So, I'm
> wondering if you have diff.algorithm set to "histogram" and this generates
> patches that we can no longer match against commits, because we are generating
> the diffs using the default algorithm.

Oh, that could well be it, I did! Linus asked people to do that
recently, I think in the -rc4 email. One of the RC emails, anyway.
IDK how many people listened to Linus. Technically it only matters
for maintainers who may send PRs to him, otherwise he said his diffstat
will be different than the one in the PR.

But it's not just me:
https://lore.kernel.org/all/168674222282.23990.8151831714077509932.git-patchwork-notify@kernel.org/
https://lore.kernel.org/all/168661442392.10094.4616497599019441750.git-patchwork-notify@kernel.org/
(there's a third one but it's is also Matthieu so CBA to get the lore
link, we're just counting people.)

Could the bot try matching in histogram and non-histogram mode?

