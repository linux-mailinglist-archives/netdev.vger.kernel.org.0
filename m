Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03C1775453
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 18:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390731AbfGYQl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 12:41:56 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34165 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390669AbfGYQly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 12:41:54 -0400
Received: by mail-lj1-f195.google.com with SMTP id p17so48656769ljg.1
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 09:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mC6vEXRd06MjrSqVkYbBiMA0HYRFyKd/iCZNBarYTrQ=;
        b=rHSiiBRsMr9Gn8XrU1QSWjJZCEJwrtH8UHMhSVuUsV0ex+H/4X+kVbbtAjZGocgUTi
         NdEQvP7XseMJ9wP6dK2tR+f0D3WolhK/YGp8oZcnyLtbEweb6HYXBX1V9rlmP0Ga4Hgd
         a2mw3DYN3VCo4aP3BOjk8ASp/CTV/JtWj8NhnqdMRvL16KLjHj3vFsXnI7wMKNTNeuKs
         NCNYHUPFm9yhq3ICPcGNUkEJ2FSuY4B71q9WPmVfh7iiKRtUGH+iEucnuEtwd/BQ637c
         7wwzksXzxe5bPiVIEv8UpzslYA49BcXkMXxCCI2fpmh+9sa1a8km8h5BrjyH7jecuvMR
         TYvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mC6vEXRd06MjrSqVkYbBiMA0HYRFyKd/iCZNBarYTrQ=;
        b=CypmMLJy3FdE0KWsPXjQyy/N+kTv+j+lScluoLAyOxxVt+GramqVGjz8SDuyxuumsA
         YrIwBthO4rg9T6pxn/H4GJzcitQ9Z85WxmzB6gtAhxlk8CR/+VKSdl55AnHHwazGb1rx
         UEQlHYfiaZGqkVu8nYqeY+Kb3PO+hOmJGxOH38NEzrGGa+YXeBdgL/IEmbU+PtmmbBj3
         DeOvchZGtQ53RQUMpQZgfazaZCWtGLBwIDMuq6MuMx1fyd3f75IdBFhHKHxhzlDFANX3
         oYTFYRoNFYCHFrVllI1YuS+RDgKNpP3LXv2zk0VMxcnjBN5Yq6EWUti4v8fZoeNsuZ9U
         Zzng==
X-Gm-Message-State: APjAAAWEWy1GOpXirC5Swn1Vm/hmXrZuqMDgnbJkO6tgQT40WlO9shcz
        gEMMK7PECoYx5auhMyHG47RMK8onTDJTe5VZxMQ=
X-Google-Smtp-Source: APXvYqzfVtRI76lTSKPVKcpaqHwusqOBIEMwAdU3wE5lYMro1Zfo7bNEEX5YY4mNcAmccPU6y+zDaA/hcq9q8/TESDA=
X-Received: by 2002:a2e:9c85:: with SMTP id x5mr18224396lji.139.1564072912248;
 Thu, 25 Jul 2019 09:41:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190725161809.14650-1-sergej.benilov@googlemail.com> <20190725162543.GJ21952@lunn.ch>
In-Reply-To: <20190725162543.GJ21952@lunn.ch>
From:   Sergej Benilov <sergej.benilov@googlemail.com>
Date:   Thu, 25 Jul 2019 18:41:41 +0200
Message-ID: <CAC9-QvATLW0uCzGpeY1kLXs5BBsfNBF_BKCnCz+38_f+STJhog@mail.gmail.com>
Subject: Re: [PATCH] sis900: add support for ethtool --eeprom-dump
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     venza@brownhat.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jul 2019 at 18:25, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +static int sis900_read_eeprom(struct net_device *net_dev, u8 *buf)
> > +{
> > +     struct sis900_private *sis_priv = netdev_priv(net_dev);
> > +     void __iomem *ioaddr = sis_priv->ioaddr;
> > +     int wait, ret = -EAGAIN;
> > +     u16 signature;
> > +     u16 *ebuf = (u16 *)buf;
> > +     int i;
> > +
> > +     if (sis_priv->chipset_rev == SIS96x_900_REV) {
> > +             sw32(mear, EEREQ);
> > +             for (wait = 0; wait < 2000; wait++) {
> > +                     if (sr32(mear) & EEGNT) {
> > +                             /* read 16 bits, and index by 16 bits */
> > +                             for (i = 0; i < sis_priv->eeprom_size / 2; i++)
> > +                                     ebuf[i] = (u16)read_eeprom(ioaddr, i);
> > +                     ret = 0;
> > +                     break;
> > +                     }
> > +             udelay(1);
> > +             }
> > +     sw32(mear, EEDONE);
>
> The indentation looks all messed up here.

This has passed ./scripts/checkpatch.pl, as you had suggested for the
previous patch.

>
> > +     } else {
> > +             signature = (u16)read_eeprom(ioaddr, EEPROMSignature);
> > +             if (signature != 0xffff && signature != 0x0000) {
> > +                     /* read 16 bits, and index by 16 bits */
> > +                     for (i = 0; i < sis_priv->eeprom_size / 2; i++)
> > +                             ebuf[i] = (u16)read_eeprom(ioaddr, i);
> > +                     ret = 0;
> > +             }
> > +     }
> > +     return ret;
> > +}
> > +
> > +#define SIS900_EEPROM_MAGIC  0xBABE
> > +static int sis900_get_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom, u8 *data)
> > +{
> > +     struct sis900_private *sis_priv = netdev_priv(dev);
> > +     u8 *eebuf;
> > +     int res;
> > +
> > +     eebuf = kmalloc(sis_priv->eeprom_size, GFP_KERNEL);
> > +     if (!eebuf)
> > +             return -ENOMEM;
> > +
> > +     eeprom->magic = SIS900_EEPROM_MAGIC;
> > +     spin_lock_irq(&sis_priv->lock);
> > +     res = sis900_read_eeprom(dev, eebuf);
> > +     spin_unlock_irq(&sis_priv->lock);
> > +     if (!res)
> > +             memcpy(data, eebuf + eeprom->offset, eeprom->len);
> > +     kfree(eebuf);
>
> Why do you not put the data directly into data and avoid this memory
> allocation, and memcpy?

Because EEPROM data from 'eeprom->offset' offset and of 'eeprom->len'
length only is expected to be returned in 'data'.

>
>             Andrew
