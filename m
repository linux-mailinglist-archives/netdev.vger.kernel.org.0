Return-Path: <netdev+bounces-1971-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 395A16FFCDB
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 00:54:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 092C41C210C1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB86BAD50;
	Thu, 11 May 2023 22:54:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A36C3FDF
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 22:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A301C433EF;
	Thu, 11 May 2023 22:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683845681;
	bh=QVVCkIxc3xtTASmFP+aV8ALm10wM0ZQ5lCoP2mGPlVQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eQjFNbJrfqzJcjoKMu0HjRT066wbeDEN2Z4+O8ZDMZ10SVneaubF51m9dmjnPwu7C
	 Ow80Zrmo6m5aqYHm6xSrEeAIERzfDKUTdgmXwZVUwMt/c3OYvALfmwzpqrbYPHAT5v
	 mAV5/pL55D4x9gIHgw5h80XQJqYU9BcfdkAhGlhMkUt/HT+ODyGiQUVVLtEbo2oBKc
	 tbnqwairZFTv2+xtrPW4qQ86EFNHagY23MyUbjgrl9YxiKXLPGSUfGdL3up8OXt6ld
	 IfPCn0A3XYkvqlHi7OknHBb9Bp2Gxv8QBIi9sVWG2LrgRiFek08lJ5db9thhJTYGQa
	 L1awzlWEFTTdQ==
Date: Thu, 11 May 2023 15:54:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>, =?UTF-8?B?S8O2cnk=?= Maincent
 <kory.maincent@bootlin.com>, netdev@vger.kernel.org, glipus@gmail.com,
 maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
 richardcochran@gmail.com, gerhard@engleder-embedded.com,
 thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
 robh+dt@kernel.org
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <20230511155439.7652757c@kernel.org>
In-Reply-To: <ZF1Y3OurlvukFBs1@shell.armlinux.org.uk>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230429175807.wf3zhjbpa4swupzc@skbuf>
	<20230502130525.02ade4a8@kmaincent-XPS-13-7390>
	<20230511134807.v4u3ofn6jvgphqco@skbuf>
	<20230511083620.15203ebe@kernel.org>
	<20230511155640.3nqanqpczz5xwxae@skbuf>
	<20230511092539.5bbc7c6a@kernel.org>
	<ZF1Y3OurlvukFBs1@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 May 2023 22:06:36 +0100 Russell King (Oracle) wrote:
> I haven't thought this through fully, but just putting this out there
> as a potential suggestion...
> 
> Would it help at all if we distilled the entire timestamping interface
> into a separate set of ops which are registered independently from the
> NDO, and NDO has a call to get the ops for the layer being configured?
> 
> That would allow a netdev driver to return the ops appropriate for the
> MAC layer or its own PHY layer, or maybe phylib.
> 
> In the case of phylib, as there is a raft of drivers that only bind to
> their phylib PHY in the NDO open method, we'd need to figure out how
> to get the ops for the current mode at that time.
> 
> There's probably lots I've missed though...

Sounds reasonable, only question is what to pass as the object (first
argument) of these ops. Some new struct?

