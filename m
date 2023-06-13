Return-Path: <netdev+bounces-10554-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D4D372F001
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 01:32:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58845280EBB
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B9537335;
	Tue, 13 Jun 2023 23:32:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E625F1361
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 23:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70015C433C8;
	Tue, 13 Jun 2023 23:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686699128;
	bh=yFCEOt8ma7hJwTmwSPWt9wtzjc8Qkj535XE0K6rLXGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FK1vphGkUbBr+TuMdwutaeqFkpolDPKyA51nmjsbWBPWoitaDW6gn9Z7ME8tMrwEQ
	 Xp31VUHXo1hM8c44cSHn0FqggDK13u88G41uCsbMJTjiLBjekk3W+9JX0Ll+O9Tu9P
	 7KrREWLEO8REEU6Z+R/qXZZIN/Pqd2HmfwqgyCHpba1n+PqkzqZ9yzkdJemnm4Tc16
	 vjBi52mkZATrxmKrYvDKt8Sg2p9AYv/+I6tZwm8uc7XtaHBF9T7bgueSGrQ0EjcfE/
	 eniPTS/O9kGApOb45l0tSIsOWcbKgkpds1px9LBw2030wc2dKv8ykC0Oo6aFZeXRXa
	 AXLtawv4lVziw==
Date: Tue, 13 Jun 2023 16:32:07 -0700
From: Saeed Mahameed <saeed@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: Light probe local SFs
Message-ID: <ZIj8d8UhsZI2BPpR@x130>
References: <20230610014254.343576-1-saeed@kernel.org>
 <20230610014254.343576-15-saeed@kernel.org>
 <20230610000123.04c3a32f@kernel.org>
 <ZIVKfT97Ua0Xo93M@x130>
 <20230612105124.44c95b7c@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230612105124.44c95b7c@kernel.org>

On 12 Jun 10:51, Jakub Kicinski wrote:
>On Sat, 10 Jun 2023 21:15:57 -0700 Saeed Mahameed wrote:
>> On 10 Jun 00:01, Jakub Kicinski wrote:
>> >On Fri,  9 Jun 2023 18:42:53 -0700 Saeed Mahameed wrote:
>> >> In case user wants to configure the SFs, for example: to use only vdpa
>> >> functionality, he needs to fully probe a SF, configure what he wants,
>> >> and afterward reload the SF.
>> >>
>> >> In order to save the time of the reload, local SFs will probe without
>> >> any auxiliary sub-device, so that the SFs can be configured prior to
>> >> its full probe.
>> >
>> >I feel like we talked about this at least twice already, and I keep
>> >saying that the features should be specified when the device is
>> >spawned. Am I misremembering?
>>
>> I think we did talk about this, but after internal research we prefer to
>> avoid adding additional knobs, unless you insist :) ..
>> I think we already did a research and we feel that all of our users are
>> going to re-configure the SF anyway, so why not make all SFs start with
>> "blank state" ?
>
>In the container world, at least, I would have thought that the
>management daemon gets a full spec of the container its starting
>upfront. So going thru this spawn / config / futz / reset cycle
>is pure boilerplate pain.
>

That's the point of the series. create / config / spawn.

personally I like that the SF object is created blank, with dev handles
(devlink/aux) to configure it, and spawn it when ready.
I don't see a point of having an extra "blank state" devlink param.

>What use cases are you considering? More VM-oriented?
>

Mostly container oriented, and selecting the ULP stacks, e.g RDMA, VDPA,
virtio, netdev, etc .. 


>> >> The defaults of the enable_* devlink params of these SFs are set to
>> >> false.
>> >>
>> >> Usage example:
>> >
>> >Is this a real example? Because we have..
>> >
>> >> Create SF:
>> >> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
>> >
>> >sfnum 11 here
>>
>> This an arbitrary user index.
>>
>> >> $ devlink port function set pci/0000:08:00.0/32768 \
>> >
>> >then port is 32768
>>
>> This is the actual HW port index, our SFs indexing start with an offset.
>>
>> >>                hw_addr 00:00:00:00:00:11 state active
>> >>
>> >> Enable ETH auxiliary device:
>> >> $ devlink dev param set auxiliary/mlx5_core.sf.1 \
>> >
>> >and instance is sf.1
>>
>> This was the first SF aux dev to be created on the system. :/
>>
>> It's a mess ha...
>>
>> Maybe we need to set the SF aux device index the same as the user index.
>> But the HW/port index will always be different, otherwise we will need a map
>> inside the driver.
>
>It'd be best to synchronously return to the user what the ID of the
>allocated entity is. It should be possible with some core changes to
>rig up devlink to return the sfnum and port ID. But IDK about the new
>devlink instance :(

I think that's possible, let me ask the team to take a shot at this.. 

I am not sure I understand what you mean by "new devlink instance".

SF creation will result in spawning two devlink handles, the SF function port of
on the eswitch and the SF device devlink instance..



