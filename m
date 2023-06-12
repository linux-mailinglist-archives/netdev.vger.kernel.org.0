Return-Path: <netdev+bounces-10127-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B691672C626
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:39:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C57171C20AF9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B3519BC7;
	Mon, 12 Jun 2023 13:39:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0860D10797
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9E7C433D2;
	Mon, 12 Jun 2023 13:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686577138;
	bh=kOpqRSin5auYZG2cMl6GxzCC9U+XkcBKfk3qYbsm2Mo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=etm991msjFPimV0I8DnHcZkFLQhcx6p5ZKZGq0wRgiD4jmpajl/f7M6Sw3bXlNG35
	 k6z/GCCvLaRQyb9QaxZltDToCy5AAZbzaFi3KBvtX69q8FLGIJXgdQm9Sj9+32wlBM
	 FHOuNxFSJq9Te9XpiBke+0GyyJtEGs2R/o6u+lzlbVzYqYbtNieBUcntkHpEqk6LN+
	 I5tJx5bnJ0Pb2R/XKfj+dbNcuSZ3BWiCI+o58YxMLj/7We6tNE/ZSQAVbBGEdHBmc0
	 YzzBo/UO7nlEuSPVSGSghDxQyxSsv73i+YEsjGDIJ16CWZFXaOHAG3Td6or7ba0dR7
	 1I95cyfl66vlA==
Date: Mon, 12 Jun 2023 16:38:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230612133853.GT12152@unreal>
References: <20230607140335.1512-1-asmaa@nvidia.com>
 <20230611181125.GJ12152@unreal>
 <ZIcC2Y+HHHR+7QYq@boxer>
 <20230612115925.GR12152@unreal>
 <20230612123718.u6cfggybbtx4owbq@skbuf>
 <20230612131707.GS12152@unreal>
 <20230612132841.xcrlmfhzhu5qazgk@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612132841.xcrlmfhzhu5qazgk@skbuf>

On Mon, Jun 12, 2023 at 04:28:41PM +0300, Vladimir Oltean wrote:
> On Mon, Jun 12, 2023 at 04:17:07PM +0300, Leon Romanovsky wrote:
> > On Mon, Jun 12, 2023 at 03:37:18PM +0300, Vladimir Oltean wrote:
> > > On Mon, Jun 12, 2023 at 02:59:25PM +0300, Leon Romanovsky wrote:
> > > > As far as I can tell, the calls to .shutdown() and .remove() are
> > > > mutually exclusive.
> > > 
> > > In this particular case, or in general?
> > > 
> > > In general they aren't. If the owning bus driver also implements its .shutdown()
> > > as .remove(), then it will call the .remove() method of all devices on that bus.
> > > That, after .shutdown() had already been called for those same children.
> > 
> > Can you please help me to see how? What is the call chain?
> > 
> > From what I see callback to ->shutdown() iterates over all devices in
> > that bus and relevant bus will check that driver is bound prior to call
> > to driver callback. In both cases, the driver is removed and bus won't
> > call to already removed device.
> 
> The sequence of operations is:
> 
> * device_shutdown() walks the devices_kset backwards, thus shutting down
>   children before parents
>   * .shutdown() method of child gets called
>   * .shutdown() method of parent gets called
>     * parent implements .shutdown() as .remove()
>       * the parent's .remove() logic calls device_del() on its children
>         * .remove() method of child gets called

But both child and parent are locked so they parent can't call to
child's remove while child is performing shutdown.

BTW, I read the same device_shutdown() function before my first reply
and came to different conclusions from you.

> 
> > If it does, it is arguably bug in bus logic, which needs to prevent such
> > scenario.
> 
> It's just a consequence of how things work when you reuse the .remove() logic
> for .shutdown() without thinking it through. It's a widespread pattern.

