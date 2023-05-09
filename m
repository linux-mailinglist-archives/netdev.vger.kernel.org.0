Return-Path: <netdev+bounces-1185-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61DFD6FC845
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84E261C20BC6
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFC319505;
	Tue,  9 May 2023 13:56:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A922817ADE
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45F4C433D2;
	Tue,  9 May 2023 13:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683640578;
	bh=CY1ovOIPu8sbbkfUjzRuMscXoKvzAOm1iH6+bqViwAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aJeNdo18g4Q8yr0Kqa4aimFLuCqx8KFGO6L3LyvG2MkRCfgBO/VKOB+snkjrlP2gx
	 6l739ehfGBX7+IGkxwPzMYz94Xd8/SPCsbDR36M6ddIwBDIi/lBfycWYzfNdUOHA/y
	 LB99UF8ZciHyKKaIvS6rangVLIRMjcsgHOChpWfShIwmlFsGrmCZUWvRyRTFn2dOJk
	 aRBhRmqJoeXMjivAlhFzCRRMjbnF8GtVP3qIKcikOEfBymu350GT7NbXmEGXJhpyof
	 nEE9e55QgO9/p11dvi/dgCEU/48C8K5hAlKMUUg3YDabaRR1sERy9DIXcLY/JE7/tx
	 XyYF4bb2yDxqQ==
Date: Tue, 9 May 2023 16:56:13 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Philipp Rosenberger <p.rosenberger@kunbus.com>,
	Zhi Han <hanzhi09@gmail.com>
Subject: Re: [PATCH net-next] net: enc28j60: Use threaded interrupt instead
 of workqueue
Message-ID: <20230509135613.GP38143@unreal>
References: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
 <20230509080627.GF38143@unreal>
 <20230509133620.GA14772@wunner.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509133620.GA14772@wunner.de>

On Tue, May 09, 2023 at 03:36:20PM +0200, Lukas Wunner wrote:
> On Tue, May 09, 2023 at 11:06:27AM +0300, Leon Romanovsky wrote:
> > On Tue, May 09, 2023 at 06:28:56AM +0200, Lukas Wunner wrote:
> > > From: Philipp Rosenberger <p.rosenberger@kunbus.com>
> > > 
> > > The Microchip ENC28J60 SPI Ethernet driver schedules a work item from
> > > the interrupt handler because accesses to the SPI bus may sleep.
> > > 
> > > On PREEMPT_RT (which forces interrupt handling into threads) this
> > > old-fashioned approach unnecessarily increases latency because an
> > > interrupt results in first waking the interrupt thread, then scheduling
> > > the work item.  So, a double indirection to handle an interrupt.
> > > 
> > > Avoid by converting the driver to modern threaded interrupt handling.
> > > 
> > > Signed-off-by: Philipp Rosenberger <p.rosenberger@kunbus.com>
> > > Signed-off-by: Zhi Han <hanzhi09@gmail.com>
> > > [lukas: rewrite commit message, linewrap request_threaded_irq() call]
> > 
> > This is part of changelog which doesn't belong to commit message. The
> > examples which you can find in git log, for such format like you used,
> > are usually reserved to maintainers when they apply the patch.
> 
> Is that a new rule?

No, this rule always existed, just some of the maintainers didn't care
about it.

> 
> Honestly I think it's important to mention changes applied to
> someone else's patch, if only to let it be known who's to blame
> for any mistakes.

Right, this is why maintainers use this notation when they apply
patches. In your case, you are submitter, patch is not applied yet
and all changes can be easily seen through lore web interface.

> 
> I'm seeing plenty of recent precedent in the git history where
> non-committers fixed up patches and made their changes known in
> this way, e.g.:

It doesn't make it correct.
Documentation/maintainer/modifying-patches.rst

Thanks

