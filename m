Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9E0305604
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhA0Inf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 03:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S316830AbhAZXKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:10:52 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0243BC06174A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 15:10:12 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id d2so91451edz.3
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 15:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dFESCStoVpRbVGk8ozF0XjMU/NzQ6nUXYZaDfTvzbGU=;
        b=F/s6E2RA6bLMPWplhhA8rTRUTjXtOkRwtTJNBUePITfv7pdkIZJTR5ob3W14ffMOLy
         xAMP1it3xUCT0I12vRHhycdME8jDblPlHqTUOCikf2C3E/g1o7comv5X8tv3gwmdFFqH
         AyKKEfsENZe4NSuKvZkRyN2NR8wppleW+ILv4WlH6x3aRsvOZlxbuvygwLE176HwhKoO
         a0/G/NOKHFqEnj+6Gxi1clmdAmgpzmwhL0rnyTKDpA/vAVCyPZJHAGDfsybhhQmaoGwT
         A3tUYTXdw8ZeORyQU89vWmzrOqka3uQmLbPL/r2+uaTXDRjzYg+vu2p0ei9V5jNB9k4+
         OZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dFESCStoVpRbVGk8ozF0XjMU/NzQ6nUXYZaDfTvzbGU=;
        b=kqxyH07TCkKPXnq9Vt6lMX2mjMosHZkDVfOa0d48edjaOFINkAA+sD+BzUq2UlJVqo
         w4NCQhVTJEFaSFpD/KxuGZiA66pZuUuugMvI2PcOhQF3G2PKoOuBR1pXFxDWUu6wCmo7
         0cuRoZknb8T3KtkAVQUEXx9mtaDWUbs44mudpQ6p8ymgIZEDKnN+OHVPtKJvu19AENXV
         q9t4mYghoCanC6Exf38/PpZ4onJ6BKFa9rnI3LHtAfyNC9UPQuPH6fNgwXf+oMS7dMSZ
         Cpbkp0NKVNy5krIZiGrKw4NNuzr2SJjVz59SQvZb004iv45rf4vWlWC7ax92/3Ue2zLW
         TPtA==
X-Gm-Message-State: AOAM532Kz5xT8A4gO63G6NRE5SW9Vu+eCMg3pR30gYODYS2awVjZ6t35
        sjULbTscLAcOGs8brqlUOXJt0BfxWkW21s7VKj4=
X-Google-Smtp-Source: ABdhPJw5zznZoxKRGmIYL2Qg5nkQSBWMDWzfCpRBe4ivbYQXTHfAufTwXZi6OmcHm4TDK/tarAufByxnOYjbbutleUc=
X-Received: by 2002:aa7:d1d7:: with SMTP id g23mr6340874edp.6.1611702610847;
 Tue, 26 Jan 2021 15:10:10 -0800 (PST)
MIME-Version: 1.0
References: <20210126115854.2530-1-qiangqing.zhang@nxp.com> <20210126115854.2530-3-qiangqing.zhang@nxp.com>
In-Reply-To: <20210126115854.2530-3-qiangqing.zhang@nxp.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 26 Jan 2021 18:09:33 -0500
Message-ID: <CAF=yD-JEU2oSy11y47TvgTr-XHRNq7ar=j=5w+14EUSyLj7xHA@mail.gmail.com>
Subject: Re: [PATCH V3 2/6] net: stmmac: stop each tx channel independently
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-imx@nxp.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 7:03 AM Joakim Zhang <qiangqing.zhang@nxp.com> wrote:
>
> If clear GMAC_CONFIG_TE bit, it would stop all tx channels, but users
> may only want to stop secific tx channel.

secific -> specific

>
> Fixes: 48863ce5940f ("stmmac: add DMA support for GMAC 4.xx")
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> index 0b4ee2dbb691..71e50751ef2d 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
> @@ -53,10 +53,6 @@ void dwmac4_dma_stop_tx(void __iomem *ioaddr, u32 chan)
>
>         value &= ~DMA_CONTROL_ST;
>         writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
> -
> -       value = readl(ioaddr + GMAC_CONFIG);
> -       value &= ~GMAC_CONFIG_TE;
> -       writel(value, ioaddr + GMAC_CONFIG);

Is it safe to partially unwind the actions of dwmac4_dma_start_tx

And would the same reasoning apply to dwmac4_(dma_start|stop)_rx?
