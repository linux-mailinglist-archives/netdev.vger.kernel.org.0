Return-Path: <netdev+bounces-1969-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A51BA6FFC91
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 00:09:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E984328194E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE1417727;
	Thu, 11 May 2023 22:09:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4BC2918
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 22:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03B9C433EF;
	Thu, 11 May 2023 22:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683842944;
	bh=iuzzBYoyz2XgpQVAQuCYlv1jBuIqGLCIXMJbzwuMVBI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fwJceY82HxQqUNUt7VwHn3AZao3GjH9oAu/NCqWVC0Piih37O7greRUBsyK0Lij+2
	 YWlh2PH4bgqA1D/zmuohnuU+NQX54MwoaW3/tdaowmhUVUGlSK81+eTW2440pJB+As
	 O+Wm4uzSlhavp32xmeDYOsCOrC0Iqj5QSgMRJXv0a4VyVL4t8VlA8+9uZ289jB9HkY
	 BEHxOfCa/esF2ehEJUz/jIVw0lk70l8El6NvW5Z9jrVSQAK9Ns7lFc1CX+FZq/mB2/
	 3uvAjvqCXMjAH9yQj2LHvDThkVhOLaaL29IenfItIh+p03Oilkc9IY4Mj4pApYK9at
	 JgAMQt6T2FAQQ==
Date: Thu, 11 May 2023 15:09:02 -0700
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
Message-ID: <20230511150902.57d9a437@kernel.org>
In-Reply-To: <20230511210237.nmjmcex47xadx6eo@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-3-kory.maincent@bootlin.com>
	<20230406184646.0c7c2ab1@kernel.org>
	<20230511203646.ihljeknxni77uu5j@skbuf>
	<54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
	<ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
	<20230511210237.nmjmcex47xadx6eo@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 May 2023 00:02:37 +0300 Vladimir Oltean wrote:
> > Surely that is equivalent to MAC timestamping? Whether the MAC
> > places it in a DMA descriptor, or whether it places it in some
> > auxiliary information along with the packet is surely irrelevant,
> > because the MAC has to have the timestamp available to it in some
> > manner. Where it ends up is just a function of implementation surely?
> > 
> > I'm just wondering what this would mean for mvpp2, where the
> > timestamps are in the descriptors. If we have a "DMA timestamp"
> > is that a "DMA timestamp" or a "MAC timestamp"? The timestamp comes
> > from the MAC in this case.  
> 
> No, a MAC timestamp carried through a DMA descriptor is still a MAC
> timestamp (better said: timestamp taken at the MAC).

Right. The method of communicating the TS and where TS is taken 
are theoretically unrelated (in practice DMA timestamp not in
a descriptor is likely pointless).

> DMA timestamps probably have to do with this igc patch set, which I
> admit to not having had the patience to follow along all the way and
> understand what is its status and if it was ever accepted in that form,
> or a different form, or if Vinicius' work for multiple in-flight TX

Exactly, think Tx. For Rx hauling the TS in metadata from PHY/MAC to
descriptor is easy. For Tx device will buffer the packet so the DMA
completion happens before the packet actually left onto the wire.

Which is not to say that some devices may not generate the Rx timestamp
when the packet is DMA'ed out of laziness, too.

> timestamps is an alternate solution to the same problem as DMA
> timestamps, or whatever:
> https://lore.kernel.org/netdev/20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com/

What I was thinking was:

 - PHY - per spec, at the RS layer
 - MAC - "close to the wire" in the MAC, specifically the pipeline
   delay (PHY stamp vs MAC stamp) should be constant for all packets;
   there must be no variable-time buffering and (for Tx) the time
   stamping must be past the stage of the pipeline affected by pause
   frames
 - DMA - worst quality, variable delay timestamp, usually taken when
   packets DMA descriptors (Rx or completion) are being written

With these definitions MAC and PHY timestamps are pretty similar
from the perspective of accuracy.

