Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C21483D4B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbiADH4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:56:39 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:34397 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiADH4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 02:56:39 -0500
Received: by mail-pf1-f174.google.com with SMTP id c2so31543020pfc.1
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 23:56:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k5yr3AtuD8K4pTVC0bU9zhjFIm+jZFJwQDj+V0I/7XU=;
        b=YvbZaGmZCoMoFaq0PMnpZvzP3rhdD5wLTYg5E7TXril+v4OYVRr+sYBRIa8Ky5Vu/j
         lA2537nlyj6NftVsJI4RzpGxSAOHM81EGshkRZ4db7dYWarHW1JbBxoUMucRdxMM5GIk
         ylKNF+t8sNynkXLcKbHDyUPxCDEigifhkZLVjFPv3GRH0mp1UywRZugmOniH0jmDIz6x
         WlRpL2Q6RFbBfuXzXupK2VjQ/vCc4TBkCEvYG5QFeltR++aLKCnrRyrQ1h3kIkVPrBFg
         FbydqBFckr228vW5vCj5sdFKhIilw+9Wa7JgyeHQdqbMInnwz7bhQL7pr+NKEtWJSB+G
         8Uog==
X-Gm-Message-State: AOAM533rMbHNAIwpx0nded6/YGgLJigjkRc0N7Vj822k2URvbLbkqLPi
        dwNWOH4GbNreRy5p2TiH7nfDYP8FJWiXxxtvduqUUPIT8Hc=
X-Google-Smtp-Source: ABdhPJzliGwRtRWEHZo1cYG12T+zI+2TUN07TYx0MRPmu3TxQE6EYTrioYv1dPdatOcrYUXYWNz8AHNz6s8o3zJHIG0=
X-Received: by 2002:a63:5f84:: with SMTP id t126mr42933525pgb.553.1641282998891;
 Mon, 03 Jan 2022 23:56:38 -0800 (PST)
MIME-Version: 1.0
References: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk> <E1mxqBh-00GWxo-51@rmk-PC.armlinux.org.uk>
 <20211216071513.6d1e0f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YbtxGLrXoR9oHRmM@shell.armlinux.org.uk> <CAFcVECJeRwgjGsxtcGpMuA23nnmywsNkA2Yngk6aDK_JuVE3NQ@mail.gmail.com>
In-Reply-To: <CAFcVECJeRwgjGsxtcGpMuA23nnmywsNkA2Yngk6aDK_JuVE3NQ@mail.gmail.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 4 Jan 2022 13:26:28 +0530
Message-ID: <CAFcVEC+N0Y7ESFe-qcfpmkbPjRSvCJ=AOXoM6XSK6xGo=J1YNw@mail.gmail.com>
Subject: Re: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pcs
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 1:55 PM Harini Katakam <harinik@xilinx.com> wrote:
>
> Hi Russell,
>
> On Fri, Dec 17, 2021 at 5:26 AM Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
> >
> > On Thu, Dec 16, 2021 at 07:15:13AM -0800, Jakub Kicinski wrote:
> > > On Thu, 16 Dec 2021 12:48:45 +0000 Russell King (Oracle) wrote:
> > > > Convert axienet to use the phylink_pcs layer, resulting in it no longer
> > > > being a legacy driver.
> > > >
> > > > One oddity in this driver is that lp->switch_x_sgmii controls whether
> > > > we support switching between SGMII and 1000baseX. However, when clear,
> > > > this also blocks updating the 1000baseX advertisement, which it
> > > > probably should not be doing. Nevertheless, this behaviour is preserved
> > > > but a comment is added.
> > > >
> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > >
> > > drivers/net/ethernet/xilinx/xilinx_axienet.h:479: warning: Function parameter or member 'pcs' not described in 'axienet_local'
> >
> > Fixed that and the sha1 issue you raised in patch 2. Since both are
> > "documentation" issues, I won't send out replacement patches until
> > I've heard they've been tested on hardware though.
>
> Thanks for the patches.
> Series looks good and we're testing at our end; will get back to you
> early next week.

Thanks Russell. I've tested AXI Ethernet and it works fine.

Regards,
Harini
