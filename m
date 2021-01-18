Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1512FAD10
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388062AbhARWDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387897AbhARWD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 17:03:26 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3643C0613CF
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 14:02:45 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id t43so5999855uad.7
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 14:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9BjWeKnLhtX9WXPmjSXlj5EkkOdetRobr1udf+4AmzQ=;
        b=a+9n5eZgCWi/s4vOPejRYrhDUcnrW08Zt0Nbg4Vzc+dhj8SIke/Z96SUBtUSWulSz0
         MUYd3MF5e44z88vDRzUNpWZOO6I4kZHXLwldldcl1xmRhrsd5lodyqaJtcLzk8P/6GoS
         o4N+ejsO0uBBQ1QpQCXmiLNjYZGOd6qC954c0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9BjWeKnLhtX9WXPmjSXlj5EkkOdetRobr1udf+4AmzQ=;
        b=BKv7rIvHCJYl+iLdIMUe2h0sNlOXSUDor2XF6m4xJGcQ8X6dbtVq4noTgKV2ceRDK6
         zz71Dd6GusQ+Z9dvW9StBSI+qXkWQxXbCBqumbtZJdCLx24h8P+zqm7+n0OGZ9cnSXu+
         N8QsrJdsKvOGJoYqsY+gf1Lp1feGIOwNYy4WP6RahCPerZ+Bf0X7pqr3ZQr1XKUav0xR
         JM0+t3zPflwyf9OLDIoGrLKU2wL6FbBr6BdWIymxk4JSH5zIllOeRcGtXePpXiapHMuT
         2KsxD6HE3oaFUT7PHmABgRYGjxru4XXUP8jRo76sF0LA8zXX+Zit9meojvtZ5xgIkKa9
         P0SA==
X-Gm-Message-State: AOAM533F2A+eW8DaHrMsGbUzrljMI5fCCxDe9TXLxXk36cpzZ1Gh1+AO
        E7XrCumEHcDKhqwU3o7gtJsSyYINBwyH+Ofk9iFceA==
X-Google-Smtp-Source: ABdhPJwuKHEEKlq5+7w41SyHuZ4THOU/eaMaoFBLcg0lHoFbaTX6gWLt3qWUpjxuMdkGEK3o+Xzp/yffgED7H2sZRvU=
X-Received: by 2002:ab0:cb:: with SMTP id 69mr821626uaj.10.1611007364845; Mon,
 18 Jan 2021 14:02:44 -0800 (PST)
MIME-Version: 1.0
References: <20210116052623.3196274-1-grundler@chromium.org> <20210116052623.3196274-3-grundler@chromium.org>
In-Reply-To: <20210116052623.3196274-3-grundler@chromium.org>
From:   Grant Grundler <grundler@chromium.org>
Date:   Mon, 18 Jan 2021 22:02:33 +0000
Message-ID: <CANEJEGuDnZ6ujsRnn7xmO-y+SxxqxyaQCJXmHeV3XgfLsA8cDg@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: usb: cdc_ncm: don't spew notifications
To:     Grant Grundler <grundler@chromium.org>,
        nic_swsd <nic_swsd@realtek.com>
Cc:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+nic_swsd [adding per Realtek developer team request]

