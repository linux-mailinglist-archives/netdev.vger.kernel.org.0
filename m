Return-Path: <netdev+bounces-1874-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C396FF61A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58B461C20D02
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5352B641;
	Thu, 11 May 2023 15:36:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1EE629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBF6C433D2;
	Thu, 11 May 2023 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683819382;
	bh=4A8n03iQdhJdrXZijpx44Mz2CX3hR6qccf720TX/kus=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RSTl0C7bnb8Fow+S1niMr3SJlq1SKSyyoHIhF61Vrv3a+pkMsZiLdsqb0oTFUaipM
	 yBXYO0TS49grQwptrGoSHpY7XTthrrVOtoNZlhGWkgG5g+GysulYEYVS5p/paTsQH3
	 Fc6w81omaJP9ioWf211nmTd/QZoXTbxcT0ojsADdFtc8pq5+pOjnoStmpHjW2gt+zh
	 8oHIjSm0sS/GknSH479cPwoPIj7cj8PKbLFwWY5sIGTk1FIshnItZyf5MnPGZLLalb
	 /vqRle8usr1UFmrGWG8MsZtoIHj8Ch+yrW5irKR4LKbrkxCSmkNHu9RADXIk8ZiZaA
	 XyG67mJIafX7w==
Date: Thu, 11 May 2023 08:36:20 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
 netdev@vger.kernel.org, glipus@gmail.com, maxime.chevallier@bootlin.com,
 vadim.fedorenko@linux.dev, richardcochran@gmail.com,
 gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com,
 krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
 linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <20230511083620.15203ebe@kernel.org>
In-Reply-To: <20230511134807.v4u3ofn6jvgphqco@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230429175807.wf3zhjbpa4swupzc@skbuf>
	<20230502130525.02ade4a8@kmaincent-XPS-13-7390>
	<20230511134807.v4u3ofn6jvgphqco@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 May 2023 16:48:07 +0300 Vladimir Oltean wrote:
> > Ok, right you move it on to dsa stub. What do you think of our case, should we
> > continue with netdev notifier?   
> 
> I don't know.
> 
> AFAIU, the plan forward with this patch set is that, if the active
> timestamping layer is the PHY, phy_mii_ioctl() gets called and the MAC
> driver does not get notified in any way of that. That is an issue
> because if it's a switch, it will want to trap PTP even if it doesn't
> timestamp it, and with this proposal it doesn't get a chance to do that.
> 
> What is your need for this? Do you have this scenario? If not, just drop
> this part from the patch.
> 
> Jakub, you said "nope" to netdev notifiers, what would you suggest here
> instead? ndo_change_ptp_traps()?

More importantly "monolithic" drivers have DMA/MAC/PHY all under 
the NDO so assuming that SOF_PHY_TIMESTAMPING implies a phylib PHY
is not going to work.

We need a more complex calling convention for the NDO.

