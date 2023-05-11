Return-Path: <netdev+bounces-1752-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B256FF0BC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC0F32816CA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C90519BD1;
	Thu, 11 May 2023 11:56:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0227D65B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:55:59 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F612680;
	Thu, 11 May 2023 04:55:58 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1px4tm-0008Rg-01;
	Thu, 11 May 2023 11:55:57 +0000
Date: Thu, 11 May 2023 13:53:53 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH 1/8] net: phy: realtek: rtl8221: allow to configure
 SERDES mode
Message-ID: <ZFzXPGeob0q4DTza@pidgin.makrotopia.org>
References: <cover.1683756691.git.daniel@makrotopia.org>
 <302d982c5550f10d589735fc2e46cf27386c39f4.1683756691.git.daniel@makrotopia.org>
 <81c3f04d-ec48-4ac0-ac16-b69dc6ae72e0@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81c3f04d-ec48-4ac0-ac16-b69dc6ae72e0@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 02:41:07AM +0200, Andrew Lunn wrote:
> > +#define RTL8221B_MMD_SERDES_CTRL		MDIO_MMD_VEND1
> > +#define RTL8221B_MMD_PHY_CTRL			MDIO_MMD_VEND2
> 
> I suggest you don't do this. Use MDIO_MMD_VEND[1|2] to make it clear
> these are vendor registers.

Ack, I will not introduce new macros to label them, but just use
MDIO_MMD_VEND1 and MDIO_MMD_VEND2 then.

> 
> > +	case RTL8221B_SERDES_OPTION_MODE_2500BASEX_SGMII:
> > +	case RTL8221B_SERDES_OPTION_MODE_2500BASEX:
> > +		phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x6a04, 0x0503);
> > +		phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x6f10, 0xd455);
> > +		phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x6f11, 0x8020);
> > +		break;
> > +	case RTL8221B_SERDES_OPTION_MODE_HISGMII_SGMII:
> > +	case RTL8221B_SERDES_OPTION_MODE_HISGMII:
> > +		phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x6a04, 0x0503);
> > +		phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x6f10, 0xd433);
> > +		phy_write_mmd(phydev, RTL8221B_MMD_SERDES_CTRL, 0x6f11, 0x8020);
> > +		break;
> > +	}
> 
> Is there anything in the datasheet to indicate register names and what
> the values mean? It would be good to replace these magic values with
> #defines.

Unfortunately they are only mentioned as magic values which have to be
written to magic registers also in the datasheet :(


