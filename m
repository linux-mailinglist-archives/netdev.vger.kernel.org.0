Return-Path: <netdev+bounces-1952-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02BCD6FFB77
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 145B11C21070
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB92AD53;
	Thu, 11 May 2023 20:50:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE03F624
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:50:36 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C704C12
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=bPs0zS9xgFQ7+41ilgCrZTaFE7mVYdjm2apdd2EgTOg=; b=QDZPq0pTwfDP9ktaZJefUI+ryA
	kfL/Q5RvRRNzIXeWET6mr07fWm2K4m1kheCzULeANCcy2XPehFHpnn8ZbXiH2J3YFpbLW9BR5RVvJ
	aiV5k4iET/pIFcL2qRUFHafWeNdt5sZedcCwA7pwISdnln3CLk3ItqVsLmN7vISbz410=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pxDF8-00Cak4-5N; Thu, 11 May 2023 22:50:30 +0200
Date: Thu, 11 May 2023 22:50:30 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	=?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
 <20230511203646.ihljeknxni77uu5j@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511203646.ihljeknxni77uu5j@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 11:36:46PM +0300, Vladimir Oltean wrote:
> On Thu, Apr 06, 2023 at 06:46:46PM -0700, Jakub Kicinski wrote:
> > > +/* Hardware layer of the SO_TIMESTAMPING provider */
> > > +enum timestamping_layer {
> > > +	SOF_MAC_TIMESTAMPING = (1<<0),
> > > +	SOF_PHY_TIMESTAMPING = (1<<1),
> > 
> > We need a value for DMA timestamps here.
> 
> What's a DMA timestamp, technically? Is it a snapshot of the PHC's time
> domain, just not at the MII pins?

I also wounder if there is one definition of DMA timestampting, or
multiple. It could simply be that the time stamp is in the DMA
descriptor, but the sample of the PHC was taken as the SOF was
received. It could be the sample of the PHC at the point the DMA
descriptor was handed back to the host. It could be the PHC was
sampled when the host reads the descriptor, etc.

I also wounder if there is sufficient documentation to be able to tell
them apart for devices which support it. So maybe it does not even
matter what the exact definition is?

	Andrew

