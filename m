Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7686DDBE4
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjDKNQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjDKNQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:16:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB51DE7C
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681218968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=65PIpy4Fo017P9Ewq+jSXe0ekV1mHG3Go0w7yGOYFXo=;
        b=NMzbmPSGv5lsZDETucUSz8HPCfvJ9qwKWu9YMyeiMGDKzt0eh/62vg90BLkox80b0HT33N
        1J4eIJW9m0DLM8N1fQ8nyHV9IASlCbae5q8U+Ji0pKLNZrv+LF5EfI5vZQUCtHv88+GKi/
        mZ8OAYXLl8PpkxRHLH951JZdAukVuTM=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-ptn5wBm_NAK5TNxmk2US7Q-1; Tue, 11 Apr 2023 09:16:07 -0400
X-MC-Unique: ptn5wBm_NAK5TNxmk2US7Q-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-b8ee07f380aso187384276.1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:16:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681218967;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=65PIpy4Fo017P9Ewq+jSXe0ekV1mHG3Go0w7yGOYFXo=;
        b=0WS7ShMzAY1BrYU3yDu9AQnI7TlOhy0iyRSRs8XcEP7c55oNsWrPZkIWLadN0A0iKr
         GO5LEE/6RvEKk0cjkx2q7wBEowuMU99iQOANx6qxz7RbnBUKNmZqHeWiUtJsh/wzk22K
         I/CBauv3zCcMdv5/SugDPhmbaSP3qeN+LPsitvg8ILlan8qBEuZDnZRLZAxgafgftbJB
         3O7VMbp5JqwGJC5i6qlRxzNahC0ciM+EW5e5TUaeDTwGcSoKmDg+B3+9X7Imd9hbQECZ
         tFnHoZ0urnsJj8Ct6R2JlPb4azUeSTwaNH0z5eKLokvhd8WqJmpUk8+RdtegaeGSEuIz
         FPlA==
X-Gm-Message-State: AAQBX9e9mx13HR7/0lCkO/nmN+BvNLtL4ity1QdouDuXPVS+ZBEb4NlS
        Zmg6NA1+s3v7qXMb0siaxj6U5WrRHnv41bQKp/Xjr5DgBk9iIoPwWoArpKL689hJWeGS6bd9zl9
        GtzUpHPL6EjmR/8F2
X-Received: by 2002:a25:ad65:0:b0:b8f:2258:a4d9 with SMTP id l37-20020a25ad65000000b00b8f2258a4d9mr1572204ybe.0.1681218966701;
        Tue, 11 Apr 2023 06:16:06 -0700 (PDT)
X-Google-Smtp-Source: AKy350bcJp1EL0kh9WfurAeUa23/WA0DCHGOQMqC4gQUclro08FTcMd90O7JjKKUuxS7+Zr9P6vPkA==
X-Received: by 2002:a25:ad65:0:b0:b8f:2258:a4d9 with SMTP id l37-20020a25ad65000000b00b8f2258a4d9mr1572169ybe.0.1681218966324;
        Tue, 11 Apr 2023 06:16:06 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-96.dyn.eolo.it. [146.241.239.96])
        by smtp.gmail.com with ESMTPSA id q17-20020a37f711000000b007468765b411sm3940487qkj.45.2023.04.11.06.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 06:16:05 -0700 (PDT)
Message-ID: <cda1f9a630516ab8d02454cd052cb03b35d1b279.camel@redhat.com>
Subject: Re: [-net-next v11 5/6] net: stmmac: Add glue layer for StarFive
 JH7110 SoC
From:   Paolo Abeni <pabeni@redhat.com>
To:     Guo Samin <samin.guo@starfivetech.com>,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        Arun.Ramadoss@microchip.com
Cc:     linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Pedro Moreira <pmmoreir@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
Date:   Tue, 11 Apr 2023 15:16:00 +0200
In-Reply-To: <62fc36bc-7e43-0214-85d7-be66748a901b@starfivetech.com>
References: <20230407110356.8449-1-samin.guo@starfivetech.com>
         <20230407110356.8449-6-samin.guo@starfivetech.com>
         <CAJM55Z9jCdPASsk+fw_j+9QH3+Kj28tpCA4PgW_nB_ce7qWL8w@mail.gmail.com>
         <b8764e20-f983-177c-63c5-36bb3b57ba9e@starfivetech.com>
         <CAJM55Z8jSPz70ri_sFnKMjZDoNvoA=K-o7VCeAMmXztzOKRxaA@mail.gmail.com>
         <62fc36bc-7e43-0214-85d7-be66748a901b@starfivetech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-04-10 at 16:29 +0800, Guo Samin wrote:
