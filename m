Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3043EFE52
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 09:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbhHRH4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 03:56:13 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:33508 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239275AbhHRH4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 03:56:08 -0400
Received: by mail-lf1-f46.google.com with SMTP id p38so2894758lfa.0;
        Wed, 18 Aug 2021 00:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OKNqcjyMKvezCUeqQ9JLkZ4cJ3Qp1tm5Mjp0xQPfVdk=;
        b=KL93TLEfVVWKQlk9QF5xuI3dfpCI8RPbYAw0WT8QHMc7FcyQENZutcXYw7kuq1EH4Z
         vcyVg7ZRehOhMA1W7SusE5Trf4TSXxrE2gtEij0mGVbVGz9CwsUhk+Ge5WZtfVq10yHB
         kZAha8RNscVFV8aZa8m+obW9FYmp1M9kVmdnXgVqrD7QiEM0zdeD41v+yD+d0mcSMOw1
         F8cORnoxfY6R3zppmB2yv39hNvbZmEg9pVvfn67HYodqzuYaGMhKj6ln79mvMPretcuT
         PfWNgZPOeU40z6hqrfEr+y62Bb3PeEmVsg0VN22dWnrvv7I3RUODPF7ZTxQcQs7NxXmA
         aLLw==
X-Gm-Message-State: AOAM533vwkQcuayi3Yci5yNHmL+2eGfPXLPsBx0HccC9VjEgtbVtAOBI
        nA5CIEn8fi3HcPwEpAOl6YcQtvg3EtgeuD3o0Yc=
X-Google-Smtp-Source: ABdhPJzvrTUEsuu+UliVD0ZQ+G9FKD87vbsYb/+XxmogarBDMIyGh6vgVKWqgJPt1W2rNzsulcpbB/8ovtLoJb5k9UY=
X-Received: by 2002:ac2:5ec7:: with SMTP id d7mr5435897lfq.234.1629273332108;
 Wed, 18 Aug 2021 00:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210818034010.800652-1-keescook@chromium.org>
 <CAMZ6RqK4Rn4d-1CZsg9vJiAMHhxN6fgcqukdHpGwXoGTyNVr_Q@mail.gmail.com> <202108172320.1540EC10C@keescook>
In-Reply-To: <202108172320.1540EC10C@keescook>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 18 Aug 2021 16:55:20 +0900
Message-ID: <CAMZ6RqLecbytJFQDC35n7YiqBbrB3--POofnXFeH77Zi2xzqWA@mail.gmail.com>
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

