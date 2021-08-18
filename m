Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FC13F00A0
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhHRJf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:35:58 -0400
Received: from mail-lj1-f173.google.com ([209.85.208.173]:35707 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbhHRJe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 05:34:28 -0400
Received: by mail-lj1-f173.google.com with SMTP id y6so3964461lje.2;
        Wed, 18 Aug 2021 02:33:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CzC7eMg6GoorXihbZpnBiMn0rer4lRtJPAUz1wNS7Ds=;
        b=DLZXoPf7Dv9d35O+flm97fCaasEQnPwFPFtSRBSvjLOsvq5Xixo7UkXN/U09L/Htaq
         QEXQQ38ScqBKZDJ5wH2iCa9yGbeCiKj4H3Ls6vwIKKPTfeAK/uZMb/gEJgxtPK3UQukP
         txvFkcsI2/rQNRKouXjwUNrtPRZZR5ISjKZ637+FQl/1vj5buwDFQlSY1xMLtp9ar8xN
         6myV1g4EWi4zDuYv8RJuOrlZcr4wA1ji4mR8W70L6dw2Dh2LOzITt7F2XgA6MMYWMjkm
         JKYKFU8HH9VBf7QobF7QvMtMCm8pcLlym9r/noUYVVeg+Liy1fFq9+kAFMxe+Akfn1sV
         9N/A==
X-Gm-Message-State: AOAM532CQi+7UVwEX2cfdxrqMI+OVOTLYg6ZPijsrgIV7dat5kd+F/jA
        b10xeC9LuUnmO4pIB/Iu3RW2WhyQBqOh0OVnfi4=
X-Google-Smtp-Source: ABdhPJwHqkci/wVHZz1RIQo9bHJpWPoiaE+GXkLl0fV34qDOm85KGMeIPwC/RwTgPkoYJWCGg83a0bkp1B1FDN32yQQ=
X-Received: by 2002:a2e:a288:: with SMTP id k8mr6989386lja.315.1629279230564;
 Wed, 18 Aug 2021 02:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210818034010.800652-1-keescook@chromium.org>
 <CAMZ6RqK4Rn4d-1CZsg9vJiAMHhxN6fgcqukdHpGwXoGTyNVr_Q@mail.gmail.com>
 <202108172320.1540EC10C@keescook> <CAMZ6RqLecbytJFQDC35n7YiqBbrB3--POofnXFeH77Zi2xzqWA@mail.gmail.com>
 <202108180159.5C1CEE70F@keescook>
In-Reply-To: <202108180159.5C1CEE70F@keescook>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 18 Aug 2021 18:33:39 +0900
Message-ID: <CAMZ6RqK=Q3mvV5gyPVhBsFxE+JPANHNrgFqs=bvTgkbXjwT4Eg@mail.gmail.com>
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

On Wed. 18 Aug 2021 at 18:03, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Aug 18, 2021 at 04:55:20PM +0900, Vincent MAILHOL wrote:
> > At the end, the only goal of raw_msg[] is to have a tag pointing
> > to the beginning of the union. It would be virtually identical to
> > something like:
> > |    u8 raw_msg[];
> > |    union {
> > |        /* ... */
> > |    } __packed ;
> >
> > I had a look at your work and especially at your struct_group() macro.
> > Do you think it would make sense to introduce a union_group()?
> >
> > Result would look like:
> >
> > |    union_group_attr(urb_msg, __packed, /* raw_msg renamed to urb_msg */
> > |        struct es58x_fd_tx_conf_msg tx_conf_msg;
> > |        u8 tx_can_msg_buf[ES58X_FD_TX_BULK_MAX * ES58X_FD_CANFD_TX_LEN];
> > |        u8 rx_can_msg_buf[ES58X_FD_RX_BULK_MAX * ES58X_FD_CANFD_RX_LEN];
> > |        struct es58x_fd_echo_msg echo_msg[ES58X_FD_ECHO_BULK_MAX];
> > |        struct es58x_fd_rx_event_msg rx_event_msg;
> > |        struct es58x_fd_tx_ack_msg tx_ack_msg;
> > |        __le64 timestamp;
> > |        __le32 rx_cmd_ret_le32;
> > |    );
> >
> > And I can then use urb_msg in place of the old raw_msg (might
> > need a bit of rework here and there but I can take care of it).
> >
> > This is the most pretty way I can think of to remove this zero length array.
> > Keeping the raw_msg[] but with another size seems odd to me.
> >
> > Or maybe I would be the only one using this feature in the full
> > tree? In that case, maybe it would make sense to keep the
> > union_group_attr() macro local to the etas_es58x driver?
>
> I actually ended up with something close to this idea, but more
> generalized for other cases in the kernel. There was a sane way to
> include a "real" flexible array in a union (or alone in a struct), so
> I've proposed this flex_array() helper:
> https://lore.kernel.org/lkml/20210818081118.1667663-2-keescook@chromium.org/
>
> and then it's just a drop-in replacement for all the places that need
> this fixed, including etas_es58x:
> https://lore.kernel.org/lkml/20210818081118.1667663-3-keescook@chromium.org/#Z30drivers:net:can:usb:etas_es58x:es581_4.h
>
> Hopefully this will work out; I think it's as clean as we can get for
> now. :)

The __flex_array itself is a nasty hack :D but the rest is clean.

Is this compliant to the C standard? Well, I guess that as long
as both GCC and LLVM supports it, it is safe to add it to the
kernel.

I like the final result. I will do a bit more testing and give my
acknowledgement if everything goes well.


Yours sincerely,
Vincent
