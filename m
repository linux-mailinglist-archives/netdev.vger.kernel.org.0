Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FA1756C0
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfGYSUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:20:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38128 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfGYSUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 14:20:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4+kD9nsMIPmColepeh7zLKLcAilm/RcDJfRW/+3wacE=; b=FR/DOkS2FfK2/jxlsBSn9Lw0C4
        lVtvivDE91xm7gWeRlyUw9jSmWVfNRoLYS9VeZNfdYWLuR5MJ4Bpsgk/jOsEaNTGsnV2Xwkk86i27
        KjIU18kXYLvX9M0P3LKdGoJvrLzqJ6PMaT6yH50uvBbsmToyG9PYIUStdYn4/SRPkWJU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqiLt-0008Ac-SL; Thu, 25 Jul 2019 20:20:29 +0200
Date:   Thu, 25 Jul 2019 20:20:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergej Benilov <sergej.benilov@googlemail.com>
Cc:     venza@brownhat.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sis900: add support for ethtool --eeprom-dump
Message-ID: <20190725182029.GK21952@lunn.ch>
References: <20190725161809.14650-1-sergej.benilov@googlemail.com>
 <20190725162543.GJ21952@lunn.ch>
 <CAC9-QvATLW0uCzGpeY1kLXs5BBsfNBF_BKCnCz+38_f+STJhog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC9-QvATLW0uCzGpeY1kLXs5BBsfNBF_BKCnCz+38_f+STJhog@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 06:41:41PM +0200, Sergej Benilov wrote:
> On Thu, 25 Jul 2019 at 18:25, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > +static int sis900_read_eeprom(struct net_device *net_dev, u8 *buf)
> > > +{
> > > +     struct sis900_private *sis_priv = netdev_priv(net_dev);
> > > +     void __iomem *ioaddr = sis_priv->ioaddr;
> > > +     int wait, ret = -EAGAIN;
> > > +     u16 signature;
> > > +     u16 *ebuf = (u16 *)buf;
> > > +     int i;
> > > +
> > > +     if (sis_priv->chipset_rev == SIS96x_900_REV) {
> > > +             sw32(mear, EEREQ);
> > > +             for (wait = 0; wait < 2000; wait++) {
> > > +                     if (sr32(mear) & EEGNT) {
> > > +                             /* read 16 bits, and index by 16 bits */
> > > +                             for (i = 0; i < sis_priv->eeprom_size / 2; i++)
> > > +                                     ebuf[i] = (u16)read_eeprom(ioaddr, i);
> > > +                     ret = 0;
> > > +                     break;
> > > +                     }
> > > +             udelay(1);
> > > +             }
> > > +     sw32(mear, EEDONE);
> >
> > The indentation looks all messed up here.
> 
> This has passed ./scripts/checkpatch.pl, as you had suggested for the
> previous patch.

checkpatch just checks for things like tabs vs space. 

I would expect the indentation to be more like:


     	if (sis_priv->chipset_rev == SIS96x_900_REV) {
             	sw32(mear, EEREQ);
		for (wait = 0; wait < 2000; wait++) {
			if (sr32(mear) & EEGNT) {
				/* read 16 bits, and index by 16 bits */
				for (i = 0; i < sis_priv->eeprom_size / 2; i++)
					ebuf[i] = (u16)read_eeprom(ioaddr, i);
				ret = 0;
				break;
			}
			udelay(1);
		}
		sw32(mear, EEDONE);
	} else {
		signature = (u16)read_eeprom(ioaddr, EEPROMSignature);
		if (signature != 0xffff && signature != 0x0000) {
			/* read 16 bits, and index by 16 bits */
			for (i = 0; i < sis_priv->eeprom_size / 2; i++)
				ebuf[i] = (u16)read_eeprom(ioaddr, i);
			ret = 0;
		}
	}
	return ret;

> > Why do you not put the data directly into data and avoid this memory
> > allocation, and memcpy?
> 
> Because EEPROM data from 'eeprom->offset' offset and of 'eeprom->len'
> length only is expected to be returned in 'data'.

O.K.

	Andrew
