Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7365A4D12EA
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 09:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343683AbiCHIz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 03:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238848AbiCHIzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 03:55:25 -0500
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25DF2B19D;
        Tue,  8 Mar 2022 00:54:28 -0800 (PST)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-2db2add4516so193796647b3.1;
        Tue, 08 Mar 2022 00:54:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FS0ydfMarLV9kbW6AqtneKVvUqNm/uGFXcWK+i/U9Mw=;
        b=66I1+dHuIo8mlKOOeHv8Vw/gFvFzjuxO6MeGHpjjfEqUrPVRRxBLnAKCL7dXHBaz8t
         Jw08XGb3p2HFF3M86DHfI8nheHWZ2/JraA16EOn0YmZPUaq/PtQngk2EgIqjDWA2UOmb
         B3HrrZjF4H+wgPCS7um38IRsHwuTBlJG/wDRDFmLr/QzUG0+DGHRQYYDIu+P1Fpfjp/c
         ZqLXP5nNP3jX/mVv/L1+SAF+p6OLgJdgyfmY0SwgOXgiEza4haXpbyXjYrlB7VsGcv2s
         cbc6P6nmbPof7qQfzS0E4yrYM7REowMZqq9tR0pfMLB/L+3kAp0zl78bcb714DnjDhd4
         BxIg==
X-Gm-Message-State: AOAM5324UTlwtuLhSJbYMs2B3Ex9QFouD6IItwkh8f+ZaGLanN9IH12q
        +sPSKIQL5shmksa1qU/vuvbI6A7m8347t/N05Co=
X-Google-Smtp-Source: ABdhPJzmpPfH2R127kHFspab3kWaHDsc1bEBEtiQjCmolrICrSbsmlcHTabpP37b2G+V6WKWR7qvpYaMoc7FfNA6bHg=
X-Received: by 2002:a81:c443:0:b0:2d0:dfa3:9ed9 with SMTP id
 s3-20020a81c443000000b002d0dfa39ed9mr12067363ywj.220.1646729664636; Tue, 08
 Mar 2022 00:54:24 -0800 (PST)
MIME-Version: 1.0
References: <CAMZ6RqKEALqGSh-tr_jTbQWca0wHK7t96yR3N-r625pbM4cUSw@mail.gmail.com>
 <20220308081608.3243-1-paskripkin@gmail.com>
