Return-Path: <netdev+bounces-3898-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ED7A709793
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:51:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE6001C21262
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 12:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48ABB8C0B;
	Fri, 19 May 2023 12:51:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6327C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 12:51:28 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533E410F4
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 05:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=pf9BPjd4cLMo72yUcoA1Nvak/BfZnrjn4+5f46Liwlc=; b=z+WFSR4HKw4lHvzOJG+VNWbHO3
	GQP6/9qOwA8tIX0i/DB+YpkyFLhO5QbKcvf/EfjxMuu1tnPDeuyKeNTvfYlFGyQJ44jbcV7oUpfb7
	utMyGrnBDIgdYPltmcFgUIm11THDgySbOKAMFippISdMa41SM9Ha9/IwAJNceY1dbLeQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzzZC-00DKE2-4M; Fri, 19 May 2023 14:50:42 +0200
Date: Fri, 19 May 2023 14:50:42 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jacob Keller <jacob.e.keller@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
	vadim.fedorenko@linux.dev, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <a5435c39-438c-434c-a0b5-73bf6ecd3a99@lunn.ch>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
 <5f9a1929-b511-707a-9b56-52cc5f1c40ba@intel.com>
 <ZGVZXTEn+qnMyNgV@hoboy.vegasvil.org>
 <32cb61b3-16f6-5b2b-4d57-5764dc8499cc@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32cb61b3-16f6-5b2b-4d57-5764dc8499cc@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 04:23:10PM -0700, Jacob Keller wrote:
> 
> 
> On 5/17/2023 3:46 PM, Richard Cochran wrote:
> > On Wed, May 17, 2023 at 03:13:06PM -0700, Jacob Keller wrote:
> > 
> >> For example, ice hardware captures timestamp data in its internal PHY
> >> well after the MAC layer finishes, but it doesn't expose the PHY to the
> >> host at all..
> >>
> >> From a timing perspective it matters that its PHY, but from an
> >> implementation perspective there's not much difference since we don't
> >> support MAC timestamping at all (and the PHY isn't accessible through
> >> phylink...)
> > 
> > Here is a crazy idea:  Wouldn't it be nice to have all PHYs represented
> > in the kernel driver world, even those PHYs that are built in?
> > 
> 
> I agree. I've wanted us to enable phylib/phylink/something for our
> internal PHYs, but never got traction here to actually make it happen.
> There was a push a few years ago for using it in igb, but ultimately
> couldn't get enough support to make the development happen :( Similar
> with using the i2c interfaces... These days, so much of the control
> happens only in firmware that it has its own challenges.

I know there is some cleanup going on reducing replicated code in
Intel Ethernet drivers. I was wondering if that would extend to
PHYs. But as you say, recent Intel hardware have firmware controlling
the PHYs, not Linux. So such cleanups would be limited to older
controllers which i guess Intel probably no longer cares about.

> > I've long thought that having NETWORK_PHY_TIMESTAMPING limited to
> > PHYLIB (and in practice device tree) systems is unfortunate.
> > 
> 
> It is a bit unfortunate. In the ice driver case, we just report the
> timestamps in the usual way for a network driver, which is ok enough
> since no other timestamps exist for us.

I would actually say there is nothing fundamentally blocking using
NETWORK_PHY_TIMESTAMPING with something other than DT. It just needs
somebody to lead the way.

For ACPI in the scope of networking, everybody just seems to accept DT
won, and stuffs DT properties into ACPI tables. For PCI devices, there
has been some good work being done by Trustnetic using software nodes,
for gluing together GPIO controllers, I2C controller, SFP and
PHYLINK. It should be possible to do the same with PHY timestampers.

	 Andrew

