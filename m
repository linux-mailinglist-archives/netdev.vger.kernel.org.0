Return-Path: <netdev+bounces-1975-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE4766FFD11
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:16:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7A231C210E6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6FA17738;
	Thu, 11 May 2023 23:16:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5836B3FDF
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAE2C433D2;
	Thu, 11 May 2023 23:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683846987;
	bh=gFFD89LZvugM7WhsLKuSc3mFn036m6H0ofl6OZOFbbI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=INzcH1tuPMwA7QcC4/DiKKNy8v6/oitCig/ytfKAqNP+KCUwDv6XeB8yNDr+vsOFl
	 HqDP7yaOSLke26JSEMkD9brxORVfMrpYnBijf5Dmw+NBUlbzzXV1Z8a2XexNzej5oL
	 STxmVJuaDhf1sBTxXhPgMA35rggQLltv8GMHcse6fXxtMd5UES2X84RhCvV6Mchl2X
	 k05sE40BPdprglpKyAMt5vDUz7Ixahlqo9Ibc6GCuSvYb0caLOCYFGwK1/IoPzbsb1
	 og4hsaDVOVKcooeY1t1ivBgYndXrndYiT+3RE6cBR5pij/vC2wUNlWXdhCWxZaBmxz
	 wODqcIXFDEOHQ==
Date: Thu, 11 May 2023 16:16:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, Andrew Lunn
 <andrew@lunn.ch>, =?UTF-8?B?S8O2cnk=?= Maincent
 <kory.maincent@bootlin.com>, netdev@vger.kernel.org, glipus@gmail.com,
 maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
 richardcochran@gmail.com, gerhard@engleder-embedded.com,
 thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
 robh+dt@kernel.org
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230511161625.2e3f0161@kernel.org>
In-Reply-To: <20230511230717.hg7gtrq5ppvuzmcx@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-3-kory.maincent@bootlin.com>
	<20230406184646.0c7c2ab1@kernel.org>
	<20230511203646.ihljeknxni77uu5j@skbuf>
	<54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
	<ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
	<20230511210237.nmjmcex47xadx6eo@skbuf>
	<20230511150902.57d9a437@kernel.org>
	<20230511230717.hg7gtrq5ppvuzmcx@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 May 2023 02:07:17 +0300 Vladimir Oltean wrote:
> On Thu, May 11, 2023 at 03:09:02PM -0700, Jakub Kicinski wrote:
> > Exactly, think Tx. For Rx hauling the TS in metadata from PHY/MAC to
> > descriptor is easy. For Tx device will buffer the packet so the DMA
> > completion happens before the packet actually left onto the wire.
> > 
> > Which is not to say that some devices may not generate the Rx timestamp
> > when the packet is DMA'ed out of laziness, too.
> >   
> > > timestamps is an alternate solution to the same problem as DMA
> > > timestamps, or whatever:
> > > https://lore.kernel.org/netdev/20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com/  
> > 
> > What I was thinking was:
> > 
> >  - PHY - per spec, at the RS layer
> >  - MAC - "close to the wire" in the MAC, specifically the pipeline
> >    delay (PHY stamp vs MAC stamp) should be constant for all packets;
> >    there must be no variable-time buffering and (for Tx) the time
> >    stamping must be past the stage of the pipeline affected by pause
> >    frames
> >  - DMA - worst quality, variable delay timestamp, usually taken when
> >    packets DMA descriptors (Rx or completion) are being written
> > 
> > With these definitions MAC and PHY timestamps are pretty similar
> > from the perspective of accuracy.  
> 
> So if I add a call to ptp_clock_info :: gettimex64() where the
> skb_tx_timestamp() call is located in a driver, could that pass as
> a DMA timestamp?

Yes.

> The question is how much do we want to encourage these DMA timestamps:
> enough to make them a first-class citizen in the UAPI? Are users even
> happy with their existence?

I don't want to call anyone out, but multiple high speed devices
with the current, in tree drivers report DMA timestamps when you 
ask for HW timestamps. DMA stamps are still 2 orders of magnitude
better than SW stamping.

> I mean, I can't ignore the fact that there are NICs that can provide
> 2-step TX timestamps at line rate for all packets (not just PTP) for
> line rates exceeding 10G, in band with the descriptor in its TX
> completion queue. I don't want to give any names, just to point out
> that there isn't any inherent limitation in the technology.

Oh, you should tell me, maybe off-list then. 'Cause I don't know any.

> AFAIU from igc_ptp_tx_hwtstamp(), it's just that the igc DMA
> controller did not bother to transport the timestamps from the MAC
> back into the descriptor, leaving it up to software to do it out of
> band, which of course may cause correlation bugs and limits
> throughput. Surely they can do better.

It's not that simple. Any packet loss or diversion and you may end up
missing a completion.

