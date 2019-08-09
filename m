Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F24787846
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 13:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406442AbfHILPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 07:15:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43390 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfHILPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 07:15:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so23298395wru.10;
        Fri, 09 Aug 2019 04:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=f7SZv+Wbj8GBw6RwTzFLBb+PsmSWFpD6I1qGm7SqKno=;
        b=bfJg92ngFuSwz6qrrX4JERlHMz5w6TM1sZLijTBZn17I1PA2iLIoJc3u8FsBc2MkR4
         OVAax4ht1p1jxbgmHGte/5tUuT8VOfFpGQ2oQPaPhN7YPdtl+p89axsbZMqF/ZotTSPb
         IJnvWmQNaVf0Z07M1LC7VuhoH0Q2BH3EXBpdnFgmjcYatuN/O1zE8GOYebr0riB2hKJf
         wnDRL3S+PmcodtiZ1ND86LzJVrFowsnUd1YvdgZHKpZFX00sM2aTwFKWS5pJm95lXjxw
         2kktvDXoPox5hwq8P58BL2Mr7ArknY9JCaJ2KWbfpxNZWNzXgSU3c+wKZKs1k7KcSY3j
         ITEw==
X-Gm-Message-State: APjAAAWj1LoR22o6i9HMgTU+1HrQl74kOwSTrSCpbnTW9ngdkQyAackv
        /CNkLnHcX5Z7e3lbycToj+k=
X-Google-Smtp-Source: APXvYqwaOtYaAcKnLyntYwP21+dAI8rpyeraBtPOK0hM6QCNQ2QKzx0isksBE3jyOAutyNlrFpwwOA==
X-Received: by 2002:a5d:4083:: with SMTP id o3mr3703457wrp.150.1565349309306;
        Fri, 09 Aug 2019 04:15:09 -0700 (PDT)
Received: from 1aq-andre ([77.107.218.170])
        by smtp.gmail.com with ESMTPSA id a6sm5264780wmj.15.2019.08.09.04.15.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 04:15:08 -0700 (PDT)
Message-ID: <670000cb119a2396dee6ac346fa2a74886559b49.camel@andred.net>
Subject: Re: [PATCH] net: phy: at803x: stop switching phy delay config
 needlessly
From:   =?ISO-8859-1?Q?Andr=E9?= Draszik <git@andred.net>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     lkml <linux-kernel@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date:   Fri, 09 Aug 2019 12:15:07 +0100
In-Reply-To: <CA+h21hq69YyG3zcs2dzKJBNv-UwDPZ3ARQF9Y++9sLsvf472rg@mail.gmail.com>
References: <20190809005754.23009-1-git@andred.net>
         <CA+h21hp-K0ryB39O4X9n-mCwapiXoWy5WP6ZsvswgcDy-WBYVw@mail.gmail.com>
         <14396bfacec0c4877cb0ea9009dc92b33c169cac.camel@andred.net>
         <CA+h21hq69YyG3zcs2dzKJBNv-UwDPZ3ARQF9Y++9sLsvf472rg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2019-08-09 at 14:09 +0300, Vladimir Oltean wrote:
> Hi Andre,
> 
> On Fri, 9 Aug 2019 at 13:00, André Draszik <git@andred.net> wrote:
> > Hi Vladimir,
> > 
> > On Fri, 2019-08-09 at 12:43 +0300, Vladimir Oltean wrote:
> > > Hi Andre,
> > > 
> > > On Fri, 9 Aug 2019 at 03:58, André Draszik <git@andred.net> wrote:
> > > > This driver does a funny dance disabling and re-enabling
> > > > RX and/or TX delays. In any of the RGMII-ID modes, it first
> > > > disables the delays, just to re-enable them again right
> > > > away. This looks like a needless exercise.
> > > > 
> > > > Just enable the respective delays when in any of the
> > > > relevant 'id' modes, and disable them otherwise.
> > > > 
> > > > Also, remove comments which don't add anything that can't be
> > > > seen by looking at the code.
> > > > 
> > > > Signed-off-by: André Draszik <git@andred.net>
> > > > CC: Andrew Lunn <andrew@lunn.ch>
> > > > CC: Florian Fainelli <f.fainelli@gmail.com>
> > > > CC: Heiner Kallweit <hkallweit1@gmail.com>
> > > > CC: "David S. Miller" <davem@davemloft.net>
> > > > CC: netdev@vger.kernel.org
> > > > ---
> > > 
> > > Is there any particular problem you're facing? Does this make any difference?
> > 
> > This is a clean-up, reducing the number of lines and if statements
> > by removing unnecessary code paths and comments.
> > 
> 
> Ok. Did checkpatch not complain about the braces which you left open
> around a single line?

It actually doesn't... Should I send a v2?


Cheers,
Andre'

> 
> > Cheers,
> > Andre'
> > 
> > 
> > > >  drivers/net/phy/at803x.c | 26 ++++++--------------------
> > > >  1 file changed, 6 insertions(+), 20 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> > > > index 222ccd9ecfce..2ab51f552e92 100644
> > > > --- a/drivers/net/phy/at803x.c
> > > > +++ b/drivers/net/phy/at803x.c
> > > > @@ -257,35 +257,21 @@ static int at803x_config_init(struct phy_device *phydev)
> > > >          *   after HW reset: RX delay enabled and TX delay disabled
> > > >          *   after SW reset: RX delay enabled, while TX delay retains the
> > > >          *   value before reset.
> > > > -        *
> > > > -        * So let's first disable the RX and TX delays in PHY and enable
> > > > -        * them based on the mode selected (this also takes care of RGMII
> > > > -        * mode where we expect delays to be disabled)
> > > >          */
> > > > -
> > > > -       ret = at803x_disable_rx_delay(phydev);
> > > > -       if (ret < 0)
> > > > -               return ret;
> > > > -       ret = at803x_disable_tx_delay(phydev);
> > > > -       if (ret < 0)
> > > > -               return ret;
> > > > -
> > > >         if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > > >             phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> > > > -               /* If RGMII_ID or RGMII_RXID are specified enable RX delay,
> > > > -                * otherwise keep it disabled
> > > > -                */
> > > >                 ret = at803x_enable_rx_delay(phydev);
> > > > -               if (ret < 0)
> > > > -                       return ret;
> > > > +       } else {
> > > > +               ret = at803x_disable_rx_delay(phydev);
> > > >         }
> > > > +       if (ret < 0)
> > > > +               return ret;
> > > > 
> > > >         if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > > >             phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> > > > -               /* If RGMII_ID or RGMII_TXID are specified enable TX delay,
> > > > -                * otherwise keep it disabled
> > > > -                */
> > > >                 ret = at803x_enable_tx_delay(phydev);
> > > > +       } else {
> > > > +               ret = at803x_disable_tx_delay(phydev);
> > > >         }
> > > > 
> > > >         return ret;
> > > > --
> > > > 2.20.1
> > > > 
> > > 
> > > Regards,
> > > -Vladimir
> 
> Thanks,
> -Vladimir

