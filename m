Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D2618BDA5
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgCSRKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:10:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45678 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbgCSRKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 13:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=97QUluO/9z2nRz1LUzTzwjEEpdtKGGADgdrtcJm2fOA=; b=rMIndAv4X0iMvZD54MRmU04cL9
        wigGi4hw8VKxK79UiAvPzUG36qw6+8iJqWdy2A4J1EHH/w4iRt2r1IjxGpuXKZdzkVqyLQn1c4PAF
        FjjmDNkrmn83p2tyiVYaTzWNLYOOPKKOiXvttuCjz4ApHuebPULjbbmMM8A5rUvgbYn4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jEygV-000893-QN; Thu, 19 Mar 2020 18:10:19 +0100
Date:   Thu, 19 Mar 2020 18:10:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Dejin Zheng <zhengdejin5@gmail.com>, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, tglx@linutronix.de,
        broonie@kernel.org, corbet@lwn.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] net: phy: introduce
 phy_read_mmd_poll_timeout macro
Message-ID: <20200319171019.GJ27807@lunn.ch>
References: <20200319163910.14733-1-zhengdejin5@gmail.com>
 <20200319163910.14733-4-zhengdejin5@gmail.com>
 <c88c0ce1-af42-db67-22bc-92e82bd9efbf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c88c0ce1-af42-db67-22bc-92e82bd9efbf@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 05:56:39PM +0100, Heiner Kallweit wrote:
> On 19.03.2020 17:39, Dejin Zheng wrote:
> > it is sometimes necessary to poll a phy register by phy_read_mmd()
> > function until its value satisfies some condition. introduce
> > phy_read_mmd_poll_timeout() macros that do this.
> > 
> > Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> > ---
> >  include/linux/phy.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 36d9dea04016..a30e9008647f 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -24,6 +24,7 @@
> >  #include <linux/mod_devicetable.h>
> >  #include <linux/u64_stats_sync.h>
> >  #include <linux/irqreturn.h>
> > +#include <linux/iopoll.h>
> >  
> >  #include <linux/atomic.h>
> >  
> > @@ -784,6 +785,9 @@ static inline int __phy_modify_changed(struct phy_device *phydev, u32 regnum,
> >   */
> >  int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
> >  
> > +#define phy_read_mmd_poll_timeout(val, cond, sleep_us, timeout_us, args...) \
> > +	read_poll_timeout(phy_read_mmd, val, cond, sleep_us, timeout_us, args)
> > +
> >  /**
> >   * __phy_read_mmd - Convenience function for reading a register
> >   * from an MMD on a given PHY.
> > 
> I'm not fully convinced. Usage of the new macro with its lots of
> parameters makes the code quite hard to read. Therefore I'm also
> not a big fan of readx_poll_timeout.

One issue is that people often implement polling wrong. They don't
take into account where extra delays can happen, and return -ETIMEOUT
when in fact the operation was successful. readx_poll_timeout gives us
a core which is known to be good.

What i don't like here is phy_read_mmd_poll_timeout() takes args... We
know it should be passed a phydev, and device address and a reg. I
would prefer these to be explicit parameters. We can then get the
compiler to check the correct number of parameters are passed.

      Andrew
