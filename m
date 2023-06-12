Return-Path: <netdev+bounces-10203-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B4472CD38
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:51:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99F6F1C20B84
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C01B21CE1;
	Mon, 12 Jun 2023 17:51:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA651F189
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1EAC433EF;
	Mon, 12 Jun 2023 17:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686592285;
	bh=g5u3Aq+VwOX+Y0QrNhOdGhNHJzXvPl/H0wzhw8xaNc8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gOL1H9YTWfvg4lLDFHl/aN/r2yUNjLfwUHBbZ8YngvWU8WZwpZEsCISHS6NUwb4fN
	 2HTO6Pwx6mGhmoeU0n+IdUzE+EUBnrF389klPPwZtHamqBer/ml5Kac4Jx0Lt36Ym3
	 SugrB9JBWU8zx4o3E7Ob6ynO8YWb03jLxwSJdcqW8hf5Ju3gbt589nE1+ESqMicBA1
	 7ZgeIbY+HxvqurtJPZUGmXiW0XsYLPnTpduVZJ4B5mBKOusZooqFDLi77DFq8brGpb
	 lEkCwv4rnTWf7bfZ6kl/Qtxrvlrp/76ApAhiBiSc1OtzAocJAYEn/Hlk724y8SIqN7
	 zKg8iPZIVP28g==
Date: Mon, 12 Jun 2023 10:51:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Saeed Mahameed <saeedm@nvidia.com>
Cc: Saeed Mahameed <saeed@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, netdev@vger.kernel.org, Tariq Toukan
 <tariqt@nvidia.com>, Shay Drory <shayd@nvidia.com>, Moshe Shemesh
 <moshe@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: Light probe local SFs
Message-ID: <20230612105124.44c95b7c@kernel.org>
In-Reply-To: <ZIVKfT97Ua0Xo93M@x130>
References: <20230610014254.343576-1-saeed@kernel.org>
	<20230610014254.343576-15-saeed@kernel.org>
	<20230610000123.04c3a32f@kernel.org>
	<ZIVKfT97Ua0Xo93M@x130>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 10 Jun 2023 21:15:57 -0700 Saeed Mahameed wrote:
> On 10 Jun 00:01, Jakub Kicinski wrote:
> >On Fri,  9 Jun 2023 18:42:53 -0700 Saeed Mahameed wrote:  
> >> In case user wants to configure the SFs, for example: to use only vdpa
> >> functionality, he needs to fully probe a SF, configure what he wants,
> >> and afterward reload the SF.
> >>
> >> In order to save the time of the reload, local SFs will probe without
> >> any auxiliary sub-device, so that the SFs can be configured prior to
> >> its full probe.  
> >
> >I feel like we talked about this at least twice already, and I keep
> >saying that the features should be specified when the device is
> >spawned. Am I misremembering?
> 
> I think we did talk about this, but after internal research we prefer to
> avoid adding additional knobs, unless you insist :) .. 
> I think we already did a research and we feel that all of our users are
> going to re-configure the SF anyway, so why not make all SFs start with
> "blank state" ?

In the container world, at least, I would have thought that the
management daemon gets a full spec of the container its starting
upfront. So going thru this spawn / config / futz / reset cycle
is pure boilerplate pain.

What use cases are you considering? More VM-oriented?

> >> The defaults of the enable_* devlink params of these SFs are set to
> >> false.
> >>
> >> Usage example:  
> >
> >Is this a real example? Because we have..
> >  
> >> Create SF:
> >> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11  
> >
> >sfnum 11 here
> 
> This an arbitrary user index.
> 
> >> $ devlink port function set pci/0000:08:00.0/32768 \  
> >
> >then port is 32768
> 
> This is the actual HW port index, our SFs indexing start with an offset.
> 
> >>                hw_addr 00:00:00:00:00:11 state active
> >>
> >> Enable ETH auxiliary device:
> >> $ devlink dev param set auxiliary/mlx5_core.sf.1 \  
> >
> >and instance is sf.1
> 
> This was the first SF aux dev to be created on the system. :/
> 
> It's a mess ha...
>   
> Maybe we need to set the SF aux device index the same as the user index.
> But the HW/port index will always be different, otherwise we will need a map
> inside the driver.

It'd be best to synchronously return to the user what the ID of the
allocated entity is. It should be possible with some core changes to
rig up devlink to return the sfnum and port ID. But IDK about the new
devlink instance :(

