Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782021A6333
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 08:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgDMGvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 02:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727546AbgDMGvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 02:51:00 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07086C008651;
        Sun, 12 Apr 2020 23:51:00 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71F3120774;
        Mon, 13 Apr 2020 06:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586760659;
        bh=itKlPWSDIUfhI/V0PdIrWdvWF2mjKklAzi7kXAkEZiI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lW3fo4YIURoALAvNoGs50jvKKZweTovFobX14fD0uBwlVuO4RyTv0pyyCDG7MpSE5
         dnwQO0jwz1kaTBAwdAL3oEbM/3LoOGVflmF3Otd1Du4AeCZasNdsRzrTFIsifP197H
         FXYfFraBDh2np0cyUdjy2ZyLMzx3XOI1ZexOvtYk=
Received: by mail-wm1-f48.google.com with SMTP id y24so8995533wma.4;
        Sun, 12 Apr 2020 23:50:59 -0700 (PDT)
X-Gm-Message-State: AGi0Puatkcsnh6f8zXG8czwHmN17w2u+HBB18tIfEbEotj92iww2p/Mf
        YmDQqiwtJn6VEyn+qLMrtkepIuqC1PYAFJnTwrI=
X-Google-Smtp-Source: APiQypKIXDrIWUMhun56k6+tJYD42DUVxbckoIRpXheJTy2siWfYFqEyrdTvndxnQqeH0hqwHeJDnfIGKI9HD42tuII=
X-Received: by 2002:a05:600c:2214:: with SMTP id z20mr18682592wml.189.1586760657834;
 Sun, 12 Apr 2020 23:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200412034931.9558-1-f.fainelli@gmail.com> <20200412112756.687ff227@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ae06b4c6-6818-c053-6f33-55c96f88a4ae@gmail.com> <BN8PR12MB3266A47DE93CEAEBDB4F288AD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266A47DE93CEAEBDB4F288AD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Mon, 13 Apr 2020 14:50:47 +0800
X-Gmail-Original-Message-ID: <CAGb2v65wjtphcN4DEM4mfv+=U5KUmsTujVoPb9L0idwy=ysDZw@mail.gmail.com>
Message-ID: <CAGb2v65wjtphcN4DEM4mfv+=U5KUmsTujVoPb9L0idwy=ysDZw@mail.gmail.com>
Subject: Re: [PATCH net] net: stmmac: Guard against txfifosz=0
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 2:42 PM Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> From: Florian Fainelli <f.fainelli@gmail.com>
> Date: Apr/12/2020, 19:31:55 (UTC+00:00)
>
> >
> >
> > On 4/12/2020 11:27 AM, Jakub Kicinski wrote:
> > > On Sat, 11 Apr 2020 20:49:31 -0700 Florian Fainelli wrote:
> > >> After commit bfcb813203e619a8960a819bf533ad2a108d8105 ("net: dsa:
> > >> configure the MTU for switch ports") my Lamobo R1 platform which uses
> > >> an allwinner,sun7i-a20-gmac compatible Ethernet MAC started to fail
> > >> by rejecting a MTU of 1536. The reason for that is that the DMA
> > >> capabilities are not readable on this version of the IP, and there is
> > >> also no 'tx-fifo-depth' property being provided in Device Tree. The
> > >> property is documented as optional, and is not provided.
> > >>
> > >> The minimum MTU that the network device accepts is ETH_ZLEN - ETH_HLEN,
> > >> so rejecting the new MTU based on the txfifosz value unchecked seems a
> > >> bit too heavy handed here.
> > >
> > > OTOH is it safe to assume MTUs up to 16k are valid if device tree lacks
> > > the optional property? Is this change purely to preserve backward
> > > (bug-ward?) compatibility, even if it's not entirely correct to allow
> > > high MTU values? (I think that'd be worth stating in the commit message
> > > more explicitly.) Is there no "reasonable default" we could select for
> > > txfifosz if property is missing?
> >
> > Those are good questions, and I do not know how to answer them as I am
> > not familiar with the stmmac HW design, but I am hoping Jose can respond
> > on this patch. It does sound like providing a default TX FIFO size would
> > solve that MTU problem, too, but without a 'tx-fifo-depth' property
> > specified in Device Tree, and with the "dma_cap" being empty for this
> > chip, I have no idea what to set it to.
>
> Unfortunately, allwinner uses GMAC which does not have any mean to detect
> TX FIFO Size. Default value in HW is 2k but this can not be the case in
> these platforms if HW team decided to change it.

I looked at all the publicly available datasheets and Allwinner uses
4K TX FIFO and 16K RX FIFO in all SoCs. Not sure if this would help.

ChenYu

> Anyway, your patch looks sane to me. But if you start seeing TX Queue
> Timeout for higher MTU values then you'll need to add tx-fifo-depth
> property.
>
> ---
> Thanks,
> Jose Miguel Abreu
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