In-Reply-To: <20220308081608.3243-1-paskripkin@gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 8 Mar 2022 17:54:13 +0900
Message-ID: <CAMZ6RqKn4E9wstZF1xbefBaR3AbcORq60KXvxUTCSH8dZ+Cxag@mail.gmail.com>
Subject: Re: [PATCH v2] can: mcba_usb: properly check endpoint type
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     yashi@spacecubics.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 8 Mar 2022 at 17:16, Pavel Skripkin <paskripkin@gmail.com> wrote:
> Syzbot reported warning in usb_submit_urb() which is caused by wrong
> endpoint type. We should check that in endpoint is actually present to
> prevent this warning
>
> Found pipes are now saved to struct mcba_priv and code uses them directly
> instead of making pipes in place.
>
> Fail log:
>
> usb 5-1: BOGUS urb xfer, pipe 3 != type 1
> WARNING: CPU: 1 PID: 49 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
> Modules linked in:
> CPU: 1 PID: 49 Comm: kworker/1:2 Not tainted 5.17.0-rc6-syzkaller-00184-g38f80f42147f #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
> Workqueue: usb_hub_wq hub_event
> RIP: 0010:usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
> ...
> Call Trace:
>  <TASK>
>  mcba_usb_start drivers/net/can/usb/mcba_usb.c:662 [inline]
>  mcba_usb_probe+0x8a3/0xc50 drivers/net/can/usb/mcba_usb.c:858
>  usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
>  call_driver_probe drivers/base/dd.c:517 [inline]
>
> Reported-and-tested-by: syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
> Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>
> Changes from RFT(RFC):
>         - Add missing out pipe check
>         - Use found pipes instead of making pipes in place
>         - Do not hide usb_find_common_endpoints() error
>
> ---
>  drivers/net/can/usb/mcba_usb.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
> index 77bddff86252..91e79a2d5ae5 100644
> --- a/drivers/net/can/usb/mcba_usb.c
> +++ b/drivers/net/can/usb/mcba_usb.c
> @@ -33,10 +33,6 @@
>  #define MCBA_USB_RX_BUFF_SIZE 64
>  #define MCBA_USB_TX_BUFF_SIZE (sizeof(struct mcba_usb_msg))
>
> -/* MCBA endpoint numbers */
> -#define MCBA_USB_EP_IN 1
> -#define MCBA_USB_EP_OUT 1
> -
>  /* Microchip command id */
>  #define MBCA_CMD_RECEIVE_MESSAGE 0xE3
>  #define MBCA_CMD_I_AM_ALIVE_FROM_CAN 0xF5
> @@ -83,6 +79,8 @@ struct mcba_priv {
>         atomic_t free_ctx_cnt;
>         void *rxbuf[MCBA_MAX_RX_URBS];
>         dma_addr_t rxbuf_dma[MCBA_MAX_RX_URBS];
> +       int rx_pipe;
> +       int tx_pipe;
>  };
>
>  /* CAN frame */
> @@ -269,7 +267,7 @@ static netdev_tx_t mcba_usb_xmit(struct mcba_priv *priv,
>         memcpy(buf, usb_msg, MCBA_USB_TX_BUFF_SIZE);
>
>         usb_fill_bulk_urb(urb, priv->udev,
> -                         usb_sndbulkpipe(priv->udev, MCBA_USB_EP_OUT), buf,
> +                         priv->tx_pipe, buf,

Nitpick: you might want to put more arguments per line (up to the 80
characters limit).

>                           MCBA_USB_TX_BUFF_SIZE, mcba_usb_write_bulk_callback,
>                           ctx);
>
> @@ -608,7 +606,7 @@ static void mcba_usb_read_bulk_callback(struct urb *urb)
>  resubmit_urb:
>
>         usb_fill_bulk_urb(urb, priv->udev,
> -                         usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_OUT),
> +                         priv->rx_pipe,
>                           urb->transfer_buffer, MCBA_USB_RX_BUFF_SIZE,
>                           mcba_usb_read_bulk_callback, priv);
>
> @@ -653,7 +651,7 @@ static int mcba_usb_start(struct mcba_priv *priv)
>                 urb->transfer_dma = buf_dma;
>
>                 usb_fill_bulk_urb(urb, priv->udev,
> -                                 usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_IN),
> +                                 priv->rx_pipe,
>                                   buf, MCBA_USB_RX_BUFF_SIZE,
>                                   mcba_usb_read_bulk_callback, priv);
>                 urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> @@ -807,6 +805,13 @@ static int mcba_usb_probe(struct usb_interface *intf,
>         struct mcba_priv *priv;
>         int err;
>         struct usb_device *usbdev = interface_to_usbdev(intf);
> +       struct usb_endpoint_descriptor *in, *out;
> +
> +       err = usb_find_common_endpoints(intf->cur_altsetting, &in, &out, NULL, NULL);
> +       if (err) {
> +               dev_err(&intf->dev, "Can't find endpoints\n");
> +               return err;
> +       }
>
>         netdev = alloc_candev(sizeof(struct mcba_priv), MCBA_MAX_TX_URBS);
>         if (!netdev) {
> @@ -852,6 +857,9 @@ static int mcba_usb_probe(struct usb_interface *intf,
>                 goto cleanup_free_candev;
>         }
>
> +       priv->rx_pipe = usb_rcvbulkpipe(priv->udev, in->bEndpointAddress);
> +       priv->tx_pipe = usb_sndbulkpipe(priv->udev, out->bEndpointAddress);
> +
>         devm_can_led_init(netdev);
>
>         /* Start USB dev only if we have successfully registered CAN device */

Aside from the nitpick, it looks good to me.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>


Yours sincerely,
Vincent Mailhol
