Return-Path: <netdev+bounces-6430-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD1937163E5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:24:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9835F281210
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5215B23C79;
	Tue, 30 May 2023 14:23:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A1621076
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:23:59 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4587171D;
	Tue, 30 May 2023 07:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=FWAIGy3W6VRuHfHWmHtL4IHZGLEpQvK9/WLf1WisLfI=; b=QsJSun8z9mB/Mco6Uqic0npFOn
	J+Nfq1fixoi8UAwixInmQg0yHXy8gshY81qIm+lDlc/NAlnr/QZLZH+oqsCRdgXLnKy5XB/URA4Uo
	l0v6im7FYGjFGucV2X4rFcYiVJhAk8gO4jS7ftT7eGW6EkjsfqqV6pR19J8gsQ5iaU0U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q40Fs-00ELCp-5e; Tue, 30 May 2023 16:23:20 +0200
Date: Tue, 30 May 2023 16:23:20 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lukasz Majewski <lukma@denx.de>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Vivien Didelot <vivien.didelot@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <e7696621-38a9-41a1-afdf-0864e115d796@lunn.ch>
References: <20230530122621.2142192-1-lukma@denx.de>
 <ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
 <20230530160743.2c93a388@wsk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530160743.2c93a388@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 04:07:43PM +0200, Lukasz Majewski wrote:
> Hi Russell,
> 
> > On Tue, May 30, 2023 at 02:26:21PM +0200, Lukasz Majewski wrote:
> > > One can disable in device tree advertising of EEE capabilities of
> > > PHY when 'eee-broken-100tx' property is present in DTS.
> > > 
> > > With DSA switch it also may happen that one would need to disable
> > > EEE due to some network issues.
> > > 
> > > Corresponding switch DTS description:
> > > 
> > >  switch@0 {
> > > 	 ports {
> > > 		port@0 {
> > > 		reg = <0>;
> > > 		label = "lan1";
> > > 		phy-handle = <&switchphy0>;
> > > 		};
> > > 	}
> > > 	mdio {
> > > 		switchphy0: switchphy@0 {
> > > 		reg = <0>;
> > > 		eee-broken-100tx;
> > > 	};
> > > 	};
> > > 
> > > This patch adjusts the content of MDIO_AN_EEE_ADV in MDIO_MMD_AN
> > > "device" so the phydev->eee_broken_modes are taken into account
> > > from the start of the slave PHYs.  
> > 
> > This should be handled by phylib today in recent kernels without the
> > need for any patch (as I describe below, because the config_aneg PHY
> > method should be programming it.) Are you seeing a problem with it
> > in 6.4-rc?
> 
> Unfortunately, for this project I use LTS 5.15.z kernel.
> 
> My impression is that the mv88e6xxx driver is not handling EEE setup
> during initialization (even with v6.4-rc).

In general, nearly every driver gets EEE wrong. I have a patchset
which basically rewrites EEE. It has been posted as RFC a couple
times, and i plan to start posting it for merging this week.

But as a result, don't expect EEE to actually work with any LTS
kernel.

	Andrew

