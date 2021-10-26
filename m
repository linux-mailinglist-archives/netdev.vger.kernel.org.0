Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C243443AAC0
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 05:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbhJZDcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 23:32:31 -0400
Received: from mail-yb1-f170.google.com ([209.85.219.170]:35371 "EHLO
        mail-yb1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbhJZDca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 23:32:30 -0400
Received: by mail-yb1-f170.google.com with SMTP id i65so30500817ybb.2;
        Mon, 25 Oct 2021 20:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dSkuvBNlsR/Tr6v+p8qnht5azmInH+MBDWCZ0LaoZvg=;
        b=XlPbAYoSU27GFio8AUvCUknPEywEfdGtqj7yAPAj7spoMI3kcZqQAdFntN39XFMJbf
         Lx9Z10Ii5BQFoozGuchOLWPsDNUtjb7NqvRIBQPomOZnyDyd7ulw9VsZxKUfNBE/9YEG
         c06+a0/Dd8Hs681wn2/GlZ7WvdUawzbkt9LdIJp5xaY/cS6iES962+kFo8ld1gMsvJOy
         jblXzC5thDec8MC0eLZLDTHiuwvG9PTnr3U4u1B6aV3NLVVE9gKgQsqCsDlrFlt5+Lsa
         X+EWGikjSAvyeKv1FReX5FcODZrioGqreKdgWTxTfSRM9X1Tt+jpB3FrnNjDR/VLEqfi
         6pyg==
X-Gm-Message-State: AOAM5322xmiRox8e4RgH8KYwUVx7QGgm09JNbSIuyzcxi7ow2cmV80dW
        WL9c+Nwb2VyrJP6LJnSFh0TQqW/UvcwNwgkh67p5NeEPEzw=
X-Google-Smtp-Source: ABdhPJwc6I/ZzDqdwL2yBzXdBFnFpYhRFfdO9Ngrf2wsE4M/SEfiW4tHBSuywZqEtsSscbYryS0F13yNA09wmWjIixM=
X-Received: by 2002:a05:6902:1363:: with SMTP id bt3mr22584297ybb.152.1635219006891;
 Mon, 25 Oct 2021 20:30:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211025172247.1774451-1-mailhol.vincent@wanadoo.fr> <20211025172247.1774451-5-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20211025172247.1774451-5-mailhol.vincent@wanadoo.fr>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 26 Oct 2021 12:29:55 +0900
Message-ID: <CAMZ6RqJgzELj7BCD-st8NiXDjSFDOmqAouFaERgt1UVuoKK58Q@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] can: netlink: report the CAN controller mode
 supported flags
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 26 Oct 2021 at 02:22, Vincent Mailhol
<mailhol.vincent@wanadoo.fr> wrote:
> This patch introduces a method for the user to check both the
> supported and the static capabilities. The proposed method reuses the
> existing struct can_ctrlmode and thus do not need a new IFLA_CAN_*
> entry.
>
> Currently, the CAN netlink interface provides no easy ways to check
> the capabilities of a given controller. The only method from the
> command line is to try each CAN_CTRLMODE_* individually to check
> whether the netlink interface returns an -EOPNOTSUPP error or not
> (alternatively, one may find it easier to directly check the source
> code of the driver instead...)
>
> It appears that can_ctrlmode::mask is only used in one direction: from
> the userland to the kernel. So we can just reuse this field in the
> other direction (from the kernel to userland). But, because the
> semantic is different, we use a union to give this field a proper
> name: "supported".
>
> Below table explains how the two fields can_ctrlmode::supported and
> can_ctrlmode::flags, when masked with any of the CAN_CTRLMODE_* bit
> flags, allow us to identify both the supported and the static
> capabilities:
>
>  supported &    flags &         Controller capabilities
>  CAN_CTRLMODE_* CAN_CTRLMODE_*
>  -----------------------------------------------------------------------
>  false          false           Feature not supported (always disabled)
>  false          true            Static feature (always enabled)
>  true           false           Feature supported but disabled
>  true           true            Feature supported and enabled
>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
> Please refer to below link for the iproute2-next counterpart of this
> patch:
>
> https://lore.kernel.org/linux-can/20211003050147.569044-1-mailhol.vincent@wanadoo.fr/T/#t
> ---
>  drivers/net/can/dev/netlink.c    | 5 ++++-
>  include/uapi/linux/can/netlink.h | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
> index 26c336808be5..32e1eb63ee7d 100644
> --- a/drivers/net/can/dev/netlink.c
> +++ b/drivers/net/can/dev/netlink.c
> @@ -475,7 +475,10 @@ static int can_tdc_fill_info(struct sk_buff *skb, const struct net_device *dev)
>  static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
>  {
>         struct can_priv *priv = netdev_priv(dev);
> -       struct can_ctrlmode cm = {.flags = priv->ctrlmode};
> +       struct can_ctrlmode cm = {
> +               .supported = priv->ctrlmode_supported,
> +               .flags = priv->ctrlmode
> +       };
>         struct can_berr_counter bec = { };
>         enum can_state state = priv->state;
>
> diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
> index 75b85c60efb2..b846922ac18f 100644
> --- a/include/uapi/linux/can/netlink.h
> +++ b/include/uapi/linux/can/netlink.h
> @@ -88,7 +88,10 @@ struct can_berr_counter {
>   * CAN controller mode
>   */
>  struct can_ctrlmode {
> -       __u32 mask;
> +       union {
> +               __u32 mask;             /* Userland to kernel */
> +               __u32 supported;        /* Kernel to userland */
> +       };

While daydreaming during my lunch break, I suddenly remembered
this thread [1] and was concerned that introducing the union
might break the UAPI.

As a matter of fact, the C standard allows the compiler to add
padding at the end of an union. c.f. ISO/IEC 9899-1999, section
6.7.2.1 "Structure and union specifiers", clause 15: "There may
be unnamed padding at the end of a structure or union."

For example, if the kernel were to be compiled with the
-mstructure-size-boundary=64 ARM option in GCC [2], 32 bits of
padding would be introduced after the union, thus breaking the
alignment of the next field: can_ctrlmode::flags.

As far as my knowledge goes, I am not sure whether or not
-mstructure-size-boundary=64 (or similar options on other
architectures) is actually used. Nonetheless, I think it is safer
to declare the union as __attribute__((packed)) to prevent such
padding from occuring.

I will send a v4 later today to address this.

[1] https://lore.kernel.org/linux-can/212c8bc3-89f9-9c33-ed1b-b50ac04e7532@hartkopp.net/T/#u
[2] https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html

>         __u32 flags;
>  };

Yours sincerely,
Vincent Mailhol
