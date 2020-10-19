Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8F1292285
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 08:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgJSGa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 02:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgJSGa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 02:30:57 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E14CA2225A
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 06:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603089057;
        bh=+/43/3MRLVv2ZstdO5gGP+K9FjZVj+3FRiJ0ZJgylZA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Rjtbm17cNUWj1PDiNDsNXEjdnPnR3H5Nq8QVg+gZbTotvFpBJGqh1QMiLTO9EMeg9
         xYMWnFr25bNYvopWievWb5+PVBOyrnKtbQ/hHiT/jzPA6FWaKLxd8F+MAZDkuTYqFk
         QGd+p09EA84gxLTaFscvL1lFp4uxu6UIZ9G7JDmY=
Received: by mail-ot1-f53.google.com with SMTP id l4so9479271ota.7
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 23:30:56 -0700 (PDT)
X-Gm-Message-State: AOAM533GMd/6OJt80+yCqcUkGDIUzGrPIOPW4JZDtKPIu4x6Nk4K8FOD
        YhE9Eo6DZp8AdHynehpg6ciCDp9B8YXprrn9uOo=
X-Google-Smtp-Source: ABdhPJxsPYO6P6YLlDGMB+9Xf8TdmN8qANR5rFak2MxReY51byIeiwjGpUEzOciaY1M2gPW5Jdg9l2M0seu7+bVCxvg=
X-Received: by 2002:a9d:6a85:: with SMTP id l5mr11523557otq.77.1603089056110;
 Sun, 18 Oct 2020 23:30:56 -0700 (PDT)
MIME-Version: 1.0
References: <20201018163625.2392-1-ardb@kernel.org> <20201018175218.GG456889@lunn.ch>
 <20201018203225.GA1790657@apalos.home>
In-Reply-To: <20201018203225.GA1790657@apalos.home>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 19 Oct 2020 08:30:45 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEtLx_5_Hyuk=nU6PhnYZm3F33uWGiRHH2Yb3X2ENxRSw@mail.gmail.com>
Message-ID: <CAMj1kXEtLx_5_Hyuk=nU6PhnYZm3F33uWGiRHH2Yb3X2ENxRSw@mail.gmail.com>
Subject: Re: [PATCH net] netsec: ignore 'phy-mode' device property on ACPI systems
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Jassi Brar <jaswinder.singh@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Serge Semin <fancer.lancer@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 at 22:32, Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Sun, Oct 18, 2020 at 07:52:18PM +0200, Andrew Lunn wrote:
> > > --- a/Documentation/devicetree/bindings/net/socionext-netsec.txt
> > > +++ b/Documentation/devicetree/bindings/net/socionext-netsec.txt
> > > @@ -30,7 +30,9 @@ Optional properties: (See ethernet.txt file in the same directory)
> > >  - max-frame-size: See ethernet.txt in the same directory.
> > >
> > >  The MAC address will be determined using the optional properties
> > > -defined in ethernet.txt.
> > > +defined in ethernet.txt. The 'phy-mode' property is required, but may
> > > +be set to the empty string if the PHY configuration is programmed by
> > > +the firmware or set by hardware straps, and needs to be preserved.
> >
> > In general, phy-mode is not mandatory. of_get_phy_mode() does the
> > right thing if it is not found, it sets &priv->phy_interface to
> > PHY_INTERFACE_MODE_NA, but returns -ENODEV. Also, it does not break
> > backwards compatibility to convert a mandatory property to
> > optional. So you could just do
> >
> >       of_get_phy_mode(pdev->dev.of_node, &priv->phy_interface);
> >
> > skip all the error checking, and document it as optional.
>
> Why ?
> The patch as is will not affect systems built on any firmware implementations
> that use ACPI and somehow configure the hardware.
> Although the only firmware implementations I am aware of on upsteream are based
> on EDK2, I prefer the explicit error as is now, in case a firmware does on
> initialize the PHY properly (and is using a DT).
>

We will also lose the ability to report bogus values for phy-mode this
way, so I think we should stick with the check.
