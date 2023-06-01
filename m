Return-Path: <netdev+bounces-7230-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4389071F26D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:53:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3E2C2818C5
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:53:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2513B1D2D5;
	Thu,  1 Jun 2023 18:53:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B6F6FBA
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:53:02 +0000 (UTC)
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEE2137;
	Thu,  1 Jun 2023 11:53:01 -0700 (PDT)
Received: from arisu.localnet (unknown [23.233.251.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: detlev)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id 621166606ECA;
	Thu,  1 Jun 2023 19:52:58 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1685645579;
	bh=HA9WLCD2ceWYBo2r9YOQjN+RA/kPiPSlzAQ3oEd40Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pha/7fjJpKB9OGSkoq37gQXG8fTg0POKJKClZoPz6/0RvQPywX/k9YoOC1WxRQ2uM
	 jxn1n8rbEfdEkLFpBxbueb+GArIjeL+pork23RNdJtHJzfM8FGpEATYAi+lORycX8b
	 nSqnE8RIyYATLyDAH8xCXBzmxJi/9P3sL6kuodZu4zD0gsBHpZUPcbcdhJwDfG3WnV
	 D4Mu9HHJZxIkU8Aya0Yyf1X3wVbSBhWGxsDp14Bj2OMQMHLBToXqedhZN58Appkh1w
	 7KwYMdgfpVVShy200svEQTO1RbeoRePQALXfUjbPSvhoYuGBLOa5Kltp6z0mTUzhoZ
	 BgwUDiBPdbYWA==
From: Detlev Casanova <detlev.casanova@collabora.com>
To: linux-kernel@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] net: phy: realtek: Add optional external PHY clock
Date: Thu, 01 Jun 2023 14:53:02 -0400
Message-ID: <5682492.DvuYhMxLoT@arisu>
In-Reply-To: <4a6c413c-8791-fd00-a73e-7a12413693e3@gmail.com>
References:
 <20230531150340.522994-1-detlev.casanova@collabora.com>
 <20230531150340.522994-2-detlev.casanova@collabora.com>
 <4a6c413c-8791-fd00-a73e-7a12413693e3@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wednesday, May 31, 2023 3:08:53 P.M. EDT Heiner Kallweit wrote:
> On 31.05.2023 17:03, Detlev Casanova wrote:
> > In some cases, the PHY can use an external clock source instead of a
> > crystal.
> > 
> > Add an optional clock in the phy node to make sure that the clock source
> > is enabled, if specified, before probing.
> > 
> > Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
> > ---
> > 
> >  drivers/net/phy/realtek.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> > index 3d99fd6664d7..70c75dbbf799 100644
> > --- a/drivers/net/phy/realtek.c
> > +++ b/drivers/net/phy/realtek.c
> > @@ -12,6 +12,7 @@
> > 
> >  #include <linux/phy.h>
> >  #include <linux/module.h>
> >  #include <linux/delay.h>
> > 
> > +#include <linux/clk.h>
> > 
> >  #define RTL821x_PHYSR				0x11
> >  #define RTL821x_PHYSR_DUPLEX			BIT(13)
> > 
> > @@ -80,6 +81,7 @@ struct rtl821x_priv {
> > 
> >  	u16 phycr1;
> >  	u16 phycr2;
> >  	bool has_phycr2;
> > 
> > +	struct clk *clk;
> > 
> >  };
> >  
> >  static int rtl821x_read_page(struct phy_device *phydev)
> > 
> > @@ -103,6 +105,11 @@ static int rtl821x_probe(struct phy_device *phydev)
> > 
> >  	if (!priv)
> >  	
> >  		return -ENOMEM;
> > 
> > +	priv->clk = devm_clk_get_optional_enabled(dev, "xtal");
> 
> Why add priv->clk if it isn't used outside probe()?
> 
> How about suspend/resume? Would it make sense to stop the clock
> whilst PHY is suspended?

I'm not sure about this. Isn't the clock still necessary when suspended for 
things like wake on lan ?

> > +	if (IS_ERR(priv->clk))
> > +		return dev_err_probe(dev, PTR_ERR(priv->clk),
> > +				     "failed to get phy xtal 
clock\n");
> > +
> > 
> >  	ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR1);
> >  	if (ret < 0)
> >  	
> >  		return ret;





