Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEC11CBE70
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 09:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgEIHik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 03:38:40 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41832 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgEIHik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 03:38:40 -0400
Received: by mail-oi1-f194.google.com with SMTP id 19so10585048oiy.8;
        Sat, 09 May 2020 00:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9iOCtd8hInAFwZEEy5/s6oN5yN9LbAgaBCk+Pd2Zfpk=;
        b=Bbw7gMGmNvBOeJy7+VCtYI+VCwrgpZXeuhgBsebMAdgQDjaCS/B0bZR0L0Qj9FcyuZ
         vp/yZKTrk+njsHtalSUwDV+bATtkScXQbeYiZY6yPsDm0a5X71ZclR+fWpO7wIwOwhxx
         HU31zIQNxRhU1QHkfVzGoTiLP6yhND51flb+sdIVulFxNzxjhB0ATjsWqO9p0VwQ5e6D
         TIrMQ9X3zJIKd8OQNFYfirqa9XE1H+2Q1d3qnUqh8CYkjuqTtyOG5Lq/jU3LguHi7W5i
         TkRK9SAG1FcHpsVoqeBvyvjGYipExAOqFkRwYRxxZ20D3swUbFEp4OEgOedyhKNahf/v
         QCFg==
X-Gm-Message-State: AGi0PuYWAylJItUjeVd0eXdRcGS6DS9Rzpvf8ZRs4rIygaOSKpkje5Cp
        DvakIf5IqhyW1TbC5K/tsVFodMo9PkKPvjtUUMQ=
X-Google-Smtp-Source: APiQypIhzI5S6MTE2Rw2TcjkhcBXQU/2d5QohGoiHGR4xXrGldruM5LIRhRBh3PQtIrtKIqOX4QC/wsnF6RwhSrReUE=
X-Received: by 2002:aca:f541:: with SMTP id t62mr12715510oih.148.1589009919549;
 Sat, 09 May 2020 00:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200508223216.6611-1-f.fainelli@gmail.com>
In-Reply-To: <20200508223216.6611-1-f.fainelli@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 9 May 2020 09:38:28 +0200
Message-ID: <CAMuHMdU2A1rzqsnNZFt-Gd+ZO5qc6Mzeyunn-LXpbxk_6zq-Ng@mail.gmail.com>
Subject: Re: [PATCH net] net: broadcom: Imply BROADCOM_PHY for BCMGENET
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Stefan Wahren <wahrenst@gmx.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tal Gilboa <talgi@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

Thanks for your patch!

On Sat, May 9, 2020 at 12:32 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
> The GENET controller on the Raspberry Pi 4 (2711) is typically
> interfaced with an external Broadcom PHY via a RGMII electrical
> interface. To make sure that delays are properly configured at the PHY
> side, ensure that we get a chance to have the dedicated Broadcom PHY
> driver (CONFIG_BROADCOM_PHY) enabled for this to happen.

I guess it can be interfaced to a different external PHY, too?

> Fixes: 402482a6a78e ("net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

> --- a/drivers/net/ethernet/broadcom/Kconfig
> +++ b/drivers/net/ethernet/broadcom/Kconfig
> @@ -69,6 +69,7 @@ config BCMGENET
>         select BCM7XXX_PHY
>         select MDIO_BCM_UNIMAC
>         select DIMLIB
> +       imply BROADCOM_PHY if ARCH_BCM2835

Which means support for the BROADCOM_PHY is always included
on ARCH_BCM2835, even if a different PHY is used?

>         help
>           This driver supports the built-in Ethernet MACs found in the
>           Broadcom BCM7xxx Set Top Box family chipset.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
