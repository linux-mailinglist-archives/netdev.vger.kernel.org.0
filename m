Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD7C182636
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 01:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731507AbgCLAYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 20:24:23 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:47032 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731423AbgCLAYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 20:24:22 -0400
Received: by mail-ed1-f66.google.com with SMTP id ca19so5156217edb.13
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 17:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2rGvVBmycfkKScedJ1iOe7jEyVyAnvgjeMqSAk7DMvI=;
        b=l+9sa94S7dxAWGeaQok/mdvk6EVgPMnfIKJI+Y7+OUWy1ScH/Vvs66teWeq1CuMWX0
         vI5G7uIGovVAcuwukscRwY4FZwreYMKajQR10V8UKtsbbZSaIH1kksPT9L4GWtZGFrlG
         Qny4GI+rzeK2XAY7Mk8P2Hry0bhLTnk4xRohHCQGF5Vrl/fx8yzVVER5EBGJlrnL8lyZ
         +atTaVdKq62fVyAJaJ43/tL2gDhENYQOtLpkDxCjiVgZ9UlaB7jtdmvNu7iIh5ksj8L3
         Qqemc20wALDvxNBG4S/PGoGlU2JVb0ZAhnaZASqKHe+guHWbRVqjuKDRbtfR0whMdlaz
         FU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2rGvVBmycfkKScedJ1iOe7jEyVyAnvgjeMqSAk7DMvI=;
        b=DKBUEyDa0DqyHQrEq9+HOfQwo73sm51Fmnz/8z/rsNoc2dcRygs+L6vz6PzBrk2jui
         cGoRLtJ6PhRSdvhdurMf3Rt1dDLAM1U6sYqZrjOrVsprpBj0yRAWEMrrdHKe92f2KcQp
         8/QAI1yO4fqg44sbOL4NXqIS1RspUTZPmrVXn/j5wTQCQR1r8QF6HhoGgGLzLz98eTC5
         nSnIpb5TXL12TAaJTD52ITnhtOr+0MpVFlmRARWbTLXIxmAAKA647bjevUJHW7KfXrDz
         AkmGoJXqWRK/x1fT8mQ3T2SNkEIUAcN4w5edXQFfS0+BNBVhDlnL2niYKfsuqIoq6mFI
         q0xA==
X-Gm-Message-State: ANhLgQ36Y5YIAujk15OgU9KKzTiLlrlZW472pTCREyKNHn1aREgBNoPw
        6s+ceC0xC8suvgyyJxEUALDp3fJjxvE5JxHqYYE=
X-Google-Smtp-Source: ADFU+vsxpnX8sisSioxmTEpDqqwZWNdzkWfRCrDQuqyxnqn4oSQk9jU05spOSyRtrJ9PAwQxCZGjgWGocD8o6Sh1PkQ=
X-Received: by 2002:a17:906:9501:: with SMTP id u1mr4242036ejx.113.1583972660768;
 Wed, 11 Mar 2020 17:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200311152424.18067-1-andrew@lunn.ch>
In-Reply-To: <20200311152424.18067-1-andrew@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 12 Mar 2020 02:24:08 +0200
Message-ID: <CA+h21hr63Jc-EfDhxS91W5s6gXLavz+datD1c9CKD6cKJ4PYFQ@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: Don't instantiate phylink for CPU/DSA ports
 unless needed
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 at 17:24, Andrew Lunn <andrew@lunn.ch> wrote:
>
> By default, DSA drivers should configure CPU and DSA ports to their
> maximum speed. In many configurations this is sufficient to make the
> link work.
>
> In some cases it is necessary to configure the link to run slower,
> e.g. because of limitations of the SoC it is connected to. Or back to
> back PHYs are used and the PHY needs to be driven in order to
> establish link. In this case, phylink is used.
>
> Only instantiate phylink if it is required. If there is no PHY, or no
> fixed link properties, phylink can upset a link which works in the
> default configuration.
>
> Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---


No regressions on ocelot/felix and sja1105, which have no .adjust_link
and do have fixed-link for the CPU port.

>  net/dsa/port.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index ed7dabb57985..ec13dc666788 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -648,9 +648,14 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
>  int dsa_port_link_register_of(struct dsa_port *dp)
>  {
>         struct dsa_switch *ds = dp->ds;
> +       struct device_node *phy_np;
>
> -       if (!ds->ops->adjust_link)
> -               return dsa_port_phylink_register(dp);
> +       if (!ds->ops->adjust_link) {
> +               phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
> +               if (of_phy_is_fixed_link(dp->dn) || phy_np)
> +                       return dsa_port_phylink_register(dp);
> +               return 0;
> +       }
>
>         dev_warn(ds->dev,
>                  "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
> @@ -665,11 +670,12 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
>  {
>         struct dsa_switch *ds = dp->ds;
>
> -       if (!ds->ops->adjust_link) {
> +       if (!ds->ops->adjust_link && dp->pl) {
>                 rtnl_lock();
>                 phylink_disconnect_phy(dp->pl);
>                 rtnl_unlock();
>                 phylink_destroy(dp->pl);
> +               dp->pl = NULL;
>                 return;
>         }
>
> --
> 2.25.1
>

Thanks,
-Vladimir
