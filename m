Return-Path: <netdev+bounces-11183-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 710C6731DED
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 18:37:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5342E1C20F23
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD0A2E0C3;
	Thu, 15 Jun 2023 16:37:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67642E0C0
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 16:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15753C433C8;
	Thu, 15 Jun 2023 16:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686847022;
	bh=4pkEOA2Mn4kkP71IDVqMx/ojRnn3oDH7NMze36U1neA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t7Jw6aK8OF7+Z+eEn3Rt0r46AHduM+5BkK1+LsEiaQAAqGETpsTVJO7ORwCA5gJgF
	 tcSAHi1RjhLPx6oEa1K/Nh+iDtt+AyW5qmWpKU0oRwtLw5etwU4+oHRYU5E1vQ2D+M
	 HAwskZz8yvehPB+mFLCz4zTjsWmN0SOQ2T8ivCshca0YznPyC3779TAvLwcPfX4tPU
	 La5i/BBHgQsKLacb4ZoFRYkuac2lmxa5r+dUZAhq4hp0yvIxzPnwK3a9hqqndYjShB
	 E9CdDn6/yPDoUt0ISDvrGEGqBqS9KK3axXt0vkOivV/N9+L0lkzFntT3pKbZ9FjVEZ
	 DIXxrOWdrVENA==
Date: Thu, 15 Jun 2023 09:37:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Saeed Mahameed <saeed@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org, Tariq Toukan
 <tariqt@nvidia.com>, Shay Drory <shayd@nvidia.com>, Moshe Shemesh
 <moshe@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: Light probe local SFs
Message-ID: <20230615093701.20d0ad1b@kernel.org>
In-Reply-To: <ZIrtHZ2wrb3ZdZcB@nanopsycho>
References: <20230610014254.343576-1-saeed@kernel.org>
	<20230610014254.343576-15-saeed@kernel.org>
	<20230610000123.04c3a32f@kernel.org>
	<ZIVKfT97Ua0Xo93M@x130>
	<20230612105124.44c95b7c@kernel.org>
	<ZIj8d8UhsZI2BPpR@x130>
	<20230613190552.4e0cdbbf@kernel.org>
	<ZIrtHZ2wrb3ZdZcB@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 12:51:09 +0200 Jiri Pirko wrote:
> The problem is scalability. SFs could be activated in parallel, but the
> cmd that is doing that holds devlink instance lock. That serializes it.
> So we need to either:
> 1) change the devlink locking to be able to execute some of the cmds in
>    parallel and leave the activation sync
> 2) change the activation to be async and work with notifications
> 
> I like 2) better, as the 1) maze we just got out of recently :)
> WDYT?

I guess we don't need to wait for the full activation. Is the port
creation also async, then, or just the SF devlink instance creation?

