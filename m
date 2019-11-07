Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36450F231F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 01:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbfKGAMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 19:12:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbfKGAMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 19:12:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SZ/Wa34Obda2hcWDUEg4xGvmFj4GyZq950hL3q7kmvs=; b=0Ay8yngZ3btVzjDFakv87jLOch
        Eo4UpGEf82WA5e1OHyzP7daIArOewfB7PayoAiYzkRoSuBvwX/VgQ7QL+IToNpOB/Zv3F2asmKPZL
        dtb7HXHkj1kzZX853v+iK8g2nW6qYuKwMyo1KU8GpoqnQ38EdsBd87+kljq4aPg5ymXE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSVPl-0002Ho-NB; Thu, 07 Nov 2019 01:12:41 +0100
Date:   Thu, 7 Nov 2019 01:12:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, jiri@mellanox.com
Subject: Re: [PATCH net-next 3/5] net: dsa: mv88e6xxx: global2: Expose ATU
 stats register
Message-ID: <20191107001241.GA8003@lunn.ch>
References: <20191105001301.27966-1-andrew@lunn.ch>
 <20191105001301.27966-4-andrew@lunn.ch>
 <20191105233241.GB799546@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105233241.GB799546@t480s.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
> > +{
> > +	int err;
> > +	u16 val;
> > +
> > +	err = mv88e6xxx_g2_read(chip, MV88E6XXX_G2_ATU_STATS, &val);
> > +	if (err)
> > +		return err;
> > +
> > +	return val & MV88E6XXX_G2_ATU_STATS_MASK;
> > +}
> 
> I would use the logic commonly used in the mv88e6xxx driver for
> functions that may fail, returning only an error code and taking a
> pointer to the correct type as argument, so that we do as usual:
> 
>     err = mv88e6xxx_g2_atu_stats_get(chip, &val);
>     if (err)
>         return err;

Well, actually. Take a look at the next patch. This function gets
changed there. After you reviewed the first devlink patchset adding
control of the ATU algorithm, i went through this patchset and applied
the same comments to it. So i change the implementation to how you
actually wanted it. But i messed up my git commands and that changed
ended up in the next patch :-(

> >  /* Offset 0x0E: ATU Stats Register */
> > -#define MV88E6XXX_G2_ATU_STATS		0x0e
> > +#define MV88E6XXX_G2_ATU_STATS				0x0e
> > +#define MV88E6XXX_G2_ATU_STATS_BIN_0			(0x0 << 14)
> > +#define MV88E6XXX_G2_ATU_STATS_BIN_1			(0x1 << 14)
> > +#define MV88E6XXX_G2_ATU_STATS_BIN_2			(0x2 << 14)
> > +#define MV88E6XXX_G2_ATU_STATS_BIN_3			(0x3 << 14)
> > +#define MV88E6XXX_G2_ATU_STATS_MODE_ALL			(0x0 << 12)
> > +#define MV88E6XXX_G2_ATU_STATS_MODE_ALL_DYNAMIC		(0x1 << 12)
> > +#define MV88E6XXX_G2_ATU_STATS_MODE_FID_ALL		(0x2 << 12)
> > +#define MV88E6XXX_G2_ATU_STATS_MODE_FID_ALL_DYNAMIC	(0x3 << 12)
> > +#define MV88E6XXX_G2_ATU_STATS_MASK			0x0fff
> 
> Please use the 0x1234 format for these 16-bit registers.

Ug, no. That is a lot less readable. The datasheet describes there
fields in terms of bit offsets in the registers. Bit 14 and 15 for the
bin, bits 12 and 13 for the mode. You can clearly see that when using
value and shift representation. 0x0200 is much harder to read, and
much more error prone.

      Andrew
