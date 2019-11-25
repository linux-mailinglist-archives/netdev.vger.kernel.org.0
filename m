Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96013108B69
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfKYKKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:10:54 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39635 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbfKYKKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 05:10:54 -0500
Received: by mail-ed1-f65.google.com with SMTP id n26so12130299edw.6;
        Mon, 25 Nov 2019 02:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oxKNKG1r2qoKR1r12kWtBNNrwYTsx7eD0jpk3TN58Vg=;
        b=t/gW2W2pl8F2J4GIToK/aB45qdt1mEruk+hrDlMhhx/9dhIkbQILkwrJDfus9h0KOE
         G9O9YJkyBK8QLnOPPg9P7u4YhwexmI97wS1eevD8pdVMmyGl5Z60excDINaYYCLy5wMq
         RBoz2sX6ZEdqkkYiiJUnNtXpW/mMDe9QPznvkZ4TsTH7vAcjmVgpRj0ZBbaaInIen6Xm
         +yVtHOK/396D31GG7jIDWB1T2yzoMB715zgjGw6R42r6MGSFPCc+i9LG3MiaA2UxCdij
         EEU8jxdjlM/h3EE5XJ4oP735i13Na8IRIR7lDqbqneoDU/6I+3FZUg6J5qnIhoshBi/g
         ILkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oxKNKG1r2qoKR1r12kWtBNNrwYTsx7eD0jpk3TN58Vg=;
        b=Cg4WIVy/MOnHSPf76saPBye2dqoH19Ki0HCmphVnMYs5PdZMkmO2TpAbl4H0ANTMB1
         p+u00bD3gbRobeGFbZl7UV5TlkiwtPxLSNOVZ7DsTKvXVKsc8DOU8eNBnTUqE/hLIXeB
         udSuvVSgKmJlXIfi/OOi0ZBy8Ub8dNzxRnFhFrND28vo36bub7yLH3zYY6v53xbBmzOw
         dGGl5A1TxHCSh2kVn/MC8X96w9SsTbfsF3MWGoPllxHgzKH6Q8W89yTeyfFi++Sxon9Z
         ZxC3az5by1nsuXUGWeuUtXQzKlI7RAxuyPLkepCJnha0lduf+9gwGI+FaX48Bqtb7ghb
         yImw==
X-Gm-Message-State: APjAAAVgPG40FGhZ+B+KK13w6zrLphyS2CqVtWUmf8F5md1QodcV9MfE
        f79EYbq6dYrdG+VW0Ck1maFZz3hkJxmv7Y9JAKc=
X-Google-Smtp-Source: APXvYqziLSNnlLW7L3YCugINAMcp/CEsi8ZBH+ttX5R5vkCmALA5iK52k+HPvE4SmWxC1/cpqLSXdldS9kNmdu0pE24=
X-Received: by 2002:a17:906:4910:: with SMTP id b16mr35918507ejq.133.1574676652140;
 Mon, 25 Nov 2019 02:10:52 -0800 (PST)
MIME-Version: 1.0
References: <20191125100259.5147-1-o.rempel@pengutronix.de> <20191125100259.5147-2-o.rempel@pengutronix.de>
In-Reply-To: <20191125100259.5147-2-o.rempel@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 25 Nov 2019 12:10:41 +0200
Message-ID: <CA+h21hoCaT3DpTGgN8Og98P98tUvPS8-zMKWtVxpyObCe30NvQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] net: dsa: sja1105: fix sja1105_parse_rgmii_delays()
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, david@protonic.nl
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Nov 2019 at 12:03, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> This function was using configuration of port 0 in devicetree for all ports.
> In case CPU port was not 0, the delay settings was ignored. This resulted not
> working communication between CPU and the switch.
>
> Fixes: f5b8631c293b ("net: dsa: sja1105: Error out if RGMII delays are requested in DT")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/sja1105/sja1105_main.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index 1238fd68b2cd..34544b1c30dc 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -594,15 +594,15 @@ static int sja1105_parse_rgmii_delays(struct sja1105_private *priv,
>         int i;
>
>         for (i = 0; i < SJA1105_NUM_PORTS; i++) {
> -               if (ports->role == XMII_MAC)
> +               if (ports[i].role == XMII_MAC)
>                         continue;
>
> -               if (ports->phy_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
> -                   ports->phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
> +               if (ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
> +                   ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
>                         priv->rgmii_rx_delay[i] = true;
>
> -               if (ports->phy_mode == PHY_INTERFACE_MODE_RGMII_TXID ||
> -                   ports->phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
> +               if (ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_TXID ||
> +                   ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
>                         priv->rgmii_tx_delay[i] = true;
>
>                 if ((priv->rgmii_rx_delay[i] || priv->rgmii_tx_delay[i]) &&
> --
> 2.24.0
>