On Wed. 18 Aug 2021 at 15:48, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Aug 18, 2021 at 02:13:51PM +0900, Vincent MAILHOL wrote:
> > On Wed. 18 Aug 2021 at 12:40, Kees Cook <keescook@chromium.org> wrote:
> > > While raw_msg isn't a fixed size, it does have a maximum size. Adjust the
> > > struct to represent this and avoid the following warning when building
> > > with -Wzero-length-bounds:
> > >
> > > drivers/net/can/usb/etas_es58x/es58x_fd.c: In function 'es58x_fd_tx_can_msg':
> > > drivers/net/can/usb/etas_es58x/es58x_fd.c:360:35: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[]'} [-Wzero-length-bounds]
> > >   360 |  tx_can_msg = (typeof(tx_can_msg))&es58x_fd_urb_cmd->raw_msg[msg_len];
> > >       |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > In file included from drivers/net/can/usb/etas_es58x/es58x_core.h:22,
> > >                  from drivers/net/can/usb/etas_es58x/es58x_fd.c:17:
> > > drivers/net/can/usb/etas_es58x/es58x_fd.h:231:6: note: while referencing 'raw_msg'
> > >   231 |   u8 raw_msg[0];
> > >       |      ^~~~~~~
> > >
> > > Cc: Wolfgang Grandegger <wg@grandegger.com>
> > > Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
> > > Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > > Cc: linux-can@vger.kernel.org
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > ---
> > >  drivers/net/can/usb/etas_es58x/es581_4.h  | 2 +-
> > >  drivers/net/can/usb/etas_es58x/es58x_fd.h | 2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/can/usb/etas_es58x/es581_4.h b/drivers/net/can/usb/etas_es58x/es581_4.h
> > > index 4bc60a6df697..af38c4938859 100644
> > > --- a/drivers/net/can/usb/etas_es58x/es581_4.h
> > > +++ b/drivers/net/can/usb/etas_es58x/es581_4.h
> > > @@ -192,7 +192,7 @@ struct es581_4_urb_cmd {
> > >                 struct es581_4_rx_cmd_ret rx_cmd_ret;
> > >                 __le64 timestamp;
> > >                 u8 rx_cmd_ret_u8;
> > > -               u8 raw_msg[0];
> > > +               u8 raw_msg[USHRT_MAX];
> > >         } __packed;
> > >
> > >         __le16 reserved_for_crc16_do_not_use;
> > > diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.h b/drivers/net/can/usb/etas_es58x/es58x_fd.h
> > > index ee18a87e40c0..e0319b8358ef 100644
> > > --- a/drivers/net/can/usb/etas_es58x/es58x_fd.h
> > > +++ b/drivers/net/can/usb/etas_es58x/es58x_fd.h
> > > @@ -228,7 +228,7 @@ struct es58x_fd_urb_cmd {
> > >                 struct es58x_fd_tx_ack_msg tx_ack_msg;
> > >                 __le64 timestamp;
> > >                 __le32 rx_cmd_ret_le32;
> > > -               u8 raw_msg[0];
> > > +               u8 raw_msg[USHRT_MAX];
> > >         } __packed;
> > >
> > >         __le16 reserved_for_crc16_do_not_use;
> > > --
> > > 2.30.2
> >
> > raw_msg is part of a union so its maximum size is implicitly the
> > biggest size of the other member of that union:
>
> Yup, understood. See below...
>
> >
> > | struct es58x_fd_urb_cmd {
> > |     __le16 SOF;
> > |    u8 cmd_type;
> > |    u8 cmd_id;
> > |    u8 channel_idx;
> > |    __le16 msg_len;
> > |
> > |    union {
> > |        struct es58x_fd_tx_conf_msg tx_conf_msg;
> > |        u8 tx_can_msg_buf[ES58X_FD_TX_BULK_MAX * ES58X_FD_CANFD_TX_LEN];
> > |        u8 rx_can_msg_buf[ES58X_FD_RX_BULK_MAX * ES58X_FD_CANFD_RX_LEN];
> > |        struct es58x_fd_echo_msg echo_msg[ES58X_FD_ECHO_BULK_MAX];
> > |        struct es58x_fd_rx_event_msg rx_event_msg;
> > |        struct es58x_fd_tx_ack_msg tx_ack_msg;
> > |        __le64 timestamp;
> > |        __le32 rx_cmd_ret_le32;
> > |        u8 raw_msg[0];
> > |    } __packed;
> > |
> > |    __le16 reserved_for_crc16_do_not_use;
> > | } __packed;
> >
> > ram_msg can then be used to manipulate the other fields at the byte level.
> > I am sorry but I fail to understand why this is an issue.
>
> The issue is with using a 0-element array (these are being removed from
> the kernel[1] so we can add -Warray-bounds). Normally in this situation I
> would replace the 0-element array with a flexible array, but this
> case is unusual in several ways:
>
> - There is a trailing struct member (reserved_for_crc16_do_not_use),
>   which is never accessed (good), and documented as "please never access
>   this".

Yes. And FYI, this field is here so that
| sizeof(struct es58x_fd_urb_cmd)
returns the correct maximum size.

And, of course, because this structure will be sent to the
device, there is no possibility to reorder those fields.

> - struct es58x_fd_urb_cmd is statically allocated (it is written into
>   from the URB handler).
>
> - The message lengths coming from the USB device are stored in a u16,
>   which looked like it was possible to overflow the buffer.
>
> In taking a closer look, I see that the URB command length is checked,
> and the in-data length is checked as well, so the overflow concern
> appears to be addressed.
>
> > Also, the proposed fix drastically increases the size of the structure.
>
> Indeed. I will send a v2, now that I see that the overflow concern isn't
> an issue.

Thanks for the explanation. That makes sense.

At the end, the only goal of raw_msg[] is to have a tag pointing
to the beginning of the union. It would be virtually identical to
something like:
|    u8 raw_msg[];
|    union {
|        /* ... */
|    } __packed ;

I had a look at your work and especially at your struct_group() macro.
Do you think it would make sense to introduce a union_group()?

Result would look like:

|    union_group_attr(urb_msg, __packed, /* raw_msg renamed to urb_msg */
|        struct es58x_fd_tx_conf_msg tx_conf_msg;
|        u8 tx_can_msg_buf[ES58X_FD_TX_BULK_MAX * ES58X_FD_CANFD_TX_LEN];
|        u8 rx_can_msg_buf[ES58X_FD_RX_BULK_MAX * ES58X_FD_CANFD_RX_LEN];
|        struct es58x_fd_echo_msg echo_msg[ES58X_FD_ECHO_BULK_MAX];
|        struct es58x_fd_rx_event_msg rx_event_msg;
|        struct es58x_fd_tx_ack_msg tx_ack_msg;
|        __le64 timestamp;
|        __le32 rx_cmd_ret_le32;
|    );

And I can then use urb_msg in place of the old raw_msg (might
need a bit of rework here and there but I can take care of it).

This is the most pretty way I can think of to remove this zero length array.
Keeping the raw_msg[] but with another size seems odd to me.

Or maybe I would be the only one using this feature in the full
tree? In that case, maybe it would make sense to keep the
union_group_attr() macro local to the etas_es58x driver?

Yours sincerely,
Vincent
