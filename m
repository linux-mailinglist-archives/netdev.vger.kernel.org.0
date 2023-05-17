Return-Path: <netdev+bounces-3448-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1122F7072B7
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 22:07:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C766E281698
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE1F34CFE;
	Wed, 17 May 2023 20:07:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861CE111AD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 20:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9595C4339C;
	Wed, 17 May 2023 20:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684354028;
	bh=JngpmkirbQZwwCX9sp2TZtxp6jym5tV7TmhWqWmhpK0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q5Z2QavG5qpRyKFXmc1tTC2wpk0xOQbZcjOvutV4HYcEyiVduy6TYEX+9MDWg2cxV
	 Rk78LXfqChgF+cJX5L9YaGwiyq2PqDbJz7vne5uwRVgzPI6JUQ/p96cwFuHZUw1bLe
	 aijjdIbhQWq3kGRc9zsfdyp7k/lCjfcGHE50ZUk4ynpIKRHXmXtyMGzMZjjes0ZRhl
	 XD36bdCqSylA/KqVp+U9cPg6meyqYw4PNcI7KEG+twxeMW97WajZpZ8WOKUa99o6mv
	 7LH/eKbf8T810yvoQ7Ncf36S0zf/KWZBK3p4aht4OreMtCVsQn7PEg8EPlsE38Yf2f
	 CeMzl6Nwwfwyg==
Date: Wed, 17 May 2023 13:07:06 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>, "Russell King (Oracle)"
 <linux@armlinux.org.uk>, =?UTF-8?B?S8O2cnk=?= Maincent
 <kory.maincent@bootlin.com>, netdev@vger.kernel.org, glipus@gmail.com,
 maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
 richardcochran@gmail.com, gerhard@engleder-embedded.com,
 thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
 robh+dt@kernel.org
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230517130706.3432203b@kernel.org>
In-Reply-To: <2f89e35e-b1c9-4e08-9f60-73a96cc6e51a@lunn.ch>
References: <20230511203646.ihljeknxni77uu5j@skbuf>
	<54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
	<ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
	<20230511210237.nmjmcex47xadx6eo@skbuf>
	<20230511150902.57d9a437@kernel.org>
	<20230511230717.hg7gtrq5ppvuzmcx@skbuf>
	<20230511161625.2e3f0161@kernel.org>
	<20230512102911.qnosuqnzwbmlupg6@skbuf>
	<20230512103852.64fd608b@kernel.org>
	<20230517121925.518473aa@kernel.org>
	<2f89e35e-b1c9-4e08-9f60-73a96cc6e51a@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 May 2023 21:46:43 +0200 Andrew Lunn wrote:
> As i said in an earlier thread, with a bit of a stretch, there could
> be 7 places to take time stamps in the system. We need some sort of
> identifier to indicate which of these stampers to use.
> 
> Is clock ID unique? In a switch, i think there could be multiple
> stampers, one per MAC port, sharing one clock? So you actually need
> more than a clock ID.

Clock ID is a bit vague too, granted, but in practice clock ID should
correspond to the driver fairly well? My thinking was - use clock ID
to select the (silicon) device, use a different attribute to select 
the stamping point.

IOW try to use the existing attribute before inventing a new one.

> Also, 'By the standard - stamping happens under the MAC'. Which MAC?
> There can be multple MAC's in the pipeline. MACSEC and rate adaptation
> in the PHY are often implemented by the PHY having a MAC
> reconstituting the frame from the bitstream and putting it into a
> queue. Rate adaptation can then be performed by the PHY by sending
> pause frames to the 'primary' MAC to slow it down. MACSEC in the PHY
> takes frames in the queues and if they match a filter they get
> encrypted. The PHY then takes the frame out of the queue and passes
> them to a second MAC in the PHY which creates a bitstream and then to
> a 'PHY' to generate signals for the line.
> 
> In this sort of setup, you obviously don't want the 'primary' MAC
> doing the stamping. You want the MAC nearest to the line, or better
> still the 'PHY' within the PHY just before the line.

For a PHY "always use the point closest to the wire" makes sense.

For DMA we'd have a different set of priorities - precision vs
volume vs 1-step / 2-step; but all from the same clock. I think 
that we may want to defer figuring out selection within a single
clock for now, to make some progress.

