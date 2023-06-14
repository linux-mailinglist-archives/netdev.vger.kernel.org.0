Return-Path: <netdev+bounces-10571-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6A7572F26E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 04:05:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C297D2812D8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 02:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C3A38C;
	Wed, 14 Jun 2023 02:05:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FD07F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4919EC433C8;
	Wed, 14 Jun 2023 02:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686708353;
	bh=aygR4kjHOndgYotptc1ejxSxnXb/Ef1oCIbncczTCQM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PTo90SAu8ipXCRmuWAQCA7Pc1Lkq5hI9zEB1zqLYzuKVIKPJsqQSTNZmKZYwPjhXg
	 HQAG1jpK3KqIpgaKokdJcMD4jqbxO2dodJ/wIHVq3DBHrq5vZ6eBBqILM0ZEZq3UHw
	 1TWqMTR0y3IC2Bryv1WU/l+rSNJF/+JsQrHnbxMTE7/4OzdZCFyF83xG2R9/K/dPk+
	 8kpH0Q5j+qfbXtzNZgRnaxe/KSOd7g9wLGkEdYBkp2A685JhMPHzP8l+dp4s6ZsO+1
	 kGG6BvOwgdyZEG/w65hhgg970vHmI2J21WTeYqiPXJpbuefP5Y25g9wrEOoMcI8Sw2
	 RhHadCmQy/fMA==
Date: Tue, 13 Jun 2023 19:05:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, "David S. Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, netdev@vger.kernel.org, Tariq Toukan
 <tariqt@nvidia.com>, Shay Drory <shayd@nvidia.com>, Moshe Shemesh
 <moshe@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: Light probe local SFs
Message-ID: <20230613190552.4e0cdbbf@kernel.org>
In-Reply-To: <ZIj8d8UhsZI2BPpR@x130>
References: <20230610014254.343576-1-saeed@kernel.org>
	<20230610014254.343576-15-saeed@kernel.org>
	<20230610000123.04c3a32f@kernel.org>
	<ZIVKfT97Ua0Xo93M@x130>
	<20230612105124.44c95b7c@kernel.org>
	<ZIj8d8UhsZI2BPpR@x130>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Jun 2023 16:32:07 -0700 Saeed Mahameed wrote:
> On 12 Jun 10:51, Jakub Kicinski wrote:
> >On Sat, 10 Jun 2023 21:15:57 -0700 Saeed Mahameed wrote:  
> >> I think we did talk about this, but after internal research we prefer to
> >> avoid adding additional knobs, unless you insist :) ..
> >> I think we already did a research and we feel that all of our users are
> >> going to re-configure the SF anyway, so why not make all SFs start with
> >> "blank state" ?  
> >
> >In the container world, at least, I would have thought that the
> >management daemon gets a full spec of the container its starting
> >upfront. So going thru this spawn / config / futz / reset cycle
> >is pure boilerplate pain.
> 
> That's the point of the series. create / config / spawn.
> 
> personally I like that the SF object is created blank, with dev handles
> (devlink/aux) to configure it, and spawn it when ready.

I think we had this discussion before, wasn't the initial proposal for SF
along those lines? And we're slowly trending back towards ports in
uninitialized state. It's okay, too late now.

> I don't see a point of having an extra "blank state" devlink param.

Yeah, the param would be worse of both worlds. 
We'll need to ensure consistency in other vendors, tho.

> >What use cases are you considering? More VM-oriented?
> 
> Mostly container oriented, and selecting the ULP stacks, e.g RDMA, VDPA,
> virtio, netdev, etc .. 

Odd, okay.

> >> This was the first SF aux dev to be created on the system. :/
> >>
> >> It's a mess ha...
> >>
> >> Maybe we need to set the SF aux device index the same as the user index.
> >> But the HW/port index will always be different, otherwise we will need a map
> >> inside the driver.  
> >
> >It'd be best to synchronously return to the user what the ID of the
> >allocated entity is. It should be possible with some core changes to
> >rig up devlink to return the sfnum and port ID. But IDK about the new
> >devlink instance :(  
> 
> I think that's possible, let me ask the team to take a shot at this.. 
> 
> I am not sure I understand what you mean by "new devlink instance".
> 
> SF creation will result in spawning two devlink handles, the SF function port of
> on the eswitch and the SF device devlink instance..

Yes, I mean "SF device devlink instance" by "new devlink instance".

In theory this should all be doable with netlink. NLM_F_ECHO should
loop all notifications back to the requester. The tricky part is
catching the notifications, I'm guessing, because in theory the devlink
instance spawning may be async for locking reasons? Hopefully not,
then it's easy..

