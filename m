Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B3C45B7FD
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 11:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240626AbhKXKJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 05:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbhKXKJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 05:09:07 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C117C061574;
        Wed, 24 Nov 2021 02:05:58 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id p4so2214768qkm.7;
        Wed, 24 Nov 2021 02:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OjRtNyQ6raL8RvlGNtWJ01DJpJ/kv1Yhqrl5JLjQHYQ=;
        b=bGMI67JWqh5edskOztk07XMljM3mU8bZWP0spIe4BmPuNUGVzE5WkRRwdEZ9A0/wUS
         2sOveFUxgck7Vu40CTdO+Ys9OMIz9Mmh8Y5j+T2C3KYJIObL+W+aN4Hr9syX/aZU4pTl
         6MU0gxy37t+OGdOMXEStV717WdO2tmR0p2K0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OjRtNyQ6raL8RvlGNtWJ01DJpJ/kv1Yhqrl5JLjQHYQ=;
        b=vhd/3TEw39uPRdIjxQZeh4Q8KxUEiA5cyOgAqmHXHnelYp3fuJPt/0unJNNcvf1JO9
         GdHXTAzRIedARRUeIHN779nGHkq8ZeVcbTRX98QrfpMvNdTv6KyUONHEMPJ/AFxvPdKh
         l2gLPrRIBsBNLMJewL/qLywXY96KwAiGDWnPJ1rguS4+vofyjBEA7CGq420VRW3TS2AT
         clwzmYofqxPiIkZrlrZFt3pE0BO9UXqhVZVTx3x7hgmWib7prqXEyK6KSbTbqcTSSiw2
         jKsz3pRgj2YiQR5GCjsJOj6gVp7iA4MWCrQSkLHiqxrFUxxeq/NT6DigW/aYVMNH3G89
         j2/A==
X-Gm-Message-State: AOAM5325Lovi36smKv7VqiULXMgCdspGxS8gFOB9OeHYieeLXHa4oWaa
        /1Qx0abGADa2RdcpAHVTVzOr7klxhryFisu1fqE=
X-Google-Smtp-Source: ABdhPJy5dM73ZzwuO7N5M6V2CcGuSCoYtcmQT3DfxOPj0vj8YZRetiDRfVGgCVBDrDAqWgAeUDge6MnvSSPtl5haYC0=
X-Received: by 2002:a37:a8e:: with SMTP id 136mr4514246qkk.395.1637748357381;
 Wed, 24 Nov 2021 02:05:57 -0800 (PST)
MIME-Version: 1.0
References: <20211124061057.12555-1-dylan_hung@aspeedtech.com>
In-Reply-To: <20211124061057.12555-1-dylan_hung@aspeedtech.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 24 Nov 2021 10:05:45 +0000
Message-ID: <CACPK8Xc8aD8nY0M442=BdvrpRhYNS1HW7BNQgAQ+ExTfQMsMyQ@mail.gmail.com>
Subject: Re: [PATCH] net:phy: Fix "Link is Down" issue
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, hkallweit1@gmail.com,
        Andrew Lunn <andrew@lunn.ch>, BMC-SW <BMC-SW@aspeedtech.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 at 06:11, Dylan Hung <dylan_hung@aspeedtech.com> wrote:
>
> The issue happened randomly in runtime.  The message "Link is Down" is
> popped but soon it recovered to "Link is Up".
>
> The "Link is Down" results from the incorrect read data for reading the
> PHY register via MDIO bus.  The correct sequence for reading the data
> shall be:
> 1. fire the command
> 2. wait for command done (this step was missing)
> 3. wait for data idle
> 4. read data from data register

I consulted the datasheet and it doesn't mention this. Perhaps
something to be added?

Reviewed-by: Joel Stanley <joel@jms.id.au>

>
> Fixes: a9770eac511a ("net: mdio: Move MDIO drivers into a new subdirectory")

I think this should be:

Fixes: f160e99462c6 ("net: phy: Add mdio-aspeed")

We should cc stable too.

> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> ---
>  drivers/net/mdio/mdio-aspeed.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
> index cad820568f75..966c3b4ad59d 100644
> --- a/drivers/net/mdio/mdio-aspeed.c
> +++ b/drivers/net/mdio/mdio-aspeed.c
> @@ -61,6 +61,13 @@ static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
>
>         iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
>
> +       rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
> +                               !(ctrl & ASPEED_MDIO_CTRL_FIRE),
> +                               ASPEED_MDIO_INTERVAL_US,
> +                               ASPEED_MDIO_TIMEOUT_US);
> +       if (rc < 0)
> +               return rc;
> +
>         rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_DATA, data,
>                                 data & ASPEED_MDIO_DATA_IDLE,
>                                 ASPEED_MDIO_INTERVAL_US,
> --
> 2.25.1
>
