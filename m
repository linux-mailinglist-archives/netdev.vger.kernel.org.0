Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA6733088
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbfFCNEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:04:38 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44207 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbfFCNEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 09:04:31 -0400
Received: by mail-ed1-f68.google.com with SMTP id b8so26803574edm.11
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 06:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YSEQvhcJiqvXPcO/DL7FTegihCcgYM1wveVk+hHSwNE=;
        b=ltc6ZP4NzqFg0utfQy22+52hm5NxcReYV9nXKsxICw8L7wwz9PJQmGACgKyK4VYg0m
         Zz7C8cb3uLKpxXWsQnmyH5H6zFDdi5gosWJwozkuNS88Ll2OIWLhzgJzglDaIn6tNQIH
         K4p0KUVKAx023MgQ/Isb6G8YqoYFBFo0+I4DLYswgDq/E9BeXKzGrQ19qjpamlsdVjXg
         FdotMVmMDX4cLDFv5X1v8iY8t/D6aOEfjlzmQuXvy+jvmlvHUKmH5C8Unp43eqwOut96
         Z0kdc9KwYj8217rzjAuPgfUsOQUBIPRRtFS8Gj4kN50lKpI1Ag/VPt3N+2T4Wed8qgiY
         /53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YSEQvhcJiqvXPcO/DL7FTegihCcgYM1wveVk+hHSwNE=;
        b=Z7/c24ulAr3KMsRnQFsSxlW70+TwuMG2ngL8sX15yD58KCJyswqtl42I+dXHsG2Iul
         GPJlsrG7roVaRdYQo3dqGp8SBRJMQj1+PFs6GG6G7IL25PnmE1M/Eu9t9DPBgTTAZSXP
         fnoWklnecZFJiVc4aCaT7gYZ8Xe6DBbDHGrt/uNJCsTt/MafvdxLgMix1dgFMN0lno0D
         rxrtQXTljObiYOemuWh34Dx37S0LfdzAEX+HXFWo2x55PmJ2soSXHpWRmY+K+Z7KqTRn
         XrkEuUkyQqyk3MGvTiN5ESQzEM2HFePvhH6sx2/0HMGxwJ/PIL7fCKNSbeoLrjAmslNE
         LPJg==
X-Gm-Message-State: APjAAAUYOacehZT7m4mRLxY/BBpdyhaTxtSYWzfgobHIDwXxqocE9OlD
        pLs3HfMDIQOUgDKtYd912HpeUaWdBR2xR8jHwSU2jH0f61w=
X-Google-Smtp-Source: APXvYqylLrNunFkUy9ZhmF49tzZLEXY1tbTGnT4FEP3RTCNb5AenwSC1ieHuVQ+Lh+STLcWYr4JIOxRW+9Vf7Kp3R5Y=
X-Received: by 2002:a17:906:f8f:: with SMTP id q15mr18182230ejj.47.1559567069880;
 Mon, 03 Jun 2019 06:04:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190602233137.17930-1-olteanv@gmail.com> <20190602233137.17930-2-olteanv@gmail.com>
 <20190603005053.GH19081@lunn.ch>
In-Reply-To: <20190603005053.GH19081@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 3 Jun 2019 16:04:18 +0300
Message-ID: <CA+h21hoaOLassrEjHGoOortesCBkTUamCw8Efoc=vobwgwH25w@mail.gmail.com>
Subject: Re: [PATCH v2 net 1/1] net: dsa: sja1105: Fix link speed not working
 at 100 Mbps and below
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 at 03:50, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Jun 03, 2019 at 02:31:37AM +0300, Vladimir Oltean wrote:
> > The hardware values for link speed are held in the sja1105_speed_t enum.
> > However they do not increase in the order that sja1105_get_speed_cfg was
> > iterating over them (basically from SJA1105_SPEED_AUTO - 0 - to
> > SJA1105_SPEED_1000MBPS - 1 - skipping the other two).
> >
> > Another bug is that the code in sja1105_adjust_port_config relies on the
> > fact that an invalid link speed is detected by sja1105_get_speed_cfg and
> > returned as -EINVAL.  However storing this into an enum that only has
> > positive members will cast it into an unsigned value, and it will miss
> > the negative check.
> >
> > So take the simplest approach and remove the sja1105_get_speed_cfg
> > function and replace it with a simple switch-case statement.
> >
> > Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > Suggested-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  drivers/net/dsa/sja1105/sja1105_main.c | 32 +++++++++++++-------------
> >  1 file changed, 16 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> > index 5412c3551bcc..25bb64ce0432 100644
> > --- a/drivers/net/dsa/sja1105/sja1105_main.c
> > +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> > @@ -710,16 +710,6 @@ static int sja1105_speed[] = {
> >       [SJA1105_SPEED_1000MBPS] = 1000,
> >  };
> >
> > -static sja1105_speed_t sja1105_get_speed_cfg(unsigned int speed_mbps)
> > -{
> > -     int i;
> > -
> > -     for (i = SJA1105_SPEED_AUTO; i <= SJA1105_SPEED_1000MBPS; i++)
> > -             if (sja1105_speed[i] == speed_mbps)
> > -                     return i;
> > -     return -EINVAL;
> > -}
> > -
> >  /* Set link speed and enable/disable traffic I/O in the MAC configuration
> >   * for a specific port.
> >   *
> > @@ -742,8 +732,21 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
> >       mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
> >       mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
> >
> > -     speed = sja1105_get_speed_cfg(speed_mbps);
> > -     if (speed_mbps && speed < 0) {
> > +     switch (speed_mbps) {
> > +     case 0:
> > +             /* No speed update requested */
> > +             speed = SJA1105_SPEED_AUTO;
> > +             break;
> > +     case 10:
> > +             speed = SJA1105_SPEED_10MBPS;
> > +             break;
> > +     case 100:
> > +             speed = SJA1105_SPEED_100MBPS;
> > +             break;
> > +     case 1000:
> > +             speed = SJA1105_SPEED_1000MBPS;
> > +             break;
> > +     default:
> >               dev_err(dev, "Invalid speed %iMbps\n", speed_mbps);
> >               return -EINVAL;
> >       }
>
> Thanks for the re-write. This looks more obviously correct. One minor
> nit-pick. We have SPEED_10, SPEED_100, SPEED_1000, etc. It would be
> good to use them.
>
> With that change
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>     Andrew

Hi Andrew,

If I made the change you're suggesting, I would need to replace 0 with
SPEED_UNKNOWN and thus I would conflict with this net-next change:

https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=af7cd0366ee994e8b35985d407261dc0ed9dfb4d

I think it's simpler to wait until Dave merges net into net-next and
then submit this 1000 -> SPEED_1000 change as a net-next one, and let
the fix itself go into net.
Sounds ok?

Regards,
-Vladimir
