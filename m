Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1331F55E
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 08:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhBSHbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 02:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhBSHbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 02:31:23 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D338CC061574
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 23:30:42 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id k1so1017103vkb.11
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 23:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mgaPKM7X6IZ4BZS633QUkOiLClmxn3Aw7snlzzOE+HE=;
        b=JwKtmAxJcFebMuMbt+tCFAuG3Pq8MGMy3wIx/jt/nBWsOUcExfiXwEPZKfgIG3kuOh
         gedJVXR0MB/oxP9xZuFkBKkr/dhMj32jT3JTFqVuOCmmgtb7YV8nz3lHBIA7qSK7JGKR
         EOoOMjCe7TPWiV4NlTiSwvsIe5MmOqLcJOMVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mgaPKM7X6IZ4BZS633QUkOiLClmxn3Aw7snlzzOE+HE=;
        b=LvxM9s+DSVEGDKwOZqsvGiIqo5QFoAG2pGCCbzbQzDqsbefDS8Q9sx4uD9NTiw2wH1
         eI0Ly14jh4XKWPaCHs1B4SDDSseDFfEpQwoCKZvvjNjxaP/Jjq1Bkyur/v803JZyfpln
         mO8r6fa/HiHAjbm2qF3pIdprbybzXf/lGTgsvZA/oQBabNUyLCzMIvKa1YAfBUo8n5yi
         v9m4UZbOoMicUZ6cfmcixC8xpJ3vwT+/vKqtFTYVvuNHYyS+HInYg2IkcaWtbf0c8QJ3
         ukk5xHRyAMDa0Ode37iBInzaJo2Rsd9AUh39Pt5L7wYoLPcLrsAuHbkq2eo9EYhU4Stf
         QHzg==
X-Gm-Message-State: AOAM531gWm0ZUlo0fbmUcpBda1ZA13DmplFkUzJvGTf3Cztbodus1+cy
        spO9cthpxOBuJIJRplIHkN5fKowYlko3KUQ3GrIFdeAKv01mUtlT
X-Google-Smtp-Source: ABdhPJxlGSimiYFp4RRQBFnj52NbJgeElwaejcUiyg7f+Dsea+kl/6Vj5023sbURyCb64vfbj6AZ9CQA/cCs0s6v9VA=
X-Received: by 2002:a1f:1c4c:: with SMTP id c73mr6190764vkc.22.1613719840839;
 Thu, 18 Feb 2021 23:30:40 -0800 (PST)
MIME-Version: 1.0
References: <20210218102038.2996-1-oneukum@suse.com> <20210218102038.2996-4-oneukum@suse.com>
In-Reply-To: <20210218102038.2996-4-oneukum@suse.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Fri, 19 Feb 2021 07:30:29 +0000
Message-ID: <CANEJEGvsYPmnxx2sV89aLPJzK_SgWEW8FPhgo2zNk2d5zijK2Q@mail.gmail.com>
Subject: Re: [PATCHv3 3/3] CDC-NCM: record speed in status method
To:     Oliver Neukum <oneukum@suse.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Andrew Lunn <andrew@lunn.ch>, davem@davemloft.org,
        Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 10:21 AM Oliver Neukum <oneukum@suse.com> wrote:
>
> The driver has a status method for receiving speed updates.
> The framework, however, had support functions only for devices
> that reported their speed upon an explicit query over a MDIO
> interface.
> CDC_NCM however gets direct notifications from the device.
> As new support functions have become available, we shall now
> record such notifications and tell the usbnet framework
> to make direct use of them without going through the PHY layer.

Since this patch is missing the hunks that landed in the previous
patch and needs a v4, I'll offer my version of the commit message in
case you like it better:
    net: cdc_ncm: record speed in status method

    Until very recently, the usbnet framework only had support functions
    for devices which reported the link speed by explicitly querying the
    PHY over a MDIO interface. However, the cdc_ncm devices send
    notifications when the link state or link speeds change and do not
    expose the PHY (or modem) directly.

    Support functions (e.g. usbnet_get_link_ksettings_internal()) to directly
    query state recorded by the cdc_ncm driver were added in a previous patch.

    So instead of cdc_ncm spewing the link speed into the dmesg buffer,
    record the link speed encoded in these notifications and tell the
    usbnet framework to use the new functions to get link speed.

    This is especially useful given all existing RTL8156 devices emit
    a connection/speed status notification every 32ms and this would
    fill the dmesg buffer. This implementation replaces the one
    recently submitted in de658a195ee23ca6aaffe197d1d2ea040beea0a2 :
       "net: usb: cdc_ncm: don't spew notifications"

cheers,
grant

> v2: rebased on upstream
> v3: changed variable names
>
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Tested-by: Roland Dreier <roland@kernel.org>
> ---
>  drivers/net/usb/cdc_ncm.c | 23 +----------------------
>  1 file changed, 1 insertion(+), 22 deletions(-)
>
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 0d26cbeb6e04..74c1a86b1a71 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -1829,30 +1829,9 @@ cdc_ncm_speed_change(struct usbnet *dev,
>         uint32_t rx_speed = le32_to_cpu(data->DLBitRRate);
>         uint32_t tx_speed = le32_to_cpu(data->ULBitRate);
>
> -       /* if the speed hasn't changed, don't report it.
> -        * RTL8156 shipped before 2021 sends notification about every 32ms.
> -        */
> -       if (dev->rx_speed == rx_speed && dev->tx_speed == tx_speed)
> -               return;
> -
> +        /* RTL8156 shipped before 2021 sends notification about every 32ms. */
>         dev->rx_speed = rx_speed;
>         dev->tx_speed = tx_speed;
> -
> -       /*
> -        * Currently the USB-NET API does not support reporting the actual
> -        * device speed. Do print it instead.
> -        */
> -       if ((tx_speed > 1000000) && (rx_speed > 1000000)) {
> -               netif_info(dev, link, dev->net,
> -                          "%u mbit/s downlink %u mbit/s uplink\n",
> -                          (unsigned int)(rx_speed / 1000000U),
> -                          (unsigned int)(tx_speed / 1000000U));
> -       } else {
> -               netif_info(dev, link, dev->net,
> -                          "%u kbit/s downlink %u kbit/s uplink\n",
> -                          (unsigned int)(rx_speed / 1000U),
> -                          (unsigned int)(tx_speed / 1000U));
> -       }
>  }
>
>  static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
> --
> 2.26.2
>
