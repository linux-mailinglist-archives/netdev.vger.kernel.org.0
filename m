Return-Path: <netdev+bounces-4312-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C81E70C006
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26F3E280F6F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A7014261;
	Mon, 22 May 2023 13:48:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272D2AD4C
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:48:37 +0000 (UTC)
Received: from smtp.missinglinkelectronics.com (smtp.missinglinkelectronics.com [162.55.135.183])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6D8F4;
	Mon, 22 May 2023 06:48:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp.missinglinkelectronics.com (Postfix) with ESMTP id DEF7820619;
	Mon, 22 May 2023 15:48:30 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at missinglinkelectronics.com
Received: from smtp.missinglinkelectronics.com ([127.0.0.1])
	by localhost (mail.missinglinkelectronics.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P9uGa9M0bdmL; Mon, 22 May 2023 15:48:30 +0200 (CEST)
Received: from nucnuc.mle (p578c5bfe.dip0.t-ipconnect.de [87.140.91.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: david)
	by smtp.missinglinkelectronics.com (Postfix) with ESMTPSA id 98EF52041E;
	Mon, 22 May 2023 15:48:29 +0200 (CEST)
Date: Mon, 22 May 2023 15:48:23 +0200
From: David Epping <david.epping@missinglinkelectronics.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 3/3] net: phy: mscc: enable VSC8501/2 RGMII RX clock
Message-ID: <20230522134823.GA18381@nucnuc.mle>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
 <ZGpcGbq47nL/rlEb@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGpcGbq47nL/rlEb@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 21, 2023 at 06:59:53PM +0100, Russell King (Oracle) wrote:
> On Sat, May 20, 2023 at 06:06:03PM +0200, David Epping wrote:
> > +static int vsc85xx_rgmii_enable_rx_clk(struct phy_device *phydev,
> > +				       u32 rgmii_cntl)
> > +{
> > +	int rc, phy_id;
> > +
> > +	phy_id = phydev->drv->phy_id & phydev->drv->phy_id_mask;
> > +	if (PHY_ID_VSC8501 != phy_id && PHY_ID_VSC8502 != phy_id)
> > +		return 0;
> 
> As you are accessing the phy_id in the phy_driver struct, isn't it
> already true that this will be initialised to constants such as
> PHY_ID_VSC8501 or PHY_ID_VSC8502? In which case, why would you need
> to mask it with drv->phy_id_mask ?

Yes you are right. I copied the code from the vsc85xx_config_init()
function in the same driver, but the extra masking is not necessary.
It seems to be the phy_id in the struct phy_device which is read from
the MDIO bus and thus needs masking. phy_id in struct phy_driver seems
compile time defined and already masked.
I'll adjust my patch.

> > +
> > +	mutex_lock(&phydev->lock);
> > +
> > +	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2, rgmii_cntl,
> > +			      VSC8502_RGMII_RX_CLK_DISABLE, 0);
> > +
> > +	mutex_unlock(&phydev->lock);
> 
> What is the purpose of taking this lock? phy_modify_paged() will do its
> read-modify-write access and page accesses under the MDIO bus lock,
> which should be all that's required to guarantee an atomic update.

Yes, I copied this from the vsc85xx_rgmii_set_skews() function in the
same driver accessing the same register in the same context.
But maybe it is used there because of repeated phydev->interface
accesses, which may otherwise change during function execution?
I'll remove the locks from my patch.

Thanks for your feedback.

