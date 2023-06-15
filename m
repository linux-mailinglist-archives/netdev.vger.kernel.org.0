Return-Path: <netdev+bounces-11221-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D73AD73205B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 21:33:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82AEE28148C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6D1EAEB;
	Thu, 15 Jun 2023 19:33:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB1B2E0F5
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 19:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8917C433C8;
	Thu, 15 Jun 2023 19:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686857607;
	bh=CbmDHRUdS09gYLVxpLoVrVneJyMN7e/Od5x7sGMcLts=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=URD+U7emn6rUBz0u/iaH56yeVkDzwVoGWh8P5HxhJebeXd9gqiUhclM/hFQQF6cO7
	 2E5qth5F26CLxNppwBe//I66LYxDd9iq3pyhuEmNE+O5d9/a4kYDyBqWkx2ch6L9KH
	 KtpueW+trPm1jUxgtTcF7amEAwarq8gWiDYZBmuAAccLmiDZZjREPIGgbXLeoWSgsw
	 E4wWrykOItrxSxqKBw1Xm5uMayBpcCTbW+wR96SGKZK6ekj1MYoGjivzRcmLcY64pN
	 O/dxi6ZXJBuDEa8JXv61CvbCX7txzSB+4U/B/I9jJVBsZV9DaNwLp6wtq9bcGyx7Gc
	 CENb9+EJ027MA==
Date: Thu, 15 Jun 2023 12:33:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Saeed Mahameed <saeed@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org, Tariq Toukan
 <tariqt@nvidia.com>, Shay Drory <shayd@nvidia.com>, Moshe Shemesh
 <moshe@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: Light probe local SFs
Message-ID: <20230615123325.421ec9aa@kernel.org>
In-Reply-To: <ZItMUwiRD8mAmEz1@nanopsycho>
References: <20230610014254.343576-1-saeed@kernel.org>
	<20230610014254.343576-15-saeed@kernel.org>
	<20230610000123.04c3a32f@kernel.org>
	<ZIVKfT97Ua0Xo93M@x130>
	<20230612105124.44c95b7c@kernel.org>
	<ZIj8d8UhsZI2BPpR@x130>
	<20230613190552.4e0cdbbf@kernel.org>
	<ZIrtHZ2wrb3ZdZcB@nanopsycho>
	<20230615093701.20d0ad1b@kernel.org>
	<ZItMUwiRD8mAmEz1@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 19:37:23 +0200 Jiri Pirko wrote:
> Thu, Jun 15, 2023 at 06:37:01PM CEST, kuba@kernel.org wrote:
> >On Thu, 15 Jun 2023 12:51:09 +0200 Jiri Pirko wrote:  
> >> The problem is scalability. SFs could be activated in parallel, but the
> >> cmd that is doing that holds devlink instance lock. That serializes it.
> >> So we need to either:
> >> 1) change the devlink locking to be able to execute some of the cmds in
> >>    parallel and leave the activation sync
> >> 2) change the activation to be async and work with notifications
> >> 
> >> I like 2) better, as the 1) maze we just got out of recently :)
> >> WDYT?  
> >
> >I guess we don't need to wait for the full activation. Is the port
> >creation also async, then, or just the SF devlink instance creation?  
> 
> I'm not sure I follow :/
> The activation is when the SF auxiliary device is created. The driver then
> probes the SF auxiliary device and instantiates everything, SF devlink,
> SF netdev, etc.

Sorry, maybe let's look at an example:

$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11

needs to print / return the handle of the created port.

$ devlink port function set pci/0000:08:00.0/32768 \
               hw_addr 00:00:00:00:00:11 state active

needs to print / return the handle of the devlink instance

> We need wait/notification for 2 reasons
> 1) to get the auxiliary device name for the activated
>    SF. It is needed for convenience of the orchestration tools.
> 2) to get the result of the activation (success/fail)
>    It is also needed for convenience of the orchestration tools.

Are you saying the activation already waits for the devlink instance to
be spawned? If so that's great, all we need to do is for the:

$ devlink port function set pci/0000:08:00.0/32768 \
               hw_addr 00:00:00:00:00:11 state active

to either return sufficient info for the orchestration to know what the
resulting SF / SF devlink instance is. Most likely indirectly by adding
that info to the port so that the PORT_NEW notification carries it.

Did I confuse things even more?

As a reminder what sparked this convo is that user specifies "sfnum 11"
in the example, and the sf device gets called "sf.1".

