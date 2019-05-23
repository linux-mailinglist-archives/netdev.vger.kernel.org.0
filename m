Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D897727877
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 10:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfEWIvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 04:51:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45581 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfEWIvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 04:51:19 -0400
Received: by mail-qt1-f194.google.com with SMTP id t1so5768662qtc.12;
        Thu, 23 May 2019 01:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G/4b99ppThyzVBjBPQF+fjXgPnHh7TF65Bh6HAL+CAA=;
        b=iFQSvgGEi/wnsVDHD3d2/T7gIoSuhHyhAWlPcj3h16JjOG0JWVNSzRCgFWNFrCqHvq
         argIZdS1fQFfc5vI4uWYO00olGvHzlOkZjUHjF2c0LWvOzCkmQS+zJFcjixyOlzwkuDz
         0/jIxiRafQoAcoyzCPqXiB5YMADg3e5NERv2x3nBKZTPgag5NReR+beeBrBYY0ffYUaz
         UK4YC+GkPp+wIsx0QNdEeFyZSbmQqHugOwYL2BSzRVdsMgKXHQC2VqgCplurdeNvkOa3
         RrkXHcu98oO6IjndAsxaTWRr9YttklOV+MnRdXSwkk+1VoT1BpYsfHa5+fhwhLxnHWW9
         hXuQ==
X-Gm-Message-State: APjAAAXSMJ8HYYdXPKovohrAn/sk9UOI4OwCnhOm4g7PWUdaqRIobPdp
        yVQNZFq2t81D7Psq7hrhy/W+g+E7lf4bUv0U4OE=
X-Google-Smtp-Source: APXvYqz1mhfFsmpde2hm5zn0CKwPeOeJVfXj4XsHMSIoPLUZWkSUMq+0rPz7Qf99e4MM4Xocw9e6dHu+Ltod5QGW6WI=
X-Received: by 2002:ac8:1c51:: with SMTP id j17mr78503342qtk.7.1558601478000;
 Thu, 23 May 2019 01:51:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190502151548.11143-1-natechancellor@gmail.com>
 <CAKwvOd=nvKGGW5jvN+WFUXzOm9xeiNNUD0F9--9YcpuRmnWWhA@mail.gmail.com>
 <20190503031718.GB6969@archlinux-i9> <20190523015415.GA17819@archlinux-epyc>
In-Reply-To: <20190523015415.GA17819@archlinux-epyc>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 23 May 2019 10:51:01 +0200
Message-ID: <CAK8P3a001V5qQo4vGfpugtmrnFfUNeP_q4KY-YS7rP_L91HY1A@mail.gmail.com>
Subject: Re: [PATCH] rsi: Properly initialize data in rsi_sdio_ta_reset
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 3:54 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Thu, May 02, 2019 at 08:17:18PM -0700, Nathan Chancellor wrote:
> > On Thu, May 02, 2019 at 11:18:01AM -0700, Nick Desaulniers wrote:
> > > On Thu, May 2, 2019 at 8:16 AM Nathan Chancellor
> > > u8 data [4];
> >
> > data was __le32 in rsi_reset_chip() before commit f700546682a6 ("rsi:
> > fix nommu_map_sg overflow kernel panic").
> >
> > I wonder if this would be okay for this function:
> >
> > -------------------------------------------------
> >
> > diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> > index f9c67ed473d1..0330c50ab99c 100644
> > --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
> > +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> > @@ -927,7 +927,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
> >  {
> >         int status;
> >         u32 addr;
> > -       u8 *data;
> > +       u8 data;
> >
> >         status = rsi_sdio_master_access_msword(adapter, TA_BASE_ADDR);
> >         if (status < 0) {
> > @@ -937,7 +937,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
> >         }
> >
> >         rsi_dbg(INIT_ZONE, "%s: Bring TA out of reset\n", __func__);
> > -       put_unaligned_le32(TA_HOLD_THREAD_VALUE, data);
> > +       put_unaligned_le32(TA_HOLD_THREAD_VALUE, &data);
> >         addr = TA_HOLD_THREAD_REG | RSI_SD_REQUEST_MASTER;
> >         status = rsi_sdio_write_register_multiple(adapter, addr,
> >                                                   (u8 *)&data,

This is clearly not ok, as put_unaligned_le32() stores four bytes, and
the local variable is only one byte!

Also, sdio does use DMA for transfers, so the variable has to be
dynamically allocated. I think your original patch was correct.
The only change I'd possibly make would be to use
RSI_9116_REG_SIZE instead of sizeof(u32).

> Did any of the maintainers have any comments on what the correct
> solution is here to resolve this warning? It is one of the few left
> before we can turn on -Wuninitialized for the whole kernel.

I would argue that this should not stop us from turning it on, as the
warning is for a clear bug in the code that absolutely needs to be
fixed, rather than a false-positive.

       Arnd
