Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 057EC92841
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 17:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfHSPUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 11:20:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41964 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbfHSPUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 11:20:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FglvKdYflwHGEdk4d8dGaweWbY0hhNgRWjnewKDUOKg=; b=eNGzTOpsGdWobetWhb0aPBlyGe
        BdtlMRUhiboott+QwHFBcA/I/29fo8w4afC6qAaJRYRG45tysahIlmRF52OEdG038mGA1bwxQBHPH
        XxNRqYavuclniIbXfUvWYNKlyiVoqINLJNitlBbK1wdHVfbmdBIjvE5LjkFfz/oMsmOU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hzjSX-00074n-WC; Mon, 19 Aug 2019 17:20:37 +0200
Date:   Mon, 19 Aug 2019 17:20:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: extend PTP gettime
 function to read system clock
Message-ID: <20190819152037.GH15291@lunn.ch>
References: <20190816163157.25314-1-h.feurstein@gmail.com>
 <20190816163157.25314-3-h.feurstein@gmail.com>
 <20190819132733.GE8981@lunn.ch>
 <20190819111639.GB6123@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819111639.GB6123@t480s.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 11:16:39AM -0400, Vivien Didelot wrote:
> On Mon, 19 Aug 2019 15:27:33 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > > @@ -45,7 +45,8 @@ static int mv88e6xxx_smi_direct_write(struct mv88e6xxx_chip *chip,
> > >  {
> > >  	int ret;
> > >  
> > > -	ret = mdiobus_write_nested(chip->bus, dev, reg, data);
> > > +	ret = mdiobus_write_sts_nested(chip->bus, dev, reg, data,
> > > +				       chip->ptp_sts);
> > >  	if (ret < 0)
> > >  		return ret;
> > >  
> > 
> > Please also make a similar change to mv88e6xxx_smi_indirect_write().
> > The last write in that function should be timestamped.
> > 
> > Vivien, please could you think about these changes with respect to
> > RMU. We probably want to skip the RMU in this case, so we get slow but
> > uniform jitter, vs fast and unpredictable jitter from using the RMU.
> 
> The RMU will have its own mv88e6xxx_bus_ops.

Yes, that is what i was expecting. But for this operation, triggering
a PTP timestamp, we probably want it to fall back to MDIO, which is
much more deterministic.

     Andrew
