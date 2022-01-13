Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B392648D581
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 11:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbiAMKOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 05:14:51 -0500
Received: from mail-vk1-f170.google.com ([209.85.221.170]:46994 "EHLO
        mail-vk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiAMKOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 05:14:51 -0500
Received: by mail-vk1-f170.google.com with SMTP id bj47so3443541vkb.13;
        Thu, 13 Jan 2022 02:14:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YhBkWwODLg+bweh284yAfzMoSG22QfOafIB3DBYs9Fw=;
        b=Dw052GcjQPkk5jpV3hVpS7Sg3mjH+e2iIuK9fC+D7xEj9rC3fxtOenYn2PNIbpERW0
         /zxphP9ba0lDNO/EeL6zrlygttR2EEInPoKKR+QxXA9HflvKFGtt5oUJyKxo+RTdeAEE
         goAuFK1XuPJC/iF2FmVJEx+qA51hGzG6dwtvpLj3uZIllu7SJpUvE96+C7Nx+SBMXuhd
         Z9ewR5lRDiEwjzfTy5OYzjrEgzm8V9Ec74xacWwhn7XTKkewn4hVCc4Xqy42boB60tQO
         //EYI/qn5U/mPrwAWEhSuoSqFyrxKGGtYr0mZ9CFi+7uWMSH4e7CWZ4fLszqUvOdpyiJ
         OGJg==
X-Gm-Message-State: AOAM532646UScbeHKaAMSSQxZj9FirS7mrM80rSLFn1+F91A/6mr8XP9
        b9t+Wb30cIrYhpziQar1UmPad9tas1glD3+6L54=
X-Google-Smtp-Source: ABdhPJwup1L0UDnLIccvvhXG7M3j2cjKCwuOX0w+us6dHp9zIWRgpO3J4p282pPnbB8XWB3lfPwI7u6gZUN5R3nhwjo=
X-Received: by 2002:a05:6122:c93:: with SMTP id ba19mr2049734vkb.12.1642068890328;
 Thu, 13 Jan 2022 02:14:50 -0800 (PST)
MIME-Version: 1.0
References: <20220112181113.875567-1-robert.hancock@calian.com>
 <20220112181113.875567-3-robert.hancock@calian.com> <3caae1db-b577-1e1f-3377-11272945054c@xilinx.com>
In-Reply-To: <3caae1db-b577-1e1f-3377-11272945054c@xilinx.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Thu, 13 Jan 2022 15:44:39 +0530
Message-ID: <CAFcVECJavcDzHyi2MiM1kkYqsm=W8zTN4QWMx1fuZkXRS936JQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: macb: Added ZynqMP-specific initialization
To:     Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Robert Hancock <robert.hancock@calian.com>,
        netdev <netdev@vger.kernel.org>,
        Piyush Mehta <piyush.mehta@xilinx.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Radhey

Hi Robert,

On Thu, Jan 13, 2022 at 2:46 PM Michal Simek <michal.simek@xilinx.com> wrote:
>
>
>
> On 1/12/22 19:11, Robert Hancock wrote:
> > The GEM controllers on ZynqMP were missing some initialization steps which
> > are required in some cases when using SGMII mode, which uses the PS-GTR
> > transceivers managed by the phy-zynqmp driver.
> >
> > The GEM core appears to need a hardware-level reset in order to work
> > properly in SGMII mode in cases where the GT reference clock was not
> > present at initial power-on. This can be done using a reset mapped to
> > the zynqmp-reset driver in the device tree.
> >
> > Also, when in SGMII mode, the GEM driver needs to ensure the PHY is
> > initialized and powered on when it is initializing.
> >
> > Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> > ---
> >   drivers/net/ethernet/cadence/macb_main.c | 47 +++++++++++++++++++++++-
> >   1 file changed, 46 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > index a363da928e8b..65b0360c487a 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -34,7 +34,9 @@
> >   #include <linux/udp.h>
> >   #include <linux/tcp.h>
> >   #include <linux/iopoll.h>
> > +#include <linux/phy/phy.h>
> >   #include <linux/pm_runtime.h>
> > +#include <linux/reset.h>
> >   #include "macb.h"
> >
> >   /* This structure is only used for MACB on SiFive FU540 devices */
> > @@ -4455,6 +4457,49 @@ static int fu540_c000_init(struct platform_device *pdev)
> >       return macb_init(pdev);
> >   }
> >
> > +static int zynqmp_init(struct platform_device *pdev)
> > +{
> > +     struct net_device *dev = platform_get_drvdata(pdev);
> > +     struct macb *bp = netdev_priv(dev);
> > +     int ret;
> > +
> > +     /* Fully reset GEM controller at hardware level using zynqmp-reset driver,
> > +      * if mapped in device tree.
> > +      */
> > +     ret = device_reset(&pdev->dev);
> > +     if (ret) {
> > +             dev_err_probe(&pdev->dev, ret, "failed to reset controller");
> > +             return ret;
> > +     }
> > +
> > +     if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
> > +             /* Ensure PS-GTR PHY device used in SGMII mode is ready */
> > +             struct phy *sgmii_phy = devm_phy_get(&pdev->dev, "sgmii-phy");
> > +
> > +             if (IS_ERR(sgmii_phy)) {
> > +                     ret = PTR_ERR(sgmii_phy);
> > +                     dev_err_probe(&pdev->dev, ret,
> > +                                   "failed to get PS-GTR PHY\n");
> > +                     return ret;
> > +             }
> > +
> > +             ret = phy_init(sgmii_phy);
> > +             if (ret) {
> > +                     dev_err(&pdev->dev, "failed to init PS-GTR PHY: %d\n",
> > +                             ret);
> > +                     return ret;
> > +             }
>
> I was playing with it recently on u-boot side and device reset should happen
> between phy init and phy power on to finish calibration.
> At least that's I was told and that's I use in u-boot driver.
>
> Harini/Piyush: Please correct me if I am wrong.

Thanks for the patch.

GEM should definitely be reset once after the serdes init and power on is done.
It can be held in reset and released after serdes init or reset with a 1-0 after
serdes init. Either should be fine but a reset before phy init may not work.
I've added Radhey who worked on this recently and can add any further info.

Regards,
Harini
