Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF60C30AB18
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 16:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhBAPXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 10:23:10 -0500
Received: from mail-yb1-f169.google.com ([209.85.219.169]:38983 "EHLO
        mail-yb1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhBAPWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 10:22:15 -0500
Received: by mail-yb1-f169.google.com with SMTP id k4so17206522ybp.6;
        Mon, 01 Feb 2021 07:22:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dsxwO7hWzLBNBcxb5oAX/WrRy6edgK73m5vgz2nVH7Q=;
        b=jua+dTqmXbEX85xGAg+cPYPLbnY+yfw7xhyJavOO42LaavNpH5zixaSfHZTeAsJ8BN
         Lzi4qIrdwusUb0W1xAsQbEffQ726BRItX7AU00lNK0ZB/gBedzp8OkrrkAZMF34kQWzk
         GGmoh4LMH4rH0p7qQv8Myaioc3dDjiqHDxiIVqGBfaw3WFfuQ8Fh66EAGgELgmAPfZ4M
         +I4dqpANQvnT7kRX3MjWmXVgAzy+Ie3SeQH4+wecPTPIBhDjrczS8Uvhz/jttlp3f5fG
         WjsfbqFTqm8lFqjPwKxGp4Dg7ORm15Msetl+ZbrR0w8/cmiPnGaImtFqnby0iIdiZ/+B
         VEZA==
X-Gm-Message-State: AOAM531zVP5lRqm2HVps3UIfFl5VTT0kJSyB5ldfAZbT3r6M+iJEoa44
        gqLGTmPa2hoNeXHv0muA7oBiYIw4U2fcs+lc/N6iYE18ycTjM5+b
X-Google-Smtp-Source: ABdhPJwnE27Wk0UI8BZqnbJwsTwAI0TzEdeQheHNeNLfkQnPyHM9Ix5xSG/me6TxuPLoo+O9WHeKxVml6/8tmbokDPs=
X-Received: by 2002:a25:84cc:: with SMTP id x12mr8729588ybm.487.1612192894792;
 Mon, 01 Feb 2021 07:21:34 -0800 (PST)
MIME-Version: 1.0
References: <20210125104055.79882-1-socketcan@hartkopp.net>
In-Reply-To: <20210125104055.79882-1-socketcan@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 2 Feb 2021 00:21:23 +0900
Message-ID: <CAMZ6Rq+WvuGMrR2sQykt727ZZPvb2v-6hb0nvVpsUwWCco7bFg@mail.gmail.com>
Subject: Re: [PATCH RESEND iproute2 5.11] iplink_can: add Classical CAN frame
 LEN8_DLC support
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        linux-can <linux-can@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 25 Jan 2021 at 19:40, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> The len8_dlc element is filled by the CAN interface driver and used for CAN
> frame creation by the CAN driver when the CAN_CTRLMODE_CC_LEN8_DLC flag is
> supported by the driver and enabled via netlink configuration interface.
>
> Add the command line support for cc-len8-dlc for Linux 5.11+
>
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> ---
>  ip/iplink_can.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/ip/iplink_can.c b/ip/iplink_can.c
> index 735ab941..6a26f3ff 100644
> --- a/ip/iplink_can.c
> +++ b/ip/iplink_can.c
> @@ -35,10 +35,11 @@ static void print_usage(FILE *f)
>                 "\t[ one-shot { on | off } ]\n"
>                 "\t[ berr-reporting { on | off } ]\n"
>                 "\t[ fd { on | off } ]\n"
>                 "\t[ fd-non-iso { on | off } ]\n"
>                 "\t[ presume-ack { on | off } ]\n"
> +               "\t[ cc-len8-dlc { on | off } ]\n"
>                 "\n"
>                 "\t[ restart-ms TIME-MS ]\n"
>                 "\t[ restart ]\n"
>                 "\n"
>                 "\t[ termination { 0..65535 } ]\n"
> @@ -101,10 +102,11 @@ static void print_ctrlmode(FILE *f, __u32 cm)
>         _PF(CAN_CTRLMODE_ONE_SHOT, "ONE-SHOT");
>         _PF(CAN_CTRLMODE_BERR_REPORTING, "BERR-REPORTING");
>         _PF(CAN_CTRLMODE_FD, "FD");
>         _PF(CAN_CTRLMODE_FD_NON_ISO, "FD-NON-ISO");
>         _PF(CAN_CTRLMODE_PRESUME_ACK, "PRESUME-ACK");
> +       _PF(CAN_CTRLMODE_CC_LEN8_DLC, "CC-LEN8-DLC");
>  #undef _PF
>         if (cm)
>                 print_hex(PRINT_ANY, NULL, "%x", cm);
>         close_json_array(PRINT_ANY, "> ");
>  }
> @@ -209,10 +211,14 @@ static int can_parse_opt(struct link_util *lu, int argc, char **argv,
>                                      CAN_CTRLMODE_FD_NON_ISO);
>                 } else if (matches(*argv, "presume-ack") == 0) {
>                         NEXT_ARG();
>                         set_ctrlmode("presume-ack", *argv, &cm,
>                                      CAN_CTRLMODE_PRESUME_ACK);
> +               } else if (matches(*argv, "cc-len8-dlc") == 0) {
> +                       NEXT_ARG();
> +                       set_ctrlmode("cc-len8-dlc", *argv, &cm,
> +                                    CAN_CTRLMODE_CC_LEN8_DLC);
>                 } else if (matches(*argv, "restart") == 0) {
>                         __u32 val = 1;
>
>                         addattr32(n, 1024, IFLA_CAN_RESTART, val);
>                 } else if (matches(*argv, "restart-ms") == 0) {
> --
> 2.29.2

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Reviewed and tested the patch, everything is OK for me.
Thanks Oliver!
