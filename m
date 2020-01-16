Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABD313EB56
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405882AbgAPRtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:49:12 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45284 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387539AbgAPRtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 12:49:11 -0500
Received: by mail-ed1-f67.google.com with SMTP id v28so19674294edw.12
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 09:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3lk8qURD6DfpJl5sZ+fvqHUgEYEi5XOpTx8oRm2JQuo=;
        b=p7qyCaX0ztWpIO9+EP8fP8tN9mp0cgCnVmkycwOZZolkqnWJaOvGjHVYdSgXL6wX+A
         ATGLzM/pxBDzbAP3IycjEcvvoG+ckdQQ2iVNP+8Z53jZhaQ7+djM49L+noWKZ/1mjX6d
         d8b5RTTm8/xLTDOrutqh+pQzyWnlNhnUecUJ21MY4d37eOeiFrvVF5OdDRVbvy84rj7q
         iSmQzpYtxJgu6PL8WntwQYISzwEm/B20nxWkcR3fBRj1ply8EsUn+T0u9o+vJ4+nIivD
         Mmh2TtcXdTlxi/dR/zt/FEmrtfPJ4HjUOd6ikEP+2xwD9umV+w+pqSzdRu1VmAFJ/7Zi
         JYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3lk8qURD6DfpJl5sZ+fvqHUgEYEi5XOpTx8oRm2JQuo=;
        b=iQauNm42n8VBkB3VcdynTUWbb1mQJ/sYky6N4c7G/bUOZzwVHa+Ej+32V5u7KnYWsZ
         ILSgFIwBRZpWWLsBWCB+OTe8Tnv9qMVnuWQ1WoUtp21vBZR8JOBQtbW9lTkk0/NRGNHB
         lXj48P+TAGyrvzMvR3i3O1uCjPoJJE4gXQDTuJlseXYRFRPLz8jaZ3sbTxuMjFrJntf8
         S+QRdQ+CZNHzOPROZpWBeNXr79JdHlquwp2ZqzeeFDP9PderlBqrPSMzNbA60ghkYAk5
         b2BE26x7OABBKcL7to8L0KHC5lnmhrIWnEFHlyPXZ4aPTU39tThJwNDo1PIPjVmowDJC
         DE+A==
X-Gm-Message-State: APjAAAU8vsdEXGhpV5smu9TzAi5QQTQlmWgFNqBwg7ljRoSKKWlhdBpU
        BI+teQDWhEzX6sstopWTVJgkkpNEmOUNwdcnw/0=
X-Google-Smtp-Source: APXvYqyiHu/aiaSnGcXkUZRQqI5YazoNEctYUSgpoVYuxL3j7D/Jnfn9S+bRWsZ1f4x4taSCgppeJO7EG8IfrVkvl5w=
X-Received: by 2002:a17:906:f49:: with SMTP id h9mr4212763ejj.6.1579196949544;
 Thu, 16 Jan 2020 09:49:09 -0800 (PST)
MIME-Version: 1.0
References: <20200116174628.16821-1-olteanv@gmail.com>
In-Reply-To: <20200116174628.16821-1-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 16 Jan 2020 19:48:58 +0200
Message-ID: <CA+h21hqyna1Fyr3ZQ7mwqUOw7rtUgfC3PqTqxg-HWFbDpNKDhg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: phy: don't crash in phy_read/_write_mmd
 without a PHY driver
To:     "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jan 2020 at 19:46, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Alex Marginean <alexandru.marginean@nxp.com>
>
> The APIs can be used by Ethernet drivers without actually loading a PHY
> driver. This may become more widespread in the future with 802.3z
> compatible MAC PCS devices being locally driven by the MAC driver when
> configuring for a PHY mode with in-band negotiation.
>
> Check that drv is not NULL before reading from it.
>
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> ---

Ugh. Can I just add here:

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

without resending?

> If this hasn't been reported by now I assume it wasn't an issue so far.
> So I've targeted the patch for net-next and not provided a Fixes: tag.
>
>  drivers/net/phy/phy-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 769a076514b0..a4d2d59fceca 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -387,7 +387,7 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
>         if (regnum > (u16)~0 || devad > 32)
>                 return -EINVAL;
>
> -       if (phydev->drv->read_mmd) {
> +       if (phydev->drv && phydev->drv->read_mmd) {
>                 val = phydev->drv->read_mmd(phydev, devad, regnum);
>         } else if (phydev->is_c45) {
>                 u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
> @@ -444,7 +444,7 @@ int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
>         if (regnum > (u16)~0 || devad > 32)
>                 return -EINVAL;
>
> -       if (phydev->drv->write_mmd) {
> +       if (phydev->drv && phydev->drv->write_mmd) {
>                 ret = phydev->drv->write_mmd(phydev, devad, regnum, val);
>         } else if (phydev->is_c45) {
>                 u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
> --
> 2.17.1
>

Sorry,
-Vladimir
