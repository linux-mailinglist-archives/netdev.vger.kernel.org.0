Return-Path: <netdev+bounces-4003-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A85370A082
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 22:22:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D85E81C21195
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 20:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C559A17AAE;
	Fri, 19 May 2023 20:22:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760FE1119C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF6DC433EF;
	Fri, 19 May 2023 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684527772;
	bh=8ERj7pRpPOFtwXDxAu+QPFi9TSTZZGIT1SvV9yhNtW8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tfz+URnf5hMLYWt+/0g935MHDjFkJSSWV+WFv17EIuQzJrESngwZuSlO9ldafg92C
	 N9VyYNMNxLs1S/Olmwy17LE5tHVzHejQQVRSPRqeNv0aFrPvJPGw1kwj+WlzGmU1NI
	 9sggLw4xfVGV3fKzviPAeyEOmW/mJ8mzT3JVdpcMYegf4LkeTUsyx5WDnbTpUrOwzf
	 bhzg2XZyGynuKNceW3Cel44nz9MaStLpliRNOvNThlauyhTiiCU7AVa2Q7LDjTRxmy
	 rBgglJUQBde2hKNoGpvRFdxUObzPPecamOrwEdhXk4R1p0Ej1eabZh4JIgjyfPKbfM
	 UnYMdiOslaxXA==
Date: Fri, 19 May 2023 13:22:50 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, Andrew Lunn
 <andrew@lunn.ch>, =?UTF-8?B?S8O2cnk=?= Maincent
 <kory.maincent@bootlin.com>, netdev@vger.kernel.org, glipus@gmail.com,
 maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
 richardcochran@gmail.com, gerhard@engleder-embedded.com,
 thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
 robh+dt@kernel.org, Jacob Keller <jacob.e.keller@intel.com>, "Zulkifli,
 Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230519132250.35ce4880@kernel.org>
In-Reply-To: <20230519132802.6f2v47zuz7omvazy@skbuf>
References: <20230406184646.0c7c2ab1@kernel.org>
	<20230511203646.ihljeknxni77uu5j@skbuf>
	<54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
	<ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
	<20230511210237.nmjmcex47xadx6eo@skbuf>
	<20230511150902.57d9a437@kernel.org>
	<20230511230717.hg7gtrq5ppvuzmcx@skbuf>
	<20230511161625.2e3f0161@kernel.org>
	<20230512102911.qnosuqnzwbmlupg6@skbuf>
	<20230512103852.64fd608b@kernel.org>
	<20230519132802.6f2v47zuz7omvazy@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 May 2023 16:28:02 +0300 Vladimir Oltean wrote:
> > I may have lost track of what the argument is. There are devices
> > which will provide a DMA stamp for Tx and Rx. We need an API that'll
> > inform the user about it. 
> > 
> > To be clear I'm talking about drivers which are already in the tree,
> > not opening the door for some shoddy new HW in.  
> 
> So this is circling back to my original question (with emphasis on the
> last part):
> 
> | Which drivers provide DMA timestamps, and how do they currently signal
> | that they do this? Do they do this for all packets that get timestamped,
> | or for "some"?
> 
> https://lore.kernel.org/netdev/20230511203646.ihljeknxni77uu5j@skbuf/
> 
> If only "some" packets (unpredictable which) get DMA timestamps when
> a MAC timestamp isn't available, what UAPI can satisfactorily describe
> that? And who would want that?

The short answer is "I don't know". There's been a lot of talk about
time stamps due to Swift/BBRv2, but I don't have first hand experience
with it. That'd require time stamping "all" packets but the precision 
is really only required to be in usec.

Maybe Muhammad has a clearer use case in mind.