> Re: [-net-next v11 5/6] net: stmmac: Add glue layer for StarFive JH7110 S=
oC
> From: Emil Renner Berthing <emil.renner.berthing@canonical.com>
> to: Guo Samin <samin.guo@starfivetech.com>
> data: 2023/4/9
>=20
> > On Sat, 8 Apr 2023 at 03:16, Guo Samin <samin.guo@starfivetech.com> wro=
te:
> > >=20
> > >  Re: [-net-next v11 5/6] net: stmmac: Add glue layer for StarFive JH7=
110 SoC
> > > From: Emil Renner Berthing <emil.renner.berthing@canonical.com>
> > > to: Samin Guo <samin.guo@starfivetech.com>
> > > data: 2023/4/8
> > >=20
> > > > On Fri, 7 Apr 2023 at 13:05, Samin Guo <samin.guo@starfivetech.com>=
 wrote:
> > > > >=20
> > > > > This adds StarFive dwmac driver support on the StarFive JH7110 So=
C.
> > > > >=20
> > > > > Tested-by: Tommaso Merciai <tomm.merciai@gmail.com>
> > > > > Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
> > > > > Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> > > > > Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> > > > > ---
> > > > >  MAINTAINERS                                   |   1 +
> > > > >  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
> > > > >  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
> > > > >  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 123 ++++++++++++=
++++++
> > > > >  4 files changed, 137 insertions(+)
> > > > >  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-sta=
rfive.c
> > > > >=20
> > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > > index 6b6b67468b8f..46b366456cee 100644
> > > > > --- a/MAINTAINERS
> > > > > +++ b/MAINTAINERS
> > > > > @@ -19910,6 +19910,7 @@ M:      Emil Renner Berthing <kernel@esmi=
l.dk>
> > > > >  M:     Samin Guo <samin.guo@starfivetech.com>
> > > > >  S:     Maintained
> > > > >  F:     Documentation/devicetree/bindings/net/starfive,jh7110-dwm=
ac.yaml
> > > > > +F:     drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> > > > >=20
> > > > >  STARFIVE JH7100 CLOCK DRIVERS
> > > > >  M:     Emil Renner Berthing <kernel@esmil.dk>
> > > > > diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/driver=
s/net/ethernet/stmicro/stmmac/Kconfig
> > > > > index f77511fe4e87..5f5a997f21f3 100644
> > > > > --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > > > > +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > > > > @@ -165,6 +165,18 @@ config DWMAC_SOCFPGA
> > > > >           for the stmmac device driver. This driver is used for
> > > > >           arria5 and cyclone5 FPGA SoCs.
> > > > >=20
> > > > > +config DWMAC_STARFIVE
> > > > > +       tristate "StarFive dwmac support"
> > > > > +       depends on OF && (ARCH_STARFIVE || COMPILE_TEST)
> > > > > +       select MFD_SYSCON
> > > > > +       default m if ARCH_STARFIVE
> > > > > +       help
> > > > > +         Support for ethernet controllers on StarFive RISC-V SoC=
s
> > > > > +
> > > > > +         This selects the StarFive platform specific glue layer =
support for
> > > > > +         the stmmac device driver. This driver is used for StarF=
ive JH7110
> > > > > +         ethernet controller.
> > > > > +
> > > > >  config DWMAC_STI
> > > > >         tristate "STi GMAC support"
> > > > >         default ARCH_STI
> > > > > diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drive=
rs/net/ethernet/stmicro/stmmac/Makefile
> > > > > index 057e4bab5c08..8738fdbb4b2d 100644
> > > > > --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> > > > > +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> > > > > @@ -23,6 +23,7 @@ obj-$(CONFIG_DWMAC_OXNAS)     +=3D dwmac-oxnas.=
o
> > > > >  obj-$(CONFIG_DWMAC_QCOM_ETHQOS)        +=3D dwmac-qcom-ethqos.o
> > > > >  obj-$(CONFIG_DWMAC_ROCKCHIP)   +=3D dwmac-rk.o
> > > > >  obj-$(CONFIG_DWMAC_SOCFPGA)    +=3D dwmac-altr-socfpga.o
> > > > > +obj-$(CONFIG_DWMAC_STARFIVE)   +=3D dwmac-starfive.o
> > > > >  obj-$(CONFIG_DWMAC_STI)                +=3D dwmac-sti.o
> > > > >  obj-$(CONFIG_DWMAC_STM32)      +=3D dwmac-stm32.o
> > > > >  obj-$(CONFIG_DWMAC_SUNXI)      +=3D dwmac-sunxi.o
> > > > > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c=
 b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> > > > > new file mode 100644
