Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F9615AE98
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 18:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgBLRTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 12:19:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbgBLRTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 12:19:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rkM9QGmsqKaUtiT8wCi5xafHwiZcklUGCeleqBo8SCM=; b=TF3BD4Z07Dig+7/BleThInvxyJ
        s+g7cYYr9Gij0deR+kCx/edpUOEv05/YEwrkbMkEhnQKE+/E8wj7tKHjB+SriAnYi03a466Ay54RA
        3OhEWWx1/1F2QZ2wFlIR4GP37Jb30vq0xUFKw16FCn/2T0sDnWQN0UB/6059Hmi5ITds=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j1vfr-0006lH-0S; Wed, 12 Feb 2020 18:19:43 +0100
Date:   Wed, 12 Feb 2020 18:19:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, rrichter@marvell.com,
        linux-arm-kernel@lists.infradead.org,
        David Miller <davem@davemloft.net>, sgoutham@marvell.com
Subject: Re: [PATCH] net: thunderx: use proper interface type for RGMII
Message-ID: <20200212171942.GR19213@lunn.ch>
References: <1581108026-28170-1-git-send-email-tharvey@gateworks.com>
 <20200207210209.GD19213@lunn.ch>
 <CAJ+vNU0LV7EquWXfBKfYYLzagXiVHtvqMtx5hiM1zxXQWVgWrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU0LV7EquWXfBKfYYLzagXiVHtvqMtx5hiM1zxXQWVgWrA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 08:55:39AM -0800, Tim Harvey wrote:
> On Fri, Feb 7, 2020 at 1:02 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Fri, Feb 07, 2020 at 12:40:26PM -0800, Tim Harvey wrote:
> > > The configuration of the OCTEONTX XCV_DLL_CTL register via
> > > xcv_init_hw() is such that the RGMII RX delay is bypassed
> > > leaving the RGMII TX delay enabled in the MAC:
> > >
> > >       /* Configure DLL - enable or bypass
> > >        * TX no bypass, RX bypass
> > >        */
> > >       cfg = readq_relaxed(xcv->reg_base + XCV_DLL_CTL);
> > >       cfg &= ~0xFF03;
> > >       cfg |= CLKRX_BYP;
> > >       writeq_relaxed(cfg, xcv->reg_base + XCV_DLL_CTL);
> > >
> > > This would coorespond to a interface type of PHY_INTERFACE_MODE_RGMII_RXID
> > > and not PHY_INTERFACE_MODE_RGMII.
> > >
> > > Fixing this allows RGMII PHY drivers to do the right thing (enable
> > > RX delay in the PHY) instead of erroneously enabling both delays in the
> > > PHY.
> >
> > Hi Tim
> >
> > This seems correct. But how has it worked in the past? Does this
> > suggest there is PHY driver out there which is doing the wrong thing
> > when passed PHY_INTERFACE_MODE_RGMII?
> >
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> >
> 
> Andrew,
> 
> Yes, the DP83867 phy driver used on the Gateworks Newport boards would
> configure the delay in an incompatible way when enabled.

Hi Tim

So it was broken? Maybe find the appropriate Fixes tag, and have David
add it to stable?

    Andrew
