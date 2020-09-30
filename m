Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B25927E870
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 14:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgI3MVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 08:21:43 -0400
Received: from mail-oo1-f67.google.com ([209.85.161.67]:35138 "EHLO
        mail-oo1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728232AbgI3MVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 08:21:42 -0400
Received: by mail-oo1-f67.google.com with SMTP id k13so418082oor.2;
        Wed, 30 Sep 2020 05:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YEgxCdX3rAH5lHUw3+UUAJ162eHWPCVqP8JIftX6FNo=;
        b=XKaWO/TEs0oTtYOkL7FNQj7CnOEFzXWviQIxyYNljVSBKdnmyY4IJdTNCZ50g1YgUB
         PkqwDTk3tp6UlEXA9C1qb3sGIcxe+GHLu7CtnPnbVprI10PWHiOUpxJ4gfFwhEqJ1NGi
         JPNKLSvAjJIvqOj/PHq0zsiJEHwMUNDXTeVGpH0iFnC8uv3+LjwhroFOV31Tv8+eaCaC
         TacX88j28aZQQJlC2HYajJLTwH8c1Eou4saRj27fSchBuPc2SdWLkEQ743IOgWMo1WYK
         MIke4RHCtkj5LpH/QP9lgMdTkVMB9bIEqGvNSOu188dzw36pqUb24krPE09Lo08e0IZO
         cp7A==
X-Gm-Message-State: AOAM530PXjGsi0ZOL75tT3B3zTe8NGA3dG2rpyv74A6OLQiUfvjYMNdI
        CuHvIdpahKBjfk95OJaXEnHEFtXPK9dlmR5J2cY=
X-Google-Smtp-Source: ABdhPJzLMUeyo2RdooHxaEgwwg50UkkbVNr+eZ+KLROrYvzc91lw1WbUar+pXFO9w5zVt/YCWTbDkUNDfpGlaFIHPS8=
X-Received: by 2002:a4a:e616:: with SMTP id f22mr1799785oot.11.1601468501619;
 Wed, 30 Sep 2020 05:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200917135707.12563-1-geert+renesas@glider.be>
In-Reply-To: <20200917135707.12563-1-geert+renesas@glider.be>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 30 Sep 2020 14:21:30 +0200
Message-ID: <CAMuHMdU2k5MmUe2_g7a9268XG2=9phiWoaSTeQ9ZbxoAs3QFfw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 0/5] net/ravb: Add support for explicit
 internal clock delay configuration
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

On Thu, Sep 17, 2020 at 3:57 PM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Some Renesas EtherAVB variants support internal clock delay
> configuration, which can add larger delays than the delays that are
> typically supported by the PHY (using an "rgmii-*id" PHY mode, and/or
> "[rt]xc-skew-ps" properties).
>
> Historically, the EtherAVB driver configured these delays based on the
> "rgmii-*id" PHY mode.  This caused issues with PHY drivers that
> implement PHY internal delays properly[1].  Hence a backwards-compatible
> workaround was added by masking the PHY mode[2].
>
> This patch series implements the next step of the plan outlined in [3],
> and adds proper support for explicit configuration of the MAC internal
> clock delays using new "[rt]x-internal-delay-ps" properties.  If none of
> these properties is present, the driver falls back to the old handling.
>
> This can be considered the MAC counterpart of commit 9150069bf5fc0e86
> ("dt-bindings: net: Add tx and rx internal delays"), which applies to
> the PHY.  Note that unlike commit 92252eec913b2dd5 ("net: phy: Add a
> helper to return the index for of the internal delay"), no helpers are
> provided to parse the DT properties, as so far there is a single user
> only, which supports only zero or a single fixed value.  Of course such
> helpers can be added later, when the need arises, or when deemed useful
> otherwise.
>
> This series consists of 3 parts:
>   1. DT binding updates documenting the new properties, for both the
>      generic ethernet-controller and the EtherAVB-specific bindings,
>   2. Conversion to json-schema of the Renesas EtherAVB DT bindings.
>      Technically, the conversion is independent of all of the above.
>      I included it in this series, as it shows how all sanity checks on
>      "[rt]x-internal-delay-ps" values are implemented as DT binding
>      checks,
>   3. EtherAVB driver update implementing support for the new properties.
>
> Given Rob has provided his acks for the DT binding updates, all of this
> can be merged through net-next.
>
> Changes compared to v3[4]:
>   - Add Reviewed-by,
>   - Drop the DT updates, as they will be merged through renesas-devel and
>     arm-soc, and have a hard dependency on this series.
>
> Changes compared to v2[5]:
>   - Update recently added board DTS files,
>   - Add Reviewed-by.
>
> Changes compared to v1[6]:
>   - Added "[PATCH 1/7] dt-bindings: net: ethernet-controller: Add
>     internal delay properties",
>   - Replace "renesas,[rt]xc-delay-ps" by "[rt]x-internal-delay-ps",
>   - Incorporated EtherAVB DT binding conversion to json-schema,
>   - Add Reviewed-by.
>
> Impacted, tested:
>   - Salvator-X(S) with R-Car H3 ES1.0 and ES2.0, M3-W, and M3-N.
>
> Not impacted, tested:
>   - Ebisu with R-Car E3.
>
> Impacted, not tested:
>   - Salvator-X(S) with other SoC variants,
>   - ULCB with R-Car H3/M3-W/M3-N variants,
>   - V3MSK and Eagle with R-Car V3M,
>   - Draak with R-Car V3H,
>   - HiHope RZ/G2[MN] with RZ/G2M or RZ/G2N,
>   - Beacon EmbeddedWorks RZ/G2M Development Kit.
>
> To ease testing, I have pushed this series and the DT updates to the
> topic/ravb-internal-clock-delays-v4 branch of my renesas-drivers
> repository at
> git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git.
>
> Thanks for applying!

Is there anything still blocking this series?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
