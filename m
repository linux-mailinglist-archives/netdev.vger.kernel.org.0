Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F06A39CF9B
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 16:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhFFOm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 10:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhFFOmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 10:42:52 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5C7C061766;
        Sun,  6 Jun 2021 07:41:02 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id w15so18290947ljo.10;
        Sun, 06 Jun 2021 07:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V+VQqbr+HWpVtU96EDTK4cz59cFWA3McxCpzstRJ2Tk=;
        b=YHDeJwekUG0Gl6MUE1DBa7d+qzmxYzcWiiSr6n5Z0L2baYXh4gGORm98wn9Nb/et6J
         kcS58UZkb2lyntDqdm9DxuIehfIsW/QZAJ8rPV1PyaOjIOYihlVriMtHTEz6nTEIst9G
         Q6jHsRF56U4zD2F3xnT8KwqlFdo3Z5wdPURLFXcP37IKKCO7BbDCUFgoEqMCVkcrgkEB
         4ojHNYEhNulufiFW7C5kc5Nwseteq1drB2rto0xdA8dDeastmYfiRN6pErouiNS8jHIg
         qhykKID+E85H6BZ69bgYAt7LWytYKgvWll+C0S2LAwMqMb4RRbk970q5+Gju874zrmPk
         keIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V+VQqbr+HWpVtU96EDTK4cz59cFWA3McxCpzstRJ2Tk=;
        b=A7BAQjGNdI71I2K/vpHzI8Ct8Z6fOKJ/rMn3RttZItHk0t7goOFoR4Lc8Qu1bN8Y8X
         xInpPgKyP3rxd0HCNLjIHMPqwv6TWjrKzBX0WkVr8mVYyeXZagBLq9OpvQeqot9cyX1F
         /AvB5+ZlZ0Uliv8jlx5oRwotng1oIRBDRc4vfCv5go6e8XijfQtqEvIhSqaWYl3z0haf
         RN85aHBKSZIraqXhx97ukuaKonN0XYEBosp5q0MwRVU70JezdFBqh2kgqCo4igG9JUEl
         N1slm7p5bgnNZ3UkNe9hYDYKx47IbRz1AJRMXlkJfcM3nfxzI/PaIabpSYfiDK6nSTmg
         UZNg==
X-Gm-Message-State: AOAM531oGox2V74+EoVjJ/AjDp5S5dSnZLHwSfG2nxGsZeJKK7aD+Ljg
        /FpgkESXs9QUtTxoKpgtH1HfGfj8AbaiP5lCSso=
X-Google-Smtp-Source: ABdhPJyOuZJy0EalPIAQqe5bGOWe11Mgw0zgNqrBLc6w4fRHwNS6WEbfjqe3DGI1Mc7ncvbX7HGQDLUxRFOy7SNYUrE=
X-Received: by 2002:a2e:5347:: with SMTP id t7mr11257632ljd.464.1622990460716;
 Sun, 06 Jun 2021 07:41:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210604074419.53956-1-dong.menglong@zte.com.cn>
 <e997a058-9f6e-86a0-8591-56b0b89441aa@redhat.com> <CADxym3ZostCAY0GwUpTxEHcOPyOj5Lmv4F7xP-Q4=AEAVaEAxw@mail.gmail.com>
 <998cce2c-b18d-59c1-df64-fc62856c63a1@redhat.com>
In-Reply-To: <998cce2c-b18d-59c1-df64-fc62856c63a1@redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Sun, 6 Jun 2021 22:40:49 +0800
Message-ID: <CADxym3a_iTXWWOxK1vfNxuWRh7ve4vOWZERho7jTVUkxc2Z_rQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: tipc: fix FB_MTU eat two pages
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     ying.xue@windriver.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 10:25 PM Jon Maloy <jmaloy@redhat.com> wrote:
>
>
>
> On 6/4/21 9:28 PM, Menglong Dong wrote:
> > Hello Maloy,
> >
> > On Sat, Jun 5, 2021 at 3:20 AM Jon Maloy <jmaloy@redhat.com> wrote:
> >>
> > [...]
> >> Please don't add any extra file just for this little fix. We have enough
> >> files.
> >> Keep the macros in msg.h/c where they used to be.  You can still add
> >> your copyright line to those files.
> >> Regarding the macros kept inside msg.c, they are there because we design
> >> by the principle of minimal exposure, even among our module internal files.
> >> Otherwise it is ok.
> >>
> > I don't want to add a new file too, but I found it's hard to define FB_MTU. I
> > tried to define it in msg.h, and 'crypto.h' should be included, which
> > 'BUF_HEADROOM' is defined in. However, 'msg.h' is already included in
> > 'crypto.h', so it doesn't work.
> >
> > I tried to define FB_MTU in 'crypto.h', but it feels weird to define
> > it here. And
> > FB_MTU is also used in 'bcast.c', so it can't be defined in 'msg.c'.
> >
> > I will see if there is a better solution.
> I think we can leverage the fact that this by definition is a node local
> message, and those are never encrypted.
> So, if you base FB_MTU on the non-crypto versions of BUF_HEADROOM and
> BUF_TAILROOM we should be safe.
> That will even give us better utilization of the space available.
>

Ok, that sounds nice. I'll make a V2 based on that.

Thanks!
Menglong Dong
