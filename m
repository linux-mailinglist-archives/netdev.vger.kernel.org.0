Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572018BCBE
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 17:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbfHMPNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 11:13:32 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:33215 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729060AbfHMPNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 11:13:32 -0400
Received: by mail-yw1-f65.google.com with SMTP id e65so2578221ywh.0;
        Tue, 13 Aug 2019 08:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FTYkGKgYhTTZj8By3iaUad49bD86jov+/Fpt329FbJ0=;
        b=Kh/7+mAR0mIyZVcBOyeEfuaaFS1jIRa1wObt9SR0D+czgvWCV3YJefbtDS6k55wvbc
         4jEW7X5qmo/vq21NfelMYHknugBC0wLCO8v7xHGAjcCREdwtp//aRed6xOBKDbFzmkUM
         ygg3Vg6Js0qzww4kttodWXUq1hAVqJugFe9FtgvcfzwXK7oEyQtQcYjqC7hjZyYDySkG
         HIp3+PfvC9jmrcxekz6cfwc8qf/PQM2DkS2F54dDWpsIJfjh/gabW2yc/Skv9FvytMUe
         ImgJWWhcLj5pSA42pLlZwZLLY1txc8ljUmW4EOeyCdftC/Wcj1vyPPb6B+3YnCj9W5V8
         7dSA==
X-Gm-Message-State: APjAAAXxKNT+MPe9hlhOVVsmbreY3noQuz+xZn+3bqHJ8BGOifi36CSM
        RkOk2iwZ/Qig5iocPJUYsaVXyz7F+9dP2/9TDSg=
X-Google-Smtp-Source: APXvYqy1sMez9DxbNJVSH5PIRFadr0u7kJ0Tz2PDNYCQtLnwDiuIswKmK8DTC1SGMEQtgrGSsENSvwLCDiZUp/KH0pI=
X-Received: by 2002:a81:83c3:: with SMTP id t186mr23040734ywf.372.1565709211239;
 Tue, 13 Aug 2019 08:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <1564565779-29537-1-git-send-email-harini.katakam@xilinx.com>
 <1564565779-29537-3-git-send-email-harini.katakam@xilinx.com>
 <20190801040648.GJ2713@lunn.ch> <CAFcVEC+DyVhLzbMdSDsadivbnZJxSEg-0kUF5_Q+mtSbBnmhSA@mail.gmail.com>
 <20190813132321.GF15047@lunn.ch>
In-Reply-To: <20190813132321.GF15047@lunn.ch>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 13 Aug 2019 20:43:19 +0530
Message-ID: <CAFcVECKipjD9atgEJSf8j78q_1aOAX77nD6vVeytZ-M00qBt6A@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: gmii2rgmii: Switch priv field in mdio device structure
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        radhey.shyam.pandey@xilinx.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Aug 13, 2019 at 6:54 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Aug 13, 2019 at 04:46:40PM +0530, Harini Katakam wrote:
> > Hi Andrew,
> >
> > On Thu, Aug 1, 2019 at 9:36 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Wed, Jul 31, 2019 at 03:06:19PM +0530, Harini Katakam wrote:
> > > > Use the priv field in mdio device structure instead of the one in
> > > > phy device structure. The phy device priv field may be used by the
> > > > external phy driver and should not be overwritten.
> > >
> > > Hi Harini
> > >
> > > I _think_ you could use dev_set_drvdata(&mdiodev->dev) in xgmiitorgmii_probe() and
> > > dev_get_drvdata(&phydev->mdiomdio.dev) in _read_status()
> >
> > Thanks for the review. This works if I do:
> > dev_set_drvdata(&priv->phy_dev->mdio.dev->dev) in probe
> > and then
> > dev_get_drvdata(&phydev->mdio.dev) in _read_status()
> >
> > i.e mdiodev in gmii2rgmii probe and priv->phy_dev->mdio are not the same.
> >
> > If this is acceptable, I can send a v2.
>
> Hi Harini
>
> I think this is better, making use of the central driver
> infrastructure, rather than inventing something new.

Ok sure.

>
> The kernel does have a few helper, spi_get_drvdata, pci_get_drvdata,
> hci_get_drvdata. So maybe had add phydev_get_drvdata(struct phy_device
> *phydev)?

Maybe phydev_mdio_get_drvdata? Because the driver data member available is
phydev->mdio.dev.driver_data.

Regards,
Harini
