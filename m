Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3F4286147
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 16:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgJGObS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 10:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728623AbgJGObS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 10:31:18 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD25C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 07:31:18 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g7so2493045iov.13
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 07:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J3pzSJ8lIXDJi4ucuujiYChQQwsBgE15yHTT7k8dUpM=;
        b=O7D0vmzOliml1tifGFAWcZPzvGEopeftlHfeXy3elVHguUSGorlxmnWmyFlQliQ0OD
         Nd2sMgZO4EXcyZaQuXffJKMaiKBcr+vpz8SoP3y+tSTxOAxFBgoU0qSsIA7HvIzJqb54
         cITFSzLoLLcwycy3+Atds3NMbspgnJPJdqUQST6Gb6rFcRPbm0lJyEDlaEBzFwwByS5O
         9riyRSnhKPwEGHBO0/EbVQIwMgCUuVIfxfHfibWcVhRPXPIxGXLB8EVO0RqNnC1JnnDP
         WaGznhftHjoVi5Ru7BfB7FPItBWV4gehlVKKIzVPNHN9ueF0Y07Kncc24R4t5V9oWdfJ
         weNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J3pzSJ8lIXDJi4ucuujiYChQQwsBgE15yHTT7k8dUpM=;
        b=nI1YBH4h5HixKpBuqID+tEALh108K+6MvqsEOsfEniYXFmqfU4P5Nqi+m2B6gKTGM5
         KbRuQ+GS12KeA9mN/vzG/40EgmZQvuFOLpndMDLoZurFhe+6mLru5i30edLsTzRpIH1e
         PsIovOLg0xLOZ+Vfyau+rEDUubJIWlk5ipabO5sez9Vv0zbmLPTIwIOE9yRSq3ImaYMx
         TbzWIgwomfajidQqKCmFdzB2IZpaofsVXrdQ6L+VMnff+rZuK+9Oo+ooc7gdqYrl5lQ1
         upG92V9Zx31+pYYoG4RHPjUjS2J9xdDcSQz763whzPvIaSLo2Dv9vyEQtWoDjYDqNDGd
         Znkg==
X-Gm-Message-State: AOAM5321VBwyoDeZmLG6k6YZLlwgygXBaFwesf0dwXjJE9zBMHJn1Wgj
        I2lbwhubfHeiDQ6WWFmSTQ7JNSOrhqmfyUusfvR1Lg==
X-Google-Smtp-Source: ABdhPJzJSt0JVeqjisBKmS3+tstAHK06UfN7QULW5nRC3nEPV9p3tS6nMNgZE2TWr5u3VUIsEpdAp9h5QFQDvd+vb8Y=
X-Received: by 2002:a5e:9411:: with SMTP id q17mr2493165ioj.157.1602081077509;
 Wed, 07 Oct 2020 07:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201007084246.4068317-1-eric.dumazet@gmail.com> <4544483dd904540cdda04db3d2e2e70bad84efda.camel@redhat.com>
In-Reply-To: <4544483dd904540cdda04db3d2e2e70bad84efda.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Oct 2020 16:31:05 +0200
Message-ID: <CANn89iLcZit_0Og9MbW0x0bQ=-6pz18UpRN6RYOY12Czui1eMQ@mail.gmail.com>
Subject: Re: [PATCH net] macsec: avoid use-after-free in macsec_handle_frame()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 4:09 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hi,
>
> On Wed, 2020-10-07 at 01:42 -0700, Eric Dumazet wrote:
> > @@ -1232,9 +1233,10 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
> >       macsec_rxsc_put(rx_sc);
> >
> >       skb_orphan(skb);
> > +     len = skb->len;
> >       ret = gro_cells_receive(&macsec->gro_cells, skb);
> >       if (ret == NET_RX_SUCCESS)
> > -             count_rx(dev, skb->len);
> > +             count_rx(dev, len);
> >       else
> >               macsec->secy.netdev->stats.rx_dropped++;
>
> I'm sorry I'm low on coffee, but I can't see the race?!? here we are in
> a BH section, and the above code dereference the skb only if it's has
> been enqueued into the gro_cells napi. It could be dequeued/dropped
> only after we leave this section ?!?

We should think of this as an alias for napi_gro_receive(), and not
make any assumptions.
Semantically the skb has been given to another layer.

netif_rx() can absolutely queue the skb to another cpu backlog (RPS,
RFS...), and the other cpu might have consumed the skb right away.

We can avoid these subtle bugs by respecting simple rules ;)

>
> Thanks,
>
> Paolo
>
