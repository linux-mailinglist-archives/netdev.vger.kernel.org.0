Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E388941DFBB
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 19:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349838AbhI3RId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 13:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349021AbhI3RIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 13:08:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01C07617E6;
        Thu, 30 Sep 2021 17:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633021609;
        bh=qB28pyd3G9W1jKU1sJvEmXSTCB/fM9hWT/YO9coO46Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lD57I7buZC1D+E/nzOsGe0U6OnyD8kIUuCz9uhE3hVGiL5ivBjtmL2P/Nn7oFn8+A
         VXrPZctdXHc0YQ1Tf3KPhhEsTj9EZhra5W8tNNXYZcYUC65XFTIFCR2Uz23fbx3wew
         vW0IUupDXZrundBUHGdNgTD4y+nj69kh1XiadvJ+RF7V0qlKXy9p1qY5F/Boswqb9T
         8TkWRFWlsqmJiH2FIGnVy30ojkH9FuZuK1q6/1GF9lRs0m2rDrskD8+arwKi/Tm9JS
         IcZoholK/+5AHdWXzh16Ff5a7TEYZolj28BmojKYyw0oV3eB6hCkulag+JZD8mHy9X
         9dBgrdTdFLtMA==
Received: by pali.im (Postfix)
        id A4204E79; Thu, 30 Sep 2021 19:06:46 +0200 (CEST)
Date:   Thu, 30 Sep 2021 19:06:46 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v7 08/24] wfx: add bus_sdio.c
Message-ID: <20210930170646.cffsuytdpa72izbh@pali>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
 <20210920161136.2398632-9-Jerome.Pouiller@silabs.com>
 <CAPDyKFp2_41mScO=-Ev+kvYD5xjShQdLugU_2FTTmvzgCxmEWA@mail.gmail.com>
 <19731906.ZuIkq4dnIL@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19731906.ZuIkq4dnIL@pc-42>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 30 September 2021 18:51:09 Jérôme Pouiller wrote:
> Hello Ulf,
> 
> On Thursday 30 September 2021 12:07:55 CEST Ulf Hansson wrote:
> > On Mon, 20 Sept 2021 at 18:12, Jerome Pouiller
> > <Jerome.Pouiller@silabs.com> wrote:
> > >
> > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > >
> > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > > ---
> > >  drivers/net/wireless/silabs/wfx/bus_sdio.c | 261 +++++++++++++++++++++
> > >  1 file changed, 261 insertions(+)
> > >  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.c
> > >
> > > diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c b/drivers/net/wireless/silabs/wfx/bus_sdio.c
> > 
> > [...]
> > 
> > > +
> > > +static int wfx_sdio_probe(struct sdio_func *func,
> > > +                         const struct sdio_device_id *id)
> > > +{
> > > +       struct device_node *np = func->dev.of_node;
> > > +       struct wfx_sdio_priv *bus;
> > > +       int ret;
> > > +
> > > +       if (func->num != 1) {
> > > +               dev_err(&func->dev, "SDIO function number is %d while it should always be 1 (unsupported chip?)\n",
> > > +                       func->num);
> > > +               return -ENODEV;
> > > +       }
> > > +
> > > +       bus = devm_kzalloc(&func->dev, sizeof(*bus), GFP_KERNEL);
> > > +       if (!bus)
> > > +               return -ENOMEM;
> > > +
> > > +       if (!np || !of_match_node(wfx_sdio_of_match, np)) {
> > > +               dev_warn(&func->dev, "no compatible device found in DT\n");
> > > +               return -ENODEV;
> > > +       }
> > > +
> > > +       bus->func = func;
> > > +       bus->of_irq = irq_of_parse_and_map(np, 0);
> > > +       sdio_set_drvdata(func, bus);
> > > +       func->card->quirks |= MMC_QUIRK_LENIENT_FN0 |
> > > +                             MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
> > > +                             MMC_QUIRK_BROKEN_BYTE_MODE_512;
> > 
> > I would rather see that you add an SDIO_FIXUP for the SDIO card, to
> > the sdio_fixup_methods[], in drivers/mmc/core/quirks.h, instead of
> > this.
> 
> In the current patch, these quirks are applied only if the device appears
> in the device tree (see the condition above). If I implement them in
> drivers/mmc/core/quirks.h they will be applied as soon as the device is
> detected. Is it what we want?
> 
> Note: we already have had a discussion about the strange VID/PID declared
> by this device:
>   https://www.spinics.net/lists/netdev/msg692577.html

Yes, vendor id 0x0000 is invalid per SDIO spec. So based on this vendor
id, it is not possible to write any quirk in mmc/sdio generic code.

Ulf, but maybe it could be possible to write quirk based on OF
compatible string?

Jérôme, could you please notify your hw departement that this sdio card
does not comply with SDIO spec due to incorrect vendor id stored in hw,
so they could fix this issue in next product, by proper allocation of
vendor id number from USB-IF (*)? I know that for existing products it
is not possible to fix, but it can be fixed in next generation of
products based on used SDIO IP.

(*) - USB-IF really allocates SDIO vendor ids, see:
https://lore.kernel.org/linux-mmc/20210607140216.64iuprp3siggslrk@pali/

> 
> [...]
> > > +
> > > +static const struct sdio_device_id wfx_sdio_ids[] = {
> > > +       { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF200) },
> > > +       { },
> > > +};
> > > +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
> > > +
> > > +struct sdio_driver wfx_sdio_driver = {
> > > +       .name = "wfx-sdio",
> > > +       .id_table = wfx_sdio_ids,
> > > +       .probe = wfx_sdio_probe,
> > > +       .remove = wfx_sdio_remove,
> > > +       .drv = {
> > > +               .owner = THIS_MODULE,
> > > +               .of_match_table = wfx_sdio_of_match,
> > 
> > Is there no power management? Or do you intend to add that on top?
> 
> It seems we already have had this discussion:
> 
>   https://lore.kernel.org/netdev/CAPDyKFqJf=vUqpQg3suDCadKrFTkQWFTY_qp=+yDK=_Lu9gJGg@mail.gmail.com/#r
> 
> In this thread, Kalle said:
> > Many mac80211 drivers do so that the device is powered off during
> > interface down (ifconfig wlan0 down), and as mac80211 does interface
> > down automatically during suspend, suspend then works without extra
> > handlers.
> 
> 
> -- 
> Jérôme Pouiller
> 
> 
