Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C0029129C
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 17:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438507AbgJQPS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 11:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438466AbgJQPS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 11:18:29 -0400
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DC6120760
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 15:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602947908;
        bh=DyTynAqqIl5dYftgsJHuwoXgvda160NzcBXFmUW1C1U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2CqDbW/KttrfM9/S4Ot9gdDuDkVNbKoFDA7eG2/Cd9QXXle30Fo9OVyE4mrDcaizo
         yuY8ud43P69abwMTI8C1pd58XLuRIGX+HscP0UXDeOCa4/OU04l283YqsVX3C4Ihc8
         RZtno4EFn/g1kRcGoi4015NiRpFse4aa1zamRMGE=
Received: by mail-oo1-f54.google.com with SMTP id f19so1449589oot.4
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 08:18:28 -0700 (PDT)
X-Gm-Message-State: AOAM533ttUaPpEMZB3nxA2/Kjfid3w121PesYvRNgLjbhPOgy4d5Rhau
        nV2sD/IqgkOwWugzP/wEXBbSMqzWoR7l3DfZvho=
X-Google-Smtp-Source: ABdhPJwjgIpHyyoBkAPTixZR+t4YHbhmRGL1lZ9b+nyAjrrFBivDsuaMYX2ZP1DzbWoNzCmy+6BoLGeVtYClvQxxTSY=
X-Received: by 2002:a4a:c3ca:: with SMTP id e10mr6613627ooq.41.1602947907803;
 Sat, 17 Oct 2020 08:18:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
 <20201017144430.GI456889@lunn.ch> <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
 <20201017151132.GK456889@lunn.ch>
In-Reply-To: <20201017151132.GK456889@lunn.ch>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 17 Oct 2020 17:18:16 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
Message-ID: <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Oct 2020 at 17:11, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Oct 17, 2020 at 04:46:23PM +0200, Ard Biesheuvel wrote:
> > On Sat, 17 Oct 2020 at 16:44, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Sat, Oct 17, 2020 at 04:20:36PM +0200, Ard Biesheuvel wrote:
> > > > Hello all,
> > > >
> > > > I just upgraded my arm64 SynQuacer box to 5.8.16 and lost all network
> > > > connectivity.
> > >
> > > Hi Ard
> > >
> > > Please could you point me at the DT files.
> > >
> > > > This box has a on-SoC socionext 'netsec' network controller wired to
> > > > a Realtek 80211e PHY, and this was working without problems until
> > > > the following commit was merged
> > >
> > > It could be this fix has uncovered a bug in the DT file. Before this
> > > fix, if there is an phy-mode property in DT, it could of been ignored.
> > > Now the phy-handle property is correctly implemented. So it could be
> > > the DT has the wrong value, e.g. it has rgmii-rxid when maybe it
> > > should have rgmii-id.
> > >
> >
> > This is an ACPI system. The phy-mode device property is set to 'rgmii'
>
> Hi Ard
>
> Please try rgmii-id.
>
> Also, do you have the schematic? Can you see if there are any
> strapping resistors? It could be, there are strapping resistors to put
> it into rgmii-id. Now that the phy-mode properties is respected, the
> reset defaults are being over-written to rgmii, which breaks the link.
> Or the bootloader has already set the PHY mode to rgmii-id.
>
> You can also use '' as the phy-mode, which results in
> PHY_INTERFACE_MODE_NA, which effectively means, don't touch the PHY
> mode, something else has already set it up. This might actually be the
> correct way to go for ACPI. In the DT world, we tend to assume the
> bootloader has done the absolute minimum and Linux should configure
> everything. The ACPI takes the opposite view, the firmware will do the
> basic hardware configuration, and Linux should not touch it, or ask
> ACPI to modify it.
>

Indeed, the firmware should have set this up. This would mean we could
do this in the driver: it currently uses

priv->phy_interface = device_get_phy_mode(&pdev->dev);

Can we just assign that to PHY_INTERFACE_MODE_NA instead?
