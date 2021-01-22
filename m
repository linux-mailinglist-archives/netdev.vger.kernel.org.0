Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51712FFAC8
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 04:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbhAVDDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 22:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbhAVDDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 22:03:16 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E559C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 19:02:35 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id t15so1385517ual.6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 19:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a8+5Gm76y+b0jt2/jBQKKYc91WSpLxV2qAWcOQhFTbY=;
        b=n8H3wqeiuIjVOpELBQ8Z4PFvlxBpYqz3yetbaBoCZfuX/vTdUaOmXWpOWFOclUfyz8
         TrLcf+HwJtRfiw9Lao24FzFUZnRsZMRHGb7rjfWqmAXODIkJAGjrca37EM8vLaSizI7s
         Z+gpjc714T9DNkvIU2l7UAeA5AMAoTfpGt+lc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a8+5Gm76y+b0jt2/jBQKKYc91WSpLxV2qAWcOQhFTbY=;
        b=YnlkyOUyAdKnBaaWJtfD2edZgtZoXwtpLHP7kJ4fTO6KQdof4hElEF+GoWg8ZJlSbk
         y0D0iWohpkpS1yMfhmYYGaUeNBp/cLVRGqkSb8/6t79FjdRkYuFp6QDiQbC4JY6MSOa2
         rAusrE3NKUdlmW4VeEIjFxWEcfrH/SrP1jQLdqHLKd0QAZHzFYHRqalunRR8yyFZnsV1
         yBP1orStaZIh4BFZ2x0tHnq4u/kcBxPPWl/ZhshTiqeIjdWKwqVp5RBhy3z/elI8aVH8
         QAnxxiTDw63HcQCN0+0YAY1J8R/9/1w1NND36eHq14xH4ZbyruVyHDuHMtYfKcIhgEbJ
         ayFA==
X-Gm-Message-State: AOAM531z6JmDu9mykEbowYjzsGhmQdev67cCiSOQ04PbU4Hh49x7FiCu
        rllI41IkiZSohAItLMzi8WGfANGi9Xvt+HaDXQZaeA==
X-Google-Smtp-Source: ABdhPJyjjKeglVrq0ENqYc+6xUuuW5J9nEkjLxVZgWtLQTJFddnRviMdPkrIGbHTqpjdXi2uTNOzE5LNAqb8aouMHiU=
X-Received: by 2002:ab0:7193:: with SMTP id l19mr62551uao.84.1611284554145;
 Thu, 21 Jan 2021 19:02:34 -0800 (PST)
MIME-Version: 1.0
References: <20210121125731.19425-1-oneukum@suse.com> <20210121125731.19425-4-oneukum@suse.com>
In-Reply-To: <20210121125731.19425-4-oneukum@suse.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Fri, 22 Jan 2021 03:02:23 +0000
Message-ID: <CANEJEGsGr8VMCDLAviTXJ9wkRs8R3t79ccqmK3+CJ8cpAD=hdg@mail.gmail.com>
Subject: Re: [PATCHv2 3/3] CDC-NCM: record speed in status method
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Hayes Wang <hayeswang@realtek.com>,
        Grant Grundler <grundler@chromium.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        Roland Dreier <roland@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 12:57 PM Oliver Neukum <oneukum@suse.com> wrote:
>
> The driver has a status method for receiving speed updates.
> The framework, however, had support functions only for devices
> that reported their speed upon an explicit query over a MDIO
> interface.
> CDC_NCM however gets direct notifications from the device.
> As new support functions have become available, we shall now
> record such notifications and tell the usbnet framework
> to make direct use of them without going through the PHY layer.
>
> v2: adjusted to recent changes
>
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Tested-by: Roland Dreier <roland@kernel.org>
> ---
>  drivers/net/usb/cdc_ncm.c | 29 ++++-------------------------
>  1 file changed, 4 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 04174704bf7c..9b5bb8ae5eb8 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -142,7 +142,7 @@ static const struct ethtool_ops cdc_ncm_ethtool_ops = {
>         .get_sset_count    = cdc_ncm_get_sset_count,
>         .get_strings       = cdc_ncm_get_strings,
>         .get_ethtool_stats = cdc_ncm_get_ethtool_stats,
> -       .get_link_ksettings      = usbnet_get_link_ksettings_mdio,
> +       .get_link_ksettings      = usbnet_get_link_ksettings_internal,
>         .set_link_ksettings      = usbnet_set_link_ksettings_mdio,
>  };
>
> @@ -1827,30 +1827,9 @@ cdc_ncm_speed_change(struct usbnet *dev,
>         uint32_t rx_speed = le32_to_cpu(data->DLBitRRate);
>         uint32_t tx_speed = le32_to_cpu(data->ULBitRate);
>
> -       /* if the speed hasn't changed, don't report it.
> -        * RTL8156 shipped before 2021 sends notification about every 32ms.
> -        */
> -       if (dev->rx_speed == rx_speed && dev->tx_speed == tx_speed)
> -               return;
> -
> -       dev->rx_speed = rx_speed;
> -       dev->tx_speed = tx_speed;

Oliver,
This patch removes the use of "rx_speed" field but doesn't remove the
field from struct usbnet (usbnet.h).

It might be better to revert my patch (make that the first patch in
your series) and use your original patches.
OR use "rx_speed" as the field name in the entire series and move them
to the preferred location in struct usbnet (patch 2/3).

cheers,
grant

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
> +        /* RTL8156 shipped before 2021 sends notification about every 32ms. */
> +       dev->rxspeed = rx_speed;
> +       dev->txspeed = tx_speed;
>  }
>
>  static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
> --
> 2.26.2
>
