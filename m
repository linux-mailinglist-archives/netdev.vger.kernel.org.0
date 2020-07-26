Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9970022DC44
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 08:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgGZGM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 02:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgGZGM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 02:12:56 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2F7C0619D4
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 23:12:56 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h19so13867480ljg.13
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 23:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pesu-pes-edu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mjFcFPkYV6UQ15e1Sw/cnOMTT80K9lOv0sYuMsnpbg8=;
        b=Oq/JKnUlAX9SgNCIN2rS3ntngRStgdIT5wRDVT1qa5YLa6Xljk4gSLakcYqNbwrf4A
         rNXx4HHTqH0Jh2YjKKQi/eGniW+FMfKa74XyMOhhUKiBGr82wanEaf2ej/YPHZ84/MW5
         IHBmbmbvb1UHIJB1PK9YIzeRm6OE5HEoJJgJ8zslayrKOxWXPkl+goJIUta9pEsJw4PF
         gl3g15nkqfCCvCDV2tY9EKe6VG/4n5Fgzyi8abxE7bayEIU9QrSCUWM1V+jBAqIWoaYx
         jGT5pKGDbSu1KJX+0PtRUxOKXmPipyez2I/Qew4fXGDxujA6P6TVWTEg0HHlL3Q2D3DE
         P06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mjFcFPkYV6UQ15e1Sw/cnOMTT80K9lOv0sYuMsnpbg8=;
        b=XwGKyqXVA8/0kZsfeR9G9t1ZJX0ni9sIt6Sve0OLIkya2kd8QAmkPkwKN7P9agdmRz
         VEcFqC6JIrEaeK6nLrAAmC4EuhQjMezcDgVmfVnh3foY9AdWHjfITUqgno+sqdj+va/v
         sHFkklW3MlgB8iLWvB/7y4D2P0qokeWcbRPgYeWqPHxNHfBlSImToJ43Vbes6KaP981M
         kxnEKqORX+zyYkqyJVGYJ/F5UuL33xlpvcT80YLbCP81w+rejrr9Tx1liwRqb2e/8ZqK
         WDY9Y5NZeYeXl97x4UgCEE1gNOTTocoencBSJi7iTt8gRCx/CLhViob175DlUxQq9R3H
         SRtg==
X-Gm-Message-State: AOAM532TvT9kodRk1lTLre4anfkg1ismgQevm3os2+Ci6AWMt6eVDhVy
        mopBBvtTxmBagnML1ZQ/qLPs/j+o8CwjsaAnaRIN/w==
X-Google-Smtp-Source: ABdhPJzLAZZeMuZM0RtO55UD2RjUIs4qLuxl6cAGSb+bhh8HpFUnkvUeSQFum4N/+Mm8ZHnpyXRsev9eXIbtReWvkS8=
X-Received: by 2002:a2e:9c59:: with SMTP id t25mr7286391ljj.402.1595743974346;
 Sat, 25 Jul 2020 23:12:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200726030855.q6dfjekazfzl5usw@pesu.pes.edu> <CAM_iQpUFL7VdCKSgUa6N3pg7ijjZRu6-6UAs2oNosM-EzgXbaQ@mail.gmail.com>
In-Reply-To: <CAM_iQpUFL7VdCKSgUa6N3pg7ijjZRu6-6UAs2oNosM-EzgXbaQ@mail.gmail.com>
From:   B K Karthik <bkkarthik@pesu.pes.edu>
Date:   Sun, 26 Jul 2020 11:42:43 +0530
Message-ID: <CAAhDqq28h9_ji=ANttUyx2Q1Md=bZD3-JVCwQRW06W7aikPN0A@mail.gmail.com>
Subject: Re: [PATCH v2] net: ipv6: fix use-after-free Read in __xfrm6_tunnel_spi_lookup
To:     Cong Wang <xiyou.wangcong@gmail.com>
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

On Sun, Jul 26, 2020 at 11:05 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sat, Jul 25, 2020 at 8:09 PM B K Karthik <bkkarthik@pesu.pes.edu> wrote:
> > @@ -103,10 +103,10 @@ static int __xfrm6_tunnel_spi_check(struct net *net, u32 spi)
> >  {
> >         struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
> >         struct xfrm6_tunnel_spi *x6spi;
> > -       int index = xfrm6_tunnel_spi_hash_byspi(spi);
> > +       int index = xfrm6_tunnel_spi_hash_byaddr((const xfrm_address_t *)spi);
> >
> >         hlist_for_each_entry(x6spi,
> > -                            &xfrm6_tn->spi_byspi[index],
> > +                            &xfrm6_tn->spi_byaddr[index],
> >                              list_byspi) {
> >                 if (x6spi->spi == spi)
>
> How did you convince yourself this is correct? This lookup is still
> using spi. :)

I'm sorry, but my intention behind writing this patch was not to fix
the UAF, but to fix a slab-out-of-bound.
If required, I can definitely change the subject line and resend the
patch, but I figured this was correct for
https://syzkaller.appspot.com/bug?id=058d05f470583ab2843b1d6785fa8d0658ef66ae
. since that particular report did not have a reproducer,
Dmitry Vyukov <dvyukov@google.com> suggested that I test this patch on
other reports for xfrm/spi .

Forgive me if this was the wrong way to send a patch for that
particular report, but I guessed since the reproducer did not trigger
the crash
for UAF, I would leave the subject line as 'fix UAF' :)

xfrm6_spi_hash_by_hash seemed more convincing because I had to prevent
a slab-out-of-bounds because it uses ipv6_addr_hash.
It would be of great help if you could help me understand how this was
able to fix a UAF.

>
> More importantly, can you explain how UAF happens? Apparently
> the syzbot stack traces you quote make no sense at all. I also
> looked at other similar reports, none of them makes sense to me.

Forgive me, but I do not understand what you mean by the stack traces
(this or other similar reports) "make no sense".

I apologise if this message was hurtful / disrespectful in any manner.
thanks,

karthik
