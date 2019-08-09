Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21FFA87669
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 11:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406077AbfHIJnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 05:43:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40300 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfHIJnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 05:43:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id h8so6192212edv.7;
        Fri, 09 Aug 2019 02:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/lYu/e47EnsyNFO2LSj0BQZUPA891bB6xOUbTQXck3k=;
        b=iRSHIAoCehbO1dVJjrk5QF/hzmOCTQNgxIIcn7YckOVRAm+0XQzij9QF48TBMNLt9d
         EBphcT+ovzxMiPGdfnK1f+28gfYZtqC1YUYtlfgYoK0Qf5CAenPd/4lBVuOIb8wCqDas
         kjbQc00sgNTgR1qgU4hgrtJ+7A5UEBzUhjGd5Ld18x70P261etvIs7+2SJ6zqV/HPcZ+
         6Rmk4Ni5HaSwhK1OWJL2GW2DPvB+kshGD0HQwJJ8v3KrcNtD+MKqMr7r1ysPHUEvJa4p
         pF/5YuaRxWy6hCGBnGV8QtEO1IkK8GG6DLRAHIuZHz8BrqRStIskb1TCcbBXso7FklsB
         1Vig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/lYu/e47EnsyNFO2LSj0BQZUPA891bB6xOUbTQXck3k=;
        b=bQ65nz8peSlnpzkoy9FemiKswnzYCd5rCcGS5DG/HLdYhdRzQpwWd33+JEUut5Ja4d
         jah3Qu3JM6ZZpXBXWvva1CoJ0X+PoF4hJSyZVlQojp69gVRjNWKx2SwEn1zw8uNB73RL
         b8O+PTzT4SZWeAgsfFbQiuDQxHg4YuLZhV8fwG+HP1sotGTQIgWcuDa1rnQ44EvVkJih
         1Gvu0bHA6vevIf7MLgVYlkLr0xlGTMWOLhWkDf8789kaeUQr4o1v3b2WQJTg03w1MCCx
         3kVP4d+3LT0Ty623bJjljM2VHMadfppa0NVv/EkPbmV3DUCuJtEAqL2212EonUx7TsAh
         TUUw==
X-Gm-Message-State: APjAAAV2TQTJ6t6oK1Q34DmaI74T8iEcZDT0gxB3nibqJJLlkl9MVhNP
        +5CosARlvePW98oGeziEd1TgbbhgPz67cIuRETN9tQ==
X-Google-Smtp-Source: APXvYqxVdiPOOCTMWJskwGRKzFHXzIRK9YGnpC/sX78zcPM+MmvVQt4pR09fZ/Y5p1ameDXTlt9n/UFg9T9EgB5ytqI=
X-Received: by 2002:a17:907:2069:: with SMTP id qp9mr6652404ejb.90.1565343792337;
 Fri, 09 Aug 2019 02:43:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190809005754.23009-1-git@andred.net>
In-Reply-To: <20190809005754.23009-1-git@andred.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 9 Aug 2019 12:43:01 +0300
Message-ID: <CA+h21hp-K0ryB39O4X9n-mCwapiXoWy5WP6ZsvswgcDy-WBYVw@mail.gmail.com>
Subject: Re: [PATCH] net: phy: at803x: stop switching phy delay config needlessly
To:     =?UTF-8?Q?Andr=C3=A9_Draszik?= <git@andred.net>
Cc:     lkml <linux-kernel@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andre,

On Fri, 9 Aug 2019 at 03:58, Andr=C3=A9 Draszik <git@andred.net> wrote:
>
> This driver does a funny dance disabling and re-enabling
> RX and/or TX delays. In any of the RGMII-ID modes, it first
> disables the delays, just to re-enable them again right
> away. This looks like a needless exercise.
>
> Just enable the respective delays when in any of the
> relevant 'id' modes, and disable them otherwise.
>
> Also, remove comments which don't add anything that can't be
> seen by looking at the code.
>
> Signed-off-by: Andr=C3=A9 Draszik <git@andred.net>
> CC: Andrew Lunn <andrew@lunn.ch>
> CC: Florian Fainelli <f.fainelli@gmail.com>
> CC: Heiner Kallweit <hkallweit1@gmail.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: netdev@vger.kernel.org
> ---

Is there any particular problem you're facing? Does this make any differenc=
e?

>  drivers/net/phy/at803x.c | 26 ++++++--------------------
>  1 file changed, 6 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 222ccd9ecfce..2ab51f552e92 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -257,35 +257,21 @@ static int at803x_config_init(struct phy_device *ph=
ydev)
>          *   after HW reset: RX delay enabled and TX delay disabled
>          *   after SW reset: RX delay enabled, while TX delay retains the
>          *   value before reset.
> -        *
> -        * So let's first disable the RX and TX delays in PHY and enable
> -        * them based on the mode selected (this also takes care of RGMII
> -        * mode where we expect delays to be disabled)
>          */
> -
> -       ret =3D at803x_disable_rx_delay(phydev);
> -       if (ret < 0)
> -               return ret;
> -       ret =3D at803x_disable_tx_delay(phydev);
> -       if (ret < 0)
> -               return ret;
> -
>         if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
>             phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID) {
> -               /* If RGMII_ID or RGMII_RXID are specified enable RX dela=
y,
> -                * otherwise keep it disabled
> -                */
>                 ret =3D at803x_enable_rx_delay(phydev);
> -               if (ret < 0)
> -                       return ret;
> +       } else {
> +               ret =3D at803x_disable_rx_delay(phydev);
>         }
> +       if (ret < 0)
> +               return ret;
>
>         if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
>             phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID) {
> -               /* If RGMII_ID or RGMII_TXID are specified enable TX dela=
y,
> -                * otherwise keep it disabled
> -                */
>                 ret =3D at803x_enable_tx_delay(phydev);
> +       } else {
> +               ret =3D at803x_disable_tx_delay(phydev);
>         }
>
>         return ret;
> --
> 2.20.1
>

Regards,
-Vladimir