> > > > > index 000000000000..4963d4008485
> > > > > --- /dev/null
> > > > > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> > > > > @@ -0,0 +1,123 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0+
> > > > > +/*
> > > > > + * StarFive DWMAC platform driver
> > > > > + *
> > > > > + * Copyright (C) 2021 Emil Renner Berthing <kernel@esmil.dk>
> > > > > + * Copyright (C) 2022 StarFive Technology Co., Ltd.
> > > > > + *
> > > > > + */
> > > > > +
> > > > > +#include <linux/mfd/syscon.h>
> > > > > +#include <linux/of_device.h>
> > > > > +#include <linux/regmap.h>
> > > > > +
> > > > > +#include "stmmac_platform.h"
> > > > > +
> > > > > +struct starfive_dwmac {
> > > > > +       struct device *dev;
> > > > > +       struct clk *clk_tx;
> > > > > +};
> > > > > +
> > > > > +static void starfive_dwmac_fix_mac_speed(void *priv, unsigned in=
t speed)
> > > > > +{
> > > > > +       struct starfive_dwmac *dwmac =3D priv;
> > > > > +       unsigned long rate;
> > > > > +       int err;
> > > > > +
> > > > > +       rate =3D clk_get_rate(dwmac->clk_tx);
> > > >=20
> > > > Hi Samin,
> > > >=20
> > > > I'm not sure why you added this line in this revision. If it's just=
 to
> > > > not call clk_set_rate on the uninitialized rate, I'd much rather yo=
u
> > > > just returned early and don't call clk_set_rate at all in case of
> > > > errors.
> > > >=20
> > > > > +
> > > > > +       switch (speed) {
> > > > > +       case SPEED_1000:
> > > > > +               rate =3D 125000000;
> > > > > +               break;
> > > > > +       case SPEED_100:
> > > > > +               rate =3D 25000000;
> > > > > +               break;
> > > > > +       case SPEED_10:
> > > > > +               rate =3D 2500000;
> > > > > +               break;
> > > > > +       default:
> > > > > +               dev_err(dwmac->dev, "invalid speed %u\n", speed);
> > > > > +               break;
> > > >=20
> > > > That is skip the clk_get_rate above and just change this break to a=
 return.
> > > >=20
> > >=20
> > > Hi Emil,
> > >=20
> > > We used the solution you mentioned before V3, but Arun Ramadoss doesn=
't think that's great.
> > > (https://patchwork.kernel.org/project/linux-riscv/patch/2023010603000=
1.1952-6-yanhong.wang@starfivetech.com)
> > >=20
> > >=20
> > > > +static void starfive_eth_plat_fix_mac_speed(void *priv, unsigned i=
nt
> > > > speed)
> > > > +{
> > > > +     struct starfive_dwmac *dwmac =3D priv;
> > > > +     unsigned long rate;
> > > > +     int err;
> > > > +
> > > > +     switch (speed) {
> > > > +     case SPEED_1000:
> > > > +             rate =3D 125000000;
> > > > +             break;
> > > > +     case SPEED_100:
> > > > +             rate =3D 25000000;
> > > > +             break;
> > > > +     case SPEED_10:
> > > > +             rate =3D 2500000;
> > > > +             break;
> > > > +     default:
> > > > +             dev_err(dwmac->dev, "invalid speed %u\n", speed);
> > > > +             return;
> > >=20
> > > Do we need to return value, since it is invalid speed. But the return
> > > value of function is void.(Arun Ramadoss)
> > >=20
> > >=20
> > > So in v9, after discussing with Jakub Kicinski, the clk_set_rate was =
used to initialize the rate.
> > > (It is a reference to Intel's scheme:    dwmac-intel-plat.c: kmb_eth_=
fix_mac_speed)
> > > (https://patchwork.kernel.org/project/linux-riscv/patch/2023032806200=
9.25454-6-samin.guo@starfivetech.com)
> > >=20
> >=20
> > Yeah, I think this is a misunderstanding and Arun is considering if we
> > ought to return the error which we can't without changing generic
> > dwmac code, and Jakub is rightly concerned about using a local
> > variable uninitialized. I don't think anyone is suggesting that
> > getting the rate just to set it to the exact same value is better than
> > just leaving the clock alone.
> >=20
> HI Emil,
>=20
> Yeah, return early saves time and code complexity, and seems like a good =
solution so Yanhong did the same before v3. (Jakub has suggested it before)=
,
> I wonder if Arun or other maintainers accept this solution or if there ar=
e other solutions?

I think is not a big deal either way.

To avoid too much back and forth I'll stick to the current code.

Please address Emil comment on patch 6/6

Thanks!

Paolo

