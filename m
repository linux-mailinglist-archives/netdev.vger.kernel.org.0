Return-Path: <netdev+bounces-5274-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5237710843
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35D741C20C58
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312DFD304;
	Thu, 25 May 2023 09:04:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250012CAB
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:04:38 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5963199;
	Thu, 25 May 2023 02:04:36 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 3DCB460013;
	Thu, 25 May 2023 09:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685005475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8AnUzsP3UiJT5MlwCjsZ+EyBtgzsenG9IYcBknz1kBQ=;
	b=U2M8IBLinR/uVFzSNOYp/JLVIV4pHW8pufMV2Zwvzee1LzdOwuJE1bMW6bWaMWJsNDmvSp
	x/3aTpevugcHU38/xepiBW7Sze2R82WDfkHxpB5skOSFvbT44byBFf+Q6dMFT2/F7N2huE
	Lds8/8E4zgK67x7VwXM6Y/DKtOlxlePfu8vDsCtGWfk/uAbDDltY1kFBWMIhP+gBN6hAI4
	jCozUHi3CGSgjNaz5ey+RK3dPL2f1EAqo7kivOGX3oiZT03/W+/WNraV6IZzr8uw2acXk0
	7klvjDcM+HPd7bnQjcAnHzpowAxnzoRK1Iid2cTwu8rRXSmDvx0mp2ZIkxZ4oQ==
Date: Thu, 25 May 2023 11:04:29 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Mark Brown <broonie@kernel.org>,
 davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com, Jakub Kicinski
 <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Florian Fainelli <f.fainelli@gmail.com>, Heiner
 Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>,
 Ioana Ciornei <ioana.ciornei@nxp.com>,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Jose Abreu <joabreu@synopsys.com>, Alexandre
 Torgue <alexandre.torgue@foss.st.com>, Giuseppe Cavallaro
 <peppe.cavallaro@st.com>
Subject: Re: [PATCH net-next 1/4] net: mdio: Introduce a regmap-based mdio
 driver
Message-ID: <20230525110429.66ba241b@pc-7.home>
In-Reply-To: <20230524174145.hhurl4olnzmfadww@skbuf>
References: <20230524130807.310089-1-maxime.chevallier@bootlin.com>
	<20230524130807.310089-2-maxime.chevallier@bootlin.com>
	<8f779d98-d437-4d8b-914d-8e315b4aca17@lunn.ch>
	<20230524174145.hhurl4olnzmfadww@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Vlad, Andrew,

On Wed, 24 May 2023 20:41:45 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Wed, May 24, 2023 at 07:30:51PM +0200, Andrew Lunn wrote:
> > > +	mii->name = DRV_NAME;
> > > +	strscpy(mii->id, config->name, MII_BUS_ID_SIZE);
> > > +	mii->parent = config->parent;
> > > +	mii->read = mdio_regmap_read_c22;
> > > +	mii->write = mdio_regmap_write_c22;  
> > 
> > Since there is only one valid address on the bus, you can set
> > mii->phy_mask to make the scanning of the bus a little faster.  

Good point, I'll add that.

> Sorry, I didn't reach this thread yet, I don't have the full context.
> Just wanted to add: if the caller knows that there's only a PCS and
> not a PHY on this bus, you don't want auto-scanning at all, since
> that will create an unconnected phy_device. It would be good if the
> caller provided the phy_mask.

As there can only be one mdiodevice on that bus, and we are already
passing the address of the only available device in struct
mdio_rgmap_config.valid_addr, I guess we can simply add a flag to
indicate if autoscan needs to be enabled or not, and set phy_mask to
either unmask the only valid address, or plain ~0UL if we don't want
autoscan at all.

Thanks both of you for the reviews,

Maxime


