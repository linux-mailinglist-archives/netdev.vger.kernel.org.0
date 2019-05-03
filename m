Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C404A12CE6
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 13:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfECLuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 07:50:11 -0400
Received: from mail-yw1-f50.google.com ([209.85.161.50]:38223 "EHLO
        mail-yw1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfECLuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 07:50:11 -0400
Received: by mail-yw1-f50.google.com with SMTP id b74so3924579ywe.5
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 04:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t8Zq7NwdUbNEsTWxl/PhxvT1XcC3vHUyBDjHGeiB1AM=;
        b=BcCpbtCQH5SAp6k+M7orYibF+H5nG05IC4OQwAaE8tvlHBsFANNRicLExTBduv9X2/
         RZCs4G95UGp1NwcLcHInzFDBLkPpQw/TtrQR6ST/pX2zzc1KxVFOX6JI424wdhinCl/a
         06x/FJ0l8WJiket1Rc387zhi2vnZ1EgaLpnzlMjVN8JznwV039CIc+f+iL8LGTJab3h8
         /FHwSqVguQ55otMsa7DxmlxSyFHuNxUjU6wS8JNGvQ3UubuFMAblVf8YZ1UMQn2yPEKh
         xrm6ZEI8j851HgUnj0Mb1lb68hoDv22naYNgkpQxidCeopxD6iB2anxrfznhv+5fSbiX
         nOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t8Zq7NwdUbNEsTWxl/PhxvT1XcC3vHUyBDjHGeiB1AM=;
        b=AIC5DGEUpyIoaD+QymaeBkIsBdoa7Fdlq7iQALryl6gcde9PmZPnLYjxuz2+A4hROO
         64WdT2yNN+IfZ4pkcSMQkfJgSvNjfN3QbsH1VDdFXHCGNvSvaJxRqLDpwNNF1/mHkImQ
         deDEThosiHsrRHesDSgdmWKQ2tBYRs0qNbKAqWjqoWDRNDNr/XpYiGmYGdcHQp/p91qc
         aiANAEyvkqG1HSujetcjrLBv15bHZdBAW3Ab0m2KPA4YWoEZm8qYI37VbrZrtyuFEoeY
         DpQHCL5QLW8tWdmvRJwd+/HyOpnZm7oRwQa253ruaM+JsFeMnuFSceTIrGUKCuG0EsuZ
         7E8g==
X-Gm-Message-State: APjAAAV7kAKLi2G0dOUIx5UqT44W8a4LQuCsD/EduZIBt3WKEJnFjS0T
        1GGJq0PTdtg7/QWOt4traJlLfYsRMKPc+IkMtMxgvw==
X-Google-Smtp-Source: APXvYqxlTMbjSgszsVh0hfNyBCJGwEHZUWN1zAkUlNsOofOdhmVAlFzyUYTDeU7WpTPwdyQrzBU2pgpvebUe381bXRM=
X-Received: by 2002:a0d:c0c5:: with SMTP id b188mr2620148ywd.83.1556884210251;
 Fri, 03 May 2019 04:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190503091732.19452-1-stefan.bader@canonical.com>
 <CANn89iLjw2bvXO-N-JUhQLZtnWhQey8Hy9KiizMq0=4=CEonGA@mail.gmail.com> <CANn89iKm2wLKCMZnp+brgD+1W4r-9rd2xvVL8-=nEhqVdMX7+A@mail.gmail.com>
In-Reply-To: <CANn89iKm2wLKCMZnp+brgD+1W4r-9rd2xvVL8-=nEhqVdMX7+A@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 May 2019 07:49:58 -0400
Message-ID: <CANn89iJ_exBE2NcrfAKoDRYP+tQXmbGpR1=omwS+89MBhijaqw@mail.gmail.com>
Subject: Re: Possible refcount bug in ip6_expire_frag_queue()?
To:     Stefan Bader <stefan.bader@canonical.com>,
        Peter Oskolkov <posk@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 3, 2019 at 7:17 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, May 3, 2019 at 7:12 AM Eric Dumazet <edumazet@google.com> wrote:
> >

> > I will send the following fix
> >
> > diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
> > index 28aa9b30aeceac9a86ee6754e4b5809be115e947..d3152811b8962705a508b3fd31d2157dd19ae8e5
> > 100644
> > --- a/include/net/ipv6_frag.h
> > +++ b/include/net/ipv6_frag.h
> > @@ -94,11 +94,9 @@ ip6frag_expire_frag_queue(struct net *net, struct
> > frag_queue *fq)
> >                 goto out;
> >
> >         head->dev = dev;
> > -       skb_get(head);
> >         spin_unlock(&fq->q.lock);
> >
> >         icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
> > -       kfree_skb(head);
>
> Oh well, we want to keep the kfree_skb() of course.
>
> Only the skb_get(head) needs to be removed (this would fix memory leak
> I presume...  :/ )

Official submission :

https://patchwork.ozlabs.org/patch/1094854/ ip6: fix skb leak in
ip6frag_expire_frag_queue()

Thanks a lot Stefan for bringing up this issue to our attention !
