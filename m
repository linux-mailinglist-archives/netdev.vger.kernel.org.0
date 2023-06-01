Return-Path: <netdev+bounces-7229-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AD9871F259
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2A1F2818FB
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E822F19E55;
	Thu,  1 Jun 2023 18:48:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D438723DF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:48:58 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1C718D;
	Thu,  1 Jun 2023 11:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=bHdmnR1Xzli1omfGwEoz5opBryIwcSOFGIV2/hia/f0=; b=Xj
	v90ww/C1HE3NKJDoyJpYVZ38/0NS0131d81z0uGkR2BYA4jQ0YHwR+b32P+Jw7CR/vgMk+bhCosbF
	vxap1wKiltEir3iYsSyn4+IHwgII+6jzdCxKswz9BMO1D2Eu5OsdyqAkfSORFQtsT73aVDD+k+K/T
	xvQa7naKxvwK31o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q4nLx-00EbD4-SR; Thu, 01 Jun 2023 20:48:53 +0200
Date: Thu, 1 Jun 2023 20:48:53 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Justin Chen <justin.chen@broadcom.com>,
	Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	bcm-kernel-feedback-list@broadcom.com,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Yuiko Oshino <yuiko.oshino@microchip.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Steen Hegelund <steen.hegelund@microchip.com>,
	Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: Re: [PATCH net-next] ethtool: ioctl: improve error checking for
 set_wol
Message-ID: <312c1067-aab6-4f04-b18e-ba1b7a0d1427@lunn.ch>
References: <1685566429-2869-1-git-send-email-justin.chen@broadcom.com>
 <ZHi/aT6vxpdOryD8@corigine.com>
 <e7e49753-3ad6-9e03-44ff-945e66fca9a3@broadcom.com>
 <eda87740-669c-a6e1-9c71-a9a92d3b173a@broadcom.com>
 <e3065103-d38c-1b80-5b61-71e8ba017e71@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e3065103-d38c-1b80-5b61-71e8ba017e71@broadcom.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > > I was planning to for the Broadcom drivers since those I can test.
> > > But I could do it across the board if that is preferred.
> > > 
> > > > > Signed-off-by: Justin Chen <justin.chen@broadcom.com>
> > > > > ---
> > > > >   net/ethtool/ioctl.c | 14 ++++++++++++--
> > > > >   1 file changed, 12 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> > > > > index 6bb778e10461..80f456f83db0 100644
> > > > > --- a/net/ethtool/ioctl.c
> > > > > +++ b/net/ethtool/ioctl.c
> > > > > @@ -1436,15 +1436,25 @@ static int ethtool_get_wol(struct
> > > > > net_device *dev, char __user *useraddr)
> > > > >   static int ethtool_set_wol(struct net_device *dev, char
> > > > > __user *useraddr)
> > > > >   {
> > > > > -    struct ethtool_wolinfo wol;
> > > > > +    struct ethtool_wolinfo wol, cur_wol;
> > > > >       int ret;
> > > > > -    if (!dev->ethtool_ops->set_wol)
> > > > > +    if (!dev->ethtool_ops->get_wol || !dev->ethtool_ops->set_wol)
> > > > >           return -EOPNOTSUPP;
> > > > 
> > > > Are there cases where (in-tree) drivers provide set_wol byt not get_wol?
> > > > If so, does this break their set_wol support?
> > > > 
> > > 
> > > My original thought was to match netlink set wol behavior. So
> > > drivers that do that won't work with netlink set_wol right now. I'll
> > > skim around to see if any drivers do this. But I would reckon this
> > > should be a driver fix.
> > > 
> > > Thanks,
> > > Justin
> > > 
> > 
> > I see a driver at drivers/net/phy/microchip.c. But this is a phy driver
> > set_wol hook.
> 
> That part of the driver appears to be dead code. It attempts to pretend to
> support Wake-on-LAN, but it does not do any specific programming of wake-up
> filters, nor does it implement get_wol. It also does not make use of the
> recently introduced PHY_ALWAYS_CALL_SUSPEND flag.
> 
> When it is time to determine whether to suspend the PHY or not, eventually
> phy_suspend() will call phy_ethtool_get_wol(). Since no get_wol is
> implemented, the wol.wolopts will remain zero, therefore we will just
> suspend the PHY.
> 
> I suspect this was added to work around MAC drivers that may forcefully try
> to suspend the PHY, but that should not even be possible these days.
> 
> I would just remove that logic from microchip.c entirely.

The Microchip developers are reasonably responsive. So we should Cc:
them.

	Andrew

