Return-Path: <netdev+bounces-10301-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADFEC72DAAE
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E481C1C20C29
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 07:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949BE53AC;
	Tue, 13 Jun 2023 07:20:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD8C539E
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4ECC433EF;
	Tue, 13 Jun 2023 07:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686640804;
	bh=w8sNVrNOBO9QwDrh3I4TClcNQzcJUGjilnmmNJ7/HWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XvOy61weQz8YF1ht+URiRS4C1nXFbDSBJpvhXaIqTsoOW4PdepRYOntkizY6hj46h
	 G7jazMpzlzCEO0jfdaGBqMUgwxvUnpeDFgD3iktMo/0lD34impjsVvLC5OuExaMpqI
	 16Qma93av0jWoMK60NDK/MXk1OVW6B0Ba8MVdDgn2LqmJ4nKlHtwtVX61Gb7igYBZe
	 oyrZnhEMoDDm58tXpdg3Xmvy/YxWGa7K2QIKJiwsFTaD6jzMCYnCiWWrnKWpsJJPkR
	 djR/apJuyjRJyzsEFAgFTQaPZZNpNFpT6gpmOEBSQbSJ/fg8e1MidV4VtZZpzoc2fA
	 ua6bFLLoXi6mQ==
Date: Tue, 13 Jun 2023 10:19:59 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230613071959.GU12152@unreal>
References: <20230607140335.1512-1-asmaa@nvidia.com>
 <20230611181125.GJ12152@unreal>
 <ZIcC2Y+HHHR+7QYq@boxer>
 <20230612115925.GR12152@unreal>
 <20230612123718.u6cfggybbtx4owbq@skbuf>
 <20230612131707.GS12152@unreal>
 <20230612132841.xcrlmfhzhu5qazgk@skbuf>
 <20230612133853.GT12152@unreal>
 <20230612140521.tzhgliaok5u3q67o@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612140521.tzhgliaok5u3q67o@skbuf>

On Mon, Jun 12, 2023 at 05:05:21PM +0300, Vladimir Oltean wrote:
> On Mon, Jun 12, 2023 at 04:38:53PM +0300, Leon Romanovsky wrote:
> > On Mon, Jun 12, 2023 at 04:28:41PM +0300, Vladimir Oltean wrote:
> > > The sequence of operations is:
> > > 
> > > * device_shutdown() walks the devices_kset backwards, thus shutting down
> > >   children before parents
> > >   * .shutdown() method of child gets called
> > >   * .shutdown() method of parent gets called
> > >     * parent implements .shutdown() as .remove()
> > >       * the parent's .remove() logic calls device_del() on its children
> > >         * .remove() method of child gets called
> > 
> > But both child and parent are locked so they parent can't call to
> > child's remove while child is performing shutdown.
> 
> Please view the call chain I've posted in an email client capable of
> showing the indentation correctly. 

Thanks for the suggestion, right now I'm using mutt and lore to read
emails. Should I use another email client?

> The 2 lines:
> 
>    * .shutdown() method of child gets called
>    * .shutdown() method of parent gets called
> 
> have the same level of indentation because they occur sequentially
> within the same function.

Right

> 
> This means 2 things:
> 
> 1. when the parent runs its .shutdown(), the .shutdown() of the child
>    has already finished

Right, it is done to make sure we release childs before parents.

> 
> 2. device_shutdown() only locks "dev" and "dev->parent" for the duration
>    of the "dev->driver->shutdown(dev)" procedure. However, the situation
>    that you deem impossible due to locking is the dev->driver->shutdown(dev)
>    of the parent device. That parent wasn't found through any dev->parent
>    pointer, instead it is just another device in the devices_kset list.
>    The logic of locking "dev" and "dev->parent" there won't help, since
>    we would be locking the parent and the parent of the parent. This
>    will obviously not prevent the original parent from calling any
>    method of the original child - we're already one step higher in the
>    hierarchy.

But once child finishes device_shutdown(), it will be removed from devices_kset
list and dev->driver should be NULL at that point for the child. In driver core,
dev->driver is the marker if driver is bound. It means parent/bus won't/shouldn't
call to anything driver related to child which doesn't have valid dev->driver pointer.

> 
> So your objection above does not really apply.

We have a different opinion here.

> 
> > BTW, I read the same device_shutdown() function before my first reply
> > and came to different conclusions from you.
> 
> Well, you could try to experiment with putting ".shutdown = xxx_remove,"
> in some bus drivers and see what happens.

Like I said, this is a bug in bus logic which allows calls to device
which doesn't have driver bound to it.

> 
> Admittedly it was a few years ago, but I did study this problem and I
> did have to fix real issues reported by real people based on the above
> observations (which here are reproduced only from memory):
> https://lore.kernel.org/all/20210920214209.1733768-2-vladimir.oltean@nxp.com/

I believe you, just think that behaviour found in i2c/spi isn't how
device model works.

Thanks

