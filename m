Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B40876D5
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 12:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406209AbfHIKAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 06:00:46 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38873 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfHIKAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 06:00:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id m125so1036006wmm.3;
        Fri, 09 Aug 2019 03:00:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LCdSOwFwrhZScC72O9wronCj2Ku4lPGGJvmSIWng7Ms=;
        b=WMlY2/odH9qGgAJpKidendcn3iak2xV4QhOj79pGSLjRn5JpufASioUk7DCw6QPRfA
         hG0aYW1IoLkmanjdlxg8lYJmZWiecNJ9Rr4Zwgwoplud7OlebfCRLc+8/u8j0aZkMDqs
         KU2MRNSNwGC6KMscUx/3wmJn8r1CvAQ2+gDYIbKYzUuEBvDrr/lf8mQLc4p0ImBvzm/+
         vJshF2Q/mxigGU5LdKbMgqSD9lVlclE7jspbWjMSYfkFn4DQnzDyD2Cl9eHgD8gxxcQe
         xSdmfLZ0oCJ5naB6QAqwiQM9iPKSAEUc6EPplzRT2tPX4Hr1RNwV2sNkQRIWgd3+5e4P
         1k6g==
X-Gm-Message-State: APjAAAWOMtPeKR4g8Cc8fDTGpE7+pjTR/o3BE0GGYFKWUo8BBwnAS7tg
        tZjiBjsD1TSS3o8qGmFNhs4=
X-Google-Smtp-Source: APXvYqzGzhFouxT/8NZZD7GEWCvzyCO9KA8bYUP5Um9qrm5dBO/yvcaJBGmAkOPRvJT1N6u6g0PpFQ==
X-Received: by 2002:a1c:6a17:: with SMTP id f23mr9702686wmc.91.1565344844302;
        Fri, 09 Aug 2019 03:00:44 -0700 (PDT)
Received: from 1aq-andre ([77.107.218.170])
        by smtp.gmail.com with ESMTPSA id w23sm5060001wmi.45.2019.08.09.03.00.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 03:00:43 -0700 (PDT)
Message-ID: <14396bfacec0c4877cb0ea9009dc92b33c169cac.camel@andred.net>
Subject: Re: [PATCH] net: phy: at803x: stop switching phy delay config
 needlessly
From:   =?ISO-8859-1?Q?Andr=E9?= Draszik <git@andred.net>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     lkml <linux-kernel@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date:   Fri, 09 Aug 2019 11:00:05 +0100
In-Reply-To: <CA+h21hp-K0ryB39O4X9n-mCwapiXoWy5WP6ZsvswgcDy-WBYVw@mail.gmail.com>
References: <20190809005754.23009-1-git@andred.net>
         <CA+h21hp-K0ryB39O4X9n-mCwapiXoWy5WP6ZsvswgcDy-WBYVw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Fri, 2019-08-09 at 12:43 +0300, Vladimir Oltean wrote:
> Hi Andre,
> 
> On Fri, 9 Aug 2019 at 03:58, André Draszik <git@andred.net> wrote:
> > This driver does a funny dance disabling and re-enabling
> > RX and/or TX delays. In any of the RGMII-ID modes, it first
> > disables the delays, just to re-enable them again right
> > away. This looks like a needless exercise.
> > 
> > Just enable the respective delays when in any of the
> > relevant 'id' modes, and disable them otherwise.
> > 
> > Also, remove comments which don't add anything that can't be
> > seen by looking at the code.
> > 
> > Signed-off-by: André Draszik <git@andred.net>
> > CC: Andrew Lunn <andrew@lunn.ch>
> > CC: Florian Fainelli <f.fainelli@gmail.com>
> > CC: Heiner Kallweit <hkallweit1@gmail.com>
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: netdev@vger.kernel.org
> > ---
> 
> Is there any particular problem you're facing? Does this make any difference?

This is a clean-up, reducing the number of lines and if statements
by removing unnecessary code paths and comments.


Cheers,
Andre'


> 
> >  drivers/net/phy/at803x.c | 26 ++++++--------------------
> >  1 file changed, 6 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> > index 222ccd9ecfce..2ab51f552e92 100644
> > --- a/drivers/net/phy/at803x.c
> > +++ b/drivers/net/phy/at803x.c
> > @@ -257,35 +257,21 @@ static int at803x_config_init(struct phy_device *phydev)
> >          *   after HW reset: RX delay enabled and TX delay disabled
> >          *   after SW reset: RX delay enabled, while TX delay retains the
> >          *   value before reset.
> > -        *
> > -        * So let's first disable the RX and TX delays in PHY and enable
> > -        * them based on the mode selected (this also takes care of RGMII
> > -        * mode where we expect delays to be disabled)
> >          */
> > -
> > -       ret = at803x_disable_rx_delay(phydev);
> > -       if (ret < 0)
> > -               return ret;
> > -       ret = at803x_disable_tx_delay(phydev);
> > -       if (ret < 0)
> > -               return ret;
> > -
> >         if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> >             phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> > -               /* If RGMII_ID or RGMII_RXID are specified enable RX delay,
> > -                * otherwise keep it disabled
> > -                */
> >                 ret = at803x_enable_rx_delay(phydev);
> > -               if (ret < 0)
> > -                       return ret;
> > +       } else {
> > +               ret = at803x_disable_rx_delay(phydev);
> >         }
> > +       if (ret < 0)
> > +               return ret;
> > 
> >         if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> >             phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> > -               /* If RGMII_ID or RGMII_TXID are specified enable TX delay,
> > -                * otherwise keep it disabled
> > -                */
> >                 ret = at803x_enable_tx_delay(phydev);
> > +       } else {
> > +               ret = at803x_disable_tx_delay(phydev);
> >         }
> > 
> >         return ret;
> > --
> > 2.20.1
> > 
> 
> Regards,
> -Vladimir

