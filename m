Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BDE190D5A
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgCXMZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:25:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54166 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbgCXMZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 08:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=frYvSxVVyxhRF8P9ql5UtqwqlnhxPhI595pMmbY74tg=; b=VvPjB+Gp8kHT2LoLc8BG56K+9d
        zOdvYBa4d8I55ut4ae/ggJLHkpgTM7JwICaj54ufsSo9qz1FfWBcNuHpP/uPfrCwZaFJS6YVYJ4aX
        t3CAcFZ5Xkzvq83AOx8h4MLVeYk2Abs9LsHDvKN/lK4mhM4kKBpcCk0uRKw7y8IyM8wY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGicz-0001Vl-H0; Tue, 24 Mar 2020 13:25:53 +0100
Date:   Tue, 24 Mar 2020 13:25:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 07/14] net: ks8851: Use 16-bit writes to program MAC
 address
Message-ID: <20200324122553.GS3819@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-8-marex@denx.de>
 <20200324081311.ww6p7dmijbddi5jm@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324081311.ww6p7dmijbddi5jm@wunner.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 09:13:11AM +0100, Lukas Wunner wrote:
> On Tue, Mar 24, 2020 at 12:42:56AM +0100, Marek Vasut wrote:
> > On the SPI variant of KS8851, the MAC address can be programmed with
> > either 8/16/32-bit writes. To make it easier to support the 16-bit
> > parallel option of KS8851 too, switch both the MAC address programming
> > and readout to 16-bit operations.
> [...]
> >  static int ks8851_write_mac_addr(struct net_device *dev)
> >  {
> >  	struct ks8851_net *ks = netdev_priv(dev);
> > +	u16 val;
> >  	int i;
> >  
> >  	mutex_lock(&ks->lock);
> > @@ -358,8 +329,12 @@ static int ks8851_write_mac_addr(struct net_device *dev)
> >  	 * the first write to the MAC address does not take effect.
> >  	 */
> >  	ks8851_set_powermode(ks, PMECR_PM_NORMAL);
> > -	for (i = 0; i < ETH_ALEN; i++)
> > -		ks8851_wrreg8(ks, KS_MAR(i), dev->dev_addr[i]);
> > +
> > +	for (i = 0; i < ETH_ALEN; i += 2) {
> > +		val = (dev->dev_addr[i] << 8) | dev->dev_addr[i + 1];
> > +		ks8851_wrreg16(ks, KS_MAR(i + 1), val);
> > +	}
> > +
> 
> This looks like it won't work on little-endian machines:  The MAC bytes
> are stored in dev->dev_addr as 012345, but in the EEPROM they're stored
> as 543210.  The first 16-bit value that you write is 10 on big-endian
> and 01 on little-endian if I'm not mistaken.
> 
> By only writing 8-bit values, the original author elegantly sidestepped
> this issue.
> 
> Maybe the simplest and most readable solution is something like:
> 
>       u8 val[2];
>       ...
>       val[0] = dev->dev_addr[i+1];
>       val[1] = dev->dev_addr;
> 
> Then cast val to a u16 when passing it to ks8851_wrreg16().
> 
> Alternatively, use cpu_to_be16().

Hi Lukas

There is a cpu_to_be16() inside ks8851_wrreg16(). Something i already
checked, because i wondered about endianess issues as well.

	 Andrew
