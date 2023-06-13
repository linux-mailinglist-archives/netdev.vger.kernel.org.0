Return-Path: <netdev+bounces-10316-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD2AE72DD4E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:09:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31AB1281077
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0AD610D;
	Tue, 13 Jun 2023 09:09:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938163D78
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAFAC433D2;
	Tue, 13 Jun 2023 09:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686647365;
	bh=5YoMjA68JolkA23tLh+BPZF4o/5QE2j9cjaqVqI4d5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rj5LIfec0am42M8Rohetf9F4Wh7ksPeTVerXiuQO1FN/DOUjv301rfoK72wJn0kla
	 ut7+9Jj+EcqGfHgkl9CFI/kBiqcy6yZ8Fu/5P8hpaxcQtFH1Iba+ZxLWRK3wXVKk9H
	 wxMkY2z2PK8K+2y4JZjXzkTmUl/OtFbLLMqVzL4AR5+YH/gk/oJBr0laKYmUbK5OOi
	 +WchMpRzXR4L82Fkzg0cQkQkne2kbAUaQQkNW9lweHmbMlF2OyQIX7ZroqYbjiSVJ0
	 0/d4rymkExK2kaFn+WB9taa+MfqlCZXPlRkOh54Mdxq6AIZ6EMo2LGX+zlNKqmdIOF
	 JvTxeA2K91lKQ==
Date: Tue, 13 Jun 2023 12:09:20 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230613090920.GW12152@unreal>
References: <20230611181125.GJ12152@unreal>
 <ZIcC2Y+HHHR+7QYq@boxer>
 <20230612115925.GR12152@unreal>
 <20230612123718.u6cfggybbtx4owbq@skbuf>
 <20230612131707.GS12152@unreal>
 <20230612132841.xcrlmfhzhu5qazgk@skbuf>
 <20230612133853.GT12152@unreal>
 <20230612140521.tzhgliaok5u3q67o@skbuf>
 <20230613071959.GU12152@unreal>
 <20230613083002.pjzsno2tzbewej7o@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613083002.pjzsno2tzbewej7o@skbuf>

On Tue, Jun 13, 2023 at 11:30:02AM +0300, Vladimir Oltean wrote:
> On Tue, Jun 13, 2023 at 10:19:59AM +0300, Leon Romanovsky wrote:
> > But once child finishes device_shutdown(), it will be removed from devices_kset
> > list and dev->driver should be NULL at that point for the child.
> 
> What piece of code would make dev->driver be NULL for devices that have
> been shut down by device_shutdown()?

You are right here and I'm wrong on that point, dev->driver is set to
NULL in all other places where the device is going to be reused and not
in device_shutdown().

Unfortunately, it doesn't change a lot in our conversation, as device_shutdown()
is very specific call which is called in two flows: kernel_halt() and kernel_restart().

In both flows, it is end game.

Thanks

