Return-Path: <netdev+bounces-9790-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DE3372A9A0
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 09:01:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44410281A7A
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 07:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7851C7481;
	Sat, 10 Jun 2023 07:01:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81C26FBE
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 07:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F290BC433EF;
	Sat, 10 Jun 2023 07:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686380484;
	bh=Wp5R/TQPCiEaPzQRT909PDG6U6duYlFBbLBkcu4qLKI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E2fgUJgA1n4p5C8pfT8YLNEIATZsLszT7dKfECt/oYvRSfCUPiwDYQ11G6Ntz6vwF
	 4GTEtFjtrV/LXM3pUfiFxkTcBgS5+HcQpZmUHap/5gxSmVmJnNNRAIcU/9z1h6Bi23
	 F6IL3JSp64fOwnqYhH0t2wLAfiuaftNjMS75rdvqqt76KCyVcZJ1LBEqrpqsSqwPYy
	 09a00JDk3B40LZa4/M+Cf2+Q83lve9nq68X+t77mTl7rJyrpj6FsZpktw87gp4bYTW
	 rRFiaXyCTH5ex+ca0O8PuDa61kS92gR0R1qYguGqO3znQQ5WnozmEl7cBxMxAS0MpD
	 ODaOXh/PF5lJg==
Date: Sat, 10 Jun 2023 00:01:23 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Paolo Abeni
 <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, Saeed Mahameed
 <saeedm@nvidia.com>, netdev@vger.kernel.org, Tariq Toukan
 <tariqt@nvidia.com>, Shay Drory <shayd@nvidia.com>, Moshe Shemesh
 <moshe@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: Light probe local SFs
Message-ID: <20230610000123.04c3a32f@kernel.org>
In-Reply-To: <20230610014254.343576-15-saeed@kernel.org>
References: <20230610014254.343576-1-saeed@kernel.org>
	<20230610014254.343576-15-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  9 Jun 2023 18:42:53 -0700 Saeed Mahameed wrote:
> In case user wants to configure the SFs, for example: to use only vdpa
> functionality, he needs to fully probe a SF, configure what he wants,
> and afterward reload the SF.
> 
> In order to save the time of the reload, local SFs will probe without
> any auxiliary sub-device, so that the SFs can be configured prior to
> its full probe.

I feel like we talked about this at least twice already, and I keep
saying that the features should be specified when the device is
spawned. Am I misremembering?

Will this patch not surprise existing users? You're changing the
defaults. Does "local" mean on the IPU? Also "lightweight" feels
uncomfortably close to marketing language.

> The defaults of the enable_* devlink params of these SFs are set to
> false.
> 
> Usage example:

Is this a real example? Because we have..

> Create SF:
> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11

sfnum 11 here

> $ devlink port function set pci/0000:08:00.0/32768 \

then port is 32768

>                hw_addr 00:00:00:00:00:11 state active
> 
> Enable ETH auxiliary device:
> $ devlink dev param set auxiliary/mlx5_core.sf.1 \

and instance is sf.1 

>               name enable_eth value true cmode driverinit
> 
> Now, in order to fully probe the SF, use devlink reload:
> $ devlink dev reload auxiliary/mlx5_core.sf.1
> 
> At this point the user have SF devlink instance with auxiliary device
> for the Ethernet functionality only.

