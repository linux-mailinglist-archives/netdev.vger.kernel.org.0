Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBAD2FAD08
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733204AbhARWC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbhARWCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 17:02:09 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9D8C0613CF
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 14:01:28 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id n187so375010vke.10
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 14:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dSv0EYxQaJbjHMisjeOKJuNZjlVFGnjCJWJZiTxNS0k=;
        b=US65w8NqxwUBUWVNBX+9I5xdNtl4Mt6lNYsxAG1SFkvE47ao/Ib3p4Qy8QqqTOsHXE
         6IZ0M9zy41gGAd8FkuJM+/2JDBLgKOQxrXwvSgKRxKd4bk6HxwZMSs1qrwAu+JQ8xOf8
         kzsr5f3EtZ+hig6ImPseGjcvbRXkavQNKP9CM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dSv0EYxQaJbjHMisjeOKJuNZjlVFGnjCJWJZiTxNS0k=;
        b=WrFtMPmDpvv908i1/UdnbQyAUqCxs/fm2CeRbuuQUnI7StFUl0WvN1xVe4FfdVp22B
         rzcVuYTzWrTyOvrXlthz3Tga5SJxgXN6OrqKfWq7T5Ullk1qhEnqR4E46I0Z1+7eEdtT
         GXFMsC0oQT/LaD9x+jE4uPnHzaEcLa6rMwTGkZErgfEpaEW3w+bNo1MxZMNgq3dbXr96
         ViDbuKY942+GLCHPLOmeykBwJKS/P7Y9mlADYi3Q2izaqnTH5xnjLp6e23HuH/tfVKz+
         Vo0GlGobJwRkrp92y+TVhD42sVioqePR5oPtwi94A3/KW8ugu9a8LYm9GmlyUReD9K1X
         VlSQ==
X-Gm-Message-State: AOAM533dOEXlI24QGBbYAiArM2LOLJEVHZQpr+Ki2qHoziR4UIYHi7xJ
        MYS9qsQ1Sx10q05UGNIyH4sT9mbFPMpIFBEDFoj92g==
X-Google-Smtp-Source: ABdhPJyOEcIB4h7aL8Vc+TQvMFVeE3G9IC3ALZGHLqfMxG07hVjx8f7yvYPgp7dY9wstKAjKi4zNe5YRgWbb7GNpcJs=
X-Received: by 2002:a1f:c305:: with SMTP id t5mr928711vkf.7.1611007287521;
 Mon, 18 Jan 2021 14:01:27 -0800 (PST)
MIME-Version: 1.0
References: <20210116052623.3196274-1-grundler@chromium.org>
In-Reply-To: <20210116052623.3196274-1-grundler@chromium.org>
From:   Grant Grundler <grundler@chromium.org>
Date:   Mon, 18 Jan 2021 22:01:15 +0000
Message-ID: <CANEJEGusskCzMzP-VEbTyk2zfH+tQjHO8JpncVtufnw__2mx6A@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: usb: cdc_ncm: emit dev_err on error paths
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

On Sat, Jan 16, 2021 at 5:26 AM Grant Grundler <grundler@chromium.org> wrote:
>
> Several error paths in bind/probe code will only emit
> output using dev_dbg. But if we are going to fail the
> bind/probe, emit related output with "err" priority.
>
> Signed-off-by: Grant Grundler <grundler@chromium.org>
> ---
>  drivers/net/usb/cdc_ncm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 5a78848db93f..25498c311551 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -849,17 +849,17 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
>
>         /* check if we got everything */
>         if (!ctx->data) {
> -               dev_dbg(&intf->dev, "CDC Union missing and no IAD found\n");
> +               dev_err(&intf->dev, "CDC Union missing and no IAD found\n");
>                 goto error;
>         }
>         if (cdc_ncm_comm_intf_is_mbim(intf->cur_altsetting)) {
>                 if (!ctx->mbim_desc) {
> -                       dev_dbg(&intf->dev, "MBIM functional descriptor missing\n");
> +                       dev_err(&intf->dev, "MBIM functional descriptor missing\n");
>                         goto error;
>                 }
>         } else {
>                 if (!ctx->ether_desc || !ctx->func_desc) {
> -                       dev_dbg(&intf->dev, "NCM or ECM functional descriptors missing\n");
> +                       dev_err(&intf->dev, "NCM or ECM functional descriptors missing\n");
>                         goto error;
>                 }
>         }
> @@ -868,7 +868,7 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
>         if (ctx->data != ctx->control) {
>                 temp = usb_driver_claim_interface(driver, ctx->data, dev);
>                 if (temp) {
> -                       dev_dbg(&intf->dev, "failed to claim data intf\n");
> +                       dev_err(&intf->dev, "failed to claim data intf\n");
>                         goto error;
>                 }
>         }
> @@ -924,7 +924,7 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
>         if (ctx->ether_desc) {
>                 temp = usbnet_get_ethernet_addr(dev, ctx->ether_desc->iMACAddress);
>                 if (temp) {
> -                       dev_dbg(&intf->dev, "failed to get mac address\n");
> +                       dev_err(&intf->dev, "failed to get mac address\n");
>                         goto error2;
>                 }
>                 dev_info(&intf->dev, "MAC-Address: %pM\n", dev->net->dev_addr);
> --
> 2.29.2
>
