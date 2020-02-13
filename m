Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23B215BD5F
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 12:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbgBMLJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 06:09:21 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38266 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgBMLJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 06:09:20 -0500
Received: by mail-ot1-f68.google.com with SMTP id z9so5170961oth.5;
        Thu, 13 Feb 2020 03:09:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rh+bWg1peeSmVzyxxXOPGQpNTf1aI4Yae1qitHYFzC0=;
        b=kzhbr9MBqncwI+6BAOWb+rhiD9tVNUk4Z2RCOC7+Y0jsF/6BuiNssd4poEdTscvNge
         814VqTPT3dRLW+ttil4Eo/aXwnZ8mq3Ok4Wna21Kdwq1aD8AJ4tG/gjGvdlgk8Imvjtf
         HRXtyJp9mvjjP1Wmmq3GF/EWYKqBirQiKx2lFmgfhBupo7VWi2lqi0fTDDDe9+T31B+5
         VJYdv70B0NOjOV2ThgPGLtlgHpDMgN47ZV1qBNvJ78u7PFXyeJYsckxDg2SYUuSQjCYa
         utziGj8Hw4V4DIIfVxms7KvKfOK0NtBYakbLmd/c0lsW9DtiSQqC9yssvDzhGmk7waDa
         Extw==
X-Gm-Message-State: APjAAAUa9hYxyxmreemfGzRrAALrZ0UGs5pM5yJ9Xga1SwM+bZT3s2GV
        kouL5oV/CeX4n+HTOROcJgIoIZHGNZ5QRbhD5B1uvu4U
X-Google-Smtp-Source: APXvYqyUXZecOa5y8YQteeH6PJjeQnUGb2JBJGFxp9TbCjcYGL69hpvf7ToH3S8CyVvwVpokTq8RQvTsXTjARXZoGvI=
X-Received: by 2002:a9d:dc1:: with SMTP id 59mr13000694ots.250.1581592159889;
 Thu, 13 Feb 2020 03:09:19 -0800 (PST)
MIME-Version: 1.0
References: <20200211174126.GA29960@embeddedor>
In-Reply-To: <20200211174126.GA29960@embeddedor>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 13 Feb 2020 12:09:08 +0100
Message-ID: <CAMuHMdVZq3Lho0HxEvhv8di=OCBhvNEo=O198b1iayX_Wz_QcA@mail.gmail.com>
Subject: Re: [PATCH] treewide: Replace zero-length arrays with flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo,

On Tue, Feb 11, 2020 at 10:49 PM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
>
> struct foo {
>         int stuff;
>         struct boo array[];
> };
>
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> unadvertenly introduced[3] to the codebase from now on.
>
> All these instances of code were found with the help of the following
> Coccinelle script:
>
> @@
> identifier S, member, array;
> type T1, T2;
> @@
>
> struct S {
>   ...
>   T1 member;
>   T2 array[
> - 0
>   ];
> };

I've stumbled across one more in include/uapi/linux/usb/ch9.h:

    struct usb_key_descriptor {
            __u8  bLength;
            __u8  bDescriptorType;

            __u8  tTKID[3];
            __u8  bReserved;
            __u8  bKeyData[0];
    } __attribute__((packed));

And it seems people are (ab)using one-sized arrays for flexible arrays, too:

    struct usb_string_descriptor {
            __u8  bLength;
            __u8  bDescriptorType;

            __le16 wData[1];                /* UTF-16LE encoded */
    } __attribute__ ((packed));

As this is UAPI, we have to be careful for regressions, though.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
