Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B234522E26F
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 22:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgGZUHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 16:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgGZUHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 16:07:40 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA85C0619D2;
        Sun, 26 Jul 2020 13:07:39 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id j9so7967479ilc.11;
        Sun, 26 Jul 2020 13:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hepoEcj03sM0CyU8joldRCATVzSo814tkMYfqpOgn8Q=;
        b=R90fe9DZCZzsKaiZN6ZyStpg7gXNGe8uBdtvnltvSyM1GUusMVJH+adyWtYPGeIQQ5
         mT+8va8Vauu42JeMx8EvhRq0taB4YYKz+HutaLZI1N38fBKQq0lb+885IKovVZKEuyMk
         j1HU1yMnnIgHCo7nBsRwJIJltfsJNnVb/DvjoDDyNnIKvfbPyHrlx1NQdBlmkwkWtxIh
         bIv6nNn8Xe/QrKBXWDgJbvccBox4ItHPIGrIQC/s9YKNirgPktlEB/bLHCe50OJ+bh7w
         UAoOb9+4lAgZmSgAXjYcA75Td/XPNe23b9OTOMO6qrF3NtwzNZD+BKJyDQoAoBdGC+pS
         oI2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hepoEcj03sM0CyU8joldRCATVzSo814tkMYfqpOgn8Q=;
        b=q44chjjjBBSn3WBr8F7UXhO+9CSj1jVBqRfmXNYzFb3g3Wduew49kyyvGcwlV0p86v
         CahyWLrSlCLr9/VRDKXqkWGnfAm+Rq6st5gABKWuqNgXScCvKh6LRqCuNHDNlPDGwzLA
         7xj7DI+1aLE+qaiuxQOh3ni9LaPDdTQBBTahgvIhjqAUe35iTmvUQQzgOK52Vjur9EkA
         q5PAtdP1zPg5cMnkwBb6igwuPOF0A2Xdn9Yyu9D7Go80eU/MB5h4gcRiRNxpIjy0oKzt
         dHnGTEv11Su2PXNQgedj7N3Fle3PHk6i06Tbo4qZgPjZZDvhOWi6khnU1SKCY+5fBPyO
         ftDA==
X-Gm-Message-State: AOAM533VqSdUgS/rqX/yVcxhEYHipynoesdvNkHihvK1OBzurUOvOArs
        mpxBE21YNjXKvi9DeH89rqzmnlM32Vsx1KRI9E0=
X-Google-Smtp-Source: ABdhPJzMdNT6/iybFIAQG6sXZTJJd77PEH+FsQ+sZ/OEpvpeVmZKHQ2bJntZvMLWneIs6gNhhyuhZqAiFnl0QABDUYw=
X-Received: by 2002:a92:9a45:: with SMTP id t66mr18391483ili.268.1595794058048;
 Sun, 26 Jul 2020 13:07:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200726030855.q6dfjekazfzl5usw@pesu.pes.edu> <CAM_iQpUFL7VdCKSgUa6N3pg7ijjZRu6-6UAs2oNosM-EzgXbaQ@mail.gmail.com>
 <CAAhDqq28h9_ji=ANttUyx2Q1Md=bZD3-JVCwQRW06W7aikPN0A@mail.gmail.com>
In-Reply-To: <CAAhDqq28h9_ji=ANttUyx2Q1Md=bZD3-JVCwQRW06W7aikPN0A@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 26 Jul 2020 13:07:25 -0700
Message-ID: <CAM_iQpX+iw+5AALriNZLfx5P-LV_ratiwhMRiHXmuLE2z81aaw@mail.gmail.com>
Subject: Re: [PATCH v2] net: ipv6: fix use-after-free Read in __xfrm6_tunnel_spi_lookup
To:     B K Karthik <bkkarthik@pesu.pes.edu>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 11:12 PM B K Karthik <bkkarthik@pesu.pes.edu> wrote:
>
> On Sun, Jul 26, 2020 at 11:05 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Sat, Jul 25, 2020 at 8:09 PM B K Karthik <bkkarthik@pesu.pes.edu> wrote:
> > > @@ -103,10 +103,10 @@ static int __xfrm6_tunnel_spi_check(struct net *net, u32 spi)
> > >  {
> > >         struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
> > >         struct xfrm6_tunnel_spi *x6spi;
> > > -       int index = xfrm6_tunnel_spi_hash_byspi(spi);
> > > +       int index = xfrm6_tunnel_spi_hash_byaddr((const xfrm_address_t *)spi);
> > >
> > >         hlist_for_each_entry(x6spi,
> > > -                            &xfrm6_tn->spi_byspi[index],
> > > +                            &xfrm6_tn->spi_byaddr[index],
> > >                              list_byspi) {
> > >                 if (x6spi->spi == spi)
> >
> > How did you convince yourself this is correct? This lookup is still
> > using spi. :)
>
> I'm sorry, but my intention behind writing this patch was not to fix
> the UAF, but to fix a slab-out-of-bound.

Odd, your $subject is clearly UAF, so is the stack trace in your changelog.
:)


> If required, I can definitely change the subject line and resend the
> patch, but I figured this was correct for
> https://syzkaller.appspot.com/bug?id=058d05f470583ab2843b1d6785fa8d0658ef66ae
> . since that particular report did not have a reproducer,
> Dmitry Vyukov <dvyukov@google.com> suggested that I test this patch on
> other reports for xfrm/spi .

You have to change it to avoid misleading.

>
> Forgive me if this was the wrong way to send a patch for that
> particular report, but I guessed since the reproducer did not trigger
> the crash
> for UAF, I would leave the subject line as 'fix UAF' :)
>
> xfrm6_spi_hash_by_hash seemed more convincing because I had to prevent
> a slab-out-of-bounds because it uses ipv6_addr_hash.
> It would be of great help if you could help me understand how this was
> able to fix a UAF.

Sure, you just avoid a pointer deref, which of course can fix the UAF,
but I still don't think it is correct in any aspect.

Even if it is a OOB, you still have to explain why it happened. Once
again, I can't see how it could happen either.

>
> >
> > More importantly, can you explain how UAF happens? Apparently
> > the syzbot stack traces you quote make no sense at all. I also
> > looked at other similar reports, none of them makes sense to me.
>
> Forgive me, but I do not understand what you mean by the stack traces
> (this or other similar reports) "make no sense".

Because the stack trace in your changelog clearly shows it is allocated
in tomoyo_init_log(), which is a buffer in struct tomoyo_query, but
none of xfrm paths uses it. Or do you see anything otherwise?

Thanks.
