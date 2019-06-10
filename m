Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1FAB3BD30
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389389AbfFJTxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:53:44 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44579 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389173AbfFJTxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 15:53:44 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so16150314edr.11;
        Mon, 10 Jun 2019 12:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i55Z4U6HHP04ncRU8z8qEOuvsQo8+MFGoJtJQ1qxggI=;
        b=hVy55VCqLf8hQzfitNmW4sqc3n5sW4eQScHIYu60TCju2x+O2oNK8h740boBaRxLWm
         gnCttUCWtoVUFutQf/PUtHzMbzkbgxYQVPlA9vRjnw4FusDHizTXKG+7tIp+fUPfUmUm
         0K9+JKjrHQggSA54ho9tAN/jk5C8+u7EW7SnRSiCKddeHNWCVb7mQGstmYhTWBVjGkQC
         HienM+LFdHUv3ijj+NlHTD5Ypjim5jmoKVSNWWZVAvY7J1vnQ2oqE4nkz+C1IEZD+jNX
         BUqkBdqC3/XSulFv9i6vROS019+Ja1p+T3Su/+K4tiy3ILj2aBRD6xXn176xKw0x1awf
         qsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i55Z4U6HHP04ncRU8z8qEOuvsQo8+MFGoJtJQ1qxggI=;
        b=cReyGS/rpPfNsDlVpLOxtnWTaDM82QpQSYJrOMJJXgZ8I/OdPscOnYCpR0KnBPi9F8
         oxtO68b2EY3li1zJxYSjCT5sxouCs58gU0A8W9TTsBk1DeucpoT2tMY4eTTJZA72ALH3
         D7xuxXRrdb5R4zhq80p2qWWmHt7dpRxRTGfIYJJoV7MIbuvCj1ga4qjpZRs7slNuSSYn
         GgtIT45KeAGshYl/i1ItjEWrjm4CfKg8NPrASoVtdvd71lC8iRndXCeRSF+K1//awN5k
         ZEvA+iI4qRxrJWk40eNjD58f1MBCOKil2QzkOwivSJfBsEGEuuCQJz0BRnhok1osjoOd
         izQQ==
X-Gm-Message-State: APjAAAUE3C4nSOjOfwLQ00gS73xWG6hq4HY0WHhVYv2YoCJh80QaSawe
        hMe9AzLG6oobRZKYofwxRAPImZhJLtS3W/mIzGibLA==
X-Google-Smtp-Source: APXvYqy8JYIQjk6hk815Z5Gf1qnVb/uo/VadlhNJffuQid562XATsQWu4IkyXqHtJK/3Pxz5cCu5cV44oVnOE4AyicM=
X-Received: by 2002:a17:906:19d3:: with SMTP id h19mr10748698ejd.300.1560196422555;
 Mon, 10 Jun 2019 12:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190610193150.22231-1-f.fainelli@gmail.com>
In-Reply-To: <20190610193150.22231-1-f.fainelli@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 10 Jun 2019 22:53:31 +0300
Message-ID: <CA+h21hrcymxF7zk4yHFGhjxbLERTCU6WkfzLGQVoZ5Yxoo4xxw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: Deal with non-existing PHY/fixed-link
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jun 2019 at 22:31, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> We need to specifically deal with phylink_of_phy_connect() returning
> -ENODEV, because this can happen when a CPU/DSA port does connect
> neither to a PHY, nor has a fixed-link property. This is a valid use
> case that is permitted by the binding and indicates to the switch:
> auto-configure port with maximum capabilities.
>
> Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  net/dsa/port.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index d74bc9df1359..dde3085ff065 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -622,7 +622,7 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
>         }
>
>         err = phylink_of_phy_connect(dp->pl, port_dn, 0);
> -       if (err) {
> +       if (err && err != -ENODEV) {
>                 pr_err("could not attach to PHY: %d\n", err);
>                 goto err_phy_connect;
>         }
> --
> 2.17.1
>

Hi Florian,

Can you give an example of when this is a valid use case, and why
fixed-link is not appropriate?

Regards,
-Vladimir