On Sat, Jan 16, 2021 at 5:27 AM Grant Grundler <grundler@chromium.org> wrote:
>
> RTL8156 sends notifications about every 32ms.
> Only display/log notifications when something changes.
>
> This issue has been reported by others:
>         https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1832472
>         https://lkml.org/lkml/2020/8/27/1083
>
> ...
> [785962.779840] usb 1-1: new high-speed USB device number 5 using xhci_hcd
> [785962.929944] usb 1-1: New USB device found, idVendor=0bda, idProduct=8156, bcdDevice=30.00
> [785962.929949] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=6
> [785962.929952] usb 1-1: Product: USB 10/100/1G/2.5G LAN
> [785962.929954] usb 1-1: Manufacturer: Realtek
> [785962.929956] usb 1-1: SerialNumber: 000000001
> [785962.991755] usbcore: registered new interface driver cdc_ether
> [785963.017068] cdc_ncm 1-1:2.0: MAC-Address: 00:24:27:88:08:15
> [785963.017072] cdc_ncm 1-1:2.0: setting rx_max = 16384
> [785963.017169] cdc_ncm 1-1:2.0: setting tx_max = 16384
> [785963.017682] cdc_ncm 1-1:2.0 usb0: register 'cdc_ncm' at usb-0000:00:14.0-1, CDC NCM, 00:24:27:88:08:15
> [785963.019211] usbcore: registered new interface driver cdc_ncm
> [785963.023856] usbcore: registered new interface driver cdc_wdm
> [785963.025461] usbcore: registered new interface driver cdc_mbim
> [785963.038824] cdc_ncm 1-1:2.0 enx002427880815: renamed from usb0
> [785963.089586] cdc_ncm 1-1:2.0 enx002427880815: network connection: disconnected
> [785963.121673] cdc_ncm 1-1:2.0 enx002427880815: network connection: disconnected
> [785963.153682] cdc_ncm 1-1:2.0 enx002427880815: network connection: disconnected
> ...
>
> This is about 2KB per second and will overwrite all contents of a 1MB
> dmesg buffer in under 10 minutes rendering them useless for debugging
> many kernel problems.
>
> This is also an extra 180 MB/day in /var/logs (or 1GB per week) rendering
> the majority of those logs useless too.
>
> When the link is up (expected state), spew amount is >2x higher:
> ...
> [786139.600992] cdc_ncm 2-1:2.0 enx002427880815: network connection: connected
> [786139.632997] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink 2500 mbit/s uplink
> [786139.665097] cdc_ncm 2-1:2.0 enx002427880815: network connection: connected
> [786139.697100] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink 2500 mbit/s uplink
> [786139.729094] cdc_ncm 2-1:2.0 enx002427880815: network connection: connected
> [786139.761108] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink 2500 mbit/s uplink
> ...
>
> Chrome OS cannot support RTL8156 until this is fixed.
>
> Signed-off-by: Grant Grundler <grundler@chromium.org>
> ---
>  drivers/net/usb/cdc_ncm.c  | 12 +++++++++++-
>  include/linux/usb/usbnet.h |  2 ++
>  2 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 25498c311551..5de096545b86 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -1827,6 +1827,15 @@ cdc_ncm_speed_change(struct usbnet *dev,
>         uint32_t rx_speed = le32_to_cpu(data->DLBitRRate);
>         uint32_t tx_speed = le32_to_cpu(data->ULBitRate);
>
> +       /* if the speed hasn't changed, don't report it.
> +        * RTL8156 shipped before 2021 sends notification about every 32ms.
> +        */
> +       if (dev->rx_speed == rx_speed && dev->tx_speed == tx_speed)
> +               return;
> +
> +       dev->rx_speed = rx_speed;
> +       dev->tx_speed = tx_speed;
> +
>         /*
>          * Currently the USB-NET API does not support reporting the actual
>          * device speed. Do print it instead.
> @@ -1867,7 +1876,8 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
>                  * USB_CDC_NOTIFY_NETWORK_CONNECTION notification shall be
>                  * sent by device after USB_CDC_NOTIFY_SPEED_CHANGE.
>                  */
> -               usbnet_link_change(dev, !!event->wValue, 0);
> +               if (netif_carrier_ok(dev->net) != !!event->wValue)
> +                       usbnet_link_change(dev, !!event->wValue, 0);
>                 break;
>
>         case USB_CDC_NOTIFY_SPEED_CHANGE:
> diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
> index 88a7673894d5..cfbfd6fe01df 100644
> --- a/include/linux/usb/usbnet.h
> +++ b/include/linux/usb/usbnet.h
> @@ -81,6 +81,8 @@ struct usbnet {
>  #              define EVENT_LINK_CHANGE        11
>  #              define EVENT_SET_RX_MODE        12
>  #              define EVENT_NO_IP_ALIGN        13
> +       u32                     rx_speed;       /* in bps - NOT Mbps */
> +       u32                     tx_speed;       /* in bps - NOT Mbps */
>  };
>
>  static inline struct usb_driver *driver_of(struct usb_interface *intf)
> --
> 2.29.2
>
