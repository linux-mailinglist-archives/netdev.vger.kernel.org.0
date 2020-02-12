Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C41A15A28F
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 09:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgBLIBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 03:01:09 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38851 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728109AbgBLIBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 03:01:09 -0500
Received: by mail-oi1-f193.google.com with SMTP id l9so1188963oii.5;
        Wed, 12 Feb 2020 00:01:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KZX62Ncm7BRBCAe4drc/sfEHJXd9NYa0w9qMKq0PjM8=;
        b=QqMVPqa0vn11NKTeYrlI8UfEvB/etjkx27NA5FHWFLK2TclXkTio7yygyVHSRzs5UF
         M6Dr/oNgUFEKukikI8sD5o+OM2x1MlxigzwFLyIDSIwQwJRmKICURATQwZKR/Kqw71Mo
         bMyJ4YCI/7WB5Urm6QbjB2JnIjy4JuVVyKJ0JZnBXE+4tw+06JzELajoUO5f1JtPh4Wj
         MuoELqj3F85huGPvrY7KqqQVttpgpMyfOpOSA2gBwvVXMHDgG4c6slzwPjtaLzjGePKb
         ZsA11YM90EiozrMS/a+HUyl7t/pGJ7xBGiJs5kFBr2oTUDLVNN1aedDP200jU7Dqnxh/
         w3pA==
X-Gm-Message-State: APjAAAW5j2/zuVB04a2FRRx8adAJZLua/CjTD+z8pSZoKId+QrwpGHa9
        rl+MsByInNEK0ByejeVdxxjH0nZqyOrMOWy71lM=
X-Google-Smtp-Source: APXvYqxIAWciXgX8Kg/NU7BBZdipTfk2Iit3VO6zsFrUPVMgKeeaRMICqmTEeOvyNcdispn7Re4fuSGTerOY5ooQ4Qk=
X-Received: by 2002:a54:4707:: with SMTP id k7mr5186800oik.153.1581494468476;
 Wed, 12 Feb 2020 00:01:08 -0800 (PST)
MIME-Version: 1.0
References: <20200211174126.GA29960@embeddedor>
In-Reply-To: <20200211174126.GA29960@embeddedor>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 12 Feb 2020 09:00:57 +0100
Message-ID: <CAMuHMdV3DY1X3s7fvZz8MpxvqsUZAOivc18f40Ca8kHiZqfqKw@mail.gmail.com>
Subject: Re: [PATCH] treewide: Replace zero-length arrays with flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
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
>
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
> NOTE: I'll carry this in my -next tree for the v5.6 merge window.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Thanks!

> --- a/arch/m68k/tools/amiga/dmesg.c
> +++ b/arch/m68k/tools/amiga/dmesg.c
> @@ -34,7 +34,7 @@ struct savekmsg {
>      u_long magic2;     /* SAVEKMSG_MAGIC2 */
>      u_long magicptr;   /* address of magic1 */
>      u_long size;
> -    char data[0];
> +       char data[];
>  };

JFTR, this file is not really part of the kernel, but supposed to be compiled
by an AmigaOS compiler, which may predate the introduction of support
for flexible array members.

Well, even if you keep it included, I guess the rare users can manage ;-)
My binary dates back to 1996, and I have no plans to recompile it.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
