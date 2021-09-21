Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C146412D62
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 05:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhIUD0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 23:26:17 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:38566 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352791AbhIUCzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:55:03 -0400
Received: by mail-lf1-f45.google.com with SMTP id x27so75642318lfu.5;
        Mon, 20 Sep 2021 19:53:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IC0pg/XX+TI+s5bIXMNwch4sO7j1nEoBLODd5HuH4zo=;
        b=nA84a7kTHr4gQHJosCqtcn8rA1p1+oJf9gjAblY1sajKurT8QteAyV8qutsAvhQrg+
         Sao5l79ccRXA44NvSb4E7qu2zsci+QJyhu7OHc0G+2YoX5R8nVb/5+fXi95w1y75gjjR
         pLxWBKO8UeOmEpIyDMJgpUUsdrtDY85K+hryRwI44WqVFyS5084SYQBhImmwG58W8YNc
         3X7EVfJSFn32LVmmsAIyywY6xtNnjQABDHDFuEv5BqUXa9C0Mx8Sibb4xC2M3nIyhvjG
         Zxa/H4tGKNrngBbzWQj1HWjty5ivO+81OmHVv/j3SKSGwLVI5Im7SpEMtfLF6UGhMOC+
         W5nw==
X-Gm-Message-State: AOAM531WFM4ps+OGUdmKG/z5T9XzNX3zNj0YdxINR4NFqtzacb24jHIm
        5gxkx7IpzoNJcZSYNSopgPFp7KkY0Shj7zmrrGY=
X-Google-Smtp-Source: ABdhPJxBcBj27N0TTO69dgMarQ2SCYu+PhTbfemZzP4y8lLoYVpqH62I91YWXTrklj655Qn1US/umvEUN/gNtO1y80c=
X-Received: by 2002:a2e:a782:: with SMTP id c2mr25735230ljf.388.1632192814113;
 Mon, 20 Sep 2021 19:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210920123045.795228-1-arnd@kernel.org>
In-Reply-To: <20210920123045.795228-1-arnd@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 21 Sep 2021 11:53:22 +0900
Message-ID: <CAMZ6Rq+pfOHGshH=U3ZtzooD9sHvAz+=i2vdEcqF8Xv=q4eexQ@mail.gmail.com>
Subject: Re: [PATCH] can: etas_es58x: avoid -Wzero-length-bounds warning
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,
+CC: Kees Cook

On Mon. 20 Sep 2021 at 21:30, Arnd Bergmann <arnd@kernel.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> gcc complains when writing into a zero-length array:
>
> drivers/net/can/usb/etas_es58x/es581_4.c: In function 'es581_4_tx_can_msg':
> drivers/net/can/usb/etas_es58x/es581_4.c:374:42: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[]'} [-Wzero-length-bounds]
>   374 |         tx_can_msg = (typeof(tx_can_msg))&es581_4_urb_cmd->raw_msg[msg_len];
>       |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from drivers/net/can/usb/etas_es58x/es58x_core.h:21,
>                  from drivers/net/can/usb/etas_es58x/es581_4.c:15:
> drivers/net/can/usb/etas_es58x/es581_4.h:195:20: note: while referencing 'raw_msg'
>   195 |                 u8 raw_msg[0];
>       |                    ^~~~~~~
>   CC [M]  drivers/net/can/usb/etas_es58x/es58x_fd.o
> drivers/net/can/usb/etas_es58x/es58x_fd.c: In function 'es58x_fd_tx_can_msg':
> drivers/net/can/usb/etas_es58x/es58x_fd.c:360:42: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[]'} [-Wzero-length-bounds]
>   360 |         tx_can_msg = (typeof(tx_can_msg))&es58x_fd_urb_cmd->raw_msg[msg_len];
>       |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from drivers/net/can/usb/etas_es58x/es58x_core.h:22,
>                  from drivers/net/can/usb/etas_es58x/es58x_fd.c:17:
> drivers/net/can/usb/etas_es58x/es58x_fd.h:222:20: note: while referencing 'raw_msg'
>   222 |                 u8 raw_msg[0];
>       |                    ^~~~~~~
>
> The solution is usually to use a flexible-array member the struct, but
> we can't directly have that inside of a union, nor can it be the only
> member of a struct, so add a dummy struct with another zero-length
> member to get the intended behavior.
>
> If someone has a better workaround, let me know and I can send a new
> patch, as this version is rather ugly.

Actually, there is one. Kees Cook introduced a new macro,
DECLARE_FLEX_ARRAY(), to do this in a more elegant way:
https://lkml.org/lkml/2021/8/27/524

The same series also fixes the warning in the etas_es58x driver:
https://lkml.org/lkml/2021/8/27/523

So we only need to wait for Kees's series to get merged :)


Yours sincerely,
Vincent Mailhol
