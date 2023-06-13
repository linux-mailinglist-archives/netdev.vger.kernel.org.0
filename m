Return-Path: <netdev+bounces-10329-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC67D72DEC6
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:10:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7DE61C20C2D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC820294D9;
	Tue, 13 Jun 2023 10:10:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E19427738
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B8EC433EF;
	Tue, 13 Jun 2023 10:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686651042;
	bh=vBw4aLuV9zaKzrHC8A7BHCGMHUFVOvs2UTP76qvAcZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q5zsIMEQk5WgUdnAeuHfnz3hNAGvSoS4v7Kv82GgyCOZySCVswxHvrgpdz+DjoNM4
	 ibPXO0QrXYh7Eh503ZGpZZ/QFJx5UIpuHxFvZi7yv7Iw2F1a1SCR1/k9RvULge+zjZ
	 JKomGcXHzdIDiSs0sUFJWe3ZuICPSkm26utoqXY9MeKqUvkWD7r7kl+s9HHR/3zlPG
	 o7GXqzlmeLDruqwociEaHxg2m0dl5uBKD7oR7x/xWnkVQsnBQ9wVCvdzBGjm7HJGl/
	 Ts2t8bRui/7HHolt2VaE2GPL5m+lU7cyXNwZN/+q0UHyPId3WgF1CZrDFEJQghrY//
	 UCZUh3mjM3O0w==
Date: Tue, 13 Jun 2023 13:10:38 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230613101038.GY12152@unreal>
References: <20230612115925.GR12152@unreal>
 <20230612123718.u6cfggybbtx4owbq@skbuf>
 <20230612131707.GS12152@unreal>
 <20230612132841.xcrlmfhzhu5qazgk@skbuf>
 <20230612133853.GT12152@unreal>
 <20230612140521.tzhgliaok5u3q67o@skbuf>
 <20230613071959.GU12152@unreal>
 <20230613083002.pjzsno2tzbewej7o@skbuf>
 <20230613090920.GW12152@unreal>
 <20230613093501.46x4rvyhhyx5wo3b@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613093501.46x4rvyhhyx5wo3b@skbuf>

On Tue, Jun 13, 2023 at 12:35:01PM +0300, Vladimir Oltean wrote:
> On Tue, Jun 13, 2023 at 12:09:20PM +0300, Leon Romanovsky wrote:
> > On Tue, Jun 13, 2023 at 11:30:02AM +0300, Vladimir Oltean wrote:
> > > On Tue, Jun 13, 2023 at 10:19:59AM +0300, Leon Romanovsky wrote:
> > > > But once child finishes device_shutdown(), it will be removed from devices_kset
> > > > list and dev->driver should be NULL at that point for the child.
> > > 
> > > What piece of code would make dev->driver be NULL for devices that have
> > > been shut down by device_shutdown()?
> > 
> > You are right here and I'm wrong on that point, dev->driver is set to
> > NULL in all other places where the device is going to be reused and not
> > in device_shutdown().
> > 
> > Unfortunately, it doesn't change a lot in our conversation, as device_shutdown()
> > is very specific call which is called in two flows: kernel_halt() and kernel_restart().
> > 
> > In both flows, it is end game.
> > 
> > Thanks
> 
> Except for the fact that, as mentioned in my first reply to this thread,
> bus drivers may implement .shutdown() the same way as .remove(), so in
> that case, someone *will* unbind the drivers from those child devices,
> *after* .shutdown() was called on the child - and if the child device
> driver isn't prepared to handle that, it can dereference NULL pointers
> and bye bye reboot - the kernel hangs.
> 
> Not really sure where you're aiming with your replies at this stage.

My goal is to explain that "bus drivers may implement .shutdown() 
the same way as .remove()" is wrong implementation and expectation
that all drivers will add "if (!priv) return ..." now is not viable.

Thanks

