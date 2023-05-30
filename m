Return-Path: <netdev+bounces-6546-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97DF4716DF6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:48:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 379C11C20D2A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC22F2D275;
	Tue, 30 May 2023 19:48:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17FC200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:48:21 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF84EF3
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=25yVjcIWoQ9aGd1lILRDDgQ5yWRxY51ekcgNvFPkZiM=; b=ztSqJRYrUHObNf7Dd/8UIBFXfQ
	mCXxSev4IKtCZIuQC45jIdhq+WttI1QFXtz8RzR6nWsEFmGM8Kal1h3m/EsBh3MzJZfye/R6JKwEI
	w4PAwBHklxhgfw35lcEiQwlqKDFRp8uqwxaiGW9HEZT3cAvitbJ3+sFJt7EIOzx2gruQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q45K4-00ENaa-Ek; Tue, 30 May 2023 21:48:00 +0200
Date: Tue, 30 May 2023 21:48:00 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev <netdev@vger.kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [RFC/RFTv3 00/24] net: ethernet: Rework EEE
Message-ID: <d753d72c-6b7a-4014-b515-121dd6ff957b@lunn.ch>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <fa21ef50-7f36-3d01-5ecf-4a2832bcec89@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa21ef50-7f36-3d01-5ecf-4a2832bcec89@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 11:31:04AM -0700, Florian Fainelli wrote:
> Hi Andrew, Russell,
> 
> On 3/30/23 17:54, Andrew Lunn wrote:
> > Most MAC drivers get EEE wrong. The API to the PHY is not very
> > obvious, which is probably why. Rework the API, pushing most of the
> > EEE handling into phylib core, leaving the MAC drivers to just
> > enable/disable support for EEE in there change_link call back, or
> > phylink mac_link_up callback.
> > 
> > MAC drivers are now expect to indicate to phylib/phylink if they
> > support EEE. If not, no EEE link modes are advertised. If the MAC does
> > support EEE, on phy_start()/phylink_start() EEE advertisement is
> > configured.
> 
> Thanks for doing this work, because it really is a happy mess out there. A
> few questions as I have been using mvneta as the reference for fixing GENET
> and its shortcomings.
> 
> In your new patches the decision to enable EEE is purely based upon the
> eee_active boolean and not eee_enabled && tx_lpi_enabled unlike what mvneta
> useed to do.

I don't really care much what we decide means 'enabled'. I just want
it moved out of MAC drivers and into the core so it is consistent.

Russel, if you want to propose something which works for both Copper
and Fibre, i'm happy to implement it. But as you pointed out, we need
to decide where. Maybe phylib handles copper, and phylink is layered
on top and handles fibre?

	  Andrew

