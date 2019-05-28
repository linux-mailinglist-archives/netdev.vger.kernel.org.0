Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B132C714
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfE1Myp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:54:45 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45249 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbfE1Myp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:54:45 -0400
Received: by mail-ed1-f67.google.com with SMTP id g57so16783617edc.12
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 05:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i6VJCseZr05+MLyjh91JVOItIODV/x8BPJtns6cGxBA=;
        b=M8CHquhdK7evLgeg1hFY0guvM3aOPO5JyIZv3hHb+Dx209Gq/ZxrML+RyxYas0mD1o
         ZzOjSNVfj+rOqLWvkxKDIKyYlPhY2GgmUil4zxMPcAp98B1GFjWDf/Y73hbPrH7bdYfn
         OHbN6w57VTcvAqf+JKKo/61R3gW4jOBLAuufaRbL8ZA27vsA4l5kej17kC0RGsKucZum
         t0OurD9AEpAWqYkiYTcld0ZLHqpDBTpKG/U8iqMiMHNdo1SVY3jQ2rq1hbm6E/t7ro5K
         6NIKvHjHsCh96Eh5B6mN4BfFbtdHEumEHxouQDHFrlqBlUlGr+3TzEHrTqq+cPFCFtcQ
         LMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i6VJCseZr05+MLyjh91JVOItIODV/x8BPJtns6cGxBA=;
        b=iMXM8pnjoZ32aMCYL1+cbbZN8dBQbUtlYOcfierUYjGfN5Q2/jo0qZYydlXKYoV6rw
         CFaTBr//t303H37FpyufADpEM6UrmkO/uc9cFzaDU1o1lPrwZ5iYfh7VNQ7sfHsX3jBq
         QFNb+mnVIpVWxa5D1HPvmzuzVKeD8gIYWEGcOb4a2OytJMVMKY39V52iT6ckn+i1fqZN
         R0LjU3I02Y28Ri6NMku5W1dIbF8PKjbgfoXg1GmIHR3UsaiXgr1ELM0aAranLFieSS7K
         5IvmK3edakLiyy3KBMAJbYhJhAldi+I0N2VDE1aVRYOA2i2gpu5m4qK+mSSB7c1uZyZU
         Jo0g==
X-Gm-Message-State: APjAAAWj5SDZKF0f8ZnwwNCC032WKA8B6VX/SvloBBdkU5ZtWXRTgNUc
        8IFIfslr7FZ+FCHeXva69yL660qaXagQQvhSYH+olMJe
X-Google-Smtp-Source: APXvYqws1Yko9UzgBXoJzZMQ+SO22JTzxZOZUPf8mv8+w8ZuanL691uwsRjC5+VntxKkkOePQAtZ6UwKZjHpTmT3+BM=
X-Received: by 2002:a17:906:8397:: with SMTP id p23mr19788193ejx.300.1559048083104;
 Tue, 28 May 2019 05:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk> <E1hVYrJ-0005ZA-0S@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1hVYrJ-0005ZA-0S@rmk-PC.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 28 May 2019 15:54:31 +0300
Message-ID: <CA+h21hpXv7678MuKVfAGiwuQwzZHX_1hjXHpwZUFz8wP5aRabg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] net: phy: allow Clause 45 access via mii ioctl
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 May 2019 at 12:58, Russell King <rmk+kernel@armlinux.org.uk> wrote:
>
> Allow userspace to generate Clause 45 MII access cycles via phylib.
> This is useful for tools such as mii-diag to be able to inspect Clause
> 45 PHYs.
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phy.c | 33 ++++++++++++++++++++++++---------
>  1 file changed, 24 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 3745220c5c98..6d279c2ac1f8 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -386,6 +386,7 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
>         struct mii_ioctl_data *mii_data = if_mii(ifr);
>         u16 val = mii_data->val_in;
>         bool change_autoneg = false;
> +       int prtad, devad;
>
>         switch (cmd) {
>         case SIOCGMIIPHY:
> @@ -393,14 +394,29 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
>                 /* fall through */
>
>         case SIOCGMIIREG:
> -               mii_data->val_out = mdiobus_read(phydev->mdio.bus,
> -                                                mii_data->phy_id,
> -                                                mii_data->reg_num);
> +               if (mdio_phy_id_is_c45(mii_data->phy_id)) {
> +                       prtad = mdio_phy_id_prtad(mii_data->phy_id);
> +                       devad = mdio_phy_id_devad(mii_data->phy_id);
> +                       devad = MII_ADDR_C45 | devad << 16 | mii_data->reg_num;
> +               } else {
> +                       prtad = mii_data->phy_id;
> +                       devad = mii_data->reg_num;
> +               }
> +               mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad,
> +                                                devad);
>                 return 0;
>
>         case SIOCSMIIREG:
> -               if (mii_data->phy_id == phydev->mdio.addr) {
> -                       switch (mii_data->reg_num) {
> +               if (mdio_phy_id_is_c45(mii_data->phy_id)) {
> +                       prtad = mdio_phy_id_prtad(mii_data->phy_id);
> +                       devad = mdio_phy_id_devad(mii_data->phy_id);
> +                       devad = MII_ADDR_C45 | devad << 16 | mii_data->reg_num;
> +               } else {
> +                       prtad = mii_data->phy_id;
> +                       devad = mii_data->reg_num;
> +               }
> +               if (prtad == phydev->mdio.addr) {
> +                       switch (devad) {
>                         case MII_BMCR:
>                                 if ((val & (BMCR_RESET | BMCR_ANENABLE)) == 0) {
>                                         if (phydev->autoneg == AUTONEG_ENABLE)
> @@ -433,11 +449,10 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
>                         }
>                 }
>
> -               mdiobus_write(phydev->mdio.bus, mii_data->phy_id,
> -                             mii_data->reg_num, val);
> +               mdiobus_write(phydev->mdio.bus, prtad, devad, val);
>
> -               if (mii_data->phy_id == phydev->mdio.addr &&
> -                   mii_data->reg_num == MII_BMCR &&
> +               if (prtad == phydev->mdio.addr &&
> +                   devad == MII_BMCR &&
>                     val & BMCR_RESET)
>                         return phy_init_hw(phydev);
>
> --
> 2.7.4
>

Hi Russell,

I find the SIOCGMIIREG/SIOCGMIIPHY ioctls useful for C45 just as much
as they are for C22, but I think the way they work is a big hack and
for that reason they're less than useful when you need them most.
These ioctls work by hijacking the MDIO bus driver of a PHY that is
attached to a net_device. Hence they can be used to access at most a
PHY that lies on the same MDIO bus as one you already have a
phy-handle to.
If you have a PHY issue that makes of_phy_connect fail and the
net_device to fail to probe, basically you're SOL because you lose
that one handle that userspace had to the MDIO bus.
Similarly if you're doing a bring-up and all PHY interfaces are fixed-link.
Maybe it would be better to rethink this and expose some sysfs nodes
for raw MDIO access in the bus drivers.

-Vladimir
