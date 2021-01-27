Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4312930624B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 18:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344017AbhA0RlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 12:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344050AbhA0Rky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 12:40:54 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8030DC061573;
        Wed, 27 Jan 2021 09:40:14 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id rv9so3798711ejb.13;
        Wed, 27 Jan 2021 09:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c0zqNzdWhocaSRrPUT/nMPELWMWvRw1OqyGa9bc+g8w=;
        b=hZre1addgUyhMpi/q+57I8hO+oJ9dZzDH35DyXufB3J206XkoqJIsXKEhPFK8UjXrp
         Qk3rG4k6s/l19nSdfZPE+W18BZTu63xbOnbrNM2nI0FIoHejuXV89nic5QE8i5Y8U/kC
         /Llk0D/qA8UpBQs3AOVPYpj/T7MTq/ErwjzmywOehdwcSKKF64kiiNgSCVzFTKlAISJw
         WIAjTggZl/cMV9oM18qH0xxcPMkI8Ny1Xh6qtvD2EeVBRypyxCu+p5Od/dcDdLdXWKOZ
         E0n726mKRbrSon3L9mlxOT4ne6nv2OtaO1rnG98xL0kFAl18A+7sm1ARGEzjSzBOj7+e
         T8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c0zqNzdWhocaSRrPUT/nMPELWMWvRw1OqyGa9bc+g8w=;
        b=DXPEXRIGcfvXWINxOU8Eef9VQJCf3o2fgGPntrM34nyB1xzqqg6C4mOaqZqlnfci/M
         uZEIE64uzGCmbS6NIlGWW8g8QHwgHruzAcDhgAd/k5/XXNH9OZiC1VlOc9Nx+zVr8M4F
         hR1swO/614mit4seMg3FNksyVtYLy7J4STP51XLOaqnELRrjf2ED4E+jh6Pgc265Dr0k
         nQpaQkVhIr+fDwQMcQMFx/YYeCaa59Dj3/EsbYhsR3iJoPxd8GdysrZy5G15otAKuh5X
         ZCS28GruDSt8OocvPr/HDU69dUZOIoN31kUGJk0JDox62ERAd8hpLioVnvx6Hmxxzqfv
         JnFA==
X-Gm-Message-State: AOAM5333WCCpP6YKa1HaBdpL0YMsrrM/7NERgsrdyxxejafiB+c0Leqz
        7E1+OujnHxmyjxyaTOFDUP490L/TKb8+t1UfJWU=
X-Google-Smtp-Source: ABdhPJzB2Ho+oH8D36li7b3P9a9jXNWFVS0+37hGngKW75AFYoPtkvx/LhZpzL+ekjYf0YB0fZd8YYSPzct5pMte9yw=
X-Received: by 2002:a17:906:44a:: with SMTP id e10mr7435445eja.265.1611769213327;
 Wed, 27 Jan 2021 09:40:13 -0800 (PST)
MIME-Version: 1.0
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com> <1611747815-1934-12-git-send-email-stefanc@marvell.com>
In-Reply-To: <1611747815-1934-12-git-send-email-stefanc@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 12:39:36 -0500
Message-ID: <CAF=yD-JDGg2pxi_EQvuK5iRdVpTovswF6rZ8dvAAmV0xbeimkA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 11/19] net: mvpp2: add spinlock for FW FCA
 configuration path
To:     stefanc@marvell.com
Cc:     Network Development <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Miller <davem@davemloft.net>, nadavh@marvell.com,
        ymarkman@marvell.com, LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux@armlinux.org.uk,
        mw@semihalf.com, Andrew Lunn <andrew@lunn.ch>,
        rmk+kernel@armlinux.org.uk, Antoine Tenart <atenart@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 7:19 AM <stefanc@marvell.com> wrote:
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> Spinlock added to MSS shared memory configuration space.
>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 5 +++++
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 3 +++
>  2 files changed, 8 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> index 9d8993f..f34e260 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -1021,6 +1021,11 @@ struct mvpp2 {
>
>         /* CM3 SRAM pool */
>         struct gen_pool *sram_pool;
> +
> +       bool custom_dma_mask;
> +
> +       /* Spinlocks for CM3 shared memory configuration */
> +       spinlock_t mss_spinlock;

Does this need to be a stand-alone patch? This introduces a spinlock,
but does not use it.

Also, is the introduction of custom_dma_mask in this commit on purpose?
