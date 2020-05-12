Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED101CEE64
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 09:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgELHns convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 May 2020 03:43:48 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46193 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgELHnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 03:43:47 -0400
Received: by mail-ot1-f66.google.com with SMTP id z25so9733775otq.13;
        Tue, 12 May 2020 00:43:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WL99cZpSCjAY9uTUemuiOdybxhEn/p8SNKkMW2pnMgk=;
        b=UWfiuJ1JfrhBaZAuKcvb251vQMZUZxP6ntM+CasVEGUuDByMshQ4AkU7RrnO4/SlLz
         X4oYzFb6UliokNfhYEgnBC0nnyNQpZmc+O7fGZr5amyPhr1cIIe/4rSuCm8gqlgj/FQr
         ++kyEpzk6RO3nmTIGO0Uge5OlEHbsOKrpeHDSmItzOri1HNVpqoGdEJofGG4IAmpumTj
         UPTpxnUFJwSNCambQMmeRTyoozBAdUSt08yoJl9zYDbQj51ZR14f1cSCR9BNXhVy1irk
         i4U5SA/GB+/uUEvfLp0GITSwUidSTuTtLBsJXY8MztmWIbRjXsQb/HUdmHpPKshIyDnE
         HYXA==
X-Gm-Message-State: AGi0PuanBb5RTaSTFotTjFYhnFbmUJ66ufhnGx5DFq9u/NqaDRTOs8Dk
        7AafZ7YqJzOjnKxR3HJPE4g5NTLs9qfmqCKOUcQ=
X-Google-Smtp-Source: APiQypIDWmbHTXLtnOKXo30M5B3vTkf3nDlAfbBCqheKh4YZxA4lrYnndNhzQpgu3wBVeeut/IwxOF4lTFymYCLt8jo=
X-Received: by 2002:a9d:7990:: with SMTP id h16mr15276353otm.145.1589269426183;
 Tue, 12 May 2020 00:43:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200511154930.190212-1-Jerome.Pouiller@silabs.com> <20200511154930.190212-14-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200511154930.190212-14-Jerome.Pouiller@silabs.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 12 May 2020 09:43:34 +0200
Message-ID: <CAMuHMdVZxy+FZGPhDxotCBeEX3O4ZMkmGAwmVFXQE9ZoijDN5g@mail.gmail.com>
Subject: Re: [PATCH 13/17] staging: wfx: fix endianness of the field 'len'
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     driverdevel <devel@driverdev.osuosl.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jerome,

On Mon, May 11, 2020 at 5:53 PM Jerome Pouiller
<Jerome.Pouiller@silabs.com> wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
>
> The struct hif_msg is received from the hardware. So, it declared as
> little endian. However, it is also accessed from many places in the
> driver. Sparse complains about that:
>
>     drivers/staging/wfx/bh.c:88:32: warning: restricted __le16 degrades to integer
>     drivers/staging/wfx/bh.c:88:32: warning: restricted __le16 degrades to integer
>     drivers/staging/wfx/bh.c:93:32: warning: restricted __le16 degrades to integer
>     drivers/staging/wfx/bh.c:93:32: warning: cast to restricted __le16
>     drivers/staging/wfx/bh.c:93:32: warning: restricted __le16 degrades to integer
>     drivers/staging/wfx/bh.c:121:25: warning: incorrect type in argument 2 (different base types)
>     drivers/staging/wfx/bh.c:121:25:    expected unsigned int len
>     drivers/staging/wfx/bh.c:121:25:    got restricted __le16 [usertype] len
>     drivers/staging/wfx/hif_rx.c:27:22: warning: restricted __le16 degrades to integer
>     drivers/staging/wfx/hif_rx.c:347:39: warning: incorrect type in argument 7 (different base types)
>     drivers/staging/wfx/hif_rx.c:347:39:    expected unsigned int [usertype] len
>     drivers/staging/wfx/hif_rx.c:347:39:    got restricted __le16 const [usertype] len
>     drivers/staging/wfx/hif_rx.c:365:39: warning: incorrect type in argument 7 (different base types)
>     drivers/staging/wfx/hif_rx.c:365:39:    expected unsigned int [usertype] len
>     drivers/staging/wfx/hif_rx.c:365:39:    got restricted __le16 const [usertype] len
>     drivers/staging/wfx/./traces.h:195:1: warning: incorrect type in assignment (different base types)
>     drivers/staging/wfx/./traces.h:195:1:    expected int msg_len
>     drivers/staging/wfx/./traces.h:195:1:    got restricted __le16 const [usertype] len
>     drivers/staging/wfx/./traces.h:195:1: warning: incorrect type in assignment (different base types)
>     drivers/staging/wfx/./traces.h:195:1:    expected int msg_len
>     drivers/staging/wfx/./traces.h:195:1:    got restricted __le16 const [usertype] len
>     drivers/staging/wfx/debug.c:319:20: warning: restricted __le16 degrades to integer
>     drivers/staging/wfx/secure_link.c:85:27: warning: restricted __le16 degrades to integer
>     drivers/staging/wfx/secure_link.c:85:27: warning: restricted __le16 degrades to integer

Thanks for your patch!

> In order to make Sparse happy and to keep access from the driver easy,
> this patch declare 'len' with native endianness.
>
> On reception of hardware data, this patch takes care to do byte-swap and
> keep Sparse happy.

Which means sparse can no longer do any checking on the field,
and new bugs may/will creep in in the future, unnoticed.

> --- a/drivers/staging/wfx/hif_api_general.h
> +++ b/drivers/staging/wfx/hif_api_general.h
> @@ -23,7 +23,10 @@
>  #define HIF_COUNTER_MAX           7
>
>  struct hif_msg {
> -       __le16 len;
> +       // len is in fact little endian. However, it is widely used in the
> +       // driver, so we declare it in native byte order and we reorder just
> +       // before/after send/receive it (see bh.c).
> +       u16    len;

While there's a small penalty associated with always doing the conversion
on big-endian platforms, it will probably be lost in the noise anyway.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
