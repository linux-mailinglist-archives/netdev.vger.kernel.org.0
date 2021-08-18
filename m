Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33423EF9E4
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 07:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbhHRFOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 01:14:39 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:45724 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbhHRFOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 01:14:38 -0400
Received: by mail-lf1-f53.google.com with SMTP id g13so1930651lfj.12;
        Tue, 17 Aug 2021 22:14:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dThlhLLrplnuLh2UP7jmiTXGduhqKRmat16fPmXeSs4=;
        b=mJMGN8v2uzWYrKsMoCbN/zimJ+q+km9nqHHf00Nw/i0zZ9aChKgb+MqX/n3hsizlCh
         2if2pDhs/Aq5iNpxMyp2tIG2oX3bmtdYw27M+OMEGy/A9vt5RCFHxj7REJJxhDptpXID
         YSHQmMz4BPpeMRx5rx8EYb/NHJ1aaA00IEulfbYkLdcUnLnm2YV10xWLPfg23k19P97Q
         etwKG5LPsOR43rkYgjRucyuekdBoj/VNTURRNrP1NemTnxhr/kGMVD26x8vE0T5g65Us
         6XnGeoVxZgZ/6PFG+9aWhYPsBTZiOPIQw0foMuSKnHFftzqAkg7v6PlgJtJ8QI7V+5UA
         ckbQ==
X-Gm-Message-State: AOAM532rc/NUUIEtYO8OZUYN8Jq3hY2xJFPs+CGN2FJHTV99apgNUz/Y
        WqFn0+fz24D7+shASMKCUPw0Sy3eg4hw8HJmHL8=
X-Google-Smtp-Source: ABdhPJzGqt8rmnrhyLdtbX+v8/EnvPatnAlw9hMVu1/WitSQD341ru1TC1ELyRE65BhkPZnlrfdXY1mSAqt/mVKCk4k=
X-Received: by 2002:ac2:5d27:: with SMTP id i7mr5022735lfb.488.1629263642539;
 Tue, 17 Aug 2021 22:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210818034010.800652-1-keescook@chromium.org>
In-Reply-To: <20210818034010.800652-1-keescook@chromium.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 18 Aug 2021 14:13:51 +0900
Message-ID: <CAMZ6RqK4Rn4d-1CZsg9vJiAMHhxN6fgcqukdHpGwXoGTyNVr_Q@mail.gmail.com>
Subject: Re: [PATCH] can: etas_es58x: Replace 0-element raw_msg array
To:     Kees Cook <keescook@chromium.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 18 Aug 2021 at 12:40, Kees Cook <keescook@chromium.org> wrote:
> While raw_msg isn't a fixed size, it does have a maximum size. Adjust the
> struct to represent this and avoid the following warning when building
> with -Wzero-length-bounds:
>
> drivers/net/can/usb/etas_es58x/es58x_fd.c: In function 'es58x_fd_tx_can_msg':
> drivers/net/can/usb/etas_es58x/es58x_fd.c:360:35: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[]'} [-Wzero-length-bounds]
>   360 |  tx_can_msg = (typeof(tx_can_msg))&es58x_fd_urb_cmd->raw_msg[msg_len];
>       |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from drivers/net/can/usb/etas_es58x/es58x_core.h:22,
>                  from drivers/net/can/usb/etas_es58x/es58x_fd.c:17:
> drivers/net/can/usb/etas_es58x/es58x_fd.h:231:6: note: while referencing 'raw_msg'
>   231 |   u8 raw_msg[0];
>       |      ^~~~~~~
>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
> Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> Cc: linux-can@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/can/usb/etas_es58x/es581_4.h  | 2 +-
>  drivers/net/can/usb/etas_es58x/es58x_fd.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/can/usb/etas_es58x/es581_4.h b/drivers/net/can/usb/etas_es58x/es581_4.h
> index 4bc60a6df697..af38c4938859 100644
> --- a/drivers/net/can/usb/etas_es58x/es581_4.h
> +++ b/drivers/net/can/usb/etas_es58x/es581_4.h
> @@ -192,7 +192,7 @@ struct es581_4_urb_cmd {
>                 struct es581_4_rx_cmd_ret rx_cmd_ret;
>                 __le64 timestamp;
>                 u8 rx_cmd_ret_u8;
> -               u8 raw_msg[0];
> +               u8 raw_msg[USHRT_MAX];
>         } __packed;
>
>         __le16 reserved_for_crc16_do_not_use;
> diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.h b/drivers/net/can/usb/etas_es58x/es58x_fd.h
> index ee18a87e40c0..e0319b8358ef 100644
> --- a/drivers/net/can/usb/etas_es58x/es58x_fd.h
> +++ b/drivers/net/can/usb/etas_es58x/es58x_fd.h
> @@ -228,7 +228,7 @@ struct es58x_fd_urb_cmd {
>                 struct es58x_fd_tx_ack_msg tx_ack_msg;
>                 __le64 timestamp;
>                 __le32 rx_cmd_ret_le32;
> -               u8 raw_msg[0];
> +               u8 raw_msg[USHRT_MAX];
>         } __packed;
>
>         __le16 reserved_for_crc16_do_not_use;
> --
> 2.30.2

raw_msg is part of a union so its maximum size is implicitly the
biggest size of the other member of that union:

| struct es58x_fd_urb_cmd {
|     __le16 SOF;
|    u8 cmd_type;
|    u8 cmd_id;
|    u8 channel_idx;
|    __le16 msg_len;
|
|    union {
|        struct es58x_fd_tx_conf_msg tx_conf_msg;
|        u8 tx_can_msg_buf[ES58X_FD_TX_BULK_MAX * ES58X_FD_CANFD_TX_LEN];
|        u8 rx_can_msg_buf[ES58X_FD_RX_BULK_MAX * ES58X_FD_CANFD_RX_LEN];
|        struct es58x_fd_echo_msg echo_msg[ES58X_FD_ECHO_BULK_MAX];
|        struct es58x_fd_rx_event_msg rx_event_msg;
|        struct es58x_fd_tx_ack_msg tx_ack_msg;
|        __le64 timestamp;
|        __le32 rx_cmd_ret_le32;
|        u8 raw_msg[0];
|    } __packed;
|
|    __le16 reserved_for_crc16_do_not_use;
| } __packed;

ram_msg can then be used to manipulate the other fields at the byte level.
I am sorry but I fail to understand why this is an issue.

Also, the proposed fix drastically increases the size of the structure.


Yours sincerely,
Vincent
