Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70414D0CB7
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242619AbiCHAYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbiCHAYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:24:37 -0500
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE89525C77;
        Mon,  7 Mar 2022 16:23:41 -0800 (PST)
Received: by mail-yb1-f177.google.com with SMTP id w16so34443597ybi.12;
        Mon, 07 Mar 2022 16:23:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=03ctwj9JfxishKI39lNFiwkYLQyUapkTIk7JVqkzfkU=;
        b=zKJGEt9vPbDi9AxSJRPEiXt54gw8S06NkdAlIKo9thJOASWmbWUoIYKT25YEGbZKW5
         ZfAXDXcaE8lLUDxqqcOl76yiXbb1+tNuMmhKdCAzR+uE0Mci0n527YQsNOZ/5heRl87+
         YjOOvesXiDKiTd1dhvRuMjIFUa84RLRRFsbi/wGv2oeD7QEd79Eq/dRKuLMdddJVq1jK
         iNP+epzZZdKBxmWkKbr5Fu5Svp8eaZKuFdIP+E47Rd1Oy4HNolIrdbU81gW56mVEtEr4
         rn2NZdEZa0w8F7IP2vSxYwxTXRgJgKNzNXjsM6wm+8Xw4oRjYx9sAUjYJIfCH9dIkBFh
         l36g==
X-Gm-Message-State: AOAM531+uC+Al/hbKS/FwUpS9jg/2bXDEQ75+TB4fgEcDDWMTE/bUdT7
        UUhrNhVZEWU0Eg4UE/jCBfmUPE7nqV/d/bpkkeobEtylCGSHEjkM
X-Google-Smtp-Source: ABdhPJxLu300z9a/o98cTmbZ2qcZxeyW0M8rKMBVCZB7FHLVKHRM6U9Mf+BY2vrb6JX3S422aKKaYaDnQfSrOvYSiGI=
X-Received: by 2002:a25:d10d:0:b0:628:f428:dafe with SMTP id
 i13-20020a25d10d000000b00628f428dafemr9423935ybg.630.1646699020879; Mon, 07
 Mar 2022 16:23:40 -0800 (PST)
MIME-Version: 1.0
References: <20220307185314.11228-1-paskripkin@gmail.com>
In-Reply-To: <20220307185314.11228-1-paskripkin@gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 8 Mar 2022 09:23:31 +0900
Message-ID: <CAMZ6RqKEALqGSh-tr_jTbQWca0wHK7t96yR3N-r625pbM4cUSw@mail.gmail.com>
Subject: Re: [PATCH RFT] can: mcba_usb: properly check endpoint type
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Yasushi SHOJI <yashi@spacecubics.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
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

Hi Pavel,

> [PATCH RFT] can: mcba_usb: properly check endpoint type
It is RFC, not RFT :)
I guess you went on some manual editing. Next time, you can just let
git add the tag for you by doing:
| git format-patch --rfc ...


On Tue. 8 Mar 2022, 03:53, Pavel Skripkin <paskripkin@gmail.com> wrote:
> Syzbot reported warning in usb_submit_urb() which is caused by wrong
> endpoint type. We should check that in endpoint is actually present to
> prevent this warning
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
> Meta comments:
>
> I am not an usb expert, but looks like this driver uses one
> endpoint for in and out transactions:
>
> /* MCBA endpoint numbers */
> #define MCBA_USB_EP_IN 1
> #define MCBA_USB_EP_OUT 1
>
> That's why check only for in endpoint is added

MCBA_USB_EP_{IN,OUT} are respectively used in usb_rcvbulkpipe()
and usb_sndbulkpipe().  I invite you to have a look at what those
macros do and you will understand that these returns two different
pipes:

https://elixir.bootlin.com/linux/latest/source/include/linux/usb.h#L1964

In other words, ep_in and ep_out are some indexes of a different
entity and do not conflict with each other.

> ---
>  drivers/net/can/usb/mcba_usb.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
> index 77bddff86252..646aac1a8684 100644
> --- a/drivers/net/can/usb/mcba_usb.c
> +++ b/drivers/net/can/usb/mcba_usb.c
> @@ -807,6 +807,13 @@ static int mcba_usb_probe(struct usb_interface *intf,
>         struct mcba_priv *priv;
>         int err;
>         struct usb_device *usbdev = interface_to_usbdev(intf);
> +       struct usb_endpoint_descriptor *in;
> +
> +       err = usb_find_common_endpoints(intf->cur_altsetting, &in, NULL, NULL, NULL);

If you go this direction, then please use
usb_find_common_endpoint() to retrieve the value of both ep_in
and ep_out and use them instead of MCBA_USB_EP_{IN,OUT}

> +       if (err) {
> +               dev_err(&intf->dev, "Can't find endpoints\n");
> +               return -ENODEV;

return ret;

Please keep the error code of usb_find_common_endpoint().

> +       }
>
>
>
>         netdev = alloc_candev(sizeof(struct mcba_priv), MCBA_MAX_TX_URBS);
>         if (!netdev) {


Yours sincerely,
Vincent Mailhol
